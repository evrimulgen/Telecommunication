
  CREATE OR REPLACE FORCE VIEW "LONTANA"."V_DEBITORKA" ("PHONE_NUMBER", "PAYMENTS_ALL", "BILLS_ALL", "PAYMENTS_ALL_MINUS", "BILLS_ALL_MINUS", "DEBITORKA", "DEBITORKA_MINUS") AS 
  SELECT T2."PHONE_NUMBER",T2."PAYMENTS_ALL",T2."BILLS_ALL",T2."PAYMENTS_ALL_MINUS",T2."BILLS_ALL_MINUS",
         T2.PAYMENTS_ALL + T2.BILLS_ALL DEBITORKA,
         T2.PAYMENTS_ALL_MINUS + T2.BILLS_ALL_MINUS DEBITORKA_MINUS         
    FROM (SELECT T1.PHONE_NUMBER,
                 (SELECT SUM(CS.PAYMENTS_SUMM_ALL)
                    FROM CONTRACT_STATISTICS CS
                    WHERE CS.PHONE_NUMBER = T1.PHONE_NUMBER) PAYMENTS_ALL,
                 (SELECT SUM(CS.BILLS_SUMM_ALL)
                    FROM CONTRACT_STATISTICS CS
                    WHERE CS.PHONE_NUMBER = T1.PHONE_NUMBER) BILLS_ALL,
                 (SELECT SUM(CS.PAYMENTS_SUMM_ALL)
                    FROM CONTRACT_STATISTICS CS
                    WHERE CS.PHONE_NUMBER = T1.PHONE_NUMBER
                      and cs.PAYMENTS_SUMM_ALL + cs.BILLS_SUMM_ALL <= 0) PAYMENTS_ALL_MINUS,
                 (SELECT SUM(CS.BILLS_SUMM_ALL)
                    FROM CONTRACT_STATISTICS CS
                    WHERE CS.PHONE_NUMBER = T1.PHONE_NUMBER
                      and cs.PAYMENTS_SUMM_ALL + cs.BILLS_SUMM_ALL <= 0) BILLS_ALL_MINUS              
            FROM (SELECT PHONE_NUMBER
                    FROM CONTRACT_STATISTICS
                    GROUP BY PHONE_NUMBER) T1) T2 