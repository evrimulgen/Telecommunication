CREATE OR REPLACE PROCEDURE EXPORT_CALLS_TO_TEXT (
--
--#Version=1
--
-- ������������� ���� �� ������� �����
--
        PROG_FILE_DIR IN VARCHAR2, -- ���� � ����� � ���������� ������
        MONTH_YEAR IN VARCHAR2,     --�����_��� �� ������� ���������� ��������
        EXT_FILE_PATH IN VARCHAR2, --���� ���� ����� ����������� �����
        CONNECT_STR IN VARCHAR2, --������ ����������
        WORK_SCHEMA_NAME IN VARCHAR2      -- ��� ����� ��� ������� ������������ �������� ������
)
AS
      LANGUAGE JAVA
      NAME 'JAVA_EXPORT_CALLS_TO_TEXT.EXPORT_CALLS_TO_TEXT ( java.lang.String,
                          java.lang.String,
                          java.lang.String,
                          java.lang.String,
                          java.lang.String
                                 ) 
      ';