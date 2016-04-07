CREATE OR REPLACE PROCEDURE GET_PHONE_REST_INFO
(
  pPHONE varchar2 
)
-- version 2
--
--v2. 25.05.2015 ��������. ��������� GET_TARIFF_REST_TABLE ���� ����� �������� ������, � �� ����� ����������� ������
-- ������: �������� �., ������� �. 
-- ��������� �������������� � IVR (��������� �����). ��������� ��� ��� ������ � ������������ ��������� ��������� �������: ������ ������� ��� ���. 
--�������� ��� � �������� (�����: ���� ������ �������. ��������� ����� ��������� � SMS.)
IS 
  vRES VARCHAR2(1000 CHAR);
BEGIN
  BEGIN 
    IF (pPHONE IS NOT NULL) AND (LENGTH(pPHONE) = 10) THEN
      vRES := GET_TARIFF_REST_TABLE(pPHONE);
      HTP.PRINT(vRES);
    ELSE
      HTP.PRINT('�� ��������� ����� ����� ��������!'); 
    END IF;
  EXCEPTION 
    WHEN OTHERS THEN
      HTP.PRINT('Error! ��� ���������� ������� �������� ������!');    
  END;        
END;