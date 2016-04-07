DROP MATERIALIZED VIEW LONTANA.V_MONITOR_STRINGS_MAT;
CREATE MATERIALIZED VIEW LONTANA.V_MONITOR_STRINGS_MAT (DAT,ERR,COLOR)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH COMPLETE
START WITH TO_DATE('20-���-2014 09:35:07','dd-mon-yyyy hh24:mi:ss')
NEXT SYSDATE + NUMTODSINTERVAL(5, 'MINUTE')   
WITH PRIMARY KEY
AS 
/* Formatted on 20.02.2014 9:34:39 (QP5 v5.227.12220.39754) */
WITH KOL_SMS
     AS (SELECT COUNT (*) SMS, MAX (date_send) sms_date
           FROM log_send_sms
          WHERE TRUNC (date_send) = TRUNC (SYSDATE) AND note IS NULL)
SELECT '���������� ������������ ��� � ����, ����� ��������� ���',
          '�����: '
       || TO_CHAR (sms)
       || '. ��������� ������������ ���: '
       || TO_CHAR (sms_date, 'HH24:mi'),
       CASE
          WHEN (SMS < 2000) AND (sms_date > (SYSDATE - 10 / 1440))
          THEN
             'GREEN'
          WHEN (    (SMS > 2000)
                AND (SMS < 10000)
                AND (sms_date > (SYSDATE - 40 / 1440)))
          THEN
             'YELLOW'
          ELSE
             'RED'
       END
          color
  FROM KOL_SMS
UNION ALL
SELECT "DAT", "ERR", "COLOR"
  FROM (WITH BLOCKED_PHONES
             AS (SELECT COUNT (*) blocked,
                        MAX (block_date_time) last_time_block
                   FROM auto_blocked_phone ab, db_loader_account_phones dba
                  WHERE     TRUNC (block_date_time) = TRUNC (SYSDATE)
                        AND note LIKE '%�%'
                        AND DBA.PHONE_NUMBER(+) = AB.PHONE_NUMBER
                        AND dba.account_id <> 93
                        AND DBA.YEAR_MONTH = TO_CHAR (SYSDATE, 'yyyymm'))
        SELECT '���������� ������������� ������� � ����, ����� ��������� ����������'
                  Dat,
                  '����� '
               || TO_CHAR (blocked)
               || ' . ��������� ����������: '
               || TO_CHAR (last_time_block, 'HH24:mi')
                  ERR,
               CASE
                  WHEN blocked < 2000 THEN 'GREEN'
                  WHEN ( (blocked > 2000) AND (blocked < 3000)) THEN 'YELLOW'
                  ELSE 'RED'
               END
                  color
          FROM BLOCKED_PHONES)
UNION ALL
SELECT "DAT", "ERR", "COLOR"
  FROM (WITH UNBLOCKED_PHONES
             AS (SELECT COUNT (*) unblocked,
                        MAX (unblock_date_time) last_time_unblock
                   FROM auto_unblocked_phone ab, db_loader_account_phones dba
                  WHERE     TRUNC (unblock_date_time) = TRUNC (SYSDATE)
                        AND note LIKE '%�%'
                        AND DBA.PHONE_NUMBER(+) = AB.PHONE_NUMBER
                        AND dba.account_id <> 93
                        AND DBA.YEAR_MONTH = TO_CHAR (SYSDATE, 'yyyymm'))
        SELECT '���������� ���������������� ������� � ���� ����� ����������, ����� ��������� ����������'
                  Dat,
                  '����� '
               || TO_CHAR (unblocked)
               || ' . ��������� �������������: '
               || TO_CHAR (last_time_unblock, 'HH24:mi')
                  ERR,
               CASE
                  WHEN unblocked < 2000
                  THEN
                     'GREEN'
                  WHEN ( (unblocked > 2000) AND (unblocked < 3000))
                  THEN
                     'YELLOW'
                  ELSE
                     'RED'
               END
                  color
          FROM UNBLOCKED_PHONES);


COMMENT ON MATERIALIZED VIEW LONTANA.V_MONITOR_STRINGS_MAT IS 'snapshot table for snapshot LONTANA.V_MONITOR_STRINGS_MAT';

CREATE OR REPLACE SYNONYM CRM_USER.V_MONITOR_STRINGS_MAT FOR LONTANA.V_MONITOR_STRINGS_MAT;

GRANT SELECT ON LONTANA.V_MONITOR_STRINGS_MAT TO CRM_USER;
