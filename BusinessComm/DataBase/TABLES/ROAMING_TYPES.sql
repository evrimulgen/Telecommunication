CREATE TABLE ROAMING_TYPES(
  ROAMING_TYPE_ID Integer NOT NULL PRIMARY KEY,
  NAME Varchar2(150 char ) NOT NULL
)
/
  
COMMENT ON TABLE ROAMING_TYPES IS '���� ��������'
/
COMMENT ON COLUMN ROAMING_TYPES.ROAMING_TYPE_ID IS '������������� ������'
/
COMMENT ON COLUMN ROAMING_TYPES.NAME IS '�������� ���� ��������'
/

SET DEFINE OFF;
Insert into ROAMING_TYPES (ROAMING_TYPE_ID, NAME) Values (0, '��� ��������');
Insert into ROAMING_TYPES (ROAMING_TYPE_ID, NAME) Values (1, '�������(��� ������ �����������');
Insert into ROAMING_TYPES (ROAMING_TYPE_ID, NAME) Values (2, '������������� �������');
Insert into ROAMING_TYPES (ROAMING_TYPE_ID, NAME) Values  (3, '�������������, ������������ �������');
COMMIT;
