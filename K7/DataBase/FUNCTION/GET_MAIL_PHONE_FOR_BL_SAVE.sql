CREATE OR REPLACE FUNCTION GET_MAIL_PHONE_FOR_BL_SAVE RETURN CLOB IS
--Version=1
RESULT_CLOB CLOB;
LINE CLOB;
BEGIN
--  DBMS_LOB.CREATETEMPORARY(RESULT_CLOB, TRUE);
  RESULT_CLOB:='"�������"' || CHR(9) || '"���� ����������"' || CHR(9) || '"������"' || CHR(9) || '"���"';  
  FOR rec IN(
    SELECT *
      FROM V_PHONE_NUMBER_FOR_BLOCK_SAVE
      ORDER BY BEGIN_DATE ASC
  ) LOOP
    LINE:=CHR(10) || rec.PHONE_NUMBER || CHR(9) || rec.BEGIN_DATE || CHR(9) || rec.BALANCE || CHR(9) || rec.FIO;
    DBMS_LOB.APPEND(RESULT_CLOB, LINE);      
  END LOOP;       
  RETURN RESULT_CLOB;
  DBMS_LOB.FREETEMPORARY(RESULT_CLOB); 
END;
/