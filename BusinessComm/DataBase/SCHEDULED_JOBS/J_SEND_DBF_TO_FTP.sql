BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'J_SEND_DBF_TO_FTP'
      ,start_date      => sysdate
      ,repeat_interval => 'FREQ=MINUTELY;INTERVAL=10'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'begin
                             STOP_JOB_PCKG.CHECK_WORK_JOB;
                             SEND_DBF_TO_FTP; 
                           end;'
      ,comments        => '���������� �� FTP � ����� 1C/TO_1C 
����� � ����������� .dbf �� D:\Tarifer\DB\FOR_1C.
������������ ����� ��������� � ����� D:\Tarifer\DB\FOR_1C\BACKUP\'
    );
END;
/
