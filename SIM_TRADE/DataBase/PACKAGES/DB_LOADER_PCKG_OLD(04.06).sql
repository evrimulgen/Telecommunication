CREATE OR REPLACE PACKAGE DB_LOADER_PCKG AS
--
--#Version=40
--
--40 ��������. ������� ��������� ���������� ���-�� ������� ��������� �/�.
--39 �������. ���������� ��������� ��� ������ ��������
--38 �������. ��� �������� �� ���������, ����� ����� ��� � ������� "����"
--37 �������. ��������� �������� ����������� ����� �� �������.
--36 ��������. ������� ��������� ���������� ������ ������������ �����.
--35 ��������. �������� ��������� ����������� ��������� ������� �/�. (����. ������ ����������)
--34 �������. ���������� ������������� ��������
--33 �������. ���������� ����������(�������).
--32 �������. ���������� ����������.
--31 �������. �������� ����������� �������� �������, � ������ �����.
--30 �������. �������� �����: ���.����.
--29 ��������. ������� ��������� ����������� ��������� ������� �/�.
--27 ��������. ������� ������� � ��������� ��� ������ MN_UNLIM.
--25 ��������. ������� ���. ���� � �����.
--19 ������. ������ ���������� ��������� �������, ���� �� ��� �� ������ ��� ���������� ��������.
--18 ������. ������� ����������� � ������ ORGANIZATION_ID ��� ��������
--   (�������� ����������� ����� DB_LOADER_PCKG_VARS).
--17 �������. ����� ������-��� � DB_LOADER_SIM_PCKG.
--16 �������. + ��������� LOG_SEND_PAID_SMS_ADD_REC.
--15 �������. + ��������� LOG_SET_PHONE_OPTION_ADD_REC.
--14 �������. + ��������� update_phone_balance.
--13 �������. ��������� �������� ���������� ��� ���������� ������������ �����.
--
-- ���������� ���������� ������ � ������ DB_LOADER_PCKG_VARS !!!
--
PROCEDURE START_LOAD_PAYMENTS(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2
  );
--
PROCEDURE ADD_PAYMENT(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pPAYMENT_DATE DATE,
  pPAYMENT_SUM IN NUMBER,
  pPAYMENT_NUMBER IN VARCHAR2,
  pPAYMENT_VALID_FLAG IN NUMBER,
  pPAYMENT_STATUS_TEXT IN VARCHAR2
  );
--
PROCEDURE COMMIT_LOAD_PAYMENTS(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2
  );
--
procedure ADD_DB_LOADER_PHONE_STAT_UPD(
  pYEAR                     IN NUMBER,
  pMONTH                    IN NUMBER,
  pLOGIN                    IN VARCHAR2,
  pPHONE_NUMBER             IN VARCHAR2
  );  

--
PROCEDURE START_LOAD_ACCOUNT_PHONES(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2
  );
--
FUNCTION GET_VOLUME_SERVICE(
  pPHONE_NUMBER IN VARCHAR2,
  vYEAR_MONTH in integer,
  vSERVICE_VOLUME_ID in number
  ) RETURN VARCHAR2;
--
PROCEDURE ADD_ACCOUNT_PHONE(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pPHONE_IS_ACTIVE  IN NUMBER,              /* 0 - ����������, 1 - �������� */
  pCELL_PLAN_CODE IN VARCHAR2,              /* ��� ��������� �����*/
  pNEW_CELL_PLAN_CODE IN VARCHAR2,          /* ��� ������ ��������� �����*/
  pNEW_CELL_PLAN_DATE IN DATE,              /* ���� ����� ��������� �����*/
  pORGANIZATION_ID IN VARCHAR2,             /* ��� ����������� */
  pNEED_RESET_OPTIONS IN INTEGER DEFAULT 1, /* ����� ���������� �������� ����� (����� ��������� ������) */
  pCONSERVATION IN NUMBER DEFAULT 0,        /* 0 - ���, 1 - �� ���������� */
  pSYSTEM_BLOCK IN NUMBER DEFAULT 0         /* 0 - ���, 1 - ��������� ���� �� ������������� */
  );
--
PROCEDURE ADD_ACCOUNT_PHONE_OPTION(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pOPTION_CODE IN VARCHAR2,       /* ��� ����� */
  pOPTION_NAME IN VARCHAR2,       /* ������������ ����� */
  pOPTION_PARAMETERS IN VARCHAR2, /* ��������� ����� */
  pTURN_ON_DATE IN DATE,          /* ���� ����������� */
  pTURN_OFF_DATE IN DATE,         /* ���� ����������� */
  pTURN_ON_COST IN NUMBER,        /* ��������� ����������� */
  pMONTHLY_PRICE IN NUMBER        /* ��������� � ����� */
  );
--
PROCEDURE COMMIT_LOAD_ACCOUNT_PHONES(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2
  );
--
-- ���� ���������� ������� �������� (������� � �� ����� ������������ ��������������� �����)
FUNCTION GET_PHONE_BALANCE_DATE(
  pPHONE_NUMBER IN VARCHAR2
  ) RETURN DATE;
--
--������������� ����������� �� ������ ������������� ��������
PROCEDURE SET_MN_UNLIM_VOLUME (
  pYEAR                     IN NUMBER,                    
  pMONTH                    IN NUMBER,
  pPHONE_NUMBER             IN VARCHAR2,
  pMnUnlimD                IN NUMBER,
  pMnUnlimT  IN NUMBER,
  pMnUnlimO   IN NUMBER
  );
--  
-- ��������������� ����� ���������� �� ������
PROCEDURE SET_DB_LOADER_PHONE_STAT(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pESTIMATE_SUM NUMBER,
  pZEROCOST_OUTCOME_MINUTES NUMBER,
  pZEROCOST_OUTCOME_COUNT NUMBER,
  pCALLS_COUNT INTEGER,
  pCALLS_MINUTES NUMBER,
  pCALLS_COST NUMBER,
  pSMS_COUNT INTEGER,
  pSMS_COST NUMBER,
  pMMS_COUNT INTEGER,
  pMMS_COST NUMBER,
  pINTERNET_MB NUMBER,
  pINTERNET_COST NUMBER
  );
--
PROCEDURE SET_PHONE_BILL_DATA (
  pYEAR                     IN NUMBER,
  pMONTH                    IN NUMBER,
  pLOGIN                    IN VARCHAR2,
  pPHONE_NUMBER             IN VARCHAR2,
  pDATE_BEGIN               IN DATE,
  pDATE_END                 IN DATE,
  pBILL_SUM                 IN NUMBER,
  pSUBSCRIBER_PAYMENT_MAIN  IN NUMBER,
  pSUBSCRIBER_PAYMENT_ADD   IN NUMBER,
  pSINGLE_PAYMENTS          IN NUMBER,
  pCALLS_LOCAL_COST         IN NUMBER,
  pCALLS_OTHER_CITY_COST    IN NUMBER,
  pCALLS_OTHER_COUNTRY_COST IN NUMBER,
  pMESSAGES_COST            IN NUMBER,
  pINTERNET_COST            IN NUMBER,
  pOTHER_COUNTRY_ROAMING_COST IN NUMBER,
  pNATIONAL_ROAMING_COST    IN NUMBER,
  pPENI_COST                IN NUMBER,
  pDISCOUNT_VALUE           IN NUMBER,
  pTARIFF_CODE              IN VARCHAR2, 
  pother_country_roaming_calls    IN NUMBER,
  pother_country_roaming_mes IN NUMBER,
  pother_country_roaming_int IN NUMBER,
  pnational_roaming_calls         IN NUMBER,
  pnational_roaming_messages      IN NUMBER,
  pnational_roaming_internet      IN NUMBER
  );
--
-- ������������� ����� �� ���� � ������� ������ (����� �������� ���������� ��� ������������ ������)
PROCEDURE SET_ACCOUNT_LOGON_PAUSE(
  pACCOUNT_NAME IN VARCHAR2, 
  pPAUSED_MINUTES IN INTEGER
  );
--
-- ��������� ����� �� ���� � ������� ������ (����� �������� ���������� ��� ������������ ������)
FUNCTION IS_ACCOUNT_LOGON_PAUSED(
  pACCOUNT_NAME IN VARCHAR2
  ) RETURN INTEGER;
--
-- �������� �������� ���������
FUNCTION GET_CONSTANT_VALUE(
  pCONSTANT_NAME IN VARCHAR2
  ) RETURN VARCHAR2;
--
--���������� ��������� ���� ����������� ������ ������������� ��������
FUNCTION GET_MN_UNLIM_SDATE(
  pPHONE_NUMBER IN VARCHAR2
  ) RETURN date;
--
PROCEDURE SET_REPORT_DATA(
  pPHONE_NUMBER IN VARCHAR2,
  pCURRENT_SUM IN NUMBER,
  pDATE_LAST_UPDATE IN VARCHAR2
  );
--
PROCEDURE SET_FIELD_DETAILS(
  pFIELD_ID IN INTEGER,
  pFIELD_VALUE IN VARCHAR2
  );
--��������� ��������� ������� �/�  
PROCEDURE SAVE_BALANCE_CHANGE(
  pLOGIN IN VARCHAR2,
  pBALANCE IN VARCHAR2
  );
-- ��������, �������� �� ����
FUNCTION CHECK_BILL_DETAILS(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pABONKA IN NUMBER,
  pCALLS IN NUMBER,
  pSINGLE_PAYMENTS IN NUMBER,
  pDISCOUNTS IN NUMBER,
  pBILL_SUM IN NUMBER
  ) RETURN INTEGER;
-- ������� ������� ��������� �� �����
PROCEDURE CLEAR_BILL_DETAIL_ABON_PERIOD(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2
  );
-- �������� ������ ��������� �� �����
PROCEDURE ADD_BILL_DETAIL_ABON_PERIOD(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pDATE_BEGIN IN VARCHAR2,
  pDATE_END IN VARCHAR2,
  pTARIFF_CODE IN VARCHAR2,
  pABON_MAIN IN NUMBER,
  pABON_ADD IN NUMBER,
  pABON_ALL IN NUMBER
  );
-- ������� �������  �/� �������� �� �����
PROCEDURE CLEAR_BILL_DETAIL_MN_ROUMING(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2
  );
-- �������� ������ �/� �������� �� �����
PROCEDURE ADD_BILL_DETAIL_MN_ROUMING(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pDATE_BEGIN IN VARCHAR2,
  pDATE_END IN VARCHAR2,
  pROUMING_COUNTRY IN VARCHAR2,
  pROUMING_CALLS IN NUMBER,
  pROUMING_GPRS IN NUMBER,
  pROUMING_SMS IN NUMBER,
  pCOMPANY_TAX IN NUMBER,
  pROUMING_SUM IN NUMBER
  );
-- ������� �������  ��� �������� �� �����
PROCEDURE CLEAR_BILL_DETAIL_MG_ROUMING(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2
  );
-- �������� ������ ��� �������� �� �����
PROCEDURE ADD_BILL_DETAIL_MG_ROUMING(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pDATE_BEGIN IN VARCHAR2,
  pDATE_END IN VARCHAR2,
  pROUMING_COUNTRY IN VARCHAR2,
  pROUMING_CALLS IN NUMBER,
  pROUMING_GPRS IN NUMBER,
  pROUMING_SMS IN NUMBER,
  pCOMPANY_TAX IN NUMBER,
  pROUMING_SUM IN NUMBER
  );
-- �������� ����
PROCEDURE ADD_BILL_DETAILS(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pABONKA IN NUMBER,
  pCALLS IN NUMBER,
  pSINGLE_PAYMENTS IN NUMBER,
  pDISCOUNTS IN NUMBER,
  pBILL_SUM IN NUMBER,
  pCOMPLETE_BILL IN INTEGER
  );
