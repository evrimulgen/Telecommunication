CREATE OR REPLACE PROCEDURE SEND_SMS_NOTICE_BAL_WITH_NOL AS
--
--#Version=1
--
CURSOR C IS
  SELECT 
    v_abonent_balances.PHONE_NUMBER_FEDERAL,
    v_abonent_balances.BALANCE,
    v_abonent_balances.SURNAME || ' ' || v_abonent_balances.NAME || ' ' || v_abonent_balances.PATRONYMIC FIO,
    v_abonent_balances.DISCONNECT_LIMIT,
    ACCOUNTS.NEXT_MONTH_NOTICE_TEXT,
    ACCOUNTS.ACCOUNT_ID
  FROM v_abonent_balances,ACCOUNTS
  WHERE loader_script_name is not null
        AND v_abonent_balanceS.ACCOUNT_ID=ACCOUNTS.ACCOUNT_ID
        and v_abonent_balances.BALANCE-NVL(v_abonent_balances.DISCONNECT_LIMIT,0)<0  --������ ����� 2 ��� ������ ���� ������ ����������
        and phone_is_active_code=1 
        ;     
--
--
  SMS VARCHAR2(2000); 
  SMS_TXT VARCHAR2(500);

--
BEGIN
   IF ((SYSDATE-TRUNC(SYSDATE) > 9/24) and (SYSDATE-TRUNC(SYSDATE) < 18/24))  THEN 
     FOR vREC IN C
     LOOP      
         SMS_TXT:='��������� �������! ��� ������ ������������� - '||to_char(round(vRec.Balance))||'. ��� ����� ����� ������������. �� ���� �������� ���������� �� ���:(495)7887908';
         SMS:=LOADER3_pckg.SEND_SMS(
           vREC.PHONE_NUMBER_FEDERAL,
           '���-����������',
           SMS_TXT);   --����� ��������������         
     END LOOP; 
   END IF;  
 END;
/