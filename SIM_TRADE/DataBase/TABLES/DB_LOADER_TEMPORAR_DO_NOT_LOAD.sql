CREATE TABLE DB_LOADER_TEMPORAR_DO_NOT_LOAD (
  PHONE_NUMBER VARCHAR2(10 CHAR)
  );
  
COMMENT ON TABLE DB_LOADER_TEMPORAR_DO_NOT_LOAD IS '������ ���������, ��� ������� ������ ��������� ����������� (�� ����� ������� ������������ ���� ������).';

COMMENT ON COLUMN DB_LOADER_TEMPORAR_DO_NOT_LOAD.PHONE_NUMBER IS '����� ��������.';