CREATE OR REPLACE PROCEDURE BLOCK_CLIENT_WTH_0_BAL2(
  pACCOUNT_ID IN INTEGER
  ) AS
--
--#Version=20
--
--21.11.2012 ����������. ���������� ������� �� ������������� + �������� ������� ��������������� ����� �����������.
--09.09.2011 �������. ������� ����� ��������� �� ������
--�������. �������� ���������� ������.
  vDISCONNECT_COUNT BINARY_INTEGER := 15;
--
CURSOR C IS
SELECT V_PHONE_NUMBERS_FOR_BLOCK.ACCOUNT_ID,
       V_PHONE_NUMBERS_FOR_BLOCK.PHONE_NUMBER_FEDERAL,
       V_PHONE_NUMBERS_FOR_BLOCK.BALANCE,
       V_PHONE_NUMBERS_FOR_BLOCK.FIO,
       V_PHONE_NUMBERS_FOR_BLOCK.BLOCK_NOTICE_TEXT,
       V_PHONE_NUMBERS_FOR_BLOCK.BLOCK_BALANCE
  FROM V_PHONE_NUMBERS_FOR_BLOCK
  WHERE V_PHONE_NUMBERS_FOR_BLOCK.ACCOUNT_ID=pACCOUNT_ID
  ORDER BY BALANCE-NVL(DISCONNECT_LIMIT, 0) ASC;
--
CURSOR BL (ID INTEGER) IS
  SELECT 
    ACCOUNTS.DO_AUTO_BLOCK
  FROM ACCOUNTS
  WHERE ID=ACCOUNTS.ACCOUNT_ID;
--
  vBL BL%ROWTYPE;
  SMS VARCHAR2(2000); 
  LOCK_PH VARCHAR2(2000);
  ERROR_COL NUMBER;
  SMS_TXT VARCHAR2(500 char);
  INDEXI INTEGER;
  BL_PHONE DBMS_SQL.VARCHAR2_TABLE;
  BL_FIO DBMS_SQL.VARCHAR2_TABLE;
  BL_BALANCE DBMS_SQL.NUMBER_TABLE;
  BL_SMS DBMS_SQL.VARCHAR2_TABLE;
  BL_BLOCK_BALANCE DBMS_SQL.NUMBER_TABLE;

  DATE_ROWS DBMS_SQL.DATE_TABLE; 
  COST_ROWS DBMS_SQL.NUMBER_TABLE; 
  DESCRIPTION_ROWS DBMS_SQL.VARCHAR2_TABLE;
  L BINARY_INTEGER;
  NEEDINVESTIGATION INT;
  NEXTVALDET INT;
  TEMPSUM_REPORTDATA NUMBER(10,2);
BEGIN
  BL_PHONE.DELETE; 
  BL_FIO.DELETE; 
  BL_BALANCE.DELETE; 
  BL_SMS.DELETE; 
  BL_BLOCK_BALANCE.DELETE; 
  DATE_ROWS.DELETE; 
  COST_ROWS.DELETE; 
  DESCRIPTION_ROWS.DELETE;
  INDEXI:=-1;
