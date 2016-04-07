CREATE OR REPLACE PROCEDURE P_USSD_CHANGE_PP_QUEUE
is
  --
  --Version=11
  --
  --v.11 23.09.2015 ������� ��� ������������� �������� ������ �� email,����������� ������ ��� ������ � ������� �� ��������
  --                        ���� ������ ���������� ������ J_USSD_CHANGE_PP_SEND_MAIL
  --                        ��������� ���� ������
  --                       ������ �������� �� ������������� ������ ����� ��� �������� �� email
  --v.10 21.09.2015 ������� ������ ������, � ��� ��� ������� ���.�������� �� ��������� ������.
  --v.9 17.09.2015 ������� ������� �������� ��� ��������� ��� �������� ������
  --                         ������: ���� ���� �������� = ���� �������� ��������, �� ����� �������� ����� ����� ��������.
  --                                ��� ��������� ��������� � ������������ � ���� ����
  --v.8 10.09.2015 ������� ������� �������� �� ������������� ���������
  --v.7 10.09.2015 ������� ��������� ��������� �������� � ����� �� � ������� ������
  --v.6 08.09.2015 ������� ������� �������� ������ �� email ���� �� �������� ������ ����.����� �������
  --v.5 18.08.2015 ������� �������� ����� ������������� ���
  --v.4 12.08.2015 ������� ������� �������� �� ������� ��������� �� ������
  --v.3 20.07.2015 ������� ��������� ������� ����������� �������� �� ����� � ������ �������
  --v.2 13.07.2015 ������� ������� �������� �� ������
  --v.1 09.07.2015 ������� ������� ��������� ��� ��������� ������ �� ����� ������ �� USSD

  cOK_ANSWER CONSTANT VARCHAR2(3 CHAR) := '��!'; --������������� ����� ��� ���������� ������ �� ����� ��
  cFUTURE_DATE CONSTANT CHAR(1 char) := 'N'; --������� ����� ��������� ����� N - ������� ��, Y - � ��������� �������
  cUSSD_NEW_STATUS_ID USSD_CHANGE_CONTRACT_STATUS.USSD_CHANGE_CONTRACT_STATUS_ID%TYPE := null;
  cUSSD_FINAL_STATUS_ID USSD_CHANGE_CONTRACT_STATUS.USSD_CHANGE_CONTRACT_STATUS_ID%TYPE := 3;
  cUSSD_CONTRACT_CHANG_STATUS_ID USSD_CHANGE_CONTRACT_STATUS.USSD_CHANGE_CONTRACT_STATUS_ID%TYPE := 2;
  cUSSD_SEND_MAIL_STATUS_ID USSD_CHANGE_CONTRACT_STATUS.USSD_CHANGE_CONTRACT_STATUS_ID%TYPE := 4;
  cERROR_CHANGE_SMS CONSTANT VARCHAR2(123 CHAR) :=  '� ��������� ����� ��������� ����� �� USSD ����������, ��� ����� ��������� ����� ���������� � ������ ��������� �� ���. 0577.';
  vSmsText  varchar2(200 char);
  vTariffCode TARIFFS.TARIFF_CODE%TYPE;
  vTariffID TARIFFS.TARIFF_ID%TYPE;
  vCurrentTariffID TARIFFS.TARIFF_ID%TYPE;
  vERROR_MESSAGE varchar2(100 char);
  vTicketID BEELINE_TICKETS.TICKET_ID%TYPE;
  vTempStr varchar2(50 char);
  vMonthlyPayment TARIFFS.MONTHLY_PAYMENT%TYPE;
  vCurrentMonthlyPayment TARIFFS.MONTHLY_PAYMENT%TYPE;
  vAbonentBalance Integer;
  vUSSD_STATUS_ID  USSD_CHANGE_PP_LOG.USSD_CHANGE_CONTRACT_STATUS_ID%TYPE;
  vDETAILED_TARIFF_NAME varchar2(500 char);
  
