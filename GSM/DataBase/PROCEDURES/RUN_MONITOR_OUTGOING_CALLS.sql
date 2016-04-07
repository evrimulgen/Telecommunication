CREATE OR REPLACE PROCEDURE RUN_MONITOR_OUTGOING_CALLS(
    pRUN_CURRENT_SESSION number default 0
) IS
  --V2
  -- 2. ������� - 30.04.2015 �������� ��������, ��������� ��������� � ������� ������ ��� ���. ��������� ��� �������
  
  -- 1. ������� - ��������� ��������� ������� ������ �������� ���������� ���������� ������� ��� �������� �������
  -- � PARAMS ��������� �������� ��� ������� �� ������� �����.
  -- ��������� ���� J_CALC_CALL_SUMMARY_STAT ��� ���������� ����������
  -- ����� ���������� �������� �� �������.  
  
  vOLD_VALUE INTEGER;
  res integer;
BEGIN
  
  vOLD_VALUE := TO_NUMBER( MS_PARAMS.GET_PARAM_VALUE('MONTH_OFFSET_MONITOR_OUTGOING_CALLS') );
  res := MS_PARAMS.SET_PARAM_VALUE('MONTH_OFFSET_MONITOR_OUTGOING_CALLS','0');
  COMMIT;
  
  DBMS_LOCK.SLEEP(1);
  
  -- ���� �������, ��������� � ������� �����, �� �������� TRUE
  IF pRUN_CURRENT_SESSION = 0 then
    DBMS_SCHEDULER.RUN_JOB('J_CALC_CALL_SUMMARY_STAT', false);
  ELSE
    DBMS_SCHEDULER.RUN_JOB('J_CALC_CALL_SUMMARY_STAT');    
  END IF;

  -- ���� �� �������� ���������� � ������ ����������, ��� ��� ���� ������� �������� ������ ��������
  DBMS_LOCK.SLEEP(2); 
  res := MS_PARAMS.SET_PARAM_VALUE('MONTH_OFFSET_MONITOR_OUTGOING_CALLS', to_char(vOLD_VALUE) );
  COMMIT;
  
END;
/
