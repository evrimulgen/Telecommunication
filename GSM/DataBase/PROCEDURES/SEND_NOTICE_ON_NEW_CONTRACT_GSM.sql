CREATE OR REPLACE PROCEDURE LONTANA.SEND_NOTICE_ON_NEW_CONTRACT(
  pCONTRACT_ID IN INTEGER
  ) IS
--
--Version=4 
-- ���������� �.�. 12.11.2012 ���������� �������� ��� 2-� ��� ��� ����������� ������ ��������.
-- ���������� �.�. 13.11.2012 ����������� ������ 2-�� ���.
CURSOR C IS
  SELECT CONTRACTS.PHONE_NUMBER_FEDERAL,
         OPERATORS.OPERATOR_NAME,
         ABONENTS.SURNAME||' '||ABONENTS.NAME||' '||ABONENTS.PATRONYMIC FIO         
    FROM CONTRACTS, 
         OPERATORS,
         ABONENTS      
    WHERE CONTRACTS.CONTRACT_ID=pCONTRACT_ID
      AND CONTRACTS.OPERATOR_ID=OPERATORS.OPERATOR_ID
      AND CONTRACTS.ABONENT_ID=ABONENTS.ABONENT_ID;      
rec C%ROWTYPE;
SMS_TEXT VARCHAR2(500 CHAR);
SMS VARCHAR2(500 CHAR); 
BEGIN
  OPEN C;
  FETCH C INTO rec;
  CLOSE C;
  IF rec.OPERATOR_NAME='������' THEN
    SMS_TEXT:='��� ������������ gsmcorp.ru,�������,��� ��������������� �������� ����� ��������!';
    SMS:=LOADER3_PCKG.SEND_SMS(
           rec.PHONE_NUMBER_FEDERAL,
           '���-����������',
           SMS_TEXT);
    SMS_TEXT:= '��. �������,��������� ������ - *200*555# � 0588, ������ ���������-84956487888 ��� � ����������-05455 (�������� ��� ����������).';
    SMS:=LOADER3_PCKG.SEND_SMS(
           rec.PHONE_NUMBER_FEDERAL,
           '���-����������',
           SMS_TEXT);
    SMS_TEXT:='��������� ������, ������������ ������ � ����������� ����� �� ����� www.gsmcorp.ru � ������� ������� ��������.';
    SMS:=LOADER3_PCKG.SEND_SMS(
           rec.PHONE_NUMBER_FEDERAL,
           '���-����������',
           SMS_TEXT);
    IF SMS IS NULL THEN  
      INSERT INTO BLOCK_SEND_SMS(PHONE_NUMBER, SEND_DATE_TIME, ABONENT_FIO) 
        VALUES (rec.PHONE_NUMBER_FEDERAL, sysdate, rec.FIO);
    END IF;
    COMMIT;       
  END IF;
END;
/

--grant execute on SEND_NOTICE_ON_NEW_CONTRACT to lontana_role;