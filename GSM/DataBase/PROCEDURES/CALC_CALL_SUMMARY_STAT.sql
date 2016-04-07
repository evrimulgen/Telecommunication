CREATE OR REPLACE PROCEDURE CALC_CALL_SUMMARY_STAT (
    pYEAR_MONTH NUMBER DEFAULT 0,  -- ������, �� �������� ����� ���������� ������ ����������, ���� NULL - �� ����� ������� (������� � 201308) 
    CALC_CUR_CALL NUMBER DEFAULT 0 -- ������������� ��� ��� ���������� �� ������������� �������� 
) IS 
-- ���������, ������� ������� ������� ���������� �� ������������ 
-- ��� ��� �����������, ������� ��� ��������� �� ������� ������� EXT_CALL_MM_YYYY ������ �� �������������
--
-- #Version=4
-- v4. ������� - 15.12.2015. ���������� �������������� ������ ��� ��������� �������
-- v3. ������� - 02.12.2015. ���������� ��������� ���������� � ������� ����� ��������� �����, ���� �� ���, ���� � ���� ���������
--                           ����� ���������� ����������� AT_FT_DE �� ������ �������� �������                          
-- v2. ������� - 22.05.2015. ��� �������� ����� ��������� �� ������ � ������� ������� ���, ��� ������ 2 ������
--     sum( case 
--            when C.DUR >2 then trunc((C.DUR-1)/60)+1
--            else 0            
--          end
--        )                              
  
  -- ������ �������, ��� ������� ����������� ��������� �� ������� �������� 
  vTABLE_NAME VARCHAR2(20 CHAR);

  cursor CUR_IN_CALL (pYEAR_MONTH NUMBER default null) is     
    select distinct HBM.YEAR_MONTH
      from HOT_BILLING_MONTH hbm               
     where 
           --HBM.DB = 1               -- ������� �� ��� ������, ������� ��� ��������� �� ������� ������� 
       --and 
            HBM.YEAR_MONTH >= 201308 -- ��� ��� �������� � EXT_CALL_MM_YYYY ����� �� �������������
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
    DELETE FROM CALL_SUMMARY_STAT CS
      WHERE (CS.YEAR_MONTH = pYEAR_MONTH OR NVL(pYEAR_MONTH, 0) = 0); 
  END;
       
