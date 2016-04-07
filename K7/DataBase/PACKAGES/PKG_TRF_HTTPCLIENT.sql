CREATE OR REPLACE package PKG_TRF_HttpClient
is

  /* ��������� ������ */
  sWALLET_DIR     constant  varchar2(100) := 'file:D:\Work\WALLET';
  sWALLET_PASS    constant  varchar2(100) := 'qwerty12345';
  sDBROOT         constant  varchar2(100) := 'D:\Work\HTTP_LOG';         -- �������� ����������
  sTEMPERRORMESS  constant  varchar2(100) := '������ �������';

  /* ���� ��������� ������������ �������� ������� ���������� ������� */
  type arr is record
  (
    id     binary_integer,
    name   varchar2(32000),
    value  varchar2(32000)
  );
  type arr_table is table of arr index by binary_integer;
  cARR   arr_table;
  IndexParams     integer := 1;          -- ������� ������� �������

  /* ���������� ������ */
  sLOADERNAME     varchar2(40);          -- ��� �����������
  dDATE           date;                  -- ������� ���� � �����
  sHTTP_DIR       varchar2(1000);        --
  sDATESTAMP      varchar2(100);         -- ������������� (������� ����)
  sTIMESTAMP      varchar2(100);         -- ������������� (������� �����)
  sDBCATALOG      varchar2(1000);        -- ���������� ???
  sDEBUGFOLDER    varchar2(1000);        -- ���������� ������
  sSUBFOLDER      varchar2(100);         -- �������������
  sURL            varchar2(100);         -- ����� �������� (URL)
  nSESSION        integer;               -- ������������� ������� ������
  nID             integer;               -- ������������� ������� ������

  uREQUEST        utl_http.req;          -- ������ �� ����
  uRESPONSE       utl_http.resp;         -- ����� � �����
  sREQUEST_TEXT   varchar2(32000);        -- ������������������ ������

  sLOGIN          varchar2(1000);        -- �����
  sFILE           utl_file.file_type;    -- ��� ����� ��������
  sFILE_TYPE      varchar2(20);          -- Success/Failed

  sNAME           varchar2(1000);        -- ��� ��������� ������
  sVALUE          varchar2(32000);        -- �������� ��������� ������

  sLINE           varchar2(32767);       -- ������ html
  cCLOB           clob;                  -- ����� ����� � ����������
  cHTML           clob;                  -- ����� ����� html

  sLOGERROR       varchar2(100);         -- ����� ������
  sERRORTEXT      varchar2(100);         -- ����� ������

   /* ������� �������� �������� ��������� �� XML */
  function ExtractDataFromXML
  (
    sXML   in varchar2,
    sPARAM in varchar2
  )
  return varchar2;


  /* ������� �������� ��������� */
  function ExtractDataFromString
  (
    sTEXT  clob,
    sBEG   in varchar2,
    sEND   in varchar2,
    nSTART  in integer default 1
  )
  return clob;


  /* ��������� ������������� ���������� */
  procedure Init
  (
    nFLAG  in boolean default true
  );


  /* ��������� ���������� ������� */
  procedure InsertTable;


  /* ��������� ������������� ������ � ���� */
  procedure SaveFile
  (
    sIN   in varchar2 default null,
    sOUT  in varchar2 default null,
    nNUMB in integer default 1
  );


  /* ��������� ���������� ������� */
  procedure Begin_Request
  (
    sURL  in varchar2,
    sMETHOD  in varchar default 'POST'
  );

  /* ��������� ���������� ��������� ������� */
  procedure Set_Header
  (
    sREFEREF  in varchar2 default null
  );


  /* ��������� ������������ ������ ������� */
  procedure AddRequestParameter
  (
   sNAME   in varchar2,
   sVALUE  in varchar2
  );


  /* ��������� ��������� ������ */
  procedure Get_Response;


  /* ��������� ���������� ������� */
  procedure End_Response;


  /* ������� �������� �������� clob �������� */
  function IsValidResult
  return boolean;

  /* ������� ���������� ����� */
  function SaveCookies
  return binary_integer;


  /* ��������� �������������� ����� */
  procedure RestoreCookies
  (
    nSESSION  in binary_integer
  );


  /* ��������� ������������ �������� */
  procedure MakeLoader;
  
  /* ��������� �������� �������� �� directory */
  procedure DropDirectory;

