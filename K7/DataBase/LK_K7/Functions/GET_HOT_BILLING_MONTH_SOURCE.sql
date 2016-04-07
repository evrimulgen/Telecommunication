CREATE OR REPLACE FUNCTION K7_LK.GET_HOT_BILLING_MONTH_SOURCE (
   pYEAR_MONTH   IN INTEGER)
   RETURN VARCHAR2
IS
   --
   --#Version=1
   --
   -- ���������� �������� �����������
   --
   -- ������� ���������:
   --   pYEAR_MONTH - ��� � ����� � ������� 201407 (YYYYMM)
   --
   -- ��������� �������:
   --   ��� ���������:
   --     'TABLE' - � ������� CALL_MM_YYYY,
   --     'DISK'  - �� �����.
   --
   CURSOR C
   IS
      SELECT DECODE (DB,  1, 'TABLE',  0, 'DISK',  'UNKNOWN')
        FROM CORP_MOBILE.HOT_BILLING_MONTH
       WHERE HOT_BILLING_MONTH.YEAR_MONTH = pYEAR_MONTH;

   vRESULT   VARCHAR2 (20 CHAR);
BEGIN
   OPEN C;

   FETCH C INTO vRESULT;

   CLOSE C;

   RETURN vRESULT;
END;
/
