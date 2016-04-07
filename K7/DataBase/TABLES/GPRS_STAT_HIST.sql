CREATE TABLE GPRS_STAT_HIST
(
  STAT_ID          NUMBER(38),
  PHONE            VARCHAR2(10 CHAR),
  TARIFF_CODE      VARCHAR2(30 CHAR),
  INITVALUE        NUMBER(18),
  CURRVALUE        NUMBER(18),
  CURR_CHECK_DATE  TIMESTAMP(6),
  NEXT_CHECK_DATE  TIMESTAMP(6),
  CTRL_PNT         NUMBER(12)                   DEFAULT 0,
  IS_CHECKED       NUMBER(12)                   DEFAULT 0
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

COMMENT ON TABLE GPRS_STAT_HIST				IS '����� ��������� �� ������� ��������� ��� ������������ ������� ������� ������� INTERNET, ������ ����������� ������ ���.������� � ������������ �� ����';

COMMENT ON COLUMN GPRS_STAT_HIST.STAT_ID		IS '��������� ����';

COMMENT ON COLUMN GPRS_STAT_HIST.PHONE			IS '����� ��������';

COMMENT ON COLUMN GPRS_STAT_HIST.TARIFF_CODE 		IS '��� ������';

COMMENT ON COLUMN GPRS_STAT_HIST.INITVALUE 		IS '����� ������� ��� ������������� ������';

COMMENT ON COLUMN GPRS_STAT_HIST.CURRVALUE 		IS '������� ��������� ������';

COMMENT ON COLUMN GPRS_STAT_HIST.CURR_CHECK_DATE 	IS '����-����� ������� ��������';

COMMENT ON COLUMN GPRS_STAT_HIST.NEXT_CHECK_DATE 	IS '����-����� ��������� ��������';

COMMENT ON COLUMN GPRS_STAT_HIST.CTRL_PNT		IS '����� ������� �����, �� ������� ������ �������� ������� ������� ��������� �������� � ����������� ���������� ����� ��� �����������';

COMMENT ON COLUMN GPRS_STAT_HIST.IS_CHECKED 		IS '����� ��������� ������';
/

alter table gprs_stat_hist add (IS_TARIFF number(1) default 0);

COMMENT ON COLUMN gprs_stat_hist.IS_TARIFF IS '������� ��������� �����';

alter table GPRS_STAT_HIST add (TURN_LOG_ID number(28) default 0);

COMMENT ON COLUMN GPRS_STAT_HIST.TURN_LOG_ID IS '��. ������ � ���� ������������ GPRS_TURN_LOG';

CREATE INDEX I_GPRS_STAT_HIST_PHONE ON GPRS_STAT_HIST(PHONE)
COMPRESS 1;
