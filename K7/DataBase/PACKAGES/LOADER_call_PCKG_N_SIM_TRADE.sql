CREATE OR REPLACE PACKAGE LOADER_call_PCKG_N AS

--#Version=01
-- ����� ������� �������.
/*--�������� ����������
function create_conn (lgn in varchar2,
                      pss in varchar2,
                      phone in varchar2 default 0,
                      report_type in  number,
                      answer out blob
                      ) return varchar2;
function  create_rpt_log_tbl (report_type in number, p_account_id in number, blFile in blob, filename in varchar2)
  return varchar2;
--�������� ��������
function create_rpt_log (report_type in number, account in varchar2, blFile in blob, filename in varchar2)
  return varchar2;*/

--��������� ���������� ������ �� ����� �������.
function get_status_complite(report_type in number,login in varchar2, pswd in varchar) return number;
--��������� ����� �� ������� ����������� �� �\�
  PROCEDURE LOAD_REPORT_DATA(
    pACCOUNT_ID IN INTEGER
    );
--��������� ������� ���������� �� ���� �\�
Procedure load_report_data_all;

--��������� ������� �� �\�
procedure LOAD_ACCOUNT_PAYMENTS(pACCOUNT_ID in number);
--���������� ������
function lock_phone(pACCOUNT_ID in varchar2,
                    pPHONE_NUMBER in varchar2)
                    return varchar2;
--������������� ������
function unlock_phone(pACCOUNT_ID in varchar2,
                    pPHONE_NUMBER in varchar2)
                    return varchar2;
--�������� ��������
procedure LOAD_ACCOUNT_PHONES_STATE(pACCOUNT_ID in number);
--���������� ��������
procedure UPDATE_ACCOUNT_PHONES_STATE(pACCOUNT_ID in number) ;
--�������� �����
PROCEDURE LOAD_PHONES_OPTIONS(pACCOUNT_ID IN INTEGER);

END;
/
CREATE OR REPLACE PACKAGE BODY SIM_TRADE.LOADER_call_PCKG_N AS
  Divider varchar2(1):=chr(59);--�����������
  NDS number:=1.18; --������ ���
  SQ_Value integer;  --������� �������� Sequnce
  type Rheader is record (h_name varchar2(50)
                         ,h_value varchar2(200));
  type header_table is table of Rheader INDEX BY binary_integer;
  type loader_table is table of varchar2(1000) INDEX BY binary_integer;
  Tloader           loader_table;--������ ���������� html
  Theader           header_table;--��������� html
  TsiteAddr         loader_table;TempField varchar2(300);ServerCount integer;--����� ��� ��������

/*===���������� ��� ������� �������===*/
  Snum_Rep varchar2(15); --��� �������� ���������
/*=======*/

/**/
/*=======================================*/
/*=============== ����������� ===========*/
/*=======================================*/
function create_conn (lgn in varchar2,
                      pss in varchar2,
                      report_type in  number,--6 ReportData,1 Payments ,7 Lock Phone
                      answer out blob,
                      phone in varchar2 default 0
                      ) return varchar2
is
  err        varchar2(1000);
  req        utl_http.req;--������
  resp       utl_http.resp;--�����
  urls       varchar2(1000);
  header     Rheader;
  i          number;
  --
  raw_buf raw(32767);
  line    varchar2(1000);

  procedure read_headers is --������ ���������
    begin
      for n in 1..utl_http.get_header_count(resp)
        loop
           utl_http.get_header(resp, n,header.h_name , header.h_value);
           Theader(n).h_name:=header.h_name;
           Theader(n).h_value:=header.h_value;
        end loop;
    exception when others  then null;
    end;-- ��������� �����������

begin

   begin --������� �����������
     for c in 1..3 loop  --��� ������� �����������
     SQ_Value:=sq_get_server.nextval;
      case report_type
       when 10 then --�������������
       urls:= TsiteAddr(mod(SQ_Value,ServerCount)+1)||'/lock?bill='||lgn||chr(38)||'pas='||pss||chr(38)||'phone_number='||phone||chr(38)||'locking=false';
       when 9 then --����������
       urls:= TsiteAddr(mod(SQ_Value,ServerCount)+1)||'/lock?bill='||lgn||chr(38)||'pas='||pss||chr(38)||'phone_number='||phone||chr(38)||'locking=true';
       when 6 then --Report Data
       urls:= TsiteAddr(mod(SQ_Value,ServerCount)+1)||'/order?bill='||lgn||chr(38)||'pas='||pss;
       when 1 then--Payments
       urls :=TsiteAddr(mod(SQ_Value,ServerCount)+1)||'/payments?bill='||lgn||chr(38)||'pas='||pss||chr(38)||'start_date='||to_char(sysdate-nvl(MS_PARAMS.GET_PARAM_VALUE('LOADER_N_PAYMENTS_DAY'),0),'DD.MM.YY')||chr(38)||'end_date='||to_char(sysdate,'DD.MM.YY');
       when 3 then--Phone_states
       urls :=TsiteAddr(mod(SQ_Value,ServerCount)+1)||'/phone_states?bill='||lgn||chr(38)||'pas='||pss||chr(38)||'num_rep='||Snum_rep;
       when 31 then--Phone_statuses
       urls :=TsiteAddr(mod(SQ_Value,ServerCount)+1)||'/phone_statuses?bill='||lgn||chr(38)||'pas='||pss;
       when 4 then--Phone_options
       urls :=TsiteAddr(mod(SQ_Value,ServerCount)+1)||'/services_and_plans?bill='||lgn||chr(38)||'pas='||pss;
      end case;

          begin
          utl_http.set_transfer_timeout(MS_PARAMS.GET_PARAM_VALUE('USS_BEELINE_LOADER_TIME_OUT'));--��������� �������� 5 �����. ( ��� ? )
          req:= utl_http.begin_request(urls);
          utl_http.set_body_charset(req,'UTF-8');
          resp := utl_http.get_response(req);
          if resp.status_code>0 then exit;end if;--���� ���� ��������� ���������� �������
          exception
          when others then --���� ���������� �� ������, ������� ��� 2 ����, � ������ 20 ���.
                      if c<3 then dbms_lock.sleep(20);else
                      err:=resp.status_code||' Error! ���������� ���������! '||chr(13)||sqlerrm;
                      return(err);
                      end if;
          end;
      end loop;
        if resp.status_code=400 then--���� ������ ������� - ��������, � ������ �������.
        utl_http.read_line(resp,err);
        read_headers;
        UTL_HTTP.END_RESPONSE(resp);
        return(err||' Code:400');
        end if;
    exception  --��������� �������� ����������, �� ������ ������.
      when others then
      err:=err||'���:'||nvl(resp.status_code,0);
      if nvl(resp.status_code,0)>0 then UTL_HTTP.END_RESPONSE(resp);end if;
      err:=err||' Error! ���������� �� ���������, ���� �� ������! '||chr(13)||sqlerrm;
      return(err);
    end;--����������� ���������


  begin --�������� ����������� ������ � blob ��� �����������
        -- � ��������� ������� ��� �������� � ����
  read_headers;
    dbms_lob.createtemporary(answer, true );
    i:=0;
    loop
     utl_http.read_line(resp,line);--������ varchar2
       if report_type in (1,9,10,31)--��� ����
         then raw_buf:=utl_raw.cast_to_raw(convert(line,'CL8MSWIN1251','UTF8'));--����������� � raw-bufer
       else raw_buf:=utl_raw.cast_to_raw(line);
       end if;
     i:=i+1;
       if report_type in (3,4) --��� ������� �������
         then Tloader(i):=convert(line,'utf8','CL8MSWIN1251');
       else Tloader(i):=line;
       end if;
     dbms_lob.append(answer,raw_buf);--� blob
    end loop;
  exception
      when others then--� ����� ������ ��������� ����������
      UTL_HTTP.END_RESPONSE(resp);
  end;
   if dbms_lob.getlength(answer)!=0 and (not nvl(resp.status_code,999)>200) then return('OK'); --��� ���������� � ����
   else Return('��� �����������! ���:'||resp.status_code);end if;--��� ����������� ����������
 end;
