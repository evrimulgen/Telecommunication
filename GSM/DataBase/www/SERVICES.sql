CREATE OR REPLACE PROCEDURE SERVICES(
  SESSION_ID IN VARCHAR2 DEFAULT NULL
  ) IS
--#Version=2
-- 2. ������� �. 09.09.2015 ������ http://redmine.tarifer.ru/issues/3338. ��������� ����������� ������� ��� ������ ULTRA VIP 2015 (1400) � ������������� "��� �����������".
  vPHONE_NUMBER VARCHAR2(20 CHAR);
  vCELL_PLAN_NAME VARCHAR2(100 CHAR);
  vUSER_NAME VARCHAR2(100 CHAR);
  vBALANCE NUMBER;
  vDISCONNECT_LIMIT NUMBER;
  vPHONE_STATUS_CODE INTEGER; -- 0 - ������������, 1-��������
  vACTUAL_DATE DATE; -- ���� � ����� ������������
  vNAME_OPT_ROWS DBMS_SQL.VARCHAR2_TABLE;
  vDATE_ROWS DBMS_SQL.DATE_TABLE;
  vMONTHLY_COST_ROWS DBMS_SQL.NUMBER_TABLE;
  vCOUNT_PACKAGE integer;
--
  CURSOR VAL_PACKAGE(pPHONE_NUMBER VARCHAR2, vCELL_PLAN_NAME VARCHAR2) IS    
    select 
         tb.UNIT_TYPE
         ,tb.REST_TYPE
         ,tb.INITIAL_SIZE
         ,tb.CURR_VALUE
         ,case 
            when (tb.INITIAL_SIZE - tb.CURR_VALUE) > tb.INITIAL_SIZE then tb.INITIAL_SIZE
            else
              (tb.INITIAL_SIZE - tb.CURR_VALUE)
          end SPENT
         ,tb.NEXT_VALUE
         ,tb.FREQUENCY 
         ,tb.SOC       
         ,tb.SOC_NAME
         ,tb.REST_NAME  
         ,CASE tb.UNIT_TYPE
            when 'INTERNET' then '��'
            when 'SMS_MMS' then '��.'
            when 'VOICE' then '���.'
            else ''
          end  Measure --�������,
     from table (lontana.TARIFF_RESTS_TABLE(pPHONE_NUMBER)) tb  
     WHERE TRIM(vCELL_PLAN_NAME) NOT IN ('ULTRA VIP 1400(���.)', '������ �������� (1300)', 'ULTRA VIP 2015 (1400)') 
        OR tb.UNIT_TYPE <> 'VOICE'               
     Order by tb.UNIT_TYPE
    ; 
    
    CURSOR CUR_COUNT(pPHONE_NUMBER VARCHAR2) is 
      select count(*) cnt
        into vCOUNT_PACKAGE
        from table (lontana.TARIFF_RESTS_TABLE(pPHONE_NUMBER)) tb
     ;

    FUNCTION MONTH_NAME (YEAR_MONTH IN INTEGER) RETURN VARCHAR2 IS 
    BEGIN
      RETURN 
        CASE YEAR_MONTH
          WHEN 01 THEN '������ '
          WHEN 02 THEN '������� '
          WHEN 03 THEN '����� '
          WHEN 04 THEN '������ '
          WHEN 05 THEN '��� '
          WHEN 06 THEN '���� '
          WHEN 07 THEN '���� '
          WHEN 08 THEN '������� '
          WHEN 09 THEN '�������� '
          WHEN 10 THEN '������� '
          WHEN 11 THEN '������ '
          WHEN 12 THEN '������� '
        END;  
    END;

