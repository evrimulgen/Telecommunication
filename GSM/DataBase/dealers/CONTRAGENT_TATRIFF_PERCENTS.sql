CREATE OR REPLACE PROCEDURE WWW_DEALER.CONTRAGENT_TATRIFF_PERCENTS (
    NAME_ARRAY IN OWA.VC_ARR,
    VALUE_ARRAY IN OWA.VC_ARR   
  ) IS
--#VERSION=1 
-- V1. 2015.06.09 - �������. ���������, ������� ������������ �������� �� ����������� � �������� � ������ � ���������� �������.
  
  vSESSION_ID VARCHAR2(100 CHAR);  -- ������������� ������
  vEXCEL BOOLEAN;  -- ���������� �� ����� �������� � Excel
  vTEXT  BOOLEAN;  --
  vCONTRAGENT_ID INTEGER;  -- ID ����������� 
  vCONTRAGENT_NAME VARCHAR2(200 char); -- ��� ����������� 
  I integer; -- ���������� ����� � ������� - �������
  cCRLF CONSTANT VARCHAR2(2 CHAR) := CHR(13) || CHR(10);
  vIS_SET_PERC_4_ALL_DEALERS number(1); -- �������, ������������� �� �������� ��� ���� ������������ �� ������� �������� �� ���� �� ������ (1 - ��, 0 - ���)
      
  TYPE T_PERCENT IS RECORD (
    PERCENT_1C NUMBER,
    PERCENT_1C_ACTUAL NUMBER,
    PERCENT_1C_HISTORY VARCHAR2(4000 CHAR),    
    PERCENT_HAND NUMBER,
    PERCENT_HAND_ACTUAL NUMBER,
    PERCENT_HISTORY VARCHAR2(4000 CHAR)    
  );  
  -- �������� ������ ����������� (������ - ��� ���������, �������� - �������� ��������)
  TYPE T_TARIFF_PERCENTS IS TABLE OF T_PERCENT INDEX BY BINARY_INTEGER;
  -- ���������� (������������, ���, ��������)
  TYPE T_CONTRAGENT IS RECORD (
    USER_ID INTEGER,
    USER_NAME VARCHAR2(255 CHAR),
    PERCENTS T_TARIFF_PERCENTS
  );
  -- ������ ������������, ��� - ���������� ����� �����������
  TYPE T_CONTRAGENTS IS TABLE OF T_CONTRAGENT INDEX BY BINARY_INTEGER;
  
  vCONTRAGENTS T_CONTRAGENTS;
  vTARIFFS DBMS_SQL.VARCHAR2S; -- ������ ���������� (������ - ���, �������� - ������������)
  vLINE VARCHAR2(32000 CHAR);
  vTARIFF_POS PLS_INTEGER;
  vCONTRAGENT_POS PLS_INTEGER;
  vPERIOD_SAVE VARCHAR2(200 CHAR);
  vPERIOD_SAVE_DATE DATE;
  vPERIOD_OPEN VARCHAR2(200 CHAR);
  vPERIOD_OPEN_DATE DATE;
  
  vSTYLE VARCHAR2(100 char);
    
  --  ����� �� ������ ��� ������� ��������� �������� �� 1� ��� ������� ������
  CURSOR CUR_TARIFFS IS
    SELECT TR.TARIFF_ID, TR.TARIFF_NAME
      FROM D_TARIFFS TR
     WHERE 
     NOT EXISTS
     (SELECT P1.TARIFF_ID FROM D_TARIFF_PERCENTS P1 WHERE NVL(PERCENT, 0) > 0 AND P1.TARIFF_ID = TR.TARIFF_ID  -- �� ��������� ������ ���� ������� ���, ��� �������� �� ��� �������� �� ������ �������
       UNION ALL
      SELECT P2.TARIFF_ID FROM D_TARIFF_PRC_HANDS P2 WHERE P2.TARIFF_ID = TR.TARIFF_ID
     )
     AND 
     TR.IS_ACTIVE = 1;
  --
  CURSOR C_PERCENTS(pMANAGER_ID INTEGER, pPERIOD_DATE DATE, pCONTRAGENT_ID INTEGER) IS  
    SELECT D_U.USER_ID
          ,D_U.DESCRIPTION CONTRAGENT_NAME
          ,TR.TARIFF_ID
          ,TR.TARIFF_NAME
          -- ���������� �������� ��� (��� ���������� ����� �����������)
          ,ROW_NUMBER() OVER (PARTITION BY TR.TARIFF_ID ORDER BY D_U.DESCRIPTION) R_NUM
          ,S_GET_CONTR_TARIFF_PERCENT_1C(TR.TARIFF_ID, pPERIOD_DATE, V_USER.USER_ID) PERCENT_1C -- S_GET_TARIFF_PERCENT_1C(TR.TARIFF_ID, pPERIOD_DATE) PERCENT_1C  ���������� D_CONTR_TARIFF_PERCENTS
          ,S_GET_CONTR_TARIFF_PERCENT_1C(TR.TARIFF_ID, sysdate, V_USER.USER_ID) PERCENT_1C_ACTUAL
          ,S_GET_CONTR_TARIF_PERC_1C_HIST(TR.TARIFF_ID, V_USER.USER_ID) PERCENT_1C_HISTORY--S_GET_CONTRAGENT_PERC_1C_HIST(OP.OPERATOR_ID, V_USER.USER_ID) PERCENT_1C_HISTORY
          ,(
             SELECT P_HAND.PERCENT PERCENT_HAND
               FROM D_CONTR_TARIFF_PERC_HANDS P_HAND                    
              WHERE (V_USER.USER_ID = P_HAND.USER_ID)
                AND (TR.TARIFF_ID = P_HAND.TARIFF_ID)
                AND (P_HAND.PERIOD = pPERIOD_DATE)
                AND ROWNUM < 2
            ) PERCENT_HAND
          ,S_GET_CONTR_TARIFF_PERC_HAND(TR.TARIFF_ID, V_USER.USER_ID, pPERIOD_DATE) PERCENT_HAND_ACTUAL  --S_GET_TARIFF_PERCENT_HAND(TR.TARIFF_ID, V_USER.USER_ID, pPERIOD_DATE) PERCENT_HAND_ACTUAL
          ,S_GET_CONTR_TARIFF_PERC_HIST(TR.TARIFF_ID, V_USER.USER_ID) PERCENT_HISTORY --S_GET_TARIFF_PERC_HIST(TR.TARIFF_ID, V_USER.USER_ID) PERCENT_HISTORY
      FROM V_USERS_BY_MANAGER V_USER
          ,D_USER_NAMES D_U
          ,D_TARIFFS TR
     WHERE (V_USER.MANAGER_ID = pMANAGER_ID)
       AND (V_USER.USER_ID = pCONTRAGENT_ID)
       AND (V_USER.USER_ID = D_U.USER_ID (+))
       AND NVL(D_U.IS_MANAGER, 0) <> 1          
     ORDER BY D_U.DESCRIPTION, TR.TARIFF_NAME     
     ;  
  
