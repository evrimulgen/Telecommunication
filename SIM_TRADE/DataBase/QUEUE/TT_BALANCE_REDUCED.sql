CREATE OR REPLACE TYPE T_PHONE AS OBJECT
(
  PHONE_NUMBER VARCHAR2(11)
);

BEGIN
   DBMS_AQADM.CREATE_QUEUE_TABLE(
      queue_table            => 'QT_TT_BALANCE_REDUCED',
      queue_payload_type     => 'T_PHONE');
END;
/

BEGIN
   DBMS_AQADM.DROP_QUEUE_TABLE(
      queue_table            => 'QT_TT_BALANCE_REDUCED');
END;
/

BEGIN
   DBMS_AQADM.CREATE_QUEUE(
      queue_name         =>  'Q_TT_BALANCE_REDUCED',
      queue_table        =>  'QT_TT_BALANCE_REDUCED');
END;
/

BEGIN
   DBMS_AQADM.START_QUEUE('Q_TT_BALANCE_REDUCED');
END;
/

--EXECUTE TT_BALANCE_REDUCED_PCKG.ADD_PHONE_NUMBER('9277524741', 123.45);

--EXECUTE TT_BALANCE_REDUCED_PCKG.SEND_NOTICES;

CREATE OR REPLACE TRIGGER TAU_CURRENT_BALANCE_REDUCED
AFTER UPDATE ON IOT_CURRENT_BALANCE
FOR EACH ROW
BEGIN
--#Version=1
  -- �������� ��������� � �������� ������� � �������
  IF :NEW.BALANCE < :OLD.BALANCE THEN
    -- ���� ������ ��������
    TT_BALANCE_REDUCED_PCKG.ADD_PHONE_NUMBER(:NEW.PHONE_NUMBER, :NEW.BALANCE);
  END IF;
END;
/

/*

alter TRIGGER TAU_CURRENT_BALANCE_REDUCED enable; 

select * from IOT_CURRENT_BALANCE
order by last_update desc

*/