--#if GetVersion("LOG_TARIFF_OPTIONS_REQ") < 1
CREATE OR REPLACE FUNCTION TRY_STR_TO_NUMBER(S IN VARCHAR2) RETURN NUMBER IS
--#Version=1
-- ����������� ������ � �����.
-- ���� �������������� �� ������� (������ �� �������� ������), �� ���������� NULL
BEGIN
  RETURN TO_NUMBER(S);
EXCEPTION WHEN OTHERS THEN
  RETURN NULL;
END;
/
--#end if
