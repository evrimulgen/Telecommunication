
  CREATE OR REPLACE TRIGGER "CORP_MOBILE"."TU_HACKERS_FIND" 
BEFORE INSERT OR UPDATE
ON DB_LOADER_PHONE_STAT
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN  
  IF INSERTING THEN
    IF :new.SMS_COUNT  >= Ms_PARAMs.get_num_var('CRIT_SMS_COUNT')  THEN
      INSERT INTO HACKERS(HACKERS_ID, PHONE_NUMBER, SERVICES_TYPE, DATE_CREATED, CHECKED_TYPE_ID, COUNT_SMS_CHANGE)    
        VALUES (S_NEW_HACKERS_ID.NEXTVAL, :new.PHONE_NUMBER, 2, SYSDATE, 1, :new.SMS_COUNT);    
    END IF;      
    INSERT INTO QUEUE_CURRENT_BALANCES(PHONE_NUMBER, QUEUE_TYPE)
      VALUES(:NEW.PHONE_NUMBER, 43);   
  ELSIF UPDATING  THEN  
    IF ((:new.SMS_COUNT - :old.SMS_COUNT) >= Ms_PARAMs.get_num_var('CRIT_SMS_COUNT'))  THEN
      INSERT INTO HACKERS(HACKERS_ID, PHONE_NUMBER, SERVICES_TYPE, DATE_CREATED, CHECKED_TYPE_ID, COUNT_SMS_CHANGE)    
        VALUES (S_NEW_HACKERS_ID.NEXTVAL, :new.PHONE_NUMBER, 2, SYSDATE, 1, :new.SMS_COUNT - :old.SMS_COUNT);    
    END IF;
    IF :NEW.ESTIMATE_SUM > :OLD.ESTIMATE_SUM THEN
      INSERT INTO QUEUE_CURRENT_BALANCES(PHONE_NUMBER, QUEUE_TYPE)
        VALUES(:NEW.PHONE_NUMBER, 43);  
    END IF;
  END IF;          
END;
ALTER TRIGGER "CORP_MOBILE"."TU_HACKERS_FIND" ENABLE