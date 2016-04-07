CREATE OR REPLACE FUNCTION S_GET_REGEXP_TEMPLATE(
  pSOURCE_TEMPLATE IN VARCHAR2,  -- ������ ���� aabb, ababab - ����������� ������ ����� 0..9 � ����� a � b  
  pRESULT_TEMPLATE OUT VARCHAR2, -- �������������� ������ ��� ORACLE_REGEXP
  pERROR_MESSAGE OUT VARCHAR2    -- ��������� �� ������ - ���� �� ����������  
  ) RETURN INTEGER IS            -- 1 - ��� ���������, ����� ������ ���� ������ ������ � pERROR_MESSAGE
  --
  vTMP VARCHAR2(250 CHAR);
  I PLS_INTEGER;
  vALIAS_COUNT PLS_INTEGER := 0;
  vA_ALIAS VARCHAR2(2 CHAR) := NULL;
  vB_ALIAS VARCHAR2(2 CHAR) := NULL;
  vC_ALIAS VARCHAR2(2 CHAR) := NULL;
  vD_ALIAS VARCHAR2(2 CHAR) := NULL;
  vCURRENT_CHAR VARCHAR2(1 CHAR);
  -- ��������� ����� � �������� ������� ���� ������ ����� � ����� A � B
  FUNCTION CHECK_TEMPLATE(pSOURCE_TEMPLATE IN VARCHAR2, pERROR_MESSAGE OUT VARCHAR2) RETURN BOOLEAN IS  
    vTMP VARCHAR2(250 CHAR);
  BEGIN 
    vTMP := REGEXP_REPLACE(pSOURCE_TEMPLATE, '[[:digit:]]', '0'); -- ��������� ��� ����� � 0 
    vTMP := REPLACE(vTMP, ' ', '');
    vTMP := REGEXP_REPLACE(vTMP, 'A', '0'); -- ��������� ��� ����� A � 0 
    vTMP := REGEXP_REPLACE(vTMP, 'B', '0'); -- ��������� ��� ����� B � 0 
    vTMP := REGEXP_REPLACE(vTMP, 'C', '0'); -- ��������� ��� ����� B � 0
    vTMP := REGEXP_REPLACE(vTMP, 'D', '0'); -- ��������� ��� ����� B � 0
    vTMP := REGEXP_REPLACE(vTMP, '0000', '0'); -- ��������� ������ 0 � ���� 0 
    vTMP := REGEXP_REPLACE(vTMP, '000', '0'); -- ��������� ��� 0 � ���� 0 
    vTMP := REGEXP_REPLACE(vTMP, '00', '0'); -- ��������� ��� 0 � ���� 0
    -- � ������ ����� ������ ���� ������ ������
    IF SUBSTR(vTMP, 1, 1) = '^' THEN
      vTMP := SUBSTR(vTMP, 2);
    END IF; 
    -- � ����� ����� ������ ���� ��������� ������
    IF SUBSTR(vTMP, LENGTH(vTMP), 1) = '$' THEN
      vTMP := SUBSTR(vTMP, 1, LENGTH(vTMP)-1);
    END IF; 
    -- ���� � ���������� ��������� �� 0, ������ ���-�� �� ��
    IF vTMP <> '0' THEN
      pERROR_MESSAGE := '�� ���������� ������. ������ ������ ��������� ������ ����� �� 0 �� 9 � ������� a, b � c';    
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END;
BEGIN
  pRESULT_TEMPLATE := NULL;
  pERROR_MESSAGE := NULL;

  vTMP := REPLACE( 
                   REPLACE(
                           REPLACE(
                                    REPLACE(UPPER(pSOURCE_TEMPLATE), '�', 'A'), 
                           '�', 'B'), 
                   '�', 'C'),
          '�', 'D'); -- ��������� ������� � � � � ��������� A B C 
  IF CHECK_TEMPLATE(vTMP, pERROR_MESSAGE) THEN
    FOR I IN 1..LENGTH(vTMP) LOOP
      vCURRENT_CHAR := SUBSTR(vTMP, I, 1);   
    
      IF vCURRENT_CHAR = 'A' THEN
        IF vA_ALIAS IS NULL THEN
          vALIAS_COUNT := NVL(vALIAS_COUNT, 0) + 1;
          vA_ALIAS := '\'||TO_CHAR(vALIAS_COUNT);
          pRESULT_TEMPLATE := pRESULT_TEMPLATE || '(.)'; 
        ELSE
          pRESULT_TEMPLATE := pRESULT_TEMPLATE || vA_ALIAS; 
        END IF;
      ELSIF vCURRENT_CHAR = 'B' THEN
        IF vB_ALIAS IS NULL THEN
          vALIAS_COUNT := NVL(vALIAS_COUNT, 0) + 1;
          vB_ALIAS := '\'||TO_CHAR(vALIAS_COUNT);
          pRESULT_TEMPLATE := pRESULT_TEMPLATE || '(.)'; 
        ELSE
          pRESULT_TEMPLATE := pRESULT_TEMPLATE || vB_ALIAS; 
        END IF;
      ELSIF vCURRENT_CHAR = 'C' THEN
        IF vC_ALIAS IS NULL THEN
          vALIAS_COUNT := NVL(vALIAS_COUNT, 0) + 1;
          vC_ALIAS := '\'||TO_CHAR(vALIAS_COUNT);
          pRESULT_TEMPLATE := pRESULT_TEMPLATE || '(.)';
        ELSE
          pRESULT_TEMPLATE := pRESULT_TEMPLATE || vC_ALIAS;
        END IF;
      ELSIF vCURRENT_CHAR = 'D' THEN
        IF vD_ALIAS IS NULL THEN
          vALIAS_COUNT := NVL(vALIAS_COUNT, 0) + 1;
          vD_ALIAS := '\'||TO_CHAR(vALIAS_COUNT);
          pRESULT_TEMPLATE := pRESULT_TEMPLATE || '(.)';
        ELSE
          pRESULT_TEMPLATE := pRESULT_TEMPLATE || vD_ALIAS;
        END IF;      
      ELSE
        pRESULT_TEMPLATE := pRESULT_TEMPLATE || vCURRENT_CHAR;
      END IF;
    END LOOP;
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END;
/
