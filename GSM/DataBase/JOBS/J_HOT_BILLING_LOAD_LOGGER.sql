BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        job_name => 'J_HOT_BILLING_LOAD_LOGGER',
        job_type => 'PLSQL_BLOCK',
        job_action => '--#Version=1
                        --
                        --v.1 09.10.2014 ������� - ������� ����
                        BEGIN
                          STOP_JOB_PCKG.CHECK_WORK_JOB;  
                          HOT_BILLING_DBF_LOADED_LOGGER; 
                        END;', 
        start_date => SYSDATE,
        repeat_interval => 'FREQ = MINUTELY; INTERVAL = 1',
        enabled => TRUE
);
END;