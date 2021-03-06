CREATE OR REPLACE PACKAGE LOADER4_PCKG IS
--
--#Version=8
-- ���� ����� ����������� "���-������", �������� ����� ������-��� ��������
--
-- 5 �������. ��������� �������� ����� ��� ������, ���������, �������.
-- 4 �������. ��������� ��������� ��������� ���� ��������
-- 3 �������. ������� ������ ������
-- 2 �������. ������ ��������� ��������� � ��������
-- 1 �������. �������� ������ 4 ������� "���-������" ������� ���, ��� � ���� �����, �������� �������(�������)
--
  FUNCTION SEND_PAID_SMS(
    pPHONE_NUMBER IN VARCHAR2
    ) RETURN VARCHAR2;
--
  FUNCTION GET_PHONE_STATUS(
    pPHONE_NUMBER IN VARCHAR2,
    pFULL_CHECK IN INTEGER DEFAULT 0
    ) RETURN VARCHAR2;
--   
  FUNCTION SET_PHONE_OPTION_ON(
    pPHONE_NUMBER IN VARCHAR2,
    pOPTION_NAME IN VARCHAR2
    ) RETURN VARCHAR2;
--
  FUNCTION SET_PHONE_OPTION_OFF(
    pPHONE_NUMBER IN VARCHAR2,
    pOPTION_NAME IN VARCHAR2
    ) RETURN VARCHAR2; 
--
-- ��������� ���������� ���� �������� � ���������� �����
  PROCEDURE SIM_GET_ALL_BALANCE; 
--
-- ������������ �����.
  PROCEDURE SIM_MOVE(
    pCELL_NUMBER IN VARCHAR,
    pAGENT_ID IN INTEGER,
    pSUB_AGENT_ID IN INTEGER    
    );  
--
--    
  FUNCTION GET_PHONE_BILLS(
    pPHONE_NUMBER IN VARCHAR2
    ) RETURN VARCHAR2;
--
--    
  FUNCTION GET_PHONE_BILL_DETAILS(
    pPHONE_NUMBER IN VARCHAR2
    ) RETURN VARCHAR2;
--     
--  
  PROCEDURE SIM_GET_ALL_BILLS;
--     
--  
  PROCEDURE SIM_GET_ALL_BILL_DETAILS;
--     
  FUNCTION CP_TRANSFERS(
    pACCOUNTS_FROM IN VARCHAR2,
    pACCOUNTS_TO IN VARCHAR2,
    pTRANSFER_SUM IN VARCHAR2
    ) RETURN VARCHAR2;
--     
END LOADER4_PCKG;
/

CREATE OR REPLACE PACKAGE BODY LOADER4_PCKG IS

/*  cSITE_PASSWORD CONSTANT VARCHAR2(50 CHAR) := '88887777';
  cLOADER_NAME CONSTANT VARCHAR2(50 CHAR):= 'megafon';
  cDB_DATA_SOURCE CONSTANT VARCHAR2(50 CHAR):= '89.108.122.49:1521/GSMCORP';
  cDB_USER_NAME CONSTANT VARCHAR2(50 CHAR):= 'db_loader';
  cDB_PASSWORD CONSTANT VARCHAR2(50 CHAR):= 'db_loader';*/
--
  PROCEDURE GET_SETTINGS(
    pSITE_PASSWORD OUT VARCHAR2,
    pLOADER_NAME OUT VARCHAR2,
    pDB_DATA_SOURCE OUT VARCHAR2,
    pDB_USER_NAME OUT VARCHAR2,
    pDB_PASSWORD OUT VARCHAR2
    ) IS
--
CURSOR C IS
  SELECT * 
    FROM SIM_SETTINGS
    WHERE SETTINGS_ACTIVE=1;    
rec C%ROWTYPE;    
BEGIN
  OPEN C;
  FETCH C INTO rec;
  IF NOT(C%NOTFOUND) THEN
    pSITE_PASSWORD:=rec.SERVICE_GID_PASSWORD;
    pLOADER_NAME:=rec.LOADER_NAME;
    pDB_DATA_SOURCE:=rec.LOADER_DB_CONNECTION;
    pDB_USER_NAME:=rec.LOADER_DB_USER_NAME;
    pDB_PASSWORD:=rec.LOADER_DB_PASSWORD; 
  END IF;
  CLOSE C;
