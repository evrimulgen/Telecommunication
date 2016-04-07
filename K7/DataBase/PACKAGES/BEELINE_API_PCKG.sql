CREATE OR REPLACE PACKAGE BEELINE_API_PCKG AS
--
--#Version=61
--v.61 2016.03.14 ��������. ���� ��������� � Collect_account_phone_opts_st. �������� ���������� tag � Zag �� 255 char. ����� ������� case ��� ������� �� if � ELSIF.
--v.60 2016.01.12 ��������. ���� ��������� � ������� LOAD_DETAIL_FROM_API. C����� ����������� � API_GET_UNBILLED_CALLS_LOG ��� �������� parse_res
--v.59 2016.01.12 ��������. ������� ����������� ���������� tag, v_loc, str �� 255 char (������� GET_API_UNBILLED_CALLS_LIST)
--v.57 2015.12.22 ��������. ������� Collect_account_BANS. ������� ����������� ���������� tag, v_loc �� 500 char
--v.57 2015.12.22 ��������. ������� Collect_account_BANS. ������� ����������� ���������� tag, v_loc �� 255 char
--v.56 2015.12.22 ��������. ������� ����������� ���������� tag, v_loc, str �� 255 char (������� GET_API_CTN_INFO_LIST_TABLE)
--v.55 2015.12.16 �������. 1. ��������� ����� � ��������� ����� ACCOUNT_PHONE_OPTIONS: ���������� ��������� �������� �� ���� NULLS FIRST, 
--                            ����� � ������ ����� ������ �������� � ����� � �� �������� ������������.
--                         2. ������ ����������������� �������� ����� �� ������� 
--v.54 2015.12.15 ��������. �������� ����� � ������� ������ � ������� REPLACE_SIM_LOG. ������ �������� ��� �������� ����������
--v.53 2015.09.23 �������. ������� �������� � Collect_account_phone_status, ����������� �� ������� ���� ����� ������� ��������
--v.52 2015.09.23 �������. ��������� ����� ����� ������� ����������� �� ���.
--v.51 31.08.2015 �������. ���� ��������� � Collect_account_phone_status. ������� ������ �� ����������� ����.
--v.50 31.08.2015 ��������. ���� ��������� � Collect_account_phone_opts_st. ������ �� ������� ���������. �������� ������. �� ���������� ����� l_pos � idx
--v.49 31.08.2015 ��������. �������� ������� �������� ���� ����������� (Collect_account_phone_opts_st). ������ ��� � ����������� ��� � ������ ���������� �� ������
--v.48 27.08.2015 ��������, ������. ������� �������� ������� �������� ����� �� ������� � ����������� �� �����
--v.47 26.08.2015 �������. ��������� �������� ��������
--v.46 24.08.2015 �������. ��������� ������ ������� BEELINE_API_PCKG.Collect_account_BANS � ����� ������ � XML ����������
--v.45 04.08.2015 �������. ������� �������� pKOL_DAY � account_phone_payments, �������� ���������� ����, �� ������� ����������� �������
--                        �������� megre ��� ������� � DB_LOADER_PAYMENT_TRANSFERS
--v.44 03.08.2015 �������.�������� ������� �� �������� �������� �� API
--v.43 31.07.2015 �������� ���������� ���������� ��������� ������ �������� � ����� ���� ARCHIVE_PCKG.ADD_REC_API_GET_PAYMENT_LIST(vREC.account_number), �.�. ������ ��������� ������� ���������� ���������� � �� ���� ������ merge
--                                       ����������� ���� � ������� account_phone_payments.
--v.42 22.07.2015 �������. ��������� ��������� ROAMING_PROVIDER_ID �� �������.
--v.41 15.07.2015 �������. ������� ������� mcBalance - ��������� �� REST API ����� ��� � �������, ���������� ��� ��.
--                        ������ ������ ��������� ��� ��������� ������ ��� REST API  
--v.40 13.07.2015 �������. ������� ������ ������� ������ � get_ticket_status
--v.39 09.07.2015 �������. ������� ����� changePP ��� ������ ����� ��������� ����� ����� API
--v.38 18.06.2015 �������. ������� � �������� �� API ���� ROAMING_PROVIDER_ID
--v.37 18.05.2015 �������. ������� ��������� ������� �������� ��� �������� �������� �� ���
--v.36 14.05.2015 ������� ��������� �������� �����(Collect_account_BANS) � �������� (Collect_account_phone_status) ��� ������������� ������
--v.35 23.04.2015 ��������. ������� ��������� ������ -30926 (��������� � merge ��������� �������� �� ���)
--v.34 22.04.2015 �������. �������� ������ ��������� �������� ����� ��� �����������.
--v.33 21.04.2015 �������. ��������� ������ ������� �� ��� �� ���������, ������� ������������ �����.
--v.32 21.04.2015 �������. ��������� ����� �� ��� �� �������� �� ������ ������ �������� ������� � �����.
--v.31 03.04.2015 �������.�������� ������ � LOAD_DETAIL_FROM_API. ������ t.ServiceType in (''G'', ''W'') ������ tab.ServiceType in (''G'', ''W'') 
--v.30 26.03.2015 �������.������� ������� merge � LOAD_DETAIL_FROM_API, ������� ������� when matched then � ������� �������� �� GRPS � WAP
--v.29 02.03.2015 ��������. ���. ������� phone_status, account_phone_status, collect_account_phone_status (��������� �������� HLR), �������� ������� phone_SIM
-- v.28 24.02.2015 ��������. ��������� ������� �������� ������� ��� ����, ������� ��������� GET_SIMList ��-�� ������������
--v.27 17.02.2015 ��������. ��������� ������� ��������� ������ SIM ����� ��� BAN
-- v.25 09.02.2015 ����� ���������� ������ REST ��������� ���� ������. 
-- v.24 06.02.2015 ����� ��������� �������� ������ REST (function rest_info_rests).
-- 02.02.2015 �������.������� ���������� ���������� � LOAD_DETAIL_FROM_API
-- 29.01.2015 ��������. ��������� ����� ���������� ������������ ��������, ����� API  (pUSE_API  = 1) ��� ��� ������� � ������� HOT_BILLING_GET_CALL_TAB
-- 21.  19.01.2015 �������. �� ��������� ����������� ��� ������ ��� �������� �� API �������� UC.serviceName AT_FT_CODE � HOT_BILLING_GET_CALL_TAB
-- 20. 30.12.2014 �������. ����� ���������-�������� � ��������� �������
-- 19. 29.12.2014 �������. ����� ���������-�������� � ��������� �������
-- 18. 29.12.2014 �������. ���������� �������������� ����������� ���� ������� �� ���
-- 17. 18.12.2014 �������. �������� ��������. ������� �������� ������� �������.
-- 16. 15.10.2014 �������. ����������� �������� ��������. ������ �����.
-- 15. 15.10.2014 �������. ����������� �������� ��������.
-- 14. 15.10.2014 �������. ������� ����� ������ � ��������. ����� �� ������ ��������-������.
-- 13. 10.10.2014 �������. ������� ���������� ���� �������.
-- 12. 02.10.2014 ������ �. �������� ������� ACCOUNT_PHONE_STATUS. ��������� �������� �������� ���� ��������� ����� �������
--    �� XML � ����������� �����������/���������� ���� LAST_CHANGE_STATUS_DATE ������� DB_LOADER_ACCOUNT_PHONES ���������� ���������
-- 11. 25.09.2014 �������. ������ �������������� ��� � ������� ������ �� ������� �� ������ CONVERT_PCKG
-- 10. 10.09.2014 �������. ��������� ��������� UNLOCK_PHONES. ������ ��������� � ����� �������� ������ ������ ���� �������   
-- 9. 01.10.2013 �����. ������� �������� �������� �� �\� � ������������� �\�.
-- 8. 29.08.14. ������. �������� ��� ��������� � �������� �������.
-- 7. 24.07.14. ������. ������� �������� ���� � ���� ��������������� ���������� ��� �����.
-- 6. 24.07.14. ������. �������� ���������� ����� ��� �����������/���������� �����
-- 5 21.07.14 ���������. ������� ������� TURN_TARIFF_OPTION, ������� ���������� ��� ��������� �������� ����� ��� ������.
-- 4.21.07.14 ���������. ����������� ��������
--������ SIM �����
FUNCTION REPLACE_SIM(
  pPHONE_NUMBER IN VARCHAR2,
  pICC         in varchar2
  ) RETURN VARCHAR2;
--���������� ��������.
--pCode - ������� ����������: WIB � ���������� �� �������, STO � ���������� �� �����
FUNCTION LOCK_PHONE(
  pPHONE_NUMBER IN VARCHAR2,
  pMANUAL_BLOCK IN INTEGER DEFAULT 1,
  pCode in varchar2
  ) RETURN VARCHAR2;
--������������� ��������.
FUNCTION UNLOCK_PHONE(
  pPHONE_NUMBER IN VARCHAR2,
  pMANUAL_UNLOCK IN INTEGER DEFAULT 1
  ) RETURN VARCHAR2;
Function account_phone_payments  (
  pAccount_id in number,
  pKOL_DAY in INTEGER DEFAULT 3 
  ) return varchar2;    
--������ ��������
Function phone_status  (
  pPHONE_NUMBER in number
  ) return varchar2;  
--  
function account_phone_status(
  Paccount_id in number
  ) return varchar2;
--  
function account_phone_options(
  Paccount_id in number,
  p_STREAM_ID in integer default null, 
  pCountSTREAM in integer default null  
  ) return varchar2;
function Collect_account_phone_status(
  nMOD_NUM in number default 0,--������ ������
  nMOD in number default 1,--������
  pCUR_BAN IN NUMBER DEFAULT 0,  -- 0 ������ ���� ��� ����.
  pLOAD_ONLY_NEW number default 0 --�� ��������� �������� ��� ������������� �������
  ) return varchar2;
--���������� ������ ��� �� ����������
function Collect_account_BANS(
  Paccount_id in number
  ) return varchar2;                                     
--����� ��������
Function phone_options  (
  pPHONE_NUMBER in number
  ) return varchar2;
function Collect_account_phone_opts(
  Paccount_id in number
  ) return varchar2;
--������� �������
Function phone_detail_call (
  pPHONE_NUMBER in number
  ) return varchar2;
--�������� ����� � ���
Function Get_account_bill (
  pAccount_id in number,
  pRequestID in number
  )return varchar2;
--������ ������ �������
Function get_ticket_status (
  pAccount_id in number,
  pRequestID in VARCHAR2
  ) return varchar2 ;
--�������� ������ �� ����������� �����.
FUNCTION Create_account_bill(
  PaccountId IN VARCHAR2,
  Pyear_month IN INTEGER 
  ) RETURN VARCHAR2;
--������� ���������� �� ������
Function phone_report_data  (
  pPHONE_NUMBER in number
  ) return varchar2;   
--�������� ������� ���������� �� �/� 
function account_report_data(
  Paccount_id in number,
  n_mod in number
  ) return varchar2;  
-- ������� TURN_TARIFF_OPTION ���������� ��� ��������� �������� ����� ��� ������.
-- ������������ �������� ��� ������ ��� ����� ������.
-- ������ ����������� � ������� BEELINE_TICKETS, ������ ������ ��������� ����������� JOB �������� �������.
FUNCTION TURN_TARIFF_OPTION(
  pPHONE_NUMBER IN VARCHAR2,
  pOPTION_CODE IN VARCHAR2,
  pTURN_ON IN INTEGER, -- 0: ���������, 1: ��������
  pEFF_DATE IN DATE,   -- ���� ����������� ������ (NULL - ����� ������)
  pEXP_DATE IN DATE,   -- ���� ��������������� ���������� (NULL - �� ���������)
  pREQUEST_INITIATOR IN VARCHAR2 -- ��������� ������� (�� 10 ������)
  ) RETURN VARCHAR2;        
-- �������� ����������� �� ���
PROCEDURE LOAD_DETAIL_FROM_API(
  pPHONE_NUMBER IN VARCHAR2
  );                             
-- ��������� �������� ������� REST
function rest_info_rests(
  pPHONE_NUMBER varchar2
  ) return beeline_rest_api_pckg.TRests;
--���������� ������ ��� ����� �� ����������� ��������
function phone_SIM(
  pPHONE_NUMBER in number
  ) return varchar2;  
--��������� ������ �������� �������� �� ����
function account_phone_SIM(
  Paccount_id in number
  ) return varchar2;
--��������� ������ �������� �������� �� ���� �����������
function Collect_account_phone_SIM(
  Paccount_id in number
  ) return varchar2;
--
--�������� ������ �� ����� ��������� �����
function changePP (pPHONE_NUMBER NUMBER, pNEWTariffCode varchar2, pFutureDate varchar2 default 'N' )
    RETURN VARCHAR2;    
-- ��������� �� REST API ����� ��� � �������, ���������� ��� ��.
function mcBalance(
  pPHONE_NUMBER varchar2
  ) return beeline_rest_api_pckg.TRestsMCBalance;  
-- ������� �������� ����� ���������� � �������
procedure Collect_account_phone_opts_st(
  p_STREAM_ID in integer, 
  pCountSTREAM in integer
  );
--                            
END;

