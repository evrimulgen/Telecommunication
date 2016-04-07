create tablespace TS_BEELINE_SOAP_API_LOG
DATAFILE 
  'D:\ORACLE\ORADATA\K7\TS_BEELINE_SOAP_API_LOG_0' SIZE 30G AUTOEXTEND ON NEXT 1G MAXSIZE UNLIMITED
LOGGING
ONLINE
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

alter table BEELINE_SOAP_API_LOG move tablespace TS_BEELINE_SOAP_API_LOG;

alter table BEELINE_SOAP_API_LOG move lob (SOAP_ANSWER) store as (tablespace TS_BEELINE_SOAP_API_LOG);

Alter index CORP_MOBILE.PK_BSAL rebuild TABLESPACE TS_BEELINE_SOAP_API_LOG;

Alter index CORP_MOBILE.I_PHONE_TYPE_ACCOUNT rebuild TABLESPACE TS_BEELINE_SOAP_API_LOG;