begin
/*
  FOR REC IN CUR_IN_EXT_TABLE(pYEAR_MONTH) LOOP 
    -- �������� ������ �� ������� �� �����, ������� ����� �������������
    CLEAR_CALL_SUMMARY_MONTH(REC.YEAR_MONTH);    
    
    -- ������������ ���������� �� ������� �������(-��)
      vTABLE_NAME := to_char(to_date(rec.YEAR_MONTH,'YYYYMM'), 'mm_yyyy');
      EXECUTE IMMEDIATE ' 
        INSERT INTO CALL_SUMMARY_STAT (CONTRACT_ID, PHONE_NUMBER_FEDERAL, YEAR_MONTH, DURATION_OUT_NO_PAID, DURATION_OUT_NO_PAID_ONLY_BEE, DURATION_IN_NO_PAID, DURATION_IN_NO_PAID_ONLY_BEE, DURATION_IN_YES_PAID, DURATION_IN_YES_PAID_ONLY_BEE, DURATION_OUT_YES_PAID, DURATION_OUT_YES_PAID_ONLY_BEE, INTERNET_TRAFFIC, SMS_OUT, MMS_OUT)           
            select 
                   V.CONTRACT_ID
                 , V.PHONE_NUMBER_FEDERAL
                 , '|| TO_CHAR(rec.YEAR_MONTH) ||'    
                 , (
                    select sum(C.DUR)/60
                      from EXT_CALL_' || vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) = 0  -- ��������� 
                       and C.SERVICEDIRECTION = 1 -- 1=���������, 2=��������
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_OUT_NO_PAID
                 , (
                    select sum(C.DUR)/60
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) = 0  -- ��������� 
                       and C.SERVICEDIRECTION = 1 -- 1=���������, 2=��������
                       AND C.AT_FT_DE LIKE ''%������%''
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_OUT_NO_PAID_ONLY_BEE
                 , (
                    select sum(C.DUR)/60
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) = 0  -- ��������� 
                       and C.SERVICEDIRECTION = 2 -- 1=���������, 2=��������
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_IN_NO_PAID
                 , (
                    select sum(C.DUR)/60
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) = 0  -- ��������� 
                       and C.SERVICEDIRECTION = 2 -- 1=���������, 2=��������
                       AND C.AT_FT_DE LIKE ''%������%''
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_IN_NO_PAID_ONLY_BEE
                 , (
                    select sum(C.DUR)/60
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) <> 0  -- ������ 
                       and C.SERVICEDIRECTION = 2 -- 1=���������, 2=��������
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_IN_YES_PAID 
                 , (
                    select sum(C.DUR)/60
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) <> 0  -- ������ 
                       and C.SERVICEDIRECTION = 2 -- 1=���������, 2=��������
                       AND C.AT_FT_DE LIKE ''%������%''
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_IN_YES_PAID_ONLY_BEE                     
                 , (
                    select sum(C.DUR)/60
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) <> 0  -- ������ 
                       and C.SERVICEDIRECTION = 1 -- 1=���������, 2=��������
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_OUT_YES_PAID        
                 , (
                    select sum(C.DUR)/60
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) <> 0  -- ������ 
                       and C.SERVICEDIRECTION = 1 -- 1=���������, 2=��������
                       AND C.AT_FT_DE LIKE ''%������%''
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_OUT_YES_PAID_ONLY_BEE
                 , (
                    select sum(C.DUR)
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''G''           
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) INTERNET_TRAFFIC  
                 , (
                    select count(C.DUR)
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''S''           
                       AND C.START_TIME >= V.CONTRACT_DATE
                       and C.SERVICEDIRECTION = 1                      
                   ) SMS_OUT
                 , (
                    select count(C.DUR)
                      from EXT_CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''U''           
                       AND C.START_TIME >= V.CONTRACT_DATE
                       and C.SERVICEDIRECTION = 1                      
                   ) MMS_OUT                        
              from v_contracts v
              where V.CONTRACT_DATE = 
                    (
                     select max(CN.CONTRACT_DATE)
                       from contracts cn
                      where CN.PHONE_NUMBER_FEDERAL = V.PHONE_NUMBER_FEDERAL
                      group by CN.PHONE_NUMBER_FEDERAL
                    )                        
        '; 
    COMMIT;
  END LOOP;
*/  
  IF (CALC_CUR_CALL <> 0) THEN 
    FOR REC IN CUR_IN_CALL(pYEAR_MONTH) LOOP
      -- �������� ������ �� ������� �� �����, ������� ����� �������������
      CLEAR_CALL_SUMMARY_MONTH(REC.YEAR_MONTH);
      
      --  ������������ ���������� �� ������������� �����������
      /*
      EXECUTE IMMEDIATE  'INSERT INTO CALL_SUMMARY (SUBSCR_NO, ISROAMING, SERVICEDIRECTION, SERVICETYPE, CALL_COST, COUNT_CALL, IS_BEELINE, IS_PAID, AT_CHG_AMT, COST_CHNG, COSTNOVAT, DUR, YEAR_MONTH)
        SELECT 
               C.SUBSCR_NO    SUBSCR_NO, 
               C.ISROAMING    ISROAMING, 
               C.SERVICEDIRECTION    SERVICEDIRECTION, 
               C.SERVICETYPE    SERVICETYPE, 
               SUM(C.CALL_COST)    CALL_COST, 
               COUNT(*)       COUNT_CALL, 
               (case when C.AT_FT_DE like ''%������%'' then 1 else 0 end) IS_BEELINE,
               (case when nvl(C.COSTNOVAT,0) = 0 then 0 else 1 end) IS_PAID,
               sum(to_number(replace(C.AT_CHG_AMT,'','',''.''))) AT_CHG_AMT, 
               SUM(C.COST_CHNG)    COST_CHNG, 
               SUM(C.COSTNOVAT)    COSTNOVAT, 
               SUM(C.DUR)    DUR, '||to_char(rec.YEAR_MONTH)||'
          FROM CALL_'|| to_char(to_date(rec.YEAR_MONTH,'YYYYMM'), 'mm_yyyy') ||' c
        group by C.SERVICEDIRECTION, C.ISROAMING, C.SERVICETYPE, C.SUBSCR_NO, (case when C.AT_FT_DE like ''%������%'' then 1 else 0 end), (case when nvl(C.COSTNOVAT,0) = 0 then 0 else 1 end) 
        ';
     */
      vTABLE_NAME := to_char(to_date(rec.YEAR_MONTH,'YYYYMM'), 'mm_yyyy');
      EXECUTE IMMEDIATE ' 
        INSERT INTO CALL_SUMMARY_STAT (CONTRACT_ID, PHONE_NUMBER_FEDERAL, YEAR_MONTH, DURATION_OUT_NO_PAID, DURATION_OUT_NO_PAID_ONLY_BEE, DURATION_IN_NO_PAID, DURATION_IN_NO_PAID_ONLY_BEE, DURATION_IN_YES_PAID, DURATION_IN_YES_PAID_ONLY_BEE, DURATION_OUT_YES_PAID, DURATION_OUT_YES_PAID_ONLY_BEE, INTERNET_TRAFFIC, SMS_OUT, MMS_OUT)           
            select 
                   V.CONTRACT_ID
                 , V.PHONE_NUMBER_FEDERAL
                 , '|| TO_CHAR(rec.YEAR_MONTH) ||'    
                 , (
                    select sum( case 
                                  when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                  else 0            
                                end
                              )
                      from CALL_' || vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) = 0  -- ��������� 
                       and C.SERVICEDIRECTION = 1 -- 1=���������, 2=��������
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_OUT_NO_PAID
                 , (
                    select sum( case 
                                  when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                  else 0            
                                end
                              )
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) = 0  -- ��������� 
                       and C.SERVICEDIRECTION = 1 -- 1=���������, 2=��������
                       AND upper(C.AT_FT_DE) LIKE ''%������%''
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_OUT_NO_PAID_ONLY_BEE
                 , (
                    select sum( case 
                                  when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                  else 0            
                                end
                              )
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) = 0  -- ��������� 
                       and C.SERVICEDIRECTION = 2 -- 1=���������, 2=��������
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_IN_NO_PAID
                 , (
                    select sum( case 
                                  when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                  else 0            
                                end
                              )
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) = 0  -- ��������� 
                       and C.SERVICEDIRECTION = 2 -- 1=���������, 2=��������
                       AND upper(C.AT_FT_DE) LIKE ''%������%''
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_IN_NO_PAID_ONLY_BEE
                 , (
                    select sum( case 
                                  when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                  else 0            
                                end
                              )
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) <> 0  -- ������ 
                       and C.SERVICEDIRECTION = 2 -- 1=���������, 2=��������
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_IN_YES_PAID 
                 , (
                    select sum( case 
                                  when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                  else 0            
                                end
                              )
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) <> 0  -- ������ 
                       and C.SERVICEDIRECTION = 2 -- 1=���������, 2=��������
                       AND upper(C.AT_FT_DE) LIKE ''%������%''
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_IN_YES_PAID_ONLY_BEE                     
                 , (
                    select sum( case 
                                  when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                  else 0            
                                end
                              )
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) <> 0  -- ������ 
                       and C.SERVICEDIRECTION = 1 -- 1=���������, 2=��������
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_OUT_YES_PAID        
                 , (
                    select sum( case 
                                  when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                  else 0            
                                end
                              )
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''C''
                       and nvl(C.COSTNOVAT, 0) <> 0  -- ������ 
                       and C.SERVICEDIRECTION = 1 -- 1=���������, 2=��������
                       AND upper(C.AT_FT_DE) LIKE ''%������%''
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) DURATION_OUT_YES_PAID_ONLY_BEE
                 , (
                    select sum(nvl(C.DUR, 0))
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''G''           
                       AND C.START_TIME >= V.CONTRACT_DATE
                   ) INTERNET_TRAFFIC  
                 , (
                    select count(C.DUR)
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''S''           
                       AND C.START_TIME >= V.CONTRACT_DATE
                       and C.SERVICEDIRECTION = 1                      
                   ) SMS_OUT
                 , (
                    select count(C.DUR)
                      from CALL_'|| vTABLE_NAME || ' c
                     where C.SUBSCR_NO = V.PHONE_NUMBER_FEDERAL
                       and C.SERVICETYPE = ''U''           
                       AND C.START_TIME >= V.CONTRACT_DATE
                       and C.SERVICEDIRECTION = 1                      
                   ) MMS_OUT                        
              from 
                   (
                    select V2.CONTRACT_ID
                          ,V2.PHONE_NUMBER_FEDERAL
                          ,NVL(CC.CONTRACT_CHANGE_DATE, V2.CONTRACT_DATE) CONTRACT_DATE' -- ���������� ���������� ��������� � ������� ����� ��������� ����� 
                   ||'
                      from v_contracts v2
                          ,V_CONTRACT_CHANGES cc
                     where V2.CONTRACT_DATE = 
                           (
                            select max(CN.CONTRACT_DATE)
                              from contracts cn
                             where CN.PHONE_NUMBER_FEDERAL = V2.PHONE_NUMBER_FEDERAL
                             group by CN.PHONE_NUMBER_FEDERAL
                           )                    
                       and V2.CONTRACT_ID = cc.CONTRACT_ID (+)
                   )  V
        '; 
      commit;
    END LOOP;
  END IF;
end;
/
