CREATE TABLE COLLECTOR_CALL_FROM_BILL(
  YEAR_MONTH INTEGER,
  FILE_ID INTEGER,
  PHONE_NUMBER VARCHAR2(10 CHAR),
  USAGE_connect_date VARCHAR2(10 CHAR),
  USAGE_connect_time VARCHAR2(10 CHAR),
  USAGE_other_number VARCHAR2(30 CHAR),
  USAGE_duration VARCHAR2(10 CHAR), 
  USAGE_at_charge_amt VARCHAR2(10 CHAR),
  USAGE_feature_description VARCHAR2(100 CHAR),
  USAGE_cell_id VARCHAR2(20 CHAR),
  USAGE_at_num_mins_to_rate VARCHAR2(10 CHAR),
  USAGE_call_action_code VARCHAR2(10 CHAR)
  );