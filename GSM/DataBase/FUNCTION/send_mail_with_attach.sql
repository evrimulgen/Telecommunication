CREATE OR REPLACE PROCEDURE send_mail_with_attach (RECIPIENT       IN VARCHAR2,
                                        MESSAGE_TITLE   IN VARCHAR2,
                                        MAIL_TEXT       IN CLOB default NULL,
                                        p_attach_name in varchar2 default null, 
                                        p_attach_blob IN BLOB DEFAULT NULL,
                                        p_attach_mime IN VARCHAR2 DEFAULT NULL
                                        )
AS
   --Vesion#1
   CURSOR C
   IS
      SELECT * FROM SEND_MAIL_PARAMETRES;

   -- ����������, �������������� smtp-����������
   mail_conn     UTL_SMTP.connection;
   nls_charset   VARCHAR2 (200);
   MAIL          C%ROWTYPE;
   k             INTEGER;
   l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
   l_step        PLS_INTEGER  := 12000; -- make sure you set a multiple of 3 not higher than 24573
--s VARCHAR2(24);
--m_title VARCHAR2(1000);
--subject VARCHAR2(1000);
BEGIN
   OPEN C;

   FETCH C INTO MAIL;

   CLOSE C;

   -- ��������� ����������
   mail_conn := UTL_SMTP.open_connection (MAIL.SMTP_SERVER, MAIL.SMTP_PORT);
   -- ������������� ��������� �����
   UTL_SMTP.ehlo (mail_conn, MAIL.SMTP_SERVER);
   --utl_smtp.command(mail_conn, 'STARTTLS');
   UTL_SMTP.command (mail_conn, 'auth login');

   SELECT VALUE
     INTO nls_charset
     FROM nls_database_parameters
    WHERE parameter = 'NLS_CHARACTERSET';

   -- cENCODING_PAGE := 'AL32UTF8';
   -- CodedStr := utl_encode.text_encode('darkelf522', cENCODING_PAGE, utl_encode.base64);
   UTL_SMTP.command ( mail_conn, UTL_ENCODE.text_encode (MAIL.USER_LOGIN, nls_charset, UTL_ENCODE.base64));
   UTL_SMTP.command ( mail_conn, UTL_ENCODE.text_encode (MAIL.USER_PASSWORD, nls_charset, UTL_ENCODE.base64));
   -- ��������� ������ �����������
   UTL_SMTP.mail (mail_conn, MAIL.USER_LOGIN);
   -- ��������� ������ ����������
   UTL_SMTP.rcpt (mail_conn, RECIPIENT);
   -- �������� ������� data, ����� ������� ����� ������ �������� ������
   UTL_SMTP.open_data (mail_conn);
   -- �������� ���������� ������: ����, "��", "����", "����"
   UTL_SMTP.write_data ( mail_conn, 'Subject: ' || encode (MESSAGE_TITLE) || UTL_TCP.crlf);
   UTL_SMTP.write_data ( mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
   UTL_SMTP.write_data ( mail_conn, 'Content-Type: text/html; charset=UTF-8' || UTL_TCP.crlf);
   UTL_SMTP.write_data ( mail_conn, 'Content-Transfer-Encoding: quoted-printable ' || UTL_TCP.CRLF);
   UTL_SMTP.write_data ( mail_conn, 'Date: ' || TO_CHAR (SYSDATE, 'dd.MM.yy hh24:mi:ss', 'NLS_DATE_LANGUAGE = RUSSIAN') || UTL_TCP.crlf);
   UTL_SMTP.write_data ( mail_conn, 'From: ' || MAIL.USER_LOGIN || UTL_TCP.crlf);
   UTL_SMTP.write_data ( mail_conn, 'To: ' || RECIPIENT || UTL_TCP.crlf);
   UTL_SMTP.write_data ( mail_conn, UTL_TCP.crlf);
   -- ����� ������
   
   if MAIL_TEXT is not null then
     k := TRUNC ( (DBMS_LOB.GETLENGTH (MAIL_TEXT) - 1) / 2000);

     FOR i IN 0 .. k
     LOOP
        UTL_SMTP.write_raw_data ( mail_conn,
              UTL_ENCODE.QUOTED_PRINTABLE_ENCODE (
                    UTL_RAW.cast_to_raw ( DBMS_LOB.SUBSTR (MAIL_TEXT, 2000, i * 2000 + 1)
                    )
                  )
          );
     END LOOP;
   end if;
   --application/excel
   IF p_attach_name IS NOT NULL THEN
    UTL_SMTP.write_data(mail_conn, '--' || l_boundary || UTL_TCP.crlf);
    UTL_SMTP.write_data(mail_conn, 'Content-Type: ' || p_attach_mime || '; name="' || p_attach_name || '"' || UTL_TCP.crlf);
    UTL_SMTP.write_data(mail_conn, 'Content-Transfer-Encoding: base64' || UTL_TCP.crlf);
    UTL_SMTP.write_data(mail_conn, 'Content-Disposition: attachment; filename="' || p_attach_name || '"' || UTL_TCP.crlf || UTL_TCP.crlf);

    FOR i IN 0 .. TRUNC((DBMS_LOB.getlength(p_attach_blob) - 1 )/l_step) LOOP
      UTL_SMTP.write_data(mail_conn, UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(DBMS_LOB.substr(p_attach_blob, l_step, i * l_step + 1))));
    END LOOP;

    UTL_SMTP.write_data(mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
  END IF;

   UTL_SMTP.write_data (mail_conn, UTL_TCP.crlf);
   -- �������� ������� � ���������� �������� ���������
   UTL_SMTP.close_data (mail_conn);
   -- ���������� ������ � �������� ���������� � ��������
   UTL_SMTP.quit (mail_conn);
EXCEPTION
   -- ���� ��������� ������ �������� ������, ������� ���������� � �������
   -- ������ �������� ������
   WHEN UTL_SMTP.transient_error OR UTL_SMTP.permanent_error
   THEN
      BEGIN
         UTL_SMTP.quit (mail_conn);
      EXCEPTION
         -- ���� SMTP ������ ����������, ���������� � �������� �����������.
         -- ����� QUIT �������� � ������. ��������� ���������� ���������
         -- ������������ ��� ������.
         WHEN UTL_SMTP.transient_error OR UTL_SMTP.permanent_error
         THEN
            NULL;
      END;

      raise_application_error (
         -20000,
         '������ �������� �����: ' || SQLERRM);
END;
/
