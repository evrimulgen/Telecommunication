create or replace function get_last_options_update(pphone_number in varchar2) return date is
            Result date; --���� ���������� ���������� �����
          begin
            select max(po.last_check_date_time) into result
            from db_loader_account_phone_opts po
            where po.phone_number=pphone_number and po.year_month=to_char(sysdate,'YYYYMM');
            return(result);
          exception
            when others then
            return(Result);
          end get_last_options_update;
/