CREATE OR REPLACE PACKAGE BODY BEELINE_API_PCKG AS

  cPARSE_RESULT CONSTANT VARCHAR2(2 CHAR) := 'OK';
  
  const_year_month number; -- ������� �����-���
  --������ ����������� ������ ��� BEELINE_API_PCKG.Collect_account_phone_status 
  --           � beeline_api_pckg.account_phone_status  
  FUNCTION GET_API_CTN_INFO_LIST_TABLE(
    pXML IN XMLTYPE  
  ) RETURN VARCHAR2 AS 
    srcClob clob;
    vBuffer      VARCHAR2 (2048);
    l_amount     number;
    l_pos        number := 1;
    l_clob_len   number ;
    cou          integer ;
    beg_str       int;
    end_str       int;
    beg_tag       int;
    tag           varchar2(255 char);
    v_loc         VARCHAR2(255 char);
    TYPE API_GET_CTN_INFO_LIST_ARR is table of API_GET_CTN_INFO_LIST%ROWTYPE INDEX BY BINARY_INTEGER;
    rec  API_GET_CTN_INFO_LIST_ARR;
    idx integer;
    ret varchar2(500 char);
    str_len integer;
    str varchar2 (255 char);
  BEGIN
    ret:= cPARSE_RESULT;
    begin
      EXECUTE IMMEDIATE 'TRUNCATE TABLE API_GET_CTN_INFO_LIST';
        select XMLroot (pXML, VERSION '1.0').Getclobval () into srcClob 
          from dual;
      idx := 0;
      loop
        l_amount := DBMS_LOB.INSTR ( srcClob, chr(10), l_pos, 1)-l_pos;
        exit when l_amount <= 0;
        if l_amount > 2048 then
          raise_application_error(-20001,'������ ������� ������ � �� ���������� � ������');
        end if;      
        dbms_lob.read(srcClob, l_amount, l_pos, vBuffer);
        v_loc:= SUBSTR(vBuffer, 1,255);
        beg_str:=instr(v_loc,'>',1,1)+1;
        end_str:=instr(v_loc,'<',1,2);
        beg_tag:=instr(v_loc,'<',1,1);
        str_len := end_str-beg_str;
        if instr(v_loc,'<',1,2)>1 then          
          tag:=SUBSTR(v_loc,beg_tag+1, beg_str-beg_tag-2);
          str :=  SUBSTR(v_loc, beg_str, str_len);
          
          if tag = 'ctn' then
            rec(idx).ctn := str;
          ELSIF tag = 'statusDate' then
            rec(idx).statusDate := str;
          ELSIF tag = 'status' then
            rec(idx).status := str;
          ELSIF tag = 'pricePlan' then
            rec(idx).pricePlan := str;         
          ELSIF tag = 'reasonStatus' then
            rec(idx).reasonStatus := str;  
          ELSIF tag = 'lastActivity' then
            rec(idx).lastActivity := str;  
          ELSIF tag = 'activationDate' then
            rec(idx).activationDate := str; 
          ELSIF tag = 'subscriberHLR' then
            rec(idx).subscriberHLR := str;      
          --������ ��� ���� ����������� �������
          idx := idx + 1;
          end if;
        end if;       
      ------------------------------------------------
        l_pos := l_pos + l_amount +1;
      end loop;
      if idx > 0 then
        FORALL i IN 0..idx - 1
         INSERT INTO API_GET_CTN_INFO_LIST(ctn, statusDate, status, pricePlan, 
                                           reasonStatus, lastActivity, activationDate, subscriberHLR)
           VALUES(rec(i).ctn, rec(i).statusDate, rec(i).status, rec(i).pricePlan,
                  rec(i).reasonStatus, rec(i).lastActivity, rec(i).activationDate, rec(i).subscriberHLR);
      end if;          
    exception
      when others then
        ret := SQLERRM;  
    end;
    RETURN ret;
  END; 
  --������ ����������� ������ ��� ����������� �� ���
  FUNCTION GET_API_UNBILLED_CALLS_LIST(
    pXML IN XMLTYPE
    ) RETURN VARCHAR2 AS
      srcClob clob;
      vBuffer      VARCHAR2 (2048);
      l_amount     number;
      l_pos        number := 1;
      beg_str       int;
      end_str       int;
      beg_tag       int;
      tag           varchar2(255 char);
      v_loc         varchar2(255 char);
      TYPE API_GET_CTN_INFO_LIST_ARR is table of API_GET_UNBILLED_CALLS_LIST%ROWTYPE INDEX BY BINARY_INTEGER;
      rec  API_GET_CTN_INFO_LIST_ARR;
      idx integer;
      ret varchar2(500);
      str_len integer;
      str varchar2(255 char);
      cPARSE_RESULT varchar2(100):='OK';
  BEGIN
    ret:= cPARSE_RESULT;
    begin
      EXECUTE IMMEDIATE 'TRUNCATE TABLE API_GET_UNBILLED_CALLS_LIST';
      select XMLroot (pXML, VERSION '1.0').Getclobval () into srcClob from dual;
      idx := 0;
      loop
        l_amount := DBMS_LOB.INSTR ( srcClob, chr(10), l_pos, 1)-l_pos;
        exit when l_amount <= 0;
        if l_amount > 2048 then
          raise_application_error(-20001,'������ ������� ������ � �� ���������� � ������');
        end if;
        dbms_lob.read(srcClob, l_amount, l_pos, vBuffer);
        v_loc:= SUBSTR(vBuffer, 1,255);
        beg_str:=instr(v_loc,'>',1,1)+1;
        end_str:=instr(v_loc,'<',1,2);
        beg_tag:=instr(v_loc,'<',1,1);
        str_len := end_str-beg_str;
        if instr(v_loc,'<',1,2)>1 then
          tag:=LOWER(SUBSTR(v_loc,beg_tag+1, beg_str-beg_tag-2));
          str :=  SUBSTR(v_loc, beg_str, str_len);
          if tag = 'calldate' then
            rec(idx).calldate := str;
          ELSIF tag = 'callnumber' then
            rec(idx).callnumber := str;
          ELSIF tag = 'calltonumber' then
            rec(idx).calltonumber := str;
          ELSIF tag = 'servicename' then
            rec(idx).servicename := str;
          ELSIF tag = 'calltype' then
            rec(idx).calltype := str;
          ELSIF tag = 'datavolume' then
            rec(idx).datavolume := str;
          ELSIF tag = 'callamt' then
            rec(idx).callamt := str;
          ELSIF tag = 'callduration' then
            rec(idx).callduration := str;
          --������ ��� ���� ����������� �������
          idx := idx + 1;
          end if;
        end if;
      ------------------------------------------------
        l_pos := l_pos + l_amount +1;
      end loop;
      ------------------------------------------------
      if idx > 0 then
        FORALL i IN 0..idx - 1
          INSERT INTO API_GET_UNBILLED_CALLS_LIST(calldate, callnumber, calltonumber, servicename,
                                                 calltype, datavolume, callamt, callduration)
            VALUES(rec(i).calldate, rec(i).callnumber, rec(i).calltonumber, rec(i).servicename,
                   rec(i).calltype, rec(i).datavolume, rec(i).callamt, rec(i).callduration);
      end if;
      UPDATE API_GET_UNBILLED_CALLS_LIST
        SET CALLTYPE = REPLACE(CALLTYPE, '&quot;', '"');
    exception
      when others then
        ret := SQLERRM;
    end;
    RETURN ret;
  END;  
  --�������� ����� ��� REST API
  FUNCTION GET_REST_API_TOKEN(
    pPHONE_NUMBER varchar2
    ) return BEELINE_API_TOKEN_LIST.REST_TOKEN%TYPE is
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN,
             ACCOUNTS.New_Pswd
        FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS
        WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
          AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                       from DB_LOADER_ACCOUNT_PHONES 
                                                       where PHONE_NUMBER = pPHONE_NUMBER);
    vREC C%ROWTYPE;
    vToken_Last_Update_DATE BEELINE_API_TOKEN_LIST.REST_LAST_UPDATE%TYPE;
    vToken BEELINE_API_TOKEN_LIST.REST_TOKEN%TYPE;
  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    
    vToken := null;
    
    IF vREC.LOGIN IS NOT NULL THEN
    
      select t.rest_token, t.rest_last_update into vToken, vToken_Last_Update_DATE
        from beeline_api_token_list t 
        where t.acc_log = vREC.login;
      
      if ( vToken_Last_Update_DATE<sysdate- 9/24 --9/1440 
          or vToken_Last_Update_DATE is null)  then 
        vToken := BEELINE_REST_API_PCKG.GET_TOKEN(vREC.login,vREC.new_pswd);
      end if;
    end if;
    
    RETURN vToken;    
  end; 
     
-- ������ ����� �����
  FUNCTION REPLACE_SIM(
    pPHONE_NUMBER IN VARCHAR2, 
    pICC in varchar2
    ) RETURN VARCHAR2 IS
    --
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN,
             ACCOUNTS.New_Pswd,
             ACCOUNTS.ACCOUNT_NUMBER,
             ACCOUNTS.Company_Name,
             Accounts.Account_Id
        FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS
        WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
          AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                       from DB_LOADER_ACCOUNT_PHONES 
                                                       where PHONE_NUMBER = pPHONE_NUMBER);
    --
    vREC     C%ROWTYPE;
    V_RESULT VARCHAR2(20000);
    oICC     VARCHAR2(18);
    Respond  varchar2(5000); -- �����
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);
  BEGIN
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        Respond:=BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd);        
        panswer:=BEELINE_SOAP_API_PCKG.replaseSIM(Respond, pPHONE_NUMBER, pICC, '',vrec.account_id);                  
        select extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:replaceSIMResponse/return'
                                          ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')
          into V_RESULT from dual;            
        if V_RESULT is null then 
          select nvl(pANSWER.Err_text,
                     extractValue(pANSWER.ANSWER,
                                  'S:Envelope/S:Body/ns0:Fault/detail/ns1:UssWsApiException/errorDescription',
                                  'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/ xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"'))
            into V_RESULT
            from dual; 
          if V_RESULT is null then  
            raise_application_error(-20000, '������������� ������ ��.'); 
          else 
            return(V_RESULT);
          end if;
        else
          --���������� � ��� 
          insert into REPLACE_SIM_LOG(PHONE, OLD_SIM, NEW_SIM, REP_USER, REP_DATE, ERR, BSAL_ID, SIM_LOG_TYPE_ID)
            values(pPHONE_NUMBER, oICC, pICC, null, null,0,pANSWER.BSAL_ID, 1);
          --���������� ������ ������ �� ��������                   
          insert into beeline_tickets(ticket_id, account_id, ban, ticket_type, answer, comments, phone_number, user_created, date_create)
            values(V_RESULT,vrec.account_id, vrec.account_number, 12, null, null, pPHONE_NUMBER, user, sysdate);                   
          commit;
          return V_RESULT;                  
        end if;
      EXCEPTION
        WHEN OTHERS THEN
          Respond := SQLERRM;
          insert into REPLACE_SIM_LOG(PHONE, OLD_SIM, NEW_SIM, REP_USER, REP_DATE, ERR, BSAL_ID, SIM_LOG_TYPE_ID)
            values(pPHONE_NUMBER, oICC, pICC, null, null,2,pANSWER.BSAL_ID, 1);
          commit;
          return Respond;
      END;        
    ELSE
      insert into REPLACE_SIM_LOG(PHONE, OLD_SIM, NEW_SIM, REP_USER, REP_DATE, ERR, BSAL_ID, SIM_LOG_TYPE_ID)
        values(pPHONE_NUMBER, oICC, pICC, null, null,1,null, 1);
      commit;
      RETURN pPHONE_NUMBER || ' �� ������ � ���� ������.';
    END IF;
  END;
-- ������ ���������� ������
  FUNCTION LOCK_PHONE(
    pPHONE_NUMBER IN VARCHAR2,
    pMANUAL_BLOCK IN INTEGER DEFAULT 1,
    pCode         in varchar2
    ) RETURN VARCHAR2 IS
    --
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN, ACCOUNTS.New_Pswd,ACCOUNTS.Account_Id,ACCOUNTS.Account_Number
        FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS
        WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
          AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                       from DB_LOADER_ACCOUNT_PHONES 
                                                       where PHONE_NUMBER = pPHONE_NUMBER);
    vREC C%ROWTYPE;
    FIO      VARCHAR2(2000);
    V_RESULT VARCHAR2(20000);
    Respond  varchar2(5000); -- �����
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);
  BEGIN
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        Respond:=BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd);--�������� �����
        pANSWER:=BEELINE_SOAP_API_PCKG.suspendCTN(Respond, pPHONE_NUMBER, sysdate + 1 / 86400, '', pCode,vrec.account_id);--������ � ���
        --������ ������
        select extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:suspendCTNResponse/return'
                                            ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')
          into V_RESULT from dual;            
        if V_RESULT is null then--���� ��� ����������� ������ ������
          --���� ����� ������
          if pANSWER.Err_text!='OK' then 
            V_RESULT:=pANSWER.Err_text;
          else
            select nvl(pANSWER.Err_text,    
                       extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:Fault/detail/ns1:UssWsApiException/errorDescription'
                                                  ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/ xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"') )
              into V_RESULT from dual; 
          end if;     
          --��� ������ ������ ���������� ������������� ������
          if V_RESULT is null then
            raise_application_error(-20000, '������������� ������ ��.');
          --���� ����� ������ ���������� ���   
          else 
            return('Error_Api:'||V_RESULT); 
          end if;
        --���� �� � ������� � ���� �����
        else
         --���������� � ��� 
          INSERT INTO AUTO_BLOCKED_PHONE(PHONE_NUMBER, BALLANCE, BLOCK_DATE_TIME,
                                         MANUAL_BLOCK, USER_NAME, ABONENT_FIO, note)
            VALUES(pPHONE_NUMBER, GET_ABONENT_BALANCE(pPHONE_NUMBER), SYSDATE,
                   pMANUAL_BLOCK, USER, FIO, '������ �� ���� �'||V_RESULT);
         --���������� ������ ������ �� ��������
          insert into beeline_tickets(ticket_id, account_id, ban, ticket_type, answer, comments, phone_number,user_created,date_create)
            values(V_RESULT,vrec.account_id, vrec.account_number, 9, null, null,pPHONE_NUMBER,user,sysdate);
          commit;
          --���������� ����� ������ �� ��������
          return ('������ �� ���� �'||V_RESULT);          
        end if;
      --� ������ ���������� ���������� ������  
      EXCEPTION
        WHEN OTHERS THEN
          Respond := SQLERRM;
          return Respond;
      END;
    ELSE
      RETURN pPHONE_NUMBER || ' �� ������ � ���� ������.';
    END IF;
  END;
-- ������ ������������� ������
  FUNCTION UNLOCK_PHONE(
    pPHONE_NUMBER  IN VARCHAR2,
    pMANUAL_UNLOCK IN INTEGER DEFAULT 1
    ) RETURN VARCHAR2 IS
    --
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN, ACCOUNTS.New_Pswd,ACCOUNTS.Account_Id,ACCOUNTS.Account_Number
        FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS
        WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
          AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                       from DB_LOADER_ACCOUNT_PHONES 
                                                       where PHONE_NUMBER = pPHONE_NUMBER);  
    vREC     C%ROWTYPE;
    FIO      VARCHAR2(2000);
    V_RESULT VARCHAR2(20000);
    Respond  varchar2(5000); -- �����
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);
  BEGIN
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        Respond:=BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd);--�������� �����
        pANSWER:=BEELINE_SOAP_API_PCKG.restoreCTN(Respond, pPHONE_NUMBER, sysdate + 1 / 86400,'',vrec.account_id);--������ � ���
        --������ ������
        select extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:restoreCTNResponse/return'
                                          ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')
          into V_RESULT from dual;            
        if V_RESULT is null then --���� ��� ����������� ������ ������
           --���� ����� ������
          select nvl(pANSWER.Err_text,
                     extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:Fault/detail/ns1:UssWsApiException/errorDescription'
                                ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/ xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"'))
            into V_RESULT from dual;                        
              --��� ������ ������ ���������� ������������� ������
          if V_RESULT is null then  
            raise_application_error(-20000, '������������� ������ ��.');
          --���� ����� ������ ���������� ���   
          else 
            return('Error_Api:'||V_RESULT); 
          end if;
        --���� �� � ������� � ���� �����
         else
         --���������� � ��� 
          INSERT INTO AUTO_UNBLOCKED_PHONE(PHONE_NUMBER, BALLANCE, UNBLOCK_DATE_TIME,
                                           MANUAL_BLOCK, USER_NAME, ABONENT_FIO, note)
            VALUES(pPHONE_NUMBER, GET_ABONENT_BALANCE(pPHONE_NUMBER), SYSDATE, 
                   pMANUAL_UNLOCK, USER, FIO, '������ �� ������� �'||V_RESULT);
          --���������� ������ ������ �� ��������
          insert into beeline_tickets(ticket_id, account_id, ban, ticket_type, answer, comments, phone_number,user_created,date_create)
            values(V_RESULT,vrec.account_id, vrec.account_number, 10, null, null,pPHONE_NUMBER,user,sysdate);
          commit;
          --���������� ����� ������ �� ��������
          return ('������ �� ������� �'||V_RESULT);          
        end if;
      --� ������ ���������� ���������� ������  
      exception
        WHEN OTHERS THEN
          Respond := SQLERRM;
          return Respond;
      end;
      return Respond;
    ELSE
      RETURN pPHONE_NUMBER || ' �� ������ � ���� ������.';
    END IF;
  END;
-- ������ ������� ����������� ������
  Function phone_status(
    pPHONE_NUMBER in number
    ) return varchar2 is
     --
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN, 
             ACCOUNTS.New_Pswd,
             (case ACCOUNTS.Is_Collector
                when 1 then nvl(bi.ban,0)
                else accounts.account_number
              end) account_number, 
             accounts.account_id
        FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS, beeline_loader_inf bi
        WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
          and bi.phone_number(+)=DB_LOADER_ACCOUNT_PHONES.Phone_Number
          AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                       from DB_LOADER_ACCOUNT_PHONES 
                                                       where PHONE_NUMBER = pPHONE_NUMBER);                                                           
    vREC C%ROWTYPE;
    Respond  varchar2(5000); -- �����
    Resp_code varchar2(200);-- ����� ���
    Resp_plan varchar2(200);-- ����� ���
    Resp_date_change varchar2(200 char);
    pSubscriberHLR varchar2(10);
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);  
    vCOMMENT VARCHAR2(1000 CHAR);
  
    procedure update_phones (ph in varchar2,ym in number,acc in number, pCODE IN VARCHAR2, pDATE_CHANGE IN DATE, pHLR in varchar2) as 
      PRAGMA AUTONOMOUS_TRANSACTION;
    begin
      update db_loader_account_phones q 
        set q.phone_is_active=decode(Respond,'ACTIVE',1,'BLOCKED',0)
           ,q.last_check_date_time=sysdate 
           ,q.conservation=decode(Respond, 'ACTIVE',0,'BLOCKED', decode(Resp_code,'S1B',1,'DUF',1,'BSB',1,'DOSS',1,0))
           ,q.system_block=decode(Respond, 'ACTIVE',0,'BLOCKED', decode(Resp_code,'BSB',1,'DUF',1,'DOSS',1,0))
           ,q.cell_plan_code=Resp_plan
           ,Q.LAST_CHANGE_STATUS_DATE=pDATE_CHANGE
           ,Q.STATUS_ID=CONVERT_PCKG.STATUS_CODE_TO_STATUS_ID(pCODE) 
           ,q.SubscriberHLR=pHLR                                                        
        where q.phone_number=ph 
          and q.year_month=ym 
          and q.account_id=acc
          and trim(Respond) in ('ACTIVE','BLOCKED');               
      --temp_add_account_phone_history(ph, Resp_plan, case Respond when 'ACTIVE' then 1 when 'BLOCKED' then 0 end, sysdate);
      commit;
    end;      

  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        pANSWER:=BEELINE_SOAP_API_PCKG.getCTNInfoList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd), pPHONE_NUMBER,vREC.account_number, '');
        select extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:getCTNInfoListResponse/CTNInfoList/status',      'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')
              ,extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:getCTNInfoListResponse/CTNInfoList/reasonStatus','xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"') 
              ,extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:getCTNInfoListResponse/CTNInfoList/pricePlan',   'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')   
              ,extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:getCTNInfoListResponse/CTNInfoList/statusDate',  'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')     
              ,extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:getCTNInfoListResponse/CTNInfoList/subscriberHLR',  'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"') 
        into Respond,Resp_code,Resp_plan, Resp_date_change, pSubscriberHLR from dual; 
