-- Create table
--#if not TableExists("ALL_LOAD_LOGS") then
create table ALL_LOAD_LOGS
(
  load_log_id          INTEGER,
  email                VARCHAR2(32),
  load_date_time       DATE,
  is_success           NUMBER(1),
  error_text           VARCHAR2(2000 CHAR),
  account_load_type_id INTEGER,
  beeline_rn           VARCHAR2(30)
)
--#end if

-- Add comments to the table 
--#if GetTableComment("ALL_LOAD_LOGS")<>"������ ����� �������� ���������� � ����� ���������" then
comment on table ALL_LOAD_LOGS
  is '������ ����� �������� ���������� � ����� ���������';
--#end if

-- Add comments to the columns 
--#if GetTableComment("ALL_LOAD_LOGS.load_log_id")<>"��������� ����" then
comment on column ALL_LOAD_LOGS.load_log_id
  is '��� ������ (��������� ����)';
--#end if

--#if GetTableComment("ALL_LOAD_LOGS.email")<>"E-mail ���������� ������" then
comment on column ALL_LOAD_LOGS.email
  is 'E-mail ���������� ������';
--#end if

--#if GetTableComment("ALL_LOAD_LOGS.load_date_time")<>"���� � ����� ��������" then
comment on column ALL_LOAD_LOGS.load_date_time
  is '���� � ����� ��������';
--#end if

--#if GetTableComment("ALL_LOAD_LOGS.is_success")<>"������� �������� �������� (1 - �������, 0 - ������)" then
comment on column ALL_LOAD_LOGS.is_success
  is '������� �������� �������� (1 - �������, 0 - ������)';
--#end if

--#if GetTableComment("ALL_LOAD_LOGS.error_text")<>"����� ������ ��� ���������� ��������" then
comment on column ALL_LOAD_LOGS.error_text
  is '����� ������ ��� ���������� ��������';
--#end if

--#if GetTableComment("ALL_LOAD_LOGS.beeline_rn")<>"��� ������ ������" then
comment on column ALL_LOAD_LOGS.beeline_rn
  is '��� ������ ������';
--#end if


--#Execute MAIN_SCHEMA=IsClient("")

--#if not GrantExists("ALL_LOAD_LOGS", "ROLE", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT ALL ON ALL_LOAD_LOGS TO &MAIN_SCHEMA'||'_ROLE'; end;
--#end if

--#if not GrantExists("ALL_LOAD_LOGS", "ROLE_RO", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT SELECT ON ALL_LOAD_LOGS TO &MAIN_SCHEMA'||'_ROLE_RO'; end;
--#end if
