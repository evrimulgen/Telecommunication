
  CREATE OR REPLACE PROCEDURE "CORP_MOBILE"."ADD_COLL_FULL_FIN_BILLS" (
  pSTREAM_ID in INTEGER DEFAULT -1
  ) IS  
-- Version = 3
  CURSOR C(pACC_ID IN INTEGER, pYM IN INTEGER, 
           pPHONE IN VARCHAR2, pBAN IN NUMBER) IS 
    SELECT * 
      FROM DB_LOADER_FULL_FINANCE_BILL
      WHERE ACCOUNT_ID = pACC_ID 
        AND YEAR_MONTH = pYM
        AND PHONE_NUMBER = pPHONE
        AND NVL(BAN, 0) = NVL(pBAN, 0);
  cDUMMY C%ROWTYPE;
  VAT CONSTANT NUMBER(15,4):= 1.18; 
  STREAM_COUNT CONSTANT INTEGER:= 5;
  vX XMLTYPE;
  vACCOUNT_ID INTEGER;
  I INTEGER;
  E_NODE INTEGER;
  vPHONE_NUMBER VARCHAR2(10 CHAR);
  vTEMP VARCHAR2(15 CHAR);
  vABONKA NUMBER(15, 4);
  vCALLS NUMBER(15, 4);
  vSINGLE_PAYMENTS NUMBER(15, 4);
  vDISCOUNTS NUMBER(15, 4);
  vBILL_SUM NUMBER(15, 4);   
  vCALLS_COUNTRY NUMBER(15, 4);  
  vCALLS_SITY NUMBER(15, 4);  
  vCALLS_LOCAL NUMBER(15, 4);  
  vCALLS_SMS_MMS NUMBER(15, 4);  
  vCALLS_GPRS NUMBER(15, 4);  
  vCALLS_RUS_RPP NUMBER(15, 4);  
  vCALLS_ALL NUMBER(15, 4);  
  vPHONES VARCHAR2(2000 CHAR);
  vABON_MAIN NUMBER(15, 4);  
  vABON_ADD NUMBER(15, 4);  
  vABON_ALL NUMBER(15, 4);    
  vSINGLE_MAIN NUMBER(15, 4);    
  vSINGLE_ADD NUMBER(15, 4);    
  vSINGLE_PENALTI NUMBER(15, 4);    
  vSINGLE_CHANGE_TARIFF NUMBER(15, 4);    
  vSINGLE_TURN_ON_SERV NUMBER(15, 4);    
  vSINGLE_CORRECTION_ROUMING NUMBER(15, 4);    
  vSINGLE_INTRA_WEB NUMBER(15, 4);    
  vSINGLE_VIEW_BLACK_LIST NUMBER(15, 4);    
  vSINGLE_OTHER NUMBER(15, 4);    
  vDISCOUNT_TOTAL NUMBER(15, 4);    
  vDISCOUNT_FLAG NUMBER(1);  
  vROUMING_CALLS NUMBER(15, 4);
  vROUMING_SMS NUMBER(15, 4);
  vROUMING_GPRS NUMBER(15, 4);
  vCOMPANY_TAX NUMBER(15, 4);
  vROUMING_SUM NUMBER(15, 4);
  FUNCTION TO_NUM(RES IN VARCHAR2) RETURN NUMBER IS
  ITOG NUMBER(15,4);  
  vRES VARCHAR2(15 CHAR);
  BEGIN    
    vRES:=REPLACE(RES, ',', '.');
    BEGIN
      ITOG:=TO_NUMBER(vRES);
    EXCEPTION
      WHEN OTHERS THEN
        ITOG:=TO_NUMBER(REPLACE(vRES, '.', ','));
    END;
    RETURN ITOG;
  END;
