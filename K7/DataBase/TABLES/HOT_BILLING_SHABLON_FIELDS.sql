CREATE TABLE HOT_BILLING_SHABLON_FIELDS(
  EXT_P_BAN VARCHAR2(9 BYTE),  
  BAN NUMBER(9),
  BEN NUMBER(5), 
  BILL_SEQ_N NUMBER(5),
  SUBSCR_NO VARCHAR2(11 BYTE),
  CH_SEIZ_DT DATE,
  MSG_SWH_ID VARCHAR2 (15 Byte),  
  US_SEQ_N NUMBER(9),
  AT_SOC VARCHAR2(9 Byte),
  AT_SOC_DT DATE,
  SOC_EXP_DT DATE,
  SOC_SEQ_NO NUMBER(9),
  AT_FT_CODE VARCHAR2(6 Byte),
  AT_RTEF_DT DATE,
  AT_RTFR_LV VARCHAR2(1 Byte),
  RT_LVL_CD VARCHAR2(1 Byte),
  PC_PLAN_CD VARCHAR2(9 Byte),
  PC_P_EF_DT DATE,
  S_FTR_SQ_N NUMBER(9), 
  C_ACT_CD VARCHAR2(1 Byte),
  AT_RTAT_CD VARCHAR2(1 Byte),
  FT_SEL_DT DATE,
  AT_C_DR_SC NUMBER(9),
  AT_CDRRD_M NUMBER(11,2),
  AT_NMIN_RT NUMBER(11,2),
  AT_N_OF_IM NUMBER(11,2),
  AT_CHG_AMT NUMBER(11,2),
  AT_C_AT_IU NUMBER(11,2),
  AT_C_ST_PD VARCHAR2(2 Byte),
  IN_PD_CODE VARCHAR2(2 Byte),
  CALL_TO_TN VARCHAR2(18 Byte),
  CALLING_NO VARCHAR2(21 Byte),
  MPS_FIL_NM NUMBER(9),
  SPC_NUM_TP VARCHAR2(1 Byte),
  MESSAGE_TP VARCHAR2(1 Byte),
  AIR_FRE_CD VARCHAR2(2 Byte),
  C_CPRD_IND VARCHAR2(1 Byte),
  C_CSTP_IND VARCHAR2(1 Byte),
  CYCLE_CODE NUMBER(2),
  CYL_R_YR NUMBER(4),
  CYL_R_MTH NUMBER(2),
  BL_RERT_CD VARCHAR2(1 Byte),
  BL_RERT_DT DATE,
  ACT_RSL_CD VARCHAR2(2 Byte),
  SRV_FT_CD VARCHAR2(6 Byte),
  DURATION VARCHAR2(8 Byte),
  FREE_CL_RS VARCHAR2(1 Byte),
  MTRD_UNITS NUMBER(9),
  DATA_VOL NUMBER(11,2),
  WHLSALE_PC NUMBER(9,3),
  N_DCWH_PC NUMBER(9,3),
  ORIG_AMT NUMBER(11,2),
  ORIG_AM_GN NUMBER(11,2),
  NW_CH_ORIG VARCHAR2(16 Byte),
  F_PROC_IND VARCHAR2(1 Byte),
  C_OF_ORIG VARCHAR2(3 Byte),
  AU_EFF_DT DATE,
  C_MN_ST_DT DATE,
  C_STT_DT DATE,
  MPS_RT_IND VARCHAR2(1 Byte),
  SRV_TP VARCHAR2(1 Byte),
  INC_SRV VARCHAR2(8 Byte),
  INC_FT VARCHAR2(8 Byte),
  TF_PLAN_ID VARCHAR2(8 Byte),
  INC_ACC_ID VARCHAR2(8 Byte),
  IMSI VARCHAR2(15 Byte),
  IMEI VARCHAR2(15 Byte),
  M_CGTP_IND VARCHAR2(1 Byte),
  EVENT_TYPE NUMBER(3),
  THSHLD_CLS VARCHAR2(2 Byte),
  AT_GRS_AMT NUMBER(11,2),
  AC_AMT NUMBER(11,2),
  CL_FWD_IND VARCHAR2(1 Byte),
  CELL_ID VARCHAR2(6 Byte),
  DEF_BEN NUMBER(5),
  USG_PAC_CD VARCHAR2(5 Byte),
  LOC_AREA VARCHAR2(6 Byte),
  GUIDE_BY VARCHAR2(1 Byte),
  OUTCOL_IND VARCHAR2(1 Byte),
  PROV_ID VARCHAR2(8 Byte),
  R_TAMT_AIR NUMBER(11,2),
  WAVD_CL_IN VARCHAR2(1 Byte),
  BSC_SRV_CD VARCHAR2(2 Byte),
  BSC_SRV_TP VARCHAR2(1 Byte),
  DIALED_DIG VARCHAR2(21 Byte),
  C_COUNT_CD VARCHAR2(3 Byte),
  CALL_SRC VARCHAR2(1 Byte),
  CALL_DEST VARCHAR2(1 Byte),
  RECORD_ID VARCHAR2(5 Byte),
  INIT_F_IND VARCHAR2(1 Byte),
  C_CRDT_IND VARCHAR2(1 Byte),
  C_CRIU_IND VARCHAR2(1 Byte),
  MT_FTR_IND VARCHAR2(1 Byte),
  PRODUCT_TP VARCHAR2(1 Byte),
  CALL_SERV VARCHAR2(1 Byte),
  TAX_IND VARCHAR2(1 Byte),
  RATE_CODE1 VARCHAR2(9 Byte),
  RATE_CODE2 VARCHAR2(9 Byte),
  RATE_CODE3 VARCHAR2(9 Byte),
  RATE_CODE4 VARCHAR2(9 Byte),
  RATE_CODE5 VARCHAR2(9 Byte),
  RT_CD_IND1 VARCHAR2(1 Byte),
  RT_CD_IND2 VARCHAR2(1 Byte),
  RT_CD_IND3 VARCHAR2(1 Byte),
  RT_CD_IND4 VARCHAR2(1 Byte),
  RT_CD_IND5 VARCHAR2(1 Byte),
  LOGCL_DATE DATE,
  IU_LVL_CD VARCHAR2(1 Byte),
  ALLOCN_IND VARCHAR2(1 Byte),
  PF_SHRT_CD VARCHAR2(7 Byte),
  AT_CAI_SGR NUMBER(11,2),
  UOM VARCHAR2(2 Byte),
  C_UC_RT_IN VARCHAR2(1 Byte),
  SDR_AMOUNT NUMBER(12,6),
  SP_SRVC_CD VARCHAR2(10 Byte),
  HOME_CTN VARCHAR2(11 Byte),
  TECHNOLOGY VARCHAR2(1 Byte),
  NEW_BAL NUMBER(11,2),
  ADV_PM_IND VARCHAR2(1 Byte),
  CALL_DESTN VARCHAR2 (50 Byte),
  SUB_STATUS VARCHAR2(1 Byte),
  CUR_IND VARCHAR2(1 Byte),
  MAIN_CTN VARCHAR2(11 Byte),
  MAIN_SOCNO NUMBER(9),
  COMVRS_AMT NUMBER(15,6),
  AL_PYD_IND VARCHAR2(1 Byte),
  SERVICE_ID VARCHAR2(2 Byte),
  ROAM_FLAG VARCHAR2(1 Byte),
  DIRECTION VARCHAR2(3 Byte),
  SPECIAL_FT VARCHAR2(1 Byte),
  SRVICE_FLG VARCHAR2(3 Byte),
  MPSRT_IND VARCHAR2(1 Byte),
  SUBSCR_ID NUMBER(9),
  DISCT_SOCS VARCHAR2(100 Byte),
  LOC_ZNE_ID VARCHAR2(8 Byte),
  SES_ST_DT DATE,
  USG_SES_ID VARCHAR2(10 Byte),
  DR_SOC VARCHAR2(9 Byte),
  DR_SCSQ_NO NUMBER(9),
  DR_STEP NUMBER(9),
  AT_FT_DESC VARCHAR2(100 Byte)
  );

