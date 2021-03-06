--#if isclient("CORP_MOBILE") OR isclient("GSM_CORP") then
--#if GetVersion("V_BILLS_VIOL_NO_ACTIV_ALL") < 2
CREATE OR REPLACE VIEW V_BILLS_VIOL_NO_ACTIV_ALL as
--Version=2
--2. ��������. ������� ������ ���� ACCOUNTS.ACCOUNT_NUMBER

  SELECT FB.YEAR_MONTH,
         FB.ACCOUNT_ID,
         FB.PHONE_NUMBER,
         FB.ABONKA,
         FB.CALLS,
         FB.SINGLE_PAYMENTS,
         FB.DISCOUNTS,
         FB.BILL_SUM,
         A.ACCOUNT_NUMBER
    FROM DB_LOADER_FULL_FINANCE_BILL FB, ACCOUNTS A
    WHERE FB.BILL_SUM > 0
      AND FB.COMPLETE_BILL = 1
      AND FB.ACCOUNT_ID = A.ACCOUNT_ID
      AND NOT EXISTS (SELECT 1 
                        FROM DB_LOADER_ACCOUNT_PHONE_HISTS H
                        WHERE H.PHONE_NUMBER = FB.PHONE_NUMBER
                          AND H.PHONE_IS_ACTIVE = 1
                          AND H.END_DATE >= TO_DATE(TO_CHAR(FB.YEAR_MONTH)||'01', 'YYYYMMDD')
                          AND H.BEGIN_DATE < ADD_MONTHS(TO_DATE(TO_CHAR(FB.YEAR_MONTH)||'01', 'YYYYMMDD'), 1))
      AND EXISTS (SELECT 1 
                    FROM DB_LOADER_ACCOUNT_PHONE_HISTS H
                    WHERE H.PHONE_NUMBER = FB.PHONE_NUMBER
                      AND H.END_DATE >= TO_DATE(TO_CHAR(FB.YEAR_MONTH)||'01', 'YYYYMMDD')
                      AND H.BEGIN_DATE < ADD_MONTHS(TO_DATE(TO_CHAR(FB.YEAR_MONTH)||'01', 'YYYYMMDD'), 1))
  UNION ALL
  SELECT B.YEAR_MONTH,
         B.ACCOUNT_ID,
         B.PHONE_NUMBER,
         B.SUBSCRIBER_PAYMENT_MAIN + B.SUBSCRIBER_PAYMENT_ADD AS ABONKA,
         B.CALLS_OTHER_COUNTRY_COST + B.CALLS_OTHER_CITY_COST + B.CALLS_LOCAL_COST
          + B.INTERNET_COST + B.MESSAGES_COST AS CALLS,
         B.SINGLE_PAYMENTS,
         B.DISCOUNT_VALUE AS DISCOUNTS,
         B.BILL_SUM,
         A.ACCOUNT_NUMBER
    FROM DB_LOADER_BILLS B,
         DB_LOADER_FULL_FINANCE_BILL FB, ACCOUNTS A
    WHERE B.BILL_SUM>0
      AND B.ACCOUNT_ID = FB.ACCOUNT_ID(+) 
      AND B.YEAR_MONTH = FB.YEAR_MONTH(+) 
      AND B.PHONE_NUMBER = FB.PHONE_NUMBER(+)
      AND FB.PHONE_NUMBER IS NULL  
      AND B.ACCOUNT_ID = A.ACCOUNT_ID
      AND NOT EXISTS (SELECT 1 
                        FROM DB_LOADER_ACCOUNT_PHONE_HISTS H
                        WHERE H.PHONE_NUMBER = FB.PHONE_NUMBER
                          AND H.PHONE_IS_ACTIVE = 1
                          AND TRUNC(H.END_DATE) >= B.DATE_BEGIN
                          AND TRUNC(H.BEGIN_DATE) <= b.DATE_END)
      AND EXISTS (SELECT 1 
                    FROM DB_LOADER_ACCOUNT_PHONE_HISTS H
                    WHERE H.PHONE_NUMBER = FB.PHONE_NUMBER
                      AND TRUNC(H.END_DATE) >= B.DATE_BEGIN
                      AND TRUNC(H.BEGIN_DATE) <= b.DATE_END);
/                          
--#end if

--#Execute MAIN_SCHEMA=IsClient("")
--#if not GrantExists("V_BILLS_VIOL_NO_ACTIV_ALL", "ROLE", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT SELECT ON V_BILLS_VIOL_NO_ACTIV_ALL TO &MAIN_SCHEMA'||'_ROLE'; end;
--#end if

--#if not GrantExists("V_BILLS_VIOL_NO_ACTIV_ALL", "ROLE_RO", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT SELECT ON V_BILLS_VIOL_NO_ACTIV_ALL TO &MAIN_SCHEMA'||'_ROLE_RO'; end;
--#end if


--#end if
