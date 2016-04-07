CREATE OR REPLACE PROCEDURE CHECK_MONTH_TARIFF_PAY IS

    --version 10
    --v.10 ��������. ��� ������ ������ � ������� PHONE_CALC_ABON_TP_UNLIM_ON � �������� ��������� YEAR_MONTH ��������� ��������� �����.
    --v9. ��������. ����� �������� �� ����� ������������� ��������� ��� ������ ������ � ������� PHONE_CALC_ABON_TP_UNLIM_ON.
    --                     ������ �� ��������� ����� ���� � ������ ������.
    --v8. ��������. ������� ��������� ������ 7. �� ��������������� ������ � ��������� ������ ����������� ���. ������ 302
    --v7. ��������. ������, � ������� �� � ���������. ������� � ������� ������ � ������� ������ � ������������� �� ���� ���������� ��� ������� ���. ������ 302 �� �����������
    --                     ����� ���. ������ �� ������������ ������ �� �������� ������.
    --v6. ��������. ��������� ������ � ����. PHONE_CALC_ABON_TP_UNLIM_ON ������ ��������� ��������
    --v5. ��������. ��� ������� � ����. PHONE_CALC_ABON_TP_UNLIM_ON ������� ������ ���� TARIFF_ID
    --v4. ��������. ������� ������ �������, �� ������� ������ �������� �������� �� � ������� PHONE_CALC_ABON_TP_UNLIM_ON
    --v3. ��������.  ������� ����.  CONTRACTS �� views V_CONTRACTS. ������� ������� �������������� ���. �������
    
    NOW_MONTH INTEGER;
    vRes INTEGER;
    pPhoneCnt INTEGER;
    vIS_ACTIVE INTEGER;
BEGIN
    --���������� ���/�����
    NOW_MONTH:=TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'));
    --� ��������� ���� ������ ����������� ���. ������ "�����, ������������ ��� ����.����� �� ���."
    IF TO_CHAR(SYSDATE, 'YYYYMM') <> TO_CHAR(SYSDATE+1, 'YYYYMM') THEN
        FOR rec IN (SELECT 
                              C.CONTRACT_ID,
                              C.PHONE_NUMBER_FEDERAL, 
                              TR.MONTHLY_PAYMENT,
                              NVL(TR.IS_AUTO_INTERNET, 0) IS_AUTO_INTERNET,
                              C.CONTRACT_DATE, 
                              TR.TARIFF_ID
                          FROM V_CONTRACTS C, 
                                   TARIFFS TR/*, 
                                   DB_LOADER_ACCOUNT_PHONES D*/
                          WHERE C.TARIFF_ID = TR.TARIFF_ID(+)
                            AND NVL(TR.DISCR_SPISANIE, 0) = 1                    
                            AND C.DOP_STATUS IS NULL
                            /*AND D.PHONE_NUMBER = C.PHONE_NUMBER_FEDERAL
                            AND D.YEAR_MONTH = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'))
                            AND NVL(D.PHONE_IS_ACTIVE, -1) = 1*/)
        LOOP
            --���� �� ����� ������������ ������� ��� �������� ������
            IF GET_ABONENT_BALANCE(rec.PHONE_NUMBER_FEDERAL) <= rec.MONTHLY_PAYMENT THEN
                vRes := 1;
                --���� �� ������ �� � ��������������� ������� � �������� ������� � ������� ������, �� ���. ������ �� ����������� � ���������� �����
                IF (NVL(ms_constants.GET_CONSTANT_VALUE('CALC_ABON_TP_UNLIM_ON'), 0) = 1) AND --���� ������� �������� �������� ������ �� �� � ���������
                    (rec.IS_AUTO_INTERNET = 1) AND --���� �� � ��������� ��������������� �������
                    ((to_number(to_char(rec.CONTRACT_DATE, 'YYYYMM')) = to_number(to_char(sysdate, 'YYYYMM')))
                      OR
                     ((to_number(to_char(rec.CONTRACT_DATE, 'YYYYMM')) <> to_number(to_char(sysdate, 'YYYYMM'))) AND (to_number(MS_params.GET_PARAM_VALUE('CALC_ABON_TP_UNLIM_ON_4_OLD_PHN')) = 1))) THEN
                    --��������� ������ ������. ���� �������, �� ����������
                    vIS_ACTIVE := 0;
                    SELECT count(*)
                        INTO vIS_ACTIVE
                      FROM DB_LOADER_ACCOUNT_PHONES DB
                    WHERE DB.PHONE_NUMBER = rec.PHONE_NUMBER_FEDERAL
                         AND DB.YEAR_MONTH = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'))
                         AND NVL(DB.PHONE_IS_ACTIVE, 0) = 1;
                       
                    IF NVL(vIS_ACTIVE, 0) > 0 THEN                        
                        --��������� ������� ������� ������ � ����., ���� ���, �� ���������� ����� ������
                        --������ ������������ � ������� �����/�������, �.�. ������������ ������ ����� ������������� ��������� (�.�. ���������� �������� ����. � ������ ������)
                        pPhoneCnt := 0;
                        SELECT count(*)
                            INTO pPhoneCnt
                           FROM PHONE_CALC_ABON_TP_UNLIM_ON
                         WHERE PHONE_NUMBER = rec.PHONE_NUMBER_FEDERAL
                             AND YEAR_MONTH = to_number(TO_CHAR(ADD_MONTHS(sysdate, 1), 'YYYYMM'))
                             AND TARIFF_ID = rec.TARIFF_ID;
                        --
                        IF pPhoneCnt = 0 THEN
                            INSERT INTO PHONE_CALC_ABON_TP_UNLIM_ON (YEAR_MONTH, PHONE_NUMBER, TARIFF_ID) 
                            VALUES (to_number(TO_CHAR(ADD_MONTHS(sysdate, 1), 'YYYYMM')), rec.PHONE_NUMBER_FEDERAL, rec.TARIFF_ID);
                            commit;                           
                        END IF;
                        --
                        vRes := 0; 
                    END IF;                  
                END IF;
                
                IF vRes = 1 THEN
                    UPDATE CONTRACTS C
                          SET C.DOP_STATUS = 302
                     WHERE C.CONTRACT_ID = rec.CONTRACT_ID;
                    COMMIT;
                END IF;
            END IF;
        END LOOP;  
    END IF;
    --������ ���. �������
    FOR rec IN (SELECT 
                         C.CONTRACT_ID,
                         C.PHONE_NUMBER_FEDERAL, 
                         TR.MONTHLY_PAYMENT
                      FROM V_CONTRACTS C, 
                                TARIFFS TR/*, 
                                DB_LOADER_ACCOUNT_PHONES D*/
                      WHERE C.TARIFF_ID = TR.TARIFF_ID(+)
                           AND NVL(TR.DISCR_SPISANIE, 0) = 1
                           AND NVL(C.DOP_STATUS, 0) = 302
                     /* AND D.PHONE_NUMBER = C.PHONE_NUMBER_FEDERAL
                      AND D.YEAR_MONTH = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'))
                      AND NVL(D.PHONE_IS_ACTIVE, -1) = 0*/)
    LOOP
        IF GET_ABONENT_BALANCE(rec.PHONE_NUMBER_FEDERAL) > rec.MONTHLY_PAYMENT THEN
            UPDATE CONTRACTS C
                  SET C.DOP_STATUS = NULL
             WHERE C.CONTRACT_ID = rec.CONTRACT_ID;
            COMMIT;
        END IF;
    END LOOP;  
END;