CREATE OR REPLACE FUNCTION CALC_BALANCE_ROWS_TABLE_BY_DAY(
  pPHONE_NUMBER IN VARCHAR2
  ) RETURN BALANCE_ROW_TAB PIPELINED AS
--#Version=3
--
--v.3 16.12.2015 ������� ��������� ������������ 
--                      �� ����, �� ����� ������ �� ������ ����.(������ http://redmine.tarifer.ru/issues/3377)
--
-- ���������� ����������� ������� �� CALC_BALANCE_ROWS2, �� ��������� ������������ 
-- �� ����, �� ����� ������ �� ������ ����.
--
  vDATE_ROWS DBMS_SQL.DATE_TABLE;
  vCOST_ROWS DBMS_SQL.NUMBER_TABLE;
  vDESCRIPTION_ROWS DBMS_SQL.VARCHAR2_TABLE;
  TYPE CALL_CURSOR_TYPE  IS REF CURSOR;
  vCALL_CURSOR CALL_CURSOR_TYPE;
  I BINARY_INTEGER;
  cABONPAYMENT_PATTERN CONSTANT VARCHAR2(100 CHAR) := '(.* ���������.*) [c�] (\d\d\.\d\d\.\d\d\d\d) �� (\d\d\.\d\d\.\d\d\d\d)(.*)';
  cDETAIL_PATTERN CONSTANT VARCHAR2(100) := '����������� ������� �� (\d\d)\.(\d\d\d\d).*';
  cINSTALLMENT_PATTERN CONSTANT VARCHAR2(100 CHAR) := '(���������.*) � (\d\d\.\d\d\.\d\d\d\d) �� (\d\d\.\d\d\.\d\d\d\d)(.*)';
  vDESCRIPTION VARCHAR2(4000);
  vDESCRIPTION1 VARCHAR2(4000);
  vDESCRIPTION2 VARCHAR2(4000);
  BEGIN_DATE DATE;
  vDATE DATE;
  END_DATE DATE;
  vCOST NUMBER;
  vTABLE_NAME VARCHAR2(100 CHAR);
  vSQL VARCHAR2(500 CHAR);
BEGIN
  CALC_BALANCE_ROWS2(pPHONE_NUMBER, vDATE_ROWS, vCOST_ROWS, vDESCRIPTION_ROWS);
  -- 
  I := vDATE_ROWS.FIRST;
  WHILE I IS NOT NULL LOOP
    vDESCRIPTION := vDESCRIPTION_ROWS(I);
    IF REGEXP_LIKE(vDESCRIPTION, cABONPAYMENT_PATTERN) THEN
      BEGIN_DATE := TO_DATE(REGEXP_REPLACE(vDESCRIPTION, cABONPAYMENT_PATTERN, '\2'), 'DD.MM.YYYY');
      END_DATE := TO_DATE(REGEXP_REPLACE(vDESCRIPTION, cABONPAYMENT_PATTERN, '\3'), 'DD.MM.YYYY');
      vDESCRIPTION1 := REGEXP_REPLACE(vDESCRIPTION, cABONPAYMENT_PATTERN, '\1');
      vDESCRIPTION2 := REGEXP_REPLACE(vDESCRIPTION, cABONPAYMENT_PATTERN, '\4');
      vCOST := vCOST_ROWS(I) / (END_DATE-BEGIN_DATE+1);
      -- ���������� ��� ���
      vDATE := BEGIN_DATE;
      WHILE vDATE <= END_DATE LOOP
        PIPE ROW(
          BALANCE_ROW_TYPE(
            vDATE,
            vCOST,
            vDESCRIPTION1 || ' �� ' || TO_CHAR(vDATE, 'DD.MM.YYYY') || vDESCRIPTION2
            )
          );
        vDATE := vDATE + 1;
      END LOOP;
    ELSIF REGEXP_LIKE(vDESCRIPTION, cDETAIL_PATTERN) THEN
      -- ������ ������� �� ������ ������� �� ������ �������� 
      vTABLE_NAME := REGEXP_REPLACE(vDESCRIPTION, cDETAIL_PATTERN, 'CALL_\1_\2');
      vSQL := 'SELECT
                 INSERT_DATE,
                 SUM(CALL_COST)
               FROM
                 '||vTABLE_NAME||'
              WHERE
                SUBSCR_NO=:PHONE_NUMBER
              GROUP BY INSERT_DATE
              HAVING SUM(CALL_COST) <> 0';
      OPEN vCALL_CURSOR FOR vSQL USING pPHONE_NUMBER;
      LOOP
        FETCH vCALL_CURSOR INTO vDATE, vCOST;
        EXIT WHEN vCALL_CURSOR%NOTFOUND;
        PIPE ROW(
          BALANCE_ROW_TYPE(
            vDATE,
            -vCOST,
            '��������� �����������' 
            )
          );
      END LOOP;
      CLOSE vCALL_CURSOR;
    ELSIF REGEXP_LIKE(vDESCRIPTION, cINSTALLMENT_PATTERN) THEN      
      BEGIN_DATE := TO_DATE(REGEXP_REPLACE(vDESCRIPTION, cINSTALLMENT_PATTERN, '\2'), 'DD.MM.YYYY');
      END_DATE := TO_DATE(REGEXP_REPLACE(vDESCRIPTION, cINSTALLMENT_PATTERN, '\3'), 'DD.MM.YYYY');
      vDESCRIPTION1 := REGEXP_REPLACE(vDESCRIPTION, cINSTALLMENT_PATTERN, '\1');
      vDESCRIPTION2 := REGEXP_REPLACE(vDESCRIPTION, cINSTALLMENT_PATTERN, '\4');
      vCOST := vCOST_ROWS(I) / (END_DATE-BEGIN_DATE+1);
      -- ���������� ��� ���
      vDATE := BEGIN_DATE;
      WHILE vDATE <= END_DATE LOOP
        PIPE ROW(
          BALANCE_ROW_TYPE(
            vDATE,
            vCOST,
            vDESCRIPTION1 || ' �� ' || TO_CHAR(vDATE, 'DD.MM.YYYY') || vDESCRIPTION2
            )
          );
        vDATE := vDATE + 1;
      END LOOP;    
    ELSE
      PIPE ROW(
        BALANCE_ROW_TYPE(
          vDATE_ROWS(I),
          vCOST_ROWS(I),
          vDESCRIPTION_ROWS(I)
          )
        );
    END IF;
    I := vDATE_ROWS.NEXT(I);
  END LOOP;
END;
/

/*

SELECT * FROM TABLE(CALC_BALANCE_ROWS_TABLE_BY_DA2(:PHONE_NUMBER))
where description like '%�����������%'
ORDER BY ROW_DATE DESC;

SELECT INSERT_DATE, SUM(CALL_COST) FROM CALL_01_2015
WHERE SUBSCR_NO=:phone_number
GROUP BY INSERT_DATE
HAVING SUM(CALL_COST) <> 0
;


DECLARE
  cDETAIL_PATTERN CONSTANT VARCHAR2(100) := '����������� ������� �� (01)\.(2015).*';
  vDESCRIPTION VARCHAR2(4000);
BEGIN
  vDESCRIPTION := '����������� ������� �� 01.2015 (�� 06.01.2015 21:47)';
  IF REGEXP_LIKE(vDESCRIPTION, cDETAIL_PATTERN) THEN
    DBMS_OUTPUT.PUT_LINE(REGEXP_REPLACE(vDESCRIPTION, cDETAIL_PATTERN, '\1_\2'));
  ELSE
    DBMS_OUTPUT.PUT_LINE('NOT LIKE');
  END IF;
END;


DECLARE
  S VARCHAR2(1000);
  cABONPAYMENT_PATTERN VARCHAR2(1000);
  BEGIN_DATE DATE;
  END_DATE DATE;
BEGIN
  cABONPAYMENT_PATTERN := '(.* ���������.*) [c�] (\d\d\.\d\d\.\d\d\d\d) �� (\d\d\.\d\d\.\d\d\d\d)(.*)';
  S := '2 ��������� �� ������ ������� ������� (RLT_BC) � 01.01.2015 �� 04.01.2015';
  IF REGEXP_LIKE(S, cABONPAYMENT_PATTERN) THEN
    dbms_output.put_line(REGEXP_REPLACE(S, cABONPAYMENT_PATTERN, '\1'));
    dbms_output.put_line(REGEXP_REPLACE(S, cABONPAYMENT_PATTERN, '\2'));
    dbms_output.put_line(REGEXP_REPLACE(S, cABONPAYMENT_PATTERN, '\3'));
    dbms_output.put_line(REGEXP_REPLACE(S, cABONPAYMENT_PATTERN, '\4'));
    BEGIN_DATE := TO_DATE(REGEXP_REPLACE(S, cABONPAYMENT_PATTERN, '\2'), 'DD.MM.YYYY');
    END_DATE := TO_DATE(REGEXP_REPLACE(S, cABONPAYMENT_PATTERN, '\3'), 'DD.MM.YYYY');
    dbms_output.put_line('Day count: '||(end_date-begin_date+1));
  else
    dbms_output.put_line('not like');
  end if;
END;

*/