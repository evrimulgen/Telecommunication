CREATE OR REPLACE FUNCTION LOAD_NEW_CONTRACTS_BY_UTL(pContract_date date default sysdate, load_result_K7 out clob, load_result_TELETIE out clob, arm_contract varchar2 default null) RETURN VARCHAR2 IS
--
-- Version = 15
--
--v15 05.02.2016 - ������� - ������� ������ �������� ����������.
--v14 13.01.2016 - ������� - ������� ���������� ������ � ���������� ������� �� CONTRACT_ID 
--v13 30.11.2014 - �������. - ������� ��� ����� ������ �������� �� � �������� �� �������������� �����.
--v12. 27.11.2015 - ������� - ������� ��������� ����� "���������" ������ � ���� ������
--v11. 18.11.2015 - ������� - ������� NVL ��� ���������� ���������� �������.
--v.9.12.11.2015 - ������� - ������� ������
--v.8.10.11.2015 - ������� - ������ ���������� ����� ���������� ������� �� ������ http://redmine.tarifer.ru/issues/3637
--v.7.03.10.2015 - ������� - ����� �������� ���� AUTO_LOAD_CONTRACTS_LOG
--v.6.02.10.2015 - ������ - ������� ������� ��������� ��� ��������� � ���� ������� ���� ��� �����
--v.5.23.03.2015 - ������� - ������ ���������� ������ ��� �������� ����������� ���������� ��� �������
--v.4.12.03.2015 - ������� - ����� ���������� � �������, � ������� TARIFF_CODE_CRM  is null
--v.3.12.03.2015 - ������� - ������� ������� ������� AUTO_LOAD_CONTRACTS_LOG, ���� ��� ���������� ���������  
--v.2.11.03.2015 - ������� - ������� ������� �������������� ������ �� mnp ������
--v.1.04.03.2015 - ������� - ������ ������� �������� ���������� � ��������.
--
  ITOG BLOB;
  URL VARCHAR2(500 CHAR);
  ERROR_TEXT VARCHAR2 (1000);
  lCount Integer;
  lLine Varchar2(1000);
  vIsCollector Integer;
  OK_MESSAGE CONSTANT VARCHAR2(3) := 'OK!';
  cRassochkaValue CONSTANT VARCHAR2(20) := '���������';
  pvIsCollector Integer;
  pITOG VARCHAR2 (1000);


 function ADD_NEW_CONTRACTS (Line varchar2, pIsCollector in out Integer) RETURN VARCHAR2
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  --���������� ���� �� ������� ������ �������� �� ��������� �������
  cDayChangeDopStatus CONSTANT INTEGER := 7;
  
  cDialerCodePos CONSTANT INTEGER := 2;
  cDialerNamePos CONSTANT INTEGER := 3;
  PhoneNumberStrPos CONSTANT INTEGER := 4;
  mnpNumberStrPos CONSTANT INTEGER := 5;
  
  isCorporateStrPos CONSTANT INTEGER := 15;
  
  tarCrmIdOldPos CONSTANT INTEGER := 6;
  tarCrmIdNewPos CONSTANT INTEGER := 7;
  min_tariff_START_BALANCE CONSTANT TARIFFS.START_BALANCE%TYPE := -1;
  
    
  cSurnameNewPos CONSTANT INTEGER := 18;
  cNameNewPos CONSTANT INTEGER := 19;
  cPatronymicNewPos CONSTANT INTEGER := 20;
  
  cSurnameOldPos CONSTANT INTEGER := 14;
  cNameOldPos CONSTANT INTEGER := 15;
  cPatronymicOldPos CONSTANT INTEGER := 16;
  
  cPromisedSumPos CONSTANT INTEGER := 17;
  
  cContractDateNewPos CONSTANT INTEGER := 10;
  cContractDateOldPos CONSTANT INTEGER := 9;
  
  cRassochkaNewPos CONSTANT INTEGER := 13;
  cInstPaymentSumNewPos CONSTANT INTEGER := 12;
  cInstPaymentMonthsNewPos CONSTANT INTEGER := 14;
  
  cRassochkaOldPos CONSTANT INTEGER := 12;
  cInstPaymentSumOldPos CONSTANT INTEGER := 11;
  cInstPaymentMonthsOldPos CONSTANT INTEGER := 13;
  
  
  cReceivedSumNewPos CONSTANT INTEGER := 9;
  cReceivedSumOldPos CONSTANT INTEGER := 8;
  
  
  cEnterSumPos  CONSTANT INTEGER := 16;
  
  cContractDopStatus  CONSTANT INTEGER := 21;

  cAbonentID CONSTANT ABONENTS.STREET_NAME%TYPE := 0;
  vDialerCode DEALERS.DEALER_KOD%TYPE;-- ��� �������
  vPhoneNumber CONTRACTS.PHONE_NUMBER_FEDERAL%TYPE;-- ����������� ����� ��������
  mnpNumberStr CONTRACTS.PHONE_NUMBER_FEDERAL%TYPE;-- MNP �����
  vCONTRACT_DATE  CONTRACTS.CONTRACT_DATE%TYPE; --���� ���������� ���������
  vCONTRACT_ID  CONTRACTS.CONTRACT_ID%TYPE; --���� ���������� ���������
  
  vTARIFF_ID TARIFFS.TARIFF_ID%TYPE;
  vTariffOldID  TARIFFS.TARIFF_ID%TYPE;
  vSTART_BALANCE TARIFFS.START_BALANCE%TYPE;
  vTARIFF_CODE_CRM TARIFFS.TARIFF_CODE_CRM%TYPE; --����� crm_id
  vOPERATOR_ID TARIFFS.OPERATOR_ID%TYPE;
  vPHONE_NUMBER_TYPE TARIFFS.PHONE_NUMBER_TYPE%TYPE;
  
  vABONENT_ID ABONENTS.ABONENT_ID%TYPE;
  
  vFILIAL_ID FILIALS.FILIAL_ID%TYPE;
  
  
  ABONENTS_TABLE ABONENTS%ROWTYPE;
  
  PROMISED_PAYMENTS_TABLE PROMISED_PAYMENTS%ROWTYPE;
  MNP_REMOVE_TABLE  MNP_REMOVE%ROWTYPE;
  CONTRACTS_TABLE  CONTRACTS%ROWTYPE;
  
  vDialerName DEALERS.DEALER_NAME%TYPE;
  
  --vSummTemp varchar2(10);
  vTempCount Integer;
  
  
  USE_NEW_FIELDS boolean; --���������� ����� ����
  LOAD_FIO boolean; -- ��������� ���, ���� ������ ��������
  ErrMessage  varchar2(32000);
  
  MNPline  varchar2(1000);
  
  -- �������� N-��� �� ����� ����� �� ������ (��� �����) ������ Str.

  FUNCTION Extract_Word(
       vList      IN     VARCHAR2,
       nItemNumber    IN     NUMBER,
       vListItemDelimiter  IN     VARCHAR2 DEFAULT ';'
      ) RETURN VARCHAR2
    IS
    nItemPosition  NUMBER;
    nItemLength  NUMBER;
  BEGIN
    nItemPosition := INSTR(vListItemDelimiter||vList,
             vListItemDelimiter,1,nItemNumber);

    nItemLength := INSTR(vList||vListItemDelimiter, vListItemDelimiter,
           1,nItemNumber) - nItemPosition;
    RETURN trim(SUBSTR(vList, nItemPosition, nItemLength));
  END;
  
  function ADD_MNP_CONTRACT(pline varchar2, ppIsCollector in out integer) RETURN VARCHAR2
  IS
  v_line varchar2(32000);
  mnp varchar2(11);
  begin
    v_line := pline;
    mnp := Extract_Word(v_line, mnpNumberStrPos); 
    if nvl(mnp, 'a') <> 'a' then
      
      v_line := REPLACE(v_line, mnp, '');
      v_line := REPLACE(v_line, Extract_Word(v_line, PhoneNumberStrPos), mnp); 
      Return 'MNP ����� '||ADD_NEW_CONTRACTS(v_line, ppIsCollector);
    else
      Return ' ';
    end if;
  end;
  
  --��������� ����� ���������� ������� � �����, ������� ���� ��� ��������� ��������
  function GET_RECEIVED_SUM(pUSE_NEW_FIELDS boolean, pLine1 varchar2, pSTART_BALANCE TARIFFS.START_BALANCE%TYPE) Return CONTRACTS.RECEIVED_SUM%TYPE as
    vSummTemp varchar2(10);
    vRes CONTRACTS.RECEIVED_SUM%TYPE;
  begin
    vRes := 0;
    if pUSE_NEW_FIELDS then
       vSummTemp := Extract_Word(pline1, cReceivedSumNewPos);
    else
       vSummTemp := Extract_Word(pline1, cReceivedSumOldPos);
    end if;
    
    if nvl(vSummTemp, 'a') <> 'a'
       AND nvl(substr(vSummTemp, 3, 1), 'a') <> nvl(substr(vSummTemp, 6, 1), 'a')
       AND nvl(substr(vSummTemp, 3, 1), 'a') <> '.' THEN
      
      vRes := to_number(vSummTemp);
    end if;
    
    -- ���� ��������� �����
    vSummTemp := Extract_Word(pline1, cEnterSumPos);
    
    if nvl(vSummTemp, 'a') <> 'a' and vSummTemp <> '0' then
      vRes := nvl(vRes, 0) + to_number(vSummTemp);  
    end if;
    
    if pSTART_BALANCE <> min_tariff_START_BALANCE then
      vRes := pSTART_BALANCE;   
    end if;
    
    Return vRes;
    
  end;
  
