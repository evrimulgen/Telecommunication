CREATE OR REPLACE PROCEDURE CALC_BALANCE_ROWS2 (
   pPHONE_NUMBER       IN            VARCHAR2,
   pDATE_ROWS          IN OUT NOCOPY DBMS_SQL.DATE_TABLE,
   pCOST_ROWS          IN OUT NOCOPY DBMS_SQL.NUMBER_TABLE,
   pDESCRIPTION_ROWS   IN OUT NOCOPY DBMS_SQL.VARCHAR2_TABLE,
   pFILL_DESCRIPTION   IN            BOOLEAN DEFAULT TRUE,
   pBALANCE_DATE       IN            DATE DEFAULT NULL)
IS
   --
   --#Version=69
   --69. 2016.15.03 ������. ���� � ��������� ���������� ���� HANDS_BILLING, �� ������ ������� ���������� ��� ������ ���� �������� - ��� ���������� ����� �� ������ ����������� ����� ���������
   --68. 2015.05.12 ��������. ���� ���� ������� ������ ������� ����, �� ����� ������� ������� ���� ��� ����������� ��������� ���� � ��������� ��������
   --67. 2015.05.12 ��������. ��� ������������ ������� �������� ����������, ������� 2 ������� ��� �� �������. �������� ����� ������ ���� ����� ��������� ������
   --66. 2015.05.12 ��������. ������� ����������� ������� ������� �� ���� �������� ������ (������ ������ ���������� ������). ������ �� �������� ����� �������� �� ������ �����������
   --65. 2015.03.31. �������.������� ��������� ���������� ���������� ��� ������,������ D.END_DATE >= trunc(SYSDATE) ������ D.END_DATE > SYSDATE
   --64. 2015.03.27. �������. ��������� ��� ����-������.
   --63.2015-03-20 �����. ��������� �������� (NOT vCALC_ABON_PAYMENT_TO_MONTHEND) ������ 1397, �.�. ��������� ���������� �������� � � ������ ������ ���� ������
   --62.04.02.2015 �������. �������� ���� ����. ����� ��� �������� ����� ������������ ���������� nvl(DB_LOADER_ACCOUNT_PHONE_OPTS.ADDED_FOR_RETARIF� 0) <> 1
   --61. �������. ���������� ������ ���� �������.
   --60. �������. ������ ������� �� ������� �� ������� ������������ ������� ���� ���������� DB_LOADER_ABONENT_PERIODS
   --59. �������. ������ ���� �������� ��� �������������, ���������� ����� ���� �������� ��� ��������� ������ ����� ����� ������.
   --58. #1412, #1343
   --55. �������. ������� ���� ����� �����.
   --54. �����. ���������� ������� � APPEND_ROW ����������� ���� ������� ��� ������� �� balance_var_except
   --54. �����. ������� ������� � APPEND_ROW ����������� ���� ������� ��� ������� �� balance_var_except
   --53. �������. �������� ������� ���������� ����� ��� ����������� ������� ������
   --52. �������. ����������� ���� �������� ����� ��� ������ �����..
   --51. �������. ����������� ���� ��� ������� � ������� �������(�������� ������� ��������).
   --50. �������. ���������� �������� �����.
   --49. �������. ����� ���� ����� ���� ������ �� �������� �� �����������. ��������� �������� ����� ���������.
   --48. �������. ���������� ���������� ��� ����� ���.
   --46. �������. ����������� ������������ ��������� ��� ����� �/� ������� ������
   --44. �������. ������ ������
   --35. �������. �������� ������ ����������� ������ � ������.
   --25. �������. �������� ���� ����, �� ������� ������ ��� �����������(����� ���������)
   --24. �������. ������� ���������� ����, ���(����� ������� ���) - �������.
   --22. �������. ��������� ���� ���� ��������� ��� �������� ���������
   --21. ������. ������ ������������� �������, ��������� �� 4 ��� �� ���� ��������.
   --20. �������. ��������� ���������� �������� ���������(RECALC_CHARGE_COST).
   --19. �������. ���� ����� � ������ ���������� ������, �� ������� ��, ������ ����� � ������������.
   --18. �������. �������� ���� ����� �������� ������, ���� �� ����� ��� ������.
   --17. ������. ������ ����� ��������, ������������� � ��������� �������.
   --16. ������. ������ ��������� ���� ��������� �������� ��������� CORRECT_ACTIVATION_DATE_DAYS.
   --    ���� ��������� ���, �� ��������� �� ��������.
   --15. ������. �������� ������ ��������� �� ������ �� ��������� "�� �������".
   --    ������ ��������� �� ����� ������ ���������� �� �������� �������.
   --    ��� ���������� ������ ��� ��������� ����� ������ �������� � 5 ���� �� ������ �������� ��������.
   --14. �������. ������� ������ �� ���� ���������.
   --13. ������. ������� ������ �� �������� ��������� ��� ������������ ������� ���������� �� �����������.
   --12. 29.08.2011 �������. ������� ��������� ���� ����� �� ����, �� �������
   -- �� ��������� ������� ��������� ������� ������� (��� ������)
   --
   DAY_PAY_IN_BLOK         CONSTANT NUMBER := 5;
   DAYS_NESTABIL           CONSTANT INTEGER := 5;
   cDAYS_PAYMENT_BEFORE_CONTRACT    INTEGER := 4; -- ��� �� ������ ���������, ��� ������� ����� ����������� �������
   vTEMP_DATE_BEGIN_ABON            DATE;
   vCONTRACT_DATE                   DATE;

   CURSOR C_CONTRACT
   IS
        SELECT C.CONTRACT_DATE, C.CONTRACT_ID, C.HANDS_BILLING
          FROM CONTRACTS C
         WHERE     C.PHONE_NUMBER_FEDERAL = pPHONE_NUMBER
               AND (pBALANCE_DATE IS NULL OR C.CONTRACT_DATE <= pBALANCE_DATE)
      ORDER BY C.CONTRACT_DATE DESC;

   CURSOR C_BALANCE (
      aPHONE_NUMBER     VARCHAR2,
      aCONTRACT_DATE    DATE)
   IS
        SELECT PHONE_BALANCES.BALANCE_DATE,
               PHONE_BALANCES.BALANCE_VALUE,
               PHONE_BALANCES.FIX_YEAR_MONTH_ID
          FROM PHONE_BALANCES
         WHERE     PHONE_BALANCES.PHONE_NUMBER = aPHONE_NUMBER
               AND (   pBALANCE_DATE IS NULL
                    OR PHONE_BALANCES.BALANCE_DATE <= pBALANCE_DATE)
               AND (   aCONTRACT_DATE IS NULL
                    OR PHONE_BALANCES.BALANCE_DATE >= aCONTRACT_DATE)
      ORDER BY PHONE_BALANCES.BALANCE_DATE DESC;

   CURSOR CODE (
      pDATE   IN DATE)
   IS
      SELECT CELL_PLAN_CODE
        FROM DB_LOADER_ACCOUNT_PHONE_HISTS H
       WHERE     H.PHONE_NUMBER = pPHONE_NUMBER
             AND H.BEGIN_DATE <= pDATE
             AND H.END_DATE >= pDATE;

   CURSOR DB_REPORT (
      pYEAR_MONTH   IN INTEGER)
   IS
      SELECT DATE_LAST_UPDATE,
             TRUNC (-DETAIL_SUM, 2) AS BILL_SUM,
                '���. ��. �� ���. ���. �� '
             || TO_CHAR (DATE_LAST_UPDATE, 'MM.YYYY')
             || ' (�� '
             || TO_CHAR (DATE_LAST_UPDATE, 'DD.MM.YYYY HH24:MI')
             || ')'
                AS REMARKS
        FROM DB_LOADER_REPORT_DATA
       WHERE     DB_LOADER_REPORT_DATA.PHONE_NUMBER = pPHONE_NUMBER
             AND DB_LOADER_REPORT_DATA.YEAR_MONTH = pYEAR_MONTH;

   CURSOR NEW_DATE_ABON (
      pSTART_BALANCE_DATE             IN DATE,
      pCORRECT_ACTIVATION_DATE_DAYS   IN INTEGER)
   IS
      SELECT FIRST_VALUE (H.BEGIN_DATE) OVER (ORDER BY H.END_DATE ASC)
        FROM DB_LOADER_ACCOUNT_PHONE_HISTS H
       WHERE     H.PHONE_NUMBER = pPHONE_NUMBER
             AND H.PHONE_IS_ACTIVE = 1
             AND H.END_DATE >=
                    pSTART_BALANCE_DATE - pCORRECT_ACTIVATION_DATE_DAYS
             AND H.BEGIN_DATE <=
                    pSTART_BALANCE_DATE + pCORRECT_ACTIVATION_DATE_DAYS;

   CURSOR ACC_ID
   IS
      SELECT P1.ACCOUNT_ID
        FROM DB_LOADER_ACCOUNT_PHONES P1
       WHERE     P1.PHONE_NUMBER = pPHONE_NUMBER
             AND P1.YEAR_MONTH = (SELECT MAX (P2.YEAR_MONTH)
                                    FROM DB_LOADER_ACCOUNT_PHONES P2);

   CURSOR OPT_ACT (
      pBEGIN_DATE   IN DATE,
      pEND_DATE     IN DATE)
   IS
        SELECT TRUNC (H.BEGIN_DATE) BEGIN_DATE, TRUNC (H.END_DATE) END_DATE
          FROM DB_LOADER_ACCOUNT_PHONE_HISTS H
         WHERE     H.PHONE_NUMBER = pPHONE_NUMBER
               AND TRUNC (H.BEGIN_DATE) <= TRUNC (pEND_DATE)
               AND TRUNC (H.END_DATE) >= TRUNC (pBEGIN_DATE)
               AND H.PHONE_IS_ACTIVE = 1
      ORDER BY H.BEGIN_DATE ASC;

   CURSOR PH_W_D_A
   IS
      SELECT *
        FROM PHONE_NUMBER_WITH_DAILY_ABON PHA
       WHERE PHA.PHONE_NUMBER = pPHONE_NUMBER;

   CURSOR TARIFF_PAY_TYPE
   IS
      SELECT NVL (tariffs.TARIFF_ABON_DAILY_PAY, 1) CALC_ABON_PAYMENT_TO_NOW
        FROM tariffs
       WHERE TARIFFS.TARIFF_ID =
                GET_PHONE_TARIFF_ID (
                   pPHONE_NUMBER,
                   (SELECT DB_LOADER_ACCOUNT_PHONES.CELL_PLAN_CODE
                      FROM DB_LOADER_ACCOUNT_PHONES
                     WHERE     DB_LOADER_ACCOUNT_PHONES.PHONE_NUMBER =
                                  pPHONE_NUMBER
                           AND DB_LOADER_ACCOUNT_PHONES.LAST_CHECK_DATE_TIME =
                                  (SELECT MAX (P2.LAST_CHECK_DATE_TIME)
                                     FROM DB_LOADER_ACCOUNT_PHONES P2
                                    WHERE P2.PHONE_NUMBER = pPHONE_NUMBER)),
                   SYSDATE);

   CURSOR SDVIG_D (
      cTARIFF_ID              IN INTEGER,
      cBEGIN_DATE             IN DATE,
      cSDVIG_DISCR_SPISANIE   IN INTEGER)
   IS
      SELECT *
        FROM DB_LOADER_ABONENT_PERIODS D
       WHERE     D.PHONE_NUMBER = pPHONE_NUMBER
             AND D.TARIFF_ID = cTARIFF_ID
             AND D.BEGIN_DATE < cBEGIN_DATE
             AND D.YEAR_MONTH =
                    TO_NUMBER (
                       TO_CHAR (
                          ADD_MONTHS (cBEGIN_DATE, -cSDVIG_DISCR_SPISANIE),
                          'YYYYMM'))
             AND NOT EXISTS
                        (SELECT 1
                           FROM DB_LOADER_ABONENT_PERIODS D1
                          WHERE     D1.PHONE_NUMBER = pPHONE_NUMBER
                                AND D1.TARIFF_ID <> cTARIFF_ID
                                AND D1.BEGIN_DATE < cBEGIN_DATE
                                AND D1.BEGIN_DATE > D.BEGIN_DATE);

   vACCOUNT_ID                      INTEGER;
   recCODE                          DB_LOADER_ACCOUNT_PHONE_HISTS.CELL_PLAN_CODE%TYPE;
   vCONTRACT_ID                     CONTRACTS.CONTRACT_ID%TYPE;
   vCREDIT                          CONTRACTS.IS_CREDIT_CONTRACT%TYPE;
   vSTART_BALANCE_VALUE             NUMBER (15, 2);
   vSTART_BALANCE_DATE              DATE;
   vSTART_BALANCE_DATE_FOR_PAYMS    DATE;
   vABON_PAYMENT_START_DATE         DATE;
   vOPTION_GROUP_ID                 INTEGER;
   vSERVICE_START_DATE              DATE; -- ���� ������  ������� ��������� �� ������.
   vSERVICE_END_DATE                DATE; -- ���� ��������� ������� ��������� �� ������.
   vNEW_TURN_ON_COST                NUMBER; -- ��������� ����������� �������� ����� (�� �����������).
   vNEW_MONTHLY_COST                NUMBER; -- ��������� ����� � ����� (�� �����������).
   ABON_PAY_DAY_AFTER_BLOCK         BOOLEAN;
   HISTORY_ID_ACT                   INTEGER;
   HISTORY_ID_BL                    INTEGER;
   HISTORY_ID_END_DATE              DATE;
   REC_BILL_DATE                    DATE;
   REC_BILL_SUM                     NUMBER;
   REC_REMARK                       VARCHAR2 (300);
   rec_REPORT                       DB_REPORT%ROWTYPE;
   FLAG_CURR_MONTH                  INTEGER;
   FLAG_DATA_OPTIONS_CURR_MONTH     INTEGER;
   PAYMENTS_PREV_MONTH              INTEGER;
   vCALC_ABON_PAYMENT_TO_MONTHEND   BOOLEAN; -- ������� ������� ��������� �� ����� ������
   --
   -- ���������� ����, �� ������� ���� ������ ��������� ������� ���������.
   -- ���� ���� ��������� �� ��������� � ����� ��������, �� ����� ������ ������ �� ���� ���������.
   vCORRECT_ACTIVATION_DATE_DAYS    INTEGER;
   -- vTEMP_DATE_BEGIN_ABON DATE; -- ��������� ����������(������ ���� ���������)
   PREV_STATUS                      NUMBER;
   pCALC_ABON_PAYMENT_TO_MONTHEND   INTEGER;
   TEMP_DATE_BEGIN_SCHET            DATE; -- ����, ��-������� ������ ����������
   vDATE_SERVICE_CHECK              DATE;
   vSERVER_NAME                     VARCHAR2 (50 CHAR);
   vCALC_OPTIONS_DAILY_ACTIV        VARCHAR2 (30 CHAR);
   vLAST_DAY_OPTION_ADD             DATE;
   vCOUNT_ACT_OPTION                INTEGER;
   vDUMMY_PH                        PH_W_D_A%ROWTYPE;
   vFIX_YEAR_MONTH_ID               INTEGER;
   vSERVICE_PAID_FULL               INTEGER;
   vDUMMY_TPT                       TARIFF_PAY_TYPE%ROWTYPE;
   vCHECK_ABON_MODULE_DATE          DATE;
   vABON_DISCOUNT                   INTEGER;
   vINST_PAYMENT_DATE               DATE;
   vINST_PAYMENT_SUM                NUMBER (13, 2);
   vINST_PAYMENT_MONTH              INTEGER;
   vINST_TEMP_DATE                  DATE;
   vINST_TEMP_SUM                   NUMBER (13, 2);
   vINST_TEMP_DESCR                 VARCHAR2 (300 CHAR);
   vABON_COEFFICIENT                NUMBER (15, 4);
   i                                INTEGER;
   vCALC_ABON_BLOCK_COUNT_DAYS      NUMBER;
   vPERIOD_ACTIV                    INTEGER;
   vOPTION_GROUP_COSTS              DBMS_SQL.VARCHAR2_TABLE;
   vOPTION_GROUP_LIST               VARCHAR2 (500 CHAR);
   L                                BINARY_INTEGER;
   I                                BINARY_INTEGER;
   vPREV_DISCR_TARIFF_ID            INTEGER;
   VPREV_DISCR_YEAR_MONTH           INTEGER;
   NEED_DISCR_SPISANIE              INTEGER;
   NEED_DAILY_SPISANIE              INTEGER;
   pDATE_DETER   DATE;
   DUMMY_S_D                        SDVIG_D%ROWTYPE;

   --
   PROCEDURE APPEND_ROW (pDATE DATE, pCOST NUMBER, pDESCRIPTION VARCHAR2)
   IS
      C   BINARY_INTEGER;
   --  exclude integer;
   BEGIN
      IF pCOST <> 0
      THEN
         C := pDATE_ROWS.COUNT + 1;
         pDATE_ROWS (C) := pDATE;
         pCOST_ROWS (C) := pCOST;

         IF pFILL_DESCRIPTION
         THEN
            pDESCRIPTION_ROWS (C) := pDESCRIPTION;
         END IF;
      END IF;
   END;

   --
   FUNCTION fLOAD_BILL_IN_BALANCE (faccount_id NUMBER, fYEAR_MONTH NUMBER)
      RETURN NUMBER
   IS
      res   NUMBER := 0;
   BEGIN
      SELECT COUNT (*)
        INTO res
        FROM ACCOUNT_LOADED_BILLS AB
       WHERE     AB.ACCOUNT_ID = faccount_id
             AND AB.YEAR_MONTH >= fYEAR_MONTH
             AND AB.LOAD_BILL_IN_BALANCE = 1;

      IF res > 0
      THEN
         res := 1;
      END IF;

      RETURN res;
   END;
