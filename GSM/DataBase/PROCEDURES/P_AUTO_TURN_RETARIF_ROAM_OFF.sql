--#if GetVersion("P_AUTO_TURN_RETARIF_ROAM_OFF") < 3
CREATE OR REPLACE PROCEDURE P_AUTO_TURN_RETARIF_ROAM_OFF IS
--#Version=3
--
-- ��������� ��������� � ��������� ������ �� ������� ��� ���������, � ������� ���������� �������.
-- �������� ��� �������������� ���������������.
--
-- 3. ������. 31.07.2014. �������� ���������� ���������� ������� (������ ORA-01002)
--
-- ������ ��������� �������� (� �����)
-- ������ ���� ������, ��� ������ �������� �� ����������� � P_AUTO_TURN_RETARIF_ROAMING !!!
C_ROAMING_TIMEOUT CONSTANT NUMBER := 24;
-- ����� �������� ��������� �� � ����� �������� �� ����� ����� (� ����� �����)
cNOT_CHECK_HRS_BEFOR_NEW_MONTH CONSTANT NUMBER := 10/60/24; -- 10 ����� ��
cNOT_CHECK_HRS_AFTER_NEW_MONTH CONSTANT NUMBER := 10/60/24;     -- 10 ����� �����
--
CURSOR C_PHONES IS
  -- ������ � ����������������, � ������� �� ���� �������� �� ������ ���������. 
  SELECT
    ROAMING_RETARIF_PHONES.ID,
    ROAMING_RETARIF_PHONES.PHONE_NUMBER,
    ROAMING_RETARIF_PHONES.OPTION_CODE
  FROM
    LAST_ROAMING_TIMESTAMPS,
    ROAMING_RETARIF_PHONES
  WHERE
    ROAMING_RETARIF_PHONES.PHONE_NUMBER=LAST_ROAMING_TIMESTAMPS.PHONE_NUMBER
    AND ((LAST_ROAMING_TIMESTAMPS.LAST_SERVICE_DATE_TIME < SYSDATE-C_ROAMING_TIMEOUT/24 -- ��������� ������� ��� ������ ������� ��������
            AND TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) >= 22) -- �� 22:00 �� ��������� (��� ������, ������ ��� ���������)
        -- ���� ������ > 26 �����, �� ��������� � ����� ������ (�� ��������� ��������� ����������)
        OR LAST_ROAMING_TIMESTAMPS.LAST_SERVICE_DATE_TIME < SYSDATE-(C_ROAMING_TIMEOUT+2)/24) 
    AND ROAMING_RETARIF_PHONES.END_DATE_TIME IS NULL /* � ������ � ������� ��������������� ������� */
    ;
--
vRESULT VARCHAR2(2000);
vTICKET_ID VARCHAR2(20);
--
BEGIN
  -- ������ �� ��������� ��������� ����� �� � ����� �������� �� ����� ����� (��� ����� ���� �� ��������� ������� � ������ ��������).
  IF TO_CHAR(SYSDATE, 'MM') <> TO_CHAR(SYSDATE+cNOT_CHECK_HRS_BEFOR_NEW_MONTH, 'MM') -- ����� ��������
    OR TO_CHAR(SYSDATE, 'MM') <> TO_CHAR(SYSDATE-cNOT_CHECK_HRS_AFTER_NEW_MONTH, 'MM') THEN -- �� 22 ����� ���� �� ��������� (��� ������ ���������)
    -- �� ������� ����� ������ ������ �� ������.
    NULL;
    debug_out('�������� - ���� ��������');
  ELSE
    --
    -- �������� �����
    --
    -- ���������� ��� ������
    FOR vREC IN C_PHONES LOOP
      debug_out(vREC.PHONE_NUMBER || ': disable ' || vREC.OPTION_CODE);
      -- ��������� ���������������
      vRESULT := BEELINE_API_PCKG.TURN_TARIFF_OPTION(vREC.PHONE_NUMBER, vREC.OPTION_CODE, 0, NULL, NULL, 'RETARIF');
      IF vRESULT LIKE '������ �%' THEN
        -- ����������� ���� ��������� ���������������
        vTICKET_ID := regexp_replace(vRESULT, '������ � *(\d+)', '\1');
        UPDATE ROAMING_RETARIF_PHONES
        SET 
          END_DATE_TIME=SYSDATE,
          SERVICE_OFF_TICKET_ID = vTICKET_ID,
          SERVICE_OFF_ERROR_MESSAGE = NULL
        WHERE
          ROAMING_RETARIF_PHONES.ID = vREC.ID;
      ELSE
        UPDATE ROAMING_RETARIF_PHONES
        SET 
          SERVICE_OFF_ERROR_MESSAGE = vRESULT
        WHERE
          ROAMING_RETARIF_PHONES.ID = vREC.ID;
      END IF;
      COMMIT;
    END LOOP;
  END IF;
END;
/
--#end if
