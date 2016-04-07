CREATE TABLE SERVICE_TYPES(
  SERVICE_TYPE_CHAR Varchar2(1 char) NOT NULL PRIMARY KEY,
  NAME Varchar2(30 ) NOT NULL
)
/
  
COMMENT ON TABLE SERVICE_TYPES IS '��� �������'
/
COMMENT ON COLUMN SERVICE_TYPES.SERVICE_TYPE_CHAR IS '��� ������'
/
COMMENT ON COLUMN SERVICE_TYPES.NAME IS '�������� ���� ������'
/
SET DEFINE OFF;
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('C', '������');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('M', '��������');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('S', '���');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('U', '���');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('G', 'GPRS');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('W', 'WAP');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('D', '����� �� ���.������');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('N', '����� �� ������ �����');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('P', '������������ �����');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('O', '������');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('A', '���������� �����');
Insert into SERVICE_TYPES (SERVICE_TYPE_CHAR, NAME) Values ('J', '�������������');
COMMIT;
