CREATE OR REPLACE PROCEDURE SEND_SMS_PROMISED_PAYMENT(pPhoneNumber in varchar2,  pSMS_TXT in VARCHAR2) IS
  --Version 1
    --
    --v1. 23.09.2015. ������. ��������� �������� ��� � ��������� ���������� �������

SMS VARCHAR2(2000);
pragma autonomous_transaction;
BEGIN
  
  SMS := LOADER3_pckg.SEND_SMS(pPhoneNumber, '���-����������', pSMS_TXT);
   
   EXCEPTION
     WHEN others THEN
       NULL;
END;

