# =======================================================================================================================================================================================================
# SUBJECT        : orchestration file for running py scripts for package
# OBJECT TYPE    : python
# OBJECT NAME    : py_batch
# CREATED BY     : Harold Delaney
# CREATED ON     : 20170410
# SOURCE         : 
# PREPERATION    : 
# FREQUENCY      : DAILY
#               
# REMARKS        : 1) 
#                  2) 
#                  3)
# =======================================================================================================================================================================================================
# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- START
# =============================================================================
import os
import sys
import subprocess
import time # DATE TIME OPERATIONS
import re # REGEX
# PYTHON EXE PATH
pyPath = sys.executable.replace('pythonw','python')
# GET THE DIRECTORY OF THE CURRENT RUNNING SCRIPT. "__file__" IS ITS FULL PATH
path, fileName = os.path.split(os.path.realpath(__file__))
fullPath = os.path.join(path, fileName)
# LIBRARY FILE PATH
utilPath = os.path.join(path, '../__utils/')
utilPath = os.path.abspath(os.path.realpath(utilPath))  
# ADDS ABOVE NOMINATED DIRECTORIES TO IMPORT SEARCH PATH
sys.path.insert(0, utilPath)
sys.path.insert(0, os.path.dirname(os.path.abspath(os.path.realpath(__file__))) ) 
# CALL LIBRARY FUNCTIONS IDENTIFIED IN ABOVE PATHS
from PY_UTIL_EMAIL import pyMail
from PY_UTIL_DB import pyDB
from PY_UTIL_CONFIG import pyConfig
# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- END
# =============================================================================
__version__ = "1.0.0"
__author__ = "Harold Delaney"

g = dict(
    CONFIG_FILE = utilPath + '\PY_DB.conf',
    VARS_TABLE_NAME = 'PY_VARS_CTL',
    PKG_NME = fileName.replace('.py','').upper()
)

def main():
    init()
    get_vars()
    email_status('START')
    script_run()
    email_status('END')
    write_log() # SUCCESS
    
def init():
    pathLength = len(fullPath.split('\\'))- 2
    g['PKG_NME_PRNT'] = str(fullPath.split('\\')[pathLength]).upper()
    g['CONFIG'] = pyConfig(g['CONFIG_FILE']).recs()
    g['DB_SHRT'] = g['CONFIG']['DB'].replace('.db','')
    g['ENV'] = g['CONFIG']['ENV']
    # CHANGE - 20171128 ==================================================================================
    g['DB'] = g['CONFIG']['DB_DIR'] + g['CONFIG']['DB']    #dbPath + '\\' + g['CONFIG']['DB']
    g['DRVR_PATH'] = g['CONFIG']['DRVR_DIR']    #drvrPath
    # CHANGE =============================================================================================
    g['MSMT_DTE_ID'] = time.strftime('%Y%m%d') 
    g['STARTED_AT'] = time.strftime("%Y-%m-%d %H:%M:%S") 

def get_vars():
    dbmgr = pyDB(g['DB']) 
    rslt = dbmgr.get_vars(**g)
        # ADD RESULTS FROM GET_VARS CALL TO DICTIONARY (g)
    for r in rslt:
        g[str(r[0])] = str(r[1])
        #print(r)
    #print([g])   
   
def script_run():
    # =============================================================================
    # CONVERT STR TO LIST TO ARRAY FOR TABLE LIST RUNNING 
    # =============================================================================
    pkgs_to_run = g['PKGS_TO_RUN']
    pkgs_to_run_array = []
    # CONVERTS LIST OBJECT TO ARRAY FOR LOOPING
    for item in pkgs_to_run.split(','): # COMMA, OR OTHER
        pkgs_to_run_array.append(item)    
    try:
        # LOOP THROUGH ALL THE PACKAGES/SCRIPTS FOR THIS FOLDER
        for pkg in pkgs_to_run_array:
            subprocess.call([pyPath, str(path + r"\\" + pkg + '.py')])
    except:
        # capture a finish time to be entered into the db
        finished_at = time.strftime("%Y-%m-%d %H:%M:%S")
        # =============================================================================
        # WRITE RESULTS OF ERROR TO LOCAL DB 
        # =============================================================================   
        e = sys.exc_info()
        dbmgr = pyDB(db)
        dbmgr.write_log(finished_at,'EMAIL ERROR: ' + str(e),**g)
                    
