CREATE OR REPLACE FUNCTION ADD_PROMISED_PAYMENT (pPHONE_NUMBER   IN VARCHAR2,
                                                 pPAYMENT_SUM    IN NUMBER,
                                                 pPAYMENT_DATE   IN DATE)
   RETURN VARCHAR2
IS
   --Version = 6
   --v.6 14.10.2015 �������. ������� �������� ��������� � �������������� ���������� �������
   --v.5 17.03.2015 �������. �������  PRAGMA AUTONOMOUS_TRANSACTION;   
   --25.11.2014 ��������. ������� PROMISED_PAYMENTS �������� �� views V_ACTIVE_PROMISED_PAYMENTS
   PRAGMA AUTONOMOUS_TRANSACTION;
   CURSOR C (aPHONE_NUMBER VARCHAR2)
   IS
      SELECT PP.*
        FROM V_ACTIVE_PROMISED_PAYMENTS PP
       WHERE PP.PHONE_NUMBER = aPHONE_NUMBER AND PP.PAYMENT_DATE <= SYSDATE;

   ITOG    VARCHAR2 (300 CHAR);
   REC_C   C%ROWTYPE;
   vSMS_TEXT varchar2(500 char);
BEGIN
   ITOG := '';
   vSMS_TEXT := '';

   OPEN C (pPHONE_NUMBER);

   FETCH C INTO REC_C;

   IF C%NOTFOUND
   THEN
      INSERT INTO PROMISED_PAYMENTS (PHONE_NUMBER,
                                     PAYMENT_DATE,
                                     PROMISED_DATE,
                                     PROMISED_SUM,
                                     PROMISED_DATE_END)
           VALUES (pPHONE_NUMBER,
                   SYSDATE,
                   pPAYMENT_DATE,
                   pPAYMENT_SUM,
                   pPAYMENT_DATE);

      COMMIT;
      ITOG :=
            '�������� ��������� ������ '
         || TO_CHAR (pPAYMENT_SUM)
         || '� �� '
         || TO_CHAR (pPAYMENT_DATE, 'DD.MM.YYYY HH24:MI:SS')
         || ' �� ����� '
         || pPHONE_NUMBER
         || '.';
         
      
      vSMS_TEXT := '��� ������������ ��������� ������ �� ����� '||TO_CHAR (pPAYMENT_SUM)||'�, ���� �������� �� '|| TO_CHAR (pPAYMENT_DATE, 'DD.MM.YYYY');
      SEND_SMS_PROMISED_PAYMENT (pPHONE_NUMBER, vSMS_TEXT);
      
   ELSE
      ITOG :=
            '��� ������ '
         || pPHONE_NUMBER
         || ' ��� ���������� ��������� ������.';
   END IF;

   CLOSE C;

   RETURN ITOG;
END;
/

GRANT EXECUTE ON  ADD_PROMISED_PAYMENT TO CORP_MOBILE_ROLE;
GRANT EXECUTE ON  ADD_PROMISED_PAYMENT TO CORP_MOBILE_ROLE_RO;
CREATE SYNONYM CRM_USER.ADD_PROMISED_PAYMENT FOR ADD_PROMISED_PAYMENT;
GRANT EXECUTE ON  ADD_PROMISED_PAYMENT TO CRM_USER;
