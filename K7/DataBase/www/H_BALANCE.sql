CREATE OR REPLACE PROCEDURE H_BALANCE IS
--#Version=1
--
BEGIN
  H_BEGIN('����������� �������');
  HTP.PRINT('
          <br>��������� ������� ��������� �������, ��������������� �� ���� � �������� �������,
          ����� ������� ����������: 
          <ul>
            <li>����� �������.</li>
            <li>����� ����������.</li>
            <li><b>�������� ������</b>.</li>
          </ul>
          ������ �� ������� ������ <IMG border="0" alt="GSM" src="IMG_XLS_ICON" > 
          �������� ��������� ������ � ��������� Excel �����.<br>');
  H_END;
END;
/
