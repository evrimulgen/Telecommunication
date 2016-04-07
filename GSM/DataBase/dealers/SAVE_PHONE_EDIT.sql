CREATE OR REPLACE PROCEDURE SAVE_PHONE_EDIT(
  SESSION_ID IN VARCHAR2 DEFAULT NULL,
  pUSER_ID IN VARCHAR2 DEFAULT NULL,
  pPHONE_NUMBER_ID VARCHAR2 DEFAULT NULL,   
  --pPHONE_NUMBER VARCHAR2 DEFAULT NULL,
  --pPRICE NUMBER DEFAULT NULL,
  SUBMIT_PHONE_EDIT VARCHAR2 DEFAULT NULL,
  pSIM_NUMBER1 VARCHAR2 DEFAULT NULL,
  pSIM_NUMBER2 VARCHAR2 DEFAULT NULL,
  pTARIFF_ID VARCHAR2 DEFAULT NULL,
  pSTATUS_ID INTEGER DEFAULT NULL,
  pCODE_WORD VARCHAR2 DEFAULT NULL,
  pSURNAME VARCHAR2 DEFAULT NULL,      
  pNAME VARCHAR2 DEFAULT NULL,      
  pPATRONYMIC VARCHAR2 DEFAULT NULL,      
  pBDATE VARCHAR2 DEFAULT NULL,      
  pPASSPORT_SER_NUM VARCHAR2 DEFAULT NULL,      
  pPASSPORT_DATE VARCHAR2 DEFAULT NULL,      
  pPASSPORT_GET VARCHAR2 DEFAULT NULL,      
  pCONTACT_PHONE VARCHAR2 DEFAULT NULL,      
  pMAIL VARCHAR2 DEFAULT NULL,      
  pREGISTRATION VARCHAR2 DEFAULT NULL,
  pDELIVER_ADDRESS VARCHAR2 DEFAULT NULL,      
  pDELIVER_CONTACT VARCHAR2 DEFAULT NULL,      
  pDELIVER_CONTACT_PHONE VARCHAR2 DEFAULT NULL,
  pCOMMENTS VARCHAR2 DEFAULT NULL,
  pDELIVER_STARTED VARCHAR2 DEFAULT NULL,
  pHLR VARCHAR2 DEFAULT NULL
  ) IS
-- 
--version=2
-- v2 - 16.11.2015. - ������� �. �� ������� ���������� ������ �������� �� �������� �������� HLR. http://redmine.tarifer.ru/issues/3646

  CURSOR CUR IS 
    SELECT T.TARIFF_NAME, ST.STATUS_NAME, ST.STATUS_CODE,
           PH.*,
           OP.SIM_NUMBER_PREFIX, OP.SIM_NUMBER2_LENGTH
      FROM D_PHONE_NUMBERS PH, D_TARIFFS T, D_STATUSES ST, D_OPERATORS OP
     WHERE PH.PHONE_NUMBER_ID = pPHONE_NUMBER_ID
       AND PH.TARIFF_ID = T.TARIFF_ID (+)
       AND PH.STATUS_ID = ST.STATUS_ID (+)
       AND PH.OPERATOR_ID = OP.OPERATOR_ID (+);
  REC CUR%ROWTYPE;   
--  sim �����, �����, ������� �����, ���������� ������, �������� �������� ��������.
  vDATE DATE;      
  vDATELU DATE;
  vDELIVER_STARTED DATE;
  vERROR_MESSAGE VARCHAR2(2000 CHAR);
  vUSER_ID INTEGER;
  vHLR VARCHAR2(10 CHAR);
  vOUT_ERROR VARCHAR2(1000);
  vMAIL VARCHAR2(32000);
  vPHONE_NUMBER VARCHAR2(20);
