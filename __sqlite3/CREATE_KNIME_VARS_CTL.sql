/*
=======================================================================================================================================================================================================
SUBJECT		 : Control table housing variables required for automating/running knime packages
OBJECT TYPE	 : TABLE
OBJECT NAME	 : CTL_KNIME_VARS
CREATED BY	 : Harold Delaney
CREATED ON	 : 20180716
SOURCE	 : 
PREPERATION	 : CREATE TABLE INSERT VALUES REQUIRED FOR KNIME RUNNING
REMARKS	 : 1) 
           2)
           3)
 
=======================================================================================================================================================================================================

PRAGMA auto_vacuum = FULL;

TABLE CREATION
-----------------------------

DROP TABLE CTL_KNIME_VARS;

CREATE TABLE CTL_KNIME_VARS (
    id        INTEGER        PRIMARY KEY AUTOINCREMENT,
    ENV       VARCHAR (6)    NOT NULL,
    PKG_NME   VARCHAR (150),
    VAR_TYPE  VARCHAR (6)    NOT NULL,
    VAR_NME   VARCHAR (150)  NOT NULL,
    VAR_VAL   VARCHAR (2000) NOT NULL,
    VAR_CMNTS VARCHAR (2000) NOT NULL
);

=======================================================================================================================================================================================================
*/

/*
=======================================================================================================================================================================================================
DO NOT DELETE AND RERUN BELOW INSERTS
DATE PARAMS DRIVE PARTS OF THE KNIME DATA PROCESSING AND ANY DATES SHOW BELOW SHOULD BE VIEWED AS NOT CURRENT
AMEND AND RUN UPDATE SCRIPTS TO ALTER EXISTING ENTRIES
=======================================================================================================================================================================================================
*/
/*
UPDATE
	CTL_KNIME_VARS
SET
	VAR_VAL = 20180601
WHERE
	1 = 1
	AND PKG_NME = 'FX_PAIRS_TICK'
	AND ENV = 'PROD'
	AND VAR_NME = 'EXTRACT_DTE_ID'
*/


delete from CTL_KNIME_VARS;

