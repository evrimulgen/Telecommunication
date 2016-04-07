CREATE TABLE STOP_JOB_EXCEPTION
(
  NAME_STOP_JOB  VARCHAR2(30 CHAR)
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

COMMENT ON TABLE STOP_JOB_EXCEPTION IS 'JOB, по которым остановку с помощью STOP_JOB не делаем ';

COMMENT ON COLUMN STOP_JOB_EXCEPTION.NAME_STOP_JOB IS 'Имя job';


CREATE UNIQUE INDEX PK_NAME_STOP_JOB ON STOP_JOB_EXCEPTION
(NAME_STOP_JOB)
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