
  CREATE OR REPLACE TRIGGER "SIM_TRADE"."TIU_BEELINE_TICKETS" 
  BEFORE INSERT OR UPDATE ON BEELINE_TICKETS FOR EACH ROW 
--#Version=1
DECLARE 
  vSTATUS VARCHAR2(100 CHAR);
BEGIN
  IF (UPDATING) AND (:NEW.TICKET_TYPE IN (9, 10)) THEN 
    IF (NVL(:NEW.ANSWER, -1) = 0) AND (NVL(:OLD.ANSWER, -1) = -1) then
      vSTATUS:=BEELINE_API_PCKG.PHONE_STATUS(:NEW.PHONE_NUMBER);
      SELECT B.STATUS_CODE INTO vSTATUS
        FROM DB_LOADER_ACCOUNT_PHONES D,
             BEELINE_STATUS_CODE B
        WHERE D.PHONE_NUMBER = :NEW.PHONE_NUMBER
          AND D.YEAR_MONTH = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'))
          AND D.STATUS_ID = B.STATUS_ID(+)
          and rownum <=1;
      :NEW.COMMENTS := :NEW.COMMENTS||'Код статуса: '||vSTATUS;
    END IF;
  END IF;
END; 

ALTER TRIGGER "SIM_TRADE"."TIU_BEELINE_TICKETS" ENABLE