
-- v1 - 23.10.2014 - ������� ����������

BEGIN
    sys.dbms_scheduler.create_job(
        job_name            => 'J_CHECK_ACTIVATED_PHONES',
        job_type            => 'PLSQL_BLOCK',
        job_action          => '
BEGIN
    CheckActivatedPhones( p_check_single_phone => 0 );
END;
',
        start_date          => sysdate,
        repeat_interval     => 'FREQ=MINUTELY; INTERVAL=5',
        end_date            => to_date( null ),
        enabled             => false,
        auto_drop           => false,
        comments            => '��������� ��������� ������ (������ ��������: ������, USSD-������� � �.�.) � � ������ ����������� ������� ���������� SMS'
    );
END;
/
show errors
exit
