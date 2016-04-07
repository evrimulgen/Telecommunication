create table MESSAGE_TEXTS
(
  TEXT_BLOCK_SMS   VARCHAR2(140 CHAR),
  TEXT_NOTIFY_SMS  VARCHAR2(160 CHAR),
  TEXT_NOTIFY_SMS2 VARCHAR2(200 CHAR)
)

comment on table MESSAGE_TEXTS is '������� ������� ���������';
comment on column MESSAGE_TEXTS.TEXT_BLOCK_SMS   is '����� ����������� ���';
comment on column MESSAGE_TEXTS.TEXT_NOTIFY_SMS  is '����� ��������������� ���';
comment on column MESSAGE_TEXTS.TEXT_NOTIFY_SMS2 is '����� ��������������� ��� 2';

UPDATE message_texts SET text_block_sms='��� ������ %balance% ���. ��� ����� ������������. �.788-79-08.';
UPDATE message_texts SET text_notify_sms='��� ������ ������ � ���������� �����. �.788-79-08.';
UPDATE message_texts SET text_notify_sms2='������ ������ ����� %balance% �� ��������� ���������� ��������� ����. �������� ������� *132*11# �����. ����������� ����� +74957378081';


--#if not ColumnExists("MESSAGE_TEXTS.TEXT_NOTIFY_SMS_HAND_BLOCK")
ALTER TABLE MESSAGE_TEXTS ADD TEXT_NOTIFY_SMS_HAND_BLOCK VARCHAR2(200 CHAR);
COMMENT ON COLUMN MESSAGE_TEXTS.TEXT_NOTIFY_SMS_HAND_BLOCK IS '����� ��������������� ��� ��� ������� � ������ ������ ���������� �/� ������ - ������� � ������� �����������';
--#end if

--#if not ColumnExists("MESSAGE_TEXTS.TEXT_NOTIFY_SMS_HAND_BLOCK_4_PITER")
ALTER TABLE MESSAGE_TEXTS ADD TEXT_NOTIFY_SMS_HAND_BLOCK_4_PITER VARCHAR2(200 CHAR);
COMMENT ON COLUMN MESSAGE_TEXTS.TEXT_NOTIFY_SMS_HAND_BLOCK_4_PITER IS '����� ��������������� ��� ��� ������� � ������ ������ ���������� �/� ����������� �����';
--#end if