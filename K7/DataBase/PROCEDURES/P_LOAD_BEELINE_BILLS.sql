CREATE OR REPLACE procedure P_LOAD_BEELINE_BILLS(Paccount_id in number) is
--��� ����������� ���� ��������
  type T_LOAD_LOG is record (lvl varchar2(50)
                            ,CMT varchar2(50)
                            ,ERR VARCHAR2(100));
  type TLOAD_LOG is table of T_LOAD_LOG INDEX BY binary_integer;
  Load_log TLOAD_LOG;
  LLR integer:=0;--LOAD_LOG_RECORD - ��������� �� ������ � TLOAD_LOG
  LOG_EXCEPTION exception;
--
BillPeriod integer; bills_count integer; bills_lyambda integer;--������,���������� ������,���������� �� ������������
Bills_NF boolean default FAlse;
Ncount integer:=0;
XML_file_id varchar2(500);
obj_id integer;--����� ������� � ��.
pack_i integer:=0;--���������� ������������� ����� �������� �������
pack_size integer:=5;--25;-- ������ ��� ����� ��������
pack varchar2(500);--����� ��� �������+
--
sql_count integer; --�������������

procedure chek_account_bills is
  pragma autonomous_transaction; 
  begin
    update db_loader_bills_period lbp 
      set lbp.bills_count= (select count(*) 
                              from db_loader_bills t 
                              where t.account_id=Paccount_id and t.year_month=BillPeriod)
          ,lbp.bills_zero= (select count(*)  
                              from db_loader_full_finance_bill ffb 
                              where ffb.account_id=Paccount_id and ffb.year_month=BillPeriod
                                                                              and ffb.bill_sum=0)
          ,lbp.bills_loaded= (select count(*)  
                                from db_loader_full_finance_bill ffb 
                                where ffb.account_id=Paccount_id and ffb.year_month=BillPeriod and ffb.bill_sum!=0) 
          ,lbp.bills_conflict= (select count(*)  
                                  from db_loader_ffb_except ffb 
                                  where ffb.account_id=Paccount_id and ffb.year_month=BillPeriod and ffb.resolve=0)
      where lbp.account_id=Paccount_id 
        and lbp.year_month=BillPeriod;
    commit;
  
    Select bp.bills_count, nvl(bp.bills_count,-1)-(nvl(bp.bills_zero,0)+nvl(bp.bills_loaded,0)+nvl(bp.bills_conflict,0))
      into bills_count,bills_lyambda
      from db_loader_bills_period bp 
      where bp.account_id=Paccount_id 
        and bp.year_month=BillPeriod;
  exception
    When no_data_found then 
      Bills_NF:=true;
  end;

function Get_account_bill(acc in number, ticket_id in number) return number is
  load_err varchar2(200); 
  begin
    load_err:=beeline_api_pckg.Get_account_bill(acc,ticket_id);
    if length(regexp_substr(load_err,'\d+'))>5 then 
      return(regexp_substr(load_err,'\d+'));--���� � ������ ����� ������ 5 ������ - ��� LOG_ID
    else --�� ���������� ��������� - �������������
      LLR:=LLR+1;
      Load_log(LLR).lvl:='�������� ���������� (���)';
      Load_log(LLR).ERR:='�������� ���������� �� ����� ����� ��� �� �������';
      Load_log(LLR).CMT:='Account_ID='||Paccount_id||' YM='||BillPeriod;
      raise LOG_EXCEPTION;
      return('������!');
    end if;
   
  end;

procedure Create_account_bill(acc in number,year_m number) is
  begin
    LLR:=LLR+1;
    Load_log(LLR).lvl:='����� ���������� �� �����';
    Load_log(LLR).ERR:=beeline_api_pckg.Create_account_bill(acc,year_m);
    Load_log(LLR).CMT:='Account_ID='||acc||' YM='||year_m;
    raise LOG_EXCEPTION; 
  end; 

begin
  BillPeriod:=to_char(ADD_MONTHS(sysdate - 2,-1),'YYYYMM');--���������� �����
