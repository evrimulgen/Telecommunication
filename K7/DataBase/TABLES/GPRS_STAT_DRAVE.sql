CREATE TABLE GPRS_STAT_DRAVE
(
  DRAVE_STAT_ID    INTEGER,
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
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE GPRS_STAT_DRAVE IS 'Статистика по номерам абонентов c тарифным планом "Драйв" для отслеживания текущих объёмов остатка INTERNET';

COMMENT ON COLUMN GPRS_STAT_DRAVE.DRAVE_STAT_ID IS 'Первичный ключ';

COMMENT ON COLUMN GPRS_STAT_DRAVE.PHONE IS 'Номер телефона';

COMMENT ON COLUMN GPRS_STAT_DRAVE.TARIFF_CODE IS 'Код тарифа';

COMMENT ON COLUMN GPRS_STAT_DRAVE.INITVALUE IS 'Объём трафика при инициализации';

COMMENT ON COLUMN GPRS_STAT_DRAVE.CURRVALUE IS 'Текущий доступный трафик';

COMMENT ON COLUMN GPRS_STAT_DRAVE.CURR_CHECK_DATE IS 'Дата-время текущей проверки';

COMMENT ON COLUMN GPRS_STAT_DRAVE.NEXT_CHECK_DATE IS 'Дата-время следующей проверки';

COMMENT ON COLUMN GPRS_STAT_DRAVE.CTRL_PNT IS 'Метка опорной точки, по опорным точкам строится прогноз времени следующей проверки';

COMMENT ON COLUMN GPRS_STAT_DRAVE.IS_CHECKED IS 'Метка обработки записи';

CREATE UNIQUE INDEX PK_GPRS_STAT_DRAVE ON GPRS_STAT_DRAVE
(DRAVE_STAT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE GPRS_STAT_DRAVE ADD (
  CONSTRAINT PK_GPRS_STAT_DRAVE
  PRIMARY KEY
  (DRAVE_STAT_ID)
  USING INDEX PK_GPRS_STAT_DRAVE);

GRANT SELECT ON GPRS_STAT_DRAVE TO CORP_MOBILE_ROLE;

GRANT SELECT ON GPRS_STAT_DRAVE TO CORP_MOBILE_ROLE_RO;