--#if GetVersion("HOT_BILLING_UPDATE_LAST_ROAMNG") < 5
CREATE OR REPLACE PROCEDURE HOT_BILLING_UPDATE_LAST_ROAMNG(
  CALL_ROW IN CALL_TYPE,
  RECALC_CALL_ROW IN CALL_TYPE -- ������������� ���������
  ) IS
--#Version=5
-- ��������� ��������� ����/����� ���������� ��������, ���� �� ��� ��� ������
--
-- 5. �������. 14.11.14. �������� ������� ��� ���� LAST_FULLCOST_CALL_DATE_TIME
-- 4. ������. 09.09.14. ������ �������� �������� ������ �� �������� ������� 
--    (�� ��������� ������� �������� �� �������������� - �� ����������).
-- 3. ������. 30.07.14. ������ ���������� ���� LAST_FULLCOST_CALL_DATE_TIME.
-- 2. ������. 27.07.14. ������ �������� �� ��������� ������ �� 1 ������.
--
  PRAGMA AUTONOMOUS_TRANSACTION;
  --
  CURSOR C_LAST_ROAMING(pPHONE_NUMBER VARCHAR2) IS
    SELECT 
      LAST_SERVICE_DATE_TIME,
      LAST_FULLCOST_CALL_DATE_TIME
    FROM 
      LAST_ROAMING_TIMESTAMPS
    WHERE 
      PHONE_NUMBER=pPHONE_NUMBER;
  --  
  vLAST_SERVICE_DATE_TIME DATE;
  vLAST_FULLCOST_CALL_DATE_TIME DATE;
  cROAMING_COST_PER_MINUTE CONSTANT NUMBER := 9.94;
BEGIN
  -- ���� ������ � ��������
  IF CALL_ROW.AT_FT_DE LIKE '(���)%' THEN
    OPEN C_LAST_ROAMING(CALL_ROW.SUBSCR_NO);
    FETCH C_LAST_ROAMING INTO vLAST_SERVICE_DATE_TIME, vLAST_FULLCOST_CALL_DATE_TIME;
    IF C_LAST_ROAMING%NOTFOUND THEN
      -- �� ����� - ��������� ����� ������
      -- ���� ����� ����� ��������, �� ����� ��������� LAST_FULLCOST_CALL_DATE_TIME
      IF RECALC_CALL_ROW.CALL_COST > 0
          AND RECALC_CALL_ROW.DUR > 0
          AND ((RECALC_CALL_ROW.CALL_COST / TRUNC((RECALC_CALL_ROW.DUR + 59)/60)) 
            BETWEEN cROAMING_COST_PER_MINUTE AND cROAMING_COST_PER_MINUTE+0.0099 ) THEN
        INSERT INTO LAST_ROAMING_TIMESTAMPS (
          PHONE_NUMBER, 
          LAST_SERVICE_DATE_TIME,
          LAST_FULLCOST_CALL_DATE_TIME
        ) VALUES (
          CALL_ROW.SUBSCR_NO,
          CALL_ROW.START_TIME,
          CALL_ROW.START_TIME
        );
      ELSE
        INSERT INTO LAST_ROAMING_TIMESTAMPS (
          PHONE_NUMBER, 
          LAST_SERVICE_DATE_TIME
        ) VALUES (
          CALL_ROW.SUBSCR_NO,
          CALL_ROW.START_TIME
        );
      END IF;
      COMMIT;
    ELSE
      -- �����.
      -- ���������, ���� ����� ���� ������ ������������ �� 1 ��� ��� �����, 
      -- ����� �� ��������� ������� �� �����.
      IF CALL_ROW.START_TIME > vLAST_SERVICE_DATE_TIME + 1/24 THEN
        UPDATE LAST_ROAMING_TIMESTAMPS 
          SET LAST_SERVICE_DATE_TIME = CALL_ROW.START_TIME
          WHERE LAST_ROAMING_TIMESTAMPS.PHONE_NUMBER = CALL_ROW.SUBSCR_NO;
        COMMIT;
      END IF;
    END IF;
    IF -- ������ �������� (�� ��������� ������� �������� �� ��������������)
      (RECALC_CALL_ROW.SERVICEDIRECTION = 2
      -- ���� ��������� ������ ����� ��������� 9,94 ���. �� 1 ������
      AND RECALC_CALL_ROW.CALL_COST > 0
      AND RECALC_CALL_ROW.DUR > 0
      AND (RECALC_CALL_ROW.CALL_COST / TRUNC((RECALC_CALL_ROW.DUR + 59)/60)) 
        BETWEEN cROAMING_COST_PER_MINUTE AND cROAMING_COST_PER_MINUTE+0.0099)
       or (RECALC_CALL_ROW.SERVICEDIRECTION = 1
            and RECALC_CALL_ROW.AT_FT_DE LIKE '(���)%'
            and RECALC_CALL_ROW.CALL_COST > 0
            AND RECALC_CALL_ROW.DUR > 0
            AND (RECALC_CALL_ROW.CALL_COST / TRUNC((RECALC_CALL_ROW.DUR + 59)/60)) 
              BETWEEN cROAMING_COST_PER_MINUTE AND cROAMING_COST_PER_MINUTE+0.0099 )  
      THEN
      --
      -- ���������, ���� ����� ���� ������ ������������ �� 1 ��� ��� �����, 
      -- ����� �� ��������� ������� �� �����.
      IF (CALL_ROW.START_TIME > vLAST_FULLCOST_CALL_DATE_TIME + 1/24) 
          or (vLAST_FULLCOST_CALL_DATE_TIME is null) THEN
        UPDATE LAST_ROAMING_TIMESTAMPS 
          SET LAST_FULLCOST_CALL_DATE_TIME = CALL_ROW.START_TIME
          WHERE LAST_ROAMING_TIMESTAMPS.PHONE_NUMBER = CALL_ROW.SUBSCR_NO;
        COMMIT;
      END IF;
    END IF;
  END IF;
END;
/
--#end if
