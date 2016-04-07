CREATE TABLE CONTRACT_STATISTICS(
  CONTRACT_ID INTEGER PRIMARY KEY,
  PHONE_NUMBER VARCHAR2(10 CHAR) NOT NULL,
  DATE_BEGIN DATE NOT NULL,
  DATE_CANCEL DATE,
  BILLS_SUMM_ALL NUMBER(15, 4),
  PAYMENTS_SUMM_ALL NUMBER(15, 4),
  BILLS_SUMM_BEELINE NUMBER(15, 4),
  PAYMENTS_SUMM_BEELINE NUMBER(15, 4),
  DEBITORKA NUMBER(15, 4),
  STAT_COMPLETE INTEGER
  );
  
ALTER TABLE CONTRACT_STATISTICS ADD (
  CONSTRAINT FK_CONTRACT_STAT_CONTRACT_ID 
    FOREIGN KEY (CONTRACT_ID) 
    REFERENCES CONTRACTS (CONTRACT_ID)
  );    
  
GRANT SELECT, INSERT, UPDATE, DELETE ON CONTRACT_STATISTICS TO CORP_MOBILE_ROLE;  

CREATE INDEX I_CONTRACT_STATS_PHONE ON CONTRACT_STATISTICS 
  (PHONE_NUMBER);