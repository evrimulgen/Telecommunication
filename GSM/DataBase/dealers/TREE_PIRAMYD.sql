DROP TABLE TREE_PIRAMYD CASCADE CONSTRAINTS;

CREATE TABLE TREE_PIRAMYD
(
  MANAGER_GUID  VARCHAR2(50 char),
  MANAG_NAME    VARCHAR2(50 CHAR),
  RELATION_KEY  INTEGER,
  N_ROW         INTEGER,
  TAX           NUMBER,
  BONUS         NUMBER,
  DATE_BONUS    DATE,
  DATE_LOAD     DATE,
  LEVEL_TREE    INTEGER
);


COMMENT ON COLUMN TREE_PIRAMYD.MANAGER_GUID IS 'GUID ���������';

COMMENT ON COLUMN TREE_PIRAMYD.N_ROW IS '����� ������, ������������ � �������� �����';

COMMENT ON COLUMN TREE_PIRAMYD.MANAG_NAME IS '��� ���������';

COMMENT ON COLUMN TREE_PIRAMYD.RELATION_KEY IS '���� ����� � �������, ��������� �� ����� ������';

COMMENT ON COLUMN TREE_PIRAMYD.TAX IS '�����, ������������ ����� �������� ����� ���������';
    
COMMENT ON COLUMN TREE_PIRAMYD.BONUS IS '�����, ������� �������� ���������, �.�. ������� ������'; 

COMMENT ON COLUMN TREE_PIRAMYD.LEVEL_TREE IS '������� ��������, ����������� ����� �������� ��� �� ���������';

COMMENT ON COLUMN TREE_PIRAMYD.DATE_BONUS IS '���� ���������� ������';

COMMENT ON COLUMN TREE_PIRAMYD.DATE_LOAD IS '���� �������� ����� (���������� ������������)';