/*=======================================*/
/*= �������� ���� ������ � Blob ������� =*/
/*=======================================*/
function  create_rpt_log_tbl (report_type in number, p_account_id in number, blFile in blob, filename in varchar2)
  return varchar2
  is
pragma autonomous_transaction;
begin

insert into loader_call_n_log
  (account_id, load_date, file_name, file_body,report_type)
values
  (p_account_id, sysdate, filename, blFile,report_type);

commit;
return('OK');
exception
  when others then return('Error!'||sqlerrm);
end;
procedure  create_rpt_log_tbl(report_type in number
                            , p_account_id in number
                            , blFile in blob
                            , filename in varchar2)is
var varchar2(1000);
begin
var:=create_rpt_log_tbl(report_type,p_account_id,blFile,filename);
if var='OK' then null; end if;
end;

/*=======================================*/
/*===== �������� ���������� ������ ======*/-- �� ������������
/*=======================================*/
function get_status_complite(report_type in number,login in varchar2, pswd in varchar) return number is
  req        utl_http.req;--������
  resp       utl_http.resp;--�����
  url varchar2 (200);
  ord_rn varchar2(50);
  result number;
begin
  case report_type
    when 6 then url:=MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS') ||'/order_last?bill='||login||'&'||'pas='||pswd;
  end case;
  req  := utl_http.begin_request(url);
  utl_http.set_body_charset(req, 'UTF-8');
  resp := utl_http.get_response(req);
  utl_http.get_header_by_name(resp,'Order-Number',ord_rn);
  select 0 into result from dual where --���� ����� ��� �������, �� ���������� 1
  exists (select * from account_load_logs l where l.beeline_rn=ord_rn and l.is_success=1 and l.account_load_type_id=report_type);
  UTL_HTTP.END_RESPONSE(resp);
  return(result);
exception
  when others then UTL_HTTP.END_RESPONSE(resp); return(1); --���� ���-�� ���������
end;

/*=======================================*/
/*==== 6 ��ר� � ������� ����������� ====*/
/*=======================================*/
PROCEDURE LOAD_REPORT_DATA(
    pACCOUNT_ID IN INTEGER
    ) IS

method            varchar2(50);--�������� ���������
--
log_EXCEPTION       EXCEPTION;
err                 varchar2(1000);
--
answer_mes blob;--��������
--
plogin     VARCHAR2(30 CHAR);
pPASSWORD  VARCHAR2(30 CHAR);
account    number;
--
Snext_RN   varchar2(60);--����� ����������� ������
SRN        varchar2(60);--����� ������������ ������
S_file_RN  varchar2(200);--����������� ����
counter    number:=0;
--
account_sum number:=0;--����� �� �\� ��� �������� �������� �� ��. �����

 --������� ������ � ������� � ������� ����� db_loader_pckg.SET_REPORT_DATA
          function insertstr(item varchar2, pars_type number) return varchar2  is
           rcReportData db_loader_report_data%rowtype;
           sMSG varchar2(200);
              sTMP varchar2(3000);
              sFld varchar2(200);
            nPozDivider number;
            nIndexField number;
          begin
          sTMP:=item||divider;
          nIndexField:=0;
          dbms_output.enable;
          loop--������� ������
          nPozDivider:=instr(sTMP,divider,1,1);
          sFld:= substr(sTMP,1,nPozDivider-1);
          sTMP:= substr(sTMP,nPozDivider+1);
          case nIndexField
            when 2 then rcReportData.Phone_Number:=trim(sFLD);--���.�����
            when 3 then rcReportData.Detail_Sum:=to_number(replace(rtrim(sfld,chr(10)||chr(13)||chr(9)),',','.'), '9999999999.99')*nds;--�����*���
            else
              null;
          end case;
          nIndexField:=nIndexField+1;
            exit when nPozDivider is null;
          end loop;
          --���.����
          rcReportData.Year_Month:=to_number(to_char(sysdate,'YYYYMM'));
          rcReportData.Date_Last_Update:=to_char(sysdate);
          /* ���������  ������ */
          if pars_type=1 then
          smsg:=(to_char(rcReportData.Year_Month)||','||to_char(rcReportData.Phone_Number)||','||
          to_char(rcReportData.Detail_Sum)||','||to_char(rcReportData.Date_Last_Update));
          db_loader_pckg.SET_REPORT_DATA(rcReportData.Phone_Number,rcReportData.Detail_Sum,to_char(sysdate,'DD.MM.YYYY-HH24:MI:SS'));
          return(sMSG);
          elsif pars_type=0 then
           return(rcReportData.Detail_Sum);
          end if;

          end;
