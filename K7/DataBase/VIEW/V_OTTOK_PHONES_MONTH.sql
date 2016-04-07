CREATE OR REPLACE FORCE VIEW V_OTTOK_PHONES_MONTH
--#Version 1
-- 1. �� ����� ��������� ��� �� ������, ������� ������ � ����� � �����.  
--    ������� ��������� � ����� : 
--      1) ���� ����� � ���������� � ��������� �������� 2 ���; 
--      2) ���� ����� � ������������� ��������, �� �� ������� 3 ������. (������������ - ���� � ������ ������ �������, ������ ��� ���� ����� �����������)
AS 
   SELECT DISTINCT VC.PHONE_NUMBER_FEDERAL,
                   VC.CONTRACT_ID,
                   VC.CONTRACT_DATE,
                   VC.CONTRACT_CANCEL_DATE,                   
                   Q.ACCOUNT_ID,
                   Q.YEAR_MONTH                                        -- 4697
     FROM v_contracts vc, DB_LOADER_ACCOUNT_PHONES q    
    WHERE     TO_NUMBER (TO_CHAR (VC.CONTRACT_DATE, 'YYYYMM')) <= Q.YEAR_MONTH
          AND TO_NUMBER ( TO_CHAR (NVL (VC.CONTRACT_CANCEL_DATE, SYSDATE), 'YYYYMM')) >= Q.YEAR_MONTH
          AND VC.PHONE_NUMBER_FEDERAL = q.PHONE_NUMBER
          AND ( -- ���� ����, � ������� ����������� �� �����, ������� ������ � ����� �������� 2 ������ � ������ � � �������������
                (     NOT EXISTS
                             (SELECT 1
                                FROM DB_LOADER_ACCOUNT_PHONE_HISTS dla
                               WHERE     DLA.PHONE_NUMBER =
                                            VC.PHONE_NUMBER_FEDERAL
                                     AND DLA.PHONE_IS_ACTIVE = 1
                                     AND DLA.BEGIN_DATE <
                                            ADD_MONTHS (
                                               TO_DATE (Q.YEAR_MONTH,
                                                        'YYYYmm'),
                                               1)
                                     AND DLA.END_DATE >=
                                            ADD_MONTHS (
                                               TO_DATE (Q.YEAR_MONTH,
                                                        'YYYYmm'),
                                               -2)              --Q.YEAR_MONTH
                                                  )
                  AND NOT EXISTS
                             (SELECT 1
                                FROM IOT_BALANCE_HISTORY bh
                               WHERE     BH.PHONE_NUMBER =
                                            VC.PHONE_NUMBER_FEDERAL
                                     AND BH.BALANCE > 0
                                     AND BH.LAST_UPDATE >=
                                            ADD_MONTHS (
                                               TO_DATE (Q.YEAR_MONTH,
                                                        'YYYYmm'),
                                               -2)
                                     AND BH.LAST_UPDATE <=
                                            TO_DATE (Q.YEAR_MONTH, 'YYYYmm'))
                  AND EXISTS -- ��� ����, ����� �� ������, ������� ��� ������ � ����� � ���������� ������, �� �������� � ����� � ��������� ������
                         (SELECT 1
                            FROM DB_LOADER_ACCOUNT_PHONE_HISTS dla
                           WHERE     DLA.PHONE_NUMBER =
                                        VC.PHONE_NUMBER_FEDERAL
                                 AND DLA.PHONE_IS_ACTIVE = 1
                                 AND DLA.BEGIN_DATE <
                                        ADD_MONTHS (
                                           TO_DATE (Q.YEAR_MONTH, 'YYYYmm'),
                                           1)
                                 AND DLA.END_DATE >=
                                        ADD_MONTHS (
                                           TO_DATE (Q.YEAR_MONTH, 'YYYYmm'),
                                           -3)                  --Q.YEAR_MONTH
                                              )
                  AND EXISTS -- ��� ����, ����� �� ������, ������� ��� ������ � ����� � ���������� ������, �� �������� � ����� � ��������� ������
                         (SELECT 1
                            FROM IOT_BALANCE_HISTORY bh
                           WHERE     BH.PHONE_NUMBER =
                                        VC.PHONE_NUMBER_FEDERAL
                                 AND BH.BALANCE > 0
                                 AND BH.LAST_UPDATE >=
                                        ADD_MONTHS (
                                           TO_DATE (Q.YEAR_MONTH, 'YYYYmm'),
                                           -3)
                                 AND BH.LAST_UPDATE <=
                                        TO_DATE (Q.YEAR_MONTH, 'YYYYmm')))
               OR -- ���� ��������� �� ������, ������� ���� ��������� � ������� 3-� ������� ������
                  (    NOT EXISTS
                              (SELECT 1
                                 FROM CALL_SUMMARY cs        -- ������ �������
                                WHERE     CS.YEAR_MONTH <= Q.YEAR_MONTH
                                      AND CS.YEAR_MONTH >=
                                             TO_NUMBER (
                                                TO_CHAR (
                                                   ADD_MONTHS (
                                                      TO_DATE (Q.YEAR_MONTH,
                                                               'YYYYMM'),
                                                      -2),
                                                   'YYYYMM'))
                                      AND CS.SUBSCR_NO =
                                             VC.PHONE_NUMBER_FEDERAL)
                   AND NOT EXISTS
                              (SELECT 1
                                 FROM DB_LOADER_FULL_FINANCE_BILL ffb -- � �� ������ ������
                                WHERE     FFB.YEAR_MONTH <= Q.YEAR_MONTH
                                      AND FFB.YEAR_MONTH >=
                                             TO_NUMBER (
                                                TO_CHAR (
                                                   ADD_MONTHS (
                                                      TO_DATE (Q.YEAR_MONTH,
                                                               'YYYYMM'),
                                                      -2),
                                                   'YYYYMM'))
                                      AND FFB.PHONE_NUMBER =
                                             VC.PHONE_NUMBER_FEDERAL
                                      AND FFB.CALLS <> 0)
                   -- �� �� 4 ������ ����������� ���������� (����� ���� � ��� �� ����� ����� �������� ������ ������ �����)
                   AND EXISTS
                          (SELECT 1
                             FROM CALL_SUMMARY cs            -- ������ �������
                            WHERE     CS.YEAR_MONTH <= Q.YEAR_MONTH
                                  AND CS.YEAR_MONTH >=
                                         TO_NUMBER (
                                            TO_CHAR (
                                               ADD_MONTHS (
                                                  TO_DATE (Q.YEAR_MONTH,
                                                           'YYYYMM'),
                                                  -3),
                                               'YYYYMM'))
                                  AND CS.SUBSCR_NO = VC.PHONE_NUMBER_FEDERAL)
                   AND EXISTS
                          (SELECT 1
                             FROM DB_LOADER_FULL_FINANCE_BILL ffb -- � �� ������ ������
                            WHERE     FFB.YEAR_MONTH <= Q.YEAR_MONTH
                                  AND FFB.YEAR_MONTH >=
                                         TO_NUMBER (
                                            TO_CHAR (
                                               ADD_MONTHS (
                                                  TO_DATE (Q.YEAR_MONTH,
                                                           'YYYYMM'),
                                                  -3),
                                               'YYYYMM'))
                                  AND FFB.PHONE_NUMBER =
                                         VC.PHONE_NUMBER_FEDERAL
                                  AND FFB.CALLS <> 0)));

GRANT SELECT ON V_OTTOK_PHONES_MONTH TO CORP_MOBILE_ROLE;

GRANT SELECT ON V_OTTOK_PHONES_MONTH TO CORP_MOBILE_ROLE_RO;