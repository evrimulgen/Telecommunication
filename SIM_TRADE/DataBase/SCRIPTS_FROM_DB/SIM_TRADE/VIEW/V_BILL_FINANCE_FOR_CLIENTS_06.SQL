
  CREATE OR REPLACE FORCE VIEW "SIM_TRADE"."V_BILL_FINANCE_FOR_CLIENTS_06" ("ACCOUNT_ID", "YEAR_MONTH", "PHONE_NUMBER", "BILL_SUM_OLD", "BILL_SUM_NEW", "ABON_TP_OLD", "ABON_TP_NEW", "ABON_ADD_OLD", "ABON_ADD_NEW", "DISCOUNT_OLD", "DISCOUNT_NEW", "SINGLE_PENALTI", "SINGLE_PAYMENTS_OLD", "SINGLE_PAYMENTS_NEW", "CALLS_COUNTRY", "CALLS_SITY", "CALLS_LOCAL", "CALLS_SMS_MMS", "CALLS_GPRS", "CALLS_RUS_RPP", "COMPLETE_BILL", "ROUMING_NATIONAL", "ROUMING_INTERNATIONAL") AS 
  SELECT T1.ACCOUNT_ID,
          T1.YEAR_MONTH,
          T1.PHONE_NUMBER,
          T1.BILL_SUM_OLD,
          ROUND (
               T1.BILL_SUM_OLD
             + T1.SINGLE_PENALTI
             + T1.SINGLE_VIEW_BLACK_LIST
             + CASE
                  WHEN T1.ABON_MAIN > 0
                  THEN
                     T1.ABON_TP_REAL * (T1.ABON_TP_FULL_NEW / T1.ABON_MAIN)
                  ELSE
                     T1.ABON_TP_FULL_NEW
               END
             - T1.ABON_TP_REAL
             + T1.ABON_SERVICE_ADD_COST
             - T1.DISCOUNTS
             + T1.DISCOUNT_SMS_PLUS
             + T1.DISCOUNT_CALL,
             4)
             AS BILL_SUM_NEW,
          T1.ABON_TP_REAL AS ABON_TP_OLD,
          ROUND (
             CASE
                WHEN T1.ABON_MAIN > 0
                THEN
                   T1.ABON_TP_REAL * (T1.ABON_TP_FULL_NEW / T1.ABON_MAIN)
                ELSE
                   T1.ABON_TP_FULL_NEW
             END,
             4)
             AS ABON_TP_NEW,                  --Определим новую абонку клиенту
          T1.ABON_ADD AS ABON_ADD_OLD,
          T1.ABON_ADD + T1.ABON_SERVICE_ADD_COST AS ABON_ADD_NEW,
          T1.DISCOUNTS AS DISCOUNT_OLD,
          T1.DISCOUNT_SMS_PLUS + T1.DISCOUNT_CALL AS DISCOUNT_NEW,
          T1.SINGLE_PENALTI,
          T1.SINGLE_PAYMENTS AS SINGLE_PAYMENTS_OLD,
            T1.SINGLE_PAYMENTS
          + T1.SINGLE_PENALTI
          + T1.SINGLE_VIEW_BLACK_LIST
          - T1.SINGLE_MAIN
             AS SINGLE_PAYMENTS_NEW,
          T1.CALLS_COUNTRY,
          T1.CALLS_SITY,
          T1.CALLS_LOCAL,
          T1.CALLS_SMS_MMS,
          T1.CALLS_GPRS,
          T1.CALLS_RUS_RPP,
          T1.COMPLETE_BILL,
          t1.ROUMING_NATIONAL,  t1.ROUMING_INTERNATIONAL
     FROM (SELECT FB.ACCOUNT_ID,
                  FB.YEAR_MONTH,
                  FB.PHONE_NUMBER,
                  FB.BILL_SUM AS BILL_SUM_OLD,
                  FB.ABON_MAIN + FB.SINGLE_MAIN AS ABON_TP_REAL, --Реальная абонка по билайну
                  FB.ABON_ADD + FB.SINGLE_ADD AS ABON_SERVICE_OLD, --Реальная плата за услуги по билайну
                  FB.DISCOUNT_CALL + FB.DISCOUNT_SMS_PLUS AS DISCOUNTS_CLIENT, --Скидки идущие клиенту
                    FB.SINGLE_PAYMENTS
                  - FB.SINGLE_MAIN
                  - FB.SINGLE_ADD
                  + FB.SINGLE_PENALTI
                  + FB.SINGLE_VIEW_BLACK_LIST
                     AS SINGLE_PAYMENTS_CLIENT, --Разовые начисл идущие клиенту
                  CASE
                     WHEN (FB.BILL_SUM <> 0) AND (FB.ABON_MAIN > 0)
                     THEN
                        GET_NEW_FULL_FINANCE_ABON_TP (FB.ACCOUNT_ID,
                                                      FB.YEAR_MONTH,
                                                      FB.PHONE_NUMBER)
                     ELSE
                        0
                  END
                     AS ABON_TP_FULL_NEW, --Полная абонка за месяц, пересчитанная
                  CASE
                     WHEN     (FB.BILL_SUM <> 0)
                          AND (FB.ABON_ADD + FB.SINGLE_ADD <> 0)
                     THEN
                        GET_TARIFF_OPTION_ADD_COST (FB.ACCOUNT_ID,
                                                    FB.YEAR_MONTH,
                                                    FB.PHONE_NUMBER)
                     ELSE
                        0
                  END
                     AS ABON_SERVICE_ADD_COST,    --Добавочная стоимость услуг
                  FB.ABONKA,
                  FB.CALLS,
                  FB.SINGLE_PAYMENTS,
                  FB.DISCOUNTS,
                  FB.COMPLETE_BILL,
                  FB.ABON_MAIN,
                  FB.ABON_ADD,
                  FB.ABON_OTHER,
                  FB.SINGLE_MAIN,
                  FB.SINGLE_ADD,
                  FB.SINGLE_PENALTI,
                  FB.SINGLE_CHANGE_TARIFF,
                  FB.SINGLE_VIEW_BLACK_LIST,
                  FB.DISCOUNT_SMS_PLUS,
                  FB.DISCOUNT_YEAR,
                  FB.DISCOUNT_CALL,
                  FB.CALLS_COUNTRY,
                  FB.CALLS_SITY,
                  FB.CALLS_LOCAL,
                  FB.CALLS_SMS_MMS,
                  FB.CALLS_GPRS,
                  FB.CALLS_RUS_RPP,
                  FB.ROUMING_NATIONAL,  FB.ROUMING_INTERNATIONAL
             FROM DB_LOADER_FULL_FINANCE_BILL FB,
                  BILL_FINANCE_FOR_CLIENTS_SAVED
            WHERE     FB.COMPLETE_BILL = 1
                  AND FB.ACCOUNT_ID =
                         BILL_FINANCE_FOR_CLIENTS_SAVED.ACCOUNT_ID(+)
                  AND FB.YEAR_MONTH =
                         BILL_FINANCE_FOR_CLIENTS_SAVED.YEAR_MONTH(+)
                  AND FB.PHONE_NUMBER =
                         BILL_FINANCE_FOR_CLIENTS_SAVED.PHONE_NUMBER(+)
                  AND BILL_FINANCE_FOR_CLIENTS_SAVED.PHONE_NUMBER IS NULL) T1
   UNION ALL
   SELECT BS1.ACCOUNT_ID,
          BS1.YEAR_MONTH,
          BS1.PHONE_NUMBER,
          BS1.BILL_SUM_OLD,
          BS1.BILL_SUM_NEW,
          BS1.ABON_TP_OLD,
          BS1.ABON_TP_NEW,
          BS1.ABON_ADD_OLD,
          BS1.ABON_ADD_NEW,
          BS1.DISCOUNT_OLD,
          BS1.DISCOUNT_NEW,
          BS1.SINGLE_PENALTI,
          BS1.SINGLE_PAYMENTS_OLD,
          BS1.SINGLE_PAYMENTS_NEW,
          BS1.CALLS_COUNTRY,
          BS1.CALLS_SITY,
          BS1.CALLS_LOCAL,
          BS1.CALLS_SMS_MMS,
          BS1.CALLS_GPRS,
          BS1.CALLS_RUS_RPP,
          BS1.COMPLETE_BILL,
          null, null
     FROM BILL_FINANCE_FOR_CLIENTS_SAVED BS1