BEGIN
    counter:=0;
    SELECT login,nvl(new_pswd,password) password, ACCOUNT_NUMBER,n_method
      INTO plogin, ppassword                    ,ACCOUNT        ,method
    FROM ACCOUNTS WHERE ACCOUNT_ID=pACCOUNT_ID;
    --��������� ����� �� �����������...
    if strInLike(6,method,';','()')=0 then err:=' ������������ ������ ���������! '; raise log_EXCEPTION;end if;
   /* if get_status_complite(6,plogin,ppassword)=0
      then
    err:='��� ������ ������!';
    raise log_EXCEPTION;end if;--���� ��������� ��� �������� - ������� . */

    err:=create_conn(plogin,ppassword,6,answer_mes);--��������� ����������

        for i in Theader.first..theader.last loop--���������� header
          if Theader(i).h_name='Next-Order-Number' then Snext_RN:= Theader(i).h_value;end if;--���������
          if Theader(i).h_name='Order-Number' then SRN:= Theader(i).h_value;end if;
          if Theader(i).h_name='Order-Time' then
             if (sysdate-to_date(replace(Theader(i).h_value,' '),'DD HH24:MI'))>0.5 then
               err:='Error:������� ������������ ������ ������ 12 �����.';
               raise log_EXCEPTION;
             end if;
          end if;
        end loop;
        if Snext_RN is null then Snext_RN:='����� �� �������Ĩ�!'; end if;
        if (length(trim(SRN)) is not null)
           then  S_file_RN:=SRN||'.csv'; else S_file_RN:='Err '||account||to_char(sysdate,'MMDDmiss');
        end if;

     if err='OK' then

   begin  --�������� ���������� ��ר�� - ���� ����� ��� ������� ��������
    select 0 into err from dual where
    exists (select * from account_load_logs l
            where l.beeline_rn=SRN and l.is_success=1 and l.account_load_type_id=6);
    if err='0' then err:='��� ������ ������!'; raise log_EXCEPTION;end if;
    exception when no_data_found then null;
    end;  --�������� ���������� �����

     err:='';
     -- err:=create_rpt_log(6,account,answer_mes,S_file_RN);--������ ����� �� �����
        err:=create_rpt_log_tbl(6,pACCOUNT_ID,answer_mes,S_file_RN);--������ ����� � ����
        if err!='OK' then raise log_EXCEPTION;end if;
     else --���� �� ������ ���������� ��������
        raise log_EXCEPTION;
     end if;--���������� �����������
  -------------------------------------
    --��������� , ���� ��������� �� ������ ��� ������� xml �� ��������
    if (instr(Tloader(1),'Error')>0)or(instr(Tloader(1),'<')>0) then
      err:=Tloader(1); raise log_exception;
    end if;
    --�������� ������
    --������������ ������� �������� �� ����� �����
    for i in Tloader.first+1..Tloader.last loop
     if trim(Tloader(i))is not null then
     account_sum:=account_sum+to_number(replace(rtrim(insertstr(Tloader(i),0),chr(10)||chr(13)||chr(9)),',','.'), '9999999999.99');
     counter:=counter+1;
     end if;
    end loop;
        --���������� ������ � ������ �������� �� ����� �����
    pragma autonomous_transaction;
    begin
     UPDATE iot_acc_report_data_temp
     SET nsum = account_sum,load_date_time=sysdate
     WHERE account_id = pACCOUNT_ID and year_month=to_char(sysdate,'YYYYMM');
    IF ( sql%rowcount = 0 )
     THEN
      insert into iot_acc_report_data_temp
            (account_id, year_month, nsum, load_date_time)
          values
            (pACCOUNT_ID, to_char(sysdate,'YYYYMM'), account_sum,sysdate);
     END IF;
     commit;
     end;

    --��������� �������
    counter:=0;
    --�������� ������ � ����
    for c in (select distinct t.account_id from iot_acc_report_data_temp t
              where t.account_id=pACCOUNT_ID and t.can_load=1 and t.year_month=to_char(sysdate,'YYYYMM'))
     loop
     for i in Tloader.first+1..Tloader.last loop--���������� ���������
     --���� ���������� �� ������ � ������ ������ �� ������ ���� ��� ������ ��� �� 400
           if insertstr(Tloader(i),1)is not null then counter:=counter+1;end if;
     end loop i;
    end loop c;
  --�������� �������� ����������
  INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                         IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID,BEELINE_RN)
  VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
   1,'Ok! Add '||counter||' rows.'||' �������:'||Snext_RN, 6,SRN);commit;

  EXCEPTION --�������� �������
      when others then  --log_EXCEPTION � ���������

      err:=err||' -- '||SQLERRM||'--'|| case
                                          when SQ_Value is null then ''
                                          else TsiteAddr(mod(SQ_Value,ServerCount)+1)
                                        end;
      INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                                 IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID,BEELINE_RN)
      VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
           0,err||decode(Snext_RN,null,'',' �������:')||Snext_RN, 6,SRN);
      commit;
END;
--����� � ������� ����������� �� ���� �\�
Procedure load_report_data_all is begin
  for c in (select distinct t.account_id idn from ACCOUNTS t)
    loop
    LOAD_REPORT_DATA(c.idn);
    end loop;
end;

procedure LOAD_ACCOUNT_PAYMENTS(
    pACCOUNT_ID in number) is

