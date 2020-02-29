/*
=======================================================================================================================================================================================================
SUBJECT		 : Control table housing variables required for automating/running python packages
OBJECT TYPE	 : TABLE
OBJECT NAME	 : PY_VARS_CTL
CREATED BY	 : Harold Delaney
CREATED ON	 : 20191012
SOURCE	 : 
PREPERATION	 : CREATE TABLE INSERT VALUES REQUIRED FOR SSIS RUNNING
REMARKS	 : 1) 
           2)
           3)
 
=======================================================================================================================================================================================================

PRAGMA auto_vacuum = FULL;


TABLE CREATION
-----------------------------

DROP TABLE PY_VARS_CTL;

CREATE TABLE PY_VARS_CTL (
    id        INTEGER        PRIMARY KEY AUTOINCREMENT,
    ENV       VARCHAR (6)    NOT NULL,
    PKG_NME   VARCHAR (150),
    VAR_TYPE  VARCHAR (6)    NOT NULL,
    VAR_NME   VARCHAR (150)  NOT NULL,
    VAR_VAL   VARCHAR (2000) NOT NULL,
    VAR_CMNTS VARCHAR (2000) NOT NULL
);

select pkg_nme,max(case when var_nme = 'SITE_CDE' then var_val else '' end) as site_cde
,max(case when var_nme = 'CNTRY_CDE' then var_val else '' end) as cntry_cde
,max(case when var_nme = 'URL' then var_val else '' end) as site_url
 from PY_VARS_CTL where pkg_nme in (select pkg_nme from PY_VARS_CTL where var_val = 'JOBS') and var_nme in ('URL','SITE_CDE','CNTRY_CDE') 
 group by pkg_nme

 
select *
 from PY_VARS_CTL where pkg_nme ='PY_JOBS_US_SIMPLYHIRED' in (select pkg_nme from PY_VARS_CTL where var_val = 'JOBS') and var_nme in ('URL','SITE_CDE') 

select distinct pkg_nme from PY_VARS_CTL where 1 = 1 order by 1


select * from PY_VARS_CTL where var_nme = 'PYTHON_SCRIPT_PATH_JOBS'
=======================================================================================================================================================================================================
*/

delete from PY_VARS_CTL;

-- ENVIRONMENT PARAMETERS
-- PROD
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL_SNDR_USRNME','lanoitan17@gmail.com','email sender username/address for email notifications');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL_SNDR_PWORD','500BourkeStreet','email sender password');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL_DSTRBTN_LST','toshach@gmail.com','email distribution list for email notifications');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','DATA_RETENTION_DAYS','60','number of days to keep data within sqlite tables.  is overridden if a pkg variable is present');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL_MSG','','generic email message. is overridden if pkg variable is present');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','LOOP_RNDM_SLEEP_LOW','1','sets the lower limit of the random wait time function accross all packages that rely on looping through web pages on the site (assists in reflecting human interaction on website');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','LOOP_RNDM_SLEEP_HIGH','5','sets the higher limit of the random wait time function accross all packages that rely on looping through web pages on the site (assists in reflecting human interaction on website');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','WEB_DRVR_NME','chromedriver.exe','the web driver used for the selenium parser');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','DEFAULT_SYS_DOWNLOAD_PATH','C:\Users\tosha\Downloads','file path to default system download folder');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','PYTHON_SCRIPT_PATH_MARKETS','D:\Sync\__rodinaFre\__scripts\__python\markets\\','file path to relevant scripts');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','PYTHON_SCRIPT_PATH_ECO_CAL','D:\Sync\__rodinaFre\__scripts\__python\economic_cal\\','file path to relevant scripts');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','GMAIL_SMTP_HOST','smtp.gmail.com','smtp host details for gmail');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','GMAIL_SMTP_HOST','587','smtp port number for gmail');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','PYTHON_EXE_PATH','C:\Users\tosha\Anaconda3\envs\rodinaFre\python.exe','python executable path');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','ALPHAVANTAGE_API_KEY','56K58AYA092DZZPA','api key');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','QUANDL_API_KEY','-7YMD_XEY7yvNsYDX92s','api key');