BEGIN
  --IF (USER_ID IS NOT NULL) THEN
    IF (pPHONE_NUMBER_ID IS NULL) THEN
      vERROR_MESSAGE := '���������� ����� �� ���������. ���������� �� ��������.';
    ELSE
      OPEN CUR;
      FETCH CUR INTO REC;
      IF CUR%NOTFOUND THEN
        vERROR_MESSAGE := '�� ������� �������� � ����� '||TO_CHAR(pPHONE_NUMBER_ID);
      END IF;
      CLOSE CUR;
      
      IF vERROR_MESSAGE IS NULL THEN
        BEGIN
          IF vERROR_MESSAGE IS NULL AND 
            (
              (REC.STATUS_ID = GET_STATUS_OPTIONS_ID('ACTIVATED'))
              OR
              (REC.STATUS_ID = GET_STATUS_OPTIONS_ID('ACTIVATED_1C'))
              OR
              (REC.STATUS_ID = GET_STATUS_OPTIONS_ID('LINKED'))
              OR
              (REC.STATUS_ID = GET_STATUS_OPTIONS_ID('LINKED_1C'))
            ) 
          THEN
            vERROR_MESSAGE := '������ ���������� ������ ! ����� ��� �����������/����������, �������� ��������� � ���� �� �����������.';
          END IF;  
        
          IF vERROR_MESSAGE IS NULL THEN
            BEGIN
              vDATE := TO_DATE(pBDATE, 'DD.MM.YYYY'); 
            EXCEPTION WHEN OTHERS THEN
              vERROR_MESSAGE := '������ ���������� ������ ! ���� �������� � ������ ���� � ������� DD.MM.YYYY HH24:MI:SS ('||pBDATE||')';
            END;
          END IF;
            
          IF vERROR_MESSAGE IS NULL THEN
            BEGIN
              vDATE := TO_DATE(pPASSPORT_DATE, 'DD.MM.YYYY'); 
            EXCEPTION WHEN OTHERS THEN
              vERROR_MESSAGE := '������ ���������� ������ ! ���� ������ �������� ������ ���� � ������� DD.MM.YYYY HH24:MI:SS ('||pPASSPORT_DATE||')';
            END;
          END IF;
          
          IF vERROR_MESSAGE IS NULL THEN
            BEGIN
              vDELIVER_STARTED := TO_DATE(pDELIVER_STARTED, 'DD.MM.YYYY'); 
            EXCEPTION WHEN OTHERS THEN
              vERROR_MESSAGE := '������ ���������� ������ ! ���� �������� �������� ������ ���� � ������� DD.MM.YYYY HH24:MI:SS ('||pDELIVER_STARTED||')';
            END;
          END IF;
          
          IF (vERROR_MESSAGE IS NULL) AND (REC.SIM_NUMBER2_LENGTH IS NOT NULL) AND (LENGTH(pSIM_NUMBER2) > REC.SIM_NUMBER2_LENGTH) THEN
            vERROR_MESSAGE := '������ ���������� ������ ! ����� ���������� ������ SIM ����� �� ������ ��������� '||REC.SIM_NUMBER2_LENGTH||' ��������.';
          END IF; 
            
          IF vERROR_MESSAGE IS NULL THEN
            BEGIN
              vDELIVER_STARTED := TO_DATE(pDELIVER_STARTED, 'DD.MM.YYYY'); 
            EXCEPTION WHEN OTHERS THEN
              vERROR_MESSAGE := '������ ���������� ������ ! ���� �������� �������� ������ ���� � ������� DD.MM.YYYY HH24:MI:SS ('||pDELIVER_STARTED||')';
            END;
          END IF;

          IF vERROR_MESSAGE IS NULL THEN
            BEGIN              
              vHLR := pHLR;
              /*
              vHLR := TO_NUMBER(pHLR);
              IF vHLR <> TRUNC(vHLR) THEN
                vERROR_MESSAGE := '������ ���������� ������ ! HL ������ ���� ����� ������.';
              END IF; 
              */
            EXCEPTION WHEN OTHERS THEN
              --vERROR_MESSAGE := '������ ���������� ������ ! HL ������ ���� ������.';
              vERROR_MESSAGE := '������ ���������� ������ ! HL ������������.';
            END;
          END IF;

          -- ���� �������� ������ (�� ���������)
          IF (vERROR_MESSAGE IS NULL) AND (NVL(pSTATUS_ID, 0) <> 0) THEN
            IF S_CAN_CHANGE_STATUS(pPHONE_NUMBER_ID, pSTATUS_ID, pUSER_ID, vERROR_MESSAGE) = 0 THEN
              NULL; -- ������ �� ������, ��� �� ������ ������� vERROR_MESSAGE 
            END IF;
          END IF;
           
          IF vERROR_MESSAGE IS NULL THEN
            -- ����� ��� ������, ����� ��� �������� ������� ������� �� ���������� ���  ��� �������        
            G_STATE.USER_ID := pUSER_ID;
            --
            -- ���������� ������ NULL - ������ ������ �� ������, 0 - ������ ������� ������, ����� ������ �� ����������
            --
             UPDATE D_PHONE_NUMBERS D 
                SET --D.PHONE_NUMBER = SUBSTR(pPHONE_NUMBER, 1, 20),
                    --D.PRICE = SUBSTR(pPRICE, 1, 20),
                    D.SIM_NUMBER1 = SUBSTR(pSIM_NUMBER1, 1, 20),
                    D.SIM_NUMBER2 = SUBSTR(pSIM_NUMBER2, 1, 20),
                    D.TARIFF_ID = NVL(pTARIFF_ID, D.TARIFF_ID),
                    D.STATUS_ID = DECODE(pSTATUS_ID, NULL, D.STATUS_ID, 0, NULL, pSTATUS_ID),
                    D.STATUS_ID_CONTRAGENT = DECODE(pSTATUS_ID, NULL, D.STATUS_ID, 0, NULL, pSTATUS_ID),
                    D.CODE_WORD = SUBSTR(pCODE_WORD, 1, 100),
                    D.SURNAME = SUBSTR(pSURNAME, 1, 30),      
                    D.NAME = SUBSTR(pNAME, 1, 30),      
                    D.PATRONYMIC = SUBSTR(pPATRONYMIC, 1, 30),      
                    D.BDATE = SUBSTR(pBDATE, 1, 10),
                    D.PASSPORT_SER_NUM = SUBSTR(pPASSPORT_SER_NUM, 1, 20),      
                    D.PASSPORT_DATE = SUBSTR(pPASSPORT_DATE, 1, 20),
                    D.PASSPORT_GET = SUBSTR(pPASSPORT_GET, 1, 50),
                    D.CONTACT_PHONE = SUBSTR(pCONTACT_PHONE, 1, 20),
                    D.MAIL = SUBSTR(pMAIL, 1, 100),
                    D.REGISTRATION = SUBSTR(pREGISTRATION, 1, 100),
                    D.DELIVER_ADDRESS = SUBSTR(pDELIVER_ADDRESS, 1, 200),
                    D.DELIVER_CONTACT = SUBSTR(pDELIVER_CONTACT, 1, 100),
                    D.DELIVER_CONTACT_PHONE = SUBSTR(pDELIVER_CONTACT_PHONE, 1, 20),
                    D.COMMENTS = SUBSTR(pCOMMENTS, 1, 2000),
                    D.DELIVER_STARTED = vDELIVER_STARTED,
                    --D.DATE_CHANGED_CONTRAGENT = SYSDATE, -- ����� �� ���������, ����������� ���������
                    -- USER_ID - ������������, ������� ������� ������
                    -- (���� ����� ������ NULL - �� �� ���������, ���� 0 - ������ ���������, ������ ������������, ����� ������ ������������)
                    D.USER_ID = DECODE(pSTATUS_ID, NULL, D.USER_ID, 0, NULL, pUSER_ID),
                    D.HL = SUBSTR(pHLR, 1, 10)   
              WHERE D.PHONE_NUMBER_ID = pPHONE_NUMBER_ID
              RETURNING D.USER_ID INTO vUSER_ID;
          END IF;
        EXCEPTION WHEN OTHERS THEN
          vERROR_MESSAGE := '������ �������������� ���������� ������. '|| HTF.ESCAPE_SC(dbms_utility.format_error_stack ||CHR(13)||CHR(10)|| dbms_utility.format_error_backtrace);
        END;
      END IF;
    END IF;  
