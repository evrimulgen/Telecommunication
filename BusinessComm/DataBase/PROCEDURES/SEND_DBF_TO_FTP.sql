CREATE OR REPLACE PROCEDURE SEND_DBF_TO_FTP
as
--Version =1
--
--v.1 ������  01.12.2015 ������ ��������� �� ������� #3752
begin
  SEND_FILES_TO_FTP('.dbf', '1C/TO_1C', 'DIR_BILL_FOR_1C', 2);
  -- ���������� �����, �������� - '.dbf'
  -- ���� �� FTP ������� - ������ ������������
  -- �������� ���������� � ������� - constant- ���������� ���  ���������� � �����
  -- ��� ������������ �� FTP ������ 1� - 2
end;
/