BEGIN
  FOR rec IN (SELECT CB.*, ROWID
                FROM COLLECTOR_BILL_XML CB
                WHERE CB.XML_CHECKED = 0
                  AND MOD(CB.FILE_ID, STREAM_COUNT) = MOD(pSTREAM_ID, STREAM_COUNT)
                ORDER BY CB.FILE_ID ASC)
  LOOP
    vACCOUNT_ID:=NVL(REC.ACCOUNT_ID, 93);
    vX:=XMLTYPE(REC.XML_TXT);
    vX:=vX.extract('XML_BILL/ECare_Corporate_Str/ECare_Ban_Str/ECare_Ben_Str/ECare_Ben_Summary_Str');
    DELETE FROM COLLECTOR_XML_FILES
      WHERE FILE_ID = REC.FILE_ID;
    -- Общая инфа по номеру
    FOR bill IN (SELECT EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Charge_Totals/SUMM_SUBS_CHARGES_subscriber_no') PHONE_NUMBER,
                        EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Charge_Totals/SUMM_SUBS_CHARGES_subs_summ_rc_amt') ABONKA,
                        EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Charge_Totals/SUMM_SUBS_CHARGES_subs_summ_oc_amt') SINGLE_PAYMENTS,
                        EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Charge_Totals/SUMM_SUBS_CHARGES_subs_summ_uc_amt') CALLS,
                        EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Charge_Totals/SUMM_SUBS_CHARGES_subs_summ_disc_amt') DISCOUNTS,
                        EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Charge_Totals/SUBSCRIBER_TOTAL_subs_total_all_charges') BILL_SUM
                   FROM TABLE(XMLSequence(vX.extract('ECare_Ben_Summary_Str/ECare_Ben_BillDet_Str/ECare_Sub_Charge_Totals'))) TA )
    LOOP
      INSERT INTO COLLECTOR_XML_FILES(FILE_ID, YEAR_MONTH, PHONE_NUMBER, ACCOUNT_ID, BAN, FILE_NAME)
        VALUES(REC.FILE_ID, REC.YEAR_MONTH, bill.PHONE_NUMBER, vACCOUNT_ID, REC.BAN, REC.FILE_NAME);  -- Привязка номеров к файлам
      vPHONE_NUMBER:=bill.PHONE_NUMBER;
      vABONKA:=TO_NUM(bill.ABONKA);
      vSINGLE_PAYMENTS:=TO_NUM(bill.SINGLE_PAYMENTS);
      vCALLS:=TO_NUM(bill.CALLS);
      vDISCOUNTS:=TO_NUM(bill.DISCOUNTS);
      vBILL_SUM:=TO_NUM(bill.BILL_SUM);
