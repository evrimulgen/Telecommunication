CREATE OR REPLACE FUNCTION S_GET_DATE_TIME_TEXT(
  pDATE_TIME IN DATE
  ) RETURN VARCHAR2 IS
--#Version=1
  vRESULT VARCHAR2(100 CHAR);
BEGIN
  IF TRUNC(pDATE_TIME) = TRUNC(SYSDATE) THEN
    vRESULT := '�������, ' || TO_CHAR(pDATE_TIME, 'HH24:MI');
  ELSIF TRUNC(pDATE_TIME) = TRUNC(SYSDATE)-1 THEN
    vRESULT := '�����, ' || TO_CHAR(pDATE_TIME, 'HH24:MI');
  ELSE
    vRESULT := TO_CHAR(pDATE_TIME, 'DD.MM.YYYY') || ', '|| TO_CHAR(pDATE_TIME, 'HH24:MI');
  END IF;
  RETURN vRESULT;
END;
/