-- ��������� ���� � ��������
PROCEDURE COMMIT_BILL_DETAILS(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pABONKA IN NUMBER,
  pCALLS IN NUMBER,
  pSINGLE_PAYMENTS IN NUMBER,
  pDISCOUNTS IN NUMBER,
  pBILL_SUM IN NUMBER,
  pCOMPLETE_BILL IN INTEGER,
  pABON_MAIN IN NUMBER,
  pABON_ADD IN NUMBER,
  pABON_OTHER IN NUMBER,
  pSINGLE_MAIN IN NUMBER,
  pSINGLE_ADD IN NUMBER, 
  pSINGLE_PENALTI IN NUMBER, 
  pSINGLE_CHANGE_TARIFF IN NUMBER,
  pSINGLE_TURN_ON_SERV IN NUMBER, 
  pSINGLE_CORRECTION_ROUMING IN NUMBER,
  pSINGLE_INTRA_WEB IN NUMBER,
  pSINGLE_VIEW_BLACK_LIST IN NUMBER,
  pSINGLE_OTHER IN NUMBER, 
  pDISCOUNT_YEAR IN NUMBER, 
  pDISCOUNT_SMS_PLUS IN NUMBER, 
  pDISCOUNT_CALL IN NUMBER, 
  pDISCOUNT_COUNT_ON_PHONES IN NUMBER,
  pDISCOUNT_SOVINTEL IN NUMBER,
  pDISCOUNT_OTHERS IN NUMBER, 
  pCALLS_COUNTRY IN NUMBER, 
  pCALLS_SITY IN NUMBER, 
  pCALLS_LOCAL IN NUMBER, 
  pCALLS_SMS_MMS IN NUMBER, 
  pCALLS_GPRS IN NUMBER, 
  pCALLS_RUS_RPP IN NUMBER, 
  pCALLS_ALL IN NUMBER,
  pROUMING_NATIONAL IN NUMBER,
  pROUMING_INTERNATIONAL IN NUMBER
  );
--
PROCEDURE ADD_ACCOUNT_PHONE_OPTION2(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pOPTION_CODE IN VARCHAR2,       /* ��� ����� */
  pOPTION_NAME IN VARCHAR2,       /* ������������ ����� */
  pOPTION_PARAMETERS IN VARCHAR2, /* ��������� ����� */
  pTURN_ON_DATE IN DATE,          /* ���� ����������� */
  pTURN_OFF_DATE IN DATE,         /* ���� ����������� */
  pTURN_ON_COST IN NUMBER,        /* ��������� ����������� */
  pMONTHLY_PRICE IN NUMBER        /* ��������� � ����� */
  );
--��������� ���-�� ������� ��������� �/�  
PROCEDURE SAVE_COUNT_PHONE(
  pLOGIN IN VARCHAR2,
  pCountPhone IN NUMBER
  );
--
END; 
/
CREATE OR REPLACE PACKAGE BODY DB_LOADER_PCKG AS
--
PROCEDURE START_LOAD_PAYMENTS(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2
  ) IS
--
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
/* �� �������
  DELETE FROM DB_LOADER_PAYMENTS 
    WHERE DB_LOADER_PAYMENTS.ACCOUNT_ID=vACCOUNT_ID 
    AND DB_LOADER_PAYMENTS.YEAR_MONTH=vYEAR_MONTH;
*/
END;
--
procedure ADD_DB_LOADER_PHONE_STAT_UPD(
  pYEAR                     IN NUMBER,
  pMONTH                    IN NUMBER,
  pLOGIN                    IN VARCHAR2,
  pPHONE_NUMBER             IN VARCHAR2
  ) IS
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
  CURSOR C_FIND IS
    SELECT ddd.ROWID,
      ddd.*
    FROM DB_LOADER_PHONE_STAT_update ddd
    WHERE ddd.year=pYEAR
          AND DDD.MONTH=pMONTH
          AND ddd.PHONE_NUMBER=pPHONE_NUMBER
          and ddd.login=pLOGIN;
  C_REC C_FIND%ROWTYPE;
BEGIN
  OPEN C_FIND;
  FETCH C_FIND INTO C_REC;
  IF C_FIND%FOUND THEN
    null;
  ELSE
    insert into DB_LOADER_PHONE_STAT_update values(pYEAR,pPHONE_NUMBER,null,pMONTH,pLOGIN);
    commit;
  END IF;
  CLOSE C_FIND;
END;
--
FUNCTION GET_VOLUME_SERVICE(
  pPHONE_NUMBER IN VARCHAR2,
  vYEAR_MONTH in integer,
  vSERVICE_VOLUME_ID in number
  ) RETURN VARCHAR2 IS
  RES varchar2(50);
  vSQL_PV varchar2(300);