BEGIN
  IF NAME_ARRAY.COUNT > 0 THEN
    vEXCEL := FALSE;
    vTEXT := FALSE;
    vIS_SET_PERC_4_ALL_DEALERS := 0;
    
    
    -- ���������� ����������� ���������
    FOR I IN NAME_ARRAY.FIRST..NAME_ARRAY.LAST LOOP
      
      IF UPPER(NAME_ARRAY(I)) = 'SESSION_ID' THEN
        vSESSION_ID := SUBSTR(VALUE_ARRAY(I), 1, 100);
--      ELSIF UPPER(NAME_ARRAY(I)) = 'PAGE' THEN
--        vPAGE := TO_NUMBER(VALUE_ARRAY(I));
      ELSIF UPPER(NAME_ARRAY(I)) = 'XLS' THEN
        vEXCEL := TRUE;
      ELSIF UPPER(NAME_ARRAY(I)) = 'XTEXT' THEN
        vTEXT := TRUE;
      -- ���������� ������ 
      ELSIF NAME_ARRAY(I) = 'PERIOD_SAVE' THEN
        vPERIOD_SAVE := VALUE_ARRAY(I);
      ELSIF NAME_ARRAY(I) = 'PERIOD_OPEN' THEN
        vPERIOD_OPEN := VALUE_ARRAY(I);
      ELSIF NAME_ARRAY(I) = 'CONTRAGENT_ID' THEN 
        vCONTRAGENT_ID := TO_NUMBER( VALUE_ARRAY(I) );
      ELSIF NAME_ARRAY(I) = 'SET_NAME_FOR_ALL_DEALERS' THEN
        vIS_SET_PERC_4_ALL_DEALERS := 1;
      END IF;
      
    END LOOP;
    
