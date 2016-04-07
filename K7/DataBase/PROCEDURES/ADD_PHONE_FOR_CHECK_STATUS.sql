CREATE OR REPLACE PROCEDURE ADD_PHONE_FOR_CHECK_STATUS (pPhone in varchar2) as
--
--Version=1
--
--v.1 ������� 07.05.2015 ������� ��������� ��� �������� ������� ��� �������� ��������
--
  PRAGMA AUTONOMOUS_TRANSACTION;
  vPhoneCount Integer;
begin
  
  IF NVL(pPhone, '0') <> 0 THEN
    
    --������� ���������� ���������� ������� � �������
    select 
      count(*) into vPhoneCount 
    from 
      QUEUE_FOR_CHECK_PHONE_STATUS
    where phone_number = pPhone;
    
    --���� ������ � ������� ���, �� ��������� ���
    if nvl(vPhoneCount, 0) = 0 then
      INSERT INTO QUEUE_FOR_CHECK_PHONE_STATUS (phone_number)
      VALUES (pPhone);
    end if;
    
    commit;  
  END IF;
end;