/*
=======================================================================================================================================================================================================
SUBJECT		 : log table displaying ERROR and SUCCESS detail
OBJECT TYPE	 : TABLE
OBJECT NAME	 : PY_PROCESS_LOG
CREATED BY	 : Harold Delaney
CREATED ON	 : 20170406
SOURCE	 : 
PREPERATION	 : CREATE TABLE INSERT VALUES REQUIRED FOR SSIS RUNNING
REMARKS	 : 1) 
	       2)
	       3) 
=======================================================================================================================================================================================================

TABLE CREATION
-----------------------------

DROP TABLE PY_PROCESS_LOG;

CREATE
	TABLE
		PY_PROCESS_LOG(
			ID INTEGER PRIMARY KEY AUTOINCREMENT,
			MSMT_DTE_ID INTEGER,
			PKG_NME VARCHAR(50),
			START_DATETIME VARCHAR(20),
			END_DATETIME VARCHAR(20),
			STATUS VARCHAR(20),
			STATUS_DESC VARCHAR(20000),
			VARS VARCHAR(20000)
		);

select * from PY_PROCESS_LOG
=======================================================================================================================================================================================================
*/