/*
ENVIRONMENT PARAMETERS
-------------------------------------------------
SELECT
	*
FROM
	CTL_KNIME_VARS
WHERE
	1 = 1
	AND env = 'PROD'
	AND var_type = 'ENV'

*/
-- PROD
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','FILEPATH.CMDLINE','C:\Windows\System32\cmd.exe','file path to the windows command executable');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','FILEPATH.7ZIP','P:\PortableApps\PortableApps\7-ZipPortable\App\7-Zip64\7z.exe','file path to the 7zip portableApps executable');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','FILEPATH.BATCH.FILES','D:\Sync\__rodinaFre\__scripts\__batch','file path to the batch command files used to run 3rd party scripts');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','FILEPATH.PYTHON.EXE','C:\Users\tosha\Anaconda3\envs\lanoitan\python.exe','python executable path');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','FILEPATH.CHROME.WEB.DRVR','D:\Sync\__rodinaFre\@drivers\chromedriver.exe','the web driver used for the selenium parser');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','FILEPATH.DEFAULT.SYS.DOWNLOAD.DIR','D:\Downloads','file path to default system download folder');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','FILEPATH.PREPROCESSED','H:\__rodinaFre.local\__data\__preprocessed','file path to the data folder used to prepare files for extraction and import');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','FILEPATH.PROCESSED','H:\__rodinaFre.local\__data\__processed','file path to the data folder used to archived post processed  external flat files');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','POSTGRES.HOSTNAME','localhost','postgres hostname');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','POSTGRES.DB.NAME','rodinaFre','db url for connection');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','POSTGRES.DB.PORT','5432','db url for connection');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','POSTGRES.DB.USER','postgres','user sign on');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','POSTGRES.DB.PWRD','fletch$00','user password');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','POSTGRES.DB.RF.SCHEMA','RF','default schema for rodinaFre work');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL.GMAIL.SENDER.NME','lanoitan17@gmail.com','email sender username/address for email notifications');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL.GMAIL.SENDER.PWD','500BourkeStreet','email sender password');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL.GMAIL.SMTP.HOST','smtp.gmail.com','smtp host details for gmail');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL.GMAIL.SMTP.PORT','587','smtp port number for gmail');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL.DSTRBTN.LST','toshach@protonmail.com','email distribution list for email notifications');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','EMAIL.MSG','','generic email message if not specified in package variables');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','KEY.ALPHAVANTAGE.API','56K58AYA092DZZPA','api key');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','KEY.QUANDL.API','-7YMD_XEY7yvNsYDX92s','api key');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','DATA.RETENTION.DAYS','30','number of days to keep data within sqlite tables.  is overridden if a pkg variable is present');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','LOOP.RNDM.SLEEP.LOW','1','sets the lower limit of the random wait time function accross all packages that rely on looping through web pages on the site (assists in reflecting human interaction on website');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','','ENV','LOOP.RNDM.SLEEP.HIGH','5','sets the higher limit of the random wait time function accross all packages that rely on looping through web pages on the site (assists in reflecting human interaction on website');

-- DEV
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','FILEPATH.CMDLINE','C:\Windows\System32\cmd.exe','file path to the windows command executable');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','FILEPATH.7ZIP','P:\PortableApps\PortableApps\7-ZipPortable\App\7-Zip64\7z.exe','file path to the 7zip portableApps executable');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','FILEPATH.BATCH.FILES','D:\Sync\__rodinaFre\__scripts\__batch','file path to the batch command files used to run 3rd party scripts');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','FILEPATH.PYTHON.EXE','C:\Users\tosha\Anaconda3\envs\lanoitan\python.exe','python executable path');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','FILEPATH.CHROME.WEB.DRVR','D:\Sync\__rodinaFre\@drivers\chromedriver.exe','the web driver used for the selenium parser');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','FILEPATH.DEFAULT.SYS_DOWNLOAD_DIR','D:\Downloads','file path to default system download folder');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','FILEPATH.PREPROCESSED','H:\__rodinaFre.local\__data\__preprocessed','file path to the data folder used to prepare files for extraction and import');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','FILEPATH.PROCESSED','H:\__rodinaFre.local\__data\__processed','file path to the data folder used to archived post processed  external flat files');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','POSTGRES.HOSTNAME','localhost','postgres hostname');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','POSTGRES.DB.NAME','rodinaFre','db url for connection');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','POSTGRES.DB.PORT','5432','db url for connection');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','POSTGRES.DB.USER','postgres','user sign on');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','POSTGRES.DB.PWRD','fletch$00','user password');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','POSTGRES.DB.RF.SCHEMA','RF','default schema for rodinaFre work');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','EMAIL.GMAIL.SENDER.NME','lanoitan17@gmail.com','email sender username/address for email notifications');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','EMAIL.GMAIL.SENDER.PWD','500BourkeStreet','email sender password');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','EMAIL.GMAIL.SMTP.HOST','smtp.gmail.com','smtp host details for gmail');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','EMAIL.GMAIL.SMTP.PORT','587','smtp port number for gmail');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','EMAIL.DSTRBTN.LST','toshach@protonmail.com','email distribution list for email notifications');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','EMAIL.MSG','','generic email message if not specified in package variables');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','KEY.ALPHAVANTAGE.API','56K58AYA092DZZPA','api key');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','KEY.QUANDL.API','-7YMD_XEY7yvNsYDX92s','api key');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','DATA.RETENTION.DAYS','30','number of days to keep data within sqlite tables.  is overridden if a pkg variable is present');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','LOOP.RNDM.SLEEP.LOW','1','sets the lower limit of the random wait time function accross all packages that rely on looping through web pages on the site (assists in reflecting human interaction on website');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','','ENV','LOOP.RNDM.SLEEP.HIGH','5','sets the higher limit of the random wait time function accross all packages that rely on looping through web pages on the site (assists in reflecting human interaction on website');

/* 
==============================================================================================================================
TABLEAU REPORT UPDATE (CHANGE SQLSERVER CONNECTIONS DEPENDING ON PLATFORM BEING RUN ON)
** NO PYTHON BATCH REQUIRED - WILL BE RUN INDIVIDUALLY FROM REPORTING DIRECTORY USING CMD BATCH
============================================================================================================================== 
*/

/*
PY_CCY_PAIRS_TICK_FX
-------------------------------------------------
SELECT
	*
FROM
	CTL_KNIME_VARS
WHERE
	1 = 1
	AND env = 'PROD'
	AND var_type = 'PKG'
	AND pkg_nme = 'FX_PAIRS_TICK'
	
*/

-- PROD
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','ACTIVE.IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','SMRY.DESC','(NA)','retrieves monthly minute bar currency and idx pairs from histdata.com in compressed folder form.  unpack and import spreadsheet data');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','URL','http://www.histdata.com','source url to scrape');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','URL.PART1','/download-free-forex-data/?/metastock/1-minute-bar-quotes','additional url parts - typical used for search paramaters');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','SLEEP.VAL','20','sets wait time function (assists in reflecting human interaction on website');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','FILE.MOVE.DEST.PATH','D:\Sync\__lanoitan\@data\__fx','destination folder path to store files temporarily');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','FILE.NAME.SEARCH','HISTDATA','part or all of the file name required for moving');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','FILE.EXTENSION','zip','file extension of the files being moved');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','DOWNLOAD.ID','a_file','id tag for the download element');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','CCY.PAIRS','AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,AUXAUD,XAUAUD','ccy pairs to retrieve from histdata');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','USES.WEB.DRVR','N','indicates whether web driver (selenium) is used or html can be parsed directly');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','FX.PAIRS.MBAR','PKG','EXTRACT.DTE.ID','20200131','tracks the next extract date');
-- DEV
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','ACTIVE.IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','SMRY.DESC','(NA)','retrieves monthly minute bar currency and idx pairs from histdata.com in compressed folder form.  unpack and import spreadsheet data');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','URL','http://www.histdata.com','source url to scrape');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','URL.PART1','/download-free-forex-data/?/metastock/1-minute-bar-quotes','additional url parts - typical used for search paramaters');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','SLEEP.VAL','20','sets wait time function (assists in reflecting human interaction on website');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','FILE.MOVE.DEST.PATH','D:\Sync\__lanoitan\@data\__fx','destination folder path to store files temporarily');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','FILE.NAME.SEARCH','HISTDATA','part or all of the file name required for moving');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','FILE.EXTENSION','zip','file extension of the files being moved');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','DOWNLOAD.ID','a_file','id tag for the download element');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','CCY.PAIRS','AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,AUXAUD,XAUAUD','ccy pairs to retrieve from histdata');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','USES.WEB.DRVR','N','indicates whether web driver (selenium) is used or html can be parsed directly');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','FX.PAIRS.MBAR','PKG','EXTRACT.DTE.ID','20200131','tracks the next extract date');

