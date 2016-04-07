--#if not ObjectExists("S_NEW_ROAMING_RETARIF_SERV_ID")
CREATE SEQUENCE S_NEW_ROAMING_RETARIF_SERV_ID;
--#end if

--#if not TableExists("ROAMING_RETARIF_SERVS") then
CREATE TABLE ROAMING_RETARIF_SERVS
(
  ID           INTEGER  CONSTRAINT PK_ROAMING_RETARIF_SERVS PRIMARY KEY,
  NAME          VARCHAR2(250 CHAR),
  USER_CREATED  VARCHAR2(30 CHAR),
  DATE_CREATED  DATE,
  USER_LAST_UPDATED  VARCHAR2(30 CHAR),
  DATE_LAST_UPDATED  DATE
);
--#end if

--#if GetTableComment("ROAMING_RETARIF_SERV")<>"���������� ����� � ��������" then
COMMENT ON TABLE ROAMING_RETARIF_SERVS IS '���������� ����� � ��������';
--#end if

--#if GetColumnComment("ROAMING_RETARIF_SERVS.ID") <> "��������� ����" then
COMMENT ON COLUMN ROAMING_RETARIF_SERVS.ID IS '��������� ����';
--#end if

--#if GetColumnComment("ROAMING_RETARIF_SERVS.NAME") <> "�������� ������" then
COMMENT ON COLUMN ROAMING_RETARIF_SERVS.NAME IS '�������� ������';
--#end if

--#if not IndexExists("UQ_ROAMING_RETARIF_SERVS_NAME") THEN
CREATE UNIQUE INDEX UQ_ROAMING_RETARIF_SERVS_NAME ON ROAMING_RETARIF_SERVS(NAME);
--#end if

--#IF GetVersion("TIU_ROAMING_RETARIF_SERVS") < 1 THEN
CREATE OR REPLACE TRIGGER TIU_ROAMING_RETARIF_SERVS 
  BEFORE INSERT OR UPDATE ON ROAMING_RETARIF_SERVS FOR EACH ROW 
--#Version=1
BEGIN 
  IF INSERTING THEN 
    IF NVL(:NEW.ID, 0) = 0 then 
      :NEW.ID := S_NEW_ROAMING_RETARIF_SERV_ID.NEXTVAL; 
    END IF; 
    :NEW.USER_CREATED := USER; 
    :NEW.DATE_CREATED := SYSDATE;
  END IF; 
  :NEW.USER_LAST_UPDATED := USER; 
  :NEW.DATE_LAST_UPDATED := SYSDATE; 
END;
--#end if


insert into ROAMING_RETARIF_SERVS (name) values ('(���) � ��.���� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��.��������� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��.�� ��.���� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��.��������� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��/������� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��/��� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��/��� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��/�������� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��� ������ ������� ����������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ���.��������� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ���/������� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ���/��� � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �������. �/� (������� ��������� �� ���������� ������� �������)');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ���. ���. �� (������ ������)(� ���������� ������� �������)');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ���. ���. �� (��������� ������)(� ���������� ������� �������)');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ������������ ������ � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ������ � ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ���������� �� ��.�������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���)������ � �O �� ��');
-- �����
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� �/�');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� �/� �� "������"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� �� ����� ��.����');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� ���. �� "������"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �������� � ���.������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �������� � "�������"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �������� � "���"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �������� � ���.������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �������� � ������ ��.����');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ���������  (������/��)');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ����.�� ��.������� (��������.)');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �������� � "���� ����"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �?������� � ������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �?������� �� ������� "������"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �����?��� (������/��)');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) �����?��� � ������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� (?�����/��)');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� (������/��)');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� ?� ������� "������"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� � ������');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� �� "�������"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� �� "���"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ��������� �� ������� "������"');
insert into ROAMING_RETARIF_SERVS (name) values ('(���) ����.������ � ��.�������');
--
commit;