END;   
-- 
  PROCEDURE GET_SETTINGS_CORP_PORTAL(
    pSITE_LOGIN OUT VARCHAR2,
    pSITE_PASSWORD OUT VARCHAR2,
    pLOADER_NAME OUT VARCHAR2,
    pDB_DATA_SOURCE OUT VARCHAR2,
    pDB_USER_NAME OUT VARCHAR2,
    pDB_PASSWORD OUT VARCHAR2
    ) IS
--
CURSOR C IS
  SELECT * 
    FROM SIM_SETTINGS
    WHERE SETTINGS_ACTIVE=1;    
rec C%ROWTYPE;    
BEGIN
  OPEN C;
  FETCH C INTO rec;
  IF NOT(C%NOTFOUND) THEN
    pSITE_LOGIN:=rec.CORP_PORTAL_LOGIN;
    pSITE_PASSWORD:=rec.CORP_PORTAL_PASSWORD;
    pLOADER_NAME:=rec.LOADER_NAME;
    pDB_DATA_SOURCE:=rec.LOADER_DB_CONNECTION;
    pDB_USER_NAME:=rec.LOADER_DB_USER_NAME;
    pDB_PASSWORD:=rec.LOADER_DB_PASSWORD; 
  END IF;
  CLOSE C;
END;    
--
-- ������� - ������-��� - �������� �������(������ ������ ��� ��� � �����)
  FUNCTION GET_PHONE_STATUS(
    pPHONE_NUMBER IN VARCHAR2,
    pFULL_CHECK IN INTEGER DEFAULT 0
    ) RETURN VARCHAR2 IS
--
vSITE_PASSWORD VARCHAR2(50 CHAR);
vLOADER_NAME VARCHAR2(50 CHAR);
vDB_DATA_SOURCE VARCHAR2(50 CHAR);
vDB_USER_NAME VARCHAR2(50 CHAR);
vDB_PASSWORD VARCHAR2(50 CHAR);
vFULL_CHECK BOOLEAN;
V_RESULT VARCHAR2(300 CHAR);
BEGIN
  GET_SETTINGS(vSITE_PASSWORD, vLOADER_NAME, vDB_DATA_SOURCE, vDB_USER_NAME, vDB_PASSWORD);
  IF pFULL_CHECK=1 THEN
    vFULL_CHECK:=TRUE;
  ELSE
    vFULL_CHECK:=FALSE;
  END IF;
  BEGIN
    V_RESULT:=LOADER_CALL_PCKG.GET_PHONE_STATUS(
                               vSITE_PASSWORD, 
                               vLOADER_NAME, 
                               vDB_DATA_SOURCE, 
                               vDB_USER_NAME,                                
                               vDB_PASSWORD,  
                               pPHONE_NUMBER, 
                               vFULL_CHECK);
  EXCEPTION WHEN OTHERS THEN
    V_RESULT:=SQLERRM;
  END; 
  RETURN V_RESULT;                                 
END GET_PHONE_STATUS;
--
-- ������� - ������-��� - ����������� ����� 
  FUNCTION SET_PHONE_OPTION_ON(
    pPHONE_NUMBER IN VARCHAR2,
    pOPTION_NAME IN VARCHAR2
    ) RETURN VARCHAR2 IS
--
vSITE_PASSWORD VARCHAR2(50 CHAR);
vLOADER_NAME VARCHAR2(50 CHAR);
vDB_DATA_SOURCE VARCHAR2(50 CHAR);
vDB_USER_NAME VARCHAR2(50 CHAR);
vDB_PASSWORD VARCHAR2(50 CHAR);
V_RESULT VARCHAR2(300 CHAR);
vTYPE_SET VARCHAR2(12 CHAR);
BEGIN
  GET_SETTINGS(vSITE_PASSWORD, vLOADER_NAME, vDB_DATA_SOURCE, vDB_USER_NAME, vDB_PASSWORD);
  BEGIN
    V_RESULT:=LOADER_CALL_PCKG.SET_PHONE_OPTION_ON(
                               vSITE_PASSWORD, 
                               vLOADER_NAME, 
                               vDB_DATA_SOURCE, 
                               vDB_USER_NAME, 
                               vDB_PASSWORD,  
                               pPHONE_NUMBER, 
                               pOPTION_NAME);
  EXCEPTION WHEN OTHERS THEN
    V_RESULT:=SQLERRM;
  END; 
  IF V_RESULT IS NOT NULL THEN
    vTYPE_SET:='�����������';  
    INSERT INTO SIM_PHONE_OPTION_SET_HISTORY(PHONE_NUMBER, OPTION_NAME, NOTE, TYPE_SET)
      VALUES (pPHONE_NUMBER, pOPTION_NAME, V_RESULT, vTYPE_SET);      
    COMMIT;
  END IF;
  RETURN V_RESULT;                              
