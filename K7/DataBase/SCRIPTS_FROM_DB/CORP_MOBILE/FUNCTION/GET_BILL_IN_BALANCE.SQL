
  CREATE OR REPLACE FUNCTION "CORP_MOBILE"."GET_BILL_IN_BALANCE" (
   paccount_id in INTEGER, pYEAR_MONTH in number
  ) RETURN INTEGER IS
--Vesion=1
CURSOR C IS
SELECT ACCOUNT_ID
                     FROM ACCOUNT_LOADED_BILLS AB
                     WHERE AB.ACCOUNT_ID=paccount_id and AB.YEAR_MONTH=pYEAR_MONTH
                     and AB.LOAD_BILL_IN_BALANCE = 1 ;
DUMMY NUMBER;
ITOG NUMBER;
BEGIN
  OPEN C;
  FETCH C INTO DUMMY;
  IF C%FOUND THEN
    ITOG:=1;
  ELSE
    ITOG:=0;
  END IF;
  CLOSE C;
  RETURN ITOG;
END;
