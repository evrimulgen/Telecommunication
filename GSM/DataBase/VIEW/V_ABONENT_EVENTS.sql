DROP VIEW V_ABONENT_EVENTS;

CREATE OR REPLACE FORCE VIEW V_ABONENT_EVENTS
AS

   SELECT                                                         --#Version=6
            --v6. -- �. ������� - �� ������������ ��� �� sms_log, ��� ��� � ���� SMS_LOG.SEND_DATE ����������� ������ ���� NULL.  
                                                                            --
                                         -- �������, ������������ � ���������.
                                     -- ��������� � �������� PHONE_NUMBER=...!
                                                                            --
         CONTRACTS.PHONE_NUMBER_FEDERAL AS PHONE_NUMBER,
         EVENTS.EVENT_CODE,
         EVENT_DESCRIPTIONS.DESCRIPTION,
         EVENT_DESCRIPTIONS.IMAGE_BMP,
         EVENTS.EVENT_DATE,
         CASE WHEN EVENTS.COST > 0 THEN ROUND (EVENTS.COST, 2) ELSE NULL END
            INCOME,
         CASE WHEN EVENTS.COST < 0 THEN ROUND (EVENTS.COST, 2) ELSE NULL END
            OUTCOME,
         EVENTS.BALANCE,
         EVENTS.EVENT,
         EVENTS.NOTE
    FROM (SELECT                                                      --������
                DB_LOADER_ACCOUNT_PHONE_HISTS.PHONE_NUMBER,
                 'STATUS' AS EVENT_CODE,
                 DB_LOADER_ACCOUNT_PHONE_HISTS.BEGIN_DATE AS EVENT_DATE,
                 TO_NUMBER (NULL) COST,
                 TO_NUMBER (NULL) BALANCE,
                 '����� �������' EVENT,
                 CASE
                    WHEN DB_LOADER_ACCOUNT_PHONE_HISTS.PHONE_IS_ACTIVE = 1
                    THEN
                          '�������, ����� '
                       || DB_LOADER_ACCOUNT_PHONE_HISTS.CELL_PLAN_CODE
                    ELSE
                       '����������'
                 END
                    AS NOTE
            FROM DB_LOADER_ACCOUNT_PHONE_HISTS
          /*
          UNION ALL
          SELECT --����������� ������� (������ ������� � �����)
            ABONENT_BALANCE_ROWS.ROW_DATE BEGIN_DATE,
            ABONENT_BALANCE_ROWS.ROW_COMMENT ACTION,
            '���������: '||ABONENT_BALANCE_ROWS.ROW_COST NOTE
          FROM ABONENT_BALANCE_ROWS
          WHERE ABONENT_BALANCE_ROWS.ROW_COST > 0
          UNION ALL
          SELECT
            ABONENT_BALANCE_ROWS.ROW_DATE BEGIN_DATE,
            ABONENT_BALANCE_ROWS.ROW_COMMENT ACTION,
            '���������: '||-ABONENT_BALANCE_ROWS.ROW_COST NOTE
          FROM ABONENT_BALANCE_ROWS
          WHERE ABONENT_BALANCE_ROWS.ROW_COST < 0
          */
          UNION ALL
          SELECT                                                --����/�������
                t.phone_number,
                 CASE ticket_type
                    WHEN 15
                    THEN                       -- �����������/���������� �����
                       (SELECT CASE
                                  WHEN TARIFF_OPTIONS_REQ_LOG.INCLUSION_TYPE =
                                          'A'
                                  THEN
                                     'OPTION_TURN_ON'
                                  ELSE
                                     'OPTION_TURN_OFF'
                               END
                          FROM TARIFF_OPTIONS_REQ_LOG
                         WHERE     TARIFF_OPTIONS_REQ_LOG.REQUEST_ID =
                                      TO_CHAR (t.TICKET_ID)
                               AND ROWNUM <= 1)
                    WHEN 9
                    THEN
                       'BLOCK'
                    WHEN 10
                    THEN
                       'UNLOCK'
                    ELSE
                       'TICKET'
                 END
                    AS ACTION_TYPE,
                 t.date_create begin_date,
                 TO_NUMBER (NULL) COST,
                 TO_NUMBER (NULL) BALANCE,
                 CASE
                    WHEN ticket_type = 15
                    THEN                       -- �����������/���������� �����
                       (SELECT CASE
                                  WHEN TARIFF_OPTIONS_REQ_LOG.INCLUSION_TYPE =
                                          'A'
                                  THEN
                                        '����������� ������ '
                                     || TARIFF_OPTIONS_REQ_LOG.OPTION_CODE
                                  ELSE
                                        '���������� ������ '
                                     || TARIFF_OPTIONS_REQ_LOG.OPTION_CODE
                               END
                          FROM TARIFF_OPTIONS_REQ_LOG
                         WHERE     TARIFF_OPTIONS_REQ_LOG.REQUEST_ID =
                                      TO_CHAR (t.TICKET_ID)
                               AND ROWNUM <= 1)
                    WHEN ticket_type = 9
                    THEN                                         -- ����������
                          '������� ������������'
                       || (SELECT ' �� ����������'
                             FROM queue_phone_reblock_log
                            WHERE ticked_lock_id = t.ticket_id)
                    WHEN ticket_type = 10
                    THEN                                         -- ����������
                          '������� ���������������'
                       || (SELECT ' (��� ����� �� ����������)'
                             FROM queue_phone_reblock_log
                            WHERE ticked_unlock_id = t.ticket_id)
                    ELSE
                          '������� '
                       || NVL (
                             (SELECT ticket_type_name
                                FROM beeline_ticket_types
                               WHERE beeline_ticket_types.ticket_type_id =
                                        t.ticket_type),
                             '???')
                 END
                    action,
                    TO_CHAR (T.USER_CREATED)
                 || ', ������ '
                 || TO_CHAR (t.TICKET_ID)
                 || ' '
                 || DECODE (NVL (t.answer, '-1'),
                            '-1', '�� ���������',
                            '0', '���������',
                            '1', '���������',
                            '����')
                 || '. '
                 || t.comments
                    note
            FROM beeline_tickets t
          UNION ALL
          SELECT                                            --������������ ���
                SMS_LOG.PHONE,
                 'SMS' AS ACTION_TYPE,
                 nvl(SEND_DATE, DATE_START) BEGIN_DATE,
                 TO_NUMBER (NULL) COST,
                 TO_NUMBER (NULL) BALANCE,
                    'SMS '
                 || DECODE (STATUS,
                            'DELIVERED', '����������',
                            '������: ' || STATUS),
                 MESSAGE NOTE
            FROM SMS_LOG
          --
          UNION ALL
          SELECT                                           --������������ USSD
                USSD_LOG.MSISDN,
                 'USSD' AS ACTION_TYPE,
                 USSD_DATE BEGIN_DATE,
                 TO_NUMBER (NULL) COST,
                 TO_NUMBER (NULL) BALANCE,
                 'USSD: ' || USSD,
                 TEXT_RES
            FROM USSD_LOG
           WHERE USSD IS NOT NULL
          --
          UNION ALL
          SELECT                                         --����������� �������
                PHONE_NUMBER,
                 'AUTOROAMING_ON' AS ACTION_TYPE,
                 BEGIN_DATE_TIME BEGIN_DATE,
                 TO_NUMBER (NULL) COST,
                 TO_NUMBER (NULL) BALANCE,
                 '����������� �������' ACTION,
                    '������ �� �����������: '
                 || SERVICE_ON_TICKET_ID
                    AS NOTE
            FROM ROAMING_RETARIF_PHONES
          UNION ALL
          SELECT                                        --����������� ��������
                PHONE_NUMBER,
                 'AUTOROAMING_OFF' AS ACTION_TYPE,
                 END_DATE_TIME,
                 TO_NUMBER (NULL) COST,
                 TO_NUMBER (NULL) BALANCE,
                 '����������� ��������' ACTION,
                    '������ �� ����������: '
                 || SERVICE_OFF_TICKET_ID
                    AS NOTE
            FROM ROAMING_RETARIF_PHONES
          -- ������� �������
          UNION ALL
          SELECT PHONE_NUMBER,
                 'PAYMENT' AS ACTION_TYPE,
                 REAL_CREATED_AT,
                 PAYMENT_SUM COST,
                 TO_NUMBER (NULL) BALANCE,
                    '������: '
                 || PAYMENT_REMARK
                 || ' �� '
                 || TO_CHAR (PAYMENT_DATE, 'DD.MM.YYYY'),
                 TO_CHAR (PAYMENT_SUM) || ' ���.'
            FROM V_FULL_BALANCE_PAYMENTS
           WHERE PAYMENT_TYPE <> 3              -- ��������� ������� ���������
          --
          -- ������� "�� �����", ���������� ��������
          --
          UNION ALL
          SELECT RECEIVED_PAYMENTS.PHONE_NUMBER,
                 'PAYMENT_STOPPED_ON_BILL',
                 ACCOUNT_LOADED_BILLS.DATE_LAST_UPDATE AS CREATED_DATE,
                 -RECEIVED_PAYMENTS.PAYMENT_SUM COST,
                 TO_NUMBER (NULL) BALANCE,
                 '������������� � ����� ���������� ��������',
                    -RECEIVED_PAYMENTS.PAYMENT_SUM
                 || ' ���. �� '
                 || TO_CHAR (RECEIVED_PAYMENTS.DATE_CREATED,
                             'DD.MM.YYYY HH24:MI:SS')
            FROM RECEIVED_PAYMENTS,
                 DB_LOADER_FULL_FINANCE_BILL,
                 ACCOUNT_LOADED_BILLS
           WHERE     IS_CONTRACT_PAYMENT = 0 -- ����� �������� � ������ ���������� ��������
                 AND REVERSESCHET = 1
                 AND DB_LOADER_FULL_FINANCE_BILL.PHONE_NUMBER =
                        RECEIVED_PAYMENTS.phone_number
                 AND DB_LOADER_FULL_FINANCE_BILL.YEAR_MONTH =
                        TO_NUMBER (
                           TO_CHAR (RECEIVED_PAYMENTS.PAYMENT_DATE_TIME,
                                    'yyyymm'))
                 AND ACCOUNT_LOADED_BILLS.ACCOUNT_ID =
                        DB_LOADER_FULL_FINANCE_BILL.ACCOUNT_ID
                 AND ACCOUNT_LOADED_BILLS.YEAR_MONTH =
                        DB_LOADER_FULL_FINANCE_BILL.YEAR_MONTH
                 AND ACCOUNT_LOADED_BILLS.LOAD_BILL_IN_BALANCE = 1
          -- ������� ��������� ������ �����������
          UNION ALL
          SELECT phone_number,
                 'PROMISED_PAYMENT_ON' AS ACTION_TYPE,
                 DATE_CREATED,
                 promised_sum,
                 TO_NUMBER (NULL) BALANCE,
                    '��������� ������ �� '
                 || TO_CHAR (payment_date, 'dd.mm.yyyy'),
                    TO_CHAR (promised_sum)
                 || ' �. ��������� �� '
                 || TO_CHAR (PROMISED_DATE_END, 'dd.mm.yyyy')
            FROM promised_payments
          -- ������� ��������� ��������� �����������
          UNION ALL
          SELECT phone_number,
                 'PROMISED_PAYMENT_OFF' AS ACTION_TYPE,
                 PROMISED_DATE,
                 -PROMISED_SUM,
                 TO_NUMBER (NULL) BALANCE,
                    '���������� ��������� ������ �� '
                 || TO_CHAR (payment_date, 'dd.mm.yyyy'),
                 TO_CHAR (promised_sum)
            FROM promised_payments
          UNION ALL
          -- ������
          SELECT contracts.phone_number_federal,
                 'BALANCE_ROW',
                 BALANCE.ROW_DATE,
                 BALANCE.ROW_COST,
                 TO_NUMBER (NULL) BALANCE,
                 BALANCE.DESCRIPTION,
                 TO_CHAR (ROUND (BALANCE.ROW_COST, 2)) || ' ���.'
            FROM CONTRACTS,
                 TABLE (
                    CALC_BALANCE_ROWS_TABLE_BY_DAY (
                       contracts.phone_number_federal)) BALANCE
           WHERE     CONTRACTS.CONTRACT_DATE =
                        (SELECT MAX (C2.CONTRACT_DATE)
                           FROM CONTRACTS C2
                          WHERE C2.PHONE_NUMBER_FEDERAL =
                                   CONTRACTS.PHONE_NUMBER_FEDERAL)
                 AND BALANCE.DESCRIPTION NOT LIKE '������:%' -- ������ ������� ��������
          UNION ALL
          -- ����� �������
          SELECT contracts.phone_number_federal,
                 'NEW_CONTRACT',
                 CONTRACTS.CONTRACT_DATE,
                 TO_NUMBER (NULL) COST,
                 TO_NUMBER (NULL) BALANCE,
                 '����� �������',
                 '���: ' || CONTRACTS.CONTRACT_ID
            FROM CONTRACTS
           WHERE CONTRACTS.CONTRACT_DATE =
                    (SELECT MAX (C2.CONTRACT_DATE)
                       FROM CONTRACTS C2
                      WHERE C2.PHONE_NUMBER_FEDERAL =
                               CONTRACTS.PHONE_NUMBER_FEDERAL)
          UNION ALL
          -- ��������� ���������
          SELECT contracts.phone_number_federal,
                 'CONTRACT_CHANGE',
                 CONTRACT_CHANGES.DATE_CREATED,
                 TO_NUMBER (NULL) COST,
                 TO_NUMBER (NULL) BALANCE,
                 DOCUM_TYPES.DOCUM_TYPE_NAME,
                 TARIFFS.TARIFF_NAME
            FROM CONTRACTS,
                 CONTRACT_CHANGES,
                 DOCUM_TYPES,
                 TARIFFS
           WHERE     CONTRACTS.CONTRACT_ID = CONTRACT_CHANGES.CONTRACT_ID
                 AND CONTRACTS.CONTRACT_DATE =
                        (SELECT MAX (C2.CONTRACT_DATE)
                           FROM CONTRACTS C2
                          WHERE C2.PHONE_NUMBER_FEDERAL =
                                   CONTRACTS.PHONE_NUMBER_FEDERAL)
                 AND CONTRACT_CHANGES.DOCUM_TYPE_ID =
                        DOCUM_TYPES.DOCUM_TYPE_ID
                 AND TARIFFS.TARIFF_ID(+) = CONTRACT_CHANGES.TARIFF_ID
          --
          -- ����� �/�����
          --
          UNION ALL
          SELECT ACCS.phone_number,
                 'ACCOUNT_CHANGED',
                 ACCS.account_date,
                 TO_NUMBER (NULL) COST,
                 TO_NUMBER (NULL) BALANCE,
                 '����� �������� �����',
                    ACCOUNTS_PREV.account_number
                 || ' ('
                 || ACCOUNTS_PREV.company_name
                 || ')'
                 || ' => '
                 || ACCOUNTS.account_number
                 || ' ('
                 || ACCOUNTS.company_name
                 || ')'
            FROM (SELECT ACCOUNT_DATE,
                         ACCOUNT_ID,
                         LAG (
                            ACCOUNT_ID,
                            1)
                         OVER (PARTITION BY PHONE_NUMBER
                               ORDER BY ACCOUNT_DATE)
                            PREV_ACCOUNT_ID,
                         PHONE_NUMBER,
                         SOURCE
                    FROM V_PHONE_ACCOUNT_HISTORY) ACCS,
                 ACCOUNTS,
                 ACCOUNTS ACCOUNTS_PREV
           WHERE     ACCS.account_id <> ACCS.prev_account_id
                 AND ACCOUNTS.account_id = ACCS.account_id
                 AND ACCOUNTS_PREV.account_id = ACCS.prev_account_id
          --
          -- ������� ��������
          --
          UNION ALL
          SELECT CONTRACTS.PHONE_NUMBER_FEDERAL,
                 'BALANCE_FIX',
                 IOT_BALANCE_HISTORY.START_TIME,
                 TO_NUMBER (NULL) COST,
                 IOT_BALANCE_HISTORY.BALANCE,
                 '������������ ������',
                 TO_CHAR (IOT_BALANCE_HISTORY.BALANCE) || ' ���.'
            FROM CONTRACTS, IOT_BALANCE_HISTORY
           WHERE     CONTRACTS.CONTRACT_DATE =
                        (SELECT MAX (C2.CONTRACT_DATE)
                           FROM CONTRACTS C2
                          WHERE C2.PHONE_NUMBER_FEDERAL =
                                   CONTRACTS.PHONE_NUMBER_FEDERAL)
                 AND IOT_BALANCE_HISTORY.PHONE_NUMBER =
                        TO_NUMBER (CONTRACTS.PHONE_NUMBER_FEDERAL)
                 AND IOT_BALANCE_HISTORY.START_TIME >= SYSDATE - 60) EVENTS,
         CONTRACTS,
         EVENT_DESCRIPTIONS
   WHERE     EVENTS.PHONE_NUMBER = CONTRACTS.PHONE_NUMBER_FEDERAL
         AND CONTRACTS.CONTRACT_DATE =
                (SELECT MAX (C2.CONTRACT_DATE)
                   FROM CONTRACTS C2
                  WHERE C2.PHONE_NUMBER_FEDERAL =
                           CONTRACTS.PHONE_NUMBER_FEDERAL)
         AND EVENT_DESCRIPTIONS.EVENT_CODE(+) = EVENTS.EVENT_CODE
         AND EVENTS.EVENT_DATE >= CONTRACTS.CONTRACT_DATE - 10
         and EVENTS.PHONE_NUMBER = '9057322888'
  order by events.event_date desc         


GRANT SELECT ON V_ABONENT_EVENTS TO LONTANA_ROLE;

GRANT SELECT ON V_ABONENT_EVENTS TO LONTANA_ROLE_RO;
