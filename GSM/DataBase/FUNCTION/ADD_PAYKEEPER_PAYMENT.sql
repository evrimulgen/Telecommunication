CREATE OR REPLACE FUNCTION LONTANA.ADD_PAYKEEPER_PAYMENT (
  pPAYKEEPER_ID VARCHAR2,  
  pPAY_SUM VARCHAR2,
  pCLIENT_ID VARCHAR2,
  pORDER_ID VARCHAR2  
) 
RETURN VARCHAR2
IS 
--#version=5
--v5. 14.07.2015 - ������� �., ������ �. - ������ ��������� ������� �. �� ������ ���������� ����.
--v4. 14.07.2015 - ������� �., �������� �. - ��������� �������� �������� ���, �������� ���������� �������� ����
--v3. 13.07.2015 - ������� �. - ����� ����������� � ��������� ������� ������������ ��������� ������� - GET_PAYKEEPER_COEFFICIENT, � ���������� ������ � �������� ����� - TO_NUMBER2.  
--v2. 13.07.2015 - ������� �. - �������� ����������� ��������� �������, ���������� �� PayKeeper(��� ������� ������������ � �����). 
                             -- �������� � PARAMS ��� 'PAYKEEPER_COEFFICIENT'. ���� �� �����, �� ����� �� ��������� 1                             
--v1. - ������� �.
-- ������� ������������� ��� ���������� ������� ���������� �� ������� PayKeeper.
-- ����������� � ������ ������ http://redmine.tarifer.ru/issues/3023.
-- ����� ����������� �� ��������� ������� �� � ������� �������� DB_LOADER_PAYMENTS ������ � ���������� ����������, � ������:
   --  ����� ������� PAYMENT_NUMBER - ���������� ID ������� � ������� PayKeeper;
   --  ����� �������� PHONE_NUMBER - ����� ��������;
   --  ����������� � ������� PAYMENT_STATUS_TEXT - ������ ���� 'GSM PayKeeper'.
-- ���� ������ �� �������, ������ �� ��� �������� ����� � �� ��������� ���, ���������� ������!
--
-- ��������! ������ ������������� ������ ������ ���� ���������� � ���������� WWW_DEALER.LOAD_PAYKEEPER_PAYMENT!

  vPAY_ALREADY_EXIST INTEGER;
  vPAYKEEPER PAYKEEPER_PAYMENT_LOG%ROWTYPE;
  vACCOUNT_ID INTEGER;
  vPAY_SUM number(15,2);
  cPAYKEEPER_STATUS_TEXT CONSTANT VARCHAR2 (20 CHAR) := 'GSM PayKeeper';
  
  vBALANCE NUMBER;
  vSMS_TEXT varchar2 (200 char);
  vPAYKEEPER_COEFFICIENT number;
  SMS VARCHAR2(2000); 
    
  FUNCTION PAYMENT_NUMBER_EXIST (pPAYMENT_NUMBER VARCHAR2, pPHONE_NUMBER VARCHAR2) RETURN BOOLEAN
  IS
  --��������� ������������� ������� � DB_LOADER_PAYMENTS 
    CURSOR CUR_PAYMENT (pPAYMENT_NUMBER VARCHAR2, pPHONE_NUMBER VARCHAR2) IS
      SELECT DP.ACCOUNT_ID, DP.CONTRACT_ID
        FROM DB_LOADER_PAYMENTS DP
       WHERE DP.PAYMENT_NUMBER = pPAYMENT_NUMBER
         AND DP.PHONE_NUMBER = pPHONE_NUMBER
         AND DP.PAYMENT_STATUS_TEXT = cPAYKEEPER_STATUS_TEXT 
    ;                
    vcur CUR_PAYMENT%rowtype;
  BEGIN
    OPEN CUR_PAYMENT(pPAYMENT_NUMBER, pPHONE_NUMBER);
    FETCH CUR_PAYMENT into vcur;
    IF CUR_PAYMENT%NOTFOUND THEN
      CLOSE CUR_PAYMENT;
      RETURN FALSE;
    ELSE
      CLOSE CUR_PAYMENT;
      RETURN TRUE;
    END IF;    
  END;
  
