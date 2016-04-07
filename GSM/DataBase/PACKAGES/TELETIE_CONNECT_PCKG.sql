CREATE OR REPLACE PACKAGE TELETIE_CONNECT_PCKG
AS
   --#Version=1
   --
   --v1  27,10,2014 -������� �.�. - ����� ��� ������ �� �������� TeleTie
   --
   --

   --������� ����������
   FUNCTION create_conn (lgn           IN     VARCHAR2,
                         pss           IN     VARCHAR2,
                         connection_type   IN     NUMBER,
                         REQUEST out varchar2,
                         ANSWER out varchar2,
                         phone         IN     VARCHAR2 DEFAULT 0,
                         year_month in varchar2 default 0
                         )
      RETURN VARCHAR2;

   --����� � ����
   PROCEDURE SAVE_LOG (connection_type    IN NUMBER,
                       CONN_REQUEST in varchar2,          
                       CONN_ANSWER in varchar2,
                       ERROR_TEXT in varchar2
                       );
--������� ���������� � ����� � ����  
  procedure CONNECT_AND_SAVE_LOG (lgn           IN     VARCHAR2,
                         pss           IN     VARCHAR2,
                         connection_type   IN     NUMBER,
                         phone         IN     VARCHAR2 DEFAULT 0,
                         year_month in varchar2 default 0
                         );
                                 
END;
/
CREATE OR REPLACE PACKAGE BODY TELETIE_CONNECT_PCKG AS
  
  SQ_Value integer;  --������� �������� Sequnce

/**/
/*=======================================*/
/*=============== ����������� ===========*/
/*=======================================*/
function create_conn (lgn in varchar2,
                      pss in varchar2,
                      connection_type in  number,--6 ReportData,1 Payments ,7 Lock Phone
                      REQUEST out varchar2,
                      ANSWER out varchar2,
                      phone in varchar2 default 0,
                      year_month in varchar2 default 0
                      ) return varchar2
is
  err        varchar2(1000);
  req        utl_http.req;--������
  resp       utl_http.resp;--�����
  urls       varchar2(1000);
  i          number;

begin
  
  err := 'OK';
  
  begin --������� �����������
    for c in 1..3 loop  --��� ������� �����������
      SQ_Value := sq_get_server.nextval;
     
      select SITE_URL into urls from TELETIE_CONN_TYPES where CONN_TYPE_ID = connection_type;
     
      urls := Replace(urls, '%PHONE_NUMBER%', phone);
      REQUEST := urls; 

      begin
        utl_http.set_transfer_timeout(MS_PARAMS.GET_PARAM_VALUE('USS_BEELINE_LOADER_TIME_OUT'));--��������� �������� 5 �����. ( ��� ? )
        req:= utl_http.begin_request(urls);
        utl_http.set_body_charset(req,'UTF-8');
        resp := utl_http.get_response(req);

        if resp.status_code > 0 then 
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
  utl_http.read_line(resp,ANSWER); 
  RETURN (err);
end;

PROCEDURE SAVE_LOG (connection_type    IN NUMBER,
                       CONN_REQUEST in varchar2,          
                       CONN_ANSWER in varchar2,
                       ERROR_TEXT in varchar2
                       )
  is
  pragma autonomous_transaction;
  IS_SUCCESS integer;
  err varchar2 (200); 
begin
  
  if Upper(ERROR_TEXT) <> 'OK' AND ERROR_TEXT <> '' THEN
    IS_SUCCESS := 0;
    err := ERROR_TEXT;
  else
    IS_SUCCESS := 1;
    err := null;  
  end if;
  
  INSERT INTO TELETIE_CONN_LOGS (CONN_TYPE_ID, CONN_REQUEST, CONN_ANSWER, IS_SUCCESS, ERROR_TEXT)
  VALUES
  (connection_type, CONN_REQUEST, CONN_ANSWER, IS_SUCCESS, err);
  
  COMMIT;    
end;


--������� ���������� � ����� � ����  
procedure CONNECT_AND_SAVE_LOG (lgn           IN     VARCHAR2,
                         pss           IN     VARCHAR2,
                         connection_type   IN     NUMBER,
                         phone         IN     VARCHAR2 DEFAULT 0,
                         year_month in varchar2 default 0
                         ) is
REQUEST varchar2(200);
ANSWER varchar2(200);
err varchar2(200);
                         
begin
  err := TELETIE_CONNECT_PCKG.CREATE_CONN('', '', connection_type, REQUEST, ANSWER, phone);
  TELETIE_CONNECT_PCKG.SAVE_LOG(connection_type, REQUEST, ANSWER, err);
end;                         
                              
                         
END;
/