CREATE OR REPLACE FUNCTION GET_PAYKEEPER_COEFFICIENT RETURN NUMBER IS
  -- Version1
  --v1 - 13.05.2015 - ������� �. - ���������� ����������� ��������� �������� PayKeeper 
  vRES number;
BEGIN  
  vRES :=  TO_NUMBER2 (
                          nvl(
                              MS_PARAMS.GET_PARAM_VALUE('PAYKEEPER_COEFFICIENT'),
                              '1' -- ���� ����������� �� �����, �� ����� 1
                             )
                      );
  return vRES;                      
END;