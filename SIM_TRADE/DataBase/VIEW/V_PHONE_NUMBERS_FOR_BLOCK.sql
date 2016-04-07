CREATE OR REPLACE VIEW V_PHONE_NUMBERS_FOR_BLOCK
AS 
  SELECT
--#Version=4.
--v.4 20.10.2015 ������� ������� contract_id
--                      ����� ������ 
--3 ���������� �.�. ���������� ����������� ���-�� ����� + ����� 6 ����� ����� ��������, �� 1 ���
--2 �������. ������������� � IOT_CURRENT_BALANCE
--1 30.05.2013 ����� �.  
    V.CONTRACT_ID,
    V.DEALER_KOD,
    V.PHONE_NUMBER_FEDERAL,
    CASE
      WHEN (ICB.LAST_UPDATE IS NOT NULL) AND (ICB.LAST_UPDATE > SYSDATE -15/24/60 ) THEN
        ICB.BALANCE
    ELSE
      GET_ABONENT_BALANCE(V.PHONE_NUMBER_FEDERAL)
    END BALANCE,
    V.SURNAME || ' ' || V.NAME || ' ' || V.PATRONYMIC FIO,
    V.DISCONNECT_LIMIT,
    V.IS_CREDIT_CONTRACT,
    CASE
      WHEN V.IS_CREDIT_CONTRACT=1 THEN
        ACCOUNTS.TEXT_NOTICE_BLOCK_CREDIT
    ELSE
      ACCOUNTS.BLOCK_NOTICE_TEXT
    END BLOCK_NOTICE_TEXT,
    
    CASE
      WHEN V.IS_CREDIT_CONTRACT=1 THEN
        ACCOUNTS.BALANCE_BLOCK_CREDIT
    ELSE
      ACCOUNTS.BALANCE_BLOCK
    END BALANCE_BLOCK,
    
    ACCOUNTS.ACCOUNT_ID,
    
    NVL(
        CASE
          WHEN NVL(V.IS_CREDIT_CONTRACT, 0)=1 THEN
            TARIFFS.BALANCE_BLOCK_CREDIT
        ELSE
          TARIFFS.BALANCE_BLOCK
        END,
        NVL(
              CASE
                WHEN NVL(V.IS_CREDIT_CONTRACT, 0)=1 THEN
                  ACCOUNTS.BALANCE_BLOCK_CREDIT
              ELSE
                ACCOUNTS.BALANCE_BLOCK
              END, 0
            )
       )
    + NVL(V.DISCONNECT_LIMIT, 0) block_balance
  
  FROM v_abonent_balances_2 V,
       ACCOUNTS,
       TARIFFS,
       IOT_CURRENT_BALANCE ICB
  WHERE loader_script_name is not null
    AND V.ACCOUNT_ID=ACCOUNTS.ACCOUNT_ID(+)
    AND TARIFFS.TARIFF_ID(+)=V.TARIFF_ID
    AND V.PHONE_NUMBER_FEDERAL = ICB.PHONE_NUMBER(+)
    and (
          CASE
            WHEN (ICB.LAST_UPDATE IS NOT NULL) AND (ICB.LAST_UPDATE > SYSDATE -15/24/60 ) THEN
              ICB.BALANCE
          ELSE
            GET_ABONENT_BALANCE(V.PHONE_NUMBER_FEDERAL)
          END - NVL(V.DISCONNECT_LIMIT, 0) <

           NVL(
                CASE
                  WHEN NVL(V.IS_CREDIT_CONTRACT, 0)=1 THEN
                    TARIFFS.BALANCE_BLOCK_CREDIT
                ELSE
                  TARIFFS.BALANCE_BLOCK
                END,
                NVL(
                     CASE
                       WHEN NVL(V.IS_CREDIT_CONTRACT, 0)=1 THEN
                          ACCOUNTS.BALANCE_BLOCK_CREDIT
                      ELSE
                        ACCOUNTS.BALANCE_BLOCK
                      END
                     , 0)
               )
        
        )
    and V.phone_is_active_code=1
--    and V.HAND_BLOCK=0
    AND EXISTS (SELECT 1
                  FROM DB_LOADER_ACCOUNT_PHONES
                  WHERE V.PHONE_NUMBER_FEDERAL=DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER
                    AND DB_LOADER_ACCOUNT_PHONES.LAST_CHECK_DATE_TIME>SYSDATE-5)
    AND NOT EXISTS (SELECT 1
                      FROM AUTO_BLOCKED_PHONE
                      WHERE V.PHONE_NUMBER_FEDERAL=AUTO_BLOCKED_PHONE.PHONE_NUMBER
                        -- �� ����� 6 ����� �����
                        AND  (AUTO_BLOCKED_PHONE.BLOCK_DATE_TIME > sysdate-6/24)
                        and AUTO_BLOCKED_PHONE.Note IS NULL)
    AND NOT EXISTS (SELECT 1
                      FROM LOYAL_PHONE_FOR_BLOCK
                      WHERE
                      V.PHONE_NUMBER_FEDERAL=LOYAL_PHONE_FOR_BLOCK.PHONE_NUMBER
                   ) 