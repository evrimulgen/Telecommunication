--#if not ObjectExists("S_NEW_CONTRACT_ID")
CREATE SEQUENCE S_NEW_CONTRACT_ID
  START WITH 101
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;
--#end if

--#if not TableExists("CONTRACTS") then
CREATE TABLE CONTRACTS
(
  CONTRACT_ID           INTEGER                 NOT NULL,
  CONTRACT_NUM          INTEGER,
  CONTRACT_DATE         DATE,
  FILIAL_ID             INTEGER,
  OPERATOR_ID           INTEGER,
  PHONE_NUMBER_FEDERAL  VARCHAR2(10 CHAR)       NOT NULL,
  PHONE_NUMBER_CITY     VARCHAR2(7 CHAR),
  PHONE_NUMBER_TYPE     NUMBER(1),
  TARIFF_ID             INTEGER,
  SIM_NUMBER            VARCHAR2(20 CHAR),
  SERVICE_ID            INTEGER,
  DISCONNECT_LIMIT      NUMBER,
  CONFIRMED             NUMBER(1),
  USER_CREATED          VARCHAR2(30 CHAR),
  DATE_CREATED          DATE,
  USER_LAST_UPDATED     VARCHAR2(30 CHAR),
  DATE_LAST_UPDATED     DATE,
  ABONENT_ID            INTEGER
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;
--#end if

--#if not ColumnExists("CONTRACTS.RECEIVED_SUM") then
ALTER TABLE CONTRACTS ADD RECEIVED_SUM NUMBER(15, 2) CONSTRAINT CHK_CONTRACTS_RECEIVED_SUM CHECK (RECEIVED_SUM >= 0);
--#end if

--#if not ColumnExists("CONTRACTS.START_BALANCE") then
ALTER TABLE CONTRACTS ADD START_BALANCE NUMBER(15, 2) DEFAULT 0 NOT NULL ;
--#end if

--#if not ColumnExists("CONTRACTS.GOLD_NUMBER_SUM") then
ALTER TABLE CONTRACTS ADD GOLD_NUMBER_SUM NUMBER(15, 2) DEFAULT 0;
--#end if

--#if not ColumnExists("CONTRACTS.USER_PASSWORD") then
ALTER TABLE CONTRACTS ADD USER_PASSWORD VARCHAR2(30 CHAR);
--#end if


--#if not ColumnExists("CONTRACTS.HANDS_BILLING") then
ALTER TABLE CONTRACTS ADD HANDS_BILLING INTEGER;
--#end if



--#if GetTableComment("CONTRACTS")<>"��������" then
COMMENT ON TABLE CONTRACTS IS '��������';
--#end if

--#if GetColumnComment("CONTRACTS.CONTRACT_ID") <> "��������� ����" then
COMMENT ON COLUMN CONTRACTS.CONTRACT_ID IS '��������� ����';
--#end if

--#if GetColumnComment("CONTRACTS.CONTRACT_NUM") <> "����� ��������" then
COMMENT ON COLUMN CONTRACTS.CONTRACT_NUM IS '����� ��������';
--#end if

--#if GetColumnComment("CONTRACTS.CONTRACT_DATE") <> "���� ��������" then
COMMENT ON COLUMN CONTRACTS.CONTRACT_DATE IS '���� ��������';
--#end if

--#if GetColumnComment("CONTRACTS.FILIAL_ID") <> "��� �������" then
COMMENT ON COLUMN CONTRACTS.FILIAL_ID IS '��� �������';
--#end if

--#if GetColumnComment("CONTRACTS.OPERATOR_ID") <> "��� ���������" then
COMMENT ON COLUMN CONTRACTS.OPERATOR_ID IS '��� ���������';
--#end if

--#if GetColumnComment("CONTRACTS.PHONE_NUMBER_FEDERAL") <> "� �������� � ����������� ������� (������ 10 ����)" then
COMMENT ON COLUMN CONTRACTS.PHONE_NUMBER_FEDERAL IS '� �������� � ����������� ������� (������ 10 ����)';
--#end if

--#if GetColumnComment("CONTRACTS.PHONE_NUMBER_CITY") <> "� �������� � ��������� ������� (7 ����)" then
COMMENT ON COLUMN CONTRACTS.PHONE_NUMBER_CITY IS '� �������� � ��������� ������� (7 ����)';
--#end if

--#if GetColumnComment("CONTRACTS.PHONE_NUMBER_TYPE") <> "��� ������ (1- ���������, ����� �����������)" then
COMMENT ON COLUMN CONTRACTS.PHONE_NUMBER_TYPE IS '��� ������ (1- ���������, ����� �����������)';
--#end if

--#if GetColumnComment("CONTRACTS.TARIFF_ID") <> "��� ��������� �����" then
COMMENT ON COLUMN CONTRACTS.TARIFF_ID IS '��� ��������� �����';
--#end if

--#if GetColumnComment("CONTRACTS.SIM_NUMBER") <> "����� SIM �����" then
COMMENT ON COLUMN CONTRACTS.SIM_NUMBER IS '����� SIM �����';
--#end if

--#if GetColumnComment("CONTRACTS.SERVICE_ID") <> "��� ������ ������ ����������� ������" then
COMMENT ON COLUMN CONTRACTS.SERVICE_ID IS '��� ������ ������ ����������� ������';
--#end if

--#if GetColumnComment("CONTRACTS.DISCONNECT_LIMIT") <> "����� ���������� (���������� ������������� ������)" then
COMMENT ON COLUMN CONTRACTS.DISCONNECT_LIMIT IS '����� ���������� (���������� ������������� ������)';
--#end if

--#if GetColumnComment("CONTRACTS.CONFIRMED") <> "1 - �������� ��������" then
COMMENT ON COLUMN CONTRACTS.CONFIRMED IS '1 - �������� ��������';
--#end if

--#if GetColumnComment("CONTRACTS.USER_CREATED") <> "������������, ��������� ������" then
COMMENT ON COLUMN CONTRACTS.USER_CREATED IS '������������, ��������� ������';
--#end if

--#if GetColumnComment("CONTRACTS.DATE_CREATED") <> "����/����� �������� ������" then
COMMENT ON COLUMN CONTRACTS.DATE_CREATED IS '����/����� �������� ������';
--#end if

--#if GetColumnComment("CONTRACTS.USER_LAST_UPDATED") <> "������������, ��������������� ������ ���������" then
COMMENT ON COLUMN CONTRACTS.USER_LAST_UPDATED IS '������������, ��������������� ������ ���������';
--#end if

--#if GetColumnComment("CONTRACTS.DATE_LAST_UPDATED") <> "����/����� ��������� �������� ������" then
COMMENT ON COLUMN CONTRACTS.DATE_LAST_UPDATED IS '����/����� ��������� �������� ������';
--#end if

--#if GetColumnComment("CONTRACTS.ABONENT_ID") <> "��� �������� (�� ����������� ���������)" then
COMMENT ON COLUMN CONTRACTS.ABONENT_ID IS '��� �������� (�� ����������� ���������)';
--#end if

--#if GetColumnComment("CONTRACTS.RECEIVED_SUM") <> "�����, ���������� �� �������� ��� ���������� ��������" then
COMMENT ON COLUMN CONTRACTS.RECEIVED_SUM IS '�����, ���������� �� �������� ��� ���������� ��������';
--#end if

--#if GetColumnComment("CONTRACTS.START_BALANCE") <> "������ �������� �� ������ ���������� �������� (� ������ �������� �������)" then
COMMENT ON COLUMN CONTRACTS.START_BALANCE IS '������ �������� �� ������ ���������� �������� (� ������ �������� �������)';
--#end if

--#if GetColumnComment("CONTRACTS.GOLD_NUMBER_SUM") <> "��������� ""��������"" ������" then
COMMENT ON COLUMN CONTRACTS.GOLD_NUMBER_SUM IS '��������� "��������" ������';
--#end if

--#if GetColumnComment("CONTRACTS.USER_PASSWORD") <> "������ � ������� ��������" then
COMMENT ON COLUMN CONTRACTS.USER_PASSWORD IS '������ � ������� ��������';
--#end if


--#if not IndexExists("I_CONTRACTS_PHONE_NUMBER_CITY") THEN
CREATE INDEX I_CONTRACTS_PHONE_NUMBER_CITY ON CONTRACTS
(PHONE_NUMBER_CITY)
LOGGING
NOPARALLEL;
--#end if


--#if not IndexExists("I_CONTRACTS_PHONE_NUMBER_FEDER") THEN
CREATE INDEX I_CONTRACTS_PHONE_NUMBER_FEDER ON CONTRACTS
(PHONE_NUMBER_FEDERAL)
LOGGING
NOPARALLEL;
--#end if


--#if not IndexExists("I_CONTRACTS_CONTRACT_NUM") THEN
CREATE INDEX I_CONTRACTS_CONTRACT_NUM ON CONTRACTS
(CONTRACT_NUM)
LOGGING
NOPARALLEL;
--#end if

--#if not IndexExists("I_CONTRACTS_CONTRACT_DATE") THEN
CREATE INDEX I_CONTRACTS_CONTRACT_DATE ON CONTRACTS
(CONTRACT_DATE)
LOGGING
NOPARALLEL;
--#end if

--#if not IndexExists("I_CONTRACTS_FILIAL_ID") THEN
CREATE INDEX I_CONTRACTS_FILIAL_ID ON CONTRACTS
(FILIAL_ID)
LOGGING
NOPARALLEL;
--#end if

--#if not IndexExists("I_CONTRACTS_ABONENT_ID") THEN
CREATE INDEX I_CONTRACTS_ABONENT_ID ON CONTRACTS
(ABONENT_ID)
LOGGING
NOPARALLEL;
--#end if

--#if not IndexExists("I_CONTRACTS_TARIFF_ID") THEN
CREATE INDEX I_CONTRACTS_TARIFF_ID ON CONTRACTS
(TARIFF_ID)
LOGGING
NOPARALLEL;
--#end if

--#if not IndexExists("I_CONTRACTS_OPERATOR_ID") THEN
CREATE INDEX I_CONTRACTS_OPERATOR_ID ON CONTRACTS
(OPERATOR_ID)
LOGGING
NOPARALLEL;
--#end if


--#IF GETVERSION("FREE_CONTRACT_NUMBER") < 1 THEN
CREATE OR REPLACE PROCEDURE FREE_CONTRACT_NUMBER(pCONTRACT_NUM INTEGER)  IS
--#Version=1
begin
  AUTO_NUMERATION2.FREE_SEQUENCE_VALUE('CONTRACT_NUM', pCONTRACT_NUM);
end;
--#end if

--#IF GETVERSION("NEW_CONTRACT_ID") < 1 THEN
CREATE OR REPLACE FUNCTION NEW_CONTRACT_ID RETURN NUMBER IS
--#Version=1
  vRES NUMBER;
BEGIN
  SELECT S_NEW_CONTRACT_ID.NEXTVAL
  INTO vRES
  FROM DUAL;
  RETURN vRES;
END;
--#end if

--#IF GETVERSION("TIU_CONTRACTS") < 5 THEN
CREATE OR REPLACE TRIGGER TIU_CONTRACTS
--
--Version=#4
--
--v.4 ������  14.03.2016 - ������� ���� 
--v.3 ������� 02.11.2015 - ������� ����������� ������� CURR_TARIFF_ID, ABONENT_TARIFF_OPTION, BALANCE_NOTICE_HAND_BLOCK, BALANCE_BLOCK_HAND_BLOCK, DAILY_ABON_BANNED
--v.2 �������� 28.10.2014 - ������� NVL � IF NOT(UPDATING and (:NEW.SEND_ACTIV<>:OLD.SEND_ACTIV)) THEN
--
BEFORE INSERT OR UPDATE
ON LONTANA.CONTRACTS
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE 
  pCELL_PLAN_CODE1 VARCHAR2(50 CHAR); 
  pCELL_PLAN_CODE2 VARCHAR2(50 CHAR); 
  vSTART INTEGER;
  vEND INTEGER;
BEGIN
  IF INSERTING THEN
    IF NVL(:NEW.CONTRACT_ID, 0) = 0 then
      :NEW.CONTRACT_ID := NEW_CONTRACT_ID;
    END IF;
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
    :NEW.DAILY_ABON_BANNED := 0;
    BEGIN 
        SELECT CELL_PLAN_CODE INTO pCELL_PLAN_CODE1 FROM DB_LOADER_ACCOUNT_PHONES dlp WHERE dlp.phone_number=:NEW.PHONE_NUMBER_FEDERAL AND dlp.last_check_date_time =                                                                       
            (select max(dlp1.last_check_date_time)                                                                                                                                                                                          
               from db_loader_account_phones dlp1                                                                                                                                                                                           
              where dlp1.phone_number = dlp.phone_number);                                                                                                                                                                                  
        SELECT TARIFF_CODE INTO pCELL_PLAN_CODE2 FROM TARIFFS TR WHERE TR.TARIFF_ID=:NEW.TARIFF_ID;                                                                                                                                          
        IF pCELL_PLAN_CODE1=pCELL_PLAN_CODE2 THEN                                                                                                                                                                                           
          :NEW.CURR_TARIFF_ID := :NEW.TARIFF_ID;                                                                                                                                                                                              
        ELSE
          :NEW.CURR_TARIFF_ID := -3;                                                                                                                                                                                                                               
         --select TARIFF_ID INTO :NEW.CURR_TARIFF_ID from                                                                                                                                                                                      
          --(select * from tariffs TR WHERE TR.TARIFF_CODE=pCELL_PLAN_CODE1 AND NVL(TR.TARIFF_PRIORITY, 9999)=(select min(NVL(TR1.TARIFF_PRIORITY, 9999)) from tariffs TR1 WHERE TR1.TARIFF_CODE=pCELL_PLAN_CODE1)) WHERE ROWNUM=1;           
        END IF;                                                                                                                                                                                                                             
    EXCEPTION 
      WHEN OTHERS THEN NULL; 
    END; 
  END IF;
  IF NOT(UPDATING and (nvl(:NEW.SEND_ACTIV, -1)<>nvl(:OLD.SEND_ACTIV, -1))) THEN
    :NEW.USER_LAST_UPDATED := USER;
    :NEW.DATE_LAST_UPDATED := SYSDATE;
  END IF;
  IF UPDATING THEN 
    IF :NEW.TARIFF_ID<>:OLD.TARIFF_ID THEN 
      :NEW.CURR_TARIFF_ID := :NEW.TARIFF_ID;                                                                                                                                                                                              
      INSERT INTO PHONES_TARIF_FOR_RECALC (PHONE_NUMBER) VALUES (:NEW.PHONE_NUMBER_FEDERAL); 
    END IF; 
  END IF; 
  if  Updating then
    IF      nvl( :OLD.CONTRACT_ID , -1)                                          <> nvl( :NEW.CONTRACT_ID , -1)
        OR  nvl( :OLD.CONTRACT_NUM , -1)                                         <> nvl( :NEW.CONTRACT_NUM , -1)
        OR  nvl( :OLD.CONTRACT_DATE , to_date('01.01.1900','dd.mm.yyyy') )       <> nvl( :NEW.CONTRACT_DATE , to_date('01.01.1900','dd.mm.yyyy') )
        OR  nvl( :OLD.FILIAL_ID , -1)                                            <> nvl( :NEW.FILIAL_ID , -1)
        OR  nvl( :OLD.OPERATOR_ID, -1)                                           <> nvl( :NEW.OPERATOR_ID, -1)
        OR  nvl( :OLD.PHONE_NUMBER_FEDERAL , '-1')                               <> nvl( :NEW.PHONE_NUMBER_FEDERAL , '-1')
        OR  nvl( :OLD.PHONE_NUMBER_CITY , '-1')                                  <> nvl( :NEW.PHONE_NUMBER_CITY , '-1')
        OR  nvl( :OLD.PHONE_NUMBER_TYPE , -1)                                    <> nvl( :NEW.PHONE_NUMBER_TYPE , -1)
        OR  nvl( :OLD.TARIFF_ID , -1 )                                           <> nvl( :NEW.TARIFF_ID , -1 )
        OR  nvl( :OLD.SIM_NUMBER ,  '-1' )                                       <> nvl( :NEW.SIM_NUMBER ,  '-1' )
        OR  nvl( :OLD.SERVICE_ID , -1 )                                          <> nvl( :NEW.SERVICE_ID , -1 )
        OR  nvl( :OLD.DISCONNECT_LIMIT , -1 )                                    <> nvl( :NEW.DISCONNECT_LIMIT , -1 )
        OR  nvl( :OLD.CONFIRMED , -1 )                                           <> nvl( :NEW.CONFIRMED , -1 )
        OR  nvl( :OLD.USER_CREATED , '-1' )                                      <> nvl( :NEW.USER_CREATED , '-1' )
        OR  nvl( :OLD.DATE_CREATED , to_date('01.01.1900','dd.mm.yyyy') )        <> nvl( :NEW.DATE_CREATED , to_date('01.01.1900','dd.mm.yyyy') )
        OR  nvl( :OLD.ABONENT_ID , -1 )                                          <> nvl( :NEW.ABONENT_ID , -1 )
        OR  nvl( :OLD.RECEIVED_SUM , -1 )                                        <> nvl( :NEW.RECEIVED_SUM , -1 )
        OR  nvl( :OLD.START_BALANCE , -1 )                                       <> nvl( :NEW.START_BALANCE , -1 )
        OR  nvl( :OLD.GOLD_NUMBER_SUM , -1 )                                     <> nvl( :NEW.GOLD_NUMBER_SUM , -1 )
        OR  nvl( :OLD.HAND_BLOCK , -1 )                                          <> nvl( :NEW.HAND_BLOCK , -1 )
        OR  nvl( :OLD.USER_PASSWORD , '-1' )                                     <> nvl( :NEW.USER_PASSWORD , '-1' )
        OR  nvl( :OLD.CONNECT_LIMIT , -1 )                                       <> nvl( :NEW.CONNECT_LIMIT , -1 )
        OR  nvl( :OLD.DATE_LAST_SET_PASS , to_date('01.01.1900','dd.mm.yyyy')  ) <> nvl( :NEW.DATE_LAST_SET_PASS , to_date('01.01.1900','dd.mm.yyyy')  )       
        OR  nvl( :OLD.COUNT_SET_PASS_BY_DAY , -1 )                               <> nvl( :NEW.COUNT_SET_PASS_BY_DAY , -1 )       
        OR  nvl( :OLD.HAND_BLOCK_DATE_END , to_date('01.01.1900','dd.mm.yyyy') ) <> nvl( :NEW.HAND_BLOCK_DATE_END , to_date('01.01.1900','dd.mm.yyyy')  )    
        OR  nvl( :OLD.COMMENTS , '-1' )                                          <> nvl( :NEW.COMMENTS , '-1' )
        OR  nvl( :OLD.IS_CREDIT_CONTRACT , -1 )                                  <> nvl( :NEW.IS_CREDIT_CONTRACT , -1 )
        OR  nvl( :OLD.SEND_ACTIV , -1 )                                          <> nvl( :NEW.SEND_ACTIV , -1 )
        OR  nvl( :OLD.DOP_STATUS  , -1 )                                         <> nvl( :NEW.DOP_STATUS , -1 )
        OR  nvl( :OLD.DEALER_KOD    , -1 )                                       <> nvl( :NEW.DEALER_KOD , -1 )
        OR  nvl( :OLD.CURR_TARIFF_ID , -1 )                                      <> nvl( :NEW.CURR_TARIFF_ID , -1 )    
        OR  nvl( :OLD.ABON_TP_DISCOUNT , -1 )                                    <> nvl( :NEW.ABON_TP_DISCOUNT , -1 )
        OR  nvl( :OLD.INSTALLMENT_PAYMENT_DATE , to_date('01.01.1900','dd.mm.yyyy')  ) <> nvl( :NEW.INSTALLMENT_PAYMENT_DATE , to_date('01.01.1900','dd.mm.yyyy')  )                                       
        OR  nvl( :OLD.INSTALLMENT_PAYMENT_SUM , -1 )                             <> nvl( :NEW.INSTALLMENT_PAYMENT_SUM , -1 )
        OR  nvl( :OLD.INSTALLMENT_PAYMENT_MONTHS , -1 )                          <> nvl( :NEW.INSTALLMENT_PAYMENT_MONTHS , -1 )
        OR  nvl( :OLD.INSTALLMENT_ADVANCED_REPAYMENT , to_date('01.01.1900','dd.mm.yyyy')  ) <> nvl( :NEW.INSTALLMENT_ADVANCED_REPAYMENT , to_date('01.01.1900','dd.mm.yyyy')  )                                  
        OR  nvl( :OLD.GROUP_ID  , -1 )                                           <> nvl( :NEW.GROUP_ID , -1 )                                                          
        OR  nvl( :OLD.OPTION_GROUP_ID , -1 )                                     <> nvl( :NEW.OPTION_GROUP_ID , -1 )
        OR  nvl( :OLD.MN_ROAMING , -1 )                                          <> nvl( :NEW.MN_ROAMING , -1 )
        OR  nvl( :OLD.PARAMDISABLE_SMS , '-1' )                                  <> nvl( :NEW.PARAMDISABLE_SMS , '-1' )
        OR  nvl( :OLD.CURR_TARIFF_ID, -1 )                                       <> nvl( :NEW.CURR_TARIFF_ID, -1 )
        OR  nvl( :OLD.ABONENT_TARIFF_OPTION , '-1' )                             <> nvl( :NEW.ABONENT_TARIFF_OPTION , '-1' )
        OR  nvl( :OLD.BALANCE_NOTICE_HAND_BLOCK , -1 )                           <> nvl( :NEW.BALANCE_NOTICE_HAND_BLOCK , -1 )
        OR  nvl( :OLD.BALANCE_BLOCK_HAND_BLOCK , -1 )                            <> nvl( :NEW.BALANCE_BLOCK_HAND_BLOCK , -1 )
        OR  nvl( :OLD.DAILY_ABON_BANNED , -1 )                                   <> nvl( :NEW.DAILY_ABON_BANNED , -1 )
        OR  nvl( :OLD.HANDS_BILLING , -1)                                        <> nvl( :NEW.HANDS_BILLING , -1 )
    THEN      
    INSERT INTO SH_CONTRACTS
       ( CONTRACT_ID, CONTRACT_NUM, CONTRACT_DATE, FILIAL_ID, OPERATOR_ID, PHONE_NUMBER_FEDERAL, PHONE_NUMBER_CITY, PHONE_NUMBER_TYPE, TARIFF_ID, SIM_NUMBER, SERVICE_ID, DISCONNECT_LIMIT, CONFIRMED, USER_CREATED, DATE_CREATED, USER_LAST_UPDATED, DATE_LAST_UPDATED, ABONENT_ID, RECEIVED_SUM, START_BALANCE, GOLD_NUMBER_SUM, HAND_BLOCK, USER_PASSWORD, CONNECT_LIMIT, DATE_LAST_SET_PASS, COUNT_SET_PASS_BY_DAY, HAND_BLOCK_DATE_END, COMMENTS, IS_CREDIT_CONTRACT, SEND_ACTIV, DOP_STATUS, DEALER_KOD, ABON_TP_DISCOUNT, INSTALLMENT_PAYMENT_DATE, INSTALLMENT_PAYMENT_SUM, INSTALLMENT_PAYMENT_MONTHS, INSTALLMENT_ADVANCED_REPAYMENT, GROUP_ID, OPTION_GROUP_ID, MN_ROAMING, UPDATE_TIME, UPDATE_USER, PARAMDISABLE_SMS, CURR_TARIFF_ID, ABONENT_TARIFF_OPTION, BALANCE_NOTICE_HAND_BLOCK, BALANCE_BLOCK_HAND_BLOCK, DAILY_ABON_BANNED, HANDS_BILLING)
    VALUES
       ( :old.CONTRACT_ID, :old.CONTRACT_NUM, :old.CONTRACT_DATE, :old.FILIAL_ID, :old.OPERATOR_ID, :old.PHONE_NUMBER_FEDERAL, :old.PHONE_NUMBER_CITY, :old.PHONE_NUMBER_TYPE, :old.TARIFF_ID, :old.SIM_NUMBER, :old.SERVICE_ID, :old.DISCONNECT_LIMIT, :old.CONFIRMED, :old.USER_CREATED, :old.DATE_CREATED, :old.USER_LAST_UPDATED, :old.DATE_LAST_UPDATED, :old.ABONENT_ID, :old.RECEIVED_SUM, :old.START_BALANCE, :old.GOLD_NUMBER_SUM, :old.HAND_BLOCK, :old.USER_PASSWORD, :old.CONNECT_LIMIT, :old.DATE_LAST_SET_PASS, :old.COUNT_SET_PASS_BY_DAY, :old.HAND_BLOCK_DATE_END, :old.COMMENTS, :old.IS_CREDIT_CONTRACT, :old.SEND_ACTIV, :old.DOP_STATUS, :old.DEALER_KOD, :old.ABON_TP_DISCOUNT, :old.INSTALLMENT_PAYMENT_DATE, :old.INSTALLMENT_PAYMENT_SUM, :old.INSTALLMENT_PAYMENT_MONTHS, :old.INSTALLMENT_ADVANCED_REPAYMENT, :old.GROUP_ID, :old.OPTION_GROUP_ID, :old.MN_ROAMING, sysdate, user, :old.PARAMDISABLE_SMS, :old.CURR_TARIFF_ID, :old.ABONENT_TARIFF_OPTION, :old.BALANCE_NOTICE_HAND_BLOCK, :old.BALANCE_BLOCK_HAND_BLOCK, :old.DAILY_ABON_BANNED, :OLD.HANDS_BILLING);
    END IF;  
        
    IF :NEW.DAILY_ABON_BANNED = 1 THEN
      DELETE FROM PHONE_NUMBER_WITH_DAILY_ABON
        WHERE PHONE_NUMBER_WITH_DAILY_ABON.PHONE_NUMBER = :NEW.phone_number_federal;
    END IF;  
  end if;  
  IF INSERTING THEN
    vSTART:=TO_NUMBER(TO_CHAR(:NEW.contract_date, 'YYYYMM'));
    vEND:=TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'));
    FOR I IN TRUNC(vSTART/100)..TRUNC(vEND/100) 
    LOOP
      FOR J IN 1..12 
      LOOP
        IF (I*100 + J >= vSTART) AND (I*100 + J <= vEND) THEN
          INSERT INTO QUEUE_ABONENT_PER_REBILD(YEAR_MONTH, PHONE_NUMBER)
            VALUES(I*100 + J, :NEW.phone_number_federal);
        END IF;
      END LOOP;
    END LOOP;  
  END IF;  
END;
/
--#end if


--#if not ConstraintExists("PK_CONTRACTS")
ALTER TABLE CONTRACTS ADD (
  CONSTRAINT PK_CONTRACTS
 PRIMARY KEY
 (CONTRACT_ID));
--#end if

--#if not ConstraintExists("FK_CONTRACTS_FILIAL_ID")
ALTER TABLE CONTRACTS ADD (
  CONSTRAINT FK_CONTRACTS_FILIAL_ID 
 FOREIGN KEY (FILIAL_ID) 
 REFERENCES FILIALS (FILIAL_ID),
  CONSTRAINT FK_CONTRACTS_ABONENT_ID 
 FOREIGN KEY (ABONENT_ID) 
 REFERENCES ABONENTS (ABONENT_ID),
  CONSTRAINT FK_CONTRACTS_OPERATOR_ID 
 FOREIGN KEY (OPERATOR_ID) 
 REFERENCES OPERATORS (OPERATOR_ID),
  CONSTRAINT FK_CONTRACTS_TARIFF_ID 
 FOREIGN KEY (TARIFF_ID) 
 REFERENCES TARIFFS (TARIFF_ID));
--#end if

--#if not ConstraintExists("FK_CONTRACTS_DOP_STATUS")
ALTER TABLE CONTRACTS ADD 
  CONSTRAINT FK_CONTRACTS_DOP_STATUS
 FOREIGN KEY (DOP_STATUS)
 REFERENCES CONTRACT_DOP_STATUSES (DOP_STATUS_ID);
--#end if

--#if not ConstraintExists("FK_CONTRACTS_PHONE_NUMBER_TYPE")
ALTER TABLE CONTRACTS ADD CONSTRAINT FK_CONTRACTS_PHONE_NUMBER_TYPE
  FOREIGN KEY (PHONE_NUMBER_TYPE) REFERENCES PHONE_NUMBER_TYPES;
--#end if

--#if not ConstraintExists("FK_CONTRACTS_SERVICE_ID")
ALTER TABLE CONTRACTS ADD CONSTRAINT FK_CONTRACTS_SERVICE_ID
  FOREIGN KEY (SERVICE_ID) REFERENCES SERVICES;
--#end if
  
--#if not ColumnExists("CONTRACTS.CONNECT_LIMIT") then
ALTER TABLE CONTRACTS ADD CONNECT_LIMIT NUMBER(12,2);
--#end if

--#if GetColumnComment("CONTRACTS.CONNECT_LIMIT") <> "����� ���������� ���������" then
COMMENT ON COLUMN CONTRACTS.CONNECT_LIMIT IS '����� ���������� ���������';
--#end if
  
--#if (not ColumnExists("CONTRACTS.DATE_LAST_SET_PASS")) AND IsClient("GSM_CORP") then
ALTER TABLE CONTRACTS ADD DATE_LAST_SET_PASS DATE;
--#end if

--#if (GetColumnComment("CONTRACTS.DATE_LAST_SET_PASS") <> "���� ��������� ��������� ������") AND IsClient("GSM_CORP") then
COMMENT ON COLUMN CONTRACTS.DATE_LAST_SET_PASS IS '���� ��������� ��������� ������';
--#end if
  
--#if (not ColumnExists("CONTRACTS.COUNT_SET_PASS_BY_DAY")) AND IsClient("GSM_CORP") then
ALTER TABLE CONTRACTS ADD COUNT_SET_PASS_BY_DAY INTEGER;
--#end if

--#if (GetColumnComment("CONTRACTS.COUNT_SET_PASS_BY_DAY") <> "���-�� ������� ��������� ������") AND IsClient("GSM_CORP") then
COMMENT ON COLUMN CONTRACTS.COUNT_SET_PASS_BY_DAY IS '���-�� ������� ��������� ������';
--#end if
  
--#if not ColumnExists("CONTRACTS.HAND_BLOCK") then
ALTER TABLE CONTRACTS ADD HAND_BLOCK NUMBER DEFAULT 0;
--#end if

--#if GetColumnComment("CONTRACTS.HAND_BLOCK") <> "������� ������ ���������� (0-����, 1-������)" then
COMMENT ON COLUMN CONTRACTS.HAND_BLOCK IS '������� ������ ���������� (0-����, 1-������)';
--#end if

--#if not ColumnExists("CONTRACTS.HAND_BLOCK_DATE_END") then
ALTER TABLE CONTRACTS ADD HAND_BLOCK_DATE_END DATE;
--#end if

--#if GetColumnComment("CONTRACTS.HAND_BLOCK_DATE_END") <> "���� ��������� ������ ����������" then
COMMENT ON COLUMN CONTRACTS.HAND_BLOCK_DATE_END IS '���� ��������� ������ ����������';
--#end if

--#if not ColumnExists("CONTRACTS.IS_CREDIT_CONTRACT") then
ALTER TABLE CONTRACTS ADD IS_CREDIT_CONTRACT NUMBER(1, 0);
--#end if

--#if GetColumnComment("CONTRACTS.IS_CREDIT_CONTRACT") <> "��� ������ 1-������, 0 - �����, ������ - �����" then
COMMENT ON COLUMN CONTRACTS.IS_CREDIT_CONTRACT IS '��� ������ 1-������, 0 - �����, ������ - �����';
--#end if

--#if not ColumnExists("CONTRACTS.COMMENTS") then
ALTER TABLE CONTRACTS ADD COMMENTS VARCHAR2(300 CHAR);
--#end if

--#if GetColumnComment("CONTRACTS.COMMENTS") <> "���������� � ��������" then
COMMENT ON COLUMN CONTRACTS.COMMENTS IS '���������� � ��������';
--#end if

--#if not ColumnExists("CONTRACTS.SEND_ACTIV") then
ALTER TABLE CONTRACTS ADD SEND_ACTIV NUMBER(1);
--#end if

--#if GetColumnComment("CONTRACTS.SEND_ACTIV") <> "������� ��� �����������(1-��, ������-���)" then
COMMENT ON COLUMN CONTRACTS.SEND_ACTIV IS '������� ��� �����������(1-��, ������-���)';
--#end if

--#if not ColumnExists("CONTRACTS.CURR_TARIFF_ID") then
ALTER TABLE CONTRACTS ADD CURR_TARIFF_ID INTEGER;
--#end if

--#if GetColumnComment("CONTRACTS.CURR_TARIFF_ID") <> "��� �������� ��������� �����" then
COMMENT ON COLUMN CONTRACTS.CURR_TARIFF_ID IS '��� �������� ��������� �����';
--#end if

--#if not ColumnExists("CONTRACTS.DOP_STATUS") then
ALTER TABLE CONTRACTS ADD DOP_STATUS NUMBER;
--#end if

--#if GetColumnComment("CONTRACTS.DOP_STATUS") <> "�������������� ������" then
COMMENT ON COLUMN CONTRACTS.DOP_STATUS IS '�������������� ������';
--#end if

--#if not ColumnExists("CONTRACTS.BALANCE_NOTICE_HAND_BLOCK") then
ALTER TABLE CONTRACTS ADD BALANCE_NOTICE_HAND_BLOCK INTEGER;
--#end if

--#if GetColumnComment("CONTRACTS.BALANCE_NOTICE_HAND_BLOCK") <> "���� ��������� ��������� ������" then
COMMENT ON COLUMN CONTRACTS.BALANCE_NOTICE_HAND_BLOCK IS '����� �������������� ��� ������ ����������';
--#end if

--#if not ColumnExists("CONTRACTS.BALANCE_BLOCK_HAND_BLOCK") then
ALTER TABLE CONTRACTS ADD BALANCE_BLOCK_HAND_BLOCK INTEGER;
--#end if

--#if GetColumnComment("CONTRACTS.BALANCE_BLOCK_HAND_BLOCK") <> "����� ���������� ��� ������ ����������" then
COMMENT ON COLUMN CONTRACTS.BALANCE_BLOCK_HAND_BLOCK IS '����� ���������� ��� ������ ����������';
--#end if

--#if not ColumnExists("CONTRACTS.ABON_TP_DISCOUNT") then
-- ������ ������
ALTER TABLE CONTRACTS ADD ABON_TP_DISCOUNT INTEGER;
--#end if

--#if GetColumnComment("CONTRACTS.ABON_TP_DISCOUNT ") <> "������ ���� �����, %." then
COMMENT ON COLUMN CONTRACTS.ABON_TP_DISCOUNT IS '������ ���� �����, %.';
--#end if

--#if not ColumnExists("CONTRACTS.INSTALLMENT_PAYMENT_DATE") then
-- ����� ���������
ALTER TABLE CONTRACTS ADD INSTALLMENT_PAYMENT_DATE DATE;
--#end if

--#if GetColumnComment("CONTRACTS.INSTALLMENT_PAYMENT_DATE") <> "���� ������ ���������" then
COMMENT ON COLUMN CONTRACTS.INSTALLMENT_PAYMENT_DATE IS '���� ������ ���������';
--#end if

--#if not ColumnExists("CONTRACTS.INSTALLMENT_PAYMENT_SUM") then
ALTER TABLE CONTRACTS ADD INSTALLMENT_PAYMENT_SUM NUMBER(15, 4);
--#end if

--#if GetColumnComment("CONTRACTS.INSTALLMENT_PAYMENT_SUM") <> "����� ���������, �." then
COMMENT ON COLUMN CONTRACTS.INSTALLMENT_PAYMENT_SUM IS '����� ���������, �.';
--#end if

--#if not ColumnExists("CONTRACTS.INSTALLMENT_PAYMENT_MONTHS") then
ALTER TABLE CONTRACTS ADD INSTALLMENT_PAYMENT_MONTHS INTEGER;
--#end if

--#if GetColumnComment("CONTRACTS.INSTALLMENT_PAYMENT_MONTHS") <> "����� ���������, ������" then
COMMENT ON COLUMN CONTRACTS.INSTALLMENT_PAYMENT_MONTHS IS '����� ���������, ������';
--#end if

--#if not ColumnExists("CONTRACTS.MN_ROAMING") then
ALTER TABLE CONTRACTS ADD MN_ROAMING INTEGER;
--#end if


--#if GetColumnComment("CONTRACTS.MN_ROAMING") <> "���������� �� ��������" then
COMMENT ON COLUMN CONTRACTS.MN_ROAMING IS '���������� �� ��������';
--#end if

--GRANT SELECT ON CONTRACTS TO WWW_DEALEadvanced repaymentR;

--#if not ColumnExists("CONTRACTS.DEALER_KOD") then
-- ������
ALTER TABLE CONTRACTS ADD DEALER_KOD INTEGER;
--#end if

--#if GetColumnComment("CONTRACTS.DEALER_KOD") <> "��� ������" then
COMMENT ON COLUMN CONTRACTS.DEALER_KOD IS '��� ������';
--#end if

--#if not ColumnExists("CONTRACTS.INSTALLMENT_ADVANCED_REPAYMENT") then
ALTER TABLE CONTRACTS ADD INSTALLMENT_ADVANCED_REPAYMENT DATE;
--#end if

--#if GetColumnComment("CONTRACTS.INSTALLMENT_ADVANCED_REPAYMENT") <> "���� ���������� ���������" then
COMMENT ON COLUMN CONTRACTS.INSTALLMENT_ADVANCED_REPAYMENT IS '���� ���������� ���������';
--#end if
	
--#if not ColumnExists("CONTRACTS.GROUP_ID") then
--������
ALTER TABLE CONTRACTS ADD GROUP_ID INTEGER;
--#end if

--#if GetColumnComment("CONTRACTS.GROUP_ID") <> "������" then
COMMENT ON COLUMN CONTRACTS.GROUP_ID IS '������';
--#end if

--#if not ColumnExists("CONTRACTS.GROUP_ID") then
--���� ��� �������� �������������� ������ ����� �� ����.
ALTER TABLE CONTRACTS ADD OPTION_GROUP_ID INTEGER;
COMMENT ON COLUMN CONTRACTS.OPTION_GROUP_ID IS '������ �������� ����� ';
ALTER TABLE CONTRACTS ADD (
  CONSTRAINT FK_CONTRACTS_OPTION_GROUP_ID
 FOREIGN KEY (OPTION_GROUP_ID) 
 REFERENCES TARIFF_OPTION_GROUP(OPTION_GROUP_ID)); 
--#end if

--#if not ColumnExists("CONTRACTS.paramdisable_sms") then
-- Add/modify columns 
alter table CONTRACTS add paramdisable_sms varchar2(50);
-- Add comments to the columns 
comment on column CONTRACTS.paramdisable_sms
  is '�������� ��� ����� ������� �������� ��� �����������';
--#end if  


 GRANT UPDATE(DOP_STATUS) ON CONTRACTS TO CORP_MOBILE_ROLE_RO;
	
--#if not ColumnExists("CONTRACTS.ABONENT_TARIFF_OPTION") then
--������
ALTER TABLE CONTRACTS ADD ABONENT_TARIFF_OPTION varchar2(100 char);
--#end if

--#if GetColumnComment("CONTRACTS.ABONENT_TARIFF_OPTION") <> "������" then
COMMENT ON COLUMN CONTRACTS.ABONENT_TARIFF_OPTION IS '�������� ����� ��������';
--#end if

--#if not IndexExists("I_CONTRACTS_GROUP_ID") then
CREATE INDEX I_CONTRACTS_GROUP_ID ON CONTRACTS (GROUP_ID);
-- #end if

--#if not ObjectExists("FK_CONTRACTS_GROUP_ID") then
ALTER TABLE CONTRACTS ADD (
  CONSTRAINT FK_CONTRACTS_GROUP_ID 
  FOREIGN KEY (GROUP_ID) 
  REFERENCES CONTRACT_GROUPS(GROUP_ID)
  ENABLE VALIDATE
  );  
-- #end if 




-- v1 - 23.10.2014 - ������� ����������

ALTER TABLE  CONTRACTS   ADD  (first_activated  NUMBER(1)  DEFAULT  0);
COMMENT ON COLUMN CONTRACTS.first_activated  IS '������� ����, ��� ����� ����������� ������� ���(0- ������ ���������; 1 - ����� ��� �����������)';

ALTER TABLE  CONTRACTS  ADD  (first_activated_date  DATE  DEFAULT  NULL);
COMMENT ON COLUMN CONTRACTS.first_activated_date  IS '���� ������ ���������';

CREATE INDEX  i_first_activated   ON  CONTRACTS  (first_activated);

UPDATE  contracts  SET  first_activated_date = sysdate, first_activated = 1;
COMMIT;

ALTER TABLE CONTRACTS ADD DAILY_ABON_BANNED INTEGER;

COMMENT ON COLUMN CONTRACTS.DAILY_ABON_BANNED IS '������ ���������� ���� �����';