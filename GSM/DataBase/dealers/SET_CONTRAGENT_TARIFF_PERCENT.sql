CREATE OR REPLACE PROCEDURE WWW_DEALER.SET_CONTRAGENT_TARIFF_PERCENT(
  pUSER_ID_TARIFF_ID VARCHAR2, 
  pPERCENT VARCHAR2, 
  pPERIOD DATE, 
  pIS_SET_PERC_4_ALL_DEALERS NUMBER DEFAULT 0 -- �������, ������������� ������� ��� ���� ������� ��� ������ ��� ����������� (0 - ���, 1 - ��) 
) IS
--#Version=2
--v2. 29.06.2015 � ������ ������ http://redmine.tarifer.ru/issues/3001 ��������� ��������� ��� ���������� ��������� ��� ���� ������� ��������� ������ � ���������� �������
             --  �������� ������ CUR_DEALERS, �������� ������� �������� pIS_SET_PERC_4_ALL_DEALERS - �������, ������������� ��� ���� ��� ������ ��� ����������� 
-- ���������� ��� ����������� ������� (�� ������)
--   pUSER_ID_TARIFF_ID - ��� ����������� � ��� ������ ����������� ������ ������������� 2929_1
--   pPERCENT - �������
--   pPERIOD - ������ � ������� ����������� ������� (������� ���� ������ ���������� ������)
  vUSER_ID VARCHAR2(255 CHAR);
  vTARIFF_ID VARCHAR2(255 CHAR);
  vPOS PLS_INTEGER;
  vPERIOD DATE;
  
  CURSOR CUR_DEALERS (pIS_SET_PERC_4_ALL_DEALERS number, pUSER_ID integer) IS      
    SELECT O.USER_ID 
      FROM D_USER_NAMES O
     WHERE NVL(O.IS_LOCKED, 0) <> 1
       AND NVL(O.IS_DELETED, 0) <> 1
       AND O.MANAGER_ID =
             (select DU.MANAGER_ID
                from d_user_names du 
               where du.USER_ID = pUSER_ID
             )
       AND 
         (
            ( pIS_SET_PERC_4_ALL_DEALERS = 0 and O.USER_ID = pUSER_ID ) -- ���� ������������� ������� ������ ��� ����������� ������, �� � ����� ������ ��(�����) � ����� 
            or
            ( pIS_SET_PERC_4_ALL_DEALERS = 1) -- ���� ������������� ������� ��� ����
         )           
  ;
  
  CURSOR CUR(pTARIFF_ID INTEGER, pUSER_ID INTEGER, pDATE DATE) IS
    SELECT H.*
      FROM D_CONTR_TARIFF_PERC_HANDS H
     WHERE H.USER_ID = pUSER_ID
       AND H.TARIFF_ID = pTARIFF_ID
       AND (H.PERIOD = pDATE) -- ������� ��������� ������� ������ � ��������� ����
  ;
  
  REC CUR%ROWTYPE;
  
  
  FUNCTION GET_USER_NAME(pUSER_ID INTEGER) RETURN VARCHAR2 IS
    vRES VARCHAR2(255 CHAR);
  BEGIN
    FOR REC IN (SELECT NVL(U.DESCRIPTION, U.USER_NAME) U_NAME 
                 FROM D_USER_NAMES U WHERE U.USER_ID = pUSER_ID) 
    LOOP
      vRES := REC.U_NAME; 
    END LOOP;
    RETURN vRES;
  END;
  
  FUNCTION GET_TARIFF_NAME(pTARIFF_ID INTEGER) RETURN VARCHAR2 IS
    vRES VARCHAR2(255 CHAR);
  BEGIN
    FOR REC IN (SELECT OP.TARIFF_NAME 
                 FROM D_TARIFFS OP WHERE OP.TARIFF_ID = pTARIFF_ID) 
    LOOP
      vRES := REC.TARIFF_NAME; 
    END LOOP;
    RETURN vRES;
  END;
  
BEGIN
  IF pUSER_ID_TARIFF_ID IS NOT NULL THEN  
    vPOS := INSTR(pUSER_ID_TARIFF_ID, '_');
    IF vPOS > 0 THEN
      vUSER_ID := TO_NUMBER(SUBSTR(pUSER_ID_TARIFF_ID, 1, vPOS-1));
      vTARIFF_ID := TO_NUMBER(SUBSTR(pUSER_ID_TARIFF_ID, vPOS+1));
      --RAISE_APPLICATION_ERROR(-20000, vUSER_ID||'+'||vTARIFF_ID);
      
      -- � ������, ����� ������������� ������� �� ��� ����, �� ���������� pIS_SET_PERC_4_ALL_DEALERS=false,
      -- ���� �� ������������� ��� ����, �� pIS_SET_PERC_4_ALL_DEALERS=TRUE � ����������� �� ��� ������� ���������
      FOR vDEALERS in CUR_DEALERS(pIS_SET_PERC_4_ALL_DEALERS, vUSER_ID) LOOP
        IF vDEALERS.USER_ID IS NOT NULL AND vTARIFF_ID IS NOT NULL THEN 
          IF pPERIOD IS NULL THEN
            vPERIOD := TRUNC(SYSDATE, 'MM');
          ELSE
            vPERIOD := TRUNC(pPERIOD, 'MM');
          END IF;

          OPEN CUR(vTARIFF_ID, vDEALERS.USER_ID, vPERIOD);
          FETCH CUR INTO REC;
          IF CUR%FOUND THEN
            IF TRIM(pPERCENT) IS NULL THEN
              DELETE FROM D_CONTR_TARIFF_PERC_HANDS H
              WHERE H.CONTR_TARIFF_PRC_HAND_ID = REC.CONTR_TARIFF_PRC_HAND_ID;
            ELSE
              UPDATE D_CONTR_TARIFF_PERC_HANDS H
              SET H.PERCENT = TO_NUMBER2(pPERCENT)
              WHERE H.CONTR_TARIFF_PRC_HAND_ID = REC.CONTR_TARIFF_PRC_HAND_ID;
            END IF;
          ELSE
            IF TRIM(pPERCENT) IS NOT NULL THEN
              INSERT INTO D_CONTR_TARIFF_PERC_HANDS(USER_ID, TARIFF_ID, PERCENT, PERIOD)
              VALUES(vDEALERS.USER_ID, vTARIFF_ID, TO_NUMBER2(pPERCENT), vPERIOD);
            END IF;
          END IF;
          CLOSE CUR;
        ELSE
          RAISE_APPLICATION_ERROR(-20000, '������ ���������� �������� ����������� �� ������. ��� �� ����������. �� ��������� ��� ����������� "'||vDEALERS.USER_ID||'" ��� ��� ��������� "'||vTARIFF_ID||'"');
        END IF;     
      END LOOP;
    ELSE
      RAISE_APPLICATION_ERROR(-20000, '������ ���������� �������� ����������� �� ������. ��� �� ���������� "'||pUSER_ID_TARIFF_ID||'" ������ ���� � ������� 1000_5.');
    END IF;
  END IF;
  COMMIT;
EXCEPTION WHEN OTHERS THEN
  OUT_ERROR('������ ��������� �������� "'||pPERCENT||'" ����������� '||GET_USER_NAME(vUSER_ID) || ' ��� ������ '||GET_TARIFF_NAME(vTARIFF_ID)||CHR(13)||CHR(10)||
            dbms_utility.format_error_stack ||CHR(13)||CHR(10)|| dbms_utility.format_error_backtrace);
END;
/
