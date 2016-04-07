--#if not TableExists("PARAMS") then
-- Create table
create table PARAMS
(
  param_id INTEGER not null,
  name     VARCHAR2(30) not null,
  value    VARCHAR2(256),
  type     CHAR(1) not null,
  descr    VARCHAR2(400)
);
-- S - ������ 
-- P - ������
-- N - �����.
-- B - ���������� (1/0)
--#end if

--#if not ConstraintExists("PK_PARAMS")
-- Create/Recreate primary, unique and foreign key constraints 
alter table PARAMS
  add constraint PK_PARAMS primary key (PARAM_ID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
--#end if

--#if not ConstraintExists("UNQ_PARAM_NAME")
alter table PARAMS
  add constraint UNQ_PARAM_NAME unique (NAME)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
--#end if
  
--#if not ObjectExists("S_NEW_PARAM_ID")
CREATE SEQUENCE S_NEW_PARAM_ID
  START WITH 41
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;
--#end if
  

--#if not ObjectExists("TI_PARAM_ID")
CREATE OR REPLACE TRIGGER TI_PARAM_ID
  BEFORE INSERT ON  PARAMS FOR EACH ROW 
DECLARE

BEGIN
      :NEW.PARAM_ID:= S_NEW_PARAM_ID.NEXTVAL;
END;  
--#end if


--#Execute MAIN_SCHEMA=IsClient("")

--#if not GrantExists("PARAMS", "ROLE", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT ALL ON PARAMS TO &MAIN_SCHEMA'||'_ROLE'; end;
--#end if

--#if not GrantExists("PARAMS", "ROLE_RO", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT SELECT ON PARAMS TO &MAIN_SCHEMA'||'_ROLE_RO'; end;
--#end if


--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='PHONE_NUMBER'")  and isclient("GSM_CORP") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('PHONE_NUMBER', '����� ���., �� �����. ������������ ����������� �� �������', 'N', '89266433999');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='DAY_LOAD_BILLS_ERR'") and (isclient("GSM_CORP") or isclient("CORP_MOBILE")) then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('DAY_LOAD_BILLS_ERR', '���� ������, ����� �������� ����������� �������������� � �� ����������� � ���� ������ ������', 'B', '6');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='CRIT_SMS_COUNT'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('CRIT_SMS_COUNT', '����������� ���-�� ���, ����� �������� ����������� ������� ����������� ������', 'N', 50);
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='SHOW_MESSAGE_ON_SITE'") and isclient("GSM_CORP") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SHOW_MESSAGE_ON_SITE', '���������� ��������� ��� ����� � ��', 'S', '1');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='MESSAGE_ON_SITE'") and isclient("GSM_CORP") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('MESSAGE_ON_SITE', '��������� ��� ����� � ��', 'N', '��������� �������� ��� ''������� ����������''<br>�������� ����������� ��� C ����� ����� � ����������! <br>�������, ��� � ����� ���� ��� ���� ���������� �������,<br>���������� ������ ������� � �������� ����� �������!<br>     �������� ��� ��������, ����� � ����, ������� � �����������!!!');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='ROBOT_SITE_ADRESS'") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('ROBOT_SITE_ADRESS', '����� ������ �� ������ �������� ������', 'N',  'http://194.190.8.163:443');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='LOADER_LOG_DIR'") and (isclient("GSM_CORP") or isclient("CORP_MOBILE")) then
insert into params (name, value, type, descr)
values ('LOADER_LOG_DIR', '\\10.176.1.100\share\Tarifer', 'N','���������� ��� �������� �����');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='SMS_SYSTEM_ERROR_NOTICE_PHONES'") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SMS_SYSTEM_ERROR_NOTICE_PHONE', '������ ��� ���-����������� �� ������� �������', 'N',  '9272087270;9277401866;');                      
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='SMS_SYSTEM_ERROR_NOTICE_TYPES'") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SMS_SYSTEM_ERROR_NOTICE_TYPES', '���� �����������.HotBilling;ReportData;Payments;abonSTate', 'N',  'HB;RD;P;ST'); 
--#end if
                    
