
  CREATE TABLE "CORP_MOBILE"."BILL_FOR_CLIENTS_SAVED" 
   (	"ACCOUNT_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"YEAR_MONTH" NUMBER(*,0) NOT NULL ENABLE, 
	"PHONE_NUMBER" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"DATE_BEGIN" DATE NOT NULL ENABLE, 
	"DATE_END" DATE NOT NULL ENABLE, 
	"DISCOUNT_VALUE" NUMBER(15,2) NOT NULL ENABLE, 
	"SUBSCRIBER_PAYMENT_COEF" NUMBER(15,9) NOT NULL ENABLE, 
	"OPTION_CORRECT_SUM" NUMBER(15,2), 
	"BILL_SUM_ORIGIN" NUMBER(15,2), 
	"BILL_SUM" NUMBER(15,2) NOT NULL ENABLE, 
	"SUBSCRIBER_PAYMENT_NEW" NUMBER(15,2), 
	"SUBSCRIBER_PAYMENT_OLD" NUMBER(15,2), 
	"TARIFF_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"SUBSCRIBER_PAYMENT_ADD_OLD" NUMBER(15,2), 
	"SUBSCRIBER_PAYMENT_ADD_VOZVRAT" NUMBER(15,2), 
	"BILL_CHECKED" NUMBER(*,0), 
	"USER_CREATED" VARCHAR2(30 CHAR), 
	"DATE_CREATED" DATE, 
	"USER_LAST_UPDATED" VARCHAR2(30 CHAR), 
	"DATE_LAST_UPDATED" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 