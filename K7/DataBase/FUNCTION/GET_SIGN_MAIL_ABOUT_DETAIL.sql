CREATE OR REPLACE FUNCTION GET_SIGN_MAIL_ABOUT_DETAIL(pPhoneNumber in varchar2) 
return varchar2 as
--
--#Version=1
--
--v.1 ������� - 05,06,2015 - ������� ������� ������������ ������� � ������ ���  �������� ������ � ����� ���.�� ��������� ������ "�����������". ������ ��������� �� �����' 
--
--
  sign_text varchar2(500);
begin

  sign_text := '';
 
  if nvl(GET_IS_COLLECTOR_BY_PHONE (pPhoneNumber), 0) = 0 then
    sign_text := MS_PARAMS.GET_PARAM_VALUE('SIGNATURE_MAIL_ABOUT_DETAIL_K7');
  else
    sign_text := MS_PARAMS.GET_PARAM_VALUE('SIGNATURE_MAIL_ABOUT_DETAIL_TELETIE');
  end if; 
  RETURN sign_text;
end;

GRANT EXECUTE on GET_SIGN_MAIL_ABOUT_DETAIL to CORP_MOBILE_ROLE;
GRANT EXECUTE on GET_SIGN_MAIL_ABOUT_DETAIL to CORP_MOBILE_ROLE_RO;

