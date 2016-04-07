CREATE OR REPLACE FUNCTION SMS_PROVIDER_MY_MOBI_VISION(
  pSITE_LOGIN IN VARCHAR2,
  pPROVIDER_NAME IN VARCHAR2,
  pPHONE_LIST_ARRAY IN DBMS_SQL.VARCHAR2_TABLE,
  pMAILING_NAME IN VARCHAR2,
  pSENDER_NAME IN VARCHAR2,
  pSMS_TEXT IN VARCHAR2
  ) RETURN VARCHAR2 IS
--#Version=2
--
/*
login: Simtrade
API ����: 02581258e2683a47a84043524d39fef82342bdeb
����� ������� ��� ��������: https://my.mbvn.ru/get/send.php
� ������� ���������� �������� ����� ������������ ���������� login, signature, phone, text, sender, timestamp
login - ��� �����
signature - �������
phone - ���� �����, ��� ������ ������� ����� ������� (�� ����� 50 ������� � ����� �������)
text - ����� ��� ���������
sender - ��� ����������� (���� �� ���������� �� ����� ��������)
timestamp - Timestamp �� UTC
������ �������:
https://my.mbvn.ru/get/send.php?login=Simtrade&signature=37009b5b3bd6d21531f3b39086b8b1f8&phone=84957887327&text=Hello!&sender=smstest&timestamp=1422257991
*/
  ParamURL constant varchar2(50) := 'http://my.mbvn.ru/get/send.php'; -- c https ������� ����������
  URL VARCHAR2(2000 CHAR);
  vRESULT VARCHAR2(2000 CHAR);
  vPHONES VARCHAR2(300 CHAR);
  vDATE_UTC VARCHAR2(500CHAR);
  FIRST_PHONE INTEGER;
  CHARSET VARCHAR2(50 CHAR);
  ENCODE_SMS_TEXT VARCHAR2(2000 CHAR);
  vSITE_SIGNATURE VARCHAR2(2000 CHAR);
  vAPI_KEY VARCHAR2(60 CHAR); --API ����: 02581258e2683a47a84043524d39fef82342bdeb
  req utl_http.req; --������
  resp utl_http.resp; --�����  
  sRes VARCHAR2(1024);--����� ������
  sCode VARCHAR2(4);--��� ������
begin
  CHARSET:='windows-1251';
  FIRST_PHONE:=pPHONE_LIST_ARRAY.FIRST;
  vPHONES:=pPHONE_LIST_ARRAY(FIRST_PHONE);
  ENCODE_SMS_TEXT:=pSMS_TEXT; 
  
  /*
  �������
    ����� ������ ������ ��������� ������������ �������� timestamp - ������� � ���� ������� ������ ���� ������� � ������� � ������������ � ������� 60 ������.
    ��������� timestamp ����� �� ������: https://my.mbvn.ru/get/timestamp.php
  */ 
  
  BEGIN
    --vDATE_UTC :=  UTL_HTTP.REQUEST('https://my.mbvn.ru/get/timestamp.php'); -- c https ������� ����������
    --vDATE_UTC :=  UTL_HTTP.REQUEST('http://my.mbvn.ru/get/timestamp.php'); -- c https ������� ����������
    req:= utl_http.begin_request('http://my.mbvn.ru/get/timestamp.php');--������� ����������
    utl_http.set_body_charset(req,'UTF-8');
    resp := utl_http.get_response(req);
    
    utl_http.read_line(resp, vDATE_UTC, TRUE);
    vRESULT := '';
    UTL_HTTP.END_RESPONSE(resp);--������� ����������
  EXCEPTION
    WHEN others THEN--� ����� ������ ��������� ����������
      UTL_HTTP.END_RESPONSE(resp);
    vRESULT :=  resp.status_code||' Error! ���������� ���������! '||vDATE_UTC;
  END;
  
  /* 
  ������� (�������� signature) - md5 ���, ������� ����������� ��������� �������:
  ��� ��������� �� ������� ����� ������������� � ���������� ������� � ������, � ����� ������ �������� API ����. ��� ���� ������������������ ���������� ��������������� � ������� �� ����� ��������.

  �������� ��� ������� https://my.mbvn.ru/get/balance.php?login=Simtrade&signature=c5303897fb1cf6fa4ac904be6c382812&timestamp=1422267219 
  ����� ������� � ������ ������ ������� ����� �������� �� ���������� login, timestamp � API �����: c5303897fb1cf6fa4ac904be6c382812
  � ���������� ���������
  YourLogin84957887327Long text1422267219
  � ����� ������ �������� ��� API ���� - 02581258e2683a47a84043524d39fef82342bdeb
  YourLogin84957887327Long text142226721902581258e2683a47a84043524d39fef82342bdeb
 */
  if vRESULT is null then
    vAPI_KEY := '02581258e2683a47a84043524d39fef82342bdeb';
    vSITE_SIGNATURE := pSITE_LOGIN||'8'||vPHONES||pSENDER_NAME||ENCODE_SMS_TEXT||vDATE_UTC||vAPI_KEY; --����� ������ ���� � 8
    vSITE_SIGNATURE := LOWER(Rawtohex(UTL_RAW.CAST_TO_RAW(DBMS_OBFUSCATION_TOOLKIT.MD5(input_string=>vSITE_SIGNATURE))));

    ENCODE_SMS_TEXT:=replace(ENCODE_SMS_TEXT, ' ', '%20'); --�������� ������� %20

    URL:= ParamURL || '?login='||pSITE_LOGIN ||chr(38)||'timestamp='||vDATE_UTC || chr(38)||'phone=8'||vPHONES || chr(38)|| 'sender='||pSENDER_NAME|| chr(38)||'text='||ENCODE_SMS_TEXT ||chr(38)|| 'signature='||vSITE_SIGNATURE;

    BEGIN
      req:= utl_http.begin_request(url);--�������
      utl_http.set_body_charset(req,'UTF-8');
      resp := utl_http.get_response(req);

      utl_http.read_line(resp, sRes, TRUE);

      --������� ��� ������ �� ����������
      --���� ������ "error":
      sCode := SUBSTR(sRes, INSTR(sRes, '"error":') + LENGTH('"error":') + 1, 1);--��� ������ � �������� ������� ���������� 1 {"error":"1"}

      if to_number(sCode) <> 0 then
        vRESULT := '��� �������: '||resp.status_code||'.  '||sRes;--������
      else
        vRESULT := '';        
      end if;
      
      UTL_HTTP.END_RESPONSE(resp); --�������
      return vRESULT;
    EXCEPTION 
      WHEN others THEN--� ����� ������ ��������� ����������
        UTL_HTTP.END_RESPONSE(resp);
      vRESULT :=  resp.status_code||' Error! ���������� ���������! '||sRes;
      return vRESULT;
    END;
  else
    return vRESULT;  
  end if;
END;
/


