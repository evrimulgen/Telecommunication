CREATE OR REPLACE function GET_PHONE_INACTIVE_TAB(
    pBeginDate IN DATE, 
    pEndDate IN DATE
    ) return TAB_PHONE_INACTIV PIPELINED AS
--version 2	
--v2 ��������. �������� ������� �� ������� ������� � ���������� ��.
--version 1. ��������. ������� �������	
    SQLTxt  varchar2(4000); 
    subquery varchar2(2000);
    subqueryTraf varchar2(2000);
    v_tab_cursor SYS_REFCURSOR;
    i integer;
    d integer;
    m integer;
    y integer;
    Now_m integer;
    Now_y integer;
    mm integer;
    yyyy integer;
    vDate date;
    TabCount integer;
    CALL_ROW TYPE_PHONE_INACTIV;
    pLogin varchar2(30); 
    pPhone_number_federal varchar2(10);
    pContract_date date; 
    pBalance number;
    pPHONE_IS_ACTIVE varchar2(25); 
    pDop_status_name varchar2(100);
    pLAST_CHECK_DATE_TIME date;
    pDATE_CREATED date;
    pCURR_TARIFF_ID integer;
    pTARIFF_NAME varchar2(100);
    nameTab varchar2(20);
BEGIN
    vDate := add_months(sysdate, -2); 
    y := to_number(to_char(vDate, 'YYYY'));
    m := to_number(to_char(vDate, 'MM'));    
    
    if (pBeginDate <= pEndDate) AND (pbegindate <= sysdate)  AND (pbegindate >= to_date('01.'||m||'.'||y, 'DD.MM.YYYY')) then
    SQLTxt := '';
    subquery := '';
    subqueryTraf := '';
    y := 0; 
    m := 0;
    
    --���������� ������� ��������� ����
    y := to_number(to_char(pBeginDate, 'YYYY'));
    m := to_number(to_char(pBeginDate, 'MM'));
    
    Now_y := to_number(to_char(sysdate, 'YYYY'));
    Now_m := to_number(to_char(sysdate, 'MM'));
    
    i:=0;
    vDate := add_months(to_date('01.'||m||'.'||y, 'DD.MM.YYYY'), i); 
    yyyy := to_number(to_char(vDate, 'YYYY'));
    mm := to_number(to_char(vDate, 'MM'));
    d := to_number(to_char(vDate, 'DD')); 
    
    while ((mm <= Now_m) and (yyyy = Now_y)) or (yyyy < Now_y) loop
        nameTab := '';
        if length(mm) = 1 then
            nameTab :=  'CALL_0'||to_char(mm)||'_'||to_char(yyyy);
        else
            nameTab :=  'CALL_'||to_char(mm)||'_'||to_char(yyyy);
        end if;
        
        --��������� ������������� �������
        TabCount := 0;
        SELECT count(*) 
        INTO TabCount
        FROM all_tables WHERE table_name = nametab;
        
        if TabCount > 0 then
            if m < mm then
                subquery := subquery||' union all ';
                subqueryTraf := subqueryTraf||' + '; 
            end if;
            
            subquery := subquery||
              'select * from '||nametab||' cl '||
              'where cl.servicetype IN (''C'',''S'') '||
              'AND NOT (cl.servicetype = ''C'' AND cl.servicedirection = 1 AND cl.dialed_dig IN (''0611'',''0628'',''0528'')) '||
              'AND NOT (cl.servicetype =''S'' AND cl.servicedirection = 2 AND cl.calling_no = ''9037030606'') ';
            subqueryTraf := subqueryTraf||
              '(select count(*) from '||nametab||' cltr '||
              ' where CLtr.SUBSCR_NO=V.PHONE_NUMBER_FEDERAL '||
              ' AND cltr.servicetype = ''G'' ';
        
           --������� �� ���� ����� (insert_date) ������������� ������ �� ������� � ������� ��������� ����
            if m = mm then
                subquery := subquery||' AND cl.insert_date > to_date('''||to_char(pBeginDate, 'DD.MM.YYYY')||''', ''DD.MM.YYYY'')';
                subqueryTraf := ' AND (0 = '||subqueryTraf||' AND cltr.insert_date > to_date('''||to_char(pBeginDate, 'DD.MM.YYYY')||''', ''DD.MM.YYYY''))';
            else
                subqueryTraf := subqueryTraf||')';
            end if; 
        end if;
        
        i := i + 1;
        vDate := add_months(to_date('01.'||m||'.'||y, 'DD.MM.YYYY'), i); 
        yyyy := to_number(to_char(vDate, 'YYYY'));
        mm := to_number(to_char(vDate, 'MM'));
        d := to_number(to_char(vDate, 'DD')); 
    end loop;
    subqueryTraf := subqueryTraf||')';

    SQLTxt := ' SELECT login, phone_number_federal, contract_date, balance, PHONE_IS_ACTIVE, '||
        ' Dop_status_name, LAST_CHECK_DATE_TIME, DATE_CREATED, CURR_TARIFF_ID, TARIFF_NAME '||
        ' FROM '||
        ' (SELECT V.login, V.phone_number_federal, V.contract_date, V.balance, V.PHONE_IS_ACTIVE, '||
        ' V.Dop_status_name, V.LAST_CHECK_DATE_TIME, V.DATE_CREATED, V.CURR_TARIFF_ID, V.TARIFF_NAME, V.TRAFFIC_NOT_IGNOR_FOR_INACTIVE, '||
        ' (select count(DISTINCT calling_no) '||        
        ' from '||                
        ' (select vcl.SUBSCR_NO, vcl.servicedirection, vcl.calling_no, vcl.servicetype, count(*) cnt '||            
        ' from '||       
        ' (select vcl1.SUBSCR_NO, vcl1.servicetype, vcl1.servicedirection, '||
        ' NVL((case '||
        ' when vcl1.servicedirection = 1 then '||
        ' case '|| 
        '  when (LENGTH(vcl1.dialed_dig) = 11) and ((SUBSTR(vcl1.dialed_dig, 1, 1) = ''7'') or (SUBSTR(vcl1.dialed_dig, 1, 1) = ''8'')) then SUBSTR(vcl1.dialed_dig, 2) '|| 
        '  else vcl1.dialed_dig '||
        ' end ' ||
        'else '||
        ' case '|| 
        ' when (LENGTH(vcl1.calling_no) = 11) and ((SUBSTR(vcl1.calling_no, 1, 1) = ''7'') or (SUBSTR(vcl1.calling_no, 1, 1) = ''8'')) then SUBSTR(vcl1.calling_no, 2) '||
        ' else vcl1.calling_no end '||
        ' end), ''1111111111'') calling_no '||
        ' from '||      
        ' ('||subquery||') vcl1) vcl '||            
        ' group by vcl.servicedirection, vcl.calling_no, vcl.servicetype, vcl.SUBSCR_NO) '||           
        ' where SUBSCR_NO = V.phone_number_federal) CountPhone, '||
        ' (select max(cnt) MaxCall '||        
        ' from '||          
        ' (select vcl.SUBSCR_NO, vcl.servicedirection, vcl.calling_no, vcl.servicetype, count(*) cnt '||   
        ' from '||       
        ' (select vcl1.SUBSCR_NO, vcl1.servicetype, vcl1.servicedirection, '||
        ' NVL((case '||
        ' when vcl1.servicedirection = 1 then '||
        ' case '|| 
        '  when (LENGTH(vcl1.dialed_dig) = 11) and ((SUBSTR(vcl1.dialed_dig, 1, 1) = ''7'') or (SUBSTR(vcl1.dialed_dig, 1, 1) = ''8'')) then SUBSTR(vcl1.dialed_dig, 2) '|| 
        '  else vcl1.dialed_dig '||
        ' end ' ||
        'else '||
        ' case '|| 
        ' when (LENGTH(vcl1.calling_no) = 11) and ((SUBSTR(vcl1.calling_no, 1, 1) = ''7'') or (SUBSTR(vcl1.calling_no, 1, 1) = ''8'')) then SUBSTR(vcl1.calling_no, 2) '||
        ' else vcl1.calling_no end '||
        ' end), ''1111111111'') calling_no '||
        ' from '||      
        ' ('||subquery||') vcl1) vcl '||              
        ' group by vcl.servicedirection, vcl.calling_no, vcl.servicetype, vcl.SUBSCR_NO) '||           
        ' where SUBSCR_NO = V.phone_number_federal) MaxCall '||
        ' FROM V_PHONE_INACTIVE V '||
        ' WHERE V.DATE_CREATED BETWEEN to_date('''||to_char(pBeginDate, 'DD.MM.YYYY')||''',''DD.MM.YYYY'') AND to_date('''||to_char(pEndDate, 'DD.MM.YYYY')||''', ''DD.MM.YYYY'')) '|| 
        ' WHERE (((NVL(TRAFFIC_NOT_IGNOR_FOR_INACTIVE,0) <> 1) AND ((NVL(CountPhone, 0) < 2) AND (NVL(maxCall, 0) <= 3))) OR '||
        ' ((TRAFFIC_NOT_IGNOR_FOR_INACTIVE = 1) '||subqueryTraf||'))';
     
    OPEN  v_tab_cursor  FOR  SQLTxt;
    LOOP
        FETCH v_tab_cursor 
          INTO pLogin, 
                  pPhone_number_federal, 
                  pContract_date, 
                  pBalance, 
                  pPHONE_IS_ACTIVE, 
                  pDop_status_name,
                  pLAST_CHECK_DATE_TIME,
                  pDATE_CREATED,
                  pCURR_TARIFF_ID,
                  pTARIFF_NAME;
        EXIT WHEN v_tab_cursor%NOTFOUND;
        
        CALL_ROW := TYPE_PHONE_INACTIV(pLogin,
                                                               pPhone_number_federal, 
                                                               pContract_date, 
                                                               pBalance,
                                                               pPHONE_IS_ACTIVE, 
                                                               pDop_status_name,
                                                               pLAST_CHECK_DATE_TIME,
                                                               pDATE_CREATED,
                                                               pCURR_TARIFF_ID,
                                                               pTARIFF_NAME);
                         
        PIPE ROW(CALL_ROW);
    END LOOP;

    -- Close cursor
    CLOSE v_tab_cursor;  
    end if;
END;
/
