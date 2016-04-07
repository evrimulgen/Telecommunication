CREATE OR REPLACE PROCEDURE CORP_MOBILE.SEND_SMS_NOTICE AS
--
--#Version=22
--
--22 02.07.2015 �������� �.�. �������� �� �������� ��� � ������� �������� ������
--21 23.01.2015 ������ �.�. ��������� ��������� �������� ������ � ������������ �������
--19 21.01.2013 �����. �������� ������- ������ ������������� ��� ��������� �������.������������� ���.
--02.07.2013 �����. �������� ��������� ������ � send_notice, ���� ��� �� ����������.�������� ���������� ��� � �� � �� 
--09.09.2011 �������. ������� �� ������ ����� ���������
--25.12.2012 ��������. ������� �������� ���������� SMS � ����� ������ �������������� �� ������� send_notice
--13.03.2013 ��������. ������� ������ ������ ������� � ������ ���
--10.04.2013 ��������. ��������� ������ ������������� ���������� (���������� ������) ���������� �� ����������� �������
--
CURSOR C IS
  SELECT NT.PHONE_NUMBER_FEDERAL,
         NT.BALANCE,
         NT.FIO,
         NT.DISCONNECT_LIMIT,
         NT.BALANCE_NOTICE_TEXT,
         NT.BALANCE_NOTICE,
         NT.ACCOUNT_ID,
         NT.DEALER_KOD,
         nvl(to_number(replace(regexp_substr(NT.paramdisable_sms,'\d,\d+',1,1),',','.')),0) start_sms_time,
         nvl(to_number(replace(regexp_substr(NT.paramdisable_sms,'\d,\d+',1,2),',','.')),1) end_sms_time
  FROM  --��� ��������� �������� ������ �� IOT_CURRENT_BALANCES - - ������ ��� �7 
       V_PHONE_BALANCE_NOTICE_CURRENT NT
  where
--�������� ������ ��� , �� ������� ��������� ����� ����� ���������� ���
--��� ��������� ����� ��������� ������� ��������� ������ � SEND_NOTICE
    not exists (select 1 from send_notice sn 
                  where nt.PHONE_NUMBER_FEDERAL=sn.phone_number 
                    and sn.balance_notice <= nt.balance_notice)
  and not exists (
                            SELECT 1
                              FROM PHONE_CALC_ABON_TP_UNLIM_ON ph
                            WHERE PH.PHONE_NUMBER = nt.PHONE_NUMBER_FEDERAL
                                AND PH.YEAR_MONTH = to_number(to_char(sysdate, 'YYYYMM'))
                                AND PH.TARIFF_ID = NVL(GET_CURR_PHONE_TARIFF_ID(nt.PHONE_NUMBER_FEDERAL), 0)
                       );
  vREC C%ROWTYPE;
--
CURSOR DL (KOD INTEGER) IS
  SELECT
    PATTERN, REPLACEMENT,SENDER_NAME
  FROM DEALERS
  WHERE DEALER_KOD=KOD AND PATTERN IS NOT NULL AND REPLACEMENT IS NOT NULL;

  vDL DL%ROWTYPE;
--
  v_d VARCHAR2(2000);
  v_t VARCHAR2(2000);
  SMS VARCHAR2(2000);
  SMS_TXT VARCHAR2(2000);
  date_begin DATE;
  PSender_name varchar2(20);
--  
  TYPE ACC_DO_BALANCE_NOTICE_TYPE IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  acc_notice_is_on ACC_DO_BALANCE_NOTICE_TYPE;
