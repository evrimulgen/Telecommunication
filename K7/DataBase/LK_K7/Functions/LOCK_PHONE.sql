CREATE OR REPLACE FUNCTION K7_LK.LOCK_PHONE(
  pPHONE_NUMBER IN VARCHAR2
  ) RETURN VARCHAR2 IS
--
--#Version=1
--
--v.1 05.11.2015 ������� ��������� ������� �� S1B � ����������� ���.������ "������������ ���������� 2015" (382)
--
--
  cMANUAL_LOCK_PHONE CONSTANT INTEGER := 1;--������� ����, ��� ���������� ���� ������� �������
  vRESULT VARCHAR2(500 char);
BEGIN

  --������������� ��� ������ "������������ ���������� 2015" 
  vRESULT := CORP_MOBILE.SET_DOP_STATUS (pPHONE_NUMBER, 382);
  if vRESULT = 'OK' then
    vRESULT := CORP_MOBILE.beeline_api_pckg.LOCK_PHONE(pPHONE_NUMBER, cMANUAL_LOCK_PHONE,'S1B');
  
    if INSTR(vRESULT, '������') > 0 THEN
      vRESULT := '������ ������� � ������';
    else
      vRESULT := '��������� ������! ���������� �����.';
    end if;
  end if;
  
  RETURN vRESULT;
END;
