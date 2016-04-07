CREATE OR REPLACE PACKAGE BEELINE_REST_API_PCKG AS
--
--Version=57
--
--v.57 �������� 2016.03.15 ������� ���������� �� �������� ������� �� �������. ��������� ��������� ��������� � �������:
--                                       - check_all_phone_flow, check_all_phone_tariff, all_phone_get_rest, all_phone_check_turn_tariff, all_phone_calc_traff, all_phone_init_new_month.
--v.56 �������� 2016.02.08 ���� ��������� � gprs_check_turn_tariff. ���� � ������ ������ GPRS_20G � GPRS_30G �� ���������� �����������
--v.55 �������� 2016.02.02 ���� ��������� � rep_gprs_autoturn_mon � rep_gprs_autoturn_prev � Trow_rep_gprs_autoturn_1. ������� ���� �� GPRS_20G � GPRS_30G.
--v.54 �������� 2016.02.01 ���� ��������� � drave_check_turn_tariff. ������ ������� �� ������ ������� (nvl(v_rec(3).currvalue,0)>nvl(v_rec(2).currvalue,0)) or 
--                                       ���� ��������� � gprs_check_turn_tariff. ���� ��� ����������� ������ ����� GPRS_U � ������ ��������� � ������������, �� ������ �� ���������� � ������� �� ���������.
--v.53 �������� 2016.01.28 ������� ��������� gprs_opts_turn_off_phons_err- ���������� ��������-����� � ����� ������ �� �������� �������, �� ������� ���� ������ ����������.
--v.52 �������� 2015.12.28 ���� ��������� � gprs_check_phone_flow. �������� ���������� ������� �� 10 (c_STREAM_COUNT = 10)
--v.51 �������� 2015.12.14 ���� ��������� � rep_gprs_autoturn_prev. ������� exception.
--v.50 �������� 2015.11.30 �������� ���������� ������� gprs_opts_turn_off_all_phones ������������� �� ������. ������� ��������� ������ � ���������� �������.
--v.49 �������� 2015.11.26 ��������� ������ ��������� �� ������ �� ������� ��� ����� �������� ������ (��������� ������� �����).
--                                       ������ �� ������� ������ ��������� � ������� PHONE_CALC_ABON_TP_UNLIM_ON.
--v.48 �������� 2015.11.16 ���� ��������� � gprs_check_turn_tariff, � ������ ������ ������ ��� �����������.
--                                       ��� ���� ����������� 2 � 3, ������� ��������� � ��������� ������������ ��������, ����� ��� ������, ��������� ��� ����� �����������.
--                                       ����� ������������ ��������� ����� ����������� ������ ������ �� ������ �����. GPRS_U � ������� �����. �� ����� ������. ����� ����� � ���������� ������.
--                                       ���� ����� 20 �� ���. 3 ����, �� ���. GPRS_U. ���� ����� 30 �� ���. 2 ����, �� ���. GPRS_U.
--v.47 �������� 2015.10.08 ���� ��������� � check_alien_opts. � ������� ���������� �������� ������, �.�. �� ������ ����� ����������� ��� �����, � �� ����� ���� ��� ��������� ����������.
--                                       �������� ��������� � ���, ��� ������ �� �������� ������� ���������� ����� � ��, � ��-�� ������ �������� (������������� ������ �� ���� ���) � ����� ������� �����������
--                                       �������� ���������� ����� ������ � � ����� ��� ����������� ��� ������. ������ �������������� ������� ����� ������ �� �������, � ��� ��������� ������ ��������� ������� �� � �������.
--v.46 �������� 2015.10.07 ���� ��������� � drave_check_turn_tariff. � ������� SMS_FOR_CONTRACT_PHONE_DRAVE � ���� VALUE_TRAFFIC ���������� �������� ������� � ��, ������������ �� ������.
--v.45 �������� 2015.10.07 ���� ��������� � drave_check_turn_tariff. ������� ������ ������ � ����. SMS_FOR_CONTRACT_PHONE_DRAVE, �.�. ���������� ���� �������.
--v.44 �������� 2015.10.01 ���� ��������� � drave_check_turn_tariff. ��� ���������� ������� ����� ��� �� 80 % ��� � 0, ������ ����������� � ����. SMS_FOR_CONTRACT_PHONE_DRAVE.
--                                       � ������ ����. �����. ������ � �� "�����" �� ���������� ������ ������� �������. �����. ���
--v.43 �������� 2015.10.01 ���� ��������� � drave_check_turn_tariff. ������� ���� �������� ���. ����� �������� ������ ������� ������������� ��������.
--v.42 �������� 2015.09.24 ���� ��������� � drave_check_turn_tariff. ��� ���������� 0 �������, ������ � drave_turn_log ��������� �� �����, ��������� ���������� ���������� � drave_stat
--v.41 �������� 2015.09.24 ���� ��������� � drave_calc_traff. ���� ��� ����������� �������� ���������������� ������� �������� 0, �� ��� ��������, ��� � �������� ����� ����� ����� � 0.
--                                       ������ �������� ���������������� ������� ����� �������������� �������� ������� �� ������, � � �������� ������� ������� - ���� � ������ ������ ���� � ������� ��������� ��������.
--v.40 �������� 2015.09.24 ���� ��������� ������� drave_turn_log. ��������� ���� IS_SEND_SMS_ZERO_FIRST, IS_SEND_SMS_ZERO_SECOND, IS_SEND_SMS_PREV_FIRST, IS_SEND_SMS_PREV_SECOND.
--                                       � ����� � ��� ���� ���������� ������� � ���������� ������ �������. ����� ���� ������� ��������� � drave_check_turn_tariff.
--                                       ���, ������������ ��� ���������� ������� � 0 � ���������� 80%, �������� �� 2 ��� � ������ ����. ���������� ����. � ����������� �� ��� ������.
--                                       �� 23 ����� ���������� ���� ���, ����� - ������ ��� ���.
--v.39 �������� 2015.09.24 ���� ��������� � drave_get_rest. �������� ��������, ��� ��� ����� �� �� ������ � ������ �� ����� ������������ ������� �� ����� ��. 
--                                       ������� �������� �� ������������ ���. �� �� ������ ������ � ��������.
--v.38 �������� 2015.09.23 ���� ��������� � drave_check_turn_tariff. � �������� exception. ��� ���������� drave_turn_log ������� �� ��������� ������� ���. �������� �� ���. �����
--v.37 �������� 2015.09.21 ���� ��������� � drave_check_turn_tariff. ��� ������� ����������� �������� ������������ ��� ��������.
--                                       ���� �� ����������� �������� ������� �� ����, �� �� ������������� ����� ��������� �������� �������� �� ������.
--                                       �������� ������ ������. � �������� ������� �������� �������� ������������� sysdate+10 ���.
--v.36 �������� 2015.09.04 ���� ��������� � drave_get_rest, drave_check_phone_tariff. �������� ������� �� ������ ������ �� �������� �������
--v.35 �������� 2015.09.04 ���� ������ � drave_check_turn_tariff. ��� ����������� ����� ��������� ������� ���. �������� �� ��� ������� �����������.
--v.34 �������� 2015.09.03 ������� ��������� drave_init_new_month. ������������� ������ ������, �.�. �������� ������ �������� ������ �� ������ drave_stat, drave_turn_log � ������ �� � ������� �������.
--v.33 �������� 2015.09.03 ������� ������� drave_check_turn_tariff. �������� ������� �������� �������� �� ������ ����� � �������� ��� ��� ������� ����������� ��������
--                                       �������� ������� drave_check_phone_tariff. ������ ������ � ������� drave_check_turn_tariff.
--v.32 �������� 2015.09.02 �������� drave_calc_traff. ������� ��������� ������. ������ ������� ��������� �������������� ������, ������� ������� �������� �� ����� ������
--v.31 �������� 2015.09.02 �� drave_stat ���� ������� ���� prevvalue. �������� ������� � ������ ������� (������� drave_get_rest)
--v.30 �������� 2015.09.02 ������� ������� drave_calc_traff, ������� ����������� �������������� ������ ��� ������� � ������� �����.
--v.29 �������� 2015.08.27 ���� ��������� � ������� gprs_check_turn_tariff. ���� ��� �������� ������� ������ ����� ��� �� ���������� �������� ������ ��������� ������
--                                       (������ �������� �� rest_api), �� ������������ �������� �� ������� DB_LOADER_ACCOUNT_PHONE_OPTS.
--v.28 �������� 2015.08.26 ������� ��������� drave_check_phone_flow. ������ ������������ ������� � ������� ����� � ������ (�� CONTRACTS).
--v.27 �������� 2015.08.26 ������� ��������� drave_check_phone_tariff, ������� ��������� ������ � ������� ����� �� ������������� ��������� ������� � ������� ����������� ��������
--v.26 �������� 2015.08.26 ������� ������� drave_get_rest, ������� ���������� ������� �� �������
--v.25 �������� 2015.08.26 ���� ��������� � ������� gprs_check_turn_tariff. �������� �������� ������� ������ ����� ��� �� ����������. ��������� ������. 
--                                       ������ ����. DB_LOADER_ACCOUNT_PHONE_OPTS ����� ���. ������� ��������� ����� �� rest_api - get_serviceList. 
--v.24 �������� 2015.08.14 ���� ��������� � ������� gprs_opts_turn_off. ������� ��������� ������ ��� ���������� ������.
--                                       ������ ����� ����������� �� ������������� �����, �.�. �� ������� � ������ '������', ����� ���������� �� ������ ERROR.
--v.23 �������� 2015.08.13 ���� ��������� � check_alien_opts. ����� �������� ����� �� ���. ���������� ������ ��������� ����� �����.
--v.22 �������� 2015.08.11 ���� ��������� � ������� gprs_check_turn_tariff.
--                                       ���� ������ �� �����., �� ������ � ����� ������ ��� ����� ������� � ���� � �� ����� ������ � ������� �� �����. � �������, �.�. �������� �� ����� �������� �� ���� �������
--                                       �� �����, ����� ���� ��� ������ �� �����. ������ �������� ����� ���������, � ����� �� ����������� � � ����� �� ������ ������ ������ �� ����
--v.21 �������� 2015.07.29 � ������� � 23 �� 00 ����� �� ������������ ��������� ����������, � ��������� ��� ��� - �� ��������� �����. ������. 
--                                       � ����� � ����, ���� ������ ������������� ���������� �� �����. ������� � 22:50 �� 00:10 ������ ����. ��������� ������ ������� �� ������� � ������� gprs_check_phone_flow.
--v.20 �������� 2015.07.24 ��������� ������ ��� ������ ������ ��� �����������. ������� ����������� ����� ������� ������ ����� ������ ������� GPRS_20GB � GPRS_30GB(���� ��� �����. 2 � 1 ��� ��������������) �����. GPRS_U.
--                                       �������� ������� gprs_check_turn_tariff.
--v.19 �������� 2015.07.20 ���������� ������� gprs_check_turn_tariff. ������ 3 �������� �� �����. ��������-�����. 
--                                      ����� �����. �������� �� 30 �., ����� ��������� ������� �� ����� � ������ ����� �� rest_api. ���� ������� ������ ��� �����., ����� - �� �����., ������� �����. ��� ���. � ��� �� 3-� �������
--v.18 �������� 2015.07.16 � ��������� check_alien_opts ����� ��������� ������� ������ ������ ������� �������� ������ ����� �� ������.
--v.17 ������� 2015.07.15 ������������ ������� mcBalance - ��������� ����� ���������� �����( ���) � �������, ���������� ��� ��.
--              
--  2015.07.13
--              - �������� ������� rep_gprs_autoturn_mon � rep_gprs_autoturn_prev. ������� ��� Trow_rep_gprs_autoturn_1. � ����� ��������� ���� �� ����� ������� GPRS20_GB � GPRS30_GB � MGN500MIN
--  2015.07.13
--              - �������� ������� gprs_check_turn_tariff. ���������� ������ ������ ������ ��� ����������� (����� �����. � ����������� �� ����� �����������)
--  2015.07.01
--              - ������� exception � ��������� gprs_check_phone_flow
--  2015.06.11
--              - ������� ��������� � ����� �� �����. ������� � ������� ������. �������� ������ �� ��� ��� �������, �� ������� ������� SPEED3B2B. ������� ��������� � ��� ������ ������
--  2015.06.10
--              - contracts ��������� �� v_contracts � ���������� ������� contract_cancel_date is null
--  2015.06.03
--              - ��� ������ �� ���������������� ������� ������ ����� ������������ ������ �������� ������ ����� �� ������ ����������� (��� � ���-�� ��������� �����)
--  2015.06.02
--              - � gprs_check_turn_tariff ������� ������ ��������� ������, ��� GPRS_U �������� ������� ������� ��������� ������ �� ����������� �� ����� ������
--              - � gprs_opts_turn_off ��������� �������� ��� ���������� �� ��������� ������� ������� � ��������� ����� �� �� ������������-������ 
--              - ��� ������ �� ���������������� ������� ������ ��������� ������������ �� ������� ������� � ������� ������� ���������� ������
--              - � gprs_check_turn_tariff ������� ������ ��������� ������, ��� GPRS_U �������� ������� ������� ��������� ������ ������ ������ �� ��-��������, � ��-������� � ����������� �� ���������� �������� ����� �����.
--              - ��� ������� �� ���������������� ������� ������ ��������� ������, ��� GPRS_U ��������� �������������� ����� ��������� ������� ����� ���� ������������� ������
--  2015.06.01
--              - ��� ������� �� ���������������� ������� ������ ��������� ������ GPRS_U, ��������� ��� ������ ����� �.�. ��������� �� ���� ��� 
--  2015.05.29
--              - ��� ������� �� ���������������� ������� ������ ��������� ������, ��� ���� ���.������� �������� ���� ����� �� �����������
--              - gprs_check_phone_flow - ��������� ����� ���������� ������� �� 5
--  2015.05.28
--              - � gprs_check_turn_tariff ������� ������ ��������� ������, ��� GPRS_U �������� ���� ����� �� ����������� [2015-05-28 11:17:57] ����
--              - ��� ������� �� ���������������� ������� ������ ��������� ������, ��� GPRS_U �������� ���� ����� �� �����������
--  2015.05.27
--              - � check_alien_opts �������� ������ �� ������ � ������������ �������
--              - � ����� ������� ����� �� ���������������� ����� � �������� GPRS_U ��������� ���� ���������� ����������� ���� �����.
--              - � gprs_check_turn_tariff ������� ������ ��������� ������ - ��������� nvl � ������� �� ����������� �������� DISKR_SPISANIE,
--              - � gprs_check_turn_tariff - OPERATOR_MONTHLY_COST � OPERATOR_TURN_ON_COST �������� �� MONTHLY_COST � TURN_ON_COST �������������� 
--  2015.05.26
--              - gprs_check_phone_tariff - �������� ������ ��� ������ ������� � �������������� ��������
--              - gprs_check_turn_tariff - ������� �������� ������� ����������� ��� ����������� ������
--                  1) ���������� ��� ������ � ������� ������� ����� ���������� ����������;
--                  2) �������������� ��������� ��������� �� �������� ������� ������� �� ����� ������; 
--                  3) �� ���������� ��������� �� �.2 � ���������� � �.1 ������� �������� ����������;
--                  4) ������������ ����������� ����� ��������������� ��������� ��������� � �.3
--              - ��������� ������� � ��������� (check_alien_opts, proc_alien_phone_opts) ��� �������� ���.����� ������������ ����������� (�������)
--              - � check_alien_opts ������ merge �� insert
--  2015.05.21  - ��� ������ �� ���������������� �� ������� ����� ������ ������ ������ ������������ ������� �� ������
--              - function  calc_traff - ������� � ��������� ������� ������� ������ ������������ ������� �� ������ � ������� �� ��� ��������������� (��� �������� � ������)
--  2015.05.19  - �������� ����� ��� ���� ���.������� ����������� ������� (500��)
--  2015.05.18  - ��������� ������� ������ ����������� � �������� �� ���������� � ���������, ����� ������ ������������� ��� ������ ������ ����� ���������� ������� ��� �� ����� �� �����
--                , ������ ����������� ������ ����������������� �������� ��� ������ ������� ������� ��������������� ������/������.
--  2015.05.15  -  ��������� ��������� gprs_check_phone_flow ��� ������� ��������� �������� ������� ��������� �������

-- ������� ��� �������� ������

-- ���� ��������
-- create table db_loader_resp_log (log_id number(10), load_date timestamp, phone varchar2(10), requestid number, code number(10), status varchar2(10), message varchar2(128), note varchar2(32));
-- create sequence db_loader_resp_log_id;
-- select LOG_ID,to_char(load_date,'YYYY-MM-DD HH24:mi:ss.ff3') load_date, phone, requestid, code, status,message from db_loader_resp_log;

-- Rests
-- create table db_loader_rests (rests_id number(38), load_date timestamp, phone varchar2(10 char), unitType varchar2(32 char), restType varchar2(16 char), initialSize number(18,2), currValue number(18,2), nextValue number(18,2), frequency varchar2(16 char), soc varchar2(16 char), socName varchar2(1024 char), restName varchar2(2048 char));
-- create sequence db_loader_rests_id;

-- Call Forward
-- create table db_loader_cfrw (cfrw_id number(10), load_date timestamp, requestid number(10), cfType varchar2(32));
-- create sequence db_loader_cfrw_id;

-- Subscribtions
-- create table db_loader_subs (subs_id number(10), load_date timestamp, phone varchar2(10), id varchar2(32), name varchar2(64), try_price number(12,2), buy_price number(12,2), buy_price_period number(10), start_date varchar2(32), end_free_date varchar2(32), end_date varchar2(32), try_buy_mode varchar2(16), provider_name varchar2(128), provider_contact varchar2(128), category varchar2(64), type varchar2(8));
-- create sequence db_loader_subs_id;

  type TRests is table of TInfoRest index by pls_integer;
  type TRestsMCBalance is table of TInfoRestMCBalance index by pls_integer; 
  
  type Trow_rep_gprs_autoturn_1 is record -- ��� ��� �������� ������ �� �������-������ "����� ��� ���������������� ���.�������"
    (
      PHONE           gprs_stat.phone%type,             -- ����� ��������
      CONTRACT_NUM    CONTRACTS.CONTRACT_NUM%type,      -- ����� ��������
      CONTRACT_DATE   CONTRACTS.CONTRACT_DATE%type,     -- ���� ��������
      IS_ACTIVE_WORD  varchar2(32),                     -- ������ (���������� ��� ��� - �����)
      IS_ACTIVE       TARIFFS.IS_ACTIVE%type,           -- ������ (���������� ��� ��� - �������)
      BEGIN_DATE      DB_LOADER_ACCOUNT_PHONE_HISTS.BEGIN_DATE%type, -- ���� �������
      DOP_STATUS      CONTRACT_DOP_STATUSES.DOP_STATUS_NAME%type,          -- ���. ������
      CURR_TARIFF_ID  CONTRACTS.CURR_TARIFF_ID%type,    -- �������� ���� ID
      TARIFF_CODE     TARIFFS.TARIFF_CODE%type,         -- �������� ���� ���
      TARIFF_NAME     TARIFFS.TARIFF_NAME%type,         -- �������� ���� ������������
      BALANCE         iot_current_balance.BALANCE%type, -- ������
      TARIFF          TARIFFS.MONTHLY_PAYMENT%type,     -- ����.����� �� ��������
      tariff_oper     number(18),                       -- ����.����� �� ������� �� �����
      FI550Z          number(18),                       -- FI550Z - ����� �� ��� ������
      FI850Z          number(18),                       -- FI850Z - ����� �� ��� ������
      FI1150Z         number(18),                       -- FI1150Z - ����� �� ��� ������
      FSG_TT1         number(18),
      FSG_TT2         number(18),
      FSG_TT3         number(18),
      GPRS_20GB     number(18),
      GPRS_30GB     number(18),
      GPRS_20G      number(18),
      GPRS_30G      number(18),
      GPRS_U          number(18),                       -- GPRS_U - ����� �� ��� ������
      GPRS_U_ON       date,                             -- ���� ���������� ����������� GPRS_U
      MGN500MIN    number(15,2),
      unknown         number(18),                       -- ����������� ������
      total_traff     number(18,2),                     -- ����� ������������ ������ ��������
      outcom_mi       number(18),                       -- ����� ���������� ��������� �����
      payments        number(18),                       -- ����� ���������� �� �����
      SPEED3B2B       number(18),                       -- SPEED3B2B - �����������, ���� ����������, ��������.
      SPEED3B2B_WORD  varchar2(32),                     -- SPEED3B2B - �����������, ���� ����������, ��������.
      DTM41           number(1)                         -- DTM41 - ���.�����-����������� �� ������� p2p-�������
    );
  type tbl_rep_gprs_autoturn_1 is table of Trow_rep_gprs_autoturn_1;

  type TRestStatus is record
    (
      phone               varchar2(10 char),
      status              varchar2(1 char),
      statusRsnCode       varchar2(64 char),
      statusDesc          varchar2(512 char)
    );
  type tbl_TRestStatus is table of TRestStatus;
    
  type TServiceList   -- ��� ��� ������ � ������������ �������  
    is record
       (
        name          varchar2(16),
        entityName    varchar2(128),
        entityDesc    varchar2(1024),
        rcRate        number(12,2) := 0,
        rcRatePeriod  varchar2(128),
        category      varchar2(128),
        sdbSize       number(12,2) := 0,
        viewInd       varchar2(16),
        removeInd     varchar2(16),
        effDate       varchar2(32),
        exprDate      varchar2(32)
       ); 
  type tbl_TServiceList is table of TServiceList;

--  constants      --------- BEGIN ---------------------------------------------------------------------------------------------

  beeline_protocol                constant varchar2(6)  :='https';
  beeline_domain                  constant varchar2(64) :='my.beeline.ru';
  beeline_auth_path               constant varchar2(64) :='/api/1.0/auth';
  info_rests_path                 constant varchar2(64) :='/api/1.0/info/rests';
  info_get_status_path            constant varchar2(64) :='/api/1.0/info/status';
  info_serviceList_path           constant varchar2(64) :='/api/1.0/info/serviceList';
  req_callForward_path            constant varchar2(64) :='/api/1.0/request/callForward';
  info_callForward_path           constant varchar2(64) :='/api/1.0/info/callForward';
  req_callForward_edt_path        constant varchar2(64) :='/api/1.0/request/callForward/edit';
  info_subscriptions_path         constant varchar2(64) :='/api/1.0/info/subscriptions';
  req_subscription_rmv_path       constant varchar2(64) :='/api/1.0/request/subscription/remove';
  info_get_balance                CONSTANT VARCHAR2 (23 char) := '/api/1.0/info/mcBalance';

  err_ok                          constant varchar2(5)  :='20000';
  
  c_turn_tariff_immediately       constant number       := 10;  -- (�����) ����� ����������� ��� �������������� ������� ������� �� ������ 
                                                                -- ��� ������� ����� ����������� ����������� ������������ �� ����� ����� 
  c_turn_tariff_checktime_min     constant number       := 10;  -- (�����), ����������� �������� �������� ���������� ������ ������� �� ������/������ 
  c_turn_tariff_checktime_max     constant number       := 60;  -- (�����), ������������ �������� �������� ���������� ������ ������� �� ������/������ 
  c_turn_tariff_ctrlpnt_inc       constant number       := 0.2; -- (%/100), ������� �� ������ ���������� ������� �� ������/������ ��� �������� ��������� 
                                                                -- ������ ���� ����� �������� �������� ������� ������� ����� (��� ��������� ��������) 
  c_errlvl_internet_initialsize   constant number       := 51200; -- ����� ������������� �������� �������� INTERNET �� ������, ��� ������� �������� ��������� ��������� � �������� �������������.
 -- c_errlvl_internet_initialsize   constant number       := 32768; -- ����� ������������� �������� �������� INTERNET �� ������, ��� ������� �������� ��������� ��������� � �������� �������������. 
  c_errlvl_voice_initialsize      constant number       := 12000; -- ����� ������������� �������� �������� VOICE �� ������, ��� ������� �������� ��������� ��������� � �������� �������������.                                                                
