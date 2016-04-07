CREATE OR REPLACE PACKAGE LOAD_1C IS
-- version=3 
-- v3 - ������� �. - ���������� �������� �������. ��������� ���� BONUS_GUID 
-- 
  FUNCTION RECREATE_OPERATOR(pOPERATOR_NAME VARCHAR2) RETURN INTEGER;

  FUNCTION RECREATE_TARIFF(pGUID VARCHAR2, pTARIFF_NAME VARCHAR2, pOPERATOR_ID INTEGER
                          ,pPHONE_NUMBER VARCHAR2 DEFAULT NULL
                          ,pIS_DIRECT NUMBER DEFAULT NULL
                          ) RETURN INTEGER;
  
  -- �������� ������� ������ ���������� ������� (�� ������ �������)
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ���������
  --              2 - ������, ������ �� �������� � ��� ���������
  --              3 - ������, ������ �� ��������, ��� ��������� � �� ���������� ����
  PROCEDURE RELOAD_PHONE_NUMBERS(pLOG_LEVEL INTEGER DEFAULT 1, 
                                 pPHONE_NUMBER VARCHAR2 DEFAULT NULL -- ��������� ������ ���� ����� (� �������� �����)
                                 );

  -- �������� ������� ������ ������������ (�� ������ �������)
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ���������
  --              2 - ������, ������ �� �������� � ��� ���������
  --              3 - ������, ������ �� ��������, ��� ��������� � �� ���������� ����
  PROCEDURE RELOAD_CONTRAGENTS(pLOG_LEVEL INTEGER DEFAULT 1);

  -- �������� ������� ������ ������� 
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_BONUSES(pLOG_LEVEL INTEGER DEFAULT 1);
  PROCEDURE RELOAD_BONUSES_OLD(pLOG_LEVEL INTEGER DEFAULT 1);
  -- �������� ������� ������ ��������� ������� 
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_BALANCE_CHANGES(pLOG_LEVEL INTEGER DEFAULT 1);
 
  -- ���������� ���� � ��������� � ��������� ������� 
  PROCEDURE UPDATE_BALANCE_CHANGE_PERCENTS; 

  -- ��������� ������ �����������
  FUNCTION GET_USER_BALANCE(pUSER_ID INTEGER) RETURN NUMBER;
 
  -- �������� ������� ������ ���������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_ACTIVATIONS(pLOG_LEVEL INTEGER DEFAULT 1);

  -- �������� ������� ������ �������� ���������� ������� (�� ������ �������) �� ������� ������������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ���������
  --              2 - ������, ������ �� �������� � ��� ���������
  PROCEDURE RELOAD_CONTRAGENT_RESTS(pLOG_LEVEL INTEGER DEFAULT 1
                                   ,pPHONE_NUMBER VARCHAR2 DEFAULT NULL -- ��������� ������ ��� ����� ������
  );

  -- �������� ������� ��������� �������
  --   ������ ������� � �������� �� ������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ���������
  PROCEDURE RELOAD_TARIFF_CHANGE_RULES(pLOG_LEVEL INTEGER DEFAULT 1);
 
  -- �������� ������ ��������� 
  --   ������ �������� � �������� �� ������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_PHONE_RETURNS(pLOG_LEVEL INTEGER DEFAULT 1);

  -- �������� ������� ������ ��������� ������������ 
  --   ������ ��������� � �������� �� ������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_CONTRAGENT_PERCENTS(pLOG_LEVEL INTEGER DEFAULT 1);

  -- �������� ������� ������ ��������� �� ������� 
  --   ������ ��������� � �������� �� ������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_TARIFF_PERCENTS(pLOG_LEVEL INTEGER DEFAULT 1);


  -- �������� ������ ��������� �� ���������� (����� + ����������) 
  --   ������ ��������� � �������� �� ������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_CONTR_TARIFF_PERCENTS(pLOG_LEVEL INTEGER DEFAULT 1);

 
  PROCEDURE RELOAD_TREE_PIRAMYD(pLOG_LEVEL INTEGER DEFAULT 1);  

  PRAGMA RESTRICT_REFERENCES (GET_USER_BALANCE, WNDS, WNPS, TRUST);   
END;
/

