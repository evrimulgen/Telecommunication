CREATE OR REPLACE PROCEDURE INSERT_FIX_BALANCE(
  pPHONE_NUMBER IN VARCHAR2,
  pBALANCE_DATE IN DATE,
  pFIX_BALANCE IN NUMBER,
  pFIX_YEAR_MONTH_ID IN INTEGER
  ) IS
  CURSOR DEP IS
    SELECT CURRENT_DEPOSITE_VALUE, DATE_DEPOSITE_CHANGE
      FROM CONTRACT_DEPOSITES, contracts
      WHERE CONTRACT_DEPOSITES.CONTRACT_ID=contracts.CONTRACT_ID
        and contracts.PHONE_NUMBER_FEDERAL=pPHONE_NUMBER
        and contracts.CONTRACT_DATE<=pBALANCE_DATE
        AND CONTRACT_DEPOSITES.DATE_DEPOSITE_CHANGE<=pBALANCE_DATE;
  DUMMY DEP%ROWTYPE;      
  vFIX_BALANCE NUMBER(13, 2);
--Version=1  
BEGIN  
  IF PPHONE_NUMBER<>'0000000000' THEN
    OPEN DEP;
    FETCH DEP INTO DUMMY;
    IF DEP%FOUND THEN
      vFIX_BALANCE:=pFIX_BALANCE+DUMMY.CURRENT_DEPOSITE_VALUE;
    ELSE
      vFIX_BALANCE:=pFIX_BALANCE;
    END IF;
    CLOSE DEP;
    INSERT INTO PHONE_BALANCES (PHONE_NUMBER, BALANCE_DATE, BALANCE_VALUE, FIX_YEAR_MONTH_ID) 
      VALUES (pPHONE_NUMBER, pBALANCE_DATE, vFIX_BALANCE, pFIX_YEAR_MONTH_ID);
  END IF;  
END;
/