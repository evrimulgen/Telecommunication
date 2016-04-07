CREATE OR REPLACE PROCEDURE SEND_SMS_NOTICE_2 (pAccountId INTEGER)
AS
   --
   --#Version=4
   --
   --v.4 23.02.2016 ������ ����� ����� ������ ����� char ��� ����������� 2� ������ ����� �������
    --v.3 18.02.2016 ������� ����� �������� ���������� ��� �� ������������� �������
   --v.2 23.03.2015 ������� - ��������� �� ������
   --v.1 09.09.2011 �������. ������� �� ������ ����� ���������
   --
   CURSOR C
   IS
      SELECT PHONE_NUMBER_FEDERAL,
             BALANCE,
             FIO,
             DISCONNECT_LIMIT,
             BALANCE_NOTICE_TEXT,
             ACCOUNT_ID
        FROM V_PHONE_NUMBERS_FOR_NOTICE_BAL
       WHERE account_id = pAccountId;

   vREC      C%ROWTYPE;

   --
   CURSOR BL (ID INTEGER)
   IS
      SELECT ACCOUNTS.DO_BALANCE_NOTICE
        FROM ACCOUNTS
       WHERE ID = ACCOUNTS.ACCOUNT_ID;

   --
   vBL       BL%ROWTYPE;
   v_d       VARCHAR2 (2000);
   v_t       VARCHAR2 (2000);
   SMS       VARCHAR2 (2000);
   v_SMS_TXT   VARCHAR2 (2000);
   v_ct integer;
--
BEGIN
   --
   IF (   (    (TO_NUMBER (
                   TO_CHAR (SYSDATE, 'D', 'NLS_DATE_LANGUAGE=RUSSIAN')) < 6)
           AND (TO_NUMBER (TO_CHAR (SYSDATE, 'hh24')) BETWEEN 8 AND 18))
       OR (    (TO_NUMBER (
                   TO_CHAR (SYSDATE, 'D', 'NLS_DATE_LANGUAGE=RUSSIAN')) > 5)
           AND (TO_NUMBER (TO_CHAR (SYSDATE, 'hh24')) BETWEEN 11 AND 18)))
   THEN
      FOR vREC IN C
      LOOP
         OPEN BL (vREC.ACCOUNT_ID);

         FETCH BL INTO vBL;

         CLOSE BL;

         IF vBL.DO_BALANCE_NOTICE = 1 THEN
         
            v_d := TO_CHAR (SYSDATE, 'mm/dd/yyyy');
            v_t := TO_CHAR (SYSDATE, 'hh24:mi');
            v_SMS_TXT := REPLACE (vREC.BALANCE_NOTICE_TEXT, '%balance%', to_char (ROUND (vRec.Balance, 2), 'fm99990.00'));
               --REPLACE (vREC.BALANCE_NOTICE_TEXT, '%balance%', ROUND (vRec.Balance));
            
            v_SMS_TXT := REPLACE (v_SMS_TXT, '%dolg%', to_char (ROUND (-vRec.Balance, 2), 'fm99990.00'));
            
            
            --������ �������� �� ����������� �������� ���
            SELECT count(*) into v_ct
            FROM
              log_send_sms s
            WHERE
              phone_number = vREC.PHONE_NUMBER_FEDERAL AND
              trunc(date_send) = trunc(sysdate)
              and s.sms_text = v_SMS_TXT; 
            
            --���� �� ���������� ����� ��� �������, �� ����
            if nvl(v_ct, 0) = 0 then
            
            
              SMS :=
                 LOADER3_pckg.SEND_SMS (vREC.PHONE_NUMBER_FEDERAL,
                                        '���-����������',
                                        v_SMS_TXT);
              DBMS_LOCK.SLEEP (2);

              IF SMS IS NULL THEN
                 INSERT
                   INTO BLOCK_SEND_SMS (phone_number,
                                        SEND_DATE_TIME,
                                        ABONENT_FIO)
                 VALUES (vREC.PHONE_NUMBER_FEDERAL, SYSDATE, vREC.FIO);
              END IF;
              
            end if;-- if nvl(v_ct, 0) = 0 then

            COMMIT;
         END IF;
      END LOOP;
   END IF;
END;
/