--insert into beeline_soap_api_log(soap_answer) values (pANSWER.ANSWER); commit;--�������� ������ ��� �������!
        update_phones(pPHONE_NUMBER,to_char(sysdate,'YYYYMM'),vrec.account_id, Resp_code, convert_pckg.TIMESTAMP_TZ_TO_DATE(Resp_date_change), pSubscriberHLR);
      EXCEPTION
        WHEN OTHERS THEN
          Respond := pANSWER.Err_text||CHR(13)||SQLERRM;
          return (Respond);
      END;
    Else
    Respond:='�� ������ �\�';
    end if;
    SELECT B.COMMENT_CLENT INTO vCOMMENT
      FROM BEELINE_STATUS_CODE B
      WHERE B.STATUS_CODE = Resp_code;
    Return ('������: '||Respond||'. ��� ������: '||Resp_plan||'. ��� �������: '||Resp_code||'('||vCOMMENT||')');
  end;  
-- ���������� ������ ����� �� ������
  Function phone_options(
    pPHONE_NUMBER in number
    ) return varchar2 is
     --
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN, ACCOUNTS.New_Pswd,
             decode(accounts.is_collector,1,li.ban,0,accounts.account_number,accounts.account_number) account_number
        FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS, beeline_loader_inf li
        WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
          AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
          and li.phone_number(+)=DB_LOADER_ACCOUNT_PHONES.Phone_Number
          and DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                            from DB_LOADER_ACCOUNT_PHONES 
                                                            where PHONE_NUMBER = pPHONE_NUMBER);   
    vREC C%ROWTYPE;
    Respond  varchar2(5000); -- �����
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);  
    vStart_date date;

    procedure update_options(pctn in varchar2, pserviceId in varchar2, pserviceName in varchar2,pStDate in date,pEndDate in date) as
      pragma autonomous_transaction;
      begin
         db_loader_pckg.ADD_ACCOUNT_PHONE_OPTION2(
                      to_char(sysdate,'YYYY'),
                      to_char(sysdate,'MM'),
                      vrec.login,
                      pctn, /*�����*/
                      pserviceId,       /* ��� ����� */
                      pserviceName,       /* ������������ ����� */
                      null, /* ��������� ����� */
                      pStDate,          /* ���� �����������*/
                      pEndDate,         /* ���� ���������� */
                      null,        /*��������� �����������*/
                      null        /*��������� � �����*/
                      );
        commit;
      end;
    procedure update_option_close(pctn in varchar2, pStart_date in date) as
      pragma autonomous_transaction;
      cursor otp_select is
        select *
          from db_loader_account_phone_opts op
          where op.PHONE_NUMBER = pctn
            and op.LAST_CHECK_DATE_TIME >= pStart_date;
      o_dummy otp_select%rowtype;
      begin
        open otp_select;
        fetch otp_select into o_dummy;
        if otp_select%found then 
          update db_loader_account_phone_opts op
            set op.TURN_OFF_DATE = sysdate
            where op.PHONE_NUMBER = o_dummy.PHONE_NUMBER
              and op.YEAR_MONTH = o_dummy.YEAR_MONTH
              and op.TURN_OFF_DATE is null
              and op.LAST_CHECK_DATE_TIME < pStart_date;
        end if;
        close otp_select;
        commit;
      end;

  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        vStart_date:=sysdate;
        pANSWER:=BEELINE_SOAP_API_PCKG.getServiceList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd), pPHONE_NUMBER,vREC.account_number, '');
        For i in (select substr(extractvalue (value(d),'servicesList/ctn'),-10)ctn,
                         extractvalue (value(d),'/servicesList/serviceId')   serviceId,
                         CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(extractvalue (value(d) ,'/servicesList/startDate')) startDate,
                         CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(extractvalue (value(d) ,'/servicesList/endDate')) endDate,
                         extractvalue (value(d),'/servicesList/serviceName') serviceName
                    from table(XmlSequence(pANSWER.ANSWER.extract('S:Envelope/S:Body/ns0:getServicesListResponse/servicesList',
                                                                  'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Subscriber"'))) d)
        loop
          update_options(to_char(i.ctn),i.serviceId, i.serviceName,i.startDate,i.endDate);       
          Respond:=Respond||i.serviceId||' '||i.serviceName||chr(13);
        end loop; 
      EXCEPTION
        WHEN OTHERS THEN
          Respond := SQLERRM;
          return (Respond);
      END;
    Else
      Respond:='�� ������ �\�';
    end if;
    update_option_close(pPHONE_NUMBER, vStart_date);
    Return (Respond);
  end; 
-- ������ ����������� �� ������
  Function phone_detail_call (pPHONE_NUMBER in number) return varchar2 is
     --
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN, ACCOUNTS.New_Pswd, accounts.account_number
        FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS
        WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
          AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                       from DB_LOADER_ACCOUNT_PHONES 
                                                       where PHONE_NUMBER = pPHONE_NUMBER);   
    vREC     C%ROWTYPE;
    Respond  varchar2(5000); -- �����
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);  
  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        pANSWER:=BEELINE_SOAP_API_PCKG.getUnbilledCallsList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd), pPHONE_NUMBER,vREC.account_number, '');
/*        For i in(        
        select substr(extractvalue (value(d) ,'UnbilledCallsList/callNumber'),-10) callNumber
                     ,extractvalue (value(d) ,'UnbilledCallsList/callDate')   callDate
                     ,substr(extractvalue (value(d) ,'UnbilledCallsList/callToNumber'),-10) callToNumber
                     ,extractvalue (value(d) ,'UnbilledCallsList/serviceName') serviceName
                     ,extractvalue (value(d) ,'UnbilledCallsList/callType') callType
                     ,extractvalue (value(d) ,'UnbilledCallsList/dataVolume') dataVolume
                     ,extractvalue (value(d) ,'UnbilledCallsList/callAmt') callAmt                                                               
                     ,extractvalue (value(d) ,'UnbilledCallsList/callDuration') callDuration  
        from table(XmlSequence(pANSWER.ANSWER.extract('S:Envelope/S:Body/ns0:getUnbilledCallsListResponse/UnbilledCallsList'
                 ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Subscriber"'))) d)
        loop        
        end loop;*/ 
        respond:=pANSWER.BSAL_ID;
      EXCEPTION
        WHEN OTHERS THEN
          Respond := SQLERRM;
          return (Respond);
      END;
    Else
      Respond:='�� ������ �\�';
    end if;
    Return (Respond);
  end;
-- ������ �������� ������� �� �/�
function account_phone_status(
  Paccount_id in number
  ) return varchar2 is--phone_state_table  
  CURSOR C IS
    SELECT LOGIN, New_Pswd, account_number, account_id, is_collector
      FROM ACCOUNTS
      WHERE account_id = Paccount_id;  
  vREC C%ROWTYPE;
  Respond varchar2(5000); -- �����
  pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null); 
  vYEAR_MONTH INTEGER;
  ERROR_COL INTEGER;
  parse_res varchar2(500);
  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL and vRec.Is_Collector=0 or vRec.Is_Collector is null THEN
      ERROR_COL:=0;
      LOOP
        BEGIN
          pANSWER:=BEELINE_SOAP_API_PCKG.getCTNInfoList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),'',vREC.account_number,'');        
          if pANSWER.Err_text='OK' then 
            --���������� ���������� xml � API_GET_CTN_INFO_LIST
            parse_res := GET_API_CTN_INFO_LIST_TABLE(pANSWER.ANSWER);
            if parse_res = cPARSE_RESULT then
              -- �������� ����� ���������� ������� � �����
              ARCHIVE_PCKG.ADD_REC_API_GET_CTN_INFO_LIST(vREC.account_number); 
              -- ��������� � ��                                                 
              vYEAR_MONTH:=TO_NUMBER(to_char(sysdate,'YYYYMM'));         
              MERGE INTO db_loader_account_phones ph
              -- ������� ���������
                USING (select substr(d.ctn, -10) ctn
                             ,d.status stat
                             ,d.reasonStatus reason
                             ,d.pricePlan plan
                             ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(d.statusDate) statusDate
                             ,bsc.IS_CONSERVATION
                             ,bsc.IS_SYSTEM_BLOCK
                             ,d.subscriberHLR
                         from API_GET_CTN_INFO_LIST d
                         left outer join BEELINE_STATUS_CODE bsc on bsc.STATUS_CODE = d.reasonStatus                     
                      ) api
                  ON (ph.phone_number = api.ctn 
                        and ph.year_month=vYEAR_MONTH 
                        and ph.account_id=Paccount_id)                
                WHEN MATCHED THEN
                -- ����� �����
                  UPDATE SET ph.phone_is_active=CASE WHEN API.STAT = 'ACTIVE' THEN 1 ELSE 0 END,
                             ph.cell_plan_code=api.plan,
                             ph.last_check_date_time=sysdate,
                             ph.last_change_status_date=api.statusDate,                
                             ph.conservation = CASE WHEN API.STAT = 'ACTIVE' THEN 0 ELSE API.IS_CONSERVATION END,
                             ph.system_block = CASE WHEN API.STAT = 'ACTIVE' THEN 0 ELSE API.IS_SYSTEM_BLOCK END,
                             PH.STATUS_ID = CONVERT_PCKG.STATUS_CODE_TO_STATUS_ID(API.REASON),
                             ph.SUBSCRIBERHLR = api.subscriberHLR
                  WHERE (api.stat in ('ACTIVE','BLOCKED')                        -- ��� ���� ������ �� ������ �� ��� 
                          or (api.stat is null and ph.last_check_date_time<sysdate-1))-- ���� ����� �� ���������� ����� ����� � ����� ������ ������ ��� ���� ����� ��� �������    
                WHEN NOT MATCHED THEN
                -- ����� �� �����
                  INSERT (ph.account_id, ph.year_month, ph.phone_number,
                          ph.phone_is_active, ph.cell_plan_code, ph.last_check_date_time,
                          ph.organization_id, ph.conservation, ph.system_block, 
                          ph.last_change_status_date, ph.STATUS_ID,  ph.SUBSCRIBERHLR)
                    VALUES (Paccount_id, vYEAR_MONTH, api.ctn,
                            CASE WHEN API.STAT = 'ACTIVE' THEN 1 ELSE 0 END, 
                            api.plan, sysdate, 1, 
                            CASE WHEN API.STAT = 'ACTIVE' THEN 0 ELSE API.IS_CONSERVATION END,
                            CASE WHEN API.STAT = 'ACTIVE' THEN 0 ELSE API.IS_SYSTEM_BLOCK END,
                            api.statusDate, convert_pckg.STATUS_CODE_TO_STATUS_ID(api.reason),  api.subscriberHLR)
                  WHERE api.stat in ('ACTIVE','BLOCKED');
                -- MERGE END   
              Respond:='Update '||sql%rowcount;
              -- ������ ������, ������� �������� �/�, �.�. ���� � DB_LOADER_ACCOUNT_PHONES, �� ��� � �������� �� ���
              DELETE 
                FROM DB_LOADER_ACCOUNT_PHONES PH
                WHERE PH.ACCOUNT_ID = pACCOUNT_ID
                  AND PH.YEAR_MONTH = vYEAR_MONTH 
                  AND PHONE_NUMBER NOT IN (select substr(d.ctn, -10) ctn                         
                                             from API_GET_CTN_INFO_LIST d);
              --����������� � ��� �������� 
              insert into account_load_logs( account_load_log_id,account_id, load_date_time, is_success, error_text, account_load_type_id)
                values(s_new_account_load_log_id.nextval,Paccount_id, sysdate, 1, 'Ok!'||Respond, 3);          
              if sql%rowcount>0 then 
                commit;
              end if;
            else
              Respond := parse_res;  
            end if; --if parse_res = 'OK'
          else 
            Respond:= pANSWER.Err_text;
          end if;
        EXCEPTION
          WHEN OTHERS THEN
            Respond := SQLERRM;
        END;--api_responce
        ERROR_COL:=ERROR_COL + 1;
        EXIT WHEN (INSTR(Respond, 'Update') > 0) OR (ERROR_COL >= 3); 
      END LOOP;
    Else
      Respond:='�� ������ �\�';
    end if;--vrec.login
    Return Respond;           
  end;--func
--
function account_phone_options(
  Paccount_id in number,
  p_STREAM_ID in integer default null, 
  pCountSTREAM in integer default null
  ) return varchar2  is--phone_state_table 
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN, 
             ACCOUNTS.New_Pswd, 
             accounts.account_number,
             accounts.account_id,
             accounts.is_collector
        FROM ACCOUNTS
        WHERE ACCOUNTS.account_id = Paccount_id; 
   vREC     C%ROWTYPE;
   Respond  varchar2(5000); -- �����
   pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null); 
   count_good integer:=0;
   count_bad integer:=0;   