--#Version=1
BEGIN
select nvl(sv.sql_pv,'0') into vSQL_PV from service_volume sv
where sv.service_volume_id=vSERVICE_VOLUME_ID;
if vSQL_PV<>'0' then
  vSQL_PV:=REPLACE(vSQL_PV,'%ph_num%',''''||pPHONE_NUMBER||'''');
  vSQL_PV:=REPLACE(vSQL_PV,'%y_mo%',to_char(vYEAR_MONTH));
            begin
            execute immediate vSQL_PV
              into RES;
          exception
            when others then
              RES := '0';
          end;
 return RES;
else
  return vSQL_PV;
end if;
EXCEPTION WHEN others THEN
  return '0';
END;
--
PROCEDURE ADD_PAYMENT(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pPAYMENT_DATE DATE,
  pPAYMENT_SUM IN NUMBER,
  pPAYMENT_NUMBER IN VARCHAR2,
  pPAYMENT_VALID_FLAG IN NUMBER,
  pPAYMENT_STATUS_TEXT IN VARCHAR2
  ) IS
--
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
  -- ����� �� �������� �����, ������ ������� � ������ ��������
  CURSOR C_FIND_1 IS
    SELECT 1 FROM DB_LOADER_PAYMENTS
    WHERE 
      DB_LOADER_PAYMENTS.ACCOUNT_ID=vACCOUNT_ID
      AND DB_LOADER_PAYMENTS.PAYMENT_NUMBER = pPAYMENT_NUMBER
      AND NVL(DB_LOADER_PAYMENTS.PHONE_NUMBER, '000') = NVL(pPHONE_NUMBER, '000')
      AND SIGN(DB_LOADER_PAYMENTS.PAYMENT_SUM) = SIGN(pPAYMENT_SUM);
  -- ����� �� �������� �����, ������ �������� � ����� � ������� ������ �������
  CURSOR C_FIND_2 IS
    SELECT 1 FROM DB_LOADER_PAYMENTS
    WHERE 
      DB_LOADER_PAYMENTS.ACCOUNT_ID=vACCOUNT_ID
      AND NVL(DB_LOADER_PAYMENTS.PHONE_NUMBER, '000') = NVL(pPHONE_NUMBER, '000')
      AND DB_LOADER_PAYMENTS.PAYMENT_SUM = pPAYMENT_SUM
      AND PAYMENT_NUMBER IS NULL;
  -- ����� �������-��������� ��� ��������
  CURSOR C_RETURN_BASE IS
    SELECT 1 FROM DB_LOADER_PAYMENTS
    WHERE
      DB_LOADER_PAYMENTS.ACCOUNT_ID=vACCOUNT_ID
      AND DB_LOADER_PAYMENTS.PAYMENT_NUMBER = pPAYMENT_NUMBER
      AND NVL(DB_LOADER_PAYMENTS.PHONE_NUMBER, '000') = NVL(pPHONE_NUMBER, '000')
      AND SIGN(DB_LOADER_PAYMENTS.PAYMENT_SUM) = -SIGN(pPAYMENT_SUM);
  --
  vFOUND BOOLEAN;
  vDUMMY BINARY_INTEGER;
  --  
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  IF NOT((ms_constants.GET_CONSTANT_VALUE('SERVER_NAME')='CORP_MOBILE') 
          AND ((vACCOUNT_ID<>62)or(pLOGIN='A394059377'))
          AND (pPAYMENT_DATE<TO_DATE('15.05.2012', 'DD.MM.YYYY'))) THEN
    IF (pPAYMENT_SUM < 0) AND (pPAYMENT_NUMBER IS NOT NULL) THEN
      -- ���� ��� �������, �� ���� �����-���������, � ���������, ���� ��� ���.
      OPEN C_RETURN_BASE;
      FETCH C_RETURN_BASE INTO vDUMMY;
      IF C_RETURN_BASE%NOTFOUND THEN
        -- �����-��������� �� ������, ��������� (���� ������������). 
        INSERT INTO DB_LOADER_PAYMENTS(
          ACCOUNT_ID, 
          YEAR_MONTH, 
          PHONE_NUMBER,
          PAYMENT_DATE, 
          PAYMENT_SUM, 
          PAYMENT_NUMBER,
          PAYMENT_STATUS_IS_VALID,
          PAYMENT_STATUS_TEXT
          ) VALUES (
          vACCOUNT_ID, 
          vYEAR_MONTH, 
          pPHONE_NUMBER,
          pPAYMENT_DATE, 
          -pPAYMENT_SUM, 
          pPAYMENT_NUMBER,
          1,
          NULL
          );
      END IF;
      CLOSE C_RETURN_BASE;
    END IF;
    -- ���� � ������ ��������.
    IF pPAYMENT_NUMBER IS NOT NULL THEN
      -- �� ������ ������� � ������ ��������
      OPEN C_FIND_1;
      FETCH C_FIND_1 INTO vDUMMY;
      vFOUND := C_FIND_1%FOUND;
      CLOSE C_FIND_1;
    ELSE
      -- �� ������ ��������, ����� � ������� ������ �������
      OPEN C_FIND_2;
      FETCH C_FIND_2 INTO vDUMMY;
      vFOUND := C_FIND_2%FOUND;
      CLOSE C_FIND_2;
    END IF;
    -- ���� �����, �� �� ������ (������ ��� �������� ���������������)!
    IF (NOT vFOUND)AND(pYEAR*100+pMONTH=TO_NUMBER(TO_CHAR(PPAYMENT_DATE,'YYYYMM'))) THEN
      INSERT INTO DB_LOADER_PAYMENTS(
        ACCOUNT_ID, 
        YEAR_MONTH, 
        PHONE_NUMBER,
        PAYMENT_DATE, 
        PAYMENT_SUM, 
        PAYMENT_NUMBER,
        PAYMENT_STATUS_IS_VALID,
        PAYMENT_STATUS_TEXT
        ) VALUES (
        vACCOUNT_ID, 
        vYEAR_MONTH, 
        pPHONE_NUMBER,
        pPAYMENT_DATE, 
        pPAYMENT_SUM, 
        pPAYMENT_NUMBER,
        pPAYMENT_VALID_FLAG,
        pPAYMENT_STATUS_TEXT
        );
    END IF;
  END IF;  
END;
--
PROCEDURE COMMIT_LOAD_PAYMENTS(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2
  ) IS
--
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  -- ������ �� ������
END;
--
PROCEDURE START_LOAD_ACCOUNT_PHONES(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2
  ) IS
--
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  --
  -- �������� ���� ����������� � �������� ��. ����� ����� ������������, ���� �����.
  DB_LOADER_PCKG_VARS.gPHONE_ORGANIZATIONS.DELETE; 
  FOR rec IN (
    SELECT 
      PHONE_NUMBER, ORGANIZATION_ID 
      FROM DB_LOADER_ACCOUNT_PHONES 
      WHERE DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID=vACCOUNT_ID 
      AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH=vYEAR_MONTH) 
  LOOP
    DB_LOADER_PCKG_VARS.gPHONE_ORGANIZATIONS(rec.PHONE_NUMBER) := rec.ORGANIZATION_ID;
  END LOOP;
  -- ������ �������
  DELETE FROM DB_LOADER_ACCOUNT_PHONES 
    WHERE DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID=vACCOUNT_ID 
    AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH=vYEAR_MONTH;
END;
--
-- ��������� ���������� ������� � ������� 
--  ������ ���������� � ��������� ���� � ������������� ����� ������� ����� (01.01.3000)
--  ��� ������� ������-������
PROCEDURE ADD_ACCOUNT_PHONE_HISTORY(
  pPHONE_NUMBER IN VARCHAR2,
  pCELL_PLAN_CODE IN VARCHAR2,        /* ��� ��������� �����*/
  pPHONE_IS_ACTIVE  IN NUMBER,        /* 0 - ����������, 1 - �������� */
  pDATE IN DATE
  ) IS
  --  
  VERY_BIG_DATE CONSTANT DATE := TO_DATE('01.01.3000', 'DD.MM.YYYY');
  --
  -- ���� ������ � ���������� ������� ������� 
  CURSOR CUR_HIST(pPHONE_NUMBER IN VARCHAR2,
                  pDATE IN DATE) IS
    SELECT D.*
    FROM DB_LOADER_ACCOUNT_PHONE_HISTS D
    WHERE D.PHONE_NUMBER = pPHONE_NUMBER
      AND D.BEGIN_DATE <= pDATE AND pDATE < D.END_DATE;
  -- ������ ���������� ����� ��������� ���� (� �������)
  CURSOR CUR_HIST_FUTURE(pPHONE_NUMBER IN VARCHAR2,
                         pDATE IN DATE) IS
    SELECT D.*
    FROM DB_LOADER_ACCOUNT_PHONE_HISTS D
    WHERE D.PHONE_NUMBER = pPHONE_NUMBER
      AND D.BEGIN_DATE > pDATE
    ORDER BY D.BEGIN_DATE;
  -- ��������� ���������� �� ��������� ���� (� �������)
  CURSOR CUR_HIST_PAST(pPHONE_NUMBER IN VARCHAR2,
                       pDATE IN DATE) IS
    SELECT D.*
    FROM DB_LOADER_ACCOUNT_PHONE_HISTS D
    WHERE D.PHONE_NUMBER = pPHONE_NUMBER
      AND D.END_DATE <= pDATE
    ORDER BY D.END_DATE DESC;
  REC_HIST CUR_HIST%ROWTYPE;  
  vDATE DATE;
BEGIN
  OPEN CUR_HIST(pPHONE_NUMBER, pDATE);
  FETCH CUR_HIST INTO REC_HIST;
  IF CUR_HIST%NOTFOUND THEN
    -- �� ������ � ���������� ������� (������ ����� ������� ��� �� ������)
    -- ��� ��������� ���� �� ������ ������� 
    -- (����� ���� ��������� ������� �� ����� ����, �� ���� ��������� ���������� = ����� ������� ����) 
    --
    -- �������, ���� �� ���������� � �������
    OPEN CUR_HIST_PAST(pPHONE_NUMBER, pDATE);
    FETCH CUR_HIST_PAST INTO REC_HIST;
    IF CUR_HIST_PAST%NOTFOUND THEN
      -- �������, ���� �� ���������� � �������
      OPEN CUR_HIST_FUTURE(pPHONE_NUMBER, pDATE);
      FETCH CUR_HIST_FUTURE INTO REC_HIST;
      IF CUR_HIST_FUTURE%NOTFOUND THEN
        -- ���� ����������� ��� �� � ������� �� � �������,
        -- ������ ������� ��� �� ������, ��������� ������ ������� � ������
        INSERT INTO DB_LOADER_ACCOUNT_PHONE_HISTS
        (PHONE_NUMBER, BEGIN_DATE, END_DATE, PHONE_IS_ACTIVE, CELL_PLAN_CODE)
        VALUES
        (pPHONE_NUMBER, pDATE, VERY_BIG_DATE, pPHONE_IS_ACTIVE, pCELL_PLAN_CODE);
      ELSE
        -- ���� ���������� ���� ������ � �������
        -- �������� ������� ���������� �� �������� (�� ������� ����)
        UPDATE DB_LOADER_ACCOUNT_PHONE_HISTS D
        SET D.BEGIN_DATE = pDATE
        WHERE D.HISTORY_ID = REC_HIST.HISTORY_ID;        
      END IF;      
      CLOSE CUR_HIST_FUTURE;    
    ELSE
      RAISE_APPLICATION_ERROR(-20000, '������ ������� �������. ���� ����� ������� ������ ����� ������� ����.');
    END IF;
    CLOSE CUR_HIST_PAST;
  ELSE
    -- ������ � ���������� ������� (����������� ������ ����� �������� ����)
    IF (REC_HIST.PHONE_IS_ACTIVE = pPHONE_IS_ACTIVE)
      AND (REC_HIST.CELL_PLAN_CODE = pCELL_PLAN_CODE) THEN
      -- ������ � ���������� �������, � ����� �� ����������� � ��� �� �������
      NULL; -- ������ �� ������ 
    ELSE
      -- ������ � ���������� �������, � ������ �����������
      --      
      -- �������� ����������, ������ �������� ������
      UPDATE DB_LOADER_ACCOUNT_PHONE_HISTS D
      SET D.END_DATE = pDATE
      WHERE D.HISTORY_ID = REC_HIST.HISTORY_ID;
      -- ������� ���������� ������� �� ����������� �����
      INSERT INTO DB_LOADER_ACCOUNT_PHONE_HISTS
      (PHONE_NUMBER, BEGIN_DATE, END_DATE, PHONE_IS_ACTIVE, CELL_PLAN_CODE)
      VALUES
      (pPHONE_NUMBER, pDATE, REC_HIST.END_DATE, pPHONE_IS_ACTIVE, pCELL_PLAN_CODE);      
    END IF;    
  END IF;
  CLOSE CUR_HIST;
END;
--
PROCEDURE ADD_ACCOUNT_PHONE(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pPHONE_IS_ACTIVE  IN NUMBER,              /* 0 - ����������, 1 - �������� */
  pCELL_PLAN_CODE IN VARCHAR2,              /* ��� ��������� �����*/
  pNEW_CELL_PLAN_CODE IN VARCHAR2,          /* ��� ������ ��������� �����*/
  pNEW_CELL_PLAN_DATE IN DATE,              /* ���� ����� ��������� �����*/
  pORGANIZATION_ID IN VARCHAR2,             /* ��� ����������� */
  pNEED_RESET_OPTIONS IN INTEGER DEFAULT 1, /* ����� ���������� �������� ����� (����� ��������� ������) */
  pCONSERVATION IN NUMBER DEFAULT 0,        /* 0 - ���, 1 - �� ���������� */
  pSYSTEM_BLOCK IN NUMBER DEFAULT 0         /* 0 - ���, 1 - ��������� ���� �� ������������� */
  ) IS
--
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
  vORGANIZATION_ID VARCHAR2(100 CHAR);
  --
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  -- ���� pORGANIZATION_ID IS NULL, �� ��������� ��� �������� �� ������������ � START_LOAD_ACCOUNT_PHONES
  vORGANIZATION_ID := pORGANIZATION_ID;
  IF vORGANIZATION_ID IS NULL THEN
    IF DB_LOADER_PCKG_VARS.gPHONE_ORGANIZATIONS.EXISTS(pPHONE_NUMBER) THEN
      vORGANIZATION_ID := DB_LOADER_PCKG_VARS.gPHONE_ORGANIZATIONS(pPHONE_NUMBER);
    END IF;
  END IF;
  IF vORGANIZATION_ID IS NULL THEN
    vORGANIZATION_ID := '1'; -- �� ��������� - 1
  END IF;
  INSERT INTO DB_LOADER_ACCOUNT_PHONES(
    ACCOUNT_ID, 
    YEAR_MONTH, 
    PHONE_NUMBER,
    PHONE_IS_ACTIVE,
    CELL_PLAN_CODE,
    NEW_CELL_PLAN_CODE,
    NEW_CELL_PLAN_DATE,
    ORGANIZATION_ID,
    LAST_CHECK_DATE_TIME,
    CONSERVATION,
    SYSTEM_BLOCK
    ) VALUES (
    vACCOUNT_ID, 
    vYEAR_MONTH, 
    pPHONE_NUMBER,
    pPHONE_IS_ACTIVE,
    pCELL_PLAN_CODE,
    pNEW_CELL_PLAN_CODE,
    pNEW_CELL_PLAN_DATE,
    vORGANIZATION_ID,
    SYSDATE,
    pCONSERVATION,
    pSYSTEM_BLOCK
    );
  -- ������� ���������     
  ADD_ACCOUNT_PHONE_HISTORY(pPHONE_NUMBER, pCELL_PLAN_CODE, NVL(pPHONE_IS_ACTIVE, 0), SYSDATE);
  --
  IF pNEED_RESET_OPTIONS = 1 THEN
    -- ��������� ���� ���������� ��� �����. 
    -- ����� ��� ����������� ����� ��� ����� ������������� � ADD_ACCOUNT_PHONE_OPTION.
    UPDATE DB_LOADER_ACCOUNT_PHONE_OPTS
      SET TURN_OFF_DATE = TRUNC(SYSDATE)
      WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH=vYEAR_MONTH
        AND DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER = pPHONE_NUMBER
        AND TURN_OFF_DATE IS NULL -- ���� ���� ���������� ��� �� ������
        ;
    --
  END IF;
END;
--
PROCEDURE ADD_ACCOUNT_PHONE_OPTION(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pOPTION_CODE IN VARCHAR2,       /* ��� ����� */
  pOPTION_NAME IN VARCHAR2,       /* ������������ ����� */
  pOPTION_PARAMETERS IN VARCHAR2, /* ��������� ����� */
  pTURN_ON_DATE IN DATE,          /* ���� �����������*/
  pTURN_OFF_DATE IN DATE,         /* ���� ����������� */
  pTURN_ON_COST IN NUMBER,        /* ��������� ����������� */
  pMONTHLY_PRICE IN NUMBER        /* ��������� � ����� */
  ) IS
--
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
  CURSOR C_FIND IS
    SELECT 
      DB_LOADER_ACCOUNT_PHONE_OPTS.ROWID,
      DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_OFF_DATE,
      DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_COST,
      DB_LOADER_ACCOUNT_PHONE_OPTS.MONTHLY_PRICE
    FROM DB_LOADER_ACCOUNT_PHONE_OPTS
    WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.ACCOUNT_ID=vACCOUNT_ID
    AND DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH=vYEAR_MONTH
    AND DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER = pPHONE_NUMBER
    AND DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE = pOPTION_CODE
    AND DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE = pTURN_ON_DATE;
  vREC C_FIND%ROWTYPE;
  CHECKrec BOOLEAN;
  MY_COUNT INTEGER;
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  --
  OPEN C_FIND;
  FETCH C_FIND INTO vREC;
  IF C_FIND%FOUND THEN
    IF (vREC.TURN_OFF_DATE IS NULL AND pTURN_OFF_DATE IS NOT NULL)
      OR (vREC.TURN_OFF_DATE IS NOT NULL AND pTURN_OFF_DATE IS NULL)
      OR (vREC.TURN_OFF_DATE <> pTURN_OFF_DATE)
      OR (NVL(vREC.TURN_ON_COST, -1) <> NVL(pTURN_ON_COST, -1))
      OR (NVL(vREC.MONTHLY_PRICE, -1) <> NVL(pMONTHLY_PRICE, -1))
       THEN
      UPDATE DB_LOADER_ACCOUNT_PHONE_OPTS
      SET TURN_OFF_DATE = pTURN_OFF_DATE,
        TURN_ON_COST = pTURN_ON_COST,
        MONTHLY_PRICE = pMONTHLY_PRICE,
        LAST_CHECK_DATE_TIME = SYSDATE
      WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.ROWID=vREC.ROWID;
    END IF;
  ELSE
    --�������� �� ���������� ������
    CHECKrec:=TRUE;
    SELECT COUNT(*)
      INTO MY_COUNT
      FROM DB_LOADER_ACCOUNT_PHONE_OPTS
      WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH=TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM'))
        AND DB_LOADER_ACCOUNT_PHONE_OPTS.ACCOUNT_ID=vACCOUNT_ID
        and rownum=1;
    --���� ������ ���������� ����� � ���� �������� �� ��������� �����    
    IF SYSDATE-pTURN_ON_DATE>60 
        AND ((vACCOUNT_ID <> 90) AND (TO_CHAR(SYSDATE, 'YYYYMM') = '201302'))      
        AND MY_COUNT>0 THEN
      SELECT COUNT(*)
        INTO MY_COUNT
        FROM DB_LOADER_ACCOUNT_PHONE_OPTS
        WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH=TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM'))
          AND DB_LOADER_ACCOUNT_PHONE_OPTS.ACCOUNT_ID=vACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER = pPHONE_NUMBER
          AND DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE = pOPTION_CODE
          AND DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE = pTURN_ON_DATE
          and rownum=1; 
      --� ���� ��� ������ �� ��������� ����� � ����� �� ����� �����������, ������ ������ ��������.
      IF MY_COUNT=0 THEN
        null;
        --CHECKrec:=FALSE;                 
      END IF;  
    END IF;
    IF CHECKrec THEN
      INSERT INTO DB_LOADER_ACCOUNT_PHONE_OPTS (
        ACCOUNT_ID,
        YEAR_MONTH,
        PHONE_NUMBER,
        OPTION_CODE,
        OPTION_NAME,
        OPTION_PARAMETERS,
        TURN_ON_DATE,
        TURN_OFF_DATE,
        TURN_ON_COST,
        MONTHLY_PRICE,
        LAST_CHECK_DATE_TIME
      ) VALUES (
        vACCOUNT_ID,
        vYEAR_MONTH,
        pPHONE_NUMBER,
        pOPTION_CODE,
        pOPTION_NAME,
        pOPTION_PARAMETERS,
        pTURN_ON_DATE,
        pTURN_OFF_DATE,
        pTURN_ON_COST,
        pMONTHLY_PRICE,
        SYSDATE
        );
    END IF;  
  END IF;
  CLOSE C_FIND;
END;
--
PROCEDURE COMMIT_LOAD_ACCOUNT_PHONES(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2
  ) IS
--
--  vYEAR_MONTH BINARY_INTEGER;
--  vACCOUNT_ID NUMBER;
BEGIN
--  vYEAR_MONTH := pYEAR*100+pMONTH;
--  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  --
  -- ������� ������ ORGANIZATION_ID
  DB_LOADER_PCKG_VARS.gPHONE_ORGANIZATIONS.DELETE;
END;
--
--���������� ��������� ���� ����������� ������ ������������� ��������
FUNCTION GET_MN_UNLIM_SDATE(
  pPHONE_NUMBER IN VARCHAR2
  ) RETURN date IS
--#Version=1
  vRESULT date;
BEGIN
SELECT
  nvl(max(DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE),to_date('31.12.1999','dd.mm.yyyy'))
into vRESULT
FROM
  DB_LOADER_ACCOUNT_PHONE_OPTS
WHERE
  DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER=pPHONE_NUMBER
  AND DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH = (
    SELECT MAX(YEAR_MONTH)
    FROM DB_LOADER_ACCOUNT_PHONE_OPTS
    WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER=pPHONE_NUMBER)
  and DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE='MN_UNLIMC'
  and nvl(DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_OFF_DATE,sysdate+1)>sysdate;
return vRESULT;
exception
  when others then return to_date('31.12.1999','dd.mm.yyyy');
END;
-- ���� ���������� ������� �������� (������� � �� ����� ������������ ��������������� �����)
FUNCTION GET_PHONE_BALANCE_DATE(
  pPHONE_NUMBER IN VARCHAR2
  ) RETURN DATE IS
BEGIN
  FOR rec IN (
    SELECT MAX(BALANCE_DATE) LAST_DATE
    FROM (
      SELECT PHONE_BALANCES.BALANCE_DATE
      FROM PHONE_BALANCES
      WHERE PHONE_NUMBER=pPHONE_NUMBER
    UNION
      SELECT CONTRACTS.CONTRACT_DATE
      FROM CONTRACTS
      WHERE CONTRACTS.PHONE_NUMBER_FEDERAL=pPHONE_NUMBER
    )
  ) LOOP
    RETURN rec.LAST_DATE;
  END LOOP;
  RETURN NULL;
END;
--
-- ��������������� ����� ���������� �� ������
PROCEDURE SET_DB_LOADER_PHONE_STAT(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pESTIMATE_SUM NUMBER,
  pZEROCOST_OUTCOME_MINUTES NUMBER,
  pZEROCOST_OUTCOME_COUNT NUMBER,
  pCALLS_COUNT INTEGER,
  pCALLS_MINUTES NUMBER,
  pCALLS_COST NUMBER,
  pSMS_COUNT INTEGER,
  pSMS_COST NUMBER,
  pMMS_COUNT INTEGER,
  pMMS_COST NUMBER,
  pINTERNET_MB NUMBER,
  pINTERNET_COST NUMBER
  ) IS
--
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
  CURSOR c IS
    SELECT * 
    FROM DB_LOADER_PHONE_STAT
    WHERE DB_LOADER_PHONE_STAT.YEAR_MONTH=vYEAR_MONTH
      AND DB_LOADER_PHONE_STAT.PHONE_NUMBER = pPHONE_NUMBER
      FOR UPDATE;
   C_REC c%ROWTYPE;
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  OPEN c;
  FETCH c INTO C_REC;
  IF c%NOTFOUND THEN
    -- �������
    INSERT INTO DB_LOADER_PHONE_STAT (
      ACCOUNT_ID,
      YEAR_MONTH,
      PHONE_NUMBER,
      ESTIMATE_SUM,
      ZEROCOST_OUTCOME_MINUTES,
      ZEROCOST_OUTCOME_COUNT,
      CALLS_COUNT,
      CALLS_MINUTES,
      CALLS_COST,
      SMS_COUNT,
      SMS_COST,
      MMS_COUNT,
      MMS_COST,
      INTERNET_MB,
      INTERNET_COST,
      LAST_CHECK_DATE_TIME
    ) VALUES (
      vACCOUNT_ID,
      vYEAR_MONTH,
      pPHONE_NUMBER,
      pESTIMATE_SUM,
      pZEROCOST_OUTCOME_MINUTES,
      pZEROCOST_OUTCOME_COUNT,
      pCALLS_COUNT,
      pCALLS_MINUTES,
      pCALLS_COST,
      pSMS_COUNT,
      pSMS_COST,
      pMMS_COUNT,
      pMMS_COST,
      pINTERNET_MB,
      pINTERNET_COST,
      SYSDATE
    );
  ELSE
    -- �������
    UPDATE DB_LOADER_PHONE_STAT
    SET
      ACCOUNT_ID=vACCOUNT_ID,
      ESTIMATE_SUM=pESTIMATE_SUM,
      ZEROCOST_OUTCOME_MINUTES = pZEROCOST_OUTCOME_MINUTES,
      ZEROCOST_OUTCOME_COUNT = pZEROCOST_OUTCOME_COUNT,
      CALLS_COUNT = pCALLS_COUNT,
      CALLS_MINUTES = pCALLS_MINUTES,
      CALLS_COST = pCALLS_COST,
      SMS_COUNT = pSMS_COUNT,
      SMS_COST = pSMS_COST,
      MMS_COUNT = pMMS_COUNT,
      MMS_COST = pMMS_COST,
      INTERNET_MB = pINTERNET_MB,
      INTERNET_COST = pINTERNET_COST,
      LAST_CHECK_DATE_TIME=SYSDATE
    WHERE CURRENT OF c;
  END IF;
END;
--
PROCEDURE SET_PHONE_BILL_DATA (
  pYEAR                     IN NUMBER,                    
  pMONTH                    IN NUMBER,
  pLOGIN                    IN VARCHAR2,
  pPHONE_NUMBER             IN VARCHAR2,
  pDATE_BEGIN               IN DATE,
  pDATE_END                 IN DATE,
  pBILL_SUM                 IN NUMBER,
  pSUBSCRIBER_PAYMENT_MAIN  IN NUMBER,
  pSUBSCRIBER_PAYMENT_ADD   IN NUMBER,
  pSINGLE_PAYMENTS          IN NUMBER,
  pCALLS_LOCAL_COST         IN NUMBER,
  pCALLS_OTHER_CITY_COST    IN NUMBER,
  pCALLS_OTHER_COUNTRY_COST IN NUMBER,
  pMESSAGES_COST            IN NUMBER,
  pINTERNET_COST            IN NUMBER,
  pOTHER_COUNTRY_ROAMING_COST IN NUMBER,
  pNATIONAL_ROAMING_COST    IN NUMBER,
  pPENI_COST                IN NUMBER,
  pDISCOUNT_VALUE           IN NUMBER,
  pTARIFF_CODE              IN VARCHAR2,
  pother_country_roaming_calls    IN NUMBER,
  pother_country_roaming_mes IN NUMBER,
  pother_country_roaming_int IN NUMBER,
  pnational_roaming_calls         IN NUMBER,
  pnational_roaming_messages      IN NUMBER,
  pnational_roaming_internet      IN NUMBER
  ) IS
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
  CURSOR C_FIND IS
    SELECT
      DB_LOADER_BILLS.ROWID,
      DB_LOADER_BILLS.*
    FROM DB_LOADER_BILLS
    WHERE DB_LOADER_BILLS.ACCOUNT_ID=vACCOUNT_ID
          AND DB_LOADER_BILLS.YEAR_MONTH=vYEAR_MONTH
          AND DB_LOADER_BILLS.PHONE_NUMBER=pPHONE_NUMBER;
  C_REC C_FIND%ROWTYPE;
  cDUMMY_NUMBER CONSTANT NUMBER := -1234456.25847;
  cDUMMY_DATE CONSTANT DATE := TO_DATE('15.03.1974 11', 'dd.mm.yyyy hh24');
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  OPEN C_FIND;
  FETCH C_FIND INTO C_REC;
  IF C_FIND%FOUND THEN
    IF NVL(C_REC.DATE_BEGIN, cDUMMY_DATE) <>                 NVL(pDATE_BEGIN, cDUMMY_DATE)
      OR NVL(C_REC.DATE_END, cDUMMY_DATE) <>                 NVL(pDATE_END, cDUMMY_DATE)
      OR NVL(C_REC.BILL_SUM, cDUMMY_NUMBER) <>               NVL(pBILL_SUM, cDUMMY_NUMBER)
      OR NVL(C_REC.SUBSCRIBER_PAYMENT_MAIN, cDUMMY_NUMBER)<> NVL(pSUBSCRIBER_PAYMENT_MAIN, cDUMMY_NUMBER)
      OR NVL(C_REC.SUBSCRIBER_PAYMENT_ADD, cDUMMY_NUMBER) <> NVL(pSUBSCRIBER_PAYMENT_ADD, cDUMMY_NUMBER)
      OR NVL(C_REC.SINGLE_PAYMENTS, cDUMMY_NUMBER) <>        NVL(pSINGLE_PAYMENTS, cDUMMY_NUMBER)
      OR NVL(C_REC.CALLS_LOCAL_COST, cDUMMY_NUMBER) <>       NVL(pCALLS_LOCAL_COST, cDUMMY_NUMBER)
      OR NVL(C_REC.CALLS_OTHER_CITY_COST, cDUMMY_NUMBER) <>  NVL(pCALLS_OTHER_CITY_COST, cDUMMY_NUMBER)
      OR NVL(C_REC.CALLS_OTHER_COUNTRY_COST, cDUMMY_NUMBER) <>NVL(pCALLS_OTHER_COUNTRY_COST, cDUMMY_NUMBER)
      OR NVL(C_REC.MESSAGES_COST, cDUMMY_NUMBER) <>          NVL(pMESSAGES_COST, cDUMMY_NUMBER)
      OR NVL(C_REC.INTERNET_COST, cDUMMY_NUMBER) <>          NVL(pINTERNET_COST, cDUMMY_NUMBER)
      OR NVL(C_REC.OTHER_COUNTRY_ROAMING_COST, cDUMMY_NUMBER) <>NVL(pOTHER_COUNTRY_ROAMING_COST, cDUMMY_NUMBER)
      OR NVL(C_REC.NATIONAL_ROAMING_COST, cDUMMY_NUMBER) <>  NVL(pNATIONAL_ROAMING_COST, cDUMMY_NUMBER)
      OR NVL(C_REC.PENI_COST, cDUMMY_NUMBER) <>              NVL(pPENI_COST, cDUMMY_NUMBER)
      OR NVL(C_REC.DISCOUNT_VALUE, cDUMMY_NUMBER) <>         NVL(pDISCOUNT_VALUE, cDUMMY_NUMBER)
      OR NVL(C_REC.other_country_roaming_calls, cDUMMY_NUMBER) <>         NVL(pother_country_roaming_calls, cDUMMY_NUMBER)
      OR NVL(C_REC.other_country_roaming_messages, cDUMMY_NUMBER) <>         NVL(pother_country_roaming_mes, cDUMMY_NUMBER)
      OR NVL(C_REC.other_country_roaming_internet, cDUMMY_NUMBER) <>         NVL(pother_country_roaming_int, cDUMMY_NUMBER)
      OR NVL(C_REC.national_roaming_calls, cDUMMY_NUMBER) <>         NVL(pnational_roaming_calls, cDUMMY_NUMBER)
      OR NVL(C_REC.national_roaming_messages, cDUMMY_NUMBER) <>         NVL(pnational_roaming_messages, cDUMMY_NUMBER)
      OR NVL(C_REC.national_roaming_internet, cDUMMY_NUMBER) <>         NVL(pnational_roaming_internet, cDUMMY_NUMBER)
      OR ((C_REC.TARIFF_CODE IS NULL)AND(pTARIFF_CODE IS NOT NULL))     
    THEN
      UPDATE DB_LOADER_BILLS
      SET DATE_BEGIN = pDATE_BEGIN,
        DATE_END = pDATE_END,
        BILL_SUM = pBILL_SUM,
        SUBSCRIBER_PAYMENT_MAIN = pSUBSCRIBER_PAYMENT_MAIN,
        SUBSCRIBER_PAYMENT_ADD = pSUBSCRIBER_PAYMENT_ADD,
        SINGLE_PAYMENTS = pSINGLE_PAYMENTS,
        CALLS_LOCAL_COST = pCALLS_LOCAL_COST,
        CALLS_OTHER_CITY_COST = pCALLS_OTHER_CITY_COST,
        CALLS_OTHER_COUNTRY_COST = pCALLS_OTHER_COUNTRY_COST,
        MESSAGES_COST = pMESSAGES_COST,
        INTERNET_COST = pINTERNET_COST,
        OTHER_COUNTRY_ROAMING_COST = pOTHER_COUNTRY_ROAMING_COST,
        NATIONAL_ROAMING_COST = pNATIONAL_ROAMING_COST,
        PENI_COST = pPENI_COST,
        DISCOUNT_VALUE = pDISCOUNT_VALUE,
        TARIFF_CODE = NVL(C_REC.TARIFF_CODE, pTARIFF_CODE),
        other_country_roaming_calls = pother_country_roaming_calls,
        other_country_roaming_messages = pother_country_roaming_mes,
        other_country_roaming_internet = pother_country_roaming_int,
        national_roaming_calls = pnational_roaming_calls,
        national_roaming_messages = pnational_roaming_messages,
        national_roaming_internet = pnational_roaming_internet       
      WHERE
        DB_LOADER_BILLS.ROWID = C_REC.ROWID;
    END IF;
  ELSE
    INSERT INTO DB_LOADER_BILLS (
      ACCOUNT_ID,
      YEAR_MONTH,
      PHONE_NUMBER,
      DATE_BEGIN,
      DATE_END,
      BILL_SUM,
      SUBSCRIBER_PAYMENT_MAIN,
      SUBSCRIBER_PAYMENT_ADD,
      SINGLE_PAYMENTS,
      CALLS_LOCAL_COST,
      CALLS_OTHER_CITY_COST,
      CALLS_OTHER_COUNTRY_COST,
      MESSAGES_COST,
      INTERNET_COST,
      OTHER_COUNTRY_ROAMING_COST,
      NATIONAL_ROAMING_COST,
      PENI_COST,
      DISCOUNT_VALUE,
      TARIFF_CODE,
      other_country_roaming_calls,
      other_country_roaming_messages,
      other_country_roaming_internet,
      national_roaming_calls,
      national_roaming_messages,
      national_roaming_internet
    ) VALUES (
      vACCOUNT_ID,
      vYEAR_MONTH,
      pPHONE_NUMBER,
      pDATE_BEGIN,
      pDATE_END,
      pBILL_SUM,
      pSUBSCRIBER_PAYMENT_MAIN,
      pSUBSCRIBER_PAYMENT_ADD,
      pSINGLE_PAYMENTS,
      pCALLS_LOCAL_COST,
      pCALLS_OTHER_CITY_COST,
      pCALLS_OTHER_COUNTRY_COST,
      pMESSAGES_COST,
      pINTERNET_COST,
      pOTHER_COUNTRY_ROAMING_COST,
      pNATIONAL_ROAMING_COST,
      pPENI_COST,
      pDISCOUNT_VALUE,
      pTARIFF_CODE,
      pother_country_roaming_calls,
      pother_country_roaming_mes,
      pother_country_roaming_int,
      pnational_roaming_calls,
      pnational_roaming_messages,
      pnational_roaming_internet
      );
  END IF;
  CLOSE C_FIND;
END;
--
--������������� ����������� �� ������ ������������� ��������
PROCEDURE SET_MN_UNLIM_VOLUME (
  pYEAR                     IN NUMBER,                    
  pMONTH                    IN NUMBER,
  pPHONE_NUMBER             IN VARCHAR2,
  pMnUnlimD                IN NUMBER,
  pMnUnlimT  IN NUMBER,
  pMnUnlimO   IN NUMBER
  ) IS
  vYEAR_MONTH BINARY_INTEGER;
  CURSOR C_FIND IS
    SELECT
      mv.ROWID,
      mv.*
    FROM MN_UNLIM_VOLUME mv
    WHERE mv.YEAR_MONTH=vYEAR_MONTH
          AND mv.PHONE_NUMBER=pPHONE_NUMBER;
  C_REC C_FIND%ROWTYPE;
  cDUMMY_NUMBER CONSTANT NUMBER := -1234456.25847;
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  OPEN C_FIND;
  FETCH C_FIND INTO C_REC;
  IF C_FIND%FOUND THEN
--    IF NVL(C_REC.MnUnlimD, cDUMMY_NUMBER) <> NVL(pMnUnlimD, cDUMMY_NUMBER)
--      OR NVL(C_REC.MnUnlimT, cDUMMY_NUMBER)<> NVL(pMnUnlimT, cDUMMY_NUMBER)
 --     OR NVL(C_REC.MnUnlimO, cDUMMY_NUMBER) <> NVL(pMnUnlimO, cDUMMY_NUMBER)
 --   THEN
      UPDATE MN_UNLIM_VOLUME mv
      SET MnUnlimD = pMnUnlimD,
        MnUnlimT = pMnUnlimT,
        MnUnlimO = pMnUnlimO    
      WHERE
        mv.ROWID = C_REC.ROWID;
  --  END IF;
  ELSE
    INSERT INTO MN_UNLIM_VOLUME (
      PHONE_NUMBER,
      YEAR_MONTH,
      MnUnlimD,
      MnUnlimT,
      MnUnlimO
    ) VALUES (
      pPHONE_NUMBER,
      vYEAR_MONTH,
      pMnUnlimD,
      pMnUnlimT,
      pMnUnlimO);
  END IF;
  CLOSE C_FIND;
END;

-- ������������� ����� �� ���� � ������� ������ (����� �������� ���������� ��� ������������ ������)
PROCEDURE SET_ACCOUNT_LOGON_PAUSE(
  pACCOUNT_NAME IN VARCHAR2, 
  pPAUSED_MINUTES IN INTEGER
  ) IS
BEGIN
  ACCOUNT_LOGON_PAUSE_PCKG.SET_ACCOUNT_LOGON_PAUSE(pACCOUNT_NAME, pPAUSED_MINUTES);
END;
--
-- ��������� ����� �� ���� � ������� ������ (����� �������� ���������� ��� ������������ ������)
FUNCTION IS_ACCOUNT_LOGON_PAUSED(
  pACCOUNT_NAME IN VARCHAR2
  ) RETURN INTEGER IS
BEGIN
  RETURN ACCOUNT_LOGON_PAUSE_PCKG.IS_ACCOUNT_LOGON_PAUSED(pACCOUNT_NAME);
END;
--
-- �������� �������� ���������
FUNCTION GET_CONSTANT_VALUE(
  pCONSTANT_NAME IN VARCHAR2
  ) RETURN VARCHAR2 IS
--
  CURSOR C IS
    SELECT VALUE 
      FROM CONSTANTS 
      WHERE NAME = pCONSTANT_NAME;
  S CONSTANTS.VALUE%TYPE;
BEGIN
  S := NULL;
  OPEN C;
  FETCH C INTO S;
  CLOSE C;
  RETURN S;
END;
--
--�������� ������ � �����������
PROCEDURE SET_REPORT_DATA(
  pPHONE_NUMBER IN VARCHAR2,
  pCURRENT_SUM IN NUMBER,
  pDATE_LAST_UPDATE IN VARCHAR2
  ) IS
--
vDATE_UPDATE DATE;    
CURSOR C IS
  SELECT DETAIL_SUM, ROWID, DATE_LAST_UPDATE, YEAR_MONTH, PHONE_NUMBER
    FROM DB_LOADER_REPORT_DATA 
    WHERE PHONE_NUMBER=pPHONE_NUMBER
    ORDER BY YEAR_MONTH DESC;
DUMMY C%ROWTYPE;    
BEGIN
  vDATE_UPDATE:=TO_DATE(pDATE_LAST_UPDATE,'DD.MM.YYYY-HH24:MI:SS');
  OPEN C;
  FETCH C INTO DUMMY;
  IF C%FOUND THEN 
    IF DUMMY.YEAR_MONTH=TO_NUMBER(TO_CHAR(vDATE_UPDATE, 'YYYYMM')) THEN
      UPDATE DB_LOADER_REPORT_DATA
        SET DETAIL_SUM=pCURRENT_SUM
        WHERE DB_LOADER_REPORT_DATA.YEAR_MONTH=DUMMY.YEAR_MONTH
          AND DB_LOADER_REPORT_DATA.PHONE_NUMBER=DUMMY.PHONE_NUMBER; 
    ELSE
            /*���������� �����*/
     /* IF (DUMMY.DETAIL_SUM<=pCURRENT_SUM)AND(DUMMY.DETAIL_SUM<>0) THEN
        UPDATE DB_LOADER_REPORT_DATA
          SET DETAIL_SUM=pCURRENT_SUM
          WHERE DB_LOADER_REPORT_DATA.YEAR_MONTH=DUMMY.YEAR_MONTH
            AND DB_LOADER_REPORT_DATA.PHONE_NUMBER=DUMMY.PHONE_NUMBER; 
      ELSE */
        INSERT INTO DB_LOADER_REPORT_DATA(YEAR_MONTH, PHONE_NUMBER, DETAIL_SUM, DATE_LAST_UPDATE)
          VALUES(TO_NUMBER(TO_CHAR(vDATE_UPDATE,'YYYYMM')), pPHONE_NUMBER, pCURRENT_SUM, vDATE_UPDATE);
      /*END IF;*/      
    END IF;
  ELSE
    INSERT INTO DB_LOADER_REPORT_DATA(YEAR_MONTH, PHONE_NUMBER, DETAIL_SUM, DATE_LAST_UPDATE)
      VALUES(TO_NUMBER(TO_CHAR(vDATE_UPDATE,'YYYYMM')), pPHONE_NUMBER, pCURRENT_SUM, vDATE_UPDATE);
  END IF; 
  CLOSE C; 
  COMMIT;
END;
--
--�������� ������ � �����������
PROCEDURE SET_FIELD_DETAILS(
  pFIELD_ID IN INTEGER,
  pFIELD_VALUE IN VARCHAR2
  ) IS
-- 
CURSOR C IS
  SELECT ROWID
    FROM FIELD_DETAILS 
    WHERE FIELD_DETAILS.FIELD_TYPE_ID=pFIELD_ID
      AND FIELD_DETAILS.FIELD_VALUE=pFIELD_VALUE;
vDUMMY C%ROWTYPE;   
BEGIN
  OPEN C;
  FETCH C INTO vDUMMY;
  IF C%NOTFOUND AND pFIELD_VALUE IS NOT NULL THEN
    INSERT INTO FIELD_DETAILS(FIELD_TYPE_ID, FIELD_VALUE)
      VALUES(pFIELD_ID, pFIELD_VALUE);
    COMMIT;
  END IF;  
END;
--
--��������� ��������� ������� �/�
PROCEDURE SAVE_BALANCE_CHANGE(
  pLOGIN IN VARCHAR2,
  pBALANCE IN VARCHAR2
  ) IS
  
 pAccount_id NUMBER;
 nBalance NUMBER;
 oldBalance NUMBER;
BEGIN
 IF (ms_constants.GET_CONSTANT_VALUE('SERVER_NAME')='CORP_MOBILE') THEN
   nBalance:=to_number(pBALANCE);
   pAccount_id:=FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);  

   --��������� ������ � ������� ���������� �� �/�
   UPDATE account_info SET balance = nBalance WHERE account_id = pAccount_id;
   IF SQL%NOTFOUND THEN 
     INSERT INTO account_info (account_id, Balance) VALUES (pAccount_id, nBalance);
   END IF; 

   -- �������� ���������� ������
   SELECT b.balance
   INTO oldBalance                  
   FROM balance_change b
   WHERE b.account_id = pAccount_id AND
         NVL(b.date_last_updated,b.date_created) = 
         (SELECT MAX(NVL(date_last_updated, date_created)) FROM balance_change
          WHERE account_id = b.account_id);
   IF nBalance >= oldBalance THEN
      --����������� ������ �� ���� � ���� � � ���������� ������� 
     UPDATE balance_change b SET balance = nBalance, date_last_updated = SYSDATE
     WHERE b.account_id = pAccount_id AND b.user_last_updated IS NOT NULL AND
           NVL(b.date_last_updated,b.date_created) = 
           (SELECT MAX(NVL(date_last_updated, date_created)) FROM balance_change
            WHERE account_id = b.account_id);
     IF SQL%NOTFOUND THEN 
       --����������� ������ �� ����, �� ���� � ���������� �������
       INSERT INTO balance_change (account_id, balance, date_created, user_last_updated) 
       VALUES (pAccount_id, nBalance, SYSDATE, 'loader');
     END IF; 
   ELSE
     --���� ����������� ������
     INSERT INTO balance_change (account_id, balance, date_created) 
     VALUES (pAccount_id, nBalance, SYSDATE);      
   END IF;
   COMMIT;
 END IF;  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --����������� �������� �� ������� �/� ��� �� ����
     INSERT INTO balance_change (account_id, balance, date_created, user_last_updated) 
     VALUES (pAccount_id, nBalance, SYSDATE, 'loader');
     COMMIT;
