
  CREATE OR REPLACE FUNCTION "CORP_MOBILE"."GET_HOT_DETAIL" 
(
 PHONE_NUMBER VARCHAR2,
 YEAR_MONTH NUMBER
)
RETURN CALL_TAB 
AS
  l_tab CALL_TAB := CALL_TAB();
  pYear varchar2(4);
  pmonth varchar2(2);
  
BEGIN
 pYear:=substr(to_char(YEAR_MONTH), 1,4);
 DBMS_OUTPUT.PUT_LINE(pYear);
 pMonth:=substr(to_char(YEAR_MONTH), 5,2);
 DBMS_OUTPUT.PUT_LINE(pMonth);
 EXECUTE IMMEDIATE 'SELECT CAST (MULTISET(SELECT SUBSCR_NO ,
START_TIME ,
AT_FT_CODE ,
DBF_ID ,
call_cost ,
costnovat ,
dur ,
IMEI ,
ServiceType      ,
ServiceDirection ,
IsRoaming        ,
RoamingZone      ,
CALL_DATE ,
CALL_TIME ,
DURATION ,
DIALED_DIG ,
AT_FT_DE ,
AT_FT_DESC ,
CALLING_NO ,
AT_CHG_AMT ,
DATA_VOL ,
CELL_ID ,
MN_UNLIM from  CALL_'||pMonth||'_'||pYear||' WHERE SUBSCR_NO='''||PHONE_NUMBER||''') AS CALL_TAB) FROM DUAL' into l_tab;
return l_tab;
end;