create table KILL_JOBS_EXCEPTION (
  JOB_NAME         varchar2(30), 
  JOB_RUNNING_TIME Integer
);

comment on table KILL_JOBS_EXCEPTION is '������� � ������������ ��� ��������� KILL_HANGED_JOBS';
comment on column KILL_JOBS_EXCEPTION.JOB_NAME is '��� ������� (JOBS)';

comment on column KILL_JOBS_EXCEPTION.JOB_RUNNING_TIME is '����� ������ ����� ����� ������� ���������� �����.(����� � �������, ���� �������� null, �� ������ ����� �� �����������)';