begin
  begin
    USE_NEW_FIELDS := MS_CONSTANTS.GET_CONSTANT_VALUE('LOAD_NEW_WHEN_LOAD_CONTRACTS') = '1';
    LOAD_FIO := MS_CONSTANTS.GET_CONSTANT_VALUE('LOAD_FIO_WHEN_LOAD_CONTRACTS') = '1';
    select nvl(min(filial_id), -1) into vFILIAL_ID from filials;
   
    if vFILIAL_ID = -1 then
     ErrMessage := '������! �� ������� �� ������ �������';
     RAISE_APPLICATION_ERROR(-20000, ErrMessage);
    end if;
    MNPline := null;
    -- ��������� �����������
    ErrMessage := null;
      
    if length(trim(line)) > 0 then
      --������ ���������� ������
      -- �������� ��� �������
      vDialerCode := to_number(Extract_Word(line, cDialerCodePos));
      if nvl(vDialerCode, -1) = -1 then
        ErrMessage := '������! ������������ "��� �������" '||line;
        Return ErrMessage;   
      end if;
        
        
      --�������� MNP �����, ���� ����
      mnpNumberStr := substr(Extract_Word(line, mnpNumberStrPos), -10);
        
      if nvl(mnpNumberStr, '0') <> '0' then
        MNPline := line;
      end if;
        
        
      if USE_NEW_FIELDS then
        vTARIFF_CODE_CRM := Extract_Word(line, tarCrmIdNewPos);
      else
        vTARIFF_CODE_CRM := Extract_Word(line, tarCrmIdOldPos);
      end if;
        
      --�������� ID ��������� ����� � ��������� ������
      begin
        select TARIFF_ID, START_BALANCE, OPERATOR_ID, PHONE_NUMBER_TYPE/*, CONTRACT_DATE*/ into  
               vTARIFF_ID, vSTART_BALANCE, vOPERATOR_ID, vPHONE_NUMBER_TYPE/*, vCONTRACT_DATE */
        from tariffs tf where tf.TARIFF_CODE_CRM= vTARIFF_CODE_CRM 
              and rownum <=1;
      exception
        when NO_DATA_FOUND then
        begin
          if nvl(vTARIFF_CODE_CRM, '-1') = '-1' then
            ErrMessage := null;
          else            
            ErrMessage := '������! ����� �� ������!'||line;
          end if;
          Return ErrMessage;
        end;
      end;
        
      --����� �������� ���� ���� �������
      --�������������� ��������� ������
      if nvl(vSTART_BALANCE, 0) = 0 then
        vSTART_BALANCE := min_tariff_START_BALANCE; 
      end if;
        
      --�������� ����� ��������
      vPhoneNumber := substr(Extract_Word(line, PhoneNumberStrPos), -10);
      
      --���������� ������������� ���� ��� ���
      --���� pIsCollector = 1 ��������� ��� ����� ��� 100% ���������
      if pIsCollector = 0 then
        pIsCollector := GET_IS_COLLECTOR_BY_PHONE(vPhoneNumber);
      end if;
     --�������� �� ������������� ���������
      begin
        SELECT  c.contract_date, c.tariff_id, C.CONTRACT_ID
        INTO vContract_date, vTariffOldID, vCONTRACT_ID
        FROM CONTRACTS C  
        WHERE (C.PHONE_NUMBER_FEDERAL = vPhoneNumber  or C.PHONE_NUMBER_CITY = substr(vPhoneNumber,-7)) 
          AND NOT EXISTS
                  (SELECT 1
                     FROM CONTRACT_CANCELS
                     WHERE CONTRACT_CANCELS.CONTRACT_ID = C.CONTRACT_ID);
      exception
        when NO_DATA_FOUND then
        begin
          --������ ���, ������ � �������� �� �������
          begin  
            --��������� ���������� �� ��������
            if USE_NEW_FIELDS then
                
              if Extract_Word(line, isCorporateStrPos) = '1' then
                ABONENTS_TABLE.DESCRIPTION := '���� � ����������';
              else
                ABONENTS_TABLE.DESCRIPTION := null;
              end if;
                
              if LOAD_FIO then
                ABONENTS_TABLE.SURNAME := nvl(Extract_Word(line, cSurnameNewPos), vPhoneNumber);  
                ABONENTS_TABLE.NAME := nvl(Extract_Word(line, cNameNewPos), vPhoneNumber);
                ABONENTS_TABLE.PATRONYMIC := nvl(Extract_Word(line, cPatronymicNewPos), vPhoneNumber);
              end if;
            else
              if LOAD_FIO then
                ABONENTS_TABLE.SURNAME := nvl(Extract_Word(line, cSurnameOldPos), vPhoneNumber);  
                ABONENTS_TABLE.NAME := nvl(Extract_Word(line, cNameOldPos), vPhoneNumber);
                ABONENTS_TABLE.PATRONYMIC := nvl(Extract_Word(line, cPatronymicOldPos), vPhoneNumber);
              end if;
            end if;
              
            if not LOAD_FIO then
              ABONENTS_TABLE.SURNAME := vPhoneNumber;  
              ABONENTS_TABLE.NAME := vPhoneNumber;
              ABONENTS_TABLE.PATRONYMIC := vPhoneNumber;
            end if;
                
            INSERT INTO ABONENTS 
                      (ABONENT_ID, SURNAME, NAME, PATRONYMIC, DESCRIPTION)
                  VALUES(cAbonentID, ABONENTS_TABLE.SURNAME, ABONENTS_TABLE.NAME, ABONENTS_TABLE.PATRONYMIC, ABONENTS_TABLE.DESCRIPTION)
                  RETURNING ABONENT_ID INTO vABONENT_ID
                  ;
            --����� ���������� ���������� �� ��������
              
              
            if USE_NEW_FIELDS then
              --��������� ������
              if nvl(Extract_Word(line, cPromisedSumPos), '0') <> '0' then
                PROMISED_PAYMENTS_TABLE.PHONE_NUMBER := vPhoneNumber;
                PROMISED_PAYMENTS_TABLE.PAYMENT_DATE := sysdate;
                PROMISED_PAYMENTS_TABLE.PROMISED_DATE := sysdate + 2;
                PROMISED_PAYMENTS_TABLE.PROMISED_SUM :=  to_number(Extract_Word(line, cPromisedSumPos));
                PROMISED_PAYMENTS_TABLE.PROMISED_DATE_END := trunc(sysdate + 2);
                  
                INSERT INTO PROMISED_PAYMENTS (
                            PHONE_NUMBER,
                            PAYMENT_DATE,
                            PROMISED_DATE,
                            PROMISED_SUM,
                            PROMISED_DATE_END)
                VALUES
                          (PROMISED_PAYMENTS_TABLE.PHONE_NUMBER,
                           PROMISED_PAYMENTS_TABLE.PAYMENT_DATE,
                           PROMISED_PAYMENTS_TABLE.PROMISED_DATE,
                           PROMISED_PAYMENTS_TABLE.PROMISED_SUM,
                           PROMISED_PAYMENTS_TABLE.PROMISED_DATE_END);    
              end if;
              --����� ���������� �������
                
              --����� MNP
              if nvl(mnpNumberStr, '0') <> '0' then
                --��������� ���� �� ������ ����� � ������ MNP �������
                begin
                  SELECT PHONE_NUMBER, TEMP_PHONE_NUMBER, DATE_ACTIVATE,
                             USER_CREATED, DATE_CREATED into
                             MNP_REMOVE_TABLE.PHONE_NUMBER,
                             MNP_REMOVE_TABLE.TEMP_PHONE_NUMBER,
                             MNP_REMOVE_TABLE.DATE_ACTIVATE,
                             MNP_REMOVE_TABLE.USER_CREATED,
                             MNP_REMOVE_TABLE.DATE_CREATED
                              FROM MNP_REMOVE 
                             WHERE PHONE_NUMBER = mnpNumberStr;
                  --���� ���� ����� MNP, �� ��������� ��� � ������� � ������� ������
                  --����� ����� ���� ������ ����, ��� ��� ���� PHONE_NUMBER ���������
                    
                  INSERT INTO MNP_REMOVE_HISTORY (PHONE_NUMBER, TEMP_PHONE_NUMBER,
                             DATE_ACTIVATE, USER_CREATED, DATE_CREATED, DATE_INSERTED)
                             VALUES (MNP_REMOVE_TABLE.PHONE_NUMBER, 
                                    MNP_REMOVE_TABLE.TEMP_PHONE_NUMBER, 
                                    MNP_REMOVE_TABLE.DATE_ACTIVATE,
                                    MNP_REMOVE_TABLE.USER_CREATED,
                                    MNP_REMOVE_TABLE.DATE_CREATED,
                                    sysdate);
                                      
                  --������� ������
                   DELETE FROM MNP_REMOVE WHERE PHONE_NUMBER = MNP_REMOVE_TABLE.PHONE_NUMBER;   
                exception
                  when NO_DATA_FOUND then
                    NULL;
                end;
                --��������� ������ � ������� MNP �������              
                INSERT INTO MNP_REMOVE (PHONE_NUMBER, TEMP_PHONE_NUMBER)
                    VALUES (mnpNumberStr, vPhoneNumber);
              end if; --�����-����� MNP
            end if; --�����if USE_NEW_FIELDS
             
             
            -- ������� ��������
            CONTRACTS_TABLE.CONTRACT_ID := 0;
            CONTRACTS_TABLE.CONTRACT_NUM := to_number(GET_NEXT_CONTRACT_NUMBER);
            CONTRACTS_TABLE.OPERATOR_ID := vOPERATOR_ID;
            CONTRACTS_TABLE.DEALER_KOD := vDialerCode;
            CONTRACTS_TABLE.PHONE_NUMBER_FEDERAL := vPhoneNumber;
              
            if nvl(vPHONE_NUMBER_TYPE, 0) = 1 then
              CONTRACTS_TABLE.PHONE_NUMBER_CITY := substr(vPhoneNumber, 4, 7);  
            end if;
              
            CONTRACTS_TABLE.PHONE_NUMBER_TYPE := vPHONE_NUMBER_TYPE;
            CONTRACTS_TABLE.TARIFF_ID := vTARIFF_ID;
            CONTRACTS_TABLE.ABONENT_ID := vABONENT_ID;
            CONTRACTS_TABLE.FILIAL_ID := vFILIAL_ID;
              
            if USE_NEW_FIELDS then
              CONTRACTS_TABLE.CONTRACT_DATE := to_date(Extract_Word(line, cContractDateNewPos), 'dd.mm.yyyy');

              if Extract_Word(line, cRassochkaNewPos) = cRassochkaValue then
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_DATE := CONTRACTS_TABLE.CONTRACT_DATE; 
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_SUM := to_number(Extract_Word(line, cInstPaymentSumNewPos));
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_MONTHS := to_number(Extract_Word(line, cInstPaymentMonthsNewPos));
              else
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_DATE := null; 
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_SUM := null;
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_MONTHS := null;
              end if; 
            else
              CONTRACTS_TABLE.CONTRACT_DATE := to_date(Extract_Word(line, cContractDateOldPos), 'dd.mm.yyyy');
              if Extract_Word(line, cRassochkaOldPos) = cRassochkaValue then
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_DATE := CONTRACTS_TABLE.CONTRACT_DATE; 
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_SUM := to_number(Extract_Word(line, cInstPaymentSumOldPos));
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_MONTHS := to_number(Extract_Word(line, cInstPaymentMonthsOldPos));
              else
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_DATE := null; 
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_SUM := null;
                CONTRACTS_TABLE.INSTALLMENT_PAYMENT_MONTHS := null;
              end if; 
            end if;
              
            
            CONTRACTS_TABLE.RECEIVED_SUM := GET_RECEIVED_SUM(USE_NEW_FIELDS, line, vSTART_BALANCE); 
            
            CONTRACTS_TABLE.START_BALANCE := nvl(CONTRACTS_TABLE.RECEIVED_SUM, 0) ;
            
            IF arm_contract IS NULL THEN                     
            CONTRACTS_TABLE.DOP_STATUS := NULL;
            ELSE            
            CONTRACTS_TABLE.DOP_STATUS := to_number(Extract_Word(line, cContractDopStatus));
            END IF;
              
            INSERT INTO CONTRACTS
            (CONTRACT_ID, CONTRACT_NUM, CONTRACT_DATE, FILIAL_ID, OPERATOR_ID,
            PHONE_NUMBER_FEDERAL, PHONE_NUMBER_CITY, PHONE_NUMBER_TYPE, TARIFF_ID,
            ABONENT_ID, RECEIVED_SUM,
            START_BALANCE,INSTALLMENT_PAYMENT_DATE,
            INSTALLMENT_PAYMENT_SUM, INSTALLMENT_PAYMENT_MONTHS, DEALER_KOD, DOP_STATUS)
            VALUES
            (CONTRACTS_TABLE.CONTRACT_ID, CONTRACTS_TABLE.CONTRACT_NUM, CONTRACTS_TABLE.CONTRACT_DATE, CONTRACTS_TABLE.FILIAL_ID, 
            CONTRACTS_TABLE.OPERATOR_ID, CONTRACTS_TABLE.PHONE_NUMBER_FEDERAL, CONTRACTS_TABLE.PHONE_NUMBER_CITY, 
            CONTRACTS_TABLE.PHONE_NUMBER_TYPE, CONTRACTS_TABLE.TARIFF_ID,
            CONTRACTS_TABLE.ABONENT_ID, CONTRACTS_TABLE.RECEIVED_SUM,
            CONTRACTS_TABLE.START_BALANCE, CONTRACTS_TABLE.INSTALLMENT_PAYMENT_DATE,
            CONTRACTS_TABLE.INSTALLMENT_PAYMENT_SUM, CONTRACTS_TABLE.INSTALLMENT_PAYMENT_MONTHS, CONTRACTS_TABLE.DEALER_KOD, CONTRACTS_TABLE.DOP_STATUS);
            --����� ��������� ���������  
              
            --���������� ����������� �������
              
            SELECT count(*) cnt into vTempCount FROM DEALERS WHERE dealer_kod = vDialerCode;
              
            vDialerName := Extract_Word(line, cDialerNamePos);
              
            if vTempCount = 0 then
              INSERT INTO DEALERS (dealer_kod, dealer_name) VALUES (vDialerCode, vDialerName);
            else
              UPDATE DEALERS SET dealer_name = vDialerName WHERE dealer_kod = vDialerCode;
            end if; 
              
              
            if GET_ABONENT_BALANCE_NO_AT(vPhoneNumber) < 0 then
              ErrMessage := '� �������� ������������� ������!'||chr(9)||line;
              --Return ErrMessage;
            else
              ErrMessage := OK_MESSAGE||chr(9)||line;  
            end if;
            
            commit;
            --��������� mnp �����
            ErrMessage := ErrMessage || ADD_MNP_CONTRACT(line, pIsCollector);
          
          exception
            when Others then
              ROLLBACK;
              ErrMessage :='Line = '||line||'Error = '||DBMS_UTILITY.FORMAT_ERROR_STACK;
              Return ErrMessage;  
          end;  
        end; --end when NO_DATA_FOUND 
      end;
        
      --�������� ��� �������
      if vContract_date is not null then
        --ErrMessage := '������! �������� � ����� ������� ��� ������� ' || to_char(vContract_date, 'dd.mm.yyyy') || '!' ||chr(9) ||Line;
        if USE_NEW_FIELDS then
          vCONTRACT_DATE := to_date(Extract_Word(line, cContractDateNewPos), 'dd.mm.yyyy');
        else
          vCONTRACT_DATE := to_date(Extract_Word(line, cContractDateOldPos), 'dd.mm.yyyy');
        end if;
        -- � ������ ���� �� ������ ��������, �� ����������  '������, �������� � ����� ������� ��� ������� ...'
        ErrMessage := ACTIVATE_CONTRACT_DOP_STATUS(vPhoneNumber, vCONTRACT_DATE ) ||chr(9) ||Line;
        
        --����������� ����� ���������� ������� �� ������������ ���������
        -- ������ ��� �7!!!!!! 
        if nvl(pIsCollector, 0) = 0 then
          CONTRACTS_TABLE.RECEIVED_SUM := nvl(GET_RECEIVED_SUM(USE_NEW_FIELDS, Line, min_tariff_START_BALANCE), 0);
          
          if CONTRACTS_TABLE.RECEIVED_SUM <> 0 then
          
            --��� ���������� ������� � SH_CONTRACTS
            update CONTRACTS set
              RECEIVED_SUM = NVL(RECEIVED_SUM, 0) + CONTRACTS_TABLE.RECEIVED_SUM,
              START_BALANCE = NVL(START_BALANCE, 0) +  CONTRACTS_TABLE.RECEIVED_SUM  
            WHERE
              CONTRACT_ID = vCONTRACT_ID
              and (PHONE_NUMBER_FEDERAL = vPhoneNumber  or PHONE_NUMBER_CITY = substr(vPhoneNumber,-7));
            
            ErrMessage := ErrMessage||' ��������� ����� ���������� �������!';
            commit;
          end if;
        
        --���� ����� RECEIVED_SUM   
        end if;
        
        
        --���� �������� �� ������, ������� ���� �� � ���� ���� ����� ������� � ������������� ���������� ��� � �������������� ����������
        --�� ��������� cDayChangeDopStatus ����
        
        select count(*) into vTempCount
        from  
          LOG_CHANGE_CONTRACT_DOP_STATUS
        where
         trunc(date_created) >= trunc(sysdate - cDayChangeDopStatus)
         and PHONE_NUMBER = vPhoneNumber;
        
        --���� ����� ������, �� ������ �������� ���� 
        if vTempCount > 0 then
          
          if nvl(vTariffOldID, -1) <> nvl(vTARIFF_ID, -1) then
            update CONTRACTS set
              TARIFF_ID = nvl(vTARIFF_ID, TARIFF_ID)  
            WHERE CONTRACT_ID = vCONTRACT_ID
              and (PHONE_NUMBER_FEDERAL = vPhoneNumber  or PHONE_NUMBER_CITY = substr(vPhoneNumber,-7));
              
            INSERT INTO LOG_CHAHGE_TARIFF_ID_AL_CONTR (PHONE_NUMBER, TARIFF_ID_OLD, TARIFF_ID_NEW)
              VALUES (vPhoneNumber, vTariffOldID, vTARIFF_ID);
            COMMIT;
              ErrMessage := ErrMessage||' ������� �������� ����';
          else
            ErrMessage := ErrMessage||'';  
          end if;
          
          ErrMessage := ' �������� � ����� ������� ��� ������� '||to_char(vCONTRACT_DATE, 'dd.mm.yyyy')||'! '||ErrMessage||chr(9) ||Line; 
        end if;
        
        --��������� mnp �����
        ErrMessage := ErrMessage || ADD_MNP_CONTRACT(line, pIsCollector);
        
        Return ErrMessage;
      end if; 
    end if;
  end;
  COMMIT;  
  Return ErrMessage;
  
