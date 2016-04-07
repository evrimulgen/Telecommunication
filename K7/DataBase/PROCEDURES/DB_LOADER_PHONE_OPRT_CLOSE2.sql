--#if GetVersion("DB_LOADER_PHONE_OPRT_CLOSE2") < 2 then
CREATE OR REPLACE PROCEDURE DB_LOADER_PHONE_OPRT_CLOSE2(pYEAR         IN INTEGER,
                                                        pMONTH        IN INTEGER,
                                                        pPHONE_NUMBER IN VARCHAR2) IS
--#Version=3 
--#Version=3 - ����������� ��� ������ �������� �������, ������� �� ���������� ��� ���������� ������
--1 ��������� ��������� ������������ ���� �������� (� ������� DB_LOADER_ACCOUNT_PHONE_OPTS) ������ ��� ���������� ���� ��������� � ������� ����� �� ������ � ����� ������� �����
--2 24.09.2013 ������ ������� �� Account_id �  option_parameters � ����������� ����� ����� 
  vYEAR_MONTH BINARY_INTEGER;
begin
  vYEAR_MONTH := pYEAR * 100 + pMONTH;
  for vrec in (select z.option_code, z.option_name, z.turn_on_date date_on,trunc(z.last_check_date_time) as turn_off_date    
                 from DB_LOADER_ACCOUNT_PHONE_OPTS z 
                 where z.phone_number = pPHONE_NUMBER
                   and year_month=vYEAR_MONTH
                   and z.turn_off_date is null
                   and not exists (select 1 
                                     from (select max(trunc(a.last_check_date_time)) last_check_date_time 
                                             from DB_LOADER_ACCOUNT_PHONE_OPTS a 
                                             where a.phone_number = pPHONE_NUMBER
                                               and a.year_month = vYEAR_MONTH 
                                               and a.turn_off_date is null) v
                                             where v.last_check_date_time=trunc(z.last_check_date_time)))  
  loop
    update DB_LOADER_ACCOUNT_PHONE_OPTS
      -- set turn_off_date = vREC.date_on
      set turn_off_date = vREC.turn_off_date
      where phone_number = pPHONE_NUMBER
        and year_month = vYEAR_MONTH
        and NVL(turn_off_date, SYSDATE + 1) > SYSDATE
        --and account_id=vrec.account_id
        and option_code = vrec.option_code
        --and nvl(option_parameters,'-1')=nvl(vrec.option_parameters,'-1')
        and turn_on_date = vrec.date_on;
     commit;
  end loop;
end;
/
--#end if

--CREATE SYNONYM CORP_MOBILE_DB_LOADER.DB_LOADER_PHONE_OPRT_CLOSE2 FOR DB_LOADER_PHONE_OPRT_CLOSE2;

--GRANT EXECUTE ON DB_LOADER_PHONE_OPRT_CLOSE2 TO CORP_MOBILE_DB_LOADER;
