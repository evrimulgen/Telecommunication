drop table attempts cascade constraints;

create table sms_attempts 
(
   sms_id               INTEGER              not null,
   attempt_id           INTEGER              not null,
   submit_seq           INTEGER              not null,
   start_date           DATE                 not null,
   sms_address          VARCHAR2(22)         not null,
   submit_date          DATE,
   submit_resp_result   INTEGER,
   submit_resp_date     DATE,
   smsc_message_id      VARCHAR2(22),
   result_date          DATE,
   result               INTEGER,
   result_text          VARCHAR2(1000),
   constraint PK_SMS_ATTEMPTS primary key (attempt_id, sms_id, submit_seq)
);

comment on column sms_attempts.sms_id is
'Id sms (������������� �������� id ������� sms_current';

comment on column sms_attempts.attempt_id is
'Id �������';

comment on column sms_attempts.submit_seq is
'Id ������� submit_sm';

comment on column sms_attempts.start_date is
'���� ������ ���������';

comment on column sms_attempts.sms_address is
'�����, ���� ���������� SMS';

comment on column sms_attempts.submit_date is
'���� �������� ������� submit_sm';

comment on column sms_attempts.submit_resp_result is
'��������� ������� submit_sm';

comment on column sms_attempts.submit_resp_date is
'���� ������ ���������� ������� submit_sm';

comment on column sms_attempts.smsc_message_id is
'SMSC_ID (���� ������� submit_sm ��������� �������)';

comment on column sms_attempts.result_date is
'���� ������ ���������';

comment on column sms_attempts.result is
'��������� �������� (0 - ����������, -1 - �� ����������)';

comment on column sms_attempts.result_text is
'����� ���������';

/*==============================================================*/
/* Index: attempts_smsc_id_address                              */
/*==============================================================*/
create index attempts_smsc_id_address on sms_attempts (
   sms_address ASC,
   smsc_message_id ASC
);

grant insert, update, delete, select on sms_attempts to BEELINE_SEND_SMS_USER;

CREATE OR REPLACE SYNONYM BEELINE_SEND_SMS_USER.sms_attempts for sms_attempts;