END;
--
FUNCTION GET_ACCOUNT_ID_BY_LOGIN(
  pLOGIN IN VARCHAR2
  ) RETURN INTEGER IS
  CURSOR C IS
    SELECT ACCOUNT_ID 
      FROM ACCOUNTS 
      WHERE LOGIN=pLOGIN 
        AND ROWNUM=1;
  vDUMMY C%ROWTYPE;  
  ITOG INTEGER;     
BEGIN  
  ITOG:=0;
  OPEN C;
  FETCH C INTO vDUMMY;
  IF C%FOUND THEN
    ITOG:=vDUMMY.ACCOUNT_ID;
  END IF; 
  CLOSE C;
  RETURN ITOG;   
END;
-- ��������, �������� �� ����
FUNCTION CHECK_BILL_DETAILS(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pABONKA IN NUMBER,
  pCALLS IN NUMBER,
  pSINGLE_PAYMENTS IN NUMBER,
  pDISCOUNTS IN NUMBER,
  pBILL_SUM IN NUMBER
  ) RETURN INTEGER IS
--
  vACCOUNT_ID INTEGER;
  CURSOR C(pACCOUNT_ID IN INTEGER) IS 
    SELECT * 
      FROM DB_LOADER_FULL_FINANCE_BILL FB
      WHERE FB.ACCOUNT_ID=pACCOUNT_ID
        AND FB.YEAR_MONTH=pYEAR_MONTH 
        AND FB.PHONE_NUMBER=pPHONE_NUMBER 
        AND FB.ABONKA=pABONKA 
        AND FB.CALLS=pCALLS  
        AND FB.SINGLE_PAYMENTS=pSINGLE_PAYMENTS 
        AND FB.DISCOUNTS=pDISCOUNTS 
        AND FB.BILL_SUM=pBILL_SUM 
        AND FB.COMPLETE_BILL=1;
  ITOG INTEGER;
  vDUMMY C%ROWTYPE;
