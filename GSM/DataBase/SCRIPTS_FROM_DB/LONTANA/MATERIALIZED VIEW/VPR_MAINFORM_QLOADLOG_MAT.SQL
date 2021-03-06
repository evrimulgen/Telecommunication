
  CREATE MATERIALIZED VIEW "LONTANA"."VPR_MAINFORM_QLOADLOG_MAT" ("ACCOUNT_ID", "LOGIN", "ISCOLLECTOR", "ACCOUNT_LOAD_TYPE_ID", "IS_SUCCESS", "CNT")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + NUMTODSINTERVAL(5, 'MINUTE')
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS select * from vpr_mainform_qloadlog
