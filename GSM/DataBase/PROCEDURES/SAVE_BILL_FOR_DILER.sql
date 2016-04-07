--#IF GETVERSION("SAVE_BILL_FOR_DILER") < 2 THEN
CREATE OR REPLACE PROCEDURE SAVE_BILL_FOR_DILER(
  pYEAR_MONTH IN INTEGER
  ) IS
--#Version=2
-- ����������(��������) ��������� ������ �� �����
begin
  for recNumber in(
    SELECT CONTRACTS.PHONE_NUMBER_FEDERAL
      FROM CONTRACTS
      GROUP BY CONTRACTS.PHONE_NUMBER_FEDERAL
                  )
  loop
    for rec in(
      select V.*
        from V_BILL_FOR_DILER V
        where V.YEAR_MONTH<=pYEAR_MONTH
          and v.PHONE_NUMBER = recNumber.PHONE_NUMBER_FEDERAL
          --and v.PHONE_NUMBER = '9623630138'
          AND NOT EXISTS (SELECT 1
                            FROM BILL_FOR_DILER_SAVED BS
                            WHERE BS.ACCOUNT_ID = V.ACCOUNT_ID
                              AND BS.YEAR_MONTH = V.YEAR_MONTH
                              AND BS.PHONE_NUMBER = V.PHONE_NUMBER)
      order by V.YEAR_MONTH asc                      
          )
    loop
      insert into BILL_FOR_DILER_SAVED(
          ACCOUNT_ID, YEAR_MONTH, PHONE_NUMBER, BILL_SUM_ORIGIN, BILL_SUM, 
          DISCOUNT_VALUE, DILER_PAYMENT, DILER_PAYMENT_FULL, 
          SUBSCRIBER_PAYMENT_NEW, SUBSCRIBER_PAYMENT_OLD, SUBSCRIBER_PAYMENT_ADD_OLD,
          OPTION_COST_DILER, OPTION_COST_DILER_BEELINE, OPTION_COST_FULL, 
          TARIFF_NAME, TAIL, CHECK_LONG_PLUS_BALANCE, 
          INSTALLMENT_PAYMENT_SUM, DILER_SUMM_OLD_MONTH_IN_MINUS)
        values(
          rec.ACCOUNT_ID, rec.YEAR_MONTH, rec.PHONE_NUMBER, rec.BILL_SUM_ORIGIN, rec.BILL_SUM, 
          rec.DISCOUNT_VALUE, rec.DILER_PAYMENT, rec.DILER_PAYMENT_FULL, 
          rec.SUBSCRIBER_PAYMENT_NEW, rec.SUBSCRIBER_PAYMENT_OLD, rec.SUBSCRIBER_PAYMENT_ADD_OLD,
          rec.OPTION_COST_DILER, rec.OPTION_COST_DILER_BEELINE, rec.OPTION_COST_FULL, 
          NVL(rec.TARIFF_NAME, '����� �� ������'), rec.TAIL, rec.CHECK_LONG_PLUS_BALANCE, 
          0, 0);
      commit;
    end loop;
  end loop;
  UPDATE BILL_FOR_DILER_SAVED DS
    SET DS.INSTALLMENT_PAYMENT_SUM = -1
    WHERE DS.YEAR_MONTH = pYEAR_MONTH
      AND DS.PHONE_NUMBER IN (SELECT C.PHONE_NUMBER_FEDERAL
                                FROM CONTRACTS C
                                WHERE C.INSTALLMENT_PAYMENT_DATE IS NOT NULL
                                  AND NOT EXISTS (SELECT 1
                                                    FROM CONTRACT_CANCELS CC
                                                    WHERE CC.CONTRACT_ID = C.CONTRACT_ID))
end;

--#end if