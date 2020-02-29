/*
===================================================================================================
TABLE CREATION
===================================================================================================

--drop table PY_COMMODITY_DATA;
--delete from PY_COMMODITY_DATA;

CREATE
	TABLE
		PY_COMMODITY_DATA(
			ID INTEGER PRIMARY KEY AUTOINCREMENT,
			CMDTY_CDE VARCHAR(30),
			MSMT_DTE_ID INT,
			TRADE_DT VARCHAR(50),
			INDEX_VAL VARCHAR(50),
			HIGH_VAL VARCHAR(50),
			LOW_VAL VARCHAR(50),
			TTL_MRKT_VAL VARCHAR(50),
			DIV_MRKT_VAL INTEGER,
			CAPTR_DTE_ID INT,
			STARTED_AT VARCHAR(20),
			FINISHED_AT VARCHAR(20)
		);

===================================================================================================
*/
SELECT ID, MSMT_DTE_ID, DATA_TYPE, TRADE_DT, INDEX_VAL, HIGH_VAL, LOW_VAL, TTL_MRKT_VAL, DIV_MRKT_VAL, CAPTR_DTE_ID, STARTED_AT, FINISHED_AT
FROM PY_COMMODITY_PRICE_DATA;



SELECT dat.cmdty_cde
     , dat.msmt_dte_id
     , dat.trade_dt
     , dat.index_val
     , dat.high_val
     , dat.low_val
     , dat.ttl_mrkt_val
     , dat.div_mrkt_val
     , dat.captr_dte_id
     , dat.started_at
     , dat.finished_at
  FROM py_commodity_data AS dat;			
