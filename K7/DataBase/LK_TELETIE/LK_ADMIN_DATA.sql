GRANT UNLIMITED TABLESPACE TO CORP_MOBILE_LK;

CREATE TABLE CORP_MOBILE_LK.LK_ADMIN_DATA (
  ID INTEGER CONSTRAINT PK_LK_ADMIN_DATA PRIMARY KEY,
  MAIN_ADVERT_HTML CLOB,
  COLUMN_ADVERT_HTML CLOB
);

INSERT INTO CORP_MOBILE_LK.LK_ADMIN_DATA (
  ID,
  MAIN_ADVERT_HTML,
  COLUMN_ADVERT_HTML
) VALUES (
  1,
'<div class="sel" id="pbg_1">
                    <img alt="" src="http://teletie.ru/content/e2dmt5ixcwg_661x302_.jpg">
                    <h2><span>������������� ���-�����:<br>��������'||'&'||'nbsp;'||'&'||'mdash; ���������,<br>���������'||'&'||'nbsp;'||'&'||'mdash; ��'||'&'||'nbsp;0,19 �.�.</span></h2>
                    <a class="btn" href="/plans/roaming/"><span>������� �����</span></a>
                </div>',
    '������ ������� - ����������!'
    );

COMMIT;
