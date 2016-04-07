CREATE OR REPLACE PROCEDURE BLOCK_CLIENT_WTH_0_BAL2(
  pACCOUNT_ID IN INTEGER
  ) AS
--
--#Version=22
--
--v.22 10.03.2016 ������� ��������� �������� ��� ��� ���������� ����
--v.21 17.02.2016 ������� ����� �������� ���������� ��� � ����� � ������� ���
--v.20 21.08.2015 ������� ������� ������ ������� � ������� LOYAL_PHONE_FOR_BLOCK
--16.07.2015 ��������. �������� ������������������ �������� ���.
--09.09.2011 �������. ������� ����� ��������� �� ������
--�������. �������� ���������� ������.
  vDISCONNECT_COUNT   BINARY_INTEGER := 1000;
  --
  CURSOR C IS
    SELECT V_PHONE_NUMBERS_FOR_BLOCK.ACCOUNT_ID,
           V_PHONE_NUMBERS_FOR_BLOCK.PHONE_NUMBER_FEDERAL,
           V_PHONE_NUMBERS_FOR_BLOCK.BALANCE,
           V_PHONE_NUMBERS_FOR_BLOCK.FIO,
           V_PHONE_NUMBERS_FOR_BLOCK.BLOCK_NOTICE_TEXT,
           V_PHONE_NUMBERS_FOR_BLOCK.BALANCE_BLOCK
      FROM V_PHONE_NUMBERS_FOR_BLOCK
      WHERE V_PHONE_NUMBERS_FOR_BLOCK.ACCOUNT_ID = pACCOUNT_ID;
  CURSOR BL(ID INTEGER) IS
    SELECT ACCOUNTS.DO_AUTO_BLOCK
      FROM ACCOUNTS
      WHERE ID = ACCOUNTS.ACCOUNT_ID;
  --
  vBL BL%ROWTYPE;
  SMS VARCHAR2(2000);
  LOCK_PH VARCHAR2(2000);
  ERROR_COL NUMBER;
  v_SMS_TXT VARCHAR2(500 CHAR);
  INDEXI INTEGER;
  BL_PHONE DBMS_SQL.VARCHAR2_TABLE;
  BL_FIO DBMS_SQL.VARCHAR2_TABLE;
  BL_BALANCE DBMS_SQL.NUMBER_TABLE;
  BL_SMS DBMS_SQL.VARCHAR2_TABLE;
  last_check_options DATE;
  Respond varchar2(5000);
  vROUND_BALANCE number(13, 2);
  v_ct integer;
