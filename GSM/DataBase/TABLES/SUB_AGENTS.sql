CREATE TABLE LONTANA.SUB_AGENTS
(
  SUB_AGENT_ID       INTEGER                    NOT NULL,
  SUB_AGENT_NAME     VARCHAR2(128 CHAR),
  USER_CREATED       VARCHAR2(30 CHAR),
  DATE_CREATED       DATE,
  USER_LAST_UPDATED  VARCHAR2(30 CHAR),
  DATE_LAST_UPDATED  DATE
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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

COMMENT ON TABLE LONTANA.SUB_AGENTS IS '���������� ����������';

COMMENT ON COLUMN LONTANA.SUB_AGENTS.SUB_AGENT_ID IS '��������� ����';

COMMENT ON COLUMN LONTANA.SUB_AGENTS.SUB_AGENT_NAME IS '������������ ���������';

COMMENT ON COLUMN LONTANA.SUB_AGENTS.USER_CREATED IS '������������, ��������� ������';

COMMENT ON COLUMN LONTANA.SUB_AGENTS.DATE_CREATED IS '����/����� �������� ������';

COMMENT ON COLUMN LONTANA.SUB_AGENTS.USER_LAST_UPDATED IS '������������, ��������������� ������ ���������';

COMMENT ON COLUMN LONTANA.SUB_AGENTS.DATE_LAST_UPDATED IS '����/����� ��������� �������� ������';


CREATE UNIQUE INDEX LONTANA.PK_SUB_AGENT ON LONTANA.SUB_AGENTS
(SUB_AGENT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE SEQUENCE S_NEW_SUB_AGENT_ID
  START WITH 101
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;
  

CREATE OR REPLACE FUNCTION NEW_SUB_AGENT_ID RETURN NUMBER IS
--#Version=1
  vRES NUMBER;
BEGIN
  SELECT S_NEW_SUB_AGENT_ID.NEXTVAL
    INTO vRES
    FROM DUAL;
  RETURN vRES;
END;


CREATE OR REPLACE TRIGGER LONTANA.TIU_SUB_AGENT
BEFORE INSERT OR UPDATE ON LONTANA.SUB_AGENTS FOR EACH ROW
--#Version=1
BEGIN
  IF INSERTING THEN
    IF NVL(:NEW.SUB_AGENT_ID, 0) = 0 then
      :NEW.SUB_AGENT_ID := NEW_SUB_AGENT_ID;
    END IF;
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
  END IF;
  :NEW.USER_LAST_UPDATED := USER;
  :NEW.DATE_LAST_UPDATED := SYSDATE;
END;
/


ALTER TABLE LONTANA.SUB_AGENTS ADD (
  CONSTRAINT PK_SUB_AGENT
 PRIMARY KEY
 (SUB_AGENT_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

GRANT DELETE, INSERT, SELECT, UPDATE ON LONTANA.SUB_AGENTS TO LONTANA_ROLE;