BEGIN
  vACCOUNT_ID:=GET_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  ITOG:=0;
  OPEN C(vACCOUNT_ID);
  FETCH C INTO vDUMMY;
  IF C%FOUND THEN
    ITOG:=1;
  END IF; 
  CLOSE C;
  RETURN ITOG;  
END;
-- ��������, ���� �� ���� �� ���� � ��
FUNCTION CHECK_BILL_DETAILS_ADD(
  pACCOUNT_ID IN INTEGER,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2
  ) RETURN INTEGER IS
--
  CURSOR C IS 
    SELECT * 
      FROM DB_LOADER_FULL_FINANCE_BILL FB
      WHERE FB.ACCOUNT_ID=pACCOUNT_ID
        AND FB.YEAR_MONTH=pYEAR_MONTH 
        AND FB.PHONE_NUMBER=pPHONE_NUMBER;
  ITOG INTEGER;
  vDUMMY C%ROWTYPE;
BEGIN
  ITOG:=0;
  OPEN C;
  FETCH C INTO vDUMMY;
  IF C%FOUND THEN
    ITOG:=1;
  END IF; 
  CLOSE C;
  RETURN ITOG;  
END;
-- ������� ������� ��������� �� �����
PROCEDURE CLEAR_BILL_DETAIL_ABON_PERIOD(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2
  ) IS