method            varchar2(50);--�������� ���������
--
log_EXCEPTION       EXCEPTION;
err                 varchar2(1000);
--
answer_mes blob;--��������
--
plogin     VARCHAR2(30 CHAR);
pPASSWORD  VARCHAR2(30 CHAR);
account    number;
--
SRN        varchar2(30);--����� ������������ ������
S_file_RN  varchar2(200);--����������� ����
NBalance   number; -- ������ �� �\�.
counter    number:=0;

 --������� ������ � ������� � ������� ����� db_loader_pckg.SET_REPORT_DATA
          function insertstr(item varchar2) return varchar2  is
           rcLoaderPayments db_loader_payments%rowtype;
           sMSG varchar2(200);
              sTMP varchar2(3000);
              sFld varchar2(200);
            nPozDivider number;
            nIndexField number;
            paysign number;-- "1" ����� , "-1" ����
          begin
          sTMP:=replace(
                replace(
                replace(item,'�')--��� �� ������ � ��������� ������ HEX(A000)
                       ,'"')
                       ,',',divider)||divider;
          nIndexField:=0;
          dbms_output.enable;
          loop--������� ������
          nPozDivider:=instr(sTMP,divider,1,1);
          sFld:= substr(sTMP,1,nPozDivider-1);
          sTMP:= substr(sTMP,nPozDivider+1);
          case nIndexField
            when 0 then rcLoaderPayments.Payment_Date:=to_date(sFld,'DD.MM.YYYY');
            when 1 then select decode(sFld,
                                           '������ ��������',1,
                                           '������� ������� � ������� �������',1,
                                           '������ �������� �������',1,
                                           '������ �������',-1,
                                           '������� ������� �� ������� �������',-1,
                                           '������� �������',-1)
                                           into paysign from dual;
                        select decode(paysign,-1,sfld,'')into rcLoaderPayments.Payment_Status_Text from dual;
            when 2 then rcLoaderPayments.Payment_Sum:=to_number(replace(rtrim(sfld,chr(10)||chr(13)||chr(9)),',','.'), '9999999999.99')*paysign;
            when 7 then rcLoaderPayments.Payment_Number:=sFld;
            when 8 then
             sfld:=nvl(sfld,'0000000000');
             select decode(sfld,'','0000000000',sfld) into sfld from dual;
             rcLoaderPayments.Phone_Number:=rtrim(sfld,chr(10)||chr(13)||chr(9));
            else
              null;
          end case;
          nIndexField:=nIndexField+1;
            exit when nPozDivider is null;
          end loop;
          /* ���. ���� */
          select decode(paysign,-1,0,1) into rcLoaderPayments.Payment_Status_Is_Valid from dual;
          /*��������� ������ to_char(sysdate,'DD.MM.YYYY-HH24:MI:SS')*/
          db_loader_pckg.ADD_PAYMENT(to_char(sysdate,'YYYY'),to_char(sysdate,'MM'),plogin,rcLoaderPayments.Phone_Number
          ,rcLoaderPayments.Payment_Date,rcLoaderPayments.Payment_Sum,rcLoaderPayments.Payment_Number,rcLoaderPayments.Payment_Status_Is_Valid
          ,rcLoaderPayments.Payment_Status_Text);
          smsg:='OK';
          return(sMSG);
          exception
            when others then err:=err||' ParsErr^:nIndexField='||nIndexField||';sFld='||sFld||';sTMP='||sTMP||' Counter#'||counter;
          end;
BEGIN
    counter:=0;
    SELECT t.login,nvl(t.new_pswd,t.password) password, t.ACCOUNT_NUMBER,t.n_method
      INTO plogin, ppassword                    ,ACCOUNT        ,method
    FROM ACCOUNTS t WHERE t.ACCOUNT_ID=pACCOUNT_ID;
    --��������� ����� �� �����������...
    if strInLike(1,method,';','()')=0 then err:=' ������������ ������ ���������! '; raise log_EXCEPTION;end if;
   /* if get_status_complite(6,plogin,ppassword)=0
      then
    err:='��� ������ ������!';
    raise log_EXCEPTION;end if;--���� ��������� ��� �������� - ������� . */

    err:=create_conn(plogin,ppassword,1,answer_mes);--��������� ����������

        for i in Theader.first..theader.last loop--���������� header
          case Theader(i).h_name
           when 'Content-Disposition' then S_file_RN:= Theader(i).h_value;
           when 'Balance' then
                if upper(rtrim(Theader(i).h_value,chr(10)||chr(13)||chr(9)))='NULL' then NBalance:=null;
                else
                Nbalance:=to_number(replace(rtrim(Theader(i).h_value,chr(10)||chr(13)||chr(9)),',','.'), '9999999999.99');
                end if;
           else null;
          end case;
        end loop;

     if err='OK' then
      BEGIN
           --��������� ������ �� �\�
          /* if nbalance is not null then
              DB_LOADER_PCKG.SAVE_BALANCE_CHANGE(plogin,NBalance);
           end if;*/
      ---
           if instr(S_file_RN,'attachment')>0 then --�������� ����
              S_file_RN:=ltrim(S_file_RN,'attachment; filename=');
              S_file_RN:=trim('"' from S_file_RN);
              S_file_RN:=ltrim(S_file_RN,'"RPT_UBC');-- ������� ��������� �������
              SRN:=substr(s_file_rn,1,instr(s_file_rn,'_')-1);--����� ������
           else--������ �� ���������
           raise log_EXCEPTION;
           end if;
        exception
          when others then
          SRN:='�\�'||to_char(sysdate,'MMDD-MMSS');
          S_file_RN:=account||'_err.txt';--����� ���� � �������
        end;

   begin  --�������� ���������� ��ר�� - ���� ����� ��� ������� ��������
    select 0 into err from dual where
    exists (select * from account_load_logs l
            where l.beeline_rn=SRN and l.is_success=1 and l.account_load_type_id=1);
    if err='0' then err:='��� ������ ������!'; raise log_EXCEPTION;end if;
    exception when no_data_found then null;
    end;  --�������� ����������

     err:='';
       -- err:=create_rpt_log(6,account,answer_mes,S_file_RN);--������ ����� �� �����
        err:=create_rpt_log_tbl(1,pACCOUNT_ID,answer_mes,S_file_RN);--������ ����� � ����
        if err!='OK' then raise log_EXCEPTION;end if;

     else --���� �� ������ ���������� ��������
        raise log_EXCEPTION;
     end if;--���������� �����������
  -------------------------------------
    --�������� ������
     for i in Tloader.first..Tloader.last loop
       --���� ���������� �� ������ � ������ ������ �� ������ ���� ��� ������ ��� �� 400
       if instr(Tloader(i),'Error')>0 and (i=1) then err:=Tloader(i); raise log_exception;
       elsif i>1--�������� ��������� �������
              then --��������� � �������
              if insertstr(Tloader(i))is not null then counter:=counter+1;
                else raise log_EXCEPTION;
              end if;
       end if;
     end loop;
  --�������� �������� ����������
  INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                         IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID,BEELINE_RN)
  VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
   1,'Ok! Add '||counter||' rows.', 1,SRN);commit;

  EXCEPTION --�������� �������
      when others then  --log_EXCEPTION � ���������
      err:=err||' -- '||SQLERRM||'--'|| case
                                          when SQ_Value is null then ''
                                          else TsiteAddr(mod(SQ_Value,ServerCount)+1)
                                        end;
      INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                                 IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID,BEELINE_RN)
      VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID,SYSDATE,0,err, 1,SRN);
      commit;
end;

function lock_phone(pACCOUNT_ID in varchar2,
                    pPHONE_NUMBER in varchar2)
                    return varchar2 is
