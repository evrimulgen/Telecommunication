CREATE OR REPLACE PROCEDURE AFFIX_RESPNSBL_CRM_REQUEST_UNL IS

    --Version 4.
    --
    --v4. ��������. 01.02.2016. �������� ����������� ����������, ����������� � ����. ��������� 45 �. ������ 31.
    --v3. ��������. ��������� ����� �������������� �� ������ ��� ������� ������������, ��������� ����������� ������
    --v2. ��������. ������� ����� ������������ ��������� ����������� ������ �� �������������
    --v1. ��������. ��������� ���������� ������������� �� ������� �� ������������� �������� � CRM, 
    --�� ������� ������������� ��������� �� ����
    
    pUser_Lust varchar2(30);
    pCount INTEGER;
    pRESPONSIBLE_USER varchar2(30);
    pUser_Create varchar2(30);
    vRes VARCHAR2(50);
BEGIN   
    --��������� ������� ������������ ������������� 
    --��, � ������� �� ��������� 31 ������ �������� ������
    SELECT count(USER_NAME)
    INTO pCount
    FROM USER_NAMES
    WHERE NVL(work_with_ivr, 0) = 1
    AND LAST_ACTIVE is not null
    AND to_date(to_char(LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= ((sysdate+1/24) - (45/24/60/60));

    --���� � ������� ������� ������������ ������������, �� ����� ����� ����� �������� ������������� ������
    IF pCount > 0 THEN
        --�������� ��� ������ �� ������������� (��� - 8), �� ������� ������������� ����������� �� ���� 
        FOR vrec IN (SELECT REQUEST_ID
                           FROM CRM_REQUESTS
                           WHERE TYPE_REQUEST_ID = 8
                           AND RESPONSIBLE_USER is null)
        LOOP
            --�������� ��������� ������� ������������ ������������� 
            --��, � ������� �� ��������� 31 ������ �������� ������
            SELECT count(USER_NAME)
            INTO pCount
            FROM USER_NAMES
            WHERE NVL(work_with_ivr, 0) = 1
            AND LAST_ACTIVE is not null
            AND to_date(to_char(LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= ((sysdate+1/24) - (45/24/60/60));

            --���� ������� ������������ ������������
            IF pCount > 0 THEN               
                --���������� ������������ ��������� ����������� ������ �� ������� (��� 8)
                pUser_Lust := NVL(ms_constants.GET_CONSTANT_VALUE('USER_LAST_CRM_REQUEST_UNLOCK'), '');
                
                --���� ������������ ���, �� ���������� ��� ��. ��������
                IF TRIM(pUser_Lust) = '' THEN
                    --���������� ������������, �� �������� ������� ������ (��� ������������ 864 - Admin)
                    pUser_Create := '';
                    SELECT count(USER_FIO)
                    INTO pCount
                    FROM USER_NAMES
                    WHERE USER_NAME_ID = 864;
                    
                    IF pCount = 1 THEN
                        SELECT USER_FIO
                        INTO pUser_Create
                        FROM USER_NAMES
                        WHERE USER_NAME_ID = 864;
                    END IF;

                    select count(CR.RESPONSIBLE_USER)
                    into pCount
                    from CRM_REQUESTS cr
                    where CR.REQUEST_ID = (
                                                           select max(REQ.REQUEST_ID)
                                                           from CRM_REQUESTS req
                                                           where req.TYPE_REQUEST_ID = 8
                                                           and REQ.USER_CREATED = pUser_Create
                                                           and exists
                                                                            (
                                                                                select 1
                                                                                from USER_NAMES us
                                                                                where US.USER_NAME = REQ.RESPONSIBLE_USER
                                                                                and NVL(us.work_with_ivr, 0) = 1
                                                                            ) 
                                                          );
                        
                    IF pCount = 1 THEN                                       
                      select NVL(CR.RESPONSIBLE_USER, '')
                      into pUser_Lust
                      from CRM_REQUESTS cr
                      where CR.REQUEST_ID = (
                                                              select max(REQ.REQUEST_ID)
                                                              from CRM_REQUESTS req
                                                              where req.TYPE_REQUEST_ID = 8
                                                              and REQ.USER_CREATED = pUser_Create
                                                              and exists
                                                                               (
                                                                                   select 1
                                                                                   from USER_NAMES us
                                                                                   where US.USER_NAME = REQ.RESPONSIBLE_USER
                                                                                   and NVL(us.work_with_ivr, 0) = 1
                                                                               ) 
                                                            );
                    END IF;  
                END IF;
                
                --���� pUser_Lust ������, �� ����� ������������� ID
                IF TRIM(pUser_Lust) = '' THEN
                    BEGIN
                        SELECT USER_NAME
                        INTO pRESPONSIBLE_USER
                        FROM USER_NAMES
                        WHERE NVL(work_with_ivr, 0) = 1
                        AND LAST_ACTIVE is not null
                        AND to_date(to_char(LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= ((sysdate+1/24) - (45/24/60/60))
                        and USER_NAME_ID = (SELECT MAX(us.USER_NAME_ID)
                                                          FROM USER_NAMES us
                                                          WHERE NVL(us.work_with_ivr, 0) = 1
                                                          AND us.LAST_ACTIVE is not null
                                                          AND to_date(to_char(us.LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= ((sysdate+1/24) - (45/24/60/60)));
                    EXCEPTION
                        WHEN OTHERS THEN
                            NULL;   
                    END;                                    
                ELSE
                    --��������� ������� ������������� 
                    SELECT count(USER_NAME)
                    INTO pCount
                    FROM USER_NAMES
                    WHERE NVL(work_with_ivr, 0) = 1
                    AND LAST_ACTIVE is not null
                    AND to_date(to_char(LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= ((sysdate+1/24) - (45/24/60/60))
                    and USER_NAME_ID < (SELECT USER_NAME_ID
                                                       FROM USER_NAMES
                                                       WHERE USER_NAME = pUser_Lust)
                    ORDER BY USER_NAME_ID desc;
                    
                    IF pCount > 0 THEN
                        BEGIN
                            SELECT USER_NAME
                            INTO pRESPONSIBLE_USER
                            FROM
                            (SELECT USER_NAME
                             FROM USER_NAMES
                             WHERE NVL(work_with_ivr, 0) = 1
                             AND LAST_ACTIVE is not null
                             AND to_date(to_char(LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= ((sysdate+1/24) - (45/24/60/60))
                             and USER_NAME_ID < (SELECT USER_NAME_ID
                                                                FROM USER_NAMES
                                                                WHERE USER_NAME = pUser_Lust)
                             ORDER BY USER_NAME_ID desc)
                            WHERE ROWNUM = 1;
                        EXCEPTION
                            WHEN OTHERS THEN
                                NULL;  
                        END;
                    ELSE
                        BEGIN
                            --������������� �� �������������
                            SELECT USER_NAME
                            INTO pRESPONSIBLE_USER
                            FROM USER_NAMES
                            WHERE NVL(work_with_ivr, 0) = 1
                            AND LAST_ACTIVE is not null
                            AND to_date(to_char(LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= ((sysdate+1/24) - (45/24/60/60))
                            and USER_NAME_ID = (SELECT MAX(us.USER_NAME_ID)
                                                               FROM USER_NAMES us
                                                              WHERE NVL(us.work_with_ivr, 0) = 1
                                                              AND us.LAST_ACTIVE is not null
                                                             AND to_date(to_char(us.LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= ((sysdate+1/24) - (45/24/60/60)));
                        EXCEPTION
                            WHEN OTHERS THEN
                                NULL;  
                        END;
                    END IF;
                END IF;
                
                --��������� ������������ � ������� ��������
                vRes := ms_constants.SET_CONSTANT_VALUE('USER_LAST_CRM_REQUEST_UNLOCK', pRESPONSIBLE_USER);
                --��������� ������ � CRM
                UPDATE CRM_REQUESTS
                SET RESPONSIBLE_USER  = pRESPONSIBLE_USER
                WHERE REQUEST_ID = vrec.REQUEST_ID;
                COMMIT;
            END IF;
        END LOOP;
    END IF;
END;