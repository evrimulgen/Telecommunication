CREATE OR REPLACE PROCEDURE WWW_DEALER.DO_LOAD_FROM_1C(pRESOURCE_TYPE VARCHAR2 DEFAULT NULL) IS
--#VERSION=2. 
--v2 - 04.08.2015 - ������� �. ��������� �������� ��� ����� ������
BEGIN
  IF pRESOURCE_TYPE = 'PHONE_NUMBERS' THEN
    LOAD_1C.RELOAD_PHONE_NUMBERS;
    HTP.PRINT('������ ��������� �� ����������� ������ ��������� �������.');
  ELSIF pRESOURCE_TYPE = 'CONTRAGENTS' THEN
    LOAD_1C.RELOAD_CONTRAGENTS;
    HTP.PRINT('������ ������������ �������� �������.');
  ELSIF pRESOURCE_TYPE = 'ACTIVATIONS' THEN
    LOAD_1C.RELOAD_ACTIVATIONS;
    HTP.PRINT('�������������� ������ ��������� �������.');
  ELSIF pRESOURCE_TYPE = 'BONUSES' THEN
    LOAD_1C.RELOAD_BONUSES;
    HTP.PRINT('������ ��������� �������.');
  ELSIF pRESOURCE_TYPE = 'CONTRAGENT_RESTS' THEN
    LOAD_1C.RELOAD_CONTRAGENT_RESTS;
    HTP.PRINT('������� �� ������� ������������ ��������� �������.');
  ELSIF pRESOURCE_TYPE = 'BALANCE_CHANGES' THEN
    LOAD_1C.RELOAD_BALANCE_CHANGES;
    HTP.PRINT('��������� ������� ������������ ��������� �������.');
  ELSIF pRESOURCE_TYPE = 'PHONE_RETURNS' THEN
    LOAD_1C.RELOAD_PHONE_RETURNS;
    HTP.PRINT('������� �� ������� ������������ ������� ���������.');
  ELSIF pRESOURCE_TYPE = 'TARIFF_CHANGE_RULES' THEN 
    LOAD_1C.RELOAD_TARIFF_CHANGE_RULES;
    HTP.PRINT('������� ��������� ������� ������� ���������.');
  ELSIF pRESOURCE_TYPE = 'CONTRAGENT_PERCENTS' THEN
    LOAD_1C.RELOAD_CONTRAGENT_PERCENTS;
    HTP.PRINT('�������� ������������ ������� ���������.');
  ELSIF pRESOURCE_TYPE = 'TARIFF_PERCENTS' THEN 
    LOAD_1C.RELOAD_CONTR_TARIFF_PERCENTS;
    HTP.PRINT('�������� �� ������� ������� ���������.');
  ELSIF pRESOURCE_TYPE = 'CONTR_TARIFF_PERCENTS' THEN 
    LOAD_1C.RELOAD_CONTR_TARIFF_PERCENTS;
    HTP.PRINT('�������� ������������ �� ������� ������� ���������.');    
  ELSE
    HTP.PRINT('�������� �� 1� �� �������. ��� �������� �� �������������� "'||pRESOURCE_TYPE||'".');
  END IF;
EXCEPTION WHEN OTHERS THEN
  HTP.PRINT('������ �������� �� 1�.'||CHR(13)||CHR(10)||dbms_utility.format_error_stack ||CHR(13)||CHR(10)|| dbms_utility.format_error_backtrace);
END;
/