begin
  OPEN C;
  FETCH C INTO vREC;
  CLOSE C;
  IF vREC.LOGIN IS NOT NULL 
      and (vRec.Is_Collector=0 
            or vRec.Is_Collector is null)  THEN
    BEGIN      
      for i in (select ph.phone_number
                  from db_loader_account_phones ph 
                  where ph.year_month=const_year_month 
                    and ph.account_id=Paccount_id
                    and mod(to_number(ph.PHONE_NUMBER), decode(nvl(pCountSTREAM, 0), 0, 1, pCountSTREAM)) = nvl(p_STREAM_ID,0)
                  order by get_last_options_update(ph.phone_number) nulls first) 
      loop
        pANSWER:=BEELINE_SOAP_API_PCKG.getServiceList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),i.phone_number,vREC.account_number,'');            
        if pANSWER.Err_text='OK' then    
         --���� �� ������
          for s in (select substr(extractvalue (value(d) ,'servicesList/ctn'),-10)ctn
                           ,trim(extractvalue (value(d) ,'/servicesList/serviceId'))   serviceId
                           ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(extractvalue (value(d) ,'/servicesList/startDate')) startDate
                           ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(extractvalue (value(d) ,'/servicesList/endDate')) endDate
                           ,trim(extractvalue (value(d) ,'/servicesList/serviceName')) serviceName
                     from table(XmlSequence(pANSWER.ANSWER.extract('S:Envelope/S:Body/ns0:getServicesListResponse/servicesList'
                                                                  ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Subscriber"'))) d)
          loop
            --�������� ��������� ����� �� ������� ��������
            null;
            db_loader_pckg.ADD_ACCOUNT_PHONE_OPTION2(
                 to_char(sysdate,'YYYY'),
                 to_char(sysdate,'MM'),
                 vrec.login,
                 to_char(s.ctn), /*�����*/
                 s.serviceId,       /* ��� ����� */
                 s.serviceName,       /* ������������ ����� */
                 null, /* ��������� ����� */
                 s.startDate,          /* ���� �����������*/
                 s.endDate,         /* ���� ���������� */
                 null,        /*��������� �����������*/
                 null        /*��������� � �����*/
                 );
            count_good:=count_good+1; 
          end loop s;                                   
        else
          count_bad:=count_bad+1;
        end if;
         --������� ������ ������� ��� ����� �����
        DB_LOADER_PHONE_OPRT_CLOSE2(substr(to_char(const_year_month),1,4), substr(to_char(const_year_month),5,2),i.phone_number); 
        commit;
      end loop i;       
   --����������� � ��� �������� 
      if count_good>0 then --���� ���� ���� ����� - �������� ��� �� ������.
        insert into account_load_logs(account_load_log_id,account_id, load_date_time, is_success, error_text, account_load_type_id)
          values(s_new_account_load_log_id.nextval,Paccount_id, sysdate, 1, 'Ok! Update options count '||count_good, 4);
      else 
        insert into account_load_logs(account_load_log_id,account_id, load_date_time, is_success, error_text, account_load_type_id)
          values(s_new_account_load_log_id.nextval,Paccount_id, sysdate, 0, 'Update:'||count_good||' err_count='||count_bad||',last err_txt:'||pANSWER.Err_text, 4);
      end if;
      commit;  
    EXCEPTION
      WHEN OTHERS THEN
        Respond := SQLERRM;
        return Respond;
    END;--api_responce
  Else
    Respond:='�� ������ �\�';
  end if;--vrec.login
  Return Respond;
--         
end;--func 
--
  Function account_phone_payments(
    pAccount_id in number,
    pKOL_DAY in INTEGER DEFAULT 3 
    ) return varchar2 is
     --
    CURSOR C IS
      SELECT distinct LOGIN, New_Pswd, account_number, account_id
        FROM ACCOUNTS
        WHERE ACCOUNT_ID = pAccount_id;   
    vREC C%ROWTYPE;
    Respond  varchar2(5000); -- �����
    paysign number(1);--����������� �������.
    counter number:=0;
    counter2 number := 0;
    counter_PAYM number:=0;
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);       
  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      for date_start in (select the_day 
                           from V_CALENDAR 
                           where the_day between trunc(sysdate)-pKOL_DAY and  trunc(sysdate)
                           order by the_day desc
                           )
                                        
      LOOP
      BEGIN
        pANSWER:=BEELINE_SOAP_API_PCKG.getPaymentList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),'',vREC.account_number,'', date_start.the_day , date_start.the_day);
                  
        if pANSWER.Err_text='OK' then    
          counter2 := 0;
          counter_PAYM := 0;
          --
          DELETE FROM API_GET_PAYMENT_LIST;
          --
          INSERT INTO API_GET_PAYMENT_LIST(ctn, paymentDate, paymentStatus, paymentType, 
                                           paymentOriginalAmt, paymentCurrentAmt, 
                                           bankPaymentID, paymentActivateDate)
            select extractvalue (value(d) ,'/PaymentList/ctn') ctn
                  ,extractvalue (value(d) ,'/PaymentList/paymentDate') paymentDate
                  ,extractvalue (value(d) ,'/PaymentList/paymentStatus') paymentStatus
                  ,extractvalue (value(d) ,'/PaymentList/paymentType') paymentType
                  ,extractvalue (value(d) ,'/PaymentList/paymentOriginalAmt') paymentOriginalAmt
                  ,extractvalue (value(d) ,'/PaymentList/paymentCurrentAmt') paymentCurrentAmt
                  ,extractvalue (value(d) ,'/PaymentList/bankPaymentID') bankPaymentID
                  ,extractvalue (value(d) ,'/PaymentList/paymentActivateDate') paymentActivateDate
              from table(XmlSequence(pANSWER.ANSWER.extract('S:Envelope/S:Body/ns0:getPaymentListResponse/PaymentList'
                                                           ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Subscriber"'))) d;       
          -- �������� ����� ���������� ������� � �����
          ARCHIVE_PCKG.ADD_REC_API_GET_PAYMENT_LIST(vREC.account_number); 
          --���� �� ��������
          for payments in (select substr(PL.ctn, -10) ctn
                                  ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(PL.paymentDate) paymentDate
                                  ,PL.paymentStatus paymentStatus
                                  ,PL.paymentType paymentType
                                  ,PL.paymentOriginalAmt paymentOriginalAmt
                                  ,PL.paymentCurrentAmt paymentCurrentAmt
                                  ,nvl(PL.bankPaymentID,0) bankPaymentID
                                  ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(PL.paymentActivateDate) paymentActivateDate
                              from API_GET_PAYMENT_LIST PL) 
          LOOP
             --�������� ��������
             --������ ����������� �������
             /*
             Backout ������ �������
             Funds transfer from ������� ������� �� ������� �������
             Funds transfer to ������� ������� c ������� �������
             Refund ������� �������
             Payment ������ ��������
             Refund reversal ������ �������� �������
             */
            paysign := case 
                         when payments.paymentStatus='Payment' then 1
                         when payments.paymentStatus='Backout' then -1
                         when payments.paymentStatus='Funds transfer from' then -1
                         when payments.paymentStatus='Funds transfer to' then 1
                         when payments.paymentStatus='Refund' then -1
                         when payments.paymentStatus='Refund reversal' then 1
                       else
                        0
                       end;
                             
            IF INSTR(payments.paymentStatus, 'Funds transfer') = 0 THEN                                         
              db_loader_pckg.add_payment(
                                         pyear => substr(to_char(const_year_month),1,4),
                                         pmonth => to_char(payments.paymentDate,'MM'),
                                         plogin => vREC.Login,
                                         pphone_number => NVL(payments.ctn, '0000000000'),
                                         ppayment_date => payments.paymentDate,
                                         ppayment_sum => to_number(replace(rtrim(payments.paymentOriginalAmt,chr(10)||chr(13)||chr(9)),',','.'), '9999999999.99')*paysign,
                                         ppayment_number => payments.bankPaymentID,
                                         
                                         ppayment_valid_flag => case
                                                                WHEN paysign=-1 THEN 0
                                                                else 1
                                                                end ,

                                         ppayment_status_text => case 
                                                                   when payments.paymentStatus='Payment' then '������ ��������'
                                                                   when payments.paymentStatus='Backout' then '������ �������'
                                                                   when payments.paymentStatus='Funds transfer from' then '������� ������� �� ������� �������'
                                                                   when payments.paymentStatus='Funds transfer to' then '������� ������� c ������� �������'
                                                                   when payments.paymentStatus='Refund' then '������� �������'
                                                                   when payments.paymentStatus='Refund reversal' then '������ �������� �������'
                                                                 else
                                                                  '��� ������'
                                                                 end
                                       );                                
              counter := counter + 1;
              counter2 := counter2 + 1;
            END IF;
            
            counter_PAYM := counter_PAYM + 1;
          end loop;   
          -- ���������� �������� �����    
          MERGE INTO DB_LOADER_PAYMENT_TRANSFERS PT
            USING (select substr(PL.ctn, -10) ctn
                          ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(PL.paymentDate) paymentDate
                          ,PL.paymentStatus paymentStatus
                          ,PL.paymentType paymentType
                          ,PL.paymentOriginalAmt paymentOriginalAmt
                          ,PL.paymentCurrentAmt paymentCurrentAmt
                          ,PL.bankPaymentID bankPaymentID
                          ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(PL.paymentActivateDate) paymentActivateDate
                      from API_GET_PAYMENT_LIST PL
                      WHERE INSTR(PL.paymentStatus, 'Funds transfer') > 0
                      and
                      substr(ctn, -10) in 
                                (
                                  select ctn from
                                  (
                                      select
                                              substr(PL.ctn, -10) ctn
                                              ,PL.paymentStatus paymentStatus
                                              ,NVL(bankPaymentID, 0)
                                              ,count(*) ct   
                                      from API_GET_PAYMENT_LIST PL
                                       WHERE INSTR(PL.paymentStatus, 'Funds transfer') > 0
                                  group by   substr(PL.ctn, -10), PL.paymentStatus, NVL(bankPaymentID, 0)          
                                  )
                                  where ct <= 1
                                  )
                        
                        
                        
                      ) API
              ON (PT.PHONE_NUMBER = API.ctn 
                    AND NVL(PT.BANK_PAYMENT_ID, 0) = NVL(API.bankPaymentID, 0)
                    AND PT.PAYMENT_STATUS = API.paymentStatus 
                    AND PT.ACCOUNT_ID = pACCOUNT_ID
                    AND PT.PAYMENT_ORIGINAL_AMT = API.PAYMENTORIGINALAMT
                    AND PT.PAYMENT_CURRENT_AMT = API.PAYMENTCURRENTAMT
                    
                    )
            WHEN MATCHED THEN 
              UPDATE SET
                PT.PAYMENT_DATE=API.paymentDate,
                PT.PAYMENT_TYPE=API.paymentType,
                --PT.PAYMENT_ORIGINAL_AMT=API.paymentOriginalAmt, 
                --PT.PAYMENT_CURRENT_AMT=API.paymentCurrentAmt,
                PT.PAYMENT_ACTIVATE_DATE=API.paymentActivateDate               
            WHEN NOT MATCHED THEN   
              INSERT(PT.ACCOUNT_ID, PT.PHONE_NUMBER, PT.PAYMENT_DATE, PT.PAYMENT_STATUS, PT.PAYMENT_TYPE, 
                     PT.PAYMENT_ORIGINAL_AMT, PT.PAYMENT_CURRENT_AMT, PT.BANK_PAYMENT_ID, PT.PAYMENT_ACTIVATE_DATE)   
                VALUES(pACCOUNT_ID, API.ctn, API.paymentDate, API.paymentStatus, API.paymentType, 
                       API.paymentOriginalAmt, API.paymentCurrentAmt, API.bankPaymentID, API.paymentActivateDate);   
          --�������� �������� ����������
          INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                                 IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID,BEELINE_RN)
            VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
             1, 'Ok! Add '||counter2||' rows. All '||counter_PAYM||' rows.', 1, pANSWER.BSAL_ID);
            
          commit;
            
          Respond:='Ok! Add '||counter;
          
        else 
          Respond:= pANSWER.Err_text;
        end if;  
      EXCEPTION
        WHEN OTHERS THEN
          Respond := SQLERRM;
          return (Respond);
      END;
      end loop;
    Else
      Respond:='�� ������ �\�';
    end if;
    
    Return (Respond);
  end;  
--���������� ������ ��� �� ����������
function Collect_account_BANS(
  Paccount_id in number
  ) return varchar2 is 
  --������ �� ������������� ������
  CURSOR C IS
    SELECT ACCOUNTS.LOGIN,
           ACCOUNTS.New_Pswd,
           accounts.account_number,
           accounts.account_id
     FROM ACCOUNTS
     WHERE ACCOUNTS.account_id = Paccount_id
       AND ACCOUNTS.Is_Collector = 1;        
   vREC     C%ROWTYPE;
   err varchar2(1000);--��� ����������� ��������� �� �������+
   count_rec integer:=0;
   pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);
   
   srcClob clob;
   vBuffer      VARCHAR2 (2048);
   l_amount     number;
   l_pos        number := 1;
   l_clob_len   number ;
   beg_str       int;
   end_str       int;
   beg_tag       int;
   tag           varchar2(500 char);
   v_loc         VARCHAR2(500 char);
   TYPE API_ACCOUNT_BAN_LIST_TEMP_ARR is table of API_ACCOUNT_BAN_LIST_TEMP%ROWTYPE INDEX BY BINARY_INTEGER;
   rec  API_ACCOUNT_BAN_LIST_TEMP_ARR;
   
   idx integer;
    
  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      Begin--�������� ������� ������ ��������
        --�������������
        err := '';
        --��������� ������ BAN-��
        pANSWER := BEELINE_SOAP_API_PCKG.getBANInfoList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),vREC.Login,vREC.Account_Id,'');
        -- 
        EXECUTE IMMEDIATE 'TRUNCATE TABLE API_ACCOUNT_BAN_LIST_TEMP';
        --
        /*
        INSERT INTO API_ACCOUNT_BAN_LIST_TEMP(BAN, BAN_NAME, MARKET_CODE, BAN_CURRENCY_IND)
          select extractvalue (value(d) ,'BanInfoList/ban') BAN,
                 extractvalue (value(d) ,'BanInfoList/banName') BAN_NAME,
                 extractvalue (value(d) ,'BanInfoList/marketCode') MARKET_CODE,
                 extractvalue (value(d) ,'BanInfoList/banCurrencyInd') BAN_CURRENCY_IND
            from table(XmlSequence(pANSWER.ANSWER.extract('S:Envelope/S:Body/ns0:getBANInfoListResponse/BanInfoList',
                                                          'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Subscriber"')))d;
        */
        -- 
        
        select XMLroot (pANSWER.ANSWER, VERSION '1.0').Getclobval () into srcClob from dual;
        idx := 0;
        loop
          l_amount := DBMS_LOB.INSTR ( srcClob, chr(10), l_pos, 1)-l_pos;
          exit when l_amount <= 0;
          if l_amount > 2048 then
            raise_application_error(-20001,'������ ������� ������ � �� ���������� � ������');
          end if;
                
          dbms_lob.read(srcClob, l_amount, l_pos, vBuffer);
          
          v_loc:= SUBSTR(vBuffer, 1,255);
          
          beg_str:=instr(v_loc,'>',1,1)+1;
          end_str:=instr(v_loc,'<',1,2);
          beg_tag:=instr(v_loc,'<',1,1);

          if instr(v_loc,'<',1,2)>1 then
            tag :=  SUBSTR(v_loc,beg_tag+1,beg_str-beg_tag-2);
            
            if tag='ban' then
              rec(idx).ban:=SUBSTR(v_loc,beg_str,end_str-beg_str);
            ELSIF tag='banName' then
              rec(idx).BAN_NAME:=REPLACE(SUBSTR(v_loc,beg_str,end_str-beg_str),chr(38)||'quot;','"');
            ELSIF tag='marketCode' then
              rec(idx).MARKET_CODE:=SUBSTR(v_loc,beg_str,end_str-beg_str);
            ELSIF tag='banCurrencyInd' then
              rec(idx).BAN_CURRENCY_IND := SUBSTR(v_loc,beg_str,end_str-beg_str);
                   
              --������ ��� ���� ����������� �������
              idx := idx + 1;
            end if;
          end if;       
          l_pos := l_pos + l_amount +1;
        end loop;    

        
        if idx > 0 then
          FORALL i IN 0..idx - 1
            INSERT INTO API_ACCOUNT_BAN_LIST_TEMP(
                                                  BAN,
                                                  BAN_NAME,
                                                  MARKET_CODE,
                                                  BAN_CURRENCY_IND
                                                 )
                                         VALUES (
                                                  rec(i).BAN,
                                                  rec(i).BAN_NAME,
                                                  rec(i).MARKET_CODE,
                                                  rec(i).BAN_CURRENCY_IND
                                               );
        end if;
        
        select count(*) into count_rec
          from API_ACCOUNT_BAN_LIST_TEMP;
        --
        if count_rec > 1 then --���� ����������� ������
          -- ���������� � ��������������� ������� ����� ��������
          Insert into beeline_loader_inf 
            select Paccount_id,
                   null,
                   null,
                   a_temp.ban 
            from API_ACCOUNT_BAN_LIST_TEMP a_temp
            where not exists (
                                select 1 
                                      from
                                            beeline_loader_inf bl 
                                      where
                                            bl.ban= a_temp.BAN
                                            and bl.account_id = Paccount_id
                             )
            ;
           -- �������� �� ��������������� ������� �������� ��������              
          delete from beeline_loader_inf bli 
            where bli.ban in (
                              select 
                                    to_char(bl.ban) 
                              from
                                    beeline_loader_inf bl 
                              where 
                                  bl.account_id=Paccount_id
                              minus
                              select
                                    to_char(a_temp.ban) 
                              from 
                                    API_ACCOUNT_BAN_LIST_TEMP a_temp
             );
           
           --
           MERGE INTO DB_LOADER_ACCOUNT_BAN_LIST b_list
          -- ������� ���������
            USING (
                    select 
                        BAN,
                        BAN_NAME,
                        MARKET_CODE ,
                        BAN_CURRENCY_IND
                     from API_ACCOUNT_BAN_LIST_TEMP                   
                  ) b_list_temp
                  
            ON (
                  B_LIST.ACCOUNT_ID = pAccount_id
                  and B_LIST.BAN = B_LIST_TEMP.BAN 
               )       
            WHEN MATCHED THEN
          -- ����� �����
            UPDATE SET  
                        b_list.BAN_NAME = b_list_temp.BAN_NAME,
                        b_list.MARKET_CODE = b_list_temp.MARKET_CODE ,
                        b_list.BAN_CURRENCY_IND = b_list_temp.BAN_CURRENCY_IND,
                        B_LIST.DATE_UPDATED = sysdate
   
          WHEN NOT MATCHED THEN
          -- ����� �� �����
            INSERT (
                    b_list.ACCOUNT_ID,
                    b_list.BAN,
                    b_list.BAN_NAME,
                    b_list.MARKET_CODE ,
                    b_list.BAN_CURRENCY_IND,
                    b_list.DATE_CREATED
                    )
              VALUES (
                    pAccount_id,
                    b_list_temp.BAN,
                    b_list_temp.BAN_NAME,
                    b_list_temp.MARKET_CODE ,
                    b_list_temp.BAN_CURRENCY_IND,
                    sysdate
                 )
            ;
          --- MERGE END
          -- �������� �� ������� �������� ��������
           delete from DB_LOADER_ACCOUNT_BAN_LIST bli 
            where ban in (
                              select 
                                    ban 
                              from
                                    DB_LOADER_ACCOUNT_BAN_LIST bl 
                              where 
                                  bl.account_id=Paccount_id
                              minus
                              select
                                    a_temp.ban 
                              from 
                                    API_ACCOUNT_BAN_LIST_TEMP a_temp
             );
             
           --���������
           commit;
        else 
          raise VALUE_ERROR; 
        end if;--�������� ���������� ����������� �������.
      exception
        when VALUE_ERROR then 
          err:='������ �������� ���.�/� ������ 100.'; 
        when others then 
          err:='�� ���������� �������� ������ ��������.'||SQLERRM;
      ROLLBACK;
      return err;
      end;-- ����� �������� ��������   
    end if;

  --��������, ��� ����������
    insert into account_load_logs
           ( account_load_log_id,account_id, load_date_time, is_success, error_text, account_load_type_id)
      values(s_new_account_load_log_id.nextval,Paccount_id, sysdate,
              case err when null then 1 else 0 end , nvl(err,'OK! Get '||count_rec||' rows;'),14);
    commit;
    return nvl(err,'OK!');   
  --  
  end;         
