CREATE OR REPLACE PROCEDURE SMS_ADD_REQUEST(pprovider_id in integer,
                                            pphone       in varchar2,
                                            pmessage     in varchar2,
                                            pdate_start   in date DEFAULT sysdate,
                                            pSMS_SenderName in varchar2 DEFAULT NULL
                                            ) is
                                            
--Version=3
--
--v.3 ������� 25.11.2014 - ������ ��������
--v.2 ������� 24.11.2014 - ������� �������� ������ ���� �� ����������� �����, ���� �� ����� �� ���������
--
  SENDER_NAME SMS_SENDER_NAME.SMS_SENDER_NAME%TYPE;
BEGIN
   
-- ���� SENDER_NAME �����, �� ���������� ���, ������� ��������� � �����   
   SENDER_NAME := nvl(trim(pSMS_SenderName) , GET_SMS_SENDER_NAME_BY_PHONE(pphone));

-- ���� SENDER_NAME �����, �� ���������� ���, ������� ������ ��-���������   
   SENDER_NAME := nvl(SENDER_NAME, MS_CONSTANTS.GET_CONSTANT_VALUE('SMS_SENDER_NAME') );

  insert into sms_current
    (
    
      PROVIDER_ID,
      PHONE,
      MESSAGE,
      RESULT_STR,
      STATUS_CODE,
      DESCRIPTION_STR,
      SMS_ID,
      INSERT_DATE,
      UPDATE_DATE,
      ERROR_CODE,
      REQ_COUNT,
      DATE_START,
      SMS_SENDER_NAME
    
    )
  values
    (pprovider_id,
     pphone,
     pmessage,
     null,
     99,
     null,
     null,
     null,
     null,
     null,
     0,
     pdate_start,
     SENDER_NAME
     );
  commit;
end;
/