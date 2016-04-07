CREATE OR REPLACE PROCEDURE CALC_BALANCE_ROWS_ALL IS
--#Version=2
--
-- 2. 2015.10.29. �������. 
  L BINARY_INTEGER;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE ABONENT_BALANCE_ROWS_ALL'; 
  commit;
  for rec in (select d.PHONE_NUMBER
                from db_loader_phone_periods d
                where d.YEAR_MONTH = TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM'))
                  and not exists (select 1
                                    from tarifer_bill_for_clients v
                                    where v.YEAR_MONTH = d.YEAR_MONTH
                                      and v.PHONE_NUMBER = d.PHONE_NUMBER)
             )
  loop
    CALC_BALANCE_ROWS_NO_CREDIT(rec.PHONE_NUMBER);
    insert into ABONENT_BALANCE_ROWS_ALL(phone_number, ROW_DATE, ROW_COST, ROW_COMMENT)
      select rec.PHONE_NUMBER, ROW_DATE, ROW_COST, ROW_COMMENT  
        from ABONENT_BALANCE_ROWS;
    commit;
  end loop;
  update ABONENT_BALANCE_ROWS_ALL
    set ROW_TYPE = case
                     when ROW_COMMENT LIKE '1 ���������%' then 1
                     when ROW_COMMENT LIKE '2 ��������� �� ������%' then 2
                     when ROW_COMMENT LIKE '���. ��. �� ���. ���.%' then 3
                     when ROW_COMMENT LIKE '����������� �������%' then 4
                     when ROW_COMMENT LIKE '���������� ������%' then 5                     
                     when ROW_COMMENT LIKE '���������:%' then 6  
                     when ROW_COMMENT LIKE '������� �������%' then 7 
                     when ROW_COMMENT LIKE '������������ ���������� ������ (3� � ����)' then 8  
                     when ROW_COMMENT LIKE '����%' then 10
                     when ROW_COMMENT LIKE '������: ��������� ������%' then 11
                     when ROW_COMMENT LIKE '������: ��������������� � �����:%' then 12
                     when ROW_COMMENT LIKE '������ ��������������:%' then 13
                     when ROW_COMMENT LIKE '��������� ������' then 14
                     when ROW_COMMENT LIKE '������:%' then 20
                     else -1
                   end;
  COMMIT;
END;
/