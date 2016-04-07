CREATE OR REPLACE PACKAGE RUBY_ROBOT_PCKG
AS
   --#Version=1
   --
   --v1  17,10,2014 -������� �.�. - ����� ������� Ruby � ���� �����
   --
   -- ����� ������� �������.

   --������� ����������
   FUNCTION create_conn (lgn           IN     VARCHAR2,
                         pss           IN     VARCHAR2,
                         report_type   IN     NUMBER,
                         answer           OUT BLOB,
                         phone         IN     VARCHAR2 DEFAULT 0,
                         year_month in varchar2 default 0
                         )
      RETURN VARCHAR2;

   --����� � ����
   PROCEDURE create_rpt_log_tbl (report_type    IN NUMBER,
                                 p_account_id   IN NUMBER,
                                 blFile         IN BLOB,
                                 filename       IN VARCHAR2);
END;
/
CREATE OR REPLACE PACKAGE BODY RUBY_ROBOT_PCKG AS
  
  Divider varchar2(1):=chr(59);--�����������
  NDS number:=1.18; --������ ���
  const_year_month number; -- ������� �����-���
  SQ_Value integer;  --������� �������� Sequnce
  type Rheader is record (h_name varchar2(50)
                         ,h_value varchar2(200));
  type header_table is table of Rheader INDEX BY binary_integer;
  type loader_table is table of varchar2(1000) INDEX BY binary_integer;
  Tloader           loader_table;--������ ���������� html
  Theader           header_table;--��������� html
  TsiteAddr         loader_table;
  TempField varchar2(300);
  ServerCount integer;--����� ��� ��������
/*======��� ����������� ��������======*/
  type Rcollector is record(p_n varchar2(15)
                           ,ban varchar2(15)
                           ,acc integer);
  type Tcollector_table is table of Rcollector INDEX BY binary_integer; 
  collector_table   Tcollector_table;                                                   
/*===���������� ��� ������� �������===*/
  Snum_Rep varchar2(15); --��� �������� ���������
  Sobj_ids varchar2(500);
  Syear_month varchar2(200);
/*=======*/

