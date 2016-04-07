CREATE OR REPLACE PROCEDURE CHECK_CREATE_USER(
  p_USER_NAME VARCHAR2, 
  p_PASSWORD VARCHAR2, 
  p_EXCEPT_USER_NAME_ID NUMBER,
  p_USER_RIGHT IN INTEGER DEFAULT NULL /* 1-�������������, 2-��������, 3-������ ���. �� ��������, ����� ������������ */
  --p_ROLE_NAME VARCHAR2
) IS
--
--#Version=5
--
-- 5 ��������. ��������� ������� ������� � ������� �������� � ��������� ������������
-- 4 ��������. ������� �������� �� ��� ���� 3 - ������ ���. �� ��������

  vINT INTEGER;
  vSCHEMA_NAME ALL_USERS.USERNAME%TYPE;
  vROLE_NAME VARCHAR2(30);
  vREVOKE_ROLE_NAME VARCHAR2(30);
  ROLE_NOT_GRANTED_ERROR EXCEPTION;
  PRAGMA EXCEPTION_INIT(ROLE_NOT_GRANTED_ERROR, -01951);
begin
  IF TRIM(p_USER_NAME) IS NULL THEN
    RAISE_APPLICATION_ERROR(-20001, '��� ������������ Oracle ������ ���� ���������.');
  END IF;
--
  SELECT USERNAME 
    INTO vSCHEMA_NAME 
    FROM ALL_USERS
    WHERE USER_ID = USERENV('SCHEMAID');
  vROLE_NAME := vSCHEMA_NAME || '_ROLE';
  IF (p_USER_RIGHT = 2) OR (p_USER_RIGHT = 3) THEN -- �������� ��� ������ ���. �� ��������
    vREVOKE_ROLE_NAME := vROLE_NAME;
    vROLE_NAME := vROLE_NAME || '_RO';
  ELSE
    vREVOKE_ROLE_NAME := vROLE_NAME || '_RO';
  END IF;
--
  SELECT COUNT(*)
  INTO vINT
  FROM USER_NAMES UN
  WHERE UN.USER_NAME = UPPER(TRIM(p_USER_NAME))
    AND UN.USER_NAME_ID <> NVL(p_EXCEPT_USER_NAME_ID, -1);
  IF vINT > 0 THEN
    RAISE_APPLICATION_ERROR(-20002, '������������ � ������ '||UPPER(TRIM(p_USER_NAME))||' ��� ���������������. �������� ��� ������������.');
  END IF;
--
  SELECT COUNT(*)
  INTO vINT 
  FROM ALL_USERS AU
  WHERE AU.USERNAME = UPPER(TRIM(p_USER_NAME));
  IF vINT = 0 THEN
    IF TRIM(p_PASSWORD) IS NOT NULL THEN
      EXECUTE IMMEDIATE 'CREATE USER '||UPPER(TRIM(p_USER_NAME))|| ' IDENTIFIED BY "'||TRIM(p_PASSWORD)||'"';
    ELSE
      RAISE_APPLICATION_ERROR(-20002, '������ ������ ���� ���������.');
    END IF;
  ELSE
    -- ����� ���� ��������� ���������� ������������ ��� ��������� ������
    IF TRIM(p_PASSWORD) IS NOT NULL THEN
      EXECUTE IMMEDIATE 'ALTER USER '||UPPER(TRIM(p_USER_NAME))|| ' IDENTIFIED BY "'||TRIM(p_PASSWORD)||'"';
    END IF;
  END IF;
  EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO '||UPPER(TRIM(p_USER_NAME));
  -- (�������� �� ���� ���� USER_ROLE)??
  EXECUTE IMMEDIATE 'GRANT '|| vROLE_NAME ||' TO '||UPPER(TRIM(p_USER_NAME));
  -- ������� ������������ ����
  BEGIN
    EXECUTE IMMEDIATE 'REVOKE '|| vREVOKE_ROLE_NAME ||' FROM ' ||UPPER(TRIM(p_USER_NAME));
  EXCEPTION  WHEN ROLE_NOT_GRANTED_ERROR THEN 
    NULL;
  END;
END;
/
