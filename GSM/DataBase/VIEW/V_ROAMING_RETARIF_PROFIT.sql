CREATE OR REPLACE VIEW V_ROAMING_RETARIF_PROFIT AS
select
--#Version=4
-- ���������� ������ �� ��������������� �����.
-- �������� ��������� ������ �� ������� ���,
-- �� ������ ��� ���� ������������ ������� �������, � � ������ �� ������� ���������� �� ������� �������.
--
-- 4. ������. ������� � ������� ������� ���
-- 3. ������. ������� ����� ������� ��������  (� �����)
-- 2. ������. ��������� ������ ����������� ����� � ����������.
--
  PROFIT.D DAY, 
  FULL_COST,
  OPTIONS_PROFIT,
  CHARGES.CHARGES_SUM,
  CHARGES.TURNED_ON TURNED_ON_COUNT,
  CHARGES.TURNED_OFF TURNED_OFF_COUNT,
  CHARGES.CNT ACTIVE_ABONENT_COUNT,
  OPTIONS_PROFIT-CHARGES.CHARGES_SUM SUMMARY_PROFIT,
  ROUND(LOAD_DELAY*24, 1) LOAD_DELAY_HOUR
from 
  ( -- ������ ������� �� �������, ��������� �� ����
select 
  SUM(DECODE(c.SERVICETYPE, 'C', c.call_cost, 0)) FULL_COST, 
  SUM(trunc(c.cost_chng, 2)) OPTIONS_PROFIT,
  TRUNC(C.START_TIME) D,
  AVG(C.INSERT_DATE-C.START_TIME) LOAD_DELAY
from 
  (select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_07_2014
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_08_2014
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_09_2014
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_10_2014
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_11_2014
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_12_2014
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_01_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_02_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_03_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_04_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_05_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_06_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_07_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_08_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_09_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_10_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_11_2015
  UNION ALL
  select SUBSCR_NO, CALL_COST, START_TIME, COST_CHNG, SERVICETYPE, INSERT_DATE from CALL_12_2015) C, 
  ROAMING_RETARIF_PHONES
where 
  c.subscr_no(+) = ROAMING_RETARIF_PHONES.phone_number
  AND ROAMING_RETARIF_PHONES.ROAMING_RETARIF_METHOD=1 /* ������ � ���������� */
  and (c.start_time(+) between ROAMING_RETARIF_PHONES.BEGIN_DATE_TIME and nvl(ROAMING_RETARIF_PHONES.END_DATE_TIME, sysdate))
GROUP BY
  TRUNC(C.START_TIME) 
ORDER BY TRUNC(C.START_TIME) desc
  ) PROFIT,
( -- ��������� ������� �� ������ ���� ��� ������ ������ �������
  select
  DAYS.the_day D,
  sum(5) CHARGES_SUM, -- ��������� 5 ������ � ����
  count(*) CNT,
  SUM(CASE WHEN DAYS.the_day = TRUNC(ROAMING_RETARIF_PHONES.BEGIN_DATE_TIME) THEN 1 ELSE 0 END) TURNED_ON,
  SUM(CASE WHEN DAYS.the_day = TRUNC(ROAMING_RETARIF_PHONES.END_DATE_TIME) THEN 1 ELSE 0 END) TURNED_OFF
from 
  ROAMING_RETARIF_PHONES, 
  ( -- ��� ����� ������ ������� ������ ��� ��� �������� ���� (� 1 ������ �� 31 �������)
    select trunc(sysdate, 'YYYY') + (level-1) as the_day
    from dual
    connect by level <= to_number(to_char(last_day(add_months(trunc(sysdate, 'YYYY'),11)), 'DDD'))
    UNION
    select trunc(ADD_MONTHS(sysdate, -12), 'YYYY') + (level-1) as the_day
    from dual
    connect by level <= to_number(to_char(last_day(add_months(trunc(ADD_MONTHS(sysdate, -12), 'YYYY'),11)), 'DDD'))
  ) DAYS 
where 
  (DAYS.the_day between TRUNC(ROAMING_RETARIF_PHONES.BEGIN_DATE_TIME) and TRUNC(nvl(ROAMING_RETARIF_PHONES.END_DATE_TIME, sysdate)))
  AND ROAMING_RETARIF_PHONES.ROAMING_RETARIF_METHOD=1 /* ������ � ���������� */
GROUP BY
  DAYS.the_day) CHARGES
where 
  PROFIT.D=CHARGES.D
/