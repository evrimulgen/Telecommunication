
  
BEGIN 
dbms_scheduler.create_job('"J_LOAD_BEELINE_BILLS_285"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN 
STOP_JOB_PCKG.CHECK_WORK_JOB;
P_LOAD_BEELINE_BILLS(285);
END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-OCT-2014 01.11.19.000000000 PM +04:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ = HOURLY; INTERVAL = 1'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>TRUE,comments=>
'Загрузка счетов билайн ACCOUNT_ID 285'
);
dbms_scheduler.enable('"J_LOAD_BEELINE_BILLS_285"');
COMMIT; 
END; 
