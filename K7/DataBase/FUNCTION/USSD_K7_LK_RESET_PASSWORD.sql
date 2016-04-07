CREATE OR REPLACE FUNCTION USSD_K7_LK_RESET_PASSWORD (
   pPHONE_NUMBER   IN VARCHAR2
   )
   RETURN VARCHAR2
AS
   --
   --#Version=1
   --
   --v.1 ������� 26.11.2015 - ������� ��������� ������ �� USSD ��� ����� � K7_LK (ag-sv.ru)
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   vRESULT  VARCHAR2 (2000);
BEGIN
  if nvl(CONVERT_PCKG.GET_IS_COLLECTOR_BY_PHONE(pPHONE_NUMBER), 0) = 0 then
    vRESULT := case K7_LK.RESET_PASSWORD(pPHONE_NUMBER)
                 when 'OK' then
                   '������ ��������� �� SMS'
                 when 'NO_PHONE' then
                   '���������� ����� �� ������. ���������� � ������ ����������� ���������'
                 when 'ERROR' then
                   '������, ��������� �����.'
               end;
  else
    vRESULT := '������� ����������';   
  end if;
  commit;
  RETURN TRIM (vRESULT);
END;
/
