CREATE OR REPLACE VIEW V_ABON_PAYMENT_BY_PHONES_YEAR2 AS
SELECT
--#Version=1
--
-- ������������ ��������� ��� �������� � ������� ������� ��������� � �������� �� �������.
-- � ����� PAYMENT_01 - PAYMENT_12 �������� ���������� �� ������, ������� � �.�.
-- � ���� BALANCE ������� ������� ������ ��������.
-- � ���� PROFIT_FOR_YEAR �������� ���������� �� ���.
--
  V_ABON_PAYMENT_BY_PHONES_YEAR.*,
  V_PROFIT_BY_PHONES_YEAR.PROFIT_FOR_YEAR
FROM
  V_ABON_PAYMENT_BY_PHONES_YEAR,
  V_PROFIT_BY_PHONES_YEAR
WHERE 
  V_ABON_PAYMENT_BY_PHONES_YEAR.PHONE_NUMBER=V_PROFIT_BY_PHONES_YEAR.PHONE_NUMBER
  AND V_ABON_PAYMENT_BY_PHONES_YEAR.BILL_YEAR=V_PROFIT_BY_PHONES_YEAR.BILL_YEAR
/