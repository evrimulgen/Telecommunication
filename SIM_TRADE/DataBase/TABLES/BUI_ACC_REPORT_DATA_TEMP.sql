create or replace trigger BUI_ACC_REPORT_DATA_TEMP
  before insert or update on iot_acc_report_data_temp  
  for each row
declare pragma autonomous_transaction;
  --local variables here
  OLD_MONTH_SUM number;
  nil number;
  
begin   
 if to_char(sysdate,'DD')='01'-- and to_number(to_char(sysdate,'HH24'))>10
  then :new.can_load:=0; -- ���� ������� ������ �����, �� ������� ������.  
 elsif to_number(to_char(sysdate,'DD'))<10 then --�� 10�� ������ �� ��������
  begin
    select t.nsum into OLD_MONTH_SUM from IOT_ACC_REPORT_DATA_TEMP t
     where t.account_id=:new.account_id and t.year_month=to_char(add_months(sysdate,-1),'YYYYMM');
  exception
    when no_data_found then OLD_MONTH_SUM:=0;
  end;  
    if :new.nsum<(OLD_MONTH_SUM*0.9) then :new.can_load:=1;
    --���� ������ 90%, �� �������� ��������
     --���� � ������ 10 ���� ����� ������ ���� ����� �������� ������+(������� ����� �� ���� * ���.����) 
     --������ ������, ����� ������������� �������� � ����� ���-��.(���� ������ ����) 
    elsif :new.nsum>OLD_MONTH_SUM+OLD_MONTH_SUM*(to_number(to_char(sysdate,'DD'))/30)
            and OLD_MONTH_SUM!=0
             then :new.can_load:=0; 
             nil:=loader3_pckg.SEND_SMS('9277401866','system',:new.account_id||' RD:���� �������� �� �.�����');
    end if;
 elsif to_number(to_char(sysdate,'DD'))>=10
  then :new.can_load:=1;
 end if; 
  
commit;
end BUI_ACC_REPORT_DATA_TEMP;
/