end;

function create_conn (URLs varchar2, ConnectErrorText out varchar2) Return BLOB 
is
 --err        varchar2(1000);
 req        utl_http.req;--������
 resp       utl_http.resp;--�����  
 raw_buf raw(32767);
 revLine varchar2(1000);
 answer Blob;
 i Integer;
 type loader_table is table of varchar2(1000) INDEX BY binary_integer;
 Tloader           loader_table;--������ ���������� html
 clobLine clob;
begin
  ConnectErrorText := 'OK';
  begin
    utl_http.set_transfer_timeout(MS_PARAMS.GET_PARAM_VALUE('USS_BEELINE_LOADER_TIME_OUT'));--��������� �������� 5 �����. ( ��� ? )
    req:= utl_http.begin_request(urls);
    utl_http.set_body_charset(req,'UTF-8');
    resp := utl_http.get_response(req);
  
  
    if resp.status_code=400 then--���� ������ ������� - ��������, � ������ �������.
      utl_http.read_line(resp, ConnectErrorText);
      UTL_HTTP.END_RESPONSE(resp);
      ConnectErrorText := ConnectErrorText ||' Code:400';
        --return(err||' Code:400');
    end if;
  exception  --��������� �������� ����������, �� ������ ������.
    when others then
      ConnectErrorText := ConnectErrorText||' ���:'||nvl(resp.status_code,0);
      if nvl(resp.status_code,0)>0 then 
       UTL_HTTP.END_RESPONSE(resp);
      end if;
     
      ConnectErrorText := ConnectErrorText||' ConnectErrorText! ���������� �� ���������, ���� �� ������! '||chr(13)||sqlerrm;
  end;--����������� ���������
  
  
  begin
    dbms_lob.createtemporary(answer, true);
    i:=0;
    loop
      utl_http.read_line(resp,revLine);
       -- �������� ���������� ������ � ����      
      raw_buf := utl_raw.cast_to_raw(revLine);
      dbms_lob.append(answer,raw_buf);
      --���������� ������ ������
      if  i > 0 then
        Tloader(i - 1) := revLine;
      end if;
      i := i +1;
    end loop;
  exception
    when others then--� ����� ������ ��������� ����������
      UTL_HTTP.END_RESPONSE(resp);
      if Instr(DBMS_UTILITY.FORMAT_ERROR_STACK, 'ORA-29266: end-of-body reached') = 0 then
        ConnectErrorText := ConnectErrorText || 'SQLERROR= '||DBMS_UTILITY.FORMAT_ERROR_STACK;
      end if;
     
  end;
  
  --load_result := '��������� ��������:<br>';
  load_result_K7 := MS_PARAMS.GET_PARAM_VALUE('MAIL_NEW_CONTRACTS_FIRST_LINE') ;
  load_result_TELETIE := MS_PARAMS.GET_PARAM_VALUE('MAIL_NEW_CONTRACTS_FIRST_LINE');
  
  begin
    if NVL(Tloader.last, -1) >= 0 then
      for i in Tloader.first..Tloader.last loop
        lLine := Tloader(i);
        -- ��������� �� �������� �� ��� ������ �����
        select count(*) ct into lCount from AUTO_LOAD_CONTRACTS_LOG
          where contract_line =  lLine;
        
        -- ���� �� ���������, �� ������������ ������
        if lCount = 0 then
          vIsCollector := 0;
          clobLine := ADD_NEW_CONTRACTS(lLine, vIsCollector)||'<br>';
          --���������� �����, ������� �� � ���
          INSERT INTO AUTO_LOAD_CONTRACTS_LOG (CONTRACT_LINE) VALUES (lLine);
          if vIsCollector = 0 then
            
            if INSTR(UPPER(clobLine),UPPER(cRassochkaValue),1)  > 0 then
              clobLine := '<b>'||cRassochkaValue||'!</b>'||clobLine;
            end if;

            DBMS_LOB.APPEND(load_result_K7, clobLine);
          else
          begin
            if DBMS_LOB.INSTR(clobLine, OK_MESSAGE, 1, 1) = 0 THEN
              DBMS_LOB.APPEND(load_result_TELETIE, clobLine);
            END IF;
          end;
          end if;
        end if;
      end loop;
      COMMIT;
    else
      ConnectErrorText := '��� ���������� ���������� �� '||to_char(pContract_date, 'dd.mm.yyyy');
      /*
      --���� ��� ���������� ����������, �� ������� �������
       select count(*) ct into lCount from AUTO_LOAD_CONTRACTS_LOG;
       if nvl(lCount, 0) > 0 then
        delete from AUTO_LOAD_CONTRACTS_LOG;
        commit;
      end if;
      */  
    end if;
  exception
    when OTHERS then
      ROLLBACK;
      ConnectErrorText := '������: '||SQLERRM;
  end;
  
  RETURN answer;
  
