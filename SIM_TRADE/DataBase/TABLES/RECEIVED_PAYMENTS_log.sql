create table RECEIVED_PAYMENTS_log (
  fdate_rec       date,
  
  CURR_SCHEMA       varchar2(100),
  CURR_USER         varchar2(100),
  HOST              varchar2(100),
  IP_ADDRESS        varchar2(100),
  OS_USER           varchar2(100),  
  
  faction         varchar2(20),
  
  received_payment_id      INTEGER,
  
  phone_number             VARCHAR2(10 CHAR),
  payment_sum              NUMBER(15,2) ,
  payment_date_time        DATE,
  contract_id              INTEGER,
  is_contract_payment      NUMBER(1) default 0,
  filial_id                INTEGER,
  payment_annul_flag       NUMBER(1) default 0,
  payment_annul_date_time  DATE,
  payment_annul_reason     VARCHAR2(200 CHAR),
  user_who_annulate        VARCHAR2(30 CHAR),

  remark                   VARCHAR2(500 CHAR),
  received_payment_type_id INTEGER,
  reverseschet             INTEGER default 0,
  parent_payment_id        INTEGER,
  is_distributed           NUMBER(1),
  payment_period           INTEGER,
  
  phone_number_new             VARCHAR2(10 CHAR),
  payment_sum_new               NUMBER(15,2) ,
  payment_date_time_new         DATE,
  contract_id_new               INTEGER,
  is_contract_payment_new       NUMBER(1) default 0,
  filial_id_new                 INTEGER,
  payment_annul_flag_new        NUMBER(1) default 0,
  payment_annul_date_time_new   DATE,
  payment_annul_reason_new      VARCHAR2(200 CHAR),
  user_who_annulate_new         VARCHAR2(30 CHAR),

  remark_new                    VARCHAR2(500 CHAR),
  received_payment_type_id_new  INTEGER,
  reverseschet_new              INTEGER default 0,
  parent_payment_id_new         INTEGER,
  is_distributed_new           NUMBER(1),
  payment_period_new            INTEGER
  
  );  

