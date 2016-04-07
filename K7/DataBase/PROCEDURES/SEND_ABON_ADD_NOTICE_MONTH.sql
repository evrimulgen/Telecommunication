CREATE OR REPLACE PROCEDURE SEND_ABON_ADD_NOTICE_MONTH IS
--Version 1
--
--v1. �������.
  shab varchar2(500 char);
  sms_text varchar2(500 char);
  month_name varchar2(20 char);
  v varchar2(500 char);
BEGIN--���������� � ��������� 3 ��� ������
  if (to_char(sysdate + 3, 'yyyymm') = to_char(add_months(sysdate, 1), 'yyyymm'))  then   
    --����� ���
    shab := '��������� �������! %new_date% �������� ����. ����� �� �����: %option_name%. ����� - %abon_sum%���. �� �������� ��������� ������.';   
    shab:= replace(shab, '%new_date%', '01.'||to_char(add_months(sysdate, 1), 'mm.yyyy'));     
    
    for rec in (select * from V_DISCR_ABON_ADD)
    loop
      --��������� ������
      sms_text:=replace(shab, '%abon_sum%', to_char(rec.NEW_ABON_ADD));
      --��������� ������        
      sms_text:=replace(sms_text, '%option_name%', to_char(rec.NEW_ABON_ADD_OPTS));     
      v:=loader3_pckg.SEND_SMS(rec.PHONE_NUMBER_FEDERAL, 'AgSvyazi', sms_text);  
    end loop;     
  end if;
END;