end;
        
BEGIN
if arm_contract is null then
  URL := MS_PARAMS.GET_PARAM_VALUE('GET_NEW_CONTRACTS_URL');
  if URL is not null then
    URL := REPLACE(URL, '%CONTRACT_DATE%', to_char(pContract_date, 'yyyy.mm.dd'));
    ITOG :=  create_conn (URL, ERROR_TEXT);
    
   -- dbms_output.put_line ('ConnectErrorText = '||ERROR_TEXT);
/*
    --vline := trim('1;00005555;����;79689681650;;203;A924BF5F-F99A-4298-A700-D1100A35EB8B; ����������� ������ + �������� 2490;0;03.03.2015;���������;700;;0;0;;');
    --dbms_output.put_line(ADD_NEW_CONTRACTS('1;00005555;����;79654041993;;203;A924BF5F-F99A-4298-A700-D1100A35EB8B; ����������� ������ + �������� 2490;0;03.03.2015;���������;700;;0;0;;', vIsCollector));
--    */
  else
    ITOG := null;  
  end if; 
else
  pvIsCollector := 0;
  pITOG :=  ADD_NEW_CONTRACTS (arm_contract, pvIsCollector);
  ERROR_TEXT := pITOG;
  --ERROR_TEXT := pITOG||arm_contract;
end if;  
 
/*
��������;��� ������;�����;�����;����� MNP;����� id;����� crm_id;�����;����� ��������;���� ���������;���������;����;���������;������ ���������;���� � ����������;��������� �����;��������� ������;�������;���;��������
1;5148;����� ������ �����;79660260077;;375;17807FAA-22A9-4F6B-9CAE-139D52EAAA68; ������� (1300 ���.);0;02.03.2015;���������;0;;0;0;;
1;2663;��������;79037908506;;175;9E8B1BC0-2528-412D-A48D-8CCA64BF1AE0; ������ ���������;0;02.03.2015;���������;0;;0;0;;;�������;����;��������
 */
  Return ERROR_TEXT;

END;
/
