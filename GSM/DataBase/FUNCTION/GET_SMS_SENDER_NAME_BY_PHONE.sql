CREATE OR REPLACE FUNCTION GET_SMS_SENDER_NAME_BY_PHONE (pPhoneNumber VARCHAR2) RETURN VARCHAR2 IS
/******************************************************************************
   NAME:       GET_SMS_SENDER_NAME_BY_PHONE
   

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        02.12.2015    ��������  ������� exception ��� ����������� ����� ����������� �� �/�.
                                      �.�. ����� ���� ����� ���� ������ �������, ������� ����������� �� �/�
   1.0        24/11/2014   Admin       1. ������� ��������� ����� ��� ���� "�� ����" ��� �������� ���


******************************************************************************/

SENDER_NAME SMS_SENDER_NAME.SMS_SENDER_NAME%TYPE;

BEGIN
  
  begin  
    SELECT 
      (SELECT SMS_SENDER_NAME FROM SMS_SENDER_NAME WHERE  SMS_SENDER_NAME.SMS_SENDER_NAME_ID =  ACCOUNTS.SMS_SENDER_NAME_ID) 
       INTO SENDER_NAME
      FROM ACCOUNTS
    WHERE ACCOUNT_ID = GET_ACCOUNT_ID_BY_PHONE(pPhoneNumber);
  exception
    when others then
      SENDER_NAME := NULL;  
  end;
  
  RETURN nvl(SENDER_NAME, MS_CONSTANTS.GET_CONSTANT_VALUE('SMS_SENDER_NAME'));
     
END GET_SMS_SENDER_NAME_BY_PHONE;