--  END IF;


  BEGIN
    SELECT PH.USER_ID,ph.phone_number,ph.date_last_updated
      INTO vUSER_ID,vPHONE_NUMBER,vDATELU
      FROM D_PHONE_NUMBERS PH
     WHERE PH.PHONE_NUMBER_ID = pPHONE_NUMBER_ID;
   EXCEPTION 
     WHEN OTHERS THEN NULL;
   END;

  -- ���� ��������� ���������, � ������� ������������ - ��� ��, ��� ������� ������������ �� ��������� (������ ������) 
  -- �� ��������� �� ��� �����
  -- 
  IF (vERROR_MESSAGE IS NULL) AND ((pUSER_ID = vUSER_ID) OR (vUSER_ID IS NULL)) THEN
    if nvl(pSTATUS_ID,0)=3 then
      begin
       vMAIL := S_PHONE_RESERVED_LETTER_SEND(vPHONE_NUMBER,vUSER_ID,vDATELU,vOUT_ERROR);
       IF vOUT_ERROR IS NOT NULL THEN
          vERROR_MESSAGE := '����� '||vPHONE_NUMBER||' ������������! ������ ��� �������� ������ � ������������! '||vOUT_ERROR; 
       END IF;
      EXCEPTION WHEN OTHERS THEN
        vERROR_MESSAGE := '����� '||vPHONE_NUMBER||' ������������! ������ ��� �������� ������ � ������������! '||HTF.ESCAPE_SC(dbms_utility.format_error_stack ||CHR(13)||CHR(10)|| dbms_utility.format_error_backtrace);
      END;
    end if;
    IF vERROR_MESSAGE IS NULL then
       -- ��� �������� ����� � MY_STORE 
       G_STATE.USER_ID := pUSER_ID;
       G_STATE.IS_CONTRAGENT := 1; 
       MY_STORE2(SESSION_ID);
    ELSE
      -- ���� ������, �� ��� �� �� ����������, �������� �� 
      PHONE_NUMBER(
        SESSION_ID,
        pPHONE_NUMBER_ID,   
        --pPHONE_NUMBER,
        --pPRICE,
        SUBMIT_PHONE_EDIT,
        pSIM_NUMBER1,
        pSIM_NUMBER2,
        pTARIFF_ID,
        pSTATUS_ID,
        pCODE_WORD,
        pSURNAME,      
        pNAME,      
        pPATRONYMIC,      
        pBDATE,      
        pPASSPORT_SER_NUM,      
        pPASSPORT_DATE,      
        pPASSPORT_GET,      
        pCONTACT_PHONE,      
        pMAIL,      
        pREGISTRATION,
        pDELIVER_ADDRESS,      
        pDELIVER_CONTACT,      
        pDELIVER_CONTACT_PHONE,
        pCOMMENTS,
        vERROR_MESSAGE,
        pHLR
      );
    END IF;   
  ELSE
    -- ���� ������, �� ��� �� �� ����������, �������� �� 
    PHONE_NUMBER(
      SESSION_ID,
      pPHONE_NUMBER_ID,   
      --pPHONE_NUMBER,
      --pPRICE,
      SUBMIT_PHONE_EDIT,
      pSIM_NUMBER1,
      pSIM_NUMBER2,
      pTARIFF_ID,
      pSTATUS_ID,
      pCODE_WORD,
      pSURNAME,      
      pNAME,      
      pPATRONYMIC,      
      pBDATE,      
      pPASSPORT_SER_NUM,      
      pPASSPORT_DATE,      
      pPASSPORT_GET,      
      pCONTACT_PHONE,      
      pMAIL,      
      pREGISTRATION,
      pDELIVER_ADDRESS,      
      pDELIVER_CONTACT,      
      pDELIVER_CONTACT_PHONE,
      pCOMMENTS,
      vERROR_MESSAGE,
      pHLR
    );
  END IF;       
END;
/