comment on table RECEIVED_PAYMENTS_LOG is '���������������� ��������� � ������� �������� ������� RECEIVED_PAYMENTS';
comment on column RECEIVED_PAYMENTS_LOG.fdate_rec is '���� ���������';
comment on column RECEIVED_PAYMENTS_LOG.curr_schema is '������ �������� : �����';
comment on column RECEIVED_PAYMENTS_LOG.curr_user is '������ �������� : ������������';
comment on column RECEIVED_PAYMENTS_LOG.host is '������ �������� : HOST';
comment on column RECEIVED_PAYMENTS_LOG.ip_address is '������ �������� : IP';
comment on column RECEIVED_PAYMENTS_LOG.os_user is '������ �������� : ������������ OS';
comment on column RECEIVED_PAYMENTS_LOG.faction is '�������� (INSERT, UPDATE, DELETE)';
comment on column RECEIVED_PAYMENTS_LOG.received_payment_id is '��������� ���� ������ RECEIVED_PAYMENT';
comment on column RECEIVED_PAYMENTS_LOG.phone_number is '������ �������� ���� : ����� ��������';
comment on column RECEIVED_PAYMENTS_LOG.payment_sum is '������ �������� ���� : ���������� �����';
comment on column RECEIVED_PAYMENTS_LOG.payment_date_time is '������ �������� ���� : ���� � ����� �������';
comment on column RECEIVED_PAYMENTS_LOG.contract_id is '������ �������� ���� : ��� ��������';
comment on column RECEIVED_PAYMENTS_LOG.is_contract_payment is '������ �������� ���� : �������, ��� ����� ������ ��� ���������� ���������';
comment on column RECEIVED_PAYMENTS_LOG.filial_id is '������ �������� ���� : ��� ������� (�����), ���������� �����';
comment on column RECEIVED_PAYMENTS_LOG.payment_annul_flag is '������ �������� ���� : ������� �������������';
comment on column RECEIVED_PAYMENTS_LOG.payment_annul_date_time is '������ �������� ���� : ���� � ����� ������������� �������';
comment on column RECEIVED_PAYMENTS_LOG.payment_annul_reason is '������ �������� ���� : ������� �������������';
comment on column RECEIVED_PAYMENTS_LOG.user_who_annulate is '������ �������� ���� : ������������, ������� ����������� �����';
comment on column RECEIVED_PAYMENTS_LOG.remark is '������ �������� ���� : ���������� � �������';
comment on column RECEIVED_PAYMENTS_LOG.received_payment_type_id is '������ �������� ���� : ��� �������(������ �� RECEIVED_PAYMENT_TYPES)';
comment on column RECEIVED_PAYMENTS_LOG.reverseschet is '������ �������� ���� : ���� 1, �� � ����������� ������� - ����� ����������� � ��������������� ������ ��� ������ ���������� � ������';
comment on column RECEIVED_PAYMENTS_LOG.parent_payment_id is '������ �������� ���� : ������ �� ������������ ������ (��� ������ ������� � �������������� �������)';
comment on column RECEIVED_PAYMENTS_LOG.is_distributed is '������ �������� ���� : ';
comment on column RECEIVED_PAYMENTS_LOG.payment_period is '������ �������� ���� : ������ ������������� ������ (��� �������������� �������� �� ������ �������) � ������� YYYYMM';
comment on column RECEIVED_PAYMENTS_LOG.phone_number_new  is '����� �������� ���� : ����� ��������';
comment on column RECEIVED_PAYMENTS_LOG.payment_sum_new  is '����� �������� ���� : ���������� �����';
comment on column RECEIVED_PAYMENTS_LOG.payment_date_time_new  is '����� �������� ���� : ���� � ����� �������';
comment on column RECEIVED_PAYMENTS_LOG.contract_id_new is '����� �������� ���� : ��� ��������';
comment on column RECEIVED_PAYMENTS_LOG.is_contract_payment_new  is '����� �������� ���� : �������, ��� ����� ������ ��� ���������� ���������';
comment on column RECEIVED_PAYMENTS_LOG.filial_id_new is '����� �������� ���� : ��� ������� (�����), ���������� �����';
comment on column RECEIVED_PAYMENTS_LOG.payment_annul_flag_new  is '����� �������� ���� : ������� �������������';
comment on column RECEIVED_PAYMENTS_LOG.payment_annul_date_time_new  is '����� �������� ���� : ���� � ����� ������������� �������';
comment on column RECEIVED_PAYMENTS_LOG.payment_annul_reason_new  is '����� �������� ���� : ������� �������������';
comment on column RECEIVED_PAYMENTS_LOG.user_who_annulate_new  is '����� �������� ���� : ������������, ������� ����������� �����';
comment on column RECEIVED_PAYMENTS_LOG.remark_new  is '����� �������� ���� : ���������� � �������';
comment on column RECEIVED_PAYMENTS_LOG.received_payment_type_id_new  is '����� �������� ���� : ��� �������(������ �� RECEIVED_PAYMENT_TYPES)';
comment on column RECEIVED_PAYMENTS_LOG.reverseschet_new  is '����� �������� ���� : ���� 1, �� � ����������� ������� - ����� ����������� � ��������������� ������ ��� ������ ���������� � ������';
comment on column RECEIVED_PAYMENTS_LOG.parent_payment_id_new  is '����� �������� ���� : ������ �� ������������ ������ (��� ������ ������� � �������������� �������)';
comment on column RECEIVED_PAYMENTS_LOG.is_distributed_new  is '����� �������� ���� : ';
comment on column RECEIVED_PAYMENTS_LOG.payment_period_new  is '����� �������� ���� : ������ ������������� ������ (��� �������������� �������� �� ������ �������) � ������� YYYYMM';
