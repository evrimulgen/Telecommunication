
  CREATE OR REPLACE PROCEDURE "SIM_TRADE"."ALTER_USER_ENCRYPT_PWD" (
  p_USER_NAME VARCHAR2, 
  p_PASSWORD VARCHAR2
) IS
BEGIN
  EXECUTE IMMEDIATE 'ALTER USER '||p_USER_NAME||' IDENTIFIED BY "'||p_PASSWORD||'"';
  UPDATE user_names SET encrypt_pwd = 1 WHERE UPPER(user_name) = UPPER(p_USER_NAME);
  COMMIT;
END;