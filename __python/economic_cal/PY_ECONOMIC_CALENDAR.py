# =======================================================================================================================================================================================================
# SUBJECT        : economic calendar - list of when key announcements are to occur
# OBJECT TYPE    : python - BeautifulSoup
# OBJECT NAME    : py_economic_calendar
# CREATED BY     : Harold Delaney
# CREATED ON     : 20180903
# SOURCE         : [ https://www.forexfactory.com ]
# PREPERATION    : 
# FREQUENCY      : MONTHLY
#               
# REMARKS        : 1) DEFAULT TIME ZONE AND CONFIG FOR SITE (AND SCRAPE):
#                     * TIME ZONE   : (GMT -5:00) Eastern Time (US & Canada), Bogota, Lima
#                     * DST         : DST On
#                     * TIME FORMAT : am / pm 
#                  2) 
#                  3)
# =======================================================================================================================================================================================================

# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- START
# =============================================================================
import os 
import sys
import time # date time operations
import datetime # date subtractions
from datetime import datetime as fdttm
import re # regex
import random 
from bs4 import BeautifulSoup
from dateutil import relativedelta
from _datetime import date
# RETURN CURRENT SCRIPT PATH ("__file__" IS FILES FULL PATH)
path, fileName = os.path.split(os.path.realpath(__file__))
fullPath = os.path.join(path, fileName)
# UTIL FILE PATH
utilPath = os.path.join(path, '../__utils/')
utilPath = os.path.abspath(os.path.realpath(utilPath))  
# ADD ABOVE NOMINATED DIRECTORIES TO IMPORT SEARCH PATH
sys.path.insert(0, utilPath)
sys.path.insert(0, os.path.dirname(os.path.abspath(os.path.realpath(__file__))) ) 
# CALL USER DEFINED MODULES/FUNCTIONS
from PY_UTIL_EMAIL import pyMail
from PY_UTIL_DB import pyDB
from PY_UTIL_CONFIG import pyConfig
from PY_UTIL_HTMLPASS import pyHTMLPass
from PY_UTIL_LIB import pyLIB
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
    scrape()
    write_log() # SUCCESS
    
def init():
    g['CONFIG'] = pyConfig(g['CONFIG_FILE']).recs()
    g['PKG_PATH'] = path
    g['ENV'] = g['CONFIG']['ENV']
    # CHANGE - 20171128 ==================================================================================
    g['DB'] = g['CONFIG']['DB_DIR'] + g['CONFIG']['DB']    #dbPath + '\\' + g['CONFIG']['DB']
    g['DRVR_PATH'] = g['CONFIG']['DRVR_DIR']    #drvrPath
    # CHANGE =============================================================================================
    g['MSMT_DTE_ID'] = time.strftime('%Y%m%d') 
    g['DAY_NBR'] = time.strftime('%d')
    g['MONTH_NBR'] = time.strftime('%m')
    g['YEAR_NBR'] = time.strftime('%Y')
    g['STARTED_AT'] = time.strftime("%Y-%m-%d %H:%M:%S")
    g['MONTH_NBR_CNVRT'] = {'JANUARY': '01'
                           ,'FEBRUARY': '02'
                           ,'MARCH': '03'
                           ,'APRIL': '04'
                           ,'MAY': '05'
                           ,'JUNE': '06'
                           ,'JULY': '07'
                           ,'AUGUST': '08'
                           ,'SEPTEMBER': '09'
                           ,'OCTOBER': '10'
                           ,'NOVEMBER': '11'
                           ,'DECEMBER': '12'
                           ,'JAN': '01'
                           ,'FEB': '02'
                           ,'MAR': '03'
                           ,'APR': '04'
                           ,'MAY': '05'
                           ,'JUN': '06'
                           ,'JUL': '07'
                           ,'AUG': '08'
                           ,'SEP': '09'
                           ,'OCT': '10'
                           ,'NOV': '11'
                           ,'DEC': '12'
                           }
#     g['MONTH_LIST'] = ['jan.2016','feb.2016','mar.2016','apr.2016','may.2016','jun.2016','jul.2016','aug.2016','sep.2016','oct.2016','nov.2016','dec.2016'
#                        ,'jan.2017','feb.2017','mar.2017','apr.2017','may.2017','jun.2017','jul.2017','aug.2017','sep.2017','oct.2017','nov.2017','dec.2017'
#                        ,'jan.2018','feb.2018','mar.2018','apr.2018','may.2018','jun.2018','jul.2018',
#                        'aug.2018','sep.2018','oct.2018','nov.2018','dec.2018']
      
def get_vars():
    dbmgr = pyDB(g['DB']) 
    rslt = dbmgr.get_vars(**g)
    # ADD RESULTS FROM GET_VARS CALL TO DICTIONARY (g)
    for r in rslt:
        g[str(r[0])] = str(r[1])
        #print(r)
    #print([g])
    