result varchar2(100);
err varchar2(1000);
answer blob;
plogin     VARCHAR2(30 CHAR);
pPASSWORD  VARCHAR2(30 CHAR);
begin
    SELECT login,nvl(new_pswd,password) password
      INTO plogin, ppassword
    FROM ACCOUNTS WHERE ACCOUNT_ID=pACCOUNT_ID;
 for c in 1..3 loop --������� 3 ����
    err:=create_conn(plogin,ppassword,9,answer,pPHONE_NUMBER);
       --������� ��� ����� ����� ���� : ������ �9999999999 �� ���������� ������� ���������
       if err='OK' or (Tloader.count>0  and instr(Tloader(1),'��������')=1) then
         create_rpt_log_tbl(9,pACCOUNT_ID,answer,'lock_'||pPHONE_NUMBER||'_OK');--�������� ����� �� �������.
         return(Tloader(1));--�������� � ������������� �������
       else -- ���� ����� �������� �����
         if dbms_lob.istemporary(answer)is null then  dbms_lob.createtemporary(answer, true ); end if;
         for i in Theader.first..Theader.last loop
           dbms_lob.append(answer,utl_raw.cast_to_raw(convert(Theader(i).h_name||':'||Theader(i).h_value||chr(13),'CL8MSWIN1251','UTF8')));
         end loop;
         dbms_lob.append(answer,utl_raw.cast_to_raw(convert('����� ����������:'||err,'CL8MSWIN1251','UTF8')));--���������� � blob
         create_rpt_log_tbl(9,pACCOUNT_ID,answer,'lock_'||pPHONE_NUMBER||'_ERR');
         result:='Error';
       end if;
 end loop;
return(result);--���� ������ ������� ���������� ��������.
exception
when others then
       if dbms_lob.istemporary(answer)is null then  dbms_lob.createtemporary(answer, true ); end if;
       dbms_lob.append(answer,utl_raw.cast_to_raw('����� ����������:'||err));--���������� � blob
       create_rpt_log_tbl(9,pACCOUNT_ID,answer,'lock_'||pPHONE_NUMBER||'_ERR');
       return('Error');
end;

function unlock_phone(pACCOUNT_ID in varchar2,
                    pPHONE_NUMBER in varchar2)
                    return varchar2 is
result varchar2(100);
err varchar2(1000);
answer blob;
plogin     VARCHAR2(30 CHAR);
pPASSWORD  VARCHAR2(30 CHAR);
begin
    SELECT login,nvl(new_pswd,password) password
      INTO plogin, ppassword
    FROM ACCOUNTS WHERE ACCOUNT_ID=pACCOUNT_ID;

 for c in 1..3 loop --������� 3 ����
 err:=create_conn(plogin,ppassword,10,answer,pPHONE_NUMBER);
       --������� ��� ����� ����� ���� : ������ �9999999999 �� ���������� ������� ���������
       if err='OK' or (Tloader.count>0  and instr(Tloader(1),'��������')=1) then
         create_rpt_log_tbl(10,pACCOUNT_ID,answer,'unlock_'||pPHONE_NUMBER||'_OK');--�������� ����� �� �������.
         return(Tloader(1));--�������� � ������������� �������
       else
         if dbms_lob.istemporary(answer)is null then  dbms_lob.createtemporary(answer, true ); end if;
         for i in Theader.first..Theader.last loop--��������� ��������� � ����
           dbms_lob.append(answer,utl_raw.cast_to_raw(convert(Theader(i).h_name||':'||Theader(i).h_value||chr(13),'CL8MSWIN1251','UTF8')));
         end loop;
         dbms_lob.append(answer,utl_raw.cast_to_raw(convert('����� ����������:'||err,'CL8MSWIN1251','UTF8')));--���������� � blob
         create_rpt_log_tbl(10,pACCOUNT_ID,answer,'unlock_'||pPHONE_NUMBER||'_ERR');
         result:='Error';
       end if;
 end loop;
 --���� ������ �����- ��������
return(result);
exception
when others then
  if dbms_lob.istemporary(answer)is null then  dbms_lob.createtemporary(answer, true ); end if;
  dbms_lob.append(answer,utl_raw.cast_to_raw('����� ����������:'||err));--���������� � blob
  return('Error');
end;


/*=======================================*/
/*=== 3 ������� ��������� ����������� ===*/
/*=======================================*/
procedure LOAD_ACCOUNT_PHONES_STATE(pACCOUNT_ID in number)
    is

    method            varchar2(50);--�������� ���������
--
log_EXCEPTION       EXCEPTION;
err                 varchar2(1000);
--
answer_mes blob;--��������
--
plogin     VARCHAR2(30 CHAR);
pPASSWORD  VARCHAR2(30 CHAR);
account    number;
--
Snext_RN   varchar2(60);--����� ����������� ������
SRN        varchar2(60);--����� ������������ ������
S_file_RN  varchar2(200);--����������� ����
counter    number:=0;

 --������� ������ � ������� � ������� ����� db_loader_pckg.SET_REPORT_DATA
          function insertstr(item varchar2) return varchar2  is
           rcStates db_loader_account_phones%rowtype;
           sMSG varchar2(200);
              sTMP varchar2(3000);
              sFld varchar2(200);
            nPozDivider number;
            nIndexField number;
          begin
          sTMP:=item||divider;
          nIndexField:=0;
          dbms_output.enable;
          loop--������� ������
          nPozDivider:=instr(sTMP,divider,1,1);
          sFld:= substr(sTMP,1,nPozDivider-1);
          sTMP:= substr(sTMP,nPozDivider+1);
          sFld:=trim(sFld);
          case nIndexField
            when 2 then rcStates.Organization_Id:=to_number(replace(rtrim(sfld,chr(10)||chr(13)||chr(9)),',','.'), '9999999999.99');
            when 8 then select decode(sFld,'���������������',0,'��������',1) into rcStates.Phone_Is_Active from dual; --����������
            when 9 then rcStates.Phone_Number:=to_number(sFld);
            when 10 then rcStates.Cell_Plan_Code:=sFld;
            when 13 then select decode(sFld,'����������',1,'���������������� ����������',0,0) into rcStates.Conservation from dual; --��� ����������
            else
              null;
          end case;
          nIndexField:=nIndexField+1;
            exit when nPozDivider is null;
          end loop;

          /* ���������  ������ */
          Db_Loader_Pckg.ADD_ACCOUNT_PHONE(
            to_char(sysdate,'YYYY'),
            to_char(sysdate,'MM'),
            plogin,
            rcStates.Phone_Number ,
            rcStates.Phone_Is_Active,             /* 0 - ����������, 1 - �������� */
            rcStates.Cell_Plan_Code,              /* ��� ��������� �����*/
            null,                                 /* ��� ������ ��������� �����*/
            null,                                 /* ���� ����� ��������� �����*/
            rcStates.Organization_Id,             /* ��� ����������� */
            0,                                    /* ����� ���������� �������� ����� (����� ��������� ������) */
            rcStates.Conservation,                /* 0 - ���, 1 - �� ���������� */
            0                                     /* 0 - ���, 1 - ��������� ���� �� ������������� */
            );
          smsg:=(to_char(rcStates.Phone_Number)||','||to_char(rcStates.Phone_Is_Active)||','||
          to_char(rcStates.Cell_Plan_Code)||','||to_char(rcStates.Organization_Id));
          return(sMSG);
          exception
            when others then err:=err||' ParsErr^:nIndexField='||nIndexField||';sFld='||sFld||';sTMP='||sTMP;
          end;

