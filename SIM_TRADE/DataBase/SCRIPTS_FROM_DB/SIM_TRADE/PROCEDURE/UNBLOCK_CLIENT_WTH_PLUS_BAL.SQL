
  CREATE OR REPLACE PROCEDURE "SIM_TRADE"."UNBLOCK_CLIENT_WTH_PLUS_BAL" AS
--
--#Version=10
--
--09.09.2011 Крайнов. Вынесен отбор телефонов во вьюшку
--
CURSOR C IS
  SELECT V_PHONE_NUMBERS_FOR_UNLOCK.FIO,
         V_PHONE_NUMBERS_FOR_UNLOCK.BALANCE,
         V_PHONE_NUMBERS_FOR_UNLOCK.PHONE_NUMBER_FEDERAL
    FROM V_PHONE_NUMBERS_FOR_UNLOCK
    WHERE NOT EXISTS(SELECT 1
                       FROM AUTO_UNBLOCKED_PHONE
                       WHERE V_PHONE_NUMBERS_FOR_UNLOCK.PHONE_NUMBER_FEDERAL=AUTO_UNBLOCKED_PHONE.PHONE_NUMBER
                         AND AUTO_UNBLOCKED_PHONE.NOTE='Ошибка. Error! Разблокировка через сайт не разрешена'
                         AND AUTO_UNBLOCKED_PHONE.UNBLOCK_DATE_TIME>SYSDATE-4/24) 
                             --Номера с запретом не чаще раз в 4 часа
    order by BALANCE-NVL(DISCONNECT_LIMIT, 0) DESC;

      /*SELECT * 
  FROM v_abonent_balances
  WHERE  v_abonent_balances.PHONE_NUMBER_FEDERAL=9672217562; */
  
  unb_d_t DATE;
  UNLOCK_PH VARCHAR2(2000);
  ERROR_COL NUMBER;
BEGIN
     
     FOR vREC IN C  
     LOOP
       ERROR_COL:=0; 
       unb_d_t:=sysdate;
       UNLOCK_PH:=LOADER3_pckg.UNLOCK_PHONE(vREC.PHONE_NUMBER_FEDERAL, 0,1); --Для Сим-трайд прописываем жестко т.к. один л\с
     --  
       IF UNLOCK_PH IS NOT NULL THEN
         LOOP
           ERROR_COL:=ERROR_COL+1;
--           UNLOCK_PH:=LOADER3_pckg.UNLOCK_PHONE(vREC.PHONE_NUMBER_FEDERAL, 0);
           EXIT WHEN (UNLOCK_PH IS NULL) OR (ERROR_COL=2); 
         END LOOP;
       END IF;
     --
       IF ERROR_COL=2  THEN
        INSERT INTO AUTO_UNBLOCKED_PHONE  
          (phone_number,
           Ballance,
           Note,
           unblock_date_time,
           ABONENT_FIO) 
         VALUES (vREC.PHONE_NUMBER_FEDERAL, vREC.Balance, SUBSTR('Ошибка. '||UNLOCK_PH, 1, 300), unb_d_t,vREC.FIO);
       ELSE 
         UPDATE DB_LOADER_ACCOUNT_PHONES
         SET DB_LOADER_ACCOUNT_PHONES.PHONE_IS_ACTIVE=1
         WHERE  
          DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH= (Select * from  (select DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH from
          DB_LOADER_ACCOUNT_PHONES where DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER=vREC.PHONE_NUMBER_FEDERAL order by YEAR_MONTH desc) where rownum=1) 
          and DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER=vREC.PHONE_NUMBER_FEDERAL;
      END IF;
      COMMIT;
     END LOOP;
   END; 
