-- Create table
create table PROMISED_PAYMENTS_CHANGE_LOG(
  account_id              INTEGER,
  year_month              INTEGER,
  phone_number            VARCHAR2(10 CHAR),
  payment_date            DATE,
  payment_sum             NUMBER(15,2),
  payment_status_is_valid NUMBER(1),
  payment_number          VARCHAR2(30 CHAR),
  payment_status_text     VARCHAR2(200 CHAR),
  contract_id             INTEGER,
  date_created            DATE,
  comm_txt                VARCHAR2(200 CHAR)
  );
  
  
-- Add comments to the table 
comment on table PROMISED_PAYMENTS_CHANGE_LOG is '��� ���������� ���������� �������';
-- Add comments to the columns 
comment on column PROMISED_PAYMENTS_CHANGE_LOG.account_id is 'ID �������';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.year_month is '��� � �����';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.phone_number is '����� ��������';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.payment_date is '���� �������';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.payment_sum is '����� �������';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.payment_status_is_valid is '������ �������';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.payment_number is '����� �������';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.payment_status_text is '�������� ������� �������';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.contract_id is '������ �� ��������, � �������� ��������� �����';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.date_created is '���� �������� ������� � ��';
comment on column PROMISED_PAYMENTS_CHANGE_LOG.comm_txt is '�����������';
