CREATE TABLE PHONES
(
  PHONE_ID           INTEGER                    NOT NULL,
  PHONE_NUMBER       VARCHAR2(13 CHAR)          NOT NULL,
  PHONE_NUMBER_CITY  VARCHAR2(16 CHAR)
);

COMMENT ON TABLE PHONES IS '���������� ���������� �������';

COMMENT ON COLUMN PHONES.PHONE_ID IS '������������� ������ (����� ������ ����������)';

COMMENT ON COLUMN PHONES.PHONE_NUMBER IS '� �������� � ����������� ������� (������ 10 ����)';

COMMENT ON COLUMN PHONES.PHONE_NUMBER_CITY IS '� �������� � ��������� ������� (13 ����)';



CREATE UNIQUE INDEX PHONES_PK ON PHONES
(PHONE_ID);

ALTER TABLE PHONES ADD (
  CONSTRAINT PHONES_PK
  PRIMARY KEY
  (PHONE_ID)
  USING INDEX PHONES_PK
  ENABLE VALIDATE);

GRANT DELETE, INSERT, SELECT, UPDATE PHONES TO BUSINESS_COMM_ROLE;

GRANT SELECT ON PHONES TO BUSINESS_COMM_ROLE_RO;

CREATE INDEX I_phones_id_number_city ON phones
  (phone_id, phone_number_city);
  
ALTER TABLE  PHONES ADD (PHONE_FOR_VIEW VARCHAR2(20 CHAR)) ;
COMMENT ON COLUMN PHONES.PHONE_FOR_VIEW IS '��������� �������� ����������� ������';

alter table phones add(region varchar2(50 char));
comment on column phones.region is '������ �������� ������';

CREATE INDEX I_PHONES_PN_RG_V ON PHONES
(PHONE_id, PHONE_NUMBER, REGION, PHONE_FOR_VIEW);