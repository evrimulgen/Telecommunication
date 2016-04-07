CREATE OR REPLACE PROCEDURE LOAD_ACC_PAYMENTS_4_EQUIPMENTS IS
    --v1. 04.12.2014 ��������. 
    type loader_table is table of varchar2(1000) INDEX BY binary_integer;
    Tloader  loader_table;--������ ����������
    log_EXCEPTION EXCEPTION;
    err varchar2(1000);
    answer_mes blob;--��������
    plogin VARCHAR2(30 CHAR);
    pPASSWORD VARCHAR2(30 CHAR);
    counter number:=0;
    metod_id integer;
    DividerTab varchar2(1):=chr(9);--����������� ���������
    NTitle integer;    
    ValLoad varchar2(200);
  
    --������� ������ � ������� � ������� ����� db_loader_pckg.SET_REPORT_DATA
    function insertstr(item varchar2) return varchar2  is
        rcEquip ACC_PAYMENTS_FOR_EQUIPMENT%rowtype;
        sMSG varchar2(200);
        sTMP varchar2(3000);
        sFld varchar2(2000);
        nPozDivider number;
        nIndexField number;
        pBan integer;
        pCountBan integer;
        pres integer;
        
    begin
        sTMP:=item||dividerTab;
        nIndexField:=0;
        dbms_output.enable;
        
        --������� ������ 
        loop
            nPozDivider:=instr(sTMP,dividerTab,1,1);
            sFld:= substr(sTMP,1,nPozDivider-1);
            sTMP:= substr(sTMP,nPozDivider+1);
            case nIndexField
                when 0 then rcEquip.ACC_PAYMENT_NUMBER := to_number(trim(sFLD)); --����� ����� ������
                when 1 then rcEquip.ACCOUNT_ID := to_number(trim(sFLD)); --����� �������� �����
                when 4 then rcEquip.DATE_ISSUING := to_date(trim(sFLD), 'DD.MM.YYYY'); --���� ����������� ����� ������
                when 5 then rcEquip.ACC_PAYMENT_SUM := to_number(replace(rtrim(sFLD,chr(10)||chr(13)||chr(9)),',','.'), '9999999999.99'); --����� ����� ������ � ���*/
                else null;
            end case;
            nIndexField:=nIndexField+1;
            exit when  nPozDivider is null;
        end loop;
        
        --���������� ������������� BAN
        SELECT count(ACCOUNT_ID)
        INTO pCountBan
        FROM ACCOUNTS
        WHERE ACCOUNT_NUMBER = rcEquip.ACCOUNT_ID; --� ACCOUNT_ID ������� ������� ����� BAN
        
        if pCountBan > 0 then
            SELECT ACCOUNT_ID
            INTO pBan
            FROM ACCOUNTS
            WHERE ACCOUNT_NUMBER = rcEquip.ACCOUNT_ID; --� ACCOUNT_ID ������� ������� ����� BAN
        else
            raise log_EXCEPTION;
        end if;
        
        --��������� ���� �� ������ ���� � �������
        select count(*)
        into pres
        from ACC_PAYMENTS_FOR_EQUIPMENT 
        where ACC_PAYMENT_NUMBER =  rcEquip.ACC_PAYMENT_NUMBER;
        
        --���������  ������, ���� ��� ����������� � �������
        if pres = 0 then
            INSERT INTO ACC_PAYMENTS_FOR_EQUIPMENT 
                (ID_ACC_PAYMENT_EQUIPMENT, 
                 ACC_PAYMENT_NUMBER, 
                 ACCOUNT_ID, 
                 DATE_ISSUING, 
                 ACC_PAYMENT_SUM, 
                 ACC_PAYMENT_CHECK) 
            VALUES 
                (S_NEW_ID_ACC_PAYMENT_EQUIPMENT.NEXTVAL, 
                 rcEquip.ACC_PAYMENT_NUMBER,
                 pBan,
                 rcEquip.DATE_ISSUING,
                 rcEquip.ACC_PAYMENT_SUM, 
                 0);--����������� ���� ���������� �� �����������
		    
			commit;
            counter:=counter+1;
            
            --���������� ������ �� ����, ��� ��������� ����� ����
            SEND_MAIL1('denis@k7.ru',
                                '����� ������ �� ������������',
                                '��������� ����� ���� ������ �� ������������: '||rcEquip.ACC_PAYMENT_NUMBER);
        end if;
        smsg:='OK';
        return(sMSG);
    exception
        when others then err:=err||' ParsErr^:nIndexField='||nIndexField||';sFld='||sFld||';sTMP='||sTMP||' Counter#'||counter;
    end;

begin
    counter:=0;
    --����� ��� ������� ����� ��� BAN �7
    plogin := 'C4457453';
    pPASSWORD := 'A4582633b';
    metod_id := 12; --��� - ����� �� ������������
    
    --��������� ����������
    err := RUBY_ROBOT_PCKG.create_conn(plogin, ppassword, metod_id, answer_mes);

    if err='OK' then
        RUBY_ROBOT_PCKG.create_rpt_log_tbl(metod_id, -1, answer_mes, 'ACC_PAY_4_EQUIP_FILE'); --� ACCOUNT_ID ���������� -1, �.�. ���� �������� �� ���� ������
    else --���� �� ������ ���������� ��������
        raise log_EXCEPTION;
    end if;

    --�������� �������� Loader
    NTitle := RUBY_ROBOT_PCKG.Get_Count_Loader;
    for i in 1..NTitle loop
        Tloader(i):= RUBY_ROBOT_PCKG.Get_Loader(i);   
    end loop i;

    --��������� , ���� ��������� �� ������ ��� ������� xml �� ��������
    if (instr(Tloader(1),'Error')>0) or (instr(Tloader(1),'<')>0) then
        err:=Tloader(1); 
        raise log_exception;
    end if;
    
    --��������� ������
    NTitle := 0;
    for i in Tloader.first..Tloader.last loop
        --���������� ������ � ������������� ����� � �����������
        if (instr(trim(Tloader(i)),'SheetName',1,1) <> 0) or (instr(trim(Tloader(i)),'�����',1,1) <> 0) then
            NTitle := i;
        end if; 
              
        if (i > NTitle+1) and (trim(Tloader(i)) is not null) then        
            if insertstr(Tloader(i)) is null then 
                raise log_EXCEPTION;
            end if; 
        end if;
    end loop;
 
    --�������� �������� ����������
    INSERT INTO ACCOUNT_LOAD_LOGS (ACCOUNT_LOAD_LOG_ID, LOAD_DATE_TIME,
        IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID)
    VALUES(S_NEW_ACCOUNT_LOAD_LOG_ID.NEXTVAL, SYSDATE,
                 1,'Ok! Add '||counter||' rows.', 12);
    commit;

EXCEPTION --�������� �������
    when others then  --log_EXCEPTION � ���������

    err:=err||' -- '||SQLERRM||'--������� ���������:'||nvl(counter,0);
                                        
    INSERT INTO ACCOUNT_LOAD_LOGS(ACCOUNT_LOAD_LOG_ID, LOAD_DATE_TIME,
        IS_SUCCESS, ERROR_TEXT, ACCOUNT_LOAD_TYPE_ID)
    VALUES(S_NEW_ACCOUNT_LOAD_LOG_ID.NEXTVAL, SYSDATE,
        0,'Update '||err, 12);
    commit;
END LOAD_ACC_PAYMENTS_4_EQUIPMENTS;
/

