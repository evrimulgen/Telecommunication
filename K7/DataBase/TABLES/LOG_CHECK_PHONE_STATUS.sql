CREATE TABLE LOG_CHECK_PHONE_STATUS
(
  PHONE_NUMBER VARCHAR2(10) NOT NULL,
  DATE_CREATED DATE,
  INSERT_DATE DATE DEFAULT SYSDATE,
  IS_ERROR INTEGER,
  ERROR_TEXT VARCHAR2 (250)
  
);

COMMENT ON TABLE LOG_CHECK_PHONE_STATUS IS '������� ��� ���������� �������� �� ������ ��������';
COMMENT ON COLUMN LOG_CHECK_PHONE_STATUS.PHONE_NUMBER IS '����� ��������';
COMMENT ON COLUMN LOG_CHECK_PHONE_STATUS.DATE_CREATED IS '���� �������� ������ � ������� (QUEUE_FOR_CHECK_PHONE_STATUS)';
COMMENT ON COLUMN LOG_CHECK_PHONE_STATUS.INSERT_DATE IS '���� �������� ������ � ���� (LOG_CHECK_PHONE_STATUS)';
COMMENT ON COLUMN LOG_CHECK_PHONE_STATUS.IS_ERROR IS '������ �������� ������ (0 -��� ������, 1 - � �������)';
COMMENT ON COLUMN LOG_CHECK_PHONE_STATUS.ERROR_TEXT IS '����� ������';