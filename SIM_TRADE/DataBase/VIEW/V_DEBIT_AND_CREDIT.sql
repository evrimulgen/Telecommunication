create OR REPLACE view V_DEBIT_AND_CREDIT AS
   SELECT 
--
--Version=5
--
--V.5   ������� 25.05.2015 ��������� ���� CONTRACT_NUM - ���� ������� ������ �� �� ��� �������
--Version = 4 ����������: ��������� ����� ���� � ������� 15.10.2012
--Version = 3 ����������: ��������� ����� ���� � ������� �� ������� �� ����� 11.10.2012
--Version = 2 ����������: ��������� ����� ���� � ������� CONTRACT_NUM 11.10.2012   
   
   v.YEAR_MONTH,
          v.PHONE_NUMBER,
          v.BILL_SUM_OLD BEELINE_BILL,
          V.BILL_SUM_NEW CLIENT_BILL,
          (SELECT
              SUM (P.PAYMENT_SUM)
             FROM DB_LOADER_PAYMENTS P
             WHERE 
              P.PHONE_NUMBER = V.PHONE_NUMBER
              AND TO_CHAR (P.PAYMENT_DATE, 'YYYYMM') = v.YEAR_MONTH
          )
             PAYMENTS,
             
          (
            SELECT
              SUM (P.PAYMENT_SUM)
            FROM
              V_FULL_BALANCE_PAYMENTS P
            WHERE
              P.PHONE_NUMBER = V.PHONE_NUMBER
              AND TO_CHAR (P.PAYMENT_DATE, 'YYYYMM') = v.YEAR_MONTH
           )
             PAYMENTS_FULL,
          GET_ABONENT_BALANCE (
             V.PHONE_NUMBER,
             TO_DATE (v.YEAR_MONTH || '01', 'YYYYMMDD') - 1
             )
            BALANCE_ON_BEGIN,
          
          (SELECT C.CONTRACT_DATE
             FROM V_CONTRACTS c
            WHERE     c.PHONE_NUMBER_FEDERAL = v.PHONE_NUMBER
                  AND C.CONTRACT_CANCEL_DATE IS NULL
                  AND ROWNUM = 1
            )
             CONTRACT_DATE,
             (SELECT ACCOUNT_NUMBER
             FROM ACCOUNTS
            WHERE ACCOUNT_ID = v.ACCOUNT_ID)
             CONTRACT_NUM
     FROM V_BILL_FINANCE_FOR_CLIENTS v;


GRANT SELECT ON V_DEBIT_AND_CREDIT TO SIM_TRADE_ROLE;