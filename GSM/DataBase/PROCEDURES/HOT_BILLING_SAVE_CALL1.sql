/* Formatted on 23/03/2015 15:08:05 (QP5 v5.252.13127.32867) */
CREATE OR REPLACE PROCEDURE hot_billing_save_call1
IS
--
--v2 ������� 23.03.2015 ����� �������� ����������. ������� �� �  hot_billing_PCKG.SAVE_CALL (1, 0, 0);
--
BEGIN
   -- Call the procedure
   hot_billing_PCKG.SAVE_CALL (1, 0, 0);
   -- ����� � �������� ������ �� ��� � ��
   --DELETE_DOUBLE_DETAIL;
   
END;
/
