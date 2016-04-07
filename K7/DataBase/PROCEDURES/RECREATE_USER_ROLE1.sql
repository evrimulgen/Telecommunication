--#if GetVersion("RECREATE_USER_ROLE1") < 8 then
CREATE OR REPLACE PROCEDURE RECREATE_USER_ROLE1(pROLE_NAME VARCHAR2 DEFAULT USER || '_ROLE', 
  pUSER_NAME VARCHAR2 DEFAULT USER) AUTHID CURRENT_USER IS 
--
--#Version=8
--
-- 8. ������. ������� ������������ ���� *_RO � ������� �� ������ � �� ���������� ��������
-- 7. ������. �������� �������, ������������ � 'BIN$'.
--
-- 6. �������.
--      ������ DEFAULT USER ROLE
--
-- 5. ������. 
--      ������� ������ ���� �� ������������������ (SEQUENCE)
--      ������� ���������� �������� �� EXECUTE IMMEDIATE
-- 
-- 4. ������. ���� 'GRANT CREATE SESSION TO' � ���� EXCEPTION
--      ������� ���������� ������ ROLE_EXISTS �� OTHERS
--      ��� ������������ ��� ����������� ���� ������������ ������ 
--      ��� ������������� ����� ����� �� CREATE SESSION WITH ADMIN OPTION � CREATE ROLE
--    ��������� ��������� ������ ����� ������ �� ��� ����� ����� ���� ������ 
--      CREATE SESSION
-- 3. ������. �������� ������, ��-�� ������� ����� �� ����������  
--    �������� ���������� ������ � ������, ���� ��� ����� ����� �� 
--    ���� ������ ������ (�� ����, �� ������������), � �������� 
--    ������ ���� ����������� �����������.
-- 2. ������. ����� ������ �� DBA_* �������, ������� �������� 
--    �� ������ ��������� �� ����� ������������ ������������, 
--    � �� �� ����� ��������� �����. 
--
--  ROLE_EXISTS EXCEPTION;         -- ���������� "���� ��� ����������" 
--  PRAGMA EXCEPTION_INIT(ROLE_EXISTS, -01921); 
--
  pROLE_NAME_RO VARCHAR2(30); 
--
  CURSOR CUR_TABLES(pUSER_NAME VARCHAR2) IS 
    SELECT OBJECT_NAME FROM ALL_OBJECTS WHERE (OBJECT_TYPE = 'TABLE') 
      AND (OWNER = pUSER_NAME)
      AND OBJECT_NAME NOT LIKE 'BIN$%'; 
  CURSOR CUR_PROCEDURES(pUSER_NAME VARCHAR2) IS 
    SELECT OBJECT_NAME FROM ALL_OBJECTS WHERE 
      (OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')) 
      AND (OWNER = pUSER_NAME) AND (OBJECT_NAME <> 'RECREATE_USER_ROLE1') 
/*    MINUS 
    SELECT TABLE_NAME FROM ALL_TAB_PRIVS  
          WHERE (TABLE_SCHEMA = pUSER_NAME)  AND (GRANTEE=pROLE_NAME)*/
          ; 
  CURSOR CUR_VIEWS(pUSER_NAME VARCHAR2) IS 
    SELECT OBJECT_NAME FROM ALL_OBJECTS WHERE (OBJECT_TYPE IN ('VIEW', 'SEQUENCE')) AND (OWNER = pUSER_NAME); 
-- 
BEGIN 
  -- ��������� ������� ���� ������������ � �������: 
  --   ����������, ��������������, �������� � ������� �� ���� ������ ������� ����� 
  --   ������ ���� �������, �������� � ������� 
  --   � ������� �� ���� ������ � �������������������
--
  BEGIN 
    EXECUTE IMMEDIATE 'CREATE ROLE '||pROLE_NAME; 
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO '||pROLE_NAME; 
  EXCEPTION WHEN OTHERS THEN 
    NULL; 
  END; 
  pROLE_NAME_RO := pROLE_NAME || '_RO';
  BEGIN 
    EXECUTE IMMEDIATE 'CREATE ROLE '||pROLE_NAME_RO; 
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO '||pROLE_NAME_RO; 
  EXCEPTION WHEN OTHERS THEN 
    NULL; 
  END; 
-- 
  FOR REC_TABLES IN CUR_TABLES(pUSER_NAME) LOOP 
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||pUSER_NAME||'.'||REC_TABLES.OBJECT_NAME||' TO '||pROLE_NAME;
    EXECUTE IMMEDIATE 'GRANT SELECT                         ON '||pUSER_NAME||'.'||REC_TABLES.OBJECT_NAME||' TO '||pROLE_NAME_RO;
  END LOOP; 
-- 
  FOR REC_PROCEDURES IN CUR_PROCEDURES(pUSER_NAME) LOOP
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON '||pUSER_NAME||'.'||REC_PROCEDURES.OBJECT_NAME||' TO '||pROLE_NAME;
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON '||pUSER_NAME||'.'||REC_PROCEDURES.OBJECT_NAME||' TO '||pROLE_NAME_RO;
  END LOOP; 
-- 
  FOR REC_VIEWS IN CUR_VIEWS(pUSER_NAME) LOOP 
    EXECUTE IMMEDIATE 'GRANT SELECT ON '||pUSER_NAME||'.'||REC_VIEWS.OBJECT_NAME||' TO '||pROLE_NAME;
    EXECUTE IMMEDIATE 'GRANT SELECT ON '||pUSER_NAME||'.'||REC_VIEWS.OBJECT_NAME||' TO '||pROLE_NAME_RO;
  END LOOP;
-- 
END;
/
--#end if
