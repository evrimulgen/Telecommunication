--#if not TableExists("SEND_DETAIL_GROUPS_LOG") then
create table SEND_DETAIL_GROUPS_LOG
(
  group_id		INTEGER,
  year_month		INTEGER,
  send_date_time	DATE,
  error_text		VARCHAR2(2000 CHAR)
);
comment on table SEND_DETAIL_GROUPS_LOG is '��� �������� ����������� ����� ���������';
--#end if

--#if GetColumnComment("SEND_DETAIL_GROUPS_LOG.group_id") <> "������" then
comment on column SEND_DETAIL_GROUPS_LOG.group_id is '������';
--#end if
--#if GetColumnComment("SEND_DETAIL_GROUPS_LOG.year_month") <> "��� � ����� ��������� �������" then
comment on column SEND_DETAIL_GROUPS_LOG.year_month is '��� � ����� ��������� �������';
--#end if
--#if GetColumnComment("SEND_DETAIL_GROUPS_LOG.send_date_time") <> "���� ��������" then
comment on column SEND_DETAIL_GROUPS_LOG.send_date_time is '���� ��������';
--#end if
--#if GetColumnComment("SEND_DETAIL_GROUPS_LOG.error_text") <> "����� ������" then
comment on column SEND_DETAIL_GROUPS_LOG.error_text is '����� ������';
--#end if

alter table SEND_DETAIL_GROUPS_LOG add (is_detail number(2) default 0);
COMMENT ON COLUMN SEND_DETAIL_GROUPS_LOG.is_detail IS '������� ������� ��� ��������� ������� �� �������� ����������� (0-�����������/1-������)';
