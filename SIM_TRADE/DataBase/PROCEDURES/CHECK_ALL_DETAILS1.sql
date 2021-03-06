CREATE OR REPLACE PROCEDURE CHECK_ALL_DETAILS1(
  pYEAR_MONTH IN NUMBER
  ) IS
  INFA CLOB;
  LENG INTEGER;
  BEGINING INTEGER; 
  ENDING INTEGER;
  I INTEGER; 
  LINE VARCHAR2(2000);
  BE INTEGER;
  EN INTEGER;
  TYP VARCHAR2(100);
  LE VARCHAR2(100);
  LEN NUMBER;
  vINFO DBMS_SQL.VARCHAR2_TABLE;
  CURSOR C(pTYPE_CALL IN VARCHAR2) IS
    SELECT TYPE_CALL
    FROM TYPE_CALL_FOR_DILER
    WHERE TYPE_CALL_FOR_DILER.TYPE_CALL=pTYPE_CALL;
  vDUMMY C%ROWTYPE;  
BEGIN
  FOR rec IN (SELECT DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER
                FROM DB_LOADER_ACCOUNT_PHONES
                WHERE DB_LOADER_ACCOUNT_PHONES.YEAR_MONTH=pYEAR_MONTH) 
  LOOP
    GET_DETAIL_FIELD(rec.PHONE_NUMBER,pYEAR_MONTH, 11, vINFO);
    FOR I IN 1..vINFO.COUNT 
    LOOP
      OPEN C(vINFO(I));
      FETCH C INTO vDUMMY;
      IF C%NOTFOUND THEN
        INSERT INTO TYPE_CALL_FOR_DILER(TYPE_CALL)
          VALUES(vINFO(I));
        COMMIT;
      END IF; 
      CLOSE C;
    END LOOP;                
  END LOOP;
END;
/

GRANT EXECUTE ON CHECK_ALL_DETAILS1 TO LONTANA_ROLE;
