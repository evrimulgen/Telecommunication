CREATE OR REPLACE FUNCTION WWW_GET_RESTORE_PASSWORD(
  pPHONE_NUMBER IN VARCHAR2 
  ) RETURN INTEGER IS
--#Version=1
CURSOR C IS
  SELECT COUNT(*) 
    FROM (SELECT *
      FROM v_contracts
      WHERE v_contracts.PHONE_NUMBER_FEDERAL=pPHONE_NUMBER
      );
vCNT BINARY_INTEGER;
BEGIN
  vCNT:=0;
  OPEN C;
  FETCH C INTO vCNT;
  CLOSE C; 
  IF vCNT>0 THEN
    RETURN 1;
  ELSE 
    RETURN 0;
  END IF; 
END;
/

GRANT EXECUTE ON WWW_GET_RESTORE_PASSWORD TO LONTANA_WWW;
/       