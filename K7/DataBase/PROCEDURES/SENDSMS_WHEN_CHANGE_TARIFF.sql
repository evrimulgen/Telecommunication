CREATE OR REPLACE procedure SENDSMS_WHEN_CHANGE_TARIFF(pMAILING_NAME IN VARCHAR2 default null) is
--#Version=4

--v.4 �������� 20.01.2016 ������� ����� �������� ���. ������ ������������ � 9 �� 21.
--v.3 �������� 06.10.2015 ����� ����������� �� �������� ��� �� ������ � ������ �� PB450CL_F, PS750CL_F, PS900CL_F, MSKMINCLF, MSKLIGLCF. ������ � ������ 1.
--v.2 �������� 30.09.2015 ��������� �������� ��� �� ������ � ������ �� PB450CL_F, PS750CL_F, PS900CL_F, MSKMINCLF, MSKLIGLCF ��������. ����� ������ �������. 
--                                     ������� - �������� ������� � �� �� �� ����, � ����� � ���� ��� ���������� �� �����
-- 1. ��������, �������. ������ http://redmine.tarifer.ru/issues/2677.
--       ��������� SENDSMS_WHEN_CHANGE_TARIFF �������� �� ������� �������, � ������� �� ��������� ����� ���� ����� �� � ������� (�� ������� DB_LOADER_ACCOUNT_PHONE_HISTS) � � �������� (�� ������� contract_changes) ��� � �������� � ���� ����.
--       ����������� �� ������� ����� �������� ��� (SEND_SMS_CHANGE_TARIFF_LOG), ��� ��� � ���� ����� ��� �� ���������� � ���������� ���.  
CURSOR c is 
  select beeline.phone_number, beeline.change_date,
         beeline.tariff_code, tarifer.tariff_name, beeline.tariff_code_lag
    from 
        (select trunc(begin_date) change_date, 
               begin_date, phone_number, 
               cell_plan_code tariff_code,
               lag(cell_plan_code) over (partition by phone_number order by begin_date) tariff_code_lag
          from DB_LOADER_ACCOUNT_PHONE_HISTS
         --where PHONE_NUMBER = '9654041993'  ��� ����� 
        ) beeline
       ,(select distinct c.phone_number_federal, 
               cc.contract_change_date, 
               t.tariff_code, 
               t.tariff_name, 
               trunc(cc.contract_change_date) change_date
          from contract_changes cc, 
               contracts c, 
               tariffs t 
         where cc.docum_type_id = 4 
           and c.contract_id = cc.contract_id 
           and cc.tariff_id = t.tariff_id
           --and C.PHONE_NUMBER_FEDERAL = '9654041993'  ��� �����
       ) tarifer
  where beeline.tariff_code_lag is not null 
    and beeline.tariff_code <> beeline.tariff_code_lag
    and beeline.phone_number = tarifer.phone_number_federal
    and beeline.tariff_code = tarifer.tariff_code
    and ((beeline.change_date = tarifer.change_date) or
         (beeline.change_date = tarifer.change_date-1)or
         (beeline.change_date = tarifer.change_date+1)
        )
    and not exists 
           (select 1 from SEND_SMS_CHANGE_TARIFF_LOG
             where phone_number = beeline.phone_number 
               and tariff_code = beeline.tariff_code
               and change_date = beeline.change_date
               and error_text is null
           )
    and ( (beeline.change_date > SYSDATE - 1) or
          (tarifer.change_date > SYSDATE - 1) );

  itog VARCHAR2(200 CHAR);
  vMAILING_NAME VARCHAR2(30 CHAR);
BEGIN
  --�������� �� ����� �������� - �� ������ � 9 �� 21 � �������� � 9 �� 21.
  IF ((TO_NUMBER(TO_CHAR(SYSDATE,'D','NLS_DATE_LANGUAGE=RUSSIAN'))<6) AND (SYSDATE-TRUNC(SYSDATE)>9/24) AND (SYSDATE-TRUNC(SYSDATE)<21/24))
       OR((TO_NUMBER(TO_CHAR(SYSDATE,'D','NLS_DATE_LANGUAGE=RUSSIAN'))>5) AND (SYSDATE-TRUNC(SYSDATE)>9/24) AND (SYSDATE-TRUNC(SYSDATE)<21/24))  THEN
    for v in c loop 
      begin   
        exit when c%notfound;
        if pMAILING_NAME is null then 
          vMAILING_NAME:='���-����������';
        else
          vMAILING_NAME:=pMAILING_NAME;
        end if;
        itog:=loader3_pckg.SEND_SMS(v.phone_number, vMAILING_NAME, '��� ����� ������� �� "'||v.tariff_name||'"');
        INSERT INTO SEND_SMS_CHANGE_TARIFF_LOG (phone_number, tariff_code, change_date, send_date_time, error_text)
        VALUES (v.phone_number, v.tariff_code, v.change_date, SYSDATE, itog);
      exception
        when others then 
          itog:=substr(SQLERRM,1,200);
          INSERT INTO SEND_SMS_CHANGE_TARIFF_LOG (phone_number, tariff_code, change_date, send_date_time, error_text)
          VALUES (v.phone_number, v.tariff_code, v.change_date, SYSDATE, itog);
      end;      
    end loop;
    COMMIT;
  END IF; 
END SENDSMS_WHEN_CHANGE_TARIFF;