--                 
 --���������� �������� �� ������������� �/� 
function Collect_account_phone_status(
--  Paccount_id in number,
  nMOD_NUM in number default 0,--������ ������
  nMOD in number default 1,--������
  pCUR_BAN IN NUMBER DEFAULT 0,  -- 0 ������ ���� ��� ����.
  pLOAD_ONLY_NEW number default 0 --�� ��������� �������� ��� ������������� �������
  ) return varchar2 is--phone_state_table  
  cursor CBans IS
    select bl.ban, 
           bl.account_id,
           aa.LOGIN,
           aa.New_Pswd,
           aa.account_number,
           aa.is_collector
      from DB_LOADER_ACCOUNT_BAN_LIST bl,
           accounts aa
      where bl.account_id = aa.account_id(+) 
        and mod(bl.ban, nMOD) = nMOD_NUM--������� ������
        and (bl.ban = pCUR_BAN or pCUR_BAN = 0)  -- ���� ���������� ���, ���� ���
        --�������� ���� �� ����������� ������� ���� �����������
        and (
              (pLOAD_ONLY_NEW = 0 and BL.DATE_LAST_LOAD_STATUS is not null)
              OR (pLOAD_ONLY_NEW = 1 and BL.DATE_LAST_LOAD_STATUS is null)
            )
        --������� ����� , ����� �� ��� ����� �� ����������
      order by BL.DATE_LAST_LOAD_STATUS asc NULLS FIRST;
  Respond  varchar2(5000); -- �����
  pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null); 
  count_good integer:=0;
  count_bad integer:=0;
  i integer:=0;
  err varchar2(1000);--��� ����������� ��������� �� �������+
  dogovor_date date;
  vYEAR_MONTH INTEGER;
  parse_res varchar2(500);
  
begin
  BEGIN       
    for pBAN in CBans
    LOOP 
      count_good := 0;
      begin 
        pANSWER:= SOAP_API_ANSWER_TYPE(NULL, NULL,null);--������� ���������� ������
        pANSWER:=BEELINE_SOAP_API_PCKG.getCTNInfoList(BEELINE_SOAP_API_PCKG.auth(pBAN.LOGIN, pBAN.New_Pswd),'',pBAN.ban,'');
      exception
        when others then 
          pANSWER.Err_text:=sqlerrm;  
      end;    
      if pANSWER.Err_text='OK' then 
        --���������� ���������� xml � API_GET_CTN_INFO_LIST
        parse_res := GET_API_CTN_INFO_LIST_TABLE(pANSWER.ANSWER);
          
        if parse_res = cPARSE_RESULT then
          
          -- �������� ����� ���������� ������� � �����
          ARCHIVE_PCKG.ADD_REC_API_GET_CTN_INFO_LIST(pBAN.ban);                                                  
          ---��������� �������  
          vYEAR_MONTH:=TO_NUMBER(to_char(sysdate,'YYYYMM'));
          MERGE INTO db_loader_account_phones ph
          -- ���������
            USING (select substr(d.ctn, -10) acc_ctn
                         ,substr(d.ctn, -10) ctn
                         ,d.status stat
                         ,d.reasonStatus reason
                         ,d.pricePlan plan
                         ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(d.statusDate) statusDate
                         ,bsc.IS_CONSERVATION
                         ,bsc.IS_SYSTEM_BLOCK
                         ,d.subscriberHLR
                     from API_GET_CTN_INFO_LIST d
                     left outer join BEELINE_STATUS_CODE bsc on bsc.STATUS_CODE = d.reasonStatus   
                  ) api                  
              ON (ph.phone_number = api.acc_ctn 
                    and ph.year_month=vYEAR_MONTH 
                    and ph.account_id=pBAN.Account_id)        
          WHEN MATCHED THEN
          --����� �����
            UPDATE SET ph.phone_is_active=CASE  WHEN API.STAT = 'ACTIVE' THEN 1 ELSE 0 END,
                       ph.cell_plan_code=api.plan,
                       ph.last_check_date_time=sysdate,
                       ph.last_change_status_date=api.statusDate,                
                       ph.conservation = CASE WHEN API.STAT = 'ACTIVE' THEN 0 ELSE API.IS_CONSERVATION END,
                       ph.system_block = CASE WHEN API.STAT = 'ACTIVE' THEN 0 ELSE API.IS_SYSTEM_BLOCK END,
                       PH.STATUS_ID = CONVERT_PCKG.STATUS_CODE_TO_STATUS_ID(API.REASON),
                       ph.SUBSCRIBERHLR = api.subscriberHLR
              WHERE ((api.stat in('ACTIVE','BLOCKED'))
                      or (api.stat is null and ph.last_check_date_time<sysdate-1))-- ���� ����� �� ���������� ����� ����� � ����� ������ ������ ��� ���� ����� ��� �������
            -- ��������� DELETE �������� ������ ��� ��� �������, ������� ������ ��� UPDATE
            DELETE where api.ctn is null          
          WHEN NOT MATCHED THEN
          -- ����� �� �����
            INSERT (ph.account_id, ph.year_month, ph.phone_number,
                    ph.phone_is_active,
                    ph.cell_plan_code, ph.last_check_date_time, ph.organization_id,
                    ph.conservation,
                    ph.system_block,
                    PH.LAST_CHANGE_STATUS_DATE,
                    PH.STATUS_ID,
                    ph.SUBSCRIBERHLR)
              VALUES (pBAN.account_id, vYEAR_MONTH, api.ctn,
                      CASE 
                        WHEN API.STAT = 'ACTIVE' THEN 1 
                        ELSE 0 
                      END, 
                      api.plan, sysdate, 1, 
                      CASE 
                        WHEN API.STAT = 'ACTIVE' THEN 0
                        ELSE API.IS_CONSERVATION
                      END,
                      CASE 
                        WHEN API.STAT = 'ACTIVE' THEN 0
                        ELSE API.IS_SYSTEM_BLOCK
                      END,
                      api.statusDate, 
                      convert_pckg.STATUS_CODE_TO_STATUS_ID(api.reason), 
                      api.subscriberHLR)
            WHERE api.stat in ('ACTIVE','BLOCKED');
          --������� �������   
          count_good:=count_good+sql%rowcount;
            
          --������� ���������� �� ������� � beeline_loader_inf
          --������� ��� ������ �� ���� �� beeline_loader_inf
          DELETE FROM beeline_loader_inf
            WHERE BAN = pBAN.BAN;
          --  
          
          MERGE INTO BEELINE_LOADER_INF b
            USING (select 
                      substr(ctn, -10) ctn,
                      pBAN.ACCOUNT_ID ACCOUNT_ID,
                      pBAN.ban ban
                   from API_GET_CTN_INFO_LIST
                   ) api                  
              ON (b.phone_number = api.ctn)        
          WHEN MATCHED THEN
            UPDATE
              SET
                b.ACCOUNT_ID = api.ACCOUNT_ID,
                b.BAN = api.ban
          WHEN NOT MATCHED THEN
            INSERT (b.ACCOUNT_ID, b.PHONE_NUMBER, b.BAN) 
            VALUES (api.ACCOUNT_ID, api.ctn, api.ban);
/*            
          
          INSERT INTO BEELINE_LOADER_INF BL 
                  (
                    BL.ACCOUNT_ID,
                    BL.PHONE_NUMBER,
                    BL.BAN) 
          select pBAN.ACCOUNT_ID,
                 substr(ctn, -10),
                 pBAN.ban
            from API_GET_CTN_INFO_LIST;
*/           
          --������� ������ ������ �� beeline_loader_inf
          delete from beeline_loader_inf t 
            where t.phone_number is null 
              and t.account_id= pBAN.account_id 
              and t.ban= pBAN.BAN
              AND EXISTS (SELECT 1
                            FROM BEELINE_LOADER_INF Z 
                            WHERE Z.PHONE_NUMBER IS NOT NULL 
                              AND Z.ACCOUNT_ID= pBAN.ACCOUNT_ID 
                              AND Z.BAN = pBAN.BAN);
          --��������� ��������� ���� �������� �������
          update DB_LOADER_ACCOUNT_BAN_LIST t
            set DATE_LAST_LOAD_STATUS = sysdate
            where t.account_id = pBAN.account_id 
              and t.ban = pBAN.BAN;      
          --����������� � ��� �������� 
          if count_good>0 then --���� ���� ���� ����� - �������� ��� �� ������.
            insert into account_load_logs(
                     account_load_log_id, account_id, load_date_time, is_success, 
                     error_text, account_load_type_id)
              values(s_new_account_load_log_id.nextval, pBAN.account_id, sysdate, 1, 
                     'Ok! Update '||count_good||' rows,err_count='||count_bad||';'||err, 3);
          else 
            insert into account_load_logs(
                     account_load_log_id, account_id, load_date_time, is_success,  
                     error_text, account_load_type_id)
              values(s_new_account_load_log_id.nextval, pBAN.account_id , sysdate, 0, 
                     'err_count='||count_bad||',last err_txt:'||pANSWER.Err_text||';'||err, 3);
          end if;--if count_good>0 then          
          commit;--� ��� �������� � ��� �������
        end if;--if parse_res = cPARSE_RESULT then
                         
      else
        insert into aaa(nnn1, sss1, sss2)
          values(pANSWER.BSAL_ID,pANSWER.Err_text, pBAN.BAN);
        commit;
        count_bad:=count_bad+1;
      end if;--if pANSWER.Err_text='OK' then                  
    END LOOP PBAN;
  EXCEPTION
    WHEN OTHERS THEN
      Respond := SQLERRM||';'||err;
      return Respond;
  END;--api_responce
  Return Respond;        
end;--func
--
function Collect_account_phone_opts(
  Paccount_id in number
  ) return varchar2  is--phone_state_table
  type Tbans is table of varchar2(20);  
  CURSOR C IS
    SELECT LOGIN, New_Pswd, account_number, account_id, is_collector
      FROM ACCOUNTS
      WHERE account_id = Paccount_id;    
  CURSOR TECH is 
    select distinct bl.ban 
      from beeline_loader_inf bl 
      where bl.account_id=Paccount_id; 
  Bans Tbans;
  vREC C%ROWTYPE;
  Respond varchar2(5000); -- �����
  pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null); 
  count_good integer:=0;
  count_bad integer:=0;
  err varchar2(1000);
begin
  OPEN C;
  FETCH C INTO vREC;
  CLOSE C;
  IF vREC.LOGIN IS NOT NULL and vRec.Is_Collector=1 THEN
    BEGIN      
      OPEN TECH;
      FETCH TECH bulk collect into Bans;
      CLOSE TECH;
      --���� �� ��������
      for I in Bans.first..bans.last
      LOOP
        Begin
          pANSWER:=BEELINE_SOAP_API_PCKG.getServiceList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),'',bans(i),'');            
          if pANSWER.Err_text='OK' then      
            --���� �� ������
            for s in (select substr(extractvalue (value(d) ,'servicesList/ctn'),-10)ctn
                             ,trim(extractvalue (value(d) ,'/servicesList/serviceId'))   serviceId
                             ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(extractvalue(value(d) ,'/servicesList/startDate')) startDate
                             ,CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(extractvalue(value(d) ,'/servicesList/endDate')) endDate
                             ,trim(extractvalue (value(d) ,'/servicesList/serviceName')) serviceName
                        from table(XmlSequence(pANSWER.ANSWER.extract(
                               'S:Envelope/S:Body/ns0:getServicesListResponse/servicesList'
                               ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Subscriber"'))) d)
            loop
            --�������� ��������� ����� �� ������� ��������
              null;
              db_loader_pckg.ADD_ACCOUNT_PHONE_OPTION2(
                  to_char(sysdate,'YYYY'),
                  to_char(sysdate,'MM'),
                  vrec.login,
                  to_char(s.ctn), /*�����*/
                  s.serviceId,       /* ��� ����� */
                  s.serviceName,       /* ������������ ����� */
                  null, /* ��������� ����� */
                  s.startDate,          /* ���� �����������*/
                  s.endDate,         /* ���� ���������� */
                  null,        /*��������� �����������*/
                  null        /*��������� � �����*/
                  );
            end loop s;                   
            commit;
            count_good:=count_good+1;                    
          else
            insert into aaa(nnn1,sss1,sss2)values(pANSWER.BSAL_ID,pANSWER.Err_text,bans(i));commit;
            count_bad:=count_bad+1;
          end if;       
        EXCEPTION
          WHEN OTHERS THEN 
            err:=sqlerrm;
            insert into aaa(sss2)values(err||' '||bans(i)||' '||to_char(i));commit;
            count_bad:=count_bad+1;
        END;        
      END LOOP I; 
      --
      for u in (select * 
                  from db_loader_account_phones p 
                  where p.year_month=const_year_month 
                    and p.account_id=Paccount_id)
      loop
        --������� ������ ������� ��� ����� �����
        DB_LOADER_PHONE_OPRT_CLOSE2(substr(to_char(const_year_month),1,4), substr(to_char(const_year_month),5,2),u.phone_number); 
      end loop u;          
     --����������� � ��� �������� 
      if count_good>0 then --���� ���� ���� ����� - �������� ��� �� ������.
        insert into account_load_logs(account_load_log_id,account_id, load_date_time, is_success, error_text, account_load_type_id)
          values(s_new_account_load_log_id.nextval,Paccount_id, sysdate, 1, 'Ok! Update options on'||count_good||' ban''s,err_count='||count_bad, 4);
      else 
        insert into account_load_logs(account_load_log_id,account_id, load_date_time, is_success, error_text, account_load_type_id)
          values(s_new_account_load_log_id.nextval,Paccount_id, sysdate, 0, 'err_count='||count_bad||',last err_txt:'||pANSWER.Err_text, 4);
      end if;  
    EXCEPTION
      WHEN OTHERS THEN
        Respond := SQLERRM;
        return Respond;
    END;--api_responce
  Else
    Respond:='�� ������ �\�';
  end if;--vrec.login
  Return Respond;        
end;--func 
--  
Function get_ticket_status (
  pAccount_id in number,
  pRequestID in VARCHAR2
  ) return varchar2 is
    CURSOR C IS
      SELECT LOGIN, New_Pswd, account_id
        FROM ACCOUNTS
        WHERE ACCOUNT_ID=pAccount_id;    
  vREC     C%ROWTYPE;
  Respond  varchar2(5000); -- �����
  Resp_code varchar2(200);-- ����� ���
  pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);      
    
procedure update_ticket (pRespond in varchar2,pResp_code in varchar2) as 
  PRAGMA AUTONOMOUS_TRANSACTION;
  vAnswerCode Integer;
begin
  vAnswerCode := case Respond
                   when 'COMPLETE' then 1
                   when 'REJECTED' then 0
                   when 'CANCELED' then 0
                   when 'EXPIRED_REQ' then 0
                   when 'NULL' then 0
                   when 'NEED_MORE_INFORMATION' then 0
                 else
                   null
                 end;                                            
  update beeline_tickets k 
    set k.answer = vAnswerCode,
        k.comments=k.comments||' '||pResp_code||' '||Resp_code,
        k.date_update=sysdate 
    where k.ticket_id=pRequestID and pRespond is not null;             
  UPDATE USSD_CHANGE_PP_LOG PPL
    SET PPL.USSD_CHANGE_CONTRACT_STATUS_ID = vAnswerCode
    where PPL.TICKET_ID = pRequestID
      and pRespond is not null
      and nvl(PPL.USSD_CHANGE_CONTRACT_STATUS_ID, 0) = 0;   
  commit;
end; 
 
  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        pANSWER:=BEELINE_SOAP_API_PCKG.getRequestList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),pRequestID,vREC.LOGIN,pAccount_id);
        select extractValue(pANSWER.ANSWER, 'S:Envelope/S:Body/ns0:getRequestListResponse/requestList/requests/requestStatus',
                                            'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/ xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')
              ,extractValue(pANSWER.ANSWER, 'S:Envelope/S:Body/ns0:getRequestListResponse/requestList/requests/requestComments',
                                            'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/ xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')      
          into Respond,Resp_code from dual; 
--insert into beeline_soap_api_log(soap_answer) values (pANSWER.ANSWER); commit;--�������� ������ ��� �������!        
        update_ticket(Respond,Resp_code);
        /*FULFILL_REQ ��������� ��������� ������
        OPEN ������
        IN_PROGRESS � �������� ����������
        COMPLETE ��������
        AUTO_COMPLETE �������� �������������
        PARTIALLY_COMPLETE �������� ��������
        WAITING_FOR_APPROVAL ������� �������������
        NEED_MORE_INFORMATION ��������� ������ ����������
        REJECTED ��������
        NULL ������ ������
        CANCELED �����������
        PENDING � ��������
        PENDING_OPEN � �������� ��������
        PENDING_CLOSE � �������� ��������
        EXPIRED_REQ ����� ������� �������
        PERIODIC_IN_PROGRESS ����������� ������������*/        
      EXCEPTION
        WHEN OTHERS THEN
          Respond := SQLERRM;
          return (Respond);
      END;
    Else
      Respond:='�� ������ �\�';
    end if;
    Return (Respond||';'||Resp_code);
  end;  
--
FUNCTION Create_account_bill(
  PaccountId IN VARCHAR2,
  Pyear_month IN INTEGER 
  ) RETURN VARCHAR2 IS
    --
    CURSOR C IS
      SELECT LOGIN, New_Pswd, Account_Id, Account_Number
        FROM ACCOUNTS
        WHERE ACCOUNT_ID = PaccountId;
    vREC     C%ROWTYPE;
    Bill_Date date;
    V_RESULT VARCHAR2(20000);
    Respond  varchar2(5000); -- �����
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);
  BEGIN
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        begin
          select pr.end_date into Bill_Date 
            from db_loader_bills_period pr 
            where pr.account_id=PaccountId 
              and pr.year_month=Pyear_month;
        exception
          when no_data_found then 
            Return('������ �� �������� ��� ������');
        end;
        Respond:=BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd);--�������� �����
        pANSWER:=BEELINE_SOAP_API_PCKG.createBillChargesRequest(Respond,vrec.account_number,vrec.account_id,Bill_Date);--������ � ���
        --������ ������              
        select extractValue(pANSWER.ANSWER,
                            'S:Envelope/S:Body/ns0:createBillChargesRequestResponse/requestId',
                            'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')
          into V_RESULT from dual;            
        if V_RESULT is null --���� ��� ����������� ������ ������
           then --���� ����� ������
          if pANSWER.Err_text!='OK' then 
            V_RESULT:=pANSWER.Err_text;
          else
            select nvl(pANSWER.Err_text, 
                       extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:Fault/detail/ns1:UssWsApiException/errorDescription'
                                                  ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/ xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"'))
              into V_RESULT from dual; 
          end if;     
          --��� ������ ������ ���������� ������������� ������
          if V_RESULT is null then  
            raise_application_error(-20000, '������������� ������ ��.');
          --���� ����� ������ ���������� ���   
          else 
            return('Error_Api:'||V_RESULT); 
          end if;
        --���� �� � ������� � ���� �����
        else
         --���������� ������ ������ �� ��������
          insert into beeline_tickets(ticket_id, account_id, ban, ticket_type, answer, comments, phone_number,user_created,date_create)
            values(V_RESULT,vrec.account_id, vrec.account_number, 5, null, Pyear_month,null,user,sysdate);
          commit;
          --���������� ����� ������ �� ��������
          return ('������� ����� '||V_RESULT);          
        end if;
      --� ������ ���������� ���������� ������  
      EXCEPTION
        WHEN OTHERS THEN
          Respond := SQLERRM;
          return Respond;
      END;
    ELSE
      RETURN PaccountId || ' �� ������ � ���� ������.';
    END IF;
  END;
--�������� ���������� �� �����.
Function Get_account_bill (
  pAccount_id in number,
  pRequestID in number
  ) return varchar2 is
    CURSOR C IS
      SELECT LOGIN, New_Pswd, account_id
        FROM ACCOUNTS
        WHERE ACCOUNT_ID=pAccount_id;    
    bill_exception exception;
    vREC C%ROWTYPE;
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);   
  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        pANSWER:=BEELINE_SOAP_API_PCKG.getBillCharges(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),pRequestID,pAccount_id);
        if instr(pANSWER.Err_text,'OK')=0 then 
          raise bill_exception;
        end if;               
      EXCEPTION
        WHEN OTHERS THEN
          return (SQLERRM);
      END;
    Else
    Return('�� ������ �\�');
    end if;
    Return (pANSWER.BSAL_ID);
  end; 
