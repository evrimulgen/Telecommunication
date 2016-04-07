--�������� ���������� ����� ������� ���������� 16.01.2013

CREATE OR REPLACE FORCE VIEW V_CHECK_TARIFF_ID
AS
   SELECT PHONE_NUMBER_FEDERAL,
          GET_CURR_PHONE_TARIFF_ID (PHONE_NUMBER_FEDERAL)
             GET_CURR_PHONE_TARIFF_ID_NEW,
          GET_PHONE_TARIFF_ID (PHONE_NUMBER_FEDERAL,
                               (SELECT TARIFF_CODE
                                  FROM TARIFFS T
                                 WHERE T.TARIFF_ID = C.TARIFF_ID),
                               SYSDATE)
             GET_CURR_PHONE_TARIFF_ID_OLD
     FROM V_CONTRACTS C WHERE CONTRACT_CANCEL_DATE IS NULL;