/*phone_statuses begin now*/
begin
 counter:=0;
    SELECT login,nvl(new_pswd,password) password, ACCOUNT_NUMBER,n_method
      INTO plogin, ppassword                    ,ACCOUNT        ,method
    FROM ACCOUNTS WHERE ACCOUNT_ID=pACCOUNT_ID;
    --��������� ����� �� �����������...
    if strInLike(3,nvl(method,'0;'),';','()')=0 then err:=' ������������ ������ ���������! '; raise log_EXCEPTION;end if;
    -- ������ ���������� ������ ������
     begin
      select max(trim(both '#' from regexp_substr(e.error_text,'#[^#]+#'))) into Snum_Rep
      from account_load_logs e where e.load_date_time in (select MAX(r.load_date_time)
                                                          from  account_load_logs r
                                                          where r.account_load_type_id=3 and regexp_instr(r.error_text,'#\d+#')>0
                                                          and r.account_id=pACCOUNT_ID)
      and e.account_load_type_id=3 and e.account_id=pACCOUNT_ID;
     exception
      when others then Snum_Rep:=0;
     end;
    --

    err:=create_conn(plogin,ppassword,3,answer_mes);--��������� ����������

        for i in Theader.first..theader.last loop--���������� header
          if Theader(i).h_name='Next-Order-Number' then Snext_RN:= Theader(i).h_value;end if;--���������
          if Theader(i).h_name='Order-Number' then SRN:= Theader(i).h_value;end if;
          if Theader(i).h_name='Order-Time' then
             if (sysdate-to_date(replace(Theader(i).h_value,' '),'DD HH24:MI'))>0.5 then
               err:='Error:������� ������������ ������ ������ 12 �����.';
               raise log_EXCEPTION;
             end if;
          end if;
        end loop;
        if Snext_RN is null then Snext_RN:='����� �� �������Ĩ�!'; end if;
        if (length(trim(SRN)) is not null)
           then  S_file_RN:=SRN||'.csv'; else S_file_RN:='Err '||account||to_char(sysdate,'MMDDmiss');
        end if;

     if err='OK' then
        err:=create_rpt_log_tbl(3,pACCOUNT_ID,answer_mes,S_file_RN);--������ ����� � ����
        if err!='OK' then raise log_EXCEPTION;end if;
     else --���� �� ������ ���������� ��������
        raise log_EXCEPTION;
     end if;--���������� �����������
    --��������� , ���� ��������� �� ������ ��� ������� xml �� ��������
    if (Tloader is null) or (instr(Tloader(1),'Error')>0)or(instr(Tloader(1),'<')>0) then
      err:=Tloader(1); raise log_exception;
    end if;
    --������
    db_loader_pckg.START_LOAD_ACCOUNT_PHONES(to_char(sysdate,'YYYY'),to_char(sysdate,'MM'),plogin);

    --�������� ������

     for i in Tloader.first+1..Tloader.last loop--���������� ���������
     --���� ���������� �� ������ � ������ ������ �� ������ ���� ��� ������ ��� �� 400
           if insertstr(Tloader(i))is not null then counter:=counter+1;
           else raise log_EXCEPTION;
           end if;
     end loop i;
     commit;
    --������
    db_loader_pckg.COMMIT_LOAD_ACCOUNT_PHONES(to_char(sysdate,'YYYY'),to_char(sysdate,'MM'),plogin);
  --�������� �������� ����������
  INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                         IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID,BEELINE_RN)
  VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
   1,'Ok! Add '||counter||' rows.'||' �������:#'||Snext_RN||'#', 3,SRN);
   commit;

  EXCEPTION --�������� �������
      when others then  --log_EXCEPTION � ���������
      err:=err||' -- '||SQLERRM||'--������� ������������:'||nvl(counter,0)||'--'
                                     ||case
                                          when SQ_Value is null then ''
                                          else TsiteAddr(mod(SQ_Value,ServerCount)+1)
                                        end;

      rollback;--�������� ������ ������� �� ������ �������������

      INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                                 IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID,BEELINE_RN)
      VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
           0,err||decode(Snext_RN,null,'',' �������:#')||Snext_RN||'#', 3,SRN);
      commit;



null;
end;

/*=======================================*/
/*===== 3 ������� ��������� UPDATE ======*/
/*=======================================*/
procedure UPDATE_ACCOUNT_PHONES_STATE(pACCOUNT_ID in number)
    is
    method            varchar2(50);--�������� ���������
