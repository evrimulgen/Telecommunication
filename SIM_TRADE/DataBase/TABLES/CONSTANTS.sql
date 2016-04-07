--#if not ObjectExists("S_NEW_CONSTANT_ID")
CREATE SEQUENCE S_NEW_CONSTANT_ID;
--#end if


--#if not TableExists("CONSTANTS") then
CREATE TABLE CONSTANTS ( 
  NAME         VARCHAR2 (30)  NOT NULL, 
  DESCR        VARCHAR2 (400), 
  TYPE         CHAR (1)      NOT NULL, 
  VALUE        VARCHAR2 (256), 
  CONSTANT_ID  INTEGER       NOT NULL,
  CONSTRAINT UNQ_CONST_NAME UNIQUE (NAME), 
  CONSTRAINT PK_CONSTANTS
  PRIMARY KEY ( CONSTANT_ID ) ); 
--#end if

--#if GetTableComment("CONSTANTS")<>"��������� ������� (���������, ������� �������� � �.�.)" then
COMMENT ON TABLE CONSTANTS IS '��������� ������� (���������, ������� �������� � �.�.)';
--#end if

--#if GetColumnSize("CONSTANTS.DESCR") < 400 then
ALTER TABLE CONSTANTS
MODIFY  DESCR        VARCHAR2 (400);
--#end if

--#if not ColumnExists("CONSTANTS.PAGE_NAME") then
ALTER TABLE CONSTANTS
ADD  PAGE_NAME VARCHAR2 (256);
--#end if

--#if not ColumnExists("CONSTANTS.ORDER_NUMBER") then
ALTER TABLE CONSTANTS
ADD  ORDER_NUMBER INTEGER;
--#end if

--#if not ColumnExists("CONSTANTS.CAPTION") then
ALTER TABLE CONSTANTS
ADD  CAPTION VARCHAR2(256);
--#end if

--#if not ColumnExists("CONSTANTS.ITEMS") then
ALTER TABLE CONSTANTS
ADD  ITEMS VARCHAR2 (2000);
--#end if

--#if not ColumnExists("CONSTANTS.ACCESS_VERSTION") then
ALTER TABLE CONSTANTS ADD ACCESS_VERSTION NUMBER(13, 6) DEFAULT 0;
--#end if

--#if not ColumnExists("CONSTANTS.ACCESS_VERSTION") then
ALTER TABLE CONSTANTS ADD ACCESS_VERSTION_STRING VARCHAR2(30 CHAR) DEFAULT '0.0.0.0';
--#end if

--#if GetColumnComment("CONSTANTS.CONSTANT_ID") <> "��� ������ (��������� ����)" then
COMMENT ON COLUMN CONSTANTS.CONSTANT_ID IS '��� ������ (��������� ����)';
--#end if

--#if GetColumnComment("CONSTANTS.DESCR") <> "�������� ���������" then
COMMENT ON COLUMN CONSTANTS.DESCR IS '�������� ���������';
--#end if
--#if GetColumnComment("CONSTANTS.NAME") <> "��� ���������" then
COMMENT ON COLUMN CONSTANTS.NAME IS '��� ���������';
--#end if
--#if GetColumnComment("CONSTANTS.TYPE") <> "��� �������� ���������" then
COMMENT ON COLUMN CONSTANTS.TYPE IS '��� �������� ���������';
--#end if
--#if GetColumnComment("CONSTANTS.VALUE") <> "�������� ��������� � ���� ������" then
COMMENT ON COLUMN CONSTANTS.VALUE IS '�������� ��������� � ���� ������';
--#end if
--#if GetColumnComment("CONSTANTS.PAGE_NAME") <> "������������ �������� ���������" then
COMMENT ON COLUMN CONSTANTS.PAGE_NAME IS '������������ �������� ���������';
--#end if
--#if GetColumnComment("CONSTANTS.ORDER_NUMBER") <> "���������� ����� �� �������� ���������" then
COMMENT ON COLUMN CONSTANTS.ORDER_NUMBER IS '���������� ����� �� �������� ���������';
--#end if
--#if GetColumnComment("CONSTANTS.ITEMS") <> "������ ���������� ��������" then
COMMENT ON COLUMN CONSTANTS.ITEMS IS '������ ���������� ��������';
--#end if
--#if GetColumnComment("CONSTANTS.CAPTION") <> "��������� ���������" then
COMMENT ON COLUMN CONSTANTS.CAPTION IS '��������� ���������';
--#end if
--#if GetColumnComment("CONSTANTS.ACCESS_VERSTION") <> "�������� � ������" then
COMMENT ON COLUMN CONSTANTS.ACCESS_VERSTION IS '�������� � ������';
--#end if
--#if GetColumnComment("CONSTANTS.ACCESS_VERSTION") <> "�������� � ������(������)" then
COMMENT ON COLUMN CONSTANTS.ACCESS_VERSTION_STRING IS '�������� � ������(������)';
--#end if

