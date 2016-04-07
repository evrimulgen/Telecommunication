CREATE OR REPLACE PROCEDURE GET_BEELINE_TOKEN (pACCOUNT_ID INTEGER DEFAULT NULL) IS
-- VERSION=4
-- v4. 01.10.2015 ������� �. - �������� ��������� ������ ������ � ������ ������ ����������. 
-- v3. 14.08.2015 ������� �.- ���������� ����������� �������� �������.
-- v2. 30.07.2015 ������� �.- ��� ������ �� ������� � �������,
-- v1. 28.07.2015 ������� �.- ����� � ��������� ��������� ����� ���������� ������ � ����� �������� ���������� ������ �� ����������� ����������� �������, 
                           -- � ����� ��������� ������ � �����. 
--
-- ��������, ����������� ������  
-- ������������ BEELINE_SOAP_API_PCKG.getCTNInfoList ��� �������� ����������������� ������, ���� ����� �������� � ����������� �������, �� ��������� ����� � �����
--declare
  vTOKEN        varchar2(500 CHAR); 
  dat_f number; 
  vResp_date_change  varchar2(200 char);
  
  pREQUEST_TEXT varchar2(1000 CHAR);
  token  varchar2(500 CHAR);
  
    
  vERR_CODE VARCHAR2(50 char);
  vERR_MESSAGE  VARCHAR2(200 char);
    
  pANSWER SOAP_API_ANSWER_TYPE := SOAP_API_ANSWER_TYPE(NULL, NULL,null);
  vPHONE_NUMBER varchar2(15 char);   
  vLAST_UPDATE_TOKEN DATE;
  
  PROCEDURE SET_TOKEN_VALID (pLOGIN VARCHAR2, pIS_VALID INTEGER, pTOKEN VARCHAR2 DEFAULT NULL, 
  pACCOUNT_ID INTEGER,  pTOKEN_REQUEST VARCHAR2, pTOKEN_ANSWER XMLTYPE DEFAULT NULL) IS    
  -- ��������� ��������� ����� �� ���������� ������. ���� �� ������ �� ���������� ������, �� ��������� �.
  BEGIN
   IF pIS_VALID <> 2 THEN
    IF TRIM(pTOKEN) IS NOT NULL THEN 
      UPDATE beeline_api_token_list t 
         SET t.token = pTOKEN 
           , t.last_update = sysdate
           , t.IS_VALID = pIS_VALID
       WHERE t.acc_log = pLOGIN
      ;
    ELSE
      UPDATE beeline_api_token_list t 
         SET t.last_update = sysdate
           , t.IS_VALID = pIS_VALID
       WHERE t.acc_log = pLOGIN
      ;
    END IF;
    
    IF ( sql%rowcount = 0 ) THEN
      INSERT INTO beeline_api_token_list(ACC_LOG, TOKEN, LAST_UPDATE, IS_VALID)
        VALUES (pLOGIN, pTOKEN, sysdate, pIS_VALID );
    END IF;
    COMMIT;
   END IF; 
    --���������� ���
    BEGIN 
        INSERT INTO GET_BEELINE_TOKEN_LOG(DATE_SEND, ACCOUNT_ID, IS_VALID, TOKEN_REQUEST, TOKEN_ANSWER)
           VALUES (sysdate, pACCOUNT_ID, pIS_VALID, pTOKEN_REQUEST, pTOKEN_ANSWER);
        COMMIT;
    EXCEPTION
      WHEN OTHERS THEN 
        null;
    END;        
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, '��� ������� ��� ���������� ������ ������ � ������� BEELINE_API_TOKEN_LIST �������� ������!');
  END; 
           
  FUNCTION IS_BROKEN_ERROR(pANS SOAP_API_ANSWER_TYPE) RETURN INTEGER
  IS    
  -- ���������, ����������� �� ������ ��� ������ ��� ���. 
  -- 0 - �� ���������, 1 - ���������!
  -- ����� ��������� ������ � ����������, ���� �� ��� ���
    vRES BOOLEAN;
    vIS_BREAK INTEGER;
    vERR_CODE VARCHAR2(50 char);
    vERR_MESSAGE  VARCHAR2(200 char);
  BEGIN
    SELECT 
           extractValue(pANS.ANSWER,'S:Envelope/S:Body/ns0:Fault/detail/ns1:UssWsApiException/errorDescription'
                              ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types"'
                       ),
           extractValue(pANS.ANSWER,'S:Envelope/S:Body/ns0:Fault/detail/ns1:UssWsApiException/errorCode'

                                   ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types"'
                       ) 
      INTO vERR_MESSAGE, vERR_CODE
      FROM dual
    ;
      
    SELECT BS.IS_BREAK_TOKEN
      INTO vIS_BREAK  
      FROM BEELINE_SOAP_API_ERR BS
     WHERE UPPER( TRIM(BS.ERR_CODE) ) = UPPER( TRIM(vERR_CODE) )
    ; 
    RETURN NVL(vIS_BREAK, 0);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    -- ������ � ����������� ��� ����� ������. ����������� ��� ������ � ����� ������ � ��������� � ����������. 
      IF vERR_CODE IS NOT NULL or vERR_MESSAGE IS NOT NULL THEN 
        INSERT INTO BEELINE_SOAP_API_ERR(ERR_CODE, ERR_ENG_TEXT ) VALUES (vERR_CODE, vERR_MESSAGE );
        COMMIT;
      END IF;     
      RETURN 0;
  END;

  FUNCTION  GET_NEW_TOKEN_FROM_SITE(pLOGIN varchar2, pPASSWORD varchar2) RETURN varchar2
  -- ������� ��������� ������ � ����� ������
  IS
    retxml  XMLTYPE;
    v_TOKEN  varchar2(500 CHAR); 
    soap_text varchar2(32767);
    env       CLOB; 
    http_req  utl_http.req; 
    http_resp utl_http.resp;     
  BEGIN
    soap_text:='<?xml version="1.0" encoding="utf-8"?>
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:uss-wsapi:Auth">
        <soapenv:Header/>
        <soapenv:Body>
          <urn:auth>
            <login>'||pLOGIN||'</login>
            <password>'||pPASSWORD||'</password>
          </urn:auth>
        </soapenv:Body>
      </soapenv:Envelope>';
             
    --� �������� ������������� ��������� ���������� HTTP 'file:C:\OracleClient32'
    UTL_HTTP.set_wallet(ms_params.GET_PARAM_VALUE('SSL_WALLET_DIR'), '082g625p4Y412sD');
    v_TOKEN:=ms_constants.GET_CONSTANT_VALUE('BEELINE_SOAP_API_URL')||'/AuthService'; 
    http_req:= utl_http.begin_request(v_TOKEN, 'POST','HTTP/1.1'); 
    utl_http.set_body_charset(http_req, 'UTF-8'); 
    utl_http.set_header(http_req, 'Content-Type', 'text/xml'); 
    utl_http.set_header(http_req, 'Content-Length', length(soap_text)); 
    utl_http.set_header(http_req, 'SOAPAction', 'https://uatssouss.beeline.ru:443/api/AuthService/urn:uss-wsapi:Auth:AuthInterface:authRequest'); 
    utl_http.write_text(http_req, soap_text); 
    http_resp := utl_http.get_response(http_req); 
    utl_http.read_text(http_resp, env); 
    utl_http.end_response(http_resp);
                
    IF http_resp.status_code = 200 THEN
      retxml := sys.xmltype.createxml(env); 
      SELECT extractValue(retxml,'S:Envelope/S:Body/ns0:authResponse/return','xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Auth"') 
        INTO v_TOKEN 
        FROM dual;
    END IF;  
    RETURN v_TOKEN;
  END;

      
