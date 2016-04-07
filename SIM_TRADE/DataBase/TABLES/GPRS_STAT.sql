CREATE TABLE GPRS_STAT
(
  STAT_ID          NUMBER(38),
  PHONE            VARCHAR2(10 CHAR),
  TARIFF_CODE      VARCHAR2(30 CHAR),
  INITVALUE        NUMBER(18),
  CURRVALUE        NUMBER(18),
  CURR_CHECK_DATE  TIMESTAMP(6),
  NEXT_CHECK_DATE  TIMESTAMP(6),
  CTRL_PNT         NUMBER(1)
)
TABLESPACE USERS
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;
/
ALTER TABLE GPRS_STAT ADD (
  CONSTRAINT PK_GPRS_STAT
 PRIMARY KEY
 (STAT_ID));
/
CREATE SEQUENCE GPRS_STAT_ID
  START WITH 201
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;
/
CREATE OR REPLACE FUNCTION NEW_GPRS_STAT_ID RETURN NUMBER IS
--#Version=1
  vRES NUMBER;
BEGIN
  SELECT GPRS_STAT_ID.NEXTVAL
  INTO vRES
  FROM DUAL;
  RETURN vRES;
END;
/
COMMENT ON TABLE GPRS_STAT 										IS '���������� �� ������� ��������� ��� ������������ ������� ������� ������� INTERNET, ������ ����������� ������ ���.������� � ������������ �� ����';

COMMENT ON COLUMN GPRS_STAT.STAT_ID 					IS '��������� ����';

COMMENT ON COLUMN GPRS_STAT.PHONE 						IS '����� ��������';

COMMENT ON COLUMN GPRS_STAT.TARIFF_CODE 			IS '��� ������';

COMMENT ON COLUMN GPRS_STAT.INITVALUE 				IS '����� ������� ��� ������������� ������';

COMMENT ON COLUMN GPRS_STAT.CURRVALUE 				IS '������� ��������� ������';

COMMENT ON COLUMN GPRS_STAT.CURR_CHECK_DATE 	IS '����-����� ������� ��������';

COMMENT ON COLUMN GPRS_STAT.NEXT_CHECK_DATE 	IS '����-����� ��������� ��������';

COMMENT ON COLUMN GPRS_STAT.CTRL_PNT					IS '����� ������� �����, �� ������� ������ �������� ������� ������� ��������� �������� � ����������� ���������� ����� ��� �����������';

/