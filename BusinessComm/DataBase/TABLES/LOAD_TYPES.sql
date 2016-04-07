CREATE TABLE LOAD_TYPES (
LOAD_TYPE_ID INTEGER PRIMARY KEY,
LOAD_TYPE_NAME VARCHAR2(10 CHAR) NOT NULL,
URL_TEMPLATE VARCHAR2(200 CHAR) NOT NULL,
USER_CREATED VARCHAR2(30 CHAR) NOT NULL,
DATE_CREATED DATE NOT NULL,
USER_UPDATED VARCHAR2(30 CHAR) NOT NULL,
DATE_UPDATED DATE NOT NULL);

COMMENT ON TABLE LOAD_TYPES IS '���� �������� � ����� ���������';
COMMENT ON COLUMN LOAD_TYPES.LOAD_TYPE_ID  IS '������������� ������';
COMMENT ON COLUMN LOAD_TYPES.LOAD_TYPE_NAME IS '�������� ����';
COMMENT ON COLUMN LOAD_TYPES.URL_TEMPLATE IS '������ ������ ��� �������� (��������, http://10.191.1.57:3200/%operator_name%/payments?branch=%branch%&login=%login%&password=%password%)';
COMMENT ON COLUMN LOAD_TYPES.USER_CREATED IS '������������, ��������� ������';
COMMENT ON COLUMN LOAD_TYPES.DATE_CREATED IS '����/����� �������� ������';
COMMENT ON COLUMN LOAD_TYPES.USER_UPDATED IS '������������, ��������������� ������ ���������';
COMMENT ON COLUMN LOAD_TYPES.DATE_UPDATED IS '����/����� ��������� �������� ������';


CREATE SEQUENCE S_NEW_LOAD_TYPES_ID
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

CREATE OR REPLACE TRIGGER TIU_LOAD_TYPES
  BEFORE INSERT OR UPDATE ON LOAD_TYPES FOR EACH ROW
--#Version=1
BEGIN
  IF INSERTING THEN
    IF NVL(:NEW.LOAD_TYPE_ID, 0) = 0 then
      :NEW.LOAD_TYPE_ID := S_NEW_LOAD_TYPES_ID.NEXTVAL;
    END IF;
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
  END IF;
  :NEW.USER_UPDATED := USER;
  :NEW.DATE_UPDATED := SYSDATE;
END;

-- ��������� ������� load_types.load_type_name
alter table LOAD_TYPES modify load_type_name VARCHAR2(64 CHAR);
-- ��������� ������ ��� ������ SIM-����� ��������
insert into load_types lt values (2,'������ SIM-�����',
'http://10.191.1.57:3200/%operator%/change_sim?branch=%branch%'||chr(38)||'login=%login%'||chr(38)||'password=%password%'||chr(38)||
  'phone=%phone%'||chr(38)||'new_icc_id=%new_icc_id%'||chr(38)||'new_puk1=%new_puk1%',
USER,SYSDATE,USER,SYSDATE);
commit;--
