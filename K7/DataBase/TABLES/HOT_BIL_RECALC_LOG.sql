-- Create table
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
  ticket_id   NVARCHAR2(15)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table HOT_BIL_RECALC_LOG
  is '������ ��������� ������ ������ HOT_BILLING_RECALC_ROW_P�KG';
-- Add comments to the columns 
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
/