-- BillPeriod:=201502;
  --��������� ��������� ������ �� ��������� ������ (BillPeriod)
  chek_account_bills;
  --���� �� �� ��������� - �������.(���� ����� � ��� �� ������������ �������)
  if bills_count>0 and bills_lyambda=0 then return; end if;
  --���� ������ � ������� ��� - ������.
  if Bills_NF then loader_call_pckg_n.UPDATE_ACCOUNT_BILLS_PERIOD(Paccount_id);
    
    select count(*) into Ncount from account_load_logs lg 
               where lg.account_load_type_id=52 
                 and lg.account_id=Paccount_id
                 and lg.load_date_time>sysdate-15/1440
                 and lg.is_success=1;
    if Ncount=0  then 
      LLR:=LLR+1;
      Load_log(LLR).lvl:='�������� account_load_logs';Load_log(LLR).ERR:='��� ������ �� �������� ���������� �������� ����������';
      Load_log(LLR).CMT:='Account_ID='||Paccount_id||' YM='||BillPeriod;
      raise LOG_EXCEPTION;
    end if;
  end if;
 -- Ncount:=0;
  --��������� ���� �� ����������� ����� �� "���������� �����" � ��������� XML ���� � ������������
  if nvl(bills_count,0)=0 then --���� ���������� �� ��������� - ������
    for C_ticket in ( select t.ticket_id, t.date_create, t.answer
                        from BEELINE_TICKETS t 
                        where t.ticket_type=5 
                          and regexp_substr(t.comments,'\d+')=BillPeriod 
                          and t.account_id=Paccount_id
                          and nvl(t.answer,-1)!=0
                        order by t.date_create,t.answer desc) 
    loop
      if C_ticket.answer=1 and C_ticket.date_create>trunc(sysdate-5) then--���� ���� ������ �� 5 ���� ��������
        begin--���� ����������� xml
         select max(x.bsal_id) into XML_file_id from beeline_soap_api_log x 
             where x.account_id=Paccount_id and x.load_type=5 and instr(x.soap_request,C_ticket.ticket_id)>0; 
        exception
             when others then XML_file_id:='���_�����';--��� ����������� XML
        end;
        --??????????
        if (XML_file_id!='���_�����' and XML_file_id is not null) then exit;end if;--���� XML_���� ���������� �� ����� �������� - ������� �� �����;
                 
        XML_file_id:=Get_account_bill(Paccount_id,C_ticket.ticket_id);--����� ������ XML �� API
        exit;--���� �������� �� �����, �� ������� �� ����� - ���� ����.
                 
      elsif C_ticket.answer is null and C_ticket.date_create>trunc(sysdate-1) -- ���� ������ � �� ����������� - ���������
        then 
        case regexp_substr(beeline_api_pckg.get_ticket_status (pAccount_id,C_ticket.ticket_id),'[^;]+',1,1)
          when 'COMPLETE' then XML_file_id:=Get_account_bill(Paccount_id,C_ticket.ticket_id);--���� ����� - ������
                               exit;--���� �������� �� �����, �� ������� �� ����� - ���� ����.
          when 'REJECTED' then Create_account_bill(Paccount_id,BillPeriod);--���� ��������� ������ ��������� - ������ ������. 
          when 'IN_PROGRESS' then LLR:=LLR+1;
                                   Load_log(LLR).lvl:='������ ������ IN_PROGRESS';
                                   Load_log(LLR).ERR:='����� �'||C_ticket.ticket_id||' ����������� � '||to_char(C_ticket.date_create,'DD.MM HH24:MI');
                                   Load_log(LLR).CMT:='Account_ID='||Paccount_id||' YM='||BillPeriod;
                                   raise LOG_EXCEPTION;--���������� � �������� - �������� �����.                                     
          else XML_file_id := null;--���� ��� ���-��.
        end case;                     
      end if;
    end loop;
    if  XML_file_id is null then Create_account_bill(Paccount_id,BillPeriod);end if; --��� ������, �� ���������� ��� � ��������. 
    --���� ����� � ����������� XML ���� - ������ ���������� �� �����
    loader_call_pckg_n.PARSE_ACCOUNT_BILLS_API(Paccount_id,BillPeriod,XML_file_id); 
  end if;
  
  chek_account_bills;  