BEGIN
  
  vPAYKEEPER.PAYKEEPER_ID := pPAYKEEPER_ID; 
  vPAYKEEPER.PAY_SUM := pPAY_SUM ; --TO_NUMBER(pPAY_SUM); 
  vPAYKEEPER.CLIENT_ID := pCLIENT_ID; 
  vPAYKEEPER.ORDER_ID := pORDER_ID;     
  
--  vPAY_ALREADY_EXIST := 0;
--  BEGIN
--    vPAY_ALREADY_EXIST := PAYMENT_NUMBER_EXIST(vPAYKEEPER.PAYKEEPER_ID, vPAYKEEPER.CLIENT_ID);
--  EXCEPTION 
--    WHEN OTHERS THEN
--      RETURN ('������ ��� ������ PAYMENT_NUMBER_EXIST');
--  END;

  -- ���� ����� ������ �� ������, �� �������� ���
  IF ( NOT PAYMENT_NUMBER_EXIST(vPAYKEEPER.PAYKEEPER_ID, vPAYKEEPER.CLIENT_ID) ) THEN    
    vACCOUNT_ID := GET_ACCOUNT_ID_BY_PHONE(vPAYKEEPER.CLIENT_ID);
    
    IF NVL(vACCOUNT_ID, 0) <> 0 THEN
      -- ������ �������� �� ������ ������
      BEGIN
        -- v2 - �������� ����������� ��� ��������� �������
        vPAYKEEPER_COEFFICIENT := NVL(GET_PAYKEEPER_COEFFICIENT, 1);
        vPAY_SUM := TO_NUMBER2(vPAYKEEPER.PAY_SUM)*vPAYKEEPER_COEFFICIENT;        
      EXCEPTION 
        WHEN OTHERS THEN 
          RETURN ('������ ��� ���������� ���� �������!');
      END;

      BEGIN
        INSERT INTO DB_LOADER_PAYMENTS (ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, PAYMENT_DATE, PAYMENT_SUM, PAYMENT_STATUS_IS_VALID, PAYMENT_NUMBER, PAYMENT_STATUS_TEXT)
        VALUES (vACCOUNT_ID, TO_CHAR(SYSDATE, 'YYYYMM'), vPAYKEEPER.CLIENT_ID, TRUNC(SYSDATE), vPAY_SUM, 1, vPAYKEEPER.PAYKEEPER_ID, cPAYKEEPER_STATUS_TEXT );
        COMMIT;
        
        --���������� ��� � ���������� �������
        BEGIN
          vBALANCE := GET_ABONENT_BALANCE(vPAYKEEPER.CLIENT_ID);
          vSMS_TEXT := '�� ��� ���� �������� ����� � ������� '|| to_char(vPAY_SUM) ||'�. ������ ����� ���������� '|| to_char(vBALANCE) ||'�.';
          SMS:=LOADER3_pckg.SEND_SMS(vPAYKEEPER.CLIENT_ID,
                                     '���-����������',
                                     vSMS_TEXT
                                    );                                             
        EXCEPTION 
          WHEN OTHERS THEN
            NULL; -- ���� �������� ������ ��� ���������� � �������, ������ ������� � 
        END;
        RETURN('OK! ������ ��������!');
      EXCEPTION
        WHEN OTHERS THEN 
          RETURN ('������ ��� ������� ������� � �������!');
      END;
    ELSE
      RETURN ('ERROR! �� ������ ������� ���� ��� CLIENT_ID '||vPAYKEEPER.CLIENT_ID);      
    END IF;
  ELSE 
    RETURN ('ERROR! ������ SUM=' ||pPAY_SUM|| ' ��� CLIENTID='|| vPAYKEEPER.CLIENT_ID ||' ��� ��������������� � �������');
    --RETURN ('ERROR! ������ � ����� ID ��� ������!');
  END IF;
  
END;

--GRANT EXECUTE ON ADD_PAYKEEPER_PAYMENT to WWW_DEALER;
/
