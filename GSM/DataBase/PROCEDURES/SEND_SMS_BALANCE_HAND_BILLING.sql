CREATE OR REPLACE PROCEDURE SEND_SMS_BALANCE_HAND_BILLING IS

 CURSOR C IS
   SELECT DATE_BILLING, COST, PHONE_NUMBER_TARIFER, PHONE_NUMBER_CLIENT, CONTRACT_ID, GET_ABONENT_BALANCE_K( PHONE_NUMBER_TARIFER, DATE_BILLING) bal 
       FROM BALANCE_HAND_BILLING 
     where SEND_SMS = 0
      and nvl(PHONE_NUMBER_CLIENT,0) <> 0;

 SMS       VARCHAR2 (2000);
 TXT       VARCHAR2 (2000);
 
BEGIN

  for vREC in C
  loop
   
     TXT := '��.�������! '|| to_char(vREC.DATE_BILLING,'dd.mm.yyyy')|| ' � ������ ����� ���� ������� ����.����� � ������� '||to_char (ROUND (vRec.COST, 2), 'fm99990.00')||
            ' �.  ������:'|| to_char (ROUND (vRec.bal, 2), 'fm99990.00')||' �. ����������, ��� ���������� ������ ����������� ����� �� ������ ������� � ��������. �.05455. �������� ������ ��� �������� �� ����� www.gsmcorporacia.ru/oplata_uslug � ����� ���������� www.gsmcorp.ru/m';
      
     SMS :=
               LOADER3_pckg.SEND_SMS (vREC.PHONE_NUMBER_CLIENT,
                                      '���-����������',TXT);
               
      update BALANCE_HAND_BILLING bhb
         set
             SEND_SMS = 1,
             DATA_SEND_SMS = sysdate
         where  bhb.CONTRACT_ID = vREC.CONTRACT_ID
       and  bhb.PHONE_NUMBER_TARIFER = vREC.PHONE_NUMBER_TARIFER;
                               
  end loop;
  commit;
 
END SEND_SMS_BALANCE_HAND_BILLING;
/
