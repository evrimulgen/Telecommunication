CREATE OR REPLACE PROCEDURE BLOCK_FRAUD_BY_CONDITIONS AS
--
--#Version=1
--
--v.1 24.09.2015 ������� ������� ��������� ������������ ���.������� ����. ���������� ���������� � ��������� BLOCK_PHONE_WITH_DOPSTATUS  (������ http://redmine.tarifer.ru/issues/2917)
--                      ���������� ����������� ��������� ������ � ����������� ������ ���� ��� ���������� ��������� ������� ������:
--                      1. ���� ����� ����� ��������� (���� ��������) �� 5 ���� ������������
--                      2. ���� �� ������ ��������� ��� � ��������� Premium Rate MO SMS (�������� ��� ������� ��������, ����������� ����� ����� ���������)
--                      3. ��������� ����� ��� �� ����� 0.


  c_FROUD_DOP_STATUS CONTRACT_DOP_STATUSES.DOP_STATUS_ID%TYPE := 8;
  type ref_cursor is ref cursor;
  sql_txt VARCHAR2(1000 CHAR);
  c ref_cursor;
  v_phone_number contracts.phone_number_federal%TYPE;
  v_contract_id contracts.contract_id%TYPE;
  cnt_days INTEGER;
  mm_yyyy varchar2(7 char);
  mm_yyyy_minus_cnt_days varchar2(7 char);
BEGIN
  cnt_days:= nvl(to_number(MS_CONSTANTS.GET_CONSTANT_VALUE('COUNT_DAYS_AUTO_BLOCK_FRAUD')), 5);
  mm_yyyy := TO_CHAR(SYSDATE,'mm_yyyy');
  mm_yyyy_minus_cnt_days := TO_CHAR(TRUNC(SYSDATE)-(cnt_days - 1), 'mm')||'_'||TO_CHAR(TRUNC(SYSDATE)-(cnt_days - 1),'yyyy');
   
  IF mm_yyyy <> mm_yyyy_minus_cnt_days THEN
    sql_txt:='select c.PHONE_NUMBER_FEDERAL, c.contract_id  from v_contracts c
              where trunc(SYSDATE) - c.CONTRACT_DATE < '||cnt_days||
              ' and c.CONTRACT_CANCEL_DATE is null
                and (exists (select 1 from CALL_'||mm_yyyy||' where subscr_no = c.PHONE_NUMBER_FEDERAL
                               and call_cost <> 0
                               and servicetype=''S''
                               and (at_ft_de=''Premium Rate MO SMS'' or at_ft_desc=''Premium Rate MO SMS''))
                   or exists (select 1 from CALL_'||mm_yyyy_minus_cnt_days||' where subscr_no = c.PHONE_NUMBER_FEDERAL
                                and call_cost <> 0
                                and servicetype=''S''
                                and (at_ft_de=''Premium Rate MO SMS'' or at_ft_desc=''Premium Rate MO SMS''))                            
                      )';    
  ELSE
    sql_txt:='select c.PHONE_NUMBER_FEDERAL, c.contract_id from v_contracts c 
              where trunc(SYSDATE) - c.CONTRACT_DATE < '||cnt_days||
              ' and c.CONTRACT_CANCEL_DATE is null
                and exists (select 1 from CALL_'||mm_yyyy||' where subscr_no = c.PHONE_NUMBER_FEDERAL
                             and call_cost <> 0
                             and servicetype=''S''
                            and (at_ft_de=''Premium Rate MO SMS'' or at_ft_desc=''Premium Rate MO SMS''))';
  END IF;
  OPEN c FOR sql_txt;
  LOOP
    FETCH c INTO v_phone_number, v_contract_id;
    EXIT WHEN c%NOTFOUND;
    --INSERT INTO fraud_blocked_phone (phone_number) VALUES (v_phone_number);
    if nvl(CONVERT_PCKG.GET_IS_COLLECTOR_BY_PHONE (v_phone_number), 0) = 1 then
      UPDATE CONTRACTS
      SET
        DOP_STATUS = c_FROUD_DOP_STATUS--�� �����
      WHERE
        CONTRACT_ID = v_contract_id
        and DOP_STATUS <> c_FROUD_DOP_STATUS
        ;
    end if;

  END LOOP;
  COMMIT;
  --�������� ��������� ��� ���������� ������� � ������������
  BLOCK_PHONE_WITH_DOPSTATUS;
  
END;

