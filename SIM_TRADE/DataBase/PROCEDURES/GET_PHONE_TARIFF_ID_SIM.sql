--#IF GETVERSION("GET_PHONE_TARIFF_ID") < 4 THEN
CREATE OR REPLACE FUNCTION SIM_TRADE.GET_PHONE_TARIFF_ID(
  pPHONE_NUMBER IN VARCHAR2,
  pTARIFF_CODE IN VARCHAR2,
  pDATE IN DATE DEFAULT SYSDATE
  ) RETURN INTEGER IS
--
--#Version=4
--
-- ��������� ���������� �������� ���� �� ��� ����.
-- ���� � ���� ����� ������� ��������� ������� � �����������, �� ��������� 
-- ������� ������ �� ��������.
-- 
CURSOR C_TARIFFS IS
  SELECT TARIFF_ID
    FROM TARIFFS WHERE TARIFF_CODE=pTARIFF_CODE
    ORDER BY NVL(TARIFFS.TARIFF_PRIORITY, 9999) ASC;
--
CURSOR C_CONTRACTS IS
  SELECT C.TARIFF_ID, 
         c.CONTRACT_ID,
         TARIFFS.TARIFF_CODE
    FROM CONTRACTS C, 
         CONTRACT_CANCELS CC, 
         TARIFFS
    WHERE C.PHONE_NUMBER_FEDERAL=pPHONE_NUMBER
      AND (pDATE IS NULL OR C.CONTRACT_DATE <= pDATE)
      AND CC.CONTRACT_ID(+)=C.CONTRACT_ID
      AND (CC.CONTRACT_CANCEL_DATE IS NULL OR CC.CONTRACT_CANCEL_DATE >= pDATE)
      AND TARIFFS.TARIFF_ID=C.TARIFF_ID
      AND ROWNUM <= 1;
--
CURSOR C_CONTRACTS2 IS
  SELECT C.TARIFF_ID, 
         c.CONTRACT_ID,
         TARIFFS.TARIFF_CODE
    FROM CONTRACTS C,
         TARIFFS
    WHERE C.PHONE_NUMBER_FEDERAL=pPHONE_NUMBER
      AND TARIFFS.TARIFF_ID(+)=C.TARIFF_ID
      and tariffs.TARIFF_CODE=pTARIFF_CODE
    order by c.CONTRACT_DATE desc;
--
CURSOR CCH_CONTRACTS(pCONTRACT_ID IN INTEGER) IS
  SELECT CH.TARIFF_ID
    FROM CONTRACT_CHANGES CH,
         TARIFFS
    WHERE CH.CONTRACT_CHANGE_DATE<=pDATE
      AND CH.CONTRACT_ID=pCONTRACT_ID
      AND CH.TARIFF_ID=TARIFFS.TARIFF_ID(+)
      AND TARIFFS.TARIFF_CODE=pTARIFF_CODE
    ORDER BY CH.CONTRACT_CHANGE_DATE DESC;
--
  vRESULT INTEGER;
  vTARIFF_ID2 INTEGER;
  REC_C C_CONTRACTS%ROWTYPE;
  REC_C2 C_CONTRACTS2%ROWTYPE;
  REC_CCH CCH_CONTRACTS%ROWTYPE;
--
BEGIN
  OPEN C_TARIFFS;
  FETCH C_TARIFFS INTO vRESULT;
  IF C_TARIFFS%FOUND THEN
    -- �������� �������� ��� ���� ������. 
    FETCH C_TARIFFS INTO vTARIFF_ID2;
    IF C_TARIFFS%FOUND THEN
      -- ���� ��� ���� - ���� ����� � ���������.
      OPEN C_CONTRACTS;
      FETCH C_CONTRACTS INTO REC_C;
      IF C_CONTRACTS%FOUND THEN  
        IF REC_C.TARIFF_CODE=pTARIFF_CODE THEN 
          vRESULT:=REC_C.TARIFF_ID;
        END IF;            
        OPEN CCH_CONTRACTS(REC_C.CONTRACT_ID);
        FETCH CCH_CONTRACTS INTO REC_CCH;
        IF (CCH_CONTRACTS%FOUND)AND(NVL(REC_CCH.TARIFF_ID, 0)<>0) THEN
          vRESULT:=REC_CCH.TARIFF_ID;
        END IF;
        CLOSE CCH_CONTRACTS;
      ELSE
        OPEN C_CONTRACTS2;
        FETCH C_CONTRACTS2 INTO REC_C2;
        IF C_CONTRACTS2%FOUND THEN
          vRESULT:=REC_C2.TARIFF_ID;
        END IF;
        CLOSE C_CONTRACTS2;
      END IF;
      CLOSE C_CONTRACTS;
    END IF;
  END IF;
  CLOSE C_TARIFFS;
  RETURN vRESULT;
END;
/
--#end if