--DBMS_OUTPUT.PUT_LINE(vPHONE_NUMBER); DBMS_OUTPUT.PUT_LINE(vABONKA); DBMS_OUTPUT.PUT_LINE(vSINGLE_PAYMENTS); DBMS_OUTPUT.PUT_LINE(vCALLS); DBMS_OUTPUT.PUT_LINE(vDISCOUNTS); DBMS_OUTPUT.PUT_LINE(vBILL_SUM);
      IF  (vPHONE_NUMBER IS NOT NULL) AND (vABONKA IS NOT NULL) AND (vCALLS IS NOT NULL) 
            AND (vSINGLE_PAYMENTS IS NOT NULL) AND (vDISCOUNTS IS NOT NULL) AND (vBILL_SUM IS NOT NULL) THEN
        OPEN C(vACCOUNT_ID, REC.YEAR_MONTH, vPHONE_NUMBER, REC.BAN);
        FETCH C INTO cDUMMY;
        IF NOT(C%FOUND) THEN 
          INSERT INTO DB_LOADER_FULL_FINANCE_BILL(ACCOUNT_ID,YEAR_MONTH,PHONE_NUMBER,ABONKA,CALLS,SINGLE_PAYMENTS,DISCOUNTS,BILL_SUM,COMPLETE_BILL,
                                                  ABON_MAIN,ABON_ADD,ABON_OTHER,SINGLE_MAIN,SINGLE_ADD,SINGLE_PENALTI,SINGLE_CHANGE_TARIFF,  --7
                                                  SINGLE_TURN_ON_SERV,SINGLE_CORRECTION_ROUMING,SINGLE_INTRA_WEB,SINGLE_VIEW_BLACK_LIST,SINGLE_OTHER,  --5
                                                  DISCOUNT_YEAR,DISCOUNT_SMS_PLUS,DISCOUNT_CALL,DISCOUNT_COUNT_ON_PHONES,DISCOUNT_OTHERS,  --5
                                                  CALLS_COUNTRY,CALLS_SITY,CALLS_LOCAL,CALLS_SMS_MMS,CALLS_GPRS,CALLS_RUS_RPP,CALLS_ALL,
                                                  ROUMING_NATIONAL,ROUMING_INTERNATIONAL,DISCOUNT_SOVINTEL, BAN)
            VALUES(vACCOUNT_ID, REC.YEAR_MONTH, vPHONE_NUMBER, VAT*vABONKA, VAT*vCALLS, VAT*vSINGLE_PAYMENTS, VAT*vDISCOUNTS, VAT*vBILL_SUM, 1,
                   0, 0, 0, 0, 0, 0, 0, 
                   0, 0, 0, 0, 0, 
                   0, 0, 0, 0, 0, 
                   0, 0, 0, 0, 0, 0, 0, 
                   0, 0, 0, REC.BAN);
        ELSE
          UPDATE DB_LOADER_FULL_FINANCE_BILL FB
            SET FB.ABONKA = VAT*vABONKA, FB.CALLS = VAT*vCALLS, FB.SINGLE_PAYMENTS = VAT*vSINGLE_PAYMENTS, 
                FB.DISCOUNTS = VAT*vDISCOUNTS, FB.BILL_SUM = VAT*vBILL_SUM, FB.COMPLETE_BILL = 1
            WHERE FB.ACCOUNT_ID = vACCOUNT_ID
              AND FB.YEAR_MONTH = REC.YEAR_MONTH
              AND FB.PHONE_NUMBER = vPHONE_NUMBER
              AND NVL(FB.BAN,0) = NVL(REC.BAN, 0);
        END IF;
        CLOSE C;
      END IF;
    END LOOP;
    -- Детальная инфа по номеру, выбор номеров
    FOR details IN (SELECT VALUE(TA) VALUE_XML                        
                    FROM TABLE(XMLSequence(vX.extract('ECare_Ben_Summary_Str/ECare_Sub_Main_Str'))) TA )
    LOOP      
      -- Звонки                             
      vPHONES:=';';
      FOR calls IN (SELECT EXTRACTVALUE(VALUE(TA), 'ECare_Sub_UsageCharges/USAGE_SUMM_subscriber_no') PHONE_NUMBER,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_UsageCharges/USAGE_SUMM_intntl_actv_amt') CALLS_COUNTRY,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_UsageCharges/USAGE_SUMM_intcty_actv_amt') CALLS_SITY,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_UsageCharges/USAGE_SUMM_air_actv_amt') CALLS_LOCAL,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_UsageCharges/USAGE_SUMM_rpp_air_actv_amt') CALLS_RUS_RPP_amt,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_UsageCharges/USAGE_SUMM_sms_charges') CALLS_SMS_MMS,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_UsageCharges/USAGE_SUMM_gprs_charges') CALLS_GPRS,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_UsageCharges/USAGE_SUMM_rpp_charges') CALLS_RUS_RPP_charges,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_UsageCharges/SUBSCRIBER_TOTAL_total_subscriber_services') CALLS_ALL,
                           VALUE(TA) VALUE_XML                        
                      FROM TABLE(XMLSequence((details.VALUE_XML).extract('ECare_Sub_Main_Str/ECare_Sub_Charges/ECare_Sub_UsageCharges'))) TA )
      LOOP 
        vPHONE_NUMBER:=calls.PHONE_NUMBER;
        vCALLS_COUNTRY:=TO_NUM(calls.CALLS_COUNTRY);
        vCALLS_SITY:=TO_NUM(calls.CALLS_SITY);
        vCALLS_LOCAL:=TO_NUM(calls.CALLS_LOCAL);
        vCALLS_RUS_RPP:=TO_NUM(calls.CALLS_RUS_RPP_amt);
        vCALLS_SMS_MMS:=TO_NUM(calls.CALLS_SMS_MMS);
        vCALLS_GPRS:=TO_NUM(calls.CALLS_GPRS);
        vCALLS_RUS_RPP:=vCALLS_RUS_RPP + TO_NUM(calls.CALLS_RUS_RPP_charges);
        vCALLS_ALL:=TO_NUM(calls.CALLS_ALL);
    --DBMS_OUTPUT.PUT_LINE(vPHONE_NUMBER); DBMS_OUTPUT.PUT_LINE(vCALLS_COUNTRY); DBMS_OUTPUT.PUT_LINE(vCALLS_SITY); DBMS_OUTPUT.PUT_LINE(vCALLS_LOCAL);
    --DBMS_OUTPUT.PUT_LINE(vCALLS_SMS_MMS); DBMS_OUTPUT.PUT_LINE(vCALLS_GPRS); DBMS_OUTPUT.PUT_LINE(vCALLS_RUS_RPP); DBMS_OUTPUT.PUT_LINE(vCALLS_ALL);
        IF  (vPHONE_NUMBER IS NOT NULL) AND (vCALLS_COUNTRY IS NOT NULL) AND (vCALLS_SITY IS NOT NULL) AND (vCALLS_LOCAL IS NOT NULL) 
              AND (vCALLS_SMS_MMS IS NOT NULL) AND (vCALLS_GPRS IS NOT NULL) AND (vCALLS_GPRS IS NOT NULL) AND (vCALLS_ALL IS NOT NULL) THEN
          UPDATE DB_LOADER_FULL_FINANCE_BILL FB
            SET FB.CALLS_COUNTRY = VAT*vCALLS_COUNTRY, FB.CALLS_SITY = VAT*vCALLS_SITY, FB.CALLS_LOCAL = VAT*vCALLS_LOCAL, FB.CALLS_SMS_MMS = VAT*vCALLS_SMS_MMS, 
                FB.CALLS_GPRS = VAT*vCALLS_GPRS, FB.CALLS_RUS_RPP = VAT*vCALLS_RUS_RPP, FB.CALLS_ALL = VAT*vCALLS_ALL, FB.COMPLETE_BILL = 1
            WHERE FB.ACCOUNT_ID = vACCOUNT_ID
              AND FB.YEAR_MONTH = REC.YEAR_MONTH
              AND FB.PHONE_NUMBER = vPHONE_NUMBER
              AND NVL(FB.BAN,0) = NVL(REC.BAN, 0);
        END IF;
      end loop;
      -- Скидки
      vPHONES:=';';
      FOR disc IN (SELECT EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Discounts/SUMM_DISCOUNT_SUB_bill_comment') DISCOUNT_NAME,
                          EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Discounts/SUMM_DISCOUNT_SUB_discount_pct') DISCOUNT_PROCENT,
                          EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Discounts/SUMM_DISCOUNT_SUB_adjusted_amt') DISCOUNT_ZONE,
                          EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Discounts/SUMM_DISCOUNT_SUB_actv_amt') DISCOUNT_SUM,
                          EXTRACTVALUE(VALUE(TA), 'ECare_Sub_Discounts/SUBSCRIBER_TOTAL_discount_total_amt') DISCOUNT_TOTAL
                     FROM TABLE(XMLSequence((details.VALUE_XML).extract('ECare_Sub_Main_Str/ECare_Sub_Charges/ECare_Sub_Discounts'))) TA )
      LOOP
        SELECT EXTRACTVALUE(details.VALUE_XML, 'ECare_Sub_Main_Str/ECare_SubscriberInfo/CHG_subscriber_no') INTO vPHONE_NUMBER FROM DUAL;
        IF INSTR(vPHONES, vPHONE_NUMBER) = 0 THEN
          UPDATE DB_LOADER_FULL_FINANCE_BILL FB
            SET FB.DISCOUNT_YEAR = 0, FB.DISCOUNT_CALL = 0, FB.DISCOUNT_COUNT_ON_PHONES = 0, 
                FB.DISCOUNT_OTHERS = 0, FB.DISCOUNT_SMS_PLUS = 0, FB.DISCOUNT_SOVINTEL = 0
            WHERE FB.ACCOUNT_ID = vACCOUNT_ID
              AND FB.YEAR_MONTH = REC.YEAR_MONTH
              AND FB.PHONE_NUMBER = vPHONE_NUMBER
              AND NVL(FB.BAN,0) = NVL(REC.BAN, 0);
          vPHONES:=vPHONES || vPHONE_NUMBER || ';';
        END IF; 
        vDISCOUNT_TOTAL:=TO_NUM(disc.DISCOUNT_TOTAL); 
        vDISCOUNT_FLAG:=0;
        IF disc.DISCOUNT_NAME = 'Корректировка абонентской платы' THEN
          UPDATE DB_LOADER_FULL_FINANCE_BILL FB
            SET FB.DISCOUNT_YEAR = FB.DISCOUNT_YEAR + VAT*vDISCOUNT_TOTAL
            WHERE FB.ACCOUNT_ID = vACCOUNT_ID
              AND FB.YEAR_MONTH = REC.YEAR_MONTH
              AND FB.PHONE_NUMBER = vPHONE_NUMBER
              AND NVL(FB.BAN,0) = NVL(REC.BAN, 0); 
          vDISCOUNT_FLAG:=1;
        END IF;      
        IF vDISCOUNT_FLAG = 0 THEN
          UPDATE DB_LOADER_FULL_FINANCE_BILL FB
            SET FB.DISCOUNT_OTHERS = FB.DISCOUNT_OTHERS + VAT*vDISCOUNT_TOTAL
            WHERE FB.ACCOUNT_ID = vACCOUNT_ID
              AND FB.YEAR_MONTH = REC.YEAR_MONTH
              AND FB.PHONE_NUMBER = vPHONE_NUMBER
              AND NVL(FB.BAN,0) = NVL(REC.BAN, 0); 
        END IF;    
      END LOOP; 
      -- Абонент периоды      
      vPHONES:=';';
      FOR activ IN (SELECT EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RecurringCharges/SCHEDULED_SUMM_RC_subscriber_no') PHONE_NUMBER,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RecurringCharges/SCHEDULED_SUMM_RC_priod_cvrg_st_date') DATE_BEGIN,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RecurringCharges/SCHEDULED_SUMM_RC_priod_cvrg_nd_date') DATE_END,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RecurringCharges/SCHEDULED_SUMM_RC_rc_actv_amt') ABON_MAIN,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RecurringCharges/SCHEDULED_SUMM_RC_soc_rc_actv_amt') ABON_ADD,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RecurringCharges/SUBSCRIBER_TOTAL_total_subscriber') ABON_ALL,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RecurringCharges/SCHEDULED_SUMM_RC_soc') TARIFF_CODE
                      FROM TABLE(XMLSequence((details.VALUE_XML).extract('ECare_Sub_Main_Str/ECare_Sub_Charges/ECare_Sub_RecurringCharges'))) TA )
      LOOP
        vPHONE_NUMBER:=activ.PHONE_NUMBER;
        IF INSTR(vPHONES, activ.PHONE_NUMBER) = 0 THEN
          DELETE
            FROM DB_LOADER_FULL_BILL_ABON_PER AP
            WHERE AP.ACCOUNT_ID = vACCOUNT_ID
              AND AP.YEAR_MONTH = REC.YEAR_MONTH
              AND AP.PHONE_NUMBER = activ.PHONE_NUMBER
              AND NVL(AP.BAN,0) = NVL(REC.BAN, 0);
          vPHONES:=vPHONES || activ.PHONE_NUMBER || ';';
        END IF;
        vABON_MAIN:=TO_NUM(activ.ABON_MAIN);
        vABON_ADD:=TO_NUM(activ.ABON_ADD);
        vABON_ALL:=TO_NUM(activ.ABON_ALL);
        INSERT INTO DB_LOADER_FULL_BILL_ABON_PER(ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, 
                                                 DATE_BEGIN, DATE_END, 
                                                 TARIFF_CODE, ABON_MAIN, ABON_ADD, ABON_ALL, BAN)
          VALUES(vACCOUNT_ID, REC.YEAR_MONTH, activ.PHONE_NUMBER, 
                 TO_DATE(activ.DATE_BEGIN||'/'||TO_CHAR(TRUNC(REC.YEAR_MONTH/100)), 'DD/MM/YYYY'), 
                 TO_DATE(activ.DATE_END||'/'||TO_CHAR(TRUNC(REC.YEAR_MONTH/100)), 'DD/MM/YYYY'),
                 activ.TARIFF_CODE, VAT*vABON_MAIN, VAT*vABON_ADD, VAT*vABON_ALL, REC.BAN); 
         UPDATE DB_LOADER_FULL_FINANCE_BILL FB
            SET FB.ABON_MAIN = NVL((SELECT SUM(AP.ABON_MAIN)
                                      FROM DB_LOADER_FULL_BILL_ABON_PER AP
                                      WHERE AP.ACCOUNT_ID = FB.ACCOUNT_ID
                                        AND AP.YEAR_MONTH = FB.YEAR_MONTH
                                        AND AP.PHONE_NUMBER = FB.PHONE_NUMBER
                                        AND NVL(AP.BAN,0) = NVL(FB.BAN, 0)), 0), 
                FB.ABON_ADD = NVL((SELECT SUM(AP.ABON_ADD)
                                     FROM DB_LOADER_FULL_BILL_ABON_PER AP
                                     WHERE AP.ACCOUNT_ID = FB.ACCOUNT_ID
                                       AND AP.YEAR_MONTH = FB.YEAR_MONTH
                                       AND AP.PHONE_NUMBER = FB.PHONE_NUMBER
                                       AND NVL(AP.BAN,0) = NVL(FB.BAN, 0)), 0),  
                FB.COMPLETE_BILL = 1
            WHERE FB.ACCOUNT_ID = vACCOUNT_ID
              AND FB.YEAR_MONTH = REC.YEAR_MONTH
              AND FB.PHONE_NUMBER = vPHONE_NUMBER
              AND NVL(FB.BAN,0) = NVL(REC.BAN, 0);       