--   constants     ---------  END  ---------------------------------------------------------------------------------------------

  function intr_to_sec(p_time interval day to second) return number; -- ������� ��������� � ���� � �������

  function get_token(p_login varchar2, p_passwd varchar2) return varchar2;
  function get_data(purl in varchar2, phdr in varchar2) return clob;
  function get_resp_stat(code number, status varchar2, message varchar2, phone varchar2, requestid number, note varchar2, return_status number, p_req varchar2, p_data clob) return number;
  function info_rests(token varchar2, phash varchar2, pclient varchar2, ctn varchar2) return TRests;
  function req_callforward(token varchar2, phash varchar2, pclient varchar2, ctn varchar2) return number;
  function info_callforward(token varchar2, phash varchar2, pclient varchar2, ctn varchar2, requestid integer) return number;
  function req_callForward_edit(token varchar2, phash varchar2, pclient varchar2, ctn varchar2, CallFrwEdtReqDo varchar2) return number;
  function info_subscriptions(token varchar2, phash varchar2, pclient varchar2, ctn varchar2) return number;
  function req_subscriptions_remove(token varchar2, phash varchar2, pclient varchar2, ctn varchar2, subscriptionid varchar2, ptype varchar2) return number;

  function  gprs_check_turn_tariff(p_phone varchar2) return number; -- �������� ������� �������� �������� �� ������/������ � ����������� ������ ��� ������������� 
  function  gprs_get_rest (p_phone varchar2) return number; -- ��������� � ������ �������� �� ������ � gprs_stats, ��������� ������� ������ ��� ������������� �������/���.������� (���������� 1 ���� ������ ���� ���������)
  function  get_status(pPHONE_NUMBER varchar2) return tbl_TRestStatus pipelined; -- �������� ������ ������
  function  get_serviceList(pPHONE_NUMBER varchar2) return tbl_TServiceList pipelined;  -- �������� ������ ������������ �����
  procedure gprs_check_tariff_test(p_flow_code varchar2); -- ������ ������������ ���������� ������ GPRS_FLOWS (TEST)
  procedure gprs_check_tariff_all_test; -- ������ ������������ ���� ������� (TEST)
  procedure gprs_check_phone_all; -- ������ ������������ ���� ������� (�� CONTRACTS)
  procedure gprs_check_phone_flow(p_STREAM_ID integer); -- ������ ������������ ������� � ������ (�� CONTRACTS)
  procedure gprs_check_phone_tariff(p_phone varchar2); -- �������� �������� �� ������������� ��������� � ���������������
  procedure gprs_init_new_month; -- ������������� ������ ������
  function  gprs_opts_turn_off(p_phone varchar2, p_opts_code varchar2, p_note varchar2) return number; -- ��������� ����
  procedure gprs_opts_turn_off_all(p_phone varchar2, p_note varchar2); -- ��������� �� ����� ��������� ����� �� ��������� ������
  procedure gprs_opts_turn_off_all_phones(p_STREAM_ID integer, p_STREAM_COUNT integer); -- ��������� ��� ���.�����, ����� ��������� �����, �� ���� �������
  procedure gprs_opts_turn_off_phone_err; --��������� ��� ���. �����, ����� ��������� �����, �� �������, �� ������� ���� ������ ���������� � ����� ������
  
  type t_calc_traff is record
    (
      total_traff number(24)    := 0,
      total_sec   number(24,3)  := 0
    );   
  type tbl_calc_traff is table of t_calc_traff;  
  function  calc_traff(p_phone varchar2)  return tbl_calc_traff pipelined; -- ������ ���������������� ������� � ������������ �� ��� �������

  procedure check_alien_opts(p_STREAM_ID integer); -- �������� ���.����� ������������ ������������ �� ��������� �����������
  procedure proc_alien_phone_opts(rec_al gprs_alien_opts%rowtype); -- ���������� ����� ����� � ������
  
  function rep_gprs_autoturn_mon(p_phone varchar2 default null) return tbl_rep_gprs_autoturn_1 pipelined; -- ����� �������. ������������ �� ������� ����� �� ������ ��������.
                                                                                                          -- (���� �� �������� �������� ������ ������ �� ���� �������)
  function rep_gprs_autoturn_prev(p_phone varchar2 default null, p_year_month varchar2 default null) return tbl_rep_gprs_autoturn_1 pipelined;-- ����� �������. ������������ �� ��������� ������
  
  FUNCTION mcBalance (pToken     VARCHAR2,
                      pUuid      VARCHAR2,
                      phash      VARCHAR2,
                      ctn        VARCHAR2)
      RETURN TRestsMCBalance;  --��������� ����� ���������� �����( ���) � �������, ���������� ��� ��.
                                                                                                              
  oracle_wallet_file    constant varchar2(1024) := ms_params.GET_PARAM_VALUE('SSL_WALLET_DIR'); --'file:C:\OracleClient32'
  oracle_wallet_passwd  constant varchar2(1024) := '082g625p4Y412sD';
  
  --������. ������� � ��������� ��� �������� � �������� ������� �� ������� � ������� �����
  function drave_get_rest(p_phone varchar2) return number; -- ��������� � ������ �������� �� ������ � ������� ����� � drave_stats, ��������� ������� ������ ��� ����������� ������� (���������� 1 ���� ������ ���� ���������)
  procedure drave_check_phone_tariff(p_phone varchar2); -- �������� ������ � ������� ����� �� ������������� ��������� ������� � ������� ����������� ��������
  procedure drave_check_phone_flow(p_STREAM_ID integer, p_STREAM_COUNT integer); -- ������ ������������ ������� � ������� ����� � ������ (�� CONTRACTS)
  function drave_calc_traff(p_phone varchar2) return number; -- ������ ���������������� ������� � ������������ �� ��� ������� ��� ������� � ������� �����. ��������� - �������� ��������������� �������
  function drave_check_turn_tariff(p_phone varchar2) return number; -- �������� ������� �������� �������� �� ������ ����� � �������� ��� ��� ������� ����������� ��������
  procedure drave_init_new_month; -- ������������� ������ ������

  --�������� ������� �� ������� �� ���� �������
  procedure check_all_phone_flow(p_STREAM_ID integer, p_STREAM_COUNT integer); -- ������ ������������ ������� ��� �������� ������� �� ������� � ������
  procedure check_all_phone_tariff(p_phone varchar2, p_tariff_id integer); --�������� �������� �� ������������� ��������� ������� � �������� ���
  procedure all_phone_get_rest(p_phone varchar2, p_tariff_id integer); -- ��������� � ������ �������� �� ������� �� ������
  function all_phone_check_turn_tariff(p_phone varchar2, p_tariff_id integer, p_pckg_code varchar2, p_unittype varchar2, p_turn_on_date date) return number; -- �������� ������� �������� �� ������ � �������� ��� ��� ������� �������
  function all_phone_calc_traff(p_phone varchar2, p_unittype varchar2) return number; -- ������ ���������������� ������� � ������������ �� ��� ������� ��� �������. ��������� - �������� ��������������� ������� �� �������
  procedure all_phone_init_new_month; -- ������������� ������ ������
  
--#########################################################################
/*
������ ������� �������:
CORP_MOBILE@orcl01> exec :v_num := BEELINE_REST_API_PCKG.info_rests(BEELINE_REST_API_PCKG.get_token('AS453209624','32503250'),'','','9623630138')
CORP_MOBILE@orcl01> print v_num

     V_NUM
----------
         1
CORP_MOBILE@orcl01> select * from db_loader_rests;
15 rows selected.

CORP_MOBILE@orcl01> exec :v_num:= BEELINE_REST_API_PCKG.req_callforward(BEELINE_REST_API_PCKG.get_token('AS453209624','32503250'),'','','9623630138')
CORP_MOBILE@orcl01> print v_num
     V_NUM
----------
2224494279

CORP_MOBILE@orcl01> exec :v_num:= BEELINE_REST_API_PCKG.info_callforward(BEELINE_REST_API_PCKG.get_token('AS453209624','32503250'),'','','9623630138',2224494279)
CORP_MOBILE@orcl01> select * from db_loader_cfrw;
no rows selected

CORP_MOBILE@orcl01> exec :v_num:= BEELINE_REST_API_PCKG.req_callforward(BEELINE_REST_API_PCKG.get_token('AS453209624','32503250'),'','','9623630138')
CORP_MOBILE@orcl01> print v_num
     V_NUM
----------
2224494616

CORP_MOBILE@orcl01> exec :v_num:= BEELINE_REST_API_PCKG.req_callforward_edit(BEELINE_REST_API_PCKG.get_token('AS453209624','32503250'),'','','9623630138','')
CORP_MOBILE@orcl01> print v_num
     V_NUM
----------
         0

CORP_MOBILE@orcl01> exec :v_num := BEELINE_REST_API_PCKG.info_subscriptions(BEELINE_REST_API_PCKG.get_token('AS453209624','32503250'),'','','9623630138')
CORP_MOBILE@orcl01> exec :v_num := BEELINE_REST_API_PCKG.req_subscriptions_remove(BEELINE_REST_API_PCKG.get_token('AS453209624','32503250'),'','','9623630138','','')
CORP_MOBILE@orcl01> print v_num
     V_NUM
----------
2224494873

CORP_MOBILE@orcl01> select LOG_ID,to_char(load_date,'YYYY-MM-DD HH24:mi:ss.ff3') load_date, phone, requestid, code, status,message,note from db_loader_resp_log;

    LOG_ID LOAD_DATE                 PHONE       REQUESTID       CODE STATUS     MESSAGE                        NOTE
---------- ------------------------- ---------- ---------- ---------- ---------- ------------------------------ --------------------------------
        27 2015-01-29 15:17:24.057   9623630138          0      20000 "OK"       null                           info_rests
        28 2015-01-29 15:18:46.665   9623630138          0      20000 "OK"       null                           req_callforward
        29 2015-01-29 15:19:20.150   9623630138 2224505646      20017 "ERROR"    "BAD_REQUEST_STATUS"           info_callforward
        30 2015-01-29 15:19:34.851   9623630138          0      20000 "OK"       null                           req_callforward
        31 2015-01-29 15:20:02.635   9623630138          0      20000 "OK"       null                           info_subscriptions
        32 2015-01-29 15:20:23.888   9623630138          0      20000 "OK"       null                           req_subscriptions_remove
        33 2015-01-29 15:21:42.769   9623630138          0      -2100 NoData     Server retrieve null.          req_callforward_edit
        34 2015-01-29 15:23:03.079   9623630138 2224505646      20000 "OK"       null                           info_callforward



����� ������� � ������� ����������� req_callforward ��������� �����, ����� info_callforward ����� ��������� �����:

        28 2015-01-29 15:18:46.665   9623630138          0      20000 "OK"       null                           req_callforward
        29 2015-01-29 15:19:20.150   9623630138 2224505646      20017 "ERROR"    "BAD_REQUEST_STATUS"           info_callforward
        34 2015-01-29 15:23:03.079   9623630138 2224505646      20000 "OK"       null                           info_callforward

��� ������� �� '/api/1.0/request/callForward/edit' (����� req_callforward_edit) ������ ���������� NULL, ���� ������ requestid, �.�. ������ ������ �� ������� .


������ ������ � ���������� � �������������� ��������, ��������� ��� �������� ��� ������ (������ ������������ ������).

*/

--#########################################################################

END BEELINE_REST_API_PCKG;


CREATE OR REPLACE PACKAGE BODY BEELINE_REST_API_PCKG AS

--   intr_to_sec  --------- BEGIN ---------------------------------------------------------------------------------------------
  function intr_to_sec(p_time interval day to second) return number as
  begin
    return(extract(day from p_time)*24*60*60+extract(hour from p_time)*60*60+extract(minute from p_time)*60+extract(second from p_time));
  end;
--   intr_to_sec  ---------  END  ---------------------------------------------------------------------------------------------

--   get_resp_stat --------- BEGIN ---------------------------------------------------------------------------------------------
-- ������ ��������� ��������� � ��� � ��������� � �������� ���������� ��������� return_status 
  function get_resp_stat(code number, status varchar2, message varchar2, phone varchar2, requestid number, note varchar2, return_status number, p_req varchar2, p_data clob) return number as
  pragma autonomous_transaction;
  begin
    insert into db_loader_resp_log
      (
        LOG_ID,
        LOAD_DATE,
        PHONE,
        REQUESTID,
        CODE,
        STATUS,
        MESSAGE,
        NOTE,
        REQUEST,
        RESPONSE
      ) 
      values
      (
        db_loader_resp_log_id.nextval,
        systimestamp,
        phone,
        requestid,
        code,
        status,
        message,
        note,
        p_req,
        p_data
      );
    commit;
    return(return_status);
  end;
--   get_resp_stat ---------  END  ---------------------------------------------------------------------------------------------

--   get_data   ------------ BEGIN ---------------------------------------------------------------------------------------------
  function get_data(purl in varchar2, phdr in varchar2) return clob as
    req   UTL_HTTP.REQ;
    resp  UTL_HTTP.RESP;
    v_data clob;
begin
    UTL_HTTP.set_wallet(oracle_wallet_file, oracle_wallet_passwd);
    req := UTL_HTTP.BEGIN_REQUEST(purl);

    UTL_HTTP.SET_HEADER(req, 'User-Agent', 'Mozilla/4.0');
    utl_http.set_body_charset(req,'UTF-8');

    if phdr is not null then
      UTL_HTTP.SET_HEADER(req, phdr);
    end if;

    resp := UTL_HTTP.GET_RESPONSE(req);
    UTL_HTTP.READ_TEXT(resp,v_data);
    UTL_HTTP.END_RESPONSE(resp);
    RETURN (v_data);
    EXCEPTION
      WHEN UTL_HTTP.END_OF_BODY THEN
        UTL_HTTP.END_RESPONSE(resp);
    RETURN ('');
  end;
--   get_data   ------------  END  ---------------------------------------------------------------------------------------------

--   get_token  ------------ BEGIN ---------------------------------------------------------------------------------------------
  function get_token(p_login in varchar2, p_passwd in varchar2) return varchar2 AS
    v_token varchar2(100);
    v_login varchar2(50);
    pragma autonomous_transaction;
  BEGIN

    v_token := json_ext.get_string(json(get_data(beeline_protocol||'://'||beeline_domain||beeline_auth_path||'?login='||p_login||chr(38)||'password='||p_passwd,'')),'token');
    if v_token is not null then
      select acc_log into v_login from beeline_api_token_list where acc_log = p_login for update;
      if v_login is null then
        insert into beeline_api_token_list 
          (
            ACC_LOG,
            TOKEN,
            LAST_UPDATE,
            REST_TOKEN,
            REST_LAST_UPDATE
          )
          values 
          (
            p_login, 
            null,
            null,
            v_token, 
            sysdate
          );
      else
        update beeline_api_token_list set rest_token=v_token, rest_last_update=sysdate where acc_log=p_login;
      end if;
  
      commit;      
    end if;    
    RETURN (v_token);
  END;
--   get_token  ------------  END  ---------------------------------------------------------------------------------------------

--   info_rests ------------ BEGIN ---------------------------------------------------------------------------------------------
  function info_rests(token varchar2, phash varchar2, pclient varchar2, ctn varchar2) return TRests as
    obj       json;
    tmp       json_list;
    tmpobj    json;
    v_rest    TInfoRest;
    v_rests   TRests;
    v_data    db_loader_resp_log.response%type;
    v_req     db_loader_resp_log.request%type;
    v_hdr     varchar2(512);
    v_grs     number(12);
    v_code    db_loader_resp_log.code%type; 
  begin
    
    v_req  := beeline_protocol||'://'||beeline_domain||info_rests_path||'?ctn='||ctn;
    v_hdr  := 'Cookie: token='||token||'; domain='||beeline_domain||'; path='||info_rests_path||';';
    v_data := get_data(v_req, v_hdr);
    v_grs  := get_resp_stat(-9000,'LogReqResp','Save request and response into log.', ctn,0,'info_rests',0,v_req||chr(38)||'token='||token, v_data);
    if v_data  is null  then return(v_rests); end if;
    obj    := json(v_data);

    v_code := nvl(json_ext.get_json(obj,'meta').get('code').get_number,0);
    v_grs  := get_resp_stat
      (
        v_code,
        nvl(json_ext.get_json(obj,'meta').get('status').get_string,''),
        nvl(json_ext.get_json(obj,'meta').get('message').get_string,''),
        ctn,
        0,
        'info_rests',
        0,
        v_req||chr(38)||'token='||token, 
        v_data
      );
    if v_code <> err_ok then return(v_rests);  end if;

    tmp := json_ext.get_json_list(obj,'rests');
    for i in 1 .. tmp.count loop
      v_rest := TInfoRest(systimestamp, ctn, '','',0,0,0,'','','','');
      tmpobj := json(tmp.get(i));

      if (tmpobj.exist('unitType'))    then v_rest.unitType     := tmpobj.get('unitType').get_string; else v_rest.unitType := ''; end if;
      if (tmpobj.exist('restType'))    then v_rest.restType     := tmpobj.get('restType').get_string; else v_rest.restType := ''; end if;
      if (tmpobj.exist('initialSize')) then v_rest.initialSize  := tmpobj.get('initialSize').get_number; else v_rest.initialSize := 0; end if;
      if (tmpobj.exist('currValue'))   then v_rest.currValue    := tmpobj.get('currValue').get_number; else v_rest.currValue := 0; end if;
      if (tmpobj.exist('nextValue'))   then v_rest.nextValue    := tmpobj.get('nextValue').get_number; else v_rest.nextValue := 0; end if;
      if (tmpobj.exist('frequency'))   then v_rest.frequency    := tmpobj.get('frequency').get_string; else v_rest.frequency := ''; end if;
      if (tmpobj.exist('soc'))         then v_rest.soc          := tmpobj.get('soc').get_string; else v_rest.soc := ''; end if;
      if (tmpobj.exist('socName'))     then v_rest.socName      := tmpobj.get('socName').get_string; else v_rest.socName := ''; end if;
      if (tmpobj.exist('restName'))    then v_rest.restName     := tmpobj.get('restName').get_string; else v_rest.restName := ''; end if;
      
      if upper(v_rest.unitType)='INTERNET' and v_rest.initialSize > c_errlvl_internet_initialsize 
      then 
        v_rest.currValue  :=round(v_rest.currValue/1024/1024,2); 
        v_rest.initialSize:=round(v_rest.initialSize/1024/1024,2); 
      end if;-- 32GB
      if upper(v_rest.unitType)='VOICE' and v_rest.initialSize >= c_errlvl_voice_initialsize
      then 
        v_rest.currValue:=v_rest.currValue/60; 
        v_rest.initialSize:=v_rest.initialSize/60; 
      end if;
      
      v_rests(i) := v_rest;
    end loop;

    return(v_rests);
  end;
--   info_rests ------------  END  ------------------------------------------------------------------------------------

--   get_status ------------ BEGIN ---------------------------------------------------------------------------------------------
  function get_status(pPHONE_NUMBER varchar2) return tbl_TRestStatus pipelined AS  -- �������� ������ ������
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN,
             ACCOUNTS.New_Pswd,
             ACCOUNTS.ACCOUNT_NUMBER,
             ACCOUNTS.Company_Name,
             Accounts.Account_Id
        FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS
       WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
         AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
         AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
            from DB_LOADER_ACCOUNT_PHONES where PHONE_NUMBER = pPHONE_NUMBER);
    vREC     C%ROWTYPE;
    v_data    db_loader_resp_log.response%type;
    v_req     db_loader_resp_log.request%type;
    v_code    db_loader_resp_log.code%type; 
    v_hdr     varchar2(512);
    v_grs     number(12);
    token     varchar2(64);
    token_old date;
    obj       json;
    v_result  TRestStatus;
  BEGIN
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
       select t.rest_token,t.rest_last_update into token,token_old from beeline_api_token_list t where t.acc_log=vREC.login;
       if (token_old<sysdate- 9/24 --9/1440 
         or token_old is null) 
       then 
          token := GET_TOKEN(vREC.login,vREC.new_pswd);
       end if;

      v_req  := beeline_protocol||'://'||beeline_domain||info_get_status_path||'?ctn='||pPHONE_NUMBER;
      v_hdr  := 'Cookie: token='||token||'; domain='||beeline_domain||'; path='||info_get_status_path||';';
      v_data := get_data(v_req, v_hdr);
      v_grs  := get_resp_stat(-9000,'LogReqResp','Get status.', pPHONE_NUMBER,0,'info_get_status',0,v_req||chr(38)||'token='||token, v_data);
      if v_data  is not null  then
        obj  := json(v_data);
        v_code := nvl(json_ext.get_json(obj,'meta').get('code').get_number,0);
        v_grs  := get_resp_stat
          (
            v_code,
            nvl(json_ext.get_json(obj,'meta').get('status').get_string,''),
            nvl(json_ext.get_json(obj,'meta').get('message').get_string,''),
            pPHONE_NUMBER,
            0,
            'info_get_status',
            0,
            v_req||chr(38)||'token='||token, 
            v_data
          );
        if v_code = err_ok then
          v_result.phone         := pPHONE_NUMBER;
          v_result.status        := nvl(obj.get('status').get_string,'');
          v_result.statusRsnCode := nvl(obj.get('statusRsnCode').get_string,'');
          v_result.statusDesc    := nvl(obj.get('statusDesc').get_string,'');
          pipe row(v_result);
        end if;
      end if;
    end if;
  END;
--   get_status ------------  END  ------------------------------------------------------------------------------------

--   get_serviceList ------- BEGIN ---------------------------------------------------------------------------------------------
  function get_serviceList(pPHONE_NUMBER varchar2) return tbl_TServiceList pipelined AS  -- �������� ������ ������������ �����
    CURSOR C IS
      SELECT ACCOUNTS.LOGIN,
             ACCOUNTS.New_Pswd,
             ACCOUNTS.ACCOUNT_NUMBER,
             ACCOUNTS.Company_Name,
             Accounts.Account_Id
        FROM DB_LOADER_ACCOUNT_PHONES, ACCOUNTS
       WHERE DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER = pPHONE_NUMBER
         AND ACCOUNTS.ACCOUNT_ID = DB_LOADER_ACCOUNT_PHONES.ACCOUNT_ID
         AND DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH = (select max(YEAR_MONTH) 
            from DB_LOADER_ACCOUNT_PHONES where PHONE_NUMBER = pPHONE_NUMBER);
    vREC          C%ROWTYPE;
    tmp           json_list;
    tmpobj        json;
    v_data        db_loader_resp_log.response%type;
    v_req         db_loader_resp_log.request%type;
    v_code        db_loader_resp_log.code%type; 
    v_hdr         varchar2(512);
    v_grs         number(12);
    token         varchar2(64);
    token_old     date;
    obj           json;
    v_servicelist TServiceList; 
  
  BEGIN
    OPEN C;
    FETCH C INTO vREC;
    CLOSE C;
    IF vREC.LOGIN IS NOT NULL THEN
       select t.rest_token,t.rest_last_update into token,token_old from beeline_api_token_list t where t.acc_log=vREC.login;
       if (token_old<sysdate- 9/24 --9/1440 
         or token_old is null) 
       then 
          token := GET_TOKEN(vREC.login,vREC.new_pswd);
       end if;

      v_req  := beeline_protocol||'://'||beeline_domain||info_serviceList_path||'?ctn='||pPHONE_NUMBER;
      v_hdr  := 'Cookie: token='||token||'; domain='||beeline_domain||'; path='||info_serviceList_path||';';
      v_data := get_data(v_req, v_hdr);
      v_grs  := get_resp_stat(-9000,'LogReqResp','Get services list.', pPHONE_NUMBER,0,'info_get_serviceList',0,v_req||chr(38)||'token='||token, v_data);
      if v_data  is not null  then
        obj  := json(v_data);
        v_code := nvl(json_ext.get_json(obj,'meta').get('code').get_number,0);
        v_grs  := get_resp_stat
          (
            v_code,
            nvl(json_ext.get_json(obj,'meta').get('status').get_string,''),
            nvl(json_ext.get_json(obj,'meta').get('message').get_string,''),
            pPHONE_NUMBER,
            0,
            'info_get_serviceList',
            0,
            v_req||chr(38)||'token='||token, 
            v_data
          );
        if v_code = err_ok then
          tmp := json_ext.get_json_list(obj,'services');
          for i in 1 .. tmp.count loop
            tmpobj := json(tmp.get(i));

            if (tmpobj.exist('name'))         then v_servicelist.name         := tmpobj.get('name').get_string; else v_servicelist.name := ''; end if;
            if (tmpobj.exist('entityName'))   then v_servicelist.entityName   := tmpobj.get('entityName').get_string; else v_servicelist.entityName := ''; end if;
            if (tmpobj.exist('entityDesc'))   then v_servicelist.entityDesc   := tmpobj.get('entityDesc').get_string; else v_servicelist.entityDesc := ''; end if;
            if (tmpobj.exist('rcRate'))       then v_servicelist.rcRate       := tmpobj.get('rcRate').get_number; else v_servicelist.rcRate := 0; end if;
            if (tmpobj.exist('rcRatePeriod')) then v_servicelist.rcRatePeriod := tmpobj.get('rcRatePeriod').get_string; else v_servicelist.rcRatePeriod := ''; end if;
            if (tmpobj.exist('category'))     then v_servicelist.category     := tmpobj.get('category').get_string; else v_servicelist.category := ''; end if;
            if (tmpobj.exist('sdbSize'))      then v_servicelist.sdbSize      := tmpobj.get('sdbSize').get_number; else v_servicelist.sdbSize := 0; end if;
            if (tmpobj.exist('viewInd'))      then v_servicelist.viewInd      := tmpobj.get('viewInd').get_string; else v_servicelist.viewInd := ''; end if;
            if (tmpobj.exist('removeInd'))    then v_servicelist.removeInd    := tmpobj.get('removeInd').get_string; else v_servicelist.removeInd := ''; end if;
            if (tmpobj.exist('effDate'))      then v_servicelist.effDate      := tmpobj.get('effDate').get_string; else v_servicelist.effDate := ''; end if;
            if (tmpobj.exist('exprDate'))     then v_servicelist.exprDate     := tmpobj.get('exprDate').get_string; else v_servicelist.exprDate := ''; end if;    
            pipe row(v_servicelist);
          end loop;
        end if;
      end if;
    end if;
  END;
--   get_serviceList ------------  END  ------------------------------------------------------------------------------------
  
--   req_callforward --- BEGIN ------------------------------------------------------------------------------------
  function req_callforward(token varchar2, phash varchar2, pclient varchar2, ctn varchar2) return number as
    obj       json;
    v_data    db_loader_resp_log.response%type;
    v_req     db_loader_resp_log.request%type;
    v_hdr     varchar2(512);
    v_grs     number(12);
    v_reqid   number(18);
    v_code    db_loader_resp_log.code%type; 
  begin
    if token  is null  then
      return (get_resp_stat(-2000,'TokenIsEmpty','The token attribute must not be an empty string', ctn,0,'req_callforward',0,v_req, v_data));
    elsif ctn is null then
      return (get_resp_stat(-2001,'CtnIsEmpty','The CTN attribute must not be an empty string', ctn, 0,'req_callforward',0,v_req, v_data));
    end if;
    
    v_req := beeline_protocol||'://'||beeline_domain||req_callforward_path||'?ctn='||ctn;
    v_hdr  :='Cookie: token='||token||'; domain='||beeline_domain||'; path='||req_callforward_path||';';
    v_data := get_data(v_req, v_hdr);
    v_grs  := get_resp_stat(-9000,'LogReqResp','Save request and response into log.', ctn,0,'req_callforward',0,v_req||chr(38)||'token='||token, v_data);
    if v_data  is null  then
      return (get_resp_stat(-2100,'NoData','Server retrieve null.',ctn,0,'req_callforward', 0,v_req||chr(38)||'token='||token, v_data));
    end if;
    obj := json(v_data);

    v_reqid:= nvl(json_ext.get_number(obj,'requestId'),0); 
    v_code := nvl(json_ext.get_json(obj,'meta').get('code').get_number,0);
    v_grs  := get_resp_stat
      (
        v_code,
        nvl(json_ext.get_json(obj,'meta').get('status').get_string,''),
        nvl(json_ext.get_json(obj,'meta').get('message').get_string,''),
        ctn,
        v_reqid,
        'req_callforward',
        0,
        v_req||chr(38)||'token='||token, 
        v_data
      );
    if v_code <> err_ok then return(0); end if;
    return(v_reqid);
  end;
--   req_callforward ---  END  ------------------------------------------------------------------------------------

--   info_callforward ------ BEGIN ------------------------------------------------------------------------------------
  function info_callforward(token varchar2, phash varchar2, pclient varchar2, ctn varchar2, requestid integer) return number as
    obj       json;
    tmp       json_list;
    tmpobj    json;
    v_cfrw    db_loader_cfrw%rowtype;
    v_data    db_loader_resp_log.response%type;
    v_req     db_loader_resp_log.request%type;
    v_hdr     varchar2(512);
    v_grs     number(12);
    v_code    db_loader_resp_log.code%type; 
  begin
    if token  is null  then
      return (get_resp_stat(-2000,'TokenIsEmpty','The token attribute must not be an empty string', ctn, requestid,'info_callforward', 0,v_req, v_data));
    elsif requestid =0 then
      return (get_resp_stat(-2002,'RequestidIsNull','The RequestID attribute must not be 0', ctn, requestid,'info_callforward', 0,v_req, v_data));
    end if;

    v_req := beeline_protocol||'://'||beeline_domain||info_callforward_path||'?requestId='||requestid;
    v_hdr := 'Cookie: token='||token||'; domain='||beeline_domain||'; path='||info_callforward_path||';';
    v_data := get_data(v_req, v_hdr);
    v_grs  := get_resp_stat(-9000,'LogReqResp','Save request and response into log.', ctn,0,'info_callforward',0,v_req||chr(38)||'token='||token, v_data);
    if v_data  is null  then
      return (get_resp_stat(-2100,'NoData','Server retrieve null.',ctn,0,'info_callforward', 0,v_req||chr(38)||'token='||token, v_data));
    end if;
    obj := json(v_data);

    v_code := nvl(json_ext.get_json(obj,'meta').get('code').get_number,0);
    v_grs  := get_resp_stat
      (
        v_code,
        nvl(json_ext.get_json(obj,'meta').get('status').get_string,''),
        nvl(json_ext.get_json(obj,'meta').get('message').get_string,''),
        ctn,
        requestid,
        'info_callforward',
        0,
        v_req||chr(38)||'token='||token, 
        v_data
      );
    if v_code <> err_ok then return(0); end if;

    tmp := json_ext.get_json_list(obj,'callForwards');
    for i in 1 .. tmp.count loop
      v_cfrw.cfrw_id   := db_loader_cfrw_id.nextval;
      v_cfrw.load_date := systimestamp;
      v_cfrw.requestid := requestid;
      tmpobj := json(tmp.get(i));

      if (tmpobj.exist('cfType')) then v_cfrw.cfType := tmpobj.get('cfType').get_string; else v_cfrw.cfType := ''; end if;

      insert into db_loader_cfrw values v_cfrw;
    end loop;

    return(1);
  end;