--
BEGIN
   --
   --���������� ����, �� ������� ����� ���������
   --���� pBALANCE_DATE ������ ������� ����, �� ����� ������� ����, �.�. ��������� ��� ����
   pDATE_DETER := SYSDATE;
   IF TRUNC(NVL(pBALANCE_DATE, SYSDATE)) > TRUNC(SYSDATE) THEN
     pDATE_DETER := NVL(pBALANCE_DATE, SYSDATE) ;
   END IF;
   --
   pDATE_ROWS.DELETE;
   pCOST_ROWS.DELETE;
   pDESCRIPTION_ROWS.DELETE;

   --
   OPEN ACC_ID;

   FETCH ACC_ID INTO vACCOUNT_ID;

   IF ACC_ID%NOTFOUND
   THEN
      vACCOUNT_ID := 0;
   END IF;

   CLOSE ACC_ID;

   --
   vCALC_ABON_PAYMENT_TO_MONTHEND :=
      ('1' =
          MS_CONSTANTS.GET_CONSTANT_VALUE ('CALC_ABON_PAYMENT_TO_MONTH_END'));

   IF vCALC_ABON_PAYMENT_TO_MONTHEND
   THEN
      OPEN PH_W_D_A;

      FETCH PH_W_D_A INTO vDUMMY_PH;

      IF PH_W_D_A%FOUND
      THEN
         pCALC_ABON_PAYMENT_TO_MONTHEND := 0;
      ELSE
         OPEN TARIFF_PAY_TYPE;

         FETCH TARIFF_PAY_TYPE INTO vDUMMY_TPT;

         IF TARIFF_PAY_TYPE%FOUND
         THEN
            pCALC_ABON_PAYMENT_TO_MONTHEND :=
               vDUMMY_TPT.CALC_ABON_PAYMENT_TO_NOW;
         ELSE
            pCALC_ABON_PAYMENT_TO_MONTHEND := 1;
         END IF;

         CLOSE TARIFF_PAY_TYPE;
      END IF;

      CLOSE PH_W_D_A;
   ELSE
      pCALC_ABON_PAYMENT_TO_MONTHEND := 0;
   END IF;

   -- ���������� ���� ��������� ���� ���������
   vCORRECT_ACTIVATION_DATE_DAYS :=
      NVL (MS_CONSTANTS.GET_CONSTANT_VALUE ('CORRECT_ACTIVATION_DATE_DAYS'),
           0);
   --
   vCALC_OPTIONS_DAILY_ACTIV :=
      MS_CONSTANTS.GET_CONSTANT_VALUE ('CALC_OPTIONS_DAILY_ACTIV');

   --
   OPEN C_CONTRACT;

   FETCH C_CONTRACT INTO vCONTRACT_DATE, vCONTRACT_ID;

   CLOSE C_CONTRACT;

   --
   IF MS_CONSTANTS.GET_CONSTANT_VALUE ('USE_ABON_DISCOUNTS') = '1'
   THEN
      vABON_COEFFICIENT := 1 + NVL (vABON_DISCOUNT, 0) / 100;
   ELSE
      vABON_COEFFICIENT := 1;
   END IF;

   -- ������������� �������
   OPEN C_BALANCE (pPHONE_NUMBER, vCONTRACT_DATE);

   FETCH C_BALANCE
      INTO vSTART_BALANCE_DATE, vSTART_BALANCE_VALUE, vFIX_YEAR_MONTH_ID;

   IF C_BALANCE%NOTFOUND
   THEN
      vSTART_BALANCE_DATE :=
         NVL (vCONTRACT_DATE, TO_DATE ('01.01.2000', 'DD.MM.YYYY'));
      -- ���� ��� ������ �������� ��������� - �� 4 ��� ������ ��������
      vSTART_BALANCE_DATE_FOR_PAYMS :=
         vSTART_BALANCE_DATE - cDAYS_PAYMENT_BEFORE_CONTRACT;
      vSTART_BALANCE_VALUE := 0;
   ELSE
      vSTART_BALANCE_DATE_FOR_PAYMS := vSTART_BALANCE_DATE;
   END IF;

   CLOSE C_BALANCE;

   IF vSTART_BALANCE_VALUE <> 0
   THEN
      APPEND_ROW (vSTART_BALANCE_DATE,
                  vSTART_BALANCE_VALUE,
                  '��������� ������');
   END IF;

   -- ������� ����� ���� ��������
   FOR rec
      IN (SELECT PAYMENT_DATE,
                 PAYMENT_SUM,
                 PAYMENT_REMARK,
                 reverseschet                       -- ������ ������  ( #1343)
            FROM V_FULL_BALANCE_PAYMENTS
           WHERE     V_FULL_BALANCE_PAYMENTS.PHONE_NUMBER = pPHONE_NUMBER
                 AND (   V_FULL_BALANCE_PAYMENTS.PAYMENT_DATE >=
                            vSTART_BALANCE_DATE_FOR_PAYMS
                      OR (    V_FULL_BALANCE_PAYMENTS.CONTRACT_ID =
                                 vCONTRACT_ID
                          AND V_FULL_BALANCE_PAYMENTS.PAYMENT_REMARK <>
                                 '��������� ������'
                          AND vFIX_YEAR_MONTH_ID IS NULL))
                 AND (   pBALANCE_DATE IS NULL
                      OR V_FULL_BALANCE_PAYMENTS.PAYMENT_DATE <=
                            pBALANCE_DATE))
   LOOP
      APPEND_ROW (
         rec.PAYMENT_DATE,
         rec.PAYMENT_SUM,
            '������: '
         || rec.PAYMENT_REMARK
         || CASE
               WHEN NVL (rec.reverseschet, 0) = 1
               THEN
                  '(�� ��������� ����.)'
               ELSE
                  ' '
            END);

      IF (    rec.reverseschet = 1
          AND fLOAD_BILL_IN_BALANCE (vACCOUNT_ID,
                                     TO_CHAR (rec.PAYMENT_DATE, 'YYYYMM')) =
                 1)
      THEN
         APPEND_ROW (
            rec.PAYMENT_DATE,
            -rec.PAYMENT_SUM,
               '������ ��������������: '
            || rec.PAYMENT_REMARK);
      END IF;
   END LOOP;


   --������ ���� �������� ��� ���������� ����� �� ������ ����������� ����� ��������� ������� � 


 if vHANDS_BILLING = 1 then
   
   for rec in (
                SELECT DATE_BILLING, COST
                  FROM BALANCE_HAND_BILLING
                 where PHONE_NUMBER_TARIFER = pPHONE_NUMBER 
                   and DATE_BILLING <= pBALANCE_DATE
              )
   loop
      APPEND_ROW (rec.DATE_BILLING, - rec.COST, '�������� ����. ����� (������ �������)');
   end loop;
   
   
  
 else  -- if vHANDS_BILLING = 1 then
   
  

   -- ����������
   FLAG_CURR_MONTH := 0;                  --�� ��� ����� ���� ��� �� ���������

   FOR rec
      IN (SELECT BILL_DATE,
                 CASE
                    WHEN vABON_COEFFICIENT = 1
                    THEN
                       -NVL (V_FULL_BALANCE_BILLS.BILL_SUM, 0)
                    ELSE
                       -NVL (V_FULL_BALANCE_BILLS.BILL_SUM, 0)
                 END
                    BILL_SUM,
                 V_FULL_BALANCE_BILLS.REMARK
            --'��������� �������� ����� ��������� �� ��������� �����'
            FROM V_FULL_BALANCE_BILLS
           WHERE     V_FULL_BALANCE_BILLS.PHONE_NUMBER = pPHONE_NUMBER
                 AND V_FULL_BALANCE_BILLS.BILL_DATE >= vSTART_BALANCE_DATE ----vCORRECT_ACTIVATION_DATE_DAYS
                 AND (   pBALANCE_DATE IS NULL
                      OR V_FULL_BALANCE_BILLS.BILL_DATE <= pBALANCE_DATE))
   LOOP
      IF TO_CHAR (SYSDATE, 'YYYYMM') = TO_CHAR (rec.BILL_DATE, 'YYYYMM')
      THEN                        --��������� �� ������� ����� � ������ ������
         FLAG_CURR_MONTH := 1;
      END IF;

      IF SUBSTR (rec.REMARK, 1, 1) = '�'
      THEN                                       --���� ����������� �� �������
         rec_REPORT.DATE_LAST_UPDATE := NULL;

         IF    TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) - DAYS_NESTABIL > 0
            OR TO_CHAR (rec.BILL_DATE, 'YYYYMM') <>
                  TO_CHAR (SYSDATE, 'YYYYMM')
         THEN       --DAYS_NESTABIL ���� �� ������ ������ ��������� � ��������
            OPEN DB_REPORT (TO_NUMBER (TO_CHAR (rec.BILL_DATE, 'YYYYMM')));

            FETCH DB_REPORT INTO rec_REPORT;

            CLOSE DB_REPORT;

            IF rec_REPORT.DATE_LAST_UPDATE IS NOT NULL
            THEN
               IF    (rec.BILL_DATE IS NULL)
                  OR (rec.BILL_SUM > rec_REPORT.BILL_SUM)
               THEN
                  rec.BILL_DATE := rec_REPORT.DATE_LAST_UPDATE;
                  rec.BILL_SUM := rec_REPORT.BILL_SUM;
                  rec.REMARK := rec_REPORT.REMARKS;
               END IF;
            END IF;
         END IF;

         APPEND_ROW (rec.BILL_DATE, rec.BILL_SUM, rec.REMARK);
      ELSE
         APPEND_ROW (rec.BILL_DATE, rec.BILL_SUM, rec.REMARK);
      END IF;
   END LOOP;

   --
   IF     (FLAG_CURR_MONTH = 0)
      AND (TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) - DAYS_NESTABIL > 0)
      AND (   pBALANCE_DATE IS NULL
           OR TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMM')) =
                 TO_NUMBER (TO_CHAR (pBALANCE_DATE, 'YYYYMM')))
   THEN                     --�� ��� ����� �� ���� ������, ������� ����� �����
      rec_REPORT.DATE_LAST_UPDATE := NULL;

      OPEN DB_REPORT (TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMM')));

      FETCH DB_REPORT INTO rec_REPORT;

      CLOSE DB_REPORT;

      IF rec_REPORT.DATE_LAST_UPDATE IS NOT NULL
      THEN
         APPEND_ROW (rec_REPORT.DATE_LAST_UPDATE,
                     rec_REPORT.BILL_SUM,
                     rec_REPORT.REMARKS);
      END IF;
   END IF;

   -- ��������� �� ������
   IF '1' =
         MS_CONSTANTS.GET_CONSTANT_VALUE ('CALC_ABON_PAYMENT_BLOCK_5_DAYS')
   THEN
      ABON_PAY_DAY_AFTER_BLOCK := TRUE;
      vCALC_ABON_BLOCK_COUNT_DAYS :=
         NVL (MS_PARAMS.GET_PARAM_VALUE ('CALC_ABON_BLOCK_COUNT_DAYS'), 1);

      IF vCALC_ABON_BLOCK_COUNT_DAYS < 1
      THEN
         vCALC_ABON_BLOCK_COUNT_DAYS := 1;
      END IF;
   ELSE
      ABON_PAY_DAY_AFTER_BLOCK := FALSE;
      vCALC_ABON_BLOCK_COUNT_DAYS := 0;
   END IF;

   -- ������ ���� ���������
   IF vCORRECT_ACTIVATION_DATE_DAYS <> 0
   THEN
      OPEN NEW_DATE_ABON (vSTART_BALANCE_DATE, vCORRECT_ACTIVATION_DATE_DAYS);

      FETCH NEW_DATE_ABON INTO vTEMP_DATE_BEGIN_ABON;

      IF NEW_DATE_ABON%NOTFOUND
      THEN
         vTEMP_DATE_BEGIN_ABON := vSTART_BALANCE_DATE;
      END IF;

      CLOSE NEW_DATE_ABON;

      IF vTEMP_DATE_BEGIN_ABON <
            vSTART_BALANCE_DATE - vCORRECT_ACTIVATION_DATE_DAYS
      THEN
         vTEMP_DATE_BEGIN_ABON := vSTART_BALANCE_DATE;
      END IF;
   ELSE
      vTEMP_DATE_BEGIN_ABON := vSTART_BALANCE_DATE;
   END IF;

   -- ��������� ���� ������ �������
   SELECT MAX (LAST_DATE)
     INTO vABON_PAYMENT_START_DATE
     FROM (                      -- ����� (������ ���� ����� ���������� �����)
           SELECT TRUNC (DB_LOADER_BILLS.DATE_END) + 1 LAST_DATE
             FROM DB_LOADER_BILLS, ACCOUNT_LOADED_BILLS
            WHERE     DB_LOADER_BILLS.PHONE_NUMBER = pPHONE_NUMBER
                  AND ACCOUNT_LOADED_BILLS.ACCOUNT_ID =
                         DB_LOADER_BILLS.ACCOUNT_ID
                  AND ACCOUNT_LOADED_BILLS.YEAR_MONTH =
                         DB_LOADER_BILLS.YEAR_MONTH
                  AND ACCOUNT_LOADED_BILLS.LOAD_BILL_IN_BALANCE = 1
           UNION ALL
           -- ����� ������ �������
           SELECT   TRUNC (
                       LAST_DAY (
                          TO_DATE (
                                TO_CHAR (
                                   DB_LOADER_FULL_FINANCE_BILL.YEAR_MONTH)
                             || '01',
                             'YYYYMMDD')))
                  + 1
                     LAST_DATE
             FROM DB_LOADER_FULL_FINANCE_BILL, ACCOUNT_LOADED_BILLS
            WHERE     DB_LOADER_FULL_FINANCE_BILL.PHONE_NUMBER =
                         pPHONE_NUMBER
                  AND ACCOUNT_LOADED_BILLS.ACCOUNT_ID =
                         DB_LOADER_FULL_FINANCE_BILL.ACCOUNT_ID
                  AND ACCOUNT_LOADED_BILLS.YEAR_MONTH =
                         DB_LOADER_FULL_FINANCE_BILL.YEAR_MONTH
                  AND ACCOUNT_LOADED_BILLS.LOAD_BILL_IN_BALANCE = 1
                  AND DB_LOADER_FULL_FINANCE_BILL.COMPLETE_BILL = 1
           UNION ALL
           -- ���� ���� �������/��������
           SELECT vTEMP_DATE_BEGIN_ABON FROM DUAL);

   IF (    vABON_PAYMENT_START_DATE < vSTART_BALANCE_DATE
       AND CONVERT_PCKG.GET_IS_COLLECTOR_BY_PHONE (pPHONE_NUMBER) <> 1)
   THEN
      vABON_PAYMENT_START_DATE := vSTART_BALANCE_DATE;
   END IF;

   IF (    (CONVERT_PCKG.GET_IS_COLLECTOR_BY_PHONE (pPHONE_NUMBER) = 1)
       AND (ABS (vABON_PAYMENT_START_DATE - vSTART_BALANCE_DATE) < 3)
       AND (GET_BILL_IN_BALANCE (vACCOUNT_ID,
                                 TO_CHAR (vCONTRACT_DATE, 'YYYYMM')) = 0))
   THEN
      vABON_PAYMENT_START_DATE := vSTART_BALANCE_DATE;
   END IF;

   vCHECK_ABON_MODULE_DATE := vABON_PAYMENT_START_DATE - 1;

   -- ���������
   FOR recPAYMENTS
      IN (SELECT YEAR_MONTH,
                 TO_DATE (YEAR_MONTH, 'YYYYMM') BEGIN_DATE,
                 ADD_MONTHS (TO_DATE (YEAR_MONTH, 'YYYYMM'), 1) - 1 END_DATE,
                 TO_DATE (YEAR_MONTH, 'YYYYMM') FIRST_MONTH_DATE,
                 ADD_MONTHS (TO_DATE (YEAR_MONTH, 'YYYYMM'), 1) - 1
                    LAST_MONTH_DATE,
                 TARIFF_CODE
            FROM DB_LOADER_PHONE_PERIODS
           WHERE     PHONE_NUMBER = pPHONE_NUMBER
                 AND (   pBALANCE_DATE IS NULL
                      OR TO_DATE (YEAR_MONTH, 'YYYYMM') <= pBALANCE_DATE)
                 AND YEAR_MONTH >=
                        TO_NUMBER (
                           TO_CHAR (vABON_PAYMENT_START_DATE, 'YYYYMM'))
          UNION ALL
          -- � ����� ������� ���������� �������� �����, ���� �� ��� �������, � ������ ��� �� ���������.
          -- ��� �������� ���� �� ����������� ������.
          SELECT TO_NUMBER (
                    TO_CHAR (ADD_MONTHS (TO_DATE (YEAR_MONTH, 'YYYYMM'), 1),
                             'YYYYMM'))
                    AS YEAR_MONTH,               -- �������� ����� ������ �� 1
                 ADD_MONTHS (TO_DATE (YEAR_MONTH, 'YYYYMM'), 1) BEGIN_DATE,
                 ADD_MONTHS (TO_DATE (YEAR_MONTH, 'YYYYMM'), 2) - 1 END_DATE,
                 ADD_MONTHS (TO_DATE (YEAR_MONTH, 'YYYYMM'), 1)
                    FIRST_MONTH_DATE,
                 ADD_MONTHS (TO_DATE (YEAR_MONTH, 'YYYYMM'), 2) - 1
                    LAST_MONTH_DATE,
                 TARIFF_CODE
            FROM DB_LOADER_PHONE_PERIODS
           WHERE     PHONE_NUMBER = pPHONE_NUMBER
                 AND YEAR_MONTH = TO_CHAR (SYSDATE - 1, 'YYYYMM')
                 AND NOT EXISTS
                            (
                              SELECT 1
                               FROM DB_LOADER_PHONE_PERIODS ph
                              WHERE ph.YEAR_MONTH = (DB_LOADER_PHONE_PERIODS.YEAR_MONTH + 1)
                            )
                 AND NOT EXISTS
                            (SELECT 1
                               FROM DB_LOADER_PHONE_PERIODS ds
                              WHERE ds.YEAR_MONTH =
                                       TO_NUMBER (
                                          TO_CHAR (
                                             NVL (pBALANCE_DATE, SYSDATE),
                                             'YYYYMM')))
          ORDER BY YEAR_MONTH)
   LOOP
      vPERIOD_ACTIV := 0;

      -- ��������, ��� ������ ������ ��� �� �������������
      IF recPAYMENTS.END_DATE > vCHECK_ABON_MODULE_DATE
      THEN
         vCHECK_ABON_MODULE_DATE := recPAYMENTS.END_DATE;

         --    dbms_output.put_line('recPAYMENTS.END_DATE=' || recPAYMENTS.END_DATE);
         IF NVL (vCREDIT, 0) <> 1
         THEN         -- ���� 1, �� ������� ���������, ����� ������ �� �������
            IF recPAYMENTS.BEGIN_DATE < vABON_PAYMENT_START_DATE
            THEN
               recPAYMENTS.BEGIN_DATE := vABON_PAYMENT_START_DATE;
            END IF;

            IF pCALC_ABON_PAYMENT_TO_MONTHEND = 1
            THEN
               -- ��������� ��������� �� ����� �������� ������.
               NULL;
            ELSE
               -- ��������� ����� ������� �� ������� ����.
               IF recPAYMENTS.END_DATE > TRUNC(pDATE_DETER) --TRUNC (SYSDATE)
               THEN
                  recPAYMENTS.END_DATE := TRUNC(pDATE_DETER); --TRUNC (SYSDATE);
               END IF;
            END IF;

            -- �� ��������� �������, ��� ���������� ���� ��� � �����.
            PREV_STATUS := 0;
            TEMP_DATE_BEGIN_SCHET := TRUNC (recPAYMENTS.BEGIN_DATE - 1);
            vPREV_DISCR_TARIFF_ID := 0;
            VPREV_DISCR_YEAR_MONTH := 0;

            FOR recPHONE_STATUS_HISTORY
               IN ( SELECT
                            BEGIN_DATE,
                            END_DATE,
                            TARIFF_ID,
                            CELL_PLAN_CODE,
                            PHONE_IS_ACTIVE,
                            MONTHLY_PRICE,
                            DAYLY_PRICE,
                            DISCR_SPISANIE,
                            SDVIG_DISCR_SPISANIE
                      FROM
                      (  
                        SELECT D.BEGIN_DATE,
                            D.END_DATE,
                            D.TARIFF_ID,
                            D.TARIFF_CODE CELL_PLAN_CODE,
                            D.IS_ACTIVE PHONE_IS_ACTIVE,
                            CASE
                               WHEN    (D.IS_ACTIVE = 1)
                                    -- ���� ������� ���������� � ��������� ������, �� ������� ��������� ��� ��� ������������
                                    OR (    (D.END_DATE >= TRUNC (SYSDATE))
                                        AND (TO_CHAR (D.BEGIN_DATE, 'YYYYMM') =
                                                TO_CHAR (SYSDATE, 'YYYYMM'))
                                        AND (pCALC_ABON_PAYMENT_TO_MONTHEND = 1))
                               THEN
                                  NVL (TR.MONTHLY_PAYMENT, 0)
                               ELSE
                                  NVL (TR.MONTHLY_PAYMENT_LOCKED, 0)
                            END
                               AS MONTHLY_PRICE,
                            -- � ����������� �� ���������� ������ ���� ������� ���� ������������� ���������
                            CASE
                               WHEN    (D.IS_ACTIVE = 1)
                                    -- ���� ������� ���������� � ��������� ������, �� ������� ��������� ��� ��� ������������
                                    OR (    (D.END_DATE >= TRUNC (SYSDATE))
                                        AND (TO_CHAR (D.BEGIN_DATE, 'YYYYMM') =
                                                TO_CHAR (SYSDATE, 'YYYYMM'))
                                        AND (pCALC_ABON_PAYMENT_TO_MONTHEND = 1))
                               THEN
                                  NVL (TR.DAYLY_PAYMENT, 0)
                               ELSE
                                  NVL (TR.DAYLY_PAYMENT_LOCKED, 0)
                            END
                               AS DAYLY_PRICE,
                            NVL (DISCR_SPISANIE, 0) DISCR_SPISANIE,
                            NVL (SDVIG_DISCR_SPISANIE, 0) SDVIG_DISCR_SPISANIE
                       FROM DB_LOADER_ABONENT_PERIODS D, TARIFFS TR
                      WHERE     D.PHONE_NUMBER = pPHONE_NUMBER
                            AND D.YEAR_MONTH = recPAYMENTS.YEAR_MONTH
                            AND (   pBALANCE_DATE IS NULL
                                 OR D.BEGIN_DATE <= pBALANCE_DATE)
                            AND D.END_DATE >= TRUNC (vABON_PAYMENT_START_DATE)
                            AND D.TARIFF_ID = TR.TARIFF_ID(+)
                   UNION ALL
                       SELECT  
                            ADD_MONTHS (TO_DATE (D.YEAR_MONTH, 'YYYYMM'), 1) BEGIN_DATE,
                            ADD_MONTHS (TO_DATE (D.YEAR_MONTH, 'YYYYMM'), 2) - 1 END_DATE,
                            D.TARIFF_ID,
                            D.TARIFF_CODE CELL_PLAN_CODE,
                            D.IS_ACTIVE PHONE_IS_ACTIVE,
                            CASE
                               WHEN    (D.IS_ACTIVE = 1)
                                    -- ���� ������� ���������� � ��������� ������, �� ������� ��������� ��� ��� ������������
                                    OR (    (D.END_DATE >= TRUNC (SYSDATE))
                                        AND (TO_CHAR (D.BEGIN_DATE, 'YYYYMM') =
                                                TO_CHAR (SYSDATE, 'YYYYMM'))
                                        AND (pCALC_ABON_PAYMENT_TO_MONTHEND = 1))
                               THEN
                                  NVL (TR.MONTHLY_PAYMENT, 0)
                               ELSE
                                  NVL (TR.MONTHLY_PAYMENT_LOCKED, 0)
                            END
                               AS MONTHLY_PRICE,
                            -- � ����������� �� ���������� ������ ���� ������� ���� ������������� ���������
                            CASE
                               WHEN    (D.IS_ACTIVE = 1)
                                    -- ���� ������� ���������� � ��������� ������, �� ������� ��������� ��� ��� ������������
                                    OR (    (D.END_DATE >= TRUNC (SYSDATE))
                                        AND (TO_CHAR (D.BEGIN_DATE, 'YYYYMM') =
                                                TO_CHAR (SYSDATE, 'YYYYMM'))
                                        AND (pCALC_ABON_PAYMENT_TO_MONTHEND = 1))
                               THEN
                                  NVL (TR.DAYLY_PAYMENT, 0)
                               ELSE
                                  NVL (TR.DAYLY_PAYMENT_LOCKED, 0)
                            END
                               AS DAYLY_PRICE,
                            NVL (DISCR_SPISANIE, 0) DISCR_SPISANIE,
                            NVL (SDVIG_DISCR_SPISANIE, 0) SDVIG_DISCR_SPISANIE
                       FROM DB_LOADER_ABONENT_PERIODS D, TARIFFS TR
                       WHERE D.PHONE_NUMBER = pPHONE_NUMBER
                            AND (D.YEAR_MONTH + 1) = recPAYMENTS.YEAR_MONTH
                            AND D.YEAR_MONTH = TO_CHAR (SYSDATE - 1, 'YYYYMM')
                            AND (   pBALANCE_DATE IS NULL
                                 OR D.BEGIN_DATE <= pBALANCE_DATE)
                            AND D.END_DATE >= TRUNC (vABON_PAYMENT_START_DATE)
                            AND D.TARIFF_ID = TR.TARIFF_ID(+) 
                            AND D.END_DATE = (
                                                           select max(PRD.END_DATE)
                                                           from DB_LOADER_ABONENT_PERIODS prd
                                                           where PRD.PHONE_NUMBER = D.PHONE_NUMBER
                                                           and PRD.YEAR_MONTH = D.YEAR_MONTH
                                                           and (pBALANCE_DATE IS NULL OR PRD.BEGIN_DATE <= pBALANCE_DATE)
                                                           and PRD.END_DATE >= TRUNC (vABON_PAYMENT_START_DATE)
                                                         )
                            AND NOT EXISTS
                                        (
                                          SELECT 1
                                           FROM DB_LOADER_PHONE_PERIODS ph
                                          WHERE ph.YEAR_MONTH = (D.YEAR_MONTH + 1)
                                        )  
                            AND NOT EXISTS
                                        (SELECT 1
                                           FROM DB_LOADER_PHONE_PERIODS ds
                                          WHERE ds.YEAR_MONTH =
                                                   TO_NUMBER (
                                                      TO_CHAR (
                                                         NVL (pBALANCE_DATE, SYSDATE),
                                                         'YYYYMM')))
                            AND TRUNC(NVL (pBALANCE_DATE, SYSDATE)) > TRUNC(SYSDATE) --������ ��� ���� ������� ������ ������� ����
                   )
                   ORDER BY BEGIN_DATE ASC, END_DATE ASC)
            LOOP
               recPHONE_STATUS_HISTORY.SDVIG_DISCR_SPISANIE := 1;
               NEED_DISCR_SPISANIE := 0;
               NEED_DAILY_SPISANIE := 0;

               IF     (recPHONE_STATUS_HISTORY.BEGIN_DATE =
                          recPAYMENTS.FIRST_MONTH_DATE)
                  AND (recPHONE_STATUS_HISTORY.END_DATE =
                          recPAYMENTS.LAST_MONTH_DATE)
                  AND (recPHONE_STATUS_HISTORY.PHONE_IS_ACTIVE = 0)
               THEN
                  -- ���� ����� ���� ����� � �����, �� �������� �� ���� ������.
                  recPHONE_STATUS_HISTORY.END_DATE :=
                     recPHONE_STATUS_HISTORY.BEGIN_DATE - 1;
               END IF;

               vPERIOD_ACTIV :=
                  vPERIOD_ACTIV + recPHONE_STATUS_HISTORY.PHONE_IS_ACTIVE;

               IF TRUNC (recPHONE_STATUS_HISTORY.BEGIN_DATE) <=
                     TRUNC (TEMP_DATE_BEGIN_SCHET + 1)
               THEN
                  recPHONE_STATUS_HISTORY.BEGIN_DATE :=
                     TRUNC (TEMP_DATE_BEGIN_SCHET + 1);
               END IF;

               IF     (TRUNC (recPHONE_STATUS_HISTORY.END_DATE) >
                          TRUNC (pDATE_DETER)) --TRUNC (SYSDATE))
                  AND (pCALC_ABON_PAYMENT_TO_MONTHEND <> 1)
               THEN
                  recPHONE_STATUS_HISTORY.END_DATE := TRUNC (pDATE_DETER); --TRUNC (SYSDATE);
               END IF;

               IF     (recPHONE_STATUS_HISTORY.END_DATE >=
                          recPHONE_STATUS_HISTORY.BEGIN_DATE)
                  AND (TRUNC (recPHONE_STATUS_HISTORY.END_DATE) >=
                          TRUNC (TEMP_DATE_BEGIN_SCHET + 1))
               THEN
                  -- ��������� �������� �� ���������, ���� ������� ���
                  IF recPHONE_STATUS_HISTORY.CELL_PLAN_CODE IS NULL
                  THEN
                     recPHONE_STATUS_HISTORY.CELL_PLAN_CODE :=
                        recPAYMENTS.TARIFF_CODE;
                  END IF;

                  IF ABON_PAY_DAY_AFTER_BLOCK
                  THEN
                     IF (recPHONE_STATUS_HISTORY.PHONE_IS_ACTIVE = 0)
                     THEN
                        IF   recPHONE_STATUS_HISTORY.END_DATE
                           - recPHONE_STATUS_HISTORY.BEGIN_DATE >=
                              vCALC_ABON_BLOCK_COUNT_DAYS - 1
                        THEN
                           recPHONE_STATUS_HISTORY.END_DATE :=
                                recPHONE_STATUS_HISTORY.BEGIN_DATE
                              + vCALC_ABON_BLOCK_COUNT_DAYS
                              - 1;
                        END IF;

                        -- ���� �������� ������ ���� ����, �� ���� ������� �� �����.
                        IF (PREV_STATUS = 0)
                        THEN
                           recPHONE_STATUS_HISTORY.END_DATE :=
                              recPHONE_STATUS_HISTORY.BEGIN_DATE - 1;
                        END IF;
                     END IF;
                  END IF;

                  IF recPHONE_STATUS_HISTORY.BEGIN_DATE <
                        recPAYMENTS.BEGIN_DATE
                  THEN
                     recPHONE_STATUS_HISTORY.BEGIN_DATE :=
                        recPAYMENTS.BEGIN_DATE;
                  END IF;

                  -- ��������� ������� ���������
                  recPHONE_STATUS_HISTORY.DAYLY_PRICE :=
                       recPHONE_STATUS_HISTORY.DAYLY_PRICE
                     + (  recPHONE_STATUS_HISTORY.MONTHLY_PRICE
                        / (  recPAYMENTS.LAST_MONTH_DATE
                           - recPAYMENTS.FIRST_MONTH_DATE
                           + 1));

                  IF     (recPHONE_STATUS_HISTORY.PHONE_IS_ACTIVE = 1)
                     AND (recPHONE_STATUS_HISTORY.DISCR_SPISANIE = 1)
                  /*AND (recPHONE_STATUS_HISTORY.TARIFF_ID <> vPREV_DISCR_TARIFF_ID)*/
                  THEN
                     --DBMS_OUTPUT.put_line ('discr');
                     IF (TO_NUMBER (
                            TO_CHAR (
                               ADD_MONTHS (
                                  recPHONE_STATUS_HISTORY.BEGIN_DATE,
                                  recPHONE_STATUS_HISTORY.SDVIG_DISCR_SPISANIE),
                               'YYYYMM')) >
                            TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMM')))
                     THEN
                        --DBMS_OUTPUT.put_line ('time end');
                        --vPREV_DISCR_TARIFF_ID:=recPHONE_STATUS_HISTORY.TARIFF_ID;
                        IF (recPHONE_STATUS_HISTORY.SDVIG_DISCR_SPISANIE <> 0)
                        THEN
                           OPEN SDVIG_D (recPHONE_STATUS_HISTORY.TARIFF_ID,
                                         recPHONE_STATUS_HISTORY.BEGIN_DATE,
                                         recPHONE_STATUS_HISTORY.SDVIG_DISCR_SPISANIE);

                           FETCH SDVIG_D INTO DUMMY_S_D;

                           IF SDVIG_D%FOUND
                           THEN
                              NEED_DISCR_SPISANIE := 1;
                           ELSE
                              NEED_DAILY_SPISANIE := 1;
                           END IF;

                           CLOSE SDVIG_D;
                        ELSE
                           NEED_DISCR_SPISANIE := 1;
                        END IF;
                     ELSE
                        NEED_DAILY_SPISANIE := 1;
                     END IF;
                  END IF;

                  --
                  IF TRUNC (recPHONE_STATUS_HISTORY.BEGIN_DATE) <=
                        TRUNC (recPHONE_STATUS_HISTORY.END_DATE)
                  THEN                                    --���� ���� ��������
                     IF     (recPHONE_STATUS_HISTORY.DISCR_SPISANIE = 1)
                        AND (NEED_DAILY_SPISANIE <> 1)
                     THEN
                        IF NEED_DISCR_SPISANIE = 1
                        THEN
                           IF     (vPREV_DISCR_YEAR_MONTH <>
                                      TO_NUMBER (
                                         TO_CHAR (
                                            recPHONE_STATUS_HISTORY.BEGIN_DATE,
                                            'YYYYMM')))
                              AND (vPREV_DISCR_TARIFF_ID <>
                                      recPHONE_STATUS_HISTORY.TARIFF_ID)
                           THEN
                              APPEND_ROW (
                                 recPHONE_STATUS_HISTORY.BEGIN_DATE,
                                 - (  vABON_COEFFICIENT
                                    * recPHONE_STATUS_HISTORY.MONTHLY_PRICE),
                                    '1 ��������� ('
                                 || recPHONE_STATUS_HISTORY.CELL_PLAN_CODE
                                 || CASE
                                       WHEN recPHONE_STATUS_HISTORY.PHONE_IS_ACTIVE =
                                               1
                                       THEN
                                          ', ��������'
                                       ELSE
                                          ', ����������'
                                    END
                                 || '), ������� �� �����');
                              vPREV_DISCR_TARIFF_ID :=
                                 recPHONE_STATUS_HISTORY.TARIFF_ID;
                              vPREV_DISCR_YEAR_MONTH :=
                                 TO_NUMBER (
                                    TO_CHAR (
                                       recPHONE_STATUS_HISTORY.BEGIN_DATE,
                                       'YYYYMM'));
                           END IF;
                        END IF;
                     ELSE
                        APPEND_ROW (
                           recPHONE_STATUS_HISTORY.BEGIN_DATE,
                           - (  vABON_COEFFICIENT
                              * recPHONE_STATUS_HISTORY.DAYLY_PRICE
                              * (  TRUNC (recPHONE_STATUS_HISTORY.END_DATE)
                                 - TRUNC (recPHONE_STATUS_HISTORY.BEGIN_DATE)
                                 + 1)),
                              '1 ��������� ('
                           || recPHONE_STATUS_HISTORY.CELL_PLAN_CODE
                           || CASE
                                 WHEN recPHONE_STATUS_HISTORY.PHONE_IS_ACTIVE =
                                         1
                                 THEN
                                    ', ��������'
                                 ELSE
                                    ', ����������'
                              END
                           || ') c '
                           || TO_CHAR (recPHONE_STATUS_HISTORY.BEGIN_DATE,
                                       'DD.MM.YYYY')
                           || ' �� '
                           || TO_CHAR (recPHONE_STATUS_HISTORY.END_DATE,
                                       'DD.MM.YYYY')
                           || ' ('
                           || ROUND (recPHONE_STATUS_HISTORY.DAYLY_PRICE, 2)
                           || ' ���./����)');
                     END IF;
                  END IF;

                  TEMP_DATE_BEGIN_SCHET :=
                     TRUNC (recPHONE_STATUS_HISTORY.END_DATE);
               END IF;

               PREV_STATUS := recPHONE_STATUS_HISTORY.PHONE_IS_ACTIVE;
            END LOOP;
         END IF;

         -- �������� ������� ������ ����� ������
         FLAG_DATA_OPTIONS_CURR_MONTH := 0;

         FOR recFLAG
            IN (SELECT DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE
                  FROM DB_LOADER_ACCOUNT_PHONE_OPTS
                 WHERE     DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH =
                              recPAYMENTS.YEAR_MONTH
                       AND DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER =
                              pPHONE_NUMBER
                 UNION ALL
                 -- � ����� ������� ���������� �������� ������ � ������ ���� ������� ������ �������� ������
                 -- ��� �������� ���� �� ����������� ������.
                 SELECT DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE
                 FROM DB_LOADER_ACCOUNT_PHONE_OPTS
                 WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER = pPHONE_NUMBER 
                 AND DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH = TO_CHAR (SYSDATE - 1, 'YYYYMM')
                 AND (DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH + 1) = recPAYMENTS.YEAR_MONTH
                 AND NOT EXISTS
                            (
                              SELECT 1
                               FROM DB_LOADER_PHONE_PERIODS ph
                              WHERE ph.YEAR_MONTH = (DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH + 1)
                            ) 
                 AND NOT EXISTS
                            (
                             SELECT 1
                               FROM DB_LOADER_ACCOUNT_PHONE_OPTS op
                              WHERE op.YEAR_MONTH =
                                       TO_NUMBER (
                                          TO_CHAR (NVL (pBALANCE_DATE, SYSDATE), 'YYYYMM'))
                            )
                 AND TRUNC(NVL (pBALANCE_DATE, SYSDATE)) > TRUNC(SYSDATE) --������ ��� ���� ������� ������ ������� ����
                 )
         LOOP
            FLAG_DATA_OPTIONS_CURR_MONTH := 1;
            EXIT;
         END LOOP;

         PAYMENTS_PREV_MONTH :=
            CASE
               WHEN   recPAYMENTS.YEAR_MONTH
                    - ROUND (recPAYMENTS.YEAR_MONTH / 100) * 100 = 1
               THEN
                  recPAYMENTS.YEAR_MONTH - 89
               ELSE
                  recPAYMENTS.YEAR_MONTH - 1
            END;

         -- �������� �����
         FOR recSERVICES
            IN (
                  SELECT DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE,
                       DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_NAME,
                       DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE,
                       DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_OFF_DATE,
                       DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_COST,
                       DB_LOADER_ACCOUNT_PHONE_OPTS.MONTHLY_PRICE,
                       ACCOUNTS.OPERATOR_ID,
                       TARIFF_OPTIONS.DISCR_SPISANIE
                  FROM DB_LOADER_ACCOUNT_PHONE_OPTS, ACCOUNTS, TARIFF_OPTIONS
                 WHERE     DB_LOADER_ACCOUNT_PHONE_OPTS.ACCOUNT_ID =
                              ACCOUNTS.ACCOUNT_ID
                       AND NVL (
                              DB_LOADER_ACCOUNT_PHONE_OPTS.ADDED_FOR_RETARIF,
                              0) <> 1
                       AND DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE =
                              TARIFF_OPTIONS.OPTION_CODE(+)
                       AND (   (    DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH =
                                       recPAYMENTS.YEAR_MONTH
                                AND FLAG_DATA_OPTIONS_CURR_MONTH = 1)
                            OR (    DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH =
                                       PAYMENTS_PREV_MONTH
                                AND FLAG_DATA_OPTIONS_CURR_MONTH = 0
                                AND DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_OFF_DATE >=
                                       TO_DATE (
                                             TO_CHAR (recPAYMENTS.YEAR_MONTH)
                                          || '01',
                                          'YYYYMMDD')))
                       AND DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER =
                              pPHONE_NUMBER
                       AND NVL (
                              DB_LOADER_ACCOUNT_PHONE_OPTS.ADDED_FOR_RETARIF,
                              0) <> 1
                       -- AND (DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_COST <> 0 OR DB_LOADER_ACCOUNT_PHONE_OPTS.MONTHLY_PRICE <> 0)
                       AND (   (    pBALANCE_DATE IS NULL
                                AND DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE <=
                                       SYSDATE)
                            OR (DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE <=
                                   pBALANCE_DATE))
                      UNION ALL
                        -- � ����� ������� ���������� �������� ������ � ������ ���� ������� ������ �������� ������
                        -- ��� �������� ���� �� ����������� ������.           
                        SELECT 
                            DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE,
                            DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_NAME,
                            DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE,
                            DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_OFF_DATE,
                            DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_COST,
                            DB_LOADER_ACCOUNT_PHONE_OPTS.MONTHLY_PRICE,
                            ACCOUNTS.OPERATOR_ID,
                            TARIFF_OPTIONS.DISCR_SPISANIE
                        FROM DB_LOADER_ACCOUNT_PHONE_OPTS, 
                                 ACCOUNTS, 
                                 TARIFF_OPTIONS
                        WHERE DB_LOADER_ACCOUNT_PHONE_OPTS.ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID
                        AND DB_LOADER_ACCOUNT_PHONE_OPTS.OPTION_CODE = TARIFF_OPTIONS.OPTION_CODE(+)
                        AND NVL (DB_LOADER_ACCOUNT_PHONE_OPTS.ADDED_FOR_RETARIF,0) <> 1
                        --AND NVL (DB_LOADER_ACCOUNT_PHONE_OPTS.ADDED_FOR_RETARIF,0) <> 1
                        AND DB_LOADER_ACCOUNT_PHONE_OPTS.PHONE_NUMBER = pPHONE_NUMBER
                        AND (DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH + 1) = recPAYMENTS.YEAR_MONTH
                        AND (
                                (DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_OFF_DATE IS NULL) 
                                 OR 
                                (DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_OFF_DATE >= NVL(pBALANCE_DATE, SYSDATE))
                               )
                        AND (
                                    (DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH = TO_CHAR (SYSDATE - 1, 'YYYYMM')
                                    AND 
                                     FLAG_DATA_OPTIONS_CURR_MONTH = 1)
                            OR 
                                    (DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH = PAYMENTS_PREV_MONTH
                                    AND 
                                     FLAG_DATA_OPTIONS_CURR_MONTH = 0
                                    AND 
                                     DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_OFF_DATE >=
                                       TO_DATE (TO_CHAR (recPAYMENTS.YEAR_MONTH)|| '01', 'YYYYMMDD'))
                               )
                        AND (   (pBALANCE_DATE IS NULL
                                AND DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE <=
                                       SYSDATE)
                            OR (DB_LOADER_ACCOUNT_PHONE_OPTS.TURN_ON_DATE <=
                                   pBALANCE_DATE)
                              )
                        AND NOT EXISTS
                                        (
                                          SELECT 1
                                           FROM DB_LOADER_ACCOUNT_PHONE_OPTS ph
                                          WHERE ph.YEAR_MONTH = (DB_LOADER_ACCOUNT_PHONE_OPTS.YEAR_MONTH + 1)
                                        ) 
                        AND NOT EXISTS
                                        (
                                          SELECT 1
                                           FROM DB_LOADER_ACCOUNT_PHONE_OPTS op
                                          WHERE op.YEAR_MONTH =
                                                   TO_NUMBER (TO_CHAR (NVL (pBALANCE_DATE, SYSDATE), 'YYYYMM'))
                                         )
                        AND TRUNC(NVL (pBALANCE_DATE, SYSDATE)) > TRUNC(SYSDATE) --������ ��� ���� ������� ������ ������� ����
                   )
         LOOP
            -- ��������� ����
            vSERVICE_START_DATE := recPAYMENTS.BEGIN_DATE;    -- ������ ������

            IF vSERVICE_START_DATE < recSERVICES.TURN_ON_DATE
            THEN
               vSERVICE_START_DATE := TRUNC (recSERVICES.TURN_ON_DATE); -- ���� �����������
            END IF;

            -- �������� ����
            vSERVICE_END_DATE := recPAYMENTS.LAST_MONTH_DATE;  -- ����� ������
            --
            vDATE_SERVICE_CHECK := recSERVICES.TURN_ON_DATE + 1;

            IF vDATE_SERVICE_CHECK < vCONTRACT_DATE
            THEN
               vDATE_SERVICE_CHECK := vCONTRACT_DATE + 1;
            END IF;

            IF vDATE_SERVICE_CHECK <
                  TO_DATE (recPAYMENTS.YEAR_MONTH || '01', 'YYYYMMDD')
            THEN
               vDATE_SERVICE_CHECK :=
                  TO_DATE (recPAYMENTS.YEAR_MONTH || '01', 'YYYYMMDD') + 1;
            END IF;

            OPEN CODE (vDATE_SERVICE_CHECK + 5); -- ���� ����������� ������ + 5 ���� �� ������ ������������ ��������

            FETCH CODE INTO recCODE;           -- ������� ��� ������ � ��� ���

            CLOSE CODE;                                                     --

            GET_TARIFF_OPTION_COST (
               recSERVICES.OPERATOR_ID,
               GET_PHONE_TARIFF_ID (pPHONE_NUMBER,
                                    recCODE,
                                    vDATE_SERVICE_CHECK), -- ����� ����� �� �������
               recSERVICES.OPTION_CODE,
               vDATE_SERVICE_CHECK,
               vNEW_TURN_ON_COST,
               vNEW_MONTHLY_COST);
            -- ���� ��������� � ����������� ������, �� ���������� �.
            recSERVICES.TURN_ON_COST :=
               NVL (NVL (vNEW_TURN_ON_COST, recSERVICES.TURN_ON_COST), 0);
            recSERVICES.MONTHLY_PRICE :=
               NVL (NVL (vNEW_MONTHLY_COST, recSERVICES.MONTHLY_PRICE), 0);

            -- ��������� ����������� ��������� ������ � ��� ������, � ������� ����������.
            IF recSERVICES.TURN_ON_COST <> 0
            THEN
               -- ���� ��������� ����������� ���������,
               -- �� ���� ��������� ���� �����������.
               -- ���� ���� ����������� � ������� ������, �� ���� � ������.
               IF TO_CHAR (recSERVICES.TURN_ON_DATE, 'YYYYMM') =
                     recPAYMENTS.YEAR_MONTH
               THEN
                  APPEND_ROW (
                     recSERVICES.TURN_ON_DATE,
                     -recSERVICES.TURN_ON_COST,
                        '���������� ������ '
                     || recSERVICES.OPTION_NAME
                     || ' ('
                     || recSERVICES.OPTION_CODE
                     || ') � '
                     || TO_CHAR (recSERVICES.TURN_ON_DATE, 'DD.MM.YYYY'));
               END IF;
            END IF;

            -- ����������� ����������� ����� �� ������
            IF     (recSERVICES.MONTHLY_PRICE <> 0)
               AND (NVL (vCREDIT, 0) <> 1)
               AND (vPERIOD_ACTIV > 0)
            THEN
               --
               --   �������� ��������� ������ ���:
               --   - ���� ������ ���������� � ������� ������, �� �� ���������� ����
               --     �� ���� ����������� �� ����� ������, ���� �� ���� ����������,
               --     ���� �� ������� ����, ���� ��������� ������� "�� �������".
               --   - ���� ������ ���������� �����, �� � ������� �������� �����, ����
               --     �� ���������� ���� �� ������ ������ �� ���� ����������.
               --   - ���� ������ ���������� ������� (���� ����� ��� ���), �� �������� �� ������.
               --
               -- ���� ��������� ��������� �� �� ����� ������, �� ������������ ���� ���������
               IF (NOT vCALC_ABON_PAYMENT_TO_MONTHEND)
               THEN -- �������� ��� ��������� �� ���������, �� ����� ������ ��� �����
                  IF     (vSERVICE_END_DATE >
                             TRUNC (NVL (pBALANCE_DATE, SYSDATE)))
                     AND (NVL (recSERVICES.DISCR_SPISANIE, 0) <> 1)
                  THEN -- ������ ����������� �� ���������, ��� �������� �� ��� ����.
                     vSERVICE_END_DATE := TRUNC (NVL (pBALANCE_DATE, SYSDATE));
                  END IF;
               ELSE                                -- �������� �� ����� ������
                  IF     (vSERVICE_END_DATE >
                             TRUNC (NVL (pBALANCE_DATE, SYSDATE)))
                     AND (NVL (recSERVICES.DISCR_SPISANIE, 1) = 0)
                  THEN -- ������ ����������� �� ���������, ��� �������� �� ����� ������.
                     vSERVICE_END_DATE := TRUNC (NVL (pBALANCE_DATE, SYSDATE));
                  END IF;
               END IF;

               -- ���� ������ ��������� ����� ����� ������������ ������, ��
               -- ���� ��������� ������ ��������������
               IF vSERVICE_END_DATE > recSERVICES.TURN_OFF_DATE
               THEN
                  vSERVICE_END_DATE := recSERVICES.TURN_OFF_DATE;
               END IF;

               --
               vSERVICE_PAID_FULL := 0;

               IF     (pPHONE_NUMBER = '9099093514')
                  AND (recSERVICES.OPTION_CODE = 'MN_UNLIMC')
                  AND (vSERVICE_END_DATE >=
                          TRUNC (NVL (pBALANCE_DATE, SYSDATE)))
               THEN
                  IF vSERVICE_END_DATE >= TRUNC (SYSDATE)
                  THEN
                     vSERVICE_END_DATE :=
                        CASE
                           WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) <= 25
                           THEN
                              TO_DATE ('25' || TO_CHAR (SYSDATE, 'MMYYYY'),
                                       'DDMMYYYY')
                           ELSE
                              TO_DATE (
                                    '25'
                                 || TO_CHAR (ADD_MONTHS (SYSDATE, 1),
                                             'MMYYYY'),
                                 'DDMMYYYY')
                        END;
                     vSERVICE_PAID_FULL := 1;
                  END IF;
               END IF;

               --
               --������ ���������� ����, �� ������� ����� ���������
               --���� pBALANCE_DATE ������ ������� ����, �� ����� ������� ����, �.�. ��������� ��� ����
               pDATE_DETER := SYSDATE;
               IF TRUNC(NVL(pBALANCE_DATE, SYSDATE)) > TRUNC(SYSDATE) THEN
                 pDATE_DETER :=NVL(pBALANCE_DATE, SYSDATE) ;
               END IF;
               
               IF     (recSERVICES.OPTION_CODE = 'GPRS_FS')
                  AND (vSERVICE_END_DATE > pDATE_DETER) --SYSDATE)
               THEN
                  vSERVICE_END_DATE := pDATE_DETER; --SYSDATE;
               END IF;

               --
               IF vCALC_OPTIONS_DAILY_ACTIV = '1'
               THEN
                  vLAST_DAY_OPTION_ADD := vSERVICE_START_DATE - 1;
                  vCOUNT_ACT_OPTION := 0;

                  FOR recACTIV
                     IN OPT_ACT (vSERVICE_START_DATE, vSERVICE_END_DATE)
                  LOOP
                     IF recACTIV.BEGIN_DATE <= vLAST_DAY_OPTION_ADD
                     THEN
                        recACTIV.BEGIN_DATE := vLAST_DAY_OPTION_ADD + 1;
                     END IF;

                     IF recACTIV.END_DATE > vSERVICE_END_DATE
                     THEN
                        recACTIV.END_DATE := vSERVICE_END_DATE;
                     END IF;

                     vCOUNT_ACT_OPTION :=
                          vCOUNT_ACT_OPTION
                        + (  TRUNC (recACTIV.END_DATE)
                           - TRUNC (recACTIV.BEGIN_DATE)
                           + 1);
                     vLAST_DAY_OPTION_ADD := recACTIV.END_DATE;
                  END LOOP;
               END IF;

               -- ��������
               IF     (vSERVICE_START_DATE <= vSERVICE_END_DATE)
                  AND (   pBALANCE_DATE IS NULL
                       OR vSERVICE_START_DATE <= pBALANCE_DATE)
               THEN
                  IF vSERVICE_PAID_FULL = 0
                  THEN
                     APPEND_ROW (
                        vSERVICE_START_DATE,
                          -recSERVICES.MONTHLY_PRICE
                        * CASE
                             WHEN NVL (recSERVICES.DISCR_SPISANIE, 0) = 1
                             THEN
                                1
                             ELSE
                                  CASE
                                     WHEN vCALC_OPTIONS_DAILY_ACTIV = '1'
                                     THEN
                                        vCOUNT_ACT_OPTION
                                     ELSE
                                        (  TRUNC (vSERVICE_END_DATE)
                                         - TRUNC (vSERVICE_START_DATE)
                                         + 1)
                                  END
                                / (  TRUNC (recPAYMENTS.LAST_MONTH_DATE)
                                   - TRUNC (recPAYMENTS.FIRST_MONTH_DATE)
                                   + 1)
                          END,
                           '2 ��������� �� ������ '
                        || recSERVICES.OPTION_NAME
                        || ' ('
                        || recSERVICES.OPTION_CODE
                        || ') � '
                        || TO_CHAR (vSERVICE_START_DATE, 'DD.MM.YYYY')
                        || ' �� '
                        || TO_CHAR (vSERVICE_END_DATE, 'DD.MM.YYYY')
                        || CASE
                              WHEN vCALC_OPTIONS_DAILY_ACTIV = '1'
                              THEN
                                    ' ��� ���. ��: '
                                 || TO_CHAR (vCOUNT_ACT_OPTION)
                              ELSE
                                 ''
                           END);
                  ELSE
                     APPEND_ROW (
                        vSERVICE_START_DATE,
                        CASE
                           WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) <= 25
                           THEN
                              -recSERVICES.MONTHLY_PRICE
                           ELSE
                              -recSERVICES.MONTHLY_PRICE * 2
                        END,
                           '����� �� ������ '
                        || recSERVICES.OPTION_NAME
                        || ' �� '
                        || TO_CHAR (
                              CASE
                                 WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) <=
                                         25
                                 THEN
                                    TO_DATE (
                                       '25' || TO_CHAR (SYSDATE, 'MMYYYY'),
                                       'DDMMYYYY')
                                 ELSE
                                    TO_DATE (
                                          '25'
                                       || TO_CHAR (ADD_MONTHS (SYSDATE, 1),
                                                   'MMYYYY'),
                                       'DDMMYYYY')
                              END,
                              'DD.MM.YYYY'));
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END IF;
   END LOOP;
 end if; -- if vHANDS_BILLING = 1 then
END;
/