--    IF vCONTRAGENT_ID IS NULL THEN
--      
--    END IF;
    
    -- ���� �������� � ��������� ���� �� ���������, �� �������� � TARIFF_PERCENTS
    /*
   --
   */    
    IF vEXCEL THEN
      PRINT_EXCEL_HEADER('CONTRAGENT_TARIFF_PERCENTS.xls', TRUE);
      -- 3 ������������ ������
      G_STATE.EXCEL_FREEZE_ROWS := 2;
    END IF;
        
    IF vSESSION_ID IS NOT NULL THEN
      S_BEGIN(SESSION_ID=>vSESSION_ID);
      
      IF G_STATE.USER_ID IS NOT NULL THEN
        HTP.PRINT('        <div id="content">');
        
        BEGIN
          
          -- ���� ������ �� �����, �� �� ��������� ������ ������� �����        
          IF vPERIOD_SAVE IS NULL THEN
            vPERIOD_SAVE := TO_CHAR( TRUNC(SYSDATE, 'MM'), 'DD.MM.YYYY' );                   
          END IF;          
          BEGIN
            vPERIOD_SAVE_DATE := TO_CHAR( TRUNC(vPERIOD_SAVE), 'DD.MM.YYYY' );
          EXCEPTION WHEN OTHERS THEN 
            vPERIOD_SAVE_DATE := TRUNC(SYSDATE, 'MM');
          END;
          
          IF vPERIOD_OPEN IS NULL THEN
            vPERIOD_OPEN := TO_CHAR(TRUNC(SYSDATE, 'MM'), 'DD.MM.YYYY');
          END IF;          
          BEGIN
            vPERIOD_OPEN_DATE := TO_DATE(vPERIOD_OPEN, 'DD.MM.YYYY');
          EXCEPTION WHEN OTHERS THEN
            vPERIOD_OPEN_DATE := TRUNC(SYSDATE, 'MM');
          END;          
          
          FOR I IN NAME_ARRAY.FIRST..NAME_ARRAY.LAST LOOP
            IF SUBSTR(NAME_ARRAY(I), 1, 4) = 'PERC' THEN
              -- ������� ����������� 
              -- �� ��������� N ������� ��� �����������, ����� ������������� ��� ���������, ������ ���
  --            HTP.PRINT('NUMBER='||vNUMBER ||', NAME=' || VALUE_ARRAY(I) || '<BR>');
              SET_CONTRAGENT_TARIFF_PERCENT(REPLACE(NAME_ARRAY(I), 'PERC', ''), VALUE_ARRAY(I), vPERIOD_SAVE, vIS_SET_PERC_4_ALL_DEALERS);              
            END IF;
          END LOOP;
          
        EXCEPTION WHEN OTHERS THEN
          OUT_ERROR(dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
                    dbms_utility.format_error_backtrace);
          
        END;
        
        -- ���������� ������ �������
        FOR REC_TARIFFS IN CUR_TARIFFS LOOP
          vTARIFFS(REC_TARIFFS.TARIFF_ID) := REC_TARIFFS.TARIFF_NAME; 
        END LOOP;        
        
        -- ���������� �������� �� ����������� �� ������� �� �������
        FOR REC IN C_PERCENTS(G_STATE.USER_ID, vPERIOD_OPEN_DATE, vCONTRAGENT_ID) LOOP
          vCONTRAGENTS(REC.R_NUM).USER_ID := REC.USER_ID;
          vCONTRAGENTS(REC.R_NUM).USER_NAME := REC.CONTRAGENT_NAME;
          vCONTRAGENT_NAME := REC.CONTRAGENT_NAME;
          vCONTRAGENTS(REC.R_NUM).PERCENTS(REC.TARIFF_ID).PERCENT_1C := REC.PERCENT_1C;
          vCONTRAGENTS(REC.R_NUM).PERCENTS(REC.TARIFF_ID).PERCENT_1C_ACTUAL := REC.PERCENT_1C_ACTUAL;
          vCONTRAGENTS(REC.R_NUM).PERCENTS(REC.TARIFF_ID).PERCENT_1C_HISTORY := REC.PERCENT_1C_HISTORY;
          vCONTRAGENTS(REC.R_NUM).PERCENTS(REC.TARIFF_ID).PERCENT_HAND := REC.PERCENT_HAND;
          vCONTRAGENTS(REC.R_NUM).PERCENTS(REC.TARIFF_ID).PERCENT_HAND_ACTUAL := REC.PERCENT_HAND_ACTUAL; -- �������, ������������� �� ������� ������
          vCONTRAGENTS(REC.R_NUM).PERCENTS(REC.TARIFF_ID).PERCENT_HISTORY := REC.PERCENT_HISTORY;
        END LOOP;        
        
        -- ���� ��������� � ����, �� ������� ���������
        IF vEXCEL THEN        
          HTP.PRINT('<h3>�������� ������������ "'||vCONTRAGENT_NAME||'" � �������� � ������ (� ������ - '|| vPERIOD_OPEN ||')</h3><br>');   
        END IF;
        
        -- ���� �� �������� � ����, �� ������ ��������
        -- ������� ������ ����� � �������� � ��������
        IF NOT vEXCEL THEN
          HTP.PRINT('
          <FORM METHOD="POST" ACTION="!CONTRAGENT_TATRIFF_PERCENTS" ID="CONTRAGENT_TATRIFF_PERCENTS">
          <INPUT TYPE="HIDDEN" NAME="SESSION_ID" VALUE="'||G_STATE.SESSION_ID||'">
          <INPUT TYPE="HIDDEN" NAME="PERIOD_SAVE" VALUE="'||vPERIOD_OPEN||'">');
          HTP.PRINT('
              <table class="search_table"><tbody>
                <tr>
                  <td align="left"><INPUT CLASS=text TYPE=SUBMIT VALUE="���������"></td>
                  <td align="left"><input class="text" type="SUBMIT" name="XLS" title="��������� �������� �� ������������ � �������� � ������� � MS Excel" value="��������� � Excel"></td>
                ');
          HTP.PRINT('
                  <td align="right">������:
                    <select name="PERIOD_OPEN" id="PERIOD_OPEN" onchange="submit();">
                      '||GET_PERIOD_OPTIONS(vPERIOD_OPEN_DATE, TO_DATE('01.01.2010', 'DD.MM.YYYY'))||' 
                    </select>
                  </td>
                </tr>');      
          HTP.PRINT('
                <tr>
                  <td align="left" colspan="2">���������� : 
                    <select name="CONTRAGENT_ID" onchange="submit();"> ');
          PRINT_USERS_OPTIONS(vCONTRAGENT_ID, 1, G_STATE.USER_ID);
          HTP.PRINT('
                    </select>
                  </td>
                </tr>');
          HTP.PRINT('
              </tbody></table>');        
        END IF;
        
                
        IF vEXCEL THEN
          I := 1;
          vLINE := '<TABLE class="table_data"><tr><th>�</th><th>�����</th><th>����%</th><th>1�</th></tr>'|| cCRLF;          
          IF vCONTRAGENTS.count > 0 THEN
            vTARIFF_POS := vTARIFFS.FIRST;
            vCONTRAGENT_POS := vCONTRAGENTS.FIRST;
            WHILE vTARIFF_POS IS NOT NULL LOOP
              vLINE := vLINE || '<tr><td>'|| I ||'</td><td>'||vTARIFFS(vTARIFF_POS) ||'</td>';
              IF vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS.COUNT > 0 AND vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS.EXISTS(vTARIFF_POS) THEN
                vLINE := vLINE || '<td>'||vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_HAND||'</td>'||
                        '<td>'||vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_1C ||'</td></tr>'|| cCRLF;
              ELSE
                vLINE := vLINE || '<td></td><td></td>'|| cCRLF;
              END IF;              
              vTARIFF_POS := vTARIFFS.NEXT(vTARIFF_POS);
              I := I + 1;
            END LOOP;
            HTP.PRN(vLINE);
          end if;        
        ELSE

          -- ���� ��� ����������� ������� �������� ����� ������ ��� ���� ������� � ����������
          IF vCONTRAGENTS.count > 0 THEN
            vTARIFF_POS := vTARIFFS.FIRST;
            vCONTRAGENT_POS := vCONTRAGENTS.FIRST;
            i := 1;
            HTP.PRINT('
                  <table class="table_data">
                    <tr>
                      <th >�</th>
                      <th >�����</th>
                      <th >������� (����.)</th>
                      <th >������� (1�)</th>
                    <tr>
                    <tr>
                      <td colspan="2"> ��� ��������� ����������� ��������� �� ��������� ���� ������� ������ ������� �������</td>
                      <td>   
                          <input type="submit" value = "���������� ����" title="��� ������� �������� ����� ��������� ��� �������� ����������� � ����������� ��� ���� ���������" id = "SetPercentForAll" name="SET_NAME_FOR_ALL_DEALERS"/> 
                      </td>
                      <td></td>
                    <tr>
                    ');
                     
            WHILE vTARIFF_POS IS NOT NULL LOOP              
              --vLINE := 
              IF vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS.COUNT > 0 AND vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS.EXISTS(vTARIFF_POS) THEN
                IF vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_1C IS NULL THEN
                  vSTYLE := 'style="color: rgb(148, 148, 148)"' ;
                ELSE 
                  vSTYLE := '' ;
                END IF;
                
                HTP.PRINT('
                    <tr>
                      <td>'||I ||'</td>
                      <td>'||vTARIFFS(vTARIFF_POS) ||'</td>
                      <td>
                        <input class="text 1" pattern="\d+([,\.]{1}\d{1,2})?" 
                         placeholder="' || vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_HAND_ACTUAL || '" 
                         maxlength="10" size="3"  
                         title = "'||vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_HISTORY||'" 
                         name="PERC' || vCONTRAGENTS(vCONTRAGENT_POS).USER_ID || '_' || vTARIFF_POS || '"
                         id="PERC'   || vCONTRAGENTS(vCONTRAGENT_POS).USER_ID || '_' || vTARIFF_POS || '" type=edit 
                         value="' || vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_HAND || '"  
                         "/>
                      </td>                    
                      <td '||vSTYLE||' title = "'|| vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_1C_HISTORY||'">'||
                      NVL(vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_1C, vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_1C_ACTUAL) ||'
                      </td>
                    </tr>                
                ');
              ELSE 
                HTP.PRINT('
                    <tr>
                      <td>�����</td>
                      <td>'||vTARIFFS(vTARIFF_POS) ||'</td>
                      <td>
                        <input class=text pattern="\d+([,\.]{1}\d{1,2})?" 
                         placeholder="" 
                         maxlength="10" size="3"  
                         name="PERC' || vCONTRAGENTS(vCONTRAGENT_POS).USER_ID || '_' || vTARIFF_POS || '"
                         id="PERC'   || vCONTRAGENTS(vCONTRAGENT_POS).USER_ID || '_' || vTARIFF_POS || '" type=edit 
                         value=""  
                         "/>
                      </td>                    
                      <td title = "'|| vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_1C_HISTORY||'">'||
                        vCONTRAGENTS(vCONTRAGENT_POS).PERCENTS(vTARIFF_POS).PERCENT_1C_ACTUAL ||'
                      </td>
                    </tr>                
                ');            
              END IF;
              vTARIFF_POS := vTARIFFS.NEXT(vTARIFF_POS);
              I := I + 1;
            END LOOP;
            
          END IF;
        END IF;
                
        HTP.PRINT('</TABLE>');
        
      END IF;
      HTP.PRINT('</div>');
    END IF;
    S_END;
  END IF;
EXCEPTION WHEN OTHERS THEN
  OUT_ERROR(dbms_utility.format_error_stack ||CHR(13)||CHR(10)||
            dbms_utility.format_error_backtrace);    
END;
/
