CREATE TABLE TARIFFS(
  TARIFF_ID               Integer        NOT NULL,
  TARIFF_CODE             Varchar2(30 )  NOT NULL,
  TARIFF_NAME             Varchar2(100 ) NOT NULL,
  MOBILE_OPERATOR_NAME_ID Integer        NOT NULL,
  IS_ACTIVE               Integer        NOT NULL,
  START_BALANCE           Number(10,2),
  CONNECT_PRICE           Number(10,2),
  MONTHLY_PAYMENT         Number(10,2),
  CALC_KOEFF              Number(15,4),
  TARIFF_ADD_COST         Number(15,2),
  CALC_KOEFF_DETAL        Number(15,4),
  USER_CREATED            VARCHAR2(30 CHAR) NOT NULL,
  DATE_CREATED            DATE              NOT NULL,
  USER_LAST_UPDATED       VARCHAR2(30 CHAR) NOT NULL,
  DATE_LAST_UPDATED       DATE              NOT NULL  
);

COMMENT ON TABLE  TARIFFS                         IS '���������� �������� ������';
COMMENT ON COLUMN TARIFFS.TARIFF_ID               IS '������������ ������';
COMMENT ON COLUMN TARIFFS.TARIFF_CODE             IS '��� ��������� �����';
COMMENT ON COLUMN TARIFFS.TARIFF_NAME             IS '������������ ��������� �����';
COMMENT ON COLUMN TARIFFS.MOBILE_OPERATOR_NAME_ID IS '��� ��������� ������� �����';
COMMENT ON COLUMN TARIFFS.IS_ACTIVE               IS '�������� (����� ���������� ��������� �� ����)';
COMMENT ON COLUMN TARIFFS.START_BALANCE           IS '��������� ������';
COMMENT ON COLUMN TARIFFS.CONNECT_PRICE           IS '��������� �����������';
COMMENT ON COLUMN TARIFFS.MONTHLY_PAYMENT         IS '����������� ����� �� ������ � ���.';
COMMENT ON COLUMN TARIFFS.CALC_KOEFF              IS '����������� ��������� ���������';
COMMENT ON COLUMN TARIFFS.TARIFF_ADD_COST         IS '���������� ��������� ��� ������';
COMMENT ON COLUMN TARIFFS.CALC_KOEFF_DETAL        IS '����������� ��������� �����������';
COMMENT ON COLUMN TARIFFS.USER_CREATED            IS '������������, ��������� ������';
COMMENT ON COLUMN TARIFFS.DATE_CREATED            IS '����/����� �������� ������';
COMMENT ON COLUMN TARIFFS.USER_LAST_UPDATED       IS '������������, ��������������� ������ ���������';
COMMENT ON COLUMN TARIFFS.DATE_LAST_UPDATED       IS '����/����� ��������� �������� ������';

CREATE UNIQUE INDEX PK_TARIFFS ON TARIFFS (TARIFF_ID);


CREATE SEQUENCE S_NEW_TARIFFS
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE OR REPLACE TRIGGER TIU_TARIFFS
  BEFORE INSERT OR UPDATE ON TARIFFS FOR EACH ROW
BEGIN
 IF INSERTING THEN
    IF NVL(:NEW.TARIFF_ID, 0) = 0 then
      :NEW.TARIFF_ID := S_NEW_TARIFFS.NEXTVAL;
    END IF;
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
    :NEW.USER_LAST_UPDATED := USER;
    :NEW.DATE_LAST_UPDATED := SYSDATE;
  END IF;
  if UPDATING THEN
    :NEW.USER_LAST_UPDATED := USER;
    :NEW.DATE_LAST_UPDATED := SYSDATE;
  end if;
END;

ALTER TABLE TARIFFS ADD (
  CONSTRAINT TARIFF_ID_PK
  PRIMARY KEY (TARIFF_ID)
  USING INDEX PK_TARIFFS
  ENABLE VALIDATE);

ALTER TABLE TARIFFS ADD (
  CONSTRAINT FK_OPERATOR_ID 
  FOREIGN KEY (MOBILE_OPERATOR_NAME_ID) 
  REFERENCES MOBILE_OPERATOR_NAMES (MOBILE_OPERATOR_NAME_ID)
  ENABLE VALIDATE);

GRANT DELETE, INSERT, SELECT, UPDATE ON TARIFFS TO BUSINESS_COMM_ROLE;
GRANT SELECT ON S_NEW_TARIFFS TO BUSINESS_COMM_ROLE;
GRANT SELECT, UPDATE ON TARIFFS TO BUSINESS_COMM_ROLE_RO;

CREATE UNIQUE INDEX I_TARIFF_ID_TARIFF_NAME ON TARIFFS
(TARIFF_ID, TARIFF_NAME);

CREATE INDEX I_tariffs_tariff_name_add_cost ON  tariffs
  (tariff_id, tariff_name, tariff_add_cost);

-- ��������� foreign key - ������ �� filials.filial_id, ������� ������� mobile_operator_name_id
alter table TARIFFS add filial_id number;
comment on column TARIFFS.filial_id is '������ ��������� FILIALS.FILIAL_ID';
update TARIFFS a set a.filial_id = decode(a.mobile_operator_name_id,31,81,a.mobile_operator_name_id);
alter table TARIFFS modify filial_id not null;
alter table TARIFFS
  add constraint FK_FILIAL_ID1 foreign key (FILIAL_ID)
  references filials (FILIAL_ID);
alter table TARIFFS drop constraint FK_OPERATOR_ID;    
alter table TARIFFS drop column mobile_operator_name_id;