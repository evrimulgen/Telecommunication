CREATE OR REPLACE PROCEDURE SEND_NOTICE_ON_NEW_CONTRACT(
  pCONTRACT_ID IN INTEGER
  ) IS
--
--Version=11
--v11. 16.01.2016 - �������� ����� ��� "����������!��������� 10% � ������� ��� ���������� ����� ���� www.gsmcorporacia.ru/oplata_uslug � ����� ���������� www.gsmcorp.ru/m"
--v10. 14.12.2015 - ������� ����� ��� "����������!��������� 10% � ������� ��� ���������� ����� ���� www.gsmcorporacia.ru/oplata_uslug � ����� ���������� www.gsmcorp.ru/m"
--v9.25.11.2015 - ������� ������� ��� "����������!��������� 10% � ������� ��� ���������� ����� ���� www.gsmcorporacia.ru/oplata_uslug � ����� ���������� www.gsmcorp.ru/m"
--v.8 29.09.2015 - ������  ����� ��� � ������� "���������� GSM �  '��������� '||TO_CHAR(vPERCECNT_PAYKEEPER)||'% � ������ �������
-- �� ������� ���������� �����������
--v.7 20.08.2015 - ������� - ������� ��� ���� ��� � ������� "���������� GSM Corporacia ��� iOS http://www.gsmcorporacia.ru/itunes ������������ ������ ,������ �������,����� � ������ ,����� � ����� �������� ������� � ������ ������"
--v.6 13.07.2015 - ������� �. - �� ������� �����������,��������� ���������� � ������ ��� ������ ���������� ������
                            -- ������� �  BLOCK_SEND_SMS � ����� ����� - ������ ��� ��� ��������� ����� ��� � ����� �� �����!
--v.5 17.03.2015 ������� ������� � ��������� � ����������� � USSD ����� "�������� �������� ������� �� ������ *200*5550#"  
-- ���������� �.�. 12.11.2012 ���������� �������� ��� 2-� ��� ��� ����������� ������ ��������.
-- ���������� �.�. 13.11.2012 ����������� ������ 2-�� ���.
  CURSOR C IS
    SELECT CONTRACTS.PHONE_NUMBER_FEDERAL,
           OPERATORS.OPERATOR_NAME,
           ABONENTS.SURNAME||' '||ABONENTS.NAME||' '||ABONENTS.PATRONYMIC FIO         
      FROM CONTRACTS, 
           OPERATORS,
           ABONENTS      
      WHERE CONTRACTS.CONTRACT_ID=pCONTRACT_ID
        AND CONTRACTS.OPERATOR_ID=OPERATORS.OPERATOR_ID
        AND CONTRACTS.ABONENT_ID=ABONENTS.ABONENT_ID;      
  rec C%ROWTYPE;
  SMS_TEXT VARCHAR2(500 CHAR);
  SMS VARCHAR2(500 CHAR);
  vPERCECNT_PAYKEEPER NUMBER;
  vPAYKEEPER_COEFFICIENT NUMBER; 
BEGIN
  OPEN C;
  FETCH C INTO rec;
  CLOSE C;
  IF rec.OPERATOR_NAME='������' THEN
    
    for rec_sms in (
                    select * from
                     (
                      select 1 sort_idx, '��� ������������ gsmcorp.ru, �������,��� ��������������� �������� ����� ��������!' SMS_TEXT from dual
                      union all
                      select 2  sort_idx, '��. �������, ��������� ������ - *200*555# � 0588, �������� �������� ������� �� ������ *200*5550#, � ��� �� � ������� ������� �������� �� ����� ����� gsmcorporacia.ru/lk/MAIN' SMS_TEXT from dual
                      union all
                      select 3  sort_idx, '������ ��������� - 84956487888 ��� � ���������� - 05455 (�������� ��� ����������).' SMS_TEXT from dual
                      /*union all
                      select 4  sort_idx, '����������! ��������� 10% � ������� ��� ���������� ����� ���� www.gsmcorporacia.ru/oplata_uslug � ����� ���������� www.gsmcorp.ru/m' SMS_TEXT from dual*/
                     )
                    order by sort_idx desc
                   )
    loop
      SMS:=LOADER3_PCKG.SEND_SMS(
           rec.PHONE_NUMBER_FEDERAL,
           '���-����������',
           rec_sms.SMS_TEXT);
      -- ���� ������� ��� ���������� ����������� �������� ���
      dbms_lock.sleep(1);  
    end loop;
    
    --v6 - ��� ������������ >1 ��������� �����
    --vPAYKEEPER_COEFFICIENT := GET_PAYKEEPER_COEFFICIENT;
   -- IF NVL(vPAYKEEPER_COEFFICIENT, 0 ) > 1 THEN
   --   vPERCECNT_PAYKEEPER := (vPAYKEEPER_COEFFICIENT - 1)*100; -- ��������� �������
     -- SMS_TEXT := '��������� '||TO_CHAR(vPERCECNT_PAYKEEPER)||'% � ������ ������� ��� ������ ������ �� ����� �����! http://www.gsmcorporacia.ru/oplata_uslug/'; 
     -- SMS:=LOADER3_PCKG.SEND_SMS(
     --        rec.PHONE_NUMBER_FEDERAL,
      --       '���-����������',
      --       SMS_TEXT);  
    --END IF;

-- ���������������, ��� ����� �� �����
--    IF SMS IS NULL THEN  
--      INSERT INTO BLOCK_SEND_SMS(PHONE_NUMBER, SEND_DATE_TIME, ABONENT_FIO) 
--        VALUES (rec.PHONE_NUMBER_FEDERAL, sysdate, rec.FIO);
--    END IF;

    COMMIT;       
  END IF;
END;