CREATE OR REPLACE procedure UPDATE_ACCOUNT_PHONES_SIM IS                                          
  vRes VARCHAR2(1000);
  vPhone integer;
  oldSim VARCHAR2(18);
  
  --Version 2
  --
  --v.2 2015.12.15 ��������. �������� ����� � ������� ������ � ������� REPLACE_SIM_LOG. ������ �������� ��� �������� ����������
  
BEGIN
  --���������� ��� �/�
  for rec in (select 
                   ACCOUNT_ID, 
                   n_method, 
                   is_collector
                 from accounts)
  loop 
    --��������� ����������� ����������
    if strInLike(23,nvl(rec.n_method,'0;'),';','()')=1 then
      --���� �/� ����������
      if rec.is_collector = 1 then
        vRes := BEELINE_API_PCKG.Collect_account_phone_SIM(rec.ACCOUNT_ID); 
      else
        vRes := BEELINE_API_PCKG.account_phone_SIM(rec.ACCOUNT_ID); 
      end if;          
    end if;
  end loop;
  
  --����� ���� ��� ��������� ������ SIM, ��������� ���������� � dop_phones 
  for irec in (SELECT 
                      db.ACCOUNT_ID, 
                      db.PHONE_NUMBER, 
                      db.SIM_NUMBER, 
                      db.IMSI_NUMBER,
                      AC.ACCOUNT_NUMBER,
                      AC.COMPANY_NAME
                   FROM DB_LOADER_SIM db,
                             ACCOUNTS ac
                   WHERE DB.ACCOUNT_ID = AC.ACCOUNT_ID)
  loop
    --���� � ������� phones_dop ������� ������ �� ������, �� ��������� dop
    select count(dop.PHONE_NUMBER)
    into vPhone
    from phones_dop dop
    where dop.PHONE_NUMBER = irec.PHONE_NUMBER; 
    oldSim := ''; 
    
    if vPhone = 1 then
      --���������� ������ ����� ��� �����
      select pd.SIM
      into oldSim
      from phones_dop pd
      where pd.phone_number = irec.PHONE_NUMBER;  
      --����������
      UPDATE PHONES_DOP dp
      SET dp.sim = irec.SIM_NUMBER, 
             dp.BAN = irec.ACCOUNT_NUMBER,
             dp.NAME_BAN = irec.COMPANY_NAME,
             dp.datetime_sim = trunc(sysdate)
      WHERE dp.PHONE_NUMBER = irec.PHONE_NUMBER;     
      commit;
    else
      --�������  
       INSERT INTO PHONES_DOP (PHONE_NUMBER, BAN, SIM, NAME_BAN, DATETIME_SIM) 
       VALUES (irec.PHONE_NUMBER, irec.ACCOUNT_NUMBER, irec.SIM_NUMBER, irec.COMPANY_NAME, trunc(sysdate));
       commit;
    end if;  
    --���������� � ������� 
    insert into REPLACE_SIM_LOG(PHONE, OLD_SIM, NEW_SIM, REP_USER, REP_DATE, ERR, BSAL_ID, SIM_LOG_TYPE_ID)
    values(irec.PHONE_NUMBER, oldSim, irec.SIM_NUMBER, null, null, 0, null, 2);
    commit;      
  end loop;            
END;