--#if GetVersion("SMS_SYSTEM_ERROR_NOTICE") < 8 then
create or replace procedure SMS_SYSTEM_ERROR_NOTICE is
--#Version=8
--8 26.12.2013 ����� ������� ����� ����� ������� loyal_block
--7 16.08.2013 ����� �������� ������� ��������� �����������
--6 ����� PRC_LOG_WORK_SERVICE (����������� ������ ��������) ������ �������� ��������� API
--5 06.08.2013 ��� ������� �������� ������ ��� �������� API
--4 04.08.2013 ����� ������� ������� ��������
--3 19.07.2013 ��� ���������� � ���������� �������� ������ ������� USSD
--2 18.07.2013 ��� ���������� � ���������� �������� ������ ������� teletie(Apache) �������
  msg varchar2(300);--����� ���-���������;

  msgK7 varchar2(300);--����� ���-���������;
  --
  Sresponce varchar2(3000);
 -- err1 varchar2(3000);
  --
  TYPE T_OBJNAME IS TABLE OF VARCHAR2(128);
  OBJ1 T_OBJNAME;
  s1 varchar2(128);
  type Serv_table is table of varchar2(1000) INDEX BY binary_integer;TsiteAddr Serv_table;
  TempField varchar2(600);
  function get_type_active(type_value in varchar2)return number is
    begin
      return strInLike(type_value,MS_PARAMS.GET_PARAM_VALUE('SMS_SYSTEM_ERROR_NOTICE_TYPES'),';','()');
    end;
    --HotBilling
  function check_HB return number is
    result number;
    Ssql varchar2(32000);
   begin
    if ms_constants.GET_CONSTANT_VALUE('SERVER_NAME')='CORP_MOBILE' then
     ssql:='begin
     select max(t) into :result
     from ( select count(*) as t
            from hot_billing_files hbf
            where hbf.load_edate is null and substr(hbf.file_name,-3)=''dbf''
            and hbf.load_sdate<=sysdate-to_number(MS_params.GET_PARAM_VALUE(''DELAY_NOTICE_HOT_BILL_ERROR''))/24
            union all
            select case
                   when max(to_date(substr(hbf.file_name, -19, 15), ''yyyymmdd-hh24miss'')) <=sysdate-to_number(MS_params.GET_PARAM_VALUE(''DELAY_NOTICE_HOT_BILL_ERROR''))/24 then 1 else 0
                   end case
            from hot_billing_files hbf where substr(hbf.file_name,-3)=''dbf'') ;
      exception
       when others then :result:=1;
     end;';
    elsif ms_constants.GET_CONSTANT_VALUE('SERVER_NAME')='GSM_CORP' then
     ssql:='begin
     select PKG_TRF_FILEAPI.getFileCount(''D:\\ftp\\gsm\\BEELINE\\BILLING\\POSTPAID'') into :result from dual;
     end;';
    else return 0;
    end if;
    execute immediate ssql using in out result;
    if  ms_constants.GET_CONSTANT_VALUE('SERVER_NAME')='GSM_CORP' and result<4 then result:=0;end if;
    return result;
   end;
    --Report data
  function check_Report(num in number) return number is
    result number;
    begin
     select case sysdate-max(load_date_time)
            WHEN 0 then 0.00000001
            ELSE sysdate-max(load_date_time)
            end into result
            from ACCOUNT_LOAD_LOGS WW
            WHERE WW.ACCOUNT_LOAD_TYPE_ID=num AND IS_SUCCESS=1 ;
    if result>0.1 then result:=1; else result:=0;end if;
    return result;
    exception
     when others then return 1;
    end;
--max 1 sms per 12 h.
  Function sms_not_exists(var in varchar2) return boolean is
    c number;
    begin
      select count(*) into c from log_send_sms t where
      t.date_send>sysdate-720/1440 and t.sms_text like '%'||var||'%';
      if c>0 then return false; else return true;end if;
    exception
      when no_data_found then return true;
      when others then return false;
    end;
--sms send
  Procedure send_sys_msg(message in varchar2) is
      sFld varchar2(200);
      nPozDivider number;
      nIndexField number;
      sTMP varchar2(1000);
      res varchar2(300);
    begin
      sTMP:=MS_PARAMS.GET_PARAM_VALUE('SMS_SYSTEM_ERROR_NOTICE_PHONES');
      nIndexField:=0;
      loop--������� ������
      nPozDivider:=instr(sTMP,';',1,1);
      sFld:= substr(sTMP,1,nPozDivider-1);
      sTMP:= substr(sTMP,nPozDivider+1);
        res:=loader3_pckg.SEND_SMS(sfld,'system',message);
      nIndexField:=nIndexField+1;
      exit when nPozDivider is null;
      end loop;
    end;