END SET_PHONE_OPTION_ON;
--
-- ������� - ������-��� - ���������� ����� 
  FUNCTION SET_PHONE_OPTION_OFF(
    pPHONE_NUMBER IN VARCHAR2,
    pOPTION_NAME IN VARCHAR2
    ) RETURN VARCHAR2 IS
--
vSITE_PASSWORD VARCHAR2(50 CHAR);
vLOADER_NAME VARCHAR2(50 CHAR);
vDB_DATA_SOURCE VARCHAR2(50 CHAR);
vDB_USER_NAME VARCHAR2(50 CHAR);
vDB_PASSWORD VARCHAR2(50 CHAR);
V_RESULT VARCHAR2(300 CHAR);
vTYPE_SET VARCHAR2(12 CHAR);
BEGIN
  GET_SETTINGS(vSITE_PASSWORD, vLOADER_NAME, vDB_DATA_SOURCE, vDB_USER_NAME, vDB_PASSWORD);
  BEGIN
    V_RESULT:=LOADER_CALL_PCKG.SET_PHONE_OPTION_OFF(
                               vSITE_PASSWORD, 
                               vLOADER_NAME, 
                               vDB_DATA_SOURCE, 
                               vDB_USER_NAME, 
                               vDB_PASSWORD,  
                               pPHONE_NUMBER, 
                               pOPTION_NAME);
  EXCEPTION WHEN OTHERS THEN
    V_RESULT:=SQLERRM;
  END; 
  IF V_RESULT IS NOT NULL THEN
    vTYPE_SET:='����������';
    INSERT INTO SIM_PHONE_OPTION_SET_HISTORY(PHONE_NUMBER, OPTION_NAME, NOTE, TYPE_SET)
      VALUES (pPHONE_NUMBER, pOPTION_NAME, V_RESULT, vTYPE_SET);      
    COMMIT;
  END IF;
  RETURN V_RESULT;                         
END SET_PHONE_OPTION_OFF;
--
-- �������� ������� ��� ����� ���-����������
  FUNCTION SEND_PAID_SMS(
    pPHONE_NUMBER IN VARCHAR2
    ) RETURN VARCHAR2 IS
--
vSITE_PASSWORD VARCHAR2(50 CHAR);
vLOADER_NAME VARCHAR2(50 CHAR);
vDB_DATA_SOURCE VARCHAR2(50 CHAR);
vDB_USER_NAME VARCHAR2(50 CHAR);
vDB_PASSWORD VARCHAR2(50 CHAR);
V_RESULT VARCHAR2(300 CHAR);    
BEGIN
  GET_SETTINGS(vSITE_PASSWORD, vLOADER_NAME, vDB_DATA_SOURCE, vDB_USER_NAME, vDB_PASSWORD);
  BEGIN
    V_RESULT:=LOADER_CALL_PCKG.SEND_PAID_SMS(
                               vSITE_PASSWORD, 
                               vLOADER_NAME, 
                               vDB_DATA_SOURCE, 
                               vDB_USER_NAME, 
                               vDB_PASSWORD,  
                               pPHONE_NUMBER);
  EXCEPTION WHEN OTHERS THEN
    V_RESULT:=SQLERRM;
  END; 
  IF V_RESULT IS NOT NULL THEN
    INSERT INTO SIM_SEND_PAID_SMS_HISTORY(PHONE_NUMBER, NOTE)
      VALUES (pPHONE_NUMBER, V_RESULT);      
    COMMIT;
  END IF;
  RETURN V_RESULT;                            
END SEND_PAID_SMS;
--
-- ��������� ���������� ���� �������� � ���������� �����
  PROCEDURE SIM_GET_ALL_BALANCE IS
