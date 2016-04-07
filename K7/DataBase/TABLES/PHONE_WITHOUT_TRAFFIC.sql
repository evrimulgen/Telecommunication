CREATE TABLE PHONE_WITHOUT_TRAFFIC
(
  LOGIN                   VARCHAR2(30 CHAR),
  PHONE_NUMBER_FEDERAL    VARCHAR2(10 CHAR),
  CONTRACT_DATE           DATE,
  BALANCE                 NUMBER(15,2),
  PHONE_IS_ACTIVE         VARCHAR2(25 CHAR),
  DOP_STATUS_NAME         VARCHAR2(100 CHAR),
  LAST_CHECK_DATE_STATUS  DATE,
  DATE_CREATED            DATE,
  TARIFF_NAME             VARCHAR2(300 CHAR),
  ERROR_LOAD_API          VARCHAR2(500 CHAR)
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

COMMENT ON TABLE PHONE_WITHOUT_TRAFFIC IS 'Номера без трафика';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.LOGIN IS 'Л/с (логин)';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.PHONE_NUMBER_FEDERAL IS 'Номер';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.CONTRACT_DATE IS 'Дата контракта';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.BALANCE IS 'Баланс';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.PHONE_IS_ACTIVE IS 'Статус';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.DOP_STATUS_NAME IS 'Доп. статус';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.LAST_CHECK_DATE_STATUS IS 'Дата/время последнего обновления статуса';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.DATE_CREATED IS 'Дата создания записи';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.TARIFF_NAME IS 'Наименование тарифа';

COMMENT ON COLUMN PHONE_WITHOUT_TRAFFIC.ERROR_LOAD_API IS 'Ошибка загрузки по АПИ';


GRANT SELECT ON PHONE_WITHOUT_TRAFFIC TO CORP_MOBILE_ROLE;

GRANT SELECT ON PHONE_WITHOUT_TRAFFIC TO CORP_MOBILE_ROLE_RO;