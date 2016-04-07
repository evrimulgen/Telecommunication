CREATE TABLE TARIFFS(
  TARIFF_ID          INTEGER                    NOT NULL,
  TARIFF_CODE        VARCHAR2(30 CHAR),
  OPERATOR_ID        INTEGER,
  TARIFF_NAME        VARCHAR2(100 CHAR),
  IS_ACTIVE          NUMBER(1),
  START_BALANCE      NUMBER,
  CONNECT_PRICE      NUMBER,
  ADVANCE_PAYMENT    NUMBER,
  USER_CREATED       VARCHAR2(30 CHAR),
  DATE_CREATED       DATE,
  USER_LAST_UPDATED  VARCHAR2(30 CHAR),
  DATE_LAST_UPDATED  DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

ALTER TABLE TARIFFS ADD DAYLY_PAYMENT NUMBER(15, 2) DEFAULT 0;

COMMENT ON COLUMN TARIFFS.DAYLY_PAYMENT IS '����������� ����� �� ������';

ALTER TABLE TARIFFS ADD DAYLY_PAYMENT_LOCKED NUMBER(15, 2) DEFAULT 0;

COMMENT ON COLUMN TARIFFS.DAYLY_PAYMENT_LOCKED IS '����������� ����� �� ������ (�������������)';

ALTER TABLE TARIFFS ADD MONTHLY_PAYMENT NUMBER(15, 2) DEFAULT 0;

COMMENT ON COLUMN TARIFFS.MONTHLY_PAYMENT IS '����������� ����� �� ������ � ���.';

ALTER TABLE TARIFFS ADD MONTHLY_PAYMENT_LOCKED NUMBER(15, 2) DEFAULT 0;

COMMENT ON COLUMN TARIFFS.MONTHLY_PAYMENT_LOCKED IS '����������� ����� �� ������ � ���. (�������������)';

ALTER TABLE TARIFFS ADD FREE_MONTH_MINUTES_CNT_FOR_RPT NUMBER(6, 0);


COMMENT ON TABLE TARIFFS IS '�������� �����';

COMMENT ON COLUMN TARIFFS.TARIFF_ID IS '��������� ����';

COMMENT ON COLUMN TARIFFS.TARIFF_NAME IS '������������ ��������� �����';

COMMENT ON COLUMN TARIFFS.TARIFF_CODE IS '��� ��������� �����';

COMMENT ON COLUMN TARIFFS.OPERATOR_ID IS '��� ��������� ������� �����';

COMMENT ON COLUMN TARIFFS.IS_ACTIVE IS '�������� (����� ���������� ��������� �� ����)';

COMMENT ON COLUMN TARIFFS.START_BALANCE IS '��������� ������';

COMMENT ON COLUMN TARIFFS.CONNECT_PRICE IS '��������� �����������';

COMMENT ON COLUMN TARIFFS.ADVANCE_PAYMENT IS '��������� ������';

COMMENT ON COLUMN TARIFFS.USER_CREATED IS '������������, ��������� ������';

COMMENT ON COLUMN TARIFFS.DATE_CREATED IS '����/����� �������� ������';

COMMENT ON COLUMN TARIFFS.USER_LAST_UPDATED IS '������������, ��������������� ������ ���������';

COMMENT ON COLUMN TARIFFS.DATE_LAST_UPDATED IS '����/����� ��������� �������� ������';

COMMENT ON COLUMN TARIFFS.FREE_MONTH_MINUTES_CNT_FOR_RPT IS '���������� ���������� ����� � �����, ��� ���������� ������� ����� �������� �������� � ����� �� ���������� �������';

CREATE INDEX I_TARIFFS_OPERATOR_ID ON TARIFFS(OPERATOR_ID);

CREATE UNIQUE INDEX PK_TARIFFS ON TARIFFS(TARIFF_ID);

CREATE SEQUENCE S_NEW_TARIFF_ID
  START WITH 61
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;


CREATE OR REPLACE FUNCTION NEW_TARIFF_ID RETURN NUMBER IS
--#Version=1
  vRES NUMBER;
BEGIN
  SELECT S_NEW_TARIFF_ID.NEXTVAL
    INTO vRES
    FROM DUAL;
  RETURN vRES;
END;
/

SHOW ERRORS;

CREATE OR REPLACE TRIGGER TU_TARIFFS
  BEFORE UPDATE ON TARIFFS
  REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  IF UPDATING THEN  
    p_new_tarif(:OLD.TARIFF_ID); 
  END IF;          
END;

CREATE OR REPLACE TRIGGER TIU_TARIFFS
  BEFORE INSERT OR UPDATE ON TARIFFS FOR EACH ROW
--#Version=1
BEGIN
  IF INSERTING THEN
    IF NVL(:NEW.TARIFF_ID, 0) = 0 then
      :NEW.TARIFF_ID := NEW_TARIFF_ID;
    END IF;
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
  END IF;
  :NEW.USER_LAST_UPDATED := USER;
  :NEW.DATE_LAST_UPDATED := SYSDATE;
END;
/
SHOW ERRORS;

ALTER TABLE TARIFFS ADD BALANCE_BLOCK NUMBER(12,2);

COMMENT ON COLUMN TARIFFS.BALANCE_BLOCK IS '����� ����������';

ALTER TABLE TARIFFS ADD BALANCE_UNBLOCK NUMBER(12,2);

COMMENT ON COLUMN TARIFFS.BALANCE_UNBLOCK IS '����� �������������';

ALTER TABLE TARIFFS ADD BALANCE_NOTICE NUMBER(12,2);

COMMENT ON COLUMN TARIFFS.BALANCE_NOTICE IS '����� ��������������';

ALTER TABLE TARIFFS ADD TARIFF_ADD_COST NUMBER(12,2);

COMMENT ON COLUMN TARIFFS.TARIFF_ADD_COST IS '���������� ��������� ��� ������';

ALTER TABLE TARIFFS ADD BALANCE_BLOCK_CREDIT NUMBER(12,2);

COMMENT ON COLUMN TARIFFS.BALANCE_BLOCK_CREDIT IS '����� ����������';

ALTER TABLE TARIFFS ADD BALANCE_UNBLOCK_CREDIT NUMBER(12,2);

COMMENT ON COLUMN TARIFFS.BALANCE_UNBLOCK_CREDIT IS '����� �������������';

ALTER TABLE TARIFFS ADD BALANCE_NOTICE_CREDIT NUMBER(12,2);

COMMENT ON COLUMN TARIFFS.BALANCE_NOTICE_CREDIT IS '����� ��������������';

ALTER TABLE TARIFFS ADD   TARIFF_CODE_CRM        VARCHAR2(50 CHAR);

COMMENT ON COLUMN TARIFFS.TARIFF_CODE_CRM IS '��� ��������� ����� �� CRM';

ALTER TABLE TARIFFS ADD TARIFF_PRIORITY INTEGER;

COMMENT ON COLUMN TARIFFS.TARIFF_PRIORITY IS '��������� ��������� �����';

ALTER TABLE TARIFFS ADD TARIFF_ABON_DAILY_PAY INTEGER;

COMMENT ON COLUMN TARIFFS.TARIFF_ABON_DAILY_PAY IS '������ ����������� �� ����(GSM)';

ALTER TABLE TARIFFS ADD TARIFF_ACTION_PLUS_SMS INTEGER;

COMMENT ON COLUMN TARIFFS.TARIFF_ACTION_PLUS_SMS IS '������� ����� + � ���300';

create unique index I_TARIFFS_CODE_PRIORITY_ID on TARIFFS (TARIFF_CODE, NVL(TARIFF_PRIORITY,9999), TARIFF_ID);

-- ������ ��� GSM 
CREATE UNIQUE INDEX UNQ_TRF_CODE_CRM ON TARIFFS
(TARIFF_CODE_CRM)
LOGGING
NOPARALLEL;

-- ������ ��� GSM 
ALTER TABLE TARIFFS
MODIFY(TARIFF_CODE_CRM  NOT NULL);

ALTER TABLE TARIFFS ADD FILIAL_ID INTEGER;

COMMENT ON COLUMN TARIFFS.FILIAL_ID IS '������';

ALTER TABLE TARIFFS ADD OPERATOR_MONTHLY_ABON_ACTIV NUMBER(13, 2);

COMMENT ON COLUMN TARIFFS.OPERATOR_MONTHLY_ABON_ACTIV IS '�������� ����. ��. ��� ��������';

ALTER TABLE TARIFFS ADD OPERATOR_MONTHLY_ABON_BLOCK NUMBER(13, 2);

COMMENT ON COLUMN TARIFFS.OPERATOR_MONTHLY_ABON_BLOCK IS '�������� ����. ��. � ����. ����������';

ALTER TABLE TARIFFS ADD DISCR_SPISANIE NUMBER(1, 0);

COMMENT ON COLUMN TARIFFS.DISCR_SPISANIE IS '���������� �������� ����������� �����';

ALTER TABLE TARIFFS ADD SDVIG_SPISANIY INTEGER;

COMMENT ON COLUMN TARIFFS.SDVIG_SPISANIY IS '����� �������� ����������� �����(1 - �� 1 ���� ������, -2 - �� 2 ��� �����)';

ALTER TABLE TARIFFS ADD TRAFFIC_NOT_IGNOR_FOR_INACTIVE INTEGER;	

COMMENT ON COLUMN TARIFFS.TRAFFIC_NOT_IGNOR_FOR_INACTIVE IS '�� ������������ �������� ������ (��� ������ - ������ � ������������� �����������)';

ALTER TABLE TARIFFS ADD SDVIG_DISCR_SPISANIE INTEGER;

COMMENT ON COLUMN TARIFFS.SDVIG_DISCR_SPISANIE IS '����� ����������� �������� ����������� �����(1 - ���������� ����� 1�� ������, 0 - ����� ����������)';

alter table tariffs add (is_auto_internet number(1) default 0);
COMMENT ON COLUMN TARIFFS.IS_AUTO_INTERNET IS '������� ������� � ������ ��������������� internet ���.�������(�����)';

alter table tariffs add (NOT_USE_REP_PHONE_WITHOUT_TRAF INTEGER);
COMMENT ON COLUMN TARIFFS.NOT_USE_REP_PHONE_WITHOUT_TRAF IS '������� �� ����� ������ � ������ - ������ ��� �������, 1 - �� ���������';

alter table tariffs add (REST_AUTO_INTERNET number(12) default 0);
COMMENT ON COLUMN TARIFFS.REST_AUTO_INTERNET IS '������� ��������-������� ������ ��� ������� ���������� ����������� ���.������ (����������� �������).';

ALTER TABLE TARIFFS ADD (USSD_TURN_ON_COMMAND VARCHAR2(100 BYTE) UNIQUE);
COMMENT ON COLUMN  TARIFFS.USSD_TURN_ON_COMMAND IS '������� USSD ��� �������� �� �����';

alter table tariffs add (CHANGE_TO_TARIFF INTEGER);
COMMENT ON COLUMN TARIFFS.CHANGE_TO_TARIFF IS '������� �������� �� ���� ����� �� ussd (0 -  ��� �������� 1 - �������� �������)';

alter table tariffs add (CHANGE_FROM_TARIFF INTEGER);
COMMENT ON COLUMN TARIFFS.CHANGE_FROM_TARIFF IS '������� �������� c ������� ������ �� ussd (0 -  ��� �������� 1 - �������� �������)';

ALTER TABLE TARIFFS ADD TARIFF_URL VARCHAR2(200 BYTE);
COMMENT ON COLUMN TARIFFS.TARIFF_URL IS '������ �� �������� ��';

Alter table TARIFFS add( SPECIAL_BAN_ID INTEGER);

COMMENT ON COLUMN TARIFFS.SPECIAL_BAN_ID IS '�������������� ������������ ���� (SPECIAL_BANS.SPECIAL_BAN_ID)';

Alter table TARIFFS add( DETAILED_TARIFF_NAME VARCHAR2(100 CHAR));

COMMENT ON COLUMN TARIFFS.DETAILED_TARIFF_NAME IS '������ �������� ������ (�������� ��� � ��������)';

ALTER TABLE TARIFFS ADD (
  CONSTRAINT FK_SPECIAL_BAN_ID
  FOREIGN KEY (SPECIAL_BAN_ID) 
  REFERENCES SPECIAL_BANS (SPECIAL_BAN_ID)
  ENABLE VALIDATE
  );


CREATE OR REPLACE TRIGGER TIU_TARIFFS
BEFORE INSERT OR UPDATE
ON TARIFFS
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    IF NVL(:NEW.TARIFF_ID, 0) = 0 then
      :NEW.TARIFF_ID := NEW_TARIFF_ID;
    END IF;
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
  END IF;
  :NEW.USER_LAST_UPDATED := USER;
  :NEW.DATE_LAST_UPDATED := SYSDATE;
  
  IF NVL(:NEW.PHONE_NUMBER_TYPE, 0) = 0 THEN
    :NEW.PHONE_NUMBER_TYPE := 0;  
  END IF;
  
  if  UPDATING then    
    IF      nvl( :OLD.TARIFF_ID , -1)                                         <> nvl( :NEW.TARIFF_ID , -1)
        OR  nvl( :OLD.TARIFF_CODE , '-1')                                     <> nvl( :NEW.TARIFF_CODE , '-1')
        OR  nvl( :OLD.OPERATOR_ID , -1 )                                      <> nvl( :NEW.OPERATOR_ID , -1 )
        OR  nvl( :OLD.TARIFF_NAME , '-1')                                     <> nvl( :NEW.TARIFF_NAME , '-1')
        OR  nvl( :OLD.IS_ACTIVE , -1)                                         <> nvl( :NEW.IS_ACTIVE , -1)    
        OR  nvl( :OLD.START_BALANCE , -1 )                                    <> nvl( :NEW.START_BALANCE , -1 )      
        OR  nvl( :OLD.CONNECT_PRICE , -1)                                     <> nvl( :NEW.CONNECT_PRICE , -1)       
        OR  nvl( :OLD.ADVANCE_PAYMENT , -1 )                                  <> nvl( :NEW.ADVANCE_PAYMENT , -1 ) 
        OR  nvl( :OLD.USER_CREATED , '-1' )                                   <> nvl( :NEW.USER_CREATED , '-1' )
        OR  nvl( :OLD.DATE_CREATED , to_date('01.01.1900','dd.mm.yyyy') )     <> nvl( :NEW.DATE_CREATED , to_date('01.01.1900','dd.mm.yyyy') )
        OR  nvl( :OLD.PHONE_NUMBER_TYPE , -1 )                                <> nvl( :NEW.PHONE_NUMBER_TYPE , -1 )        
        OR  nvl( :OLD.DAYLY_PAYMENT , -1 )                                    <> nvl( :NEW.DAYLY_PAYMENT , -1 )        
        OR  nvl( :OLD.DAYLY_PAYMENT_LOCKED , -1 )                             <> nvl( :NEW.DAYLY_PAYMENT_LOCKED , -1 )            
        OR  nvl( :OLD.MONTHLY_PAYMENT , -1 )                                  <> nvl( :NEW.MONTHLY_PAYMENT , -1 )          
        OR  nvl( :OLD.MONTHLY_PAYMENT_LOCKED , -1 )                           <> nvl( :NEW.MONTHLY_PAYMENT_LOCKED , -1 )                
        OR  nvl( :OLD.CALC_KOEFF , -1 )                                       <> nvl( :NEW.CALC_KOEFF , -1 )           
        OR  nvl( :OLD.FREE_MONTH_MINUTES_CNT_FOR_RPT , -1 )                   <> nvl( :NEW.FREE_MONTH_MINUTES_CNT_FOR_RPT , -1 )            
        OR  nvl( :OLD.BALANCE_BLOCK , -1  )                                   <> nvl( :NEW.BALANCE_BLOCK , -1  )                                              
        OR  nvl( :OLD.BALANCE_UNBLOCK , -1 )                                  <> nvl( :NEW.BALANCE_UNBLOCK , -1 )       
        OR  nvl( :OLD.BALANCE_NOTICE , -1 )                                   <> nvl( :NEW.BALANCE_NOTICE , -1 ) 
        OR  nvl( :OLD.TARIFF_ADD_COST , -1 )                                  <> nvl( :NEW.TARIFF_ADD_COST , -1 )
        OR  nvl( :OLD.BALANCE_BLOCK_CREDIT , -1 )                             <> nvl( :NEW.BALANCE_BLOCK_CREDIT , -1 )                                                 
        OR  nvl( :OLD.BALANCE_UNBLOCK_CREDIT  , -1 )                          <> nvl( :NEW.BALANCE_UNBLOCK_CREDIT , -1 )                                                     
        OR  nvl( :OLD.BALANCE_NOTICE_CREDIT , -1 )                            <> nvl( :NEW.BALANCE_NOTICE_CREDIT , -1 )                                     
        OR  nvl( :OLD.TARIFF_CODE_CRM , '-1' )                                <> nvl( :NEW.TARIFF_CODE_CRM , '-1' )                                      
        OR  nvl( :OLD.TARIFF_PRIORITY , -1 )                                  <> nvl( :NEW.TARIFF_PRIORITY , -1 )                                         
        OR  nvl( :OLD.TARIFF_ABON_DAILY_PAY , -1 )                            <> nvl( :NEW.TARIFF_ABON_DAILY_PAY , -1 )
        OR  nvl( :OLD.TARIFF_ACTION_PLUS_SMS , -1 )                           <> nvl( :NEW.TARIFF_ACTION_PLUS_SMS , -1 )
        OR  nvl( :OLD.FILIAL_ID    , -1 )                                     <> nvl( :NEW.FILIAL_ID , -1 )                         
        OR  nvl( :OLD.OPERATOR_MONTHLY_ABON_ACTIV  , -1 )                     <> nvl( :NEW.OPERATOR_MONTHLY_ABON_ACTIV , -1 )                                                          
        OR  nvl( :OLD.OPERATOR_MONTHLY_ABON_BLOCK , -1 )                      <> nvl( :NEW.OPERATOR_MONTHLY_ABON_BLOCK , -1 )                                                   
        OR  nvl( :OLD.CALC_KOEFF_DETAL , -1 )                                 <> nvl( :NEW.CALC_KOEFF_DETAL , -1 )                                                      
     THEN       
     INSERT INTO SH_TARIFFS
       ( TARIFF_ID, TARIFF_CODE, OPERATOR_ID, TARIFF_NAME, IS_ACTIVE,  START_BALANCE, CONNECT_PRICE, ADVANCE_PAYMENT, USER_CREATED, DATE_CREATED, USER_LAST_UPDATED, DATE_LAST_UPDATED, PHONE_NUMBER_TYPE, DAYLY_PAYMENT, DAYLY_PAYMENT_LOCKED, MONTHLY_PAYMENT, MONTHLY_PAYMENT_LOCKED, CALC_KOEFF, FREE_MONTH_MINUTES_CNT_FOR_RPT, BALANCE_BLOCK, BALANCE_UNBLOCK, BALANCE_NOTICE, TARIFF_ADD_COST, BALANCE_BLOCK_CREDIT, BALANCE_UNBLOCK_CREDIT, BALANCE_NOTICE_CREDIT, TARIFF_CODE_CRM, TARIFF_PRIORITY, TARIFF_ABON_DAILY_PAY, TARIFF_ACTION_PLUS_SMS, FILIAL_ID, OPERATOR_MONTHLY_ABON_ACTIV, OPERATOR_MONTHLY_ABON_BLOCK, CALC_KOEFF_DETAL, UPDATE_USER, UPDATE_TIME )
     VALUES
       ( :old.TARIFF_ID, :old.TARIFF_CODE, :old.OPERATOR_ID, :old.TARIFF_NAME, :old.IS_ACTIVE, :old.START_BALANCE, :old.CONNECT_PRICE, :old.ADVANCE_PAYMENT, :old.USER_CREATED, :old.DATE_CREATED, :old.USER_LAST_UPDATED, :old.DATE_LAST_UPDATED, :old.PHONE_NUMBER_TYPE, :old.DAYLY_PAYMENT, :old.DAYLY_PAYMENT_LOCKED, :old.MONTHLY_PAYMENT, :old.MONTHLY_PAYMENT_LOCKED, :old.CALC_KOEFF, :old.FREE_MONTH_MINUTES_CNT_FOR_RPT, :old.BALANCE_BLOCK, :old.BALANCE_UNBLOCK, :old.BALANCE_NOTICE, :old.TARIFF_ADD_COST, :old.BALANCE_BLOCK_CREDIT, :old.BALANCE_UNBLOCK_CREDIT, :old.BALANCE_NOTICE_CREDIT, :old.TARIFF_CODE_CRM, :old.TARIFF_PRIORITY, :old.TARIFF_ABON_DAILY_PAY, :old.TARIFF_ACTION_PLUS_SMS, :old.FILIAL_ID, :old.OPERATOR_MONTHLY_ABON_ACTIV, :old.OPERATOR_MONTHLY_ABON_BLOCK, :old.CALC_KOEFF_DETAL, USER, SYSDATE );
    END IF;   
  end if; 
END;
/