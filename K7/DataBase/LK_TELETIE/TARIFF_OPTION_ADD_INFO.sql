CREATE TABLE CORP_MOBILE_LK.TARIFF_OPTION_ADD_INFO (
  TARIFF_OPTION_ID INTEGER CONSTRAINT PK_TARIFF_OPTION_ADD_INFO PRIMARY KEY,
  CATEGORY_NAME VARCHAR2(100 CHAR),
  DESCRIPTION  VARCHAR2(4000 CHAR)
);

COMMENT ON TABLE CORP_MOBILE_LK.TARIFF_OPTION_ADD_INFO IS '�������������� ���������� �� �������';