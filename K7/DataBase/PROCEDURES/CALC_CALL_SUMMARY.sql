CREATE OR REPLACE PROCEDURE CORP_MOBILE.CALC_CALL_SUMMARY (
    pYEAR_MONTH NUMBER DEFAULT 0,  -- ������, �� �������� ����� ���������� ������ ����������, ���� NULL - �� ����� ������� (������� � 201308) 
    CALC_CUR_CALL NUMBER DEFAULT 0 -- ������������� ��� ��� ���������� �� ������������� �������� 
) IS 
-- ���������, ������� ������� ������� ���������� �� ������������ 
-- ��� ��� �����������, ������� ��� ��������� �� ������� ������� EXT_CALL_MM_YYYY ������ �� �������������
--
-- #Version=1  
  -- ������ �������, ��� ������� ����������� ��������� �� ������� �������� 
  cursor CUR_IN_CALL (pYEAR_MONTH NUMBER default null) is     
    select distinct HBM.YEAR_MONTH
      from HOT_BILLING_MONTH hbm               
     where HBM.DB = 1               -- ������� �� ��� ������, ������� ��� ��������� �� ������� ������� 
       and HBM.YEAR_MONTH >= 201308 -- ��� ��� �������� � EXT_CALL_MM_YYYY ����� �� �������������
       and (
            HBM.YEAR_MONTH = pYEAR_MONTH 
          or 
            nvl(pYEAR_MONTH, 0) = 0 
           )                 
    order by HBM.YEAR_MONTH
   ; 
  
  -- ������ �������, ��� ������� ����������� ��������� �� ������� �������� 
  cursor CUR_IN_EXT_TABLE (pYEAR_MONTH NUMBER default null) is     
    select distinct HBM.YEAR_MONTH
      from HOT_BILLING_MONTH hbm               
     where HBM.DB = 0               -- ������� �� ��� ������, ������� ��� ��������� �� ������� ������� 
       and HBM.YEAR_MONTH >= 201308 -- ��� ��� �������� � EXT_CALL_MM_YYYY ����� �� �������������
       and (
            HBM.YEAR_MONTH = pYEAR_MONTH 
          or 
            nvl(pYEAR_MONTH, 0) = 0 
           )                 
    order by HBM.YEAR_MONTH
   ; 

   
  PROCEDURE CLEAR_CALL_SUMMARY_MONTH (pYEAR_MONTH NUMBER) IS
  -- ��������� ������ ������ �� ��������� ����� ���� �� ������� � �� ��� �����, �� ���������
  BEGIN
    DELETE FROM CALL_SUMMARY CS
      WHERE (CS.YEAR_MONTH = pYEAR_MONTH OR NVL(pYEAR_MONTH, 0) = 0); 
  END;
       
begin
  for REC in CUR_IN_EXT_TABLE(pYEAR_MONTH) loop 
    -- �������� ������ �� ������� �� �����, ������� ����� �������������
    CLEAR_CALL_SUMMARY_MONTH(REC.YEAR_MONTH);    
    
    -- ������������ ���������� �� ������� �������(-��)
    EXECUTE IMMEDIATE 'INSERT INTO CALL_SUMMARY (SUBSCR_NO, ISROAMING, SERVICEDIRECTION, SERVICETYPE, CALL_COST, COUNT_CALL, AT_CHG_AMT, COST_CHNG, COSTNOVAT, DUR, YEAR_MONTH)
        SELECT C.SUBSCR_NO SUBSCR_NO,
               C.ISROAMING ISROAMING, 
               C.SERVICEDIRECTION SERVICEDIRECTION,
               C.SERVICETYPE SERVICETYPE,      
               sum(C.CALL_COST) CALL_COST, 
               COUNT(C.CALL_COST) COUNT_CALL,
               sum(to_number(replace(C.AT_CHG_AMT,'','',''.''))) AT_CHG_AMT,            
               sum(C.COST_CHNG) COST_CHNG,  
               sum(C.COSTNOVAT) COSTNOVAT,   
               sum(C.DUR) DUR, '||to_char(rec.YEAR_MONTH)||'
          FROM EXT_CALL_'|| to_char(to_date(rec.YEAR_MONTH,'YYYYMM'), 'mm_yyyy') ||' c
        group by C.SERVICEDIRECTION, C.ISROAMING, C.SERVICETYPE, C.SUBSCR_NO
        ';
    --DBMS_OUTPUT.PUT_LINE('������ ='||to_char(rec.YEAR_MONTH)||', �������� � '||to_char(sysdate, 'yyyy.mm.dd hh:mi:ss'));     
    INSERT INTO temp_log (msg) values ('������ ='||to_char(rec.YEAR_MONTH)||', �������� � '||to_char(sysdate, 'yyyy.mm.dd hh:mi:ss'));
    commit;
  end loop;
  
  IF (CALC_CUR_CALL <> 0) THEN 
    FOR REC IN CUR_IN_CALL(pYEAR_MONTH) LOOP
      -- �������� ������ �� ������� �� �����, ������� ����� �������������
      CLEAR_CALL_SUMMARY_MONTH(REC.YEAR_MONTH);
      
      --  ������������ ���������� �� ������������� �����������
      EXECUTE IMMEDIATE  'INSERT INTO CALL_SUMMARY (SUBSCR_NO, ISROAMING, SERVICEDIRECTION, SERVICETYPE, CALL_COST, COUNT_CALL, AT_CHG_AMT, COST_CHNG, COSTNOVAT, DUR, YEAR_MONTH)
        SELECT 
               C.SUBSCR_NO    SUBSCR_NO, 
               C.ISROAMING    ISROAMING, 
               C.SERVICEDIRECTION    SERVICEDIRECTION, 
               C.SERVICETYPE    SERVICETYPE, 
               SUM(C.CALL_COST)    CALL_COST, 
               COUNT(*)       COUNT_CALL, 
               sum(to_number(replace(C.AT_CHG_AMT,'','',''.''))) AT_CHG_AMT, 
               SUM(C.COST_CHNG)    COST_CHNG, 
               SUM(C.COSTNOVAT)    COSTNOVAT, 
               SUM(C.DUR)    DUR, '||to_char(rec.YEAR_MONTH)||'
          FROM CALL_'|| to_char(to_date(rec.YEAR_MONTH,'YYYYMM'), 'mm_yyyy') ||' c
        group by C.SERVICEDIRECTION, C.ISROAMING, C.SERVICETYPE, C.SUBSCR_NO
        ';
      --DBMS_OUTPUT.PUT_LINE('������ ='||to_char(rec.YEAR_MONTH)||', �������� � '||to_char(sysdate, 'yyyy.mm.dd hh:mi:ss'));     
      INSERT INTO temp_log ( msg) values ('������ ='||to_char(rec.YEAR_MONTH)||', �������� � '||to_char(sysdate, 'yyyy.mm.dd hh:mi:ss')||',');
      commit;
    END LOOP;
  END IF;
end;
/