--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='CALC_ABON_BLOCK_COUNT_DAYS'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('CALC_ABON_BLOCK_COUNT_DAYS', '����� ���� ����� ��.��. ����� �����', 'N',  '1'); =======
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='SMTP_HOST'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SMTP_HOST', '������ SMTP', 'S',  'smtp.qip.ru'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='SMTP_USERNAME'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SMTP_USERNAME', '�������� ����� - ������������', 'S',  'k7@fromru.com'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='SMTP_PASSWORD'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SMTP_PASSWORD', '�������� ����� - ������', 'P',  'ct2OZW2l75kS'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='SMTP_FROMTEXT'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SMTP_FROMTEXT', '�������� ����� - �� ����', 'S',  '�������� �����'); 
--#end if
  
--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='DAY_LOAD_BILLS_ERR'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('TELETIE_PAY_PASSWORD', '������ ��� ����������� ��������', 'N',  '9osGetQSt2Q7'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='MAIL_COST'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('MAIL_COST', '��������� �������� ����� �� 1 ����', 'N',  '3'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='DB_DIR'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('DB_DIR', '����� � ������� �������, �������� ��.�. ', B',  '\\10.176.1.100\share\Tarifer\DB\'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='TEMPDB_DIR'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('TEMPDB_DIR', '���������� ��� ���������� �������� ������ ������� �� �����', B',  'E:\temp\LOADCSV\TEMPDB'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='PHONE_NOTICE_HOT_BILL_ERROR'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('PHONE_NOTICE_HOT_BILL_ERROR', '������� �������� � ������������������� ���. �������', 'N',  '9623630138'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='PHONE_NOTICE_TELETIE_ERROR'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('PHONE_NOTICE_TELETIE_ERROR', '������� �������� � ������������������� TELETIE', 'N',  '9623630138'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='CALC_BALANCE_STREAM_COUNT'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('CALC_BALANCE_STREAM_COUNT', '����� ������� ��������� �������� �������', 'N',  '3'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='TP_NOTIFY_GPRS'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('TP_NOTIFY_GPRS', '�� � ������������ � ������� GPRS', 'S',  '1040,799,819,1201,980,1200,1240,1241,383,404,405,406,407,408,409,410,436,437,538,539,880'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='MES_NOTIFY_GPRS'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('MES_NOTIFY_GPRS', '��������� � ������� GPRS', 'S',  '��������, ������� ��������-������! ����������� 0.5���. - 9,95 ���./ 1�����. �� ��������� ��������, ��������� GPRS � ���������� ���������� ��������, ��� ���������� ����������� ��������. ����. ������� 84957378081'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='TP_NOTIFY_GPRS_ISKL'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('TP_NOTIFY_GPRS_ISKL', '���������� ��� �� � ������������ � ������� GPRS', 'S',  '383,404,405,406,407,408,409,410,436,437,538,539,880'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='MES_NOTIFY_GPRS_ISKL'") and isclient("CORP_MOBILE") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('MES_NOTIFY_GPRS_ISKL', '��������� � ������� GPRS', 'S',  '��������, ������� ��������-������! ����������� 0.5���. - 9,95 ���./ 1�����. �� ��������� ��������, ��������� GPRS � ���������� ���������� ��������, ��� ���������� ����������� ��������. ����. ������� 84957378081'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='SEND_SMS_CREATE_REQUEST'") and (isclient("CORP_MOBILE") or isclient("GSM_CORP")) then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('SEND_SMS_CREATE_REQUEST', '���������� �� ��� ��� �������� ������.', 'N',  '1'); 
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='USERS_ADD_PAYMENT'") and isclient("GSM_CORP") then
INSERT INTO PARAMS (NAME, DESCR, TYPE, VALUE)
  VALUES ('USERS_ADD_PAYMENT', '������������, ������� ��������� ��������� �������', 'S',  'MATVEEVNS;ADMIN;TANYA'); 
--#end if

--ALTER TABLE CORP_MOBILE.PARAMS
--MODIFY(VALUE VARCHAR2(600 BYTE))

ALTER TABLE PARAMS MODIFY(NAME VARCHAR2(60)); 

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='('BEELINE_BLOCK_CODE_FOR_BLOCK', '") and isclient("GSM_CORP") then
Insert into PARAMS (NAME, VALUE, TYPE, DESCR) Values ('BEELINE_BLOCK_CODE_FOR_BLOCK', 'WIB', 'S', '��� ���������� �� ������� (������)');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='('BEELINE_BLOCK_CODE_FOR_BLOCK_SAVE', '") and isclient("GSM_CORP") then
Insert into PARAMS (NAME, VALUE, TYPE, DESCR) Values ('BEELINE_BLOCK_CODE_FOR_BLOCK_SAVE', 'S1B', 'S', '��� ���������� �� ����������(������)');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='('AVG_HOT_BIL_NFILES_PERCENT', '") and isclient("GSM_CORP") then
insert into PARAMS (NAME, VALUE, TYPE, DESCR) values  ('AVG_HOT_BIL_NFILES_PERCENT', 10, 'N',  '����������� (� ���������) ���������� ����������� ������� �� �������� �� ������');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='('AVG_HOT_BIL_FILES_PER_HOUR', '") and isclient("GSM_CORP") then
insert into PARAMS (NAME, VALUE, TYPE, DESCR) values  ('AVG_HOT_BIL_FILES_PER_HOUR', 2, 'N',  '������� ���������� ����������� ������ � ��� (��� �������� ��������)');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='('AVG_HOT_BIL_FILES_PER_DAY', '") and isclient("GSM_CORP") then
insert into PARAMS (NAME, VALUE, TYPE, DESCR) values  ('AVG_HOT_BIL_FILES_PER_DAY', 50, 'N', '������� ���������� ����������� ������ � ���� (��� �������� ��������)');
--#end if

--#if not RecordExists("SELECT * FROM PARAMS WHERE NAME='('AVG_HOT_BIL_FILES_PER_WEEK', '") and isclient("GSM_CORP") then
insert into PARAMS (NAME, VALUE, TYPE, DESCR) values ('AVG_HOT_BIL_FILES_PER_WEEK', 300, 'N', '������� ���������� ����������� ������ � ������ (��� �������� ��������)');
--#end if

--#if not IndexExists("I_PARAMS_NAME_VALUE") then
CREATE UNIQUE INDEX I_PARAMS_NAME_VALUE ON PARAMS(NAME, VALUE);
--#end if

Insert into PARAMS   (NAME, VALUE, TYPE, DESCR)
 Values   ('GET_NEW_CONTRACTS_URL', 'http://tariffer.ditrade.ru/TariferActivation/?PASS_KEY=8c72f20eadcd960af2277612ef2e88be23f1e3122f49a6fa8987d25fcd1de77&DATE=CONTRACT_DATE', 'S', '������ ��� ��������� ����������, �������������� � ������������ ����');

Insert into PARAMS
   (NAME, VALUE, TYPE, DESCR)
 Values
   ( 'MAIL_NEW_CONTRACTS_K7', 'denis@k7.ru', 'S', '�������� ���� K7 ��� �������� ���� � ���������� � �������� ���������');
Insert into PARAMS
   ( NAME, VALUE, TYPE, DESCR)
 Values
   ( 'MAIL_NEW_CONTRACTS_TELETIE', 'info@teletie.ru,start@teletie.ru,elvira_d@simtravel.ru,anastasya_k@simtravel.ru', 'S', '�������� ���� TELETIE ��� �������� ���� � ���������� � �������� ���������');

Insert into PARAMS   ( NAME, VALUE, TYPE, DESCR)
 Values
   ( 'MAIL_NEW_CONTRACTS_FIRST_LINE', '��������� ��������:<br>', 'S', '������ ������ �  ���� ������ ��� ��������� ��������� � ��������');

Insert into PARAMS   ( NAME, VALUE, TYPE, DESCR)
 Values
  ('TARIFER_SUPPORT_MAIL', 'a.afrosin@tarifer.ru,i.matyunin@tarifer.ru,k.kraynov@tarifer.ru,a.alexeev@tarifer.ru', 'S', 'E-mail ������ ����������� ��� ��������� "��������"');


Insert into PARAMS
   (NAME, VALUE, TYPE, DESCR)
 Values
   ('MONTH_COUNT_AVG_SUM', '2', 'N', '���������� ������� �� ������� �������������� ������� ������ ��� ����� ���.�������� -> �������');
   
INSERT INTO PARAMS (NAME, VALUE, TYPE, DESCR) 
VALUES
('TEXT_ABON_FOR_INET_TARIFF', 
 '��������� �������� ����������� ����� �� %month_name% �� ������ ������ ���������� %new_date% � ������� %abon_sum% ���. ��������� ������ �������.', 
 'S', 
 '�������������� � ������������� ���������� �����, ����� ������ ������ ������'); 

Insert into PARAMS
   (NAME, VALUE, TYPE, DESCR)
 Values
   ('SIGNATURE_MAIL_ABOUT_DETAIL_K7', '*��������������� ���������� ����� ���������� �� ����������� �� �������� ����������� ������.
*��� ������ ���� ������������ �������������, �������� �� ���� �� �����.
*�� ���� �������� ���������� e-mail: oao@k7.ru tel: +7 (495) 247-88-88', 'S', '������ ������� ��� ������ � ������������. ����� ���.�� ��������� ������ "�����������". ������ ��������� �� �����');

Insert into PARAMS
   (NAME, VALUE, TYPE, DESCR)
 Values
   ('SIGNATURE_MAIL_ABOUT_DETAIL_TELETIE', '*��������������� ���������� ����� ���������� �� ����������� �� �������� ����������� ������.',
    'S', '������ ������� ��� ������ � ������������ � TeleTie. ����� ���.�� ��������� ������ "�����������". ������ ��������� �� �����');

Insert into PARAMS
   (NAME, VALUE, TYPE, DESCR)
 Values
   ('MAIL_ERROR_TURN_TARIFF_OPTIONS', 'dzhunusova_e@teletie.moscow,koshuba_a@teletie.moscow,dzhenkova_a@teletie.moscow,pozdeeva_t@teletie.moscow,ms@sim-travel.ru,start@teletie.ru', 'S', '������ Email ������� ��� �������� ������� � ����������� ���������� �����');

INSERT INTO PARAMS (NAME, VALUE, TYPE, DESCR) 
VALUES ('TXT_SMS_4_PHONE_WITH_REPRIEVE_ABON', '������: %bal% ���., ������� ����.����� �� ������ %tar% �� ����� %abon_sum% ���. �� ��������� ���������� ���������� ��������� ������!', 'S', '����� ��� ��� ������� � ��������� ������ (��� ������� � �� � ���������. �������)');

INSERT INTO PARAMS (NAME, VALUE, TYPE, DESCR) 
VALUES ('CHECK_NEED_WORK_PROC_SEND_UNL_INTERNET', '1', 'B', '������� ������������� ������ ��������� �������� ��� � �������� ���� ����� ��� ������� � ����������� ����������, � ������� ������ ������ ������');

INSERT INTO PARAMS (NAME, VALUE, TYPE, DESCR) 
VALUES ('CHECK_WORK_PROC_SEND_SMS_PHN_PEPR_ABON', '1', 'B', '������� ������������� ������ ��������� �������� ��� � �������� ���� ����� ��� ������� � ��������� ������');

INSERT INTO PARAMS (NAME, VALUE, TYPE, DESCR) 
VALUES ('DO_NOT_SEND_SMS_BLOCK_PHN_PEPR_ABON', '1', 'B', '�� ���������� ��� � ����� �� ������ � ��������� ������');

COMMIT;

Insert into PARAMS    (NAME, VALUE, TYPE, DESCR)
 Values    ('CHANGE_PP_EMAIL', 'agsv@k7.ru', 'S', '�mail, �� ������� ������������ ������ ��� ����� ������ �������');

Insert into PARAMS  (NAME, VALUE, TYPE, DESCR)
 Values  ('CALL_CENTER_CONTACTS_STR', '+74952478888 ( 0577 � ������� ������ ���������)', 'S', '������ ��������� ��� ��������� � ���������� CALL-������');
 
Insert into PARAMS  (NAME, VALUE, TYPE, DESCR)
 Values  ('TEXT_SMS_ZERO_TRAFFIC_DRAVE_FIRST', '��������� �������! �� ������������� ��������-������, ��������� �� ������ %tariff%. �������� ����������. ����������� ������� �� ����� � ������� ����������� ���������! ������ ������� *132*12# � � ������ �������� lte.teletie.ru. ���.: +74997090202. �������.', 'S', '����� 1 ��� ��� ������� � �� "�����", ������� ������������� ������ � 0 (�� ��� ���������� �������)');
 
Insert into PARAMS  (NAME, VALUE, TYPE, DESCR)
 Values  ('TEXT_SMS_ZERO_TRAFFIC_DRAVE_SECOND', '��������� �������! �� ������������� ��������-������, ��������� �� ������ %tariff%. �������� ����������. ����������� ������� �� ����� � ������� ����������� ���������! ������ ������� *132*12# � � ������ �������� lte.teletie.ru. ���.: +74997090202. �������.', 'S', '����� 2 ��� ��� ������� � �� "�����", ������� ������������� ������ � 0 (�� ��� ���������� �������)');
 
Insert into PARAMS  (NAME, VALUE, TYPE, DESCR)
 Values  ('TEXT_SMS_PREV_FLOW_TRAFFIC_DRAVE_FIRST', '��������� �������! ��������, ��� �� ������������� ����� 80% ���������� ��������-������� �� ������ %tariff%. � ��� �������� ������ %traf_volue% ��. ����� ��������� ��������-������� �������� ����� ����������. ����������� ������� �� ����� � ������� ����������� ���������. ������ ������� *132*12# � � ������ �������� lte.teletie.ru. ���: +74997090202. �������.', 'S', '����� 1 ��� ��� ������� � �� "�����", ������� ������������� ������ ����� ��� �� 80% (�� ��� ���������� �������)');
 
Insert into PARAMS  (NAME, VALUE, TYPE, DESCR)
 Values  ('TEXT_SMS_PREV_FLOW_TRAFFIC_DRAVE_SECOND', '��������� �������! ��������, ��� �� ������������� ����� 80% ���������� ��������-������� �� ������ %tariff%. � ��� �������� ������ %traf_volue% ��. ����� ��������� ��������-������� �������� ����� ����������. ����������� ������� �� ����� � ������� ����������� ���������. ������ ������� *132*12# � � ������ �������� lte.teletie.ru. ���: +74997090202. �������.', 'S', '����� 2 ��� ��� ������� � �� "�����", ������� ������������� ������ ����� ��� �� 80% (�� ��� ���������� �������)');

Insert into PARAMS   (NAME, VALUE, TYPE, DESCR)
 Values   ('MAIL_BLOCK_ON_SAVE', 'agsv@k7.ru', 'S', '�������� �����, �� ������� ������������ ���������� ��� ���������� �������');
 
INSERT INTO PARAMS (NAME, VALUE, TYPE, DESCR) 
VALUES ('CALC_ABON_TP_UNLIM_ON_4_OLD_PHN', '1', 'B', '������� ������ ��������� �� �������� ������ ��� ������� �� ������� ����������� (�.�. �����������, � ������� ���� 2 � ����� ����� ������������� ���������)');

INSERT INTO PARAMS (NAME, VALUE, TYPE, DESCR) 
VALUES ('DAY_BLOCK_PHN_CALC_ABON_TP_UNLIM_NEW_PHN', '3', 'N', '���� ���������� ������� � ��������� ������ (��� ����� �������)');

INSERT INTO PARAMS (NAME, VALUE, TYPE, DESCR) 
VALUES ('DAY_BLOCK_PHN_CALC_ABON_TP_UNLIM_OLD_PHN', '3', 'N', '���� ���������� ������� � ��������� ������ (��� ������ �������)');
  
Insert into PARAMS  (NAME, VALUE, TYPE, DESCR)
 Values  ('TEXT_SMS_ZERO_TRAFFIC_ALL_PHONE', '��������� �������! �� ������������� ��������-������, ��������� �� ������ %tariff%. ������ ������� *132*12# � � ������ �������� lte.teletie.ru. ���.: +74997090202. �������.', 'S', '����� ��� ��� ������� ������� �� ������� � 0');

Insert into PARAMS  (NAME, VALUE, TYPE, DESCR)
 Values  ('TEXT_SMS_PREV_FLOW_TRAFFIC_ALL_PHONE', '��������� �������! ��������, ��� �� ������������� ����� 80% ���������� ������� �� ������ %tariff%. � ��� �������� ������ %traf_volue% ��. ������ ������� *132*12# � � ������ �������� lte.teletie.ru. ���: +74997090202. �������.', 'S', '����� ��� ��� ������� ������� �� ������ ����� ��� �� 80%');

COMMIT;