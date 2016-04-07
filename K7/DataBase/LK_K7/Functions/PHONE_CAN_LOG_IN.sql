GRANT EXECUTE ON GET_ACCOUNT_ID_BY_PHONE TO K7_LK;
/

GRANT SELECT ON ACCOUNTS TO K7_LK;
/

CREATE OR REPLACE FUNCTION K7_LK.PHONE_CAN_LOG_IN(pPHONE IN VARCHAR2) RETURN BOOLEAN IS
--
--#Version=5
--
-- ���������� TRUE, ���� ������� ����� ����� � ������ �������.
--
-- 5. ������� 27.11.2015 ������ �7 (�� ��������� � �� "��������") ����� ������������.
-- 4. ������. ������ ��������� � "��������" ����� ������������.
-- 3. ������. ��� ����� ����������.
--
CURSOR C IS
  SELECT 1
  FROM CORP_MOBILE.ACCOUNTS
  WHERE ACCOUNTS.ACCOUNT_ID = CORP_MOBILE.GET_ACCOUNT_ID_BY_PHONE(pPHONE)
  AND (ACCOUNTS.ACCOUNT_ID NOT IN (49, 72, 73, 93, 99)); -- �� �������� � �� �������
--
vDUMMY NUMBER := 0;
--
BEGIN
  IF pPHONE = '9689681650' THEN
    RETURN TRUE; -- �������� �����
  END IF;
  OPEN C;
  FETCH C INTO vDUMMY;
  CLOSE C;
  RETURN (vDUMMY=1);
END;
/