--   info_callforward ------  END  ------------------------------------------------------------------------------------

--   req_callforward_edit -- BEGIN ------------------------------------------------------------------------------------
  function req_callForward_edit(token varchar2, phash varchar2, pclient varchar2, ctn varchar2, CallFrwEdtReqDo varchar2) return number as
    obj       json;
    tmp       json_list;
    tmpobj    json;
    v_cfrw    db_loader_cfrw%rowtype;
    v_data    db_loader_resp_log.response%type;
    v_req     db_loader_resp_log.request%type;
    v_hdr     varchar2(512);
    v_grs     number(12);
    v_reqid   number(18);
    v_code    db_loader_resp_log.code%type; 
  begin
    if token  is null  then
      return (get_resp_stat(-2000,'TokenIsEmpty','The token attribute must not be an empty string',ctn,0,'req_callforward_edit', 0,v_req, v_data));
    elsif ctn  is null then
      return (get_resp_stat(-2001,'CtnIsEmpty','The CTN attribute must not be an empty string',ctn, 0,'req_callforward_edit', 0,v_req, v_data));
    end if;

    v_req  := beeline_protocol||'://'||beeline_domain||req_callForward_edt_path||'?ctn='||ctn;
    v_hdr  := 'Cookie: token='||token||'; domain='||beeline_domain||'; path='||req_callForward_edt_path||';';
    v_data := get_data(v_req, v_hdr);
    v_grs  := get_resp_stat(-9000,'LogReqResp','Save request and response into log.', ctn,0,'req_callforward_edit',0,v_req||chr(38)||'token='||token, v_data);
    if v_data  is null  then
      return (get_resp_stat(-2100,'NoData','Server retrieve null.',ctn,0,'req_callforward_edit', 0,v_req||chr(38)||'token='||token,v_data));
    end if;
    obj := json(v_data);

    v_reqid:= nvl(json_ext.get_number(obj,'requestId'),0); 
    v_code := nvl(json_ext.get_json(obj,'meta').get('code').get_number,0);
    v_grs  := get_resp_stat
      (
        v_code,
        nvl(json_ext.get_json(obj,'meta').get('status').get_string,''),
        nvl(json_ext.get_json(obj,'meta').get('message').get_string,''),
        ctn,
        v_reqid,
        'req_callforward_edit',
        0,
        v_req||chr(38)||'token='||token, 
        v_data
      );
    if v_code <> err_ok then return(0); end if;

    return(v_reqid);
  end;
--   req_callforward_edit --  END  ------------------------------------------------------------------------------------

--   info_subscriptions ---- BEGIN ---------------------------------------------------------------------------------------------
  function info_subscriptions(token varchar2, phash varchar2, pclient varchar2, ctn varchar2) return number as
    obj       json;
    tmp       json_list;
    tmpobj    json;
    v_subs    db_loader_subs%rowtype;
    v_data    db_loader_resp_log.response%type;
    v_req     db_loader_resp_log.request%type;
    v_hdr     varchar2(512);
    v_grs     number(12);
    v_code    db_loader_resp_log.code%type; 
  begin
    if token  is null  then
      return (get_resp_stat(-2000,'TokenIsEmpty','The token attribute must not be an empty string', ctn, 0,'info_subscriptions',0,v_req, v_data));
    elsif ctn is null then
      return (get_resp_stat(-2001,'CtnIsEmpty','The CTN attribute must not be an empty string', ctn, 0,'info_subscriptions',0,v_req, v_data));
    end if;
    
    v_req := beeline_protocol||'://'||beeline_domain||info_subscriptions_path||'?ctn='||ctn;
    v_hdr := 'Cookie: token='||token||'; domain='||beeline_domain||'; path='||info_subscriptions_path||';';
    v_data := get_data(v_req, v_hdr);
    v_grs  := get_resp_stat(-9000,'LogReqResp','Save request and response into log.', ctn,0,'info_subscriptions',0,v_req||chr(38)||'token='||token, v_data);
    if v_data  is null  then
      return (get_resp_stat(-2100,'NoData','Server retrieve null.',ctn,0,'info_subscriptions', 0,v_req||chr(38)||'token='||token, v_data));
    end if;
    obj := json(v_data);

    v_code := nvl(json_ext.get_json(obj,'meta').get('code').get_number,0);
    v_grs  := get_resp_stat
      (
        v_code,
        nvl(json_ext.get_json(obj,'meta').get('status').get_string,''),
        nvl(json_ext.get_json(obj,'meta').get('message').get_string,''),
        ctn,
        0,
        'info_subscriptions',
        0,
        v_req||chr(38)||'token='||token, 
        v_data
      );
    if v_code <> err_ok then return(0); end if;

    tmp := json_ext.get_json_list(obj,'subscriptions');
    for i in 1 .. tmp.count loop
      v_subs.subs_id    := db_loader_subs_id.nextval;
      v_subs.load_date  := systimestamp;
      v_subs.phone      := ctn;

      tmpobj := json(tmp.get(i));

      if (tmpobj.exist('id'))               then v_subs.id                := tmpobj.get('id').get_string; else v_subs.id := ''; end if;
      if (tmpobj.exist('name'))             then v_subs.name              := tmpobj.get('name').get_string; else v_subs.name := ''; end if;
      if (tmpobj.exist('try_price'))        then v_subs.try_price         := tmpobj.get('try_price').get_number; else v_subs.try_price := 0; end if;
      if (tmpobj.exist('buy_price'))        then v_subs.buy_price         := tmpobj.get('buy_price').get_number; else v_subs.buy_price := 0; end if;
      if (tmpobj.exist('buy_price_period')) then v_subs.buy_price_period  := tmpobj.get('buy_price_period').get_number; else v_subs.buy_price_period := 0; end if;
      if (tmpobj.exist('start_date'))       then v_subs.start_date        := tmpobj.get('start_date').get_string; else v_subs.start_date := ''; end if;
      if (tmpobj.exist('end_free_date'))    then v_subs.end_free_date     := tmpobj.get('end_free_date').get_string; else v_subs.end_free_date := ''; end if;
      if (tmpobj.exist('end_date'))         then v_subs.end_date          := tmpobj.get('end_date').get_string; else v_subs.end_date := ''; end if;
      if (tmpobj.exist('try_buy_mode'))     then v_subs.try_buy_mode      := tmpobj.get('try_buy_mode').get_string; else v_subs.try_buy_mode := ''; end if;
      if (tmpobj.exist('provider_name'))    then v_subs.provider_name     := tmpobj.get('provider_name').get_string; else v_subs.provider_name := ''; end if;
      if (tmpobj.exist('provider_contact')) then v_subs.provider_contact  := tmpobj.get('provider_contact').get_string; else v_subs.provider_contact := ''; end if;
      if (tmpobj.exist('category'))         then v_subs.category          := tmpobj.get('category').get_string; else v_subs.category := ''; end if;
      if (tmpobj.exist('type'))             then v_subs.type              := tmpobj.get('type').get_string; else v_subs.type := ''; end if;

      insert into db_loader_subs values v_subs;
    end loop;

    return(1);
  end;
--   info_subscriptions ----  END  ------------------------------------------------------------------------------------

--   req_subscription_remove ---- BEGIN ---------------------------------------------------------------------------------------------
  function req_subscriptions_remove(token varchar2, phash varchar2, pclient varchar2, ctn varchar2, subscriptionid varchar2, ptype varchar2) return number as
    obj       json;
    v_data    db_loader_resp_log.response%type;
    v_req     db_loader_resp_log.request%type;
    v_hdr     varchar2(512);
    v_grs     number(12);
    v_reqid   number(18);
    v_code    db_loader_resp_log.code%type; 
  begin
    if token  is null  then
      return (get_resp_stat(-2000,'TokenIsEmpty','The token attribute must not be an empty string', ctn, 0,'req_subscriptions_remove',0,v_req, v_data));
    elsif ctn is null then
      return (get_resp_stat(-2001,'CtnIsEmpty','The CTN attribute must not be an empty string', ctn, 0,'req_subscriptions_remove',0,v_req, v_data));
    end if;

    v_req := beeline_protocol||'://'||beeline_domain||req_subscription_rmv_path||'?ctn='||ctn;
    v_hdr := 'Cookie: token='||token||'; domain='||beeline_domain||'; path='||req_subscription_rmv_path||';';
    v_data := get_data(v_req, v_hdr);
    v_grs  := get_resp_stat(-9000,'LogReqResp','Save request and response into log.', ctn,0,'req_subscriptions_remove',0,v_req||chr(38)||'token='||token, v_data);
    if v_data  is null  then
      return (get_resp_stat(-2100,'NoData','Server retrieve null.',ctn,0,'req_subscriptions_remove', 0,v_req||chr(38)||'token='||token, v_data));
    end if;
    obj := json(v_data);

    v_reqid:= nvl(json_ext.get_number(obj,'requestId'),0); 
    v_code := nvl(json_ext.get_json(obj,'meta').get('code').get_number,0);
    v_grs  := get_resp_stat
      (
        v_code,
        nvl(json_ext.get_json(obj,'meta').get('status').get_string,''),
        nvl(json_ext.get_json(obj,'meta').get('message').get_string,''),
        ctn,
        v_reqid,
        'req_subscriptions_remove',
        0,
        v_req||chr(38)||'token='||token, 
        v_data
      );
    if v_code <> err_ok then return(0); end if;

    return(v_reqid);

  end;
--   req_subscription_remove ----  END  ------------------------------------------------------------------------------------

--   gprs_check_turn_tariff ---- BEGIN ---------------------------------------------------------------------------------------------
  function gprs_check_turn_tariff(p_phone varchar2) return number as -- �������� ������� �������� �������� �� ������/������ � ����������� ������ ��� �������������
    type t_stat is table of gprs_stat%rowtype index by pls_integer;
    v_rec                 t_stat;
    v_num                 number(38) := 0;
    v_time                interval day (5) to second (9);
    v_num0                number(38);-- ������ � ������ ������
    v_time0               interval day (5) to second (9); -- � ������ ������
    v_vol                 number(12);
    v_tariff_code         varchar2(30);
    v_tariff_code_old     varchar2(30);
    delta_time_sec        number(12);
    ctrl_pnt_cnt          number(12); -- ���-�� ��� ���������� ������� �����
    new_opt_id            number(38);
    v_str                 varchar2(1024);
    v_str0                varchar2(1024);
    v_grs                 number(12);
    v_date                timestamp;
    i                     number(12) := 0;
    j                     number(12) := 0;
    v_is_no_turn_on       number     := 0;
    v_rest_auto_internet  number(12) := 500; -- ����� ��� ���� ���.������� ����������� ������� (500��) ��� ���������������, ��� ������������ � ������ ���������������� �� ������ 650
    v_first_day           date;

    v_last_week_opt       varchar2(32) := 'GPRS_U';

    type t_stat2 is record
      (
        phone           varchar2(10),
        initvalue       integer,
        currvalue       integer,
        curr_check_date timestamp
      );
    type t_stats is table of t_stat2 index by pls_integer;
    vt_stat t_stats;
    
    v_total_sec     number(24,3)  := 0;
    v_total_traf    number(24)    := 0;  
    v_end_month_sec number(24,3)  := 0;
    
    pSchemeWork integer; --����� ������ ��������� �� ����������� �������
    pCntTarCode integer;
    pExistsOpt integer;
    nk integer;
    ik integer;

  begin
    
    -- v_rec(1) - ������ ����� ��������� 
    -- v_rec(2) - ������������� ���������
    -- v_rec(3) - ������� ���������, � ���������� �.�. ���� ������ ��� ���������� � ��� �� �������� � ��

    begin
    
      select tariff_code into v_tariff_code from (select tariff_code from gprs_turn_log where phone=p_phone and date_off is null order by date_off desc) where rownum <2;
      
      if v_tariff_code is not null then -- ������ ��������� �����?  
        select count(1)
          into v_num
          from tariffs
         where tariff_code=v_tariff_code
           and is_auto_internet=1;
        
        if nvl(v_num,0)>0 then  -- ���� ����� �� ������������� ����������� �������, ����� 0 
          select t.REST_AUTO_INTERNET*1.1 -- ������� �� ������ �������� ����� ������� ��� ���������� ������� � ����� ������
            into v_rest_auto_internet
            from v_contracts c
                 join tariffs t 
                   on t.tariff_id=C.TARIFF_ID
           where C.CONTRACT_CANCEL_DATE is null
             and T.IS_AUTO_INTERNET<>0
             and phone_number_federal= p_phone;
        end if;
        
        select * into v_rec(1) 
          from (select * from gprs_stat where phone = p_phone and tariff_code= v_tariff_code order by curr_check_date, stat_id) where rownum <2;

        select * into v_rec(2) 
          from (select * from (select * from gprs_stat where phone = p_phone and tariff_code= v_tariff_code order by curr_check_date desc, stat_id desc) where rownum <3  order by curr_check_date, stat_id) where rownum <2;
            
        select * into v_rec(3) 
          from (select * from gprs_stat where phone = p_phone and tariff_code= v_tariff_code order by curr_check_date desc, stat_id desc) where rownum <2;

        
        -- ������� ����/������� ��������� ��������, ���������� ����� �� ���������������� ������� ��������� 20% ��� 0  
        
        -- ������� ������� ������������ ��� ������������ ������� �������, ���� <= c_turn_tariff_immediately (10 ��� ��-���������) �� ������������� ����������
        v_num0 := abs(nvl(v_rec(2).currvalue,0)-nvl(v_rec(3).currvalue,0)); -- ����� ����������� � ���������� ���������  
        v_num  := abs(nvl(intr_to_sec(v_rec(3).curr_check_date - v_rec(2).curr_check_date),0)); -- ����� � ���������� ��������� � ��������
        -- ���� ������� ������� �� ������:
        --    > ����������� ���������, ������ ��� ���� ������� � ����� �� ����� ���� ��������� � "0" 
        --    <= ������������ ������� ��������-������� �� ������ (v_rest_auto_internet);
        --    ����� �������� �� c_turn_tariff_immediately (10 ��-���������) �����;
        -- �� ���������� ����� ����� ����������         
        if (nvl(v_rec(3).currvalue,0)>nvl(v_rec(2).currvalue,0))
        or (nvl(v_rec(3).currvalue,0) <= nvl(v_rest_auto_internet,0)) 
        or (v_num0 <>0 and v_num <> 0 and nvl(v_rec(3).currvalue,0)*v_num/v_num0/60 <= c_turn_tariff_immediately) then -- ��-��������� "10" (�����)
          -- ���������� ���.�����
          -- dbms_output.put_line('���������� ���.�����');
          -- ���������� �������������� ����������� ����� ������� �� ����� �����
          -- ������� �������� ����������� � ������ ������ �� ��������� �����

          -- ������� ������������ ����� ������� (� ������� ������)
          --  select sum(distinct initvalue) into initvalue_sum from gprs_stat where phone=p_phone;
          v_tariff_code_old := v_tariff_code; -- ��������� ������ ��� ������ ����
          begin
            -- ����� ������������ ������ ��������
            select
                    total_sec,
                    total_traff
              into
                    v_total_sec,
                    v_total_traf
              from
                    table(calc_traff(p_phone));
            --���-�� ������ �� ����� ������ ������� � ������� ������������ ��������
            v_end_month_sec := intr_to_sec(to_date(to_char(last_day(sysdate),'YYYY-MM-DD')||' 23:59:59','YYYY-MM-DD hh24:mi:ss')-systimestamp); -- vt_stat(1).curr_check_date); --
            if    v_total_sec  <= 0 
              or  v_total_traf <= 0 
              then 
              --dbms_output.put_line('��������� ������ '||p_phone||' ��������: v_total_sec = 0 .');
              return(-1); 
            end if;
            --dbms_output.put_line(vt_stat(1).phone||' | ��: '||round(v_total_sec/24/60/60,2)||' ��. | �������� ��: '||v_total_traf||' | �� ����� ���: '||round(v_end_month_sec/24/60/60,2)||' ��. | ����������� ��: '||round(v_total_traf*v_end_month_sec/v_total_sec,0));
            -- �� ����� ������ ����������� (��)
            v_num := v_total_traf*v_end_month_sec/v_total_sec;
          exception
            when no_data_found then 
              --dbms_output.put_line('��� ������ ��� ���������');
              return(-1);
          end;                  
          -- dbms_output.put_line('�� ����� ������ �����������: '||v_num);

          -- opt_id ����������� ������
          --����� ���� ��� ���������� ���������� �������, ������� ����������� �� ����� ������ (v_num), ���������� ������ ����� �����������
          --�� ������ ������ ������� 3 ����� �����������: 
          --����� 1. - ������. 990, 1290, 980, 1280. ������������ ������ GPRS_20 � GPRS_U. ����� GPRS_20 �����. �������� 3 ����/�����
              --  1) ����������� ��������� ��������� �� �������� ������� ������� �� ����� ������;
              --  2) ����� ��������� ���������� ������� 20��;
              --  3) ���� ��������� ��������� <= ��������� ���������� ������ 20�� ��� ����� 20�� ��� �����. 3 ����, �� ���������� GPRS_U, ����� 20��.
          --����� 2. - ������. 1590. ������������ ������ FSG_TT2, FSG_TT3 � GPRS_U. �������� ������ ������
              --  1) ���������� ��� ������ � ������� ������� ����� ���������� ����������;
              --  2) �������������� ��������� ��������� �� �������� ������� ������� �� ����� ������; 
              --  3) �� ���������� ��������� �� �.2 � ���������� � �.1 ������� �������� ����������;
              --  4) ������������ ����������� ����� ��������������� ��������� ��������� � �.3
          --����� 3. - ������. 1580. ������������ ������ GPRS_30 � GPRS_U. ����� GPRS_30 �����. �������� 2 ���/�����
              --  1) ����������� ��������� ��������� �� �������� ������� ������� �� ����� ������;
              --  2) ����� ��������� ���������� ������� 30��;
              --  3) ���� ��������� ��������� <= ��������� ���������� ������ 30�� ��� ����� 30�� ��� �����. 3 ����, �� ���������� GPRS_U, ����� 30��.
          --
          pSchemeWork := 0;
          begin
            select nvl(ATR.INT_TYPE, 0)
              into pSchemeWork
             from congr_tarif cn,
                     tariffs_attrs atr
            where CN.TARIFFS_ATTRIBUTES_ID = ATR.TARIFFS_ATTRIBUTES_ID
                and ATR.ATTRIBUTES_NAME = 'SCHEME_AUTO_CONNECT_PCKG'
                and CN.TARIFF_ID = GET_CURR_PHONE_TARIFF_ID(p_phone);   
          exception
            when others then 
              return(-1);
          end;
          --���� �� ������� ����� �����. ������, �� ������ �� ���������� � �� �������� ���� � ������������
          if nvl(pSchemeWork, 0) = 0 then
            return(-1);
          end if;
          --�������� �����
          begin
            select
                    code,
                    VOLUME
              into
                    v_tariff_code,
                    v_num0
              from
                    (
                      select
                              TF.OPTION_CODE      code,
                              nvl(TF.INTERNET_VOLUME,0)  volume,
                              case nvl(TF.DISCR_SPISANIE,0)
                                when 0 then 
                                            nvl(TC.MONTHLY_COST,0)
                                            * 
                                              ceil(beeline_rest_api_pckg.intr_to_sec
                                              (
                                                  trunc(add_months(sysdate,1),'mm')
                                                - systimestamp
                                              )/24/60/60)/
                                                to_number(to_char(last_day(sysdate),'dd'))
                                else
                                  nvl(TC.MONTHLY_COST,0)
                              end 
                              cost_for_month_rest
                        from
                              tariff_options  tf,
                              TARIFF_OPTION_COSTS tc
                       where
                              TF.IS_AUTO_INTERNET=1
                         and  TF.INTERNET_VOLUME >= 
                                                                       (
                                                                           CASE
                                                                              WHEN ((nvl(pSchemeWork, 0) = 1) or (nvl(pSchemeWork, 0) = 3)) THEN --��� ����� 1 � 3 ����� ��� ��������� ������
                                                                                 1
                                                                              ELSE --��� ����� 2
                                                                                 nvl(v_num,0)
                                                                           END
                                                                       )
                         and  TC.TARIFF_OPTION_ID = TF.TARIFF_OPTION_ID
                         and  sysdate between TC.BEGIN_DATE and TC.END_DATE
                         and exists (
                                            select 1
                                             from congr_tarif cn,
                                                     tariffs_attrs atr
                                           where CN.TARIFFS_ATTRIBUTES_ID = ATR.TARIFFS_ATTRIBUTES_ID
                                               and ATR.ATTRIBUTES_NAME = 'ATR_OPTION'
                                               and CN.TARIFF_ID = GET_CURR_PHONE_TARIFF_ID(p_phone)
                                               and nvl(ATR.INT_TYPE, 0) = TC.TARIFF_OPTION_ID
                                         )
                       order  by
                              cost_for_month_rest
                    )
             where
                    rownum < 2;
          exception
            when no_data_found then
              if (nvl(pSchemeWork, 0) = 2) then
                begin
                  select
                      code,
                      VOLUME
                  into
                      v_tariff_code,
                      v_num0
                  from
                      (
                        select
                                TF.OPTION_CODE      code,
                                TF.INTERNET_VOLUME  volume,
                                case nvl(TF.DISCR_SPISANIE,0)
                                  when 0 then 
                                              nvl(TC.MONTHLY_COST,0)
                                              * 
                                                ceil(beeline_rest_api_pckg.intr_to_sec
                                                (
                                                    trunc(add_months(sysdate,1),'mm')
                                                  - systimestamp
                                                )/24/60/60)/
                                                  to_number(to_char(last_day(sysdate),'dd'))
                                  else nvl(TC.MONTHLY_COST,0)
                                end 
                                cost_for_month_rest
                          from
                                tariff_options  tf,
                                TARIFF_OPTION_COSTS tc
                         where
                                TF.IS_AUTO_INTERNET=1
                           and  TF.INTERNET_VOLUME > 0
                           and  TF.INTERNET_VOLUME < nvl(v_num,0)
                           and  TC.TARIFF_OPTION_ID = TF.TARIFF_OPTION_ID
                           and  sysdate between TC.BEGIN_DATE and TC.END_DATE
                           and exists (
                                            select 1
                                             from congr_tarif cn,
                                                     tariffs_attrs atr
                                           where CN.TARIFFS_ATTRIBUTES_ID = ATR.TARIFFS_ATTRIBUTES_ID
                                               and ATR.ATTRIBUTES_NAME = 'ATR_OPTION'
                                               and CN.TARIFF_ID = GET_CURR_PHONE_TARIFF_ID(p_phone)
                                               and nvl(ATR.INT_TYPE, 0) = TC.TARIFF_OPTION_ID
                                          )
                         order  by
                                volume desc, 
                                cost_for_month_rest
                      )
                  where
                      rownum < 2;
                exception
                  when others then
                    return(-1);
                end;
              else
                return(-1);
              end if;
          end;        
          --��� ����� �����. 1 � 3 ������ �������������� ��������
          if nvl(pSchemeWork, 0) = 1 then
            --��� ������ ����� ������� ����������� ����, ��� ���� 20�� �����. �������� 3 ����, �.�.
            --���� v_tariff_code = 20��, �� ��������� �� ����������. ���� = 3, �� ���. GPRS_U
            pCntTarCode := 0;
            select count(*)
               into pCntTarCode
              from TARIFF_OPTIONS tr
            where TR.OPTION_CODE = v_tariff_code
                and TR.TARIFF_OPTION_ID = 1857; --��� ����� GPRS_20G
            
            if nvl(pCntTarCode, 0) > 0 then
              --��������� ���������� �����������
              pCntTarCode := 0;
              SELECT count(*)
                 INTO pCntTarCode
                FROM GPRS_TURN_LOG lg
              WHERE ((LG.TARIFF_CODE = v_tariff_code)
                          or
                          (LG.TARIFF_CODE = 'GPRS_20GB')) --��������� ���������� ����������� GPRS_20GB
                   AND LG.PHONE = p_phone;
              --
              if nvl(pCntTarCode,0) > 2 then
                begin
                  --���������� ��������
                  select OP.OPTION_CODE, nvl(OP.INTERNET_VOLUME, 0)
                     into v_tariff_code, v_num0
                    from TARIFF_OPTIONS op
                  where nvl(OP.IS_UNLIM_INTERNET, 0) = 1
                      and OP.TARIFF_OPTION_ID = 68; --��� ����� GPRS_U
                exception
                  when others then
                    return(-1);
                end; 
              end if;
            end if;
          else
            if nvl(pSchemeWork, 0) = 3 then
              --��� ������ ����� ������� ����������� ����, ��� ���� 30�� �����. �������� 2 ����, �.�.
              --���� v_tariff_code = 30��, �� ��������� �� ����������. ���� = 2, �� ���. GPRS_U
              pCntTarCode := 0;
              select count(*)
                 into pCntTarCode
                from TARIFF_OPTIONS tr
              where TR.OPTION_CODE = v_tariff_code
                  and TR.TARIFF_OPTION_ID = 1866; --��� ����� GPRS_30G
              
              if nvl(pCntTarCode, 0) > 0 then
                --��������� ���������� �����������
                pCntTarCode := 0;
                SELECT count(*)
                   INTO pCntTarCode
                  FROM GPRS_TURN_LOG lg
                WHERE ((LG.TARIFF_CODE = v_tariff_code)
                            or
                            (LG.TARIFF_CODE = 'GPRS_30GB')) --��������� ���������� ����������� GPRS_30GB
                     AND LG.PHONE = p_phone;
                --
                if nvl(pCntTarCode, 0) > 1 then
                  begin
                    --���������� ��������
                    select OP.OPTION_CODE, nvl(OP.INTERNET_VOLUME, 0)
                       into v_tariff_code, v_num0
                      from TARIFF_OPTIONS op
                    where nvl(OP.IS_UNLIM_INTERNET, 0) = 1
                        and OP.TARIFF_OPTION_ID = 68; --��� ����� GPRS_U
                  exception
                    when others then
                      return(-1);
                  end; 
                end if;
              end if;
            end if;
          end if;  
          -- dbms_output.put_line('����� ����� ����� ��.: '||new_opt_id);
          -- dbms_output.put_line('��� : '||v_tariff_code);
          
          --������������ �����������
          --���� ����� GPRS_U � ����� ���� � ������������, �� ����� ������ �� ������
          SELECT count(*)
              INTO pCntTarCode
            FROM GPRS_PHONE_LIMIT lm
          WHERE lm.PHONE_NUMBER = p_phone;
          
          if (nvl(pCntTarCode, 0) > 0) and (v_tariff_code = 'GPRS_U') then
            return(-1);
          end if;
                  
          -- ��������� ������ �����, �� �� �������� ����                
          begin
            select count(*)
               into v_is_no_turn_on
              from table(get_serviceList(p_phone)) sr
            where sr.name = v_tariff_code_old
                and exists (
                                   select 1
                                    from tariff_options opt
                                  where OPT.OPTION_CODE = sr.name
                                      and nvl(OPT.IS_AUTO_INTERNET, 0) = 1
                                );
          exception
            when others then
              SELECT count(1)             
                   into v_is_no_turn_on
                FROM DB_LOADER_ACCOUNT_PHONE_OPTS
                   join tariff_options opt on opt.option_code=DB_LOADER_ACCOUNT_PHONE_OPTS.option_code 
              WHERE OPT.OPTION_CODE = v_tariff_code_old 
                   and nvl(OPT.IS_AUTO_INTERNET, 0) = 1 
                   and DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER=p_phone 
                   and DB_LOADER_ACCOUNT_PHONE_OPTS.turn_off_date is null;
          end;

          if nvl(v_is_no_turn_on,0)<>0 then
            if gprs_opts_turn_off(p_phone,v_tariff_code_old,'gprs_check_turn_tariff') <0 then 
              --return(-1);
              null;
            end if;
          end if;
            
          -- ����� ������� ���������� ���������� �����
          select log_id -- id ������ � ��������� ������������, ��������� ��� ��� ����� ����� ����������� � ������� ������
            into v_grs 
            from (
                  select 
                         log_id 
                    from 
                         gprs_turn_log 
                   where 
                         phone = p_phone and 
                         tariff_code = v_tariff_code_old 
                   order by 
                         date_off desc nulls first
                  ) 
            where rownum <2;
          if nvl(v_grs,0)<>0 then  
            update gprs_turn_log set date_off = systimestamp where log_id = v_grs;
          end if;
          update gprs_stat set is_checked = 1  where stat_id in (v_rec(1).stat_id, v_rec(2).stat_id) and nvl(is_checked,0)=0;

          --������ 3 ��������� ������� �����. �����.
          --����� �����. ������ �������� �� 30 �., � ����� ��������� ������� ������ ��� ������� �� rest_api.
          --���� ������ ����, �� ������ ��� �����., ����� �� �����., ������� ����� �������� 3 ����.
          --���� ������ �����. �� 2 ��� ��� �� �����������
          for nk in 1..3 loop
            -- ���������� ����� ����� � ��������� ���� ��������������� ���������� 22:00 ���������� ��� ������
            for i in 1..3 loop -- ����� 3 �������
              v_str0  := beeline_api_pckg.turn_tariff_option(p_phone,v_tariff_code, 1, null, null, 'AUTO_GPRS');
              v_str   := upper(substr(v_str0,1,5));

              v_grs  := get_resp_stat(-9000,'LogReqResp',case when v_str = 'ERROR' then 'Error turn tariff.' else 'Success turn tariff.' end, p_phone, 0,'gprs_check_turn_tariff',0
                                      ,'Phone number: '||p_phone||' | Tariff: '||v_tariff_code||' | User: '||user
                                      , v_str0);
              if v_str = 'ERROR' then 
                DBMS_LOCK.SLEEP(30);
              else
                exit;
              end if;
            end loop;
            --���� ���� ������ �����������, �� �������, �� ��� ��������� 3 ������� �����.
            if v_str = 'ERROR' then 
              --return(-1); 
              exit;
            end if;
            --���� ������ ����������, �� ��������� ������ �� ������� rest_api
            for ik in 1..3 loop
              DBMS_LOCK.SLEEP(30);
              pExistsOpt := 0;
               select count(*) 
                  into pExistsOpt
                from table(corp_mobile.beeline_rest_api_pckg.get_serviceList(p_phone))
              where name = v_tariff_code;
              --���� ������ �������, �� �������
              if nvl(pExistsOpt, 0) > 0 then
                exit; 
              end if;
            end loop;
            
            if nvl(pExistsOpt, 0) > 0 then 
              --return(-1); 
              exit;
            end if;
          end loop;
                             
          update gprs_stat set is_checked = 1  where stat_id = v_rec(3).stat_id and nvl(is_checked,0)=0;

          -- �������� ������ � gprs_stat � ������ ������� ����� � ������� ���������� ��������� �� ��������� ���������� ���������
          v_num := NEW_gprs_turn_log_id;
          insert into gprs_turn_log
              (
                LOG_ID,
                PHONE,
                TARIFF_CODE,
                DATE_ON,
                DATE_OFF
              ) 
            values 
              (
                v_num, 
                p_phone, v_tariff_code, 
                systimestamp, 
                null
              );
          --�������� ������ ������ � ������������ ������ ���� ������
          insert into gprs_stat
            (
              STAT_ID,
              TURN_LOG_ID,
              PHONE,
              TARIFF_CODE,
              INITVALUE,
              CURRVALUE,
              CURR_CHECK_DATE,
              NEXT_CHECK_DATE,
              CTRL_PNT,
              IS_CHECKED
            ) 
            values 
            (
              new_gprs_stat_id,
              v_num, 
              p_phone, 
              v_tariff_code, 
              v_num0, 
              v_num0, 
              systimestamp, 
              trunc(sysdate+c_turn_tariff_checktime_min/24/60,'MI'),
              1,
              0
            );
        else 
          --�������� �� ������ 20%
          -------------------------------
          -- ������� ���������� ����������� ����� ��� ��������� ������������ ���������, ��� ���������� ���������� ���������
          -- ��������� ����������� ������ ���������� ����������� ����� 
          select nvl(sum(ctrl_pnt),1) into ctrl_pnt_cnt from gprs_stat where phone = p_phone and tariff_code = v_tariff_code and ctrl_pnt<>0 and stat_id <>v_rec(3).stat_id;
          -- dbms_output.put_line('����� ����������� �����: '||ctrl_pnt_cnt);
          -- dbms_output.put_line('20% Check');
          if v_rec(3).currvalue <= v_rec(3).initvalue*(1-c_turn_tariff_ctrlpnt_inc*ctrl_pnt_cnt)  then -- ��-��������� 0.2, ������� ��������� ������ ���� ����� ��� init-20%*�����_�����������_�����
            -- ������ ����� ����������� ����� - ������ ����� ��������� ����������� ������ ����� ������ ������������ �������� (20% �� ���������)
            v_rec(3).ctrl_pnt := ceil((1-v_rec(3).currvalue/v_rec(3).initvalue)/c_turn_tariff_ctrlpnt_inc) - ctrl_pnt_cnt; -- �������� ��� ����������� ������� �����
          else -- ����� ���������� ����� ����������� �����
            v_rec(3).ctrl_pnt := 0;
          end if;
              
          -- ���������� ���� ��������� ��������
          ----------------------------------------------
          -- ����� � �������� � ��������� ��������
          v_num := abs(intr_to_sec(v_rec(3).curr_check_date-v_rec(2).curr_check_date));
          if v_num <=300 then v_num:= 600; end if; -- ���� ����� ����� � �������� �������� ������ 0 ��� ��� ����� 5 ���, �� ����������� 10 ���
          -- ���������� ����� ������� ���������������� � ��������� ��������, ���� 0. �� ��� 60 ���
          v_num0 := abs(v_rec(2).currvalue-v_rec(3).currvalue);
          --dbms_output.put_line('������������� ������� : '||v_num0||' �� '||v_num||' ������');
          --dbms_output.put_line('������� ������� ������������������: '||v_rec(3).currvalue);
          if v_num0 = 0 then
            delta_time_sec := c_turn_tariff_checktime_max*60;  -- ��-��������� 60 ���;
          else 
            -- ��������������� ����� ������ ����������� �����
            delta_time_sec :=v_rec(3).initvalue*c_turn_tariff_ctrlpnt_inc*ctrl_pnt_cnt*v_num/v_num0;  -- c_turn_tariff_ctrlpnt_inc (��-��������� 0.2)
            -- ��������������� ����� ������ ���� �������
            v_num0 := v_rec(3).currvalue*v_num/v_num0;
            --dbms_output.put_line('������ 20% ����� ������: '||delta_time_sec);
            --dbms_output.put_line('������ ���� ����� ������: '||v_num0);
            
            -- ���� ������ ���� ��������� ������� ������ 20% �� ������������� �� ����
            if delta_time_sec > v_num0 then 
              delta_time_sec := v_num0; 
              -- ���������� ���������� � ����������� ������ �������� ������������ ��������� 
              if delta_time_sec < c_turn_tariff_checktime_min then 
                delta_time_sec := c_turn_tariff_checktime_min;
              else                
                delta_time_sec := floor(delta_time_sec/(c_turn_tariff_checktime_min*60))*c_turn_tariff_checktime_min*60;
              end if;
            end if;            
            -- dbms_output.put_line('���������� ���� �������� � ��������: '||delta_time_sec);
            -- ���� ��������� ����� ����������� 20% ������� �� ���������� ������� ����� ����� 1 ����, �� ��������� ��������� ��������� ����� 1 ���
            if delta_time_sec/60/60 > 1 then delta_time_sec := c_turn_tariff_checktime_max*60; end if;
          end if;
          -- ����������� ���� ��������� ��������, ����������� �����
          update gprs_stat set is_checked = 1  where stat_id in (v_rec(1).stat_id, v_rec(2).stat_id) and nvl(is_checked,0)=0;
          update gprs_stat set next_check_date = trunc(sysdate+delta_time_sec/24/60/60,'MI'), ctrl_pnt = v_rec(3).ctrl_pnt  where stat_id=v_rec(3).stat_id;
              
        end if;
        commit;
      else
        -- dbms_output.put_line('v_tariff_code ������� ������ ��������, ������� ������! ');
        return(-1);
      end if;  
     exception
      when no_data_found then
        -- ��������� ����� � REST - ������� - ���� Skype TeleTie 2015-02-19 14:17
        select tariff_code, stat_id into v_tariff_code,v_num from (select tariff_code, stat_id from gprs_stat where phone=p_phone order by stat_id desc) where rownum<2;
        
        if v_tariff_code is null then return(-1); end if; -- ���� ��������� ���� ��� �� ����� � (-1)
        
        -- ctrl_pnt ��������� ����������� ������ ����������� �����  ����� ��� �� ���� ����� ������������ �������� (20% �� ���������)
        update gprs_stat set ctrl_pnt=ceil((1-currvalue/initvalue)/c_turn_tariff_ctrlpnt_inc), next_check_date = trunc(sysdate+c_turn_tariff_checktime_min/24/60,'MI') where stat_id = v_num;
        -- �������� gprs_turn_log ������� �� ���������.
        select 
               count(1)
          into
               i 
          from (
                select
                       distinct
                       tariff_code, 
                       turn_log_id 
                  from 
                       gprs_stat 
                 where 
                       phone=p_phone
               );
        j :=0; 
        for rec in (
                    select 
                           distinct
                           tariff_code, 
                           turn_log_id 
                      from 
                           (
                            select 
                                   tariff_code, 
                                   turn_log_id 
                              from 
                                   gprs_stat 
                             where 
                                   phone=p_phone
                               and not exists(
                                              select 
                                                     1 
                                                from 
                                                     gprs_turn_log 
                                               where 
                                                     log_id = turn_log_id
                                              ) 
                             order by 
                                   stat_id
                            )
                    ) 
        loop
          j := j + 1;
          if j = i then v_date := null; else v_date := systimestamp; end if;
          begin
            insert into gprs_turn_log
              ( 
                LOG_ID,
                PHONE,
                TARIFF_CODE,
                DATE_ON,
                DATE_OFF
              )
              values 
              (
                rec.turn_log_id, 
                p_phone, 
                rec.tariff_code, 
                sysdate, 
                v_date
              );
          exception
            when DUP_VAL_ON_INDEX then 
              v_grs  := get_resp_stat(-9000,'DUP_VAL_ON_INDEX','Error adding record in gprs_turn_log with turn_log_id from gprs_stat.', p_phone, 0,'gprs_check_turn_tariff',0
                                        ,'Phone number: '||p_phone||' | Tariff: '||rec.tariff_code||' | User: '||user
                                        , 'Error adding record in gprs_turn_log with turn_log_id from gprs_stat.');
          end;
        end loop;
        commit;
    end;

    return(0);
  end; 
