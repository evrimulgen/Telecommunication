CREATE OR REPLACE PROCEDURE BALANCE(
  SESSION_ID IN VARCHAR2 DEFAULT NULL
  ) IS
--#Version=2
  pDATE_ROWS DBMS_SQL.DATE_TABLE;
  pCOST_ROWS DBMS_SQL.NUMBER_TABLE;
  pDESCRIPTION_ROWS DBMS_SQL.VARCHAR2_TABLE;
  PRIXOD NUMBER;
  RASXOD NUMBER;
  TEMP_DATE DATE;
  TEMP_COST NUMBER;
  TEMP_NOTE VARCHAR2(2000);
  vPHONE_NUMBER VARCHAR2(20 CHAR);
  vCELL_PLAN_NAME VARCHAR2(100 CHAR);
  vUSER_NAME VARCHAR2(100 CHAR);
  vBALANCE NUMBER;
  vDISCONNECT_LIMIT NUMBER;
  vPHONE_STATUS_CODE INTEGER; 
  vACTUAL_DATE DATE;
BEGIN
  PRIXOD:=0;
  RASXOD:=0;
  S_BEGIN(SESSION_ID=>SESSION_ID,STRANICA=>2);
  IF G_STATE.USER_ID IS NOT NULL THEN    
    SQL_GET_USER_INFO(
      G_STATE.USER_ID,
      vPHONE_NUMBER,
      vCELL_PLAN_NAME,
      vUSER_NAME,
      vBALANCE,
      vDISCONNECT_LIMIT,
      vPHONE_STATUS_CODE,
      vACTUAL_DATE
      );
    SQL_GET_ABONENT_BALANCE_ROWS(
      G_STATE.USER_ID,
      SYSDATE,
      pDATE_ROWS, 
      pCOST_ROWS, 
      pDESCRIPTION_ROWS
      );
    HTP.PRINT('
        <div id="content">');  
    HTP.PRINT('
          <table class="info_table">
            <tbody>
              <tr>
                <td class="first_cell"><b>�������</b></td>
                <td class="last_cell">' || SQL_GET_USER_PHONE(G_STATE.USER_ID) || '</td>
              </tr>
              <tr>
                <td class="first_cell"><b>������ �� ' || TO_CHAR(vACTUAL_DATE, 'DD.MM.YY') || '</b></td>
                <td class="last_cell">' || 
                  CASE WHEN vBALANCE<0 THEN '<span class="red">' || COST_TO_CHAR(vBALANCE) || '</span>'
                       ELSE COST_TO_CHAR(vBALANCE) 
                  END  
                  || ' ���.</td>
              </tr>
            </tbody>
          </table>');
    HTP.PRINT('
          <h2>����������� �������:</h2>
          <a href="report_balance?' || G_STATE.SESSION_KEY_PARAM_1 || '&PHONE_NUMBER=' || SQL_GET_USER_PHONE(G_STATE.USER_ID) || '" title="" class="xls_download_link"><img src="IMG_XLS_ICON" title="" alt="" /></a>');      
    IF pDATE_ROWS.COUNT = 0 THEN
      HTP.PRINT('
          <center><i><b>��� ������.</b></i></center>');
    ELSE
      HTP.PRINT('
          <table>
            <thead>
              <tr>
                <td class="first_cell align_center">����</td>
                <td class="align_center" width="105">������ (���.)</td>
                <td class="align_center" width="105">������ (���.)</td>
                <td class="last_cell">����������</td>
              </tr>
            </thead>
            <tbody>');
      FOR I IN pDATE_ROWS.FIRST..pDATE_ROWS.LAST LOOP
        IF pCOST_ROWS(I)<0 
        THEN
          HTP.PRINT('
              <tr>
                <td class="first_cell">' || TO_CHAR(pDATE_ROWS(I), 'DD.MM.YYYY') || '</td>
                <td></td>
                <td><div class="align_right">' || COST_TO_CHAR(pCOST_ROWS(I)) || '</div></td>
                <td class="last_cell">' || pDESCRIPTION_ROWS(I) || '</td>
              </tr>');
          RASXOD:=RASXOD+pCOST_ROWS(I); 
        ELSE 
          HTP.PRINT('
              <tr>
                <td class="first_cell">' || TO_CHAR(pDATE_ROWS(I), 'DD.MM.YYYY') || '</td>
                <td><div class="align_right">' || COST_TO_CHAR(pCOST_ROWS(I)) || '</div></td>
                <td></td>
                <td class="last_cell">' || pDESCRIPTION_ROWS(I) || '</td>
              </tr>');          
          PRIXOD:=PRIXOD+pCOST_ROWS(I); 
        END IF;   
      END LOOP;
      HTP.PRINT('
              <tr>
                <td align=right>�����:</td>
                <td><div class="align_right">' || COST_TO_CHAR(PRIXOD) || '</div></td>
                <td><div class="align_right">' || COST_TO_CHAR(RASXOD) || '</div></td>
                <td></td>
              </tr>');
      HTP.PRINT('
            </tbody>
            <tfoot>
              <tr>
                <td></td>
                <td><div class="align_right">�����:</div></td>
                <td colspan="2"><div class="align_left">' || COST_TO_CHAR(PRIXOD+RASXOD) || ' ���.</div></td>
              </tr>
            </tfoot>
          </table>');
    END IF;
    HTP.PRINT('
				</div>'); 
  END IF;
  S_END;
--EXCEPTION WHEN OTHERS THEN
--  OUT_ERROR(SQLERRM);
END;
/
