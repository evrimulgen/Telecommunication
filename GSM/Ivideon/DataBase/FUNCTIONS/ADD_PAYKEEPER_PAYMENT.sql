GRANT EXECUTE ON LONTANA.TO_NUMBER2 TO IVIDEON;
CREATE SYNONYM IVIDEON.TO_NUMBER2 FOR LONTANA.TO_NUMBER2;

 
CREATE OR REPLACE FUNCTION ADD_PAYKEEPER_PAYMENT (
  pPAYKEEPER_PAYMENT_ID VARCHAR2,  
  pPAYMENT_SUM VARCHAR2,
  pABONENT_ID VARCHAR2
) 
RETURN VARCHAR2
IS 
--#version=6
--v6. 09.02.2016 - ������� �. - ����������� ������� ��� ����� Ivideon
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
  
  cPAYKEEPER_COEFFICIENT CONSTANT INTEGER := 1;
  
  vBALANCE NUMBER;
  
  vPAYMENT_PURPOSE_ID PAYMENT_PURPOSE_TYPE.PAYMENT_PURPOSE_ID%TYPE;
  vPAYKEEPER_PAYMENT_ID PAYMENT_HISTORY.PAYKEEPER_PAYMENT_ID%TYPE;  
  vPAYMENT_SUM PAYMENT_HISTORY.PAYMENT_SUM%TYPE;
  vABONENT_ID PAYMENT_HISTORY.ABONENT_ID%TYPE;
  
  vRes varchar2(2000 char);
  
  
  
  --���������� ������������� ���������� ������� ��� payKeeper
  function GET_PAYMENT_PURPOSE_ID RETURN PAYMENT_PURPOSE_TYPE.PAYMENT_PURPOSE_ID%TYPE
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    vRes PAYMENT_PURPOSE_TYPE.PAYMENT_PURPOSE_ID%TYPE;
  begin
    
    begin
      select
        PAYMENT_PURPOSE_ID into vRes
      from
        PAYMENT_PURPOSE_TYPE
      where
        upper(PAYMENT_PURPOSE_CODE) = 'PAYKEEPER_PAYMENT';
    exception
      when others then
        vRes := -1;  
    end;
    
    if nvl(vRes, -1) = -1 then
      Insert into PAYMENT_PURPOSE_TYPE
        (PAYMENT_PURPOSE_CODE, PAYMENT_PURPOSE_DESC)
      Values
        ('paykeeper_payment', '���������� �� ������� PayKeeper')
      returning PAYMENT_PURPOSE_ID into vRes;
    end if; 
    
    COMMIT;
    RETURN vRes;
  end;  
    
  --��������� ������������� ������� � PAYMENT_HISTORY
  --���� ������ ����, �� ���������� 1, ���� ���, �� 0
  FUNCTION PAYMENT_EXIST (
                    plPAYKEEPER_PAYMENT_ID PAYMENT_HISTORY.PAYKEEPER_PAYMENT_ID%TYPE,
                    plAbonent_id PAYMENT_HISTORY.Abonent_id%TYPE,
                    plPAYMENT_PURPOSE_ID PAYMENT_PURPOSE_TYPE.PAYMENT_PURPOSE_ID%TYPE)
  RETURN integer
  IS
    vCount INTEGER;
    vRes Integer;
  BEGIN
    
    SELECT count(*) into vCount
        FROM PAYMENT_HISTORY PH
       WHERE PH.PAYKEEPER_PAYMENT_ID = plPAYKEEPER_PAYMENT_ID
         AND ph.abonent_id = plAbonent_id
         and PH.PAYMENT_PURPOSE_ID = plPAYMENT_PURPOSE_ID;
    
    if nvl(vCount, 0) = 0 then
      vRes := 0;
    else
      vRes := 1;
    end if;  
    
    Return vRes;     
  END;
  
  
    --��������� ������������� ������� � PAYMENT_HISTORY
  --���� ������ ����, �� ���������� 1, ���� ���, �� 0
  FUNCTION ABONENT_EXIST (
                            plAbonent_id PAYMENT_HISTORY.Abonent_id%TYPE
                          )
  RETURN integer
  IS
    vCount INTEGER;
    vRes Integer;
  BEGIN
    
    SELECT count(*) into vCount
        FROM IVIDEON_ABONENTS
       WHERE abonent_id = plAbonent_id;
    
    if nvl(vCount, 0) = 0 then
      vRes := 0;
    else
      vRes := 1;
    end if;  
    
    Return vRes;     
  END;
  
BEGIN
  
  vPAYKEEPER_PAYMENT_ID := to_number(pPAYKEEPER_PAYMENT_ID) ;  
  vPAYMENT_SUM := TO_NUMBER2(pPAYMENT_SUM);
  vABONENT_ID :=  to_number(pABONENT_ID) ; 
  
  vPAYMENT_PURPOSE_ID := GET_PAYMENT_PURPOSE_ID;
  
  --������ �������� �� ������������� ��������
  IF ABONENT_EXIST(vABONENT_ID) = 1 THEN 
         
    -- ���� ����� ������ �� ������, �� �������� ���
    IF PAYMENT_EXIST(vPAYKEEPER_PAYMENT_ID, vABONENT_ID, vPAYMENT_PURPOSE_ID) = 0 THEN    
      -- ������ �������� �� ������ ������
      BEGIN
        -- v2 - �������� ����������� ��� ��������� �������
        --vPAYKEEPER_COEFFICIENT := NVL(GET_PAYKEEPER_COEFFICIENT, 1);
        vPAYMENT_SUM := vPAYMENT_SUM * cPAYKEEPER_COEFFICIENT;
        
        BEGIN
          
          Insert into PAYMENT_HISTORY
            (ABONENT_ID, PAYMENT_SUM, PAYMENT_DATE,  PAYKEEPER_PAYMENT_ID, PAYMENT_PURPOSE_ID)
          Values
            (vABONENT_ID, vPAYMENT_SUM, sysdate, vPAYKEEPER_PAYMENT_ID, vPAYMENT_PURPOSE_ID);
          COMMIT;
            
          vRes :=  'OK! ������ ��������!';
        EXCEPTION
          WHEN OTHERS THEN 
            vRes := '������ ��� ������� ������� � �������!';
        END;
                
      EXCEPTION 
        WHEN OTHERS THEN 
          vRes := '������ ��� ���������� ���� �������!';
      END;

    ELSE 
      vRes := 'ERROR! ������ SUM=' ||pPAYMENT_SUM|| ' ��� CLIENTID='|| pABONENT_ID ||' ��� ��������������� � �������';

    END IF;-- IF PAYMENT_EXIST(vPAYKEEPER_PAYMENT_ID, vABONENT_ID, vPAYMENT_PURPOSE_ID) = 0 THEN 
  else
    vRes := 'ERROR! �� ������ ������� ���� ��� CLIENT_ID '||pABONENT_ID;  
  END IF;--IF ABONENT_EXIST(vABONENT_ID) = 1 THEN    
  
  Return vRes;
END;

--GRANT EXECUTE ON ADD_PAYKEEPER_PAYMENT to WWW_DEALER;
/