BEGIN 
  dat_f := TO_NUMBER(TO_CHAR(sysdate,'yyyymm'));   
  
  FOR rec IN (SELECT account_id, LOGIN, NEW_PSWD password, account_number  
                FROM accounts ac
                    ,beeline_api_token_list ba
               WHERE 
--                     AC.ACCOUNT_ID NOT IN (125)  -- ����� ������� �����
--                 AND 
                     (AC.ACCOUNT_ID = pACCOUNT_ID OR pACCOUNT_ID IS NULL)
                 AND TRIM(AC.NEW_PSWD) IS NOT NULL 
                 AND AC.LOGIN = BA.ACC_LOG (+)
                 AND AC.ACCOUNT_ID <> 98
              ORDER BY nvl(BA.IS_VALID, 0)  -- ����� � ������ ������� ������� �������� ������
             )
  LOOP
    BEGIN 
     
      pANSWER       := SOAP_API_ANSWER_TYPE(NULL, NULL,null); 
      TOKEN         := null;
      pREQUEST_TEXT := null;
      vPHONE_NUMBER := null;
      
      SELECT DB.PHONE_NUMBER           
        INTO vPHONE_NUMBER    
        FROM DB_LOADER_ACCOUNT_PHONES DB               
       WHERE db.year_month = dat_f
         AND DB.ACCOUNT_ID = rec.account_id
        -- AND DB.PHONE_IS_ACTIVE = 1
         AND rownum<=1 
         --AND db.phone_number = '9687711133'
         ;
    
      
        pANSWER := BEELINE_SOAP_API_PCKG.getCTNInfoList(BEELINE_SOAP_API_PCKG.auth(rec.LOGIN, rec.password), vPHONE_NUMBER, rec.account_number, ''); 
          
        TOKEN := BEELINE_SOAP_API_PCKG.auth(rec.LOGIN, rec.password);
          
        pREQUEST_TEXT := 'BEGIN BEELINE_SOAP_API_PCKG.getCTNInfoList(BEELINE_SOAP_API_PCKG.auth('''||rec.LOGIN||''', '''||rec.password||'''), '''||vPHONE_NUMBER||''', '''||rec.account_number||''', ''''); END; TOKEN - '||token||'';
        
      --  IF (TRIM(pANSWER.ANSWER.GETSTRINGVAL()) is null  or pANSWER.ANSWER is null)then
      --    SET_TOKEN_VALID(rec.login, 2, null, rec.account_id, pREQUEST_TEXT||' ������ ������ �����', pANSWER.ANSWER);
      --  end if;

        SELECT 
          extractValue(
              pANSWER.ANSWER,
               'S:Envelope/S:Body/ns0:getCTNInfoListResponse/CTNInfoList/statusDate'
               ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types" xmlns:ns0="urn:uss-wsapi:Subscriber"'
          )   
          INTO vRESP_DATE_CHANGE    
          FROM dual
        ;
          
        IF TRIM(vRESP_DATE_CHANGE) IS NULL THEN  -- ������ �� ������, ������ � ������ ������ ����� ������, �������� ����������, ����� ���������� ��������� ������
          RAISE_APPLICATION_ERROR(-20000, '� ������ �� ������ ������ ������'); 
        ELSE
          -- ���� ������� ������ ��� ������, ������ ����� �������. ���������� ���� ����. 
          SET_TOKEN_VALID(rec.login, 1, null, rec.account_id, pREQUEST_TEXT||' '||pANSWER.Err_text, pANSWER.ANSWER);      
        END IF;      
    EXCEPTION
      -- ���� �������� ������, ������� ��� �� ������ 
      WHEN others THEN 
        IF REC.ACCOUNT_ID <> 125 THEN -- ���� �� ������ ��
          SELECT 
               extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:Fault/detail/ns1:UssWsApiException/errorDescription'
                                  ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types"'
                           ),
               extractValue(pANSWER.ANSWER,'S:Envelope/S:Body/ns0:Fault/detail/ns1:UssWsApiException/errorCode'
                                       ,'xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:uss-wsapi:Types"'
                           ) 
            INTO vERR_MESSAGE, vERR_CODE
            FROM dual
          ;
          
          -- ���� vERR_MESSAGE, vERR_CODE ������, �� �� ������ ����� ����� �������� ������ �����  
          IF IS_BROKEN_ERROR(pANSWER)=0 and (vERR_MESSAGE is not null or vERR_CODE is not null) THEN
            -- ������ �� ���������, ������ ����� �������
            SET_TOKEN_VALID(rec.login, 1, null, rec.account_id, pREQUEST_TEXT||' '||pANSWER.Err_text, pANSWER.ANSWER);
          ELSE 
            -- ������ ��������� - ����� ������, ������� �������� �������� ����� ����� ����� ����
            -- ������� ���������. ��� ����� ����������
           -- IF (TRIM(pANSWER.ANSWER.GETSTRINGVAL()) is null  or pANSWER.ANSWER is null) then 
            IF pANSWER.ANSWER is null then   --- � ������ ������ ����������
              SET_TOKEN_VALID(rec.login, 2, null, rec.account_id, pREQUEST_TEXT||' '||pANSWER.Err_text, pANSWER.ANSWER);
              vTOKEN := GET_NEW_TOKEN_FROM_SITE(rec.login, rec.password);
              IF TRIM(vTOKEN) IS NOT NULL THEN 
                -- ������� 01.10.2015  �������� ����� �����,���������� �������� ������ ������
                SET_TOKEN_VALID(rec.login, 1, vTOKEN, rec.account_id, pREQUEST_TEXT ||' ����� ����� - '||vTOKEN||'');
              END IF;
            ELSE   -- �������� ����������� ������ �� �������                                                                                                    
              SET_TOKEN_VALID(rec.login, 0, null, rec.account_id, pREQUEST_TEXT||' '||pANSWER.Err_text, pANSWER.ANSWER);      
              vTOKEN := GET_NEW_TOKEN_FROM_SITE(rec.login, rec.password);
                IF TRIM(vTOKEN) IS NOT NULL THEN
                  -- �������� ����� �����,���������� �������� ������ ������
                  SET_TOKEN_VALID(rec.login, 1, vTOKEN, rec.account_id, pREQUEST_TEXT ||' ����� ����� - '||vTOKEN||'');
                END IF; 
            END IF;              
          END IF;
        ELSE
          BEGIN
            SELECT BA.LAST_UPDATE
              INTO vLAST_UPDATE_TOKEN
              FROM beeline_api_token_list BA              
             WHERE BA.ACC_LOG = REC.LOGIN
               AND BA.LAST_UPDATE >= (SYSDATE - 1/24) -- ����� ���������� ������ ���� �����
            ;
          EXCEPTION 
            WHEN NO_DATA_FOUND THEN             
              -- ������� ���������. ��� ����� ����������
              --SET_TOKEN_VALID(rec.login, 0, null, rec.account_id, pREQUEST_TEXT, pANSWER.ANSWER);          
              vTOKEN := GET_NEW_TOKEN_FROM_SITE(rec.login, rec.password);
              IF TRIM(vTOKEN) IS NOT NULL THEN
                -- �������� ����� �����,���������� �������� ������ ������
                SET_TOKEN_VALID(rec.login, 1, vTOKEN, rec.account_id, pREQUEST_TEXT ||' ����� ����� - '||vTOKEN||'');
              ELSE
                SET_TOKEN_VALID(rec.login, 0,  null, rec.account_id, pREQUEST_TEXT||' '||pANSWER.Err_text, pANSWER.ANSWER);
              END IF; 
          END;
        END IF; 
      
    END;                   
  END LOOP;          
       
END;
/
