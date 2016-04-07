/* Formatted on 26/12/2014 14:12:13 (QP5 v5.252.13127.32867) */
CREATE OR REPLACE PACKAGE ECOMOBILE_PCKG
AS
   /******************************************************************************
   #VERSION=2
   v/2 - ������� 26.12.2014 �������� ������ �������� ������, ���������� ������ ������ 12 ��������
   v.1 -�������� ������� ����� ��� ������ � ������ ����������
   ******************************************************************************/

   --��������� �������� ���������
   PROCEDURE GetPhones;

   --��������� �������
   PROCEDURE GetPayments (pPHONE IN VARCHAR2);

   --��������� �����������
   PROCEDURE GetDetails;

   --��������� ������������ �� ������������� ������ �� ������������ ������
   FUNCTION GetDetailsByPhone (pYEAR           IN INTEGER,
                               pMONTH          IN INTEGER,
                               pPHONE_NUMBER   IN VARCHAR2)
      RETURN CLOB;
END ECOMOBILE_PCKG;
/
/* Formatted on 26.12.2014 14:04:11 (QP5 v5.252.13127.32867) */
CREATE OR REPLACE PACKAGE BODY ECOMOBILE_PCKG
AS
   /******************************************************************************
   #VERSION=2
   v/2 - ������� 26.12.2014 �������� ������ �������� ������, ���������� ������ ������ 12 ��������
   v.1 -������� ������� ����� ��� ������ � ������ ����������
   ******************************************************************************/

   plogin      VARCHAR2 (30 CHAR);
   pPASSWORD   VARCHAR2 (30 CHAR);                        --����� ��� ��������


   PROCEDURE GetXMLDATA (metod_id     IN     INTEGER,
                         xmldata         OUT XMLTYPE,
                         pPHONE       IN     VARCHAR2 DEFAULT 0,
                         year_month   IN     VARCHAR2 DEFAULT 0)
   IS
      err          VARCHAR2 (1000);
      --
      answer_mes   BLOB;                                            --��������
      --
      FileName     VARCHAR2 (20);
   BEGIN
      err :=
         RUBY_ROBOT_PCKG.create_conn (plogin,
                                      ppassword,
                                      metod_id,
                                      answer_mes,
                                      pPHONE,
                                      year_month);

      FileName :=
         CASE metod_id
            WHEN 92 THEN 'GetPhones'
            WHEN 93 THEN 'GetPayments'
            WHEN 94 THEN 'GetDetails'
         END;

      RUBY_ROBOT_PCKG.create_rpt_log_tbl (
         metod_id,
         225,
         answer_mes,
         'EKOMOBILE_' || FileName || '_FILE');

      SELECT XMLTYPE (answer_mes, NLS_CHARSET_ID ('cl8mswin1251'))
        INTO xmldata
        FROM DUAL;
   END;

   --��������� �������� ���������
   PROCEDURE GetPhones
   IS
      xmldata       XMLTYPE;
      vYEAR_MONTH   INTEGER;
      i             INTEGER;
      j             INTEGER;
   BEGIN
      GetXMLDATA (92, xmldata);

      vYEAR_MONTH := TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMM'));

      DELETE FROM DB_LOADER_ACCOUNT_PHONES AP
            WHERE AP.ACCOUNT_ID = 225 AND AP.YEAR_MONTH = vYEAR_MONTH;

      FOR rec
         IN (SELECT EXTRACTVALUE (VALUE (TA), '*/phone') PHONE_NUMBER,
                    substr(EXTRACTVALUE (VALUE (TA), '*/tarif/name'), 1, 12) code,
                    EXTRACTVALUE (VALUE (TA), '*/status/id') st,
                    VALUE (TA) VALUE_XML
               FROM TABLE (
                       XMLSEQUENCE ( (xmldata).EXTRACT ('response/data/*'))) TA)
      LOOP
         i := i + 1;

         IF rec.st = '10'
         THEN
            j := 0;
         ELSE
            j := 1;
         END IF;

         db_loader_pckg.ADD_ACCOUNT_PHONE (
            TRUNC (vYEAR_MONTH / 100),
            vYEAR_MONTH - TRUNC (vYEAR_MONTH / 100) * 100,
            '���������',
            rec.phone_number,
            j,
            rec.code,
            NULL,
            NULL,
            1,
            0,
            0,
            0);
      END LOOP;

      COMMIT;
   END;


   --��������� �������
   PROCEDURE GetPayments (pPHONE IN VARCHAR2)
   IS
      xmldata      XMLTYPE;
      vURL         VARCHAR2 (500 CHAR);
      vSUM         NUMBER;
      vFILE_NAME   VARCHAR2 (300 CHAR);
   BEGIN
      DELETE FROM ABONENT_BALANCE_ROWS;

      --IF INSTR (vFILE_NAME, pPHONE) > 0
      --THEN
      GetXMLDATA (93, xmldata, pPHONE);

      BEGIN
         FOR rec
            IN (SELECT EXTRACTVALUE (VALUE (TA), '*/phone') PHONE,
                       EXTRACTVALUE (VALUE (TA), '*/agent_date') AGENT_DATE,
                       EXTRACTVALUE (VALUE (TA), '*/sum') SUMMA,
                       EXTRACTVALUE (VALUE (TA), '*/note') NOTE,
                       VALUE (TA) VALUE_XML
                  FROM TABLE (
                          XMLSEQUENCE (
                             (xmldata).EXTRACT ('response/data/*'))) TA)
         LOOP
            IF REC.PHONE IS NOT NULL
            THEN
               BEGIN
                  vSUM := TO_NUMBER (REC.SUMMA);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     vSUM := TO_NUMBER (REPLACE (REC.SUMMA, '.', ','));
               END;

               INSERT
                 INTO ABONENT_BALANCE_ROWS (ROW_DATE, ROW_COST, ROW_COMMENT)
                  VALUES (
                            TO_DATE (SUBSTR (REC.AGENT_DATE, 1, 8),
                                     'YYYYMMDD'),
                            vSUM,
                            REC.NOTE);
            END IF;
         END LOOP;

         COMMIT;
      --      END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            INSERT
              INTO ABONENT_BALANCE_ROWS (ROW_DATE, ROW_COST, ROW_COMMENT)
            VALUES (TRUNC (SYSDATE), 0, '������ ����������.');

            COMMIT;
      END;
   END;

   --��������� �����������
   PROCEDURE GetDetails
   IS
      xmldata       XMLTYPE;
      vYEAR_MONTH   VARCHAR2 (6 CHAR);
      raw_buf       RAW (32767);
      line          VARCHAR2 (1000);
      file_data     BLOB;
      cfile_data    CLOB;
      phone         VARCHAR2 (10);
      Descr         VARCHAR2 (50);
      Sobesednik    VARCHAR2 (20);
   BEGIN
      vYEAR_MONTH := TO_CHAR (SYSDATE, 'YYYYMM');
      DBMS_LOB.createtemporary (file_data, TRUE);

      FOR rec1
         IN (SELECT *
               FROM db_loader_account_phones x
              WHERE     x.account_id = 225
                    AND x.year_month =
                           TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMM'))
                    AND EXISTS
                           (SELECT 1
                              FROM db_loader_account_phone_hists z
                             WHERE     x.PHONE_NUMBER = z.PHONE_NUMBER
                                   AND z.PHONE_IS_ACTIVE = 1
                                   AND z.END_DATE >= SYSDATE - 5))
      LOOP
         GetXMLDATA (94, xmldata, rec1.PHONE_NUMBER);

         FOR rec
            IN (SELECT TO_CHAR (
                          TO_DATE (EXTRACTVALUE (VALUE (TA), '*/date'),
                                   'yyyy-mm-dd'),
                          'dd.mm.yyyy')
                          NDate,
                       EXTRACTVALUE (VALUE (TA), '*/time') NTime,
                       EXTRACTVALUE (VALUE (TA), '*/type') NType,
                       EXTRACTVALUE (VALUE (TA), '*/descr') NDescr,
                       EXTRACTVALUE (VALUE (TA), '*/cost') NSum,
                       EXTRACTVALUE (VALUE (TA), '*/duration') NDuration,
                       EXTRACTVALUE (VALUE (TA), '*/dst_phone') dst_phone,
                       EXTRACTVALUE (VALUE (TA), '*/src_phone') src_phone,
                       EXTRACTVALUE (VALUE (TA), '*/base_station')
                          base_station
                  FROM TABLE (
                          XMLSEQUENCE (
                             (xmldata).EXTRACT ('response/data/*'))) TA)
         LOOP
            --if rec.NSum <> 0 then

            line := NULL;

            IF    INSTR (rec.NDescr, 'SMS') > 0
               OR INSTR (rec.NDescr, '���') > 0
            THEN
               Descr := 'S';
            ELSIF    (INSTR (rec.NDescr, '���') > 0)
                  OR (INSTR (rec.NDescr, '���') > 0)
                  OR (INSTR (rec.NDescr, '��') > 0)
                  OR (INSTR (rec.NDescr, '��') > 0)
            THEN
               Descr := 'C';
            ELSE
               Descr := 'G';
            END IF;


            IF    (INSTR (rec.NType, '���') > 0)
               OR (INSTR (rec.NType, '���') > 0)
            THEN
               Sobesednik := '1' || CHR (09) || rec.dst_phone;
            ELSE
               Sobesednik := '2' || CHR (09) || rec.src_phone;
            END IF;

            line :=
                  Phone
               || CHR (09)
               || rec.NDate
               || CHR (09)
               || rec.NTime
               || CHR (09)
               || Descr
               || CHR (09)
               || Sobesednik
               || CHR (09)
               || (  SUBSTR (rec.NDuration, 4, 2) * 60
                   + SUBSTR (rec.NDuration, 7, 2))
               || CHR (09)
               || rec.NSum
               || CHR (09)
               || CHR (09)
               || CHR (09)
               || rec.NDescr
               || CHR (09)
               || rec.base_station
               || CHR (09)
               || CHR (13)
               || CHR (10);
            raw_buf := UTL_RAW.cast_to_raw (line);
            DBMS_LOB.append (file_data, raw_buf);                     --� blob
         --end if;
         END LOOP;
      END LOOP;

      FOR rec
         IN (SELECT *
               FROM db_loader_account_phones x
              WHERE     x.account_id = 225
                    AND x.year_month = TO_NUMBER (vYEAR_MONTH)
                    AND EXISTS
                           (SELECT 1
                              FROM db_loader_account_phone_hists z
                             WHERE     x.PHONE_NUMBER = z.PHONE_NUMBER --and z.PHONE_IS_ACTIVE = 1
                                   AND z.END_DATE >= SYSDATE - 5)
                    AND NOT EXISTS
                               (SELECT 1
                                  FROM DB_LOADER_PHONE_STAT Z
                                 WHERE     z.ACCOUNT_ID = x.ACCOUNT_ID
                                       AND Z.PHONE_NUMBER = X.PHONE_NUMBER
                                       AND Z.YEAR_MONTH = X.YEAR_MONTH))
      LOOP
         INSERT INTO DB_LOADER_PHONE_STAT (ACCOUNT_ID,
                                           YEAR_MONTH,
                                           PHONE_NUMBER,
                                           ESTIMATE_SUM,
                                           ZEROCOST_OUTCOME_MINUTES,
                                           ZEROCOST_OUTCOME_COUNT,
                                           CALLS_COUNT,
                                           CALLS_MINUTES,
                                           CALLS_COST,
                                           SMS_COUNT,
                                           SMS_COST,
                                           MMS_COUNT,
                                           MMS_COST,
                                           INTERNET_MB,
                                           INTERNET_COST,
                                           LAST_CHECK_DATE_TIME,
                                           COST_CHNG)
              VALUES (rec.ACCOUNT_ID,
                      rec.YEAR_MONTH,
                      rec.PHONE_NUMBER,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      SYSDATE,
                      0);
      END LOOP;

      COMMIT;
   END;

   --��������� ������������ �� ������������� ������ �� ������������ ������
   FUNCTION GetDetailsByPhone (pYEAR           IN INTEGER,
                               pMONTH          IN INTEGER,
                               pPHONE_NUMBER   IN VARCHAR2)
      RETURN CLOB
   IS
      xmldata      XMLTYPE;
      raw_buf      RAW (32767);
      line         VARCHAR2 (1000);
      file_data    BLOB;
      cfile_data   CLOB;

      Descr        VARCHAR2 (50);
      Sobesednik   VARCHAR2 (20);
      year_month   VARCHAR2 (6);
   BEGIN
      DBMS_LOB.createtemporary (file_data, TRUE);

      year_month :=
            pYEAR
         || CASE LENGTH (TO_CHAR (pMONTH))
               WHEN 1 THEN '0' || TO_CHAR (pMONTH)
               ELSE TO_CHAR (pMONTH)
            END;

      GetXMLDATA (94,
                  xmldata,
                  pPHONE_NUMBER,
                  year_month);

      FOR rec
         IN (SELECT TO_CHAR (
                       TO_DATE (EXTRACTVALUE (VALUE (TA), '*/date'),
                                'yyyy-mm-dd'),
                       'dd.mm.yyyy')
                       NDate,
                    EXTRACTVALUE (VALUE (TA), '*/time') NTime,
                    EXTRACTVALUE (VALUE (TA), '*/type') NType,
                    EXTRACTVALUE (VALUE (TA), '*/descr') NDescr,
                    EXTRACTVALUE (VALUE (TA), '*/cost') NSum,
                    EXTRACTVALUE (VALUE (TA), '*/duration') NDuration,
                    EXTRACTVALUE (VALUE (TA), '*/dst_phone') dst_phone,
                    EXTRACTVALUE (VALUE (TA), '*/src_phone') src_phone,
                    EXTRACTVALUE (VALUE (TA), '*/base_station') base_station
               FROM TABLE (
                       XMLSEQUENCE ( (xmldata).EXTRACT ('response/data/*'))) TA)
      LOOP
         --if rec.NSum <> 0 then

         line := NULL;

         IF INSTR (rec.NDescr, 'SMS') > 0 OR INSTR (rec.NDescr, '���') > 0
         THEN
            Descr := 'S';
         ELSIF    (INSTR (rec.NDescr, '���') > 0)
               OR (INSTR (rec.NDescr, '���') > 0)
               OR (INSTR (rec.NDescr, '��') > 0)
               OR (INSTR (rec.NDescr, '��') > 0)
         THEN
            Descr := 'C';
         ELSE
            Descr := 'G';
         END IF;


         IF    (INSTR (rec.NType, '���') > 0)
            OR (INSTR (rec.NType, '���') > 0)
         THEN
            Sobesednik := '1' || CHR (09) || rec.dst_phone;
         ELSE
            Sobesednik := '2' || CHR (09) || rec.src_phone;
         END IF;

         line :=
               pPHONE_NUMBER
            || CHR (09)
            || rec.NDate
            || CHR (09)
            || rec.NTime
            || CHR (09)
            || Descr
            || CHR (09)
            || Sobesednik
            || CHR (09)
            || (  SUBSTR (rec.NDuration, 4, 2) * 60
                + SUBSTR (rec.NDuration, 7, 2))
            || CHR (09)
            || rec.NSum
            || CHR (09)
            || CHR (09)
            || CHR (09)
            || rec.NDescr
            || CHR (09)
            || rec.base_station
            || CHR (09)
            || CHR (13)
            || CHR (10);
         raw_buf := UTL_RAW.cast_to_raw (line);
         DBMS_LOB.append (file_data, raw_buf);                        --� blob
      --end if;
      END LOOP;

      cfile_data := PKG_FILEUTIL.BLOB_TO_CLOB (file_data, -1);

      RETURN cfile_data;
   END;
BEGIN
   plogin := 'gsmcorporacia';
   pPASSWORD := 'sdv4f5gSDjh49ddsPFg';
END ECOMOBILE_PCKG;
/
