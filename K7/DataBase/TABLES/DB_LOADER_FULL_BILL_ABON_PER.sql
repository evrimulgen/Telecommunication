CREATE TABLE DB_LOADER_FULL_BILL_ABON_PER(
  ACCOUNT_ID INTEGER NOT NULL,
  YEAR_MONTH INTEGER NOT NULL,
  PHONE_NUMBER VARCHAR2(10 CHAR) NOT NULL,
  DATE_BEGIN DATE NOT NULL,
  DATE_END DATE NOT NULL,
  TARIFF_CODE VARCHAR2(15 CHAR),
  ABON_MAIN NUMBER(15, 4) NOT NULL,
  ABON_ADD NUMBER(15, 4) NOT NULL,
  ABON_ALL NUMBER(15, 4) NOT NULL
  );

CREATE INDEX I_ABON_PER_A_ID_Y_M_PH_N ON DB_LOADER_FULL_BILL_ABON_PER
(ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER)
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


CREATE OR REPLACE TRIGGER TIU_DB_LDR_F_BILL_ABON_PER
  BEFORE INSERT OR UPDATE ON DB_LOADER_FULL_BILL_ABON_PER FOR EACH ROW
--#Version=1
BEGIN
  IF INSERTING THEN
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
  END IF;
  :NEW.USER_LAST_UPDATED := USER;
  :NEW.DATE_LAST_UPDATED := SYSDATE;
END;

ALTER TABLE DB_LOADER_FULL_BILL_ABON_PER ADD (DATE_CREATED DATE);
ALTER TABLE DB_LOADER_FULL_BILL_ABON_PER ADD (USER_CREATED       VARCHAR2(30 CHAR));
ALTER TABLE DB_LOADER_FULL_BILL_ABON_PER ADD (USER_LAST_UPDATED  VARCHAR2(30 CHAR));
ALTER TABLE DB_LOADER_FULL_BILL_ABON_PER ADD (DATE_LAST_UPDATED  DATE);
ALTER TABLE DB_LOADER_FULL_BILL_ABON_PER ADD (BAN NUMBER(15));

COMMENT ON COLUMN DB_LOADER_FULL_BILL_ABON_PER.USER_CREATED IS '������������, ��������� ������';
COMMENT ON COLUMN DB_LOADER_FULL_BILL_ABON_PER.DATE_CREATED IS '����/����� �������� ������';
COMMENT ON COLUMN DB_LOADER_FULL_BILL_ABON_PER.USER_LAST_UPDATED IS '������������, ��������������� ������ ���������';
COMMENT ON COLUMN DB_LOADER_FULL_BILL_ABON_PER.DATE_LAST_UPDATED IS '����/����� ��������� �������� ������';
COMMENT ON COLUMN DB_LOADER_FULL_BILL_ABON_PER.BAN IS '��� �����';

               
--GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOADER_FULL_BILL_ABON_PER TO SIM_TRADE_ROLE;
               
--GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOADER_FULL_BILL_ABON_PER TO LONTANA_ROLE;
               
--GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOADER_FULL_BILL_ABON_PER TO CORP_MOBILE_ROLE;
               
--GRANT SELECT ON DB_LOADER_FULL_BILL_ABON_PER TO CORP_MOBILE_ROLE_RO;