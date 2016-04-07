CREATE OR REPLACE PROCEDURE SEND_SMS_ABOUT_TARIFF_CHANGE (pPhoneNumber in varchar2) IS
/******************************************************************************
   NAME:       SEND_SMS_ABOUT_TARIFF_CHANGE
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/11/2014   �������       1.������ ���������  ��� �������� ��������� � ����� ������

   NOTES:

******************************************************************************/

SMS VARCHAR2(500 CHAR);

BEGIN

  SMS := LOADER3_pckg.SEND_SMS(pPhoneNumber,'SMS-info','�������� ���� ������� �������.', 0, GET_SMS_SENDER_NAME_BY_PHONE (pPhoneNumber));

END SEND_SMS_ABOUT_TARIFF_CHANGE;
/