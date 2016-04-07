CREATE OR REPLACE PROCEDURE P_USSD_CHANGE_PP_SEND_MAIL AS
  --
  --#Version=1
  --
  --v.1 ������� 23,09,2015 ������� ��������� �������� ������ �� ����� ��������� �����, ���������� �� USSD, �� EMAIL
  --
  --
  cUSSD_SEND_MAIL_STATUS_ID USSD_CHANGE_CONTRACT_STATUS.USSD_CHANGE_CONTRACT_STATUS_ID%TYPE := 4; --���� ��������
  cUSSD_ADD_STATUS_ID CONSTANT USSD_CHANGE_CONTRACT_STATUS.USSD_CHANGE_CONTRACT_STATUS_ID%TYPE := 2; --���.������� ��������
  vMailText varchar2(3000);
BEGIN
  
  vMailText := '';
  for rec in (
              select 
                    PP.ERROR_MESSAGE,
                    pp.rowid r_ROWID
              from
                USSD_CHANGE_PP_LOG pp
              where
                PP.USSD_CHANGE_CONTRACT_STATUS_ID = cUSSD_SEND_MAIL_STATUS_ID
           )
  loop
    vMailText := vMailText|| rec.ERROR_MESSAGE;
    
    
    update USSD_CHANGE_PP_LOG
        set USSD_CHANGE_CONTRACT_STATUS_ID = cUSSD_ADD_STATUS_ID
       where USSD_CHANGE_PP_LOG.rowid = rec.r_rowid;
       
  end loop;
  
  commit;
  
  if length(trim(vMailText)) > 0 then
    vMailText := '<table  border="1" cellspacing="0" cellpadding="8">'
                 ||vMailText
                 ||'</table>';
    vMailText := '����� ��������� �����:<br><br>'||vMailText;
                 
    send_sys_mail (
                   '����� ��',
                   vMailText ,
                  'CHANGE_PP_EMAIL'
                );
  end if;
END;

