CREATE OR REPLACE package BEELINE_SMPP_API is
--
--Version=3
--
--v.3 ������� 02.11.2015 - ��������� ������ ������ �� �������� ���. ��� ������ ������� � MYJSMPP
--v.2 ������� 06.03.2015 - �������� ������������ ����� ��������� ��� �������� �������� ���
--
  /* ������� �������� ������� ���
     ������������ �������� - ���� �� ����� :
     "ENROUTE"
     "DELIVERED"
     "EXPIRED"
     "DELETED"
     "UNDELIVERABLE"
     "ACCEPTED"
     "UNKNOWN"
     "REJECTED"
     "UNKNOWN"
     ��������� :
     p_host - ���� ������� SMPP
     p_port - ���� ������� SMPP       
     p_user - ������������ ��� �����������
     p_passw - ������ ��� �����������
     p_sourceAddr - ����� ����������� (�������� �����������)
     p_messageId - ��� ������������ ���
  */

   
  procedure CreateSession (p_host in varchar2,
                        p_port in varchar2,       
                        p_user in varchar2,
                        p_passw in varchar2)
                          
  AS LANGUAGE JAVA
  NAME 'MYJSMPP.CreateSession (java.lang.String ,
                                      java.lang.String ,
                                      java.lang.String ,
                                      java.lang.String )';   
  procedure DisconnectSession 
  AS LANGUAGE JAVA
  NAME 'MYJSMPP.DisconnectSession ()';
  
  procedure SEND_CHECK_STATUS_SMS
  AS LANGUAGE JAVA
  NAME 'MYJSMPP.SEND_CHECK_STATUS_SMS ()';
end;
/
