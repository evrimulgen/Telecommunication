CREATE OR REPLACE PROCEDURE LONTANA_WWW.SQL_GET_ABONENT_DETAIL_TEXT(
  pUSER_ID IN INTEGER,
  pYEAR_MONTH IN NUMBER,
  pDATE OUT DBMS_SQL.VARCHAR2_TABLE,
  pTIME OUT DBMS_SQL.VARCHAR2_TABLE,
  pSOBESEDNIK OUT DBMS_SQL.VARCHAR2_TABLE,
  pTYPE OUT DBMS_SQL.VARCHAR2_TABLE,
  pLENGTH OUT DBMS_SQL.VARCHAR2_TABLE,
  pCOST OUT DBMS_SQL.NUMBER_TABLE,
  pROUMING OUT DBMS_SQL.VARCHAR2_TABLE, 
  pZONA_ROUMINGA OUT DBMS_SQL.VARCHAR2_TABLE, 
  pINFO OUT DBMS_SQL.VARCHAR2_TABLE 
  ) IS
  INFA CLOB;
  LENG INTEGER;
  BEGINING INTEGER; 
  ENDING INTEGER;
  I INTEGER; 
  LINE VARCHAR2(2000);
  BE INTEGER;
  EN INTEGER;
  TYP VARCHAR2(100);
  LE VARCHAR2(100);
  LEN NUMBER;
FUNCTION TO_NUM(RES IN VARCHAR2) RETURN NUMBER IS
ITOG NUMBER(15,4);  
vRES VARCHAR2(15 CHAR);
begin    
  vRES:=REPLACE(RES, ',', '.');
  BEGIN
    ITOG:=TO_NUMBER(vRES);
  EXCEPTION
    WHEN OTHERS THEN
      ITOG:=TO_NUMBER(REPLACE(vRES, '.', ','));
  END;
  RETURN ITOG;