--  
FULL_CHECK INTEGER;
DATE_ON DATE;
RESULT VARCHAR2(300 CHAR);
COUNT_ALL INTEGER;
COUNT_GOOD INTEGER;
BEGIN
  COUNT_ALL:=0;
  COUNT_GOOD:=0;
  DATE_ON:=SYSDATE;
  IF DATE_ON+2/24-TRUNC(DATE_ON+2/24)<10 THEN -- ���� ����� �� 22:00 �� 8:00
    FULL_CHECK:=1;
  ELSE
    FULL_CHECK:=0;
  END IF;
  FOR rec IN(
    SELECT CELL_NUMBER,
           CASE 
             WHEN SIM.DATE_BALANCE IS NULL THEN ADD_MONTHS(SYSDATE,-3)
             ELSE SIM.DATE_BALANCE
           END AS DATE_BALANCE  
      FROM SIM
      WHERE SIM.SERVICEGID_STATUS=1 
        AND SIM.STATUS_ID<>6 -- �� �������
        AND SIM.STATUS_ID<>5 -- �� � ��������(�����������)
        AND SIM.STATUS_ID<>4 -- �� � ��������(�������)
      ORDER BY DATE_BALANCE ASC 
  ) LOOP
    COUNT_ALL:=COUNT_ALL+1;
    RESULT:=LOADER4_PCKG.GET_PHONE_STATUS(rec.CELL_NUMBER, FULL_CHECK);
    IF RESULT IS NULL THEN
      COUNT_GOOD:=COUNT_GOOD+1;
    END IF;
  END LOOP;  
  INSERT INTO SIM_OPERATION_HISTORY(OPERATION_TYPE, NOTE, DATE_BEGIN)
    VALUES('�������� ���� �������� � ������-����', '������� '||TO_CHAR(COUNT_GOOD)||'/'||TO_CHAR(COUNT_ALL), DATE_ON);    
END;  
--
-- ������������ �����.
  PROCEDURE SIM_MOVE(
    pCELL_NUMBER IN VARCHAR,
    pAGENT_ID IN INTEGER,
    pSUB_AGENT_ID IN INTEGER
    ) IS
--
BEGIN
  IF pAGENT_ID<>0 THEN
    UPDATE SIM 
      SET SIM.AGENT_ID=pAGENT_ID
      WHERE SIM.CELL_NUMBER=pCELL_NUMBER;
  END IF;       
  IF pSUB_AGENT_ID<>0 THEN
    UPDATE SIM 
      SET SIM.SUBAGENT_ID=pSUB_AGENT_ID
      WHERE SIM.CELL_NUMBER=pCELL_NUMBER;
  END IF;  
END; 
--
--
  FUNCTION GET_PHONE_BILLS(
    pPHONE_NUMBER IN VARCHAR2
    ) RETURN VARCHAR2 IS
--
V_RESULT VARCHAR2(300 CHAR);    
vSITE_PASSWORD VARCHAR2(50 CHAR);
vLOADER_NAME VARCHAR2(50 CHAR);
vDB_DATA_SOURCE VARCHAR2(50 CHAR);
vDB_USER_NAME VARCHAR2(50 CHAR);
vDB_PASSWORD VARCHAR2(50 CHAR);
BEGIN
  GET_SETTINGS(vSITE_PASSWORD, vLOADER_NAME, vDB_DATA_SOURCE, vDB_USER_NAME, vDB_PASSWORD);
  BEGIN
    V_RESULT:=LOADER_CALL_PCKG.GET_PHONE_BILLS(
    --���������� �����������, ������� ������������
                               '45950690', --vSITE_PASSWORD, 
                               vLOADER_NAME, 
                               vDB_DATA_SOURCE, 
                               vDB_USER_NAME, 
                               vDB_PASSWORD,  
                               'CP_9257324000' --pPHONE_NUMBER
                               );
  EXCEPTION WHEN OTHERS THEN
    V_RESULT:=SQLERRM;
  END; 
  IF V_RESULT IS NOT NULL THEN
    NULL;
  END IF;
  RETURN V_RESULT;                            
END GET_PHONE_BILLS;
--
--
  FUNCTION GET_PHONE_BILL_DETAILS(
    pPHONE_NUMBER IN VARCHAR2
    ) RETURN VARCHAR2 IS
--
V_RESULT VARCHAR2(300 CHAR);    
vSITE_PASSWORD VARCHAR2(50 CHAR);
vLOADER_NAME VARCHAR2(50 CHAR);
vDB_DATA_SOURCE VARCHAR2(50 CHAR);
vDB_USER_NAME VARCHAR2(50 CHAR);
vDB_PASSWORD VARCHAR2(50 CHAR);
BEGIN
  GET_SETTINGS(vSITE_PASSWORD, vLOADER_NAME, vDB_DATA_SOURCE, vDB_USER_NAME, vDB_PASSWORD);
  BEGIN
    V_RESULT:=LOADER_CALL_PCKG.GET_PHONE_BILL_DETAILS(
                               vSITE_PASSWORD, 
                               vLOADER_NAME, 
                               vDB_DATA_SOURCE, 
                               vDB_USER_NAME, 
                               vDB_PASSWORD,  
                               pPHONE_NUMBER);
  EXCEPTION WHEN OTHERS THEN
    V_RESULT:=SQLERRM;
  END; 
  IF V_RESULT IS NOT NULL THEN
    NULL;
  END IF;
  RETURN V_RESULT;                            