COMMENT ON TABLE HOT_BILLING_SHABLON_FIELDS IS '������� ������ ��� �����(��� ���� ������)';

COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.EXT_P_BAN IS 'BAN �����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.BAN IS 'BAN �������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.BEN IS 'BEN �������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.BILL_SEQ_N IS '����������� ���������� ����� ������ � ����������� ����� (��������� ��������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SUBSCR_NO IS '������� �����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CH_SEIZ_DT IS '����_����� ���������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.MSG_SWH_ID IS '������� ���������� (SwitchID)'; 
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.US_SEQ_N IS '���������� ����� ������ (��������� ����)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_SOC IS '������, �� ������� ������������ �����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_SOC_DT IS '���� ��������� ��������������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SOC_EXP_DT IS '���� ���������� �������� ��������������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SOC_SEQ_NO IS '���������� ����� ������ � ����������� ������ (��������� ��������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_FT_CODE IS '�������� ���� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_RTEF_DT IS '���� ����� ����������� ������� ���� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_RTFR_LV IS '������� ����������� ������: N � �� ���������; M � ������-������� (������� ��������); C � ������� �������� ������ (�����-�����, ������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RT_LVL_CD IS '������� �����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.PC_PLAN_CD IS '�������� ����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.PC_P_EF_DT IS '���� ��������� ��������� �����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.S_FTR_SQ_N IS '���������� ����� ������ � ����������� ��������������� ������ (��������� ��������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_ACT_CD IS '��� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_RTAT_CD IS '��� ��������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.FT_SEL_DT IS '���� ����������� ���������������� ������ ��� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_C_DR_SC IS '������������ (���.)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_CDRRD_M IS '������������ (���., � �����������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_NMIN_RT IS '���������� ����� ��� �����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_N_OF_IM IS '���������� ������������ (��������) ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_CHG_AMT IS '���������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_C_AT_IU IS '��������� ������� ���������� ������������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_C_ST_PD IS '������ ���������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.IN_PD_CODE IS '������ ���������� ��������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CALL_TO_TN IS '����� ����������� ��������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CALLING_NO IS '����� ���������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.MPS_FIL_NM IS '������������� ����� (��������� ��������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SPC_NUM_TP IS '������� ����������� �����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.MESSAGE_TP IS '��� ������: �������� ��� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AIR_FRE_CD IS '������� ��-�����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_CPRD_IND IS '������� ����������� ������� ���������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_CSTP_IND IS '������� ����������� ������ (��� ����-�����������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CYCLE_CODE IS '�������-����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CYL_R_YR IS '���';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CYL_R_MTH IS '�����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.BL_RERT_CD IS '������� ����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.BL_RERT_DT IS '���� ����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.ACT_RSL_CD IS '������������� ������ ����������� ������ (��� ��������� �������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SRV_FT_CD IS '������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.DURATION IS '������������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.FREE_CL_RS IS '������� ��-�����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.MTRD_UNITS IS '������� ���������.'; 
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.DATA_VOL IS '����� (��� data)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.WHLSALE_PC IS '����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.N_DCWH_PC IS '���� � ������ ��������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.ORIG_AMT IS '��������� �� ���������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.ORIG_AM_GN IS '������������� (�������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.NW_CH_ORIG IS '���������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.F_PROC_IND IS '��������� ���������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_OF_ORIG IS '������ ���������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AU_EFF_DT IS '���� ������������� ������������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_MN_ST_DT IS '����� ������ �������-�����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_STT_DT IS '���� ������ �������-�����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.MPS_RT_IND IS '������� ����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SRV_TP IS '����� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.INC_SRV IS '������� ��������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.INC_FT IS '��� ��������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.TF_PLAN_ID IS '�������� ���� ��������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.INC_ACC_ID IS 'Account ID';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.IMSI IS 'IMSI';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.IMEI IS 'IMEI';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.M_CGTP_IND IS '��� ����������� (�������� ����������� ��� ���)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.EVENT_TYPE IS '��� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.THSHLD_CLS IS '����� ������'; 
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_GRS_AMT IS '��������� ��� ����� ������  ��������������� ����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AC_AMT IS '�������������� ��������� (��������, ��������� ����������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CL_FWD_IND IS '������� �������������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CELL_ID IS '������������� ����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.DEF_BEN IS 'BEN �� ���������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.USG_PAC_CD IS '��������� ���� (�� ������������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.LOC_AREA IS '��� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.GUIDE_BY IS '������� �����������: �� IMSI/MSISDN/ ��������������� MSISDN'; 
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.OUTCOL_IND IS '������� ����������� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.PROV_ID IS '�������-���������. ��������� ���������� ��������:'; 
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.R_TAMT_AIR IS '������ �������-����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.WAVD_CL_IN IS '������� ����������������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.BSC_SRV_CD IS '��� �������� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.BSC_SRV_TP IS '��� �������� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.DIALED_DIG IS '��������� �����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_COUNT_CD IS '��� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CALL_SRC IS '�������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CALL_DEST IS '����������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RECORD_ID IS '������������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.INIT_F_IND IS '��������� ��������� ����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_CRDT_IND IS '������� ����������� ����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_CRIU_IND IS '������� ���������� ������ ������������ ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.MT_FTR_IND IS '������� ������� ������������� �������������� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.PRODUCT_TP IS '��� ��������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CALL_SERV IS '��� ���������� �������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.TAX_IND IS '������� ���������������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RATE_CODE1 IS '����-���1-5 (���������� ����� ����������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RATE_CODE2 IS '����-���1-5';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RATE_CODE3 IS '����-���1-5';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RATE_CODE4 IS '����-���1-5';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RATE_CODE5 IS '����-���1-5';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RT_CD_IND1 IS '������� ����-���� 1-5';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RT_CD_IND2 IS '������� ����-���� 1-5';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RT_CD_IND3 IS '������� ����-���� 1-5';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RT_CD_IND4 IS '������� ����-���� 1-5';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.RT_CD_IND5 IS '������� ����-���� 1-5';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.LOGCL_DATE IS '���������� ����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.IU_LVL_CD IS '��� ������������ ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.ALLOCN_IND IS '������� ���������� ���������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.PF_SHRT_CD IS '�������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_CAI_SGR IS '��������� ������� ����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.UOM IS '������� ���������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.C_UC_RT_IN IS '������� ������� ������ (��� ����������� �������)';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SDR_AMOUNT IS '��������� � SDR';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SP_SRVC_CD IS '�������������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.HOME_CTN IS '����� ����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.TECHNOLOGY IS '����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.NEW_BAL IS '������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.ADV_PM_IND IS '������� ��������� ������� ��������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CALL_DESTN IS '';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SUB_STATUS IS '������ �������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.CUR_IND IS '������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.MAIN_CTN IS '�������� ������� �����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.MAIN_SOCNO IS '��������������� ������ ���������� ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.COMVRS_AMT IS '������� �������-��������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AL_PYD_IND IS '������� ������������'; 
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SERVICE_ID IS '������ID';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.ROAM_FLAG IS '������� ��������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.DIRECTION IS '�����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SPECIAL_FT IS '����������� �����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SRVICE_FLG IS '';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.MPSRT_IND IS '������� ����������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SUBSCR_ID IS 'ID  ��������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.DISCT_SOCS IS '������-������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.LOC_ZNE_ID IS '������� ��������� ����';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.SES_ST_DT IS '���� ������ ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.USG_SES_ID IS 'ID ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.DR_SOC IS '������ ������������ ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.DR_SCSQ_NO IS '���������� ����� ������ � ����������� ������������ ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.DR_STEP IS '���� ������������ ������';
COMMENT ON COLUMN HOT_BILLING_SHABLON_FIELDS.AT_FT_DESC IS '��� ������ (�����). ��������� ���������� �������� :';
