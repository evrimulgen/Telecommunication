--#if GetVersion("PRC_LOG_WORK_SERVICE") < 4 then
create or replace procedure PRC_LOG_WORK_SERVICE  is
--#Version=4 
--3 ��������� ��������� �������� is_collector �������  LOG_SPR_WORK_SERVICE 
--4 ���������� ��������� ��������� ������� � ������� check_server 
--declare 
   phone         varchar2(10) := null;  
  Snum_rep      number:= null;  
  type Serv_table is table of varchar2(1000) INDEX BY binary_integer;  
  TsiteAddr     Serv_table;  
  TempField     varchar2(600);  
  ServerCount   integer;  
  SQ_Value      integer;  
  req           utl_http.req; --������  
  resp          utl_http.resp; --�����  
  urls          varchar2(100);  
  pss           varchar2(30);  
  lgn           varchar2(30);  
  newpswd       varchar2(30);  
  pServerAddres varchar2(64);  
  pErr          number := 0;  
  err           varchar2(3000) := null;  
  null_var      varchar2(3000) := null;  
  vCount        number := 0;  
  pACCOUNT_ID   integer;  
  TsiteAddrStr  varchar2(512);  
  vErr          number:=0;  
  vRowid        varchar2(32);  
  pstatus_code  varchar2(10);  
  vCh           number;  
  
  function auth(login in varchar2,password in varchar2) return varchar2 as  
    soap_text varchar2(32767);  
    env       CLOB;  
    http_req  utl_http.req;  
    http_resp utl_http.resp;  
    url        varchar2(32767);  
    retxml  XMLTYPE;  
begin  
  
--��� ����� ��������������� SOAP  
soap_text:='<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:uss-wsapi:Auth">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:auth>
         <login>'||login||'</login>
         <password>'||password||'</password>
      </urn:auth>
   </soapenv:Body>
</soapenv:Envelope>';  
  
--� �������� ������������� ��������� ���������� HTTP  
url:=ms_constants.GET_CONSTANT_VALUE('BEELINE_SOAP_API_URL')||'/AuthService';  
http_req:= utl_http.begin_request(url, 'POST','HTTP/1.1');  
utl_http.set_body_charset(http_req, 'UTF-8');  
utl_http.set_header(http_req, 'Content-Type', 'text/xml');  
    utl_http.set_header(http_req, 'Content-Length', length(soap_text));  
    utl_http.set_header(http_req, 'SOAPAction', 'http://uatssouss.beeline.ru:80/api/AuthService/urn:uss-wsapi:Auth:AuthInterface:authRequest');  
    utl_http.write_text(http_req, soap_text);  
    http_resp := utl_http.get_response(http_req);  
    utl_http.read_text(http_resp, env);  
    utl_http.end_response(http_resp);  
    if http_resp.status_code = 200 then  
       retxml := sys.xmltype.createxml(env);  
       select extractValue(retxml,'S:Envelope/S:Body/ns0:authResponse/return','xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="urn:uss-wsapi:Auth"') into url from dual;  
    else  
      url:='API �� ��������: '||to_char(http_resp.status_code)||' '||http_resp.reason_phrase;  
    end if;  
return url;  
end;  
  
Function check_server(s_url in varchar2, fErr out number, fErr_text out varchar2, fStatus out varchar2 ) return number  
      is  
  req        utl_http.req;--������  
  resp       utl_http.resp;--�����  
  result     integer;  
      begin  
        
          begin  
          --utl_http.set_transfer_timeout(10); 
            
          req:= utl_http.begin_request(s_url);  
          utl_http.set_body_charset(req,'UTF-8');  
          resp := utl_http.get_response(req);  
  
         fStatus:=resp.status_code;
          
        if resp.status_code=200 then  
         fErr := 0;  
         fErr_text:=null; 
         end if; 
         
         if fStatus<>'200' then 
         utl_http.read_line(resp,err);
         fErr := 1;  
         fErr_text:=err;       
         end if; 
         
            -- ��������� ����������  
        if resp.status_code > 0 then UTL_HTTP.END_RESPONSE(resp); end if;  
         exception  
        when others then  
          fErr_text  := resp.status_code || ' Error! ���������� ���������! ' || chr(13) || sqlerrm;  
          fErr := 1;  
          begin  
            UTL_HTTP.END_RESPONSE(resp); -- ��������� ����������  
          exception  
            when others then  
              null;  
          end;  
      end;  
      
return nvl(result,-1);  

