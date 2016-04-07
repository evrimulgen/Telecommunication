CREATE OR REPLACE FUNCTION F_SMS_PROVIDER_TargertSMS
--
--VERSION=1
--
--v.1  29.09.2015 - ������� ��� �������� ��� ����� ���������� TargertSMS
--
--  
  (
   pSITE_LOGIN         IN VARCHAR2,
   pSitePassword       in VARCHAR2,
   pPROVIDER_NAME      IN VARCHAR2,
   pPHONE_LIST_ARRAY   IN DBMS_SQL.VARCHAR2_TABLE,
   pMAILING_NAME       IN VARCHAR2,
   pSENDER_NAME        IN VARCHAR2,
   pSMS_TEXT           IN VARCHAR2)
   RETURN VARCHAR2
IS
  ParamURL   CONSTANT VARCHAR2 (50) := 'https://sms.targetsms.ru/sendsms.php'; -- c https ������� ����������
  URL                 VARCHAR2 (2000 CHAR);
  vRESULT             VARCHAR2 (2000 CHAR);
  vPHONES             VARCHAR2 (300 CHAR);
  FIRST_PHONE         INTEGER;
  ENCODE_SMS_TEXT     VARCHAR2 (2000 CHAR);
  req                 UTL_HTTP.req;                                  --������
  resp                UTL_HTTP.resp;                                  --�����
  sRes                VARCHAR2 (1024);                         --����� ������
  sCode               VARCHAR2 (4);                              --��� ������
BEGIN
   
  FIRST_PHONE := pPHONE_LIST_ARRAY.FIRST;
  vPHONES := pPHONE_LIST_ARRAY (FIRST_PHONE);
  ENCODE_SMS_TEXT := pSMS_TEXT;

  ENCODE_SMS_TEXT := REPLACE (ENCODE_SMS_TEXT, ' ', '%20'); --�������� ������� %20

--  https://sms.targetsms.ru/sendsms.php?user=���_�����_�_�����_�������&pwd=������&sadr=��
--  _����_������_SMS&dadr=�����_��������_����������_SMS&text=����� SMS
  URL :=
          ParamURL
           || '?user='
           || pSITE_LOGIN
           || CHR (38)
           || 'pwd='
           || pSitePassword
           || CHR (38)
           || 'sadr='
           || pSENDER_NAME
           || CHR (38)
           || 'dadr=+7'
           || vPHONES
           || CHR (38)
           || 'text='
           || ENCODE_SMS_TEXT;
    
    

  BEGIN
    UTL_HTTP.set_wallet (ms_params.GET_PARAM_VALUE ('SSL_WALLET_DIR'), '082g625p4Y412sD');
           
    req := UTL_HTTP.begin_request (url);                        --�������
    UTL_HTTP.set_body_charset (req, 'UTF-8');
    resp := UTL_HTTP.get_response (req);

    UTL_HTTP.read_line (resp, sRes, TRUE);

    IF INSTR (sRes, 'error') > 0 THEN
      --������� ��� ������ �� ����������
      --���� ������ "error":
      sCode := SUBSTR (sRes, INSTR (sRes, 'error') + LENGTH ('error'), 1);

      IF TO_NUMBER (sCode) <> 0 THEN
         vRESULT :=
                   '��� �������: '
                    || resp.status_code
                    || '.  '
                    || sRes;                                            --������
      ELSE
         vRESULT := '';
      END IF;
    ELSE
      vRESULT := '��� �� ����������: '|| sRes;
    END IF;
   
   UTL_HTTP.END_RESPONSE (resp);                               --�������
   
  EXCEPTION
    WHEN OTHERS THEN                            --� ����� ������ ��������� ����������
      UTL_HTTP.END_RESPONSE (resp);
      vRESULT := resp.status_code
                || ' Error! ���������� ���������! '
                || sRes;
  END;

  --��� ������� ���������� � ���������� ����� ������������� ���������   
  RETURN vRESULT;
END;