--DBMS_OUTPUT.PUT_LINE(activ.PHONE_NUMBER); DBMS_OUTPUT.PUT_LINE(activ.DATE_BEGIN); DBMS_OUTPUT.PUT_LINE(activ.DATE_END); DBMS_OUTPUT.PUT_LINE(vABON_MAIN);
--DBMS_OUTPUT.PUT_LINE(vABON_ADD); DBMS_OUTPUT.PUT_LINE(vABON_ALL); DBMS_OUTPUT.PUT_LINE(activ.TARIFF_CODE);
      END LOOP;
      -- Разовые начисления
      vPHONES:=';';
      FOR singl IN (SELECT EXTRACTVALUE(VALUE(TA), 'ECare_Sub_OneTimeCharges/ONE_TIME_CHARGE_subscriber_no') PHONE_NUMBER,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_OneTimeCharges/ONE_TIME_CHARGE_bill_text_summed') S_NAME,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_OneTimeCharges/ONE_TIME_CHARGE_ot_price') S_PRICE,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_OneTimeCharges/ONE_TIME_CHARGE_quantity_summed') S_QUNT,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_OneTimeCharges/ONE_TIME_CHARGE_ot_product') S_PRODUCT,
                           EXTRACTVALUE(VALUE(TA), 'ECare_Sub_OneTimeCharges/SUBSCRIBER_TOTAL_oc_total_amt_app') S_TOTAL
                      FROM TABLE(XMLSequence((details.VALUE_XML).extract('ECare_Sub_Main_Str/ECare_Sub_Charges/ECare_Sub_OneTimeCharges'))) TA
                    UNION ALL
                    SELECT EXTRACTVALUE(VALUE(TB), 'ECare_Sub_OneTimeChargesDetails/CHARGE_subscriber_no') PHONE_NUMBER,
                           EXTRACTVALUE(VALUE(TB), 'ECare_Sub_OneTimeChargesDetails/CHARGE_bill_text') S_NAME,
                           EXTRACTVALUE(VALUE(TB), 'ECare_Sub_OneTimeChargesDetails/CHARGE_actv_amt') S_PRICE,
                           EXTRACTVALUE(VALUE(TB), 'ECare_Sub_OneTimeChargesDetails/CHARGE_actv_amt') S_QUNT,
                           EXTRACTVALUE(VALUE(TB), 'ECare_Sub_OneTimeChargesDetails/CHARGE_actv_amt_1') S_PRODUCT,
                           EXTRACTVALUE(VALUE(TB), 'ECare_Sub_OneTimeChargesDetails/SUBSCRIBER_TOTAL_oc_total_amt_app') S_TOTAL
                      FROM TABLE(XMLSequence((details.VALUE_XML).extract('ECare_Sub_Main_Str/ECare_Sub_Charges/ECare_Sub_OneTimeChargesDetails'))) TB )
      LOOP
        vPHONE_NUMBER:=singl.PHONE_NUMBER;
        IF INSTR(vPHONES, singl.PHONE_NUMBER) = 0 THEN
          UPDATE DB_LOADER_FULL_FINANCE_BILL FB
            SET FB.SINGLE_MAIN = 0, FB.SINGLE_ADD = 0, FB.SINGLE_PENALTI = 0, FB.SINGLE_CHANGE_TARIFF = 0, FB.SINGLE_TURN_ON_SERV = 0, 
                FB.SINGLE_CORRECTION_ROUMING = 0, FB.SINGLE_INTRA_WEB = 0, FB.SINGLE_VIEW_BLACK_LIST = 0, FB.SINGLE_OTHER = 0
            WHERE FB.ACCOUNT_ID = vACCOUNT_ID
              AND FB.YEAR_MONTH = REC.YEAR_MONTH
              AND FB.PHONE_NUMBER = singl.PHONE_NUMBER
              AND NVL(FB.BAN,0) = NVL(REC.BAN, 0);
          vPHONES:=vPHONES || singl.PHONE_NUMBER || ';';
        END IF;
        vSINGLE_MAIN:=0; vSINGLE_ADD:=0; vSINGLE_PENALTI:=0; vSINGLE_CHANGE_TARIFF:=0; vSINGLE_TURN_ON_SERV:=0; 
        vSINGLE_CORRECTION_ROUMING:=0; vSINGLE_INTRA_WEB:=0; vSINGLE_VIEW_BLACK_LIST:=0; vSINGLE_OTHER:=0; 
        CASE
          WHEN singl.S_NAME = 'Абонентская плата по тарифному плану' THEN vSINGLE_MAIN:=TO_NUM(singl.S_TOTAL); 
          WHEN singl.S_NAME = 'Абонентская плата за дополнительные услуги' then vSINGLE_ADD:=to_num(singl.S_TOTAL);
          WHEN (singl.S_NAME = 'Подключение услуги')and(singl.S_TOTAL='42.37') THEN vSINGLE_INTRA_WEB:=TO_NUM(singl.S_TOTAL);
          WHEN singl.S_NAME = 'Цена перехода 423.73'  THEN vSINGLE_CHANGE_TARIFF:=TO_NUM(singl.S_TOTAL); -- Плата за смену ТП 
          ELSE vSINGLE_OTHER:=TO_NUM(singl.S_TOTAL);
        END CASE;
        UPDATE DB_LOADER_FULL_FINANCE_BILL FB
          SET FB.SINGLE_MAIN = FB.SINGLE_MAIN + VAT*vSINGLE_MAIN, FB.SINGLE_ADD = FB.SINGLE_ADD + VAT*vSINGLE_ADD, 
              FB.SINGLE_PENALTI = FB.SINGLE_PENALTI + VAT*vSINGLE_PENALTI, FB.SINGLE_CHANGE_TARIFF = FB.SINGLE_CHANGE_TARIFF + VAT*vSINGLE_CHANGE_TARIFF, 
              FB.SINGLE_TURN_ON_SERV = FB.SINGLE_TURN_ON_SERV + VAT*vSINGLE_TURN_ON_SERV, FB.SINGLE_CORRECTION_ROUMING = FB.SINGLE_CORRECTION_ROUMING + VAT*vSINGLE_CORRECTION_ROUMING, 
              FB.SINGLE_INTRA_WEB = FB.SINGLE_INTRA_WEB + VAT*vSINGLE_INTRA_WEB, FB.SINGLE_VIEW_BLACK_LIST = FB.SINGLE_VIEW_BLACK_LIST + VAT*vSINGLE_VIEW_BLACK_LIST, 
              FB.SINGLE_OTHER = FB.SINGLE_OTHER + VAT*vSINGLE_OTHER, FB.COMPLETE_BILL = 1
          WHERE FB.ACCOUNT_ID = vACCOUNT_ID
            AND FB.YEAR_MONTH = REC.YEAR_MONTH
            AND FB.PHONE_NUMBER = vPHONE_NUMBER
            AND NVL(FB.BAN,0) = NVL(REC.BAN, 0); 
