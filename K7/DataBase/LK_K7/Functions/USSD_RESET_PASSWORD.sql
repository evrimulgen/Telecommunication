CREATE OR REPLACE FUNCTION K7_LK.USSD_RESET_PASSWORD(
  pPHONE_NUMBER IN VARCHAR2
  ) RETURN VARCHAR2 IS
--
--#Version=1
--
-- ������� ���������� ������ ��� �������� � ���������� ��� �� SMS. ��� ������� ������ ������ ����� USSD
-- ������������ ��������:
--  '������ ����� ��������� �� ���': �������� ��������� �������;
--  'NO_PHONE': ��� ������ ������;
--  'ERROR': ������, ��������� �����.
--
  vRESULT VARCHAR2(50 char);
BEGIN

  vRESULT := RESET_PASSWORD(pPHONE_NUMBER);

  if vRESULT = 'OK' then
    vRESULT := '������ ����� ��������� �� ���';
  end if;
  
  RETURN vRESULT;
END;
