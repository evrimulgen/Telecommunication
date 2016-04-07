--DROP TABLE CALL_STAT_PAY_TRAFFIC CASCADE CONSTRAINTS;
CREATE TABLE CALL_STAT_PAY_TRAFFIC
(
  PHONE_NUMBER_FEDERAL           VARCHAR2(10 CHAR) NOT NULL,
  YEAR_MONTH                     NUMBER NOT NULL, 
  OTHER_CITY_COST                NUMBER,
  OTHER_CITY_DURATION_MINUTE     NUMBER,
  OTHER_COUNTRY_COST             NUMBER,
  OTHER_COUNTRY_DURATION_MINUTE  NUMBER,
  LOCAL_COST                     NUMBER,
  LOCAL_DURATION_MINUTE          NUMBER,
  ROUMING_COST                   NUMBER,
  ROUMING_DURATION_MINUTE        NUMBER,
  MESSAGES_COST                  NUMBER,
  MESSAGES_COUNT                 NUMBER  
);

comment on table CALL_STAT_PAY_TRAFFIC is '���������� ������� ��� ������ �� �������� �������'; 
comment on column CALL_STAT_PAY_TRAFFIC.PHONE_NUMBER_FEDERAL IS '����� ��������'; 
comment on column CALL_STAT_PAY_TRAFFIC.OTHER_CITY_COST IS '��������� ������������� �������'; 
comment on column CALL_STAT_PAY_TRAFFIC.OTHER_CITY_DURATION_MINUTE IS '������������ ������������� �������'; 
comment on column CALL_STAT_PAY_TRAFFIC.OTHER_COUNTRY_COST IS '��������� ������������� �������'; 
comment on column CALL_STAT_PAY_TRAFFIC.OTHER_COUNTRY_DURATION_MINUTE IS '������������ ������������� �������'; 
comment on column CALL_STAT_PAY_TRAFFIC.LOCAL_COST IS '��������� ������� �������'; 
comment on column CALL_STAT_PAY_TRAFFIC.LOCAL_DURATION_MINUTE IS '������������ ������� �������'; 
comment on column CALL_STAT_PAY_TRAFFIC.ROUMING_COST IS '��������� ����������� �������'; 
comment on column CALL_STAT_PAY_TRAFFIC.ROUMING_DURATION_MINUTE IS '������������ ����������� �������'; 
comment on column CALL_STAT_PAY_TRAFFIC.MESSAGES_COST IS '��������� ���'; 
comment on column CALL_STAT_PAY_TRAFFIC.MESSAGES_COUNT IS '���������� ���';

CREATE INDEX CALL_STAT_PAY_TRAFFIC_PHONE ON CALL_STAT_PAY_TRAFFIC ( PHONE_NUMBER_FEDERAL );

CREATE INDEX CALL_STAT_PAY_TRAF_YEAR_MONTH ON CALL_STAT_PAY_TRAFFIC ( YEAR_MONTH );