--
log_EXCEPTION       EXCEPTION;
err                 varchar2(1000);
--
answer_mes blob;--��������
--
plogin     VARCHAR2(30 CHAR);
pPASSWORD  VARCHAR2(30 CHAR);
account    number;
--
S_file_RN  varchar2(200);--����������� ����
counter    number:=0;

 --������� ������ � ������� � ������� ����� db_loader_pckg.SET_REPORT_DATA
          function insertstr(item varchar2) return varchar2  is
           rcStates db_loader_account_phones%rowtype;
           sMSG varchar2(200);
              sTMP varchar2(3000);
              sFld varchar2(200);
            nPozDivider number;
            nIndexField number;
          begin
          sTMP:=replace(
                replace(
                replace(item,'�')--��� �� ������ � ��������� ������ HEX(A000)
                       ,'"')
                       ,',',divider)||divider;

          nIndexField:=0;
          dbms_output.enable;
          loop--������� ������
          nPozDivider:=instr(sTMP,divider,1,1);
          sFld:= substr(sTMP,1,nPozDivider-1);
          sTMP:= substr(sTMP,nPozDivider+1);
          sFld:=trim(sFld);
          case nIndexField
            when 0 then rcStates.Phone_Number:=trim(sFld);
            when 2 then rcStates.Organization_Id:=to_number(regexp_substr(sFld,'\d+'));
            when 6 then rcStates.Cell_Plan_Code:=trim(rtrim(ltrim(regexp_substr(sFld,'\([^()]+\)$'),'('),')'));
            when 8 then select decode(sFld,'���������������',0,'��������',1) into rcStates.Phone_Is_Active from dual; --����������
            when 10 then select decode(sFld,'����������',1,0) into rcStates.Conservation from dual; --��� ����������
            else
              null;
          end case;

          nIndexField:=nIndexField+1;
            exit when nPozDivider is null;
          end loop;

          /* ���������  ������ */
          Db_Loader_Pckg.ADD_ACCOUNT_PHONE(
            to_char(sysdate,'YYYY'),
            to_char(sysdate,'MM'),
            plogin,
            rcStates.Phone_Number ,
            rcStates.Phone_Is_Active,             /* 0 - ����������, 1 - �������� */
            rcStates.Cell_Plan_Code,              /* ��� ��������� �����*/
            null,                                 /* ��� ������ ��������� �����*/
            null,                                 /* ���� ����� ��������� �����*/
            rcStates.Organization_Id,             /* ��� ����������� */
            0,                                    /* ����� ���������� �������� ����� (����� ��������� ������) */
            rcStates.Conservation,                /* 0 - ���, 1 - �� ���������� */
            0                                     /* 0 - ���, 1 - ��������� ���� �� ������������� */
            );
          smsg:=(to_char(rcStates.Phone_Number)||','||to_char(rcStates.Phone_Is_Active)||','||
          to_char(rcStates.Cell_Plan_Code)||','||to_char(rcStates.Organization_Id));
          return(sMSG);
          exception
            when others then err:=err||' ParsErr^:nIndexField='||nIndexField||';sFld='||sFld||';sTMP='||sTMP;
          end;

/*phone_statuses begin now*/
begin
 counter:=0;
    SELECT login,nvl(new_pswd,password) password, ACCOUNT_NUMBER,n_method
      INTO plogin, ppassword                    ,ACCOUNT        ,method
    FROM ACCOUNTS WHERE ACCOUNT_ID=pACCOUNT_ID;
    --��������� ����� �� �����������...
    if strInLike(31,nvl(method,'0;'),';','()')=0 then err:=' ������������ ������ ���������! '; raise log_EXCEPTION;end if;

    err:=create_conn(plogin,ppassword,31,answer_mes);--��������� ����������


    S_file_RN:='States'||'.csv';


     if err='OK' then
        err:=create_rpt_log_tbl(3,pACCOUNT_ID,answer_mes,S_file_RN);--������ ����� � ����
        if err!='OK' then raise log_EXCEPTION;end if;
     else --���� �� ������ ���������� ��������
        raise log_EXCEPTION;
     end if;--���������� �����������
    --��������� , ���� ��������� �� ������ ��� ������� xml �� ��������
    if (Tloader is null) or (instr(Tloader(1),'Error')>0)or(instr(Tloader(1),'<')>0) then
      err:=Tloader(1); raise log_exception;
    end if;

    --�������� ������

    --������
    db_loader_pckg.START_LOAD_ACCOUNT_PHONES(to_char(sysdate,'YYYY'),to_char(sysdate,'MM'),plogin);

     for i in Tloader.first+1..Tloader.last loop--���������� ���������
     --���� ���������� �� ������ � ������ ������ �� ������ ���� ��� ������ ��� �� 400
           if insertstr(Tloader(i))is not null then counter:=counter+1;
           else raise log_EXCEPTION;
           end if;
     end loop i;
     commit;
    --������
    db_loader_pckg.COMMIT_LOAD_ACCOUNT_PHONES(to_char(sysdate,'YYYY'),to_char(sysdate,'MM'),plogin);
  --�������� �������� ����������
  INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                         IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID)
  VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
   1,'Ok! Update '||counter||' rows.', 3);
   commit;

  EXCEPTION --�������� �������
      when others then  --log_EXCEPTION � ���������
      err:=err||' -- '||SQLERRM||'--������� ���������:'||nvl(counter,0)||'--'
                                     ||case
                                          when SQ_Value is null then ''
                                          else TsiteAddr(mod(SQ_Value,ServerCount)+1)
                                        end;

      rollback;--�������� ������ ������� �� ������ �������������

      INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                                 IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID)
      VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
           0,'Update '||err, 3);
      commit;
end;

/*=======================================*/
/*========= 4 ������ ��������� ==========*/
/*=======================================*/
PROCEDURE LOAD_PHONES_OPTIONS(
    pACCOUNT_ID IN INTEGER
    ) IS

method            varchar2(50);--�������� ���������
--
log_EXCEPTION       EXCEPTION;
err                 varchar2(1000);
--
answer_mes blob;--��������
--
plogin     VARCHAR2(30 CHAR);
pPASSWORD  VARCHAR2(30 CHAR);
account    number;
Nyear_month number:=to_number(to_char(sysdate,'YYYYMM'));
--
Snext_RN   varchar2(60);--����� ����������� ������
SRN        varchar2(60);--����� ������������ ������
S_file_RN  varchar2(200);--����������� ����
counter    number:=0;
--

  VTopts Topts:=Topts();

 --������� ������ � ������� � ������� ����� db_loader_pckg.SET_REPORT_DATA
          function insertstr(item varchar2) return varchar2  is
           rcOpts db_loader_account_phone_opts%rowtype;
           sMSG varchar2(200);
              sTMP varchar2(3000);
              sFld varchar2(200);
            nPozDivider number;
            nIndexField number;
          begin
                      sTMP:=replace(
                replace(
                replace(item,'�')--��� �� ������ � ��������� ������ HEX(A000)
                       ,'"')
                       ,',',divider)||divider;
         -- sTMP:=item||divider;
          nIndexField:=0;
          dbms_output.enable;
          loop--������� ������
          nPozDivider:=instr(sTMP,divider,1,1);
          sFld:= substr(sTMP,1,nPozDivider-1);
          sTMP:= substr(sTMP,nPozDivider+1);
          case nIndexField
          --  9670103613 ;;;��������;06.06.2013;�������������;����������;31.01.2013;;BVISAEXT2;17.05.2012
            when 0 then rcOpts.Phone_Number:=trim(sFLD);--���.�����
            when 6 then rcOpts.Option_Name:=trim(sFLD);--������������ ������
            when 7 then rcOpts.Turn_On_Date:=to_date(trim(sFLD),'DD.MM.YYYY');--���� ������ ��������
            when 8 then rcOpts.Turn_Off_Date:=to_date(trim(sFLD),'DD.MM.YYYY');--���� ��������� ��������
            when 9 then rcOpts.Option_Code:=trim(sFLD);--��� ������
            else
              null;
          end case;
          nIndexField:=nIndexField+1;
            exit when nPozDivider is null;
          end loop;
          --���.����
          rcOpts.Account_Id:=pACCOUNT_ID;
          rcOpts.Year_Month:=Nyear_month;
          rcOpts.Last_Check_Date_Time:=to_char(sysdate);
          rcOpts.Monthly_Price:=ltrim(regexp_substr(rcOpts.Option_Name,'\/(\d+)'),'/');
          rcOpts.Turn_On_Cost:=ltrim(regexp_substr(rcOpts.Option_Name,'\((\d+)'),'(');
          --���������� � �������������� �������
          vTopts.extend;
          vTopts(vTopts.count):=topts_obj(rcOpts.Account_Id,rcOpts.Year_Month,rcOpts.Phone_Number,rcOpts.Option_Code
                                         ,rcOpts.Option_Name,rcOpts.Option_Parameters,rcOpts.Turn_On_Date,rcOpts.Turn_Off_Date
                                         ,rcOpts.Last_Check_Date_Time,rcOpts.Turn_On_Cost,rcOpts.Monthly_Price);

          /* ���������� ���������� �����*/
          smsg:=vTopts.count;
          return(sMSG);
          end;
