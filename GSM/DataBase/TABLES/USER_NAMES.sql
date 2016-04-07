--#if not TableExists("USER_NAMES") then
CREATE TABLE USER_NAMES
(
  USER_NAME_ID            INTEGER               NOT NULL,
  USER_FIO                VARCHAR2(400 CHAR),
  USER_NAME               VARCHAR2(120 CHAR),
  PASSWORD2               VARCHAR2(120 CHAR),
  FILIAL_ID               INTEGER,
  RIGHTS_TYPE             INTEGER,
  USER_NAME_CREATED       VARCHAR2(30 CHAR),
  DATE_CREATED            DATE,
  USER_NAME_LAST_UPDATED  VARCHAR2(30 CHAR),
  DATE_LAST_UPDATED       DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;
--#end if

--#if GetTableComment("USER_NAMES")<>"������������" then
COMMENT ON TABLE USER_NAMES IS '������������';
--#end if

--#if GetColumnComment("USER_NAMES.USER_NAME_ID")<>"��������� ����" then
COMMENT ON COLUMN USER_NAMES.USER_NAME_ID IS '��������� ����';
--#end if

--#if GetColumnComment("USER_NAMES.USER_FIO")<>"��� ������������" then
COMMENT ON COLUMN USER_NAMES.USER_FIO IS '��� ������������';
--#end if

--#if GetColumnComment("USER_NAMES.USER_NAME")<>"��� ������������ Oracle" then
COMMENT ON COLUMN USER_NAMES.USER_NAME IS '��� ������������ Oracle';
--#end if

--#if GetColumnComment("USER_NAMES.PASSWORD2")<>"������ (�� ��������)" then
COMMENT ON COLUMN USER_NAMES.PASSWORD2 IS '������ (�� ��������)';
--#end if

--#if GetColumnComment("USER_NAMES.FILIAL_ID")<>"��� ������� �� ���������" then
COMMENT ON COLUMN USER_NAMES.FILIAL_ID IS '��� ������� �� ���������';
--#end if

--#if GetColumnComment("USER_NAMES.RIGHTS_TYPE")<>"��� ���� ������������� : 1 - �������������, 2 - ��������, 3 - ������ ���. �� ��������, ����� ������� ������������" then
COMMENT ON COLUMN USER_NAMES.RIGHTS_TYPE IS '��� ���� ������������� : 1 - �������������, 2 - ��������, 3 - ������ ���. �� ��������, ����� ������� ������������';
--#end if

--#if GetColumnComment("USER_NAMES.USER_NAME_CREATED")<>"������������, ��������� ������" then
COMMENT ON COLUMN USER_NAMES.USER_NAME_CREATED IS '������������, ��������� ������';
--#end if

--#if GetColumnComment("USER_NAMES.DATE_CREATED")<>"����/����� �������� ������" then
COMMENT ON COLUMN USER_NAMES.DATE_CREATED IS '����/����� �������� ������';
--#end if

--#if GetColumnComment("USER_NAMES.USER_NAME_LAST_UPDATED")<>"������������, ��������������� ������ ���������" then
COMMENT ON COLUMN USER_NAMES.USER_NAME_LAST_UPDATED IS '������������, ��������������� ������ ���������';
--#end if

--#if GetColumnComment("USER_NAMES.DATE_LAST_UPDATED")<>"����/����� ��������� �������� ������" then
COMMENT ON COLUMN USER_NAMES.DATE_LAST_UPDATED IS '����/����� ��������� �������� ������';
--#end if


--#if not ConstraintExists("PK_USER_NAMES") then
ALTER TABLE USER_NAMES ADD CONSTRAINT PK_USER_NAMES PRIMARY KEY (USER_NAME_ID);
--#end if

--#if not ConstraintExists("FK_USER_NAMES_FILIAL_ID") then
ALTER TABLE USER_NAMES ADD CONSTRAINT FK_USER_NAMES_FILIAL_ID 
 FOREIGN KEY (FILIAL_ID) REFERENCES FILIALS;
--#end if

--#if not IndexExists("I_USER_NAMES_FILIAL_ID") then
CREATE INDEX I_USER_NAMES_FILIAL_ID ON USER_NAMES (FILIAL_ID);
--#end if

--#if GetVersion("TIU_USER_NAMES")<1 then
CREATE OR REPLACE TRIGGER TIU_USER_NAMES
BEFORE INSERT OR UPDATE
ON USER_NAMES 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    pCount integer;
BEGIN 
    --���� �������
    IF INSERTING THEN
        IF NVL(:NEW.USER_NAME_ID, 0) = 0 then
            :NEW.USER_NAME_ID := NEW_USER_NAME_ID;
        END IF;
        :NEW.USER_NAME_CREATED := USER;
        :NEW.DATE_CREATED := SYSDATE;
        --���������� ������� ���� ������� ���������� � CRM � ������� ������� �����
        IF ( :NEW.LAST_ACTIVE IS NOT NULL ) AND
            ( NVL(:NEW.LAST_CRM_PHONEUNREF_ID, 0) <> 0 )  THEN
            INSERT INTO LOG_WORK_USER_CRM (USER_NAME_ID, CRM_PHONEUNREF_ID, BEGIN_DATE, END_DATE) 
                VALUES (:NEW.USER_NAME_ID, :NEW.LAST_CRM_PHONEUNREF_ID, :NEW.LAST_ACTIVE, :NEW.LAST_ACTIVE);
        END IF;   
    END IF;
    :NEW.USER_NAME_LAST_UPDATED := USER;
    :NEW.DATE_LAST_UPDATED := SYSDATE;
    
    --���� ����������
    IF UPDATING THEN
        --���� ��������� ��� �� ������� ����� ��� ��������� ������� �����
        IF ( ( :OLD.LAST_ACTIVE IS NULL ) AND ( :NEW.LAST_ACTIVE IS NOT NULL ) AND ( NVL(:NEW.LAST_CRM_PHONEUNREF_ID, 0) <> 0 ) ) OR
            ( ( :NEW.LAST_ACTIVE IS NOT NULL ) AND (NVL(:NEW.LAST_CRM_PHONEUNREF_ID, 0) <> 0) AND ( NVL(:OLD.LAST_CRM_PHONEUNREF_ID, 0) <> NVL(:NEW.LAST_CRM_PHONEUNREF_ID, 0) ) ) OR
            ( 
              ( :OLD.LAST_ACTIVE IS NOT NULL ) AND ( :NEW.LAST_ACTIVE IS NOT NULL ) AND ( NVL(:NEW.LAST_CRM_PHONEUNREF_ID, 0) <> 0 ) AND
              ( (to_date(to_char(:NEW.LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS') - to_date(to_char(:OLD.LAST_ACTIVE, 'DD.MM.YYYY HH24:MI:SS'), 'DD.MM.YYYY HH24:MI:SS')) >=  40/24/60/60)
            )  THEN
            INSERT INTO LOG_WORK_USER_CRM (USER_NAME_ID, CRM_PHONEUNREF_ID, BEGIN_DATE, END_DATE) 
                VALUES (:NEW.USER_NAME_ID, :NEW.LAST_CRM_PHONEUNREF_ID, :NEW.LAST_ACTIVE, :NEW.LAST_ACTIVE);
        ELSE
            IF ( :OLD.LAST_ACTIVE IS NOT NULL ) AND 
                ( :NEW.LAST_ACTIVE IS NOT NULL ) AND 
                ( NVL(:NEW.LAST_CRM_PHONEUNREF_ID, 0) <> 0 )  AND 
                (:OLD.LAST_ACTIVE <> :NEW.LAST_ACTIVE) THEN
                --��������� ������� ������ �� ������� ������������ � ������� 
                --(��� ��� ������������� �� ������� ��� ������� ���������� � CRM � ������� ������� �����)
                SELECT count(*)
                INTO pCount
                FROM LOG_WORK_USER_CRM cr
                WHERE cr.USER_NAME_ID = :NEW.USER_NAME_ID;     
                    
                IF pCount > 0 THEN
                    --����������
                    UPDATE LOG_WORK_USER_CRM cr
                    SET cr.END_DATE = :NEW.LAST_ACTIVE
                    WHERE cr.CRM_PHONEUNREF_ID = :NEW.LAST_CRM_PHONEUNREF_ID
                    AND cr.USER_NAME_ID = :NEW.USER_NAME_ID
                    AND cr.DATE_CREATED = (select max(wr.DATE_CREATED)
                                                           from LOG_WORK_USER_CRM wr
                                                           where WR.CRM_PHONEUNREF_ID = CR.CRM_PHONEUNREF_ID
                                                           and WR.USER_NAME_ID = CR.USER_NAME_ID);    
                ELSE
                    --�������
                    INSERT INTO LOG_WORK_USER_CRM (USER_NAME_ID, CRM_PHONEUNREF_ID, BEGIN_DATE, END_DATE) 
                        VALUES (:NEW.USER_NAME_ID, :NEW.LAST_CRM_PHONEUNREF_ID, :NEW.LAST_ACTIVE, :NEW.LAST_ACTIVE);
                END IF;    
            END IF;
        END IF;
    END IF;
END;
--#end if

--#if not ColumnExists("USER_NAMES.CHECK_ALLOW_ACCOUNT") then
ALTER TABLE USER_NAMES ADD CHECK_ALLOW_ACCOUNT NUMBER(1);
--#end if

--#if GetColumnComment("USER_NAMES.CHECK_ALLOW_ACCOUNT")<>"���� ��������. 1 - ��������� ������ ������������ � �/�" then
COMMENT ON COLUMN USER_NAMES.CHECK_ALLOW_ACCOUNT IS '���� ��������. 1 - ��������� ������ ������������ � �/�';
--#end if

--#if not ColumnExists("USER_NAMES.USER_NAME_OKTEL") AND ISClient("GSM_CORP") then
ALTER TABLE USER_NAMES ADD USER_NAME_OKTEL VARCHAR2(120 CHAR);
--#end if

--#if GetColumnComment("USER_NAMES.USER_NAME_OKTEL")<>"��� � Oktel" AND ISClient("GSM_CORP") then
COMMENT ON COLUMN USER_NAMES.USER_NAME_OKTEL IS '��� � IP ���������';
--#end if

--#if not ColumnExists("USER_NAMES.PASSWORD_OKTEL") and isclient("GSM_CORP") then
ALTER TABLE USER_NAMES ADD PASSWORD_OKTEL VARCHAR2(20 CHAR);
--#end if

--#if GetColumnComment("USER_NAMES.PASSWORD_OKTEL")<>"������ � IP ���������" and isclient("GSM_CORP") then
COMMENT ON COLUMN USER_NAMES.PASSWORD_OKTEL IS '������ � Oktel';
--#end if
              
--#if not ColumnExists("USER_NAMES.ENCRYPT_PWD") then
ALTER TABLE USER_NAMES ADD ENCRYPT_PWD NUMBER(1);
--#end if

--#if GetColumnComment("USER_NAMES.ENCRYPT_PWD")<>"1 - ����������� ������" then
COMMENT ON COLUMN USER_NAMES.ENCRYPT_PWD IS '1 - ����������� ������';
--#end if

--#if not ColumnExists("USER_NAMES.MAX_PROMISED_PAYMENT") then
ALTER TABLE USER_NAMES ADD MAX_PROMISED_PAYMENT NUMBER(15, 2);
--#end if

--#if GetColumnComment("USER_NAMES.MAX_PROMISED_PAYMENT")<>"������������ ��������� ������" then
COMMENT ON COLUMN USER_NAMES.MAX_PROMISED_PAYMENT IS '������������ ��������� ������';
--#end if

CREATE SYNONYM WWW_DEALER.USER_NAMES FOR LONTANA.USER_NAMES;

GRANT SELECT, INSERT ON LONTANA.USER_NAMES TO WWW_DEALER;

alter table USER_NAMES add
(
  LAST_CRM_PHONEUNREF_ID NUMBER(10,0) DEFAULT 0,
  VIEW_OPERATOR_LOG NUMBER(1,0)
);

COMMENT ON COLUMN USER_NAMES.LAST_CRM_PHONEUNREF_ID IS '��������� �������������� ��� ������ ID ������������ ������ (������� �����)';
COMMENT ON COLUMN USER_NAMES.VIEW_OPERATOR_LOG IS '����� �� �������� �����. 1- ���������; 0 - ���������';

alter table USER_NAMES add(SHOW_BLOCK_UNBLOCK_BTN  INTEGER);
COMMENT ON COLUMN USER_NAMES.SHOW_BLOCK_UNBLOCK_BTN IS '����������� ����������/�������������(����� ���.��������� -> ������ � ����������)';

alter table USER_NAMES add(  CRM_ADMIN INTEGER);

COMMENT ON COLUMN USER_NAMES.CRM_ADMIN IS '������� ������ ������ �� ����� � CRM, � ���������� ������ ��������� �� �����. 1- �����; 0 - ������� ������������';

ALTER TABLE USER_NAMES ADD RIGHT_CANCEL_CONTRACT INTEGER;

COMMENT ON COLUMN USER_NAMES.RIGHT_CANCEL_CONTRACT IS '����������� ����������� ��������';

ALTER TABLE USER_NAMES ADD CONTRACT_ACTIVE_CHAT INTEGER DEFAULT 0;

COMMENT ON COLUMN USER_NAMES.CONTRACT_ACTIVE_CHAT IS '������� ��������� ���������� �������� � ���������, ��������� id ��������� (0 - ��������� ������� ���)';

ALTER TABLE USER_NAMES ADD WORK_WITH_CHAT INTEGER DEFAULT 0;

COMMENT ON COLUMN USER_NAMES.WORK_WITH_CHAT IS '������� ����, ��� ������������ ����� �������� � �����';

ALTER TABLE USER_NAMES ADD IS_NOT_BREAK_CHAT INTEGER DEFAULT 0;

COMMENT ON COLUMN USER_NAMES.IS_NOT_BREAK_CHAT IS '������� ������ ������� ���� �� ������ ������������ � 10 ���'; 

alter table user_names add(tickets_per_page integer);

COMMENT ON COLUMN user_names.tickets_per_page is '���������� ������ �� �������� (��� CRM)';

alter table user_names add(work_with_tariff_activation integer);

COMMENT ON COLUMN user_names.work_with_tariff_activation is '����������� ������ � �������� �� ��������� �������';