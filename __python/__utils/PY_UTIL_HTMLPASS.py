# =======================================================================================================================================================================================================
# SUBJECT        : htmlpass - navigates to url and passes in html to parser
# OBJECT TYPE    : python
# OBJECT NAME    : py_htmlpass
# CREATED BY     : Harold Delaney
# CREATED ON     : 20170403
# SOURCE         : 
# PREPERATION    : 
# FREQUENCY      : ADHOC
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
import time # date time operations
import random
import requests
import urllib
from urllib.request import Request, urlopen  # Python 3
from selenium import webdriver # parse the full scripted results of websites (for sites that are javascript heavy)
from selenium.webdriver.chrome.options import Options

from PY_UTIL_EMAIL import pyMail
from PY_UTIL_DB import pyDB
# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- END
# =============================================================================

class pyHTMLPass():
    def __init__(self,url,**g):
        self.url = url
            
    def __del__(self):
        """ close webdriver
        """
        self.driver.close()
        self.driver.quit()
        self.driver.stop_client()
    # =============================================================================
    # htmlPASS to be analysed for data
    # - returns full page HTML code 
    # =============================================================================
    def htmlPass(url,**g):
        try:
            # ================================================================
            # EXTRACT HTML USING PARSER OR WEB DRIVER CONFIG
            # ================================================================
            if g['USES_WEB_DRVR'] == 'N':
                #requests.get('https://api.github.com/user', auth=('user', 'pass'))
                #headers = {'User-agent': 'Google Chrome'}
                #html = requests.get(url, headers=headers)
                html = Request(url)
                html.add_header = [('User-agent', 'Google Chrome')]
                html = urlopen(html).read()    
            elif g['USES_WEB_DRVR'] == 'Y':
                driver = webdriver.Chrome(executable_path = str(g['DRVR_PATH'] + '\\' + g['WEB_DRVR_NME'])) #chromeDrvr
                driver.get(url)
                
                # SLEEP REQUIRED DUE TO SEEK TRYING TO REDIRECT PAGE AND MESSING WITH THE CAPTURE OF LINK
                # FORCES A WAIT FOR PAGE TO PROPERLY RENDER BEFORE CAPTURING HTML
                if 'SEEK' in url.upper(): 
                    time.sleep(10) # INSERTS PAUSE TO ASSIST REFLECTING HUMAN INTERACTION ON WEBPAGE
                
                html = driver.page_source
                
                driver.close()
                driver.quit()
                driver.stop_client()
            
            return html
        except:
            # capture a finish time to be entered into the db
            finished_at = time.strftime("%Y-%m-%d %H:%M:%S")
            e = sys.exc_info()
            print('ERROR ENCOUNTERED : ' + str(e))
            # =============================================================================
            # WRITE RESULTS OF ERROR TO LOCAL DB 
            # =============================================================================   
            dbmgr = pyDB(g['DB'])
            dbmgr.write_log(finished_at,'HTML PASSING ERROR: ' + str(e),**g)
            # =============================================================================
            # EMAIL SUMMARY OF ERROR TO TO DISTRIBUTION LIST
            # =============================================================================
            htmlRes = '''<table cellpadding="8" cellspacing="3" border="3">
                        <tr>
                        <th>msmt_date_id</th>
                        <th>pkg_nme</th>
                        <th>start_datetime</th>
                        <th>end_datetime</th>
                        <th>status</th>
                        </tr>'''
            htmlRes = htmlRes + '<tr><td>' + str(g['MSMT_DTE_ID']) + '</td><td>' + str(g['PKG_NME']) + '</td><td>' + str(g['STARTED_AT']) + '</td><td>' + str(finished_at) + '</td><td>' + 'ERROR' + '</td></tr>'
            htmlRes = htmlRes + '</table>'
            # SUBJECT & RECIPIENTS
            mymail = pyMail(str(g['PKG_NME']) + ' - ERROR ENCOUNTERED @ ' + time.strftime("%Y-%m-%d %H:%M:%S"), **g)
            # START HTML BODY (GREETING / OPENING LINE OF EMAIL). 
            mymail.htmladd('A HTML PASSING ERROR was encountered for package : ' + str(g['PKG_NME']))
            # FURTHER DETAILS ADDED TO BODY (SEPERATED BY A PARAGRAPH SO LINE FEEDS NOT REQUIRED)
            # ADD LINE OF TEXT
            mymail.htmladd('Summary of ERROR')
            # ADD HTML TABLE CONSTRUCTED ABOVE
            mymail.htmladd(htmlRes)
            # HEADER FOR ERROR TEXT
            mymail.htmladd('<b><u>ERROR DETAIL</u></b>')
            # ADD FULL ERROR TO BODY OF EMAIL
            mymail.htmladd(str(e).replace('<','(').replace('>',')'))
            # SEND
            mymail.send()
            # QUIT EXECUTION OF PYTHON SCRIPT
            quit()
            #sys.exit()
        
    # =============================================================================
    # htmlDownloadLink 
    # - returns full page HTML code 
    # =============================================================================
    def htmlDownloadLink(url,fileSearchStr,linkId,**g):
        # RANDOM TIMER TO MAKE ANY LOOPING CALLS TO A URL APPEAR MORE "HUMAN"
        try:
            rndm_sleep = int(g['SLEEP_VAL'])
        except:
            rLow = int(g['LOOP_RNDM_SLEEP_LOW'])
            rHigh = int(g['LOOP_RNDM_SLEEP_HIGH'])
            rndm_sleep = random.randint(rLow,rHigh)
            
        try:
            # ================================================================
            # DOWNLOAD FILE FROM PAGE LINK            
            # ================================================================
            # add missing support for chrome "send_command"  to selenium webdriver
            # TRY 1 - NOT WORKING
