grant execute ON IVIDEON.ADD_PAYKEEPER_PAYMENT to WWW_DEALER;
CREATE OR REPLACE PROCEDURE WWW_DEALER.LOAD_PAYKEEPER_PAYMENT (
    NAME_ARRAY IN OWA.VC_ARR,
    VALUE_ARRAY IN OWA.VC_ARR   
)
IS
-- VERSION=3
-- V3. 17.02.2016  - ������� �. �������� ������ ��� ������������ ������ � ���������� �������! ������ ������ ����� ��� �������� - �����!
--                              � ������ ����� ������ �������� ������� ���������� ������������� ���������� �������.
--                              ���� ����� ������ �������� (� ����� �� ��� ��������),������ �������� �� ������� ������ - � �� ��������� ������������� ���������� ������� 
--                              � ��������� ������� - ���������� ������!   
-- V2. 09.02.2016  - ������� �. ������� ��������� �������� ��� ������������ IVIDEONA
-- V1. 03.05.2015  - ������� �.
--  
-- ���������, ��� ������ POST ������� �� ��������� ������� PayKeeper � ����������� � ��� �������� �� ����� ���������� �������. 
-- ����������� � ������ ������ http://redmine.tarifer.ru/issues/3023.
-- ��������� ������������ ���������� ����������, ���������� �����, ���������� � ���������� �� PayKeeper, � ����������� �����.
-- ���� ���� ���������, ��������� ������ - ������� ADD_PAYKEEPER_PAYMENT
-- ������ ������������ ����������: 
--   ID VARCHAR2 DEFAULT NULL,  -- ����������, ������� �� ������������� ����� ������� � PayKeeper   
--   SUM VARCHAR2 DEFAULT NULL,  -- ����� ������� � ������ � ��������� �� �����. ����������� � �����   
--   clientid VARCHAR2 DEFAULT NULL, -- ������������� �������. ��� ��, ��� ��� ��������� ����� ������   
--   orderid VARCHAR2 DEFAULT NULL, -- ����� ������. �� ����������   
--   KEY VARCHAR2 DEFAULT NULL -- �������� ������� �������, ������ �� �������� a-f � 0-9

  vRESULT_INSERT_PAY VARCHAR2(1000 CHAR);
  vERROR VARCHAR2(2000 CHAR);  
  vPAYKEEPER PAYKEEPER_PAYMENT_LOG%ROWTYPE;
  
  pID VARCHAR2(30 CHAR);
  pSUM VARCHAR2(15 CHAR);
  pCLIENT_ID VARCHAR2(50 CHAR);
  pORDER_ID VARCHAR2(50 CHAR);
  pKEY VARCHAR2(100 CHAR); 
  
  pCODE_WORD CONSTANT VARCHAR2(50 CHAR) := 'RjKjnBn3bVj59bne'; -- ������� �����, ������ ���� ����� �� ��� � ���������� ������� �������� PayKeeper 
  vHASH_ANSWER VARCHAR2(100 CHAR);  -- MD5-hash ��� ������ � ������ ����������� ������� 
  
  -- �������� ���������� �����
  FUNCTION IsValidKey RETURN BOOLEAN
  IS
    vHASH varchar2 (1000 CHAR);
    vKEY  varchar2 (100 CHAR);
  BEGIN
    vHASH := pID || pSUM || pCLIENT_ID || pORDER_ID || pCODE_WORD;
    vKEY := lower( Rawtohex(UTL_RAW.CAST_TO_RAW(DBMS_OBFUSCATION_TOOLKIT.MD5(input_string=>vHASH))));      
    IF vKEY = lower(pKEY) THEN
      RETURN TRUE; 
    ELSE
      RETURN FALSE;
    END IF;
  END IsValidKey;
  
  -- �������� �� ������������ IVIDEONA
  FUNCTION IS_IVIDEON_USER( pUSER_ID varchar2) RETURN INTEGER
  IS
    vRes Integer;
    vCount Integer;
  BEGIN
    vRes := 0;
    vCount := 0;
    
    select
      count(*) into vCount
    from
      IVIDEON.V_IVIDEION_USERS
    where
      TO_CHAR(IVIDEON.V_IVIDEION_USERS.ABONENT_ID) = trim(pUSER_ID);
    
    if nvl(vCount, 0) > 0 then
      vRes := 1;
    else
      vRes := 0;
    end if;
    
    RETURN vRes;  
    
  END IS_IVIDEON_USER;
  
    
BEGIN
  BEGIN
    
    -- ���������� ���������
    FOR I IN NAME_ARRAY.FIRST..NAME_ARRAY.LAST LOOP        
      IF UPPER(NAME_ARRAY(I)) = 'ID' THEN
        pID := SUBSTR(VALUE_ARRAY(I), 1, 100);
      ELSIF UPPER(NAME_ARRAY(I)) = 'SUM' THEN
        pSUM := SUBSTR(VALUE_ARRAY(I), 1, 100);
      ELSIF UPPER(NAME_ARRAY(I)) = 'CLIENTID' THEN
        pCLIENT_ID := SUBSTR(VALUE_ARRAY(I), 1, 100);
      ELSIF UPPER(NAME_ARRAY(I))  = 'ORDERID' THEN
        pORDER_ID := SUBSTR(VALUE_ARRAY(I), 1, 100);
      ELSIF UPPER(NAME_ARRAY(I))  = 'KEY' THEN
        pKEY := SUBSTR(VALUE_ARRAY(I), 1, 100);
      END IF;        
    END LOOP;
    
