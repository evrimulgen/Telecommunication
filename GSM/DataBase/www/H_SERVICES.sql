CREATE OR REPLACE PROCEDURE H_SERVICES IS
--#Version=1
--
BEGIN
  H_BEGIN('���������� ��������');
  HTP.PRINT('
          <br>������� ������������ ��������� ����� ����������:
          <ul>
            <li>���� �����������.</li>
            <li>�������� ������.</li>');
--            <li>����������� ����������� �����.</li>
  HTP.PRINT('
          </ul><br>');
  H_END;
END;
/