--sms send ��� �7
  Procedure send_sys_msg_K7(message in varchar2) is
      sFld varchar2(200);
      nPozDivider number;
      nIndexField number;
      sTMP varchar2(1000);
      res varchar2(300);
    begin
      sTMP:=MS_PARAMS.GET_PARAM_VALUE('PHONE_NOTICE_TELETIE_ERROR');
      nIndexField:=0;
      loop--������� ������
      nPozDivider:=instr(sTMP,';',1,1);
      sFld:= substr(sTMP,1,nPozDivider-1);
      sTMP:= substr(sTMP,nPozDivider+1);
        res:=loader3_pckg.SEND_SMS(sfld,'system',message);
      nIndexField:=nIndexField+1;
      exit when nPozDivider is null;
      end loop;
    end;

    -- �������� �������� job, ������� ����������� ������ 15 �����.
    function check_hovering_jobs return number is
     tmpCnt Number;
    begin
      select count(*) INTO tmpCnt from (select job_name, sysdate-last_start_date from DBA_SCHEDULER_JOBS where (job_name like 'J_LOAD_REPORT%' OR job_name like 'J_LOAD_PHONES%' 
      OR job_name like 'J_LOAD_PAYMENTS%'
      OR job_name like 'J_LOAD_DETAILS%') AND STATE='RUNNING' AND (last_start_date)<sysdate-40/1440); 
      return tmpCnt;
    end;

    -- �������� job �� �����-�������� ���������.
    function check_Block_Unlock return number is
     tmpCnt Number;
    begin
      select count(*) INTO tmpCnt from (select * from dba_scheduler_jobs r where r.job_name like 'J_%LOCK_CLIENT%' and r.ENABLED!='TRUE');
      return tmpCnt;
    end;
    --�������� ������ ��������
    Function check_loader_servers return varchar2
      is
  ServerCount integer;
  req        utl_http.req;--������
  resp       utl_http.resp;--�����
  urls       varchar2(100);
  result varchar2(200);
      begin
      TempField:=MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS');
      ServerCount:=(LENGTH(MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS'))
      -LENGTH(REPLACE(MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS') , ';'))); --���������� �������
        for n in 1..ServerCount
         loop
          TsiteAddr(n):= substr(TempField,1,instr(TempField,';',1,1)-1);
          TempField:= substr(TempField,instr(TempField,';',1,1)+1);
         end loop;

      for c in 1..ServerCount loop
       urls :=TsiteAddr(c);
          begin
          utl_http.set_transfer_timeout(30);
          req:= utl_http.begin_request(urls);
          utl_http.set_body_charset(req,'UTF-8');
          resp := utl_http.get_response(req);
          if resp.status_code in (200,304) then result:=result+'';
          else result:=result+TsiteAddr(c);
          end if;
          UTL_HTTP.END_RESPONSE(resp);
          exception
          when others then
          if nvl(resp.status_code,0)>0 then UTL_HTTP.END_RESPONSE(resp);end if;
          result:=result||TsiteAddr(c);
          end;
      end loop;
if length(result)<2 then result:=null;end if;
return result;
end;

--�������� ������ �� ���������� ������
  Function check_server(s_url in varchar2) return integer
      is
  req        utl_http.req;--������
  resp       utl_http.resp;--�����
  result integer;
      begin
          begin
          UTL_HTTP.set_wallet('file:C:\oracle_wallets', '082g625p4Y412sD');
          utl_http.set_transfer_timeout(10);
          req:= utl_http.begin_request(s_url);
          utl_http.set_body_charset(req,'UTF-8');
          resp := utl_http.get_response(req);
          if resp.status_code in (200) then result:=1;
          else result:=0;
          end if;
          UTL_HTTP.END_RESPONSE(resp);
          exception
          when others then
            dbms_output.put_line(sqlerrm);
          if nvl(resp.status_code,0)>0 then UTL_HTTP.END_RESPONSE(resp);end if;
          result:=0;
          end;
return result;
end;
--�������� ������������ TableSpace
Function check_ts_size return integer
  is
result integer;
begin
select a.tablespace_name||' '||to_char(round(100-a.free_space/(tbs_size/100)))||'%',1 into Sresponce,result
from
(select tablespace_name, round(sum(bytes)/1024/1024 ,2) as free_space
from dba_free_space group by tablespace_name) a,
(select tablespace_name, sum(bytes)/1024/1024 as tbs_size
from dba_data_files group by tablespace_name
UNION
select tablespace_name, sum(bytes)/1024/1024 tbs_size
from dba_temp_files
group by tablespace_name ) b
where a.tablespace_name(+)=b.tablespace_name and
a.tablespace_name not like 'CALL%' and a.tablespace_name not in ('SYSAUX','SYSTEM','UNDOTBS1') 
and(100-a.free_space/(tbs_size/100))>90;
return result;
exception
  when others then return 0;
end;

-----�������� ����
begin
  msg:=null;
  msgK7:=null;
  
--e-care
  if check_server('https://my.beeline.ru/')=1 then  Sresponce:=ms_constants.SET_CONSTANT_VALUE('TEST_e-Care_PASS_OK','1');
     else Sresponce:=ms_constants.SET_CONSTANT_VALUE('TEST_e-Care_PASS_OK','0');
  end if ;
--old_cab
  if check_server('http://cabinet.beeline.ru/')=1 then  Sresponce:=ms_constants.SET_CONSTANT_VALUE('TEST_Bee_Old_PASS_OK','1');
     else Sresponce:=ms_constants.SET_CONSTANT_VALUE('TEST_Bee_Old_PASS_OK','0');
  end if ;
if Sresponce is null then null;end if;
  commit;
  
if get_type_active('TS')=1 and check_ts_size=1 and sms_not_exists('TABLESPACE TOO FAT')
  then
msg:=msg||';'||Sresponce||':TABLESPACE TOO FAT;';
Sresponce:=null;
end if;
if get_type_active('HB')=1 and check_HB>0.5 and sms_not_exists('HotBilling long pause')
  then
msg:=msg||';HotBilling long pause;';
end if;
if get_type_active('B_UB')=1 and check_Block_Unlock>0 and sms_not_exists('Block-Unlock jobs disable')
  then
msg:=msg||';'||check_Block_Unlock||' Block-Unlock jobs disable;';
end if;
if get_type_active('RD')=1 and check_Report(6)>0 and sms_not_exists('ReportData Alert')
  then
msg:=msg||';ReportData Alert;';
end if;
if get_type_active('P')=1 and check_Report(1)>0 and sms_not_exists('Payments Alert')
  then
msg:=msg||';Payments Alert;';
end if;
if get_type_active('ST')=1 and check_Report(3)>0 and sms_not_exists('State Alert')
then
msg:=msg||';State Alert;';
end if;
if get_type_active('SER')=1 then
   TempField:=check_loader_servers;
   if TempField is not null and sms_not_exists('Serv:%died')
      then msg:=msg||';Serv:'||TempField||' died;';
   end if;
end if;

if check_hovering_jobs>0 then begin    
 --select username INTO SCHEMA_ from v$session WHERE AUDSID = USERENV('sessionid');    
 --execute immediate 'select ''exec DBMS_SCHEDULER.DISABLE('''||chr(39)||job_name||chr(39)||''', TRUE);'' from DBA_SCHEDULER_JOBS where OWNER=''CORP_MOBILE''' BULK COLLECT INTO OBJ1;    
 execute immediate 'select owner||''.''||job_name from DBA_SCHEDULER_JOBS where (job_name like ''J_LOAD_REPORT%'' OR job_name like ''J_LOAD_PHONES%'' OR job_name like ''J_LOAD_PAYMENTS%'' OR job_name like ''J_BLOCK_%'' OR job_name like ''J_UNBLOCK_CLIENT%'' OR job_name like ''J_LOAD_DETAILS%'') AND STATE=''RUNNING'' AND (last_start_date)<sysdate-25/1440' BULK COLLECT INTO OBJ1;    
 for A IN 1..OBJ1.LAST LOOP    
  s1:=OBJ1(A);    
  s1:='begin DBMS_SCHEDULER.STOP_JOB('''||s1||''', TRUE); end; ';    
  --if not to_number(to_char(sysdate,'HH24')) between 0 and 8 then    
   --msg:=msg||';h_j:'||s1;    
  --end if;    
  begin    
   execute immediate s1;    
--   dbms_output.put_line(s1);    
  EXCEPTION    
   WHEN OTHERS THEN    
   dbms_output.put_line('������ ');    
   dbms_output.put_line(s1);    
  END;     
 END LOOP;    
end;    
end if;  

if msg is not null then send_sys_msg(msg);end if;
if msgK7 is not null then send_sys_msg_K7(msgK7);end if;
--� ������� �������� ������ ���������
--api
  /*begin
    Sresponce:=beeline_soap_api_pckg.auth('Nikolayk7','N499854');
    err1:=null;
    if instr(Sresponce,' ')>0 then
      err1 := Sresponce;
    end if;
    merge into LOG_WORK_SERVICE LOG USING (select 'AUTH' SERVICE_NAME,null REPORT_TYPE,1 ACCOUNT_ID,sysdate DATE_TIME,'API' SERVER_TYPE,null SERVER_ADDRES,DECODE(err1,null,0,1) ERR,err1 ERR_TEXT from dual) TT
     ON (LOG.SERVICE_NAME=TT.SERVICE_NAME AND LOG.ACCOUNT_ID=TT.ACCOUNT_ID AND LOG.SERVER_TYPE=TT.SERVER_TYPE AND LOG.ERR=TT.ERR)
     WHEN MATCHED THEN UPDATE SET LOG.DATE_TIME=sysdate
     WHEN NOT MATCHED THEN INSERT (SERVICE_NAME,REPORT_TYPE,ACCOUNT_ID,DATE_TIME,SERVER_TYPE,SERVER_ADDRES,ERR,ERR_TEXT)
     VALUES (TT.SERVICE_NAME,TT.REPORT_TYPE,TT.ACCOUNT_ID,TT.DATE_TIME,TT.SERVER_TYPE,TT.SERVER_ADDRES,TT.ERR,TT.ERR_TEXT);

  end; */

 --PRC_LOG_WORK_SERVICE;

end SMS_SYSTEM_ERROR_NOTICE;
/
--#end if