--
  vACCOUNT_ID INTEGER;
BEGIN
  vACCOUNT_ID:=GET_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  DELETE DB_LOADER_FULL_BILL_ABON_PER FBAP
    WHERE FBAP.ACCOUNT_ID=vACCOUNT_ID
      AND FBAP.YEAR_MONTH=pYEAR_MONTH
      AND FBAP.PHONE_NUMBER=pPHONE_NUMBER;
  COMMIT;    
END;
-- �������� ������ ��������� �� �����
PROCEDURE ADD_BILL_DETAIL_ABON_PERIOD(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pDATE_BEGIN IN VARCHAR2,
  pDATE_END IN VARCHAR2,
  pTARIFF_CODE IN VARCHAR2,
  pABON_MAIN IN NUMBER,
  pABON_ADD IN NUMBER,
  pABON_ALL IN NUMBER
  ) IS
--
  vACCOUNT_ID INTEGER;
  vDATE_BEGIN DATE;
  vDATE_END DATE;
  vTARIFF_CODE VARCHAR2(15 CHAR);
BEGIN
  vACCOUNT_ID:=GET_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  vDATE_BEGIN:=TO_DATE(pDATE_BEGIN, 'DD/MM/YYYY');
  vDATE_END:=TO_DATE(pDATE_END, 'DD/MM/YYYY');
  IF pTARIFF_CODE='null' THEN
    vTARIFF_CODE:=NULL;
  ELSE
    vTARIFF_CODE:=pTARIFF_CODE;
  END IF;
  INSERT INTO DB_LOADER_FULL_BILL_ABON_PER(ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, 
                                           DATE_BEGIN, DATE_END, TARIFF_CODE, 
                                           ABON_MAIN, ABON_ADD, ABON_ALL)
    VALUES(vACCOUNT_ID, pYEAR_MONTH, pPHONE_NUMBER, 
           vDATE_BEGIN, vDATE_END, vTARIFF_CODE, 
           pABON_MAIN, pABON_ADD, pABON_ALL);                                   
  COMMIT;
END;
-- ������� ������� ��� �������� �� �����
PROCEDURE CLEAR_BILL_DETAIL_MG_ROUMING(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2
  ) IS
--
  vACCOUNT_ID INTEGER;
BEGIN
  vACCOUNT_ID:=GET_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  DELETE DB_LOADER_FULL_BILL_MG_ROUMING FBR
    WHERE FBR.ACCOUNT_ID=vACCOUNT_ID
      AND FBR.YEAR_MONTH=pYEAR_MONTH
      AND FBR.PHONE_NUMBER=pPHONE_NUMBER;
  COMMIT;    
END;
-- �������� ������ ��� �������� �� �����
PROCEDURE ADD_BILL_DETAIL_MG_ROUMING(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pDATE_BEGIN IN VARCHAR2,
  pDATE_END IN VARCHAR2,
  pROUMING_COUNTRY IN VARCHAR2,
  pROUMING_CALLS IN NUMBER,
  pROUMING_GPRS IN NUMBER,
  pROUMING_SMS IN NUMBER,
  pCOMPANY_TAX IN NUMBER,
  pROUMING_SUM IN NUMBER
  ) IS
--
  vACCOUNT_ID INTEGER;
  vDATE_BEGIN DATE;
  vDATE_END DATE;