--�������� �� ������������ 
  function IS_DUBLE_TIKET (pPhoneNumber in USSD_CHANGE_PP_LOG.PHONE_NUMBER%TYPE )
    Return INTEGER As
    vRes Integer;
  begin
    
    select 
      count(*) into vRes 
    from
      USSD_CHANGE_PP_LOG pp
    where
      PP.PHONE_NUMBER = pPhoneNumber
      and PP.YEAR_MONTH = to_number(to_char(sysdate, 'yyyymm'))
      and PP.DATE_INSERTED >= sysdate - 1 --��������� ������ �� ���������� �����
      --�������� ������ ������ ����������� ������ �� ��������� �������� �� Email
      and PP.USSD_CHANGE_CONTRACT_STATUS_ID in (cUSSD_SEND_MAIL_STATUS_ID, cUSSD_CONTRACT_CHANG_STATUS_ID)
      --��������� �� ���� �������� ��������
       --��������� �� ���� �������� ��������
      and PP.DATE_INSERTED >= (
                               select
                                 max(
                                     case
                                      when trunc(contract_date) = trunc(DATE_CREATED) then
                                        DATE_CREATED
                                     else
                                      contract_date       
                                     end
                                    ) 
                                  contract_date
                               from
                                 v_contracts v
                               where
                                 V.CONTRACT_CANCEL_DATE is null
                                 and V.PHONE_NUMBER_FEDERAL = PP.PHONE_NUMBER
                        );
      
   
    IF NVL (vRes, 0) > 0 then
      vRes := 1;
    ELSE
      vRes := 0;
    END IF;
        
     
    Return vRes;  
      
  end;
--��������� ���������� �������� ������ �� ������� ���� �������  
  function GET_DETAILED_TARIFF_NAME (
                                     pCurrentTariffID TARIFFS.TARIFF_ID%TYPE,
                                     pNewTariffID TARIFFS.TARIFF_ID%TYPE
                                    )
    RETURN varchar2  IS
    
    vRes varchar2(500 char);

    vCt integer;
  begin
    vRes := '';
    
    --��������� �� ������������ �����
    select
      count(*) into vCt 
    from
      Tariffs t
    where
      t.tariff_id = pNewTariffID
      and nvl(t.SPECIAL_BAN_ID, 1) = (
                                      select
                                        nvl(SPECIAL_BAN_ID, 1)
                                      from
                                        Tariffs tt
                                      where
                                        tt.tariff_id = pCurrentTariffID
                                        and rownum <= 1
                                    );
    if nvl(vCt, 0) = 0 then
      
      begin
        select
          DETAILED_TARIFF_NAME into vRes 
       from
         Tariffs t
       where
         t.tariff_id = pNewTariffID;
      exception
        when OTHERS then
          vRes := SQLERRM;  
      end;
         
    end if;                              
       
    Return vRes;   
  end;   
  
--�������� �� ����������� �������� �� �����, ������� ������ �� USSD
  function GET_CHANGE_FROM_TARIFF(pCurrentTariffID TARIFFS.TARIFF_ID%TYPE) RETURN INTEGER IS
    vCT INTEGER;
    vRes Integer;
  begin
    
    select count(*) into vCT
      from tariffs
    where
      tariff_id = pCurrentTariffID
      and nvl(CHANGE_FROM_TARIFF, 0) = 1;
    
    if nvl(vCT, 0) > 0  then
      vRes := 1; --��������� ������� 
    else
      vRes := 0; -- ��������� �������
    end if;
    
    RETURN vRes;  
    
  end;
  
-- ��������� ���� ����� �� ������ �� ���� ���� ������
  function GET_DAYLY_PAYMENT (pMONTHLY_PAYMENT TARIFFS.MONTHLY_PAYMENT%TYPE) RETURN TARIFFS.MONTHLY_PAYMENT%TYPE IS
    vDAY_IN_MONTH INTEGER;
    vRes TARIFFS.MONTHLY_PAYMENT%TYPE;
  BEGIN
    vDAY_IN_MONTH := to_number(to_char(last_day(sysdate), 'dd'));  
   
    vRes := NVL(round(NVL(pMONTHLY_PAYMENT, 0) / vDAY_IN_MONTH, 2), 0);
   
    RETURN vRes;
  END; 
  