/**/
/*=======================================*/
/*=============== ����������� ===========*/
/*=======================================*/
function create_conn (lgn in varchar2,
                      pss in varchar2,
                      report_type in  number,--6 ReportData,1 Payments ,7 Lock Phone
                      answer out blob,
                      phone in varchar2 default 0,
                      year_month in varchar2 default 0
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
     
      select ACCOUNT_LOAD_TYPE_URL into urls from ACCOUNT_LOAD_TYPES where ACCOUNT_LOAD_TYPE_ID = report_type;
     
      urls := TsiteAddr(mod(SQ_Value,ServerCount)+1) || urls;
     
      urls := Replace(urls, '%LOGIN%', lgn);  
      urls := Replace(urls, '%PASSWORD%', pss);
      urls := Replace(urls, '%START_DATE%', to_char(sysdate-nvl(MS_PARAMS.GET_PARAM_VALUE('LOADER_N_PAYMENTS_DAY'),0),'DD.MM.YY'));
      urls := Replace(urls, '%END_DATE%', to_char(sysdate,'DD.MM.YY'));
      urls := Replace(urls, '%NUM_REP%', Snum_rep);
      urls := Replace(urls, '%DD_MM_YYYY_-DD_MM_YYYY%', Syear_month);
      urls := Replace(urls, '%OBJ%', Sobj_ids);
      urls := Replace(urls, '%PHONE_NUMBER%', phone);
      urls := Replace(urls, '%YYYYMM%', year_month);

      begin
        utl_http.set_transfer_timeout(MS_PARAMS.GET_PARAM_VALUE('USS_BEELINE_LOADER_TIME_OUT'));--��������� �������� 5 �����. ( ��� ? )
        req:= utl_http.begin_request(urls);
        utl_http.set_body_charset(req,'UTF-8');
        resp := utl_http.get_response(req);
        if resp.status_code>0 then 
          exit;
        end if;--���� ���� ��������� ���������� �������
      exception
        when others then --���� ���������� �� ������, ������� ��� 2 ����, � ������ 20 ���.
          if c<3 then 
            dbms_lock.sleep(20);
          else
            err := resp.status_code||' Error! ���������� ���������! '||chr(13)||sqlerrm;
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
      err := err||'���:'||nvl(resp.status_code,0);
      if nvl(resp.status_code,0)>0 then 
       UTL_HTTP.END_RESPONSE(resp);
      end if;
     
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
      --��� ����
      if report_type in (1,9,10,31) then 
        raw_buf := utl_raw.cast_to_raw(convert(line,'CL8MSWIN1251','UTF8'));--����������� � raw-bufer
      else 
        raw_buf := utl_raw.cast_to_raw(line);
      end if;
      
      i:=i+1;
      --��� ������� �������
      if report_type in (3,4) then 
        Tloader(i) := convert(line,'utf8','CL8MSWIN1251');
      elsif report_type = 5 and i>1 then 
        Tloader(i) := replace(convert(line,'AL32UTF8','CL8MSWIN1251'),';;','; ;');
      else 
        Tloader(i) := line;  
      end if;
      dbms_lob.append(answer,raw_buf);--� blob
    end loop;
  exception
    when others then--� ����� ������ ��������� ����������
      UTL_HTTP.END_RESPONSE(resp);
  end;
  
  if dbms_lob.getlength(answer)!=0 and (not nvl(resp.status_code,999)>200) then
    return('OK'); --��� ���������� � ����
  elsif dbms_lob.getlength(answer)=0 then 
    Return('��� �����������! ���:'||resp.status_code||' '||sqlerrm);
  elsif nvl(resp.status_code,999)>200 then 
    Return('������ ����������! ���:'||resp.status_code);
  end if;--��� ����������� ����������
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
  (p_account_id, sysdate, filename, blFile,report_type)
  ;

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
/*==== �������� ���� ����������� ������==*/
/*=======================================*/
function  create_rpt_log (report_type in number, account in varchar2, blFile in blob, filename in varchar2)
  return varchar2
  is
ft  utl_file.file_type;
sTIMESTAMP varchar2(50);
sDEBUGFOLDER varchar2(120);
sHTTPdir varchar2 (100);
nFLAG binary_integer:=0;
--
folder varchar2(20);
error varchar2(500);
clob_len integer;
pos integer:=1;
raw_buf raw(32767);
amount binary_integer := 32760;--��� ������ blob
BEGIN
 case report_type
   when 9 then folder:='lock';
   when 10 then folder:='unlock';
   when 6 then folder:='report_data';
   when 1 then folder:='payments';
 end case;
sTIMESTAMP := to_char(sysdate,'hh')||'_'||to_char(sysdate,'mm')||'_'||to_char(sysdate,'ss');
sDEBUGFOLDER:=MS_PARAMS.GET_PARAM_VALUE('LOADER_LOG_DIR')||'\DB\'||const_year_month||'\'||account||'\'||folder;--dir �� �����
sHTTPdir:='DIR'||account||sTIMESTAMP;--dir � oracle
nFLAG := PKG_TRF_FILEAPI.mkdirs(sDEBUGFOLDER);--������ ������
  if nFLAG>0 then
    execute immediate 'create or replace directory '||sHTTPDIR||' as '''||sDEBUGFOLDER||'''';
    execute immediate 'grant read, write on directory '||sHTTPDIR||' to public';
  end if;
error:='DIRECTORY CREATED!';--� ������ ������ ������ �� ���, ��� �������� ������ directory
ft:=utl_file.fopen(UPPER(sHTTPDIR),filename,'W');
        clob_len := dbms_lob.getlength(blFile);
          while pos<clob_len loop--���������� ���������� � ���� ������� �� 32��
            dbms_lob.read(blFile, amount, pos, raw_buf);
            utl_file.put_raw(ft,raw_buf);
            pos:=pos+amount;
          end loop;
          --� ����� ���������� ���������
          for i in Theader.first..theader.last loop--���������� header
            utl_file.put_line(ft,Theader(i).h_name);
            utl_file.put_line(ft,Theader(i).h_value);
          end loop;
          utl_file.fCLOSE(ft);
execute immediate 'drop directory '||sHTTPDIR;
return('OK');
exception
when others then
  error:=error||sqlerrm;
  if utl_file.is_open(ft) then
    utl_file.fCLOSE(ft);
  end if;
  return(error);
end;

procedure  create_rpt_log(report_type in number
                            , p_account_id in number
                            , blFile in blob
                            , filename in varchar2)is
var varchar2(1000);
begin
var:=create_rpt_log(report_type,p_account_id,blFile,filename);
if var='OK' then null; end if;
end;



begin
  -- Initialization
  --�����
  const_year_month:=to_number(to_char(sysdate,'YYYYMM'));
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