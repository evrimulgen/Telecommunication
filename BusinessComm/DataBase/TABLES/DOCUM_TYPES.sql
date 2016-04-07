CREATE TABLE DOCUM_TYPES
(
  DOCUM_TYPE_ID      INTEGER                NOT NULL,
  DOCUM_TYPE_NAME    VARCHAR2(100 CHAR)     NOT NULL,
  USER_CREATED       VARCHAR2(30 CHAR)      NOT NULL,
  DATE_CREATED       DATE                   NOT NULL,
  USER_LAST_UPDATED  VARCHAR2(30 CHAR)      NOT NULL,
  DATE_LAST_UPDATED  DATE                   NOT NULL  
);

COMMENT ON  TABLE DOCUM_TYPES                   IS '���� ����������';
COMMENT ON COLUMN DOCUM_TYPES.DOCUM_TYPE_ID     IS '��������� ����';
COMMENT ON COLUMN DOCUM_TYPES.DOCUM_TYPE_NAME   IS '������������ ';
COMMENT ON COLUMN DOCUM_TYPES.USER_CREATED      IS '������������, ��������� ������';
COMMENT ON COLUMN DOCUM_TYPES.DATE_CREATED      IS '����/����� �������� ������';
COMMENT ON COLUMN DOCUM_TYPES.USER_LAST_UPDATED IS '������������, ��������������� ������ ���������';
COMMENT ON COLUMN DOCUM_TYPES.DATE_LAST_UPDATED IS '����/����� ��������� �������� ������';



CREATE UNIQUE INDEX PK_DOCUM_TYPES ON DOCUM_TYPES (DOCUM_TYPE_ID);

CREATE SEQUENCE S_NEW_DOCUM_TYPE
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;


CREATE OR REPLACE TRIGGER TIU_DOCUM_TYPES
  BEFORE INSERT OR UPDATE ON DOCUM_TYPES FOR EACH ROW
BEGIN
  IF INSERTING THEN
    IF NVL(:NEW.DOCUM_TYPE_ID, 0) = 0 then
      :NEW.DOCUM_TYPE_ID :=  S_NEW_DOCUM_TYPE.NEXTVAL;
    END IF;
    :NEW.USER_CREATED := USER;
    :NEW.DATE_CREATED := SYSDATE;
  END IF;
  :NEW.USER_LAST_UPDATED := USER;
  :NEW.DATE_LAST_UPDATED := SYSDATE;
END;
/



ALTER TABLE DOCUM_TYPES ADD (CONSTRAINT PK_DOCUM_TYPES PRIMARY KEY(DOCUM_TYPE_ID)
  USING INDEX PK_DOCUM_TYPES ENABLE VALIDATE);

GRANT DELETE, INSERT, SELECT, UPDATE ON DOCUM_TYPES TO BUSINESS_COMM_ROLE;
GRANT SELECT ON S_NEW_DOCUM_TYPE TO BUSINESS_COMM_ROLE;
GRANT SELECT, UPDATE ON DOCUM_TYPES TO BUSINESS_COMM_ROLE_RO;