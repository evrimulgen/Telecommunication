--#if not TableExists("CONTRACT_GROUPS") then
CREATE TABLE CONTRACT_GROUPS
(
 GROUP_ID INTEGER NOT NULL,
 GROUP_NAME VARCHAR2(220 CHAR) 
);
--#end if

--#Execute MAIN_SCHEMA=IsClient("")

--#if not GrantExists("CONTRACT_GROUPS", "ROLE", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT ALL ON CONTRACT_GROUPS TO &MAIN_SCHEMA'||'_ROLE'; end;
--#end if

--#if not GrantExists("CONTRACT_GROUPS", "ROLE_RO", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT SELECT ON CONTRACT_GROUPS TO &MAIN_SCHEMA'||'_ROLE_RO'; end;
--#end if

--#if not ObjectExists("S_NEW_CONTRACT_GROUP_ID")
CREATE SEQUENCE S_NEW_CONTRACT_GROUP_ID
START WITH 101 MAXVALUE 999999999999999999999999999
MINVALUE 1
NOCYCLE
CACHE 20
NOORDER;
--#end if

--#if not GrantExists("S_NEW_CONTRACT_GROUP_ID", "ROLE", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT SELECT ON S_NEW_CONTRACT_GROUP_ID TO &MAIN_SCHEMA'||'_ROLE'; end;
--#end if

--#if not GrantExists("S_NEW_CONTRACT_GROUP_ID", "ROLE_RO", "SELECT") then
begin EXECUTE IMMEDIATE 'GRANT SELECT ON S_NEW_CONTRACT_GROUP_ID TO &MAIN_SCHEMA'||'_ROLE_RO'; end;
--#end if

--#if GetColumnSize("CONTRACT_GROUPS.GROUP_NAME") < 220 then
ALTER TABLE CONTRACT_GROUPS
MODIFY GROUP_NAME VARCHAR2(220);
--#end if

--#if not ColumnExists("CONTRACT_GROUPS.paramussd_gr_bal") then
ALTER TABLE CONTRACT_GROUPS ADD paramussd_gr_bal NUMBER(1);
--#end if

--#if GetColumnComment("CONTRACT_GROUPS.paramussd_gr_bal") <> "��������:  ���������� �� ussd ������ ������" then
COMMENT ON COLUMN CONTRACT_GROUPS.paramussd_gr_bal IS '��������:  ���������� �� ussd ������ ������';
--#end if

--#if not ColumnExists("CONTRACT_GROUPS.PARAMPDF_CONTACTS") then
ALTER TABLE CONTRACT_GROUPS ADD PARAMPDF_CONTACTS VARCHAR2(600);
--#end if

--#if GetColumnComment("CONTRACT_GROUPS.PARAMPDF_CONTACTS") <> "��������: ���������� ������ ��� ������ PDF" then
COMMENT ON COLUMN CONTRACT_GROUPS.PARAMPDF_CONTACTS IS '��������: ���������� ������ ��� ������ PDF';
--#end if

--#if not ColumnExists("CONTRACT_GROUPS.PARAMPDF_BANKDET") then
ALTER TABLE CONTRACT_GROUPS ADD PARAMPDF_BANKDET VARCHAR2(600);
--#end if

--#if GetColumnComment("CONTRACT_GROUPS.PARAMPDF_BANKDET") <> "��������: ���������� ��������� ��� ������ PDF" then
COMMENT ON COLUMN CONTRACT_GROUPS.PARAMPDF_BANKDET IS '��������: ���������� ��������� ��� ������ PDF';
--#end if

--#if not ColumnExists("CONTRACT_GROUPS.PARAMPDF_LOGO") then
ALTER TABLE CONTRACT_GROUPS ADD PARAMPDF_LOGO BLOB;
--#end if

--#if GetColumnComment("CONTRACT_GROUPS.PARAMPDF_LOGO") <> "��������: ������� ��� ������ PDF" then
COMMENT ON COLUMN CONTRACT_GROUPS.PARAMPDF_LOGO IS '��������: ������� ��� ������ PDF';
--#end if

--#if not ColumnExists("CONTRACT_GROUPS.PARAMDET_MAIL") then
ALTER TABLE CONTRACT_GROUPS ADD PARAMDET_MAIL VARCHAR2(100);
--#end if

--#if GetColumnComment("CONTRACT_GROUPS.PARAMDET_MAIL") <> "��������: ����� ����� ��� �������� �����������" then
COMMENT ON COLUMN CONTRACT_GROUPS.PARAMDET_MAIL IS '��������: ����� ����� ��� �������� �����������';
--#end if

 --#if not ColumnExists("CONTRACT_GROUPS.hand_block_date_end") then
 -- Add/modify columns 
alter table CONTRACT_GROUPS add hand_block_date_end date;
-- Add comments to the columns 
comment on column CONTRACT_GROUPS.hand_block_date_end
  is '��������: ������ ���������� ��� ���� ������ - ���� ���������';
--#end if 

--#if not ObjectExists("PK_CONTRACT_GROUPS_GROUP_ID") then
ALTER TABLE CONTRACT_GROUPS
 ADD CONSTRAINT PK_CONTRACT_GROUPS_GROUP_ID
  PRIMARY KEY (GROUP_ID);
-- #end if  