end;
BEGIN
  INFA:=LONTANA.WWW_GET_PHONE_DETAIL(pUSER_ID,pYEAR_MONTH);
  LENG:=DBMS_LOB.GETLENGTH(INFA);
  IF LENG>0 THEN
    ENDING:=1;
    I:=0;
    --DBMS_LOB.INSTR(INFA,CHR(10),1,1);
    WHILE (DBMS_LOB.INSTR(INFA,CHR(10),ENDING+1,1)<>0) --AND (I<8)
    LOOP
      BEGINING:=ENDING;
      I:=I+1;
      ENDING:=DBMS_LOB.INSTR(INFA,CHR(10),BEGINING+1,1);
      LINE:=DBMS_LOB.SUBSTR(INFA,ENDING-BEGINING-1,BEGINING);
      BE:=INSTR(LINE,CHR(9),1);
      EN:=INSTR(LINE,CHR(9),BE+1);
      pDATE(I):=SUBSTR(LINE,BE+1,5);
      BE:=INSTR(LINE,CHR(9),EN+1);
      pTIME(I):=SUBSTR(LINE,EN+1,BE-EN-1);
      EN:=INSTR(LINE,CHR(9),BE+1);    
      pTYPE(I):=CASE SUBSTR(LINE,BE+1,EN-BE-1)
                  WHEN 'C' THEN '������'
                  WHEN 'S' THEN '���'
                  WHEN 'U' THEN '���'
                  WHEN 'G' THEN '��������'
                  WHEN 'W' THEN 'WAP'
                  WHEN 'O' THEN '������' 
                END;              
      BE:=INSTR(LINE,CHR(9),EN+1);
      IF (pTYPE(I)='������') OR (pTYPE(I)='���') OR (pTYPE(I)='���') THEN
        TYP:=CASE SUBSTR(LINE,EN+1,BE-EN-1)
                  WHEN '1' THEN '���. '
                  WHEN '2' THEN '��. '
                  WHEN '3' THEN '�������. '
                  WHEN 'else' THEN '�����. '
                END;
        pTYPE(I):=TYP || pTYPE(I);        
      END IF;                       
      EN:=INSTR(LINE,CHR(9),BE+1);    
      pSOBESEDNIK(I):=SUBSTR(LINE,BE+1,EN-BE-1);
      BE:=INSTR(LINE,CHR(9),EN+1);    
      IF pTYPE(I)='WAP' THEN
        LE:=SUBSTR(LINE,EN+1,BE-EN-11) || ' Mb';
      ELSE 
        LEN:=TO_NUM(SUBSTR(LINE,EN+1,BE-EN-1));
        IF TRUNC(LEN-60*TRUNC(LEN/60))<10 THEN 
          LE:=TO_CHAR(TRUNC(LEN/60)) || ':0' || TO_CHAR(TRUNC(LEN-60*TRUNC(LEN/60)));
        ELSE
          LE:=TO_CHAR(TRUNC(LEN/60)) || ':' || TO_CHAR(TRUNC(LEN-60*TRUNC(LEN/60)));
        END IF;  
      END IF;
      pLENGTH(I):=LE;    
      EN:=INSTR(LINE,CHR(9),BE+1);    
      pCOST(I):=TO_NUM(SUBSTR(LINE,BE+1,EN-BE-1));
      BE:=INSTR(LINE,CHR(9),EN+1);    
      pROUMING(I):=SUBSTR(LINE,EN+1,BE-EN-1);
      EN:=INSTR(LINE,CHR(9),BE+1);    
      pZONA_ROUMINGA(I):=SUBSTR(LINE,BE+1,EN-BE-1);
      pINFO(I):=SUBSTR(LINE,EN+1,LENGTH(LINE)-EN);
    END LOOP;
    /* 
    ���� � ������:
    - ���� ����� (����������)
    - ����
    - �����
    - ��� ������
    - ����������� ������
    - ����������
    - ����� (�������, �����)
    - ��������� (���)
    - ������� �������� (1=��)
    - ���� ��������
    - ���.����������
    --
    ����:
  ����������� ������:
          1-���������
          2-��������
          3-�������������
          else ������������
  ��� ������:          
  'C', '������'
  'S', '���'
  'U', '���'
  'G', '��������'
  'W', 'WAP'
  'O', '������'
    */
    LINE:=DBMS_LOB.SUBSTR(INFA,LENG-ENDING,ENDING+1);
    I:=I+1;
    BE:=INSTR(LINE,CHR(9),1);
    EN:=INSTR(LINE,CHR(9),BE+1);
    pDATE(I):=SUBSTR(LINE,BE+1,5);
    BE:=INSTR(LINE,CHR(9),EN+1);
    pTIME(I):=SUBSTR(LINE,EN+1,BE-EN-1);
    EN:=INSTR(LINE,CHR(9),BE+1);    
      pTYPE(I):=CASE SUBSTR(LINE,BE+1,EN-BE-1)
                  WHEN 'C' THEN '������'
                  WHEN 'S' THEN '���'
                  WHEN 'U' THEN '���'
                  WHEN 'G' THEN '��������'
                  WHEN 'W' THEN 'WAP'
                  WHEN 'O' THEN '������' 
                END;              
    BE:=INSTR(LINE,CHR(9),EN+1);
      IF (pTYPE(I)='������') OR (pTYPE(I)='���') OR (pTYPE(I)='���') THEN
        TYP:=CASE SUBSTR(LINE,EN+1,BE-EN-1)
                  WHEN '1' THEN '���. '
                  WHEN '2' THEN '��. '
                  WHEN '3' THEN '�������. '
                  WHEN 'else' THEN '�����. '
                END;
      pTYPE(I):=TYP || pTYPE(I);        
    END IF;                       
    EN:=INSTR(LINE,CHR(9),BE+1);    
    pSOBESEDNIK(I):=SUBSTR(LINE,BE+1,EN-BE-1);
    BE:=INSTR(LINE,CHR(9),EN+1);    
    IF pTYPE(I)='WAP' THEN
      LE:=SUBSTR(LINE,EN+1,BE-EN-11) || ' Mb';
    ELSE
      LEN:=TO_NUM(SUBSTR(LINE,EN+1,BE-EN-1));
      IF TRUNC(LEN-60*TRUNC(LEN/60))<10 THEN 
        LE:=TO_CHAR(TRUNC(LEN/60)) || ':0' || TO_CHAR(TRUNC(LEN-60*TRUNC(LEN/60)));
      ELSE
        LE:=TO_CHAR(TRUNC(LEN/60)) || ':' || TO_CHAR(TRUNC(LEN-60*TRUNC(LEN/60)));
      END IF;  
    END IF;
    pLENGTH(I):=LE;    
    EN:=INSTR(LINE,CHR(9),BE+1);    
    pCOST(I):=TO_NUM(SUBSTR(LINE,BE+1,EN-BE-1));
    BE:=INSTR(LINE,CHR(9),EN+1);    
    pROUMING(I):=SUBSTR(LINE,EN+1,BE-EN-1);
    EN:=INSTR(LINE,CHR(9),BE+1);    
    pZONA_ROUMINGA(I):=SUBSTR(LINE,BE+1,EN-BE-1);
    pINFO(I):=SUBSTR(LINE,EN+1,LENGTH(LINE)-EN);
  END IF;
END;
/