#                 driver.command_executor._commands["send_command"] = ("POST", '/session/$sessionId/chromium/send_command')
#                 params = {'cmd': 'Page.setDownloadBehavior', 'params': {'behavior': 'allow', 'downloadPath': g['CONFIG']['DB_DIR'] + '__fx'}}
#                 command_result = driver.execute("send_command", params)            
            
            # TRY 2 - NOT WORKING - STILL SAVES TO DEFAULT DIRECTORY
            chromeOptions = webdriver.ChromeOptions()
            chromeOptions.add_argument("--start-maximized")
            prefs = {"profile.default_content_settings.popups": 0,
                     "download.default_directory": r"g['CONFIG']['DB_DIR']" + "__fx\\", # IMPORTANT - ENDING SLASH V IMPORTANT
                     "directory_upgrade": True}
            chromeOptions.add_experimental_option("prefs", prefs)

            driver = webdriver.Chrome(executable_path = str(g['DRVR_PATH'] + '\\' + g['WEB_DRVR_NME']), chrome_options=chromeOptions) #chromeDrvr
            driver.get(url) 
            if linkId == '':           
                None
            else:
                dlLink = driver.find_element_by_id(linkId).click() #instantiate a click on the desired page element
            
            time.sleep(int(rndm_sleep)) 
            #NOT WORKING - GET STUCK IN ENDLESS LOOP
#             for file in os.listdir(g['DEFAULT_SYS_DOWNLOAD_PATH']):
#                 if file.endswith(fileSearchStr + '.crdownload') or file.endswith(fileSearchStr + '.part'):
#                     while True: # ascii/tick-data-quotes/eurusd/2017/10
#                         if file.endswith(fileSearchStr + '.crdownload') or file.endswith(fileSearchStr + '.part'):
#                             time.sleep(10)
#                         elif file.endswith(fileSearchStr):
#                             break
#                         else:
#                             time.sleep(10)
#                 else:
#                     None
            driver.close()
            driver.quit()
            driver.stop_client()
            
                #return dlLink
        except:
            # capture a finish time to be entered into the db
            finished_at = time.strftime("%Y-%m-%d %H:%M:%S")
            e = sys.exc_info()
            print('ERROR ENCOUNTERED : ' + str(e))
            # =============================================================================
            # WRITE RESULTS OF ERROR TO LOCAL DB 
            # =============================================================================   
            dbmgr = pyDB(g['DB'])
            dbmgr.write_log(finished_at,'HTML PASSING ERROR: ' + str(e),**g)
            # =============================================================================
            # EMAIL SUMMARY OF ERROR TO TO DISTRIBUTION LIST
            # =============================================================================
            htmlRes = '''<table cellpadding="8" cellspacing="3" border="3">
                        <tr>
                        <th>msmt_date_id</th>
                        <th>pkg_nme</th>
                        <th>start_datetime</th>
                        <th>end_datetime</th>
                        <th>status</th>
                        </tr>'''
            htmlRes = htmlRes + '<tr><td>' + str(g['MSMT_DTE_ID']) + '</td><td>' + str(g['PKG_NME']) + '</td><td>' + str(g['STARTED_AT']) + '</td><td>' + str(finished_at) + '</td><td>' + 'ERROR' + '</td></tr>'
            htmlRes = htmlRes + '</table>'
            # SUBJECT & RECIPIENTS
            mymail = pyMail(str(g['PKG_NME']) + ' - ERROR ENCOUNTERED @ ' + time.strftime("%Y-%m-%d %H:%M:%S"), **g)
            # START HTML BODY (GREETING / OPENING LINE OF EMAIL). 
            mymail.htmladd('A DOWNLOAD LINK ERROR was encountered for package : ' + str(g['PKG_NME']))
            # FURTHER DETAILS ADDED TO BODY (SEPERATED BY A PARAGRAPH SO LINE FEEDS NOT REQUIRED)
            # ADD LINE OF TEXT
            mymail.htmladd('Summary of ERROR')
            # ADD HTML TABLE CONSTRUCTED ABOVE
            mymail.htmladd(htmlRes)
            # HEADER FOR ERROR TEXT
            mymail.htmladd('<b><u>ERROR DETAIL</u></b>')
            # ADD FULL ERROR TO BODY OF EMAIL
            mymail.htmladd(str(e).replace('<','(').replace('>',')'))
            # SEND
            mymail.send()
            # QUIT EXECUTION OF PYTHON SCRIPT
            quit()
            #sys.exit()
