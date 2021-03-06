
  CREATE OR REPLACE PROCEDURE "SIM_TRADE"."TEMP_DELTABAL" (nnum number, sessionid number)
is
 PRAGMA AUTONOMOUS_TRANSACTION;
i number:=1;
n number:=0;
balance_work number;
balance_test number;
phone_number number;
balance_date date:=sysdate;
begin

select round((count(*)/20)+0.5) into n from testbalance_phone1 where num=nnum and session_id=sessionid;

if n<>0 then
for i in 1..n loop
insert into testdelta_balance
select q.phone_number,balance_date, get_abonent_balance(q.phone_number,balance_date),
0,0,0, 0, 0, q.session_id
 from testbalance_phone1 q
 where q.flag=0 and rownum<21
 and num=nnum
 and session_id=sessionid
 and not exists
 (select 1 from testdelta_balance a where a.phone_number=q.phone_number and session_id=sessionid);

commit;

end loop;
end if;

end;
