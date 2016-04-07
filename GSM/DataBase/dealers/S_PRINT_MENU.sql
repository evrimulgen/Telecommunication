CREATE OR REPLACE PROCEDURE WWW_DEALER.S_PRINT_MENU IS
--#Version=2
-- v2. ������� �. 2015.06.17 - ��������� ����� ������� � �������� ��������� "%��" - �������� ������������ �� �������. 
  vPAGE_NAME VARCHAR2(40);
  vURL VARCHAR2(250 CHAR);
--
  PROCEDURE PRINT_MENU_ITEM(
    pURL IN VARCHAR2,
    pTEXT IN VARCHAR2,
    pPAGE_NAME IN VARCHAR2,
    pADD_TEXT IN VARCHAR2 DEFAULT NULL,
    pTITLE IN VARCHAR2 DEFAULT NULL
    ) IS
  BEGIN
    IF vPAGE_NAME = pURL OR '!'||vPAGE_NAME= pURL THEN
      HTP.PRINT('
        <span class="left" id="active_tab"><span>'||pTEXT||'</span></span>');
    ELSE
      HTP.PRINT('
        <a href="'||pURL||'?' ||G_STATE.SESSION_KEY_PARAM_1 || '" title="'||NVL(pTITLE, pTEXT)||'" class="left">'||pADD_TEXT||pTEXT||'</a>');
    END IF;
  END;
--
BEGIN
  HTP.PRINT('
    <div id="tab_menu2"></div>
      <div id="main">
        <div id="tab_menu">');      
  vPAGE_NAME := HTF.ESCAPE_URL(LOWER(SUBSTR(OWA_UTIL.GET_CGI_ENV('PATH_INFO'), 2)));
  IF SUBSTR(vPAGE_NAME, 1, 1) = '!' THEN
    vPAGE_NAME := SUBSTR(vPAGE_NAME, 2);
  END IF;              
  IF SUBSTR(vPAGE_NAME, LENGTH(vPAGE_NAME), 1) = '/' THEN
    vPAGE_NAME := SUBSTR(vPAGE_NAME, 1, LENGTH(vPAGE_NAME)-1);
  END IF;  
  --IF (vPAGE_NAME='main') AND (G_STATE.USER_ID IS NULL) THEN
  --  vPAGE_NAME:='';
  --END IF;
  --htp.print(G_STATE.IS_ADMIN);
  IF G_STATE.USER_ID IS NOT NULL THEN
    IF G_STATE.IS_ADMIN = 1 THEN 
      PRINT_MENU_ITEM('main', '�������', vPAGE_NAME);
      --PRINT_MENU_ITEM('admin_messages', '�������', vPAGE_NAME); -- ������� ������ ����������, �������� ��������, ������ ��� �� ����
      --PRINT_MENU_ITEM('admin_logs', '��� ��������', vPAGE_NAME); -- ���������� �� ������ ��������
      PRINT_MENU_ITEM('admin_summary_logs', '������ ��������', vPAGE_NAME);
      PRINT_MENU_ITEM('admin_user_list', '������������', vPAGE_NAME);
      PRINT_MENU_ITEM('admin_news', '������� (�����)', vPAGE_NAME);
      PRINT_MENU_ITEM('admin_faq', '����', vPAGE_NAME);
      PRINT_MENU_ITEM('ADMIN_TARIFF_ORDER_LIST', '������', vPAGE_NAME);
      PRINT_MENU_ITEM('ADMIN_DELIVERY_TYPE_LIST', '��. ��������', vPAGE_NAME, null, '������� ��������');
      PRINT_MENU_ITEM('ADMIN_OPTIONS_SIM_CARD_ORDER', '����� SIM', vPAGE_NAME, null, '����� ���-����');
    ELSIF G_STATE.IS_MANAGER = 1 THEN
      PRINT_MENU_ITEM('main', '�������', vPAGE_NAME);
      --PRINT_MENU_ITEM('store', '����� GSM', vPAGE_NAME);
      PRINT_MENU_ITEM('my_store2', '��� �����', vPAGE_NAME);
      PRINT_MENU_ITEM('my_bonuses', '�������', vPAGE_NAME, null, '������ ��������������, ������� ��������� ������������ ������� ���������� �� ����');
      PRINT_MENU_ITEM('my_pays', '�������', vPAGE_NAME, null, '������ ������, ������� ���� ����������� ������������ ������� ���������� �� ����');
      PRINT_MENU_ITEM('my_balance_changes', '������', vPAGE_NAME);
      PRINT_MENU_ITEM('contragent_balances', '�����-�', vPAGE_NAME, NULL, '������ ������������, ������� ���������� �� ���� � ��������� �������');      
      PRINT_MENU_ITEM('!contragent_percents', '%��', vPAGE_NAME, NULL, '�������� �� ����������');
      PRINT_MENU_ITEM('!tariff_percents', '%��', vPAGE_NAME, NULL, '�������� �� �������');
      PRINT_MENU_ITEM('!contragent_tatriff_percents', '%��', vPAGE_NAME, NULL, '�������� ������������ �� �������');
      --PRINT_MENU_ITEM('messages', '������', vPAGE_NAME, 
          --'<span id="contragent_new_messages" style="display:none;" title="���� ������������� ���������">! </span>');
      PRINT_MENU_ITEM('!CONTRAGENT_NEW_SIM_CARD_ORD', '����� SIM', vPAGE_NAME); --CONTRAGENT_NEW_SIM_CARD_ORD  CONTRAGENT_SIM_CARD_ORDERS
      
      PRINT_MENU_ITEM('contragent_edit_user', '������', vPAGE_NAME);
      
      --HTP.PRINT('
      --<script>
      --   IntervalIDCheckNewMessages = self.setInterval("ContragentCheckNewMessages('||G_STATE.USER_ID||');", 3000);
      --</script>');     
      
    ELSIF G_STATE.IS_CONTRAGENT = 1 THEN
      PRINT_MENU_ITEM('main', '�������', vPAGE_NAME);
      PRINT_MENU_ITEM('store', '����� GSM', vPAGE_NAME);
      PRINT_MENU_ITEM('my_store2', '��� �����', vPAGE_NAME);
      PRINT_MENU_ITEM('my_bonuses', '�������', vPAGE_NAME);
      PRINT_MENU_ITEM('my_pays', '�������', vPAGE_NAME);
      PRINT_MENU_ITEM('my_balance_changes', '������', vPAGE_NAME);
      PRINT_MENU_ITEM('messages', '������', vPAGE_NAME 
        , /*'<img id="contragent_new_messages" style="display : none;" src="IMG_NEW_MESSAGE" title="���� ������������� ���������" alt="���� ������������� ���������">'*/
          '<span id="contragent_new_messages" style="display:none;" title="���� ������������� ���������">! </span>'
        );
      PRINT_MENU_ITEM('contragent_edit_user', '����� ������', vPAGE_NAME);
      
      PRINT_MENU_ITEM('!CONTRAGENT_NEW_SIM_CARD_ORD', '����� SIM', vPAGE_NAME);
      
      HTP.PRINT('        
      <script>
         IntervalIDCheckNewMessages = self.setInterval("ContragentCheckNewMessages('||G_STATE.USER_ID||');", 3000);
      </script>');     
      
    ELSE
      PRINT_MENU_ITEM('main', /*S_GET_USER_DESCRIPTION(G_STATE.USER_ID)*/ '������ �������', vPAGE_NAME);
      PRINT_MENU_ITEM('activations', '���������� ���������', vPAGE_NAME);
      PRINT_MENU_ITEM('status_changes', '���������� ��������� ��������', vPAGE_NAME);
      PRINT_MENU_ITEM('OPERATOR_SIM_CARD_ORDERS', '���������� ������', vPAGE_NAME);
      
    END IF; 
    
    vURL := 'h_' || vPAGE_NAME || CASE UPPER(vPAGE_NAME) WHEN 'MAIN' THEN '?SESSION_ID='||G_STATE.SESSION_ID||'' ELSE '' END ||'';
    HTP.PRINT('
        <a href="main?' ||G_STATE.SESSION_KEY_PARAM_1 || '&' || 'amp;close_session=1" title="���������� ���������� ������" id="exit_link" class="right">�����</a>
        <a href="'||vURL||'" onclick="var url='''||vURL||''';
          window.open(url, ''_blank'', ''toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes'');
          return false;" title="�������" id="help_link" class="right">������</a>
      </div>');
      
    IF G_STATE.IS_CONTRAGENT = 1 THEN
      HTP.PRINT('<div id="support_info">�� �������� ���������� ������������: <b>8-903-778-74-63</b> ��������� <b>8-964-556-82-23</b>. 
                      <img src="http://wwp.icq.com/scripts/online.dll?icq=252072858&'||'img=5" border="0" /> ICQ: <b>607-290-902</b></div>');
    END IF;
  ELSE
    HTP.PRINT('
        <!--<a title="" class="left">������ ��������</a>
        <a title="" class="left">����������� �������</a>
        <a title="" class="left">�����������</a>
        <a title="" class="left">���������� ��������</a>-->
        <span title="���������� ���������� ������" id="exit_link" class="right">�����</span>
        <a href="h_main_nologin" onclick="var url=''h_main_nologin'';
          window.open(url, ''_blank'', ''toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes'');
          return false;" title="�������" id="help_link" class="right">������</a>
      </div>');
  END IF;
END;
/