--
BEGIN
 --�������� �� ����� �������� - �� ������ � 9 �� 18 � �������� � 12 �� 18.
  IF ((TO_NUMBER(TO_CHAR(SYSDATE,'D','NLS_DATE_LANGUAGE=RUSSIAN'))<6) AND (SYSDATE-TRUNC(SYSDATE)>9/24) AND (SYSDATE-TRUNC(SYSDATE)<18/24))
      OR((TO_NUMBER(TO_CHAR(SYSDATE,'D','NLS_DATE_LANGUAGE=RUSSIAN'))>5) AND (SYSDATE-TRUNC(SYSDATE)>12/24) AND (SYSDATE-TRUNC(SYSDATE)<18/24))  THEN
    --��������� ���� ������ ���������, �� ��� ���� ������ �� ��������� �� SEND_NOTICE � ����� ���������...
    date_begin:=sysdate;
    --��������� ������ � SEND_NOTICE ���, ���� ���������� ���������� ��� �������
    --, ����� �� �� ������� �� SEND_NOTICE 
    update SEND_NOTICE sn 
      set sn.send_date_time=sysdate --0:38 (count=14638)
      where sn.phone_number in (select vc.PHONE_NUMBER_FEDERAL 
                                  from V_PHONE_BALANCE_NOTICE_CURRENT VC, send_notice sn2
                                  where vc.PHONE_NUMBER_FEDERAL=sn2.phone_number and vc.BALANCE_NOTICE>=sn2.balance_notice);
    commit;
      
       --��������� ���. � ������� �����
    for inf in 
        (SELECT
         ACCOUNTS.Account_Id,
         ACCOUNTS.DO_BALANCE_NOTICE
         FROM ACCOUNTS)
    loop
      acc_notice_is_on(inf.account_id):=nvl(inf.do_balance_notice,0);
    end loop; 
    --��������� ������ � ���������� ������� ������ ����� ���� ��������� ���.
    FOR vREC IN C --0:51 (count=213)
    LOOP--0:00.61*n
      --���� �� ������� ����� �������� ���������� � ����� ������� ��� ����� � ���������
      IF acc_notice_is_on(vREC.ACCOUNT_ID)=1 and 
         (trunc(sysdate)+vrec.start_sms_time)<=sysdate
         and
         (trunc(sysdate)+vrec.end_sms_time)>=sysdate   
        THEN
        v_d:=to_char(sysdate,'mm/dd/yyyy');
        v_t:=to_char(sysdate,'hh24:mi');
        --��� ��� ��������� ��� ���������� ���, �� ������ ����������� - ���
        UPDATE send_notice s SET s.send_date_time=sysdate
        WHERE s.phone_number = vREC.PHONE_NUMBER_FEDERAL AND s.balance_notice <= vREC.balance_notice;
        
        IF (SQL%NOTFOUND) THEN
          SMS_TXT:=replace(vREC.BALANCE_NOTICE_TEXT,'%balance%',ltrim(to_char(vRec.Balance,'99999999990.99'))||' �.');
          SMS_TXT:=replace(SMS_TXT,'%dolg%',round(-vRec.Balance));

          --�����
          PSender_name:=null;
          --������ ���������� ���������� ��� ������� �� �����������
          FOR vDL IN DL(vREC.DEALER_KOD) LOOP
            SMS_TXT:=replace(SMS_TXT, vDL.pattern, vDL.replacement);
            PSender_name:=vDL.Sender_Name;
          END LOOP;

          --���������� ����� ������ ���������� ��������� ������ ����������
          FOR vDL IN DL(0) LOOP
            SMS_TXT:=replace(SMS_TXT, vDL.pattern, vDL.replacement);
          END LOOP;
          
          CREATE_SNAPSHOT(vREC.PHONE_NUMBER_FEDERAL);
          SMS:=LOADER3_pckg.SEND_SMS(
            vREC.PHONE_NUMBER_FEDERAL,
            '���-����������',
            SMS_TXT,
            0,
            PSender_name);
          DBMS_LOCK.SLEEP(0.1);--�������� �� ������ �� ������� ������-����������.
          IF SMS IS NULL THEN --���� �������� �������
            --�������� � ����-�����������
            INSERT INTO BLOCK_SEND_SMS(phone_number, SEND_DATE_TIME, ABONENT_FIO)
              VALUES (vREC.PHONE_NUMBER_FEDERAL, sysdate, vREC.FIO);
            --������������� ������ � ������������ ����������� ��� �������
            UPDATE send_notice s 
              SET s.send_date_time=sysdate, s.balance_notice=vREC.balance_notice
              WHERE s.phone_number = vREC.PHONE_NUMBER_FEDERAL AND s.balance_notice > vREC.balance_notice;
            IF SQL%NOTFOUND THEN
              INSERT INTO send_notice (phone_number, send_date_time, balance_notice)
                VALUES (vREC.PHONE_NUMBER_FEDERAL, sysdate, vREC.balance_notice);
            END IF;
             /*insert into aaa (nnn1,sss1) values (1,vREC.PHONE_NUMBER_FEDERAL); --������������� ��������
             else
             insert into aaa (nnn1,sss1) values (0,vREC.PHONE_NUMBER_FEDERAL);*/
          END IF;--������� ��������
          
        END IF;--�������� ��� ����� ����������
        COMMIT;
      END IF;--�������� ��� �� �\�
    END LOOP;
    --������ ������� ���������� ���������� �� �������, ������� ��� � V_PHONE_BALANCE_NOTICE_CURRENT
    DELETE FROM send_notice 
      WHERE send_date_time < date_begin;--0:06
    COMMIT;
  END IF;--���������� �����.
END;