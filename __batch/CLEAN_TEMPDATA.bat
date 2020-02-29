rem ===========================================================================================================================================================
rem SUBJECT      : TEMP data tidy up
rem OBJECT TYPE	 : batch
rem OBJECT NAME  : CLEAN_TEMPDATA.bat
rem CREATED BY	 : Harold Delaney
rem CREATED ON   : 20170511
rem SOURCE       : 
rem PREPERATION  : 
rem 			   
rem REMARKS      : 1) selenium webdriver creates a "scoped_dir*" in temp folder and never removes it - leading to a filling drive
rem                2) websearch reveals its a likely bug with the chrome webdriver
rem                3) batch file deletes all files and directories in the TEMP folder
rem  
rem ===========================================================================================================================================================

@echo off

rem set dirPath=%TEMP%

Echo %TEMP%

chdir /D %TEMP%

for /d %%D in (*) do rd /s /q "%%D"
del /f /q *
