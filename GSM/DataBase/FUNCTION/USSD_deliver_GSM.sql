CREATE OR REPLACE FUNCTION USSD_deliver(responset        IN VARCHAR2, --��������� ���� ��������
                                        msisdnt          IN VARCHAR2, --MSISDN ��������
                                        service          IN VARCHAR2, --��������� ���, ������������ ��� ������
                                        location         IN VARCHAR2, --���� ���� �������� ��������� ��� �������� USSD �����.
                                        lang             IN VARCHAR2, --������������� �����. ������� �� �������� USSDC. ��������� �������� - ru|tr|en.
                                        ussdt            IN VARCHAR2, --�������������� ���� ��������.
                                        XCPAXActiont     IN VARCHAR2, --������������� ����������
                                        XCPAMSGIDt       IN VARCHAR2, --������������� �����. ��� �������� ���� deliver ��� ������������� ��� �����, ������� ����� ��������� � ������. ����� ��� ������� ����� � �����������.
                                        XCPAUSSDSessiont out VARCHAR2, --������� ����������� ������. ���� �������� yes, �� ����� ������ ���� � ������������ ������.
                                        HTTP_ANSWER      out VARCHAR2)
   RETURN VARCHAR2 IS
  ussdtt             VARCHAR2(2000);
  PAR                VARCHAR2(2000);
  RES                VARCHAR2(200);
  SQL_text           VARCHAR2(200);
  SQL_text_ASF       VARCHAR2(100);
  SQL_text_ASE       VARCHAR2(100);
  ussd_text          VARCHAR2(200);
  ussd_cur_date      date;
  rowid_USSD_CURRENT rowid;
  id_ussd            integer;
  new_id_ussd        integer;
  flag               integer;
  flag1              integer;
  pcount             integer;

  --#Version=1