--DBMS_OUTPUT.PUT_LINE(singl.PHONE_NUMBER); DBMS_OUTPUT.PUT_LINE(singl.S_NAME); DBMS_OUTPUT.PUT_LINE(singl.S_PRICE); 
--DBMS_OUTPUT.PUT_LINE(singl.S_QUNT); DBMS_OUTPUT.PUT_LINE(singl.S_PRODUCT); DBMS_OUTPUT.PUT_LINE(singl.S_TOTAL);
--DBMS_OUTPUT.PUT_LINE(vSINGLE_MAIN||'~'||vSINGLE_ADD||'~'||vSINGLE_PENALTI||'~'|| vSINGLE_CHANGE_TARIFF||'~'|| vSINGLE_TURN_ON_SERV||'~'|| vSINGLE_CORRECTION_ROUMING||'~'||vSINGLE_INTRA_WEB||'~'|| vSINGLE_VIEW_BLACK_LIST||'~'||vSINGLE_OTHER);
      END LOOP; 
      -- Международный роуминг
      vPHONES:=';';
      FOR introum IN (SELECT EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingIntCharges/SUMM_ROAMING_ZONE_subscriber_no') PHONE_NUMBER,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingIntCharges/SUMM_ROAMING_ZONE_priod_cvrg_st_date') DATE_BEGIN,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingIntCharges/SUMM_ROAMING_ZONE_priod_cvrg_nd_date') DATE_END,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingIntCharges/SUMM_ROAMING_ZONE_provider_desc') ROUMING_COUNTRY,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingIntCharges/SUMM_ROAMING_ZONE_r_gsm_air_zone_actv_amt') ROUMING_CALLS,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingIntCharges/SUMM_ROAMING_ZONE_r_gsm_sms_zone_actv_amt') ROUMING_SMS,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingIntCharges/SUMM_ROAMING_ZONE_r_gsm_gprs_zone_actv_amt') ROUMING_GPRS,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingIntCharges/SUBSCRIBER_TOTAL_gsm_total_subscriber') ROUMING_SUM
                        FROM TABLE(XMLSequence((details.VALUE_XML).extract('ECare_Sub_Main_Str/ECare_Sub_Charges/ECare_Sub_RoamingIntCharges'))) TA )
      LOOP
        vPHONE_NUMBER:=introum.PHONE_NUMBER;
        IF INSTR(vPHONES, introum.PHONE_NUMBER) = 0 THEN
          DELETE
            FROM DB_LOADER_FULL_BILL_MN_ROUMING MN
            WHERE MN.ACCOUNT_ID = vACCOUNT_ID
              AND MN.YEAR_MONTH = REC.YEAR_MONTH
              AND MN.PHONE_NUMBER = introum.PHONE_NUMBER
              AND NVL(MN.BAN,0) = NVL(REC.BAN, 0);
          vPHONES:=vPHONES || introum.PHONE_NUMBER || ';';
        END IF;
        vROUMING_CALLS:=TO_NUM(introum.ROUMING_CALLS);
        vROUMING_SMS:=TO_NUM(introum.ROUMING_SMS);
        vROUMING_GPRS:=TO_NUM(introum.ROUMING_GPRS);
        vROUMING_SUM:=TO_NUM(introum.ROUMING_SUM);
        INSERT INTO DB_LOADER_FULL_BILL_MN_ROUMING(ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, 
                                                   DATE_BEGIN, DATE_END, ROUMING_COUNTRY, 
                                                   ROUMING_CALLS, ROUMING_GPRS, ROUMING_SMS, COMPANY_TAX, ROUMING_SUM, BAN)
          VALUES(vACCOUNT_ID, REC.YEAR_MONTH, introum.PHONE_NUMBER, 
                 TO_DATE(introum.DATE_BEGIN||'/'||TO_CHAR(TRUNC(REC.YEAR_MONTH/100)), 'DD/MM/YYYY'), 
                 TO_DATE(introum.DATE_END||'/'||TO_CHAR(TRUNC(REC.YEAR_MONTH/100)), 'DD/MM/YYYY'), introum.ROUMING_COUNTRY, 
                 VAT*vROUMING_CALLS, VAT*vROUMING_GPRS, VAT*vROUMING_SMS, 0, VAT*vROUMING_SUM, REC.BAN); 
         UPDATE DB_LOADER_FULL_FINANCE_BILL FB
            SET FB.ROUMING_INTERNATIONAL = NVL((SELECT SUM(MN.ROUMING_SUM)
                                                  FROM DB_LOADER_FULL_BILL_MN_ROUMING MN
                                                  WHERE MN.ACCOUNT_ID = FB.ACCOUNT_ID
                                                    AND MN.YEAR_MONTH = FB.YEAR_MONTH
                                                    AND MN.PHONE_NUMBER = FB.PHONE_NUMBER), 0),  
                FB.COMPLETE_BILL = 1
            WHERE FB.ACCOUNT_ID = vACCOUNT_ID
              AND FB.YEAR_MONTH = REC.YEAR_MONTH
              AND FB.PHONE_NUMBER = vPHONE_NUMBER
              AND NVL(FB.BAN,0) = NVL(REC.BAN, 0);
      END LOOP;   
      -- Национальный роуминг
      vPHONES:=';';
      FOR natroum IN (SELECT EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingNatCharges/SUMM_ROAMING_subscriber_no') PHONE_NUMBER,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingNatCharges/SUMM_ROAMING_priod_cvrg_st_date') DATE_BEGIN,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingNatCharges/SUMM_ROAMING_priod_cvrg_nd_date') DATE_END,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingNatCharges/SUMM_ROAMING_provider_desc') ROUMING_COUNTRY,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingNatCharges/SUMM_ROAMING_r_gsm_local_actv_amt') ROUMING_CALLS,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingNatCharges/SUMM_ROAMING_r_gsm_sms_actv_amt') ROUMING_SMS,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingNatCharges/SUMM_ROAMING_r_gsm_gprs_actv_amt') ROUMING_GPRS,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingNatCharges/SUMM_ROAMING_r_gsm_server_actv_amt') COMPANY_TAX,
                             EXTRACTVALUE(VALUE(TA), 'ECare_Sub_RoamingNatCharges/SUBSCRIBER_TOTAL_gsm_total_subscriber') ROUMING_SUM
                        FROM TABLE(XMLSequence((details.VALUE_XML).extract('ECare_Sub_Main_Str/ECare_Sub_Charges/ECare_Sub_RoamingNatCharges'))) TA )
      LOOP
        vPHONE_NUMBER:=natroum.PHONE_NUMBER;
        IF INSTR(vPHONES, natroum.PHONE_NUMBER) = 0 THEN
          DELETE
            FROM DB_LOADER_FULL_BILL_MG_ROUMING MN
            WHERE MN.ACCOUNT_ID = vACCOUNT_ID
              AND MN.YEAR_MONTH = REC.YEAR_MONTH
              AND MN.PHONE_NUMBER = natroum.PHONE_NUMBER
              AND NVL(MN.BAN,0) = NVL(REC.BAN, 0);
          vPHONES:=vPHONES || natroum.PHONE_NUMBER || ';';
        END IF;
        vROUMING_CALLS:=TO_NUM(natroum.ROUMING_CALLS);
        vROUMING_SMS:=TO_NUM(natroum.ROUMING_SMS);
        vROUMING_GPRS:=TO_NUM(natroum.ROUMING_GPRS);
        vCOMPANY_TAX:=TO_NUM(natroum.COMPANY_TAX);
        vROUMING_SUM:=TO_NUM(natroum.ROUMING_SUM); 
        INSERT INTO DB_LOADER_FULL_BILL_MG_ROUMING(ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, 
                                                   DATE_BEGIN, DATE_END, ROUMING_COUNTRY, 
                                                   ROUMING_CALLS, ROUMING_GPRS, ROUMING_SMS, COMPANY_TAX, ROUMING_SUM, BAN)
          VALUES(vACCOUNT_ID, REC.YEAR_MONTH, natroum.PHONE_NUMBER, 
                 TO_DATE(natroum.DATE_BEGIN||'/'||TO_CHAR(TRUNC(REC.YEAR_MONTH/100)), 'DD/MM/YYYY'), 
                 TO_DATE(natroum.DATE_END||'/'||TO_CHAR(TRUNC(REC.YEAR_MONTH/100)), 'DD/MM/YYYY'), natroum.ROUMING_COUNTRY, 
                 VAT*vROUMING_CALLS, VAT*vROUMING_GPRS, VAT*vROUMING_SMS, VAT*vCOMPANY_TAX, VAT*vROUMING_SUM, REC.BAN); 
         UPDATE DB_LOADER_FULL_FINANCE_BILL FB
            SET FB.ROUMING_NATIONAL = NVL((SELECT SUM(MN.ROUMING_SUM)
                                             FROM DB_LOADER_FULL_BILL_MG_ROUMING MN
                                             WHERE MN.ACCOUNT_ID = FB.ACCOUNT_ID
                                               AND MN.YEAR_MONTH = FB.YEAR_MONTH
                                               AND MN.PHONE_NUMBER = FB.PHONE_NUMBER), 0),  
                FB.COMPLETE_BILL = 1
            WHERE FB.ACCOUNT_ID = vACCOUNT_ID
              AND FB.YEAR_MONTH = REC.YEAR_MONTH
              AND FB.PHONE_NUMBER = vPHONE_NUMBER
              AND NVL(FB.BAN,0) = NVL(REC.BAN, 0);
      END LOOP;    
    END LOOP;  
    UPDATE COLLECTOR_BILL_XML C
      SET C.XML_CHECKED = 1
      WHERE C.FILE_ID = REC.FILE_ID;
    COMMIT;
  END LOOP;  
END; 