/* 
==============================================================================================================================
MARKETS
============================================================================================================================== 
*/
-- PY_BATCH_MARKETS (CONTROLS WHAT SCRIPTS IN THE "MARKETS" FOLDER ARE RUN)
-- PROD
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_BATCH_MARKETS','PKG','ACTIVE_IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_BATCH_MARKETS','PKG','PKGS_TO_RUN','PY_COMMODITIES','list of packages to be run within the current folder (comma(,) delimeted)');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_BATCH_MARKETS','PKG','SMRY_DESC','(NA)','batch controller - this package is used to fire packages located in same folder and listed in the PKG_TO_RUN variable');

-- PY_COMMODITIES
-- PROD
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_COMMODITIES','PKG','ACTIVE_IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_COMMODITIES','PKG','SMRY_DESC','(NA)','using the yahoo finance API, retrieve various commoditiy prices per day');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_COMMODITIES','PKG','TBL_NME','PY_COMMODITY_DATA','table name for the scrape results to be posted to');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_COMMODITIES','PKG','CMDTY_CDES','NASDAQOMX/NQUSB1771AUD,NASDAQOMX/NQUSB1771AUDN,NASDAQOMX/NQUSB1771AUDT,NASDAQOMX/NQUSB1771CAD,NASDAQOMX/NQUSB1771CADT,NASDAQOMX/NQUSB1771GBP,NASDAQOMX/NQUSB1771GBPT,NASDAQOMX/QCOL,NASDAQOMX/NQCICCER,NASDAQOMX/NQCICCTR,NASDAQOMX/NQCIKCER,NASDAQOMX/NQCIKCTR,NASDAQOMX/NQCICUER,NASDAQOMX/NQCICUTR,NASDAQOMX/NQCIHGER,NASDAQOMX/NQCIHGTR,NASDAQOMX/NQAU0001,NASDAQOMX/NQAU0001T,NASDAQOMX/NQCA0001,NASDAQOMX/NQCA0001T,NASDAQOMX/NQCICLER,NASDAQOMX/NQCICLTR,NASDAQOMX/NQG0001,NASDAQOMX/NQG0001T,NASDAQOMX/NQGB0001,NASDAQOMX/NQGB0001T,NASDAQOMX/NQNA0001,NASDAQOMX/NQCIGCER,NASDAQOMX/NQCIGCTR,NASDAQOMX/NQXAUGLD,NASDAQOMX/NQXAUGLD,NASDAQOMX/XAU,NASDAQOMX/NQUSB1757AUD,NASDAQOMX/NQUSB1757AUDN,NASDAQOMX/NQUSB1757AUDT,NASDAQOMX/NQUSB1757CAD,NASDAQOMX/NQUSB1757CADN,NASDAQOMX/NQUSB1757CADT,NASDAQOMX/NQUSB1757GBPN,NASDAQOMX/NQCINGER,NASDAQOMX/NQCINGTR,NASDAQOMX/NQCISIER,NASDAQOMX/NQCISITR','codes used to query api database');

-- PY_$EVZ
-- PROD
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_$EVZ','PKG','ACTIVE_IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_$EVZ','PKG','SMRY_DESC','(NA)','collecting daily close price for $EVZ per day');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_$EVZ','PKG','TBL_NME','PY_EVZ_DATA','table name for the scrape results to be posted to');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_$EVZ','PKG','URL','https://www.barchart.com/stocks/quotes/$EVZ','source url to scrape');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_$EVZ','PKG','DATA_TYPE','STOCK','data type entry for results');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_$EVZ','PKG','SITE_CDE','$EVZ','site code entry for results');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_$EVZ','PKG','USES_WEB_DRVR','N','indicates whether web driver (selenium) is used or html can be parsed directly');

