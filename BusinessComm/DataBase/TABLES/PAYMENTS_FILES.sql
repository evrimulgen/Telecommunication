create table PAYMENTS_FILES
(
  FILE_ID INTEGER PRIMARY KEY,
  FILE_NAME  VARCHAR2(50),
  LOAD_START_DATE DATE,
  LOAD_END_DATE DATE,
  USER_CREATE VARCHAR2(30 CHAR),
  DATE_CREATE DATE
);

COMMENT ON TABLE PAYMENTS_FILES IS '������� � ������� ��������'; 
COMMENT ON COLUMN PAYMENTS_FILES.FILE_ID IS 'ID ������������ �����'; 
COMMENT ON COLUMN PAYMENTS_FILES.FILE_NAME IS '��� �����';
COMMENT ON COLUMN PAYMENTS_FILES.LOAD_START_DATE IS '����-����� ������ �������� �����'; 
COMMENT ON COLUMN PAYMENTS_FILES.LOAD_END_DATE IS '����-����� ��������� �������� �����';
COMMENT ON COLUMN PAYMENTS_FILES.USER_CREATE IS '��������� ������������';
COMMENT ON COLUMN PAYMENTS_FILES.DATE_CREATE IS '���� ��������';

CREATE SEQUENCE S_PAYMENTS_FILES_ID
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

CREATE OR REPLACE TRIGGER TI_PAYMENTS_FILES
--#Version=2
--v.2 ������� ������� DATE_INSERT_FILE_NAME
  BEFORE INSERT ON PAYMENTS_FILES FOR EACH ROW
BEGIN
    
    if nvl(:NEW.FILE_ID, 0) = 0 then
      :NEW.FILE_ID := S_PAYMENTS_FILES_ID.Nextval;
    end if;
    :NEW.DATE_CREATE := SYSDATE;
    :NEW.USER_CREATE := USER;
    
END;
/

GRANT SELECT ON PAYMENTS_FILES TO BUSINESS_COMM_ROLE;

CREATE INDEX I_PAYMENT_FILE_ID_FILE_NAME ON PAYMENTS_FILES(FILE_ID, FILE_NAME)
COMPRESS 2
;