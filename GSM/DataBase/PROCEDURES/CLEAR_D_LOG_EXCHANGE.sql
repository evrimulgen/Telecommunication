CREATE OR REPLACE procedure WWW_DEALER.CLEAR_D_LOG_EXCHANGE AS
--
--#Version=1
--

/******************************************************************************
    ��������� ������� ���� ���� ������� ������ ������� �� 30 ����
******************************************************************************/
max_day_count constant integer := 30;

BEGIN
    delete WWW_DEALER.D_LOG_EXCHANGE tt where TT.CHANGE_DATE< sysdate - max_day_count;
    commit;
END;