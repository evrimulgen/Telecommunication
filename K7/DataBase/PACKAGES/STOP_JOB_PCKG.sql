CREATE OR REPLACE PACKAGE STOP_JOB_PCKG
AS
    --#Version=2
    --
	--v2  28.05.2015 - �������� �.�. - ������� ���� ����������� job
    --v1  03.04.2015 - �������� �.�. - ����� ��������� job (stop)
   
    --������� job
    PROCEDURE STOP_JOB (pTime_Min IN INTEGER);
    
   --��������� �������� ����������� ������� job
    PROCEDURE CHECK_WORK_JOB;
END;
/

CREATE OR REPLACE PACKAGE BODY STOP_JOB_PCKG AS

/*=======================================*/
PROCEDURE STOP_JOB (pTime_Min IN INTEGER) IS

    TYPE T_JOBNAME IS TABLE OF VARCHAR2(128);
    vJOB T_JOBNAME;
	pStart_time_job DATE; -- �����, ������� job
    vRes VARCHAR2(50);
BEGIN
    BEGIN
        --���������� �����, ����� ������� job ����� ������ ��������
        pStart_time_job := sysdate + pTime_Min/24/60; 
        --��������� �������� ������� � ������� ��������
        vRes := ms_constants.SET_CONSTANT_VALUE('START_TIME_JOB_AFTER_STOP', to_char(pStart_time_job, 'DD.MM.YYYY HH24:MI:SS'));
        commit;
        
        --������� ��� job
        execute immediate 'SELECT owner||''.''||job_name FROM DBA_SCHEDULER_JOBS WHERE STATE=''RUNNING'' AND OWNER = (SELECT SYS_CONTEXT (''userenv'', ''CURRENT_SCHEMA'') FROM DUAL) AND job_name NOT IN (SELECT NAME_STOP_JOB FROM STOP_JOB_EXCEPTION)' BULK COLLECT INTO vJOB;
        IF vJOB.COUNT > 0 THEN
            FOR I IN 1..vJOB.LAST LOOP
                BEGIN
                    execute immediate 'begin DBMS_SCHEDULER.STOP_JOB('''||vJOB(i)||''', TRUE); end;';
                    --dbms_output.put_line(vJOB(i));
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;
                END;
            END LOOP;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
END;

/*=======================================*/
PROCEDURE CHECK_WORK_JOB IS
BEGIN
    IF sysdate < to_date(NVL(ms_constants.GET_CONSTANT_VALUE('START_TIME_JOB_AFTER_STOP'), to_char(sysdate-1, 'DD.MM.YYYY HH24:MI:SS')), 'DD.MM.YYYY HH24:MI:SS') THEN
        raise_application_error(-20000, '�������� ������ job');
    END IF; 
END;

END;
/