/*
ECONOMIC.CALENDAR.BABYPIPS
-------------------------------------------------
SELECT
    *
FROM
    CTL_KNIME_VARS
WHERE
    1 = 1
    AND env = 'PROD'
    AND var_type = 'PKG'
    AND pkg_nme = 'ECONOMIC.CALENDAR.BABYPIPS'
    
*/
-- PROD 
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','ECONOMIC.CALENDAR.BABYPIPS','PKG','ACTIVE.IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','ECONOMIC.CALENDAR.BABYPIPS','PKG','SMRY.DESC','(NA)','scrapes key dates listed on various world economic calendars');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','ECONOMIC.CALENDAR.BABYPIPS','PKG','URL','https://www.babypips.com/economic-calendar?timezone=Australia%2FMelbourne','source url to scrape');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','ECONOMIC.CALENDAR.BABYPIPS','PKG','TBL.NME','PY_ECONOMIC_CALENDAR','table name for the scrape results to be posted to');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','ECONOMIC.CALENDAR.BABYPIPS','PKG','DATA.TYPE','ECONOMIC ANNOUNCEMENT','data type entry for results');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','ECONOMIC.CALENDAR.BABYPIPS','PKG','SITE.CDE','FXCM','site code entry for results');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','ECONOMIC.CALENDAR.BABYPIPS','PKG','WEEK.NBR','50','calendar site is driven on week number.  use this to determine current and previous week (to pick up the ACTUAL values)');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','ECONOMIC.CALENDAR.BABYPIPS','PKG','USES.WEB.DRVR','N','indicates whether web driver (selenium) is used or html can be parsed directly');
-- DEV 
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','ECONOMIC.CALENDAR.BABYPIPS','PKG','ACTIVE.IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','ECONOMIC.CALENDAR.BABYPIPS','PKG','SMRY.DESC','(NA)','scrapes key dates listed on various world economic calendars');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','ECONOMIC.CALENDAR.BABYPIPS','PKG','URL','https://www.babypips.com/economic-calendar?timezone=Australia%2FMelbourne','source url to scrape');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','ECONOMIC.CALENDAR.BABYPIPS','PKG','TBL.NME','PY_ECONOMIC_CALENDAR','table name for the scrape results to be posted to');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','ECONOMIC.CALENDAR.BABYPIPS','PKG','DATA.TYPE','ECONOMIC ANNOUNCEMENT','data type entry for results');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','ECONOMIC.CALENDAR.BABYPIPS','PKG','SITE.CDE','FXCM','site code entry for results');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','ECONOMIC.CALENDAR.BABYPIPS','PKG','WEEK.NBR','50','calendar site is driven on week number.  use this to determine current and previous week (to pick up the ACTUAL values)');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','ECONOMIC.CALENDAR.BABYPIPS','PKG','USES.WEB.DRVR','N','indicates whether web driver (selenium) is used or html can be parsed directly');


