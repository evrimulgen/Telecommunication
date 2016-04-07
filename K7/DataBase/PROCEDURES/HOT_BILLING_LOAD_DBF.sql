CREATE OR REPLACE PROCEDURE HOT_BILLING_LOAD_DBF IS
--Version=7
--
--7. 2015.11.26. �������. ������� �������� �������� AT_SOC, PC_PLAN_CD, C_ACT_CD, MESSAGE_TP, SRV_FT_CD, UOM, DISCT_SOCS
--v.6 ������� 18.06.2015 ������� �������� ������� PROV_ID
--v.5 ������� 28.04.2015 ������� ������� �������� ������ � ����, ���� ��� ���� ������� ��� ���������
--                      ������� ���������� �� Email, ���� ��������� ������ �� ������ ��������
--v.4 ������� 25.03.2015 ������� HOT_BILLING_ALARM_PHONE
--v.3 ������� 10.12.2014 ������ �������� �� ������������ ����������� ����� (������������ ������ �������)
--v.2 ������� ������ �������� �� load_date
--
  CURSOR curf IS
    SELECT ROWID, hbf.file_name, hbf.hbf_id
      FROM HOT_BILLING_FILES hbf
      WHERE hbf.load_edate IS NULL         
        AND SUBSTR (hbf.file_name, -3) = 'dbf'
        AND nvl(HBF.LOAD_COUNT, 0) = 0
      ORDER BY hbf.hbf_id;
  rowi             ROWID;
  filen            VARCHAR2 (50);
  hbf_idp          FLOAT;
  vDEL_ROW_COUNT   INTEGER;
BEGIN
  OPEN curf;
  LOOP
    FETCH curf INTO rowi, filen, hbf_idp;
    EXIT WHEN curf%NOTFOUND;
    BEGIN
      UPDATE HOT_BILLING_FILES hbf
        SET hbf.load_sdate = SYSDATE
        WHERE ROWID = rowi;
      COMMIT;
      dbase_pkg.load_table (
         p_dir        => 'DBF_FILES',
         p_file       => filen,
         p_tname      => 'HOT_BILLING_TEMP_CALL',
         p_dbf_id     => hbf_idp,
         p_cnames     => 'SUBSCR_NO,CH_SEIZ_DT,AT_SOC,AT_FT_CODE,PC_PLAN_CD,C_ACT_CD,AT_CHG_AMT,CALLING_NO,MESSAGE_TP,SRV_FT_CD,DURATION,DATA_VOL,IMEI,CELL_ID,PROV_ID,DIALED_DIG,UOM,DISCT_SOCS,AT_FT_DESC',
         p_colnames   => 'SUBSCR_NO,CH_SEIZ_DT,AT_SOC,AT_FT_CODE,PC_PLAN_CD,C_ACT_CD,AT_CHG_AMT,CALLING_NO,MESSAGE_TP,SRV_FT_CD,DURATION,DATA_VOL,IMEI,CELL_ID,PROV_ID,DIALED_DIG,UOM,DISCT_SOCS,AT_FT_DESC',
         p_show       => FALSE);
      vDEL_ROW_COUNT := null;
      --������� ������ ������� �� ��������
      DELETE FROM hot_billing_temp_call htc
        WHERE HTC.DBF_ID = hbf_idp 
          AND (htc.ch_seiz_dt IS NULL
              OR htc.ch_seiz_dt NOT LIKE ('20%')
              OR (NOT REGEXP_LIKE (duration, '[0-9]')))
        RETURN COUNT (*) INTO vDEL_ROW_COUNT;
      COMMIT; 
      UPDATE HOT_BILLING_FILES hbf
        SET hbf.load_edate = SYSDATE, 
            HBF.DEL_ROW_COUNT = nvl(vDEL_ROW_COUNT, 0),
            HBF.LOAD_COUNT = nvl(HBF.LOAD_COUNT, 0) + 1
        WHERE ROWID = rowi;
      -- ��������� ������ �� ������� ����������     
      for rec in (select distinct subscr_no  
                    from hot_billing_temp_call 
                    where dbf_id = hbf_idp)
      loop
        HOT_BILLING_ALARM_PHONE(rec.subscr_no, hbf_idp);     
      end loop;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        UPDATE HOT_BILLING_FILES hbf
          SET HBF.LOAD_COUNT = nvl(HBF.LOAD_COUNT, 0) + 1
          WHERE ROWID = rowi;
        COMMIT;                     
        send_sys_mail(sys_context('userenv', 'CURRENT_SCHEMA')||' ������ ��� �������� �����', 
          '������ ��� �������� �����: '|| filen|| '<br> ����� ������:<br>'||SQLERRM, 'TARIFER_SUPPORT_MAIL');
    END;
  END LOOP;
  CLOSE curf;
END;
/