CREATE OR REPLACE FUNCTION TARIFF_RESTS_TABLE(
  pPHONE_NUMBER IN VARCHAR2
  ) RETURN TARIFF_REST_ROW_TAB PIPELINED AS
--#Version=2
--
--v.2 ������� 20.02.2015 ����� �������� ����� �� ���������� ����������
--v.1 ������� 13.02.2015 ���������� ������� �������  �� REST_API
--
  vRESTS beeline_rest_api_pckg.TRests;
  vREST  TInfoRest;
  I BINARY_INTEGER;
BEGIN
  vRESTS := beeline_api_pckg.rest_info_rests(pPHONE_NUMBER);
  I := vRESTS.FIRST;
  WHILE I IS NOT NULL LOOP
    vREST := vRESTS(I);

    PIPE ROW(
        TARIFF_REST_ROW_TYPE(
          pPHONE_NUMBER,
          vREST.unitType,
          vREST.restType,
          vREST.initialSize,
          vREST.currValue,
          vREST.nextValue,
          vREST.frequency,
          vREST.soc,
          vREST.socName,
          vREST.restName)
      );
    I := vRESTS.NEXT(I);
  END LOOP;
END;
/

GRANT EXECUTE ON TARIFF_RESTS_TABLE TO LONTANA_ROLE;
GRANT EXECUTE ON TARIFF_RESTS_TABLE TO LONTANA_ROLE_RO;