--#if not ObjectExists("S_NEW_PAYKEEPER_PAYMENT_ID")
CREATE SEQUENCE S_NEW_PAYKEEPER_PAYMENT_ID;
--#end if

--#if not TableExists("PAYKEEPER_PAYMENT_LOG") then
CREATE TABLE PAYKEEPER_PAYMENT_LOG
(
  PAYKEEPER_PAYMENT_ID  INTEGER CONSTRAINT PK_PAYKEEPER_PAYMENT_LOG PRIMARY KEY,   --  ��������� ���� ID
  PAYKEEPER_ID VARCHAR2 (50 CHAR), 
  PAY_SUM      VARCHAR2 (50 CHAR), --  ����� ������� � ������ � ��������� �� �����. ����������� � �����   
  CLIENT_ID VARCHAR2(10 CHAR), -- ������������� �������. ��� ��, ��� ��� ��������� ����� ������   
  ORDER_ID  VARCHAR2(20 CHAR) DEFAULT NULL, -- ����� ������. �� ����������   
  KEY_HASH  VARCHAR2(50 CHAR),  -- �������� ������� �������, ������ �� �������� a-f � 0-9   
  USER_CREATED  VARCHAR2(30 CHAR),
  DATE_CREATED  DATE,
  USER_LAST_UPDATED  VARCHAR2(30 CHAR),
  DATE_LAST_UPDATED  DATE
);
--#end if

--#if GetTableComment("PAYKEEPER_PAYMENT")<>"�������" then
COMMENT ON TABLE PAYKEEPER_PAYMENT_LOG IS '��� ���� �������� � ��������� ��������� �� ��������� ������� PayKeeper';
--#end if

--#if GetColumnComment("PAYKEEPER_PAYMENT_LOG.PAYKEEPER_PAYMENT_ID") <> "��������� ���� ID" then
COMMENT ON COLUMN PAYKEEPER_PAYMENT_LOG.PAYKEEPER_PAYMENT_ID IS '��������� ���� ID';
--#end if

--#if GetColumnComment("PAYKEEPER_PAYMENT_LOG.PAYKEEPER_ID") <> "��������� ���� ID ����������, ������� �� ������������� ����� ������� � PayKeeper" then
COMMENT ON COLUMN PAYKEEPER_PAYMENT_LOG.PAYKEEPER_ID IS '����������, ������� �� ������������� ����� ������� � PayKeeper';
--#end if

--#if GetColumnComment("PAYKEEPER_PAYMENT_LOG.PAY_SUM") <> "����� ������� � ������ � ��������� �� �����. ����������� � �����" then
COMMENT ON COLUMN PAYKEEPER_PAYMENT_LOG.PAY_SUM IS '����� ������� � ������ � ��������� �� �����. ����������� � �����';
--#end if
                 
--#if GetColumnComment("PAYKEEPER_PAYMENT_LOG.CLIENT_ID") <> "������������� �������. ��� ��, ��� ��� ��������� ����� ������" then
COMMENT ON COLUMN PAYKEEPER_PAYMENT_LOG.CLIENT_ID IS '������������� �������. ��� ��, ��� ��� ��������� ����� ������. � ����� ������ - ����� ��������.';
--#end if
      
--#if GetColumnComment("PAYKEEPER_PAYMENT_LOG.ORDER_ID") <> "����� ������. �� ����������" then
COMMENT ON COLUMN PAYKEEPER_PAYMENT_LOG.ORDER_ID IS '����� ������. �� ����������';
--#end if

--#if GetColumnComment("PAYKEEPER_PAYMENT_LOG.KEY_HASH") <> "�������� ������� �������, ������ �� �������� a-f � 0-9" then
COMMENT ON COLUMN PAYKEEPER_PAYMENT_LOG.KEY_HASH IS '�������� ������� �������, ������ �� �������� a-f � 0-9';
--#end if

--#if not IndexExists("I_PAYKEEPER_PAYMENT_LOG_CLIENT_ID") THEN
CREATE INDEX I_PAYKEEPER_PAYMENT_LOG_NAME ON PAYKEEPER_PAYMENT_LOG(CLIENT_ID);
--#end if

--#IF GetVersion("TIU_PAYKEEPER_PAYMENT_LOG") < 1 THEN
CREATE OR REPLACE TRIGGER TIU_PAYKEEPER_PAYMENTs 
  BEFORE INSERT OR UPDATE ON PAYKEEPER_PAYMENT_LOG FOR EACH ROW 
--#Version=1
BEGIN 
  IF INSERTING THEN 
    IF NVL(:NEW.PAYKEEPER_PAYMENT_ID, 0) = 0 then 
      :NEW.PAYKEEPER_PAYMENT_ID := S_NEW_PAYKEEPER_PAYMENT_ID.NEXTVAL; 
    END IF; 
    :NEW.USER_CREATED := USER; 
    :NEW.DATE_CREATED := SYSDATE;
  END IF; 
  :NEW.USER_LAST_UPDATED := USER; 
  :NEW.DATE_LAST_UPDATED := SYSDATE; 
END;
--#end if

GRANT SELECT, INSERT, UPDATE, DELETE on PAYKEEPER_PAYMENT_LOG TO WWW_DEALER;

GRANT SELECT, INSERT, UPDATE, DELETE on PAYKEEPER_PAYMENT_LOG TO LONTANA_ROLE;

GRANT SELECT on PAYKEEPER_PAYMENT_LOG TO LONTANA_ROLE_RO;

