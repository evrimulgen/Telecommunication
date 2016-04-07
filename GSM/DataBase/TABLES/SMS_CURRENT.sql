CREATE TABLE SMS_CURRENT(
  PROVIDER_ID INTEGER,
  PHONE VARCHAR2(11 BYTE),
  MESSAGE VARCHAR2(2000 BYTE),
  RESULT_STR VARCHAR2(200 BYTE),
  STATUS_CODE INTEGER,
  DESCRIPTION_STR VARCHAR2(200 BYTE),
  SMS_ID INTEGER,
  INSERT_DATE DATE,
  UPDATE_DATE DATE,
  ERROR_CODE INTEGER,
  REQ_COUNT INTEGER,
  DATE_START DATE
  );

CREATE INDEX SMS_CURRENT$PHONE$IDX ON SMS_CURRENT(PHONE);

CREATE OR REPLACE TRIGGER TIU_SMS_CURRENT
  BEFORE INSERT OR UPDATE ON SMS_CURRENT FOR EACH ROW
--#Version=1
BEGIN
  if INSERTING then
    :NEW.Insert_Date:=sysdate;
  end if;
  :NEW.UPDATE_DATE:= sysdate;
END;
/

--GRANT DELETE, INSERT, SELECT, UPDATE ON SMS_CURRENT TO CORP_MOBILE_ROLE;

--GRANT SELECT ON SMS_CURRENT TO CORP_MOBILE_ROLE_RO;

GRANT DELETE, INSERT, SELECT, UPDATE ON SMS_CURRENT TO LONTANA_ROLE;

GRANT SELECT ON SMS_CURRENT TO LONTANA_ROLE_RO;

--#if not ColumnExists("SMS_CURRENT.SMS_SENDER_NAME")
ALTER TABLE SMS_CURRENT ADD SMS_SENDER_NAME VARCHAR2(20);
COMMENT ON COLUMN SMS_CURRENT.SMS_SENDER_NAME IS '������������� �����, ������������� � ���� "�� ����" ��� �������� ���, ������� �� ������� SMS_SENDER_NAME';
--#end if

COMMENT ON COLUMN SMS_CURRENT.PROVIDER_ID IS '������������� ���������� �� ������� SMS_SEND_PARAMETRS, ����� �������� ���������� ���.';
COMMENT ON COLUMN SMS_CURRENT.PHONE IS '������, �� ������� ������������ ���';
COMMENT ON COLUMN SMS_CURRENT.MESSAGE IS '���� ���������';
COMMENT ON COLUMN SMS_CURRENT.RESULT_STR IS '��������� �������� ��������� (Ok - ��� ������� ��������)';
COMMENT ON COLUMN SMS_CURRENT.STATUS_CODE IS '������������� �������, � ������� ��������� ���';
COMMENT ON COLUMN SMS_CURRENT.DESCRIPTION_STR IS '������ � ������� �� �������';
COMMENT ON COLUMN SMS_CURRENT.SMS_ID IS 'ID ���, ���������� �� �������';
COMMENT ON COLUMN SMS_CURRENT.INSERT_DATE IS '���� ������� ��������� � ������� �� ��������';
COMMENT ON COLUMN SMS_CURRENT.UPDATE_DATE IS '���� ����������';
COMMENT ON COLUMN SMS_CURRENT.ERROR_CODE IS '��� ������';
COMMENT ON COLUMN SMS_CURRENT.REQ_COUNT IS '���������� ������� �������� ���������';
COMMENT ON COLUMN SMS_CURRENT.DATE_START IS '���� ������ ��������';


create sequence sms_current_seq;

alter table sms_current add id integer;

update sms_current set id = sms_current_seq.nextval;

commit;

alter table sms_current modify id not null;

alter table sms_current add constraint sms_current_pk primary key (id);

create or replace trigger TIU_SMS_CURRENT
 before insert or update on SMS_CURRENT
FOR EACH ROW
BEGIN
  if INSERTING then
    :NEW.Insert_Date:=sysdate;
    :new.id := sms_current_seq.nextval;
  end if;
  :NEW.UPDATE_DATE:= sysdate;
END;
/
COMMENT ON COLUMN SMS_CURRENT.id IS '�� ������';