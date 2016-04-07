CREATE TABLE FIELD_DETAIL_TYPES(
  FIELD_DETAIL_TYPES_ID INTEGER PRIMARY KEY,
  FIELD_TYPE_ID INTEGER NOT NULL,
  FIELD_COMMENT VARCHAR2(30 CHAR) NOT NULL
);

COMMENT ON COLUMN FIELD_DETAIL_TYPES.FIELD_DETAIL_TYPES_ID IS '��������� ����'; 

COMMENT ON COLUMN FIELD_DETAIL_TYPES.FIELD_TYPE_ID IS '��� ����'; 

COMMENT ON COLUMN FIELD_DETAIL_TYPES.FIELD_COMMENT IS '�������� ����'; 

CREATE SEQUENCE S_NEW_FIELD_DETAIL_TYPES_ID;

CREATE OR REPLACE FUNCTION NEW_FIELD_DETAIL_TYPES_ID RETURN NUMBER IS
--#Version=1
  vRES NUMBER;
BEGIN
  SELECT S_NEW_FIELD_DETAIL_TYPES_ID.NEXTVAL
    INTO vRES
    FROM DUAL;
  RETURN vRES;
END;

CREATE OR REPLACE TRIGGER TIU_FIELD_DETAIL_TYPES
  BEFORE INSERT ON FIELD_DETAIL_TYPES FOR EACH ROW
--#Version=1
BEGIN
  IF NVL(:NEW.FIELD_DETAIL_TYPES_ID, 0) = 0 then
    :NEW.FIELD_DETAIL_TYPES_ID := NEW_FIELD_DETAIL_TYPES_ID;
  END IF;
END;

GRANT SELECT, UPDATE, INSERT, DELETE ON FIELD_DETAIL_TYPES TO CORP_MOBILE_ROLE;