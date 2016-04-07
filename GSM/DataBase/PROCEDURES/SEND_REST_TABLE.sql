CREATE OR REPLACE PROCEDURE SEND_REST_TABLE AS
--
--Version=8
--
--v.8 �������� 15.01.2015 ����� "��������� 10% � ������� ��� ���������� ����� ���� www.gsmcorporacia.ru/oplata_uslug � ����� ���������� www.gsmcorp.ru/m"  �� ���
--v.7 ������� 28.12.2015 �� ������� ���������� GSM, ��� Tariff_id=1758 ��������� ���������� �� ������
--v.6 �������� 25.11.2015 ������� ����� "��������� 10% � ������� ��� ���������� ����� ���� www.gsmcorporacia.ru/oplata_uslug � ����� ���������� www.gsmcorp.ru/m" � ���
--v.5 �������  05.10.2015 - �� �������
--                           ������!   ������ �� ����� NEW (1300)
--                           ������!   ������ �� ����� NEW (���) (1500)
--      
--v.4 �������  01.10.2015 - �� �������
--                            ������! ULTRA VIP (1400)
--                            ������� ������� ��� (1180) NEW
--                            ������� ������� ��� (1300) NEW
--                            ����������������� 1500
--                            ������! ULTRA VIP (���) (1600)
--                            ����������������� �� (1100)
--                            ������! ������ �������� 1300(NEW)
--
--                            ����� �������� ���� � �������� ������� �� ��������� :
--                            ������� ������ �� ������ ������ ���������� ������� � ������������� �����- ��� �����������
--v.3 ������  08.09.2015 - ��� ������ ULTRA VIP 2015 (1400) �� = 1978 ������ ��������� "*��� �����������*"
--v.2 ������� 20.05.2015 - ���������� ������ �� USSD ������� ������� �� ������� ������ �������� 1300 � ������ 1400 �����
--v.1 ������� 20.02.2015 - ������� ���������
--
  CURSOR phones is
    select PHONE_NUMBER from USSD_TARIFF_REST_QUEUE;
    

  res VARCHAR2(1000);
  vCURR_PHONE_TARIFF_ID INTEGER;

BEGIN

    
  for ph in phones loop
    
    vCURR_PHONE_TARIFF_ID := nvl(GET_CURR_PHONE_TARIFF_ID(ph.phone_number), -1);
    
    if vCURR_PHONE_TARIFF_ID = 1978 then -- tariff_id = 1978 ULTRA VIP 2015 (1400)
      res := '��� ����� ��� �����������'||chr(13);
    else
      res := '������� �� �������:'||chr(13);
      for c in (
          select 
          --SOC_NAME,  -- ������
          trim(REST_NAME) REST_NAME,
          
          case 
            when CURR_VALUE < 0 then 0
            else
              CURR_VALUE
          end       
          
          ||
          
          CASE UNIT_TYPE
                when 'INTERNET' then '��;'
                when 'SMS_MMS' then '��.;'
                when 'VOICE' then '���.;'
              else
                  ''
              end CURR_VALUE --�������,
              
          from table (TARIFF_RESTS_TABLE(ph.phone_number))
          where 
                UPPER(MS_PARAMS.GET_PARAM_VALUE('TARIFF_NAME_NO_SHOW_VOICE') ) not like 
                      UPPER('%;'|| 
                            TRIM (
                                    (select TARIFF_NAME from tariffs where tariff_id = vCURR_PHONE_TARIFF_ID) 
                                 )
                            ||';%'
                           ) 
               OR UNIT_TYPE <> 'VOICE'
              ) 
      loop
        
        if upper(c.REST_NAME) = '������� ������ �� ������ ������ ����������' 
          and vCURR_PHONE_TARIFF_ID in (1133,--  ������!   ULTRA VIP (1400)
                                        1134,--  ������� ������� ��� (1180) NEW
                                        1135,--  ������� ������� ��� (1300) NEW
                                        1156,--  ����������������� 1500
                                        1178,--  ������!   ULTRA VIP (���) (1600)
                                        1338,--  ����������������� �� (1100)
                                        1956,--  ������! ������ �������� 1300(NEW)
                                        1758 --������!!! ������ �������� (1300)
                                      ) --�� �������� ������ �� ������� ��������
        then   
          c.CURR_VALUE := '��� �����������;';
        elsif upper(c.REST_NAME) = '������� ������'
              AND vCURR_PHONE_TARIFF_ID IN (1758) --������!!! ������ �������� (1300)
        then
          c.CURR_VALUE := '��� �����������;';
        elsif upper(c.REST_NAME) = '������� ������'
              AND vCURR_PHONE_TARIFF_ID IN (1075, --������!   ������ �� ����� NEW (1300)
                                            1179 --������!   ������ �� ����� NEW (���) (1500)
                                           )
        then
          c.CURR_VALUE := 4000 - GET_CALL_OUT_MINUTE_NOTBEE (ph.phone_number)||'���.;';  
        end if;
        
        res := res ||c.REST_NAME||' - '||c.CURR_VALUE||chr(13);
        
      end loop;
    
    end if;
    
    --res := res||' ��������� 10% � ������� ��� ���������� ����� ���� www.gsmcorporacia.ru/oplata_uslug � ����� ���������� www.gsmcorp.ru/m';
    
    res := LOADER3_PCKG.SEND_SMS(ph.phone_number, '������� �� �������', res );
    
    
    delete
      from USSD_TARIFF_REST_QUEUE
    where
      PHONE_NUMBER =ph.phone_number;
    commit;
  end loop;
END;