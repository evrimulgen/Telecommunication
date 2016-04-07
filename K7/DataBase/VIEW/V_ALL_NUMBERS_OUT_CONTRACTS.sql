CREATE OR REPLACE VIEW V_ALL_NUMBERS_OUT_CONTRACTS AS
SELECT
--#Version=4
  PHONE_NUMBER,
  PHONE_IS_ACTIVE,
  ACCOUNT_ID
FROM
  DB_LOADER_ACCOUNT_PHONES PH_NEW
WHERE
      -- ��������� ������ � ����� ������� ����������� ������� 
      (PH_NEW.ACCOUNT_ID, PH_NEW.YEAR_MONTH) IN (
        SELECT PH_OLD.ACCOUNT_ID,
               MAX(PH_OLD.YEAR_MONTH)
          FROM DB_LOADER_ACCOUNT_PHONES PH_OLD
          WHERE PH_OLD.ACCOUNT_ID IS NOT NULL
          GROUP BY PH_OLD.ACCOUNT_ID)
  AND PHONE_NUMBER NOT IN (
    SELECT CONTRACTS.PHONE_NUMBER_FEDERAL 
      FROM CONTRACTS
      where CONTRACTS.CONTRACT_ID not in(
        select CONTRACT_ID
          from contract_cancels)      
    );
/