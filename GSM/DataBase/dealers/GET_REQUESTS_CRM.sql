CREATE OR REPLACE PROCEDURE GET_REQUESTS_CRM
(
  pPHONE varchar2,
  pDOP_PHONE varchar2 DEFAULT NULL
)
-- version 5
--
--v.5 ��������. 01.02.2016. �������� �������� �����������, ����������, ����������� � ����. ������ 31 � ��������� 45.
--v4. ��������. ��������� ����� �������������� �� ������ ��� ������� ������������, ��������� ����������� ������
--v3. ��������. ��������� ����� ������������ ��������� ����������� ������ �� ������� (��� 8). ������ �������� �� �������������� ������� � 30 �. �� 31�.
--v2. ��������. ���� � ������� CRM ����������� ������������ ������������, �� � ������ ������������� �� �����������
-- v1. �����: �������� �.
-- ��������� �������������� � IVR (��������� �����). ��������� ��� ��� ������ � ������������ ��������� ���������� ������ � CRM �� ������������� ������������
--� CRM �������� ������ �� ������������� ������ (�����: ���� ������ �������)
IS 
  vRES VARCHAR2(1000 CHAR);
  pTxt varchar2(100);
  pRESPONSIBLE_USER varchar2(30);
  pUser_Lust varchar2(30);
  pUser_Create varchar2(30);
  pOPERATOR varchar2(50);
  pCount INTEGER;
BEGIN
  BEGIN 
    --����� ������ �� �������
    pTxt := '������ �������������� ����� '||pPHONE||'.'; 
    
    --���� OPERATOR
    pOPERATOR := '';
    SELECT count(op.LOADER_SCRIPT_NAME)
    INTO pCount
    FROM OPERATORS op
    WHERE op.OPERATOR_ID = 3; --������
    
    IF pCount = 1 THEN
      SELECT LOADER_SCRIPT_NAME
      INTO pOPERATOR
      FROM OPERATORS
      WHERE OPERATOR_ID = 3; --������
    END IF;
    
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
    
    --���������� ������������ ��������� ����������� ������ �� ������� (��� 8)
    pUser_Lust := NVL(ms_constants.GET_CONSTANT_VALUE('USER_LAST_CRM_REQUEST_UNLOCK'), '');
    
    IF TRIM(pUser_Lust) = '' THEN
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
    
    --��������� ������� ������������ ������������� 
    --��, � ������� �� ��������� 30 ������ �������� ������
    SELECT count(USER_NAME)
    INTO pCount
    FROM USER_NAMES
    WHERE NVL(work_with_ivr, 0) = 1
    AND LAST_ACTIVE is not null
    AND to_date(to_char(LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') >= ((sysdate+1/24) - (45/24/60/60));
    
    pRESPONSIBLE_USER := ''; --�������������
    --���� ������� ������������ ������������
    IF pCount > 0 THEN
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
            HTP.PRINT('Error! ��� ���������� ������� �������� ������!');   
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
              HTP.PRINT('Error! ��� ���������� ������� �������� ������!');  
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
              HTP.PRINT('Error! ��� ���������� ������� �������� ������!');  
          END;
        END IF;
      END IF;
    END IF;
    
    --������� ������ � CRM
    INSERT INTO CRM_REQUESTS 
    (
       PHONE_NUMBER, --����� ��������
       ID_STATUS_REQUEST, --ID ������� �������
       DATE_CREATED, --���� ��������
       USER_CREATED, ---������������, ��������� 
       RESPONSIBLE_USER, --������������ ������������
       TYPE_REQUEST_ID, --ID ���� �������
       DOP_CONTACT, --�������������� �������
       DEADLINE_DATE, --������� ����
       OPERATOR, --��������  
       TEXT_REQUEST --����� �������(���� clob)
    ) 
    VALUES
    (
       pPHONE, --����� �� �������
       1, --������ - ����� 
       sysdate, 
       pUser_Create, 
       pRESPONSIBLE_USER, 
       8, --������ �� �������������
       pDOP_PHONE, 
       trunc(sysdate + 1), 
       pOPERATOR, 
       to_clob(pTxt)
    ) ;
    --��������� ������������ � ������� ��������
    vRes := ms_constants.SET_CONSTANT_VALUE('USER_LAST_CRM_REQUEST_UNLOCK', pRESPONSIBLE_USER);   
    COMMIT;
    --������� ����� 
    HTP.PRINT('���� ������ �������.');   
  EXCEPTION 
    WHEN OTHERS THEN
      HTP.PRINT('Error! ��� ���������� ������� �������� ������!');    
  END;        
END;