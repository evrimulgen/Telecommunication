CREATE OR REPLACE function HOT_BILLING_GET_RETARIFFING(
  CALL_ROW IN CALL_TYPE, pcost_koef IN number
  ) return CALL_TYPE IS
--
-- ��������������� ������ �����������
--
--     !!!!    ������ ��� �7      !!!!!!!!
--
--#Version=5
--
-- 5. 09.06.2015 ������� ������� ������ � HOT_BILLING_RECALC_ROW_P�KG.HOT_BILLING_GET_RETARIFFING
-- 4. 28.07.2014 ������. ��������� ���������� ��������
-- 3. 27.07.2014 ������. � �������� �������� ����� � ���������, � ������������� ���������.
--
  RESULT CALL_TYPE;
BEGIN
  RESULT := HOT_BILLING_RECALC_ROW_P�KG.HOT_BILLING_GET_RETARIFFING(CALL_ROW, pcost_koef);
  RETURN(RESULT);
END;
/