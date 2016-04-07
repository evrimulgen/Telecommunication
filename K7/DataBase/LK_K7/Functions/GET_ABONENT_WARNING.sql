GRANT EXECUTE ON GET_TEXT_ABON_FOR_INET_TARIFF TO K7_LK;
--
CREATE OR REPLACE FUNCTION K7_LK.GET_ABONENT_WARNING(
  pUSER_ID IN INTEGER
) RETURN VARCHAR2 IS
--
--#Version=1
--
-- ���������� ��������������, ���� ��� ���� �������� ��������.
-- ���� ������ �������������� � �������� ���������.
CURSOR C_CONTRACT IS
  SELECT 
    CONTRACTS.CONTRACT_DATE,
    CONTRACTS.PHONE_NUMBER_FEDERAL AS PHONE_NUMBER
  FROM
    CORP_MOBILE.CONTRACTS
  WHERE
    CONTRACTS.CONTRACT_ID=pUSER_ID;
--
vCONTRACT_REC C_CONTRACT%ROWTYPE;
vRESULT VARCHAR2(2000 CHAR);
--
BEGIN
  OPEN C_CONTRACT;
  FETCH C_CONTRACT INTO vCONTRACT_REC;
  CLOSE C_CONTRACT;
  --
  IF     -- ������ 7 ���� �� ����� ������
    TO_CHAR(SYSDATE, 'MM') <> TO_CHAR(SYSDATE+7, 'MM')
  OR     -- ��� ��������� � ���� ������
    TO_CHAR(vCONTRACT_REC.CONTRACT_DATE, 'YYYYMM') = TO_CHAR(SYSDATE, 'YYYYMM')
  THEN     
    vRESULT := CORP_MOBILE.GET_TEXT_ABON_FOR_INET_TARIFF(vCONTRACT_REC.PHONE_NUMBER);  
  END IF;
  --
--  vRESULT := '��������� �������� ����������� ����� �� ���� �� ������ ������ ���������� 01.06.2015 � ������� 990 ���. ��������� ������ �������.';
  RETURN vRESULT;
END;
/
