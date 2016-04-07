CREATE OR REPLACE PROCEDURE WWW_DEALER.GET_PHONE_NUMBERS_JSON4( OPERATORID VARCHAR2 DEFAULT NULL, HASH VARCHAR2 DEFAULT NULL) IS
-- #version=2
-- v.2 ������� �. 2016.02.09 - ������� ������ ������������� �� ������� IVIDEON ��� ������ ��������
-- v1. ������� �. 2015.06.19 - ������ http://redmine.tarifer.ru/issues/2971. ������� � ������� ������ �������, ������� ��������� �� ��������� ������� ������   
  CURSOR CUR IS             
    SELECT
      V_ACCOUNT_PHONE_LIST_FOR_1C.PHONE_NUMBER
    FROM
      lontana.V_ACCOUNT_PHONE_LIST_FOR_1C
    UNION ALL
    select
      TO_CHAR(IVIDEON.V_IVIDEION_USERS.ABONENT_ID) PHONE_NUMBER
    FROM
    IVIDEON.V_IVIDEION_USERS                 
     ;
          
  vIS_FIRST BOOLEAN := TRUE;
  FUNCTION PREPARE_JSON(pSTR VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        pSTR, 
        '[', '\['),
        ']', '\]'),
        '''', '\'''),
        '"', '\"'),
        '{', '\{'),
        '}', '\}')
        ;
  END;  
BEGIN
  IF HASH = 'BLABLABLABLA' THEN
    HTP.PRINT('{response: [');
    FOR REC IN CUR LOOP
      -- ['��������', '�����', '����', '�����']
      IF NOT vIS_FIRST THEN 
        HTP.PRN(',['''||PREPARE_JSON(REC.PHONE_NUMBER)||''']');
      ELSE    
        HTP.PRN('['''||PREPARE_JSON(REC.PHONE_NUMBER)||''']');    
        vIS_FIRST := FALSE;
      END IF;      
    END LOOP;
    HTP.PRINT(']}');
  ELSE
    HTP.PRINT(1/0);
  END IF;
END;
/
