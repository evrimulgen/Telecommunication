CREATE TABLE SAVED_V_DRAVE_INFO(
  PHONE_NUMBER_FEDERAL VARCHAR2(10 Char),
  MONTHLY_PAYMENT	NUMBER(15,2)
  );
  
GRANT SELECT ON SAVED_V_DRAVE_INFO TO CORP_MOBILE_ROLE;  
  
GRANT SELECT ON SAVED_V_DRAVE_INFO TO CORP_MOBILE_ROLE_RO;  
  
GRANT SELECT ON SAVED_V_DRAVE_INFO TO CRM_USER;  

CREATE SYNONYM CRM_USER.SAVED_V_DRAVE_INFO FOR CORP_MOBILE.SAVED_V_DRAVE_INFO;