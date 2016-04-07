CREATE OR REPLACE procedure SEND_UNL_INTERNET_NOTICE_MONTH is

    --Version 5
    --
    --v.5 01.02.2016. ��������. ������� ����� ���, ������� ������������ � ��������� � ������������� ��� ������.
    --v4. 22.10.2015. ��������. �� ������� ������� ��� ������ ���������� � � ������������� ���� ������.
    --                                       �.�. ���� 3 ��������� ��� ������. � ��������. ���� ��� ����� �� ��� � � ���������.
    --v3. 29.06.2015. ��������. ������� ����� ���, ������������ � ��������� ���� ������
    --v2. 17.04.2015. ��������. �������� �������� ��� �� �������
    --v1. 16.04.2015. ��������. ��������� �������� ��� � �������� ���� ����� ��� ������� � ����������� ����������, � ������� ������ ������ ������
    
    shab varchar2(500 char);
    shabVs varchar2(500 char);   
    month_name varchar2(20 char);
    pCountPh integer;
    vSpeedSendSms integer;
    pLastMin integer;
    vRes integer;
    
    PROCEDURE SEND_SMS_ABON (pShab in varchar2, pShabVs in varchar2, pNumRow in integer default 0) IS
        --��������� ��������� �� ���������� ������� � ���������� ���
        v varchar2(500 char);
        sms_text varchar2(500 char);
        curnm sys_refcursor;
        str varchar2(100 char);
        v_phone varchar2(10 char);
        v_monthly_payment NUMBER(15,2);
    BEGIN
        --���������� ����� �� �������� �������
        if pNumRow = 0 then
            str := '';
        else
            str := ' and ROWNUM <= '||to_char(pNumRow);
        end if;
        -- ��������� �� ���� ������� �� ������� CALL
        open curnm for 'select 
                                    v.PHONE_NUMBER_FEDERAL, 
                                    v.MONTHLY_PAYMENT
                                from V_PHONE_UNL_INET_BAL_LESS_ABON v
                                where not exists
                                                    (
                                                        select 1
                                                        from LOG_SEND_SMS sm
                                                        where SM.PHONE_NUMBER = V.PHONE_NUMBER_FEDERAL
                                                        and SM.NOTE is null
                                                        and trunc(SM.DATE_SEND) = trunc(sysdate)
                                                        and SM.SMS_TEXT like :pshabVs
                                                    ) '||str using pshabVs;
        loop
            FETCH curnm INTO v_phone, v_monthly_payment;
            EXIT WHEN curnm%NOTFOUND;          
            sms_text:=replace(pshab, '%abon_sum%', to_char(v_monthly_payment));  
            --���� ���� ������� ��� ������������� ���� ������
            if (to_char(sysdate + 1, 'yyyymmdd') = to_char(add_months(sysdate, 1), 'yyyymm')||'01') or
               (to_char(sysdate + 2, 'yyyymmdd') = to_char(add_months(sysdate, 1), 'yyyymm')||'01') then
                sms_text:=replace(sms_text, '%rec_pay%', to_char(trunc(v_monthly_payment - GET_ABONENT_BALANCE(v_phone))+1));     
            end if;          
            v:=loader3_pckg.SEND_SMS(v_phone, 'Teletie', sms_text);
        end loop;
    END;
  
