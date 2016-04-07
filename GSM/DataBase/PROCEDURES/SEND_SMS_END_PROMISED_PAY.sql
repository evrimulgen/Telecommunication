CREATE OR REPLACE PROCEDURE SEND_SMS_END_PROMISED_PAY IS
--
-- Version=2
--v.2 11.02.2015 ������� PROMISED_DATE_END �� PROMISED_DATE
--v.1 11.02.2015 ������� ��������� ���������� ������� �� ��������� ���������� �������
--
  l_sms_text varchar2(250 CHAR);
  l_res varchar2(2000);
  
  procedure UPDATE_PROMISED_PAYMENTS (pRowId rowid) as
  PRAGMA AUTONOMOUS_TRANSACTION;
  begin
    update PROMISED_PAYMENTS
      set SMS_SENDED = 1
    where rowid = pRowID;
    commit;
  end;
  
BEGIN
  l_sms_text := '��������� �������, ����������, ��� ���� �������� ���������� ������� ������������� �������. ��������� ������ *132*11#.'; 
  for r in (select T.PHONE_NUMBER, rowid rid 
               from PROMISED_PAYMENTS t
              where 
              --�������� �� ��������� ������� ���������� �����
              trunc(T.PROMISED_DATE) = trunc(sysdate + 1)
              
              
              --�������� �������� �� ������ MS_CONSTANTS.GET_CONSTANT_VALUE('HOUR_START_SEND_PROMIZED_MESS')
              and to_number(to_char(sysdate, 'hh24')) >= to_number(nvl(MS_CONSTANTS.GET_CONSTANT_VALUE('HOUR_START_SEND_PROMIZED_MESS'), '-1')) 

              --�������� �� ��, ��� ��� ��� �� ���� ��������
              and nvl(SMS_SENDED, 0) = 0
              )
               
  loop
    l_res := LOADER3_PCKG.SEND_SMS(R.PHONE_NUMBER, '����������', l_sms_text);
    UPDATE_PROMISED_PAYMENTS (R.rid);
  end loop;
   
END SEND_SMS_END_PROMISED_PAY;



/
