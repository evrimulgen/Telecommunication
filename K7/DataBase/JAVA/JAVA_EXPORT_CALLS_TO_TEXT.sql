CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "JAVA_EXPORT_CALLS_TO_TEXT" AS
//
//����� ��� ������ �������� ������ �� ������� � �����
//
//#Version=1
//
import java.io.IOException;
public class JAVA_EXPORT_CALLS_TO_TEXT {
    public static void EXPORT_CALLS_TO_TEXT(java.lang.String PROG_FILE_DIR, // ���� � ����� � ���������� ������
                                            java.lang.String MONTH_YEAR,      //�����_��� �� ������� ���������� ��������
                                            java.lang.String EXT_FILE_PATH,   //���� ���� ����� ����������� �����
                                            java.lang.String CONNECT_STR,       //������ ����������
                                            java.lang.String WORK_SCHEMA_NAME       //��� ����� ��� ������� ������������ �������� ������
                                            )
    throws Exception {
    Runtime rt = Runtime.getRuntime();
    java.lang.String PROG_NAME = "ExportCallsToText.exe";
    //user/password@server:port:sid  04_2014  d:\robot\DB\2014_04
    java.lang.String PARAM_STR = " "+ CONNECT_STR + " " + MONTH_YEAR + " " + EXT_FILE_PATH + " " + WORK_SCHEMA_NAME;
    Process proc = rt.exec(PROG_FILE_DIR + PROG_NAME + PARAM_STR);
  }
};
/