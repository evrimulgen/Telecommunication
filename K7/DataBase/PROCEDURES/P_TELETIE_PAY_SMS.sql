CREATE OR REPLACE procedure P_TELETIE_PAY_SMS is

  --Version 4
  --
  --v.4 23.03.2016 ��������. ��� ��������� �� ����������� (IS_MOBI_PAY) ���������� ������ ����� ���.
  --v.3 03.02.2016 ��������. ���. ���������� ������������ ������ �� ������ � �������� ����� � ������� � ��������������� �������
  --v.2 03.02.2016 ��������. ��� �������, �� ������� ��� ������� ��������� �������, ������� � ��� ����� "��� ���������� ������ ��������� ���������� ������������� ����������."
  --                                      ������ ��� � ����������� ���
  --v1 ����������� �����������.
  
  sms varchar2(1000);
  pSmsDop varchar2(100 char);
  pTxtSms varchar2(500 char);
  pCount integer;
  pCntTariffs integer;
  pDate date;
begin
  update TELETIE_PAY_LOG pl 
       set pl.sms_send=0 --���������� ������, ��� ���-�� �� �����
  where pl.ssign is null --��� ������
        or pl.http_answer!='200 Ok' --� ������ ��������
        or pl.res is not null --� �������
        or pl.date_insert<sysdate-1; -- ������ �����
  --���������        
  commit;
  
  --�������� ��� � ����������
  for c in (
                 select 
                     distinct pl.phonenr,
                     pl.amount,
                     pl.numpay,
                     CT.TARIFF_ID,
                     PL.IS_MOBI_PAY
                   from teletie_pay_log pl, 
                           db_loader_account_phones ph, 
                           contracts ct
                 where ph.phone_number=pl.phonenr 
                     and ph.year_month in (to_char(sysdate,'YYYYMM'),to_char(sysdate-1,'YYYYMM'))
                     and ph.phone_number=ct.phone_number_federal
                     and not exists(
                                             select 1 
                                               from contract_cancels cc 
                                             where ct.contract_id=cc.contract_id
                                         )
                     and pl.sms_send is null
                     and pl.res is null
                     and pl.http_answer='200 Ok'
                     and nvl(ph.phone_is_active, 0)=1
                     and (trunc(sysdate)+nvl(to_number(regexp_substr(ct.paramdisable_sms,'\d,\d+',1,1)),0))<=sysdate
                     and (trunc(sysdate)+nvl(to_number(regexp_substr(ct.paramdisable_sms,'\d,\d+',1,2)),1))>=sysdate
            ) 
  loop
    pTxtSms := '';
    pSmsDop := '';
    pCount := 0;
    pCntTariffs := 0;
    --��� �������, �� ������� ��� ������� ��������� ������� � ��� ��������� ���. ����������
    begin
      --��������� �� �������������� � ����������� �������
      select count(*)
         into pCntTariffs
        from tariffs tr
      where TR.TARIFF_ID = C.TARIFF_ID
          and (
                    (TR.TARIFF_NAME LIKE '�����%')
                    or
                    (nvl(TR.IS_AUTO_INTERNET, 0) = 1)
                );
                  
      --���� �� ������� ��������, �� ���� ������
      if nvl(pCntTariffs, 0) > 0 then            
        --�.�. ������� ���� �� distinct, �� �������� ����, ������� ����� ���� ������, ���� ������� �����������
        --����� �� �������� ������ ���, ����� ������������ ���� �������
        select max(LG.DATE_INSERT)
           into pDate
          from teletie_pay_log lg
        where LG.PHONENR = c.phonenr
            and lg.amount = c.amount
            and lg.numpay = c.numpay;

        --��������� ������� ������ �� ������� � ����� ����������� ���� �������
        select count(*)
           into pCount 
          from beeline_tickets bt 
        where bt.phone_number=c.phonenr
            and bt.ticket_type=10 --�������������
            and bt.date_create > pDate;
      end if;
    exception
      when others then
        pCount := 0;   
    end;
      
    --���� ������ �� ������� ���� � ��� �� ������� ���������, �� ��������� ���. ���������� � ���
    if (nvl(pCount, 0) > 0) and (nvl(c.IS_MOBI_PAY, 0) = 0) then
      pSmsDop := '��� ���������� ������ ��������� ���������� ������������� ����������.';
    end if;
    
    --���������� ����� ���
    if nvl(c.IS_MOBI_PAY, 0) = 0 then
      pTxtSms := '������ �� ����� '||c.amount||' ���. ��������. '||pSmsDop;
    else
      pTxtSms := '����� � ������� '||abs(c.amount)||' ���. ���������� � ������ �������.';
    end if;
    
    --�������� ���
    sms:=null;
    sms:=loader3_pckg.SEND_SMS(pPHONE_NUMBER =>c.phonenr
                                                  ,pMAILING_NAME =>'TELETIE_PAY_SMS'
                                                  ,pSMS_TEXT =>pTxtSms
                                                  ,pSENDER_NAME => 'TELETIE');

    update TELETIE_PAY_LOG pl 
         set pl.sms_send=1 
    where pl.phonenr=c.phonenr
        and pl.numpay=c.numpay
        and pl.amount=c.amount
        and pl.sms_send is null
        and sms is null; -- ��� ���������� ��� ������
    --���������
    commit;                            
  end loop;                                     
end P_TELETIE_PAY_SMS;