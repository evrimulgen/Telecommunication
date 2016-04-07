CREATE TABLE API_GET_UNBILLED_CALLS_LOG(
  PHONE_NUMBER VARCHAR2(10 CHAR),
  DATE_INSERT DATE,
  ERROR_TEXT VARCHAR2(500 CHAR)
  );

COMMENT ON TABLE API_GET_UNBILLED_CALLS_LOG IS '������� � ������ ������ �� �������� �� API'; 
COMMENT ON COLUMN API_GET_UNBILLED_CALLS_LOG.PHONE_NUMBER IS '����� ��������';
COMMENT ON COLUMN API_GET_UNBILLED_CALLS_LOG.DATE_INSERT IS '���� �������';
COMMENT ON COLUMN API_GET_UNBILLED_CALLS_LOG.ERROR_TEXT IS '����� ������';

create index API_GET_UNBILLED_CALLS_LOG_PH on API_GET_UNBILLED_CALLS_LOG(PHONE_NUMBER);

--GRANT SELECT, INSERT, UPDATE, DELETE ON API_GET_CTN_INFO_LIST TO CORP_MOBILE_ROLE;

--GRANT SELECT, INSERT, UPDATE, DELETE ON API_GET_CTN_INFO_LIST TO LONTANA_ROLE;

--GRANT SELECT, INSERT, UPDATE, DELETE ON API_GET_UNBILLED_CALLS_LOG TO SIM_TRADE_ROLE;