CREATE OR REPLACE PROCEDURE SEND_MAIL_PHONE_FOR_BL_SAVE IS
--Version=1
TEXT CLOB;
BEGIN
  TEXT:=GET_MAIL_PHONE_FOR_BL_SAVE;
  FOR rec IN(
    SELECT REPORT_MAIL_RECIPIENTS.MAIL_ADRESS,
           REPORT_TYPES.REPORT_NAME
      FROM REPORT_MAIL_RECIPIENTS, REPORT_TYPES
      WHERE REPORT_MAIL_RECIPIENTS.TYPE_REPORT='PHONE_FOR_BLOCK_SAVE'
         AND REPORT_MAIL_RECIPIENTS.TYPE_REPORT=REPORT_TYPES.TYPE_REPORT 
  ) LOOP    
    IF TEXT IS NULL THEN
      SEND_MAIL(rec.MAIL_ADRESS,rec.REPORT_NAME || ' �� ' || TO_CHAR(SYSDATE, 'DD.MM.YYYY'), '��������� ��� ���������� �� ���������� ���');
    ELSE
      SEND_MAIL(rec.MAIL_ADRESS,rec.REPORT_NAME || ' �� ' || TO_CHAR(SYSDATE, 'DD.MM.YYYY'), TEXT);
    END IF;
  END LOOP;    
END;
/