def email_status(step):
    if step == 'START':
        # SUBJECT & RECIPIENTS
        mymail = pyMail(g['PKG_NME_PRNT'] + ' - STARTED @ ' + time.strftime("%Y-%m-%d %H:%M:%S"), **g)
        # START HTML BODY (GREETING / OPENING LINE OF EMAIL)
        mymail.htmladd('End Of Message')
        # SEND
        mymail.send(**g)
    elif step == 'END':
        # =============================================================================
        # LOOPS THROUGH TABLE LIST AND GENERATES SUMMARY DATA FOR EMAIL
        # =============================================================================   
        dbmgr = pyDB(g['DB'])
        q = r"""SELECT CASE CAPTR_DTE_ID WHEN strftime('%Y%m%d', date('now')) THEN 'SUCCESS' ELSE 'ISSUE' END AS SUCCESS_FLAG, CAPTR_DTE_ID, MSMT_DTE_ID, COUNT( DISTINCT CNTRY_CDE ) AS CNT_CNTRY_CDE, COUNT(*) AS ROW_CNT FROM {0} 
                 WHERE 1 = 1
                   AND CAPTR_DTE_ID =(SELECT MAX( CAPTR_DTE_ID ) FROM PY_ECONOMIC_CALENDAR)
                 GROUP BY CAPTR_DTE_ID, MSMT_DTE_ID ORDER BY MSMT_DTE_ID""".format(
            'PY_ECONOMIC_CALENDAR'
            ) 
        rslt = dbmgr.query(q)
        # =============================================================================
        # EMAIL SUMMARY OF RESULTS TO DISTRIBUTION LIST
        # =============================================================================
        htmlRes = '''<table cellpadding="8" cellspacing="3" border="1">
                    <tr>
                    <th>success_flag</th>
                    <th>capt_date_id</th>
                    <th>msmt_date_id</th>
                    <th>cntry_cde_cnt</th>
                    <th>row_cnt</th>
                    </tr>'''
        for r in rslt:
            htmlRes = htmlRes + '<tr><td>' + str(r[0]) + '</td><td>' + str(r[1])  + '</td><td>' + str(r[2])  + '</td><td>' + str(r[3])  + '</td><td>' + str(r[4])  + '</td></tr>'
        htmlRes = htmlRes + '</table>'
        # SUBJECT & RECIPIENTS
        mymail = pyMail(g['PKG_NME_PRNT'] + ' : ENDED @ ' + time.strftime("%Y-%m-%d %H:%M:%S"), **g)
        # START HTML BODY (GREETING / OPENING LINE OF EMAIL)
        mymail.htmladd('Scrape has completed for : ' + g['PKG_NME_PRNT'] + ' : AU')
        # FURTHER DETAILS ADDED TO BODY (SEPERATED BY A PARAGRAPH SO LINE FEEDS NOT REQUIRED)
        # ADD LINE OF TEXT
        mymail.htmladd('Summary of Scrape for ' + g['PKG_NME_PRNT'] + ' : AU')
        # ADD HTML TABLE CONSTRUCTED ABOVE
        mymail.htmladd(htmlRes)
        # SEND
        mymail.send(**g)

def write_log():
    finished_at = time.strftime("%Y-%m-%d %H:%M:%S") # capture a finish time to be entered into the db
    # =============================================================================
    # WRITE RESULTS OF SUCCESS TO LOCAL DB 
    # =============================================================================   
    dbmgr = pyDB(g['DB'])
    dbmgr.write_log(finished_at,None,**g)

    
if __name__ == "__main__": main()