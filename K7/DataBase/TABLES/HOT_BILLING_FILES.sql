-- Create table
create table HOT_BILLING_FILES(
  file_name  VARCHAR2(50),
  load_sdate DATE,
  load_edate DATE,
  hbf_id     INTEGER primary key,
  FILE_SIZE INTEGER,
  ROW_COUNT INTEGER,
  DATE_INSERT_FILE_NAME date,
  DEL_ROW_COUNT INTEGER,
  LOAD_COUNT INTEGER,
  DATE_START DATE,
  DATE_END DATE,
  COUNT_LOADING INTEGER,
  FILE_SIZE_BYTE INTEGER,
  FILE_ROW_COUNT INTEGER,
  ERROR_ROW_COUNT INTEGER,
  YEAR_MONTH INTEGER
);

COMMENT ON COLUMN HOT_BILLING_FILES.FILE_SIZE IS '������ ����� � ������';
COMMENT ON COLUMN HOT_BILLING_FILES.ROW_COUNT IS '���������� ����� � �����';
COMMENT ON COLUMN HOT_BILLING_FILES.FILE_NAME IS '��� �����';
COMMENT ON COLUMN HOT_BILLING_FILES.LOAD_SDATE IS '����-����� ������ �������� �����'; 
COMMENT ON COLUMN HOT_BILLING_FILES.LOAD_EDATE IS '����-����� ��������� �������� �����';
COMMENT ON COLUMN HOT_BILLING_FILES.HBF_ID IS 'ID ������������ �����'; 
COMMENT ON COLUMN HOT_BILLING_FILES.DATE_INSERT_FILE_NAME IS '����/����� ������� ����� ����� � ��������';
COMMENT ON COLUMN HOT_BILLING_FILES.DEL_ROW_COUNT Is '���������� ���������(������������) ����� � �����';
COMMENT ON COLUMN HOT_BILLING_FILES.LOAD_COUNT IS '���������� ������� �������� ����� � ����';
COMMENT ON COLUMN HOT_BILLING_FILES.DATE_START IS '���������� ������� �������� ����� � ����';
COMMENT ON COLUMN HOT_BILLING_FILES.DATE_END IS '���������� ������� �������� ����� � ����';
COMMENT ON COLUMN HOT_BILLING_FILES.COUNT_LOADING IS '���������� ������� �������� ����� � ����';
COMMENT ON COLUMN HOT_BILLING_FILES.FILE_SIZE_BYTE IS '������ ����� � ������';
COMMENT ON COLUMN HOT_BILLING_FILES.FILE_ROW_COUNT IS '���������� ����� � �����';
COMMENT ON COLUMN HOT_BILLING_FILES.ERROR_ROW_COUNT IS '���������� ����� � �����';
COMMENT ON COLUMN HOT_BILLING_FILES.YEAR_MONTH IS '����� � �������� ��������� ����';

CREATE OR REPLACE TRIGGER TI_Hot_Billing_Files
--#Version=2
--v.2 ������� ������� DATE_INSERT_FILE_NAME
  BEFORE INSERT ON Hot_Billing_Files FOR EACH ROW
BEGIN
    :NEW.hbf_id := S_NEW_HBF_ID.Nextval;
    :NEW.DATE_INSERT_FILE_NAME := SYSDATE;
  BEGIN
    :NEW.YEAR_MONTH:=TO_NUMBER(SUBSTR(:NEW.FILE_NAME, 11, 6));
  EXCEPTION
    WHEN OTHERS THEN
      :NEW.YEAR_MONTH:=NULL;
  END;  
END;
/

-- Grant/Revoke object privileges 
grant select, insert, update, delete on HOT_BILLING_FILES to CORP_MOBILE_ROLE;
grant select on HOT_BILLING_FILES to CORP_MOBILE_ROLE_RO;