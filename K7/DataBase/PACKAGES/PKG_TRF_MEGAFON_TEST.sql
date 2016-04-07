CREATE OR REPLACE package PKG_TRF_MEGAFON_TEST is

  /* ��������� ������ */
  /*sREGION         constant  varchar2(100) := 'https://volgasg.';*/
  /*sREGION        constant  varchar2(100) := 'https://moscowsg.';*/

  /* �������� ������� */
  type arr is record
  (
    id     binary_integer,
    bill   varchar2(100),
    per    varchar2(100),
    summ   varchar2(100),
    sch    varchar2(100),
    dsch   varchar2(100)
  );

  type arr_table is table of arr index by binary_integer;
  cARR   arr_table;


  /* ���������� ������ */
  sSESSION_ID     varchar2(1000);        -- ������������� ������� ������ (��� ��������)
  sLANG_ID        varchar2(100);         -- ������ �������� ������
  sCHANNEL        varchar2(100);         -- ������ �������� ������
  sAUTH_MODE      varchar2(100);         -- ������ �������� ������

  cCLOB           varchar2(4000);
  nBILL1          number(17,2);
  nBILL2          number(17,2);
  nBILL3          number(17,2);

  
  /* ������� ����������� � https://moscowsg.megafon.ru/ */
  function CONNECTED
  (
    sLOGIN       in varchar2,
    sPASSWORD    in varchar2
  )
  return boolean;
  
  /* ������� ���������  �������� "����������� ����"  */
  function GET_PHONE_BILLS
  (
    pSITE_PASSWORD  in varchar2,
    pLOADER_NAME    in varchar2,
    pDB_DATA_SOURCE in varchar2,
    pDB_USER_NAME   in varchar2,
    pDB_PASSWORD    in varchar2,
    pPHONE_NUMBER   in varchar2
  )
  return clob;


  /* ������� - ������-��� - ������ ��������) */
  function GET_PHONE_STATUS
  (
    pSITE_PASSWORD   in varchar2,
    pLOADER_NAME     in varchar2,
    pDB_DATA_SOURCE  in varchar2,
    pDB_USER_NAME    in varchar2,
    pDB_PASSWORD     in varchar2,
    pPHONE_NUMBER    in varchar2,
    pFULL_CHECK      in boolean    -- (FullCheck - ������ ������(false) ��� ��� ������������ �����(true)
   )
   return clob;

  /* ��������� ��������� �������� "��������� ��������" */
  function GET_PHONE_OPTIONS
  (
    pPHONE_NUMBER     in varchar2,
    pSITE_PASSWORD    in varchar2,
    pLOADER_NAME      in varchar2,
    nFLAG             in number,
    nNUMB             in integer default 1
   )
   return clob;


  /* �������� ������� - ������-��� - ����������� ����� */
  function SET_PHONE_OPTION_ON
  (
    pSITE_PASSWORD   in varchar2,
    pLOADER_NAME     in varchar2,
    pDB_DATA_SOURCE  in varchar2,
    pDB_USER_NAME    in varchar2,
    pDB_PASSWORD     in varchar2,
    pPHONE_NUMBER    in varchar2,
    pOPTION_NAME     in varchar2
   )
   return clob;


  /* �������� ������� - ������-��� - ���������� ����� */
  function SET_PHONE_OPTION_OFF
  (
    pSITE_PASSWORD   in varchar2,
    pLOADER_NAME     in varchar2,
    pDB_DATA_SOURCE  in varchar2,
    pDB_USER_NAME    in varchar2,
    pDB_PASSWORD     in varchar2,
    pPHONE_NUMBER    in varchar2,
    pOPTION_NAME     in varchar2
   )
   return clob;

end PKG_TRF_MEGAFON_TEST;
/

CREATE OR REPLACE package body PKG_TRF_MEGAFON_TEST
is

 
 /* ��������� ����������� � https://moscowsg.megafon.ru/ */
 function CONNECTED
 (
 sLOGIN in varchar2,
 sPASSWORD in varchar2
 )
 return boolean
 is
 sXML varchar2(4000) := null;
 Result boolean := true;
 begin

 /* ������������� ���������� */
 PKG_TRF_HTTPCLIENT.Init;

 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/ps/scc/php/check.php';

 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HttpClient.sURL);

 /* ������������ ���������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('LOGIN', sLOGIN);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('PASSWORD', sPASSWORD);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;
 --PKG_TRF_HTTPCLIENT.uRESPONSE := utl_http.get_response(PKG_TRF_HTTPCLIENT.uREQUEST, true);

 /* ��������� ������ */
 utl_http.read_text(PKG_TRF_HttpClient.uRESPONSE, sXML, 4000);

 /* ���������� ����� */
 PKG_TRF_HTTPCLIENT.nSESSION := PKG_TRF_HttpClient.SaveCookies;

 /* ��������� �������� ���������� ������ */
 sSESSION_ID := PKG_TRF_HTTPCLIENT.ExtractDataFromXML(sXML, 'SESSION_ID');
 sLANG_ID := PKG_TRF_HTTPCLIENT.ExtractDataFromXML(sXML, 'LANG_ID');
 sCHANNEL := PKG_TRF_HTTPCLIENT.ExtractDataFromXML(sXML, 'CHANNEL');
 sAUTH_MODE := PKG_TRF_HTTPCLIENT.ExtractDataFromXML(sXML, 'AUTH_MODE');

 /* ���������� ������� */
 utl_http.end_response(PKG_TRF_HTTPCLIENT.uRESPONSE);

 /* ����������� ������������ clob �� ����������� htlm */
 begin
 loop
 utl_http.read_line(PKG_TRF_HTTPCLIENT.uRESPONSE, PKG_TRF_HTTPCLIENT.sLINE, true);
 PKG_TRF_HTTPCLIENT.sLINE := utl_i18n.unescape_reference(PKG_TRF_HTTPCLIENT.sLINE);
 PKG_TRF_HTTPCLIENT.cHTML:=PKG_TRF_HTTPCLIENT.cHTML||CHR(10)||PKG_TRF_HTTPCLIENT.sLINE;
 end loop;
 exception
 when others then
 null;
 end;

 if instr(PKG_TRF_HTTPCLIENT.cHTML,'������ �������') >0 then
 Result := false;
 end if;

 Return Result;

 end CONNECTED;


 /* ������� ��������� �������� "����������� ����" */
 function GET_PHONE_BILLS
 (
 pSITE_PASSWORD in varchar2,
 pLOADER_NAME in varchar2,
 pDB_DATA_SOURCE in varchar2,
 pDB_USER_NAME in varchar2,
 pDB_PASSWORD in varchar2,
 pPHONE_NUMBER in varchar2
 )
 return clob
 is
 cTMP clob := null;
 nCOUNT integer := 0;
 sBILLID varchar2(100) := null; -- ����� �����
 sDATEBEGINEND varchar2(100) := null; -- ��������� ������
 sBILLSUM varchar2(100) := null; -- ����� ����������
 Result clob := null;
 begin

 /* ������������� ���������� */
 PKG_TRF_HTTPCLIENT.Init;
 PKG_TRF_HTTPCLIENT.sLOADERNAME := pLOADER_NAME;
 PKG_TRF_HTTPCLIENT.sLOGIN := pPHONE_NUMBER;

 /* �������� ���������� � ������ "������-���" */
 if not CONNECTED(pPHONE_NUMBER, pSITE_PASSWORD) then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ ����������� � ������-����';
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;
 else

 /* ��������� ����������� */
 PKG_TRF_HTTPCLIENT.sSUBFOLDER := 'GetPhoneBills';

 /* ��������� �������� */
 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/SCWWW/BILLS_ORDER_FORM';

 /* ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HTTPCLIENT.sURL);

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CHANNEL',sCHANNEL);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SESSION_ID',sSESSION_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('P_USER_LANG_ID',sLANG_ID);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 /* ���� �������� ������� � ��������� ������ */
 begin
 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;

 /* ��������� ����� �������� � ���������� � ���� */
 PKG_TRF_HTTPCLIENT.SaveFile('����� ������������ �����', '�� �������� �����');
 dbms_output.put_line(PKG_TRF_HTTPCLIENT.sERRORTEXT);
 
 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.End_Response;

 exception
 /* ���� ������ � ����� - ����� ��������� ��������� */
 when others then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ GET_PHONE_BILLS';
 --dbms_output.put_line(sqlerrm);
 end;

 /* �������� �� ������� ������ ������� */
 if PKG_TRF_HTTPCLIENT.sERRORTEXT is null then

 /* ������� html-���� � ������� */
 --PKG_TRF_HTTPCLIENT.InsertTable;

 /* ���� ��������� �������� �� html ��� ��������� ���� ������ */
 cTMP := PKG_TRF_HTTPCLIENT.ExtractDataFromString(PKG_TRF_HTTPCLIENT.cHTML,'table_not_scroll_default','PRINT_ACT');
 cTMP := PKG_TRF_HTTPCLIENT.ExtractDataFromString(cTMP,'tbody','/tbody');

 /* ������ ���������� ������� ������ */
 nCOUNT := case
 when cTMP is null then 0
 else (length(cTMP) - length(replace(cTMP, 'trBillID')))/length('trBillID')
 end ;

 /* �������� �� ������� ����� �� ������� */
 if nCOUNT >0 then

 /* ���� �� ������� ������ */
 for i in 1..nCOUNT
 loop
 /* ���� �� ������ */
 for rec in (select rownum,
 z.str
 from (select rownum rn,
 replace(replace(to_char(regexp_substr(cTMP,'<div>(.+?)</div>',1,level, '')),'<div>',''),'</div>','') as str
 from dual
 connect by level <= nCOUNT*5) z
 where z.rn between (i-1)*5+1 and (i-1)*5+5)
 loop

 if rec.rownum = 1 then
 sBILLID := rec.str;
 elsif rec.rownum = 2 then
 sDATEBEGINEND := rec.str;
 elsif rec.rownum = 3 then
 sBILLSUM := rec.str;
 --DB_LOADER_SIM_PCKG.ADD_PHONE_BILL(sBILLID, pPHONE_NUMBER, sBILLSUM, sDATEBEGINEND);
 dbms_output.put_line('sBILLID-'||sBILLID||', pPHONE_NUMBER-'||pPHONE_NUMBER||', sBILLSUM-'||sBILLSUM||', sDATEBEGINEND-'||sDATEBEGINEND);
 sBILLID := null;
 sBILLSUM := null;
 sDATEBEGINEND := null;
 end if;

 end loop;

 end loop;

 end if;

 /* ���� ������ ���, ����� ��������� ������� html-�������� � ���������� */
 Result := PKG_TRF_HTTPCLIENT.cCLOB;

 else

 /* ���� ���� ������, ����� ��������� ������� ����� ������ */
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;

 end if;

 end if;
 
 /* �������� ���������� */
 PKG_TRF_HTTPCLIENT.DropDirectory;

 /* ������� ���������� */
 return Result;

 end GET_PHONE_BILLS;


 /* ������� - ������-��� - ������ ��������) */
 function GET_PHONE_STATUS
 (
 pSITE_PASSWORD in varchar2,
 pLOADER_NAME in varchar2,
 pDB_DATA_SOURCE in varchar2,
 pDB_USER_NAME in varchar2,
 pDB_PASSWORD in varchar2,
 pPHONE_NUMBER in varchar2,
 pFULL_CHECK in boolean -- (FullCheck - ������ ������(false) ��� ��� ������������ �����(true)
 )
 return clob
 is
 sNEWSTATUS varchar2(1000) := null;
 nBALANCE number(17,2) := 0;
 Result clob := null;
 begin

 /* ������������� ���������� */
 PKG_TRF_HTTPCLIENT.Init;
 PKG_TRF_HTTPCLIENT.sLOADERNAME := pLOADER_NAME;
 PKG_TRF_HTTPCLIENT.sLOGIN := pPHONE_NUMBER;

 /* �������� ���������� � ������ "������-���" */
 if not CONNECTED(pPHONE_NUMBER, pSITE_PASSWORD) then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ ����������� � ������-����';
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;

 else

 /* ��������� ����������� */
 PKG_TRF_HTTPCLIENT.sSUBFOLDER := 'Balances';

 /* ��������� �������� */
 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/SCWWW/ACCOUNT_INFO';

 /* ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HTTPCLIENT.sURL);

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('find',null);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CHANNEL',sCHANNEL);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SESSION_ID',sSESSION_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('P_USER_LANG_ID',sLANG_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CUR_SUBS_MSISDN',pPHONE_NUMBER);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SUBSCRIBER_MSISDN',pPHONE_NUMBER);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 /* ���� �������� ������� � ��������� ������ */
 begin
 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;
 
 /* ��������� ����� �������� � ���������� � ���� */
 PKG_TRF_HTTPCLIENT.SaveFile('������ ��������', '�� ������� ������.');

 /* ������� html-���� � ������� */
 PKG_TRF_HTTPCLIENT.InsertTable;

 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.End_Response;

 exception
 /* ���� ������ � ����� - ����� ��������� ��������� */
 when others then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ GET_PHONE_STATUS';
 end;

 /* �������� �� ������� ������ ������� */
 if PKG_TRF_HTTPCLIENT.sERRORTEXT is null then

 /* ������� html-���� � ������� */
 --PKG_TRF_HTTPCLIENT.InsertTable;

 /* �������� �������� */
 if not PKG_TRF_HTTPCLIENT.IsValidResult then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '�� ������� ������';
 else

 /* ��������� ������� �������� */
 sNEWSTATUS := PKG_TRF_HTTPCLIENT.ExtractDataFromString(PKG_TRF_HTTPCLIENT.cHTML,'<div>������ ��������','������� �������� ����');
 sNEWSTATUS := PKG_TRF_HTTPCLIENT.ExtractDataFromString(sNEWSTATUS,'<div class="td_def">','</div>');


 if sNEWSTATUS is not null then
 		 --DB_LOADER_SIM_PCKG.UPDATE_PHONE_STATUS(pPHONE_NUMBER, sNEWSTATUS);
 dbms_output.put_line('DB_LOADER_SIM_PCKG.UPDATE_PHONE_STATUS(pPHONE_NUMBER => '||pPHONE_NUMBER||', sNEWSTATUS => '||sNEWSTATUS||')');

 /* ��������� �������� ������� */
 begin
 nBALANCE := to_number(replace(PKG_TRF_HTTPCLIENT.ExtractDataFromString(PKG_TRF_HTTPCLIENT.cHTML,'<div class="balance_good td_def">',' ���.</div>'),'.',','));
 --DB_LOADER_SIM_PCKG.UPDATE_PHONE_BALANCE(pPHONE_NUMBER, nBALANCE);
 dbms_output.put_line('DB_LOADER_SIM_PCKG.UPDATE_PHONE_BALANCE(pPHONE_NUMBER => '||pPHONE_NUMBER||', nBALANCE => '||nBALANCE||')');

 /* ������������ ��������� clob �������� */
 Result := PKG_TRF_HTTPCLIENT.cCLOB;

 if pFULL_CHECK then
 dbms_output.put_line(substr(GET_PHONE_OPTIONS(pPHONE_NUMBER, pSITE_PASSWORD, pLOADER_NAME, 1, 2),1,1000));
 --GET_PHONE_OPTIONS(pPHONE_NUMBER, pSITE_PASSWORD, 1)
 end if;

 exception
 when others then
 dbms_output.put_line('������ ��������� nBALANCE');
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ ��������� nBALANCE';
 Result:= PKG_TRF_HTTPCLIENT.sERRORTEXT;
 end;

 else
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ ��������� �� ���������';
 Result:= PKG_TRF_HTTPCLIENT.sERRORTEXT;
 end if;

 end if;

 end if;

 end if;
 
 /* �������� ���������� */
 PKG_TRF_HTTPCLIENT.DropDirectory;

 return Result;

 end GET_PHONE_STATUS;

 /* ��������� ��������� �������� "��������� ��������" */
 function GET_PHONE_OPTIONS
 (
 pPHONE_NUMBER in varchar2,
 pSITE_PASSWORD in varchar2,
 pLOADER_NAME in varchar2,
 nFLAG in number,
 nNUMB in integer default 1
 )
 return clob
 is
 Result clob := null;
 begin

 /* ������������� ���������� */
 PKG_TRF_HTTPCLIENT.Init(false);

 /* ������ ��������� ����������� � ������� ���������� ������ */
 if nFLAG = 0 then

 /* ������������� ���������� */
 PKG_TRF_HTTPCLIENT.sLOADERNAME := pLOADER_NAME;
 PKG_TRF_HTTPCLIENT.sLOGIN := pPHONE_NUMBER;

 /* �������� ���������� � ������ "������-���" */
 if not CONNECTED(pPHONE_NUMBER, pSITE_PASSWORD) then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ ����������� � ������-����';
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;
 end if;
 end if;

 /* ���� ��� ������ ����������� */
 if PKG_TRF_HTTPCLIENT.sERRORTEXT is null then

 /* ��������� �������� */
 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/SCWWW/ORDER_SERVICE_FORM';

 /* ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HTTPCLIENT.sURL);

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('find',null);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CHANNEL',sCHANNEL);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SESSION_ID',sSESSION_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('P_USER_LANG_ID',sLANG_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CUR_SUBS_MSISDN',pPHONE_NUMBER);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SUBSCRIBER_MSISDN',pPHONE_NUMBER);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 /* ���� �������� ������� � ��������� ������ */
 begin
 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;

 /* ��������� ����� �������� � ���������� � ���� */
 PKG_TRF_HTTPCLIENT.SaveFile(nNUMB => nNUMB);

 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.End_Response;
 exception
 /* ���� ������ � ����� - ����� ��������� ��������� */
 when others then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ GET_PHONE_OPTIONS';
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;
 end;

 /* �������� �� ������� ������ */
 if PKG_TRF_HTTPCLIENT.sERRORTEXT is null then

 /* ������� html-���� � ������� */
 --PKG_TRF_HTTPCLIENT.InsertTable;

 /* ���� �� �������� */
 for rec in (select z.*
 from (select replace(replace(to_char(regexp_substr(PKG_TRF_HTTPCLIENT.cHTML,'name="SERVICE_ID" value="\S+',1,level)),'name="SERVICE_ID" value="',''),'"','') serviceid,
 to_char(regexp_substr(PKG_TRF_HTTPCLIENT.cHTML,'name="SERVICE_ID" value=*= */S+ .\S+ */S+>',1,level)) str
 from dual
 connect by level <= 20) z
 where instr(z.str,'disabled')=0)
 loop
 --DB_LOADER_SIM_PCKG.UPDATE_PHONE_OPTION(pPHONE_NUMBER, rec.serviceid);
 dbms_output.put_line('DB_LOADER_SIM_PCKG.UPDATE_PHONE_OPTION(pPHONE_NUMBER => '||pPHONE_NUMBER||', pOPTION_CODE => '||rec.serviceid||')');
 end loop;

 if not PKG_TRF_HTTPCLIENT.IsValidResult then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '�� ������� ������ �����.';
 else
 Result := PKG_TRF_HTTPCLIENT.cCLOB;
 end if;

 end if;

 end if;

 return Result;

 end GET_PHONE_OPTIONS;


 /* �������� ������� - ������-��� - ����������� ����� */
 function SET_PHONE_OPTION_ON
 (
 pSITE_PASSWORD in varchar2,
 pLOADER_NAME in varchar2,
 pDB_DATA_SOURCE in varchar2,
 pDB_USER_NAME in varchar2,
 pDB_PASSWORD in varchar2,
 pPHONE_NUMBER in varchar2,
 pOPTION_NAME in varchar2
 )
 return clob
 is
 Result clob := null;
 cTMP clob := null;
 sTYPESET varchar2(100) := '�����������';
 begin

 /* ************** ��������� ������ ����� ************** */

 /* ������������� ���������� */
 PKG_TRF_HTTPCLIENT.Init;
 PKG_TRF_HTTPCLIENT.sLOADERNAME := pLOADER_NAME;
 PKG_TRF_HTTPCLIENT.sLOGIN := pPHONE_NUMBER;

 /* �������� ���������� � ������ "������-���" */
 if not CONNECTED(pPHONE_NUMBER, pSITE_PASSWORD) then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ ����������� � ������-����';
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;
 else

 /* ��������� ����������� */
 PKG_TRF_HTTPCLIENT.sSUBFOLDER := 'OptionsOn';

 /* ��������� �������� */
 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/SCWWW/ORDER_SERVICE_FORM';

 /* ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HTTPCLIENT.sURL);

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('find',null);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CHANNEL',sCHANNEL);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SESSION_ID',sSESSION_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('P_USER_LANG_ID',sLANG_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CUR_SUBS_MSISDN',pPHONE_NUMBER);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SUBSCRIBER_MSISDN',pPHONE_NUMBER);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 /* ���� �������� ������� � ��������� ������ */
 begin
 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;

 /* ��������� ����� �������� � ���������� � ���� */
 PKG_TRF_HTTPCLIENT.SaveFile;

 /* ������� html-���� � ������� */
 --PKG_TRF_HTTPCLIENT.InsertTable;

 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.End_Response;

 exception
 when others then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ SET_PHONE_OPTION_ON';
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;
 end;

 /* �������� �� ������� ������ */
 if PKG_TRF_HTTPCLIENT.sERRORTEXT is null then

 /* �������� �������� */
 if not PKG_TRF_HTTPCLIENT.IsValidResult then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '�� ������� ������ �����';
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;

 else

 /* ************** ��������� ������ ����� ************** */

 cTMP := PKG_TRF_HTTPCLIENT.cHTML;
 PKG_TRF_HTTPCLIENT.cCLOB := null;
 PKG_TRF_HTTPCLIENT.cHTML := null;
 PKG_TRF_HTTPCLIENT.uRESPONSE := null;
 PKG_TRF_HTTPCLIENT.uREQUEST := null;
 PKG_TRF_HTTPCLIENT.sFILE_TYPE := null;
 PKG_TRF_HTTPCLIENT.sREQUEST_TEXT := null;

 /* ��������� �������� */
 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/SCWWW/ORDER_SERVICE_CONFIRM';

 /* ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HTTPCLIENT.sURL);

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('GROUP_ID','1');

 /* ���� �� �������� */
 for rec in (select z.*
 from (select replace(replace(to_char(regexp_substr(cTMP,'name="SERVICE_ID" value="\S+',1,level)),'name="SERVICE_ID" value="',''),'"','') serviceid,
 to_char(regexp_substr(cTMP,'name="SERVICE_ID" value=*= */S+ .\S+ */S+>',1,level)) str
 from dual
 connect by level <= 20) z
 where instr(z.str,'disabled')=0)
 loop
 --DB_LOADER_SIM_PCKG.UPDATE_PHONE_OPTION(pPHONE_NUMBER, rec.serviceid);
 --dbms_output.put_line('DB_LOADER_SIM_PCKG.UPDATE_PHONE_OPTION(pPHONE_NUMBER => '||pPHONE_NUMBER||', pOPTION_CODE => '||rec.serviceid||')');

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SERVICE_ID',rec.serviceid);

 if rec.serviceid = pOPTION_NAME then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := nvl(PKG_TRF_HTTPCLIENT.sERRORTEXT,'������: ����� ��� ����������');
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;
 dbms_output.put_line('������: ����� '||pOPTION_NAME||' ��� ����������');
 exit;
 end if;

 end loop;

 /* �������� �� ������� ������� ��������� ������ ����� */
 if PKG_TRF_HTTPCLIENT.sERRORTEXT is null then

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SERVICE_ID',pOPTION_NAME);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CHANNEL',sCHANNEL);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SESSION_ID',sSESSION_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('P_USER_LANG_ID',sLANG_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CUR_SUBS_MSISDN',pPHONE_NUMBER);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SUBSCRIBER_MSISDN',pPHONE_NUMBER);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 /* ���� �������� ������� � ��������� ������ */
 begin
 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;
 exception
 when others then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ ORDER_SERVICE_CONFIRM';
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;
 end;

 /* ��������� ����� �������� � ���������� � ���� */
 PKG_TRF_HTTPCLIENT.SaveFile;

 --PKG_TRF_HTTPCLIENT.InsertTable;

 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.End_Response;



 /* ************** ������������� ������� �� ��������� ������ ����� ************** */

 cTMP := PKG_TRF_HTTPCLIENT.cHTML;
 PKG_TRF_HTTPCLIENT.cCLOB := null;
 PKG_TRF_HTTPCLIENT.cHTML := null;
 PKG_TRF_HTTPCLIENT.uRESPONSE := null;
 PKG_TRF_HTTPCLIENT.uREQUEST := null;
 PKG_TRF_HTTPCLIENT.sFILE_TYPE := null;
 PKG_TRF_HTTPCLIENT.sREQUEST_TEXT := null;

 begin
 /* ��������� �������� */
 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/SCWWW/ORDER_SERVICE_ACTION';

 /* ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HTTPCLIENT.sURL);

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('GROUP_ID','1');
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SERVICES_TO_APPEND',pOPTION_NAME);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CHANNEL',sCHANNEL);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SESSION_ID',sSESSION_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('P_USER_LANG_ID',sLANG_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CUR_SUBS_MSISDN',pPHONE_NUMBER);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SUBSCRIBER_MSISDN',pPHONE_NUMBER);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;

 /* ��������� ����� �������� � ���������� � ���� */
 PKG_TRF_HTTPCLIENT.SaveFile;

 --PKG_TRF_HTTPCLIENT.InsertTable;

 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.End_Response;

 exception
 when others then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := nvl(PKG_TRF_HTTPCLIENT.sERRORTEXT,'������ ORDER_SERVICE_ACTION');
 end;

 if not PKG_TRF_HTTPCLIENT.IsValidResult then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := nvl(PKG_TRF_HTTPCLIENT.sERRORTEXT,'��� ������ �� �������������');
 end if;

 --DB_LOADER_SIM_PCKG.LOG_SET_PHONE_OPTION_ADD_REC(pPHONE_NUMBER, pOPTION_NAME, sTYPESET, PKG_TRF_HTTPCLIENT.sERRORTEXT);
 dbms_output.put_line('DB_LOADER_SIM_PCKG.LOG_SET_PHONE_OPTION_ADD_REC(pPHONE_NUMBER => '||pPHONE_NUMBER
 ||', pOPTION_NAME => '||pOPTION_NAME
 ||', pTYPE_SET => '||sTYPESET
 ||', pNOTE => '||PKG_TRF_HTTPCLIENT.sERRORTEXT||')');

 if PKG_TRF_HTTPCLIENT.sERRORTEXT is null then
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;
 else
 Result := PKG_TRF_HTTPCLIENT.cCLOB;
 end if;

 end if;

 end if;

 end if;

 end if;
 
 /* �������� ���������� */
 PKG_TRF_HTTPCLIENT.DropDirectory; 
 
 Return Result;

 end SET_PHONE_OPTION_ON;


 /* �������� ������� - ������-��� - ���������� ����� */
 function SET_PHONE_OPTION_OFF
 (
 pSITE_PASSWORD in varchar2,
 pLOADER_NAME in varchar2,
 pDB_DATA_SOURCE in varchar2,
 pDB_USER_NAME in varchar2,
 pDB_PASSWORD in varchar2,
 pPHONE_NUMBER in varchar2,
 pOPTION_NAME in varchar2
 )
 return clob
 is
 Result clob := null;
 cTMP clob := null;
 sTYPESET varchar2(100) := '����������';
 nFLAG integer := 0;
 begin

 /* ************** ��������� ������ ����� ************** */

 /* ������������� ���������� */
 PKG_TRF_HTTPCLIENT.Init;
 PKG_TRF_HTTPCLIENT.sLOADERNAME := pLOADER_NAME;
 PKG_TRF_HTTPCLIENT.sLOGIN := pPHONE_NUMBER;

 /* �������� ���������� � ������ "������-���" */
 if not CONNECTED(pPHONE_NUMBER, pSITE_PASSWORD) then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ ����������� � ������-����';
 Result := PKG_TRF_HTTPCLIENT.sERRORTEXT;
 else

 /* ��������� ����������� */
 PKG_TRF_HTTPCLIENT.sSUBFOLDER := 'OptionsOff';

 /* ��������� �������� */
 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/SCWWW/ORDER_SERVICE_FORM';

 /* ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HTTPCLIENT.sURL);

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('find',null);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CHANNEL',sCHANNEL);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SESSION_ID',sSESSION_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('P_USER_LANG_ID',sLANG_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CUR_SUBS_MSISDN',pPHONE_NUMBER);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SUBSCRIBER_MSISDN',pPHONE_NUMBER);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 begin
 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;

 /* ��������� ����� �������� � ���������� � ���� */
 PKG_TRF_HTTPCLIENT.SaveFile;

 /* ������� html-���� � ������� */
 --PKG_TRF_HTTPCLIENT.InsertTable;

 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.End_Response;

 exception
 when others then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������ SET_PHONE_OPTION_OFF';
 end;

 if not PKG_TRF_HTTPCLIENT.IsValidResult then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '�� ������� ������ �����';
 end if;


 /* �������� �� ������� ������ ��������� ������ ����� */
 if PKG_TRF_HTTPCLIENT.sERRORTEXT is null then

 /* ************** ��������� ������ ����� ************** */

 cTMP := PKG_TRF_HTTPCLIENT.cHTML;
 PKG_TRF_HTTPCLIENT.cCLOB := null;
 PKG_TRF_HTTPCLIENT.cHTML := null;
 PKG_TRF_HTTPCLIENT.uRESPONSE := null;
 PKG_TRF_HTTPCLIENT.uREQUEST := null;
 PKG_TRF_HTTPCLIENT.sFILE_TYPE := null;
 PKG_TRF_HTTPCLIENT.sREQUEST_TEXT := null;

 /* ��������� �������� */
 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/SCWWW/ORDER_SERVICE_CONFIRM';

 /* ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HTTPCLIENT.sURL);

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('GROUP_ID','1');

 /* ���� �� �������� */
 for rec in (select z.*
 from (select replace(replace(to_char(regexp_substr(cTMP,'name="SERVICE_ID" value="\S+',1,level)),'name="SERVICE_ID" value="',''),'"','') serviceid,
 to_char(regexp_substr(cTMP,'name="SERVICE_ID" value=*= */S+ .\S+ */S+>',1,level)) str
 from dual
 connect by level <= 20) z)
 loop

 if instr(rec.str,'disabled')=0 then
 -- ������ ������������ �����
 if rec.serviceid = pOPTION_NAME then
 --dbms_output.put_line('��������� ����� '||rec.serviceid);
 nFLAG := 1;
 else
 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SERVICE_ID',rec.serviceid);
 --dbms_output.put_line('�� ��������� ����� '||rec.serviceid);
 end if;
 else
 -- ������ ����������� �����
 if rec.serviceid = pOPTION_NAME then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������: ����� ��� ���������';
 nFLAG := 1;
 end if;
 --dbms_output.put_line('����������� ����� '||rec.serviceid);
 end if;

 end loop;

 if nFLAG = 0 then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := '������: ������ ����� �� ������� � ������';
 end if;

 /* �������� �� ������� ������� ��������� ������ ����� */
 if PKG_TRF_HTTPCLIENT.sERRORTEXT is null then

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CHANNEL',sCHANNEL);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SESSION_ID',sSESSION_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('P_USER_LANG_ID',sLANG_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CUR_SUBS_MSISDN',pPHONE_NUMBER);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SUBSCRIBER_MSISDN',pPHONE_NUMBER);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;

 /* ��������� ����� �������� � ���������� � ���� */
 PKG_TRF_HTTPCLIENT.SaveFile;

 PKG_TRF_HTTPCLIENT.InsertTable;

 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.End_Response;



 /* ************** ������������� ������� �� ��������� ������ ����� ************** */

 cTMP := PKG_TRF_HTTPCLIENT.cHTML;
 PKG_TRF_HTTPCLIENT.cCLOB := null;
 PKG_TRF_HTTPCLIENT.cHTML := null;
 PKG_TRF_HTTPCLIENT.uRESPONSE := null;
 PKG_TRF_HTTPCLIENT.uREQUEST := null;
 PKG_TRF_HTTPCLIENT.sFILE_TYPE := null;
 PKG_TRF_HTTPCLIENT.sREQUEST_TEXT := null;

 begin
 /* ��������� �������� */
 PKG_TRF_HTTPCLIENT.sURL := 'https://volgasg.megafon.ru/SCWWW/ORDER_SERVICE_ACTION';

 /* ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Begin_Request(PKG_TRF_HTTPCLIENT.sURL);

 /* ��������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.AddRequestParameter('GROUP_ID','1');
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SERVICES_TO_DELETE',pOPTION_NAME);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CHANNEL',sCHANNEL);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SESSION_ID',sSESSION_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('P_USER_LANG_ID',sLANG_ID);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('CUR_SUBS_MSISDN',pPHONE_NUMBER);
 PKG_TRF_HTTPCLIENT.AddRequestParameter('SUBSCRIBER_MSISDN',pPHONE_NUMBER);

 /* ���������� ���������� ��������� ������� */
 PKG_TRF_HTTPCLIENT.Set_Header;

 /* ��������� ������ � ����� �� ������� */
 PKG_TRF_HTTPCLIENT.Get_Response;

 /* ��������� ����� �������� � ���������� � ���� */
 PKG_TRF_HTTPCLIENT.SaveFile;

 --PKG_TRF_HTTPCLIENT.InsertTable;

 /* ���������� ������� */
 PKG_TRF_HTTPCLIENT.End_Response;

 exception
 when others then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := nvl(PKG_TRF_HTTPCLIENT.sERRORTEXT,'������ ORDER_SERVICE_ACTION');
 end;

 if not PKG_TRF_HTTPCLIENT.IsValidResult then
 PKG_TRF_HTTPCLIENT.sERRORTEXT := nvl(PKG_TRF_HTTPCLIENT.sERRORTEXT,'��� ������ �� �������������');
 end if;

 --DB_LOADER_SIM_PCKG.LOG_SET_PHONE_OPTION_ADD_REC(pPHONE_NUMBER, pOPTION_NAME, sTYPESET, PKG_TRF_HTTPCLIENT.sERRORTEXT);
 dbms_output.put_line('DB_LOADER_SIM_PCKG.LOG_SET_PHONE_OPTION_ADD_REC(pPHONE_NUMBER => '||pPHONE_NUMBER
 ||', pOPTION_NAME => '||pOPTION_NAME
 ||', pTYPE_SET => '||sTYPESET
 ||', pNOTE => '||PKG_TRF_HTTPCLIENT.sERRORTEXT||')');

 Result := PKG_TRF_HTTPCLIENT.cCLOB;
 end if;

 end if;

 end if;

 /* �������� ���������� */
 PKG_TRF_HTTPCLIENT.DropDirectory;
 
 Return Result;

 end SET_PHONE_OPTION_OFF;

end PKG_TRF_MEGAFON_TEST;
/