BEGIN
    --���������� ������ � ��������� 3 ���� ������
    if to_char(sysdate + 3, 'yyyymm') = to_char(add_months(sysdate, 1), 'yyyymm') then    
         
        --�������� ��� � ������ � 10 �� 16 (����� 1 ������������ � 16 ����� ��������� ���������). � ������� ���� ��������� ����� �������� � ������ ������ (�� ������ ������)
        if (to_number(to_char(sysdate, 'HH24')) = 10)  then
            --�������� ������ ��������� ����������� 1
            vRes := MS_params.SET_PARAM_VALUE('CHECK_NEED_WORK_PROC_SEND_UNL_INTERNET', 1); --��������
        end if;
        
        if (to_number(to_char(sysdate, 'HH24')) >= 10) and
           (to_number(MS_params.GET_PARAM_VALUE('CHECK_NEED_WORK_PROC_SEND_UNL_INTERNET')) = 1) then
            --����� ���
            if (to_char(sysdate + 3, 'yyyymmdd') = to_char(add_months(sysdate, 1), 'yyyymm')||'01') then --��� � ����������������� ���� ������
                shab:='��������� �������! %new_date% ����� ������� ����. ����� �� ������ �� %month_name% - %abon_sum% ���. �� ��������� ����������, ���������� ������ �������. �����������: +74997090202.';
            else
                --������������� ������: (����.����� - ������), ���������� �������� � ����������� �� ����� � ������� �������
                shab:='��������� �������! %new_date% �������� ����. ����� �� %month_name% - %abon_sum% ���. ����������� ������������� ������ %rec_pay% ���. ��� ���������� ����� �� ������� ����� ����� ���� ������������ %cur_date%. ���.: +74997090202.';
            end if;
            --���������� �����, �� �������� ���������� ��������� ������
            month_name:= 
                case
                    when to_char(sysdate, 'mm') = '01' then '�������'
                    when to_char(sysdate, 'mm') = '02' then '����'
                    when to_char(sysdate, 'mm') = '03' then '������'
                    when to_char(sysdate, 'mm') = '04' then '���'
                    when to_char(sysdate, 'mm') = '05' then '����'
                    when to_char(sysdate, 'mm') = '06' then '����'
                    when to_char(sysdate, 'mm') = '07' then '������'
                    when to_char(sysdate, 'mm') = '08' then '��������'
                    when to_char(sysdate, 'mm') = '09' then '�������'
                    when to_char(sysdate, 'mm') = '10' then '������'
                    when to_char(sysdate, 'mm') = '11' then '�������'
                    when to_char(sysdate, 'mm') = '12' then '������'
                    else ''
                end;
            --������ ��������
            shab:= replace(shab, '%new_date%', '01.'||to_char(add_months(sysdate, 1), 'mm.yyyy'));    
            shab:= replace(shab, '%month_name%', month_name);
            --���� ��� ��������� ��� �������������  ���� ������, �� ��������� ���� ���������� ��� ������
            if (to_char(sysdate + 1, 'yyyymmdd') = to_char(add_months(sysdate, 1), 'yyyymm')||'01') or
               (to_char(sysdate + 2, 'yyyymmdd') = to_char(add_months(sysdate, 1), 'yyyymm')||'01') then
                shab:= replace(shab, '%cur_date%', to_char((trunc(add_months(sysdate, 1), 'MM') - 1), 'DD.MM.YYYY')); 
            end if;
                
            --������ ��� ������
            shabVs := replace(shab, '%abon_sum%', '%');
            if (to_char(sysdate + 1, 'yyyymmdd') = to_char(add_months(sysdate, 1), 'yyyymm')||'01') or
               (to_char(sysdate + 2, 'yyyymmdd') = to_char(add_months(sysdate, 1), 'yyyymm')||'01') then
                shabVs := replace(shabVs, '%rec_pay%', '%');
            end if;
            --���������� ���������� �������, ������� ���������� ���������
            --�������� ��, �� ������� ��� ���� ��� ���������� �� ����������� ����
            select count(*)
            into pCountPh
            from V_PHONE_UNL_INET_BAL_LESS_ABON v
            where not exists
                                (
                                    select 1
                                    from LOG_SEND_SMS sm
                                    where SM.PHONE_NUMBER = V.PHONE_NUMBER_FEDERAL
                                    and SM.NOTE is null
                                    and trunc(SM.DATE_SEND) = trunc(sysdate)
                                    and SM.SMS_TEXT like shabVs
                                );
                                
            --�������� ���� ���������� ��� > 0
            if pCountPh > 0 then  
                --��������� �� ������� ����������� ���������. ���� ��� ��� 16 �����, �� �������� ��� ��� �������� � ��������� ���������� ���������
                if (to_number(to_char(sysdate, 'HH24')) < 16) then
                    --����� ���������� � ��������, �� ����� �������� ��� � ������ ���� ������� 14 ���.
                    --���� ���������� ��� < 14, �� ���������� ����� ���
                    if pCountPh <= 14 then
                        --�������� ��� ��� �����
                        SEND_SMS_ABON(shab, shabVs);   
                        --��������� ���������� ���������
                        vRes := MS_params.SET_PARAM_VALUE('CHECK_NEED_WORK_PROC_SEND_UNL_INTERNET', 0); --�� �������� 
                    else
                        --���������� ���������� �����
                        pLastMin := trunc(((trunc(sysdate) + 16/24) - sysdate)*24*60);
                        
                        if pLastMin > 0 then --�� ���� ������� �� ����� �������������, �.�. ���� ����� �������� �� ������� (to_number(to_char(sysdate, 'HH24')) < 16)
                            --������� �������� �������� ��� 
                            --���������� ��� ����� �� ���������� ���������� �����
                            vSpeedSendSms := round(pCountPh/pLastMin);
                            --���� ���������� ���, ������� ����� ��������� �� ����������� ������ ������ 14, �� �������� �� 14 ��� � ������
                            --����� �������� �� ��������� ������� ����������
                            if vSpeedSendSms <= 14 then
                                --�������� �� 14 ���
                                SEND_SMS_ABON(shab, shabVs, 14);    
                            else
                                --�������� �� �������� ������� ����������
                                SEND_SMS_ABON(shab, shabVs, vSpeedSendSms);                 
                            end if;
                        end if;            
                    end if;                
                else
                    --�������� ��� ��� �����
                    SEND_SMS_ABON(shab, shabVs);                    
                    --��������� ���������� ���������
                    vRes := MS_params.SET_PARAM_VALUE('CHECK_NEED_WORK_PROC_SEND_UNL_INTERNET', 0); --�� ��������   
                end if;
            else --���� ���������� ������� = 0, �� ��������� ���������� ���������
                vRes := MS_params.SET_PARAM_VALUE('CHECK_NEED_WORK_PROC_SEND_UNL_INTERNET', 0); --�� ��������     
            end if;
        end if; 
    end if;
END;