BEGIN
  vACCOUNT_ID:=GET_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  vDATE_BEGIN:=TO_DATE(pDATE_BEGIN, 'DD/MM/YYYY');
  vDATE_END:=TO_DATE(pDATE_END, 'DD/MM/YYYY');
  INSERT INTO DB_LOADER_FULL_BILL_MG_ROUMING(ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, 
                                             DATE_BEGIN, DATE_END, ROUMING_COUNTRY, ROUMING_CALLS, 
                                             ROUMING_GPRS, ROUMING_SMS, COMPANY_TAX, ROUMING_SUM)
    VALUES(vACCOUNT_ID, pYEAR_MONTH, pPHONE_NUMBER, 
           vDATE_BEGIN, vDATE_END, pROUMING_COUNTRY, pROUMING_CALLS,
           pROUMING_GPRS, pROUMING_SMS, pCOMPANY_TAX, pROUMING_SUM);                                   
  COMMIT;
END;
-- ������� ������� �/� �������� �� �����
PROCEDURE CLEAR_BILL_DETAIL_MN_ROUMING(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2
  ) IS
--
  vACCOUNT_ID INTEGER;
BEGIN
  vACCOUNT_ID:=GET_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  DELETE DB_LOADER_FULL_BILL_MN_ROUMING FBR
    WHERE FBR.ACCOUNT_ID=vACCOUNT_ID
      AND FBR.YEAR_MONTH=pYEAR_MONTH
      AND FBR.PHONE_NUMBER=pPHONE_NUMBER;
  COMMIT;    
END;
-- �������� ������ �/� �������� �� �����
PROCEDURE ADD_BILL_DETAIL_MN_ROUMING(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pDATE_BEGIN IN VARCHAR2,
  pDATE_END IN VARCHAR2,
  pROUMING_COUNTRY IN VARCHAR2,
  pROUMING_CALLS IN NUMBER,
  pROUMING_GPRS IN NUMBER,
  pROUMING_SMS IN NUMBER,
  pCOMPANY_TAX IN NUMBER,
  pROUMING_SUM IN NUMBER
  ) IS
--
  vACCOUNT_ID INTEGER;
  vDATE_BEGIN DATE;
  vDATE_END DATE;
BEGIN
  vACCOUNT_ID:=GET_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  vDATE_BEGIN:=TO_DATE(pDATE_BEGIN, 'DD/MM/YYYY');
  vDATE_END:=TO_DATE(pDATE_END, 'DD/MM/YYYY');
  INSERT INTO DB_LOADER_FULL_BILL_MN_ROUMING(ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, 
                                             DATE_BEGIN, DATE_END, ROUMING_COUNTRY, ROUMING_CALLS, 
                                             ROUMING_GPRS, ROUMING_SMS, COMPANY_TAX, ROUMING_SUM)
    VALUES(vACCOUNT_ID, pYEAR_MONTH, pPHONE_NUMBER, 
           vDATE_BEGIN, vDATE_END, pROUMING_COUNTRY, pROUMING_CALLS,
           pROUMING_GPRS, pROUMING_SMS, pCOMPANY_TAX, pROUMING_SUM);                                   
  COMMIT;
END;
-- �������� ����
PROCEDURE ADD_BILL_DETAILS(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pABONKA IN NUMBER,
  pCALLS IN NUMBER,
  pSINGLE_PAYMENTS IN NUMBER,
  pDISCOUNTS IN NUMBER,
  pBILL_SUM IN NUMBER,
  pCOMPLETE_BILL IN INTEGER
  ) IS
--
  vACCOUNT_ID INTEGER;
  vCHECK_ADD INTEGER;
BEGIN
  vACCOUNT_ID:=GET_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  vCHECK_ADD:=CHECK_BILL_DETAILS_ADD(vACCOUNT_ID, pYEAR_MONTH, pPHONE_NUMBER);
  IF vCHECK_ADD=0 THEN
    INSERT INTO DB_LOADER_FULL_FINANCE_BILL(ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, ABONKA, CALLS, SINGLE_PAYMENTS, DISCOUNTS, BILL_SUM, COMPLETE_BILL, 
                                            ABON_MAIN, ABON_ADD, ABON_OTHER, 
                                            SINGLE_MAIN, SINGLE_ADD, SINGLE_PENALTI, SINGLE_CHANGE_TARIFF, 
                                            SINGLE_TURN_ON_SERV, SINGLE_CORRECTION_ROUMING, 
                                            SINGLE_INTRA_WEB, SINGLE_VIEW_BLACK_LIST, SINGLE_OTHER, 
                                            DISCOUNT_YEAR, DISCOUNT_SMS_PLUS, DISCOUNT_CALL, DISCOUNT_COUNT_ON_PHONES, DISCOUNT_OTHERS, 
                                            CALLS_COUNTRY, CALLS_SITY, CALLS_LOCAL, CALLS_SMS_MMS, CALLS_GPRS, CALLS_RUS_RPP, CALLS_ALL,
                                            ROUMING_NATIONAL, ROUMING_INTERNATIONAL)
      VALUES(vACCOUNT_ID, pYEAR_MONTH, pPHONE_NUMBER, pABONKA, pCALLS, pSINGLE_PAYMENTS, pDISCOUNTS, pBILL_SUM, pCOMPLETE_BILL,
             0, 0, 0, 
             0, 0, 0, 0, 
             0, 0, 
             0, 0, 0,
             0, 0, 0, 0, 0, 
             0, 0, 0, 0, 0, 0, 0,
             0, 0);   
  ELSE
    UPDATE DB_LOADER_FULL_FINANCE_BILL FB
      SET FB.ABONKA=pABONKA, FB.CALLS=pCALLS, FB.SINGLE_PAYMENTS=pSINGLE_PAYMENTS, FB.DISCOUNTS=pDISCOUNTS, FB.BILL_SUM=pBILL_SUM, FB.COMPLETE_BILL=pCOMPLETE_BILL, 
          FB.ABON_MAIN=0, FB.ABON_ADD=0, FB.ABON_OTHER=0, 
          FB.SINGLE_MAIN=0, FB.SINGLE_ADD=0, FB.SINGLE_PENALTI=0, FB.SINGLE_CHANGE_TARIFF=0, 
          FB.SINGLE_TURN_ON_SERV=0, FB.SINGLE_CORRECTION_ROUMING=0, 
          FB.SINGLE_INTRA_WEB=0, FB.SINGLE_VIEW_BLACK_LIST=0, FB.SINGLE_OTHER=0, 
          FB.DISCOUNT_YEAR=0, FB.DISCOUNT_SMS_PLUS=0, FB.DISCOUNT_CALL=0, FB.DISCOUNT_COUNT_ON_PHONES=0, FB.DISCOUNT_OTHERS=0, 
          FB.CALLS_COUNTRY=0, FB.CALLS_SITY=0, FB.CALLS_LOCAL=0, FB.CALLS_SMS_MMS=0, FB.CALLS_GPRS=0, FB.CALLS_RUS_RPP=0, FB.CALLS_ALL=0,
          FB.ROUMING_NATIONAL=0, FB.ROUMING_INTERNATIONAL=0
      WHERE FB.ACCOUNT_ID=vACCOUNT_ID AND FB.YEAR_MONTH=pYEAR_MONTH AND FB.PHONE_NUMBER=pPHONE_NUMBER;
  END IF;                                           
  COMMIT;
END;
-- ��������� ���� � ��������
PROCEDURE COMMIT_BILL_DETAILS(
  pLOGIN IN VARCHAR2,
  pYEAR_MONTH IN INTEGER,
  pPHONE_NUMBER IN VARCHAR2,
  pABONKA IN NUMBER,
  pCALLS IN NUMBER,
  pSINGLE_PAYMENTS IN NUMBER,
  pDISCOUNTS IN NUMBER,
  pBILL_SUM IN NUMBER,
  pCOMPLETE_BILL IN INTEGER,
  pABON_MAIN IN NUMBER,
  pABON_ADD IN NUMBER,
  pABON_OTHER IN NUMBER,
  pSINGLE_MAIN IN NUMBER,
  pSINGLE_ADD IN NUMBER, 
  pSINGLE_PENALTI IN NUMBER, 
  pSINGLE_CHANGE_TARIFF IN NUMBER, 
  pSINGLE_TURN_ON_SERV IN NUMBER,
  pSINGLE_CORRECTION_ROUMING IN NUMBER,
  pSINGLE_INTRA_WEB IN NUMBER,
  pSINGLE_VIEW_BLACK_LIST IN NUMBER,
  pSINGLE_OTHER IN NUMBER, 
  pDISCOUNT_YEAR IN NUMBER, 
  pDISCOUNT_SMS_PLUS IN NUMBER, 
  pDISCOUNT_CALL IN NUMBER, 
  pDISCOUNT_COUNT_ON_PHONES IN NUMBER,
  pDISCOUNT_SOVINTEL IN NUMBER,
  pDISCOUNT_OTHERS IN NUMBER, 
  pCALLS_COUNTRY IN NUMBER, 
  pCALLS_SITY IN NUMBER, 
  pCALLS_LOCAL IN NUMBER, 
  pCALLS_SMS_MMS IN NUMBER, 
  pCALLS_GPRS IN NUMBER, 
  pCALLS_RUS_RPP IN NUMBER, 
  pCALLS_ALL IN NUMBER,
  pROUMING_NATIONAL IN NUMBER,
  pROUMING_INTERNATIONAL IN NUMBER
  ) IS
--
  vACCOUNT_ID INTEGER;
  vCHECK_ADD INTEGER;