END GET_PHONE_BILL_DETAILS;
--
--
  PROCEDURE SIM_GET_ALL_BILLS IS
--  
DATE_ON DATE;
RESULT VARCHAR2(300 CHAR);
COUNT_ALL INTEGER;
COUNT_GOOD INTEGER;
BEGIN
  COUNT_ALL:=0;
  COUNT_GOOD:=0;
  DATE_ON:=SYSDATE;
  FOR rec IN(
    SELECT * 
      FROM V_SIM_PHONES_BILLS
  ) LOOP
    COUNT_ALL:=COUNT_ALL+1;
    RESULT:=LOADER4_PCKG.GET_PHONE_BILLS(rec.CELL_NUMBER);
    IF RESULT IS NULL THEN
      COUNT_GOOD:=COUNT_GOOD+1;
    END IF;
  END LOOP;  
  INSERT INTO SIM_OPERATION_HISTORY(OPERATION_TYPE, NOTE, DATE_BEGIN)
    VALUES('��������� ������ � ������-����', '������� '||TO_CHAR(COUNT_GOOD)||'/'||TO_CHAR(COUNT_ALL), DATE_ON);    
END; 
--
--
  PROCEDURE SIM_GET_ALL_BILL_DETAILS IS
--  
DATE_ON DATE;
RESULT VARCHAR2(300 CHAR);
COUNT_ALL INTEGER;
COUNT_GOOD INTEGER;
BEGIN
  COUNT_ALL:=0;
  COUNT_GOOD:=0;
  DATE_ON:=SYSDATE;
  FOR rec IN(
    SELECT * 
      FROM SIM
  ) LOOP
    COUNT_ALL:=COUNT_ALL+1;
    RESULT:=LOADER4_PCKG.GET_PHONE_BILL_DETAILS(rec.CELL_NUMBER);
    IF RESULT IS NULL THEN
      COUNT_GOOD:=COUNT_GOOD+1;
    END IF;
  END LOOP;  
  INSERT INTO SIM_OPERATION_HISTORY(OPERATION_TYPE, NOTE, DATE_BEGIN)
    VALUES('��������� ���������� � ������-����', '������� '||TO_CHAR(COUNT_GOOD)||'/'||TO_CHAR(COUNT_ALL), DATE_ON);    
END; 
--
--
  FUNCTION CP_TRANSFERS(
    pACCOUNTS_FROM IN VARCHAR2,
    pACCOUNTS_TO IN VARCHAR2,
    pTRANSFER_SUM IN VARCHAR2
    ) RETURN VARCHAR2 IS
--
V_RESULT VARCHAR2(300 CHAR);    
vSITE_LOGIN VARCHAR2(50 CHAR);
vSITE_PASSWORD VARCHAR2(50 CHAR);
vLOADER_NAME VARCHAR2(50 CHAR);
vDB_DATA_SOURCE VARCHAR2(50 CHAR);
vDB_USER_NAME VARCHAR2(50 CHAR);
vDB_PASSWORD VARCHAR2(50 CHAR);
BEGIN
  GET_SETTINGS_CORP_PORTAL(vSITE_LOGIN, vSITE_PASSWORD, vLOADER_NAME, vDB_DATA_SOURCE, vDB_USER_NAME, vDB_PASSWORD);
  BEGIN
    V_RESULT:=LOADER_CALL_PCKG.CP_TRANSFERS(
                               vSITE_LOGIN, 
                               vSITE_PASSWORD, 
                               vLOADER_NAME, 
                               vDB_DATA_SOURCE, 
                               vDB_USER_NAME, 
                               vDB_PASSWORD,  
                               pACCOUNTS_FROM,
                               pACCOUNTS_TO,
                               pTRANSFER_SUM);
  EXCEPTION WHEN OTHERS THEN
    V_RESULT:=SQLERRM;
  END; 
  IF V_RESULT IS NOT NULL THEN
    NULL;
  END IF;
  RETURN V_RESULT;                            
END CP_TRANSFERS;

END;
/
