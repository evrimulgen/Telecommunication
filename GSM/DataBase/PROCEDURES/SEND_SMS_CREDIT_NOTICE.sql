CREATE OR REPLACE PROCEDURE CORP_MOBILE.SEND_SMS_CREDIT_NOTICE AS
--
--#Version=14
--
--09.09.2011 �������. ������� �� ������ ����� ��������� 
--05.01.2013 ���������� ����������� ������ � ��������� 

CURSOR C IS
  SELECT PHONE_NUMBER_FEDERAL,
         FIO,
         DISCONNECT_LIMIT,
         BALANCE_BLOCK_CREDIT
  FROM V_PHONE_NUMBER_CREDITS;  
     
  vREC C%ROWTYPE;
--
CURSOR BL (pPHONE_NUMBER VARCHAR2) IS
  SELECT ACCOUNTS.BALANCE_BLOCK_CREDIT,
         NVL(DB_LOADER_ACCOUNT_PHONES.PHONE_IS_ACTIVE, 0) PHONE_IS_ACTIVE
    FROM ACCOUNTS,
         DB_LOADER_ACCOUNT_PHONES
    WHERE DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID=ACCOUNTS.ACCOUNT_ID(+)
      AND DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER=pPHONE_NUMBER
      ORDER BY DB_LOADER_ACCOUNT_PHONES.LAST_CHECK_DATE_TIME DESC;
--
CURSOR LB (pPHONE_NUMBER IN VARCHAR2) IS
  SELECT V.YEAR_MONTH,
         V.BILL_SUM,
         V.SUBSCRIBER_PAYMENT_NEW,
         v.SUBSCRIBER_PAYMENT_ADD_OLD,
         v.SUBSCRIBER_PAYMENT_ADD_VOZVRAT
    FROM V_BILL_FOR_CLIENT V
    WHERE V.PHONE_NUMBER=pPHONE_NUMBER
    ORDER BY V.YEAR_MONTH DESC;
--
  vLB LB%ROWTYPE;    
  vBL BL%ROWTYPE;
  vDATE VARCHAR2(2000);
  v_t VARCHAR2(2000);
  SMS VARCHAR2(2000); 
  SMS_TXT VARCHAR2(2000);
  vBALANCE NUMBER(13, 2);
  vMONTH varchar2(15 char);
--
BEGIN
  --  
  IF (((TO_NUMBER(TO_CHAR(SYSDATE,'D','NLS_DATE_LANGUAGE=RUSSIAN'))<6) AND (SYSDATE-TRUNC(SYSDATE)>9/24) AND (SYSDATE-TRUNC(SYSDATE)<19/24))
      OR((TO_NUMBER(TO_CHAR(SYSDATE,'D','NLS_DATE_LANGUAGE=RUSSIAN'))>5) AND (SYSDATE-TRUNC(SYSDATE)>12/24) AND (SYSDATE-TRUNC(SYSDATE)<19/24)))
     AND (TO_NUMBER(TO_CHAR(SYSDATE,'DD'))>=5 AND TO_NUMBER(TO_CHAR(SYSDATE,'DD'))<=10) THEN 
    FOR vREC IN C  
    LOOP 
      OPEN BL(vREC.PHONE_NUMBER_FEDERAL);
      FETCH BL INTO vBL;
      CLOSE BL;
      SMS_TXT:='���� �� %month% ���������� %bill%�., ������� �������� �� 11-���. ���� �� %date% ����������: %dolg%.';
      vMONTH:=CASE
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=2 THEN '������'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=3 THEN '�������'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=4 THEN '����'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=5 THEN '������'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=6 THEN '���'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=7 THEN '����'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=8 THEN '����'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=9 THEN '������'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=10 THEN '��������'  
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=11 THEN '�������'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=12 THEN '������'
                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'MM'))=1 THEN '�������'  
              END;  
      SMS_TXT:=replace(SMS_TXT,'%month%',vMONTH);
      
--       IF vBL.DO_BALANCE_NOTICE=1 THEN 
      OPEN LB(vREC.PHONE_NUMBER_FEDERAL);
      FETCH LB INTO vLB;
      IF LB%FOUND THEN
        IF vLB.YEAR_MONTH=TO_NUMBER(TO_CHAR(SYSDATE-11, 'YYYYMM')) THEN
          vBALANCE:=GET_ABONENT_BALANCE(vREC.PHONE_NUMBER_FEDERAL);
          vBALANCE:=vBALANCE-vLB.SUBSCRIBER_PAYMENT_NEW-vLB.SUBSCRIBER_PAYMENT_ADD_OLD-vLB.SUBSCRIBER_PAYMENT_ADD_VOZVRAT;
          IF vBALANCE-NVL(vREC.DISCONNECT_LIMIT, 0)<NVL(vREC.BALANCE_BLOCK_CREDIT, NVL(vBL.BALANCE_BLOCK_CREDIT, 0))
              AND vBL.PHONE_IS_ACTIVE=1 THEN
            vDATE:=TO_CHAR(SYSDATE, 'DD.MM.YY'); 
            SMS_TXT:=replace(SMS_TXT,'%bill%',round(vLB.BILL_SUM));
            SMS_TXT:=replace(SMS_TXT,'%dolg%',round(-vBALANCE)); 
            SMS_TXT:=replace(SMS_TXT,'%date%', vDATE); 
            SMS:=LOADER3_pckg.SEND_SMS(
              vREC.PHONE_NUMBER_FEDERAL,
              '���-����������',
              SMS_TXT);
             
            IF SMS IS NULL THEN  
              INSERT INTO CREDIT_NOTICE_SEND(PHONE_NUMBER, DATE_TIME_CREDIT_NOTICE, ABONENT_FIO, SMS_TEXT) 
                VALUES(vREC.PHONE_NUMBER_FEDERAL, sysdate, vREC.FIO, SMS_TXT);
            END IF;
            COMMIT;
          END IF;
        END IF;
      END IF;
      CLOSE LB;
--       END IF;  
    END LOOP; 
  END IF;  
END;
/








