CREATE OR REPLACE PROCEDURE KILL_HANGED_JOBS IS

<<<<<<< .mine
  --#Version=8
  --8 07.12.2015 �������  ���-�� ������� ������� (dsj.job_name not like 'J_LOAD_PHONES_COLLECT%' AND (last_start_date)<sysdate-4/24 ) 
  --                      � ��� ������ �� �������� ��� ��������� ������ ����������� � ����������. ����������� �������� ����������� ����������
  --7 20.08.2015 ������� ������� ������� � ������������ ��� ������
  --6 19.08.2015 �������� ������� �������� �� ������� ������� � OBJ1 (OBJ1.COUNT > 0). �������� ��� �� �������������
  --5 19.08.2015 �������� �������� ����������� OBJ1 � s1
  --4 18.08.2015 �������� �������� �� ������� job J_MV_PROFIT_BY_PHONES (� ������� check_hovering_jobs).
  --3 14.08.2015 �������� �������� job J_MV_PROFIT_BY_PHONES �� ���������. ������ J_KILL_HANGED_JOBS ��� �� �������.
  --2 07.07.2015 ��� ������� ���� JOB ����� ��������
  --1 13.01.2014 ������� ����������� �� SMS_SYSTEM_ERROR_NOTICE ����������
=======
  --#Version=7
  --7 20.08.2015 ������� ������� ������� � ������������ ��� ������
  --6 19.08.2015 �������� ������� �������� �� ������� ������� � OBJ1 (OBJ1.COUNT > 0). �������� ��� �� �������������
  --5 19.08.2015 �������� �������� ����������� OBJ1 � s1
  --4 18.08.2015 �������� �������� �� ������� job J_MV_PROFIT_BY_PHONES (� ������� check_hovering_jobs).
  --3 14.08.2015 �������� �������� job J_MV_PROFIT_BY_PHONES �� ���������. ������ J_KILL_HANGED_JOBS ��� �� �������.
  --2 07.07.2015 ��� ������� ���� JOB ����� ��������
  --1 13.01.2014 ������� ����������� �� SMS_SYSTEM_ERROR_NOTICE ����������
>>>>>>> .r10866

  s1 varchar2(500 char);
    
  cursor hovering_jobs is
    select
      owner||'.'||dsj.job_name full_job_name
    from
      DBA_SCHEDULER_JOBS dsj
    where
       STATE='RUNNING'and
      (
        (
<<<<<<< .mine
          (
            dsj.job_name like 'J_LOAD_REPORT%' 
            OR (dsj.job_name like 'J_LOAD_PHONES%' and dsj.job_name not like 'J_LOAD_PHONES_COLLECT%') 
            OR dsj.job_name like 'J_LOAD_PAYMENTS%' 
            OR dsj.job_name like 'J_BLOCK_CLIENT%' 
            OR dsj.job_name like 'J_UNBLOCK_CLIENT%' 
          )
           AND (last_start_date)<sysdate-25/1440
        )
--        OR
--        (dsj.job_name not like 'J_LOAD_PHONES_COLLECT%' AND (last_start_date)<sysdate-4/24)
        OR
        exists
        (
            select 1 from KILL_JOBS_EXCEPTION k
            where K.JOB_NAME = dsj.job_name
            --��������� ������ � ����
            and last_start_date < sysdate - (K.JOB_RUNNING_TIME/60) /24
        ) 
        or 
        ( not exists -- ������ ��� � ����������� � � ������ �������� �� �����, �� ���� ��� ���������� ����� ��������� ����� 4 ����� ������   
          (
           select 1 from KILL_JOBS_EXCEPTION k
            where K.JOB_NAME = dsj.job_name    
              and K.JOB_RUNNING_TIME is not null                
          )
          and (last_start_date)<sysdate-4/24
        )
      )
      --���������� �����, ������� �� ���� �������
      and not exists
        (
            select 1 from KILL_JOBS_EXCEPTION k
            where K.JOB_NAME = dsj.job_name
            and K.JOB_RUNNING_TIME is null
        ); 
=======
          (
            dsj.job_name like 'J_LOAD_REPORT%' 
            OR (dsj.job_name like 'J_LOAD_PHONES%' and dsj.job_name not like 'J_LOAD_PHONES_COLLECT%') 
            OR dsj.job_name like 'J_LOAD_PAYMENTS%' 
            OR dsj.job_name like 'J_BLOCK_CLIENT%' 
            OR dsj.job_name like 'J_UNBLOCK_CLIENT%' 
          )
           AND (last_start_date)<sysdate-25/1440
        )
        OR
        (dsj.job_name not like 'J_LOAD_PHONES_COLLECT%' AND (last_start_date)<sysdate-4/24 )
        OR
        exists
        (
            select 1 from KILL_JOBS_EXCEPTION k
            where K.JOB_NAME = dsj.job_name
            --��������� ������ � ����
            and last_start_date < sysdate - (K.JOB_RUNNING_TIME/60) /24
        ) 
      )
      --���������� �����, ������� �� ���� �������
      and not exists
        (
            select 1 from KILL_JOBS_EXCEPTION k
            where K.JOB_NAME = dsj.job_name
            and K.JOB_RUNNING_TIME is null
        ); 
>>>>>>> .r10866

-----�������� ����
BEGIN
  
  for cur in hovering_jobs loop
    s1:='begin DBMS_SCHEDULER.STOP_JOB('''||cur.full_job_name||''', TRUE); end; ';

    BEGIN
      execute immediate s1;
      
      INSERT INTO KILL_JOB_LOG (JOB_NAME, DATE_INSERT)
      VALUES (cur.full_job_name, sysdate);
      
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;   

<<<<<<< .mine
  end loop;
  
  commit;
    
END KILL_HANGED_JOBS;
/
=======
  end loop;
  
  commit;
    
END KILL_HANGED_JOBS;>>>>>>> .r10866