-- ��������� ����������� ����� �� ������ ������
  function GET_MONTHLY_PAYMENT (pTARIFF_ID TARIFFS.TARIFF_ID%TYPE) RETURN TARIFFS.MONTHLY_PAYMENT%TYPE IS
    vRes TARIFFS.MONTHLY_PAYMENT%TYPE;
    vDISCR_SPISANIE   TARIFFS.DISCR_SPISANIE%TYPE;
    vSDVIG_DISCR_SPISANIE   TARIFFS.SDVIG_DISCR_SPISANIE%TYPE;
  begin
    select
      MONTHLY_PAYMENT, nvl(DISCR_SPISANIE, 0), nvl(SDVIG_DISCR_SPISANIE, 0)
    INTO vRes, vDISCR_SPISANIE, vSDVIG_DISCR_SPISANIE 
      from tariffs
    where
      tariff_id = pTARIFF_ID;
    
    if vDISCR_SPISANIE = 1  then
      --���� ������ ���, �� ��������� ������ ���������, ���� ����� ���� �� ��������� �� ���� ����
      if vSDVIG_DISCR_SPISANIE <> 0 then
        vRes := GET_DAYLY_PAYMENT(vRes); 
      END IF;
    else
      vRes := GET_DAYLY_PAYMENT(vRes);  
    end if; 
    
    RETURN vRes;   
  END;
  
  -- ��������� ����������� ����� �� �������� ������
  function GET_CURRENT_MONTHLY_PAYMENT (pTARIFF_ID TARIFFS.TARIFF_ID%TYPE, pPHONE_NUMBER DB_LOADER_ABONENT_PERIODS.PHONE_NUMBER%TYPE) RETURN TARIFFS.MONTHLY_PAYMENT%TYPE IS
    vRes TARIFFS.MONTHLY_PAYMENT%TYPE;
    vDISCR_SPISANIE   TARIFFS.DISCR_SPISANIE%TYPE;
--    vSDVIG_DISCR_SPISANIE   TARIFFS.SDVIG_DISCR_SPISANIE%TYPE;
--    vDISCR_SPISANIE_START_DATE DATE;
    vCT INTEGER;
  begin
    select
      MONTHLY_PAYMENT, nvl(DISCR_SPISANIE, 0)
    INTO vRes, vDISCR_SPISANIE 
      from tariffs
    where
      tariff_id = pTARIFF_ID;
    
    if vDISCR_SPISANIE = 1  then
      --�������� ���� ������ �������� ����������� ������
--      vDISCR_SPISANIE_START_DATE := last_day(add_months(trunc(sysdate, 'mm'), - SDVIG_DISCR_SPISANIE));
      
      --��������� ��, ��� ������� �� ����� �������� ���� � ������� ����� �������(�� ����������� ����, �� vDISCR_SPISANIE_START_DATE)
      SELECT count(*) into vCT
      FROM DB_LOADER_ABONENT_PERIODS D, tariffs t
      WHERE D.PHONE_NUMBER = pPHONE_NUMBER
        AND D.TARIFF_ID <> pTARIFF_ID
        and D.TARIFF_ID = T.TARIFF_ID(+)
        AND D.end_DATE >= 
        
          last_day(add_months(trunc(sysdate, 'mm'), - nvl(t.SDVIG_DISCR_SPISANIE,0)));
        
     
      if vCT > 0 then
        --���� ����� ���������, �� ��������� ������ ���� ������
        vRes := GET_DAYLY_PAYMENT(vRes);
      else
        -- ���� �� �������, �� ��������� �� ����������� �����,
        --���� ����� ������, �� ������ = ������ �� �����, ���� ���, �� ������ ����� 0
        if to_number(to_char(sysdate, 'dd')) > 1 then
          vRes := 0;  
        end if;
        
      end if;
    else
      vRes := GET_DAYLY_PAYMENT(vRes);  
    end if; 
    
    RETURN vRes;   
  END;
    

--�������� �� ����������� �������� �� �����, ������� ������ �� USSD
  function GET_CHANGE_TO_TARIFF(pTARIFF_ID TARIFFS.TARIFF_ID%TYPE) RETURN INTEGER IS
    vCT INTEGER;
    vRes Integer;
  begin
    
    select count(*) into vCT
      from tariffs
    where
      tariff_id = pTARIFF_ID
      and nvl(CHANGE_TO_TARIFF, 0) = 1;
    
    if nvl(vCT, 0) > 0  then
      vRes := 1; --��������� ������� 
    else
      vRes := 0; -- ��������� �������
    end if;
    
    RETURN vRes;  
    
  end;
  
  --��������� �� ������������� ��������
  --���� ������� �� ��������, �� 0,����� 1
  function CONTRACT_EXISTS (pPhoneNumber varchar2) RETURN INTEGER IS
    vCT integer;
    vRes Integer;
  begin
    select
          COUNT(*) into vCT
    from
      v_contracts v
    where
      V.CONTRACT_CANCEL_DATE is null
      and V.PHONE_NUMBER_FEDERAL = pPhoneNumber;
    
    if nvl(vCT, 0) = 0 then
      vRes := 0;
    else
      vRes := 1;
    end if;
    
    Return vRes;  
  end;
   