--#if not IndexExists("I_CONSTANTS_NAME_VALUE") then
CREATE UNIQUE INDEX I_CONSTANTS_NAME_VALUE ON CONSTANTS(NAME, VALUE);
--#end if

--#if GetVersion("NEW_CONSTANT_ID") < 1 then
CREATE OR REPLACE FUNCTION NEW_CONSTANT_ID RETURN NUMBER IS
--#Version=1
  RES INTEGER;
begin
  select S_NEW_CONSTANT_ID.NEXTVAL
  INTO RES
  FROM DUAL;
  RETURN RES;
END;
/
--#end if

--#if GetVersion("TBI_CONSTANTS_BEFORE_INSERT") < 1 then
CREATE OR REPLACE TRIGGER tbi_constants_before_insert
  BEFORE INSERT OR UPDATE ON CONSTANTS
  FOR EACH ROW
DECLARE 
  vRES VARCHAR2(30 CHAR);
  vTEMP VARCHAR2(30 CHAR);
  vRESn NUMBER;
--#Version=1
BEGIN
  IF INSERTING THEN
    IF NVL(:NEW.CONSTANT_ID, 0) <= 0 THEN
      :NEW.CONSTANT_ID := new_constant_id;
    END IF;
  END IF;
  vRES:=:NEW.ACCESS_VERSTION_STRING;
  vRESn:=0;
  BEGIN
    --������ 1��
    vTEMP:=SUBSTR(vRES, 1, INSTR(vRES, '.')-1);
    vRES:=SUBSTR(vRES, INSTR(vRES, '.') + 1);
    vRESn:=vRESn + TO_NUMBER(vTEMP) * 1000;
    --������ 2��
    vTEMP:=SUBSTR(vRES, 1, INSTR(vRES, '.')-1);
    vRES:=SUBSTR(vRES, INSTR(vRES, '.') + 1);
    vRESn:=vRESn + TO_NUMBER(vTEMP);
    --������ 3��
    vTEMP:=SUBSTR(vRES, 1, INSTR(vRES, '.')-1);
    vRES:=SUBSTR(vRES, INSTR(vRES, '.') + 1);
    vRESn:=vRESn + TO_NUMBER(vTEMP)/1000;
    --������ ���������
    vRESn:=vRESn + TO_NUMBER(vRES)/1000/1000;    
  EXCEPTION
    WHEN OTHERS THEN
      vRESn:=0;
  END;
  :NEW.ACCESS_VERSTION:=vRESn;
