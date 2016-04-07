/* Formatted on 12/11/2014 11:24:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FUNCTION GET_USSD_PHONE_INFO (pMSISDN IN VARCHAR2)
   RETURN VARCHAR2
IS
--
--#Version=2
--
--v2 12.11.2014 - ������� - ������� �������� ��� ��� ����������
--
   pragma autonomous_transaction;
   vITOG   VARCHAR2 (300 CHAR);

   CURSOR C
   IS
      SELECT AC.IS_COLLECTOR
        FROM DB_LOADER_ACCOUNT_PHONES D, ACCOUNTS AC
       WHERE     D.YEAR_MONTH = TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMM'))
             AND D.ACCOUNT_ID = AC.ACCOUNT_ID
             AND D.PHONE_NUMBER = pMSISDN;

   DUMMY   C%ROWTYPE;
   vSTR    VARCHAR2 (500 CHAR);
BEGIN
   OPEN C;

   FETCH C INTO DUMMY;

   IF C%FOUND
   THEN
      vITOG := '��� ����� +7' || pMSISDN || '.';
      IF NVL (DUMMY.IS_COLLECTOR, 0) = 1
      THEN                                                   -- ���� ���������
         vSTR := loader3_pckg.send_sms (pMSISDN, 'AgSv', vITOG||' Teletie.ru');
         vITOG := vITOG ||' �������� ��� ���������.';
      END IF;
   ELSE
      vITOG := '������ ����� �� �������� �� �/�.';
   END IF;

   CLOSE C;

   RETURN vITOG;
END;
/
