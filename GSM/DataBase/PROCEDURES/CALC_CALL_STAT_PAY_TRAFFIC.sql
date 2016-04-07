CREATE OR REPLACE PROCEDURE CALC_CALL_STAT_PAY_TRAFFIC (
    pYEAR_MONTH NUMBER DEFAULT 0,  -- ������, �� �������� ����� ���������� ������ ����������, ���� NULL - �� ����� ������� (������� � 201308) 
    CALC_CUR_CALL NUMBER DEFAULT 0 -- ������������� ��� ��� ���������� �� ������������� �������� 
) IS 
-- ���������, ������� ������� ������� ���������� �� �������� ������� �� ����������� 
--
-- #Version=1
-- v1. ������� - 16.12.2015. �������� ���������
  
  -- ������ �������, ��� ������� ����������� ��������� �� ������� �������� 
  vTABLE_NAME VARCHAR2(20 CHAR);
   
  PROCEDURE CLEAR_CALL_SUMMARY_MONTH (pYEAR_MONTH NUMBER) IS
  -- ��������� ������ ������ �� ��������� ����� 
  BEGIN
    DELETE FROM CALL_STAT_PAY_TRAFFIC CS
      WHERE (CS.YEAR_MONTH = pYEAR_MONTH 
            --  OR NVL(pYEAR_MONTH, 0) = 0
            ); 
  END;
       
begin

  IF (CALC_CUR_CALL <> 0) THEN 
      -- �������� ������ �� ������� �� �����, ������� ����� �������������
      CLEAR_CALL_SUMMARY_MONTH(pYEAR_MONTH);
      
      vTABLE_NAME := to_char(to_date(pYEAR_MONTH,'YYYYMM'), 'mm_yyyy');
      EXECUTE IMMEDIATE ' 
         insert into CALL_STAT_PAY_TRAFFIC (PHONE_NUMBER_FEDERAL, YEAR_MONTH, OTHER_CITY_COST, OTHER_CITY_DURATION_MINUTE, OTHER_COUNTRY_COST, OTHER_COUNTRY_DURATION_MINUTE, LOCAL_COST, LOCAL_DURATION_MINUTE, ROUMING_COST, ROUMING_DURATION_MINUTE, MESSAGES_COST, MESSAGES_COUNT)  
            select nvl(PHONE_NUMBER_FEDERAL, 0) PHONE_NUMBER_FEDERAL, 
                   nvl(YEAR_MONTH, 0) YEAR_MONTH, 
                   nvl(OTHER_CITY_COST, 0) OTHER_CITY_COST, 
                   nvl(OTHER_CITY_DURATION_MINUTE, 0) OTHER_CITY_DURATION_MINUTE, 
                   nvl(OTHER_COUNTRY_COST, 0) OTHER_COUNTRY_COST, 
                   nvl(OTHER_COUNTRY_DURATION_MINUTE, 0) OTHER_COUNTRY_DURATION_MINUTE, 
                   nvl(LOCAL_COST, 0) LOCAL_COST, 
                   nvl(LOCAL_DURATION_MINUTE, 0) LOCAL_DURATION_MINUTE, 
                   nvl(ROUMING_COST, 0) ROUMING_COST, 
                   nvl(ROUMING_DURATION_MINUTE, 0) ROUMING_DURATION_MINUTE, 
                   nvl(MESSAGES_COST, 0) MESSAGES_COST, 
                   nvl(MESSAGES_COUNT, 0) MESSAGES_COUNT 
            from
              (
                select  tp.PHONE_NUMBER_FEDERAL
                       ,'||to_char(pYEAR_MONTH)||'  YEAR_MONTH 
                       '-- ������������� ������
                     ||',(select  sum(nvl(C.CALL_COST, 0))                                 
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''������������� ������''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) OTHER_CITY_COST
                       ,(select  sum( case 
                                          when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                          else 0            
                                       end
                                     )                  
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''������������� ������''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) OTHER_CITY_DURATION_MINUTE        
                       -- ������������� ������
                       ,(select  sum(nvl(C.CALL_COST, 0))                                 
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''������������� ������''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) OTHER_COUNTRY_COST
                       ,(select  sum( case 
                                          when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                          else 0            
                                       end
                                     )                  
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''������������� ������''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) OTHER_COUNTRY_DURATION_MINUTE      
                       -- ������� ������
                       ,(select  sum(nvl(C.CALL_COST, 0))                                 
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''������� ������''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) LOCAL_COST
                       ,(select  sum( case 
                                          when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                          else 0            
                                       end
                                     )                  
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''������� ������''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) LOCAL_DURATION_MINUTE
                        -- ������ � ��������
                       ,(select  sum(nvl(C.CALL_COST, 0))                                 
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''������ � ��������''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) ROUMING_COST
                       ,(select  sum( case 
                                          when C.DUR >2 then trunc((C.DUR-1)/60)+1
                                          else 0            
                                       end
                                    )                  
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''������ � ��������''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) ROUMING_DURATION_MINUTE   
                       --   SMS/MMS
                       ,(select  sum(nvl(C.CALL_COST, 0))                                 
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''SMS/MMS''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) MESSAGES_COST
                       ,(select COUNT(C.CALL_COST)              
                          from call_'||vTABLE_NAME||' c
                              ,SERVICES_BEELINE sb
                          where C.SUBSCR_NO = tp.PHONE_NUMBER_FEDERAL
                            and C.AT_FT_CODE = SB.AT_FT_CODE (+)
                            and C.CALL_COST > 0
                            and SB.TYPE_CALL = ''SMS/MMS''       
                          group by C.SUBSCR_NO, SB.TYPE_CALL
                        ) MESSAGES_COUNT
                from
                     (
                      select distinct C.SUBSCR_NO PHONE_NUMBER_FEDERAL 
                        from 
                             call_'||vTABLE_NAME||' c
                       where C.CALL_COST > 0
                     ) tp                   
              )
        '; 
      commit;
  END IF;
end;
/
