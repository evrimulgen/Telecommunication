CREATE OR REPLACE PROCEDURE BLOCK_PHONE_WITH_DOPSTATUS
AS
  --v2. ��������. ��������� ������� ���������� ������ � ����. AUTO_BLOCKED_PHONE � ������� ������ � ���������� ������ � BEELINE_TICKETS
  --v1. ��������.
  --���������� ������� � ��� ��������� �� ����������
  CURSOR C
  IS
     SELECT 
       BL.ACCESS_BLOCK, 
       BL.ACCESS_UNLOCK, 
       BL.COMMENT_CLENT, 
       BL.DOP_STATUS_ID, 
       BL.DOP_STATUS_NAME, 
       BL.PHONE_IS_ACTIVE, 
       BL.PHONE_NUMBER, 
       BL.STATUS_ID, 
       BL.YEAR_MONTH
     FROM V_BLOCK_PHONE_WITH_DOPSTATUS bl
     WHERE 
            NOT EXISTS
              (
                SELECT 1
                FROM AUTO_BLOCKED_PHONE
                WHERE AUTO_BLOCKED_PHONE.PHONE_NUMBER = BL.PHONE_NUMBER                    
                AND (AUTO_BLOCKED_PHONE.BLOCK_DATE_TIME > SYSDATE - 30/24/60) -- �� ����� 30 ����� �����
                AND AUTO_BLOCKED_PHONE.Note like '%������ �� ���� �%'
              )
     AND 
            NOT EXISTS
               (
                 SELECT 1
                 FROM QUEUE_PHONE_REBLOCK
                 WHERE QUEUE_PHONE_REBLOCK.PHONE_NUMBER = BL.PHONE_NUMBER
               )
     AND 
            NOT EXISTS 
               (
                   SELECT 1
                   FROM BEELINE_TICKETS B
                   WHERE B.PHONE_NUMBER = BL.PHONE_NUMBER
                       AND B.TICKET_TYPE = 9
                       AND B.DATE_CREATE > SYSDATE - 30/24/60
                       AND ((B.ANSWER IS NULL) OR (B.ANSWER = 1))
               )
     ;
        
  vSTR VARCHAR2(1000 CHAR);   
begin
  --��������� �� ���� ���������� �������
  FOR vREC IN C 
  LOOP
    BEGIN
      vSTR := '';
      --���� ������ ����������
      IF NVL(vREC.PHONE_IS_ACTIVE, 0) <> 1 THEN
        --���������� ����� �� �������� �� ����������
        INSERT INTO QUEUE_PHONE_REBLOCK(PHONE_NUMBER) VALUES (vREC.PHONE_NUMBER);
        COMMIT;
      ELSIF NVL(vREC.PHONE_IS_ACTIVE, 0) = 1 THEN --���� ����� �������, ��������� �� ����������
        --���������
        vSTR := BEELINE_API_PCKG.LOCK_PHONE(vREC.PHONE_NUMBER, 1, 'S1B');   
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        INSERT INTO AAA(SSS1,SSS2)
        VALUES(vREC.PHONE_NUMBER, '���� ���������� ������ � ���. �������� �� ���������� '||TO_CHAR(SYSDATE, 'DD.MM.YYYY HH24:MI:SS')||'. '||vSTR);
        COMMIT;
    END;
  END LOOP;
end;
/
