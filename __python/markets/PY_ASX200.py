# =======================================================================================================================================================================================================
# SUBJECT        : asx200 list and 
# OBJECT TYPE    : python
# OBJECT NAME    : py_asx200
# CREATED BY     : Harold Delaney
# CREATED ON     : 20200102
# SOURCE         : yahoofinance api
# PREPERATION    : 
# FREQUENCY      : 
#               
# REMARKS        : 1) stock ticker codes found @ 
#                  2) 
#                  3) 

# =======================================================================================================================================================================================================
# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- START
# =============================================================================
import bs4 as bs # beuatifulsoup / websraping
import datetime as dt # date subtractions
import os 
import pandas as pd
import pandas_datareader.data as web
import pickle
import requests 

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
    # CHANGE =============================================================================================
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
    print([g])
    
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
    # ==========================================================================================================================================================
    # SCRAPE PART - START
    # - this should be the primary section of code that changes  
    # - only other sections that "may" change are DELETE and UPDATE DB statements
    # ==========================================================================================================================================================
    # PASS 1 - COMMODITY DATA =====================================================================
    quandl.ApiConfig.api_key = g['QUANDL_API_KEY']
    
    code_list = g['CMDTY_CDES'].split(',')
    
    for item in code_list:
        try:
            dat = quandl.get(item, authtoken = g['QUANDL_API_KEY'], rows=10) #trim_start = "2016-01-01", trim_end = "2018-09-16") 
            #print(dat)
            for index, row in dat.iterrows():
                #print( index, row[0], row[1], row[2], row[3], row[4])
                # =============================================================================
                # WRITE RESULTS OF SOUP ANALYISIS/SCRAPE TO LOCAL DB
                # =============================================================================   
                dbmgr = pyDB(g['DB'])
                q = r"""INSERT INTO {0} (MSMT_DTE_ID, CMDTY_CDE, TRADE_DT, INDEX_VAL, HIGH_VAL, LOW_VAL, TTL_MRKT_VAL, DIV_MRKT_VAL, CAPTR_DTE_ID, STARTED_AT, FINISHED_AT) VALUES ({1}, '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', {8}, {9}, '{10}', '{11}')""".format(
                    g['TBL_NME'], #[0]
                    index.strftime('%Y%m%d'), #[1]  time.strftime('%Y%m%d')
                    item, #[2]
                    index.strftime('%Y-%m-%d'), #[3]
                    row[0], #[4]
                    row[1], #[5]
                    row[2], #[6]
                    row[3], #[7]
                    row[4], #[8]
                    g['MSMT_DTE_ID'], #[9]
                    g['STARTED_AT'], #[10]
                    '' #[11]
                    )
                dbmgr.query(q)
        except:
            # capture a finish time to be entered into the db
            finished_at = time.strftime("%Y-%m-%d %H:%M:%S")
            # =============================================================================
            # WRITE RESULTS OF ERROR TO LOCAL DB 
            # =============================================================================   
            e = sys.exc_info()
            dbmgr = pyDB(g['DB'])
            dbmgr.write_log(finished_at,'QUANDL API ERROR: ' + str(e),**g)
            
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