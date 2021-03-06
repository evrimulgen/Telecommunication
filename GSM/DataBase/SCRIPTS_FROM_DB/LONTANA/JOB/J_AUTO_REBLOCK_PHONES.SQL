
  
BEGIN 
dbms_scheduler.create_job('"J_AUTO_REBLOCK_PHONES"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN 
STOP_JOB_PCKG.CHECK_WORK_JOB;
AUTO_STATUS_ACTION_PCKG.AUTO_REBLOCK_PHONES(0); 
END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('13-NOV-2014 10.26.58.000000000 AM +04:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY; INTERVAL=1; BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Очередь переблокировки номеров'
);
COMMIT; 
END; 
