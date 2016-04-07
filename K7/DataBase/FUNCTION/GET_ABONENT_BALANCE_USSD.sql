CREATE OR REPLACE FUNCTION GET_ABONENT_BALANCE_USSD(
  pPHONEA IN VARCHAR2
  ) RETURN VARCHAR2 IS
--#Version=7
--18.02.2016 �������. ������� ����� ����� ������� ������ �� accounts 
--29.06.2015 ��������. � ������� ������� ������� ��������, ������� �� ��������� ������ �� �������� �������� ������ (������� 1)
--20.02.2015 �������. ������ 2606. ������-���� +500� ��� ������� ��� ���������.
--03.02.2015 ��������. ��� ����������� (93,99) � ��������� � ������� ����� 500 �������� �� 800 (������: ������� ����� � ������ 800 ������)
--12.11.2014 ��������. �������� ��� � �������� � ����������� �� ����. ������� (��� ��� �������). ��� Teletie
--25.11.2014 ��������. ������� PROMISED_PAYMENTS �������� �� ����� V_ACTIVE_PROMISED_PAYMENTS
  CURSOR C IS
    SELECT PROMISED_SUM, PROMISED_DATE
      FROM V_ACTIVE_PROMISED_PAYMENTS
      WHERE PHONE_NUMBER = pPHONEA;
  vDUMMY C%ROWTYPE;
  PRAGMA AUTONOMOUS_TRANSACTION;
  USSD_BACK_TXT VARCHAR2 (300 CHAR);
  accountid INTEGER;
  balance NUMBER;
  n_group_id NUMBER;
  vPHONEA VARCHAR2(10 CHAR);
  SMS_ITOG VARCHAR2(300 CHAR);
  vIS_COLLECTOR INTEGER;
  V_CONTRACT_ID INTEGER;
  
  --������� ��������� ������� ��������� �� �������� ����� ������
  function get_sms_text_template (pAccountID ACCOUNTS.ACCOUNT_ID%TYPE, pBalance Number)
  Return varchar2
  as
    v_sms ACCOUNTS.BALANCE_USSD_TEXT%TYPE;
  begin
    
    begin
      select BALANCE_USSD_TEXT into v_sms
      from accounts a
      where 
        a.account_id = pAccountID;
    exception
      when OTHERS then
        v_sms := null; 
    end;
    
    v_sms := nvl(v_sms, '��� ������ %balance% ���.');
    
    v_sms := replace(v_sms, '%balance%', pBalance); 
    
    Return v_sms;  
  end;
  
BEGIN
  IF NVL(MS_PARAMS.GET_PARAM_VALUE('USSD_BALANCE_INFO_ON'), 0) = '1' THEN
    IF (MS_CONSTANTS.GET_CONSTANT_VALUE ('USES_MNP') = 1) THEN
      vPHONEA := MNP_TEMP_TO_MAIN (pPHONEA);
    ELSE
      vPHONEA := pPHONEA;
    END IF;

    SELECT GET_ACCOUNT_ID_BY_PHONE (vPHONEA) INTO accountid FROM DUAL;

    BEGIN  --���� ����� ������� ���������� ������ ������ �� ��������� ��������.
      n_group_id := 0;

      SELECT ct.GROUP_ID
        INTO n_group_id
        FROM contracts ct
        WHERE ct.phone_number_federal = vPHONEA
          AND NOT EXISTS (SELECT 1
                            FROM contract_cancels cc
                            WHERE ct.contract_id = cc.contract_id)
          AND EXISTS (SELECT 1
                        FROM contract_groups cg
                        WHERE cg.GROUP_ID = ct.GROUP_ID
                          AND cg.paramussd_gr_bal > 0);

      SELECT SUM(get_abonent_balance(c.phone_number_federal, c.contract_cancel_date, null, 1))
        INTO balance
        FROM v_contracts c
        WHERE c.GROUP_ID = n_group_id;
    EXCEPTION
      --���� ������ ���, �� ������ ������
      WHEN OTHERS THEN
        SELECT GET_ABONENT_BALANCE (vPHONEA, null, null, 1) INTO balance FROM DUAL;
    END;

    --���������� ������������� ���� ��� ���
    SELECT COUNT(IS_COLLECTOR)
      INTO vIS_COLLECTOR
      FROM ACCOUNTS
      WHERE ACCOUNT_ID = accountid AND IS_COLLECTOR IS NOT NULL;
    -- ���������� ��������.
    SELECT COUNT(C.CONTRACT_ID) INTO V_CONTRACT_ID
      FROM CONTRACTS C, CONTRACT_CANCELS CC
      WHERE C.PHONE_NUMBER_FEDERAL = pPHONEA
        AND C.CONTRACT_ID = CC.CONTRACT_ID(+)
        AND CC.CONTRACT_CANCEL_DATE IS NULL;
    IF (V_CONTRACT_ID <= 0) AND (vIS_COLLECTOR <> 0) THEN
      balance:=balance + 500;
    END IF;

    
    USSD_BACK_TXT := get_sms_text_template(accountid, balance);
    
   --���������� ���������, ���� ������� ��������� ������ (������ ��� Teletie)
    IF (vIS_COLLECTOR <> 0) THEN
      --��������� ������� ���������� �������
      OPEN C;
      FETCH C INTO vDUMMY;
      IF C%FOUND THEN
         IF vDUMMY.PROMISED_SUM <> 0 THEN
            SMS_ITOG := loader3_pckg.send_sms(vPHONEA, 'AgSv',
                     '������ ' || (balance - vDUMMY.PROMISED_SUM) || ' ���. ��������� ������ ' || TO_CHAR (vDUMMY.PROMISED_SUM)
                      || ' ���., ��������� �� ' || TO_CHAR (vDUMMY.PROMISED_DATE, 'DD.MM.YYYY') || '.');
         END IF;
      END IF;
    END IF;
  ELSE
    USSD_BACK_TXT:='�������� ������� �������� ����������';
  END IF;

  RETURN USSD_BACK_TXT;
END;
/