BEGIN
  select substr(ussdt,
                1,
                decode(instr(ussdt, '*', 1, 3),
                       0,
                       length(ussdt),
                       instr(ussdt, '*', 1, 3)) - 1) || '#'
    into ussdtt
    from dual;
  id_ussd       := 0;
  ussd_cur_date := sysdate;
  new_id_ussd   := 0;
  SQL_text_ASF  := 'alter session set cursor_sharing=force';
  SQL_text_ASE  := 'alter session set cursor_sharing=exact';
  --execute immediate SQL_text_AS;
  SQL_text := '';
   select count(*)
    into flag1
    from ussd_leafs ul
   where ul.ussd = ussdtt
     and ul.check_number = 0;
  select count(*)
    into flag
    from db_loader_account_phones dp
   where dp.phone_number = substr(msisdnt, -10);
  if flag > 0 or flag1 > 0 then
    begin
      select uc.rowid, uc.id, uc.update_date
        into rowid_USSD_CURRENT, id_ussd, ussd_cur_date
        from USSD_CURRENT uc
       where uc.xcpaxaction = XCPAXActiont
         and uc.msisdn = substr(msisdnt, -10);
      begin
        select convert(decode(lang, 'tr', ul.text_tr, 'en', ul.text_en, ul.text_ru),'UTF8'),
               ul.sql_t,
               decode(ul.ussd_end, 1, 'no', 'yes'),
               ut.id
          into res, SQL_text, XCPAUSSDSessiont, new_id_ussd
          from ussd_tree ut, ussd_leafs ul
         where ut.parent_id = id_ussd
           and ul.leaf_id = ut.leaf_id
           and ul.response = responset;
        HTTP_ANSWER := '200 Ok!';
        if SQL_text is not null then
          begin
            execute immediate SQL_text_ASF;
            SQL_text := REPLACE(SQL_text,
                                '%MSISDN%',
                                '''' || substr(msisdnt, -10) || '''');
            SELECT LENGTH(ussdt) - LENGTH(REPLACE(ussdt, '*'))
              into pcount
              FROM dual;
            for i in 3 .. pcount LOOP
              SELECT substr(ussdt,
                            instr(ussdt, '*', 1, i) + 1,
                            decode(instr(ussdt, '*', 1, i + 1),
                                   0,
                                   length(ussdt) - instr(ussdt, '*', 1, i) - 1,
                                   instr(ussdt, '*', 1, i + 1) -
                                   instr(ussdt, '*', 1, i) - 1))
                into PAR
                FROM dual;
              SQL_text := REPLACE(SQL_text,
                                  '%PAR' || to_char(i - 2) || '%',
                                  '''' || PAR || '''');
            END LOOP;
            execute immediate SQL_text
              into ussd_text;
            execute immediate SQL_text_ASE;
            res := REPLACE(res, '%USSD_TEXT%', ussd_text);
          exception
            when others then
              HTTP_ANSWER := '500 Error on the server side, partner!';
              res         := '������ �� ������� ������� ��������!';
          end;
        end if;
        IF (MS_CONSTANTS.GET_CONSTANT_VALUE('USSD_LOG_LEVEL') = '2') and
           (HTTP_ANSWER = '200 Ok!') and (XCPAUSSDSessiont = 'yes') then
          insert into ussd_log
            (id,
             xcpaxaction,
             xcpamsgid,
             ussd_date,
             msisdn,
             error_text,
             ussd,
             text_res,
             TYPE_LOG)
          values
            (id_ussd,
             XCPAXActiont,
             XCPAMSGIDt,
             ussd_cur_date,
             substr(msisdnt, -10),
             'response: ' || responset || ' new_id_ussd: ' || new_id_ussd || res,
             ussdt,
             res,
             1);
        end if;
        update USSD_CURRENT ucc
           set ucc.id              = new_id_ussd,
               ucc.xcpamsgid       = XCPAMSGIDt,
               ucc.xcpaussdsession = XCPAUSSDSessiont
         where ucc.rowid = rowid_USSD_CURRENT;
        commit;
      exception
        when others then
          HTTP_ANSWER := '556 Invalid request!';
          res         := '������������ ������!';
      end;
    exception
      when others then
        begin
          select

           decode(lang,
                        'tr',
                        ul.text_tr,
                        'en',
                        ul.text_en,
                        ul.text_ru)

                        ,
                 ul.sql_t,
                 decode(ul.ussd_end, 1, 'no', 'yes'),
                 ut.id
            into res, SQL_text, XCPAUSSDSessiont, new_id_ussd
            from ussd_tree ut, ussd_leafs ul
           where ul.ussd = ussdtt
             and ul.leaf_id = ut.leaf_id
             and ul.ussd_lvl = 1;
          HTTP_ANSWER := '200 Ok!';
          if SQL_text is not null then

            begin
              execute immediate SQL_text_ASF;
              SQL_text := REPLACE(SQL_text,
                                  '%MSISDN%',
                                  '''' || substr(msisdnt, -10) || '''');
              SELECT LENGTH(ussdt) - LENGTH(REPLACE(ussdt, '*'))
                into pcount
                FROM dual;
              for i in 3 .. pcount LOOP
                SELECT substr(ussdt,
                              instr(ussdt, '*', 1, i) + 1,
                              decode(instr(ussdt, '*', 1, i + 1),
                                     0,
                                     length(ussdt) - instr(ussdt, '*', 1, i) - 1,
                                     instr(ussdt, '*', 1, i + 1) -
                                     instr(ussdt, '*', 1, i) - 1))
                  into PAR
                  FROM dual;
                SQL_text := REPLACE(SQL_text,
                                    '%PAR' || to_char(i - 2) || '%',
                                    '''' || PAR || '''');
              END LOOP;
              execute immediate SQL_text
                into ussd_text;
              execute immediate SQL_text_ASE;
              res := REPLACE(res, '%USSD_TEXT%', ussd_text);
            exception
              when others then
                HTTP_ANSWER := '500 Error on the server side, partner!';
                res         := '������ �� ������� ������� ��������!';
            end;
          end if;
          IF (MS_CONSTANTS.GET_CONSTANT_VALUE('USSD_LOG_LEVEL') = '2') and
             (HTTP_ANSWER = '200 Ok!') and (XCPAUSSDSessiont = 'yes') then
            insert into ussd_log
              (id,
               xcpaxaction,
               xcpamsgid,
               ussd_date,
               msisdn,
               error_text,
               ussd,
               text_res,
               TYPE_LOG)
            values
              (id_ussd,
               XCPAXActiont,
               XCPAMSGIDt,
               ussd_cur_date,
               substr(msisdnt, -10),
               'new_id_ussd: ' || new_id_ussd || ' ' || res,
               ussdt,
               res,
               1);
          end if;
          insert into USSD_CURRENT
            (ID, XCPAXACTION, XCPAMSGID, MSISDN, XCPAUSSDSESSION)
          values
            (new_id_ussd,
             XCPAXActiont,
             XCPAMSGIDt,
             substr(msisdnt, -10),
             XCPAUSSDSessiont);
          commit;
        exception
          when others then
            HTTP_ANSWER := '556 Invalid request!';
            res         := '������������ ������ !';
        end;
    end;
  else
    HTTP_ANSWER := '556 Invalid request!';
    res         := '������������ ������ !';
  end if;
  IF ((MS_CONSTANTS.GET_CONSTANT_VALUE('USSD_LOG_LEVEL') = '2') or
     (MS_CONSTANTS.GET_CONSTANT_VALUE('USSD_LOG_LEVEL') = '1')) and
     ((HTTP_ANSWER <> '200 Ok!') or (XCPAUSSDSessiont = 'no')) then
    insert into ussd_log
      (id,
       xcpaxaction,
       xcpamsgid,
       ussd_date,
       msisdn,
       error_text,
       ussd,
       text_res,
       TYPE_LOG)
    values
      (id_ussd,
       XCPAXActiont,
       XCPAMSGIDt,
       ussd_cur_date,
       substr(msisdnt, -10),
       'response: ' || responset || ' new_id_ussd: ' || new_id_ussd ||
       ' HTTP_ANSWER: ' || HTTP_ANSWER || ' USSD: ' || USSDtt || ' ' || res,
       ussdt,
       res,
       1);
    commit;
  end if;
  RES:= sys.utl_url.escape(url => RES,
                                url_charset => 'CL8MSWIN1251');
  RETURN RES;
EXCEPTION
  WHEN others THEN
    HTTP_ANSWER := '500 Error on the server side, partner!';
    res         := '������ �� ������� ������� ��������!';
  RES:= sys.utl_url.escape(url => RES,
                                url_charset => 'CL8MSWIN1251');
    RETURN RES;
END;
