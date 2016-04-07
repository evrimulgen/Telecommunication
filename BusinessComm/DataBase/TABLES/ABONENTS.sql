CREATE TABLE ABONENTS
(
 ABONENT_ID              INTEGER               NOT NULL,
  SURNAME                 VARCHAR2(100 CHAR),
  NAME                    VARCHAR2(30 BYTE),
  PATRONYMIC              VARCHAR2(30 BYTE),
  BORN_DATE               DATE,
  PASSPORT_SER            VARCHAR2(10 BYTE),
  PASSPORT_NUM            VARCHAR2(10 BYTE),
  PASSPORT_DATE           DATE,
  PASSPORT_GET            VARCHAR2(150 BYTE),
  COUNTRY_ID_CITIZENSHIP  INTEGER               NOT NULL,
  REGION_ID               INTEGER               NOT NULL,
  COUNTRY_ID              INTEGER               NOT NULL,
  CITY_NAME               VARCHAR2(30 BYTE),
  STREET_NAME             VARCHAR2(30 BYTE),
  HOUSE                   VARCHAR2(5 BYTE),
  KORPUS                  VARCHAR2(5 BYTE),
  APARTMENT               VARCHAR2(10 BYTE),
  CONTACT_INFO            VARCHAR2(150 BYTE),
  IS_VIP                  INTEGER               DEFAULT 0 NOT NULL,
  EMAIL                   VARCHAR2(50 BYTE),
  DESCRIPTION             VARCHAR2(150 BYTE),
  USER_CREATED            VARCHAR2(30 BYTE)     NOT NULL,
  DATE_CREATED            DATE                  NOT NULL,
  USER_LAST_UPDATED       VARCHAR2(30 BYTE)     NOT NULL,
  DATE_LAST_UPDATED       DATE                  NOT NULL
);


COMMENT ON TABLE  ABONENTS IS '���������� ���������';
COMMENT ON COLUMN ABONENTS.ABONENT_ID IS '������������� ������';
COMMENT ON COLUMN ABONENTS.SURNAME IS '�������';
COMMENT ON COLUMN ABONENTS.NAME IS '���';
COMMENT ON COLUMN ABONENTS.PATRONYMIC IS '��������';
COMMENT ON COLUMN ABONENTS.BORN_DATE IS '���� ��������';
COMMENT ON COLUMN ABONENTS.PASSPORT_SER IS '����� ��������';
COMMENT ON COLUMN ABONENTS.PASSPORT_NUM IS '����� ��������';
COMMENT ON COLUMN ABONENTS.PASSPORT_DATE IS '���� ������ ��������';
COMMENT ON COLUMN ABONENTS.PASSPORT_GET IS '��� ����� �������';
COMMENT ON COLUMN ABONENTS.COUNTRY_ID_CITIZENSHIP IS '����������� (COUNTRIES.COUNTRY_ID)';
COMMENT ON COLUMN ABONENTS.REGION_ID IS '��������: ������ (��� ������� �� ����������� ��������)';
COMMENT ON COLUMN ABONENTS.COUNTRY_ID IS '��������: ������ - ������ �� ������ ��  ����������� �������� (COUNTRIES.COUNTRY_ID)';
COMMENT ON COLUMN ABONENTS.CITY_NAME IS '��������: �����';
COMMENT ON COLUMN ABONENTS.STREET_NAME IS '��������: �����';
COMMENT ON COLUMN ABONENTS.HOUSE IS '��������: ���';
COMMENT ON COLUMN ABONENTS.KORPUS IS '��������: ������';
COMMENT ON COLUMN ABONENTS.APARTMENT IS '��������: ��������';
COMMENT ON COLUMN ABONENTS.CONTACT_INFO IS '���������� ���������� (������; �������� � ������������ ����)';
COMMENT ON COLUMN ABONENTS.IS_VIP IS '������� VIP �������';
COMMENT ON COLUMN ABONENTS.EMAIL IS 'E-mail ��������';
COMMENT ON COLUMN ABONENTS.DESCRIPTION IS '��������';
COMMENT ON COLUMN ABONENTS.USER_CREATED IS '������������, ��������� ������';
COMMENT ON COLUMN ABONENTS.DATE_CREATED IS '����/����� �������� ������';
COMMENT ON COLUMN ABONENTS.USER_LAST_UPDATED IS '������������, ��������������� ������ ���������';
COMMENT ON COLUMN ABONENTS.DATE_LAST_UPDATED IS '����/����� ��������� �������� ������';


CREATE UNIQUE INDEX ABONENT_ID_PK ON ABONENTS
(ABONENT_ID);


CREATE SEQUENCE S_NEW_ABONENT_ID
  START WITH 2
  MAXVALUE 9999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE OR REPLACE TRIGGER TUI_ABONENTS
BEFORE INSERT OR UPDATE
ON ABONENTS
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN

 IF INSERTING THEN
    IF NVL(:NEW.ABONENT_ID, 0) = 0 then
      :NEW.ABONENT_ID := S_NEW_ABONENT_ID.NEXTVAL;
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
END ;
/


ALTER TABLE ABONENTS ADD (
  CONSTRAINT ABONENT_ID_PK
  PRIMARY KEY
  (ABONENT_ID)
  USING INDEX ABONENT_ID_PK
  ENABLE VALIDATE);

CREATE UNIQUE INDEX AB_CITI_CO_REG ON ABONENTS
(ABONENT_ID,COUNTRY_ID_CITIZENSHIP,COUNTRY_ID,REGION_ID);

ALTER TABLE BUSINESS_COMM.ABONENTS ADD 
 (CONSTRAINT ABONENTS_FK_COUNTRY FOREIGN KEY (COUNTRY_ID) REFERENCES BUSINESS_COMM.COUNTRIES (COUNTRY_ID) ENABLE VALIDATE,
  CONSTRAINT ABONENTS_FK_REGION  FOREIGN KEY (REGION_ID)  REFERENCES BUSINESS_COMM.REGIONS   (REGIONS_ID) ENABLE VALIDATE
 );


GRANT SELECT ON S_NEW_ABONENT_ID TO BUSINESS_COMM_ROLE;

GRANT DELETE, INSERT, SELECT, UPDATE ON ABONENTS TO BUSINESS_COMM_ROLE;

GRANT SELECT, UPDATE ON ABONENTS TO BUSINESS_COMM_ROLE_RO;

ALTER TABLE ABONENTS ADD (
  KEY_WORD VARCHAR2(50 CHAR),
  INN VARCHAR2(13 CHAR),
  LEGAL_ADDRESS VARCHAR2(250 CHAR),
  DELIVERY_ADDRESS VARCHAR2(250 CHAR),
  OGRN VARCHAR2(13 CHAR),
  CONTACT_PERSON VARCHAR2(150 CHAR)
);

COMMENT ON COLUMN ABONENTS.KEY_WORD IS '�������� �����';
COMMENT ON COLUMN ABONENTS.INN IS '��� ��������';
COMMENT ON COLUMN ABONENTS.LEGAL_ADDRESS IS '����������� �����';
COMMENT ON COLUMN ABONENTS.DELIVERY_ADDRESS IS '����� ��������';
COMMENT ON COLUMN ABONENTS.OGRN IS '����';
COMMENT ON COLUMN ABONENTS.CONTACT_PERSON IS '���������� ����';