--    IF pID = '48' THEN
--      vHASH_ANSWER := lower(Rawtohex(UTL_RAW.CAST_TO_RAW(DBMS_OBFUSCATION_TOOLKIT.MD5(input_string=>pID||pCODE_WORD)))); 
--      vERROR := 'OK '||vHASH_ANSWER; 
--      HTP.PRN(vERROR);
--      INSERT INTO PAYKEEPER_PAYMENT_LOG (PAYKEEPER_ID, PAY_SUM, CLIENT_ID, ORDER_ID, KEY_HASH, ANSWER)
--            VALUES (pID, pSUM, pCLIENT_ID, pORDER_ID, pKEY, vERROR);
--      COMMIT;
--      return;   
--    END IF;
    
    vPAYKEEPER.PAYKEEPER_ID := pID; 
    vPAYKEEPER.PAY_SUM := pSUM; 
    vPAYKEEPER.CLIENT_ID := pCLIENT_ID; 
    vPAYKEEPER.ORDER_ID := pORDER_ID; 
    vPAYKEEPER.KEY_HASH := pKEY;
     
    IF pID IS NULL THEN
      vERROR := 'ERROR! �������� ID �� ����� ���� ������.';
      HTP.PRN(vERROR);
      return;
    ELSIF pSUM IS NULL THEN    
      vERROR := 'ERROR! �������� SUM �� ����� ���� ������.';
      HTP.PRN(vERROR);
      return;
    ELSIF pCLIENT_ID IS NULL THEN
      vERROR := 'ERROR! �������� CLIENTID �� ����� ���� ������.';
      HTP.PRN(vERROR);
      return;
    ELSIF pKEY IS NULL THEN
      vERROR := 'ERROR! �������� KEY �� ����� ���� ������.';
      HTP.PRN(vERROR);
      return;
    END IF;
      
    vRESULT_INSERT_PAY := 'null';
    BEGIN
      IF IsValidKey THEN
        
        --��������� � ����� ����� ������ ������ (IVIDEON ��� WWW_DEALER)
        IF IS_IVIDEON_USER(vPAYKEEPER.CLIENT_ID) = 1 THEN
          --��������� ������ � IVIDEON
          vRESULT_INSERT_PAY := IVIDEON.ADD_PAYKEEPER_PAYMENT(vPAYKEEPER.PAYKEEPER_ID,  
                                                        vPAYKEEPER.PAY_SUM ,
                                                        vPAYKEEPER.CLIENT_ID
                                                       );
        ELSE
          -- ��������� ������ � DB_LOADER_PAYMENTS, 1 - ��������, 0 - �� ��������
          vRESULT_INSERT_PAY := LONTANA.ADD_PAYKEEPER_PAYMENT(vPAYKEEPER.PAYKEEPER_ID,  
                                                        vPAYKEEPER.PAY_SUM ,
                                                        vPAYKEEPER.CLIENT_ID, 
                                                        vPAYKEEPER.ORDER_ID
                                                       );
        END IF;
        
        IF vRESULT_INSERT_PAY = 'OK! ������ ��������!' THEN
          
          vHASH_ANSWER := lower( Rawtohex(UTL_RAW.CAST_TO_RAW(DBMS_OBFUSCATION_TOOLKIT.MD5(input_string=>pID||pCODE_WORD)))); 
          vERROR := 'OK '||vHASH_ANSWER;          
        
        -- ���� ��� ���������� ������� ������������ ������, ��� ������ ��� ��������������� � �������, 
        -- ��� ��������, ��� � ���������� ���, ����� ������ �������� � ���, ������ ��������� �� ������� ��� �����, � ��������� ��� �� ������ �����!
        -- � ����� ������ �������� �� �������� �� �������� ���������� �������.  
        ELSIF vRESULT_INSERT_PAY like '%��� ��������������� � �������%' THEN 
          vHASH_ANSWER := lower( Rawtohex(UTL_RAW.CAST_TO_RAW(DBMS_OBFUSCATION_TOOLKIT.MD5(input_string=>pID||pCODE_WORD))));
          vERROR := 'OK '||vHASH_ANSWER;

        -- ��� ����� ������ ���������� ���������� ������� �������� �� ������
        ELSE
          vERROR := 'Error! ������ ��� ���������� �������'; --'OK '||vHASH_ANSWER;          
        END IF;
      ELSE
        vERROR := 'Error! Hash mismatch!';      
      END IF;               
      
    EXCEPTION 
      WHEN OTHERS THEN
        vERROR := 'Error! Other exception.';
        -- ��� ����� ��������� � ��� �������� ��������
    END;
    
    HTP.PRN(vERROR);
  EXCEPTION 
    WHEN OTHERS THEN
      HTP.PRN('ERROR! � ��������� LOAD_PAYKEEPER_PAYMENT �������� ������.');
      vERROR := 'ERROR! � ��������� LOAD_PAYKEEPER_PAYMENT �������� ������.'|| vERROR;
  END;    
  
  vERROR := '�����: "'||vERROR||'".  ��������� ���������� �������: "'||vRESULT_INSERT_PAY||'".';
  INSERT INTO PAYKEEPER_PAYMENT_LOG (PAYKEEPER_ID, PAY_SUM, CLIENT_ID, ORDER_ID, KEY_HASH, ANSWER)
            VALUES (pID, pSUM, pCLIENT_ID, pORDER_ID, pKEY, vERROR);
  COMMIT;
END;
/