--�������� �� ������� ������ ������ � ������� ������
  function GET_CHANGE_PP (pPHONE_NUMBER varchar2) RETURN INTEGER IS
    vCT integer;
    vRes Integer;
  begin
  
    select
      count(distinct priceplan) into vCT
    from
      ARCHIVE_API_GET_CTN_INFO_LIST arch
    where
      ctn = pPHONE_NUMBER
      and (
            
            (
              end_date >= trunc(sysdate, 'mm')
              and 
              end_date >= (
                             select
                               case
                                when trunc(contract_date) = trunc(DATE_CREATED) then
                                  DATE_CREATED
                               else
                                contract_date       
                               end 
                                contract_date
                             from
                               v_contracts v
                             where
                               V.CONTRACT_CANCEL_DATE is null
                               and V.PHONE_NUMBER_FEDERAL = arch.ctn
                      )
            )
            
            or
            end_date is null
          )
     
    ;
    
    /*
    select count(*) into vCT from
        USSD_CHANGE_PP_LOG up
    where
      year_month = to_number(to_char(sysdate,'yyyymm'))
      and up.PHONE_NUMBER = pPHONE_NUMBER
      and 
      (
        (
          nvl(error_message, '0') = '0'
          and exists
              (select 1
               from
                BEELINE_TICKETS bt
               where 
                to_number(BT.TICKET_ID) = up.TICKET_ID
                and nvl(BT.ANSWER, 9999) in (9999, 1) -- 9999 -������ ������ ��� �� �������� 1 - ������ ���������
              )
         )
         OR
         (error_message like '%'||cEmailMessagePath||'%')
      )
      ; */
    if nvl(vCT, 0) <= 1 then
      vRes := 1; -- ��������� ��������� ������   �� �����
    else
      vRes := 0; --���������  ��������� ������ �� �����
    end if;
  
    RETURN vRes;
  end;
