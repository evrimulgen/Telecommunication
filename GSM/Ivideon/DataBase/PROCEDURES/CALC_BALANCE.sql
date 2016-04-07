CREATE OR REPLACE PROCEDURE CALC_BALANCE (pAbonentId integer DEFAULT NULL) AS
--
--#Version=2
--
--v.2 ������� 29.01.2016 ����� ���� �������� ����.�����, �.�. �� ��������� Ivideon
--                      ������� ��������� �������� ������� � ������
--                     ��������� ���������� ������ �� ��������� � ������� � ���������
--                    ������� ��������� ������� �� ����������� ������
--v.1 ������� 05.10.2015 ��������� �������� �������
--
--
--�������� �������� �������
--1. �������� ������ ��������� �� IVIDEON_ABONENTS
--2. �������� ���� ��������� ������ � ABONENT_BALANCE_HISTORY �� ��������
--3. �������� ������� ������ ���������� ��������, ��������� �� � ������.
--4. ��������� ����.����� �� ������������ �������, ��� ������� ��� � ���� ������ �������� �� ���� � ��� ������� ��������������

  --������ �� ���������
  cursor ABONENTS is
    select
      ia.ABONENT_ID,
      nvl(AB.BALANCE, 0) BALANCE
    from
      IVIDEON_ABONENTS ia
      left join ABONENT_BALANCE ab
        on AB.ABONENT_ID = IA.ABONENT_ID
    where
      (IA.ABONENT_ID = pAbonentId
      or pAbonentId IS NULL) 
      ;    
    
  --������ �� ��������
  cursor cPAYMENT_HISTORY (
                            pABONENT_ID IVIDEON_ABONENTS.ABONENT_ID%TYPE, 
                            pMIN_PAYMENT_DATE  ABONENT_BALANCE_HISTORY.DATE_CREATED%TYPE
                          )  IS
    select
      PH.PAYMENT_SUM,
      PH.PAYMENT_DATE,
      1 service_type_id --������ ��������
   from
     PAYMENT_HISTORY ph
   where
     PH.ABONENT_ID = pABONENT_ID
     and
     DATE_CREATED > pMIN_PAYMENT_DATE;
     
  --������ �� ������� �������
  cursor cCurrentTariffs (
                          pABONENT_ID IVIDEON_ABONENTS.ABONENT_ID%TYPE,
                          pDate DATE
                          
                        ) IS
    select 
      CT.ABONENT_ID,
      CT.TARIFF_ID,
      T.MONTHLY_COST,
      2 SERVICE_TYPE_ID 

    from CURRENT_ABONENT_TARIFFS ct,
         tariffs t
    where 
      CT.ABONENT_ID = pABONENT_ID
      and CT.TARIFF_ID = T.TARIFF_ID
      --�������� ������ � ������� ���� �������� � ���� ����
      and
        (
         ( 
          trunc(CT.DATE_TARIFF_ON) - trunc(CT.DATE_TARIFF_ON, 'mm') + 1 =
          trunc(pDate) - trunc(pDate, 'mm') + 1
         )
         OR
        --���� �� � ������� ������ ���� ���� �������� � ���� ������, �� ��� ���� � �����
        --� �������� �� ����
         (
            trunc(CT.DATE_TARIFF_ON) - trunc(CT.DATE_TARIFF_ON, 'mm') + 1 <
            trunc(pDate) - trunc(pDate, 'mm') + 1
            --��������� �� �� ��� ����� ��� ����������� �������
            and exists (
                        select 1
                        from
                          ABONENT_BLOCK_UNLOCK_HISTORY au
                        where
                          au.ABONENT_ID = CT.ABONENT_ID and
                          au.ACTION_TYPE_ID = 1 --�������
                          
                          --��������� �� ��, ��� ������������� ���� �������
                          and trunc(AU.DATE_CREATED) = trunc(pDate)
                          
                        )
           
                              
        )
       )
      
      --�������� ������ �� ������� ��� ������� ������� ����.�����
      and not exists (
                       select 1
                       from
                         ABONENT_BALANCE_HISTORY ah
                       where
                         AH.ABONENT_ID = CT.ABONENT_ID
                         and AH.TARIFF_ID = CT.TARIFF_ID
                         and trunc(AH.HISTORY_DATE) = trunc(pDate) 
                         and AH.SERVICE_TYPE_ID = 2 --����.����� �� ����� 
                         
                      ); 
                           
                      
     
  
  vMAX_DATE_BALANCE_HISTORY ABONENT_BALANCE_HISTORY.DATE_CREATED%TYPE;--���� �� ��������� ��� ���� ����������
  vBalance  ABONENT_BALANCE.BALANCE%TYPE;
  
  TYPE T_HISTORY_DATE is table of ABONENT_BALANCE_HISTORY.HISTORY_DATE%TYPE INDEX BY BINARY_INTEGER;
  TYPE T_AMOUNT is table of ABONENT_BALANCE_HISTORY.AMOUNT%TYPE INDEX BY BINARY_INTEGER;
  TYPE T_BALANCE_AFTER is table of ABONENT_BALANCE_HISTORY.BALANCE_AFTER%TYPE INDEX BY BINARY_INTEGER;
  TYPE T_TARIFF_ID is table of ABONENT_BALANCE_HISTORY.TARIFF_ID%TYPE INDEX BY BINARY_INTEGER;
  TYPE T_SERVICE_TYPE_ID is table of ABONENT_BALANCE_HISTORY.SERVICE_TYPE_ID%TYPE INDEX BY BINARY_INTEGER;
  
  arrHISTORY_DATE T_HISTORY_DATE;
  arrAMOUNT T_AMOUNT;
  arrBALANCE_AFTER T_BALANCE_AFTER;
  arrTARIFF_ID T_TARIFF_ID;
  arrSERVICE_TYPE_ID T_SERVICE_TYPE_ID;
  
  vIDX INTEGER;
  vCURRENT_DATE DATE;--������� ����
  
  --��������� ������ �������� (�������/����������)
  --���� ������� ���������� 1, ����� 0
  function ABONENT_IS_ACTIVE (pABONENT_ID IVIDEON_ABONENTS.ABONENT_ID%TYPE)
    Return INTEGER IS
    v_res integer;
  begin
    select
      count(*)into v_res 
    from
      ABONENT_BLOCK_UNLOCK aa
    where
      AA.ABONENT_ID = pABONENT_ID
      and nvl(AA.ABONENT_IS_ACTIVE, 0) = 1; 
  
    if nvl(v_res, 1) >= 1 then
      v_res := 1;
    else
      v_res := 0;
    end if;
    
    Return v_res;
  end;

