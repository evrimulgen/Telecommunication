create or replace package API_PKG is

  -- # 1
  -- v.1, 05.02.2016, ������ API ��� ������ � ������� �����������

  -- ����� SIM-�����
  function CHANGE_SIM_NUMBER(pPhoneNumber  in varchar2,
                             pNewSimNumber in varchar2,
                             pNewPuk       varchar2) return varchar2;

end API_PKG;
/
create or replace package body API_PKG is

  -- ��������� ��������� - �������������� ���������� �� ������� mobile_operator_names 
  MEGAFON constant integer := 41;
  NA_OPERATOR constant integer := 31;
  -- ���������, ������������ API
  API_Result varchar2(1024); 
  -- �������� �������� � �������� ������� �������
  p_operator_id number;
  p_filial_id number;
  p_account_id number;
  p_phone_id number;

  -- ����������� ��������� ��������
  function ABON_ATTRIB_DEF(pPhoneNumber in varchar2) return varchar2 is
  
  begin
    --���������� �������� �������� 
    select f.mobile_operator_name_id, f.filial_id, a.account_id, p.phone_id
      into p_operator_id, p_filial_id, p_account_id, p_phone_id
      from phones p
      join phone_on_accounts poa on poa.phone_id = p.phone_id
      join accounts a on a.account_id = poa.account_id
      join filials  f on f.filial_id = a.filial_id 
      where p.phone_number = pPhoneNumber;
    if p_operator_id is null then
      raise app_err.invalid_operator;
    end if;
    return 'ok';
  exception
    when no_data_found then
      return 'Err: ' || SQLERRM;
    when app_err.invalid_operator then
      return 'Err: ' || app_err.invalid_operator_num || ' ������������ �������� mobile_operator_name.mobile_operator_name_id';
  end ABON_ATTRIB_DEF;
  
  -- ������ SIM-�����
  function CHANGE_SIM_NUMBER(pPhoneNumber  in varchar2,
                             pNewSimNumber in varchar2,
                             pNewPuk       varchar2) return varchar2 is
    
  begin
    API_Result := ABON_ATTRIB_DEF(pPhoneNumber); 
    if API_Result = 'ok' then
      -- �������� �-�� ������ SIM-����� �� ������ ��� ����������� ���������
      case p_operator_id
        when MEGAFON then
          API_Result := megafon_pkg.change_sim_number(p_phone_id, pNewSimNumber, pNewPuk);
        when NA_OPERATOR then
          -- ��������
          API_Result := 'NA_OPERATOR';  
        else
          API_Result := ' mobile_operator_name_id = '|| p_operator_id ||' �� �������������� � API_PKG';  
          raise app_err.api_unknown_operator;
      end case;
    end if;  
    return API_Result;
    exception
    when app_err.api_unknown_operator then
      return 'Err: ' || app_err.api_unknown_operator_num || API_Result;
    when others then
      return 'Err: ' || SQLERRM;
  end CHANGE_SIM_NUMBER;

end API_PKG;
/
