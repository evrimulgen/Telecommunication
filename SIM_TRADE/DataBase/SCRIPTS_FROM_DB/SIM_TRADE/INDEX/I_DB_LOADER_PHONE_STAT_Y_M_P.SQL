
  CREATE UNIQUE INDEX "SIM_TRADE"."I_DB_LOADER_PHONE_STAT_Y_M_P" ON "SIM_TRADE"."DB_LOADER_PHONE_STAT" ("PHONE_NUMBER", "YEAR_MONTH") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS COMPRESS 1 
  STORAGE(INITIAL 786432 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 