--   gprs_check_turn_tariff ----  END  ------------------------------------------------------------------------------------

--   gprs_get_rest ----  BEGIN  ------------------------------------------------------------------------------------
  function gprs_get_rest (p_phone varchar2) return number as
    v_rests TRests;
    v_cnt  number(12) := 0;
    v_cnt2 number(12) := 0;
    v_res  number(1)  := 0;
  begin

      v_rests := beeline_api_pckg.rest_info_rests(p_phone);

      for i in 1..v_rests.count() loop

        -- ��������� ������� ������ ��� ������������� �������/���.�������
        select 
               count(1)
          into v_cnt                
          from (
                select 1 
                  from gprs_turn_log 
                 where phone = p_phone and 
                       date_off is null and
                       tariff_code=v_rests(i).soc
                 order by date_off desc  nulls first)
         where rownum <2;
        
        -- ��������� ���� ��������� �� ���� �����
        select 
               count(1)
          into v_cnt2
          from gprs_stat
         where phone = p_phone;
                          
        if (nvl(v_cnt,0) <> 0 or nvl(v_cnt2,0) = 0) and v_rests(i).unittype = 'INTERNET' and v_rests(i).resttype = 'AS' then
          -- ��������� ID ������ � ���� ������������ �������/�������
          v_cnt := null;
          if nvl(v_cnt2,0) <> 0 then
            select log_id
              into v_cnt 
              from (
                    select * 
                      from gprs_turn_log 
                     where phone=p_phone
                     order by log_id desc
                   )
             where 
                   tariff_code = v_rests(i).soc 
               and rownum <2;
          end if;
          insert into gprs_stat
            (
              STAT_ID,
              TURN_LOG_ID,
              PHONE,
              TARIFF_CODE,
              INITVALUE,
              CURRVALUE,
              CURR_CHECK_DATE,
              NEXT_CHECK_DATE,
              CTRL_PNT,
              IS_CHECKED
            ) 
            values
            (
              new_gprs_stat_id,
              nvl(v_cnt,NEW_gprs_turn_log_id),
              v_rests(i).phone,  
              v_rests(i).soc,
              v_rests(i).initialsize,
              v_rests(i).currvalue,
              systimestamp,
              null,
              1,
              0  
            );
          v_res:=1;
        end if;
      end loop;
      return(v_res);
  end;  
--   gprs_get_rest ----  END  ------------------------------------------------------------------------------------

--   gprs_check_tariff ----  BEGIN  ------------------------------------------------------------------------------------
  procedure gprs_check_tariff_test(p_flow_code varchar2) as -- ������ ������������ ���������� ������ GPRS_FLOWS (TEST)
    v_flow_id varchar2(32);
  begin
    select flow_id into v_flow_id from gprs_flows where flow_code=p_flow_code;
    
    if v_flow_id is not null then
      for rec in (select * from gprs_test_phone where flow_id = v_flow_id) loop
        gprs_check_phone_tariff(rec.phone);      
      end loop;
      
      update gprs_flows set last_check = systimestamp where flow_code = p_flow_code;
    end if; 
  end;