BEGIN
    counter:=0;
    SELECT login,nvl(new_pswd,password) password, ACCOUNT_NUMBER,n_method
      INTO plogin, ppassword                    ,ACCOUNT        ,method
    FROM ACCOUNTS WHERE ACCOUNT_ID=pACCOUNT_ID;
    --��������� ����� �� �����������...
    if strInLike(4,method,';','()')=0 then err:=' ������������ ������ ���������! '; raise log_EXCEPTION;end if;

    err:=create_conn(plogin,ppassword,4,answer_mes);--��������� ����������

        for i in Theader.first..theader.last loop--���������� header
          if Theader(i).h_name='Next-Order-Number' then Snext_RN:= Theader(i).h_value;end if;--���������
          if Theader(i).h_name='Order-Number' then SRN:= Theader(i).h_value;end if;

        end loop;
        if Snext_RN is null then Snext_RN:='����� �� �������Ĩ�!'; end if;
        if (length(trim(SRN)) is not null)
           then  S_file_RN:=SRN||'.csv'; else S_file_RN:='Err '||account||to_char(sysdate,'MMDDmiss');
        end if;

     if err='OK' then

         begin  --�������� ���������� ��ר�� - ���� ����� ��� ������� ��������
          select 0 into err from dual where
          exists (select * from account_load_logs l
                  where l.beeline_rn=SRN and l.is_success=1 and l.account_load_type_id=4);
          if err='0' then err:='��� ������ ������!'; raise log_EXCEPTION;end if;
          exception when no_data_found then null;
          end;  --�������� ���������� �����

         err:='';
         err:=create_rpt_log_tbl(4,pACCOUNT_ID,answer_mes,S_file_RN);--������ ����� � ����
         if err!='OK' then raise log_EXCEPTION;end if;

     else --���� �� ������ ���������� ��������
        raise log_EXCEPTION;
     end if;--���������� �����������
  -------------------------------------
    --��������� , ���� ��������� �� ������ ��� ������� xml �� ��������
    if (instr(Tloader(1),'Error')>0)or(instr(Tloader(1),'<')>0) then
      err:=Tloader(1); raise log_exception;
    end if;

    --�������� ������
    counter:=0;
    --������� ������ � ��������������� �������.
     for i in Tloader.first+1..Tloader.last loop--���������� ���������
           if insertstr(Tloader(i))is not null then counter:=counter+1;end if;
     end loop i;

         update db_loader_account_phone_opts opt set opt.turn_off_date=sysdate--��������� ��������
         where opt.account_id=pACCOUNT_ID and opt.year_month=Nyear_month and
               opt.turn_off_date is null;

         MERGE INTO db_loader_account_phone_opts opt
      USING (SELECT * FROM table(set(VTopts))) VT
      ON (opt.phone_number = vt.phone_number and opt.year_month=vt.year_month and opt.option_code=vt.option_code
          and opt.turn_on_date=vt.turn_on_date)

      WHEN MATCHED THEN
          UPDATE SET opt.last_check_date_time = vt.last_check_date_time,
                     opt.turn_off_date=vt.turn_off_date
          WHERE vt.option_code is not null
        --DELETE source1.col2 IS NULL
      WHEN NOT MATCHED THEN
           INSERT (opt.account_id,opt.year_month,opt.phone_number,opt.option_code,opt.option_name,opt.option_parameters
                  ,opt.turn_on_date,opt.turn_off_date,opt.last_check_date_time,opt.turn_on_cost,opt.monthly_price)
           VALUES (vt.account_id,vt.year_month,vt.phone_number,vt.option_code,vt.option_name,vt.option_parameters
                  ,vt.turn_on_date,vt.turn_off_date,vt.last_check_date_time,vt.turn_on_cost,vt.monthly_price)
           WHERE vt.option_code is not null;

     commit;



  --�������� �������� ����������
  INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                         IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID,BEELINE_RN)
  VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
   1,'Ok! Load '||counter||' rows.'||' �������:'||Snext_RN, 4,SRN);commit;

  EXCEPTION --�������� �������
      when others then  --log_EXCEPTION � ���������

      err:=err||' -- '||SQLERRM||'--'|| case
                                          when SQ_Value is null then ''
                                          else TsiteAddr(mod(SQ_Value,ServerCount)+1)
                                        end;
      INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, ACCOUNT_ID, LOAD_DATE_TIME,
                                 IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID,BEELINE_RN)
      VALUES(NEW_ACCOUNT_LOAD_LOG_ID, pACCOUNT_ID, SYSDATE,
           0,err||decode(Snext_RN,null,'',' �������:')||Snext_RN, 4,SRN);
      commit;
END;

begin
  -- Initialization
  --��������� ������ �������� !!!! ����� ����� ������� ���� ���. 3 ��.����� ����� ����� ';'����������� ��3-�
 TempField:=MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS');
 ServerCount:=(LENGTH(MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS'))
    -LENGTH(REPLACE(MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS') , ';'))); --���������� �������
  for n in 1..ServerCount
   loop
    TsiteAddr(n):= substr(TempField,1,instr(TempField,divider,1,1)-1);
    TempField:= substr(TempField,instr(TempField,divider,1,1)+1);
   end loop;

END;
/