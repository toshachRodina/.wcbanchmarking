# =======================================================================================================================================================================================================
# SUBJECT        : db - database operations utility
# OBJECT TYPE    : python
# OBJECT NAME    : py_util_db
# CREATED BY     : Harold Delaney
# CREATED ON     : 20170330
# SOURCE         : Python3 Essential Training by Bill Weinman [http://bw.org/]
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
import sqlite3 # SQLITE3 DB MANAGER 
import re # REGEX
# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- END
# =============================================================================
__version__ = '1.0.0'
__author__ = "Harold Delaney"

class pyDB(object):
    def __init__(self, db):
        self.conn = sqlite3.connect(db)
        self.conn.execute('pragma foreign_keys = on')
        self.conn.commit()
        self.cur = self.conn.cursor()
    # =============================================================================
    # GENERIC QUERY
    # - takes in the full query from the calling function and returns cursor
    # =============================================================================
    def query(self, arg):
        '''
            pyDB.query( sql )
            generator method for queries
                sql is string containing SQL
            returns a results cursor
        '''
        self.cur.execute(arg)
        self.conn.commit()
                
        print("OPERATION COMPLETE: {}".format(arg))
        return self.cur
    # =============================================================================
    # GET_VARS
    # - takes in the full query from the calling function and returns cursor
    # =============================================================================
    def get_vars(self, **g):
        '''
            pyDB.get_vars( **g )
            generator method returning results from the PY_VARS_CTL table
                **g is passed from calling script and is a dictionary specific to calling package
            returns a results cursor
        '''
        q = '''WITH DAT AS(
                    SELECT
                        UN.VAR_NME,
                        MIN( UN.ENV_FLG ) AS ENV_FLG
                    FROM
                        (
                            SELECT
                                VARS.VAR_NME,
                                VARS.VAR_VAL,
                                CASE
                                    VARS.VAR_TYPE
                                    WHEN 'ENV' THEN 2
                                    WHEN 'PKG' THEN 1
                                END AS ENV_FLG
                            FROM
                                {0} VARS
                            WHERE
                                VARS.ENV = '{2}'
                                AND VARS.VAR_TYPE = 'ENV'
                        UNION ALL SELECT
                                VARS.VAR_NME,
                                VARS.VAR_VAL,
                                CASE
                                    VARS.VAR_TYPE
                                    WHEN 'ENV' THEN 2
                                    WHEN 'PKG' THEN 1
                                END AS ENV_FLG
                            FROM
                                {0} VARS
                            WHERE
                                VARS.ENV = '{2}'
                                AND VARS.PKG_NME = '{1}'
                                AND VARS.VAR_TYPE = 'PKG'
                        ) UN
                    GROUP BY
                        VAR_NME
                ) SELECT
                    VARS.VAR_NME,
                    VARS.VAR_VAL
                FROM
                    DAT,
                    {0} VARS
                WHERE
                    VARS.ENV = '{2}'                    
                    AND VARS.VAR_NME != 'SMRY_DESC'
                    AND VARS.PKG_NME = CASE
                        DAT.ENV_FLG
                        WHEN 1 THEN '{1}'
                        WHEN 2 THEN ''
                    END
                    AND VARS.VAR_TYPE = CASE
                        DAT.ENV_FLG
                        WHEN 1 THEN 'PKG'
                        WHEN 2 THEN 'ENV'
                    END
                    AND VARS.VAR_NME = DAT.VAR_NME'''.format(
            g['VARS_TABLE_NAME'], #[0]
            g['PKG_NME'], #[1]
            g['ENV'] #[2]
            )
        q = re.sub(r"([\n ])\1*", r"\1",q).replace('\n',' ')
        self.cur.execute(q)
        self.conn.commit()
        
        print("OPERATION COMPLETE: {}".format(q))
        return self.cur
    # =============================================================================
    # WRITE_LOG
    # - writes error received or success status to sqlite3 db
    # =============================================================================
    def write_log(self, finished_at, e, **g):
        '''
            pyDB.write_log( e,**g )
            generator method writes errors encountered or success status to a SQLITE3 DB table 
                e (error) passed from calling script (if no e found, assume SUCCESS)
                **g (dictionary object specific to calling package) passed from calling script
            returns a results cursor
        '''
        # =============================================================================
        # DELETE PROCESS LOG ENTRIES OLDER THAN 2 DAYS
        # =============================================================================
        q = '''DELETE FROM PY_PROCESS_LOG WHERE 1 = 1 AND MSMT_DTE_ID <= strftime('%Y%m%d',date('now','localtime','-2 day'))'''
        q = re.sub(r"([\n ])\1*", r"\1",q).replace('\n',' ')
        self.cur.execute(q)
        self.conn.commit()
        
        print("OPERATION COMPLETE: {}".format(q))
        if e:
            status = 'ERROR'
            status_desc = str(e).replace("'",'"')
            vars = str(g).replace("'",'"')
        else:
            status = 'SUCCESS'
            status_desc = ''
            vars = ''        
        # =============================================================================
        # UPDATE LOCAL DB WITH ERROR CAPTURE FINISH TIME
        # =============================================================================
        q = r"""INSERT INTO {0} (MSMT_DTE_ID, PKG_NME, START_DATETIME, END_DATETIME, STATUS, STATUS_DESC, VARS) VALUES ({1}, '{2}', '{3}', '{4}', '{5}', '{6}', '{7}')""".format(
            'PY_PROCESS_LOG', #[0]
            g['MSMT_DTE_ID'], #[1]
            g['PKG_NME'], #[2]
            g['STARTED_AT'], #[3]
            finished_at, #[4]
            status, #[5]
            status_desc, #[6]
            vars #[7]
            )
        q = re.sub(r"([\n ])\1*", r"\1",q).replace('\n',' ')
        self.cur.execute(q)
        self.conn.commit()
        
        # OPTIMISE DB
        self.cur.execute('VACUUM')
        self.conn.commit()
        
        print("OPERATION COMPLETE: {}".format(q))
        return self.cur
        
    def __del__(self):
        self.conn.close()
