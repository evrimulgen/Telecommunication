-- Create table
create table BEELINE_API_TOKEN_LIST
(
  acc_log     VARCHAR2(50),
  token       VARCHAR2(100),
  last_update DATE
)nologging;

alter table beeline_api_token_list add (rest_token varchar2(100), rest_last_update date);

-- Add comments to the table 
comment on table BEELINE_API_TOKEN_LIST
  is '����� �� ���.';

COMMENT ON COLUMN BEELINE_API_TOKEN_LIST.REST_TOKEN IS '����� ��� ������ SOAP';

COMMENT ON COLUMN BEELINE_API_TOKEN_LIST.REST_LAST_UPDATE IS '����/����� ���������� ���������� ������ ��� ������ SOAP';

COMMENT ON COLUMN BEELINE_API_TOKEN_LIST.REST_TOKEN IS '����� ��� ������ REST';

COMMENT ON COLUMN BEELINE_API_TOKEN_LIST.REST_LAST_UPDATE IS '����/����� ���������� ���������� ������ ��� ������ REST';

