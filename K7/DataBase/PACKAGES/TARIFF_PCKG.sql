CREATE OR REPLACE PACKAGE "TARIFF_PCKG" AS
/******************************************************************************
   NAME:       TARIFF_PCKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/06/2015      Developer       1. Created this package.
******************************************************************************/

  FUNCTION GET_TARIFFS_ATTR RETURN TARIFFS_ATTRS_TABLE;

  FUNCTION GET_TARIFFS_ATTR_PIPE RETURN TARIFFS_ATTRS_TABLE pipelined; 

END TARIFF_PCKG;

/


CREATE OR REPLACE PACKAGE BODY "TARIFF_PCKG" IS
--#Version=2
--

 FUNCTION GET_TARIFFS_ATTR_PIPE
  RETURN TARIFFS_ATTRS_TABLE pipelined IS
  TAR_ATR_L TARIFFS_ATTRS_LIST;
  i integer ;
  
  BEGIN
   TAR_ATR_L := TARIFFS_ATTRS_LIST(null, null, null, null, null, null, null, null, null);
    for cur in(
                SELECT t.* FROM TARIFFS t 
              )
              LOOP
                i := 0;
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.IS_ACTIVE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.START_BALANCE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������� �����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.CONNECT_PRICE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.ADVANCE_PAYMENT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������������, ��������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := (cur.USER_CREATED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'VARCHAR2(30 CHAR)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����/����� �������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DATE_CREATED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'DATE';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������������, ��������������� ������ ���������';
                TAR_ATR_L.ATTRIBUTES_VALUE := (cur.USER_LAST_UPDATED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'VARCHAR2(30 CHAR)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME       := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����/����� ��������� �������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DATE_LAST_UPDATED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'DATE';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := ' PHONE_NUMBER_TYPE';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.PHONE_NUMBER_TYPE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ����� �� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DAYLY_PAYMENT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(15,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ����� �� ������ (�������������)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DAYLY_PAYMENT_LOCKED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(15,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ����� �� ������ � ���.';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur. MONTHLY_PAYMENT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(15,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ����� �� ������ � ���. (�������������)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.MONTHLY_PAYMENT_LOCKED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(15,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ��������� ���������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.CALC_KOEFF);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,8)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '���������� ���������� ����� � �����, ��� ���������� ������� ����� �������� �������� � ����� �� ���������� �������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.FREE_MONTH_MINUTES_CNT_FOR_RPT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(6)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME       := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_BLOCK);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� �������������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_UNBLOCK);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ��������������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_NOTICE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '���������� ��������� ��� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TARIFF_ADD_COST);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_BLOCK_CREDIT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� �������������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_UNBLOCK_CREDIT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ��������������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_NOTICE_CREDIT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��� ��������� ����� �� CRM';
                TAR_ATR_L.ATTRIBUTES_VALUE := (cur.TARIFF_CODE_CRM);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'VARCHAR2(50 CHAR)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������� ��������� �����';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TARIFF_PRIORITY);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������ ����������� �� ����(GSM)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TARIFF_ABON_DAILY_PAY);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������� ����� + � ���300';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TARIFF_ACTION_PLUS_SMS);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '�������� ����. ��. ��� ��������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.OPERATOR_MONTHLY_ABON_ACTIV);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(13,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '�������� ����. ��. � ����. ����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.OPERATOR_MONTHLY_ABON_BLOCK);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(13,2)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ��������� �����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.CALC_KOEFF_DETAL);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := 'TRAFFIC_NOT_IGNOR_FOR_INACTIVE';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TRAFFIC_NOT_IGNOR_FOR_INACTIVE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '���������� �������� ����������� �����';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DISCR_SPISANIE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� �������� ����������� �����(1 - �� 1 ���� ������, -2 - �� 2 ��� �����)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.SDVIG_SPISANIY);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ����������� �������� ����������� �����(1 - ���������� ����� 1�� ������, 0 - ����� ����������)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.SDVIG_DISCR_SPISANIE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������� ������� � ������ ��������������� internet ���.�������(�����)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.IS_AUTO_INTERNET);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������� �� ����� ������ � ������ - ������ ��� �������, 1 - �� ���������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.NOT_USE_REP_PHONE_WITHOUT_TRAF);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������� ��������-������� ������ ��� ������� ���������� ����������� ���.������ (����������� �������).';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.REST_AUTO_INTERNET);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);

                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '�������, �������� �� ����� �������� �������: 1 - ��, 0 - ���';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.IS_INTERNET_TARIFF);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_L.ATTRIBUTES_ID    := i;
                pipe ROW(TAR_ATR_L);
  
              for cur2 in (
                              select ta.NOTE, ta.ATTRIBUTES_VALUE, ta.ATTRIBUTES_TYPE
                                from v_TARIFFS_ATTRS ta , CONGR_TARIF ct
                               where ta.TARIFFS_ATTRIBUTES_ID = ct.TARIFFS_ATTRIBUTES_ID and ct.TARIFF_ID = cur.TARIFF_ID
                            )
                       loop
                         i := i+1;
                         TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                         TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                         TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                         TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                         TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                         TAR_ATR_L.ATTRIBUTES_NAME  := cur2.NOTE ;
                         TAR_ATR_L.ATTRIBUTES_VALUE := cur2.ATTRIBUTES_VALUE;
                         TAR_ATR_L.ATTRIBUTES_TYPE  := cur2.ATTRIBUTES_TYPE;
                         TAR_ATR_L.ATTRIBUTES_ID    := i;
                         pipe ROW(TAR_ATR_L);
                      end loop;
              end loop;
      RETURN ;
  END;

 FUNCTION GET_TARIFFS_ATTR
  RETURN TARIFFS_ATTRS_TABLE IS
  i integer := 0;
  TAR_ATR_T TARIFFS_ATTRS_TABLE := TARIFFS_ATTRS_TABLE();
  TAR_ATR_L TARIFFS_ATTRS_LIST;

  BEGIN
   TAR_ATR_L := TARIFFS_ATTRS_LIST(null, null, null, null, null, null, null, null, null);
    for cur in(
                SELECT t.* FROM TARIFFS t 
              )
              LOOP
                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.IS_ACTIVE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.START_BALANCE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������� �����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.CONNECT_PRICE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.ADVANCE_PAYMENT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������������, ��������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := (cur.USER_CREATED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'VARCHAR2(30 CHAR)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����/����� �������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DATE_CREATED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'DATE';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������������, ��������������� ������ ���������';
                TAR_ATR_L.ATTRIBUTES_VALUE := (cur.USER_LAST_UPDATED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'VARCHAR2(30 CHAR)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME       := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����/����� ��������� �������� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DATE_LAST_UPDATED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'DATE';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := ' PHONE_NUMBER_TYPE';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.PHONE_NUMBER_TYPE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ����� �� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DAYLY_PAYMENT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(15,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ����� �� ������ (�������������)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DAYLY_PAYMENT_LOCKED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(15,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ����� �� ������ � ���.';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur. MONTHLY_PAYMENT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(15,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ����� �� ������ � ���. (�������������)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.MONTHLY_PAYMENT_LOCKED);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(15,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ��������� ���������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.CALC_KOEFF);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,8)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '���������� ���������� ����� � �����, ��� ���������� ������� ����� �������� �������� � ����� �� ���������� �������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.FREE_MONTH_MINUTES_CNT_FOR_RPT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(6)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME       := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_BLOCK);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� �������������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_UNBLOCK);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ��������������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_NOTICE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '���������� ��������� ��� ������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TARIFF_ADD_COST);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_BLOCK_CREDIT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� �������������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_UNBLOCK_CREDIT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ��������������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.BALANCE_NOTICE_CREDIT);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��� ��������� ����� �� CRM';
                TAR_ATR_L.ATTRIBUTES_VALUE := (cur.TARIFF_CODE_CRM);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'VARCHAR2(50 CHAR)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '��������� ��������� �����';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TARIFF_PRIORITY);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������ ����������� �� ����(GSM)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TARIFF_ABON_DAILY_PAY);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������� ����� + � ���300';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TARIFF_ACTION_PLUS_SMS);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '�������� ����. ��. ��� ��������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.OPERATOR_MONTHLY_ABON_ACTIV);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(13,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '�������� ����. ��. � ����. ����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.OPERATOR_MONTHLY_ABON_BLOCK);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(13,2)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����������� ��������� �����������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.CALC_KOEFF_DETAL);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := 'TRAFFIC_NOT_IGNOR_FOR_INACTIVE';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.TRAFFIC_NOT_IGNOR_FOR_INACTIVE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '���������� �������� ����������� �����';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.DISCR_SPISANIE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� �������� ����������� �����(1 - �� 1 ���� ������, -2 - �� 2 ��� �����)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.SDVIG_SPISANIY);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '����� ����������� �������� ����������� �����(1 - ���������� ����� 1�� ������, 0 - ����� ����������)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.SDVIG_DISCR_SPISANIE);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������� ������� � ������ ��������������� internet ���.�������(�����)';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.IS_AUTO_INTERNET);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������� �� ����� ������ � ������ - ������ ��� �������, 1 - �� ���������';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.NOT_USE_REP_PHONE_WITHOUT_TRAF);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'INTEGER';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '������� ��������-������� ������ ��� ������� ���������� ����������� ���.������ (����������� �������).';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.REST_AUTO_INTERNET);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(12)';
                TAR_ATR_T(i) := TAR_ATR_L;

                TAR_ATR_T.EXTEND(1);
                i := i+1;
                TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                TAR_ATR_L.ATTRIBUTES_NAME  := '�������, �������� �� ����� �������� �������: 1 - ��, 0 - ���';
                TAR_ATR_L.ATTRIBUTES_VALUE := to_char(cur.IS_INTERNET_TARIFF);
                TAR_ATR_L.ATTRIBUTES_TYPE  := 'NUMBER(1)';
                TAR_ATR_T(i) := TAR_ATR_L;
                for cur2 in (
                              select ta.NOTE, ta.ATTRIBUTES_VALUE, ta.ATTRIBUTES_TYPE
                                from v_TARIFFS_ATTRS ta , CONGR_TARIF ct
                               where ta.TARIFFS_ATTRIBUTES_ID = ct.TARIFFS_ATTRIBUTES_ID and ct.TARIFF_ID = cur.TARIFF_ID
                            )
                       loop
                         TAR_ATR_T.EXTEND(1);
                         i := i+1;
                         TAR_ATR_L.TARIFF_ID        := cur.TARIFF_ID;
                         TAR_ATR_L.TARIFF_CODE      := cur.TARIFF_CODE;
                         TAR_ATR_L.OPERATOR_ID      := cur.OPERATOR_ID;
                         TAR_ATR_L.FILIAL_ID        := cur.FILIAL_ID;
                         TAR_ATR_L.TARIFF_NAME      := cur.TARIFF_NAME;
                         TAR_ATR_L.ATTRIBUTES_NAME  := cur2.NOTE ;
                         TAR_ATR_L.ATTRIBUTES_VALUE := cur2.ATTRIBUTES_VALUE;
                         TAR_ATR_L.ATTRIBUTES_TYPE  := cur2.ATTRIBUTES_TYPE;
                         TAR_ATR_T(i) := TAR_ATR_L;
                       end loop;
              end loop;
      RETURN TAR_ATR_T;
  END;
END;

/