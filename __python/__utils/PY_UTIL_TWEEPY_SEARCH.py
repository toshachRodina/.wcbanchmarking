# =======================================================================================================================================================================================================
# SUBJECT        : twitter api REST search - navigates to url and passes in html to parser
# OBJECT TYPE    : python
# OBJECT NAME    : py_util_tweepy_search
# CREATED BY     : Harold Delaney
# CREATED ON     : 20170830
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
import os, sys, time, tweepy 

from PY_UTIL_EMAIL import pyMail
from PY_UTIL_DB import pyDB
# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- END
# =============================================================================

class pyTweepySearch():
    def __init__(self,searchQuery, sinceId, sentmnt_mtch, place_id, cc, **g):
        self.searchQuery = searchQuery
        self.db_sinceId = sinceId
        self.sentmnt_mtch = sentmnt_mtch
        self.place_id = place_id
        self.cc = cc
        
    def __del__(self):
        None
        
    def tweepySearch(searchQuery, sinceId, sentmnt_mtch, place_id, cc, **g):        
        # SETUP TWITTER AUTHORISATION
        auth = tweepy.AppAuthHandler(g['TWIT_CNSMR_KEY'], g['TWIT_CNSMR_SECRET'])
        api = tweepy.API(auth, wait_on_rate_limit=True, wait_on_rate_limit_notify=True)
        
        if (not api):
            print ('UNABLE TO AUTHENTICATE')
            sys.exit(-1)        
        
        # IF RESULTS ONLY BELOW A SPECIFIC ID ARE, SET MAX_ID TO THAT ID.
        # ELSE DEFAULT TO NO UPPER LIMIT, START FROM THE MOST RECENT TWEET MATCHING THE SEARCH QUERY.
        max_id = -1 #L
        tweetCount = 0        
        
        print("Downloading max {0} tweets".format(g['TWIT_MAX_TWEETS'])) 
        
        while tweetCount < int(g['TWIT_MAX_TWEETS']):        
            try:
                if (max_id <= 0):
                    if (not sinceId):
                        tweets = api.search(q=searchQuery, count = int(g['TWIT_TWEETS_PER_QRY'])) #q=searchQuery
                    else:
                        tweets = api.search(q=searchQuery, count = int(g['TWIT_TWEETS_PER_QRY']), since_id = sinceId)
                else:
                    if (not sinceId):
                        tweets = api.search(q=searchQuery, count = int(g['TWIT_TWEETS_PER_QRY']),  max_id = str(max_id - 1))
                    else:
                        tweets = api.search(q=searchQuery, count = int(g['TWIT_TWEETS_PER_QRY']),  max_id = str(max_id - 1), since_id = sinceId)
                
                if not tweets:
                    print("No more tweets found")
                    break 
            
                # =============================================================================
                # PROCESS TWEETS COLLECTED FROM THE SEARCH API PROCESS
                # =============================================================================
                for tweet in tweets:
                    # =============================================================================
                    # WRITE RESULTS OF EACH TWEET TO LOCAL DB
                    # ============================================================================= 
                    created_at = str(tweet.created_at).split(' ')
                    created_at = created_at[0].replace('-','')
                    #print(tweet.encode('ascii', 'replace').decode("utf-8"))  
                    dbmgr = pyDB(g['DB'])
                    q = r"""INSERT INTO {0} (MSMT_DTE_ID, CREATED_AT, TWEET_ID, USER_ID, USER_NAME, USER_SCREEN_NAME, USER_LOCATION, CNTRY_ID, CNTRY_CDE, PLACE_NAME, SENTMT_MATCH, TWEET_TXT, IN_REPLY_TO, RE_TWEETED, PRCES_DTE_ID, STARTED_AT, FINISHED_AT) VALUES ({1}, '{2}', {3}, {4}, '{5}', '{6}', '{7}', '{8}', '{9}', '{10}', '{11}', '{12}', '{13}', '{14}', {15}, '{16}', '{17}')""".format(
                        g['TBL_NME'], #[0]
                        created_at, #[1]
                        str(tweet.created_at), #[2]
                        tweet.id, #[3]
                        tweet.user.id, #[4]
                        str(tweet.user.name.encode('ascii', 'replace').decode("utf-8")).replace('?','').replace("'",'').rstrip().lstrip(), #[5]
                        str(tweet.user.screen_name.encode('ascii', 'replace').decode("utf-8")).replace('?','').replace("'",'').rstrip().lstrip(), #[6]
                        str(tweet.user.location.encode('ascii', 'replace').decode("utf-8")).replace('?','').replace("'",'').rstrip().lstrip().upper(), #[7]
                        str(place_id), #[8]
                        cc, #[9]
                        str(tweet.place.name.encode('ascii', 'replace').decode("utf-8")).replace('?','').replace("'",'').rstrip().lstrip().upper(), #[10]
                        sentmnt_mtch,  #[11]
                        str(tweet.text.encode('ascii', 'replace').decode("utf-8")).replace('?','').replace("'",'').replace('\n','. ').replace('. . ','. '), #[12]
                        ('NOVAL' if tweet.in_reply_to_status_id_str is None else str(tweet.in_reply_to_status_id_str).upper()), #[13]
                        str(tweet.retweeted).upper(), #[14]
                        g['MSMT_DTE_ID'], #[15]
                        g['STARTED_AT'], #[16]
                        '' #[17]
                        )
                    #print(q)
                    dbmgr.query(q)
                
                tweetCount += len(tweets)
                print("Downloaded {0} tweets".format(tweetCount))
                max_id = tweets[-1].id
        
            except tweepy.TweepError as e:
                # capture a finish time to be entered into the db
                finished_at = time.strftime("%Y-%m-%d %H:%M:%S")
                e = sys.exc_info()
                print('ERROR ENCOUNTERED : ' + str(e))
                # =============================================================================
                # WRITE RESULTS OF ERROR TO LOCAL DB 
                # =============================================================================   
                dbmgr = pyDB(g['DB'])
                dbmgr.write_log(finished_at,'TWITTER SEARCH ERROR : ' + str(e),**g)
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
                mymail.htmladd('A TWITTER SEARCH ERROR was encountered for package : ' + str(g['PKG_NME']))
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
                
                # EXIT IF ANY ERROR
                print("some error : " + str(e))
                break
            
        print ("Downloaded {0} tweets".format(tweetCount))
        