BEGIN
  vACCOUNT_ID:=GET_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  vCHECK_ADD:=CHECK_BILL_DETAILS_ADD(vACCOUNT_ID, pYEAR_MONTH, pPHONE_NUMBER);
  IF vCHECK_ADD=0 THEN  
  INSERT INTO DB_LOADER_FULL_FINANCE_BILL(ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, ABONKA, CALLS, SINGLE_PAYMENTS, DISCOUNTS, BILL_SUM, COMPLETE_BILL, 
                                          ABON_MAIN, ABON_ADD, ABON_OTHER, 
                                          SINGLE_MAIN, SINGLE_ADD, SINGLE_PENALTI, SINGLE_CHANGE_TARIFF, 
                                          SINGLE_TURN_ON_SERV, SINGLE_CORRECTION_ROUMING, 
                                          SINGLE_INTRA_WEB, SINGLE_VIEW_BLACK_LIST, SINGLE_OTHER, 
                                          DISCOUNT_YEAR, DISCOUNT_SMS_PLUS, DISCOUNT_CALL, 
                                          DISCOUNT_COUNT_ON_PHONES, DISCOUNT_OTHERS, DISCOUNT_SOVINTEL,
                                          CALLS_COUNTRY, CALLS_SITY, CALLS_LOCAL, 
                                          CALLS_SMS_MMS, CALLS_GPRS, CALLS_RUS_RPP, CALLS_ALL,
                                          ROUMING_NATIONAL, ROUMING_INTERNATIONAL)
    VALUES(vACCOUNT_ID, pYEAR_MONTH, pPHONE_NUMBER, pABONKA, pCALLS, pSINGLE_PAYMENTS, pDISCOUNTS, pBILL_SUM, pCOMPLETE_BILL,
           pABON_MAIN, pABON_ADD, pABON_OTHER, 
           pSINGLE_MAIN, pSINGLE_ADD, pSINGLE_PENALTI, pSINGLE_CHANGE_TARIFF, 
           pSINGLE_TURN_ON_SERV, pSINGLE_CORRECTION_ROUMING, 
           pSINGLE_INTRA_WEB, pSINGLE_VIEW_BLACK_LIST, pSINGLE_OTHER, 
           pDISCOUNT_YEAR, pDISCOUNT_SMS_PLUS, pDISCOUNT_CALL, 
           pDISCOUNT_COUNT_ON_PHONES, pDISCOUNT_OTHERS, pDISCOUNT_SOVINTEL,
           pCALLS_COUNTRY, pCALLS_SITY, pCALLS_LOCAL, 
           pCALLS_SMS_MMS, pCALLS_GPRS, pCALLS_RUS_RPP, pCALLS_ALL,
           pROUMING_NATIONAL, pROUMING_INTERNATIONAL);      
  ELSE
    UPDATE DB_LOADER_FULL_FINANCE_BILL FB
      SET FB.ABONKA=pABONKA, FB.CALLS=pCALLS, FB.SINGLE_PAYMENTS=pSINGLE_PAYMENTS, FB.DISCOUNTS=pDISCOUNTS, FB.BILL_SUM=pBILL_SUM, FB.COMPLETE_BILL=pCOMPLETE_BILL, 
          FB.ABON_MAIN=pABON_MAIN, FB.ABON_ADD=pABON_ADD, FB.ABON_OTHER=pABON_OTHER, 
          FB.SINGLE_MAIN=pSINGLE_MAIN, FB.SINGLE_ADD=pSINGLE_ADD, FB.SINGLE_PENALTI=pSINGLE_PENALTI, FB.SINGLE_CHANGE_TARIFF=pSINGLE_CHANGE_TARIFF, 
          FB.SINGLE_TURN_ON_SERV=pSINGLE_TURN_ON_SERV, FB.SINGLE_CORRECTION_ROUMING=pSINGLE_CORRECTION_ROUMING, 
          FB.SINGLE_INTRA_WEB=pSINGLE_INTRA_WEB, FB.SINGLE_VIEW_BLACK_LIST=pSINGLE_VIEW_BLACK_LIST, FB.SINGLE_OTHER=pSINGLE_OTHER, 
          FB.DISCOUNT_YEAR=pDISCOUNT_YEAR, FB.DISCOUNT_SMS_PLUS=pDISCOUNT_SMS_PLUS, FB.DISCOUNT_CALL=pDISCOUNT_CALL, 
          FB.DISCOUNT_COUNT_ON_PHONES=pDISCOUNT_COUNT_ON_PHONES, FB.DISCOUNT_OTHERS=pDISCOUNT_OTHERS, FB.DISCOUNT_SOVINTEL=pDISCOUNT_SOVINTEL,
          FB.CALLS_COUNTRY=pCALLS_COUNTRY, FB.CALLS_SITY=pCALLS_SITY, FB.CALLS_LOCAL=pCALLS_LOCAL, 
          FB.CALLS_SMS_MMS=pCALLS_SMS_MMS, FB.CALLS_GPRS=pCALLS_GPRS, FB.CALLS_RUS_RPP=pCALLS_RUS_RPP, FB.CALLS_ALL=pCALLS_ALL,
          FB.ROUMING_NATIONAL=pROUMING_NATIONAL, FB.ROUMING_INTERNATIONAL=pROUMING_INTERNATIONAL
      WHERE FB.ACCOUNT_ID=vACCOUNT_ID AND FB.YEAR_MONTH=pYEAR_MONTH AND FB.PHONE_NUMBER=pPHONE_NUMBER;
  END IF;                                        
  COMMIT;

-- �������� �������� �� CHECK_INCORRECT_FINANCE_BILLS

  UPDATE DB_LOADER_FULL_FINANCE_BILL FB
    SET FB.COMPLETE_BILL = 0
    WHERE FB.COMPLETE_BILL = 1
      AND (FB.ACCOUNT_ID, FB.YEAR_MONTH, FB.PHONE_NUMBER) IN
            (SELECT V.ACCOUNT_ID, 
                    V.YEAR_MONTH, 
                    V.PHONE_NUMBER
               FROM V_BILL_FULL_FINANCE_INCORRECT V WHERE            
               V.ACCOUNT_ID = vACCOUNT_ID 
               AND V.YEAR_MONTH = pYEAR_MONTH 
               AND V.PHONE_NUMBER = pPHONE_NUMBER)
     AND FB.ACCOUNT_ID=vACCOUNT_ID 
     AND FB.YEAR_MONTH=pYEAR_MONTH 
     AND FB.PHONE_NUMBER=pPHONE_NUMBER;
  UPDATE DB_LOADER_FULL_FINANCE_BILL FB
    SET FB.COMPLETE_BILL = 0
    WHERE FB.COMPLETE_BILL = 1
      AND (FB.ACCOUNT_ID, FB.YEAR_MONTH, FB.PHONE_NUMBER) IN
            (SELECT V.ACCOUNT_ID, 
                    V.YEAR_MONTH, 
                    V.PHONE_NUMBER
               FROM V_BILL_FULL_ABON_PER_INCORRECT V WHERE            
               V.ACCOUNT_ID = vACCOUNT_ID 
               AND V.YEAR_MONTH = pYEAR_MONTH 
               AND V.PHONE_NUMBER = pPHONE_NUMBER)
     AND FB.ACCOUNT_ID=vACCOUNT_ID 
     AND FB.YEAR_MONTH=pYEAR_MONTH 
     AND FB.PHONE_NUMBER=pPHONE_NUMBER;

  COMMIT;


END;
--
PROCEDURE ADD_ACCOUNT_PHONE_OPTION2(
  pYEAR IN NUMBER,
  pMONTH IN NUMBER,
  pLOGIN IN VARCHAR2,
  pPHONE_NUMBER IN VARCHAR2,
  pOPTION_CODE IN VARCHAR2,       /* ��� ����� */
  pOPTION_NAME IN VARCHAR2,       /* ������������ ����� */
  pOPTION_PARAMETERS IN VARCHAR2, /* ��������� ����� */
  pTURN_ON_DATE IN DATE,          /* ���� �����������*/
  pTURN_OFF_DATE IN DATE,         /* ���� ����������� */
  pTURN_ON_COST IN NUMBER,        /* ��������� ����������� */
  pMONTHLY_PRICE IN NUMBER        /* ��������� � ����� */
  ) IS
--
  vYEAR_MONTH BINARY_INTEGER;
  vACCOUNT_ID NUMBER;
  CURSOR C_FIND IS
    SELECT 
      DB_LOADER_ACCOUNT_PHONE_OPTS.ROWID,
      DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_OFF_DATE,
      DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_COST,
      DB_LOADER_ACCOUNT_PHONE_OPTS.MONTHLY_PRICE
    FROM DB_LOADER_ACCOUNT_PHONE_OPTS
    WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.ACCOUNT_ID=vACCOUNT_ID
    AND DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH=vYEAR_MONTH
    AND DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER = pPHONE_NUMBER
    AND DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE = pOPTION_CODE
    AND DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE = pTURN_ON_DATE;
  vREC C_FIND%ROWTYPE;
  CHECKrec BOOLEAN;
  MY_COUNT INTEGER;
BEGIN
  vYEAR_MONTH := pYEAR*100+pMONTH;
  vACCOUNT_ID := FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);
  --
  OPEN C_FIND;
  FETCH C_FIND INTO vREC;
  IF C_FIND%FOUND THEN
    IF (vREC.TURN_OFF_DATE IS NULL AND pTURN_OFF_DATE IS NOT NULL)
      OR (vREC.TURN_OFF_DATE IS NOT NULL AND pTURN_OFF_DATE IS NULL)
      OR (vREC.TURN_OFF_DATE <> pTURN_OFF_DATE)
      OR (NVL(vREC.TURN_ON_COST, -1) <> NVL(pTURN_ON_COST, -1))
      OR (NVL(vREC.MONTHLY_PRICE, -1) <> NVL(pMONTHLY_PRICE, -1))
       THEN
      UPDATE DB_LOADER_ACCOUNT_PHONE_OPTS
      SET TURN_OFF_DATE = pTURN_OFF_DATE,
        TURN_ON_COST = pTURN_ON_COST,
        MONTHLY_PRICE = pMONTHLY_PRICE,
        LAST_CHECK_DATE_TIME = SYSDATE
      WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.ROWID=vREC.ROWID;
    ELSE 
      UPDATE DB_LOADER_ACCOUNT_PHONE_OPTS 
      SET LAST_CHECK_DATE_TIME = SYSDATE
      WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.ROWID=vREC.ROWID;
    END IF;
  ELSE
    --�������� �� ���������� ������
    CHECKrec:=TRUE;
    SELECT COUNT(*)
      INTO MY_COUNT
      FROM DB_LOADER_ACCOUNT_PHONE_OPTS
      WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH=TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM'))
        AND DB_LOADER_ACCOUNT_PHONE_OPTS.ACCOUNT_ID=vACCOUNT_ID
        and rownum=1;
    --���� ������ ���������� ����� � ���� �������� �� ��������� �����    
    IF SYSDATE-pTURN_ON_DATE>60 
        AND ((vACCOUNT_ID <> 90) AND (TO_CHAR(SYSDATE, 'YYYYMM') = '201302'))         
        AND MY_COUNT>0 THEN
      SELECT COUNT(*)
        INTO MY_COUNT
        FROM DB_LOADER_ACCOUNT_PHONE_OPTS
        WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH=TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM'))
          AND DB_LOADER_ACCOUNT_PHONE_OPTS.ACCOUNT_ID=vACCOUNT_ID
          AND DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER = pPHONE_NUMBER
          AND DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE = pOPTION_CODE
          AND DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE = pTURN_ON_DATE
          and rownum=1; 
      --� ���� ��� ������ �� ��������� ����� � ����� �� ����� �����������, ������ ������ ��������.
      IF MY_COUNT=0 THEN
        null;
        --CHECKrec:=FALSE;                 
      END IF;  
    END IF;
    IF CHECKrec THEN
      INSERT INTO DB_LOADER_ACCOUNT_PHONE_OPTS (
        ACCOUNT_ID,
        YEAR_MONTH,
        PHONE_NUMBER,
        OPTION_CODE,
        OPTION_NAME,
        OPTION_PARAMETERS,
        TURN_ON_DATE,
        TURN_OFF_DATE,
        TURN_ON_COST,
        MONTHLY_PRICE,
        LAST_CHECK_DATE_TIME
      ) VALUES (
        vACCOUNT_ID,
        vYEAR_MONTH,
        pPHONE_NUMBER,
        pOPTION_CODE,
        pOPTION_NAME,
        pOPTION_PARAMETERS,
        pTURN_ON_DATE,
        pTURN_OFF_DATE,
        pTURN_ON_COST,
        pMONTHLY_PRICE,
        SYSDATE
        );
    END IF;  
  END IF;
  CLOSE C_FIND;
END;
--
--��������� ���-�� ������� ��������� �/�
PROCEDURE SAVE_COUNT_PHONE(
  pLOGIN IN VARCHAR2,
  pCountPhone IN NUMBER
  ) IS
 pAccount_id NUMBER;
BEGIN
 IF (ms_constants.GET_CONSTANT_VALUE('SERVER_NAME')='CORP_MOBILE') THEN
   pAccount_id:=FIND_ACCOUNT_ID_BY_LOGIN(pLOGIN);  
   UPDATE account_info SET count_phone = pCountPhone WHERE account_id = pAccount_id;
   IF SQL%NOTFOUND THEN 
     INSERT INTO account_info (account_id, count_phone) VALUES (pAccount_id, pCountPhone);
   END IF; 
   COMMIT;
 END IF;  
END;
--
END; 
/
