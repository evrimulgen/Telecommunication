CREATE TABLE DB_LOADER_FULL_BILL_MG_ROUMING(
  ACCOUNT_ID INTEGER NOT NULL,
  YEAR_MONTH INTEGER NOT NULL,
  PHONE_NUMBER VARCHAR2(10 CHAR) NOT NULL,
  DATE_BEGIN DATE NOT NULL,
  DATE_END DATE NOT NULL,
  ROUMING_COUNTRY VARCHAR2(50 CHAR),
  ROUMING_CALLS NUMBER(15, 4) NOT NULL,
  ROUMING_GPRS NUMBER(15, 4) NOT NULL,
  ROUMING_SMS NUMBER(15, 4) NOT NULL,
  COMPANY_TAX NUMBER(15, 4) NOT NULL,
  ROUMING_SUM NUMBER(15, 4) NOT NULL
  );


CREATE OR REPLACE TRIGGER TIU_DB_LDR_F_BILL_MG_ROUMING
  BEFORE INSERT OR UPDATE ON DB_LOADER_FULL_BILL_MG_ROUMING FOR EACH ROW
--#Version=1
BEGIN
  IF INSERTING THEN
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
  END IF;
  :NEW.USER_LAST_UPDATED := USER;
  :NEW.DATE_LAST_UPDATED := SYSDATE;
END;

ALTER TABLE DB_LOADER_FULL_BILL_MG_ROUMING ADD (DATE_CREATED DATE);
ALTER TABLE DB_LOADER_FULL_BILL_MG_ROUMING ADD (USER_CREATED       VARCHAR2(30 CHAR));
ALTER TABLE DB_LOADER_FULL_BILL_MG_ROUMING ADD (USER_LAST_UPDATED  VARCHAR2(30 CHAR));
ALTER TABLE DB_LOADER_FULL_BILL_MG_ROUMING ADD (DATE_LAST_UPDATED  DATE);
ALTER TABLE DB_LOADER_FULL_BILL_MG_ROUMING ADD (BAN  NUMBER(15));

COMMENT ON COLUMN DB_LOADER_FULL_BILL_MG_ROUMING.USER_CREATED IS '������������, ��������� ������';
COMMENT ON COLUMN DB_LOADER_FULL_BILL_MG_ROUMING.DATE_CREATED IS '����/����� �������� ������';
COMMENT ON COLUMN DB_LOADER_FULL_BILL_MG_ROUMING.USER_LAST_UPDATED IS '������������, ��������������� ������ ���������';
COMMENT ON COLUMN DB_LOADER_FULL_BILL_MG_ROUMING.DATE_LAST_UPDATED IS '����/����� ��������� �������� ������';
COMMENT ON COLUMN DB_LOADER_FULL_BILL_MG_ROUMING.BAN IS '��� �����';

               
--GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOADER_FULL_BILL_MG_ROUMING TO SIM_TRADE_ROLE;
               
--GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOADER_FULL_BILL_MG_ROUMING TO LONTANA_ROLE;
               
--GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOADER_FULL_BILL_MG_ROUMING TO CORP_MOBILE_ROLE;
               
--GRANT SELECT ON DB_LOADER_FULL_BILL_MG_ROUMING TO CORP_MOBILE_ROLE_RO;