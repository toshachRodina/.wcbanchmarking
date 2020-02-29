/*
===================================================================================================
TABLE CREATION
===================================================================================================
drop table PY_ECONOMIC_CALENDAR;

CREATE
	TABLE
		PY_ECONOMIC_CALENDAR(
			ID INTEGER PRIMARY KEY AUTOINCREMENT,
			MSMT_DTE_ID INTEGER,
			DATA_TYPE VARCHAR(30),
			SITE_CDE VARCHAR(20),
			ANNCE_DTE VARCHAR(20),
			ANNCE_TM VARCHAR(20),
			CNTRY_CDE VARCHAR(3),
			ANNCE_CDE VARCHAR(20),
			ANNCE_DESC VARCHAR(1000),
			IMPACT VARCHAR(20),
			ACTUAL VARCHAR(20),
			FORECAST VARCHAR(20),
			PREVIOUS VARCHAR(20),
			CAPTR_DTE_ID INTEGER,
			STARTED_AT VARCHAR(20),
			FINISHED_AT VARCHAR(20)
		);

===================================================================================================
*/


SELECT * from PY_ECONOMIC_CALENDAR