END;
/
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='CALC_ABON_PAYMENT_BLOCK_5_DAYS'") AND (isclient("CORP_MOBILE") OR IsClient("SIM_TRADE")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('CALC_ABON_PAYMENT_BLOCK_5_DAYS', '��������� ��������� ��� 5 ���� ����� ����������', 'B', 1);
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_TARIFF_MISMATCHES'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_TARIFF_MISMATCHES', '���������� ����� - ��������� � �������', 'B', 1);  
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_PHONE_NUMBER_MISMATCHES'") AND (isclient("CORP_MOBILE") OR IsClient("SIM_TRADE")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_PHONE_NUMBER_MISMATCHES', '���������� ����� - ��������� - ������������������ ��������', 'B', 1);    
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_SEND_MAIL_PARAMETRES'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_SEND_MAIL_PARAMETRES', '���������� ���������� - ��������� �������� e-Mail', 'B', 1);      
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_SEND_ON_MAIL'") and IsClient("SIM_TRADE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_SEND_ON_MAIL', '���������� ����� - ��������� ����� �� e-Mail', 'B', 1);        
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REF_MAIL_RECIPIENT'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_REF_MAIL_RECIPIENT', '���������� ���������� - ����������� ������� �� e-Mail', 'B', 1);
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_CONTRACT_ID_AND_DISCOUNT'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_CONTRACT_ID_AND_DISCOUNT', '���������� ������� � ������ ��������� � ������ ��������', 'B', 1);      
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_TARIFFS_ADD_COST'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_TARIFFS_ADD_COST', '���������� ���. ����. ����� � ���������� �������', 'B', 1);      
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_OPERATOR_DISCOUNT'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_OPERATOR_DISCOUNT', '���������� ������ ��������� � ���������� ������', 'B', 1);   
--#end if
    
--#if not RecordExists("SELECT * FROM constants WHERE NAME='HAND_BLOCK_IS_ROBOT_BLOCK'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('HAND_BLOCK_IS_ROBOT_BLOCK', '������ ���������� ��������� ������ ������', 'B', 1);    
--#end if
      
--#if not RecordExists("SELECT * FROM constants WHERE NAME='BLOCK_PHONE_DELAY'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('BLOCK_PHONE_DELAY', '�������� ����� ��������� ��� � ����������� � ��������', 'N', 600);  
--#end if
    