end;  
  
  
  procedure ins_log(p_LOG_SPR_ID   in number,  
                    p_account_id   in integer,  
                    p_ServerAddres in varchar2,  
                    p_Err          in number,  
                    p_Err_text     in varchar2) is  
  
    insCount number;  
  
    CURSOR get_err IS  
      select decode(err,0,0,1) err, rowid  
        from LOG_WORK_SERVICE  
       where LOG_SPR_ID=p_LOG_SPR_ID  
         and nvl(server_addres,'-1') = p_ServerAddres  
         and date_time =  
             (select max(date_time)  
                from LOG_WORK_SERVICE  
               where LOG_SPR_ID=p_LOG_SPR_ID  
                 and nvl(server_addres,'-1') = nvl(p_ServerAddres,'-1'));  
  
  begin  
    --������� ������ � LOG_WORK_SERVICE  
       begin  
      OPEN get_err;  
      -- Use operator FETCH to get variables!  
      FETCH get_err  
        INTO vErr, vRowid;  
  
      IF (get_err%NOTFOUND) or (vErr <> p_Err) THEN  
        INSERT into LOG_WORK_SERVICE  
          (LOG_SPR_ID,  
           ACCOUNT_ID,  
           DATE_TIME,  
           SERVER_ADDRES,  
           ERR,  
           ERR_TEXT)  
        VALUES  
          (p_LOG_SPR_ID,  
           p_account_id,  
           sysdate,  
           decode(p_ServerAddres,'-1','',p_ServerAddres),  
           p_Err,  
           p_Err_text);  
      end if;  
  
      if vErr = p_Err then  
        update LOG_WORK_SERVICE  
           set date_time = sysdate, ERR=decode(vErr,0,0,ERR+1), account_id=p_account_id,  
  ERR_TEXT=p_Err_text  
         where rowid = vRowid;  
       
      end if;  
      commit;  
      CLOSE get_err;  
    exception  
      when others then                      
        null;  
    end;  
  end;  
  
begin  
  -- ����������� ���������� �������� �� ������ �������  ACCOUNTS  
  
  select ACCOUNT_ID, login, password, new_pswd  
    INTO pACCOUNT_ID, lgn, pss, newpswd  
    from (select ACCOUNT_ID, login, nvl(new_pswd, password) password, nvl(new_pswd, password) new_pswd  
            from ACCOUNTS where account_id !=( select IS_COLLECTOR from LOG_SPR_WORK_SERVICE where nvl(IS_COLLECTOR,-1)<>-1 and rownum = 1) 
            order by dbms_random.value())  
   where rownum <= 1; 
     
  for m in (select * from LOG_SPR_WORK_SERVICE order by LOG_SPR_ID) loop  
     
  if nvl(m.is_collector,-1)<>-1 then  
    select ACCOUNT_ID, login, password, new_pswd  
    INTO pACCOUNT_ID, lgn, pss, newpswd  
    from ACCOUNTS where ACCOUNT_ID=m.is_collector; 
    end if; 
     
    TempField   := MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS');  
    ServerCount := (LENGTH(MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS')) -  
                   LENGTH(REPLACE(MS_PARAMS.GET_PARAM_VALUE('ROBOT_SITE_ADRESS'),  
                                   ';'))); --���������� �������  
    SQ_Value    := sq_get_server.nextval;  
  
    for n in 1 .. ServerCount loop  
      begin  
        pErr := 0;  
        err := null;  
        TsiteAddr(n) := substr(TempField,  
                               1,  
                               instr(TempField, ';', 1, 1) - 1);  
        TempField := substr(TempField, instr(TempField, ';', 1, 1) + 1);  
        pServerAddres := TsiteAddr(n);  
  
      if m.SERVER_TYPE='NEW_CAB' then  
        urls := TsiteAddr(mod(SQ_Value, ServerCount) + 1)||m.report_type_str;  
      end if;  
  
      exception  
        when others then  
          err := m.report_type || '! pServerAddres=' || TsiteAddr(n) ||  
                 chr(13) || sqlerrm;  
          null;  
      end;  
  
    if m.SERVER_TYPE in ('NEW_CAB') then  
        utl_http.set_transfer_timeout(10);  
        SQ_Value := sq_get_server.nextval;  
  dbms_output.put_line('urls='||urls);
      vCh:=check_server(urls, pErr,err,pstatus_code );  
      ins_log(m.log_spr_id,paccount_id,pServerAddres,pErr,Err);  
       end if;  
  
    end loop;  
  
if m.SERVER_TYPE='OLD_CAB' then  
     pErr := 0;  
     err:=null;  
          urls := m.report_type_str;  
          vCh:=check_server(urls, pErr,err,pstatus_code );  
  
       if pstatus_code in (200) then pErr:=0;  
         else pErr:=1;  
             end if;  
  
        ins_log(m.log_spr_id,paccount_id,m.report_type_str,pErr,Err);  
         end if;  
  
     -- API  
   if m.SERVER_TYPE='API' then  
     begin  
     null_var:=beeline_soap_api_pckg.auth(lgn,newpswd); -- �� ������� ������� �����, ���� �������� ��������� ������� auth �� ������ beeline_soap_api_pckg  
     -- null_var:=auth(lgn,newpswd);  
      pErr := 0;  
      err:='';  
        
   if instr(null_var,' ')>0 then  
      pErr := 1;  
      err := null_var;  
    end if;          
     
   exception  
  when others then  
      pErr := 1;  
      err:=sqlerrm;  
      end;  
       
      ins_log(m.log_spr_id,paccount_id,-1,pErr,Err);  
      
    end if;  
    
  end loop; -- ����� ����� �� ������� LOG_SPR_WORK_SERVICE  
  
exception  
  when others then  
            null;  
  
end;
/
--#end if