BEGIN
  S_BEGIN(SESSION_ID=>SESSION_ID, STRANICA=>4);
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
    HTP.PRINT('
        <div id="content">');
    HTP.PRINT('
          <p class="phone_number"><b>�������:</b> ' || SQL_GET_USER_PHONE(G_STATE.USER_ID) || '</p>
          <h2>������������ ������</h2>');
    SQL_GET_TURNED_SERVICES(
      G_STATE.USER_ID,
      vNAME_OPT_ROWS,
      vDATE_ROWS
--      vMONTHLY_COST_ROWS
      );
    IF vNAME_OPT_ROWS.COUNT=0 THEN
      HTP.PRINT('
          <i><b>������ �� ����������</b></i>');
    ELSE
      HTP.PRINT('
          <table style="margin-bottom: 20px;">
						<thead>
							<tr>
								<td class="first_cell_service">���� �����������</td>		
                <td class="last_cell">������</td>																
<!-- 								<td class="last_cell">��������� (���.)</td>-->							
							</tr>
						</thead>					
						<tbody>');
      FOR I IN vNAME_OPT_ROWS.FIRST..vNAME_OPT_ROWS.LAST LOOP
        HTP.PRINT('
              <tr>
                <td class="first_cell_service" align="center">' || TO_DATE(vDATE_ROWS(I), 'DD.MM.YYYY') || '</td>
                <td>' || vNAME_OPT_ROWS(I) || '</td>' ||
                
--                <td class="last_cell">' || TO_CHAR(vMONTHLY_COST_ROWS(I)) || '</td>-->	
              '</tr>');
      END LOOP;
      HTP.PRINT('
            </tbody>
					</table>');
    END IF;
    --'9035747337'; --'9037956945';--'9035523338';
    
    --IF vPHONE_NUMBER = '9035523338' or vPHONE_NUMBER = '9645568223' or vPHONE_NUMBER = '9035616160' then --��� ����� 
  
    -- ���� ������������ ������� �� �������, ���� ��� (������) ����
    vCOUNT_PACKAGE := 0;
    OPEN CUR_COUNT(vPHONE_NUMBER);
    FETCH CUR_COUNT INTO vCOUNT_PACKAGE;
    CLOSE CUR_COUNT;  
      
    IF vCOUNT_PACKAGE > 0 THEN  
      HTP.PRINT('
      <h2>� ��� � ��� ����</h2>');
      HTP.PRINT('
      <table>
      ');
      --���� ��� �� ����������������� ������, �� ������������ �����, ���� �� - �� ������ ��� � ��������              
      FOR REC IN VAL_PACKAGE(vPHONE_NUMBER, vCELL_PLAN_NAME) LOOP    
          htp.print('
            <tr>
                <td width="250">'||REC.REST_NAME||'</td>
                <td width="160">
                  <div class="progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="'||REC.CURR_VALUE||'" aria-valuemin="0" aria-valuemax="'||REC.INITIAL_SIZE||'" style="width: '||trunc(REC.CURR_VALUE/REC.INITIAL_SIZE*100)||'%;">
                      <span class="show">'||REC.CURR_VALUE||' �� '||REC.INITIAL_SIZE||'</span>
                    </div>
                  </div>
                </td>
                <td>1 '||MONTH_NAME(to_number( to_char( add_months( sysdate, 1), 'MM') )) ||' ����� ������������� '||REC.INITIAL_SIZE||' '||REC.Measure||'</td>
            </tr>
          ');
         
      END LOOP;
      
      HTP.PRINT('
      </table>
      '); 
    END IF;
    
    IF vCELL_PLAN_NAME = 'ULTRA VIP 2015 (1400)' THEN  
      HTP.PRINT('
      <h2>� ��� � ��� ����</h2>');
      HTP.PRINT('
      <table>
        <tr>
            <td width="250">��������� ��������  </td>
            <td>��� �����������</td>
        </tr>
        <tr>
            <td width="250">MMS � SMS    </td>
            <td>��� �����������</td>
        </tr>
        <tr>
            <td width="250">������� ������ � ������ �� ������ �� ������  </td>
            <td>��� �����������</td>
        </tr>                    
      </table>
      ');              
    END IF;
    
    --    END IF; ��� �����
     
    HTP.PRINT('
          </br>
          <h2><i>��� ���������� ������� �������: (495) 788-79-08.</i></h2>');
    HTP.PRINT('
        </div>');    
  END IF;
  S_END;
END;
/