--���������� ���� - ������ ��������� 
  if (nvl(bills_count,0)>0)and(Paccount_id <> 125) then
    --�������
   /* insert into db_loader_full_finance_bill
    select t.account_id,t.year_month,t.phone_number,(t.subscriber_payment_main+t.subscriber_payment_add) as abonka,
      t.bill_sum-((t.subscriber_payment_main+t.subscriber_payment_add)+t.single_payments+t.discount_value) as calls,
      t.single_payments,t.discount_value as DISCOUNTS,t.bill_sum,1 as COMPLETE_BILL, 0 as ABON_MAIN, 0 as ABON_ADD,
      0 as ABON_OTHER,0 as SINGLE_MAIN, 0 as SINGLE_ADD, 0 as SINGLE_PENALTI, 0 as SINGLE_CHANGE_TARIFF, 0 as SINGLE_TURN_ON_SERV,
      0 as SINGLE_CORRECTION_ROUMING, 0 as SINGLE_INTRA_WEB, 0 as SINGLE_VIEW_BLACK_LIST,0 as SINGLE_OTHER, 0 as DISCOUNT_YEAR,
      0 as DISCOUNT_SMS_PLUS, 0 as DISCOUNT_CALL, 0 as DISCOUNT_COUNT_ON_PHONES, 0 as DISCOUNT_OTHERS, 0 as CALLS_COUNTRY,
      0 as CALLS_SITY, 0 as CALLS_LOCAL, 0 as CALLS_SMS_MMS,0 as CALLS_GPRS, 0 as CALLS_RUS_RPP, 0 as CALLS_ALL, 0 as ROUMING_NATIONAL,
      0 as ROUMING_INTERNATIONAL, trunc(sysdate) as DATE_CREATED,user as USER_CREATED, null as USER_LAST_UPDATED, null as DATE_LAST_UPDATED,
      0 as DISCOUNT_SOVINTEL, 0 as BAN
    from DB_LOADER_BILLS t 
      where t.account_id=Paccount_id and t.year_month=BillPeriod and 
            (t.bill_sum=0 and t.calls_local_cost=0 and t.calls_other_city_cost=0 and t.messages_cost=0 and t.internet_cost=0)
            and t.phone_number not in (select ffb.phone_number from db_loader_full_finance_bill ffb 
                                              where ffb.account_id=Paccount_id and ffb.year_month=BillPeriod);      
    --
    sql_count:=sql%rowcount;
    update db_loader_bills_period bp set bp.bills_zero=nvl(bp.bills_zero,0)+sql_count
           where bp.account_id=Paccount_id and bp.year_month=BillPeriod;                                
    commit;*/
    --�� �������
    
    for c in (select t.phone_number 
                from db_loader_bills t 
                where t.account_id=Paccount_id 
                  and t.year_month=BillPeriod 
               --and t.tariff_code is not null 
               --   and (t.bill_sum!=0 or t.calls_local_cost!=0 or t.calls_other_city_cost!=0 or t.messages_cost!=0 or t.internet_cost!=0) 
                  and t.phone_number not in (select ffb.phone_number 
                                               from db_loader_full_finance_bill ffb 
                                               where ffb.account_id=Paccount_id and ffb.year_month=BillPeriod)                                           
                  and (t.account_id,t.phone_number,t.year_month) not in (select account_id,phone_number,year_month 
                                                                           from db_loader_ffb_except
                                                                           where resolve=0)  ) 
    loop
      --�������� ������� obj_id ���� ���� - �����
      begin
        select regexp_substr(li.obj_id,'\d+') into obj_id 
          from beeline_loader_inf li 
          where li.account_id=Paccount_id 
            and li.phone_number=c.phone_number;
          
        pack:=pack||obj_id||'_';
        pack_i:=pack_i+1;
        if pack_i>=pack_size then 
           loader_call_pckg_n.LOAD_DETAIL_BILL(Paccount_id,BillPeriod,pack);    
           pack_i:=0;
           pack:=null;
        end if;
      exception
        when no_data_found then 
          insert into db_loader_ffb_except
            (account_id, year_month, phone_number, info, date_insert,resolve)
          values
            (Paccount_id, BillPeriod, c.phone_number, '�� ������ obj_id', sysdate,0);commit;
        when too_many_rows then 
          insert into db_loader_ffb_except
            (account_id, year_month, phone_number, info, date_insert,resolve)
          values
            (Paccount_id, BillPeriod,  c.phone_number, '������������� ������ obj_id', sysdate,0);commit;
        when others then 
          if pack_i>pack_size then pack_i:=0;pack:=null;end if;
          null;
      end; 
    end loop c;
    --��������� ��, ��� ��������))))
    if pack_i>0 then 
      loader_call_pckg_n.LOAD_DETAIL_BILL(Paccount_id,BillPeriod,pack);
    end if;
        
   --��������� ��� ������, � ������ ��������� ��.

    for c in( select tc.tariff,tc.ri 
                from (select t.rowid ri,tr.tariff_code tariff 
                        from db_loader_full_bill_abon_per t, db_loader_account_tariffs tr 
                        where (t.tariff_code=replace(tr.tariff_name,'.',', ') or t.tariff_code=tr.tariff_name)
                          and t.account_id=tr.account_id 
                          and t.year_month=BillPeriod
                          and t.tariff_code!='�� �������� L 2013'
                          and t.tariff_code!='������� �������. ������'
                          and t.tariff_code is not null
                      union all 
                      select t.rowid ri,ph.cell_plan_code tariff 
                        from db_loader_full_bill_abon_per t, db_loader_account_phones ph
                        where t.phone_number=ph.phone_number 
                          and t.account_id=ph.account_id 
                          and t.year_month=BillPeriod
                          and t.year_month=ph.year_month
                          and (t.tariff_code='�� �������� L 2013' or t.tariff_code='������� �������. ������')
                          and t.tariff_code is not null) tc ) 
    loop
      update db_loader_full_bill_abon_per ttf set ttf.tariff_code=c.tariff where ttf.rowid=c.ri;
    end loop;
    
    --��������� � �������, ���������� - ��� �������.                                                                                                                                                      
  end if;
                  
  chek_account_bills;  
  BILLS_ACCOUNT_CHECK; -- �������� ������� ������
  null;
  
end P_LOAD_BEELINE_BILLS;
/