--������� ���������� �� ������
 Function phone_report_data  (pPHONE_NUMBER in number) return varchar2 is
     --
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN, 
             ACCOUNTS.New_Pswd,
             case ACCOUNTS.Is_Collector
               when 1 then nvl(bi.ban,0)
               else ACCOUNTS.account_number
             end account_number, 
             ACCOUNTS.account_id
        FROM DB_LOADER_ACCOUNT_PHONES, 
             ACCOUNTS, 
             beeline_loader_inf bi
        WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
          and bi.phone_number(+)=DB_LOADER_ACCOUNT_PHONES.Phone_Number
          AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                       from DB_LOADER_ACCOUNT_PHONES 
                                                       where PHONE_NUMBER = pPHONE_NUMBER);    
    vREC     C%ROWTYPE;
    Respond  varchar2(5000); -- �����
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);     

    procedure upd_RD (ph in varchar2,val in number) as 
        PRAGMA AUTONOMOUS_TRANSACTION; 
    begin
      db_loader_pckg.SET_REPORT_DATA(ph, val, to_char(sysdate,'DD.MM.YYYY-HH24:MI:SS')); 
    end;       

  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        pANSWER:=BEELINE_SOAP_API_PCKG.getUnbilledBalances(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd), pPHONE_NUMBER,vREC.account_number, '');
        select extractValue(pANSWER.ANSWER,
                            'S:Envelope/S:Body/ns0:getUnbilledBalancesResponse/unbilledBalances/uc',
                            'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')     
          into Respond from dual; 
        upd_RD(pPHONE_NUMBER,to_number(replace(rtrim(Respond,chr(10)||chr(13)||chr(9)),',','.'), '9999999999.99'));
      EXCEPTION
        WHEN OTHERS THEN
          Respond := pANSWER.Err_text||CHR(13)||SQLERRM;
          return (Respond);
      END;
    Else
      Respond:='�� ������ �\�';
    end if;
    Return (Respond);
  end;  
--�������� ������� ���������� �� �/� 
function account_report_data(
  Paccount_id in number,
  n_mod in number
  ) return varchar2  is--phone_state_table 
    CURSOR C IS
      SELECT LOGIN, New_Pswd, account_number, account_id, is_collector
        FROM ACCOUNTS
        WHERE account_id = Paccount_id;    
    vREC C%ROWTYPE;
    Respond varchar2(5000); -- �����
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null); 
    count_good integer:=0;
    count_bad integer:=0;
    token varchar2(100);
begin
  OPEN C;
  FETCH C INTO vREC;
  CLOSE C;
  IF vREC.LOGIN IS NOT NULL and vRec.Is_Collector=1  THEN
    BEGIN
      token:=BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd);  
      for i in (select ph.phone_number
                  from db_loader_account_phones ph 
                  where ph.year_month=const_year_month 
                    and ph.account_id=Paccount_id
                    and mod(ph.phone_number,5)=n_mod/*������������� 5 �������*/
                  order by get_last_RD_update(ph.phone_number)) 
      loop
        pANSWER:=BEELINE_SOAP_API_PCKG.getUnbilledBalances(token,i.phone_number,Paccount_id);     
        if pANSWER.Err_text='OK' then 
          select extractValue(pANSWER.ANSWER,
                  'S:Envelope/S:Body/ns0:getUnbilledBalancesResponse/unbilledBalances/uc',
                  'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')     
            into Respond from dual; 
          db_loader_pckg.SET_REPORT_DATA(
              i.phone_number,
              to_number(replace(rtrim(Respond,chr(10)||chr(13)||chr(9)),',','.'), '9999999999.99'),
              to_char(sysdate,'DD.MM.YYYY-HH24:MI:SS')); 
          count_good:=count_good+1;                     
        else
          count_bad:=count_bad+1;
        end if;
      end loop i;       
      --����������� � ��� �������� 
      if count_good>0 then --���� ���� ���� ����� - �������� ��� �� ������.
        insert into account_load_logs(account_load_log_id,account_id, load_date_time, is_success, error_text, account_load_type_id)
          values(s_new_account_load_log_id.nextval,Paccount_id, sysdate, 1, 'Ok! Update RD count '||count_good, 6);
      else 
        insert into account_load_logs(account_load_log_id,account_id, load_date_time, is_success, error_text, account_load_type_id)
          values(s_new_account_load_log_id.nextval,Paccount_id, sysdate, 0, 'Update: err_count='||count_bad||',last err_txt:'||pANSWER.Err_text, 6);
      end if;
      commit;  
    EXCEPTION
      WHEN OTHERS THEN
        Respond := SQLERRM;
        return Respond;
    END;--api_responce
  Else
    Respond:='�� ������������� ����.'; -- �������, �.�.�� ������� ������ �� �� ������������� ����� ��������� �������
  end if;--vrec.login
  Return Respond;         
