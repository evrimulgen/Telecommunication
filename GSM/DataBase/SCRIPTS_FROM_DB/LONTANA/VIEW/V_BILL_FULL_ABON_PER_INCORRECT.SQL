
  CREATE OR REPLACE FORCE VIEW "LONTANA"."V_BILL_FULL_ABON_PER_INCORRECT" ("ACCOUNT_ID", "YEAR_MONTH", "PHONE_NUMBER", "ABONKA", "CALLS", "SINGLE_PAYMENTS", "DISCOUNTS", "BILL_SUM", "COMPLETE_BILL", "ABON_MAIN", "ABON_ADD", "ABON_OTHER", "SINGLE_MAIN", "SINGLE_ADD", "SINGLE_PENALTI", "SINGLE_CHANGE_TARIFF", "SINGLE_TURN_ON_SERV", "SINGLE_CORRECTION_ROUMING", "SINGLE_INTRA_WEB", "SINGLE_VIEW_BLACK_LIST", "SINGLE_OTHER", "DISCOUNT_YEAR", "DISCOUNT_SMS_PLUS", "DISCOUNT_CALL", "DISCOUNT_COUNT_ON_PHONES", "DISCOUNT_OTHERS", "CALLS_COUNTRY", "CALLS_SITY", "CALLS_LOCAL", "CALLS_SMS_MMS", "CALLS_GPRS", "CALLS_RUS_RPP", "CALLS_ALL", "ROUMING_NATIONAL", "ROUMING_INTERNATIONAL", "DATE_CREATED", "USER_CREATED", "USER_LAST_UPDATED", "DATE_LAST_UPDATED", "DISCOUNT_SOVINTEL", "BAN") AS 
  SELECT "ACCOUNT_ID","YEAR_MONTH","PHONE_NUMBER","ABONKA","CALLS","SINGLE_PAYMENTS","DISCOUNTS","BILL_SUM","COMPLETE_BILL","ABON_MAIN","ABON_ADD","ABON_OTHER","SINGLE_MAIN","SINGLE_ADD","SINGLE_PENALTI","SINGLE_CHANGE_TARIFF","SINGLE_TURN_ON_SERV","SINGLE_CORRECTION_ROUMING","SINGLE_INTRA_WEB","SINGLE_VIEW_BLACK_LIST","SINGLE_OTHER","DISCOUNT_YEAR","DISCOUNT_SMS_PLUS","DISCOUNT_CALL","DISCOUNT_COUNT_ON_PHONES","DISCOUNT_OTHERS","CALLS_COUNTRY","CALLS_SITY","CALLS_LOCAL","CALLS_SMS_MMS","CALLS_GPRS","CALLS_RUS_RPP","CALLS_ALL","ROUMING_NATIONAL","ROUMING_INTERNATIONAL","DATE_CREATED","USER_CREATED","USER_LAST_UPDATED","DATE_LAST_UPDATED","DISCOUNT_SOVINTEL","BAN"
    FROM DB_LOADER_FULL_FINANCE_BILL FB
    WHERE     FB.BILL_SUM <> 0
          AND fb.YEAR_MONTH >=
                 TO_NUMBER (TO_CHAR (ADD_MONTHS (SYSDATE, -4), 'yyyymm'))
          AND FB.ABONKA <> 0
          AND FB.ABONKA <>
                 (SELECT NVL (SUM (AP.ABON_ALL), 0)
                    FROM DB_LOADER_FULL_BILL_ABON_PER AP
                   WHERE     AP.ACCOUNT_ID = FB.ACCOUNT_ID
                         AND AP.YEAR_MONTH = FB.YEAR_MONTH
                         AND AP.PHONE_NUMBER = FB.PHONE_NUMBER)