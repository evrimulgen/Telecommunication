create or replace package APP_ERR is

  -- # 1.01
  -- v. 1.01, S.ISCHEYKIN, 12.02.2016, ������� ������ -20996, -20995, �������� ��� ���� ������
  -- v. 1.00, S.ISCHEYKIN, 09.02.2016, ����������� ������ ��� ������������ ���������� � ����������� (���������� ����, ����� ���������� � ����� ���������-������ ������)

  -- ! ������������ �������� ����� �� -20999 �� -20100
  invalid_account_num CONSTANT NUMBER := -20999; -- ������������ account_id
  invalid_account EXCEPTION;
  PRAGMA EXCEPTION_INIT (invalid_account, -20999);
  invalid_filial_num CONSTANT NUMBER := -20998; -- ������������ �������� filial_id ���������
  invalid_filial EXCEPTION;
  PRAGMA EXCEPTION_INIT (invalid_filial, -20998);
  api_unknown_filial_num CONSTANT NUMBER := -20997; -- filial_id ��������� �� ��������� � API_PKG
  api_unknown_filial EXCEPTION;
  PRAGMA EXCEPTION_INIT (api_unknown_filial, -20997);
  invalid_operator_num CONSTANT NUMBER := -20996; -- ������������ �������� mobile_operator_name_id ���������
  invalid_operator EXCEPTION;
  PRAGMA EXCEPTION_INIT (invalid_operator, -20996);
  api_unknown_operator_num CONSTANT NUMBER := -20995; -- mobile_operator_name_id �� ��������� � API_PKG
  api_unknown_operator EXCEPTION;
  PRAGMA EXCEPTION_INIT (api_unknown_operator, -20995);
  null_url_num CONSTANT NUMBER := -20994; -- ������ ������ (URL)
  null_url EXCEPTION;
  PRAGMA EXCEPTION_INIT (null_url, -20994);

end APP_ERR;
/
