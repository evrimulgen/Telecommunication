CREATE OR REPLACE PROCEDURE H_DETAIL IS
--#Version=1
--
BEGIN
  H_BEGIN('�����������');
  HTP.PRINT('
          <br>���������� �������, ��������������� � �������� �������,
          ������������:
          <ul>
            <li>�����.</li>
            <li>����� ���������� ��������� � ������ ������.</li>
            <li>������ <font color=green><b>��������</b></font> ������������ ����� ��������� ����������� �� ������� ������.</li>
            <li>������ <IMG border="0" alt="GSM" src="IMG_XLS_ICON"> ����������� ��������� ����������� �� ������� ������ � ��������� Excel �����.</li>
          </ul><br>');
  H_END;
END;
/
