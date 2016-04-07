CREATE OR REPLACE FUNCTION GET_BS_ZONE_NAME(
  pBS_ZONE_ID IN INTEGER
  ) RETURN VARCHAR2 IS
--
--#Version=1
--
CURSOR C IS
  SELECT ZONE_NAME 
  FROM BEELINE_BS_ZONES
  WHERE BEELINE_BS_ZONE_ID=pBS_ZONE_ID;
--
vNAME BEELINE_BS_ZONES.ZONE_NAME%TYPE;
BEGIN
  OPEN C;
  FETCH C INTO vNAME;
  CLOSE C;
  RETURN vNAME;
END;
/

GRANT EXECUTE ON GET_BS_ZONE_NAME TO CORP_MOBILE_LK;
CREATE SYNONYM CORP_MOBILE_LK.GET_BS_ZONE_NAME FOR GET_BS_ZONE_NAME;