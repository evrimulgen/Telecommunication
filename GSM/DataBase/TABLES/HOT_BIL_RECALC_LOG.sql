create table HOT_BIL_RECALC_LOG
(
  subscr_no   VARCHAR2(11 CHAR),
  start_time  DATE,
  dbf_id      NUMBER(38),
  duration    INTEGER,
  tariff_id   INTEGER,
  cost_min    INTEGER,
  cnt_podkl   INTEGER,
  name_opcion VARCHAR2(15 CHAR),
  record_time DATE default sysdate not null,
  ticket_id   NVARCHAR2(15),
  CONTRACT_ID  INTEGER,
  DURATION2    INTEGER
);
 
comment on table HOT_BIL_RECALC_LOG
  is '������ ��������� ������ ������ HOT_BILLING_RECALC_ROW_P�KG';
comment on column HOT_BIL_RECALC_LOG.subscr_no
  is '����� �������� ';
comment on column HOT_BIL_RECALC_LOG.start_time
  is '����� ������';
comment on column HOT_BIL_RECALC_LOG.dbf_id
  is 'Id ����� ���������';
comment on column HOT_BIL_RECALC_LOG.duration
  is '������������';
comment on column HOT_BIL_RECALC_LOG.tariff_id
  is 'Id ������';
comment on column HOT_BIL_RECALC_LOG.cost_min
  is ' ��������� ������';
comment on column HOT_BIL_RECALC_LOG.cnt_podkl
  is '���� �� ���������� �����';
comment on column HOT_BIL_RECALC_LOG.name_opcion
  is '��� ������������ �����';
comment on column HOT_BIL_RECALC_LOG.record_time
  is '����� ������ � ��� �������';
comment on column HOT_BIL_RECALC_LOG.ticket_id
  is '����� ������������ ������ � ������, ������ �� ����. BEELINE_TICKETS
(  ticket_id)';

COMMENT ON COLUMN HOT_BIL_RECALC_LOG.CONTRACT_ID IS '������ �� ��������� ���� CONTRACTS.contract_id';

COMMENT ON COLUMN HOT_BIL_RECALC_LOG.DURATION2 IS '������������ ���������� �������';