BEGIN
  INDEXI := -1;
  --
  FOR vREC IN C LOOP
    OPEN BL (vREC.ACCOUNT_ID);
    FETCH BL INTO vBL;
    CLOSE BL;
    IF vBL.DO_AUTO_BLOCK = 1 THEN
      IF NOT ROBOT_IN_BLOCK(vREC.PHONE_NUMBER_FEDERAL) THEN
        ERROR_COL := 0;
        INDEXI := INDEXI + 1;
        BL_PHONE(INDEXI) := vREC.PHONE_NUMBER_FEDERAL;
        BL_FIO(INDEXI) := vREC.FIO;
        BL_BALANCE(INDEXI) := vREC.BALANCE;
        BL_SMS(INDEXI) := vREC.BLOCK_NOTICE_TEXT;
      END IF;
    END IF;
    -- �� ����� vDISCONNECT_COUNT �� 1 ���.
    vDISCONNECT_COUNT := vDISCONNECT_COUNT - 1;
    IF (vDISCONNECT_COUNT <= 0) AND (MS_CONSTANTS.GET_CONSTANT_VALUE ('USE_LOYAL_SYSTEM') <> '1') THEN
      EXIT;
    END IF;
    --
    IF MS_CONSTANTS.GET_CONSTANT_VALUE ('USE_LOYAL_SYSTEM') = '1' THEN
      INSERT INTO LOYAL_PHONE_FOR_BLOCK(
                                         PHONE_NUMBER,
                                         ACCOUNT_ID,
                                         DATE_CHECK, 
                                         DATE_FUTURE_BLOCK,
                                         BALANCE_BLOCK,
                                         FIO,
                                         BALANCE,
                                         SMS_TEMPLATE
                                       )
                                 VALUES(
                                        vREC.PHONE_NUMBER_FEDERAL,
                                        vREC.ACCOUNT_ID,
                                        SYSDATE,
                                        CASE
                                          WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'HH24')) < 9 THEN
                                            TRUNC(SYSDATE) + 13/24 -- ������� ����� 13:00
                                          WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'HH24')) >= 21 THEN
                                            TRUNC(SYSDATE) + 1 + 13/24  -- ������ ����� 13:00
                                        ELSE
                                          SYSDATE + 4/24  -- ������� ����� 4�
                                        END,
                                       vREC.BALANCE_BLOCK,
                                       vREC.FIO,
                                       round(vRec.BALANCE, 2),
                                       vREC.BLOCK_NOTICE_TEXT
                                      );
      COMMIT;
    END IF;
  END LOOP;
  --�������� �������� �� ���
  IF BL_PHONE.COUNT > 0 THEN
    FOR I IN BL_PHONE.FIRST .. BL_PHONE.LAST
    LOOP
      IF TRUNC(SYSDATE, 'MM') = TRUNC(SYSDATE) THEN -- ����� 1� ���� ������
        SELECT MAX(LAST_CHECK_DATE_TIME) 
          INTO LAST_CHECK_OPTIONS 
          FROM DB_LOADER_ACCOUNT_PHONE_OPTS 
          WHERE PHONE_NUMBER = BL_PHONE(I);
          
        IF TRUNC(LAST_CHECK_OPTIONS) < TRUNC(SYSDATE) THEN
          Respond:=BEELINE_API_PCKG.PHONE_OPTIONS(BL_PHONE(I));
        END IF;
        
      END IF;
      BL_BALANCE(I):= GET_ABONENT_BALANCE(BL_PHONE(I));
      
      vROUND_BALANCE := ROUND(BL_BALANCE(I), 2);
      
      v_SMS_TXT := REPLACE(BL_SMS(I), '%balance%', to_char(vROUND_BALANCE, 'fm99990.00'));
      v_SMS_TXT := REPLACE(v_SMS_TXT, '%dolg%', to_char(- vROUND_BALANCE, 'fm99990.00'));
      
            
      --��������� LOYAL_PHONE_FOR_BLOCK ���� ������ ���������
      update LOYAL_PHONE_FOR_BLOCK
        set BALANCE = vROUND_BALANCE
      where
        PHONE_NUMBER = BL_PHONE(I)
        and nvl(BALANCE, 0) <> vROUND_BALANCE;
        
      BL_SMS(I) := v_SMS_TXT;
      
      --������ �������� �� ����������� �������� ���
      SELECT count(*) into v_ct
      FROM
        log_send_sms s
      WHERE
        phone_number = BL_PHONE(I) AND
        trunc(date_send) = trunc(sysdate)
        and s.sms_text = BL_SMS(I); 
      
      --���� �� ���������� ����� ��� �������, �� ����
      if nvl(v_ct, 0) = 0 then
        SMS:=LOADER3_pckg.SEND_SMS(BL_PHONE(I), '���-����������', BL_SMS(I));
      end if;
      
      
    END LOOP;
  END IF;
  --
  IF TO_NUMBER('0' || MS_CONSTANTS.GET_CONSTANT_VALUE ('BLOCK_PHONE_DELAY')) > 0 THEN
    DBMS_LOCK.SLEEP(TO_NUMBER('0' || MS_CONSTANTS.GET_CONSTANT_VALUE ('BLOCK_PHONE_DELAY'))); 
  ELSE
    DBMS_LOCK.SLEEP (180);
  END IF;
  --
  IF (BL_PHONE.COUNT > 0) AND (MS_CONSTANTS.GET_CONSTANT_VALUE ('USE_LOYAL_SYSTEM') <> '1') THEN
    FOR I IN BL_PHONE.FIRST .. BL_PHONE.LAST 
    LOOP
      IF BL_SMS (I) IS NULL THEN
        LOCK_PH := LOADER3_pckg.LOCK_PHONE (BL_PHONE (I), 0);
        
        IF LOCK_PH IS NOT NULL THEN
          LOOP
            ERROR_COL := ERROR_COL + 1;
            LOCK_PH := LOADER3_pckg.LOCK_PHONE (BL_PHONE (I));
            EXIT WHEN(LOCK_PH IS NULL) OR (ERROR_COL = 2);
          END LOOP;
        END IF;
        
        IF LOCK_PH IS NOT NULL THEN
          INSERT INTO AUTO_BLOCKED_PHONE(
                                         PHONE_NUMBER,
                                         BALLANCE,
                                         NOTE,
                                         BLOCK_DATE_TIME,
                                         ABONENT_FIO
                                        ) 
                                VALUES(
                                        BL_PHONE(I),
                                        BL_BALANCE(I),
                                        SUBSTR('������. ' || LOCK_PH, 300),
                                        SYSDATE,
                                        BL_FIO(I)
                                      );
        ELSE
          UPDATE DB_LOADER_ACCOUNT_PHONES
            SET DB_LOADER_ACCOUNT_PHONES.PHONE_IS_ACTIVE = 0
            WHERE
              DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = BL_PHONE(I)
              AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (SELECT MAX(DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH)
                                                           FROM DB_LOADER_ACCOUNT_PHONES
                                                           WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = BL_PHONE(I));
        END IF;
      ELSE
        INSERT INTO AUTO_BLOCKED_PHONE(
                                        PHONE_NUMBER,
                                        BALLANCE,
                                        NOTE,
                                        BLOCK_DATE_TIME,
                                        ABONENT_FIO
                                        )
          VALUES(BL_PHONE(I), BL_BALANCE(I), '��� �� ����������', SYSDATE, BL_FIO(I));
      END IF;
      COMMIT;
    END LOOP;
  END IF;
END;
/