end;--func 
-- ���������� ��� ��������� �������� ����� ��� ������.
FUNCTION TURN_TARIFF_OPTION(
  pPHONE_NUMBER IN VARCHAR2,
  pOPTION_CODE IN VARCHAR2,
  pTURN_ON IN INTEGER, -- 0: ���������, 1: ��������
  pEFF_DATE IN DATE,   -- ���� ����������� ������ (NULL - ����� ������)
  pEXP_DATE IN DATE,   -- ���� ��������������� ���������� (NULL - �� ���������)
  pREQUEST_INITIATOR IN VARCHAR2 -- ��������� ������� (�� 10 ������)
  ) RETURN VARCHAR2 IS
    --
  CURSOR C IS
    SELECT ACCOUNTS.LOGIN, ACCOUNTS.New_Pswd, ACCOUNTS.Account_Id, ACCOUNTS.Account_Number
      FROM DB_LOADER_ACCOUNT_PHONES, 
           ACCOUNTS
      WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
        AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
        AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                     from DB_LOADER_ACCOUNT_PHONES 
                                                     where PHONE_NUMBER = pPHONE_NUMBER);
    --
    vREC     C%ROWTYPE;
    FIO      VARCHAR2(2000);
    V_RESULT VARCHAR2(20000);
    vTOKEN varchar2(5000); -- �����
    vINCLUSION_TYPE VARCHAR2(1);
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);
  BEGIN
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        vINCLUSION_TYPE := CASE 
                             WHEN pTURN_ON=1 THEN 'A' 
                             ELSE 'D' 
                           END;
        vTOKEN := BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd);--�������� �����
        pANSWER:=BEELINE_SOAP_API_PCKG.addDelSOC(vTOKEN, pPHONE_NUMBER, pOPTION_CODE, vINCLUSION_TYPE, pEFF_DATE, pEXP_DATE, vREC.ACCOUNT_ID);--������ � ���
        --������ ������
        select extractValue(pANSWER.ANSWER,
                  'S:Envelope/S:Body/ns0:addDelSOCResponse/return'
                  ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')
          into V_RESULT from dual;
        IF V_RESULT IS NULL THEN--���� ��� ����������� ������ ������ ���� ����� ������
          IF pANSWER.Err_text!='OK' THEN 
            V_RESULT:=pANSWER.Err_text;
          ELSE
            SELECT nvl(pANSWER.Err_text, extractValue(pANSWER.ANSWER,
                                          'S:Envelope/S:Body/ns0:Fault/detail/ns1:UssWsApiException/errorDescription'
                                          ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/ xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"'))
              into V_RESULT from dual; 
          END IF;     
          --��� ������ ������ ���������� ������������� ������
          IF V_RESULT IS NULL THEN  
            raise_application_error(-20000, '������������� ������ ������.');
          ELSE --���� ����� ������ ���������� ���
            RETURN('Error_Api:'||V_RESULT); 
          END IF;
        ELSE --���� �� � ������� � ���� �����
          --���������� � ��� 
          LOG_TARIFF_OPTIONS_REQ(pPHONE_NUMBER, pOPTION_CODE, vINCLUSION_TYPE, pEFF_DATE, pEXP_DATE, V_RESULT, pREQUEST_INITIATOR);
          --���������� ������ ������ �� ��������
          INSERT INTO BEELINE_TICKETS(TICKET_ID, ACCOUNT_ID, BAN, TICKET_TYPE, ANSWER, COMMENTS, PHONE_NUMBER,USER_CREATED,DATE_CREATE)
            VALUES(V_RESULT,vrec.account_id, vrec.account_number, 15, null, null,pPHONE_NUMBER,user,sysdate);
          COMMIT;
          --���������� ����� ������ �� �����������
          return ('������ � '||V_RESULT); 
        END IF;
      --� ������ ���������� ���������� ������  
      EXCEPTION
        WHEN OTHERS THEN
          RETURN SQLERRM;
      END;
    ELSE
      RETURN pPHONE_NUMBER || ' �� ������ � ���� ������.';
    END IF;
  END;
        
-- �������� ����������� �� ���
PROCEDURE LOAD_DETAIL_FROM_API(
  pPHONE_NUMBER IN VARCHAR2
  ) IS 
  PRAGMA AUTONOMOUS_TRANSACTION;
    --
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN, 
             ACCOUNTS.New_Pswd, 
             accounts.account_number
        FROM DB_LOADER_ACCOUNT_PHONES, 
             ACCOUNTS
        WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
          AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                       from DB_LOADER_ACCOUNT_PHONES 
                                                       where PHONE_NUMBER = pPHONE_NUMBER); 
    --
    smonth date;
    pvLOADING_MONTH varchar2(4);
    vErr_Code varchar2(30);
    vSOAP_ANSWER XMLTYPE;
    vREC C%ROWTYPE;
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null); 
    parse_res varchar2(500 char);
    ITOG VARCHAR2(500 CHAR);
    --
      PROCEDURE AUTO_UPDATE_SERVICES_API AS
      PRAGMA AUTONOMOUS_TRANSACTION; 
      begin    
        MERGE INTO SERVICES_API SA
          USING (SELECT DISTINCT UC.SERVICENAME AT_FT_DE, UC.CALLTYPE AT_FT_DESC
                   FROM API_GET_UNBILLED_CALLS_LIST UC) API
            ON (SA.AT_FT_DE = API.AT_FT_DE AND SA.AT_FT_DESC = API.AT_FT_DESC)
          WHEN MATCHED THEN
            UPDATE SET SA.DATE_UPDATE = SYSDATE
          WHEN NOT MATCHED THEN 
            INSERT(SA.AT_FT_DE, SA.AT_FT_DESC, SA.DATE_INSERT, SA.DATE_UPDATE)
              VALUES(API.AT_FT_DE, API.AT_FT_DESC, SYSDATE, SYSDATE);
        --
        COMMIT;
      end;
  --
  BEGIN
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        pANSWER:=BEELINE_SOAP_API_PCKG.getUnbilledCallsList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd), pPHONE_NUMBER,vREC.account_number, '');
        --
        parse_res:=GET_API_UNBILLED_CALLS_LIST(pANSWER.ANSWER); 
        if parse_res = cPARSE_RESULT then 
          --
          SELECT TRUNC(SYSDATE, 'MM')
            INTO smonth 
            FROM DUAL;
          --
          BEGIN
            execute immediate 'merge into CALL_' || to_char(smonth, 'mm_yyyy') || ' ct
                               using (select distinct tabs.SUBSCR_NO, tabs.START_TIME, tabs.AT_FT_CODE,
                                             tabs.DBF_ID, tabs.call_cost, tabs.costnovat, tabs.dur,
                                             tabs.IMEI, tabs.ServiceType, tabs.ServiceDirection, 
                                             tabs.IsRoaming, tabs.RoamingZone, tabs.CALL_DATE, tabs.CALL_TIME,
                                             tabs.DURATION, tabs.DIALED_DIG, tabs.AT_FT_DE, tabs.AT_FT_DESC,
                                             tabs.CALLING_NO, tabs.AT_CHG_AMT, tabs.DATA_VOL, 
                                             tabs.CELL_ID, tabs.MN_UNLIM, tabs.cost_chng, tabs.PROV_ID ROAMING_PROVIDER_ID  
                                        from table (HOT_BILLING_GET_CALL_TAB(CURSOR(SELECT *
                                                                                      FROM (SELECT :pPHONE1 SUBSCR_NO,
                                                                                                   TO_CHAR(CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(UC.callDate), ''yyyymmddhh24miss'') CH_SEIZ_DT,
                                                                                                   UC.serviceName AT_FT_CODE,
                                                                                                   DECODE(REPLACE(UC.callAmt, ''.'', '',''), ''0,0'', ''0'', REPLACE(UC.callAmt, ''.'', '','')) AT_CHG_AMT,
                                                                                                   UC.callNumber CALLING_NO,
                                                                                                   REGEXP_REPLACE(UC.callDuration, '':'', '''') DURATION,
                                                                                                   DECODE(REPLACE(UC.dataVolume, ''.'', '',''), ''0,0'', ''0'', REPLACE(UC.dataVolume, ''.'', '','')) DATA_VOL,
                                                                                                   '''' IMEI,
                                                                                                   '''' CELL_ID,
                                                                                                   DECODE(UC.callToNumber, :pPHONE2, '''', UC.callToNumber) DIALED_DIG,
                                                                                                   UC.callType AT_FT_DESC,
                                                                                                   TO_NUMBER(MS_CONSTANTS.GET_CONSTANT_VALUE (''API_DBF_ID'')) DBF_ID
                                                                                              FROM (SELECT DISTINCT CALLDATE, CALLNUMBER, CALLTONUMBER, 
                                                                                                           SERVICENAME, CALLTYPE, DATAVOLUME, CALLAMT, CALLDURATION
                                                                                                      FROM API_GET_UNBILLED_CALLS_LIST) UC ) TT
                                                                                      where TT.ch_seiz_dt is not null 
                                                                                        and trunc(to_date(TT.ch_seiz_dt, ''yyyymmddhh24miss''), ''mm'') 
                                                                                              = to_date(''' || to_char(smonth, 'dd.mm.yyyy') || ''',''dd.mm.yyyy'')), 1)) tabs
                                      ) t
                               on (ct.subscr_no = t.subscr_no 
                                    and ct.start_time = t.start_time 
                                    and to_number(ct.AT_CHG_AMT,''99999999999D99'','' NLS_NUMERIC_CHARACTERS = '''',.'''''') 
                                          = to_number(t.AT_CHG_AMT, ''99999999999D99'','' NLS_NUMERIC_CHARACTERS = '''',.'''''') 
                                    and ( (to_number(ct.DATA_VOL,''99999999999D99'','' NLS_NUMERIC_CHARACTERS = '''',.'''''') 
                                             = to_number(t.DATA_VOL,''99999999999D99'','' NLS_NUMERIC_CHARACTERS = '''',.'''''')
                                            and ct.dur=t.dur)                                 
                                          OR (t.ServiceType in (''G'', ''W''))))
                               when not matched then
                                 insert (ct.SUBSCR_NO, ct.START_TIME, ct.AT_FT_CODE, ct.DBF_ID,
                                         ct.call_cost, ct.costnovat, ct.dur, ct.IMEI, ct.ServiceType,
                                         ct.ServiceDirection, ct.IsRoaming, ct.RoamingZone, ct.CALL_DATE,
                                         ct.CALL_TIME, ct.DURATION, ct.DIALED_DIG, ct.AT_FT_DE, 
                                         ct.AT_FT_DESC, ct.CALLING_NO, ct.AT_CHG_AMT, ct.DATA_VOL, 
                                         ct.CELL_ID, ct.MN_UNLIM, ct.INSERT_DATE, ct.cost_chng,ct.ROAMING_PROVIDER_ID) 
                                   values (t.SUBSCR_NO, t.START_TIME, t.AT_FT_CODE, t.DBF_ID,
                                           t.call_cost, t.costnovat, t.dur, t.IMEI, t.ServiceType,
                                           t.ServiceDirection, t.IsRoaming, t.RoamingZone, t.CALL_DATE,
                                           t.CALL_TIME, t.DURATION, t.DIALED_DIG, t.AT_FT_DE, 
                                           t.AT_FT_DESC, t.CALLING_NO, t.AT_CHG_AMT, t.DATA_VOL,
                                           t.CELL_ID, t.MN_UNLIM, sysdate, t.cost_chng, t.ROAMING_PROVIDER_ID)
                               when matched then
                                 UPDATE 
                                   SET ct.DATA_VOL = t.DATA_VOL,
                                       ct.DUR = t.DUR
                                   where ct.ServiceType in (''G'', ''W'')
                                     and ct.ServiceType = t.ServiceType
                                     and (to_number(ct.DATA_VOL,''99999999999D99'','' NLS_NUMERIC_CHARACTERS = '''',.'''''') 
                                            <> to_number(t.DATA_VOL,''99999999999D99'','' NLS_NUMERIC_CHARACTERS = '''',.'''''')
                                          or ct.dur <> t.dur)' 
            USING pPHONE_NUMBER, pPHONE_NUMBER; 
          EXCEPTION
              WHEN OTHERS THEN
                  vErr_Code := SQLCODE;
                  --���� ����� � ������ -30926, �� ��������� ������ �� ������, ������� ��� � CALL
                  IF vErr_Code = '-30926' THEN
                      execute immediate 'insert into CALL_' || to_char(smonth, 'mm_yyyy') || ' ct
                                        select tabs.SUBSCR_NO, tabs.START_TIME, tabs.AT_FT_CODE,
                                             tabs.DBF_ID, tabs.call_cost, tabs.costnovat, tabs.dur,
                                             tabs.IMEI, tabs.ServiceType, tabs.ServiceDirection, 
                                             tabs.IsRoaming, tabs.RoamingZone, tabs.CALL_DATE, tabs.CALL_TIME,
                                             tabs.DURATION, tabs.DIALED_DIG, tabs.AT_FT_DE, tabs.AT_FT_DESC,
                                             tabs.CALLING_NO, tabs.AT_CHG_AMT, tabs.DATA_VOL, 
                                             tabs.CELL_ID, tabs.MN_UNLIM, sysdate, tabs.cost_chng, tabs.PROV_ID ROAMING_PROVIDER_ID  
                                        from table (HOT_BILLING_GET_CALL_TAB(CURSOR(SELECT *
                                                                                      FROM (SELECT :pPHONE1 SUBSCR_NO,
                                                                                                   TO_CHAR(CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(UC.callDate), ''yyyymmddhh24miss'') CH_SEIZ_DT,
                                                                                                   UC.serviceName AT_FT_CODE,
                                                                                                   DECODE(REPLACE(UC.callAmt, ''.'', '',''), ''0,0'', ''0'', REPLACE(UC.callAmt, ''.'', '','')) AT_CHG_AMT,
                                                                                                   UC.callNumber CALLING_NO,
                                                                                                   REGEXP_REPLACE(UC.callDuration, '':'', '''') DURATION,
                                                                                                   DECODE(REPLACE(UC.dataVolume, ''.'', '',''), ''0,0'', ''0'', REPLACE(UC.dataVolume, ''.'', '','')) DATA_VOL,
                                                                                                   '''' IMEI,
                                                                                                   '''' CELL_ID,
                                                                                                   DECODE(UC.callToNumber, :pPHONE2, '''', UC.callToNumber) DIALED_DIG,
                                                                                                   UC.callType AT_FT_DESC,
                                                                                                   TO_NUMBER(MS_CONSTANTS.GET_CONSTANT_VALUE (''API_DBF_ID'')) DBF_ID
                                                                                              FROM (SELECT DISTINCT CALLDATE, CALLNUMBER, CALLTONUMBER, 
                                                                                                           SERVICENAME, CALLTYPE, DATAVOLUME, CALLAMT, CALLDURATION
                                                                                                      FROM API_GET_UNBILLED_CALLS_LIST) UC ) TT
                                                                                      where TT.ch_seiz_dt is not null 
                                                                                        and trunc(to_date(TT.ch_seiz_dt, ''yyyymmddhh24miss''), ''mm'') 
                                                                                              = to_date(''' || to_char(smonth, 'dd.mm.yyyy') || ''',''dd.mm.yyyy'')), 1)) tabs
                                          where not exists
                                                  (select 1
                                                   from CALL_' || to_char(smonth, 'mm_yyyy') || ' cl
                                                   where CL.SUBSCR_NO = tabs.SUBSCR_NO
                                                   and cl.START_TIME = tabs.START_TIME
                                                   and cl.SERVICETYPE =  tabs.ServiceType)' using pPHONE_NUMBER, pPHONE_NUMBER;   
                  END IF;
          END;                             
          --                      
          DELETE_DOUBLE_DETAIL(pPHONE_NUMBER);
          commit;
          HOT_BILLING_PCKG.i_usm_PHONE(pPHONE_NUMBER, smonth);
          --
          AUTO_UPDATE_SERVICES_API;
          --            
        else
          ITOG := parse_res;
          --�������� ������
          INSERT INTO API_GET_UNBILLED_CALLS_LOG(PHONE_NUMBER, DATE_INSERT, ERROR_TEXT) 
            VALUES(pPHONE_NUMBER, SYSDATE, parse_res);
          commit;
        end if; --if parse_res = 'OK'
        --
      END;
    end if;
  END; 
--  
  function rest_info_rests(pPHONE_NUMBER varchar2) return beeline_rest_api_pckg.TRests AS
    token BEELINE_API_TOKEN_LIST.REST_TOKEN%TYPE;
    v_rests beeline_rest_api_pckg.TRests; 
  BEGIN
     token := GET_REST_API_TOKEN(pPHONE_NUMBER);
    IF token IS NOT NULL THEN
       v_rests := beeline_rest_api_pckg.info_rests(token,'','',pPHONE_NUMBER);
    end if;
    return(v_rests);
  END;  
--���������� ������ ��� ����� �� ����������� ��������
function phone_SIM(  
    pPHONE_NUMBER number
    ) return varchar2 is
     --
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN, ACCOUNTS.New_Pswd,
             (case ACCOUNTS.Is_Collector
                when 1 then nvl(bi.ban,0)
                else accounts.account_number
             end) account_number, 
             accounts.account_id,
             accounts.account_number account_number_main,
             ACCOUNTS.COMPANY_NAME
      FROM DB_LOADER_ACCOUNT_PHONES, 
           ACCOUNTS, 
           beeline_loader_inf bi
      WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
        and bi.phone_number(+)=DB_LOADER_ACCOUNT_PHONES.Phone_Number
        AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
        AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
                                                     from DB_LOADER_ACCOUNT_PHONES 
                                                     where PHONE_NUMBER = pPHONE_NUMBER);                                                           
    vREC C%ROWTYPE;
    Respond  varchar2(5000); -- �����
    ResSerialNumber varchar2(18);
    ResImsi varchar2(15);
    vCountSim INTEGER;
    oldSim varchar2(18);
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);    
  begin
    --
    select count(*)
      into vCountSim
      from phones_dop pd
      where pd.phone_number = pPHONE_NUMBER; 
    oldSim := ''; 
    if vCountSim = 1 then
      --���������� ������ ����� ��� �����
      select pd.SIM
        into oldSim
        from phones_dop pd
        where pd.phone_number = pPHONE_NUMBER;  
    end if;
    --
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    --      
    IF vREC.LOGIN IS NOT NULL THEN
      BEGIN
        --������
        pANSWER:=BEELINE_SOAP_API_PCKG.getSIMList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),'',vREC.account_number, pPHONE_NUMBER);   
        --
        if pANSWER.Err_text='OK' then                
          select extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:getSIMListResponse/SIMList/serialNumber','xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"') 
                  ,extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:getSIMListResponse/SIMList/imsi', 'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')      
          into ResSerialNumber, ResImsi from dual;           
          --���� �� ������ ������� �������������� ����������, �� ��������� ��, ����� ���������
          if vCountSim = 1 then
            --����������
            update phones_dop dp 
              set DP.SIM = ResSerialNumber, 
                   DP.BAN = vrec.account_number_main,
                   DP.NAME_BAN = vrec.COMPANY_NAME,
                   DP.datetime_sim = trunc(sysdate)                                             
              where dp.phone_number=pPHONE_NUMBER;          
            commit;      
          else
            --�������
            INSERT INTO PHONES_DOP(PHONE_NUMBER, BAN, SIM, NAME_BAN, DATETIME_SIM) 
              VALUES (pPHONE_NUMBER, vrec.account_number_main, ResSerialNumber, vrec.COMPANY_NAME, trunc(sysdate));
            commit;
          end if;  
          --
          Respond:='��!';                     
          --���������� � ��� 
          insert into REPLACE_SIM_LOG(PHONE, OLD_SIM, NEW_SIM, REP_USER, REP_DATE, ERR, BSAL_ID, SIM_LOG_TYPE_ID)
            values(pPHONE_NUMBER, oldSim, ResSerialNumber, null, null, 0, pANSWER.BSAL_ID, 2);
          commit;
        else 
          Respond:= pANSWER.Err_text;
          insert into REPLACE_SIM_LOG(PHONE, OLD_SIM, NEW_SIM, REP_USER, REP_DATE, ERR, BSAL_ID, SIM_LOG_TYPE_ID)
            values(pPHONE_NUMBER, oldSim, null, null, null, 4, pANSWER.BSAL_ID, 2);
          commit;
        end if;
        -- 
      EXCEPTION
        WHEN OTHERS THEN
          Respond := pANSWER.Err_text||CHR(13)||SQLERRM;
          insert into REPLACE_SIM_LOG(PHONE, OLD_SIM, NEW_SIM, REP_USER, REP_DATE, ERR, BSAL_ID, SIM_LOG_TYPE_ID)
            values(pPHONE_NUMBER, oldSim, null, null, null, 2, pANSWER.BSAL_ID, 2);
          commit;
          return (Respond);
      END;
    ELSE
      Respond:='�� ������ �\�';
      insert into REPLACE_SIM_LOG(PHONE, OLD_SIM, NEW_SIM, REP_USER, REP_DATE, ERR, BSAL_ID, SIM_LOG_TYPE_ID)
        values(pPHONE_NUMBER, oldSim, null, null, null,1,null, 2);
      commit;
    END IF;   
    return (Respond);    
  end;  
--��������� ������ �������� �������� �� ����
function account_phone_SIM(
  Paccount_id number
  ) return varchar2 is
    CURSOR C IS
      SELECT LOGIN, New_Pswd, account_number, account_id, is_collector
      FROM ACCOUNTS
      WHERE account_id = Paccount_id;      
    vREC C%ROWTYPE;
    Respond  varchar2(5000); -- �����
    pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null); 
    vLoad integer; --1 - �������� ��������, ����� 0
  begin
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL and vRec.Is_Collector=0 or vRec.Is_Collector is null THEN
      BEGIN
        pANSWER:=BEELINE_SOAP_API_PCKG.getSIMList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),'',vREC.account_number);        
        --  
        if pANSWER.Err_text='OK' then    
          --             
          DELETE FROM API_GET_SIM_LIST;
          --
          INSERT INTO API_GET_SIM_LIST(ctn, serialNumber, IMSI)
            SELECT 
              extractvalue (value(d) ,'/SIMList/ctn') ctn,
              extractvalue (value(d) ,'/SIMList/serialNumber') serialNumber,
              extractvalue (value(d) ,'/SIMList/imsi') imsi
            FROM TABLE(XmlSequence(pANSWER.ANSWER.extract('S:Envelope/S:Body/ns0:getSIMListResponse/SIMList'
                                                            ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Subscriber"'))) D;
          --           
          MERGE INTO db_loader_SIM ms
            -- ������� ���������
            USING (select 
                         substr(d.ctn, -10) ctn
                         ,d.serialNumber serialNumber
                         ,d.imsi imsi       
                       from API_GET_SIM_LIST d               
                      ) api
              ON (ms.phone_number = api.ctn
                    and ms.account_id=Paccount_id)                
            WHEN MATCHED THEN
            -- ����� �����
              UPDATE SET ms.sim_number = api.serialNumber, ms.imsi_number = api.imsi 
            WHEN NOT MATCHED THEN
            -- ����� �� �����
              INSERT (ms.account_id, ms.phone_number, ms.sim_number, ms.imsi_number)
                VALUES (Paccount_id, api.ctn, api.serialNumber, api.imsi);
            --- MERGE END   
          Respond:='Update '||sql%rowcount;
          -- ������ ������, ������� �������� �/�, �.�. ���� � DB_LOADER_SIM, �� ��� � �������� �� ���
          DELETE 
            FROM DB_LOADER_SIM ms
            WHERE ms.ACCOUNT_ID = pACCOUNT_ID
              AND ms.PHONE_NUMBER NOT IN (select substr(d.ctn, -10) ctn                         
                                            from API_GET_SIM_LIST d);
          --������� �������� ��������
          vLoad := 1;
          --����������� � ��� �������� 
          insert into account_load_logs(account_load_log_id, account_id, load_date_time, is_success, error_text, account_load_type_id)
            values(s_new_account_load_log_id.nextval, Paccount_id, sysdate, 1, 'Ok!'||Respond, 23);         
          if sql%rowcount>0 then 
            commit;
          end if;
        else 
          Respond:= pANSWER.Err_text;
          vLoad := 0; --������ ��������
        end if;
      EXCEPTION
        WHEN OTHERS THEN
          Respond := SQLERRM;
          vLoad := 0; --������ ��������
          --return Respond;
      END;--api_responce
    Else
      Respond:='�� ������ �\�';
      vLoad := 0; --������ ��������
    end if;--vrec.login    
    --���� ���� ������ ��������, �� ���������� �� � ��� �������� �� �/�
    if vLoad = 0 then
      insert into account_load_logs(account_load_log_id, account_id, load_date_time, is_success, error_text, account_load_type_id)
        values(s_new_account_load_log_id.nextval, Paccount_id, sysdate, 0, 'Error!'||Respond, 23);      
      commit;
    end if;
    Return Respond;   
  end;--func
--��������� ������ �������� �������� �� ���� �����������
function Collect_account_phone_SIM(
  Paccount_id number
  ) return varchar2 is
  CURSOR C IS
    SELECT LOGIN, New_Pswd, account_number, account_id, is_collector
    FROM ACCOUNTS
    WHERE ACCOUNTS.account_id = Paccount_id;    
  type tBAN is table of varchar2(30) INDEX BY binary_integer;
  BANs tBAN;
  vREC     C%ROWTYPE;
  Respond  varchar2(5000); -- �����
  pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null); 
  count_good integer:=0;
  count_bad integer:=0;
  i integer:=0;
  err varchar2(1000);--��� ����������� ��������� �� �������+
  dogovor_date date;
  vres varchar2(1000);
  vLoad integer; --1 - �������� ��������, ����� 0  
begin
  --���������� BAN
  vRes := BEELINE_API_PCKG.Collect_account_BANS(Paccount_id);
  --
  OPEN C;
  FETCH C INTO vREC;
  CLOSE C;
  IF vREC.LOGIN IS NOT NULL and vRec.Is_Collector=1 THEN
    BEGIN    
       --���� ������ ����� �� ����
      for old_ban in (select bl.ban 
                        from beeline_loader_inf bl, 
                                db_loader_account_phones ph 
                        where --�����
                              bl.phone_number=ph.phone_number(+)
                          and ph.year_month(+)=const_year_month--J O I N ��� ������ ������                         
                           --�����
                          and bl.account_id=Paccount_id          
                           --������� ����� , ����� �� ��� ����� �� ����������
                        group by bl.ban
                        order by max(ph.last_check_date_time) asc NULLS FIRST)
      loop
        i:=i+1;
        bans(i):=old_ban.ban;
      end loop; 
      --    
      for PBAN in bans.first .. bans.last
      LOOP 
        begin 
          pANSWER:= SOAP_API_ANSWER_TYPE(NULL, NULL,null);--������� ���������� ������
          pANSWER:=BEELINE_SOAP_API_PCKG.getSIMList(BEELINE_SOAP_API_PCKG.auth(vREC.LOGIN, vREC.New_Pswd),'',bans(PBAN));      
        exception
          when others then 
            pANSWER.Err_text:=sqlerrm;  
        end;    
        --
        if pANSWER.Err_text='OK' then 
          ---���������            
          DELETE FROM API_GET_SIM_LIST;
          --
          INSERT INTO API_GET_SIM_LIST(ctn, serialNumber, IMSI)
            SELECT 
              extractvalue (value(d) ,'/SIMList/ctn') ctn,
              extractvalue (value(d) ,'/SIMList/serialNumber') serialNumber,
              extractvalue (value(d) ,'/SIMList/imsi') imsi
            FROM TABLE(XmlSequence(pANSWER.ANSWER.extract('S:Envelope/S:Body/ns0:getSIMListResponse/SIMList'
                                                            ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Subscriber"'))) D;
          --
          MERGE INTO db_loader_sim ms
            -- ���������
            USING (select 
                         substr(d.ctn, -10) acc_ctn
                         ,substr(d.ctn, -10) ctn
                         ,d.serialNumber serialNumber
                         ,d.imsi imsi 
                     from API_GET_SIM_LIST d) api                  
              ON (ms.phone_number = api.acc_ctn 
                    and ms.account_id=Paccount_id)        
            WHEN MATCHED THEN
            --����� �����
              UPDATE SET ms.sim_number = api.serialNumber, ms.imsi_number = api.imsi
              -- ��������� DELETE �������� ������ ��� ��� �������, ������� ������ ��� UPDATE
              DELETE where api.ctn is null          
            WHEN NOT MATCHED THEN
            -- ����� �� �����
            INSERT (ms.account_id, ms.phone_number, ms.sim_number, ms.imsi_number)
              VALUES (Paccount_id, api.ctn, api.serialNumber, api.imsi);
          --������� �������   
          count_good:=count_good+sql%rowcount;  
          --������� ������ ������ �� beeline_loader_inf
          delete from beeline_loader_inf t 
            where t.phone_number is null 
              and t.account_id=Paccount_id 
              and t.ban=bans(PBAN)
              AND EXISTS (SELECT 1
                                  FROM BEELINE_LOADER_INF Z 
                                  WHERE Z.PHONE_NUMBER IS NOT NULL 
                                  AND Z.ACCOUNT_ID=PACCOUNT_ID 
                                  AND Z.BAN=BANS(PBAN));  
          commit;   
        else    
          --��� ������ ��� �������� (��� �������������)       
          insert into aaa(nnn1,sss1,sss2) 
            values(pANSWER.BSAL_ID,pANSWER.Err_text,bans(PBAN));   
          commit;       
          count_bad:=count_bad+1;
        end if;               
      END LOOP PBAN;
      vLoad := 1; 
     --����������� � ��� �������� 
      if count_good>0 then --���� ���� ���� ����� - �������� ��� �� ������.
        insert into account_load_logs(account_load_log_id, account_id, load_date_time, is_success, error_text, account_load_type_id)
          values(s_new_account_load_log_id.nextval, Paccount_id, sysdate, 1, 'Ok! Update '||count_good||' rows,err_count='||count_bad||';'||err, 23);
      else 
        insert into account_load_logs(account_load_log_id, account_id, load_date_time, is_success, error_text, account_load_type_id)
          values(s_new_account_load_log_id.nextval, Paccount_id, sysdate, 0, 'err_count='||count_bad||',last err_txt:'||pANSWER.Err_text||';'||err, 23);
      end if;
     commit;
    EXCEPTION
      WHEN OTHERS THEN
        Respond := SQLERRM||';'||err;
      vLoad := 0; --������ ��������
        --return Respond;
    END;--api_responce
  else
    Respond:='�� ������ �\�';
    vLoad := 0; --������ ��������
  end if;--vrec.login  
  --���� ���� ������ ��������, �� ���������� �� � ��� �������� �� �/�
  if vLoad = 0 then
    insert into account_load_logs(account_load_log_id, account_id, load_date_time, is_success, error_text, account_load_type_id)
      values(s_new_account_load_log_id.nextval, Paccount_id, sysdate, 0, 'Error!'||Respond, 23);      
    commit;
  end if;
  Return Respond;        
end;--function

--
--�������� ������ �� ����� ��������� �����
--
function changePP (pPHONE_NUMBER NUMBER, pNEWTariffCode varchar2, pFutureDate varchar2 default 'N' )
    RETURN VARCHAR2  IS
  --
  CURSOR C
  IS
     SELECT ACCOUNTS.LOGIN,
            ACCOUNTS.New_Pswd,
            (CASE ACCOUNTS.Is_Collector
                WHEN 1 THEN NVL (bi.ban, 0)
                ELSE accounts.account_number
             END)
               account_number,
            accounts.account_id,
            accounts.account_number account_number_main,
            ACCOUNTS.COMPANY_NAME
       FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS, beeline_loader_inf bi
      WHERE     DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
            AND bi.phone_number(+) =
                   DB_LOADER_ACCOUNT_PHONES.Phone_Number
            AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
            AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH =
                   (SELECT MAX (YEAR_MONTH)
                      FROM DB_LOADER_ACCOUNT_PHONES
                     WHERE PHONE_NUMBER = pPHONE_NUMBER);

  vREC              C%ROWTYPE;
  Respond           VARCHAR2 (5000);                              -- �����
  pANSWER           SOAP_API_ANSWER_TYPE
                       := SOAP_API_ANSWER_TYPE (NULL, NULL, NULL);
  vRequestId varchar2(50);
BEGIN
  --
  OPEN C;

  FETCH C INTO vREC;

  CLOSE C;

  --
  IF vREC.LOGIN IS NOT NULL THEN
    BEGIN
      --������
      --��������� ����� �� ����������� � ����������� ������ ����� API
      -- ���� ��������, �� ������ ����� � �� ���� ���, �� ����� �� �������(��� �� ������� �� ������ ����)
      pANSWER :=
         BEELINE_SOAP_API_PCKG.changePP (
            BEELINE_SOAP_API_PCKG.auth (vREC.LOGIN, vREC.New_Pswd),
            '',
            pPHONE_NUMBER,
            vREC.account_id,
            pNEWTariffCode,
            pFutureDate
            );

      --dbms_output.put_line ('pANSWER.BSAL_ID = '||pANSWER.BSAL_ID||' pANSWER.Err_text='||pANSWER.Err_text );
      --
      IF pANSWER.Err_text = 'OK'THEN
        SELECT EXTRACTVALUE (
                   pANSWER.ANSWER,
                   'S:Envelope/S:Body/ns0:changePPResponse/requestId',
                   'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"')
           INTO vRequestId
        FROM DUAL;
        --
        
        --���������� ������ ������ �� ��������
        INSERT INTO beeline_tickets (
                  ticket_id, account_id, ban, ticket_type, 
                  answer, comments, phone_number, user_created, date_create)
          VALUES (vRequestId, vREC.account_id, vREC.account_number, 22, -- ������ �� ����� ��������� ����� 
                  NULL, NULL, pPHONE_NUMBER, USER, SYSDATE);      
        Respond := '��!'||vRequestId;

        COMMIT;
      ELSE
        Respond := pANSWER.Err_text;
      END IF;
    --
    EXCEPTION
      WHEN OTHERS THEN
        Respond := pANSWER.Err_text || CHR (13) || SQLERRM;
        COMMIT;
        RETURN (Respond);
    END;
  ELSE
    Respond := '�� ������ �\�';
    COMMIT;
  END IF;
  RETURN (Respond);
end;

function mcBalance(
  pPHONE_NUMBER varchar2
  ) return beeline_rest_api_pckg.TRestsMCBalance AS   
    token BEELINE_API_TOKEN_LIST.REST_TOKEN%TYPE;
    v_rests beeline_rest_api_pckg.TRestsMCBalance; 
BEGIN  
  token := GET_REST_API_TOKEN(pPHONE_NUMBER);
  IF token IS NOT NULL THEN
    v_rests := beeline_rest_api_pckg.mcBalance(token, '', '', pPHONE_NUMBER);
  end if;
  return(v_rests);
END;

procedure Collect_account_phone_opts_st(
  p_STREAM_ID in integer, 
  pCountSTREAM in integer
  ) is
  
  pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);
  Respond          varchar2(5000); -- �����
  err_int          integer;
  err              varchar2(1000);
  bn               number;
  srcClob          clob;
  idx              integer;
  l_amount         number;
  l_pos            number := 1;
  vBuffer          VARCHAR2 (2048);
  v_loc            VARCHAR2(255 char);
  beg_str          int;
  end_str          int;
  beg_tag          int;
  tag           varchar2(255 char);
  Zag           varchar2(255 char);
  
  type TServiceList is  record
  (
   ctn VARCHAR2(10 CHAR),
   serviceId  VARCHAR2(30 CHAR),
   startDate DATE,
   endDate   DATE,
   serviceName   VARCHAR2(200 CHAR)
  );
    
  TYPE TServiceTable is table of TServiceList INDEX BY BINARY_INTEGER;
  rec  TServiceTable;
begin  
  begin
    for i in (select distinct bal.ban, bal.account_id, ac.LOGIN, ac.New_Pswd
                from DB_LOADER_ACCOUNT_BAN_LIST bal, 
                     ACCOUNTS ac
                where bal.account_id = ac.account_id 
                  and ac.LOGIN IS NOT NULL 
                  and ac.Is_Collector = 1 
                  and mod(bal.ban, pCountSTREAM)= p_STREAM_ID)
    loop
      begin
        idx := 0;
        err_int := 0;
        l_pos := 1;
        bn := i.ban;
        rec.DELETE;
        --������ �����        
        pANSWER := BEELINE_SOAP_API_PCKG.getServiceList(BEELINE_SOAP_API_PCKG.auth(i.LOGIN, i.New_Pswd),'',i.ban,'');
        --���� ����� �����������
        if pANSWER.Err_text='OK' then
          --������������ ������� xml
          select XMLroot (pANSWER.ANSWER, VERSION '1.0').Getclobval () into srcClob from dual;
          --
          loop
            l_amount := DBMS_LOB.INSTR (srcClob, chr(10), l_pos, 1) - l_pos;
            exit when l_amount <= 0;

            if l_amount > 2048 then
              raise_application_error(-20001,'������ ������� ������ � �� ���������� � ������');
            end if;
            dbms_lob.read(srcClob, l_amount, l_pos, vBuffer);
            v_loc:= SUBSTR(vBuffer, 1,255);
            beg_str:=instr(v_loc,'>',1,1)+1;
            end_str:=instr(v_loc,'<',1,2);
            beg_tag:=instr(v_loc,'<',1,1);

            Zag :=  SUBSTR(v_loc,beg_tag+1,beg_str-beg_tag-2);
            if Zag = 'servicesList' then
              idx :=  idx + 1;  
            end if;
            
            if instr(v_loc,'<',1,2)>1 then
              tag :=  SUBSTR(v_loc,beg_tag+1,beg_str-beg_tag-2);
              err := SUBSTR(v_loc, beg_str, end_str-beg_str);
              
              if tag='ctn' then
                rec(idx).ctn := err;
              ELSIF tag='serviceId' then
                rec(idx).serviceId := err;
              ELSIF tag='startDate' then
                rec(idx).startDate := CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(err);
              ELSIF tag='endDate' then
                rec(idx).endDate := CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(err);
              ELSIF tag='serviceName' then
                rec(idx).serviceName := err;
              end if;
              
              /*case  tag 
                when 'ctn' then
                  rec(idx).ctn := err;
                when 'serviceId' then
                  rec(idx).serviceId := err;
                when 'startDate' then
                  rec(idx).startDate := CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(err);
                when 'endDate' then
                  rec(idx).endDate := CONVERT_PCKG.TIMESTAMP_TZ_TO_DATE(err);
                when 'serviceName' then
                  rec(idx).serviceName := err;
              end case;*/
            end if;   
                
            l_pos := l_pos + l_amount +1;
          end loop;    

          if idx > 0 then
            FOR ww IN 1..rec.LAST 
            LOOP
              begin
                db_loader_pckg.ADD_ACCOUNT_PHONE_OPTION2(
                                                       to_char(sysdate,'YYYY'),
                                                       to_char(sysdate,'MM'),
                                                       i.login,
                                                       to_char(rec(ww).ctn),          /* �����*/
                                                       rec(ww).serviceId,             /* ��� ����� */
                                                       rec(ww).serviceName,           /* ������������ ����� */
                                                       null,                         /* ��������� ����� */
                                                       rec(ww).startDate,             /* ���� �����������*/
                                                       rec(ww).endDate,               /* ���� ���������� */
                                                       null,                         /* ��������� �����������*/
                                                       null                          /* ��������� � �����*/
                                                       );
                                                       
              exception
                when others then
                 null;  
              end;
            end loop;                                                        
          end if;
          commit;
          err_int := 1;
        end if;
        
        for u in (
                      select distinct P.PHONE_NUMBER 
                        from BEELINE_LOADER_INF p
                      where P.BAN = i.ban
                   )
        loop
          --������� ������ ������� ��� ����� �����
          begin
            DB_LOADER_PHONE_OPRT_CLOSE2(substr(to_char(const_year_month),1,4), substr(to_char(const_year_month),5,2),u.phone_number);
          exception
            when others then
              null;  
          end;
        end loop u;

        --����������� � ��� ��������
        if err_int = 1 then --���� ����� - �������� ��� �� ������.
          err := 'Ok! Update options on '||i.ban||' ban';
        else
          err := 'Error! Options on '||i.ban||' ban';
        end if;
          
        insert into account_load_logs(account_load_log_id,account_id, load_date_time, is_success, error_text, account_load_type_id, ban)
          values(s_new_account_load_log_id.nextval,i.account_id, sysdate, err_int, err, 4, i.ban);
        commit;       
      EXCEPTION
        WHEN OTHERS THEN
          err:=sqlerrm;
          --��������
          insert into ACCOUNT_LOAD_LOGS (account_load_log_id, account_id, load_date_time, is_success, error_text, account_load_type_id, ban)
            values (s_new_account_load_log_id.nextval, i.account_id, sysdate, 0, err, 4, i.ban);
        commit;
      END;                        
    end loop;          
  EXCEPTION
    WHEN OTHERS THEN
      Respond := SQLERRM;
      --��������
      insert into ACCOUNT_LOAD_LOGS (account_load_log_id, load_date_time, is_success, error_text, account_load_type_id)
        values (s_new_account_load_log_id.nextval, sysdate, 0, Respond, 4);
      commit;  
  end; 
end;    
 
BEGIN
  --Initialization
  --�����
  const_year_month:=to_number(to_char(sysdate,'YYYYMM')); 
end;