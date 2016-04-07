CREATE OR REPLACE PROCEDURE SEND_REST_TABLE AS
--
--Version=3
--
--v.3 ������� 12.03.2015 - ��� ����������� ������� ���������� ���������'������������ ������� ���'
--                        ��� ���������� ������� ��� ����������� INTERNET,���� ����������� ����� ����� ������� is_auto_internet = 1
--v.2 ������� 25.02.2015 - ��������� ���������� ������ ��������� � ������� MSK1000_F
--v.1 ������� 20.02.2015 - ������� ���������
--
CURSOR phones is
  select PHONE_NUMBER from USSD_TARIFF_REST_QUEUE;

C_CELL_PLAN_CODE  CONSTANT  VARCHAR2(9) := 'MSK1000_F'; 

res VARCHAR2(1000);
--======������ ����������===================
--������� �������� ������ ������������� ����� - ������������� �����
del_str boolean;

--������� �������� ��������� ������� � ��������� IS_AUTO_INTERNET
del_auto_internet boolean;

--======����� ������ ����������===================
tar_count Integer; 


BEGIN

    
  for ph in phones loop
    del_str := false;
    del_auto_internet := false;
    tar_count := 0;
    
    --�������� �� ������������� ���� � �����  C_CELL_PLAN_CODE
    if GET_IS_COLLECTOR_BY_PHONE(ph.phone_number) = 1 then
      --������� �������� ������ ������������� ����� - ������������� �����
      select 
        count(CELL_PLAN_CODE) into tar_count
        from db_loader_account_phones
             where year_month = to_number(to_char(sysdate, 'yyyymm'))
                and phone_number = ph.phone_number
                and CELL_PLAN_CODE = C_CELL_PLAN_CODE;
      if nvl(tar_count, 0) > 0 then
        del_str := TRUE;
      end if;
      --������� �������� ��������� ������� � ��������� IS_AUTO_INTERNET
      select count(*) into tar_count 
          from tariffs
          where is_auto_internet = 1
          and tariff_id = GET_CURR_PHONE_TARIFF_ID(ph.phone_number);
      if nvl(tar_count, 0) > 0 then
        del_auto_internet := TRUE;
      end if;
       
    end if; 
    
    

    res := null;
    
    for c in (
          select 
          --SOC_NAME,  -- ������
          REST_NAME,
          
          case 
            when CURR_VALUE < 0 then 0
            else
              CURR_VALUE
          end       
          
          ||
          
          CASE UPPER(UNIT_TYPE)
                when 'INTERNET' then '��;'
                when 'SMS_MMS' then '��.;'
                when 'VOICE' then '���.;'
              else
                  ''
              end CURR_VALUE, --�������,
          UPPER(UNIT_TYPE) UNIT_TYPE
              
          from table (TARIFF_RESTS_TABLE(ph.phone_number))
        ) loop
        
      if (del_str AND UPPER(C.REST_NAME) = '������������� ����� ������')
         OR
         (del_auto_internet and C.UNIT_TYPE = 'INTERNET') then
        NULL;
      else
        res := res ||c.REST_NAME||' - '||c.CURR_VALUE||chr(13);
      end if;
      
    end loop;
    
    if nvl(res, '-1') = '-1' then
      res := '������������ ������� ���';
    else
      res := '�������:'||chr(13)||res;
    end if;
    
    res := LOADER3_PCKG.SEND_SMS(ph.phone_number, '������� �� �������', res );
    
    delete from USSD_TARIFF_REST_QUEUE where PHONE_NUMBER =ph.phone_number;
    commit;
  end loop;
END;
/