begin
  
  for rec in (
              select  
                PHONE_NUMBER,
                USSD_CODE,
                DATE_CREATED,
                USER_CREATED,
                rowid r_rowid
              from
                USSD_CHANGE_PP_QUEUE
              )
  loop
    vSmsText := '������ �� ����������� ��������� ����� ����������.';
    vERROR_MESSAGE := null;
    vTicketID := null;
    vTariffCode := null;
    vTariffID := null;
    vUSSD_STATUS_ID := cUSSD_NEW_STATUS_ID;
    
    --��������� �� ������������� ���������
    if CONTRACT_EXISTS(rec.PHONE_NUMBER) = 0 then
      vSmsText := '������ ��� ���������� �������. ���������� � ������ ��������� �� ���. 0577.';
      vERROR_MESSAGE := '��� ����������� ��������';  
    else
      --��������� �� ����������� ������ �������� �����
      if GET_CHANGE_PP(rec.PHONE_NUMBER) = 0 then
        vSmsText := cERROR_CHANGE_SMS;
        vERROR_MESSAGE := '� ���� ������ ��� ���� ������������ ����� ��������� �����';
      else 
        vTariffCode := GET_TARIFF_CODE_BY_USSD(rec.USSD_CODE, vERROR_MESSAGE, vTariffID);
        
        if GET_CHANGE_TO_TARIFF(vTariffID) = 1 then -- �������� ������������ �������� �� ��������� �����
          
          vCurrentTariffID := GET_CURR_PHONE_TARIFF_ID(rec.PHONE_NUMBER);
          
          if vCurrentTariffID > -1 then
             
            --�������� ���� ����� �� ���������� ������
            vMonthlyPayment := nvl(GET_MONTHLY_PAYMENT(vTariffID), 0);
            
            -- ��������� ����������� ����� �� �������� ������       
            vCurrentMonthlyPayment := nvl(GET_CURRENT_MONTHLY_PAYMENT(vCurrentTariffID, rec.PHONE_NUMBER), 0);
            
            -- �������� ������ �������� c ������ ����������� ����� �� ������� ������
            vAbonentBalance := nvl(GET_ABONENT_BALANCE(rec.PHONE_NUMBER), 0) - vCurrentMonthlyPayment;
            
            if vMonthlyPayment < vAbonentBalance then 

              if GET_CHANGE_FROM_TARIFF(vCurrentTariffID) = 1 then  -- �������� ������������ �������� � �������� ������
                      
                --�������� ������ ������������ ������
                vDETAILED_TARIFF_NAME := GET_DETAILED_TARIFF_NAME (vCurrentTariffID, vTariffID);
                
                --���� ������ ������������ �����, �� ����������� ������ �� API, ���� ��� �� ����� ������
                if nvl(vDETAILED_TARIFF_NAME, '0') = '0' then
                  if nvl(vERROR_MESSAGE, '0') = '0' then 
                    vTempStr := BEELINE_API_PCKG.changePP(rec.PHONE_NUMBER, vTariffCode, cFUTURE_DATE);
                          
                    if INSTR(vTempStr, cOK_ANSWER) > 0 then 
                      vTicketID := REPLACE(vTempStr, cOK_ANSWER, '');
                    else
                      vERROR_MESSAGE := vTempStr;
                      vSmsText := cERROR_CHANGE_SMS;
                    end if;
                            
                  end if;--vERROR_MESSAGE <> ''
                else
                  --��������� �� ��������� ����� ������
                  
                  if IS_DUBLE_TIKET(rec.PHONE_NUMBER) =  0 then
                  
                    vERROR_MESSAGE :='<tr><td>'||rec.PHONE_NUMBER ||'</td><td>'||vDETAILED_TARIFF_NAME||'</td></tr>';
                    --��������� ���.�������� �� ����� ������              
                    P_USSD_ADD_CONTRACT_CHANGES (rec.PHONE_NUMBER, rec.USSD_CODE);
                    
                    --����������� ������ ������� �� �������� ������
                    vUSSD_STATUS_ID := cUSSD_SEND_MAIL_STATUS_ID;
                  else
                    vERROR_MESSAGE := '��������� ����� �������� �� ����� ������ �� ��������� �����';
                    vSmsText := '��������� ����� �������� �� ����� ������.';
                  end if;  
                end if;-- if nvl(vDETAILED_TARIFF_NAME, '0')
              else
                vERROR_MESSAGE := '������� �� ��������� ����� ����������';
                vSmsText := cERROR_CHANGE_SMS;  
              end if;--if GET_CHANGE_FROM_TARIFF(vCurrentTariffID) = 1 t
            else
              vERROR_MESSAGE := '������������ ������� �� �����. ������: '||vAbonentBalance||'�. ��.�����: '||vMonthlyPayment;
              vSmsText := '��� �������� �� ��������� ����� ���������� ��������� ������ �� '||round(vMonthlyPayment - vAbonentBalance, 2)||'�. � ��������� ������� ������.';
            end if;--if vMonthlyPayment < vAbonentBalance then
          else
            vERROR_MESSAGE := '����� ������ ���������� ��� ������������ ��������.';
            vSmsText := '����� ������ ���������� ��� ������������ ��������.';
          end if;--if vCurrentTariffID > -1 then
        else  
          vERROR_MESSAGE := '������� �� ��������� ����� ����������';
          vSmsText := '� ��������� ������� �� ��������� ���� ����� ����������.';
        end if;--GET_CHANGE_TO_TARIFF(rec.PHONE_NUMBER)
         
      end if;--GET_CHANGE_PP(rec.PHONE_NUMBER)
      
      if nvl(vUSSD_STATUS_ID, 0) <> cUSSD_SEND_MAIL_STATUS_ID then
        if nvl(vTicketID, 0) <> 0 then
          vUSSD_STATUS_ID := cUSSD_NEW_STATUS_ID;
        else
          vUSSD_STATUS_ID := cUSSD_FINAL_STATUS_ID;
        end if;
      end if;
    end if;
    
    insert into USSD_CHANGE_PP_LOG
                    (
                      PHONE_NUMBER,
                      USSD_CODE,
                      TICKET_ID,
                      ERROR_MESSAGE,
                      DATE_CREATED,
                      USER_CREATED,
                      USSD_CHANGE_CONTRACT_STATUS_ID 
                    )
     values
            (
              rec.PHONE_NUMBER,
              rec.USSD_CODE,
              vTicketID,
              vERROR_MESSAGE,
              rec.DATE_CREATED,
              rec.USER_CREATED,
              vUSSD_STATUS_ID
            );
    
    delete from USSD_CHANGE_PP_QUEUE
    where rowid = rec.r_rowid;
   
    vERROR_MESSAGE := LOADER3_PCKG.SEND_SMS(rec.PHONE_NUMBER, '', vSmsText);
    commit;
    
  end loop;  

end;