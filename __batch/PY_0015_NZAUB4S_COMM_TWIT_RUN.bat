rem ===========================================================================================================================================================
rem SUBJECT      : generic batch call to python - webscrape batch call
rem OBJECT TYPE	 : batch
rem OBJECT NAME  : PYTHON_JS_WEBSCRAPE.bat
rem CREATED BY	 : Harold Delaney
rem CREATED ON	 : 20170212
rem SOURCE       : 
rem PREPERATION  : command line call - calls python exe and passes in python scripts for execution
rem 			   
rem REMARKS      : 1) data refreshed daily to get the summary "balances" at point in time
rem                2) designed to get a feel for the delta movements in job postings
rem                3) If you'd prefer to never have the command window show, you can use the pythonw executable by exchanging python.exe with pythonw.exe
rem  
rem ===========================================================================================================================================================

@echo off

set pythonPath=%USERPROFILE%\Anaconda3\envs\lanoitan\python.exe
set scritpPath1=D:\Sync\__lanoitan\__scripts\__python\jobs\
set scritpPath2=D:\Sync\__lanoitan\__scripts\__python\b4s\
set scritpPath3=D:\Sync\__lanoitan\__scripts\__python\markets\
set scritpPath4=D:\Sync\__lanoitan\__scripts\__python\twitter\

rem ===========================================================================================================================================================
rem JOBS - NZ
rem ===========================================================================================================================================================

%pythonPath% %scritpPath1%PY_BATCH_JOBS_NZ.py %*

TIMEOUT 30


rem ===========================================================================================================================================================
rem JOBS - AU
rem ===========================================================================================================================================================

%pythonPath% %scritpPath1%PY_BATCH_JOBS_AU.py %*

TIMEOUT 30


rem ===========================================================================================================================================================
rem BUSINESSES FOR SALE - AU
rem ===========================================================================================================================================================

%pythonPath% %scritpPath2%PY_BATCH_B4S_AU.py %*

TIMEOUT 30

rem ===========================================================================================================================================================
rem MARKETS DATA
rem ===========================================================================================================================================================

%pythonPath% %scritpPath3%PY_BATCH_MARKETS.py %*

TIMEOUT 30

rem ===========================================================================================================================================================
rem TWITTER - KEY TERMS JOBS EXTRACT FROM TWITTER API
rem ===========================================================================================================================================================

%pythonPath% %scritpPath4%PY_BATCH_TWITTER.py %*


rem pause
exit
