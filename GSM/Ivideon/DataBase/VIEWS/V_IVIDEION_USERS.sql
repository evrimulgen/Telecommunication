CREATE OR REPLACE VIEW V_IVIDEION_USERS
AS
  SELECT
  --
  --#V.1
  --
  --v.1 ������� - 09.02.2016 - ����� ��� ����������� ���� ������������� ������� IVIDEON
  --
    IA.ABONENT_ID,
    IA.E_MAIL,
    IA.FIO,
    IA.IVIDEON_PASSWORD,
    IA.IVIDEON_USER_ID,
    IA.PASSWORD
  from IVIDEON_ABONENTS ia;
  
GRANT SELECT ON V_IVIDEION_USERS TO WWW_DEALER;   