--#if not RecordExists("SELECT * FROM constants WHERE NAME='REPORTS_USE_ACCOUNT_THREADS'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('REPORTS_USE_ACCOUNT_THREADS', '� ������� ������������ ������� �� ���. ������', 'B', 1);     
--#end if
    
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SEND_INFO_SMS'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SEND_INFO_SMS', '����� ��� � ���� ��� ������ ������ ��������', 'B', 1);  
--#end if
    
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_BILLS_OPERATOR_AND_CLIENT'") AND (isclient("CORP_MOBILE") OR IsClient("GSM_CORP")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_BILLS_OPERATOR_AND_CLIENT', '���������� ����� � �� ���������(�� ��������� � ��� �������)', 'B', 1);   
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SERVER_NAME'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SERVER_NAME', '��� �������, ��� ���� ������', 'N', 'CORP_MOBILE');   
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP'") AND (isclient("CORP_MOBILE") OR IsClient("GSM_CORP")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP', '�������� ������ �������� ������ ������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_AUTO_REPORTS'") AND (isclient("CORP_MOBILE") OR IsClient("SIM_TRADE")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_AUTO_REPORTS', '�������� ����������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_BLOCK_SAVE'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_BLOCK_SAVE', '������ � ����� ��� ����� ����������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_UNBLOCK_SAVE'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_UNBLOCK_SAVE', '������ � ����� ���������� ��� ��������', 'B', '1');
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='CREDIT_SYSTEM_ENABLE'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('CREDIT_SYSTEM_ENABLE', '������ ������� ��������, 1-��, ������-���', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='FORWARDING_SYSTEM_ENABLE'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('FORWARDING_SYSTEM_ENABLE', '������������� ��� �� �������, 1-��, ������-���', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_CONTRACT_INFO'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_CONTRACT_INFO', '����� ������� "�������" � ����', 'B', '1');
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_CONTRACT_SEND_ACTIV'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_CONTRACT_SEND_ACTIV', '����� ������� � ���������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SEND_SMS_NOTICE_DELAY'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SEND_SMS_NOTICE_DELAY', '�������� ����� ������������ � ������� � ��������', 'N', '86400');  
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_LOYAL_SYSTEM'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('USE_LOYAL_SYSTEM', '������������ ������� ��������� �����', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_COMPANY_NAME'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_COMPANY_NAME', '���������� �������� �������� � �������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_BILL_CHECK'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('USE_BILL_CHECK', '�������� ������� ������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_PAYMENT_WITHOUT_CONTRACTS'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_PAYMENT_WITHOUT_CONTRACTS', '���������� ����� ������� ��� ���������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_ACCOUNT_STAT_NOW'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_REPORT_ACCOUNT_STAT_NOW', '���������� ����� - ���������� ������� �� ������� �����', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='REPORT_CONTRACTS_HAND_BLOCK'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('REPORT_CONTRACTS_HAND_BLOCK', '���������� ����� - �������� � ������ �����������', 'B', '1');
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_PROMISED_PAYMENTS'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('USE_PROMISED_PAYMENTS', '������������ ������� ��������� ��������', 'B', '1');
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_VIRTUAL_PAYMENTS'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_REPORT_VIRTUAL_PAYMENTS', '���������� ����� - ����������� �������', 'B', '1');  
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='INTERVAL_CHECK_BALANCE_CHANGE'") AND (isclient("CORP_MOBILE") OR IsClient("GSM_CORP")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('INTERVAL_CHECK_BALANCE_CHANGE', '�������� �������� ���������� ������� � ��������', 'N', '1800');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='ENCRYPT_PASSWORD'") AND (isclient("CORP_MOBILE") OR IsClient("GSM_CORP")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('ENCRYPT_PASSWORD', '��������� ������ ��� �����', 'B', '1');
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='AUTO_BLOCK_PHONE_NO_CONTRACTS'") AND (isclient("CORP_MOBILE") OR IsClient("SIM_TRADE")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('AUTO_BLOCK_PHONE_NO_CONTRACTS', '������� ��������� ������� ��� ��������', 'B', '1');
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_FILIAL_BLOCK_ACCESS'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('USE_FILIAL_BLOCK_ACCESS', '���������� �������� ������� � ������ �/�', 'B', '1');
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='HEAD_OFFICE'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('HEAD_OFFICE', '������� ����(����� �������)', 'B', '16');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='DO_TIMER_ON'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('DO_TIMER_ON', '�������� ������ �� ������� ��������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='DO_CHECK_BALANCE_CHANGE'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('DO_CHECK_BALANCE_CHANGE', '������ �������� ��������� �������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='DO_CHECK_HOT_BIL_LOAD'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('DO_CHECK_HOT_BIL_LOAD', '������ �������� �������� ���. ������� � ��', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='DO_CHECK_HOT_BIL_LOAD_LOG'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('DO_CHECK_HOT_BIL_LOAD_LOG', '������ �������� �������� ���. ������� � ����� �� ������� ������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='DO_CHECK_LOAD_LOG'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('DO_CHECK_LOAD_LOG', '������ �������� ����� ������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='DO_CHECK_HACKERS'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('DO_CHECK_HACKERS', '������ �������� �� �������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_CONTRACT_DOP_STATUS'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_CONTRACT_DOP_STATUS', '���������� ���.������ ���������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_CITY_NUMBERS'")  AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_CITY_NUMBERS', '���������� ����� - ��������� ������', 'B', '1');  
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='PAS_FINANCE_REPORT'") AND isclient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('PAS_FINANCE_REPORT', '������ �� ���������� �����', 'N', 'FinanceGsm');  
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_DEBITORKA'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_REPORT_DEBITORKA', '����� "����������� �������������"', 'B', '1');  
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_ABON_DISCOUNTS'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('USE_ABON_DISCOUNTS', '������������ "������ ����������� �����"', 'B', '1');  
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_INSTALLMENT_PAYMENT'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('USE_INSTALLMENT_PAYMENT', '������������ "��������� � ���������"', 'B', '1');  
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_FULL_ACCESS_DENIED_BLOCK'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('USE_FULL_ACCESS_DENIED_BLOCK', '������������ ������ ������ ����� ������(������ ����� ����� ������ �� PHONE_NUMBER_BLOCK_DENIED)', 'B', '1'); 
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_DEALERS'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_DEALERS', '���������� ���������� �������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_ACCOUNT_INFO'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_ACCOUNT_INFO', '���������� ���������� � ������', 'B', '1');
--#end if
  
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_TARIFF_OPT_PHONES'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_REPORT_TARIFF_OPT_PHONES', '���������� ����� �������� �����/������ - ������ �������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='LOAD_FIO_WHEN_LOAD_CONTRACTS'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('LOAD_FIO_WHEN_LOAD_CONTRACTS', '��������� ��� ��� �������� ����������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_SEND_MAIL_INFO_ABON'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_SEND_MAIL_INFO_ABON', '���������� � �������� �������� - �������� �����', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_MISSING_PHONE'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_REPORT_MISSING_PHONE', '���������� ����� ������ ����������� � ���������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_BILL_NEGATIVE'") AND isclient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_REPORT_BILL_NEGATIVE', '���������� ����� ����� ������������ � �����', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='BLOCK_TYPES_ENABLE'") AND (isclient("CORP_MOBILE") OR IsClient("GSM_CORP")) then
INSERT INTO constants (NAME, DESCR, TYPE, VALUE)
  VALUES ('BLOCK_TYPES_ENABLE', '����������� ����-�������', 'B',  '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='REPLACE_SIM_ENABLE'") AND (isclient("CORP_MOBILE") OR IsClient("GSM_CORP")) then
INSERT INTO constants (NAME, DESCR, TYPE, VALUE)
  VALUES ('REPLACE_SIM_ENABLE', '��������� ������ SIM', 'B',  '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_STATUS_JOB'") AND (isclient("CORP_MOBILE") OR IsClient("GSM_CORP")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_STATUS_JOB', '���������� ������� JOB-��', 'N', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_BALANCE_ON_DATE'") and IsClient("SIM_TRADE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_REPORT_BALANCE_ON_DATE', '���������� ����� "������� �� ����"', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_DOP_PHONE_INFO'") AND (isclient("CORP_MOBILE") OR IsClient("GSM_CORP")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_DOP_PHONE_INFO', '���������� �������� ���. ����.', 'N', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_PAYMENTS'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_PAYMENTS', '�������� ������ �������� ������ ������ �������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_STATUS'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_STATUS', '�������� ������ �������� ������ ������ �������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_NACHISL'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_NACHISL', '�������� ������ �������� ������ ������ ����������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_KODBASESTAT'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_KODBASESTAT', '�������� ������ �������� ������ ������ ���� ������� �������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_KODBASESTAMO'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_KODBASESTAMO', '�������� ������ �������� ������ ������ ���� ������� ������� ��', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_BILLS'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_BILLS', '�������� ������ �������� ������ ������ �����', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_CONTRACT'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_CONTRACT', '�������� ������ �������� ������ ������ ���������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_RASTORZH'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_RASTORZH', '�������� ������ �������� ������ ������ �����������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_DETAILS'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_DETAILS', '�������� ������ �������� ������ ������ �����������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_MOBIPAY'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_MOBIPAY', '�������� ������ �������� ������ ������ ��������� �������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_CHANGETP'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_CHANGETP', '�������� ������ �������� ������ ������ ����� ��', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_DOPPHONEINFO'") AND (isclient("CORP_MOBILE") OR IsClient("GSM_CORP")) then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_LOAD_BEE_REP_DOPPHONEINFO', '�������� ������ �������� ������ ������ ���. ����', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='REPLACE_SIM_ADM_ENABLE'") AND IsClient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('REPLACE_SIM_ADM_ENABLE', '��������� ������ SIM ������ �������', 'B', '0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='REPLACE_SIM_ADM_ENABLE'") AND IsClient("GSM_CORP") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_CONTRACT_GROUPS', '���������� ��������� ��������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='IS_MONITORING'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('IS_MONITORING', '���������� ����� ���� ����������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_DETAIL_HIDE_PHONES'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('USE_DETAIL_HIDE_PHONES', '������������ ������� �����������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_BILLVIOLS'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_BILLVIOLS', '���������� ����� - ��������� � �������', 'B', 1);  
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_BILL_VIOLATION_IN_ACCOUNT'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_BILL_VIOLATION_IN_ACCOUNT', '���������� ����� - ��������� � ������', 'B', 1);  
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_SUSPICION_OF_FRAUD'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_SUSPICION_OF_FRAUD', '���������� ����� ���������� � �������������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_MOBPAY'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_MOBPAY', '���������� ����� MobPay � ��������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_JOURNAL_OF_SENDING'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_JOURNAL_OF_SENDING', '���������� ����� ������ ��������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REP_OF_DOPSTATUS'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_REP_OF_DOPSTATUS', '���������� ����� �� ���.��������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_JOURNAL_OF_LOGPHONE'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_JOURNAL_OF_LOGPHONE', '���������� ����� ������ ����� �� ������ ��������', 'B', '1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_TARIFF_OPTION_GROUP'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('USE_TARIFF_OPTION_GROUP', '������������ ���������� "������ �������� �����"', 'B', '1', '1.8.19.0');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_FINANCE_REPORT'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_FINANCE_REPORTS', '���������� ���������� ������', 'B', '1', '1.8.20.1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_FIN_REP_HISTORY_ACTIV_PHONE'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_FIN_REP_HISTORY_ACT_PHONE', '���������� ��� ����� "������ �������� �������"', 'B', '1', '1.8.20.1');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_FIN_REP_INFLOW_OUTFLOW'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_FIN_REP_INFLOW_OUTFLOW', '���������� ��� ����� "������ � ����� �������"', 'B', '1', '1.8.21.1');
--#end if
    
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_HOT_BIL_DELAY'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_HOT_BIL_DELAY', '���������� ����� �� ��������� ��� �������', 'B', '1', '1.8.21.2');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_DETAIL_API'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_DETAIL_API', '���������� ������ �������� ����������� �� API', 'B', '1', '1.8.21.3');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_FINANCE_SUM_BILLS'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_FINANCE_SUM_BILLS', '���������� ���. ����� "����� ������ � ��������', 'B', '1', '1.8.21.7');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_SUM_POSITIVE_BALANCE'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_SUM_POSITIVE_BALANCE', '���������� ����� "����� ������������� ��������"', 'B', '1', '1.8.21.7');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='USE_TYPE_PAYMENTS'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('USE_TYPE_PAYMENTS', '������������ ���� ��������', 'B', '1', '1.8.21.19');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_CHANGE_DST'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_LOAD_BEE_REP_CHANGE_DST', '�������� ������ �������� ������ ������ ����� ���.��������', 'B', '1','1.8.21.19');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_PHONE_INACTIVITY'") AND IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_PHONE_INACTIVITY', '���������� ����� "������ � ������������� �����������"', 'B', '1', '1.8.21.7');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_LOAD_BEE_REP_RECEIVED_PAY'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_LOAD_BEE_REP_RECEIVED_PAY', '�������� ������ �������� ������ ������ ������ �������', 'B', '1','1.8.21.19');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='LOAD_NEW_WHEN_LOAD_CONTRACTS'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('LOAD_NEW_WHEN_LOAD_CONTRACTS', '��������� ����� ���� ��� �������� ����������', 'B', '1','1.8.22.12');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_PASSENGER'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_REPORT_PASSENGER', '���������� ����� ������������', 'B', '1','1.8.22.7');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='BEELINE_SMS_GATEWAY'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('BEELINE_SMS_GATEWAY', '���������� ������� ������������� ���-�����( -1 - ����� ���, 0 - ���� ���� � ��������, 1 - ���� ���� � �������)', 'N', '-1','1.8.24.6');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='BEELINE_SMS_GATEWAY'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_PHONE_ON_BAN_REPORT', '���������� ����� � ������� �� ������� �� ������������ ����� (����)', 'B', '0','1.8.24.6');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_ACCOUNT4PERIOD'") and IsClient("CORP_MOBILE") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_REPORT_ACCOUNT4PERIOD', '�������� ����� �� ������ �� ������', 'B', '0','1.8.24.7');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_APIREJECTBLOCKS'") and IsClient("CORP_MOBILE") then
Insert into CONSTANTS   (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
 Values ('SHOW_REPORT_APIREJECTBLOCKS', '�������� ����� �� ����������� �����������/�������������� ����� API', 'B', '1', '1.8.24.13');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REPORT_HOTBILLINGFILES'") then
Insert into CONSTANTS   (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
 Values ('SHOW_REPORT_HOTBILLINGFILES', '�������� ����� � ��������� �������� ��������', 'B', '1', '1.8.24.13');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REP_RECOV_CLOSE_CONTRACTS'") then
Insert into CONSTANTS
   (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
 Values
   ('SHOW_REP_RECOV_CLOSE_CONTRACTS', '�������� ����� ��� �������������� ��������������/����������� ��������', 'B', '0', '1.8.24.20');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_REP_CHNG_STAT_PRESALE_BLOCK'") then
Insert into CONSTANTS
   (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
 Values
   ('SHOW_REP_CHNG_STAT_PRESAL_BLC', '�������� ����� �� ������� "������������� ����������"', 'B', '0', '1.8.25.10');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='DO_TIMER_LOG_ERROR_ON'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('DO_TIMER_LOG_ERROR_ON', '�������� ������ �� ������� �������� (������ ��������)', 'B', '1', '1.8.25.10');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='INTERVAL_CHECK_LOG_ERROR'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('INTERVAL_CHECK_LOG_ERROR', '�������� �������� ����������� ������ �������� (�������)', 'N', '300', '1.8.25.10');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='MAIL_LOG_ERROR'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('MAIL_LOG_ERROR', 'e-mail ��� �������� ����������� ������ ��������', 'S', 'skotenkov@gmail.com', '1.8.25.10');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='INACTIVE_SUBSCR_COLUMN_NAME'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('INACTIVE_SUBSCR_COLUMN_NAME', '������ ����� ��� ������ "������ � ������������� �����������" ��� TeleTie' , 'S', 'login,phone_number_federal,contract_date,balance,phone_is_active,dop_status_name,last_check_date_time', '1.8.26.29');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='INACTIVE_SUBSCR_COLUMN_NAME'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('ENABLE_BLOCK_BY_SAVE', '���������� ������ "���������� �� ����������"' , 'B', '1', '1.8.26.32');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_FEATURE_PHONE_ISCOLLECTOR'") then
Insert into CONSTANTS
   (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
 Values
   ('SHOW_FEATURE_PHONE_ISCOLLECTOR', '���������� � ����� �������� ������� "���������", ���� ����� ����������� ����������', 'B', '1', '1.8.26.37');
--#end if


Insert into CONSTANTS  (NAME, DESCR, TYPE, VALUE,  ACCESS_VERSTION_STRING) Values
   ('HOT_BILLING_FILE_EXT', '���������� ��� ������������ ����� �������� ��������', 'S', 'dbf',     '0.0.0.0');
   
--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_JOB_AND_SEND_ACCOUNTS'") then
Insert into CONSTANTS
   (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
 Values
   ('SHOW_JOB_AND_SEND_ACCOUNTS', '���������� ��������� �������� � ���������� � ������� ������', 'B', '1', '1.8.26.53');
--#end if
-#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_ROAMING_RETARIF_PROFIT'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_ROAMING_RETARIF_PROFIT', '���������� ����� "���������� ������������� ��������"' , 'B', '1', '1.8.26.55');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='SHOW_BLOCKPHONE_ONEPAYMENT'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
  VALUES ('SHOW_BLOCKPHONE_ONEPAYMENT', '���������� ����� �� ������������ ������ ������' , 'B', '1', '1.8.26.55');
--#end if

--#if not RecordExists("SELECT * FROM constants WHERE NAME='HOUR_START_SEND_PROMIZED_MESS'") then
INSERT INTO CONSTANTS (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
 Values    ('HOUR_START_SEND_PROMIZED_MESS', '����� (���) ������ �������� ��� �� ��������� ���������� �������', 'N', '10', '1.8.26.71');
--#end if

Insert into CONSTANTS
   (NAME, DESCR, TYPE, VALUE, ACCESS_VERSTION_STRING)
 Values
   ('EXPORT_OBJECTS_TO_SVN_PATH', '���� ��� �������� ������ �������� ���� ������', 'S', '/u03/backup/DATA_BASE_SCRIPTS',  '1.8.26.74');
COMMIT;

INSERT INTO CONSTANTS (NAME, DESCR, TYPE, ACCESS_VERSTION_STRING) 
VALUES ('START_TIME_JOB_AFTER_STOP', '����� ������� job ����� �� ���������', 'S', '0.0.0.0');
COMMIT;