--   gprs_check_tariff ----  END  ------------------------------------------------------------------------------------

  procedure gprs_check_tariff_all_test as -- ������ ������������ ���� ������� (TEST)
  begin
    for rec in (select * from gprs_test_phone) loop
      gprs_check_phone_tariff(rec.phone);      
    end loop;
    update gprs_flows set last_check = systimestamp;
  end;

  procedure gprs_check_phone_all as -- ������ ������������ ���� ������� (�� CONTRACTS)
    v_tariff_code gprs_turn_log.tariff_code%type;
  begin
    for rec in (
                 select 
                   distinct phone_number_federal 
                 from 
                   v_contracts c 
                   join tariffs t on C.TARIFF_ID=t.tariff_id 
                 where C.CONTRACT_CANCEL_DATE is null
                   and t.is_auto_internet=1
                   and nvl((select phone_is_active from db_loader_account_phones where phone_number=c.phone_number_federal and year_month=to_char(sysdate,'yyyymm')),0) = 1
                   and nvl((select count(1) from mnp_remove mnp where mnp.temp_phone_number=c.phone_number_federal and mnp.date_created>=sysdate-1),0)=0 
                ) 
    loop
      -- dbms_output.put_line(rec.phone_number_federal||' | '||rec2.tariff_code);                
      gprs_check_phone_tariff(rec.phone_number_federal);      
    end loop;
  end;

  procedure gprs_check_phone_flow(p_STREAM_ID integer) as -- ������ ������������ ������� � ������ (�� CONTRACTS)
    v_tariff_code gprs_turn_log.tariff_code%type;
    c_STREAM_COUNT constant INTEGER := 10;
  begin
    --� ������� � 23 �� 00 ����� �� ������������ ��������� ����������, � ��������� ��� ��� - �� ��������� �����. ������. 
    --� ����� � ����, ���� ������ ������������� ���������� �� �����. ������� � 22:50 �� 00:10 ������ ����.
    if (to_date(to_char(sysdate, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= to_date(to_char(sysdate, 'DD.MM.YYYY')||' 00:10:00', 'DD.MM.YYYY HH24:MI:SS')) and
       (to_date(to_char(sysdate, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') <= to_date(to_char(sysdate, 'DD.MM.YYYY')||' 22:50:00', 'DD.MM.YYYY HH24:MI:SS')) then
      --
      for rec in (
                    select
                            phone_number_federal
                     from
                            (
                               select 
                                 distinct phone_number_federal 
                               from 
                                 v_contracts c 
                                 join tariffs t on C.TARIFF_ID=t.tariff_id 
                               where C.CONTRACT_CANCEL_DATE is null
                                 and t.is_auto_internet=1
                                 and nvl((select phone_is_active from db_loader_account_phones where phone_number=c.phone_number_federal and year_month=to_char(sysdate,'yyyymm')),0) = 1
                                 and nvl((select count(1) from mnp_remove mnp where mnp.temp_phone_number=c.phone_number_federal and mnp.date_created>=sysdate-1),0)=0
                                 --�������� ������, �� ������� ��� ����� �������� ������ � ������� ������, ����������� ������� � ��
                                 and not exists (
                                                        SELECT 1
                                                          FROM PHONE_CALC_ABON_TP_UNLIM_ON ph
                                                        WHERE PH.PHONE_NUMBER = c.phone_number_federal
                                                            AND PH.YEAR_MONTH = to_number(to_char(sysdate, 'YYYYMM'))
                                                            AND PH.TARIFF_ID = C.TARIFF_ID
                                                     )
                            )
                     where                           
                            MOD(TO_NUMBER(phone_number_federal), c_STREAM_COUNT) = p_STREAM_ID
                    ) 
      loop
        -- dbms_output.put_line(rec.phone_number_federal||' | '||rec2.tariff_code);    
        begin            
          gprs_check_phone_tariff(rec.phone_number_federal); 
        exception
          when others then
              NULL;
        end;     
      end loop;
    end if;
  end;

  procedure gprs_check_phone_tariff(p_phone varchar2) as -- �������� �������� �� ������������� ��������� � ���������������
    v_num0          number;
    v_num1          number;
    v_is_speed3b2b  number := 0;
    v_cnt_internet  number := 0;
    v_is_unlim_internet number := 0;
  begin

    -- �� ������������ ���� �� ����-��������   
    select
            count(1)
      into  
            v_num0
      from 
            v_contracts ct,
            tariffs tf
     where CT.PHONE_NUMBER_FEDERAL=p_phone
       and  CT.CONTRACT_CANCEL_DATE is null
       and  TF.TARIFF_ID=CT.TARIFF_ID
       and  TF.IS_AUTO_INTERNET = 1;
    if nvl(v_num0,0) = 0 then return; end if;
    
    -- ����� ������������, ���� ������� �������� ����� �� ����� ���� IS_UNLIM_INTERNET (=0)
    select sum(opt.is_unlim_internet) 
      into v_is_unlim_internet 
      from gprs_turn_log gtl
      join tariff_options opt on opt.option_code=gtl.tariff_code
     where phone=p_phone 
       and date_off is null 
     order by date_off desc;

    -- ����� ����������, ���� �� �� ������������ PHONE_IS_ACTIVE (=1)
    select sum(phone_is_active) 
      into v_num0 
      from db_loader_account_phones 
     where phone_number=p_phone 
       and year_month=to_char(sysdate,'yyyymm');
       
    -- � �� MNP 
    select count(1) 
      into v_num1 
      from mnp_remove 
     where temp_phone_number=p_phone
       and date_created>=sysdate-1;
    
    if nvl(v_is_unlim_internet,0)=0 and 
       nvl(v_num0,0) <> 0 and 
       nvl(v_num1,0) = 0
    then                                 
      select count(1) into v_num0 from gprs_stat where phone = p_phone and curr_check_date between trunc(sysdate,'MM') and sysdate;
      if v_num0=0 then -- ���� ��� ��������� � ������� ������
        --dbms_output.put_line('�������: '||p_phone);
        if gprs_get_rest(p_phone)=1 then -- ������������ ������ ���������, ���� ������ �� ������� ���� ���������;
          v_num0 := gprs_check_turn_tariff(p_phone); -- ��������� ��������� ����������
        end if;
      else
        -- ��������� ��� ����� �������� � �������� ��������� (����� � ���������� ����� next_check_date ��� �������� ������),
        --  �.�. ���������� � �������� ����� ������� � ������� ����������� ������ ������������
        select count(1) into v_num0 from (select 1 from gprs_stat gs
                                            where gs.phone = p_phone and gs.is_checked=0 
                                              and GS.NEXT_CHECK_DATE is not null 
                                              and GS.NEXT_CHECK_DATE <= sysdate 
                                            order by stat_id desc
                                         ) 
                                    where rownum <2;
        if nvl(v_num0,0) >0 -- ����� �������� � �������� ���������
        then
          
          if gprs_get_rest(p_phone)=1  then -- � ������ �� ������� ���� ���������
            -- dbms_output.put_line('��������� 1: '||p_phone);
          
            v_num0 := gprs_check_turn_tariff(p_phone); -- ��������� ��������� ����������
          
          else -- ��������� ������� ������������� ���.������
            -- dbms_output.put_line('���������������: '||p_phone);
            select -- �������� ����������� �������� �������� (<>0)
                   count(1)
              into
                   v_is_speed3b2b
              from 
                   db_loader_account_phone_opts
             where
                   phone_number=p_phone
               and option_code='SPEED3B2B'
               and turn_off_date is null
               and year_month=to_char(sysdate,'yyyymm');
               
            SELECT -- ���-�� ���.������� ����-�������� (<>0)
                   count(1)
              into
                   v_cnt_internet
              FROM
                   DB_LOADER_ACCOUNT_PHONE_OPTS
              join 
                   tariff_options opt on opt.option_code=DB_LOADER_ACCOUNT_PHONE_OPTS.option_code 
             WHERE
                   OPT.IS_AUTO_INTERNET = 1 and
                   DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER=p_phone;

            if 
              nvl(v_is_speed3b2b,0)  <>0 and
              nvl(v_cnt_internet,0)  <>0 
            then
              v_num0 := gprs_check_turn_tariff(p_phone); 
            end if;
          end if;
        end if; 
      end if;
    end if;
  end;

  procedure gprs_init_new_month as -- ������������� ������ ������
  begin
    -- ������� � ����� ������ �� ��������� �����
    for rec in (select distinct phone from gprs_stat) loop
        insert into gprs_stat_hist 
            (
              STAT_ID,
              TURN_LOG_ID,
              PHONE,
              TARIFF_CODE,
              INITVALUE,
              CURRVALUE,
              CURR_CHECK_DATE,
              NEXT_CHECK_DATE,
              CTRL_PNT,
              IS_CHECKED,
              IS_TARIFF
            ) 
          select 
              gs.STAT_ID,
              gs.TURN_LOG_ID,
              gs.PHONE,
              gs.TARIFF_CODE,
              gs.INITVALUE,
              gs.CURRVALUE,
              gs.CURR_CHECK_DATE,
              gs.NEXT_CHECK_DATE,
              gs.CTRL_PNT,
              gs.IS_CHECKED,
              nvl((case when exists(select 1 from tariffs c where c.tariff_code=gs.TARIFF_CODE) then 1 else 0 end),0)
            from 
              gprs_stat gs
            where 
                  phone=rec.phone
              and CURR_CHECK_DATE<trunc(sysdate);
        delete from gprs_stat where phone=rec.phone and CURR_CHECK_DATE<trunc(sysdate);
    end loop;
    
    for rec in (select distinct phone from gprs_turn_log) loop
        insert into gprs_turn_log_hist
          ( 
            LOG_ID,
            PHONE,
            TARIFF_CODE,
            DATE_ON,
            DATE_OFF
          )
          select 
            LOG_ID,
            PHONE,
            TARIFF_CODE,
            DATE_ON,
            DATE_OFF
          from 
            gprs_turn_log 
          where 
            phone=rec.phone and date_on<trunc(sysdate);
        delete from gprs_turn_log where phone=rec.phone and date_on<trunc(sysdate);
    end loop;
    -- ������� ���������� ������ (������ 3-� �������)
    -- delete from gprs_stat_hist     where curr_check_date < to_date(to_char(trunc(add_months(sysdate,-3),'MM'),'YYYY-MM-DD ')||'00:00','YYYY-MM-DD HH24:MI');
    -- delete from gprs_turn_log_hist where date_on < to_date(to_char(trunc(add_months(sysdate,-3),'MM'),'YYYY-MM-DD ')||'00:00','YYYY-MM-DD HH24:MI');
  end;
 
  function gprs_opts_turn_off(p_phone varchar2, p_opts_code varchar2, p_note varchar2) return number as -- ��������� ����
    v_str  varchar2(1024);
    v_str0 varchar2(1024);
    v_grs  number(12);
    i      number(12) := 0;
  begin
    -- �� ������������ ���� �� ����-��������   
    select
            count(1)
      into  
            v_grs
      from 
            v_contracts ct,
            tariffs tf
     where CT.PHONE_NUMBER_FEDERAL=p_phone
       and  CT.CONTRACT_CANCEL_DATE is null
       and  TF.TARIFF_ID=CT.TARIFF_ID
       and  TF.IS_AUTO_INTERNET = 1;
    if nvl(v_grs,0) = 0 then return(-1); end if;

    -- ��������� ������ �����, �� �� �������� ����
    select count(1) into i from tariff_options where option_code = p_opts_code; 
    if i<>0 then -- ���� ��� ���.����� (�� �����), �� ��������� ���
      --dbms_output.put_line('Is option.');
      v_str0 := beeline_api_pckg.turn_tariff_option(p_phone,p_opts_code, 0, null, null, 'AUTO_GPRS');
      v_str  := upper(substr(v_str0,1,6));

      v_grs  := get_resp_stat(-9001,'LogReqResp',case when v_str = '������' then 'Success turn off option.' else 'Error turn off option.' end, p_phone, 0, p_note,0
                                ,'Phone number: '||p_phone||' | Tariff: '||p_opts_code||' | User: '||user
                                , v_str0);
      if v_str <> '������' then return(-1); end if;
      -- ����� ������� ���������� ���������� �����
      begin
        select log_id -- id ������ � ��������� ������������, ��������� ��� ��� ����� ����� ����������� � ������� ������
          into v_grs 
          from (
                select 
                       log_id 
                  from 
                       gprs_turn_log 
                 where 
                       phone = p_phone and 
                       tariff_code = p_opts_code 
                 order by 
                       date_off desc nulls first
                ) 
          where rownum <2;
        if nvl(v_grs,0)<>0 then  
          update gprs_turn_log set date_off = systimestamp where log_id = v_grs;
        end if;
        update gprs_stat set is_checked = 1  where phone=p_phone and tariff_code = p_opts_code and is_checked=0;
        commit;
      exception
        when others then
          null;
      end;
    end if;
    return (0);
  end;

  procedure  gprs_opts_turn_off_all(p_phone varchar2, p_note varchar2) as -- ��������� ��� ���.�����, ����� ��������� �����, �� ��������� ������
    v_grs  number(12);
  begin
    for rec in (select distinct phone, tariff_code from gprs_turn_log where phone = p_phone and date_off is null) loop    
      -- dbms_output.put_line(rec.phone||' | '||rec.tariff_code||' | ');
      v_grs:=gprs_opts_turn_off(p_phone, rec.tariff_code,nvl(p_note,'gprs_opts_turn_off_all'));
    end loop;
  end;

  procedure  gprs_opts_turn_off_all_phones(p_STREAM_ID integer, p_STREAM_COUNT integer) as -- ��������� ��� ���.�����, ����� ��������� �����, �� ���� �������
    v_grs  number(12);
  begin
    for rec in (
                      select distinct phone, tariff_code 
                        from gprs_turn_log 
                      where date_off is null
                          and MOD(TO_NUMBER(phone), p_STREAM_COUNT) = p_STREAM_ID
                  ) 
    loop    
--      dbms_output.put_line(rec.phone||' | '||rec.tariff_code||' | ');
      v_grs:=gprs_opts_turn_off(rec.phone, rec.tariff_code,'gprs_opts_turn_off_all_phones - End of month.');
    end loop;
  end;
  
  procedure gprs_opts_turn_off_phone_err as -- ��������� ��� ���.�����, ����� ��������� �����, �� �������, �� ������� ���� ������ ���������� ��������-����� � ����� ������
    v_grs  number(12);
  begin
    for rec in (
                        select 
                            rs.phone,
                            substr(RS.REQUEST,  instr(RS.REQUEST, 'Tariff:')+Length('Tariff: '),  (instr(RS.REQUEST, 'User:')-3)-(instr(RS.REQUEST, 'Tariff:')+Length('Tariff: '))) code_opt                                         
                          from db_loader_resp_log rs
                        where RS.NOTE = 'gprs_opts_turn_off_all_phones - End of month.'
                            and trunc(RS.LOAD_DATE) = trunc(sysdate)
                            and (
                                     upper(rs.message) like ('%ERR%') or
                                     upper(rs.status)  like ('%ERR%')
                                  )
                            and RS.LOAD_DATE = (
                                                                select max(RS1.LOAD_DATE)
                                                                  from db_loader_resp_log rs1
                                                                where RS1.PHONE = RS.PHONE
                                                                    and RS1.NOTE = 'gprs_opts_turn_off_all_phones - End of month.'
                                                                    and (
                                                                             upper(rs1.message) like ('%ERR%') or
                                                                             upper(rs1.status)  like ('%ERR%')
                                                                          )
                                                             )
                            and not exists (
                                                     select 1
                                                       from db_loader_resp_log rs2
                                                     where RS2.PHONE = RS.PHONE
                                                         and RS2.NOTE = 'gprs_opts_turn_off_all_phones - End of month.'
                                                         and upper(rs2.message) not like ('%ERR%')
                                                         and RS2.LOAD_DATE > RS.LOAD_DATE  
                                                 )
                            and exists (
                                               select 1
                                                 from DB_LOADER_ACCOUNT_PHONES db
                                               where DB.PHONE_NUMBER = rs.phone
                                                   and DB.YEAR_MONTH = (
                                                                                         select max(DBM.YEAR_MONTH)
                                                                                           from DB_LOADER_ACCOUNT_PHONES dbm
                                                                                         where DBM.PHONE_NUMBER = DB.PHONE_NUMBER
                                                                                      )
                                                   and nvl(DB.PHONE_IS_ACTIVE, 0) = 1
                                            )
                  ) 
    loop    
      v_grs:=gprs_opts_turn_off(rec.phone, rec.code_opt,'gprs_opts_turn_off_all_phones - End of month.');
    end loop;
  end;

  function rep_gprs_autoturn_mon(p_phone varchar2 default null) return tbl_rep_gprs_autoturn_1 pipelined as -- ����� �������. ������������ �� ������� ����� �� ������ ��������.
                                                                                                            -- (���� �� �������� �������� ������ ������ �� ���� �������)
    /*  
    #2674
    ����� �������. ������������ �� ������� ����� �� ������ ��������.
    ����� ��������
    �������� ����
    ������
    ����.����� �� ��������
    FIVIP400Z - ����� �� ��� ������
    FIVIP600Z - ����� �� ��� ������
    FIVIP800Z - ����� �� ��� ������
    GPRS_U - ����� �� ��� ������
    ����� ������������ ������ ��������
    ����� ���������� ��������� �����
    ����� ���������� �� �����
    SPEED3B2B - �����������, ���� ����������, ��������.

    */
    type vt_phone is table of beeline_rest_api_pckg.Trow_rep_gprs_autoturn_1 index by pls_integer;
    v_rec         vt_phone;
    v_stmt        varchar2(4000);
    v_num         number(18);
    v_sum         number(18,2);
    v_first_day   date := to_date(to_char(trunc(sysdate,'MM'),'YYYYMM')||'01 00:00:00','YYYYMMDD hh24:mi:ss');
    v_last_day    date := to_date(to_char(sysdate,'YYYYMMDD')||' 23:59:59','YYYYMMDD hh24:mi:ss');

    type t_stat2 is record
      (
        phone           varchar2(10),
        initvalue       integer,
        currvalue       integer,
        curr_check_date timestamp
      );
    type t_stats is table of t_stat2 index by pls_integer;
    vt_stat t_stats;
    res_opt varchar2(5000);

  begin
  v_stmt :=
    'select
        distinct 
              gs.phone,  
              C.CONTRACT_NUM,
              C.CONTRACT_DATE,
              case when lap.PHONE_IS_ACTIVE=0 then ''����������'' else '''' end,
              lap.PHONE_IS_ACTIVE,            
              (select case when phone_is_active=0 then begin_date else null end from DB_LOADER_ACCOUNT_PHONE_HISTS where PHONE_NUMBER=gs.phone and end_date =to_date(''30000101'',''yyyymmdd'')) BEGIN_DATE,
              (select DOP_STATUS_NAME from CONTRACT_DOP_STATUSES where DOP_STATUS_ID = C.DOP_STATUS and rownum <2 ) DOP_STATUS,
              C.TARIFF_ID,               
              TF.TARIFF_CODE,
              TF.TARIFF_NAME,
              nvl(ICB.BALANCE,0) BALANCE,
              nvl(TF.MONTHLY_PAYMENT,0),
              nvl(TF.OPERATOR_MONTHLY_ABON_ACTIV,0),
              0,            
              0,            
              0,
              0,
              0,               
              0,               
              0,            
              0,
              0,
              0,
              0,            
              null,
              0,
              0,            
              0,            
              0,
              0,            
              0,            
              '''',
              0  
      from
          gprs_stat gs
          join v_contracts c on C.PHONE_NUMBER_FEDERAL=GS.PHONE
          left outer join tariffs tf  on TF.TARIFF_ID=C.TARIFF_ID
          left outer join iot_current_balance icb on icb.phone_number = GS.PHONE
          join db_loader_account_phones lap on lap.PHONE_NUMBER=GS.PHONE
      where
              nvl(c.CONTRACT_CANCEL_DATE,to_date(''31.01.3000'',''dd.mm.yyyy'')) >= trunc(sysdate,''MM'')
          and lap.year_month=to_char(sysdate,''yyyymm'')
          and C.TARIFF_ID >0';
          
  if p_phone is not null then v_stmt := v_stmt||' and gs.phone = '''||p_phone||''''; end if;
  
  execute immediate v_stmt bulk collect INTO v_rec ;
  
  for i in 1..v_rec.count 
    loop

      -- ����� ������������ ������ ��������
      select
              total_traff
        into
              v_rec(i).total_traff
        from
              table(calc_traff(v_rec(i).phone));

      -- ������� ���������� ������������� ������� � ����� �� ������� ����
      v_sum:=0;
      for r_opt in (select distinct tariff_code from gprs_stat where phone=v_rec(i).phone and tariff_code in (select option_code from tariff_options where is_auto_internet=1) order by tariff_code)
      loop
        select count(1) into v_sum from gprs_turn_log where phone=v_rec(i).phone and tariff_code = r_opt.tariff_code;
        
        select 
               r.monthly_cost
          into v_num
          from
               (
                select tc.tariff_option_cost_id,max(tc.date_created)
                  from tariff_option_costs tc
                  join tariff_options t on t.TARIFF_option_id=tc.tariff_option_id
                  where OPTION_CODE=r_opt.tariff_code
                            and v_last_day between tc.begin_date and tc.end_date
                  group by tc.tariff_option_cost_id
                  order by max(tc.date_created) desc
               ) q
               join tariff_option_costs r on r.tariff_option_cost_id=q.tariff_option_cost_id
         where rownum <2;

        v_sum := v_sum*nvl(v_num,0);  
        case r_opt.tariff_code 
          when 'FI550Z' then v_rec(i).FI550Z :=v_sum;
          when 'FI850Z' then v_rec(i).FI850Z :=v_sum;
          when 'FI1150Z'then v_rec(i).FI1150Z:=v_sum;
          when 'FSG_TT1'then v_rec(i).FSG_TT1:=v_sum;
          when 'FSG_TT2'then v_rec(i).FSG_TT2:=v_sum;
          when 'FSG_TT3'then v_rec(i).FSG_TT3:=v_sum;
          when 'GPRS_20GB' then v_rec(i).GPRS_20GB:=v_sum;
          when 'GPRS_30GB' then v_rec(i).GPRS_30GB:=v_sum;
          when 'GPRS_20G' then v_rec(i).GPRS_20G:=v_sum;
          when 'GPRS_30G' then v_rec(i).GPRS_30G:=v_sum;
          when 'GPRS_U' then 
            begin
              for rec_gprs in (
                                select -- �������� GPRS_U �� �������
                                       ceil(beeline_rest_api_pckg.intr_to_sec(nvl(date_off,trunc(add_months(sysdate,1),'mm'))-g.date_on)/24/60/60) use_days,
                                       g.date_on date_on
                                  from 
                                       gprs_turn_log g
                                 where 
                                       phone=v_rec(i).phone 
                                   and tariff_code = 'GPRS_U'
                              ) loop
                v_rec(i).GPRS_U     := nvl(v_rec(i).GPRS_U,0)+nvl(rec_gprs.use_days,0);
                v_rec(i).GPRS_U_ON  := rec_gprs.date_on;
              end loop;
              v_rec(i).GPRS_U := nvl(v_num,0)*nvl(v_rec(i).GPRS_U,0)/to_number(to_char(last_day(sysdate),'dd'));
            end;
          else v_rec(i).unknown:=v_rec(i).unknown+v_sum;
        end case;  
      end loop;

      
      -- ������� ���������� (�������� � �����������)    
      select 
         sum(payment_sum)
       into
         v_sum
       from
         db_loader_payments
        where
          phone_number=v_rec(i).phone and 
          payment_date between v_first_day and v_last_day 
         ;
      select 
         sum(payment_sum)
       into
         v_rec(i).payments
       from
           received_payments
        where
          phone_number=v_rec(i).phone and 
          payment_date_time between v_first_day and v_last_day 
         ;
      v_rec(i).payments := nvl(v_rec(i).payments,0)+nvl(v_sum,0);

      -- ���������� ��������� �����    
      select
          sum(ZEROCOST_OUTCOME_MINUTES+CALLS_MINUTES)
        into
          v_rec(i).outcom_mi 
        from 
          db_loader_phone_stat
        where
          phone_number=v_rec(i).phone and 
          year_month=to_char(sysdate,'yyyymm')
         ;
      
      -- ������� ����������� �������� tariff_options.OPTION_CODE = 'SPEED3B2B'      
      select
          count(1)
        into 
          v_rec(i).SPEED3B2B
        from 
         db_loader_account_phone_opts
        where
          phone_number=v_rec(i).phone and  
          option_code='SPEED3B2B' and
          turn_off_date is null and  
          year_month=to_char(sysdate,'yyyymm')
         ; 
         
      --���� ������� ������� ����������� ��������, �� ��������� ������ � ��������� ������ �������
      if (nvl(v_rec(i).SPEED3B2B,0))<>0 then
        res_opt := beeline_api_pckg.phone_options(to_number(v_rec(i).phone));
        
        -- ������� ����������� �������� tariff_options.OPTION_CODE = 'SPEED3B2B'      
        select count(1)
           into v_rec(i).SPEED3B2B
          from db_loader_account_phone_opts
        where phone_number=v_rec(i).phone 
            and option_code='SPEED3B2B' 
            and turn_off_date is null 
            and year_month=to_char(sysdate,'yyyymm');  
      end if;   

      case when (nvl(v_rec(i).SPEED3B2B,0))<>0 then v_rec(i).SPEED3B2B_WORD:='��������'; else v_rec(i).SPEED3B2B_WORD:=''; end case;
           
      -- ������� ����������� �������� tariff_options.OPTION_CODE = 'DTM41'      
      select
          count(1)
        into 
          v_rec(i).DTM41
        from 
         db_loader_account_phone_opts
        where
          phone_number=v_rec(i).phone and  
          option_code='DTM41' and
          turn_off_date is null and  
          year_month=to_char(sysdate,'yyyymm')
         ;    
      case when nvl(v_rec(i).DTM41,0) <> 0 then v_rec(i).DTM41 := 1; else v_rec(i).DTM41 := 0; end case;
      
      --������� ������ MGN500MIN
      select count(1)
         into v_rec(i).MGN500MIN
       from db_loader_account_phone_opts op
       where op.phone_number= v_rec(i).phone
           and op.option_code='MGN500MIN' 
           and op.year_month=to_char(sysdate,'yyyymm');
      --���� ������� ������� ������ �������� �� ����������� �����
      if (nvl(v_rec(i).MGN500MIN,0) <> 0)  then
        select SUM(ceil(nvl(OP.TURN_OFF_DATE,trunc(add_months(OP.TURN_ON_DATE,1),'mm'))-OP.TURN_ON_DATE)*(nvl(TC.MONTHLY_COST, 0)/to_number(to_char(last_day(OP.TURN_ON_DATE),'dd'))))
           into v_rec(i).MGN500MIN
          from db_loader_account_phone_opts op,
                  tariff_options  tf,
                  TARIFF_OPTION_COSTS tc
        where OP.OPTION_CODE = TF.OPTION_CODE
           and TC.TARIFF_OPTION_ID = tf.TARIFF_OPTION_ID
           and OP.TURN_ON_DATE between TC.BEGIN_DATE and TC.END_DATE
           and op.phone_number=v_rec(i).phone
           and op.option_code='MGN500MIN' 
           and op.year_month=to_char(sysdate,'yyyymm');
      end if;
        
      pipe row(v_rec(i)); 

    end loop;

  end;


  function rep_gprs_autoturn_prev(p_phone varchar2 default null, p_year_month varchar2 default null) return tbl_rep_gprs_autoturn_1 pipelined as 
   -- ����� �������. ������������ �� ��������� ������
   -- (���� �� �������� �������� ������ ������ �� ���� ������� �� ������� �����)
    /*  
  
    #2703
      ����� ��������
      �������� ����
      ������
      ����.����� �� ��������
      ����.����� �� ������� �� �����
      ���������� - ����.����� �������� ����� ����.����� ������ �� �����
      FIVIP400Z - ����� �� ��� ������
      FIVIP600Z - ����� �� ��� ������
      FIVIP800Z - ����� �� ��� ������
      GPRS_U - ����� �� ��� ������
      ����� ������������ ������ ��������
      ����� ���������� ��������� �����
      ����� ���������� �� �����

    */
    type vt_phone is table of beeline_rest_api_pckg.Trow_rep_gprs_autoturn_1 index by pls_integer;
    v_rec         vt_phone;
    v_stmt        varchar2(4000);
    v_sum         number(18,2);
    v_year_month  varchar2(6);
    v_first_day   date;
    v_last_day    date;
    v_num number(18);
  begin
    if p_year_month is null then v_year_month := to_char(add_months(sysdate,-1),'yyyymm'); else v_year_month := p_year_month; end if;
    v_first_day := to_date(v_year_month||'01 00:00:00','YYYYMMDD hh24:mi:ss');
    v_last_day  := to_date(v_year_month||to_char(last_day(to_date(v_year_month,'yyyymm')),'DD')||' 23:59:59','YYYYMMDD hh24:mi:ss');
  

    v_stmt :=
      'select distinct 
              gs.phone,  
              null,
              null,
              null,            
              null,
              null,            
              null,
              0,               
              gs.TARIFF_CODE,
              null,
              0,            
              0,
              0,            
              0,            
              0,            
              0,
              0,            
              0,            
              0,               
              0,
              0,
              0, 
              0,
              0,              
              null,
              0,
              0,            
              0,            
              0,
              0,            
              0,            
              null,
              0  
        from
             gprs_stat_hist gs
       where
             gs.IS_TARIFF = 1
            and gs.curr_check_date 
                between to_date('''||v_first_day||''') 
                    and to_date('''||v_last_day||''')';
            
    if p_phone is not null then v_stmt := v_stmt||' and gs.phone = '''||p_phone||''''; end if;
    
  execute immediate v_stmt bulk collect INTO v_rec ;
  for i in 1..v_rec.count loop
    begin
      select
             CONTRACT_NUM,
             CONTRACT_DATE
        into
             v_rec(i).CONTRACT_NUM,
             v_rec(i).CONTRACT_DATE
        from
             (
              select *
                from contracts
               where phone_number_federal = v_rec(i).phone
                 and NVL(curr_tariff_id, GET_CURR_PHONE_TARIFF_ID(phone_number_federal)) > 0
               order by date_last_updated desc
              )
       where                   
             rownum<2;
    exception
      when no_data_found then 
        v_rec(i).CONTRACT_NUM  := null;
        v_rec(i).CONTRACT_DATE := null;
    end;

      -- ������
      begin
        select
               bhr.balance
          into
               v_rec(i).balance
          from
               (
                select  
                       phone_number,
                       max(bh.last_update) last_update
                  from iot_balance_history bh
                 where
                       phone_number=v_rec(i).phone
                       and to_char(bh.last_update,'mm')=substr(v_year_month,5,2)
                 group by
                       phone_number      
               ) cc
               join iot_balance_history bhr 
                 on bhr.phone_number=cc.phone_number
         where cc.last_update = bhr.last_update;
      exception
        when no_data_found then 
          v_rec(i).balance:=0;
      end;
      
      -- ����.����� �� ��������
      for rec in (select abon_tp
                   from tarifer_bill_for_clients
                  where
                        year_month=v_year_month
                    and phone_number=v_rec(i).phone
                 )
      loop
        v_rec(i).tariff := v_rec(i).tariff+ nvl(rec.abon_tp,0);
      end loop;
      
      -- ����.����� �� ������� �� �����
      for rec in (select abon_main+single_main as abon_oper
                   from db_loader_full_finance_bill
                  where
                        year_month=v_year_month
                    and phone_number=v_rec(i).phone
                 )
      loop
        v_rec(i).tariff_oper := v_rec(i).tariff_oper+ nvl(rec.abon_oper,0);
      end loop;

      -- ����� ������������ ������ �������� �� ������ �����������
      -- ���������� ��������� �����    
      begin
        select
              nvl(INTERNET_MB,0),
              nvl(ZEROCOST_OUTCOME_MINUTES+CALLS_MINUTES,0)
          into
              v_rec(i).total_traff,
              v_rec(i).outcom_mi 
          from
              DB_LOADER_PHONE_STAT
         where
              phone_number = v_rec(i).phone
           and  year_month   = v_year_month;
      exception
        when others then
          v_rec(i).total_traff := 0;
          v_rec(i).outcom_mi := 0;  
      end;     


      -- ������� ���������� ������������� ������� � ����� �� ������� ����
      for r_opt in (select distinct tariff_code from gprs_stat_hist where phone=v_rec(i).phone and  curr_check_date between v_first_day and v_last_day and tariff_code in (select option_code from tariff_options where is_auto_internet=1) order by tariff_code)
      loop
        select count(1) into v_sum from gprs_turn_log_hist where phone=v_rec(i).phone and tariff_code = r_opt.tariff_code and date_on between v_first_day and v_last_day;
        select 
                r.monthly_cost
          into
                v_num
          from
                (
                  select 
                          tc.tariff_option_cost_id,
                          max(tc.date_created)
                    from
                          tariff_option_costs tc
                    join
                          tariff_options t 
                      on  
                          t.TARIFF_option_id=tc.tariff_option_id
                   where 
                          OPTION_CODE=r_opt.tariff_code
                     and  v_last_day between tc.begin_date and tc.end_date
                   group  by 
                          tc.tariff_option_cost_id
                   order  by 
                          max(tc.date_created) desc
                ) q
                join 
                      tariff_option_costs r 
                  on
                      r.tariff_option_cost_id=q.tariff_option_cost_id
         where 
                rownum <2;
        v_sum := v_sum*nvl(v_num,0);
          
        case r_opt.tariff_code 
          when 'FI550Z' then v_rec(i).FI550Z :=v_sum;
          when 'FI850Z' then v_rec(i).FI850Z :=v_sum;
          when 'FI1150Z'then v_rec(i).FI1150Z:=v_sum;
          when 'FSG_TT1'then v_rec(i).FSG_TT1:=v_sum;
          when 'FSG_TT2'then v_rec(i).FSG_TT2:=v_sum;
          when 'FSG_TT3'then v_rec(i).FSG_TT3:=v_sum;
          when 'GPRS_20GB'then v_rec(i).GPRS_20GB:=v_sum;
          when 'GPRS_30GB'then v_rec(i).GPRS_30GB:=v_sum;
          when 'GPRS_20G'then v_rec(i).GPRS_20G:=v_sum;
          when 'GPRS_30G'then v_rec(i).GPRS_30G:=v_sum;
          when 'GPRS_U' then 
            begin
              for rec_gprs in (
                                select -- �������� GPRS_U �� �������
                                       ceil(beeline_rest_api_pckg.intr_to_sec(nvl(date_off,v_last_day)-g.date_on)/24/60/60) use_days,
                                       g.date_on date_on
                                  from 
                                       gprs_turn_log_hist g
                                 where 
                                       phone=v_rec(i).phone 
                                   and tariff_code = 'GPRS_U'
                              ) loop
                v_rec(i).GPRS_U     := nvl(v_rec(i).GPRS_U,0)+nvl(rec_gprs.use_days,0);
                v_rec(i).GPRS_U_ON  := rec_gprs.date_on;
              end loop;
              v_rec(i).GPRS_U := nvl(v_num,0)*nvl(v_rec(i).GPRS_U,0)/to_number(to_char(v_last_day,'dd'));
            end;
          else v_rec(i).unknown:=v_rec(i).unknown+v_sum;
        end case;  
      end loop;
 

      -- ������� ���������� (�������� � �����������)    
      begin
        select 
         sum(payment_sum)
        into
         v_sum
        from
         db_loader_payments
        where
          phone_number=v_rec(i).phone and 
          payment_date between v_first_day and v_last_day 
         ;
      exception
        when others then
          v_sum := 0;  
      end;
      
      begin
        select 
         sum(payment_sum)
         into
           v_rec(i).payments
         from
           received_payments
        where
          phone_number=v_rec(i).phone and 
          payment_date_time between v_first_day and v_last_day 
         ;
      exception
        when others then
         v_rec(i).payments := 0;  
      end;
      
      v_rec(i).payments := nvl(v_rec(i).payments,0)+nvl(v_sum,0);

      --������� ������ MGN500MIN
      select count(1)
         into v_rec(i).MGN500MIN
       from db_loader_account_phone_opts op
       where op.phone_number= v_rec(i).phone
           and op.option_code='MGN500MIN' 
           and op.year_month=v_year_month;
      --���� ������� ������� ������ �������� �� ����������� �����
      if (nvl(v_rec(i).MGN500MIN,0) <> 0)  then
        select SUM(ceil(nvl(OP.TURN_OFF_DATE,trunc(add_months(OP.TURN_ON_DATE,1),'mm'))-OP.TURN_ON_DATE)*(nvl(TC.MONTHLY_COST, 0)/to_number(to_char(last_day(OP.TURN_ON_DATE),'dd'))))
           into v_rec(i).MGN500MIN
          from db_loader_account_phone_opts op,
                  tariff_options  tf,
                  TARIFF_OPTION_COSTS tc
        where OP.OPTION_CODE = TF.OPTION_CODE
           and TC.TARIFF_OPTION_ID = tf.TARIFF_OPTION_ID
           and OP.TURN_ON_DATE between TC.BEGIN_DATE and TC.END_DATE
           and op.phone_number=v_rec(i).phone
           and op.option_code='MGN500MIN' 
           and op.year_month=v_year_month;
      end if;
           
      pipe row(v_rec(i));

      /*         
     dbms_output.put_line(
      v_rec(i).phone||' | '||
      v_rec(i).CONTRACT_NUM||' | '||
      v_rec(i).CONTRACT_DATE||' | '||
      v_rec(i).CURR_TARIFF_ID||' | '||
      v_rec(i).TARIFF_CODE||' | '||
      v_rec(i).TARIFF_NAME||' | '||
      v_rec(i).balance||' | '||
      v_rec(i).tariff||' | '||
      v_rec(i).tariff_oper||' | '||
      v_rec(i).FI550Z||' | '||
      v_rec(i).FI850Z||' | '||
      v_rec(i).FI1150Z||' | '||
      v_rec(i).GPRS_U||' | '||
      v_rec(i).total_traff||' | '||
      v_rec(i).outcom_mi||' | '||
      v_rec(i).payments
      );
      */
    end loop;
  end;

  function  calc_traff(p_phone varchar2)  return tbl_calc_traff pipelined as -- ������ ���������������� ������� � ������������ �� ��� �������
    type t_stat2 is record
      (
        phone           varchar2(10),
        initvalue       integer,
        currvalue       integer,
        curr_check_date timestamp
      );
    type t_stats is table of t_stat2 index by pls_integer;
    vt_stat t_stats;
    v_res t_calc_traff;
  begin
    begin
      -- � ���� ����������� ��� ���������� ������/�����
      for rec_tl in  (
                    select
                            *
                      from
                            gprs_turn_log
                     where
                            phone = p_phone
                     order  by
                            date_on                
                  ) loop
        -- � ������� ����������� ��� ������ ��������� � ��� ��������� � ������� initvalue <> currvalue
        -- , ���� ������ ������� (initvalue(curr) > initvalue(previous) ) ������ ���� ����� �� ����� � ������ �������� ������ ������
        select
                sq.phone,
                sq.initvalue,
                sq.currvalue,
                sq.curr_check_date
          bulk  collect into
                vt_stat
          from
                (      
                  select
                          phone,
                          initvalue,
                          currvalue,
                          curr_check_date
                    from
                          gprs_stat
                   where
                          phone = rec_tl.phone
                     and  turn_log_id = rec_tl.log_id
                   order  by
                          curr_check_date
                ) sq
         where 
                rownum=1 or (rownum>1 and sq.initvalue<>sq.currvalue)
         order  by
                sq.curr_check_date desc;

          v_res.total_sec := v_res.total_sec + intr_to_sec(vt_stat(1).curr_check_date-vt_stat(vt_stat.count).curr_check_date);
          v_res.total_traff := v_res.total_traff+(vt_stat(1).initvalue-vt_stat(1).currvalue)-(vt_stat(vt_stat.count).initvalue-vt_stat(vt_stat.count).currvalue); 
      end loop;              
      pipe row(v_res);      
    exception
      when no_data_found then 
        --dbms_output.put_line('��� ������ ��� ���������');
        pipe row(v_res);      
    end;                  
  end;

  procedure check_alien_opts(p_STREAM_ID integer) as -- �������� ���.����� ������������ ������������ �� ��������� �����������
    c_STREAM_COUNT constant INTEGER := 5;
    res_opt varchar2(5000);
  begin
    for rec in (
                     select phone
                       from
                       (
                          select distinct c.phone
                            from gprs_turn_log c
                          where c.date_off is null 
                              and nvl((select db.phone_is_active 
                                             from db_loader_account_phones db
                                           where db.phone_number = c.phone 
                                               and db.year_month = to_char(sysdate,'yyyymm')), 0) = 1
                              and nvl((select count(1) 
                                             from mnp_remove mnp 
                                           where mnp.temp_phone_number = c.phone 
                                               and mnp.date_created >= sysdate-1), 0) = 0
                              -- ������������ ������ ������ � ������������ �������
                              and exists (
                                                select 1
                                                  from v_contracts ct,
                                                          tariffs tf
                                                where CT.PHONE_NUMBER_FEDERAL = c.phone
                                                    and CT.CONTRACT_CANCEL_DATE is null
                                                    and TF.TARIFF_ID=CT.TARIFF_ID
                                                    and nvl(TF.IS_AUTO_INTERNET, 0) = 1
                                             )          
                       )
                     where MOD(TO_NUMBER(phone), c_STREAM_COUNT) = p_STREAM_ID
                  ) 
    loop
      --��� ���������� ������� ���������� ��.
      --���������� ������ �� ������ �������, �.�. �������� ������������� ������ ������ �� ���, � ���
      --�������� ������������ �����, �� ������� � ������� ����������� ������ ����� ����������
      --�� �� ���� ������ ���� ����
      for rec_tar in (
                               select GP.TARIFF_CODE
                                from gprs_turn_log gp
                              where GP.PHONE = rec.phone
                                  and GP.DATE_OFF is null 
                          )
      loop
        --��������� ���� �� ����� ������, ����� ���� ��� ������ � ������� �����������
        for rec_opt in  (
                                select q.name option_code
                                  from table(beeline_rest_api_pckg.get_serviceList(rec.phone)) q
                                where exists (
                                                      select 1
                                                       from tariff_options top 
                                                     where TOP.OPTION_CODE = q.name
                                                         and nvl(TOP.IS_AUTO_INTERNET, 0) = 1
                                                   )
                                   and q.name <> rec_tar.tariff_code
                                   and not exists (
                                                            select 1
                                                             from gprs_alien_opts al
                                                           where AL.PHONE = rec.phone 
                                                               and AL.ALIEN_CODE = q.name
                                                               and nvl(AL.IS_CHECKED, 0) = 0
                                                        )
                             ) 
        loop
          --������� ������ � ������� ����� �����������
          insert into GPRS_ALIEN_OPTS
          (
            opts_id,
            phone,
            curr_code,
            alien_code,
            load_date
          )
          values
          (
            NEW_GPRS_ALIEN_OPTS_ID,
            rec.phone,
            rec_tar.tariff_code,
            rec_opt.option_code,
            sysdate
          );
          commit;
        end loop;
      end loop;
    end loop;
  end;

  procedure proc_alien_phone_opts(rec_al gprs_alien_opts%rowtype) as -- ���������� ����� ����� � ������
    v_rests beeline_rest_api_pckg.TRests;
    v_num integer;
    v_str  varchar2(1024);
    v_str0 varchar2(1024);
    v_grs  number(12);
  begin
    -- �������� - ������ �� ���������
    select 
            count(1)
      into
            v_num
      from
            tariffs 
     where
            tariff_code=rec_al.alien_code;
    if v_num <> 0 then
      return;
    end if;
     
    v_rests := beeline_api_pckg.rest_info_rests(rec_al.phone);
    for i in 1..v_rests.count() 
    loop
      if    v_rests(i).unitType = 'INTERNET' 
        and (
                  v_rests(i).currvalue > 0
              or  rec_al.curr_code = 'GPRS_U'
            )
      then

        -- ��������� ����� ���.����� (3 �������)
        for i in 1..3 loop
          v_str0 := beeline_api_pckg.turn_tariff_option(rec_al.phone,rec_al.alien_code, 0, null, null, 'AUTO_GPRS');
          v_str  := upper(substr(v_str0,1,5));

          v_grs  := beeline_rest_api_pckg.get_resp_stat(-9001,'check_alien_opts',case when v_str = 'ERROR' then 'Error turn off option.' else 'Success turn off option.' end, rec_al.phone, 0, 'check_alien_opts',0
                                    ,'Phone number: '||rec_al.phone||' | Tariff: '||rec_al.alien_code||' | User: '||user
                                    , v_str0);
          if  v_str = 'ERROR' then 
            DBMS_LOCK.SLEEP(30);
          else
            exit;
          end if;
        end loop;
              
        if v_str = 'ERROR' then
          return;
        end if;
        -- ������ ������� ��������� � ������
        -- �������� ���� ����������
        update 
                gprs_alien_opts
           set
                is_checked  = 1,
                date_off    = sysdate
         where
                opts_id = rec_al.opts_id;
        commit;
        exit;
      end if;
    end loop;
  end;
  
  
   --   mcBalance ------------ BEGIN ---------------------------------------------------------------------------------------------
  FUNCTION mcBalance (pToken     VARCHAR2,
                       pUuid      VARCHAR2,
                       phash      VARCHAR2,
                       ctn        VARCHAR2)
    RETURN TRestsMCBalance
  AS                       -- �������� ����� ��� � �������, ���������� ��� ��
      obj        json;
      tmpobj     json;
      v_data     db_loader_resp_log.response%TYPE;
      v_req      db_loader_resp_log.request%TYPE;
      v_hdr      VARCHAR2 (512);
      v_grs      NUMBER (12);
      v_code     db_loader_resp_log.code%TYPE;
      v_result  TInfoRestMCBalance;
      v_results  TRestsMCBalance;
      v_status   DB_LOADER_RESP_LOG.STATUS%TYPE;
      v_message   DB_LOADER_RESP_LOG.MESSAGE%TYPE;
      
      function getDataByName(pObj json, pName varchar2) RETURN NUMBER as
        vRes NUMBER(10, 2);
      begin
        
        IF (pObj.exist (pName)) THEN
          vRes := NVL (TO_NUMBER (json_ext.get_string(pObj, pName), '999999D99'), 0);
        ELSE
          vRes := 0;
        END IF;
        
        RETURN vRes;
      end;
      
  BEGIN
    v_req :=
            beeline_protocol
         || '://'
         || beeline_domain
         || info_get_balance
         || '?ctn='
         || ctn;
    v_hdr :=
            'Cookie: token='
         || pToken
         || '; domain='
         || beeline_domain
         || '; path='
         || info_get_balance
         || ';';
    
    v_data := get_data (v_req, v_hdr);
     
    v_grs := get_resp_stat (-9000,
                        'LogReqResp',
                        'Get mcBalance.',
                        ctn,
                        0,
                        'info_balance',
                        0,
                        v_req || CHR (38) || 'token=' || pToken,
                        v_data);
       
      
    IF v_data IS NOT NULL THEN
      obj := json (v_data);
      tmpobj := json_ext.get_json (obj, 'meta');
      
      v_code := nvl(json_ext.get_number (tmpobj, 'code'), 0);
      v_status := nvl(json_ext.get_string (tmpobj, 'status'), '');
      v_message := nvl(json_ext.get_string (tmpobj, 'message'), '');
            
      
      v_grs := get_resp_stat (
                           v_code,
                           v_status,
                           v_message,
                           ctn,
                           0,
                           'info_balance',
                           0,
                           v_req || CHR (38) || 'token=' || pToken,
                           v_data
                          );
        
      if v_code = err_ok then
        v_result := TInfoRestMCBalance (ctn, 0, 0);
        v_result.bsasValue :=  getDataByName(obj, 'bsasValue');
        v_result.bmkValue := getDataByName(obj, 'bmkValue');
        v_results (1) := v_result; 
      end if;

    end if;
    
    return v_results;
  END;
--   mcBalance ------------  END  ------------------------------------------------------------------------------------

  --������. ������� � ��������� ��� �������� � �������� ������� �� ������� � ������� �����
  
  -- drave_get_rest ----  BEGIN  --------------------------------------------------------------------------------------
  function drave_get_rest(p_phone varchar2) return number as -- ��������� � ������ �������� �� ������ � ������� ����� � drave_stats, ��������� ������� ������ ��� ����������� ������� (���������� 1 ���� ������ ���� ���������)
    v_rests TRests;
    v_cnt  number(12) := 0;
    v_cnt2 number(12) := 0;
    v_res  number(1)  := 0;
    v_tar_code varchar2(30 char);
  begin
    v_rests := beeline_api_pckg.rest_info_rests(p_phone);

    for i in 1..v_rests.count() loop
      --���������� ���. ��� ��, �.�. ���� ���� ����� �� � ������ �� �����, �� � ��������
      --������������ ������� �� ����� ��
      select TR.TARIFF_CODE
         into v_tar_code
       from v_contracts v,
               tariffs tr
      where V.CONTRACT_CANCEL_DATE is null
          and V.TARIFF_ID = TR.TARIFF_ID
          and V.PHONE_NUMBER_FEDERAL = p_phone;
          
      --��������� ������� ������ ��� ����������� �������
      select count(1)
         into v_cnt                
       from 
       (
          select 1 
            from drave_turn_log 
          where phone = p_phone 
              and date_off is null 
              and tariff_code = v_rests(i).soc
          order by date_off desc nulls first
       )
      where rownum <2;
            
      -- ��������� ���� ��������� �� ���� ����� ��� �������� �������
      select count(1)
         into v_cnt2
        from drave_stat st
      where st.phone = p_phone
          and st.tariff_code = v_rests(i).soc
          and exists (
                            select 1
                              from drave_turn_log lg
                            where lg.phone = st.phone
                                and lg.tariff_code = st.tariff_code
                                and lg.date_off is null
                         );
                              
      if (nvl(v_cnt,0) <> 0 or nvl(v_cnt2,0) = 0) and (v_rests(i).unittype = 'INTERNET') and (v_rests(i).resttype = 'AS') and (v_rests(i).soc = v_tar_code) then
        -- ��������� ID ������ � ���� ������������ �������
        v_cnt := null;
        if nvl(v_cnt2,0) <> 0 then
          select drave_log_id
             into v_cnt 
           from 
           (
              select * 
                from drave_turn_log 
               where phone = p_phone
               order by drave_log_id desc
           )
          where tariff_code = v_rests(i).soc 
              and rownum <2;
        end if;
              
        --���������� ����������
        insert into drave_stat
        (
          DRAVE_STAT_ID,
          DRAVE_TURN_LOG_ID,
          PHONE,
          TARIFF_CODE,
          INITVALUE,
          CURRVALUE,
          CURR_CHECK_DATE,
          NEXT_CHECK_DATE,
          CTRL_PNT,
          IS_CHECKED
        ) 
        values
        (
          S_DRAVE_STAT_ID.NEXTVAL,
          nvl(v_cnt,S_DRAVE_TURN_LOG_ID.NEXTVAL),
          v_rests(i).phone,  
          v_rests(i).soc,
          v_rests(i).initialsize,
          v_rests(i).currvalue,
          systimestamp,
          null,
          1,
          0  
        );
        v_res:=1;
      end if;
    end loop;
    return(v_res);
  end;
  -- drave_get_rest ----  END  -----------------------------------------------------------------------------------------
  
  -- drave_check_phone_tariff ----  BEGIN  ---------------------------------------------------------------------------
  procedure drave_check_phone_tariff(p_phone varchar2) as --�������� �������� �� ������� ����������� �������� ������������� �������� ���
    v_num0  integer;
    v_tar_code varchar2(30 char);
  begin
    --������������ ���� �� ������ ����� �����, ����� ������� � �� MNP
    select count(*)
       into v_num0
     from v_contracts v,
             tariffs tr
    where V.CONTRACT_CANCEL_DATE is null
        and V.TARIFF_ID = TR.TARIFF_ID
        and TR.TARIFF_NAME LIKE '�����%'
        and exists (
                            select 1
                             from db_loader_account_phones db
                           where DB.PHONE_NUMBER = V.PHONE_NUMBER_FEDERAL
                               and DB.YEAR_MONTH = to_number(to_char(sysdate, 'YYYYMM'))
                               and nvl(DB.PHONE_IS_ACTIVE, 0) = 1
                       )
        and not exists (
                                select 1
                                  from mnp_remove mnp
                                where MNP.TEMP_PHONE_NUMBER = V.PHONE_NUMBER_FEDERAL
                                    and MNP.DATE_CREATED >= sysdate-1
                            )
        and V.PHONE_NUMBER_FEDERAL = p_phone;
    
    if (nvl(v_num0,0) > 0) then     
      --���������� ��� ������� ������
      --���������� ������ ����� ��, �� ��, ������� ��� ����� ����� ���� �� �����
      select TR.TARIFF_CODE
         into v_tar_code
       from v_contracts v,
               tariffs tr
      where V.CONTRACT_CANCEL_DATE is null
          and V.TARIFF_ID = TR.TARIFF_ID
          and V.PHONE_NUMBER_FEDERAL = p_phone;
          
      --��������� ������� ���������� � ����� ����������� �� ������� ������ � ������� ��                     
      select count(1) 
         into v_num0 
        from drave_stat st
      where st.phone = p_phone 
          and st.tariff_code = v_tar_code
          and st.curr_check_date between trunc(sysdate,'MM') and sysdate
          and exists (
                            select 1
                              from drave_turn_log lg
                            where lg.phone = st.phone
                                and lg.tariff_code = st.tariff_code
                                and lg.date_off is null
                         );
      
      --���� ��� ��������� � ������� ������, ���������� ������� ������ ������ � ������� ��
      if v_num0=0 then
        --���� ���� �������� ������ � ������� �����������, �� ��� �������� ��� ���� ����� �� (������ ������ ���) � ������ ���������� �������
        select count(*)
           into v_num0
          from drave_turn_log lg
        where lg.phone = p_phone
            and lg.date_off is null;
        
        if (nvl(v_num0,0) > 0) then
          update drave_turn_log 
               set date_off = systimestamp 
          where phone = p_phone
              and date_off is null;
          commit;
        end if;
        
        --���� ���� �������������� ����������, �� �� ���������� �������� ������������
        select count(1) 
           into v_num0 
          from drave_stat st
        where st.phone = p_phone 
            and st.is_checked = 0;
            
        if (nvl(v_num0,0) > 0) then
          update drave_stat
               set is_checked = 1,
                    ctrl_pnt = 1
          where phone = p_phone 
              and is_checked = 0;
          commit;
        end if;
                                
        --������������ ������ ���������, ���� ������ �� ������� ���� ���������
        if drave_get_rest(p_phone)=1 then 
          v_num0 := drave_check_turn_tariff(p_phone); -- ��������� ��������� ����������
        end if;
      else
        -- ��������� ��� ����� �������� � �������� ��������� (����� � ���������� ����� next_check_date ��� �������� ������),
        --  �.�. ���������� � �������� ����� ������� � ������� ����������� ������ ������������
        select count(1) 
           into v_num0 
         from 
         (
             select 1 
               from drave_stat gs
             where gs.phone = p_phone 
                 and gs.is_checked=0 
                 and GS.NEXT_CHECK_DATE is not null 
                 and GS.NEXT_CHECK_DATE <= sysdate 
             order by drave_stat_id desc
         ) 
        where rownum <2;
        
        -- ����� �������� � �������� ���������                            
        if nvl(v_num0,0) >0 then   
          --������ �� ������� ���� ���������       
          if drave_get_rest(p_phone) = 1 then        
            v_num0 := drave_check_turn_tariff(p_phone); -- ��������� ��������� ����������
          end if;
        end if; 
      end if;
    end if;
  end;
  -- drave_check_phone_tariff ----  END  ------------------------------------------------------------------------------
  
  -- drave_check_phone_flow ----  BEGIN  -----------------------------------------------------------------------------
  procedure drave_check_phone_flow(p_STREAM_ID integer, p_STREAM_COUNT integer) as -- ������ ������������ ������� � ������� ����� � ������ (�� CONTRACTS)
  begin
    for rec in (
                        select phone_number_federal
                         from
                         (
                            select distinct V.PHONE_NUMBER_FEDERAL
                             from v_contracts v,
                                     tariffs tr
                            where V.CONTRACT_CANCEL_DATE is null
                                and V.TARIFF_ID = TR.TARIFF_ID
                                and TR.TARIFF_NAME LIKE '�����%'
                                and exists (
                                                    select 1
                                                     from db_loader_account_phones db
                                                   where DB.PHONE_NUMBER = V.PHONE_NUMBER_FEDERAL
                                                       and DB.YEAR_MONTH = to_number(to_char(sysdate, 'YYYYMM'))
                                                       and nvl(DB.PHONE_IS_ACTIVE, 0) = 1
                                               )
                                and not exists (
                                                        select 1
                                                          from mnp_remove mnp
                                                        where MNP.TEMP_PHONE_NUMBER = V.PHONE_NUMBER_FEDERAL
                                                            and MNP.DATE_CREATED >= sysdate-1
                                                    )
                         )
                         where MOD(TO_NUMBER(phone_number_federal), p_STREAM_COUNT) = p_STREAM_ID
                  ) 
    loop
      begin            
        drave_check_phone_tariff(rec.phone_number_federal); 
      exception
        when others then
          NULL;
      end;     
    end loop;
  end;
  -- drave_check_phone_flow ----  END  --------------------------------------------------------------------------------

  -- drave_calc_traff ----  BEGIN  ----------------------------------------------------------------------------------------
  function drave_calc_traff(p_phone varchar2) return number as -- ������ ���������������� ������� � ������������ �� ��� ������� ��� ������� � ������� �����. ��������� �������� ��������������� �������
    type t_stat2 is record
      (
        phone           varchar2(10),
        initvalue       integer,
        currvalue       integer,
        curr_check_date timestamp
      );
    type t_stats is table of t_stat2 index by pls_integer;
    vt_stat t_stats;
    v_end_month_sec number(24,3)  := 0;
    total_sec  number(24,3)  := 0; 
    total_traf  number(24)    := 0; 
    v_pred_traf number(24,3) := 0;
    v_date date;
  begin
    -- � ���� ����������� ��� ���������� ������/�����
    for rec_tl in  (
                          select *
                            from drave_turn_log
                          where phone = p_phone
                          order  by date_on                
                      )
    loop
      -- � ������� ����������� ��� ������ ��������� � ��� ��������� � ������� initvalue <> currvalue
      -- , ���� ������ ������� (initvalue(curr) > initvalue(previous) ) ������ ���� ����� �� ����� � ������ �������� ������ ������
      select
                sq.phone,
                sq.initvalue,
                sq.currvalue,
                sq.curr_check_date
        bulk  collect into vt_stat
        from
              (      
                  select
                          phone,
                          initvalue,
                          currvalue,
                          curr_check_date
                    from drave_stat
                   where phone = rec_tl.phone
                       and drave_turn_log_id = rec_tl.drave_log_id
                   order by curr_check_date
              ) sq
      where rownum=1 
             or (rownum>1 and sq.initvalue<>sq.currvalue)
      order by sq.curr_check_date desc;

      total_sec := total_sec + intr_to_sec(vt_stat(1).curr_check_date-vt_stat(vt_stat.count).curr_check_date);
      total_traf := total_traf+(vt_stat(1).initvalue-vt_stat(1).currvalue)-(vt_stat(vt_stat.count).initvalue-vt_stat(vt_stat.count).currvalue); 
    end loop;    
    
    if total_traf = 0 then
      --���������� ������� ������� �� ��� ������ (��������������� �������), �.�. �� ��������� ������ � drave_stat
      select initvalue 
         into total_traf 
        from 
        (
           select * 
             from drave_stat 
           where phone = p_phone 
           order by curr_check_date desc, drave_stat_id desc
        ) 
      where rownum <2;
      
      --���������� ���� ��������
      select V.CONTRACT_DATE
         into v_date
       from v_contracts v
      where V.CONTRACT_CANCEL_DATE is null
          and V.PHONE_NUMBER_FEDERAL = p_phone;
      
      --���� ���� ��������� ������ 1 ����� �������� ������, �� � �������� ���� ����� 1 ����� ������
      if v_date < trunc(sysdate, 'MM') then
        v_date := trunc(sysdate, 'MM');
      end if;
      
      --���-�� ������ � ������ ������ �� ������� ������������ ��������
      total_sec := intr_to_sec(systimestamp - to_date(to_char(v_date,'YYYY-MM-DD')||' 00:00:00','YYYY-MM-DD hh24:mi:ss'));
    end if;
          
    --���� ������� ��������, �� �������
    if (total_sec  <= 0) or 
       (total_traf <= 0) then 
      return(-1); 
    end if;
    
    --���-�� ������ �� ����� ������ ������� � ������� ������������ ��������
    v_end_month_sec := intr_to_sec(to_date(to_char(last_day(sysdate),'YYYY-MM-DD')||' 23:59:59','YYYY-MM-DD hh24:mi:ss')-systimestamp);
          
    -- �� ����� ������ ����������� (��)
    v_pred_traf := total_traf*v_end_month_sec/total_sec;    
    return v_pred_traf;                      
  exception
    when no_data_found then 
      return(-1);                       
  end;
  -- drave_calc_traff ----  END  ------------------------------------------------------------------------------------------
  
  -- drave_check_turn_tariff ----  BEGIN  -------------------------------------------------------------------------------
  function drave_check_turn_tariff(p_phone varchar2) return number as -- �������� ������� �������� �������� �� ������ ����� � �������� ��� ��� ������� ����������� ��������
    type t_stat is table of drave_stat%rowtype index by pls_integer;
    v_rec                   t_stat;
    v_num                 number(38) := 0;
    v_num0                number(38);-- ������ � ������ ������
    v_tariff_code         varchar2(30);
    v_drave_log_id      integer;
    delta_time_sec        number(12);
    ctrl_pnt_cnt          number(12); -- ���-�� ��� ���������� ������� �����
    v_grs                 integer;
    v_date                timestamp;
    i                       number(12) := 0;
    j                       number(12) := 0;
    v_SPEED3B2B    integer := 0;
    v_pred_traf       number := 0; --����� ��������������� �������      
    
      procedure proc_send_sms (v_text_sms in varchar2, v_trafic in integer, v_sms_type in integer) IS
        SMS VARCHAR2(500 CHAR);  
        v_tar_name varchar2(100 char);
        v_tar_id integer;
        txt_sms varchar2(500 char);
      begin
        --���������� �����
        select TR.TARIFF_ID, 
                 TR.TARIFF_NAME
           into v_tar_id,
                 v_tar_name
         from v_contracts v,
                 tariffs tr
        where V.CONTRACT_CANCEL_DATE is null
            and V.TARIFF_ID = TR.TARIFF_ID
            and V.PHONE_NUMBER_FEDERAL = p_phone;
          
        --�������� ������ �� ������ ��� ����� ������� �����
        txt_sms := v_text_sms;
        txt_sms:= replace(txt_sms, '%tariff%', v_tar_name);    
        txt_sms:= replace(txt_sms, '%traf_volue%', to_char(v_trafic)); 
        sms := loader3_pckg.SEND_SMS(p_phone, 'Teletie', txt_sms);
        
        --���������� � ������� �� �������� �� ���������� ������
        INSERT INTO SMS_FOR_CONTRACT_PHONE_DRAVE 
        (
           PHONE_NUMBER, 
           TARIFF_ID, 
           SMS_TYPE, 
           VALUE_TRAFFIC,
           DATE_CREATED
        ) 
        VALUES 
        ( 
           p_phone,
           v_tar_id,
           v_sms_type,
           v_trafic,
           sysdate
        );
        commit;
      end;
    
  begin    
    --����������� ��� ������ � id ����
    select tariff_code, 
             drave_log_id
       into v_tariff_code, 
             v_drave_log_id
      from 
      (
        select tariff_code, drave_log_id
          from drave_turn_log 
        where phone=p_phone 
            and date_off is null 
        order by date_off desc
      ) 
    where rownum <2;

    if v_tariff_code is not null then        
      --�������� ������ ����� ���������
      select * 
         into v_rec(1) 
        from 
        (
           select * 
             from drave_stat 
           where phone = p_phone 
               and tariff_code= v_tariff_code 
               and drave_turn_log_id = v_drave_log_id
           order by curr_check_date, drave_stat_id
        ) 
      where rownum <2;

      --������������� ���������
      select * 
         into v_rec(2) 
        from 
        (
           select * 
            from 
            (
               select * 
                 from drave_stat 
               where phone = p_phone 
                   and tariff_code= v_tariff_code 
                   and drave_turn_log_id = v_drave_log_id
               order by curr_check_date desc, drave_stat_id desc
            ) 
           where rownum <3  
           order by curr_check_date, drave_stat_id
        ) 
      where rownum <2;
            
      --������� ���������
      select * 
         into v_rec(3) 
        from 
        (
           select * 
             from drave_stat 
           where phone = p_phone 
               and tariff_code= v_tariff_code 
               and drave_turn_log_id = v_drave_log_id
           order by curr_check_date desc, drave_stat_id desc
        ) 
      where rownum <2;
        
      -- ������� ����/������� ��������� ��������, ���������� ����� �� ���������������� ������� 0  
      v_num0 := abs(nvl(v_rec(2).currvalue,0)-nvl(v_rec(3).currvalue,0)); -- ����� ����������� � ���������� ���������  
      v_num  := abs(nvl(BEELINE_REST_API_PCKG.intr_to_sec(v_rec(3).curr_check_date - v_rec(2).curr_check_date),0)); -- ����� � ���������� ��������� � ��������
        
      -- ���� ������� ������� �� ������:
      --    > ����������� ���������, ������ ��� ���� ������� � ������ �� ����� ���� ��������� � "0" 
      --    <= 0
      --    �������� 20% �� ���������� ������ �������
      -- �� ���������� ��������������� ���. ��� ��������� 0 ������������ ������� ������� ����������� �������� �� ������. ��� ������� ����������� �������� ���������� ���         
      -- � ������ ������� ����� ������������ ������
      if (nvl(v_rec(3).currvalue,0) <= 0) then
        -- ����� ������������ ������ ��������
        v_pred_traf := BEELINE_REST_API_PCKG.drave_calc_traff(p_phone);
        
        -- ���� ��������� ����� -1, �� ��� ������
        if nvl(v_pred_traf, -1) = -1 then
          return(-1);
        end if;
        
        --��������� �������������� ������
        update drave_turn_log dr 
             set dr.predvalue = v_pred_traf
        where dr.drave_log_id = v_drave_log_id;

        --��������� ������� ����������� ��������
        for i in 1..3 loop -- ����� 3 �������
          begin
            select count(*)
               into v_SPEED3B2B
              from table(BEELINE_REST_API_PCKG.get_serviceList(p_phone)) sr
            where sr.name = 'SPEED3B2B';
            --���� � ������ �� �����, �� �������
            exit;
          exception
            when others then
              null;
          end; 
        end loop;         
            
        --���� �������� ����������� ��������
        if nvl(v_SPEED3B2B, 0) <> 0 then         
          --��������� ��� ��������� ����������� ��������
          update drave_turn_log 
               set limit_speed = 1
          where drave_log_id = v_drave_log_id;
        end if;
       
        --�������� ������������ ������ � ���������� drave_stat
        update drave_stat 
             set is_checked = 1  
        where drave_stat_id = v_rec(3).drave_stat_id
           and nvl(is_checked,0)=0;
                
        --��������� �������� ���
        --� ����������� �� ��� ������ ���������� ��������������� ��� (���������� ����. 23 �����)
        if to_number(to_char(sysdate, 'DD')) < 23 then
          select count(*)
            into v_grs
          from drave_turn_log
          where drave_log_id = v_drave_log_id
              and nvl(is_send_sms_zero_first, 0) = 1;
              
          --���� ��� �� ������������, �� ��� ���������� ���������
          if nvl(v_grs,0) = 0  then
            --���������� ���
            proc_send_sms(MS_params.GET_PARAM_VALUE('TEXT_SMS_ZERO_TRAFFIC_DRAVE_FIRST'), trunc(v_rec(3).currvalue/1024)+1, 2);
                        
            --�������� ��������
            update drave_turn_log dr 
                 set dr.is_send_sms_zero_first = 1
            where dr.drave_log_id = v_drave_log_id;
          end if; 
        else
          select count(*)
            into v_grs
          from drave_turn_log
          where drave_log_id = v_drave_log_id
              and nvl(is_send_sms_zero_second, 0) = 1;
              
          --���� ��� �� ������������, �� ��� ���������� ���������
          if nvl(v_grs,0) = 0  then
            --���������� ���
            proc_send_sms(MS_params.GET_PARAM_VALUE('TEXT_SMS_ZERO_TRAFFIC_DRAVE_SECOND'), trunc(v_rec(3).currvalue/1024)+1, 2);
            
            --��������� ������� ��������
            update drave_turn_log dr 
                 set dr.is_send_sms_zero_second = 1
            where dr.drave_log_id = v_drave_log_id;
          end if;
        end if;        
      else
        --���� �������� ������ 20% ������� � ��� ��� �� ���� �����������, �� ���������� ��������������� ���
        if ((v_num0 <>0) and (v_num <> 0) and (nvl(v_rec(3).currvalue,0) <= v_rec(3).initvalue*c_turn_tariff_ctrlpnt_inc)) then --c_turn_tariff_ctrlpnt_inc = 0.2 (�� ���������) 20%
          --���������� ����� ��������������� �������
          v_pred_traf := BEELINE_REST_API_PCKG.drave_calc_traff(p_phone);
          
          -- ���� ��������� ����� -1, �� ��� ������
          if nvl(v_pred_traf, -1) = -1 then
            return(-1);
          end if;
          
          --��������� �������������� ������
          update drave_turn_log dr 
               set dr.predvalue = v_pred_traf
          where dr.drave_log_id = v_drave_log_id;
          
          --��������� �������� ���
          --� ����������� �� ��� ������ ���������� ��������������� ��� (���������� ����. 23 �����)
          if to_number(to_char(sysdate, 'DD')) < 23 then
            select count(*)
               into v_grs
              from drave_turn_log
            where drave_log_id = v_drave_log_id
                and nvl(is_send_sms_prev_first, 0) = 1;
              
            --���� ��� �� ������������, �� ���������� ���������
            if nvl(v_grs,0)=0  then
              --���������� ���
              proc_send_sms(MS_params.GET_PARAM_VALUE('TEXT_SMS_PREV_FLOW_TRAFFIC_DRAVE_FIRST'), trunc(v_rec(3).currvalue/1024)+1, 1);
              
              --����������� ������� �������� ���
              update drave_turn_log dr 
                   set dr.is_send_sms_prev_first = 1
              where drave_log_id = v_drave_log_id;
            end if; 
          else
            select count(*)
               into v_grs
              from drave_turn_log
            where drave_log_id = v_drave_log_id
                and nvl(is_send_sms_prev_second, 0) = 1;
              
            --���� ��� �� ������������, �� ���������� ���������
            if nvl(v_grs,0)=0  then
              --���������� ���
              proc_send_sms(MS_params.GET_PARAM_VALUE('TEXT_SMS_PREV_FLOW_TRAFFIC_DRAVE_SECOND'), trunc(v_rec(3).currvalue/1024)+1, 1);
              
              --����������� ������� �������� ���
              update drave_turn_log dr 
                   set dr.is_send_sms_prev_second = 1
              where drave_log_id = v_drave_log_id;
            end if;
          end if;
        end if;
        
        --�������� �� ������ 20%
        -------------------------------
        -- ������� ���������� ����������� ����� ��� ��������� ������������ ���������, ��� ���������� ���������� ���������
        -- ��������� ����������� ������ ���������� ����������� ����� 
        select nvl(sum(ctrl_pnt),1) into ctrl_pnt_cnt from drave_stat where phone = p_phone and tariff_code = v_tariff_code and ctrl_pnt<>0 and drave_stat_id <>v_rec(3).drave_stat_id;
        --dbms_output.put_line('����� ����������� �����: '||ctrl_pnt_cnt);
        -- dbms_output.put_line('20% Check');
        if v_rec(3).currvalue <= v_rec(3).initvalue*(1-c_turn_tariff_ctrlpnt_inc*ctrl_pnt_cnt)  then -- ��-��������� 0.2, ������� ��������� ������ ���� ����� ��� init-20%*�����_�����������_�����
          -- ������ ����� ����������� ����� - ������ ����� ��������� ����������� ������ ����� ������ ������������ �������� (20% �� ���������)
          v_rec(3).ctrl_pnt := ceil((1-v_rec(3).currvalue/v_rec(3).initvalue)/c_turn_tariff_ctrlpnt_inc) - ctrl_pnt_cnt; -- �������� ��� ����������� ������� �����
        else -- ����� ���������� ����� ����������� �����
          v_rec(3).ctrl_pnt := 0;
        end if;
              
        -- ���������� ���� ��������� ��������
        ----------------------------------------------
        -- ����� � �������� � ��������� ��������
        v_num := abs(BEELINE_REST_API_PCKG.intr_to_sec(v_rec(3).curr_check_date-v_rec(2).curr_check_date));
        -- ���� ����� ����� � �������� �������� ������ 0 ��� ��� ����� 5 ���, �� ����������� 10 ���
        if v_num <=300 then 
          v_num:= 600; 
        end if;
          
        -- ���������� ����� ������� ���������������� � ��������� ��������, ���� 0. �� ��� 60 ���
        v_num0 := abs(v_rec(2).currvalue-v_rec(3).currvalue);
        --dbms_output.put_line('������������� ������� : '||v_num0||' �� '||v_num||' ������');
        --dbms_output.put_line('������� ������� ������������������: '||v_rec(3).currvalue);
        if v_num0 = 0 then
          delta_time_sec := c_turn_tariff_checktime_max*60;  -- ��-��������� 60 ���;
        else 
          -- ��������������� ����� ������ ����������� �����
          delta_time_sec :=v_rec(3).initvalue*c_turn_tariff_ctrlpnt_inc*ctrl_pnt_cnt*v_num/v_num0;  -- c_turn_tariff_ctrlpnt_inc (��-��������� 0.2)
          -- ��������������� ����� ������ ���� �������
          v_num0 := v_rec(3).currvalue*v_num/v_num0;
          --dbms_output.put_line('������ 20% ����� ������: '||delta_time_sec);
          --dbms_output.put_line('������ ���� ����� ������: '||v_num0);
          
          -- ���� ������ ���� ��������� ������� ������ 20% �� ������������� �� ����
          if delta_time_sec > v_num0 then 
            delta_time_sec := v_num0; 
            -- ���������� ���������� � ����������� ������ �������� ������������ ��������� 
            if delta_time_sec < c_turn_tariff_checktime_min then 
              delta_time_sec := c_turn_tariff_checktime_min;
            else                
              delta_time_sec := floor(delta_time_sec/(c_turn_tariff_checktime_min*60))*c_turn_tariff_checktime_min*60;
            end if;
          end if;            
          -- dbms_output.put_line('���������� ���� �������� � ��������: '||delta_time_sec);
          -- ���� ��������� ����� ����������� 20% ������� �� ���������� ������� ����� ����� 1 ����, �� ��������� ��������� ��������� ����� 1 ���
          if delta_time_sec/60/60 > 1 then 
            delta_time_sec := c_turn_tariff_checktime_max*60; 
          end if;
        end if;
              
        -- ����������� ���� ��������� ��������, ����������� �����
        update drave_stat set next_check_date = trunc(sysdate+delta_time_sec/24/60/60,'MI'), ctrl_pnt = v_rec(3).ctrl_pnt  where drave_stat_id=v_rec(3).drave_stat_id;
      end if;
      
      --�������� ������ ������ �������������
      update drave_stat 
           set is_checked = 1  
       where drave_stat_id in (v_rec(1).drave_stat_id, v_rec(2).drave_stat_id) 
          and nvl(is_checked,0)=0;
      commit;
    else
      return(-1);
    end if;  
    return(0);
  exception
    when no_data_found then
      --������� ��������� ����� � REST - ������� (������ �� ��������� �����. ������� (���� Skype TeleTie 2015-02-19 14:17))
      select tariff_code, drave_stat_id 
         into v_tariff_code, v_num
       from 
       (
          select tariff_code, drave_stat_id 
           from drave_stat 
         where phone=p_phone 
         order by drave_stat_id desc
       ) 
      where rownum<2;
        
      --���� ���������� ����, �� ������������ ������ � ������� ������ drave_turn_log
      if v_tariff_code is not null then 
        -- ctrl_pnt ��������� ����������� ������ ����������� �����  ����� ��� �� ���� ����� ������������ �������� (20% �� ���������)       
        update drave_stat set ctrl_pnt=ceil((1-currvalue/initvalue)/c_turn_tariff_ctrlpnt_inc), next_check_date = trunc(sysdate+c_turn_tariff_checktime_min/24/60,'MI') where drave_stat_id = v_num;
        
        -- �������� drave_turn_log ������� �� ���������.
        select count(1)
          into i 
         from 
         (
            select
                   distinct
                   tariff_code, 
                   drave_turn_log_id 
             from drave_stat 
           where phone=p_phone
               and tariff_code = v_tariff_code
         );
         
        j :=0; 
        for rec in (
                        select 
                               distinct
                               tariff_code, 
                               drave_turn_log_id 
                          from 
                          (
                                select 
                                       tariff_code, 
                                       drave_turn_log_id 
                                 from drave_stat 
                               where phone=p_phone
                                  and not exists(
                                                          select 1 
                                                            from drave_turn_log 
                                                          where drave_log_id = drave_turn_log_id
                                                      ) 
                               order by drave_stat_id
                          )
                    ) 
        loop
          j := j + 1;
          if j = i then 
            v_date := null; 
          else 
            v_date := systimestamp; 
          end if;
          
          begin
            insert into drave_turn_log
              ( 
                DRAVE_LOG_ID,
                PHONE,
                TARIFF_CODE,
                DATE_ON,
                DATE_OFF,
                LIMIT_SPEED,
                IS_SEND_SMS_ZERO_FIRST,
                IS_SEND_SMS_ZERO_SECOND,
                IS_SEND_SMS_PREV_FIRST,
                IS_SEND_SMS_PREV_SECOND,
                PREDVALUE
              )
              values 
              (
                rec.drave_turn_log_id, 
                p_phone, 
                rec.tariff_code, 
                sysdate, 
                v_date,
                0, 
                0,
                0,
                0,
                0,
                null
              );
          exception
            when DUP_VAL_ON_INDEX then 
              v_grs  := BEELINE_REST_API_PCKG.get_resp_stat(-9000,'DUP_VAL_ON_INDEX','Error adding record in gprs_turn_log with turn_log_id from gprs_stat.', p_phone, 0,'gprs_check_turn_tariff',0
                                        ,'Phone number: '||p_phone||' | Tariff: '||rec.tariff_code||' | User: '||user
                                        , 'Error adding record in gprs_turn_log with turn_log_id from gprs_stat.');
          end;
        end loop;
        commit;
      else
        return(-1);
      end if;
      return(0);
  end;
  -- drave_check_turn_tariff ----  END  ----------------------------------------------------------------------------------

  -- drave_init_new_month ----  BEGIN  ---------------------------------------------------------------------------------
  procedure drave_init_new_month as -- ������������� ������ ������ ��� �������
  begin
    -- ������� � ����� ������ �� ��������� �����
    for rec in (
                     select distinct phone 
                       from drave_stat
                  ) 
    loop
      insert into drave_stat_hist 
      (
        DRAVE_STAT_ID,
        DRAVE_TURN_LOG_ID,
        PHONE,
        TARIFF_CODE,
        INITVALUE,
        CURRVALUE,
        CURR_CHECK_DATE,
        NEXT_CHECK_DATE,
        CTRL_PNT,
        IS_CHECKED
      ) 
      select 
          gs.DRAVE_STAT_ID,
          gs.DRAVE_TURN_LOG_ID,
          gs.PHONE,
          gs.TARIFF_CODE,
          gs.INITVALUE,
          gs.CURRVALUE,
          gs.CURR_CHECK_DATE,
          gs.NEXT_CHECK_DATE,
          gs.CTRL_PNT,
          gs.IS_CHECKED
      from drave_stat gs
      where gs.phone=rec.phone
      and gs.CURR_CHECK_DATE<trunc(sysdate);
        
      --������� �� drave_stat
      delete from drave_stat 
      where phone=rec.phone 
         and CURR_CHECK_DATE<trunc(sysdate);
    end loop;
    commit;
    
    for rec in (
                     select distinct phone 
                      from drave_turn_log
                  ) 
    loop
      insert into drave_turn_log_hist
      ( 
        DRAVE_LOG_ID,
        PHONE,
        TARIFF_CODE,
        DATE_ON,
        DATE_OFF,
        LIMIT_SPEED,
        IS_SEND_SMS_ZERO_FIRST,
        IS_SEND_SMS_ZERO_SECOND,
        IS_SEND_SMS_PREV_FIRST,
        IS_SEND_SMS_PREV_SECOND,
        PREDVALUE
      )
      select 
        DRAVE_LOG_ID,
        PHONE,
        TARIFF_CODE,
        DATE_ON,
        DATE_OFF,
        LIMIT_SPEED,
        IS_SEND_SMS_ZERO_FIRST,
        IS_SEND_SMS_ZERO_SECOND,
        IS_SEND_SMS_PREV_FIRST,
        IS_SEND_SMS_PREV_SECOND,
        PREDVALUE
      from drave_turn_log 
      where phone=rec.phone 
         and date_on<trunc(sysdate);
      
      delete from drave_turn_log 
      where phone=rec.phone 
          and date_on<trunc(sysdate);
    end loop;
    commit;
  end;
  -- drave_init_new_month ----  END  ------------------------------------------------------------------------------------

  --�������� ������� �� ������� �� ���� �������
  
  -- check_all_phone_flow ----  BEGIN  -----------------------------------------------------------------------------------
  procedure check_all_phone_flow(p_STREAM_ID integer, p_STREAM_COUNT integer) as -- ������ ������������ ������� ��� �������� ������� �� ������� � ������
  begin
    for rec in (
                        select phone_number_federal, TARIFF_ID
                         from
                         (
                            select distinct V.PHONE_NUMBER_FEDERAL, V.TARIFF_ID
                             from v_contracts v,
                                     tariffs tr
                            where V.CONTRACT_CANCEL_DATE is null
                                and V.TARIFF_ID = TR.TARIFF_ID
                                and TR.TARIFF_NAME NOT LIKE '�����%'
                                and exists (
                                                    select 1
                                                     from db_loader_account_phones db
                                                   where DB.PHONE_NUMBER = V.PHONE_NUMBER_FEDERAL
                                                       and DB.YEAR_MONTH = to_number(to_char(sysdate, 'YYYYMM'))
                                                       and nvl(DB.PHONE_IS_ACTIVE, 0) = 1
                                               )
                                and not exists (
                                                        select 1
                                                          from mnp_remove mnp
                                                        where MNP.TEMP_PHONE_NUMBER = V.PHONE_NUMBER_FEDERAL
                                                            and MNP.DATE_CREATED >= sysdate-1
                                                    )
                         )
                        where MOD(TO_NUMBER(phone_number_federal), p_STREAM_COUNT) = p_STREAM_ID
                  ) 
    loop
      begin            
        check_all_phone_tariff(rec.phone_number_federal, rec.TARIFF_ID); 
      exception
        when others then
          NULL;
      end;     
    end loop;
  end;
  -- check_all_phone_flow ----  END  -------------------------------------------------------------------------------------
  
  -- check_all_phone_tariff ----  BEGIN  ----------------------------------------------------------------------------------
  procedure check_all_phone_tariff(p_phone varchar2, p_tariff_id integer) as --�������� �������� �� ������������� ��������� ������� � �������� ���
    v_num0  integer;
  begin        
    --��������� ������� ���������� � ����� ����������� �� ������� ������ � ������� ��                     
    select count(1) 
       into v_num0 
      from all_phone_stat st
    where st.phone = p_phone 
        and st.curr_check_date between trunc(sysdate,'MM') and sysdate
        and exists (
                          select 1
                            from all_phone_turn_log lg
                          where lg.phone = st.phone
                              and lg.all_phone_log_id = st.all_phone_turn_log_id
                              and lg.tariff_id = p_tariff_id
                              and lg.date_off is null
                       );
      
    --���� ��� ��������� � ������� ������, ���������� ������� ������ ������ � ������� ��
    --�������� ����� ������ ��
    if v_num0=0 then
      --���� ���� �������� ������ � ������� �����������, �� ��� �������� ��� ���� ����� �� (������ ������ ���) � ������ ���������� �������
      select count(*)
         into v_num0
        from all_phone_turn_log lg
      where lg.phone = p_phone
          and lg.date_off is null;
        
      if (nvl(v_num0,0) > 0) then
        update all_phone_turn_log 
             set date_off = systimestamp 
        where phone = p_phone
            and date_off is null;
        commit;
      end if;
        
      --���� ���� �������������� ����������, �� �� ���������� �������� ������������
      select count(1) 
         into v_num0 
        from all_phone_stat st
      where st.phone = p_phone 
          and st.is_checked = 0;
           
      if (nvl(v_num0,0) > 0) then
        update all_phone_stat
             set is_checked = 1,
                  ctrl_pnt = 1
        where phone = p_phone 
            and is_checked = 0;
        commit;
      end if;
                                
      --������������ ���������
      all_phone_get_rest(p_phone, p_tariff_id);
    else
      -- ��������� ��� ����� �������� � �������� ��������� (����� � ���������� ����� next_check_date ��� �������� ������),
      --  �.�. ���������� � �������� ����� ������� � ������� ����������� ������ ������������
      select count(1) 
         into v_num0 
       from 
       (
           select 1 
             from all_phone_stat gs
           where gs.phone = p_phone 
               and gs.is_checked=0 
               and GS.NEXT_CHECK_DATE is not null 
               and GS.NEXT_CHECK_DATE <= sysdate 
           order by ALL_PHONE_STAT_ID desc
       ) 
      where rownum <2;
        
      --����� �������� � �������� ���������                            
      if nvl(v_num0,0) >0 then   
        --������ �� ������� ���� ���������       
        all_phone_get_rest(p_phone, p_tariff_id);    
      end if; 
    end if;
  end;
  -- check_all_phone_tariff ----  END  ------------------------------------------------------------------------------------
  
  -- all_phone_get_rest ----  BEGIN  --------------------------------------------------------------------------------------
  procedure all_phone_get_rest(p_phone varchar2, p_tariff_id integer) as -- ��������� � ������ �������� �� ������
    v_rests TRests;
    type t_opt2 is record
      (
        code_opt varchar2(30 char),
        date_opt date
      );
    type t_opts is table of t_opt2 index by pls_integer;
    vt_opt t_opts;
    v_cnt  number(12) := 0;
    v_cnt2 number(12) := 0;
    v_res  number(1)  := 0;
    v_tar_code varchar2(30 char);
    v_num integer := 0;
    v_num0  integer;
    v_res_opt integer;
    v_date_opt date;
  begin
    --�������� �������
    v_rests := beeline_api_pckg.rest_info_rests(p_phone);

    if v_rests.count > 0 then
      --���������� ��� ������
      select TR.TARIFF_CODE
         into v_tar_code
        from tariffs tr
      where TR.TARIFF_ID = p_tariff_id;
      
      --��������� ��������� �� ����� � ������ ������� � ���������������� �������
      select count(*)
         into v_num
        from tariffs tr
      where TR.TARIFF_ID = p_tariff_id
          and nvl(TR.IS_AUTO_INTERNET, 0) = 1;
          
      --���������� ��������� ���� ����������� ������, �.�. ����� ����� ��������������, � ������ ��� ����� ��������
      --���������� ���� ����������� ��� ���� ����� �� ���
      select name, TO_DATE(SUBSTR(effdate, 1, 10), 'YYYY-MM-DD')
      bulk collect into vt_opt
      from table(corp_mobile.beeline_rest_api_pckg.get_serviceList(p_phone));
          
      --��������� �� ��������
      for i in 1..v_rests.count() loop   
        --�� ����� ������� ��������� ��� ������� � ���������������� �������
        if (v_num = 0) or ((v_num = 1) and (v_rests(i).unittype <> 'INTERNET')) then               
          --��������� ��������� �� ����� � ������
          --����� ������ �� ���� �����, ������� ���� ��� ����� ������, �� ���� ����� �� �������� ���� �����������,
          --����� ��������� ���� ����������� � ���� ���� �� ��������, �� ��������� ���������� ������� � ������� ��� ��� ����� �����       
          v_res_opt := 0;
          v_date_opt := null;
          if v_rests(i).soc <> v_tar_code then
            --��������� ���� �����������
            --��������� �� ���� ������� � ���� ���������������
            if vt_opt.count > 0 then
              --��������� �� ���� ������� � ���� �����������
              for j in 1..vt_opt.count() loop
                if vt_opt(j).code_opt = v_rests(i).soc  then
                  --��������� ������� �������� ������ � ������� ����������� �� ������� ������
                  select count(1)
                     into v_cnt                
                   from 
                   (
                      select 1 
                        from all_phone_turn_log 
                      where phone = p_phone 
                          and date_off is null 
                          and tariff_id = p_tariff_id
                          and pckg_code = v_rests(i).soc
                          and unittype = v_rests(i).unittype
                      order by date_off desc nulls first
                   )
                  where rownum<2;
                  
                  --���� ���� �������� ������ �� ��������� ���� ����������� �����
                  if nvl(v_cnt,0) <> 0 then
                    --���� ���� ����������� �� �����, �� ��������� �������
                    select count(1)
                       into v_cnt                
                     from 
                     (
                        select 1 
                          from all_phone_turn_log 
                        where phone = p_phone 
                            and date_off is null 
                            and tariff_id = p_tariff_id
                            and pckg_code = v_rests(i).soc
                            and unittype = v_rests(i).unittype
                            and turn_on_date = vt_opt(j).date_opt
                        order by date_off desc nulls first
                     )
                    where rownum<2;
                    
                    if nvl(v_cnt,0) = 0 then
                      --
                      select count(*)
                         into v_num0
                        from all_phone_turn_log lg
                      where lg.phone = p_phone
                          and lg.date_off is null
                          and tariff_id = p_tariff_id
                          and pckg_code = v_rests(i).soc
                          and unittype = v_rests(i).unittype;
                        
                      if (nvl(v_num0,0) > 0) then
                        update all_phone_turn_log 
                             set date_off = systimestamp 
                        where phone = p_phone
                            and date_off is null
                            and tariff_id = p_tariff_id
                            and pckg_code = v_rests(i).soc
                            and unittype = v_rests(i).unittype;
                        commit;
                      end if;
                        
                      --���� ���� �������������� ����������, �� �� ���������� �������� ������������
                      select count(1) 
                         into v_num0 
                        from all_phone_stat st
                      where st.phone = p_phone 
                          and st.is_checked = 0
                          and pckg_code = v_rests(i).soc
                          and unittype = v_rests(i).unittype;
                           
                      if (nvl(v_num0,0) > 0) then
                        update all_phone_stat
                             set is_checked = 1,
                                  ctrl_pnt = 1
                        where phone = p_phone 
                            and is_checked = 0
                            and pckg_code = v_rests(i).soc
                            and unittype = v_rests(i).unittype;
                        commit;
                      end if;
                    end if;
                  end if;
                  
                  v_res_opt := 1;
                  v_date_opt := vt_opt(j).date_opt;
                  exit;
                end if;    
              end loop; 
            end if;
          else
            v_res_opt := 1; 
          end if; 
          
          --���� ������ �� ��������� � ������ �����, �� ���������� �����, ����� �� ����
          if v_res_opt <> 0 then                  
            --��������� ������� ������ ��� ����������� �������
            select count(1)
               into v_cnt                
             from 
             (
                select 1 
                  from all_phone_turn_log 
                where phone = p_phone 
                    and date_off is null 
                    and tariff_id = p_tariff_id
                    and pckg_code = v_rests(i).soc
                    and unittype = v_rests(i).unittype
                order by date_off desc nulls first
             )
            where rownum <2;
            
            -- ��������� ���� ��������� �� ���� ����� ��� �������� ������� �� �������� ������
            select count(1)
               into v_cnt2
              from all_phone_stat st
            where st.phone = p_phone
                and st.pckg_code = v_rests(i).soc
                and st.unittype = v_rests(i).unittype
                and exists (
                                  select 1
                                    from all_phone_turn_log lg
                                  where lg.phone = st.phone
                                      and lg.all_phone_log_id = st.all_phone_turn_log_id
                                      and lg.tariff_id = p_tariff_id
                                      and lg.unittype = v_rests(i).unittype
                                      and lg.date_off is null
                               );
                              
            if (nvl(v_cnt,0) <> 0 or nvl(v_cnt2,0) = 0) then
              -- ��������� ID ������
              v_cnt := null;
              if nvl(v_cnt2,0) <> 0 then
                select all_phone_log_id 
                   into v_cnt 
                 from 
                 (
                    select all_phone_log_id 
                      from all_phone_turn_log 
                    where phone = p_phone 
                        and pckg_code = v_rests(i).soc
                        and unittype = v_rests(i).unittype
                        and tariff_id = p_tariff_id
                        and date_off is null
                     order by all_phone_log_id desc
                 )
                where rownum <2;
              end if;
              
              --���������� ����������
              insert into all_phone_stat
              (
                ALL_PHONE_STAT_ID,
                ALL_PHONE_TURN_LOG_ID,
                PHONE,
                PCKG_CODE,
                UNITTYPE,
                INITVALUE,
                CURRVALUE,
                CURR_CHECK_DATE,
                NEXT_CHECK_DATE,
                CTRL_PNT,
                IS_CHECKED
              ) 
              values
              (
                S_ALL_PHONE_STAT_ID.NEXTVAL,
                nvl(v_cnt, S_ALL_PHONE_TURN_LOG_ID.NEXTVAL),
                v_rests(i).phone,  
                v_rests(i).soc,
                v_rests(i).unittype,
                v_rests(i).initialsize,
                v_rests(i).currvalue,
                systimestamp,
                null,
                1,
                0  
              );

              v_num0 := all_phone_check_turn_tariff(p_phone, p_tariff_id, v_rests(i).soc, v_rests(i).unittype, v_date_opt); -- ��������� ��������� ���������� �� ������� ������ � ������ �����
            end if;
          end if;
        end if;
      end loop;
    else
      --��������� ��� �� ������ �� ����������� �������
      --���� ����� �������� �������� ���������� ��������� ���, 
      --�� ����������� ������ �������, � ���� �� �������, �� ��� �� ���������� � ������� ��������
      update all_phone_turn_log 
           set do_not_rest = 1
      where phone = p_phone
          and date_off is null;
      commit;
    end if;
  end;
  -- all_phone_get_rest ----  END  ----------------------------------------------------------------------------------------
  
  -- all_phone_check_turn_tariff ----  BEGIN  ----------------------------------------------------------------------------
  function all_phone_check_turn_tariff -- �������� ������� �������� �� ������ � �������� ��� ��� ������� �������
  (
      p_phone varchar2, 
      p_tariff_id integer, 
      p_pckg_code varchar2, 
      p_unittype varchar2,
      p_turn_on_date date
  ) return number as 
  
    type t_stat is table of all_phone_stat%rowtype index by pls_integer;
    v_rec                   t_stat;
    v_num                 number(38) := 0;
    v_num0                number(38);-- ������ � ������ ������
    v_all_phone_log_id      integer;
    delta_time_sec        number(12);
    ctrl_pnt_cnt          number(12); -- ���-�� ��� ���������� ������� �����
    v_grs                 integer;
    v_date                timestamp;
    i                       number(12) := 0;
    j                       number(12) := 0;
    v_pred_traf       number := 0; --����� ��������������� �������      
    
      procedure proc_send_sms (v_text_sms in varchar2, v_trafic in integer) IS
        SMS VARCHAR2(500 CHAR);  
        v_tar_name varchar2(100 char);
        txt_sms varchar2(500 char);
      begin      
        --���������� �����
        select TR.TARIFF_NAME
           into v_tar_name
          from tariffs tr
        where TR.TARIFF_ID = p_tariff_id;

        --�������� ������ �� ������ ��� ����� ������� �����
        txt_sms := v_text_sms;
        txt_sms:= replace(txt_sms, '%tariff%', v_tar_name);    
        txt_sms:= replace(txt_sms, '%traf_volue%', to_char(v_trafic)); 
        --sms := loader3_pckg.SEND_SMS(p_phone, 'Teletie', txt_sms);
        commit;
      end;
    
  begin       
    --����������� id ����
    select all_phone_log_id
       into v_all_phone_log_id
      from 
      (
        select all_phone_log_id
          from all_phone_turn_log 
        where phone=p_phone
            and tariff_id = p_tariff_id
            and pckg_code = p_pckg_code
            and unittype = p_unittype
            and date_off is null
        order by date_off desc
      ) 
    where rownum <2;

    if (p_pckg_code is not null) and (nvl(v_all_phone_log_id, 0) <> 0) then        
      --�������� ������ ����� ���������
      select * 
         into v_rec(1) 
        from 
        (
           select * 
             from all_phone_stat 
           where phone = p_phone 
               and pckg_code = p_pckg_code
               and unittype = p_unittype
               and all_phone_turn_log_id = v_all_phone_log_id
           order by curr_check_date, all_phone_stat_id
        ) 
      where rownum <2;

      --������������� ���������
      select * 
         into v_rec(2) 
        from 
        (
           select * 
            from 
            (
               select * 
                 from all_phone_stat 
               where phone = p_phone 
                   and pckg_code = p_pckg_code
                   and unittype = p_unittype
                   and all_phone_turn_log_id = v_all_phone_log_id
               order by curr_check_date desc, all_phone_stat_id desc
            ) 
           where rownum <3  
           order by curr_check_date, all_phone_stat_id
        ) 
      where rownum <2;
            
      --������� ���������
      select * 
         into v_rec(3) 
        from 
        (
           select * 
             from all_phone_stat 
           where phone = p_phone 
               and pckg_code = p_pckg_code
               and unittype = p_unittype
               and all_phone_turn_log_id = v_all_phone_log_id
           order by curr_check_date desc, all_phone_stat_id desc
        ) 
      where rownum <2;
        
      -- ������� ����/������� ��������� ��������, ���������� ����� �� ���������������� ������� 0  
      v_num0 := abs(nvl(v_rec(2).currvalue,0)-nvl(v_rec(3).currvalue,0)); -- ����� ����������� � ���������� ���������  
      v_num  := abs(nvl(BEELINE_REST_API_PCKG.intr_to_sec(v_rec(3).curr_check_date - v_rec(2).curr_check_date),0)); -- ����� � ���������� ��������� � ��������
        
      -- ���� ������� ������� �� ������:
      --    > ����������� ���������, ������ ��� ���� ������� � ������ �� ����� ���� ��������� � "0" 
      --    <= 0
      --    �������� 20% �� ���������� ������ �������
      -- �� ���������� ��������������� ���. ��� ��������� 0 ������������ ������� ������� ����������� �������� �� ������. ��� ������� ����������� �������� ���������� ���         
      -- � ������ ������� ����� ������������ ������
      if (nvl(v_rec(3).currvalue,0) <= 0) then
        -- ����� ������������ ������ ��������
        v_pred_traf := BEELINE_REST_API_PCKG.all_phone_calc_traff(p_phone, p_unittype);
        
        -- ���� ��������� ����� -1, �� ��� ������
        if nvl(v_pred_traf, -1) = -1 then
          return(-1);
        end if;
        
        --��������� �������������� ������
        update all_phone_turn_log dr 
             set dr.predvalue = v_pred_traf
        where dr.all_phone_log_id = v_all_phone_log_id;
       
        --�������� ������������ ������ � ���������� all_phone_stat
        update all_phone_stat 
             set is_checked = 1  
        where all_phone_stat_id = v_rec(3).all_phone_stat_id
           and nvl(is_checked,0)=0;
                
        --��������� �������� ���
        --����� ��������� ��� ���������� ��������� ������� ��������� ������� 
        select count(*)
           into v_grs
          from all_phone_turn_log
        where all_phone_log_id = v_all_phone_log_id
            and nvl(do_not_rest, 0) = 0;
        
        --���� �� ����� ������� ������� �� �����������, �� ��� �� ���������� 
        if nvl(v_grs,0) <> 0 then
          select count(*)
             into v_grs
            from all_phone_turn_log
          where all_phone_log_id = v_all_phone_log_id
              and nvl(is_send_sms_zero, 0) = 1;
              
          --���� ��� �� ������������, �� ��� ���������� ���������
          if nvl(v_grs,0) = 0  then
            --���������� ���
            --proc_send_sms(MS_params.GET_PARAM_VALUE('TEXT_SMS_ZERO_TRAFFIC_ALL_PHONE'), trunc(v_rec(3).currvalue/1024)+1);
            
            --��������� ������� ��������
            update all_phone_turn_log dr 
                 set dr.is_send_sms_zero = 1
            where dr.all_phone_log_id = v_all_phone_log_id;
          end if;  
        else
          --��������� ���� ��������� �������� � 0, �.�. ������� �������� ����
          update all_phone_turn_log dr 
               set dr.do_not_rest = 0
          where dr.all_phone_log_id = v_all_phone_log_id;  
        end if;
      else
        --���� �������� ������ 20% ������� � ��� ��� �� ���� �����������, �� ���������� ��������������� ���
        if ((v_num0 <>0) and (v_num <> 0) and (nvl(v_rec(3).currvalue,0) <= v_rec(3).initvalue*c_turn_tariff_ctrlpnt_inc)) then --c_turn_tariff_ctrlpnt_inc = 0.2 (�� ���������) 20%
          --���������� ����� ��������������� �������
          v_pred_traf := BEELINE_REST_API_PCKG.all_phone_calc_traff(p_phone, p_unittype);
          
          -- ���� ��������� ����� -1, �� ��� ������
          if nvl(v_pred_traf, -1) = -1 then
            return(-1);
          end if;
          
          --��������� �������������� ������
          update all_phone_turn_log dr 
               set dr.predvalue = v_pred_traf
          where dr.all_phone_log_id = v_all_phone_log_id;
          
          --��������� �������� ���
          --����� ��������� ��� ���������� ��������� ������� ��������� �������
          select count(*)
             into v_grs
            from all_phone_turn_log
          where all_phone_log_id = v_all_phone_log_id
              and nvl(do_not_rest, 0) = 0;
            
          if nvl(v_grs,0) <> 0 then  
            select count(*)
               into v_grs
              from all_phone_turn_log
            where all_phone_log_id = v_all_phone_log_id
                and nvl(is_send_sms_prev, 0) = 1;
              
            --���� ��� �� ������������, �� ���������� ���������
            if nvl(v_grs,0)=0  then
              --���������� ���
              --proc_send_sms(MS_params.GET_PARAM_VALUE('TEXT_SMS_PREV_FLOW_TRAFFIC_ALL_PHONE'), trunc(v_rec(3).currvalue/1024)+1);
              
              --����������� ������� �������� ���
              update all_phone_turn_log dr 
                   set dr.is_send_sms_prev = 1
              where all_phone_log_id = v_all_phone_log_id;
            end if; 
          else
            --��������� ���� ��������� �������� � 0, �.�. ������� �������� ����
            update all_phone_turn_log dr 
                 set dr.do_not_rest = 0
            where dr.all_phone_log_id = v_all_phone_log_id;    
          end if;
        end if;
        
        --�������� �� ������ 20%
        -------------------------------
        -- ������� ���������� ����������� ����� ��� ��������� ������������ ���������, ��� ���������� ���������� ���������
        -- ��������� ����������� ������ ���������� ����������� ����� 
        select nvl(sum(ctrl_pnt),1) 
           into ctrl_pnt_cnt 
         from all_phone_stat 
        where phone = p_phone 
           and pckg_code = p_pckg_code
           and unittype = p_unittype
           and ctrl_pnt<>0 
           and all_phone_stat_id <>v_rec(3).all_phone_stat_id;
        --dbms_output.put_line('����� ����������� �����: '||ctrl_pnt_cnt);
        -- dbms_output.put_line('20% Check');
        if v_rec(3).currvalue <= v_rec(3).initvalue*(1-c_turn_tariff_ctrlpnt_inc*ctrl_pnt_cnt)  then -- ��-��������� 0.2, ������� ��������� ������ ���� ����� ��� init-20%*�����_�����������_�����
          -- ������ ����� ����������� ����� - ������ ����� ��������� ����������� ������ ����� ������ ������������ �������� (20% �� ���������)
          v_rec(3).ctrl_pnt := ceil((1-v_rec(3).currvalue/v_rec(3).initvalue)/c_turn_tariff_ctrlpnt_inc) - ctrl_pnt_cnt; -- �������� ��� ����������� ������� �����
        else -- ����� ���������� ����� ����������� �����
          v_rec(3).ctrl_pnt := 0;
        end if;
              
        -- ���������� ���� ��������� ��������
        ----------------------------------------------
        -- ����� � �������� � ��������� ��������
        v_num := abs(BEELINE_REST_API_PCKG.intr_to_sec(v_rec(3).curr_check_date-v_rec(2).curr_check_date));
        -- ���� ����� ����� � �������� �������� ������ 0 ��� ��� ����� 5 ���, �� ����������� 10 ���
        if v_num <=300 then 
          v_num:= 600; 
        end if;
          
        -- ���������� ����� ������� ���������������� � ��������� ��������, ���� 0. �� ��� 60 ���
        v_num0 := abs(v_rec(2).currvalue-v_rec(3).currvalue);
        --dbms_output.put_line('������������� ������� : '||v_num0||' �� '||v_num||' ������');
        --dbms_output.put_line('������� ������� ������������������: '||v_rec(3).currvalue);
        if v_num0 = 0 then
          delta_time_sec := c_turn_tariff_checktime_max*60;  -- ��-��������� 60 ���;
        else 
          -- ��������������� ����� ������ ����������� �����
          delta_time_sec :=v_rec(3).initvalue*c_turn_tariff_ctrlpnt_inc*ctrl_pnt_cnt*v_num/v_num0;  -- c_turn_tariff_ctrlpnt_inc (��-��������� 0.2)
          -- ��������������� ����� ������ ���� �������
          v_num0 := v_rec(3).currvalue*v_num/v_num0;
          --dbms_output.put_line('������ 20% ����� ������: '||delta_time_sec);
          --dbms_output.put_line('������ ���� ����� ������: '||v_num0);
          
          -- ���� ������ ���� ��������� ������� ������ 20% �� ������������� �� ����
          if delta_time_sec > v_num0 then 
            delta_time_sec := v_num0; 
            -- ���������� ���������� � ����������� ������ �������� ������������ ��������� 
            if delta_time_sec < c_turn_tariff_checktime_min then 
              delta_time_sec := c_turn_tariff_checktime_min;
            else                
              delta_time_sec := floor(delta_time_sec/(c_turn_tariff_checktime_min*60))*c_turn_tariff_checktime_min*60;
            end if;
          end if;            
          -- dbms_output.put_line('���������� ���� �������� � ��������: '||delta_time_sec);
          -- ���� ��������� ����� ����������� 20% ������� �� ���������� ������� ����� ����� 1 ����, �� ��������� ��������� ��������� ����� 1 ���
          if delta_time_sec/60/60 > 1 then 
            delta_time_sec := c_turn_tariff_checktime_max*60; 
          end if;
        end if;
              
        -- ����������� ���� ��������� ��������, ����������� �����
        update all_phone_stat set next_check_date = trunc(sysdate+delta_time_sec/24/60/60,'MI'), ctrl_pnt = v_rec(3).ctrl_pnt  where all_phone_stat_id=v_rec(3).all_phone_stat_id;
      end if;
      
      --�������� ������ ������ �������������
      update all_phone_stat 
           set is_checked = 1  
       where all_phone_stat_id in (v_rec(1).all_phone_stat_id, v_rec(2).all_phone_stat_id) 
          and nvl(is_checked,0)=0;
      commit;
    else
      return(-1);
    end if;  
    return(0);
  exception
    when no_data_found then
      --������� ��������� ����� � REST - ������� (������ �� ��������� �����. ������� (���� Skype TeleTie 2015-02-19 14:17))
      select all_phone_stat_id 
         into v_num
       from 
       (
          select all_phone_stat_id
           from all_phone_stat 
         where phone=p_phone
             and pckg_code = p_pckg_code
             and unittype = p_unittype
         order by all_phone_stat_id desc
       ) 
      where rownum<2;
        
      --���� ���������� ����, �� ������������ ������ � ������� ������ all_phone_turn_log
      if v_num is not null then 
        -- ctrl_pnt ��������� ����������� ������ ����������� �����  ����� ��� �� ���� ����� ������������ �������� (20% �� ���������)       
        update all_phone_stat set ctrl_pnt=ceil((1-currvalue/initvalue)/c_turn_tariff_ctrlpnt_inc), next_check_date = trunc(sysdate+c_turn_tariff_checktime_min/24/60,'MI') where all_phone_stat_id = v_num;
        
        -- �������� all_phone_turn_log ������� �� ���������.
        select count(1)
          into i 
         from 
         (
            select distinct all_phone_turn_log_id 
             from all_phone_stat 
           where phone=p_phone
               and pckg_code = p_pckg_code
               and unittype = p_unittype
         );
         
        j :=0; 
        for rec in (
                        select distinct all_phone_turn_log_id 
                          from 
                          (
                                select all_phone_turn_log_id 
                                 from all_phone_stat 
                               where phone=p_phone
                                   and pckg_code = p_pckg_code
                                   and unittype = p_unittype
                                   and not exists(
                                                          select 1 
                                                            from all_phone_turn_log 
                                                          where all_phone_log_id = all_phone_turn_log_id
                                                      ) 
                               order by all_phone_stat_id
                          )
                    ) 
        loop
          j := j + 1;
          if j = i then 
            v_date := null; 
          else 
            v_date := systimestamp; 
          end if;
          
          begin
            insert into all_phone_turn_log
              ( 
                ALL_PHONE_LOG_ID,
                PHONE,
                TARIFF_ID,
                TURN_ON_DATE,
                PCKG_CODE,
                UNITTYPE,
                DATE_ON,
                DATE_OFF,
                IS_SEND_SMS_ZERO,
                IS_SEND_SMS_PREV,
                PREDVALUE,
                DO_NOT_REST
              )
              values 
              (
                rec.all_phone_turn_log_id, 
                p_phone, 
                p_tariff_id,
                p_turn_on_date,
                p_pckg_code, 
                p_unittype,
                sysdate, 
                v_date,
                0, 
                0,
                null,
                null
              );
          exception
            when DUP_VAL_ON_INDEX then 
              v_grs  := BEELINE_REST_API_PCKG.get_resp_stat(-9000,'DUP_VAL_ON_INDEX','Error adding record in all_phone_turn_log with all_phone_turn_log_id from all_phone_stat.', p_phone, 0,'all_phone_check_turn_tariff',0
                                        ,'Phone number: '||p_phone||' | Pckg_code: '||p_pckg_code||' | User: '||user
                                        , 'Error adding record in all_phone_turn_log with all_phone_turn_log_id from all_phone_stat.');
          end;
        end loop;
        commit;
      else
        return(-1);
      end if;
      return(0);
  end;
  -- all_phone_check_turn_tariff ----  END  ------------------------------------------------------------------------------
  
  -- all_phone_calc_traff ----  BEGIN  -------------------------------------------------------------------------------------
  function all_phone_calc_traff(p_phone varchar2, p_unittype varchar2) return number as -- ������ ���������������� ������� � ������������ �� ��� ������� ��� �������. ��������� - �������� ��������������� ������� �� �������
    type t_stat2 is record
      (
        phone           varchar2(10),
        initvalue       integer,
        currvalue       integer,
        curr_check_date timestamp
      );
    type t_stats is table of t_stat2 index by pls_integer;
    vt_stat t_stats;
    v_end_month_sec number(24,3)  := 0;
    total_sec  number(24,3)  := 0; 
    total_traf  number(24)    := 0; 
    v_pred_traf number(24,3) := 0;
    v_date date;
  begin
    -- � ���� ����������� ��� ���������� ������/����� ������� ����
    for rec_tl in  (
                          select *
                            from all_phone_turn_log
                          where phone = p_phone
                             and unittype = p_unittype
                          order by date_on                
                      )
    loop
      -- � ������� ����������� ��� ������ ��������� � ��� ��������� � ������� initvalue <> currvalue
      -- , ���� ������ ������� (initvalue(curr) > initvalue(previous) ) ������ ���� ����� �� ����� � ������ �������� ������ ������
      select
                sq.phone,
                sq.initvalue,
                sq.currvalue,
                sq.curr_check_date
        bulk  collect into vt_stat
        from
              (      
                  select
                          phone,
                          initvalue,
                          currvalue,
                          curr_check_date
                    from all_phone_stat
                   where phone = rec_tl.phone
                       and unittype = p_unittype
                       and all_phone_turn_log_id = rec_tl.all_phone_log_id
                   order by curr_check_date
              ) sq
      where rownum=1 
             or (rownum>1 and sq.initvalue<>sq.currvalue)
      order by sq.curr_check_date desc;

      total_sec := total_sec + intr_to_sec(vt_stat(1).curr_check_date-vt_stat(vt_stat.count).curr_check_date);
      total_traf := total_traf+(vt_stat(1).initvalue-vt_stat(1).currvalue)-(vt_stat(vt_stat.count).initvalue-vt_stat(vt_stat.count).currvalue); 
    end loop;    
    
    if total_traf = 0 then
      --���������� ������� ������� �� ������, �.�. �� ��������� ������ � all_phone_stat �� �������� ����
      select initvalue 
         into total_traf 
        from 
        (
           select * 
             from all_phone_stat 
           where phone = p_phone 
               and unittype = p_unittype
           order by curr_check_date desc, all_phone_stat_id desc
        ) 
      where rownum <2;
      
      --���������� ���� ��������
      select V.CONTRACT_DATE
         into v_date
       from v_contracts v
      where V.CONTRACT_CANCEL_DATE is null
          and V.PHONE_NUMBER_FEDERAL = p_phone;
      
      --���� ���� ��������� ������ 1 ����� �������� ������, �� � �������� ���� ����� 1 ����� ������
      if v_date < trunc(sysdate, 'MM') then
        v_date := trunc(sysdate, 'MM');
      end if;
      
      --���-�� ������ � ������ ������ �� ������� ������������ ��������
      total_sec := intr_to_sec(systimestamp - to_date(to_char(v_date,'YYYY-MM-DD')||' 00:00:00','YYYY-MM-DD hh24:mi:ss'));
    end if;
          
    --���� ������� ��������, �� �������
    if (total_sec  <= 0) or 
       (total_traf <= 0) then 
      return(-1); 
    end if;
    
    --���-�� ������ �� ����� ������ ������� � ������� ������������ ��������
    v_end_month_sec := intr_to_sec(to_date(to_char(last_day(sysdate),'YYYY-MM-DD')||' 23:59:59','YYYY-MM-DD hh24:mi:ss')-systimestamp);
          
    -- �� ����� ������ ����������� (��)
    v_pred_traf := total_traf*v_end_month_sec/total_sec;    
    return v_pred_traf;                      
  exception
    when no_data_found then 
      return(-1);                       
  end;
  -- all_phone_calc_traff ----  END  ---------------------------------------------------------------------------------------
  
  -- all_phone_init_new_month ----  BEGIN  -----------------------------------------------------------------------------
  procedure all_phone_init_new_month as -- ������������� ������ ������ ��� �������, �� ������� ���� �������� �������
  begin
    -- ������� � ����� ������ �� ��������� �����
    for rec in (
                     select distinct phone 
                       from all_phone_stat
                  ) 
    loop
      insert into all_phone_stat_hist 
      (
        ALL_PHONE_STAT_ID,
        ALL_PHONE_TURN_LOG_ID,
        PHONE,
        PCKG_CODE,
        UNITTYPE,
        INITVALUE,
        CURRVALUE,
        CURR_CHECK_DATE,
        NEXT_CHECK_DATE,
        CTRL_PNT,
        IS_CHECKED
      ) 
      select 
          gs.ALL_PHONE_STAT_ID,
          gs.ALL_PHONE_TURN_LOG_ID,
          gs.PHONE,
          gs.PCKG_CODE,
          gs.UNITTYPE,
          gs.INITVALUE,
          gs.CURRVALUE,
          gs.CURR_CHECK_DATE,
          gs.NEXT_CHECK_DATE,
          gs.CTRL_PNT,
          gs.IS_CHECKED
      from all_phone_stat gs
      where gs.phone=rec.phone
      and gs.CURR_CHECK_DATE<trunc(sysdate);
        
      --������� �� all_phone_stat
      delete from all_phone_stat 
      where phone=rec.phone 
         and CURR_CHECK_DATE<trunc(sysdate);
    end loop;
    commit;
    
    for rec in (
                     select distinct phone 
                      from all_phone_turn_log
                  ) 
    loop
      insert into all_phone_turn_log_hist
      ( 
        ALL_PHONE_LOG_ID,
        PHONE,
        TARIFF_ID,
        TURN_ON_DATE,
        PCKG_CODE,
        UNITTYPE,
        DATE_ON,
        DATE_OFF,
        IS_SEND_SMS_ZERO,
        IS_SEND_SMS_PREV,
        PREDVALUE,
        DO_NOT_REST
      )
      select 
        ALL_PHONE_LOG_ID,
        PHONE,
        TARIFF_ID,
        TURN_ON_DATE,
        PCKG_CODE,
        UNITTYPE,
        DATE_ON,
        DATE_OFF,
        IS_SEND_SMS_ZERO,
        IS_SEND_SMS_PREV,
        PREDVALUE,
        DO_NOT_REST
      from all_phone_turn_log 
      where phone=rec.phone 
         and date_on<trunc(sysdate);
      
      delete from all_phone_turn_log 
      where phone=rec.phone 
          and date_on<trunc(sysdate);
    end loop;
    commit;
  end;
  -- all_phone_init_new_month ----  END  --------------------------------------------------------------------------------
  
END BEELINE_REST_API_PCKG;