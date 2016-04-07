create GLOBAL TEMPORARY TABLE PARSED_FILE_TEMP
(
 
  PHONE_ID INTEGER NOT NULL,
  SERVICE_DATE_TIME DATE,
  OTHER_NUMBER VARCHAR2(20 CHAR),
  SERVICE_DIRECTION INTEGER,
  SERVICE_TYPE VARCHAR2(1 CHAR),
  DURATION_SECONDS NUMBER(15,6),
  COST NUMBER (15,6),
  ORIGIN_COST  NUMBER (15,6),
  COST_WITHOUT_VAT  NUMBER (15,6),
  IS_GROUP INTEGER,
  ROAMING_TYPE INTEGER,
  SELF_ZONE VARCHAR2(150 CHAR),
  OTHER_ZONE VARCHAR2(150 CHAR),
  ADD_INFO VARCHAR2(150 CHAR),
  ACCOUNT_NO VARCHAR2(20 CHAR),
  BILL_NUMBER VARCHAR2(20 CHAR),
  BILL_DATE DATE,
  PHONE_LIMIT  NUMBER (15,6), 
  PHONE_CHARGE_LIMIT  NUMBER (15,6),
  OPTIONS VARCHAR2(150 CHAR),
  CASCADE_NUMBER INTEGER
)
ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE PARSED_FILE_TEMP IS '��������� ������� ��� �������� ������ ������ � �����������';

COMMENT ON COLUMN PARSED_FILE_TEMP.PHONE_ID IS '�� ������ �������� �� ������� PHONES';
COMMENT ON COLUMN PARSED_FILE_TEMP.SERVICE_DATE_TIME IS '���� � ����� ������';
COMMENT ON COLUMN PARSED_FILE_TEMP.OTHER_NUMBER IS '����� �����������';
COMMENT ON COLUMN PARSED_FILE_TEMP.SERVICE_DIRECTION IS '����������� ������ �� ������� SERVICE_DIRECTION_TYPES';
COMMENT ON COLUMN PARSED_FILE_TEMP.SERVICE_TYPE IS '��� ������ �� ������� SERVICE_TYPES';
COMMENT ON COLUMN PARSED_FILE_TEMP.DURATION_SECONDS IS '������������ ������';
COMMENT ON COLUMN PARSED_FILE_TEMP.COST IS '��������� ������';
COMMENT ON COLUMN PARSED_FILE_TEMP.ORIGIN_COST IS '��������� ������ �� ��������� �����';
COMMENT ON COLUMN PARSED_FILE_TEMP.COST_WITHOUT_VAT IS '��������� ������ ��� ���';
COMMENT ON COLUMN PARSED_FILE_TEMP.IS_GROUP IS '������� ���������� ������ (1- ���������, 0 - �� ���������)';
COMMENT ON COLUMN PARSED_FILE_TEMP.ROAMING_TYPE IS '��� �������� �� ������� ROAMING_TYPES';
COMMENT ON COLUMN PARSED_FILE_TEMP.SELF_ZONE IS '���� ���������� ������ "������ ������"(������ �����������)';
COMMENT ON COLUMN PARSED_FILE_TEMP.OTHER_ZONE IS '���� ���������� ������ "������ ������"';
COMMENT ON COLUMN PARSED_FILE_TEMP.ADD_INFO IS '�������������� ����������';
                
COMMENT ON COLUMN PARSED_FILE_TEMP.ACCOUNT_NO IS '����� �������� ����� �����������';
COMMENT ON COLUMN PARSED_FILE_TEMP.BILL_NUMBER IS '����� ������������� �����';
COMMENT ON COLUMN PARSED_FILE_TEMP.BILL_DATE IS '���� ������������� �����';
COMMENT ON COLUMN PARSED_FILE_TEMP.PHONE_LIMIT IS '����� ������ �� �����/�����������';
COMMENT ON COLUMN PARSED_FILE_TEMP.PHONE_CHARGE_LIMIT IS '������� ����� ������ �� �����/�����������';
COMMENT ON COLUMN PARSED_FILE_TEMP.OPTIONS IS '�������� ����� �� ������';

COMMENT ON COLUMN PARSED_FILE_TEMP.CASCADE_NUMBER IS '����� ������� �� ������� CASCADE_NUMBER_TYPES';