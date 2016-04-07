CREATE OR REPLACE PROCEDURE CREATE_PAYMENT_TICKET(
                                                pPhone_number_tarifer varchar2, 
                                                pPAYMENT_DATE         DATE,
                                                pPAYMENT_SUM          NUMBER,
                                                pPAYMENT_NUMBER       VARCHAR2
  ) IS

--
--#Version=3
--
--v.3 ������� 17.02.2016 - ������� �� ������ ������ Exception �������, ������ ����� � ��� � ���������� �����������.
--v.2 ������� 12.02.2016 - ������� ����� �������� � ����� ���������
--v.1 ������� 11.02.2016 - ��������� ��� ���������� ������� ��� �������� ������ � CRM(http://redmine.tarifer.ru/issues/4276)
--                      - ���� � ������� ������������ (crm_beeline_conformity) ����� ����� �������� �������:
--                          �� ��������, �������� ������� � � ���� ���� ����������� �������, �� ���������, �� ����� ������� ������ � received_payments
--                      -- ���� ����� ����� � ��� ��� � ��������, �� ������� ������ � crm �� ���������� ���������� ��������.
  
  PRAGMA AUTONOMOUS_TRANSACTION;
  
  cFilialID CONSTANT FILIALS.FILIAL_ID%TYPE := 16; --������������� ������� ��� �������� ��������
  cTicketTypeID CONSTANT CRM_REQUESTS.TYPE_REQUEST_ID%TYPE := 221; --������������� ��� ���� ������ � CRM
  cTYPE_CRM_BEELINE_ID CONSTANT TYPES_CRM_BEELINE.ID%TYPE := 2; -- ������������ ������� �������
   
  CURSOR c IS
    SELECT
      pPAYMENT_DATE payment_date,
      pPAYMENT_SUM payment_sum,
      pPAYMENT_NUMBER payment_number,
      
      
      (select
        contract_id
       from
        v_contracts c
       where
        C.PHONE_NUMBER_FEDERAL = c.phone_number_client
        and C.CONTRACT_CANCEL_DATE is null
      ) Contract_id,
         
      2 AS payment_type,--������� ����������� � ����� �������
      c.phone_number_tarifer,
      c.phone_number_client,
      c.operator_client,
      c.TYPE_CRM_BEELINE_ID,
      (select OPERATOR_FOR_CHAT  from OPERATORS where upper(OPERATOR_NAME) = upper(c.operator_client) ) operator_client_en
    FROM
      crm_beeline_conformity c
    WHERE
      pPhone_number_tarifer = c.phone_number_tarifer
      AND NOT EXISTS (SELECT 1 FROM CRM_BEELINE_PAYMENT_LOG_TICKET j 
                      WHERE j.phone_number_tarifer = c.phone_number_tarifer
                        AND j.payment_date = pPAYMENT_DATE
                        AND j.payment_sum = pPAYMENT_SUM
                        AND NVL(j.payment_number,'0') = NVL(pPAYMENT_NUMBER,'0')
                      );

  vErrorText CRM_BEELINE_PAYMENT_LOG_TICKET.ERROR_TEXT%TYPE;
BEGIN
  BEGIN
    for v in c loop
      
      vErrorText := '';
      
      begin
        if v.TYPE_CRM_BEELINE_ID = cTYPE_CRM_BEELINE_ID then
          --������� �������������� ������
          INSERT INTO received_payments(phone_number, payment_date_time, payment_sum, contract_id, filial_id, remark)
          VALUES (v.phone_number_client, v.payment_date, v.payment_sum, NVL(v.contract_id, 0), cFilialID, '������������� ��� ������ �� ������������.');
          
        else
          --������� CRM-������
          INSERT INTO crm_requests(phone_number, responsible_user, type_request_id, text_request, id_status_request, date_created, operator)
          VALUES (v.phone_number_client, ms_constants.GET_CONSTANT_VALUE('CRM_BEELINE_RESPONSIBLE_USER'), cTicketTypeID, '������ ��������� ����� '||v.phone_number_client||'. ����� ������� � �������� �� ����� '||v.phone_number_tarifer||': '||v.payment_sum||' ���.', 1, SYSDATE, v.operator_client_en);
          
        end if;
      exception
        when OTHERS then
          vErrorText := '������! '||SQLERRM;  
      end;
      
      --������� ���������� � ������      
      INSERT INTO CRM_BEELINE_PAYMENT_LOG_TICKET (phone_number_tarifer, phone_number_client, operator_client, payment_date, payment_sum, payment_type, payment_number, type_crm_beeline, ERROR_TEXT)
        VALUES (v.phone_number_tarifer, v.phone_number_client, v.operator_client, v.payment_date, v.payment_sum, v.payment_type, v.payment_number, v.TYPE_CRM_BEELINE_ID, vErrorText);
    end loop;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      vErrorText := '������! '||SQLERRM;
      INSERT INTO CRM_BEELINE_PAYMENT_LOG_TICKET (phone_number_tarifer, phone_number_client, operator_client, payment_date, payment_sum, payment_type, payment_number, type_crm_beeline, ERROR_TEXT)
        VALUES (pPhone_number_tarifer, pPhone_number_tarifer, null, pPAYMENT_DATE, pPAYMENT_SUM, null, pPAYMENT_NUMBER, null, vErrorText);
    COMMIT;
  END;
END;
/
