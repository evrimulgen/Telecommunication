CREATE OR REPLACE PROCEDURE CALC_BALANCE_STREAM(
  STREAM_ID IN INTEGER
  ) IS  
-- Version = 2
--
--2015.10.20. �������. ��������� �������� �� ��������.
  CURSOR L(pPHONE IN VARCHAR2) IS
    SELECT V.BLOCK_LIMIT, V.UNBLOCK_LIMIT
      FROM V_PHONE_LIMITS V
      WHERE V.PHONE_NUMBER_FEDERAL = pPHONE;
  CURSOR QPFB(pPHONE IN VARCHAR2) IS
    SELECT V.*
      FROM QUEUE_PHONE_FOR_BLOCK V
      WHERE V.PHONE_NUMBER = pPHONE;
  CURSOR QPFU(pPHONE IN VARCHAR2) IS
    SELECT V.*
      FROM QUEUE_PHONE_FOR_UNBLOCK V
      WHERE V.PHONE_NUMBER = pPHONE;
  L_DUMMY L%ROWTYPE;
  QPFB_DUMMY QPFB%ROWTYPE;
  QPFU_DUMMY QPFU%ROWTYPE;
  vCOUNT_STREAM INTEGER;
  vCURRENT_BALANCE NUMBER(15, 4);
  vTYPE NUMBER(15, 4);
  vID NUMBER(15, 4);
  vNoFound boolean;
BEGIN
  vCOUNT_STREAM:=TO_NUMBER(MS_PARAMS.GET_PARAM_VALUE('CALC_BALANCE_STREAM_COUNT'));
  FOR rec IN (SELECT PHONE_NUMBER, QUEUE_TYPE
                FROM QUEUE_CURRENT_BALANCES
                WHERE MOD(TO_NUMBER(PHONE_NUMBER), vCOUNT_STREAM) = STREAM_ID
                  AND ROWNUM <=2000)
  LOOP
    vNoFound:=false;
    vCURRENT_BALANCE:=GET_ABONENT_BALANCE(rec.PHONE_NUMBER);
    OPEN L(rec.PHONE_NUMBER);
    FETCH L INTO L_DUMMY;
    IF L%FOUND THEN
      IF vCURRENT_BALANCE < L_DUMMY.BLOCK_LIMIT THEN
        OPEN QPFB(rec.PHONE_NUMBER);
        FETCH QPFB INTO QPFB_DUMMY;
        IF QPFB%NOTFOUND THEN
          INSERT INTO QUEUE_PHONE_FOR_BLOCK(PHONE_NUMBER, NEW_STATUS_CODE)
            VALUES(rec.PHONE_NUMBER, 'WIO');
        END IF;
        CLOSE QPFB;
      ELSIF vCURRENT_BALANCE > L_DUMMY.UNBLOCK_LIMIT THEN
        OPEN QPFU(rec.PHONE_NUMBER);
        FETCH QPFU INTO QPFU_DUMMY;
        IF QPFU%NOTFOUND THEN
          INSERT INTO QUEUE_PHONE_FOR_UNBLOCK(PHONE_NUMBER, NEW_STATUS_CODE)
            VALUES(rec.PHONE_NUMBER, 'RSBO');  
        END IF;
        CLOSE QPFU;      
      END IF;
    END IF;
    CLOSE L;
    --------------------
    Begin
      select I.UPDATE_TYPE, I.BHWT_ID  
        INTO vTYPE, vID
        from IOT_BALANCE_HISTORY_WITH_TYPE i
        where I.PHONE_NUMBER=rec.PHONE_NUMBER
          and I.BHWT_ID= (Select max(I2.BHWT_ID) 
                            from IOT_BALANCE_HISTORY_WITH_TYPE i2
                            where I2.PHONE_NUMBER=I.PHONE_NUMBER);
    Exception
      WHEN NO_DATA_FOUND THEN
        vNoFound:=true;            
    End;
                        
    IF (rec.QUEUE_TYPE = vTYPE) AND (vNoFound=false) THEN
      UPDATE IOT_BALANCE_HISTORY_WITH_TYPE 
        SET LAST_UPDATE = SYSDATE, 
            BALANCE = vCURRENT_BALANCE  
        WHERE BHWT_ID=vID;
    ELSE
      INSERT INTO IOT_BALANCE_HISTORY_WITH_TYPE(PHONE_NUMBER, LAST_UPDATE, UPDATE_TYPE, BALANCE) 
        VALUES(rec.PHONE_NUMBER, sysdate, rec.QUEUE_TYPE, vCURRENT_BALANCE);
    END IF;
    --
    DELETE FROM QUEUE_CURRENT_BALANCES
      WHERE PHONE_NUMBER = rec.PHONE_NUMBER;
    COMMIT;  
  END LOOP;                               
END;

GRANT EXECUTE ON CALC_BALANCE_STREAM TO CORP_MOBILE_ROLE;