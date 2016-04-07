CREATE OR REPLACE FUNCTION CRM_PHONE_CNG_DOPST_AND_ACTIVE (pPHONE_NUMBER varchar2)
  RETURN VARCHAR2 AS
--
--Version=1
--v.1 17.03.2015 ������� - ������� ������� ��������� ���.������� � ����������/������������� ������ � ������������ � ��� �������� ��� CRM
--
    
BEGIN
  --������ ��� ������ ��: ������������ ����������
  RETURN PHONE_CHANGE_DOPST_AND_ACTIVE(pPHONE_NUMBER, 1);
END;

GRANT EXECUTE ON CRM_PHONE_CNG_DOPST_AND_ACTIVE TO CRM_USER; 

CREATE SYNONYM CRM_USER.CRM_PHONE_CNG_DOPST_AND_ACTIVE FOR CORP_MOBILE.CRM_PHONE_CNG_DOPST_AND_ACTIVE;  
