CREATE TABLE CORP_MOBILE_LK.TARIFF_DESCRIPTIONS (
  TARIFF_ID INTEGER CONSTRAINT PK_TARIFF_DESCRIPTION PRIMARY KEY,
  EXTERNAL_URL VARCHAR2(1000 CHAR),
  DESCRIPTION VARCHAR2(4000 CHAR)
  );
  

COMMENT ON TABLE CORP_MOBILE_LK.TARIFF_DESCRIPTIONS IS '�������� �������';