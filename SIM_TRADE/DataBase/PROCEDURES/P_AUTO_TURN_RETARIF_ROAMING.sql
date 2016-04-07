--#if GetVersion("P_AUTO_TURN_RETARIF_ROAMING") < 4
CREATE OR REPLACE PROCEDURE P_AUTO_TURN_RETARIF_ROAMING IS
--#Version=4
--
-- ��������� ��������� � ��� ������������� ���������� ������ �� ������� ��� ���������.
-- �������� ��� �������������� ���������������.
--
-- 4. ������. �������� ����� ��������������� ��������.
--
-- ������ �������� �������� (� �����)
-- ������ ���� ������, ��� ������ �������� �� ���������� � P_AUTO_TURN_RETARIF_ROAM_OFF !!!
C_ROAMING_PERIOD CONSTANT NUMBER := 12; 
-- ����� �������� ��������� �� � ����� �������� �� ����� ����� (� ����� �����)
cNOT_CHECK_HRS_BEFOR_NEW_MONTH CONSTANT NUMBER := 10/60/24; -- 10 ����� ��
cNOT_CHECK_HRS_AFTER_NEW_MONTH CONSTANT NUMBER := 1/24;     -- 1 ��� �����
--
CURSOR C_PHONES IS
  -- ������, � ������� ��� ������� �� ��������� �����, 
  -- � ��������������� �������� � ���������� �������� �����.
  SELECT
    LAST_ROAMING_TIMESTAMPS.PHONE_NUMBER,
    ACCOUNTS.DO_ROAMING_RETARIFICATION
  FROM
    LAST_ROAMING_TIMESTAMPS,
    ACCOUNTS
  WHERE
    LAST_ROAMING_TIMESTAMPS.LAST_FULLCOST_CALL_DATE_TIME > SYSDATE-C_ROAMING_PERIOD/24 -- ��� ����������� ������ �� ������ ��������
    AND ACCOUNTS.ACCOUNT_ID=GET_ACCOUNT_ID_BY_PHONE(LAST_ROAMING_TIMESTAMPS.PHONE_NUMBER) -- ������� ����
    AND NVL(ACCOUNTS.DO_ROAMING_RETARIFICATION, 0) <> 0 -- � ������� ���� ��������� ���������������
    AND NOT EXISTS( /* � ��� �������� ������� � ������� ��������������� */
      SELECT 1 FROM ROAMING_RETARIF_PHONES
      WHERE ROAMING_RETARIF_PHONES.PHONE_NUMBER=LAST_ROAMING_TIMESTAMPS.PHONE_NUMBER
      AND ROAMING_RETARIF_PHONES.END_DATE_TIME IS NULL
    )
    --AND LAST_ROAMING_TIMESTAMPS.PHONE_NUMBER='9689681650' -- �������� ��� �������
    ;
BEGIN
  -- ������ �� ��������� ��������� ����� �� � ����� �������� �� ����� ����� (��� ����� ���� �� ��������� ������� � ������ ��������).
  IF TO_CHAR(SYSDATE, 'MM') <> TO_CHAR(SYSDATE+cNOT_CHECK_HRS_BEFOR_NEW_MONTH, 'MM') -- ����� ��������
    OR TO_CHAR(SYSDATE, 'MM') <> TO_CHAR(SYSDATE-cNOT_CHECK_HRS_AFTER_NEW_MONTH, 'MM') THEN
    -- �� ������� ����� ������ ������ �� ������.
    NULL;
  ELSE
    --
    -- �������� �����
    --
    -- ���������� ��� ������
    FOR vREC IN C_PHONES LOOP
      -- ��������� � ���������� ���������������
      P_CHECK_ROAMING_RETARIF_PHONE(vREC.PHONE_NUMBER, vREC.DO_ROAMING_RETARIFICATION);
    END LOOP;
  END IF;
END;
/
--#end if
