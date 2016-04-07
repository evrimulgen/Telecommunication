GRANT CREATE TYPE TO CORP_MOBILE_LK;

GRANT SELECT ON TARIFF_OPTION_COSTS TO CORP_MOBILE_LK;
GRANT SELECT ON TARIFF_OPTIONS TO CORP_MOBILE_LK;
GRANT SELECT ON TARIFF_OPTION_NEW_COST TO CORP_MOBILE_LK;
GRANT SELECT ON DB_LOADER_ACCOUNT_PHONE_OPTS TO CORP_MOBILE_LK;

CREATE OR REPLACE TYPE CORP_MOBILE_LK.TURNED_OPTION_TYPE AS OBJECT
(
  TARIFF_OPTION_ID INTEGER,
  NAME VARCHAR2(100 CHAR),
  TURN_ON_DATE DATE,
  TURN_OFF_DATE DATE,
  CAN_BE_TURNED_BY_ABONENT INTEGER,
  MONTHLY_COST NUMBER(15, 2)
);

CREATE OR REPLACE TYPE CORP_MOBILE_LK.TURNED_OPTION_TAB AS TABLE OF TURNED_OPTION_TYPE
/

CREATE OR REPLACE FUNCTION CORP_MOBILE_LK.TURNED_OPTIONS(
  pUSER_ID IN INTEGER
  ) RETURN TURNED_OPTION_TAB PIPELINED AS
--#Version=2
--
-- 1. ������. 
-- 2. ������. �������� ���������� ��� ����������� �����
-- 3. ������. �� ��������� ������������ ����� ��������� ��� ������� � ��������������.
--
CURSOR C_OPTIONS IS
SELECT 
  TARIFF_OPTIONS.TARIFF_OPTION_ID,
  TARIFF_OPTION_COSTS.TARIFF_OPTION_COST_ID,
  NVL(TARIFF_OPTIONS.OPTION_NAME_FOR_AB, TARIFF_OPTIONS.OPTION_NAME) OPTION_NAME,
  OPTS.TURN_ON_DATE,
  OPTS.TURN_OFF_DATE,
  TARIFF_OPTION_COSTS.TURN_ON_COST,
  TARIFF_OPTION_COSTS.MONTHLY_COST,
  CASE 
    WHEN OPTS.TURN_OFF_DATE IS NULL THEN
      NVL(TARIFF_OPTIONS.CAN_BE_TURNED_BY_ABONENT, 0) 
    ELSE
      0 -- ��� ����������� ������ ��������� ��������
  END as CAN_BE_TURNED_BY_ABONENT
FROM 
  CORP_MOBILE.CONTRACTS C, 
  CORP_MOBILE.CONTRACT_CANCELS CCS,
  CORP_MOBILE.DB_LOADER_ACCOUNT_PHONE_OPTS OPTS,
  CORP_MOBILE.TARIFF_OPTIONS,
  CORP_MOBILE.TARIFFS,
  CORP_MOBILE.TARIFF_OPTION_COSTS
WHERE C.CONTRACT_ID=pUSER_ID
  AND C.CONTRACT_ID = CCS.CONTRACT_ID(+) 
  AND CCS.CONTRACT_CANCEL_DATE IS NULL
  AND TARIFFS.TARIFF_ID=C.CURR_TARIFF_ID
  AND OPTS.PHONE_NUMBER=C.PHONE_NUMBER_FEDERAL
  AND OPTS.YEAR_MONTH = (SELECT MAX(OPTS2.YEAR_MONTH) 
                        FROM CORP_MOBILE.DB_LOADER_ACCOUNT_PHONE_OPTS OPTS2
                        WHERE OPTS2.PHONE_NUMBER=C.PHONE_NUMBER_FEDERAL)
  AND TARIFF_OPTIONS.OPTION_CODE=OPTS.OPTION_CODE
  AND (TARIFF_OPTIONS.OPTION_NAME_FOR_AB IS NULL 
    OR (TARIFF_OPTIONS.OPTION_NAME_FOR_AB <> '-'
      AND UPPER(TARIFF_OPTIONS.OPTION_NAME_FOR_AB) <> '������'
      )
    )
  AND TARIFF_OPTIONS.TARIFF_OPTION_ID = TARIFF_OPTION_COSTS.TARIFF_OPTION_ID(+)
  AND TARIFF_OPTION_COSTS.BEGIN_DATE(+)<=TRUNC(SYSDATE)
  AND TARIFF_OPTION_COSTS.END_DATE(+)>=TRUNC(SYSDATE)
  -- �� ���������� ����� ������������� �� ������ �������������!
  AND (NVL(TARIFFS.IS_AUTO_INTERNET, 0) <> 1 OR NVL(TARIFF_OPTIONS.IS_AUTO_INTERNET, 0) <> 1)
ORDER BY
  OPTS.TURN_ON_DATE,
  NVL(TARIFF_OPTIONS.OPTION_NAME_FOR_AB, TARIFF_OPTIONS.OPTION_NAME);
--
CURSOR C_OPTIONS_2(pTARIFF_ID INTEGER, pTARIFF_OPTION_COST_ID INTEGER) IS
SELECT 
  TARIFF_OPTION_NEW_COST.TURN_ON_COST,
  TARIFF_OPTION_NEW_COST.MONTHLY_COST
FROM 
  CORP_MOBILE.TARIFF_OPTION_NEW_COST 
WHERE TARIFF_OPTION_NEW_COST.TARIFF_OPTION_COST_ID=pTARIFF_OPTION_COST_ID
  AND TARIFF_OPTION_NEW_COST.TARIFF_ID=pTARIFF_ID;
--
  vTARIFF_ID INTEGER;
  vTURN_ON_COST CORP_MOBILE.TARIFF_OPTION_NEW_COST.TURN_ON_COST%TYPE;
  vMONTHLY_COST CORP_MOBILE.TARIFF_OPTION_NEW_COST.MONTHLY_COST%TYPE;
--
BEGIN
  SELECT LK_USERS.TARIFF_ID
    INTO vTARIFF_ID
    FROM LK_USERS
    WHERE LK_USERS.ID=pUSER_ID;
  FOR vREC IN C_OPTIONS LOOP
    OPEN C_OPTIONS_2(vTARIFF_ID, vREC.TARIFF_OPTION_COST_ID);
    FETCH C_OPTIONS_2 INTO vTURN_ON_COST, vMONTHLY_COST;
    IF C_OPTIONS_2%FOUND THEN
      vREC.TURN_ON_COST := vTURN_ON_COST;
      vREC.MONTHLY_COST := vMONTHLY_COST;
    END IF;
    CLOSE C_OPTIONS_2;
    PIPE ROW(
      TURNED_OPTION_TYPE(
        vREC.TARIFF_OPTION_ID,
        vREC.OPTION_NAME,
        vREC.TURN_ON_DATE,
        vREC.TURN_OFF_DATE,
        vREC.CAN_BE_TURNED_BY_ABONENT,
        vREC.MONTHLY_COST
        )
      );
  END LOOP;
END;
/

-- select * from table(CORP_MOBILE_LK.TURNED_OPTIONS(31688))
-- select * from table(CORP_MOBILE_LK.TURNED_OPTIONS(134037))