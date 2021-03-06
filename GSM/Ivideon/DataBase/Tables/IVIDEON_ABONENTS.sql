CREATE TABLE IVIDEON_ABONENTS(
  ABONENT_ID Integer NOT NULL PRIMARY KEY,
  FIO Varchar2(150 ),
  E_MAIL Varchar2(50 ) NOT NULL UNIQUE,
  IVIDEON_USER_ID Integer,
  USER_CREATED Varchar2(30 ) NOT NULL,
  DATE_CREATED Date NOT NULL,
  USER_LAST_UPDATED Varchar2(30 ),
  DATE_LAST_UPDATED Date
);
/

 
COMMENT ON TABLE IVIDEON_ABONENTS IS '������������ ������� Ivideon';
/
COMMENT ON COLUMN IVIDEON_ABONENTS.ABONENT_ID IS '������������� ������';
/
COMMENT ON COLUMN IVIDEON_ABONENTS.FIO IS '��� ������������';
/
COMMENT ON COLUMN IVIDEON_ABONENTS.E_MAIL IS 'E-mail ������ ������������';
/
COMMENT ON COLUMN IVIDEON_ABONENTS.IVIDEON_USER_ID IS '������������� ������������ � ������� Ivideon';
/
COMMENT ON COLUMN IVIDEON_ABONENTS.USER_CREATED IS '��������� ������������';
/
COMMENT ON COLUMN IVIDEON_ABONENTS.DATE_CREATED IS '���� �������� ������';
/
COMMENT ON COLUMN IVIDEON_ABONENTS.USER_LAST_UPDATED IS '��������� ���������� ������������';
/
COMMENT ON COLUMN IVIDEON_ABONENTS.DATE_LAST_UPDATED IS '���� ����������� ����������';
/


CREATE SEQUENCE S_IVIDEON_ABONENTS_ID
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1;
  
CREATE OR REPLACE TRIGGER TIU_IVIDEON_ABONENTS
  BEFORE INSERT OR UPDATE ON IVIDEON_ABONENTS
  REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
BEGIN
  
  IF INSERTING THEN
    if nvl(:new.ABONENT_ID, 0) = 0 then
      :new.ABONENT_ID := S_IVIDEON_ABONENTS_ID.NEXTVAL;
    END IF;
    
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
    
  END IF;
  
  IF UPDATING THEN
    :NEW.USER_LAST_UPDATED := USER;
    :NEW.DATE_LAST_UPDATED := SYSDATE;
  END IF;
END;
/  

CREATE OR REPLACE TRIGGER TI_IVIDEON_ABONENTS
  AFTER INSERT ON IVIDEON_ABONENTS
  REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
BEGIN
  
 INSERT INTO ABONENT_BLOCK_UNLOCK(
                                     ABONENT_ID,
                                     ABONENT_IS_ACTIVE,
                                     BALANCE
                                     ) 
                              VALUES(
                                     :new.ABONENT_ID,
                                     1,
                                     0
                                     );
END;
/
alter table IVIDEON_ABONENTS add(PASSWORD Varchar2(50 char) not null);
COMMENT ON COLUMN IVIDEON_ABONENTS.PASSWORD IS '������ � ��������� MD5';

ALTER TABLE IVIDEON_ABONENTS ADD( IVIDEON_PASSWORD VARCHAR2(50 CHAR));
COMMENT ON COLUMN IVIDEON_ABONENTS.IVIDEON_PASSWORD IS '������ ��� ������� IVIDEON';