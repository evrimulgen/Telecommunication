declare 
sms varchar2(300 char);
begin
  sms:=loader3_pckg.SEND_SMS('9276561268', 'AgSvyazi','������ ������ ����� ����� 400� �� ��������� ���������� ��������� ����. �������� ������� *132*11# �����. ����������� ����� +74957378081');
  dbms_output.PUT_LINE(sms);
end;  