/* 
==============================================================================================================================
ECONOMIC CALENDAR
============================================================================================================================== 
*/
-- PY_BATCH_ECO_CAL (CONTROLS WHAT SCRIPTS IN THE "GOVT_KDA" FOLDER ARE RUN)
-- PROD
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_BATCH_CALENDAR','PKG','ACTIVE_IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_BATCH_CALENDAR','PKG','PKGS_TO_RUN','PY_ECONOMIC_CALENDAR','list of packages to be run within the current folder (comma(,) delimeted)');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_BATCH_CALENDAR','PKG','SMRY_DESC','(NA)','batch controller - this package is used to fire packages located in same folder and listed in the PKG_TO_RUN variable');
-- PY_ECONOMIC_CALENDAR
-- PROD 
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_ECONOMIC_CALENDAR','PKG','ACTIVE_IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_ECONOMIC_CALENDAR','PKG','SMRY_DESC','(NA)','scrapes key dates listed on forex factory');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_ECONOMIC_CALENDAR','PKG','URL','https://www.forexfactory.com/calendar.php?month=','source url to scrape');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_ECONOMIC_CALENDAR','PKG','TBL_NME','PY_ECONOMIC_CALENDAR','table name for the scrape results to be posted to');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_ECONOMIC_CALENDAR','PKG','DATA_TYPE','ECONOMIC ANNOUNCEMENT','data type entry for results');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_ECONOMIC_CALENDAR','PKG','SITE_CDE','FOREXFACTORY','site code entry for results');
insert into PY_VARS_CTL (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','PY_ECONOMIC_CALENDAR','PKG','USES_WEB_DRVR','N','indicates whether web driver (selenium) is used or html can be parsed directly');

-- SHRINK/OPTIMISE DATABASE

VACUUM;	

--=========

--WITH DAT AS(
--	SELECT
--		UN.VAR_NME,
--		MIN( UN.ENV_FLG ) AS ENV_FLG
--	FROM
--		(
--			SELECT
--				VARS.VAR_NME,
--				VARS.VAR_VAL,
--				CASE
--					VARS.VAR_TYPE
--					WHEN 'ENV' THEN 2
--					WHEN 'PKG' THEN 1
--				END AS ENV_FLG
--			FROM
--				PY_VARS_CTL VARS
--			WHERE
--				VARS.ENV = 'DEV'
--				AND VARS.VAR_TYPE = 'ENV'
--		UNION ALL SELECT
--				VARS.VAR_NME,
--				VARS.VAR_VAL,
--				CASE
--					VARS.VAR_TYPE
--					WHEN 'ENV' THEN 2
--					WHEN 'PKG' THEN 1
--				END AS ENV_FLG
--			FROM
--				PY_VARS_CTL VARS
--			WHERE
--				VARS.ENV = 'DEV'
--				AND VARS.PKG_NME = 'PY_CCY_PAIRS_TICK_FX'
--				AND VARS.VAR_TYPE = 'PKG'
--		) UN
--	GROUP BY
--		VAR_NME
--) SELECT
--	VARS.VAR_NME,
--	VARS.VAR_VAL
--FROM
--	DAT,
--	PY_VARS_CTL VARS
--WHERE
--	VARS.ENV = 'DEV'
--	AND VARS.VAR_NME != 'SMRY_DESC'
--	AND VARS.PKG_NME = CASE
--		DAT.ENV_FLG
--		WHEN 1 THEN 'PY_CCY_PAIRS_TICK_FX'
--		WHEN 2 THEN ''
--	END
--	AND VARS.VAR_TYPE = CASE
--		DAT.ENV_FLG
--		WHEN 1 THEN 'PKG'
--		WHEN 2 THEN 'ENV'
--	END
--	AND VARS.VAR_NME = DAT.VAR_NME




/*
MOVING DATA FROM 1 DATABASE TO ANOTHER
-- HELPFUL WHEN CONFLICT DB HAS DATA THAT HASNT BEEN APPLIED TO ACTUAL DB

SELECT * FROM PY_B4S_DATA

CREATE
	TABLE
		PY_JOBS_DATA(
			ID INTEGER PRIMARY KEY AUTOINCREMENT,
			MSMT_DTE_ID INTEGER,
			DATA_TYPE VARCHAR(3),
			CNTRY_CDE VARCHAR(2),
			SITE_CDE VARCHAR(30),
			FACET_TYPE VARCHAR(30),
			FACET_DESC VARCHAR(100),
			FACET_CNT INTEGER,
			STARTED_AT VARCHAR(20),
			FINISHED_AT VARCHAR(20)
		);

ATTACH DATABASE 'D:\Sync\__lanoitan\@data\PY_WEB_DATA.db'  AS att_db;
  
insert
	into
		PY_JOBADS_JOBS_DATA(
			MSMT_DTE_ID,
			DATA_TYPE,
			CNTRY_CDE,
			SITE_CDE,
			FACET_TYPE,
			FACET_DESC,
			FACET_CNT,
			STARTED_AT,
			FINISHED_AT
		) select
			MSMT_DTE_ID,
			DATA_TYPE,
			CNTRY_CDE,
			SITE_CDE,
			FACET_TYPE,
			FACET_DESC,
			FACET_CNT,
			STARTED_AT,
			FINISHED_AT
		from
			att_db.PY_JOBS_DATA a
		where
			1 = 1;


DETACH att_db;

*/