end PKG_TRF_HttpClient;
/

CREATE OR REPLACE package body PKG_TRF_HttpClient
is

 /* ������� �������� �������� ��������� �� XML */
 function ExtractDataFromXML
 (
 sXML in varchar2,
 sPARAM in varchar2
 )
 return varchar2
 is
 Result varchar2(4000);
 nBEG integer := 0;
 nEND integer := 0;
 begin

 /* ����������� ���������� � ��������� �������� ���� ��������� */
 nBEG := instr(sXML,'<'||upper(sPARAM)||'>') + length(sPARAM) + 2;
 nEND := instr(sXML,'</'||upper(sPARAM)||'>');

 /* ������������ � ����� ���������� �������� ��������� */
 Result := substr(sXML, nBEG, nEND - nBEG);
 return Result;

 end ExtractDataFromXML;


 /* ������� �������� ��������� */
 function ExtractDataFromString
 (
 sTEXT in clob,
 sBEG in varchar2,
 sEND in varchar2,
 nSTART in integer default 1
 )
 return clob
 is
 Result clob;
 nBEG integer := 0;
 nEND integer := 0;
 cTMP clob := null;
 begin

 /* ����������� ���������� � ��������� �������� ���� ��������� */
 nBEG := instr(sTEXT,sBEG,nSTART) + length(sBEG);

 cTMP := substr(sTEXT,nBEG,length(sTEXT)-nBEG+1);

 nEND := instr(cTMP,sEND);

 /* ������������ � ����� ���������� �������� ��������� */
 Result := substr(cTMP, 1, nEND-1);
 return Result;

 end ExtractDataFromString;


 /* ��������� ������������� ���������� */
 procedure Init
 (
 nFLAG in boolean default true
 )
 is
 begin
 sURL := null;
 cCLOB := null;
 cHTML := null;
 uRESPONSE := null;
 uREQUEST := null;
 sFILE_TYPE := null;
 sREQUEST_TEXT := null;
 IndexParams := 1;
 nID := null;
 sLOGERROR := null;
 sERRORTEXT := null;

 /* ������������� ������������ */
 utl_http.set_wallet(sWALLET_DIR, sWALLET_PASS);
 
 if nFLAG = true then
 sTIMESTAMP := null;
 sDATESTAMP := null;
 sHTTP_DIR := null;
 end if;

 end Init;


 /* ��������� ���������� ������� */
 procedure InsertTable
 is
 begin

 nID := gen_id;

 insert into pars_test(text,url,n, ses, header_param)
 values (cHTML, sURL, nID, nSESSION, cCLOB);
 commit;
 end InsertTable;


 /* ��������� ������ � ���� */
 procedure SaveFile
 (
 sIN in varchar2 default null,
 sOUT in varchar2 default null,
 nNUMB in integer default 1
 )
 is
 sFILENAME varchar2(40);
 begin

 if nNUMB = 1 then
 MakeLoader;
 end if;

 begin

 /* ������������� ���������� */
 cCLOB := null;
 cHTML := null;
 sLINE := null;
 dDATE := sysdate;


 /* ���������� ����� ����� */
 sFILENAME := to_char(dDATE,'yyyymmdd-hhmmss')||sFILE_TYPE||'_'||trim(to_char(nNUMB))||'.htm';
 sFILE := utl_file.fopen(sHTTP_DIR, sFILENAME, 'w', 32767);

 /* ��������� ��������� �������� */
 cCLOB := '<PRE>'||CHR(10)||
 '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">'||CHR(10)||
 'GET URL: '||sURL||CHR(10)||
 'Request: '||sREQUEST_TEXT||CHR(10)||
 'Status: '||uRESPONSE.status_code||CHR(10)||
 '--- Response Headers: ---';

 /* ������ � ���� */
 utl_file.put_line(sFILE, cCLOB);

 /* ��������� ������ ���������� ��� ��������� �������� */
 for n in 1..utl_http.get_header_count(uRESPONSE)
 loop
 utl_http.get_header(uRESPONSE, n, sNAME, sVALUE);
 cCLOB:= cCLOB||CHR(10)||sNAME||': '||sVALUE;
 utl_file.put_line(sFILE, sNAME||': '||sVALUE);
 end loop;

 /* ���������� ��������� �������� */
 cCLOB := cCLOB||CHR(10)||CHR(10)||'</PRE>';
 utl_file.put_line(sFILE, CHR(10)||CHR(10)||'</PRE>');

 /* ����������� ������������ clob �� ����������� htlm-���� ��� ������� � ������� */
 begin
 loop
 utl_http.read_line(uRESPONSE, sLINE, true);
 sLINE := utl_i18n.unescape_reference(sLINE);
 cCLOB:=cCLOB||CHR(10)||sLINE;
 cHTML:=cHTML||CHR(10)||sLINE;
 utl_file.put_line(sFILE, sLINE);
 end loop;
 exception
 when utl_http.end_of_body then
 dbms_output.put_line('!!! - '||sqlerrm);
 when others then
 dbms_output.put_line(sqlerrm);
 end;

 if sIN is not null and instr(cHTML, sIN) = 0 then
 dbms_output.put_line(sOUT);
 sERRORTEXT := sOUT;
	 end if;

 /* ���������� ������ � ������ */
 utl_file.fclose(sFILE);

 dbms_output.put_line('���� ������� �����������: '||sFILENAME);
 
 exception
 when others then
 dbms_output.put_line('������ ��� ������������ �����: '||sqlerrm||'. '||sSUBFOLDER||'_'||sTIMESTAMP);
 utl_file.fclose(sFILE);
 end;

 end SaveFile;


 /* ��������� ���������� ������� */
 procedure Begin_Request
 (
 sURL in varchar2,
 sMETHOD in varchar default 'POST'
 )
 is
 begin
 dbms_output.put_line('*****************************************************');
 begin
 dbms_output.put_line('������ ������� '||sURL);
 uREQUEST := utl_http.begin_request(sURL, sMETHOD, utl_http.HTTP_VERSION_1_1);
 exception
 when utl_http.request_failed then
 dbms_output.put_line('Request_Failed: '||utl_http.get_detailed_sqlerrm);
 utl_http.end_request(uREQUEST);
 when utl_http.http_server_error then
 dbms_output.put_line('Http_Server_Error: ' ||utl_http.get_detailed_sqlerrm);
 utl_http.end_request(uREQUEST);
 when utl_http.http_client_error then
 dbms_output.put_line('Http_Client_Error: '||utl_http.get_detailed_sqlerrm);
 utl_http.end_request(uREQUEST);
 when others then
 dbms_output.put_line('������ �������: '||sqlerrm);
 utl_http.end_request(uREQUEST);
 end;
 end Begin_Request;


 /* ��������� ���������� ��������� ������� */
 procedure Set_Header
 (
 sREFEREF in varchar2 default null
 )
 is
 begin
 begin
 dbms_output.put_line('��������� ���������');
 utl_http.set_body_charset('windows-1251');
 utl_http.set_header(uREQUEST, 'Accept-Language', 'ru,en-us;q=0.5');
 utl_http.set_header(uREQUEST, 'Accept-Charset', 'windows-1251,utf-8;q=0.7,*;q=0.7');
 utl_http.set_header(uREQUEST, 'Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
 utl_http.set_header(uREQUEST, 'User-Agent', 'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.15) Gecko/20110303 Firefox/3.6.15');
 utl_http.set_header(uREQUEST, 'Connection', 'Keep-Alive');
 utl_http.set_header(uREQUEST, 'Cache-Control', 'no-cache');
 utl_http.set_header(uREQUEST, 'Accept-Encoding', 'gzip, deflate');
 utl_http.set_header(uREQUEST, 'Content-Type', 'application/x-www-form-urlencoded');
 
 if length(sREQUEST_TEXT) > 0 then
 utl_http.set_header(uREQUEST, 'Content-Length', length(sREQUEST_TEXT));
 
 /* ���������� � ��������� ���������� ������� */
 utl_http.write_text(uREQUEST, sREQUEST_TEXT);
 end if;
 
 if sREFEREF is not null then
 utl_http.set_header(uREQUEST, 'Referer', sREFEREF);
 end if;

 /* ��������� ���������� ������� ����������� */
 utl_http.set_follow_redirect(uREQUEST, 3);
 
 exception
 when others then
 dbms_output.put_line('������ ������������ ���������: '||sqlerrm);
 end;
 end Set_Header;


 /* ��������� ������������ ������ ������� */
 procedure AddRequestParameter
 (
 sNAME in varchar2,
 sVALUE in varchar2
 )
 is
 begin

 /* ���������� ������� ������������ ��������� */
 if sREQUEST_TEXT is not null then
 sREQUEST_TEXT := sREQUEST_TEXT||'&';
 end if;

 /* ������������ ������ ��������� */
 sREQUEST_TEXT := sREQUEST_TEXT||sNAME||'='||sVALUE;

 /* ������ � ������ ���������� */
 cARR(IndexParams).id := IndexParams;
 cARR(IndexParams).name := sNAME;
 cARR(IndexParams).value := sVALUE;

 /* ��������� �������� ������� ������� ���������� */
 IndexParams := IndexParams + 1;

 end AddRequestParameter;


 /* ��������� ��������� ������ */
 procedure Get_Response
 is
 begin
 begin
 uRESPONSE := utl_http.get_response(uREQUEST/*, true*/);
 dbms_output.put_line('����� �������. ������ ������: '||uRESPONSE.status_code);
 exception
 when others then
 dbms_output.put_line('������ ������: '||sqlerrm);
 end;

 if uRESPONSE.status_code = utl_http.HTTP_OK then
 sFILE_TYPE := ' Success';
 else
 sFILE_TYPE := ' Failed';
 end if;

 end Get_Response;


 /* ��������� ���������� ������� */
 procedure End_Response
 is
 begin
 utl_http.end_response(uRESPONSE);
 end;


 /* ������� �������� �������� clob �������� */
 function IsValidResult
 return boolean
 is
 Result boolean := true;
 begin

 /* �������� clob �������� */
 if cHTML is null then
 Result := false;
 sLOGERROR := '��� ������.';
 -- �������� �� �������� ������
 elsif instr(cHTML, sTEMPERRORMESS) > 0 then
 Result := false;
 sLOGERROR := sTEMPERRORMESS;
 -- �������� ��
 elsif Instr(cHTML, '��������� ������ ��� ������ � ��������') > 0 then
 Result := false;
 sLOGERROR := '��������� ������ ��� ������ � ��������.';
 else
 Result := true;
 end if;

 return Result;

 end;


 /* ������� ���������� ����� */
 function SaveCookies
 return binary_integer
 is
 cookies utl_http.cookie_table;
 secure varchar2(1);
 begin

 /* ��������� ����� � ����� */
 utl_http.get_cookies(cookies);

 /* ��������� �������������� ������ */
 select session_id.nextval
 into nSESSION
 from dual;

 /* ���� �� ���������� ����� � ����� */
 for i in 1..cookies.count
 loop

 /* �������������� ����������� ��������� � ������ */
 if (cookies(i).secure) then
 secure := 'Y';
 else
 secure := 'N';
 end if;

 /* ������� � ������� */
 insert into my_cookies(session_id, name, value, domain, expire, path, secure, version)
 values(nSESSION, cookies(i).name, cookies(i).value,
 cookies(i).domain, cookies(i).expire, cookies(i).path, secure,
 cookies(i).version);
 end loop;
 commit; -- �������� ����������

 /* ������� �������������� ������� ������ */
 return nSESSION;
 
 end SaveCookies;


 /* ��������� �������������� ����� */
 procedure RestoreCookies
 (
 nSESSION in binary_integer
 )
 as
 cookies utl_http.cookie_table;
 cookie utl_http.cookie;
 i integer := 1;
 begin
 /* ���� �� ������� ����� � ������ ������ ������� ������ */
 for rec in (select *
 from my_cookies t
 where t.session_id = nSESSION)
 loop

 /* �������� ���������� ���� */
 cookie.name := rec.name;
 cookie.value := rec.value;
 cookie.domain := rec.domain;
 cookie.expire := rec.expire;
 cookie.path := rec.path;
 cookie.version := rec.version;

 if (rec.secure = 'Y') THEN
 cookie.secure := TRUE;
 else
 cookie.secure := FALSE;
 end if;

 cookies(i) := cookie;

 /* ��������� �������� ����� */
 i := i + 1;
 end loop;

 /* ������� ������� ����� ������ */
 utl_http.clear_cookies;

 /* ������������� �����, ���������� �� ������� */
 utl_http.add_cookies(cookies);

 end RestoreCookies;


 /* ��������� ������������ �������� */
 procedure MakeLoader
 is
 nFLAG binary_integer := 0;
 dDATE date;
 sPR varchar2(1000);
 begin
 
 dDATE := sysdate;

 /* ������������ ����� �������� �� ������� ���� � ������� */
 sDATESTAMP := to_char(dDATE,'yyyy')||'_'||to_char(dDATE,'mm');
 sTIMESTAMP := to_char(dDATE,'hh')||'_'||to_char(dDATE,'mm')||'_'||to_char(dDATE,'ss');

 /* ������������ ����� �������� � ����������� �� ��������� */
 if sLOADERNAME = 'megafon' then
 sDBCATALOG := sDBROOT||'\'||sDATESTAMP||'\Megafon\'||sLOGIN;
 sDEBUGFOLDER := sDBROOT||'\Debug\'||sDATESTAMP||
 '\Megafon\'||sLOGIN||'\'||sSUBFOLDER||'\'||sTIMESTAMP;
 else
 sDBCATALOG := sDBROOT||'\'||sDATESTAMP||'\Beeline\'||sLOGIN;
 sDEBUGFOLDER := sDBROOT||'\Debug\'||sDATESTAMP||
 '\Beeline\'||sLOGIN||'\'||sSUBFOLDER||'\'||sTIMESTAMP;
 end if;

 sDEBUGFOLDER := upper(sDEBUGFOLDER);

 /* �������� �������� */
 nFLAG := PKG_TRF_FILEAPI.mkdirs(sDEBUGFOLDER);
 sHTTP_DIR := upper(sSUBFOLDER||'_'||sTIMESTAMP);

 /* ������������ �������� ���������� ��� utl_file � ������� ���������� */
 dbms_output.put_line('sHTTP_DIR-'||sHTTP_DIR||', sDEBUGFOLDER-'||sDEBUGFOLDER);
 execute immediate 'create or replace directory '||sHTTP_DIR||' as '''||sDEBUGFOLDER||'''';
 execute immediate 'grant read, write on directory '||sHTTP_DIR||' to public';

 end MakeLoader;
 
 
 /* ��������� �������� �������� �� directory */
 procedure DropDirectory
 is
 begin
 -- ������������ �������� ����� ��������� ���������� ��� utl_file
 begin
 execute immediate 'drop directory '||sHTTP_DIR;
 exception
 when others then
 dbms_output.put_line('������ ��� �������� ���������� '||sHTTP_DIR);
 end; 
 end;
 

end PKG_TRF_HttpClient;
/