CREATE OR REPLACE PACKAGE BODY LOAD_1C IS

  TYPE T_NUMBERS_ARRAY IS TABLE OF NUMBER(1) INDEX BY VARCHAR2(20 CHAR);
  TYPE T_CONTRAGENTS_ARRAY IS TABLE OF INTEGER INDEX BY VARCHAR2(40 CHAR);

  CURSOR CUR_PHONE_NUMBER IS
    SELECT TRIM(PHONE_NUMBER) PHONE_NUMBER, COST, TRIM(OPERATOR) OPERATOR, TRIM(TARIFF_GUID) TARIFF_GUID, TRIM(TARIFF_NAME) TARIFF_NAME
          ,REST_COUNT, IS_DIRECT, DATE_LOAD, TRIM(MAIN_STORE_GUID) MAIN_STORE_GUID, TRIM(MAIN_STORE_NAME) MAIN_STORE_NAME 
          ,TRIM(SIM_NUMBER1) SIM_NUMBER1 ,TRIM(SIM_NUMBER2) SIM_NUMBER2
      FROM LOAD_PHONE_NUMBER;
      
  CURSOR CUR_CONTRAGENT IS    
    SELECT TRIM(DESCRIPTION) DESCRIPTION, BALANCE, TRIM(USER_NAME) USER_NAME, TRIM(PASSWORD_HASH) PASSWORD_HASH, TRIM(GUID) GUID, IS_LOCKED, IS_UPLOAD, DATE_LOAD
          ,TRIM(MANAGER_DESCRIPTION) MANAGER_DESCRIPTION, TRIM(MANAGER_USER_NAME) MANAGER_USER_NAME, TRIM(MANAGER_PASSWORD_HASH) MANAGER_PASSWORD_HASH, TRIM(MANAGER_GUID) MANAGER_GUID
          ,MANAGER_IS_LOCKED, MANAGER_IS_UPLOAD, IS_DELETED, MANAGER_IS_DELETED, DATE_CHANGE_PASSWORD 
      FROM LOAD_CONTRAGENT
      --where guid='48a32753-8b65-11e4-8099-de2efd98768a'
      ;
      
  CURSOR CUR_BONUS IS
    SELECT TRIM(USER_NAME) USER_NAME, TRIM(USER_GUID) USER_GUID, BONUS_DATE, TRIM(PHONE_NUMBER) PHONE_NUMBER, TRIM(SIM_NUMBER2) SIM_NUMBER2, BONUS_SUMM
          ,TRIM(OPERATOR) OPERATOR, TRIM(TARIFF_NAME) TARIFF_NAME, TRIM(TARIFF_GUID) TARIFF_GUID
          ,DATE_ACTIVATION, FULL_SUM, BONUS_PERCENT, IS_DIRECT, DATE_LOAD, BONUS_GUID
      FROM LOAD_BONUS;
  CURSOR CUR_ACTIVATION IS
    SELECT TRIM(OPERATOR) OPERATOR, TRIM(TARIFF_NAME) TARIFF_NAME, TRIM(TARIFF_GUID) TARIFF_GUID, TRIM(PHONE_NUMBER) PHONE_NUMBER, DATE_ACTIVATION
          ,TRIM(CONTRAGENT_DESCRIPTION) CONTRAGENT_DESCRIPTION, TRIM(USER_NAME) USER_NAME, TRIM(CONTRAGENT_GUID) CONTRAGENT_GUID, IS_DIRECT, DATE_LOAD 
      FROM LOAD_ACTIVATION
    ORDER BY DATE_ACTIVATION; -- ���� � ������ ����������� ��� ��������� ������ ������, �� ������ ������������ ���������
  CURSOR CUR_CONTRAGENT_REST IS
    SELECT TRIM(CONTRAGENT_DESCRIPTION) CONTRAGENT_DESCRIPTION, TRIM(USER_NAME) USER_NAME, TRIM(CONTRAGENT_GUID) CONTRAGENT_GUID
          ,TRIM(PHONE_NUMBER) PHONE_NUMBER, TRIM(OPERATOR) OPERATOR, TRIM(TARIFF_NAME) TARIFF_NAME, TRIM(TARIFF_GUID) TARIFF_GUID, IS_DIRECT, DATE_LOAD 
      FROM LOAD_CONTRAGENT_REST;
  CURSOR CUR_BALANCE_CHANGE IS
    SELECT TRIM(USER_NAME) USER_NAME, TRIM(USER_GUID) USER_GUID, DATE_TIME, SUM_INCOME, SUM_OUTCOME, BALANCE_AFTER, DATE_LOAD
          ,TRIM(PHONE_NUMBER) PHONE_NUMBER, TRIM(OPERATOR) OPERATOR, TRIM(TARIFF_NAME) TARIFF_NAME, TRIM(TARIFF_GUID) TARIFF_GUID
          ,IS_DIRECT, TRIM(TYPE_CHANGE) TYPE_CHANGE, PERIOD, PERCENT 
      FROM LOAD_BALANCE_CHANGE;
  CURSOR CUR_TARIFF_CHANGE_RULE IS
    SELECT TRIM(TARIFF_GUID_FROM) TARIFF_GUID_FROM, TRIM(TARIFF_NAME_FROM) TARIFF_NAME_FROM, TRIM(TARIFF_GUID_TO) TARIFF_GUID_TO, TRIM(TARIFF_NAME_TO) TARIFF_NAME_TO
          ,DATE_LOAD, IS_DIRECT_FROM, IS_DIRECT_TO, TRIM(OPERATOR_FROM) OPERATOR_FROM, TRIM(OPERATOR_TO) OPERATOR_TO, PRICE 
      FROM LOAD_TARIFF_CHANGE_RULE;
  CURSOR CUR_PHONE_RETURN IS
    SELECT TRIM(CONTRAGENT_DESCRIPTION) CONTRAGENT_DESCRIPTION, TRIM(CONTRAGENT_GUID) CONTRAGENT_GUID, TRIM(PHONE_NUMBER) PHONE_NUMBER, TRIM(SIM_NUMBER2) SIM_NUMBER2
          ,TRIM(OPERATOR) OPERATOR, TRIM(TARIFF_NAME) TARIFF_NAME, TRIM(TARIFF_GUID) TARIFF_GUID, IS_DIRECT, DATE_TIME, DATE_LOAD, DATE_ACTIVATION
      FROM LOAD_PHONE_RETURN;
  CURSOR CUR_CONTRAGENT_PERCENT IS
    SELECT * FROM LOAD_CONTRAGENT_PERCENT;

  CURSOR CUR_TARIFF_PERCENT IS
    SELECT * FROM LOAD_TARIFF_PERCENT;

  CURSOR CUR_CONTR_TARIFF_PERCENT IS
    SELECT * FROM LOAD_CONTRAGENT_TARIFF_PERCENT;

  -- ���������� �� ����� �� GUID-�
  FUNCTION RECREATE_MAIN_STORE(pMAIN_STORE_GUID VARCHAR2, pMAIN_STORE_NAME VARCHAR2) RETURN INTEGER IS
    CURSOR CUR IS
      SELECT MS.D_MAIN_STORE_ID, MS.MAIN_STORE_NAME
        FROM D_MAIN_STORES MS
       WHERE MS.MAIN_STORE_GUID = pMAIN_STORE_GUID;
    vRES CUR%ROWTYPE;
  BEGIN
    vRES.D_MAIN_STORE_ID := NULL;
    IF pMAIN_STORE_GUID IS NOT NULL THEN
      OPEN CUR;
      FETCH CUR INTO vRES;
      IF CUR%NOTFOUND THEN
        INSERT INTO D_MAIN_STORES(MAIN_STORE_GUID, MAIN_STORE_NAME)
        VALUES(pMAIN_STORE_GUID, pMAIN_STORE_NAME)
        RETURNING D_MAIN_STORE_ID INTO vRES.D_MAIN_STORE_ID;
      ELSIF NVL(vRES.MAIN_STORE_NAME, 'NULL') <> NVL(pMAIN_STORE_NAME, 'NULL') THEN
        UPDATE D_MAIN_STORES MS 
        SET MS.MAIN_STORE_NAME = pMAIN_STORE_NAME
        WHERE MS.D_MAIN_STORE_ID = vRES.D_MAIN_STORE_ID;
      END IF;
      CLOSE CUR;
    END IF;
    RETURN vRES.D_MAIN_STORE_ID;
  END;

  -- ���������� �� ����� �� GUID-�
  FUNCTION RECREATE_PHONE_NUMBER(pPHONE_NUMBER VARCHAR2, pOPERATOR_ID INTEGER, pSIM_NUMBER2 VARCHAR2, pTARIFF_ID INTEGER, 
                                 pUSER_ID INTEGER, pCOMMENTS VARCHAR2, pDATE_LOAD DATE, pSTATUS_ID INTEGER, 
                                 pDATE_STATUS DATE, pIS_ACTIVATED_1C NUMBER DEFAULT NULL,
                                 pUSER_ID_STORED INTEGER DEFAULT NULL, pDATE_STORED DATE DEFAULT NULL, pDATE_STORED_LOADED DATE DEFAULT NULL,
                                 pIS_ACTIVE INTEGER DEFAULT 0, pIS_ACTIVE_STORED INTEGER DEFAULT 0, pDATE_ACTIVATION DATE DEFAULT NULL,
                                 pDATE_ACTIVATION_LOADED DATE DEFAULT NULL
                                 ) RETURN INTEGER IS
    CURSOR CUR IS
      SELECT PN.PHONE_NUMBER_ID 
        FROM D_PHONE_NUMBERS PN
       WHERE PN.PHONE_NUMBER = pPHONE_NUMBER;
    vRES INTEGER;
  BEGIN
    OPEN CUR;
    FETCH CUR INTO vRES;
    IF CUR%NOTFOUND THEN
      -- ������� �� �������� �����, ���� �� ������� ��� �������� �������, �� ��������������
      INSERT INTO D_PHONE_NUMBERS(PHONE_NUMBER, OPERATOR_ID, SIM_NUMBER2, TARIFF_ID, USER_ID, COMMENT_OPERATOR, DATE_LOAD, 
                                  IS_ACTIVE, STATUS_ID, STATUS_ID_OPERATOR, IS_ACTIVATED_1C,
                                  USER_ID_STORED, DATE_STORED, DATE_STORED_LOADED, IS_ACTIVE_STORED,
                                  DATE_ACTIVATION, DATE_ACTIVATION_LOADED)
      VALUES(pPHONE_NUMBER, pOPERATOR_ID, pSIM_NUMBER2, pTARIFF_ID, pUSER_ID, pCOMMENTS, pDATE_LOAD, 
             pIS_ACTIVE, pSTATUS_ID, pSTATUS_ID, pIS_ACTIVATED_1C,
             pUSER_ID_STORED, pDATE_STORED, pDATE_STORED_LOADED, pIS_ACTIVE_STORED,
             pDATE_ACTIVATION, pDATE_ACTIVATION_LOADED)
      RETURNING PHONE_NUMBER_ID INTO vRES;
      -- � �������� ��� ���������� ������ ���� ��������� ���� ������
      IF pSTATUS_ID IS NOT NULL THEN
        UPDATE D_PHONE_STATUS_HISTORIES DS
        SET DS.DATE_CHANGE_STATUS = pDATE_STATUS
        WHERE DS.PHONE_NUMBER_ID = vRES;
      END IF;
    END IF;
    CLOSE CUR;
    RETURN vRES;
  EXCEPTION WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, 'pDATE_STATUS = '||NVL(TO_CHAR(pDATE_STATUS, 'DD.MM.YYYY'), 'NULL')||' pSTATUS_ID = '||NVL(TO_CHAR(pSTATUS_ID), 'NULL')||'. ERROR :'||dbms_utility.format_error_stack ||CHR(13)||CHR(10)|| dbms_utility.format_error_backtrace);
  END;

  FUNCTION FIND_CONTRAGENT(pUSER_GUID VARCHAR2) RETURN INTEGER IS
    CURSOR CUR IS
      SELECT UN.USER_ID
        FROM D_USER_NAMES UN
       WHERE UN.GUID = pUSER_GUID;
    vRES INTEGER;
  BEGIN
    OPEN CUR;
    FETCH CUR INTO vRES;
    CLOSE CUR;
    RETURN vRES;
  END;

  FUNCTION RECREATE_MANAGER(pUSER_NAME VARCHAR2, pUSER_GUID VARCHAR2, pUSER_DESCRIPTION VARCHAR2, 
                            pPASSWORD_HASH VARCHAR2, pIS_LOCKED NUMBER,
                            pCURRENT_DATE DATE, pIS_UPLOAD NUMBER) RETURN INTEGER IS
    CURSOR CUR(pUSER_GUID VARCHAR2) IS
      SELECT UN.ROWID R_ID, UN.*
        FROM D_USER_NAMES UN
       WHERE UN.GUID = pUSER_GUID;
    vRES CUR%ROWTYPE;
    vPASSWORD_HASH VARCHAR2(32 CHAR);
    vCHANGED BOOLEAN;
    vCHANGED_STR VARCHAR2(2000 CHAR);
  BEGIN
    IF pUSER_GUID IS NULL OR pUSER_NAME IS NULL THEN
      RETURN NULL;
    ELSE
      vPASSWORD_HASH := S_PWD_HASH(pPASSWORD_HASH);
      
      OPEN CUR(pUSER_GUID);
      FETCH CUR INTO vRES;
      IF CUR%NOTFOUND THEN
        INSERT INTO D_USER_NAMES(DESCRIPTION, USER_NAME, PASSWORD_HASH, GUID, IS_LOCKED, IS_MANAGER, IS_UPLOAD)
        VALUES (pUSER_DESCRIPTION, pUSER_NAME, vPASSWORD_HASH, pUSER_GUID, pIS_LOCKED, 1, pIS_UPLOAD)
        RETURNING USER_ID INTO vRES.USER_ID;
        --
        LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('I', 'CONTRAGENTS', pUSER_GUID, 
                '�������� �������� : ' || pUSER_NAME||CHR(13)||CHR(10)||
                '���� ��������  : '||TO_CHAR(pCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                '��������       : '||pUSER_DESCRIPTION||CHR(13)||CHR(10)||
                '������         : '||vPASSWORD_HASH||CHR(13)||CHR(10)||
                'GUID           : '||pUSER_GUID||CHR(13)||CHR(10)||
                '�������        : '||pIS_LOCKED, NULL);
      ELSE
        vCHANGED := FALSE;
        vCHANGED_STR := '';
        vCHANGED_STR := vCHANGED_STR ||'  ��������              : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(vRES.DESCRIPTION, pUSER_DESCRIPTION, vCHANGED);
        vCHANGED_STR := vCHANGED_STR ||'  ��� ������������      : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(vRES.USER_NAME, pUSER_NAME, vCHANGED);
        vCHANGED_STR := vCHANGED_STR ||'  ������                : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(vRES.PASSWORD_HASH, vPASSWORD_HASH, vCHANGED);
        vCHANGED_STR := vCHANGED_STR ||'  GUID                  : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(vRES.GUID, pUSER_GUID, vCHANGED);
        vCHANGED_STR := vCHANGED_STR ||'  �������               : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(vRES.IS_LOCKED, pIS_LOCKED, vCHANGED);
        vCHANGED_STR := vCHANGED_STR ||'  ��������� �� ����     : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(vRES.IS_UPLOAD, pIS_UPLOAD, vCHANGED);
        vCHANGED_STR := vCHANGED_STR ||'  ��������              : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(vRES.IS_MANAGER, 1, vCHANGED);
        IF vCHANGED THEN
          UPDATE D_USER_NAMES D
            SET D.DESCRIPTION = pUSER_DESCRIPTION
               ,D.USER_NAME = pUSER_NAME
               ,D.PASSWORD_HASH = vPASSWORD_HASH
               ,D.IS_LOCKED = pIS_LOCKED
               ,D.IS_UPLOAD = pIS_UPLOAD
               ,D.GUID = pUSER_GUID
               ,D.IS_MANAGER = 1
          WHERE D.ROWID = vRES.R_ID;
          --
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('U', 'CONTRAGENTS', pUSER_GUID, 
              '������� ��������   : '||pUSER_NAME||CHR(13)||CHR(10)||
              '���� ��������      : '||TO_CHAR(pCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
              'ROWID              : '||vRES.R_ID||CHR(13)||CHR(10)||
              vCHANGED_STR, NULL);
        END IF;
      END IF;
      CLOSE CUR;
      RETURN vRES.USER_ID;
    END IF;
  END;

  FUNCTION RECREATE_OPERATOR(pOPERATOR_NAME VARCHAR2) RETURN INTEGER IS
    CURSOR CUR IS
      SELECT OP.OPERATOR_ID 
        FROM D_OPERATORS OP
       WHERE UPPER(TRIM(OP.OPERATOR_NAME)) = UPPER(TRIM(pOPERATOR_NAME));
    vRES INTEGER;
  BEGIN
    IF TRIM(pOPERATOR_NAME) IS NULL THEN
      vRES := NULL;
    ELSE 
      OPEN CUR;
      FETCH CUR INTO vRES;
      IF CUR%NOTFOUND THEN
        INSERT INTO D_OPERATORS(OPERATOR_NAME)
        VALUES(pOPERATOR_NAME)
        RETURNING OPERATOR_ID INTO vRES;
      END IF;
      CLOSE CUR;
    END IF;
    RETURN vRES;
  END;

  FUNCTION RECREATE_TARIFF(pGUID VARCHAR2, pTARIFF_NAME VARCHAR2, pOPERATOR_ID INTEGER, 
                           pPHONE_NUMBER VARCHAR2, -- ��� ����������� ���� ������ (����������� ��� ������������)
                           pIS_DIRECT NUMBER
                           ) RETURN INTEGER IS
    CURSOR CUR IS
      SELECT TR.* 
        FROM D_TARIFFS TR
       --WHERE UPPER(TRIM(TR.TARIFF_NAME)) = UPPER(TRIM(pTARIFF_NAME))
       --  AND TR.OPERATOR_ID = pOPERATOR_ID;
      WHERE TR.GUID = pGUID;
    REC CUR%ROWTYPE;
  BEGIN
    IF TRIM(pGUID) IS NULL THEN
      RETURN NULL;
    ELSE
      OPEN CUR;
      FETCH CUR INTO REC;
      IF CUR%NOTFOUND THEN
        INSERT INTO D_TARIFFS(OPERATOR_ID, TARIFF_NAME, IS_ACTIVE, GUID, IS_DIRECT)
        VALUES(pOPERATOR_ID, TRIM(pTARIFF_NAME), 1, pGUID, pIS_DIRECT)
        RETURNING TARIFF_ID INTO REC.TARIFF_ID;
      ELSIF (NVL(TRIM(pTARIFF_NAME), 'NULL') <> NVL(TRIM(REC.TARIFF_NAME), 'NULL'))
         OR (NVL(pIS_DIRECT, 0) <> NVL(REC.IS_DIRECT, 0))  THEN
        -- ���� ����� ��� ����, ��������� ���
        --DEBUG_OUT('��������� ������ (PHONE_NUMBER ='||pPHONE_NUMBER||') GUID ='||REC.GUID||'. NAME :'||NVL(REC.TARIFF_NAME, 'NULL')||'->'||NVL(pTARIFF_NAME, 'NULL')||
        --  ', IS_DIRECT = '||NVL(TO_CHAR(REC.IS_DIRECT), 'NULL')||'->'||NVL(TO_CHAR(pIS_DIRECT), 'NULL')
        --);
         
        UPDATE D_TARIFFS TR
           SET TR.IS_DIRECT = pIS_DIRECT
              ,TR.TARIFF_NAME = TRIM(pTARIFF_NAME)
         WHERE TR.TARIFF_ID = REC.TARIFF_ID;
      END IF;
      CLOSE CUR;
      RETURN REC.TARIFF_ID;
    END IF;
  END;
  
  -- �������� ������� ������ ���������� ������� (�� ������ �������)
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ���������
  --              2 - ������, ������ �� �������� � ��� ���������
  --              3 - ������, ������ �� ��������, ��� ��������� � �� ���������� ����
  PROCEDURE RELOAD_PHONE_NUMBERS(pLOG_LEVEL INTEGER DEFAULT 1, 
                                 pPHONE_NUMBER VARCHAR2 DEFAULT NULL -- ��������� ������ ���� ����� (� �������� �����)
                                 ) IS
    vRECORD CUR_PHONE_NUMBER%ROWTYPE;
    vRES BOOLEAN;
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)
    CURSOR CUR(pPHONE_NUMBER VARCHAR2) IS 
      SELECT D.ROWID R_ID, UN.USER_NAME, 
             D.PHONE_NUMBER_ID, D.USER_ID, D.STATUS_ID, 
             D.IS_ACTIVE, D.PRICE, D.USER_ID_STORED, D.DATE_ACTIVATION,
             D.TARIFF_ID, TR.TARIFF_NAME, 
             D.D_MAIN_STORE_ID, MS.MAIN_STORE_NAME             
        FROM D_PHONE_NUMBERS D, D_USER_NAMES UN, D_TARIFFS TR, D_MAIN_STORES MS
       WHERE D.PHONE_NUMBER = pPHONE_NUMBER
         AND D.USER_ID = UN.USER_ID (+)
         AND D.TARIFF_ID = TR.TARIFF_ID (+)
         AND D.D_MAIN_STORE_ID = MS.D_MAIN_STORE_ID (+)
       -- ������� �������� �� GUID-�
       ;
     REC CUR%ROWTYPE;
     vTARIFF_ID INTEGER;
     vOPERATOR_ID INTEGER;
     vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
     vINSERTED_COUNT PLS_INTEGER := 0;
     vUPDATED_COUNT PLS_INTEGER := 0;
     vDELETED_COUNT PLS_INTEGER := 0;
     vRESTORED_COUNT PLS_INTEGER := 0;
     vFOUND_COUNT PLS_INTEGER := 0;
     vTOTAL_COUNT PLS_INTEGER := 0;
     vREST_MINUS PLS_INTEGER := 0;
     vCUT_COUNT PLS_INTEGER := 0;
     vRETURNED_COUNT PLS_INTEGER := 0;
     vSTATUS_ACTIVATED_1C_ID INTEGER;
     
     vCUT_ADDED BOOLEAN;
     vTMP VARCHAR2(100 CHAR);
     vERROR_MESSAGE VARCHAR2(32000);
     vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
     vMAIN_STORE_ID INTEGER;
  BEGIN
    IF GET_STATUS_OPTIONS_ID('ACTIVATED_1C') IS NULL THEN
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'PHONE_NUMBERS', NULL, 
         '������ ��� �������� ������ ���������. � ����������� �������� �� ������ ������ � �����  "ACTIVATED_1C".',
          NULL);
      RETURN;
    ELSE
      vSTATUS_ACTIVATED_1C_ID := GET_STATUS_OPTIONS_ID('ACTIVATED_1C');
    END IF;
    
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'PHONE_NUMBERS', NULL, '�������� �������� ������������ ������ ������'); 
    vCURRENT_DATE := SYSDATE;

    FOR vRECORD IN CUR_PHONE_NUMBER LOOP    
      IF (pPHONE_NUMBER IS NULL OR pPHONE_NUMBER = vRECORD.PHONE_NUMBER)


        AND TRIM(vRECORD.PHONE_NUMBER) IS NOT NULL
      THEN -- ���� ����� ��������� ������� ���� �����
      
        -- ���������� ������������ DATE_LOAD
        IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
          vDATE_LOAD := vRECORD.DATE_LOAD;
        END IF;      
      
        vTOTAL_COUNT := vTOTAL_COUNT + 1;
        vCUT_ADDED := FALSE;
        
        IF vRECORD.REST_COUNT < 0 THEN
          vREST_MINUS := vREST_MINUS + 1;
          IF pLOG_LEVEL > 1 THEN
            LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('O', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                  '������ ����� � ������������� ����������� : ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '���������      : '||vRECORD.COST||CHR(13)||CHR(10)||
                  '��������       : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                  '����� (GUID)   : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                  '�����          : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                  '� SIM 1        : '||vRECORD.SIM_NUMBER1||CHR(13)||CHR(10)||
                  '� SIM 1        : '||vRECORD.SIM_NUMBER2||CHR(13)||CHR(10)||
                  '�������        : '||vRECORD.REST_COUNT, vRECORD.PHONE_NUMBER);
          END IF;
        ELSE
          BEGIN
            vMAIN_STORE_ID := RECREATE_MAIN_STORE(TRIM(vRECORD.MAIN_STORE_GUID), vRECORD.MAIN_STORE_NAME);

            OPEN CUR(vRECORD.PHONE_NUMBER);
            FETCH CUR INTO REC;
            IF CUR%NOTFOUND THEN
              vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
              vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, vRECORD.PHONE_NUMBER, vRECORD.IS_DIRECT);
              
              INSERT INTO D_PHONE_NUMBERS(PHONE_NUMBER, OPERATOR_ID, PRICE, SIM_NUMBER1, SIM_NUMBER2, TARIFF_ID, DATE_LOAD, IS_ACTIVE, D_MAIN_STORE_ID)
              VALUES (vRECORD.PHONE_NUMBER, vOPERATOR_ID, vRECORD.COST, vRECORD.SIM_NUMBER1, vRECORD.SIM_NUMBER2, vTARIFF_ID, vRECORD.DATE_LOAD, 1, vMAIN_STORE_ID);
              
              vINSERTED_COUNT := vINSERTED_COUNT + 1;  
            
              IF pLOG_LEVEL > 1 THEN
                LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('I', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                      '�������� ����� : ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      '���������      : '||vRECORD.COST||CHR(13)||CHR(10)||
                      '��������       : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                      '����� (GUID)   : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                      '�����          : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER1||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER2||CHR(13)||CHR(10)||
                      '�� ������      : '||vRECORD.MAIN_STORE_NAME|| '(' || TRIM(vRECORD.MAIN_STORE_GUID) || ')' ||CHR(13)||CHR(10)||
                      '�������        : '||vRECORD.REST_COUNT, vRECORD.PHONE_NUMBER
                      );
              END IF;
            ELSE
              -- ��� �� ������ ���� ��������� ����� (������������ ��� ������� "������") 
              vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, vRECORD.PHONE_NUMBER, vRECORD.IS_DIRECT);
            
              IF (REC.STATUS_ID = vSTATUS_ACTIVATED_1C_ID) THEN
                -- ����� ��� �����������, ������ �������� �� ����������� ������, ������ �� "������"
                -- ��������� ������� ����, ��� ����� "������"
                
                /*  -- ��������� ��� �� ��������� !            
                INSERT INTO D_PHONE_NUMBER_CUTS
                (PHONE_NUMBER_ID, USER_ID, DATE_ACTIVATED, DATE_CUT)
                VALUES
                (REC.PHONE_NUMBER_ID, REC.USER_ID, REC.DATE_ACTIVATION --GET_DATE_SET_STATUS(REC.PHONE_NUMBER_ID, 'ACTIVATED_1C')
                , vCURRENT_DATE);
                
                vCUT_COUNT := vCUT_COUNT + 1;
                vCUT_ADDED := TRUE;
                */
              
                UPDATE D_PHONE_NUMBERS PH
                   SET PH.STATUS_ID = NULL
                      ,PH.USER_ID = NULL
                      ,PH.IS_ACTIVATED_1C = NULL
                      ,PH.DATE_LOAD = vRECORD.DATE_LOAD
                      ,PH.PRICE = vRECORD.COST
                      ,PH.DESCRIPTION_CHANGED = '����� ��� �����������, �� �� 1� ������ ���������� � ��� ��� �� ��������� �� ����������� ������. ������ ������.'
                      ,PH.D_MAIN_STORE_ID = vMAIN_STORE_ID
                 WHERE PH.ROWID = REC.R_ID;

                /* -- ��������� ��� �� ��������� !
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('C', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                        '"������" ����� : ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                        '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                        '� �����������  : '||REC.USER_NAME, vRECORD.PHONE_NUMBER);
                END IF;
                */
              ELSIF NVL(REC.IS_ACTIVE, 0) = 0 THEN
                -- ���� �� ��� ������� (�������� �������� ��� �������� �������), ����������  
                UPDATE D_PHONE_NUMBERS D
                SET D.PRICE = vRECORD.COST
                   ,D.DATE_LOAD = vRECORD.DATE_LOAD
                   ,D.IS_ACTIVE = 1
                   ,D.D_MAIN_STORE_ID = vMAIN_STORE_ID
                WHERE D.ROWID = REC.R_ID;
                --
                vRESTORED_COUNT := vRESTORED_COUNT + 1;
                --
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('R', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                      '������������  ����� : '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      'ROWID          : '||REC.R_ID||CHR(13)||CHR(10)||
                      '�� ������      : '||vRECORD.MAIN_STORE_NAME|| '(' || TRIM(vRECORD.MAIN_STORE_GUID) || ')' ||CHR(13)||CHR(10)||
                      '���������      : '||REC.PRICE||' -> '||vRECORD.COST/*||CHR(13)||CHR(10)||
                      '��������       : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                      '����� (GUID)   : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                      '�����          : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER1||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER2||CHR(13)||CHR(10)||
                      '�������        : '||vRECORD.REST_COUNT*/, vRECORD.PHONE_NUMBER);
                END IF;
              ELSIF (NVL(REC.PRICE, 0) <> NVL(vRECORD.COST, 0))
                    OR
                    (REC.PRICE IS NULL  AND vRECORD.COST IS NOT NULL) 
                    OR
                    (REC.PRICE IS NOT NULL  AND vRECORD.COST IS NULL) 
              THEN
                -- ���� ���������� ����  
                UPDATE D_PHONE_NUMBERS D
                SET D.PRICE = vRECORD.COST
                   ,D.DATE_LOAD = vRECORD.DATE_LOAD
                   ,D.IS_ACTIVE = 1
                   ,D.D_MAIN_STORE_ID = vMAIN_STORE_ID
                WHERE D.ROWID = REC.R_ID;
                --
                vUPDATED_COUNT := vUPDATED_COUNT + 1;
                --
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('U', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                      '�������  ����� : '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      'ROWID          : '||REC.R_ID||CHR(13)||CHR(10)||
                      '�� ������      : '||vRECORD.MAIN_STORE_NAME|| '(' || TRIM(vRECORD.MAIN_STORE_GUID) || ')' ||CHR(13)||CHR(10)||
                      '���������      : '||REC.PRICE||' -> '||vRECORD.COST/*||CHR(13)||CHR(10)||
                      '��������       : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                      '����� (GUID)   : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                      '�����          : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER1||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER2||CHR(13)||CHR(10)||
                      '�������        : '||vRECORD.REST_COUNT*/, vRECORD.PHONE_NUMBER);
                END IF;
              ELSIF (REC.USER_ID IS NULL) AND (vTARIFF_ID IS NOT NULL) AND
                    (NVL(REC.TARIFF_ID, -1) <> vTARIFF_ID) 
              THEN
                -- ����� �� ��������� �� ������������� � ��������� ����� � 1�  
                UPDATE D_PHONE_NUMBERS D
                SET D.TARIFF_ID = vTARIFF_ID
                   ,D.DATE_LOAD = vRECORD.DATE_LOAD
                   ,D.IS_ACTIVE = 1
                   ,D.D_MAIN_STORE_ID = vMAIN_STORE_ID
                WHERE D.ROWID = REC.R_ID;
                --
                vUPDATED_COUNT := vUPDATED_COUNT + 1;
                --
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('U', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                      '�������  ����� : '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      'ROWID          : '||REC.R_ID||CHR(13)||CHR(10)||
                      '�� ������      : '||vRECORD.MAIN_STORE_NAME|| '(' || TRIM(vRECORD.MAIN_STORE_GUID) || ')' ||CHR(13)||CHR(10)||
                      '�����          : '||REC.TARIFF_NAME||' -> '||vRECORD.TARIFF_NAME/*||CHR(13)||CHR(10)||
                      '��������       : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                      '����� (GUID)   : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                      '�����          : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER1||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER2||CHR(13)||CHR(10)||
                      '�������        : '||vRECORD.REST_COUNT*/, vRECORD.PHONE_NUMBER);
                END IF;              
              ELSIF (NVL(REC.D_MAIN_STORE_ID, -1) <> NVL(vMAIN_STORE_ID, -1)) 
              THEN
                -- ����� ��������� � ������ ������������ ������ �� ������  
                UPDATE D_PHONE_NUMBERS D
                SET D.D_MAIN_STORE_ID = vMAIN_STORE_ID
                WHERE D.ROWID = REC.R_ID;
                --
                vUPDATED_COUNT := vUPDATED_COUNT + 1;
                --
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('U', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                      '�������  ����� : '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      'ROWID          : '||REC.R_ID||CHR(13)||CHR(10)||
                      '����������� ����� : '||REC.MAIN_STORE_NAME||' -> '||vRECORD.MAIN_STORE_NAME/*||CHR(13)||CHR(10)||
                      '��������       : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                      '����� (GUID)   : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                      '�����          : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER1||CHR(13)||CHR(10)||
                      '� SIM 1        : '||vRECORD.SIM_NUMBER2||CHR(13)||CHR(10)||
                      '�������        : '||vRECORD.REST_COUNT*/, vRECORD.PHONE_NUMBER);
                END IF;              
              ELSE 
                -- ������ ������� ���� �������� - ��� �� �������� ����������� ������, ��������� ���� ��������� ����� ���������  
                UPDATE D_PHONE_NUMBERS D
                SET D.DATE_LOAD = vRECORD.DATE_LOAD
                   ,D.IS_ACTIVE = 1
                WHERE D.ROWID = REC.R_ID;
                --
                vFOUND_COUNT := vFOUND_COUNT + 1;
                --
                IF pLOG_LEVEL > 2 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('Y', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                      '����� ��� ���������: '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      'ROWID          : '||REC.R_ID
                      , vRECORD.PHONE_NUMBER);
                END IF;
              END IF;
                
              -- ���� ������ ����� �� ������ �����������
              IF REC.USER_ID_STORED IS NOT NULL THEN
                UPDATE D_PHONE_NUMBERS D
                SET D.USER_ID_STORED = NULL
                   ,D.DATE_STORED = NULL
                   ,D.DATE_LOAD = vRECORD.DATE_LOAD
                   ,D.IS_ACTIVE_STORED = NULL
                   --,DATE_STORED_LOADED = NULL 
                WHERE D.ROWID = REC.R_ID;
                --
                vRETURNED_COUNT := vRETURNED_COUNT + 1;
                --
                -- ����� ��� �� ������ �����������, ������ �������� �� ����������� ������, ������ �� "������"
                -- ��������� ������� ����, ��� ����� "������"
                
                /* -- ��������� ��� �� ��������� !
                IF NOT vCUT_ADDED THEN
                  INSERT INTO D_PHONE_NUMBER_CUTS
                  (PHONE_NUMBER_ID, USER_ID, DATE_ACTIVATED, DATE_CUT)
                  VALUES
                  (REC.PHONE_NUMBER_ID, REC.USER_ID_STORED, NULL -- GET_DATE_SET_STATUS(REC.PHONE_NUMBER_ID, 'ACTIVATED_1C')
                  , vCURRENT_DATE);
                END IF;
                --
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('R', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                      '����� "������" ���� �� ������ ����������� � ������� �� ����� GSM : '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      'ROWID          : '||REC.R_ID||CHR(13)||CHR(10)||
                      '���������      : '||REC.PRICE||' -> '||vRECORD.COST, vRECORD.PHONE_NUMBER);
                END IF;
                */
              END IF;
            END IF;
            CLOSE CUR;
            
          EXCEPTION WHEN OTHERS THEN
              vERROR_COUNT := vERROR_COUNT + 1;
              LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'PHONE_NUMBERS', vRECORD.PHONE_NUMBER, 
                      '������ ��� �������� ������ ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      'vTOTAL_COUNT   :'||vTOTAL_COUNT ||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                       dbms_utility.format_error_backtrace
                      ,
                      vRECORD.PHONE_NUMBER);
               EXIT;
          END;
        END IF;
      END IF;
    END LOOP;

    -- ���� �� ���� �� ����� ������
    -- �������� �� �������� ��� �� ��������� ������, ������� �� ���� ������� � ����� �������� (�� ���� ��������� ��������� �����)
    --
    IF (vERROR_COUNT = 0) AND (pPHONE_NUMBER IS NULL) THEN
      FOR REC IN (SELECT D.ROWID R_ID, D.DATE_LOAD, D.PHONE_NUMBER, D.PRICE
                    FROM D_PHONE_NUMBERS D
                   WHERE D.IS_ACTIVE = 1
                     AND D.USER_ID IS NULL -- �� � ������ �� � ������ ������������
                     AND D.USER_ID_STORED IS NULL -- �� ����� �� ������ �� � ������ ������������
                     AND NVL(D.DATE_LOAD, TO_DATE('01.01.1900', 'DD.MM.YYYY')) <> vDATE_LOAD)
      LOOP
        --IF NVL(REC.DATE_LOAD, TO_DATE('01.01.1900', 'DD.MM.YYYY')) <> vRECORD.DATE_LOAD THEN
            -- ������ ������� ���� �������� - ��� �� �������� ����������� ������, ���������  
            UPDATE D_PHONE_NUMBERS D
            SET D.DATE_LOAD = vDATE_LOAD
               ,D.IS_ACTIVE = 0
            WHERE D.ROWID = REC.R_ID;
            --
            vDELETED_COUNT := vDELETED_COUNT + 1;
            --           
            IF pLOG_LEVEL > 1 THEN
              LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('D', 'PHONE_NUMBERS', REC.PHONE_NUMBER, 
                  '������  ����� : '||REC.PHONE_NUMBER||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  'ROWID          : '||REC.R_ID||CHR(13)||CHR(10)||
                  '���������      : '||REC.PRICE, REC.PHONE_NUMBER);
            END IF;
        --END IF;        
      END LOOP;
    END IF;
    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'PHONE_NUMBERS', NULL,
                  '�������� ������� ��������� '||S_GET_DELTA_TIME_STR(vDATE, vCURRENT_DATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  '����� �� ������  : '||vTOTAL_COUNT||CHR(13)||CHR(10)||
                  '����� ���������  : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
                  '��������         : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  '���������� ����-�: '||vRESTORED_COUNT||CHR(13)||CHR(10)||
                  '�������-� �������: '||vREST_MINUS||CHR(13)||CHR(10)||                  
                  '��� ���������    : '||vFOUND_COUNT||CHR(13)||CHR(10)||
                  '������� �������  : '||vCUT_COUNT||CHR(13)||CHR(10)||
                  '--'||CHR(13)||CHR(10)||
                  '���������� �� ������ ����������� : '||vRETURNED_COUNT||CHR(13)||CHR(10)||                                    
                  '������� �� ������: '||vDELETED_COUNT,
                   NULL);
    END IF;
    COMMIT;
  END;

  -- ��������� ������ �����������
  FUNCTION GET_USER_BALANCE(pUSER_ID INTEGER) RETURN NUMBER IS
    vRES NUMBER;
    CURSOR CUR(pUSER_ID INTEGER) IS 
      SELECT D.BALANCE_NUM
        FROM D_BALANCES D
       WHERE D.USER_ID = pUSER_ID
       ORDER BY D.BALANCE_DATE DESC;  
  BEGIN
    OPEN CUR(pUSER_ID);
    FETCH CUR INTO vRES;
    CLOSE CUR;
    RETURN vRES;
  END;
     
  -- �������� ������� ������ ������������ (�� ������ �������)
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ���������
  --              2 - ������, ������ �� �������� � ��� ���������
  --              3 - ������, ������ �� ��������, ��� ��������� � �� ���������� ����
  PROCEDURE RELOAD_CONTRAGENTS(pLOG_LEVEL INTEGER DEFAULT 1) 
  IS  
    vRECORD CUR_CONTRAGENT%ROWTYPE;
    vUSER_ID NUMBER(8);
    vRES BOOLEAN;
    --vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)
    CURSOR CUR(pGUID VARCHAR2) IS 
      
      SELECT D.ROWID R_ID 
            ,D.*
            ,GET_USER_BALANCE(D.USER_ID) BALANCE
            ,MANAGER.USER_NAME MANAGER_USER_NAME
            ,MANAGER.DESCRIPTION MANAGER_DESCRIPTION
            ,MANAGER.PASSWORD_HASH MANAGER_PASSWORD_HASH
            ,MANAGER.GUID MANAGER_GUID
            ,MANAGER.IS_LOCKED MANAGER_IS_LOCKED
            ,MANAGER.IS_DELETED MANAGER_IS_DELETED             
        FROM D_USER_NAMES D, D_USER_NAMES MANAGER
       WHERE D.GUID = pGUID
         AND D.MANAGER_ID = MANAGER.USER_ID (+)
         --and d.guid='48a32753-8b65-11e4-8099-de2efd98768a'
       -- ������� �������� �� GUID-�
       ;

     CURSOR CUR_BALANCE(pUSER_ID INTEGER) IS
       SELECT DB.BALANCE_ID
       FROM D_BALANCES DB
       WHERE DB.USER_ID = pUSER_ID
       ORDER BY DB.BALANCE_DATE DESC;
       
     REC CUR%ROWTYPE;
     vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
     vINSERTED_COUNT PLS_INTEGER := 0;
     vUPDATED_COUNT PLS_INTEGER := 0;
     --vDELETED_COUNT PLS_INTEGER := 0;
     --vRESTORED_COUNT PLS_INTEGER := 0;
     vFOUND_COUNT PLS_INTEGER := 0;
     vTOTAL_COUNT PLS_INTEGER := 0;
     --vREST_MINUS PLS_INTEGER := 0;
     vCHANGED_STR VARCHAR2(2000 CHAR);
     vCHANGED BOOLEAN;
     vCHANGED_BALANCE BOOLEAN;
     vBALANCE_ID INTEGER;
     
     vMANAGER_ID INTEGER;
     vERROR_MESSAGE VARCHAR2(32000);
     vPASSWORD_DEFAULT VARCHAR2(50 char);
     vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
     vDATE_CHANGE_PASSWORD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'CONTRAGENTS', NULL, '�������� ������������ ������');
    vPASSWORD_DEFAULT := S_PWD_HASH('gsm1234567890');  -- ������ �� ���������  

    vCURRENT_DATE := SYSDATE;
    FOR vRECORD IN CUR_CONTRAGENT LOOP    

      -- ���������� ������������ DATE_LOAD
      IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
        vDATE_LOAD := vRECORD.DATE_LOAD;
      END IF;      

      vTOTAL_COUNT := vTOTAL_COUNT + 1;
      vRECORD.PASSWORD_HASH := S_PWD_HASH(vRECORD.PASSWORD_HASH);
      vMANAGER_ID := RECREATE_MANAGER(vRECORD.MANAGER_USER_NAME, vRECORD.MANAGER_GUID, vRECORD.MANAGER_DESCRIPTION, 
                                      vRECORD.MANAGER_PASSWORD_HASH, vRECORD.MANAGER_IS_LOCKED, vCURRENT_DATE, vRECORD.MANAGER_IS_UPLOAD);
    
      BEGIN
        OPEN CUR(vRECORD.GUID);
        FETCH CUR INTO REC;
        IF CUR%NOTFOUND THEN
          -- ��������� �� ��������� 
          IF NVL(REC.IS_DELETED, 0) <> 1 THEN

            INSERT INTO D_USER_NAMES(DESCRIPTION, USER_NAME, PASSWORD_HASH, GUID, IS_LOCKED, IS_CONTRAGENT, MANAGER_ID, IS_UPLOAD, IS_DELETED)
            VALUES (vRECORD.DESCRIPTION, vRECORD.USER_NAME, nvl(vRECORD.PASSWORD_HASH, vPASSWORD_DEFAULT), vRECORD.GUID, vRECORD.IS_LOCKED, 1, vMANAGER_ID, vRECORD.IS_UPLOAD, vRECORD.IS_DELETED)
            RETURNING USER_ID INTO vUSER_ID;
            --
            INSERT INTO D_BALANCES(USER_ID, BALANCE_DATE, BALANCE_NUM)
            VALUES(vUSER_ID, vCURRENT_DATE, vRECORD.BALANCE); 
            --  
            vINSERTED_COUNT := vINSERTED_COUNT + 1;  
            --
            IF pLOG_LEVEL > 1 THEN
              LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('I', 'CONTRAGENTS', vRECORD.GUID, 
                    '�������� ���������� : ' || vRECORD.USER_NAME||CHR(13)||CHR(10)||
                    '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                    '��������       : '||vRECORD.DESCRIPTION||CHR(13)||CHR(10)||
                    '������         : '||vRECORD.PASSWORD_HASH||CHR(13)||CHR(10)||
                    'GUID           : '||vRECORD.GUID||CHR(13)||CHR(10)||
                    '������         : '||vRECORD.BALANCE||CHR(13)||CHR(10)||
                    '����������     : '||vRECORD.IS_LOCKED||CHR(13)||CHR(10)||
                    '������         : '||vRECORD.IS_DELETED||CHR(13)||CHR(10)||
                    '��������� �� ����: '||vRECORD.IS_UPLOAD||CHR(13)||CHR(10)||                  
                    '--'||vRECORD.BALANCE||CHR(13)||CHR(10)||
                    '��������       : '||vRECORD.MANAGER_USER_NAME||CHR(13)||CHR(10)|| 
                    '  GUID ���     : '||vRECORD.MANAGER_GUID||CHR(13)||CHR(10)||
                    '  �������� ��� : '||vRECORD.MANAGER_DESCRIPTION||CHR(13)||CHR(10)||
                    '  ������ ���   : '||vRECORD.MANAGER_PASSWORD_HASH||CHR(13)||CHR(10)||
                    '  ������ ������: '||vRECORD.MANAGER_IS_DELETED||CHR(13)||CHR(10)||
                    '  ���������� ��: '||vRECORD.MANAGER_IS_LOCKED
                    , NULL);
            END IF;
          END IF;
        ELSE
          vCHANGED := FALSE;
          vCHANGED_BALANCE := FALSE;
          vCHANGED_STR := '';
          vCHANGED_STR := vCHANGED_STR ||'  ��������              : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.DESCRIPTION, vRECORD.DESCRIPTION, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'  ��� ������������      : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.USER_NAME, vRECORD.USER_NAME, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'  ������                : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.PASSWORD_HASH, vRECORD.PASSWORD_HASH, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'  GUID                  : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.GUID, vRECORD.GUID, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'  ������������          : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.IS_LOCKED, vRECORD.IS_LOCKED, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'  ������                : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.IS_DELETED, vRECORD.IS_DELETED, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'  ��������� �� ����     : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.IS_UPLOAD, vRECORD.IS_UPLOAD, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'  ������                : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.BALANCE, vRECORD.BALANCE, vCHANGED_BALANCE);                   


          vCHANGED_STR := vCHANGED_STR ||'  ��������              : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.MANAGER_DESCRIPTION, vRECORD.MANAGER_DESCRIPTION, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'    ���                 : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.MANAGER_USER_NAME, vRECORD.MANAGER_USER_NAME, vCHANGED);
          --vCHANGED_STR := vCHANGED_STR ||'    ������              : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.MANAGER_PASSWORD_HASH, vRECORD.MANAGER_PASSWORD_HASH, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'    GUID                : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.MANAGER_GUID, vRECORD.MANAGER_GUID, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'    ������������        : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.MANAGER_IS_LOCKED, vRECORD.MANAGER_IS_LOCKED, vCHANGED);
          vCHANGED_STR := vCHANGED_STR ||'    ������              : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.MANAGER_IS_DELETED, vRECORD.MANAGER_IS_DELETED, vCHANGED);

          IF vCHANGED OR vCHANGED_BALANCE THEN
            IF vCHANGED THEN
              IF nvl(rec.DATE_CHANGE_PASSWORD, TO_DATE('01.01.2000', 'DD.MM.YYYY')) > nvl(vRECORD.DATE_CHANGE_PASSWORD,TO_DATE('01.01.1900', 'DD.MM.YYYY')) THEN
                vDATE_CHANGE_PASSWORD := TO_DATE('01.01.1900', 'DD.MM.YYYY');
                UPDATE D_USER_NAMES D
                SET D.DESCRIPTION = vRECORD.DESCRIPTION
                   ,D.USER_NAME = vRECORD.USER_NAME
                   --,D.PASSWORD_HASH = vRECORD.PASSWORD_HASH
                   ,D.IS_LOCKED = vRECORD.IS_LOCKED
                   ,D.IS_UPLOAD = vRECORD.IS_UPLOAD
                   ,D.IS_DELETED = vRECORD.IS_DELETED
                   ,D.GUID = vRECORD.GUID
                   ,D.IS_CONTRAGENT = 1
                   ,D.MANAGER_ID = vMANAGER_ID
                   --,D.DATE_CHANGE_PASSWORD = vRECORD.DATE_CHANGE_PASSWORD 
                WHERE D.ROWID = REC.R_ID;                
              ELSE
                vDATE_CHANGE_PASSWORD := vRECORD.DATE_CHANGE_PASSWORD;
                -- ���� �������� ������ � 1�, �� ��������� ���� ���������� � 1�. ���� ��� �����, �� � ��������� �������� ������ ������ � ����������� ���� ����������. 
                UPDATE D_USER_NAMES D
                SET D.DESCRIPTION = vRECORD.DESCRIPTION
                   ,D.USER_NAME = vRECORD.USER_NAME
                   ,D.PASSWORD_HASH = vRECORD.PASSWORD_HASH -- ���� ��� ��������� �������������� ������ � ��������� � ��� �� ����
                   ,D.IS_LOCKED = vRECORD.IS_LOCKED
                   ,D.IS_UPLOAD = vRECORD.IS_UPLOAD
                   ,D.IS_DELETED = vRECORD.IS_DELETED
                   ,D.GUID = vRECORD.GUID
                   ,D.IS_CONTRAGENT = 1
                   ,D.MANAGER_ID = vMANAGER_ID
                   ,D.DATE_CHANGE_PASSWORD = vRECORD.DATE_CHANGE_PASSWORD 
                WHERE D.ROWID = REC.R_ID;                
              END IF;

            END IF;
            --
            IF vCHANGED_BALANCE THEN 
              INSERT INTO D_BALANCES(USER_ID, BALANCE_DATE, BALANCE_NUM, DATE_LOAD)
              VALUES(REC.USER_ID, vCURRENT_DATE, vRECORD.BALANCE, vRECORD.DATE_LOAD);
            END IF;
            --            
            vUPDATED_COUNT := vUPDATED_COUNT + 1;
            --
            IF pLOG_LEVEL > 1 THEN
              LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('U', 'CONTRAGENTS', vRECORD.GUID, 
                  '������� ���������� : '||vRECORD.USER_NAME||CHR(13)||CHR(10)||
                  '���� ��������      : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  'ROWID              : '||REC.R_ID||CHR(13)||CHR(10)||
                  vCHANGED_STR, NULL);
            END IF;
          ELSE
            vFOUND_COUNT := vFOUND_COUNT + 1;
            --
            IF pLOG_LEVEL > 2 THEN

              LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('Y', 'CONTRAGENTS', vRECORD.GUID, 
                  '���������� ��� ��������� : '||vRECORD.USER_NAME||CHR(13)||CHR(10)||
                  '���� ��������            : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  'ROWID                    : '||REC.R_ID||CHR(13)||CHR(10)||
                  vCHANGED_STR, NULL);
            END IF;
          END IF;
          -- ���� ������ �� ���������, �� ������� ���� �������� � ���������� �������
          IF NOT vCHANGED_BALANCE THEN
            vBALANCE_ID := NULL;
            OPEN CUR_BALANCE(REC.USER_ID);
            FETCH CUR_BALANCE INTO vBALANCE_ID;
            CLOSE CUR_BALANCE;
            IF vBALANCE_ID IS NOT NULL THEN
              UPDATE D_BALANCES DB
              SET DB.DATE_LOAD = vRECORD.DATE_LOAD 
              WHERE DB.BALANCE_ID = vBALANCE_ID;
            END IF;
          END IF;          
        END IF;
        CLOSE CUR;
      EXCEPTION WHEN OTHERS THEN
          vERROR_COUNT := vERROR_COUNT + 1;
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTRAGENTS', vRECORD.GUID, 
                  '������ ��� �������� ����������� ' || vRECORD.USER_NAME||CHR(13)||CHR(10)||
                  'vTOTAL_COUNT   :'||vTOTAL_COUNT ||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                   dbms_utility.format_error_backtrace
                  ,
                  NULL);
           EXIT;
      END;
    END LOOP;

    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'CONTRAGENTS', NULL,
                  '�������� ������������ ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  '����� �� ������  : '||vTOTAL_COUNT||CHR(13)||CHR(10)||
                  '����� ���������  : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
                  '��������         : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  --'������� �� ������: '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  --'���������� ����-�: '||vRESTORED_COUNT||CHR(13)||CHR(10)||
                  --'�������-� �������: '||vREST_MINUS||CHR(13)||CHR(10)||                  
                  '��� ���������    : '||vFOUND_COUNT,
                   NULL);
                   
    END IF;
    COMMIT;
  END;
  
  -- �������� ������� ������ ������� 
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_BONUSES_OLD(pLOG_LEVEL INTEGER DEFAULT 1) 
  IS
    vRECORD CUR_BONUS%ROWTYPE;
    vUSER_ID NUMBER(8);
    vTARIFF_ID INTEGER;
    vOPERATOR_ID INTEGER;
    vPHONE_NUMBER_ID INTEGER;
    
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)

    vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
    vINSERTED_COUNT PLS_INTEGER := 0;
    --vUPDATED_COUNT PLS_INTEGER := 0;
    vDELETED_COUNT PLS_INTEGER := 0;
    vSKIPED_COUNT PLS_INTEGER := 0;
    --vRESTORED_COUNT PLS_INTEGER := 0;
    --vFOUND_COUNT PLS_INTEGER := 0;
    --vTOTAL_COUNT PLS_INTEGER := 0;
    --vREST_MINUS PLS_INTEGER := 0;
     vCONTRAGENTS_ARRAY T_CONTRAGENTS_ARRAY;
     
     vERROR_MESSAGE VARCHAR2(32000);
     vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
     vIS_TRUNCATE BOOLEAN; -- ������� ���������� �������� TRUNCATE TABLE D_BALANCE_CHANGES REUSE STORAGE
     vCOUNT_TRUNCATE INTEGER;
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'BONUSES', NULL, '�������� ������� ������'); 

    vCURRENT_DATE := SYSDATE;
    
    -- v2
    vIS_TRUNCATE := FALSE;
    vCOUNT_TRUNCATE := 0;
    WHILE (NOT vIS_TRUNCATE) LOOP  -- �� ��� ��� ���� �� ��������� �������� ��������
      BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE D_BONUSES REUSE STORAGE';
        vIS_TRUNCATE := TRUE;  -- �������� ���������
      EXCEPTION 
        WHEN OTHERS THEN
          vCOUNT_TRUNCATE := vCOUNT_TRUNCATE + 1;
          DBMS_LOCK.SLEEP(1);
          IF (vCOUNT_TRUNCATE > 10) THEN  -- ���� TRUNCATE ��� � �� ������ ����� ���� �������, �� ������� ����������
            RAISE_APPLICATION_ERROR(-20000, '������! ������ �� ���������! '||vCOUNT_TRUNCATE ||' ������� �������� ������� � �������� ��������� ����������.' 
                                  ||CHR(13)||CHR(10)||' ������: '||sqlerrm); --  � ����� �������
          END IF;
      END;
    END LOOP; 
    
    
    --
    vDELETED_COUNT := SQL%ROWCOUNT;
    --
    FOR vRECORD IN CUR_BONUS LOOP
      BEGIN
        -- ���������� ������������ DATE_LOAD
        IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
          vDATE_LOAD := vRECORD.DATE_LOAD;
        END IF;      
      
        IF NOT vCONTRAGENTS_ARRAY.EXISTS(vRECORD.USER_GUID) THEN
          vCONTRAGENTS_ARRAY(vRECORD.USER_GUID) := FIND_CONTRAGENT(vRECORD.USER_GUID);
        END IF;
        vUSER_ID := vCONTRAGENTS_ARRAY(vRECORD.USER_GUID);
        
        IF vUSER_ID IS NOT NULL THEN        
          vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
          vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, vRECORD.PHONE_NUMBER, vRECORD.IS_DIRECT);
          --IF vRECORD.PHONE_NUMBER = '9299565213' THEN
          --  DEBUG_OUT(vTARIFF_ID||'_'||vRECORD.TARIFF_GUID||'_'||vRECORD.TARIFF_NAME||'_'||vOPERATOR_ID||'_'||vRECORD.PHONE_NUMBER||'_'||vRECORD.IS_DIRECT);
          --END IF;
    
          vPHONE_NUMBER_ID := RECREATE_PHONE_NUMBER(vRECORD.PHONE_NUMBER, vOPERATOR_ID, vRECORD.SIM_NUMBER2, vTARIFF_ID,
                                                    NULL /*vUSER_ID*/, -- ����� ����� �� �������� �� ����� �����������, ������ ����� ���� � �� �� ������������� �������  
                                                    '�������� ��� �������� �������', vCURRENT_DATE,
                                                    --CASE vRECORD.DATE_ACTIVATION WHEN NULL THEN NULL ELSE GET_STATUS_OPTIONS_ID('ACTIVATED_1C') END,
                                                    CASE NVL(vRECORD.DATE_ACTIVATION, TO_DATE('01.01.1890', 'DD.MM.YYYY')) WHEN TO_DATE('01.01.1890', 'DD.MM.YYYY') THEN TO_NUMBER(NULL) ELSE GET_STATUS_OPTIONS_ID('ACTIVATED_1C') END, 
                                                    vRECORD.DATE_ACTIVATION
                                                    );
        
          INSERT INTO D_BONUSES(USER_ID, BONUS_DATE, PHONE_NUMBER_ID, SIM_NUMBER2, BINUS_SUMM, OPERATOR_ID, TARIFF_ID, DATE_ACTIVATION, FULL_SUM, BONUS_PERCENT, LOAD_DATE)
          VALUES (vUSER_ID, vRECORD.BONUS_DATE, vPHONE_NUMBER_ID, vRECORD.SIM_NUMBER2, vRECORD.BONUS_SUMM, vOPERATOR_ID, vTARIFF_ID, vRECORD.DATE_ACTIVATION, vRECORD.FULL_SUM, vRECORD.BONUS_PERCENT, vCURRENT_DATE);
          --  
          vINSERTED_COUNT := vINSERTED_COUNT + 1;
        ELSE
          vSKIPED_COUNT := vSKIPED_COUNT + 1;
        END IF; 
        
        --COMMIT; 
      EXCEPTION WHEN OTHERS THEN
          vERROR_COUNT := vERROR_COUNT + 1;
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'BONUSES', NULL, 
                  '������ ��� �������� ������ ��� ����������� ' || vRECORD.USER_NAME||' ('||vRECORD.USER_GUID||')'||CHR(13)||CHR(10)||
                  '��� ������     : '||vRECORD.PHONE_NUMBER ||CHR(13)||CHR(10)||
                  '���� ������    : '||TO_CHAR(vRECORD.BONUS_DATE, 'DD.MM.YYYY HH24:MI:SS') ||CHR(13)||CHR(10)||
                  '������ ������  : '||vRECORD.BONUS_SUMM ||CHR(13)||CHR(10)||

                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                  dbms_utility.format_error_backtrace
                  ,
                  NULL);
          EXIT;
      END;
    END LOOP;

    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'BONUSES', NULL,
                  '�������� ������� ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  --'����� �� ������  : '||vTOTAL_COUNT||CHR(13)||CHR(10)||
                  '�������          : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  '�� ��������� (��� �����������) : '||vSKIPED_COUNT||CHR(13)||CHR(10)||                  
                  '���������        : '||vINSERTED_COUNT--||CHR(13)||CHR(10)||
                  --'��������         : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  --'���������� ����-�: '||vRESTORED_COUNT||CHR(13)||CHR(10)||
                  --'�������-� �������: '||vREST_MINUS||CHR(13)||CHR(10)||                  
                  --'��� ���������    : '||vFOUND_COUNT
                  ,
                   NULL);

                   
    END IF;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
      vERROR_COUNT := vERROR_COUNT + 1;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'BONUSES', NULL, 
              '������ ��� �������� ������� '||CHR(13)||CHR(10)||
              '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
              '����� �������  : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
              dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
              dbms_utility.format_error_backtrace
              ,
              NULL);
  END;

  -- �������� ������� ������ ������� 
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_BONUSES(pLOG_LEVEL INTEGER DEFAULT 1) 
  IS
    vRECORD CUR_BONUS%ROWTYPE;
    vUSER_ID NUMBER(8);
    vTARIFF_ID INTEGER;
    vOPERATOR_ID INTEGER;
    vPHONE_NUMBER_ID INTEGER;
    
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)

    vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
    vINSERTED_COUNT PLS_INTEGER := 0;
    --vUPDATED_COUNT PLS_INTEGER := 0;
    vDELETED_COUNT PLS_INTEGER := 0;
    vSKIPED_COUNT PLS_INTEGER := 0;
    vNO_CHANGE_COUNT PLS_INTEGER := 0;
    vCHANGE_COUNT PLS_INTEGER := 0;
    --vRESTORED_COUNT PLS_INTEGER := 0;
    --vFOUND_COUNT PLS_INTEGER := 0;
    --vTOTAL_COUNT PLS_INTEGER := 0;
    --vREST_MINUS PLS_INTEGER := 0;
     vCONTRAGENTS_ARRAY T_CONTRAGENTS_ARRAY;
     
     vERROR_MESSAGE VARCHAR2(32000);
     vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
     
     CURSOR CUR_BONUS_EXIST(pBONUS_GUID VARCHAR2) IS
       SELECT D.BINUS_SUMM
            , D.BONUS_DATE
            , D.BONUS_GUID
            , D.BONUS_ID
            , D.BONUS_PERCENT
            , D.DATE_ACTIVATION
            , D.FULL_SUM
            , D.OPERATOR_ID
            , D.PHONE_NUMBER_ID
            , D.SIM_NUMBER2
            , D.TARIFF_ID            
            , D.USER_ID            
         FROM D_BONUSES D
        WHERE D.BONUS_GUID = pBONUS_GUID         
     ;     
     vCUR_BONUS CUR_BONUS_EXIST%ROWTYPE;
               
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'BONUSES', NULL, '�������� ������� ������'); 

    vCURRENT_DATE := SYSDATE;
    
    --EXECUTE IMMEDIATE 'TRUNCATE TABLE D_BONUSES REUSE STORAGE';
    --
    vDELETED_COUNT := SQL%ROWCOUNT;
    
    -- ������� ���������, �� ������ ������� ����� �������. ��, ��� ����������� � LOAD_BONUSES 
    DELETE 
      FROM D_BONUSES D 
     WHERE nvl(D.BONUS_GUID, '0') NOT IN 
              (
--               SELECT BONUS_GUID
--                 FROM
--                  ( 
                   SELECT nvl(LB.BONUS_GUID, '-1')
                     FROM LOAD_BONUS LB
                     /*union
                   SELECT '-1' BONUS_GUID
                     FROM DUAL
                  )    */                
              )
       --AND D.BONUS_GUID
    ; 
    vDELETED_COUNT := SQL%ROWCOUNT;
    
    --
    FOR vRECORD IN CUR_BONUS LOOP
      BEGIN
        -- ���������� ������������ DATE_LOAD
        IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
          vDATE_LOAD := vRECORD.DATE_LOAD;
        END IF;      
      
        IF NOT vCONTRAGENTS_ARRAY.EXISTS(vRECORD.USER_GUID) THEN
          vCONTRAGENTS_ARRAY(vRECORD.USER_GUID) := FIND_CONTRAGENT(vRECORD.USER_GUID);
        END IF;
        vUSER_ID := vCONTRAGENTS_ARRAY(vRECORD.USER_GUID);
        
        IF vUSER_ID IS NOT NULL THEN        
          vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
          vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, vRECORD.PHONE_NUMBER, vRECORD.IS_DIRECT);
          --IF vRECORD.PHONE_NUMBER = '9299565213' THEN
          --  DEBUG_OUT(vTARIFF_ID||'_'||vRECORD.TARIFF_GUID||'_'||vRECORD.TARIFF_NAME||'_'||vOPERATOR_ID||'_'||vRECORD.PHONE_NUMBER||'_'||vRECORD.IS_DIRECT);
          --END IF;
    
          vPHONE_NUMBER_ID := RECREATE_PHONE_NUMBER(vRECORD.PHONE_NUMBER, vOPERATOR_ID, vRECORD.SIM_NUMBER2, vTARIFF_ID,
                                                    NULL /*vUSER_ID*/, -- ����� ����� �� �������� �� ����� �����������, ������ ����� ���� � �� �� ������������� �������  
                                                    '�������� ��� �������� �������', vCURRENT_DATE,
                                                    --CASE vRECORD.DATE_ACTIVATION WHEN NULL THEN NULL ELSE GET_STATUS_OPTIONS_ID('ACTIVATED_1C') END,
                                                    CASE NVL(vRECORD.DATE_ACTIVATION, TO_DATE('01.01.1890', 'DD.MM.YYYY')) WHEN TO_DATE('01.01.1890', 'DD.MM.YYYY') THEN TO_NUMBER(NULL) ELSE GET_STATUS_OPTIONS_ID('ACTIVATED_1C') END, 
                                                    vRECORD.DATE_ACTIVATION
                                                    );
          OPEN CUR_BONUS_EXIST (vRECORD.BONUS_GUID);
          FETCH CUR_BONUS_EXIST INTO vCUR_BONUS;          
          
          IF CUR_BONUS_EXIST%NOTFOUND THEN -- ���� �� ����� ����� �� ����������� �����, �� ��������� ���  
            INSERT INTO D_BONUSES(USER_ID, BONUS_DATE, PHONE_NUMBER_ID, SIM_NUMBER2, BINUS_SUMM, OPERATOR_ID, TARIFF_ID, DATE_ACTIVATION, FULL_SUM, BONUS_PERCENT, LOAD_DATE, BONUS_GUID)
            VALUES (vUSER_ID, vRECORD.BONUS_DATE, vPHONE_NUMBER_ID, vRECORD.SIM_NUMBER2, vRECORD.BONUS_SUMM, vOPERATOR_ID, vTARIFF_ID, vRECORD.DATE_ACTIVATION, vRECORD.FULL_SUM, vRECORD.BONUS_PERCENT, vCURRENT_DATE, vRECORD.BONUS_GUID);
            --  
            vINSERTED_COUNT := vINSERTED_COUNT + 1;
          ELSE
            --���� ���� ������������ �� �����, �� ��������� 
            IF
                 ( NVL(vCUR_BONUS.USER_ID,0) <> NVL(vUSER_ID,0) )
              OR ( NVL(vCUR_BONUS.BONUS_DATE, SYSDATE) <> NVL(vRECORD.BONUS_DATE, SYSDATE) )
              OR ( NVL(vCUR_BONUS.PHONE_NUMBER_ID, 0) <> nvl(vPHONE_NUMBER_ID, 0) )
              OR ( NVL(vCUR_BONUS.SIM_NUMBER2,'') <> NVL(vRECORD.SIM_NUMBER2, '') )
              OR ( NVL(vCUR_BONUS.BINUS_SUMM, 0) <> NVL(vRECORD.BONUS_SUMM, 0) )
              OR ( NVL(vCUR_BONUS.OPERATOR_ID, 0) <> NVL(vOPERATOR_ID, 0) )
              OR ( NVL(vCUR_BONUS.TARIFF_ID, 0) <> NVL(vTARIFF_ID, 0) )
              OR ( NVL(vCUR_BONUS.DATE_ACTIVATION, SYSDATE) <> NVL(vRECORD.DATE_ACTIVATION, SYSDATE) )
              OR ( NVL(vCUR_BONUS.FULL_SUM, 0) <> NVL(vRECORD.FULL_SUM, 0) )
              OR ( NVL(vCUR_BONUS.BONUS_PERCENT, 0) <> NVL(vRECORD.BONUS_PERCENT, 0) )                            
            THEN 
              update D_BONUSES 
                 set USER_ID         = vUSER_ID
                   , BONUS_DATE      = vRECORD.BONUS_DATE
                   , PHONE_NUMBER_ID = vPHONE_NUMBER_ID
                   , SIM_NUMBER2     = vRECORD.SIM_NUMBER2
                   , BINUS_SUMM      = vRECORD.BONUS_SUMM
                   , OPERATOR_ID     = vOPERATOR_ID
                   , TARIFF_ID       = vTARIFF_ID
                   , DATE_ACTIVATION = vRECORD.DATE_ACTIVATION
                   , FULL_SUM        = vRECORD.FULL_SUM
                   , BONUS_PERCENT   = vRECORD.BONUS_PERCENT
               where BONUS_ID = vCUR_BONUS.BONUS_ID

              ;              
              vCHANGE_COUNT := vCHANGE_COUNT + 1;
            ELSE
              vNO_CHANGE_COUNT := vNO_CHANGE_COUNT + 1;  -- ������� �������������
            END IF;
          END IF;
          
          CLOSE CUR_BONUS_EXIST;
                    
        ELSE
          vSKIPED_COUNT := vSKIPED_COUNT + 1;
        END IF; 
        
        --COMMIT; 
      EXCEPTION WHEN OTHERS THEN
          vERROR_COUNT := vERROR_COUNT + 1;
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'BONUSES', NULL, 
                  '������ ��� �������� ������ ��� ����������� ' || vRECORD.USER_NAME||' ('||vRECORD.USER_GUID||')'||CHR(13)||CHR(10)||
                  '��� ������     : '||vRECORD.PHONE_NUMBER ||CHR(13)||CHR(10)||
                  '���� ������    : '||TO_CHAR(vRECORD.BONUS_DATE, 'DD.MM.YYYY HH24:MI:SS') ||CHR(13)||CHR(10)||
                  '������ ������  : '||vRECORD.BONUS_SUMM ||CHR(13)||CHR(10)||

                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                  dbms_utility.format_error_backtrace
                  ,
                  NULL);
          EXIT;
      END;
    END LOOP;

    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'BONUSES', NULL,
                  '�������� ������� ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  --'����� �� ������  : '||vTOTAL_COUNT||CHR(13)||CHR(10)||
                  '�������          : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  '�� ��������� (��� �����������) : '||vSKIPED_COUNT||CHR(13)||CHR(10)||                  
                  '���������        : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
                  '���������        : '||vCHANGE_COUNT||CHR(13)||CHR(10)||
                  '������ ��� ��������� : '||vNO_CHANGE_COUNT--||CHR(13)||CHR(10)||
                  --'��������         : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  --'���������� ����-�: '||vRESTORED_COUNT||CHR(13)||CHR(10)||
                  --'�������-� �������: '||vREST_MINUS||CHR(13)||CHR(10)||                  
                  --'��� ���������    : '||vFOUND_COUNT
                  ,
                   NULL);

                   
    END IF;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
      vERROR_COUNT := vERROR_COUNT + 1;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'BONUSES', NULL, 
              '������ ��� �������� ������� '||CHR(13)||CHR(10)||
              '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
              '����� �������  : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
              dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
              dbms_utility.format_error_backtrace
              ,
              NULL);
  END;
  
  -- �������� ������� ������ ���������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_ACTIVATIONS(pLOG_LEVEL INTEGER DEFAULT 1) 
  IS
    vRECORD CUR_ACTIVATION%ROWTYPE;
    vRES BOOLEAN;
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)
    CURSOR CUR(pPHONE_NUMBER VARCHAR2) IS 
      SELECT D.ROWID R_ID
            ,D.*
            ,OP.OPERATOR_NAME OPERATOR
            ,DT.GUID TARIFF_GUID
            ,DT.TARIFF_NAME
            ,UN.DESCRIPTION CONTRAGENT_DESCRIPTION
            ,UN.USER_NAME
            ,UN.GUID CONTRAGENT_GUID
            ,DS.STATUS_NAME
        FROM D_PHONE_NUMBERS D
            ,D_OPERATORS OP
            ,D_TARIFFS DT
            ,D_USER_NAMES UN
            ,D_STATUSES DS
       WHERE D.PHONE_NUMBER = pPHONE_NUMBER
         AND D.OPERATOR_ID = OP.OPERATOR_ID (+)
         AND D.TARIFF_ID = DT.TARIFF_ID (+)
         AND D.USER_ID = UN.USER_ID (+)
         AND D.STATUS_ID = DS.STATUS_ID (+)
       -- ������� �������� �� GUID-�
       ;
     REC CUR%ROWTYPE;
     vTARIFF_ID INTEGER;
     vOPERATOR_ID INTEGER;
     vUSER_ID INTEGER;
     vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
     vINSERTED_COUNT PLS_INTEGER := 0;
     vUPDATED_COUNT PLS_INTEGER := 0;
     vDELETED_COUNT PLS_INTEGER := 0;
     vRESTORED_COUNT PLS_INTEGER := 0;
     vFOUND_COUNT PLS_INTEGER := 0;
     vTOTAL_COUNT PLS_INTEGER := 0;
     vREST_MINUS PLS_INTEGER := 0;
     vSKIPED_COUNT PLS_INTEGER := 0;
          
     vCHANGED_STR VARCHAR2(2000 CHAR);
     vCHANGED BOOLEAN;
     vCHANGED2 BOOLEAN;
     vPHONE_NUMBER_ID INTEGER;
     vSTATUS_ACTIVATED_1C_ID INTEGER;
     NUMBERS_ARRAY T_NUMBERS_ARRAY;
     vCONTRAGENTS_ARRAY T_CONTRAGENTS_ARRAY;
     vERROR_MESSAGE VARCHAR2(32000);
     vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
  BEGIN
    IF GET_STATUS_OPTIONS_ID('ACTIVATED_1C') IS NULL THEN
            LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'ACTIVATIONS', NULL, 
                    '������ ��� �������� ������ ���������. � ����������� �������� �� ������ ������ � �����  "ACTIVATED_1C".',
                    NULL);
    ELSE
      vSTATUS_ACTIVATED_1C_ID := GET_STATUS_OPTIONS_ID('ACTIVATED_1C'); 
    
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'ACTIVATIONS', NULL, '�������� ��������� ������'); 

      vCURRENT_DATE := SYSDATE;
      
      FOR vRECORD IN CUR_ACTIVATION LOOP

        -- ���������� ������������ DATE_LOAD
        IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
          vDATE_LOAD := vRECORD.DATE_LOAD;
        END IF;      

        vTOTAL_COUNT := vTOTAL_COUNT + 1;
      
        IF NOT vCONTRAGENTS_ARRAY.EXISTS(vRECORD.CONTRAGENT_GUID) THEN
          vCONTRAGENTS_ARRAY(vRECORD.CONTRAGENT_GUID) := FIND_CONTRAGENT(vRECORD.CONTRAGENT_GUID);
        END IF;
        vUSER_ID := vCONTRAGENTS_ARRAY(vRECORD.CONTRAGENT_GUID);
        
        IF vUSER_ID IS NOT NULL THEN
          vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
          vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, vRECORD.PHONE_NUMBER, vRECORD.IS_DIRECT);
          IF TRIM(vRECORD.PHONE_NUMBER) IS NOT NULL THEN 
            NUMBERS_ARRAY(TRIM(vRECORD.PHONE_NUMBER)) := 1;
          END IF;
        
          BEGIN
            OPEN CUR(vRECORD.PHONE_NUMBER);
            FETCH CUR INTO REC;
            IF CUR%NOTFOUND THEN
              vPHONE_NUMBER_ID := RECREATE_PHONE_NUMBER(
                                     pPHONE_NUMBER => vRECORD.PHONE_NUMBER
                                    ,pOPERATOR_ID => vOPERATOR_ID
                                    ,pSIM_NUMBER2 => NULL
                                    ,pTARIFF_ID => vTARIFF_ID
                                    ,pUSER_ID => vUSER_ID
                                    ,pCOMMENTS => '�������� ��� �������� ���������'
                                    ,pDATE_LOAD => vRECORD.DATE_LOAD
                                    ,pSTATUS_ID => vSTATUS_ACTIVATED_1C_ID
                                    ,pDATE_STATUS => vRECORD.DATE_ACTIVATION
                                    ,pIS_ACTIVATED_1C => 1
                                    ,pUSER_ID_STORED => NULL
                                    ,pDATE_STORED => NULL
                                    ,pDATE_STORED_LOADED => NULL
                                    ,pIS_ACTIVE => 0
                                    ,pIS_ACTIVE_STORED => 0
                                    ,pDATE_ACTIVATION => vRECORD.DATE_ACTIVATION
                                    ,pDATE_ACTIVATION_LOADED => vRECORD.DATE_LOAD
                                     );
                
              vINSERTED_COUNT := vINSERTED_COUNT + 1;  
              
              IF pLOG_LEVEL > 1 THEN
                LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('I', 'ACTIVATIONS', vRECORD.PHONE_NUMBER, 
                      '�������� ����� : ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      '��������       : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                      '����� (GUID)   : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                      '�����          : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                      '���� ��������� : '||TO_CHAR(vRECORD.DATE_ACTIVATION, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      '���� �������� �� 1C : '||TO_CHAR(vRECORD.DATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      '����������     : '||vRECORD.CONTRAGENT_DESCRIPTION||CHR(13)||CHR(10)||

                      '�������� ����� : '||vRECORD.USER_NAME||CHR(13)||CHR(10)||
                      '�������� (GUID): '||vRECORD.CONTRAGENT_GUID);
              END IF;
            ELSE
              vCHANGED := FALSE;
              vCHANGED2 := FALSE;
              vCHANGED_STR := '';
              vCHANGED_STR := vCHANGED_STR ||'��������       : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(UPPER(REC.OPERATOR), UPPER(vRECORD.OPERATOR), vCHANGED2); -- �� ��������� ��� ���������
              vCHANGED_STR := vCHANGED_STR ||'����� (GUID)   : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.TARIFF_GUID, vRECORD.TARIFF_GUID, vCHANGED2); -- �� ��������� ��� ���������
              vCHANGED_STR := vCHANGED_STR ||'�����          : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.TARIFF_NAME, vRECORD.TARIFF_NAME, vCHANGED2); -- �� ��������� ��� ���������
              vCHANGED_STR := vCHANGED_STR ||'������         : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.STATUS_NAME, GET_STATUS_OPTIONS_NAME('ACTIVATED_1C'), vCHANGED);
              vCHANGED_STR := vCHANGED_STR ||'����������     : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.CONTRAGENT_DESCRIPTION, vRECORD.CONTRAGENT_DESCRIPTION, vCHANGED2); -- �� ��������� ��� ���������
              vCHANGED_STR := vCHANGED_STR ||'�������� ����� : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.USER_NAME, NVL(vRECORD.USER_NAME, vRECORD.CONTRAGENT_GUID), vCHANGED2); -- �� ��������� ��� ���������
              vCHANGED_STR := vCHANGED_STR ||'�������� (GUID): ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.CONTRAGENT_GUID, vRECORD.CONTRAGENT_GUID, vCHANGED);
              vCHANGED_STR := vCHANGED_STR ||'��������� �� 1�: ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.IS_ACTIVATED_1C, 1, vCHANGED);
              vCHANGED_STR := vCHANGED_STR ||'���� ��������� : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(TO_CHAR(REC.DATE_ACTIVATION, 'DD.MM.YYYY HH24:MI:SS'), TO_CHAR(vRECORD.DATE_ACTIVATION, 'DD.MM.YYYY HH24:MI:SS'), vCHANGED);
              --vCHANGED_STR := vCHANGED_STR ||'���� �������� �� 1� : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(TO_CHAR(REC.DATE_ACTIVATION_LOADED, 'DD.MM.YYYY HH24:MI:SS'), TO_CHAR(vRECORD.DATE_LOAD, 'DD.MM.YYYY HH24:MI:SS'), vCHANGED);

              IF vCHANGED THEN
                UPDATE D_PHONE_NUMBERS D
                SET D.OPERATOR_ID = vOPERATOR_ID
                   ,D.TARIFF_ID = vTARIFF_ID
                   ,D.USER_ID = vUSER_ID
                   ,D.STATUS_ID = vSTATUS_ACTIVATED_1C_ID
                   ,D.DATE_ACTIVATION = vRECORD.DATE_ACTIVATION
                   ,D.STATUS_ID_OPERATOR = vSTATUS_ACTIVATED_1C_ID
                   ,D.IS_ACTIVATED_1C = 1
                   ,D.DESCRIPTION_CHANGED = '������� ��������� �������� �� 1�'
                   ,D.DATE_ACTIVATION_LOADED = vRECORD.DATE_LOAD
                   -- ���� ����������� �� ��� �� �����, ��� ��������, �� ��� �� � ������, ���� �������� �� ������ �����������, �� ��� ��������� ������� ���������� � ��������
                   --,D.USER_ID_STORED = DECODE(vUSER_ID, D.USER_ID_STORED, D.USER_ID_STORED, NULL)    
                WHERE D.ROWID = REC.R_ID; 
                --
                vUPDATED_COUNT := vUPDATED_COUNT + 1;
                --
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('U', 'ACTIVATIONS', vRECORD.PHONE_NUMBER, 
                      '��������� (���������) ������ : '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������      : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      'ROWID              : '||REC.R_ID||CHR(13)||CHR(10)||
                      vCHANGED_STR, vRECORD.PHONE_NUMBER);
                END IF;
              ELSE
                vFOUND_COUNT := vFOUND_COUNT + 1;
              END IF;
            END IF;
            CLOSE CUR;
            
            --COMMIT;
          EXCEPTION WHEN OTHERS THEN
              vERROR_COUNT := vERROR_COUNT + 1;
              LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'ACTIVATIONS', vRECORD.PHONE_NUMBER, 
                      '������ ��� �������� ��������� ������ ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      'vTOTAL_COUNT   :'||vTOTAL_COUNT ||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                       dbms_utility.format_error_backtrace
                      ,
                      vRECORD.PHONE_NUMBER);
               EXIT;
          END;
        ELSE
          vSKIPED_COUNT := vSKIPED_COUNT + 1;
        END IF;
      END LOOP;

      -- ���� �� ���� �� ����� ������
      -- ������� ������� ��������� �� ���� �������, ������ ������������� �� 1�, �� �� ����������� � ���������� ������
      IF vERROR_COUNT = 0 THEN
        FOR REC IN (SELECT D.ROWID R_ID, D.PHONE_NUMBER_ID, D.USER_ID, D.PHONE_NUMBER, UN.USER_NAME, D.DATE_ACTIVATION
                      FROM D_PHONE_NUMBERS D, D_USER_NAMES UN 
                     WHERE D.STATUS_ID = vSTATUS_ACTIVATED_1C_ID
                       AND D.USER_ID = UN.USER_ID (+))
        LOOP
          IF NOT NUMBERS_ARRAY.EXISTS(REC.PHONE_NUMBER) THEN
            -- ��������� ��� �� ��������� !
            /*
            -- ��������� ������� ����, ��� ����� "������"
            INSERT INTO D_PHONE_NUMBER_CUTS
            (PHONE_NUMBER_ID, USER_ID, DATE_ACTIVATED, DATE_CUT)
            VALUES
            (REC.PHONE_NUMBER_ID, REC.USER_ID, REC.DATE_ACTIVATION --GET_DATE_SET_STATUS(REC.PHONE_NUMBER_ID, 'ACTIVATED_1C')
            , vCURRENT_DATE);
            */ 
          
            UPDATE D_PHONE_NUMBERS PH
               SET PH.STATUS_ID = NULL
                  ,PH.USER_ID = NULL
                  ,PH.IS_ACTIVATED_1C = NULL
                  ,PH.DATE_ACTIVATION = NULL
                  ,PH.DATE_ACTIVATION_LOADED = NULL
             WHERE PH.ROWID = REC.R_ID;
            --
            vDELETED_COUNT := vDELETED_COUNT + 1;
            --
            /*IF pLOG_LEVEL > 1 THEN
              LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('C', 'ACTIVATIONS', REC.PHONE_NUMBER, 
                  '"������" ����� : '||REC.PHONE_NUMBER||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '� �����������  : '||REC.USER_NAME||CHR(13)||CHR(10)||
                  'ROWID          : '||REC.R_ID, REC.PHONE_NUMBER);
            END IF;*/
          END IF;        
        END LOOP;
      END IF;

      IF pLOG_LEVEL > 0 THEN
        vDATE := SYSDATE;
        LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'ACTIVATIONS', NULL,
                    '�������� ��������� ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                    '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                    '������               : '||vERROR_COUNT||CHR(13)||CHR(10)||
                    '����� �������������� :'||vTOTAL_COUNT||CHR(13)||CHR(10)||
                    '����� ���������      : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
                    '��������             : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                    '�� ��������� (��� �����������) : '||vSKIPED_COUNT||CHR(13)||CHR(10)||                  
                    '"�������" �������    : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                    '��� ���������        : '||vFOUND_COUNT,
                     NULL);
      END IF;
      COMMIT;
    END IF;
  END;
  
  -- �������� ������� ������ �������� ���������� ������� (�� ������ �������) �� ������� ������������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ���������
  --              2 - ������, ������ �� �������� � ��� ���������
  PROCEDURE RELOAD_CONTRAGENT_RESTS(pLOG_LEVEL INTEGER DEFAULT 1
                                 ,pPHONE_NUMBER VARCHAR2 DEFAULT NULL -- ��������� ������ ��� ����� ������
  ) IS
    vRECORD CUR_CONTRAGENT_REST%ROWTYPE;
    vRES BOOLEAN;
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)
    CURSOR CUR(pPHONE_NUMBER VARCHAR2) IS 
      SELECT D.ROWID R_ID
            ,D.*
            ,OP.OPERATOR_NAME OPERATOR
            ,DT.GUID TARIFF_GUID
            ,DT.TARIFF_NAME
            ,UN.DESCRIPTION CONTRAGENT_DESCRIPTION
            ,UN.USER_NAME
            ,UN.GUID CONTRAGENT_GUID
            ,DS.STATUS_NAME
        FROM D_PHONE_NUMBERS D
            ,D_OPERATORS OP
            ,D_TARIFFS DT
            ,D_USER_NAMES UN
            ,D_STATUSES DS
       WHERE D.PHONE_NUMBER = pPHONE_NUMBER
         AND D.OPERATOR_ID = OP.OPERATOR_ID (+)
         AND D.TARIFF_ID = DT.TARIFF_ID (+)
         AND D.USER_ID = UN.USER_ID (+)
         AND D.STATUS_ID = DS.STATUS_ID (+)
       -- ������� �������� �� GUID-�
       ;
     REC CUR%ROWTYPE;
     vTARIFF_ID INTEGER;
     vOPERATOR_ID INTEGER;
     vUSER_ID_STORED INTEGER;
     --
     vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
     vINSERTED_COUNT PLS_INTEGER := 0;
     vUPDATED_COUNT PLS_INTEGER := 0;
     vDELETED_COUNT PLS_INTEGER := 0;
     vRESTORED_COUNT PLS_INTEGER := 0;
     vFOUND_COUNT PLS_INTEGER := 0;
     vTOTAL_COUNT PLS_INTEGER := 0;
     vREST_MINUS PLS_INTEGER := 0;
     vSKIPED_COUNT PLS_INTEGER := 0;
     vCUT_COUNT PLS_INTEGER := 0;
     
     vPHONE_NUMBER_ID INTEGER;
     vCHANGED BOOLEAN;
     vCHANGED_STR VARCHAR2(2000 CHAR);
     
     vCONTRAGENTS_ARRAY T_CONTRAGENTS_ARRAY;
     
     vERROR_MESSAGE VARCHAR2(32000);
     vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'CONTRAGENT_RESTS', NULL, '�������� �������� ������������ ������'); 

    vCURRENT_DATE := SYSDATE;
    FOR vRECORD IN CUR_CONTRAGENT_REST LOOP

      -- ���������� ������������ DATE_LOAD
      IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
        vDATE_LOAD := vRECORD.DATE_LOAD;
      END IF;      

      IF pPHONE_NUMBER IS NULL OR vRECORD.PHONE_NUMBER = pPHONE_NUMBER THEN 
        vTOTAL_COUNT := vTOTAL_COUNT + 1;
        
        IF TRIM(vRECORD.PHONE_NUMBER) IS NULL THEN
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTRAGENT_RESTS', vRECORD.PHONE_NUMBER, 
                 '������ ��� �������� ������ �������� ������������. ����� ������ ������ ���� ���������. ���������� �'||vTOTAL_COUNT,
                 vRECORD.PHONE_NUMBER);
        ELSIF TRIM(vRECORD.CONTRAGENT_GUID) IS NULL THEN
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTRAGENT_RESTS', vRECORD.PHONE_NUMBER, 
                 '������ ��� �������� ������ �������� ������������. GUID ����������� ������ ���� ���������. ���������� �'||vTOTAL_COUNT,
                 vRECORD.PHONE_NUMBER);
        ELSE
          IF NOT vCONTRAGENTS_ARRAY.EXISTS(vRECORD.CONTRAGENT_GUID) THEN
            vCONTRAGENTS_ARRAY(vRECORD.CONTRAGENT_GUID) := FIND_CONTRAGENT(vRECORD.CONTRAGENT_GUID);
          END IF;
          vUSER_ID_STORED := vCONTRAGENTS_ARRAY(vRECORD.CONTRAGENT_GUID);
                
          IF vUSER_ID_STORED IS NOT NULL THEN        
          
            vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
            vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, vRECORD.PHONE_NUMBER, vRECORD.IS_DIRECT);
              
            BEGIN
              OPEN CUR(vRECORD.PHONE_NUMBER);
              FETCH CUR INTO REC;
              IF CUR%NOTFOUND THEN
                vPHONE_NUMBER_ID := RECREATE_PHONE_NUMBER(vRECORD.PHONE_NUMBER, vOPERATOR_ID, NULL, vTARIFF_ID, 
                                       NULL, '�������� ��� �������� �������� ������������', 
                                       vCURRENT_DATE, NULL, NULL, 0 /*pIS_ACTIVATED_1C*/,
                                       vUSER_ID_STORED, vCURRENT_DATE, vCURRENT_DATE, 1, 1);
                      
                vINSERTED_COUNT := vINSERTED_COUNT + 1;  
                    
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('I', 'CONTRAGENT_RESTS', vRECORD.PHONE_NUMBER, 
                        '�������� ����� �� ����� ����������� : ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                        '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                        '��������       : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                        '����� (GUID)   : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                        '�����          : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                        '���� �����������: '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                        '����������     : '||vRECORD.CONTRAGENT_DESCRIPTION||CHR(13)||CHR(10)||
                        '�������� ����� : '||vRECORD.USER_NAME||CHR(13)||CHR(10)||
                        '�������� (GUID): '||vRECORD.CONTRAGENT_GUID, vRECORD.PHONE_NUMBER);
                END IF;
              ELSIF NVL(REC.USER_ID_STORED, -1) <> vUSER_ID_STORED THEN
                vCHANGED_STR := '';
                vCHANGED_STR := vCHANGED_STR ||'����������     : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.CONTRAGENT_DESCRIPTION, vRECORD.CONTRAGENT_DESCRIPTION, vCHANGED); -- �� ��������� ��� ���������
                vCHANGED_STR := vCHANGED_STR ||'�������� ����� : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.USER_NAME, NVL(vRECORD.USER_NAME, vRECORD.CONTRAGENT_GUID), vCHANGED);
                vCHANGED_STR := vCHANGED_STR ||'�������� (GUID): ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.CONTRAGENT_GUID, vRECORD.CONTRAGENT_GUID, vCHANGED);
                vCHANGED_STR := vCHANGED_STR ||'�����          : ' || LOG_EXCHANGE_PKG.GET_CHANGE_MESSAGE(REC.TARIFF_GUID, vRECORD.TARIFF_GUID, vCHANGED);
                --
                UPDATE D_PHONE_NUMBERS D
                   SET D.USER_ID_STORED = vUSER_ID_STORED
                      ,D.DATE_STORED = vCURRENT_DATE
                      ,D.DATE_STORED_LOADED = vCURRENT_DATE
                      ,D.IS_ACTIVE = 1
                      ,D.IS_ACTIVE_STORED = 1
                      ,D.TARIFF_ID = vTARIFF_ID
                 WHERE D.PHONE_NUMBER_ID = REC.PHONE_NUMBER_ID; 
                --
                vUPDATED_COUNT := vUPDATED_COUNT + 1;
                --
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('U', 'CONTRAGENT_RESTS', vRECORD.PHONE_NUMBER, 
                      '����� ������� �� ����� ����������� : '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      'ROWID          : '||REC.R_ID||CHR(13)||CHR(10)||
                      vCHANGED_STR, vRECORD.PHONE_NUMBER);
                END IF;
              ELSIF NVL(REC.IS_ACTIVE, -1) <> 1 THEN
                --
                UPDATE D_PHONE_NUMBERS D
                   SET D.DATE_STORED_LOADED = vCURRENT_DATE
                      ,D.IS_ACTIVE = 1
                      ,D.IS_ACTIVE_STORED = 1 -- �� ������ ������ - ��� ���� �� ������ �����������
                      ,D.USER_ID_STORED = NVL(D.USER_ID_STORED, vUSER_ID_STORED)
                 WHERE D.PHONE_NUMBER_ID = REC.PHONE_NUMBER_ID; 
                --
                vRESTORED_COUNT := vRESTORED_COUNT + 1;
                --
                IF pLOG_LEVEL > 1 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('U', 'CONTRAGENT_RESTS', vRECORD.PHONE_NUMBER, 
                      '����� ������������ �� ����� ����������� : '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                      '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                      'ROWID          : '||REC.R_ID||CHR(13)||CHR(10)||
                      vCHANGED_STR, vRECORD.PHONE_NUMBER);
                END IF;
              ELSE
                UPDATE D_PHONE_NUMBERS D
                   SET D.DATE_STORED_LOADED = vCURRENT_DATE
                      ,D.IS_ACTIVE_STORED = 1 -- �� ������ ������ - ��� ���� �� ������ �����������
                      ,D.USER_ID_STORED = CASE NVL(D.USER_ID_STORED, 0) WHEN 0 THEN vUSER_ID_STORED ELSE D.USER_ID_STORED END
                 WHERE D.PHONE_NUMBER_ID = REC.PHONE_NUMBER_ID; 
                vFOUND_COUNT := vFOUND_COUNT + 1;
              END IF;
              
              -- ���� ����� ��� ����������� �� ������� �����������
              IF (REC.USER_ID <> vUSER_ID_STORED)
                AND (REC.STATUS_ID = GET_STATUS_OPTIONS_ID('ACTIVATED_1C')
                     OR 
                     REC.STATUS_ID = GET_STATUS_OPTIONS_ID('ACTIVATED')) 
              THEN
                -- !!! ������ �� ������ ���� (������ ����� ������ � ����� �� ����� ������� �����������)
                --     ������� ������������, � ���� ������ ��� "�����������", �� ������� ������
                  -- ����� ��� �����������, ������ �������� �� ����������� ������, ������ �� "������"
                  -- ��������� ������� ����, ��� ����� "������"

                  -- ��������� ��� �� ��������� !
                  /*
                  INSERT INTO D_PHONE_NUMBER_CUTS
                  (PHONE_NUMBER_ID, USER_ID, DATE_ACTIVATED, DATE_CUT)
                  VALUES
                  (REC.PHONE_NUMBER_ID, REC.USER_ID, REC.DATE_ACTIVATION -- GET_DATE_SET_STATUS(REC.PHONE_NUMBER_ID, 'ACTIVATED_1C')
                  , vCURRENT_DATE);
                  
                  vCUT_COUNT := vCUT_COUNT + 1;
                  */
                  UPDATE D_PHONE_NUMBERS PH
                     SET PH.STATUS_ID = NULL
                        ,PH.USER_ID = NULL
                        ,PH.IS_ACTIVATED_1C = NULL
                        ,PH.DATE_LOAD = vRECORD.DATE_LOAD
                   WHERE PH.ROWID = REC.R_ID;

                    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('C', 'CONTRAGENT_RESTS', vRECORD.PHONE_NUMBER, 
                          '"������" ����� � �������� �� ����� ������� ����������� : ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                          '������ � �����������   : ' || REC.USER_NAME||CHR(13)||CHR(10)||
                          '������� �� ����������� : ' || vRECORD.USER_NAME||CHR(13)||CHR(10)|| 
                          '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS'),
                          vRECORD.PHONE_NUMBER);
              END IF;
              --
              CLOSE CUR;
              
              --COMMIT;
            EXCEPTION WHEN OTHERS THEN
                vERROR_COUNT := vERROR_COUNT + 1;
                LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTRAGENT_RESTS', vRECORD.PHONE_NUMBER, 
                        '������ ��� �������� �������� �� ������� ������������ ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                        'vTOTAL_COUNT   :'||vTOTAL_COUNT ||CHR(13)||CHR(10)||
                        '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                        dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                         dbms_utility.format_error_backtrace
                        ,
                        vRECORD.PHONE_NUMBER);
                 EXIT;
            END;
          ELSE
            vSKIPED_COUNT := vSKIPED_COUNT + 1;
                IF pLOG_LEVEL > 2 THEN
                  LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('C', 'CONTRAGENT_RESTS', vRECORD.PHONE_NUMBER, 
                        '�� ������ ���������� ��� ������ : ' || vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                        '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                        '��������       : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                        '����� (GUID)   : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                        '�����          : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                        '���� �����������: '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                        '����������     : '||vRECORD.CONTRAGENT_DESCRIPTION||CHR(13)||CHR(10)||
                        '�������� ����� : '||vRECORD.USER_NAME||CHR(13)||CHR(10)||
                        '�������� (GUID): '||vRECORD.CONTRAGENT_GUID, vRECORD.PHONE_NUMBER);
                END IF;
            
          END IF;
        END IF;
      END IF;
    END LOOP;

    -- ���� �� ���� �� ����� ������
    -- ������� ������� �������� �� ������ ����������� � ��� �������, 
    -- ����� �� ������� ������������, �� �� ����������� � ���������� ������
    -- (���� ��������� �� ������ ���� �����)
    IF (vERROR_COUNT = 0) AND (pPHONE_NUMBER IS NULL) THEN
      FOR REC IN (SELECT D.ROWID R_ID, D.DATE_STORED_LOADED, D.PHONE_NUMBER, D.DATE_STORED, UN.USER_NAME
                    FROM D_PHONE_NUMBERS D, D_USER_NAMES UN
                   WHERE D.USER_ID_STORED IS NOT NULL
                     AND D.USER_ID_STORED = UN.USER_ID (+)
                     AND NVL(D.DATE_STORED_LOADED, TO_DATE('01.01.1900', 'DD.MM.YYYY')) <> vCURRENT_DATE)
      LOOP
        UPDATE D_PHONE_NUMBERS D
           SET D.IS_ACTIVE_STORED = 0 -- ������ ������� ������� ��������� ��������, ��������� ���� ���� ������� ��� "��������" ������
                                      -- ���� ����� �������� �� ����������� ������
              --,D.DATE_STORED_LOADED = vCURRENT_DATE
              --,D.USER_ID_STORED = NULL
              --,D.DATE_STORED = NULL                    
         WHERE D.ROWID = REC.R_ID;
        --
        vDELETED_COUNT := vDELETED_COUNT + 1;
        --           
        IF pLOG_LEVEL > 1 THEN
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('D', 'CONTRAGENT_RESTS', REC.PHONE_NUMBER, 
              '����� ����� �� ������ ����������� : '||REC.PHONE_NUMBER||CHR(13)||CHR(10)||
              '����������     : '||REC.USER_NAME||CHR(13)||CHR(10)||
              '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
              'ROWID          : '||REC.R_ID, REC.PHONE_NUMBER);
        END IF;        
      END LOOP;
    END IF;
    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'CONTRAGENT_RESTS', NULL,
                  '�������� �������� ������� �� ������� ������������ ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������               : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  '����� �������������� : '||vTOTAL_COUNT||CHR(13)||CHR(10)||
                  '�� ��������� (��� �����������) : '||vSKIPED_COUNT||CHR(13)||CHR(10)||                  
                  '����� ���������      : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
                  '��������             : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  '������������� �������: '||vRESTORED_COUNT||CHR(13)||CHR(10)||                  
                  '����� �� ������ ����������� : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  '��� ���������        : '||vFOUND_COUNT||CHR(13)||CHR(10)||
                  '-------------------'||CHR(13)||CHR(10)||
                  '������� � ������ ������������ : '||vCUT_COUNT,
                   NULL);
    END IF;
    COMMIT;
  END;

  -- �������� ������� ������ ��������� ������� 
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_BALANCE_CHANGES(pLOG_LEVEL INTEGER DEFAULT 1) IS
    vRECORD CUR_BALANCE_CHANGE%ROWTYPE;
    vUSER_ID NUMBER(8);
    vTARIFF_ID INTEGER;
    vOPERATOR_ID INTEGER;
    vPHONE_NUMBER_ID INTEGER;
    
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)

    vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
    vINSERTED_COUNT PLS_INTEGER := 0;
    --vUPDATED_COUNT PLS_INTEGER := 0;
    vDELETED_COUNT PLS_INTEGER := 0;
    vSKIPED_COUNT PLS_INTEGER := 0;
    --vRESTORED_COUNT PLS_INTEGER := 0;
    --vFOUND_COUNT PLS_INTEGER := 0;
    --vTOTAL_COUNT PLS_INTEGER := 0;
    --vREST_MINUS PLS_INTEGER := 0;
    vCONTRAGENTS_ARRAY T_CONTRAGENTS_ARRAY;
    vERROR_MESSAGE VARCHAR2(32000);
    vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
    vIS_TRUNCATE BOOLEAN; -- ������� ���������� �������� TRUNCATE TABLE D_BALANCE_CHANGES REUSE STORAGE
    vCOUNT_TRUNCATE INTEGER;
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'BALANCE_CHANGES', NULL, '�������� ��������� ������� ������'); 

    vCURRENT_DATE := SYSDATE;
    
    -- v2
    vIS_TRUNCATE := FALSE;
    vCOUNT_TRUNCATE := 0;
    WHILE (NOT vIS_TRUNCATE) LOOP  -- �� ��� ��� ���� �� ��������� �������� ��������
      BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE D_BALANCE_CHANGES REUSE STORAGE';    
        vIS_TRUNCATE := TRUE;  -- �������� ���������
      EXCEPTION 
        WHEN OTHERS THEN
          vCOUNT_TRUNCATE := vCOUNT_TRUNCATE + 1;
          DBMS_LOCK.SLEEP(1);
          IF (vCOUNT_TRUNCATE > 10) THEN  -- ���� TRUNCATE ��� � �� ������ ����� ���� �������, �� ������� ����������
            RAISE_APPLICATION_ERROR(-20000, '������! ��������� �������� �� ���������! '||vCOUNT_TRUNCATE ||' ������� �������� ������� � ����������� �������� ��������� ����������.' 
                                  ||CHR(13)||CHR(10)||' ������: '||sqlerrm); --  � ����� �������
          END IF;
      END;
    END LOOP;     
    
    --
    vDELETED_COUNT := SQL%ROWCOUNT;
    --
    FOR vRECORD IN CUR_BALANCE_CHANGE LOOP
      BEGIN
        -- ���������� ������������ DATE_LOAD
        IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
          vDATE_LOAD := vRECORD.DATE_LOAD;
        END IF;      
      
        IF vRECORD.OPERATOR IS NULL THEN
          vOPERATOR_ID := NULL;
        ELSE
          vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
        END IF;
        IF vRECORD.TARIFF_GUID IS NULL THEN
          vTARIFF_ID := NULL;
        ELSE
          vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, vRECORD.PHONE_NUMBER, vRECORD.IS_DIRECT);
        END IF;
        IF TRIM(vRECORD.PHONE_NUMBER) IS NULL THEN
          vPHONE_NUMBER_ID := NULL;
        ELSE
          vPHONE_NUMBER_ID := RECREATE_PHONE_NUMBER(vRECORD.PHONE_NUMBER, vOPERATOR_ID, NULL, vTARIFF_ID, 
                                       NULL, '�������� ��� �������� ��������� �������', 
                                       vCURRENT_DATE, NULL, NULL);
        END IF;
      
        IF NOT vCONTRAGENTS_ARRAY.EXISTS(vRECORD.USER_GUID) THEN
          vCONTRAGENTS_ARRAY(vRECORD.USER_GUID) := FIND_CONTRAGENT(vRECORD.USER_GUID);
        END IF;
        vUSER_ID := vCONTRAGENTS_ARRAY(vRECORD.USER_GUID);
        
        IF vUSER_ID IS NOT NULL THEN
          INSERT INTO D_BALANCE_CHANGES(USER_ID, DATE_TIME, SUM_INCOME, SUM_OUTCOME, LOAD_DATE, BALANCE_AFTER, PHONE_NUMBER_ID, OPERATOR_ID, TARIFF_ID, TYPE_CHANGE, PERCENT, PERIOD)
          VALUES (vUSER_ID, vRECORD.DATE_TIME, vRECORD.SUM_INCOME, vRECORD.SUM_OUTCOME, vCURRENT_DATE, vRECORD.BALANCE_AFTER, vPHONE_NUMBER_ID, vOPERATOR_ID, vTARIFF_ID, vRECORD.TYPE_CHANGE, vRECORD.PERCENT, vRECORD.PERIOD);
          --  
          vINSERTED_COUNT := vINSERTED_COUNT + 1;
        ELSE
          vSKIPED_COUNT := vSKIPED_COUNT + 1;
        END IF;
        
        --COMMIT; 
      EXCEPTION WHEN OTHERS THEN
          vERROR_COUNT := vERROR_COUNT + 1;
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'BALANCE_CHANGES', NULL, 
                  '������ ��� ��������� ������� ��� ����������� ' || vRECORD.USER_NAME||' ('||vRECORD.USER_GUID||')'||CHR(13)||CHR(10)||
                  '���� ���������   : '||TO_CHAR(vRECORD.DATE_TIME, 'DD.MM.YYYY HH24:MI:SS') ||CHR(13)||CHR(10)||
                  '����� �������    : '||vRECORD.SUM_INCOME ||CHR(13)||CHR(10)||
                  '����� �������    : '||vRECORD.SUM_OUTCOME ||CHR(13)||CHR(10)||
                  '������ �����     : '||vRECORD.BALANCE_AFTER ||CHR(13)||CHR(10)||
                  '����� ��������   : '||vRECORD.PHONE_NUMBER||CHR(13)||CHR(10)||
                  '��������         : '||vRECORD.OPERATOR||CHR(13)||CHR(10)||
                  '����� (GUID)     : '||vRECORD.TARIFF_GUID||CHR(13)||CHR(10)||
                  '�����            : '||vRECORD.TARIFF_NAME||CHR(13)||CHR(10)||
                  '���� ��������    : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                  dbms_utility.format_error_backtrace
                  ,
                  NULL);
          EXIT;
      END;
    END LOOP;

    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'BALANCE_CHANGES', NULL,
                  '�������� ��������� ���������������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  --'����� �� ������  : '||vTOTAL_COUNT||CHR(13)||CHR(10)||
                  '�������          : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  '�� ��������� (��� �����������) : '||vSKIPED_COUNT||CHR(13)||CHR(10)||                  
                  '���������        : '||vINSERTED_COUNT--||CHR(13)||CHR(10)||
                  --'��������         : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  --'���������� ����-�: '||vRESTORED_COUNT||CHR(13)||CHR(10)||
                  --'�������-� �������: '||vREST_MINUS||CHR(13)||CHR(10)||                  
                  --'��� ���������    : '||vFOUND_COUNT
                  ,
                   NULL);
                   
    END IF;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
      vERROR_COUNT := vERROR_COUNT + 1;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'BALANCE_CHANGES', NULL, 
              '������ ��� �������� ��������� ������� '||CHR(13)||CHR(10)||
              '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
              '����� �������  : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
              dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
              dbms_utility.format_error_backtrace
              ,
              NULL);
  END;
  
  -- ���������� ���� � ��������� � ��������� ������� 
  PROCEDURE UPDATE_BALANCE_CHANGE_PERCENTS IS
    -- �������� �� �� ��� � ���������� ������� ���� ������, ������� ��� ������� �� �������� ������� � ������� �������
    -- �� ������������� ���� �� ������
    CURSOR CUR_NOT_LINKED IS
      SELECT COUNT(*)
        FROM LOAD_BALANCE_CHANGE BC
            ,LOAD_BONUS LB
       WHERE BC.PHONE_NUMBER = LB.PHONE_NUMBER (+)
         AND BC.TARIFF_GUID = LB.TARIFF_GUID (+) 
         AND BC.USER_GUID = LB.USER_GUID (+)
         AND BC.SUM_INCOME = LB.BONUS_SUMM (+)
         AND BC.DATE_TIME = LB.BONUS_DATE (+)
         AND LB.USER_GUID IS NULL   
         AND NVL(BC.SUM_INCOME, 0) > 0
      --   AND BC.USER_GUID <> 'a8b38314-df3d-4e0e-91f7-602cf151a30e'
      ;

    -- �������� �� �� ��� � ������� LOAD_BALANCE_CHANGE ��������� ������������ ��������
    -- ������������ ���� �� ������ 
    CURSOR CUR_WRONG_PERCENTS IS
      SELECT COUNT(*)
        FROM LOAD_BALANCE_CHANGE BC
            ,LOAD_BONUS LB
       WHERE BC.PHONE_NUMBER = LB.PHONE_NUMBER (+)
         AND BC.TARIFF_GUID = LB.TARIFF_GUID (+) 
         AND BC.USER_GUID = LB.USER_GUID (+)
         AND BC.SUM_INCOME = LB.BONUS_SUMM (+)
         AND BC.DATE_TIME = LB.BONUS_DATE (+)
         AND NVL(BC.SUM_INCOME, 0) > 0
         AND NVL(BC.PERCENT, 0) <> NVL(LB.BONUS_PERCENT, 0);

    vNOT_LINKED_COUNT INTEGER;
    vUPDATED_COUNT INTEGER;
    vWRONG_PERCENT_COUNT INTEGER;
    vDATE_START DATE;    
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'BALANCE_CHANGES_PERCENTS', NULL, '��������� ��������� ��� ��������� ������� �� �������������� ������'); 
    vDATE_START := SYSDATE;
  
    -- ���������� �� �����������
    OPEN CUR_NOT_LINKED;
    FETCH CUR_NOT_LINKED INTO vNOT_LINKED_COUNT;
    CLOSE CUR_NOT_LINKED;
    
    IF vNOT_LINKED_COUNT > 0 THEN    
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'BALANCE_CHANGES_PERCENTS', NULL, 
            '������ ��� ��������� ��������� ��� ��������� ������� (�������� ������� �� ��������������).'||CHR(13)||CHR(10)||
            ' ������� '||vNOT_LINKED_COUNT||' ��������� ������� ��� ������� �� ������ ������� � ������ ��������������.' ||CHR(13)||CHR(10)||
            '���� ��������  : '||TO_CHAR(SYSDATE, 'DD.MM.YYYY HH24:MI:SS')
            ,
            NULL);
    END IF;    
    
    -- ������������ ������ �� ��������� �������
    EXECUTE IMMEDIATE 'TRUNCATE TABLE LOAD_BONUS_TEMP';
    
    INSERT INTO LOAD_BONUS_TEMP(USER_GUID, BONUS_DATE, PHONE_NUMBER, BONUS_SUMM, TARIFF_GUID, BONUS_PERCENT, DATE_LOAD)
    SELECT USER_GUID, BONUS_DATE, PHONE_NUMBER, BONUS_SUMM, TARIFF_GUID, BONUS_PERCENT, DATE_LOAD
    FROM  LOAD_BONUS;
    
    -- ����������� �������
    UPDATE LOAD_BALANCE_CHANGE BC
       SET BC.PERCENT = (
            SELECT LB.BONUS_PERCENT
              FROM LOAD_BONUS_TEMP LB
             WHERE BC.PHONE_NUMBER = LB.PHONE_NUMBER
               AND BC.TARIFF_GUID = LB.TARIFF_GUID 
               AND BC.USER_GUID = LB.USER_GUID
               AND BC.SUM_INCOME = LB.BONUS_SUMM
               AND BC.DATE_TIME = LB.BONUS_DATE
               AND NVL(BC.SUM_INCOME, 0) > 0
        )
     WHERE NVL(BC.PERCENT, 0) = 0;
     
     vUPDATED_COUNT := SQL%ROWCOUNT;
     
     COMMIT;
     
     OPEN CUR_WRONG_PERCENTS;
     FETCH CUR_WRONG_PERCENTS INTO vWRONG_PERCENT_COUNT;

     CLOSE CUR_WRONG_PERCENTS;
    
      IF vWRONG_PERCENT_COUNT > 0 THEN    
        LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'BALANCE_CHANGES_PERCENTS', NULL, 
              '������ ��� ��������� ��������� ��� ��������� ������� (�������� ������� �� ��������������).'||CHR(13)||CHR(10)||
              ' ������� '||vWRONG_PERCENT_COUNT||' ��������� ������� ��� ������� �� ��������� ����������� ������� �� ��������������.' ||CHR(13)||CHR(10)||
              '���� ��������  : '||TO_CHAR(SYSDATE, 'DD.MM.YYYY HH24:MI:SS')
              ,
              NULL);
      END IF;    

      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'BALANCE_CHANGES_PERCENTS', NULL,
                  '��������� ��������� ��� ��������� ������� �� �������������� ��������� '||S_GET_DELTA_TIME_STR(vDATE_START, SYSDATE)||' '||TO_CHAR(SYSDATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vDATE_START, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  ' ���������� ������� ��� ��������� �������     : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  ' ������� '||vNOT_LINKED_COUNT||' ��������� ������� ��� ������� �� ������ ������� � ������ ��������������.' ||CHR(13)||CHR(10)||
                  ' ������� '||vWRONG_PERCENT_COUNT||' ��������� ������� ��� ������� �� ��������� ����������� ������� �� ��������������.'
                  ,
                   NULL);
  
    NULL;
  EXCEPTION WHEN OTHERS THEN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'BALANCE_CHANGES_PERCENTS', NULL, 
            '������ ��� ��������� ��������� ��� ��������� ������� (�������� ������� �� ��������������)'||
            '���� ��������  : '||TO_CHAR(SYSDATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
            dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
            dbms_utility.format_error_backtrace
            ,
            NULL);
  END; 
  
  -- �������� ������� ��������� �������
  --   ������ ������� � �������� �� ������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ���������
  PROCEDURE RELOAD_TARIFF_CHANGE_RULES(pLOG_LEVEL INTEGER DEFAULT 1
  ) IS
    vRECORD CUR_TARIFF_CHANGE_RULE%ROWTYPE;
    --vRES BOOLEAN;
    --vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)
       
    vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
    vINSERTED_COUNT PLS_INTEGER := 0;
    vDELETED_COUNT PLS_INTEGER := 0;
    vTOTAL_COUNT PLS_INTEGER := 0;
    vRECORD_COUNT PLS_INTEGER := 0;

    vOPERATOR_ID_FROM INTEGER;
    vTARIFF_ID_FROM INTEGER;
    vOPERATOR_ID_TO INTEGER;
    vTARIFF_ID_TO INTEGER;
    
    vERROR_MESSAGE VARCHAR2(32000);
    vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'TARIFF_CHANGE_RULES', NULL, '�������� ������ ��������� ������� ������'); 
    
    vCURRENT_DATE := SYSDATE;
    FOR vRECORD IN CUR_TARIFF_CHANGE_RULE LOOP

      -- ���������� ������������ DATE_LOAD
      IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
        vDATE_LOAD := vRECORD.DATE_LOAD;
      END IF;      

      vTOTAL_COUNT := vTOTAL_COUNT + 1;
      
      BEGIN 
        IF vTOTAL_COUNT = 1 THEN
          DELETE FROM D_TARIFF_CHANGE_RULES; -- IF  FIRST - CLEAR ALL
          vDELETED_COUNT := SQL%ROWCOUNT;         
        END IF;
        
        vOPERATOR_ID_FROM := RECREATE_OPERATOR(vRECORD.OPERATOR_FROM);
        vTARIFF_ID_FROM := RECREATE_TARIFF(vRECORD.TARIFF_GUID_FROM, vRECORD.TARIFF_NAME_FROM, vOPERATOR_ID_FROM, NULL, vRECORD.IS_DIRECT_FROM);

        vOPERATOR_ID_TO := RECREATE_OPERATOR(vRECORD.OPERATOR_TO);
        vTARIFF_ID_TO := RECREATE_TARIFF(vRECORD.TARIFF_GUID_TO, vRECORD.TARIFF_NAME_TO, vOPERATOR_ID_TO, NULL, vRECORD.IS_DIRECT_FROM);
        
        INSERT INTO D_TARIFF_CHANGE_RULES(TARIFF_ID_FROM, TARIFF_ID_TO, PRICE)
        VALUES (vTARIFF_ID_FROM, vTARIFF_ID_TO, vRECORD.PRICE);
        --  
        vINSERTED_COUNT := vINSERTED_COUNT + 1;
        
        --COMMIT;  
      EXCEPTION WHEN OTHERS THEN
          vERROR_COUNT := vERROR_COUNT + 1;
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'TARIFF_CHANGE_RULES', NULL, 
                  '������ ��� �������� ������ ��������� ������� "' ||vRECORD.TARIFF_NAME_FROM||'" - "'||vRECORD.TARIFF_NAME_TO||'"'||CHR(13)||CHR(10)||
                  'vTOTAL_COUNT   : '||vTOTAL_COUNT ||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                  dbms_utility.format_error_backtrace
                  ,
                  NULL);
           EXIT;
      END;
    END LOOP;

    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'TARIFF_CHANGE_RULES', NULL,
                  '�������� ������ ��������� ������� ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  '�������          : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  '����� ���������  : '||vINSERTED_COUNT||CHR(13)||CHR(10),
                   NULL);
                   
    END IF;
    COMMIT;
  END;  
 
  -- �������� ������ ��������� 
  --   ������ �������� � �������� �� ������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_PHONE_RETURNS(pLOG_LEVEL INTEGER DEFAULT 1) IS
    vRECORD CUR_PHONE_RETURN%ROWTYPE;
    vUSER_ID NUMBER(8);
    vTARIFF_ID INTEGER;
    vOPERATOR_ID INTEGER;
    vPHONE_NUMBER_ID INTEGER;
    
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    --vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)

    vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
    vINSERTED_COUNT PLS_INTEGER := 0;
    --vUPDATED_COUNT PLS_INTEGER := 0;
    vDELETED_COUNT PLS_INTEGER := 0;
    vSKIPED_COUNT PLS_INTEGER := 0;

    vCONTRAGENTS_ARRAY T_CONTRAGENTS_ARRAY;
     
    vERROR_MESSAGE VARCHAR2(32000);
    vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'PHONE_RETURNS', NULL, '�������� ��������� ������� �� ����������� ����� ������'); 

    vCURRENT_DATE := SYSDATE;

    DELETE FROM D_PHONE_NUMBER_CUTS DBN;
    --
    vDELETED_COUNT := SQL%ROWCOUNT;
    --
    FOR vRECORD IN CUR_PHONE_RETURN LOOP
      BEGIN

        -- ���������� ������������ DATE_LOAD
        IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
          vDATE_LOAD := vRECORD.DATE_LOAD;
        END IF;      
      
        IF NOT vCONTRAGENTS_ARRAY.EXISTS(vRECORD.CONTRAGENT_GUID) THEN
          vCONTRAGENTS_ARRAY(vRECORD.CONTRAGENT_GUID) := FIND_CONTRAGENT(vRECORD.CONTRAGENT_GUID);
        END IF;
        vUSER_ID := vCONTRAGENTS_ARRAY(vRECORD.CONTRAGENT_GUID);
        
        IF vUSER_ID IS NOT NULL THEN        
          vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
          vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, vRECORD.PHONE_NUMBER, vRECORD.IS_DIRECT);
    
          vPHONE_NUMBER_ID := RECREATE_PHONE_NUMBER(vRECORD.PHONE_NUMBER, vOPERATOR_ID, vRECORD.SIM_NUMBER2, vTARIFF_ID,
                                                    NULL /*vUSER_ID*/, -- ����� ����� �� �������� �� ����� �����������, ������ ����� ���� � �� �� ������������� �������  
                                                    '�������� ��� �������� ���������', vCURRENT_DATE,
                                                    --CASE vRECORD.DATE_ACTIVATION WHEN NULL THEN NULL ELSE GET_STATUS_OPTIONS_ID('ACTIVATED_1C') END,
                                                    NULL, 
                                                    NULL
                                                    );
        
          INSERT INTO D_PHONE_NUMBER_CUTS(PHONE_NUMBER_ID, USER_ID, DATE_ACTIVATED, DATE_CUT, DATE_LOAD)
          VALUES (vPHONE_NUMBER_ID, vUSER_ID, vRECORD.DATE_ACTIVATION, vRECORD.DATE_TIME, vRECORD.DATE_LOAD);
          --  
          vINSERTED_COUNT := vINSERTED_COUNT + 1;
        ELSE
          vSKIPED_COUNT := vSKIPED_COUNT + 1;
        END IF; 
        
        --COMMIT; 
      EXCEPTION WHEN OTHERS THEN
          vERROR_COUNT := vERROR_COUNT + 1;
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'PHONE_RETURNS', NULL, 
                  '������ ��� �������� �������� ��� ����������� ' || vRECORD.CONTRAGENT_DESCRIPTION||' ('||vRECORD.CONTRAGENT_GUID||')'||CHR(13)||CHR(10)||
                  '��� ������     : '||vRECORD.PHONE_NUMBER ||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vRECORD.DATE_TIME, 'DD.MM.YYYY HH24:MI:SS') ||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                  dbms_utility.format_error_backtrace
                  ,
                  NULL);
          EXIT;
      END;
    END LOOP;

    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'PHONE_RETURNS', NULL,
                  '�������� ��������� ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  --'����� �� ������  : '||vTOTAL_COUNT||CHR(13)||CHR(10)||
                  '�������          : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  '�� ��������� (��� �����������) : '||vSKIPED_COUNT||CHR(13)||CHR(10)||                  
                  '���������        : '||vINSERTED_COUNT--||CHR(13)||CHR(10)||
                  --'��������         : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  --'���������� ����-�: '||vRESTORED_COUNT||CHR(13)||CHR(10)||
                  --'�������-� �������: '||vREST_MINUS||CHR(13)||CHR(10)||                  
                  --'��� ���������    : '||vFOUND_COUNT
                  ,
                   NULL);
                   
    END IF;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
      vERROR_COUNT := vERROR_COUNT + 1;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'PHONE_RETURNS', NULL, 
              '������ ��� �������� ��������� '||CHR(13)||CHR(10)||
              '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
              '����� �������  : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
              dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
              dbms_utility.format_error_backtrace
              ,
              NULL);
  END;

 
  -- �������� ������� ������ ��������� ������������ 
  --   ������ ��������� � �������� �� ������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_CONTRAGENT_PERCENTS(pLOG_LEVEL INTEGER DEFAULT 1) 
  IS
    vRECORD CUR_CONTRAGENT_PERCENT%ROWTYPE;
    vUSER_ID NUMBER(8);
    vOPERATOR_ID INTEGER;
    
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)

    vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
    vINSERTED_COUNT PLS_INTEGER := 0;
    vSKIPED_COUNT PLS_INTEGER := 0;
    vUPDATED_COUNT PLS_INTEGER := 0;
    vDELETED_COUNT PLS_INTEGER := 0;
    vCONTRAGENTS_ARRAY T_CONTRAGENTS_ARRAY;
     
    vERROR_MESSAGE VARCHAR2(32000);
    vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
    
    CURSOR CUR_P(pUSER_ID INTEGER, pOPERATOR_ID INTEGER, pPERIOD DATE) IS
       SELECT P.CONTRAGENT_PERCENT_ID
         FROM D_CONTRAGENT_PERCENTS P
        WHERE P.USER_ID = pUSER_ID
          AND P.OPERATOR_ID = pOPERATOR_ID
          AND NVL(P.PERIOD, SYSDATE) = NVL(pPERIOD, SYSDATE);
    vCONTRAGENT_PERCENT_ID INTEGER;
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'CONTRAGENT_PERCENTS', NULL, '�������� ��������� ������������ ������'); 

    vCURRENT_DATE := SYSDATE;
    
    -- ������� ������ ������ �� ��������� ������
    DELETE FROM D_CONTRAGENT_PERCENTS;
    --
    vDELETED_COUNT := SQL%ROWCOUNT;
    --
    FOR vRECORD IN CUR_CONTRAGENT_PERCENT LOOP
      BEGIN
        -- ���������� ������������ DATE_LOAD
        IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
          vDATE_LOAD := vRECORD.DATE_LOAD;
        END IF;      
      
        IF NOT vCONTRAGENTS_ARRAY.EXISTS(vRECORD.GUID) THEN
          vCONTRAGENTS_ARRAY(vRECORD.GUID) := FIND_CONTRAGENT(vRECORD.GUID);
        END IF;
        vUSER_ID := vCONTRAGENTS_ARRAY(vRECORD.GUID);
        
        IF vUSER_ID IS NOT NULL THEN        
          vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
    
          OPEN CUR_P(vUSER_ID, vOPERATOR_ID, vRECORD.PERIOD);
          FETCH CUR_P INTO vCONTRAGENT_PERCENT_ID;
          CLOSE CUR_P;
         
          IF vCONTRAGENT_PERCENT_ID IS NULL THEN
            INSERT INTO D_CONTRAGENT_PERCENTS(USER_ID, OPERATOR_ID, PERCENT, LOAD_DATE, PERIOD)
            VALUES (vUSER_ID, vOPERATOR_ID, vRECORD."PERCENT", vCURRENT_DATE, vRECORD.PERIOD);
            vINSERTED_COUNT := vINSERTED_COUNT + 1;
          ELSE
            UPDATE D_CONTRAGENT_PERCENTS DP
            SET DP.PERCENT = vRECORD."PERCENT"
            WHERE DP.CONTRAGENT_PERCENT_ID = vCONTRAGENT_PERCENT_ID;
            vUPDATED_COUNT := vUPDATED_COUNT + 1; 
          END IF;
          --  
        ELSE
          vSKIPED_COUNT := vSKIPED_COUNT + 1;
          
          IF NVL(vRECORD.IS_LOCKED, 0) <> 1 THEN
            LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTRAGENT_PERCENTS', NULL, 
                  '��� �������� ��������� ��� ����������� ' || vRECORD.DESCRIPTION||' ('||vRECORD.GUID||')'||CHR(13)||CHR(10)||
                  '��� �����������: '||vRECORD.DESCRIPTION ||CHR(13)||CHR(10)||
                  '���������� �� ������. '
                  ,
                  NULL);
          END IF;
        END IF; 
        
        --COMMIT; 
      EXCEPTION WHEN OTHERS THEN
          vERROR_COUNT := vERROR_COUNT + 1;
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTRAGENT_PERCENTS', NULL, 
                  '������ ��� �������� ��������� ��� ����������� ' || vRECORD.USER_NAME||' ('||vRECORD.GUID||')'||CHR(13)||CHR(10)||
                  '��� �����������: '||vRECORD.DESCRIPTION ||CHR(13)||CHR(10)||
                  '��� ���������  : '||vRECORD.OPERATOR ||CHR(13)||CHR(10)||
                  '��� �������    : '||TO_CHAR(vRECORD.PERIOD, 'DD.MM.YYYY') ||CHR(13)||CHR(10)||
                  '������ ��������: '||vRECORD.PERCENT ||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                  dbms_utility.format_error_backtrace
                  ,
                  NULL);
          EXIT;
      END;
    END LOOP;

    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'CONTRAGENT_PERCENTS', NULL,
                  '�������� ��������� ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  --'����� �� ������  : '||vTOTAL_COUNT||CHR(13)||CHR(10)||
                  '�������          : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  '�� ��������� (��� �����������) : '||vSKIPED_COUNT||CHR(13)||CHR(10)||                  
                  '���������        : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
                  '���������        : '||vUPDATED_COUNT--||CHR(13)||CHR(10)||
                  --'��������         : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  --'���������� ����-�: '||vRESTORED_COUNT||CHR(13)||CHR(10)||
                  --'�������-� �������: '||vREST_MINUS||CHR(13)||CHR(10)||                  
                  --'��� ���������    : '||vFOUND_COUNT
                  ,
                   NULL);
                   
    END IF;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
      vERROR_COUNT := vERROR_COUNT + 1;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTRAGENT_PERCENTS', NULL, 
              '������ ��� �������� ��������� ������������ '||CHR(13)||CHR(10)||
              '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
              '����� �������  : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
              dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
              dbms_utility.format_error_backtrace
              ,
              NULL);
  END;  

  PROCEDURE RELOAD_TARIFF_PERCENTS(pLOG_LEVEL INTEGER DEFAULT 1) IS
    vRECORD CUR_TARIFF_PERCENT%ROWTYPE;
    vOPERATOR_ID INTEGER;
    vTARIFF_ID INTEGER;
    
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)

    vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
    vINSERTED_COUNT PLS_INTEGER := 0;
    --vSKIPED_COUNT PLS_INTEGER := 0;
    vUPDATED_COUNT PLS_INTEGER := 0;
    vDELETED_COUNT PLS_INTEGER := 0;
     
    vERROR_MESSAGE VARCHAR2(32000);
    vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
    
    CURSOR CUR_P(pTARIFF_ID INTEGER, pPERIOD DATE) IS
       SELECT P.TARIFF_PERCENT_ID
         FROM D_TARIFF_PERCENTS P
        WHERE P.TARIFF_ID = pTARIFF_ID
          AND NVL(P.PERIOD, SYSDATE) = NVL(pPERIOD, SYSDATE);
    vTARIFF_PERCENT_ID INTEGER;
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'TARIFF_PERCENTS', NULL, '�������� ��������� �� ������� ������'); 

    vCURRENT_DATE := SYSDATE;