def scrape():
    # RANDOM TIMER TO MAKE ANY LOOPING CALLS TO A URL APPEAR MORE "HUMAN"
    rLow = int(g['LOOP_RNDM_SLEEP_LOW'])
    rHigh = int(g['LOOP_RNDM_SLEEP_HIGH'])
    rndm_sleep = random.randint(rLow,rHigh)
    # CALCULATE RETENTION DATE FROM RETENTION DAYS VARIABLE IN VARS TABLE
    retention_date = datetime.date.today() + datetime.timedelta(-int(g['DATA_RETENTION_DAYS']))
    retention_date_id = retention_date.strftime('%Y%m%d')
    # =============================================================================
    # DELETE FROM LOCAL DB WHERE A RERUN WOULD REPRODUCE "DUPLICATE" DATA
    # =============================================================================
    dbmgr = pyDB(g['DB'])
    q = r"""DELETE FROM {0} WHERE (captr_dte_id = {1} or captr_dte_id <= {2})""".format(
        g['TBL_NME'], #[0]
        g['MSMT_DTE_ID'], #[1]
        retention_date_id,  #[2]
        )
    dbmgr.query(q)    
    
    # =============================================================================
    # LOOP THROUGH DATES FOR HISTORICAL SCRAPES (ONLY REQUIRED FOR FIRST RUN)
    # 
    # =============================================================================
    # dts = g['MONTH_LIST'] # ONLY NEEDED TO RUN HISTORY    
    first_dy_curr_mth = fdttm.today().replace(day=1)
    
    dts = []
    dts.append( (first_dy_curr_mth - datetime.timedelta(days=1)).strftime('%b.%Y').lower() ) # PREVIOUS MONTH
    dts.append(time.strftime('%b.%Y').lower()) # CURRENT MONTH
    dts.append( (datetime.date.today() + relativedelta.relativedelta(months=1)).strftime('%b.%Y').lower() ) # NEXT MONTH X1
    dts.append( (datetime.date.today() + relativedelta.relativedelta(months=2)).strftime('%b.%Y').lower() ) # NEXT MONTH X2
    #dts.append( (datetime.date.today() + relativedelta.relativedelta(months=3)).strftime('%b.%Y').lower() ) # NEXT MONTH X3  -- CALENDAR DOESNT GO THIS FAR FORWARD
    
    
    #dts_array = []
    # CONVERTS LIST OBJECT TO ARRAY FOR LOOPING
    for item in dts:            
        # =============================================================================
        # PASS URL TO RETURN HTML FROM SITE PAGE
        # CAPTURE ANY ERRORS EXPERIENCED AND PASS TO LOCAL DB
        # =============================================================================
        url = g['URL'] + item
        passedHTML = pyHTMLPass.htmlPass(url,**g)
        soup = BeautifulSoup(passedHTML, "html.parser")
        #print(soup)#.encode("utf-8"))
        
        # ========================================================================================================================================================== 
        # SCRAPE PART - START
        # - this should be the primary section of code that changes  
        # - only other sections that "may" change are DELETE and UPDATE DB statements
        # ==========================================================================================================================================================
        
        # GET MONTH AND YEAR FROM HEADER
        for div in soup.find_all('div', class_ = 'head'):
            for span in div.find_all('span'):
                if '<strong>' in str(span).lower():
                    dt_part = span.text.upper().split(' ')                    
                    annce_mth = dt_part[-2]
                    annce_yr = dt_part[-1]
        
        for tab in soup.find_all('table', class_='calendar__table'):            
            for row in tab.find_all('tr'):
                if 'calendar__row' in str(row).lower() and 'day-breaker' not in str(row).lower() and 'calendarexpanded__container' not in str(row).lower():
                    
                    cell_nbr =  1 # INITIALISE CELL NBR TO 1 - DATA WILL BE ASSIGNED BASED ON CELL NBR (POSITION) WHICH SHOULDNT CHANGE
                    
                    for cell in row.find_all('td'):
                        #print(cell)
                        if cell_nbr == 1: # DATE OF MONTH (IF NOT NULL)
                            try:
                                dt = re.search('<span>(.*)</span>', str(cell).lower())
                                dt = dt.group(1).replace('</span>','').upper()
                                
                                dt_part = dt.split(' ')
                                
                                mth_nme = dt_part[0]
                                dy_nbr = dt_part[1]
                                if len(dy_nbr) == 1:
                                    dy_nbr = '0' + str(dy_nbr)
                                else:
                                    dy_nbr = str(dy_nbr)
                                                                    
                                mth_nbr = g['MONTH_NBR_CNVRT'].get(mth_nme)                                
                                annce_dt = str(annce_yr) + '-' + str(mth_nbr) + '-' + str(dy_nbr)
                                msmt_dte_id = str(annce_yr) + str(mth_nbr) + str(dy_nbr)
                            except:
                                annce_dt = annce_dt
                                
                        elif cell_nbr == 2: # TIME OF DAY (MIGHT BE "ALL DAY" EVENT)
                            if cell.text.strip().upper() != '':
                                annce_tm = cell.text.strip().upper()
                            else:
                                try:
                                    annce_tm = annce_tm
                                except:
                                    annce_tm = ''
                                    
                        elif cell_nbr == 3: # CNTRY CDE
                            try:
                                cntry_cde = cell.text.strip().upper()
                            except:
                                cntry_cde = ''
                                
                        elif cell_nbr == 4: # IMPACT (LOW / MEDIUM / HIGH)
                            result = cell.find('span') 
                            if result is not None:
                                impact = result.get('title')
                                impact = impact.upper().replace('IMPACT EXPECTED', '').strip()                                
                            else:
                                impact = ''                                
                                    
                        elif cell_nbr == 5: # EVENT DESCRIPTION
                            try:
                                for span in cell.find_all('span'):
                                    event_desc = span.text.strip().upper()
                            except:
                                event_desc = ''
                                
                        elif cell_nbr == 6: # -- IGNORE --  LINK TO DETAILS
                            pass
                        
                        elif cell_nbr == 7: # ACTUAL VALUE
                            try:
                                actual_val = cell.text.strip()
                            except:
                                actual_val = ''

                        elif cell_nbr == 8: # FORECAST VALUE
                            try:
                                forecast_val = cell.text.strip()
                            except:
                                forecast_val = ''
                            
                        elif cell_nbr == 9: # PREVIOUS VALUE
                            try:
                                previous_val = cell.text.strip()
                            except:
                                previous_val = ''
                            
                        elif cell_nbr == 10: # -- IGNORE --  LINK TO GRAPH 
                            pass
                        
                        else:
                            continue
                        
                        cell_nbr = cell_nbr + 1
                        
                    # GENERATE A CODE FROM THE DESC AND CRNCY
                    annce_cde = pyLIB.codeGen(cntry_cde + ' ' + event_desc) # GET CODE
                        
                    # =============================================================================
                    # WRITE RESULTS OF SOUP ANALYISIS/SCRAPE TO LOCAL DB
                    # =============================================================================   
                    dbmgr = pyDB(g['DB'])
                    q = r"""INSERT INTO {0} (MSMT_DTE_ID, DATA_TYPE, SITE_CDE, ANNCE_DTE, ANNCE_TM, CNTRY_CDE, ANNCE_CDE, ANNCE_DESC, IMPACT, ACTUAL, FORECAST, PREVIOUS, CAPTR_DTE_ID, STARTED_AT, FINISHED_AT) VALUES ({1}, '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', "{8}", '{9}', '{10}', '{11}', '{12}', {13}, '{14}', '{15}')""".format(
                        g['TBL_NME'], #[0]
                        msmt_dte_id, #[1]
                        g['DATA_TYPE'], #[2]
                        g['SITE_CDE'], #[3]
                        annce_dt, #[4]
                        annce_tm, #[5]
                        cntry_cde, #[6]
                        annce_cde, #[7]
                        event_desc, #[8]
                        impact, #[9]
                        actual_val, #[10]
                        forecast_val, #[11]
                        previous_val, #[12]
                        g['MSMT_DTE_ID'], #[13]
                        g['STARTED_AT'], #[14]
                        '' #[15]
                        )
                    #print(q)
                    dbmgr.query(q)                        
                         
    # ==========================================================================================================================================================
    # SCRAPE PART - END
    # - this should be the primary section of code that changes  
    # - only other sections that "may" change are DELETE and UPDATE db statements
    # ==========================================================================================================================================================            
    
    # =============================================================================
    # UPDATE LOCAL DB WITH A FINISH TIME
    # =============================================================================
    finished_at = time.strftime("%Y-%m-%d %H:%M:%S") # capture a finish time to be entered into the db
    dbmgr = pyDB(g['DB'])
    q = r"""UPDATE {0} SET finished_at = '{1}' WHERE captr_dte_id = {2}""".format(
        g['TBL_NME'], #[0]
        finished_at, #[1]
        g['MSMT_DTE_ID'] #[2]
        )
    dbmgr.query(q)

def write_log():
    finished_at = time.strftime("%Y-%m-%d %H:%M:%S") # capture a finish time to be entered into the db
    # =============================================================================
    # WRITE RESULTS OF SUCCESS TO LOCAL DB 
    # =============================================================================   
    dbmgr = pyDB(g['DB'])
    dbmgr.write_log(finished_at,None,**g) 
    
if __name__ == "__main__": main()
