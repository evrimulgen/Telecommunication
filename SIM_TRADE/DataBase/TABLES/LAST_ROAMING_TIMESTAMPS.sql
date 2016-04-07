--#if not TableExists("LAST_ROAMING_TIMESTAMPS") then
CREATE TABLE LAST_ROAMING_TIMESTAMPS
(
  PHONE_NUMBER            VARCHAR2(11) PRIMARY KEY,
  LAST_SERVICE_DATE_TIME  DATE,
  LAST_FULLCOST_CALL_DATE_TIME DATE
) ORGANIZATION INDEX;
--#end if

--#if GetTableComment("LAST_ROAMING_TIMESTAMPS")<>"��������� ����� �������� ��� ����������� ������" then
COMMENT ON TABLE LAST_ROAMING_TIMESTAMPS IS '��������� ����� �������� ��� ����������� ������';
--#end if

--#if GetColumnComment("LAST_ROAMING_TIMESTAMPS.PHONE_NUMBER") <> "����� �������� (��������� ����)" then
COMMENT ON COLUMN LAST_ROAMING_TIMESTAMPS.PHONE_NUMBER IS '����� �������� (��������� ����)';
--#end if

--#if GetColumnComment("LAST_ROAMING_TIMESTAMPS.LAST_SERVICE_DATE_TIME") <> "����/����� ��������� ������ � ��������" then
COMMENT ON COLUMN LAST_ROAMING_TIMESTAMPS.LAST_SERVICE_DATE_TIME IS '����/����� ��������� ������ � ��������';
--#end if

--#if GetColumnComment("LAST_ROAMING_TIMESTAMPS.LAST_FULLCOST_CALL_DATE_TIME") <> "����/����� ���������� ������ � �������� �� ������ ���������" then
COMMENT ON COLUMN LAST_ROAMING_TIMESTAMPS.LAST_FULLCOST_CALL_DATE_TIME IS '����/����� ���������� ������ � �������� �� ������ ���������';
--#end if