BEGIN
  
  vCURRENT_DATE := sysdate;
  
  for ABONENT_LIST in ABONENTS loop
    
    --�������� ������� ������ ��������
    /*
    select
      max(BALANCE) into vBalance
    from
      ABONENT_BALANCE ab
    where
      AB.ABONENT_ID = ABONENT_LIST.ABONENT_ID;
    vBalance := nvl(vBalance, 0);
     */  
    vBalance := nvl(ABONENT_LIST.BALANCE, 0);
    
    
    
    vIDX := 1;
    
    arrHISTORY_DATE.DELETE;
    arrAMOUNT.DELETE;
    arrBALANCE_AFTER.DELETE;
    arrTARIFF_ID.DELETE;
    arrSERVICE_TYPE_ID.DELETE;
    
     
    
    -- �������� ���� ��������� ������ � ABONENT_BALANCE_HISTORY �� ��������
    select
      max (DATE_CREATED) into vMAX_DATE_BALANCE_HISTORY
    from
      ABONENT_BALANCE_HISTORY ah
    where
      AH.ABONENT_ID = ABONENT_LIST.ABONENT_ID;
      
    vMAX_DATE_BALANCE_HISTORY := nvl(vMAX_DATE_BALANCE_HISTORY, to_date('01.01.1899', 'dd.mm.yyyy'));
    
    
    --�������� ���������� �������
    for cPAYMENTS in cPAYMENT_HISTORY (ABONENT_LIST.ABONENT_ID, vMAX_DATE_BALANCE_HISTORY) loop
    
      vBalance := vBalance + cPAYMENTS.PAYMENT_SUM;
      
      arrHISTORY_DATE(vIDX) := cPAYMENTS.PAYMENT_DATE;
      arrAMOUNT(vIDX) := cPAYMENTS.PAYMENT_SUM;
      arrBALANCE_AFTER(vIDX) := vBalance;
      arrTARIFF_ID(vIDX) := null;
      arrSERVICE_TYPE_ID(vIDX) := cPAYMENTS.SERVICE_TYPE_ID;
      
      vIDX := vIDX + 1; 
    end loop;--���� �� ��������
      
    --���� ������� ����� �����, �� ��� ���� �������������� � ������� ������!
    --��������� �������� �� ������ (���������� ��� ���)
   /* 
    if ABONENT_IS_ACTIVE(ABONENT_LIST.ABONENT_ID) = 1 then
      --��������� �� ���� ����������� �� �����, ���� ����� ������ ���������, �� ��������� ����.�����
      for cTariffs in  cCurrentTariffs (ABONENT_LIST.ABONENT_ID, vCURRENT_DATE) loop
        
        vBalance := vBalance - cTariffs.MONTHLY_COST;
        
        arrHISTORY_DATE(vIDX) := sysdate;
        arrAMOUNT(vIDX) := cTariffs.MONTHLY_COST;
        arrBALANCE_AFTER(vIDX) := vBalance;
        arrTARIFF_ID(vIDX) := cTariffs.TARIFF_ID;
        arrSERVICE_TYPE_ID(vIDX) := cTariffs.SERVICE_TYPE_ID;
        
        vIDX := vIDX + 1; 
      end loop;--���� cTariffs
    end if; --  if ABONENT_IS_ACTIVE(ABONENT_LIST.ABONENT_ID) = 1 then
    */
    
    if arrHISTORY_DATE.COUNT > 0 then
      FOR i IN arrHISTORY_DATE.FIRST..arrHISTORY_DATE.LAST loop
        ADD_ABONENT_BALANCE_HISTORY (
                                      ABONENT_LIST.ABONENT_ID,
                                      arrHISTORY_DATE(i),
                                      arrAMOUNT(i),
                                      arrBALANCE_AFTER(i),
                                      arrSERVICE_TYPE_ID(i),
                                      arrTARIFF_ID(i),
                                      null,
                                      null
                                    );
      end loop;
      
      MERGE INTO ABONENT_BALANCE ab
      using
        (SELECT BALANCE_AFTER,
                ABONENT_ID
          FROM ABONENT_BALANCE_HISTORY BH
          WHERE
            BH.ABONENT_ID  = ABONENT_LIST.ABONENT_ID
            AND BH.ABONENT_BALANCE_HISTORY_ID = (SELECT
                                                   MAX (ABONENT_BALANCE_HISTORY_ID)
                                                 FROM
                                                   ABONENT_BALANCE_HISTORY ABH
                                                 WHERE  
                                                   ABH.ABONENT_ID  = ABONENT_LIST.ABONENT_ID
                                                ) 
        
        )HIST
      ON
        (AB.ABONENT_ID  = HIST.ABONENT_ID)   
      WHEN MATCHED THEN
        UPDATE SET
          BALANCE = HIST.BALANCE_AFTER 
      
      WHEN NOT MATCHED THEN
        INSERT
          (ABONENT_ID, BALANCE)
        values
          (HIST.ABONENT_ID, HIST.BALANCE_AFTER )
      ;
      COMMIT;
    end if;
    
--    if ABONENT_LIST.ABONENT_ID = 24 then 
--      dbms_output.put_line('ABONENT_LIST.ABONENT_ID = '||ABONENT_LIST.ABONENT_ID||' vBalance = '||vBalance);
--    end if;
    
  
  end loop;--������ �� ��������� 

END;