/*
BUSINESS.NAMES.REGISTER
-------------------------------------------------
SELECT
    *
FROM
    CTL_KNIME_VARS
WHERE
    1 = 1
    AND env = 'PROD'
    AND var_type = 'PKG'
    AND pkg_nme = 'BUSINESS.NAMES.REGISTER'
    
*/
-- PROD 
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','BUSINESS.NAMES.REGISTER','PKG','ACTIVE.IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','BUSINESS.NAMES.REGISTER','PKG','SMRY.DESC','(NA)','bulk download business names register');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','BUSINESS.NAMES.REGISTER','PKG','HOST','data.gov.au','source url to scrape');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','BUSINESS.NAMES.REGISTER','PKG','FILE.EXTENSION.1','zip','data type entry - compressed');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','BUSINESS.NAMES.REGISTER','PKG','FILE.EXTENSION.2','xml','data type entry - data');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','BUSINESS.NAMES.REGISTER','PKG','URL.SRCE.FILE.1','/data/dataset/5bd7fcab-e315-42cb-8daf-50b7efc2027e/resource/0ae4d427-6fa8-4d40-8e76-c6909b5a071b/download/dinetpubwwwrootabnlookupwebadminbulkextractpublic_split_1_10.zip','file name and path for download for file #1');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('PROD','BUSINESS.NAMES.REGISTER','PKG','URL.SRCE.FILE.2','/data/dataset/5bd7fcab-e315-42cb-8daf-50b7efc2027e/resource/635fcb95-7864-4509-9fa7-a62a6e32b62d/download/dinetpubwwwrootabnlookupwebadminbulkextractpublic_split_11_20.zip','file name and path for download for file #2');

-- DEV 
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','BUSINESS.NAMES.REGISTER','PKG','ACTIVE.IND','Y','used to bypass from a variables perspective (rather than turning off in BATCH script)');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','BUSINESS.NAMES.REGISTER','PKG','SMRY.DESC','(NA)','bulk download business names register');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','BUSINESS.NAMES.REGISTER','PKG','HOST','data.gov.au','source url to scrape');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','BUSINESS.NAMES.REGISTER','PKG','FILE.EXTENSION.1','zip','data type entry - compressed');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','BUSINESS.NAMES.REGISTER','PKG','FILE.EXTENSION.2','xml','data type entry - data');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','BUSINESS.NAMES.REGISTER','PKG','URL.SRCE.FILE.1','/data/dataset/5bd7fcab-e315-42cb-8daf-50b7efc2027e/resource/0ae4d427-6fa8-4d40-8e76-c6909b5a071b/download/dinetpubwwwrootabnlookupwebadminbulkextractpublic_split_1_10.zip','file name and path for download for file #1');
insert into CTL_KNIME_VARS (ENV, PKG_NME, VAR_TYPE, VAR_NME, VAR_VAL, VAR_CMNTS) values ('DEV','BUSINESS.NAMES.REGISTER','PKG','URL.SRCE.FILE.2','/data/dataset/5bd7fcab-e315-42cb-8daf-50b7efc2027e/resource/635fcb95-7864-4509-9fa7-a62a6e32b62d/download/dinetpubwwwrootabnlookupwebadminbulkextractpublic_split_11_20.zip','file name and path for download for file #2');


-- SHRINK/OPTIMISE DATABASE

VACUUM;	



/*
WITH DAT AS( SELECT
	UN.VAR_NME, MIN(UN.ENV_FLG) AS ENV_FLG
FROM
	( SELECT
		VARS.VAR_NME, VARS.VAR_VAL,
		CASE
			VARS.VAR_TYPE
			WHEN 'ENV' THEN 2
			WHEN 'PKG' THEN 1
		END AS ENV_FLG
	FROM
		CTL_KNIME_VARS VARS
	WHERE
		VARS.ENV = 'PROD'
		AND VARS.VAR_TYPE = 'ENV'
UNION ALL SELECT
		VARS.VAR_NME, VARS.VAR_VAL,
		CASE
			VARS.VAR_TYPE
			WHEN 'ENV' THEN 2
			WHEN 'PKG' THEN 1
		END AS ENV_FLG
	FROM
		CTL_KNIME_VARS VARS
	WHERE
		VARS.ENV = 'PROD'
		AND VARS.PKG_NME = 'FX_PAIRS_TICK'
		AND VARS.VAR_TYPE = 'PKG' ) UN
GROUP BY
	VAR_NME ) SELECT
	VARS.VAR_NME,
	VARS.VAR_VAL
FROM
	DAT,
	CTL_KNIME_VARS VARS
WHERE
	VARS.ENV = 'PROD'
	AND VARS.VAR_NME != 'SMRY_DESC'
	AND VARS.PKG_NME =
	CASE
		DAT.ENV_FLG
		WHEN 1 THEN 'FX_PAIRS_TICK'
		WHEN 2 THEN ''
	END
	AND VARS.VAR_TYPE =
	CASE
		DAT.ENV_FLG
		WHEN 1 THEN 'PKG'
		WHEN 2 THEN 'ENV'
	END
	AND VARS.VAR_NME = DAT.VAR_NME

*/


/*
MOVING DATA FROM 1 DATABASE TO ANOTHER
-- HELPFUL WHEN CONFLICT DB HAS DATA THAT HASNT BEEN APPLIED TO ACTUAL DB
*/

/*
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