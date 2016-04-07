--#if GetVersion("CHECK_MNP_ACCOUNT_PHONE_STATUS") < 1
CREATE OR REPLACE PROCEDURE CHECK_MNP_ACCOUNT_PHONE_STATUS(
  pPHONE_NUMBER IN VARCHAR2
  ) IS  
--
--#Version=1
--
--�������� ������� ���������� ������� MNP
-- 
MNP_CHECK VARCHAR2(9 CHAR);
BEGIN
  select case when pn = 0
        then 'Active'
        else 'NotActive'
       end cs INTO MNP_CHECK      
  from (select count(MNP.PHONE_NUMBER) pn 
      from MNP_REMOVE mnp
      where MNP.IS_ACTIVE = 0
      and MNP.PHONE_NUMBER = pPHONE_NUMBER);
      
  IF MNP_CHECK = 'NotActive' THEN
    UPDATE MNP_REMOVE 
      SET MNP_REMOVE.IS_ACTIVE = 1, MNP_REMOVE.DATE_ACTIVATE = sysdate
      WHERE MNP_REMOVE.PHONE_NUMBER = pPHONE_NUMBER;
  END IF;
  --
END;
/
--#end if
