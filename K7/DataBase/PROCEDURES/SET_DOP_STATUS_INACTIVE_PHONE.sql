CREATE OR REPLACE PROCEDURE SET_DOP_STATUS_INACTIVE_PHONE
IS
  -- #Version=2
  -- v2 �������� �., ������� �.  - �������� ������ �� �/�
  -- v1 �������� �., ������� �.  - ��� �������, � ������� � ������ ���� �������� ����������� ���������� � ������� ��������� �������, ����������� ��� ������  "���� �� ������������" (id=141). 
                                               -- ����������� ������ J_SET_DOP_STATUS_INACTIVE_PHONE � ������ 18:00 - 19:00  
                                               -- ����� ����� � ������ ������ ������ � ������������ ������������ �� ����������
   
   TYPE TContrID IS RECORD
   (
     CONTRACT_ID INTEGER
   ); 
   type TArrayContrID is table of TContrID index by pls_integer;   
   vListContract TArrayContrID; 
   
   pDATE_BEGIN DATE;
   pDATE_END DATE;
                                                       
      CURSOR Cur(pDATE_BEGIN IN DATE, pDATE_END IN DATE) IS          
          SELECT CN.CONTRACT_ID
          FROM CONTRACTS CN
                 , V_PHONE_INACTIVE V
         WHERE ( CN.PHONE_NUMBER_FEDERAL, TRUNC(CN.CONTRACT_DATE) ) IN 
                        (               
                            SELECT PH.PHONE_NUMBER_FEDERAL, TRUNC (PH.CONTRACT_DATE)
                              FROM TABLE(GET_PHONE_INACTIVE_TAB(pDATE_BEGIN, pDATE_END)) PH   
                            WHERE PH.LOGIN IN 
                                                            (
                                                                 SELECT ac.LOGIN 
                                                                   FROM ACCOUNTS ac
                                                                 WHERE NVL(ac.IS_COLLECTOR, 0) = 1 
                                                            )                      
                        )
             AND CN.DOP_STATUS IS NULL                
             AND ( (CN.PHONE_NUMBER_FEDERAL = V.PHONE_NUMBER_FEDERAL) AND (TRUNC(CN.CONTRACT_DATE) = TRUNC(V.CONTRACT_DATE)) )
             AND NVL(V.PHONE_IS_ACTIVE_VALUE, 0) = 1 --����� ����� ������������� ������ ��������                                                     
        ;       
BEGIN
  --�������� ���������, � ������� �� 3 ���� ��� ����������
  pDATE_BEGIN := TRUNC(SYSDATE-2); 
  pDATE_END := TRUNC(SYSDATE-2);
  
  OPEN CUR(pDATE_BEGIN, pDATE_END);
  FETCH CUR BULK COLLECT INTO vListContract;
  CLOSE CUR; 
  
  IF vListContract.COUNT > 0 THEN
      FOR I IN 1..vListContract.COUNT LOOP
        BEGIN
             UPDATE CONTRACTS CN
                   SET CN.DOP_STATUS = 141
              WHERE  CN.CONTRACT_ID = vListContract(I).CONTRACT_ID;
              --DBMS_OUTPUT.PUT_LINE(' �����: ' || vListContract(I).CONTRACT_ID);
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
      END LOOP;   
      COMMIT;
  END IF;
END;
/
