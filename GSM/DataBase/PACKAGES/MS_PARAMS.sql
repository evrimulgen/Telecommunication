/* Formatted on 19.02.2015 16:17:05 (QP5 v5.252.13127.32867) */
CREATE OR REPLACE PACKAGE MS_PARAMS
AS
   --
   --#Version=3
   --
   -- 19.02.2015 �������.������� ��������� ��������� �������� �� ������� REF_TEXT   
   -- 23.07.13 �������. ���������� ����������� GET_PARAM_VALUE(������ ��� ����� �� ����� DBMS_RESULT_CACHE ��� SYS).
   --
   TYPE num_vars_t IS TABLE OF NUMBER
      INDEX BY VARCHAR2 (64);

   num_vars   num_vars_t;

   --
   FUNCTION get_num_var (p_name VARCHAR2)
      RETURN NUMBER;

   --
   PROCEDURE set_num_var (p_name VARCHAR2, p_value NUMBER);

   --
   -- �������� �������� ���������
   --
   FUNCTION GET_PARAM_VALUE (PARAM_NAME VARCHAR2)
      RETURN VARCHAR2
      RESULT_CACHE;

   --
   -- ���������� �������� ��������� (���������� 0 ���� ����� ��������� ���)
   --
   FUNCTION SET_PARAM_VALUE (PARAM_NAME VARCHAR2, PARAM_VALUE VARCHAR2)
      RETURN INTEGER;

   --
   -- �������� ���������
   --
   PROCEDURE NEW_PARAM (PARAM_NAME     VARCHAR2,
                        PARAM_VALUE    VARCHAR2,
                        PARAM_DESCR    VARCHAR2,
                        PARAM_TYPE     VARCHAR2);
--
--PRAGMA RESTRICT_REFERENCES (GET_PARAM_VALUE, WNDS, WNPS );
--
   --
   -- �������� �������� ��������� �� REF_TEXT
   --

 FUNCTION GET_REF_TEXT_VALUE (pREF_TEXT_NAME VARCHAR2)
      RETURN VARCHAR2 RESULT_CACHE;
      
END;
/
CREATE OR REPLACE PACKAGE BODY MS_PARAMS AS
--
-- 23.10.2012 �. �. �������� ��������� ������� ��� ������ � ������������� ����������� ������

  function get_num_var(
    p_name varchar2
    ) return number is
  begin
      return num_vars(p_name);
  end;
--  
  procedure set_num_var(
    p_name varchar2, 
    p_value number
    ) is
  begin
      num_vars(p_name) := p_value;
  end;
--
  FUNCTION GET_PARAM_VALUE(
    PARAM_NAME VARCHAR2
    ) RETURN VARCHAR2 RESULT_CACHE RELIES_ON(PARAMS) IS
  S VARCHAR2(600);
  BEGIN
    SELECT VALUE INTO S FROM PARAMS WHERE NAME = PARAM_NAME;
      RETURN (S);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN (NULL);
  END;
--
-- ���������� �������� ���������
--
  FUNCTION SET_PARAM_VALUE(
    PARAM_NAME VARCHAR2, 
    PARAM_VALUE VARCHAR2
    ) RETURN INTEGER IS
  BEGIN
    UPDATE PARAMS SET VALUE = PARAM_VALUE WHERE NAME = PARAM_NAME;
      RETURN (TO_CHAR(SQL%ROWCOUNT));
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN (NULL);
  END;
--
-- �������� ���������
--
  PROCEDURE NEW_PARAM(
    PARAM_NAME VARCHAR2, 
    PARAM_VALUE VARCHAR2,
    PARAM_DESCR VARCHAR2, 
    PARAM_TYPE VARCHAR2
    ) IS
  BEGIN
    INSERT INTO PARAMS(PARAM_ID, NAME, DESCR, TYPE, VALUE)
      VALUES(s_new_param_id.nextval, PARAM_NAME, PARAM_DESCR, PARAM_TYPE, PARAM_VALUE);
  END;
  
  --
-- �������� �������� ��������� �� REF_TEXT
--
FUNCTION GET_REF_TEXT_VALUE (pREF_TEXT_NAME VARCHAR2)
  RETURN VARCHAR2  RESULT_CACHE RELIES_ON(REF_TEXT) IS
  S VARCHAR2(100);
begin
  SELECT REF_TEXT_VALUE INTO S FROM REF_TEXT WHERE REF_TEXT_NAME = pREF_TEXT_NAME;
      RETURN (S);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN (NULL);
end;   
-- 07.11.12 �. �. �������� ����������� ���������, ���������� ���� ��� ��� ������ ������ ������
BEGIN 

  Ms_PARAMs.set_num_var('CRIT_SMS_COUNT', GET_PARAM_VALUE('CRIT_SMS_COUNT'));
       
END;

/

CREATE SYNONYM WWW_DEALER.MS_PARAMS FOR MS_PARAMS;
GRANT EXECUTE ON MS_PARAMS TO WWW_DEALER;