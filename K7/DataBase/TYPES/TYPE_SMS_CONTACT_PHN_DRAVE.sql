CREATE OR REPLACE TYPE TYPE_SMS_CONTACT_PHN_DRAVE AS OBJECT
(PHONE_NUMBER VARCHAR2(10 CHAR), 
 TARIFF_NAME varchar2(300),
 SMS_TYPE INTEGER,
 VALUE_TRAFFIC INTEGER);