/* ��� ��� ��������� ������ �������� ������, � ��������� �� D_TARIFF_PERCENTS */
    -- ������� ������ ������ �� ��������� ������
    DELETE FROM D_TARIFF_PERCENTS;

        
    --
    vDELETED_COUNT := SQL%ROWCOUNT;
    --
    FOR vRECORD IN CUR_TARIFF_PERCENT LOOP
      BEGIN
        -- ���������� ������������ DATE_LOAD
        IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
          vDATE_LOAD := vRECORD.DATE_LOAD;
        END IF;      
        
        vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
        vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, NULL, vRECORD.IS_DIRECT);
    
        OPEN CUR_P(vTARIFF_ID, vRECORD.PERIOD);
        FETCH CUR_P INTO vTARIFF_PERCENT_ID;
        CLOSE CUR_P;
         
        IF vTARIFF_PERCENT_ID IS NULL THEN
          INSERT INTO D_TARIFF_PERCENTS(TARIFF_ID, TARIFF_NAME, PERCENT, PERIOD, LOAD_DATE)
          VALUES (vTARIFF_ID, vRECORD.TARIFF_NAME, vRECORD."PERCENT", vRECORD.PERIOD, vCURRENT_DATE);
          vINSERTED_COUNT := vINSERTED_COUNT + 1;
        ELSE
          UPDATE D_TARIFF_PERCENTS DP
          SET DP.PERCENT = vRECORD."PERCENT"
          WHERE DP.TARIFF_PERCENT_ID = vTARIFF_PERCENT_ID;
          vUPDATED_COUNT := vUPDATED_COUNT + 1; 
        END IF;
        
        --COMMIT; 
      EXCEPTION WHEN OTHERS THEN
          vERROR_COUNT := vERROR_COUNT + 1;
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'TARIFF_PERCENTS', NULL, 
                  '������ ��� �������� ��������� ��� ������ ' || vRECORD.TARIFF_NAME||' ('||vRECORD.TARIFF_GUID||')'||CHR(13)||CHR(10)||
                  '��� �������  ' || TO_CHAR(vRECORD.PERIOD, 'DD.MM.YYYY') ||CHR(13)||CHR(10)||
                  '������ ��������: '||vRECORD.PERCENT ||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                  dbms_utility.format_error_backtrace
                  ,
                  NULL);
          EXIT;
      END;
    END LOOP;

    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'TARIFF_PERCENTS', NULL,
                  '�������� ��������� ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '���� ��������� ������ �� 1� : '||TO_CHAR(vDATE_LOAD, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  --'����� �� ������  : '||vTOTAL_COUNT||CHR(13)||CHR(10)||
                  '�������          : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  --'�� ��������� (��� �����������) : '||vSKIPED_COUNT||CHR(13)||CHR(10)||                  
                  '���������        : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
                  '���������        : '||vUPDATED_COUNT--||CHR(13)||CHR(10)||
                  --'��������         : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  --'���������� ����-�: '||vRESTORED_COUNT||CHR(13)||CHR(10)||
                  --'�������-� �������: '||vREST_MINUS||CHR(13)||CHR(10)||                  
                  --'��� ���������    : '||vFOUND_COUNT
                  ,
                   NULL);
                   
    END IF;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
      vERROR_COUNT := vERROR_COUNT + 1;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'TARIFF_PERCENTS', NULL, 
              '������ ��� �������� ��������� �� ������� '||CHR(13)||CHR(10)||
              '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
              '����� �������  : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
              dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
              dbms_utility.format_error_backtrace
              ,
              NULL);
  END;
  
  
  -- �������� ������ ��������� �� ���������� (����� + ����������) 
  --   ������ ��������� � �������� �� ������
  -- ������ ����� 0 - ������� ������ ������
  --              1 - ������ � ���������� �� ��������
  PROCEDURE RELOAD_CONTR_TARIFF_PERCENTS(pLOG_LEVEL INTEGER DEFAULT 1) IS
    vRECORD CUR_CONTR_TARIFF_PERCENT%ROWTYPE;
    vUSER_ID NUMBER(8);
    vOPERATOR_ID INTEGER;
    vTARIFF_ID INTEGER;
    
    vRECORD_COUNT INTEGER;
    vCURRENT_DATE DATE;
    vDATE DATE;
    vMAX_RECORD_COUNT PLS_INTEGER := 1000000; -- ������������ ���������� �������� (�� ������ ������ ���� ���-�� ����������)

    vERROR_COUNT INTEGER := 0; -- ���� �� ���� �� ���� ������ ��������
    vINSERTED_COUNT PLS_INTEGER := 0;
    vSKIPED_COUNT PLS_INTEGER := 0;
    vUPDATED_COUNT PLS_INTEGER := 0;
    vDELETED_COUNT PLS_INTEGER := 0;
    vCONTRAGENTS_ARRAY T_CONTRAGENTS_ARRAY;
     
    vERROR_MESSAGE VARCHAR2(32000);
    vDATE_LOAD DATE := TO_DATE('01.01.1900', 'DD.MM.YYYY');
    
    CURSOR CUR_P(pUSER_ID INTEGER, pTARIFF_ID INTEGER, pOPERATOR_ID INTEGER, pPERIOD DATE) IS
       SELECT P.CONTR_TARIFF_PERCENT_ID
         FROM D_CONTR_TARIFF_PERCENTS P
        WHERE P.USER_ID = pUSER_ID
          AND P.OPERATOR_ID = pOPERATOR_ID
          AND P.TARIFF_ID = pTARIFF_ID
          AND NVL(P.PERIOD, SYSDATE) = NVL(pPERIOD, SYSDATE);
    vCONTR_TARIFF_PERCENT_ID INTEGER;
  BEGIN
    LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('B', 'CONTR_TARIFF_PERCENTS', NULL, '�������� ��������� �� ������� ������������ ������'); 
    
    vCURRENT_DATE := SYSDATE;
    
    DELETE FROM D_CONTR_TARIFF_PERCENTS;
    --
    vDELETED_COUNT := SQL%ROWCOUNT;
    --
    FOR vRECORD IN CUR_CONTR_TARIFF_PERCENT LOOP
      BEGIN
        -- ���������� ������������ DATE_LOAD
        IF vRECORD.DATE_LOAD > vDATE_LOAD THEN
          vDATE_LOAD := vRECORD.DATE_LOAD;
        END IF;      
      
        IF NOT vCONTRAGENTS_ARRAY.EXISTS(vRECORD.GUID) THEN
          vCONTRAGENTS_ARRAY(vRECORD.GUID) := FIND_CONTRAGENT(vRECORD.GUID);
        END IF;
        vUSER_ID := vCONTRAGENTS_ARRAY(vRECORD.GUID);
        
        IF vUSER_ID IS NOT NULL THEN        
          vOPERATOR_ID := RECREATE_OPERATOR(vRECORD.OPERATOR);
          vTARIFF_ID := RECREATE_TARIFF(vRECORD.TARIFF_GUID, vRECORD.TARIFF_NAME, vOPERATOR_ID, NULL, vRECORD.IS_DIRECT);
    
          OPEN CUR_P(vUSER_ID, vTARIFF_ID, vOPERATOR_ID, vRECORD.PERIOD);
          FETCH CUR_P INTO vCONTR_TARIFF_PERCENT_ID;
          CLOSE CUR_P;
         
          IF vCONTR_TARIFF_PERCENT_ID IS NULL THEN
            INSERT INTO D_CONTR_TARIFF_PERCENTS(USER_ID, OPERATOR_ID, TARIFF_ID, PERCENT, LOAD_DATE, PERIOD)
            VALUES (vUSER_ID, vOPERATOR_ID, vTARIFF_ID, vRECORD."PERCENT", vCURRENT_DATE, vRECORD.PERIOD);
            vINSERTED_COUNT := vINSERTED_COUNT + 1;
          ELSE
            UPDATE D_CONTR_TARIFF_PERCENTS DP
            SET DP.PERCENT = vRECORD."PERCENT"
            WHERE DP.CONTR_TARIFF_PERCENT_ID = vCONTR_TARIFF_PERCENT_ID;
            vUPDATED_COUNT := vUPDATED_COUNT + 1; 
          END IF;
          --  
        ELSE
          vSKIPED_COUNT := vSKIPED_COUNT + 1;
          
          IF NVL(vRECORD.IS_LOCKED, 0) <> 1 THEN
            LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTR_TARIFF_PERCENTS', NULL, 
                  '��� �������� ��������� �� ������� ��� ����������� ' || vRECORD.DESCRIPTION||' ('||vRECORD.GUID||')'||CHR(13)||CHR(10)||
                  '��� �����������: '||vRECORD.DESCRIPTION ||CHR(13)||CHR(10)||
                  '���������� �� ������.'
                  ,
                  NULL);
          END IF;
        END IF; 
        
        --COMMIT; 
      EXCEPTION WHEN OTHERS THEN
          vERROR_COUNT := vERROR_COUNT + 1;
          LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTR_TARIFF_PERCENTS', NULL, 
                  '������ ��� �������� ��������� �� ������� ��� ����������� ' || vRECORD.USER_NAME||' ('||vRECORD.GUID||')'||CHR(13)||CHR(10)||
                  '��� �����������: '||vRECORD.DESCRIPTION ||CHR(13)||CHR(10)||
                  '��� ���������  : '||vRECORD.OPERATOR ||CHR(13)||CHR(10)||
                  '��� ������     : '||vRECORD.TARIFF_NAME ||CHR(13)||CHR(10)||
                  '��� �������    : '||TO_CHAR(vRECORD.PERIOD, 'DD.MM.YYYY') ||CHR(13)||CHR(10)||
                  '������ ��������: '||vRECORD.PERCENT ||CHR(13)||CHR(10)||
                  '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
                  dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                  dbms_utility.format_error_backtrace
                  ,
                  NULL);
          EXIT;
      END;
    END LOOP;

    IF pLOG_LEVEL > 0 THEN
      vDATE := SYSDATE;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('L', 'CONTR_TARIFF_PERCENTS', NULL,
                  '�������� ��������� �� ������� ��� ������������ ��������� '||S_GET_DELTA_TIME_STR(vCURRENT_DATE, vDATE)||' '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY')||' ('||TO_CHAR(vCURRENT_DATE, 'HH24:MI:SS')||' - '||TO_CHAR(SYSDATE, 'HH24:MI:SS')||')'||CHR(13)||CHR(10)||
                  '������           : '||vERROR_COUNT||CHR(13)||CHR(10)||
                  '�������          : '||vDELETED_COUNT||CHR(13)||CHR(10)||
                  '�� ��������� (��� �����������) : '||vSKIPED_COUNT||CHR(13)||CHR(10)||                  
                  '���������        : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
                  '�������� ������� : '||vUPDATED_COUNT--||CHR(13)||CHR(10)||
                  --'��������         : '||vUPDATED_COUNT||CHR(13)||CHR(10)||
                  --'���������� ����-�: '||vRESTORED_COUNT||CHR(13)||CHR(10)||
                  --'�������-� �������: '||vREST_MINUS||CHR(13)||CHR(10)||                  
                  --'��� ���������    : '||vFOUND_COUNT
                  ,
                   NULL);
                   
    END IF;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
      vERROR_COUNT := vERROR_COUNT + 1;
      LOG_EXCHANGE_PKG.PUT_LOG_MESSAGE_AUTONOMOUS('E', 'CONTR_TARIFF_PERCENTS', NULL, 
              '������ ��� �������� ��������� �� ������� ��� ������������ '||CHR(13)||CHR(10)||
              '���� ��������  : '||TO_CHAR(vCURRENT_DATE, 'DD.MM.YYYY HH24:MI:SS')||CHR(13)||CHR(10)||
              '����� �������  : '||vINSERTED_COUNT||CHR(13)||CHR(10)||
              dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
              dbms_utility.format_error_backtrace
              ,
              NULL);
  END;
 

  -- 

  -- �������� ��������
  PROCEDURE RELOAD_TREE_PIRAMYD(pLOG_LEVEL INTEGER DEFAULT 1) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE TREE_PIRAMYD';
    INSERT INTO TREE_PIRAMYD(MANAGER_GUID, MANAG_NAME, RELATION_KEY, N_ROW, TAX, BONUS, DATE_BONUS, DATE_LOAD, LEVEL_TREE) 
        SELECT TRIM(MANAGER_GUID), TRIM(MANAG_NAME), RELATION_KEY, N_ROW, TAX, BONUS, DATE_BONUS, DATE_LOAD, LEVEL_TREE
          FROM LOAD_TREE_PIRAMYD;       
  END;  
    
END;
/