--  
  FOR vREC IN C LOOP
    OPEN BL(vREC.ACCOUNT_ID);
    FETCH BL INTO vBL;
    CLOSE BL;
    IF vBL.DO_AUTO_BLOCK=1 THEN
      IF NOT ROBOT_IN_BLOCK(vREC.PHONE_NUMBER_FEDERAL) THEN
        NEEDINVESTIGATION:=0;
        BEGIN
            SELECT 1 INTO NEEDINVESTIGATION FROM INVESTIGATION_PHONES WHERE PHONE_NUMBER=vREC.PHONE_NUMBER_FEDERAL AND ROWNUM=1;
        EXCEPTION 
            WHEN OTHERS THEN NEEDINVESTIGATION:=0;
        END;            

        IF NEEDINVESTIGATION=1 THEN 
  	      CALC_BALANCE_ROWS2(vREC.PHONE_NUMBER_FEDERAL, DATE_ROWS, COST_ROWS, DESCRIPTION_ROWS, TRUE, sysdate);
  	      L := COST_ROWS.LAST;
    	  IF L IS NOT NULL THEN
           NEXTVALDET:=S_NEW_ID_DETAILS_INVPHDET.NEXTVAL;
           TEMPSUM_REPORTDATA:=0;
           BEGIN
            SELECT DETAIL_SUM INTO TEMPSUM_REPORTDATA FROM DB_LOADER_REPORT_DATA WHERE YEAR_MONTH=(SELECT * 
                                                         FROM (SELECT DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH 
                                                                 FROM DB_LOADER_ACCOUNT_PHONES 
                                                                 WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER=vREC.PHONE_NUMBER_FEDERAL
                                                                 ORDER BY YEAR_MONTH DESC)
                                                         WHERE ROWNUM=1) AND PHONE_NUMBER=vREC.PHONE_NUMBER_FEDERAL AND ROWNUM=1;
           EXCEPTION 
            WHEN OTHERS THEN TEMPSUM_REPORTDATA:=0;
           END;            

    	   FORALL I IN COST_ROWS.FIRST..L 
      	   INSERT INTO INVESTIGATION_PHONES_DETAILS (ID_DETAILS, PHONE_NUMBER, ROW_DATE, ROW_COST, ROW_COMMENT, DATEEVENT, SUM_REPORTDATA)
            VALUES (NEXTVALDET, vREC.PHONE_NUMBER_FEDERAL, DATE_ROWS(I), COST_ROWS(I), DESCRIPTION_ROWS(I), SYSDATE, TEMPSUM_REPORTDATA);
          END IF;
          COMMIT;
        END IF;
        ERROR_COL:=0; 
        SMS_TXT:=replace(vREC.BLOCK_NOTICE_TEXT,'%balance%',round(vRec.Balance));
        SMS_TXT:=replace(SMS_TXT,'%dolg%',round(-vRec.Balance));
        SMS:=LOADER3_pckg.SEND_SMS(vREC.PHONE_NUMBER_FEDERAL,
                                   '���-����������',
                                   SMS_TXT);
        DBMS_LOCK.SLEEP(2);
        INDEXI:=INDEXI+1;
        BL_PHONE(INDEXI):=vREC.PHONE_NUMBER_FEDERAL;
        BL_BLOCK_BALANCE(INDEXI):=vREC.BLOCK_BALANCE;
        BL_FIO(INDEXI):=vREC.FIO;
        BL_BALANCE(INDEXI):=vREC.BALANCE;
        BL_SMS(INDEXI):=SMS;
      END IF;      
    END IF;
        -- �� ����� vDISCONNECT_COUNT �� 1 ���.
    vDISCONNECT_COUNT := vDISCONNECT_COUNT - 1;
    IF vDISCONNECT_COUNT <= 0 THEN
      EXIT;
    END IF;    
  END LOOP; 
  IF TO_NUMBER('0'||MS_CONSTANTS.GET_CONSTANT_VALUE('BLOCK_PHONE_DELAY'))>0 THEN
    DBMS_LOCK.SLEEP(TO_NUMBER('0'||MS_CONSTANTS.GET_CONSTANT_VALUE('BLOCK_PHONE_DELAY')));    
  ELSE
    DBMS_LOCK.SLEEP(180);
  END IF;
  IF BL_PHONE.COUNT>0 THEN  
    FOR I IN BL_PHONE.FIRST..BL_PHONE.LAST LOOP
      IF GET_ABONENT_BALANCE(BL_PHONE(I))< BL_BLOCK_BALANCE(I) THEN 
        LOCK_PH:=LOADER3_pckg.LOCK_PHONE(BL_PHONE(I),0);
        IF LOCK_PH IS NOT NULL THEN
          LOOP
            ERROR_COL:=ERROR_COL+1;
            LOCK_PH:=LOADER3_pckg.LOCK_PHONE(BL_PHONE(I)); 
            EXIT WHEN (LOCK_PH IS NULL) OR (ERROR_COL=2); 
          END LOOP;
        END IF;     
        IF LOCK_PH IS NOT NULL THEN
          INSERT INTO AUTO_BLOCKED_PHONE(PHONE_NUMBER, BALLANCE, NOTE, BLOCK_DATE_TIME, ABONENT_FIO) 
            VALUES (BL_PHONE(I), BL_BALANCE(I), SUBSTR('������. '||LOCK_PH, 300), SYSDATE, BL_FIO(I));
        ELSE 
          UPDATE DB_LOADER_ACCOUNT_PHONES
            SET DB_LOADER_ACCOUNT_PHONES.PHONE_IS_ACTIVE=0
            WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER=BL_PHONE(I)
              AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH=(SELECT * 
                                                         FROM (SELECT DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH 
                                                                 FROM DB_LOADER_ACCOUNT_PHONES 
                                                                 WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER=BL_PHONE(I)
                                                                 ORDER BY YEAR_MONTH DESC)
                                                         WHERE ROWNUM=1);
        END IF;
      ELSE 
        INSERT INTO AUTO_BLOCKED_PHONE(PHONE_NUMBER, BALLANCE, NOTE, BLOCK_DATE_TIME, ABONENT_FIO) 
          VALUES(BL_PHONE(I), BL_BALANCE(I), '����� �� ������������ �� ������� ��������� �������.', SYSDATE, BL_FIO(I));  
        DATE_ROWS.DELETE; 
        COST_ROWS.DELETE; 
        DESCRIPTION_ROWS.DELETE;

        CALC_BALANCE_ROWS2(BL_PHONE(I), DATE_ROWS, COST_ROWS, DESCRIPTION_ROWS, TRUE, sysdate);
        L := COST_ROWS.LAST;
        IF L IS NOT NULL THEN
         NEXTVALDET:=S_NEW_ID_DETAILS_INVPHDET.NEXTVAL;

         TEMPSUM_REPORTDATA:=0;
         BEGIN
          SELECT DETAIL_SUM INTO TEMPSUM_REPORTDATA FROM DB_LOADER_REPORT_DATA WHERE YEAR_MONTH=(SELECT * 
                                                       FROM (SELECT DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH 
                                                               FROM DB_LOADER_ACCOUNT_PHONES 
                                                               WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER=BL_PHONE(I)
                                                               ORDER BY YEAR_MONTH DESC)
                                                       WHERE ROWNUM=1) AND PHONE_NUMBER=BL_PHONE(I) AND ROWNUM=1;
         EXCEPTION 
          WHEN OTHERS THEN TEMPSUM_REPORTDATA:=0;
         END;            
         FORALL II IN COST_ROWS.FIRST..L 
          INSERT INTO INVESTIGATION_PHONES_DETAILS (ID_DETAILS, PHONE_NUMBER, ROW_DATE, ROW_COST, ROW_COMMENT, DATEEVENT, SUM_REPORTDATA)
           VALUES (NEXTVALDET, BL_PHONE(I), DATE_ROWS(II), COST_ROWS(II), DESCRIPTION_ROWS(II), SYSDATE, TEMPSUM_REPORTDATA);
        END IF;
        INSERT INTO INVESTIGATION_PHONES (PHONE_NUMBER,TURN_ON_DATE) VALUES (BL_PHONE(I),SYSDATE);

      END IF;
      COMMIT;
    END LOOP;
  END IF;  
END;
/
