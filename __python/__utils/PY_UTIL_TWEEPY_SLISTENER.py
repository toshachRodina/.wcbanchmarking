# =======================================================================================================================================================================================================
# SUBJECT        : sentiment analysis from twitter
# OBJECT TYPE    : python
# OBJECT NAME    : py_twitter_jobs
# CREATED BY     : Harold Delaney
# CREATED ON     : 20170623
# SOURCE         : twitter (tweepy python library)
# PREPERATION    : 
# FREQUENCY      : STREAMIN
#               
# REMARKS        : 1) 
#                  2) 
#                  3)
# =======================================================================================================================================================================================================
# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- START
# =============================================================================
from tweepy import StreamListener
import json, time, sys

class pySListener(StreamListener):

    def __init__(self, api = None, fprefix = 'streamer', **g):
        self.api = api or API()
        self.counter = 0
        self.fprefix = fprefix
        '''self.output  = open(fprefix + '.' 
                            + time.strftime('%Y%m%d-%H%M%S') + '.json', 'w')'''
        self.delout  = open('delete.txt', 'a')
        self.db = g['DB']
        self.country_filter = g['CONTRY_RESTRICTIONS']

    def on_data(self, tweet, **g):
        print(tweet)        
        # CONVERT JSON TEXT OBJECT (DATA) TO PYTHON DICTIONARY
        d = json.loads(tweet)
        #print (str(d).upper().encode('ascii', 'ignore')) # print(d['glossary']['title'])
        
   
        coords = d['coordinates']
        if d.get('place'):
            place_coords = d['place']['bounding_box']['coordinates']
            place_type = d['place']['place_type']
            place_name = d['place']['name']
            place_full_name = d['place']['full_name']
            place_country_code = d['place']['country_code']
            place_country = d['place']['country'] 
        else:
            return
            
        print(coords)
        print(place_coords)
        print(place_type)
        print(place_name)
        print(place_full_name)
        print(place_country_code)
        print(place_country)
                
        try:
            # BASIC FILTERS
            if place_country_code in self.country_filter and str(d['in_reply_to_status_id']).upper().encode('ascii', 'ignore') == 'NONE' and 'retweeted_status' not in d and 'HTTP' not in str(d['text']).upper().encode('ascii', 'ignore'):
                print('keep : ' + tweet)
                #self.on_status(**d)
                return
            elif 'delete' in tweet:
                delete = json.loads(tweet)['delete']['status']
                if self.on_delete(delete['id'], delete['user_id']) is False:
                    return False
            elif 'limit' in tweet:
                if self.on_limit(json.loads(tweet)['limit']['track']) is False:
                    return False
            elif 'warning' in tweet:
                warning = json.loads(tweet)['warnings']
                print (warning['message'])
                return false
        except KeyError as k:
            print ("Fail: " + str(k))
            
    def on_status(self, **d): #status):
        # PREPARE TO WRITE TO A DATABASE OR FILE
        # GENERATE DICTIONARY PAIRS FOR TABLE CALL AND INSERTION
        tweet = dict(
            MSMT_DTE_ID = time.strftime('%Y%m%d')
           ,DATA_TYPE = 'TEMP'
           ,CNTRY_CDE = d['user']['country_code']
           ,LOCATION = d['user']['location']
           ,GEO = d['geo']
           ,COORDS = d['coords']['lon'] + ',' + d['coords']['lat'] #'d['coordinates']
           ,UTC_OFFSET = d['user']['utc_offset']
           ,TIME_ZONE = d['user']['time_zone']
           ,LANGUAGE = d['user']['lang']
           ,DESCRIPTION = d['user']['description']
           ,TEXT = str(d['text']).upper().encode('utf-8')
           ,USER_NAME = d['user']['screen_name']
           ,USER_CREATED = d['user']['created_at']
           ,RETWEET_COUNT = d['retweet_count']
           ,RETWEET_STATUS = d['retweeted']
        )
        print(tweet)
        
        self.filter_tweet(**tweet)
        
        return
    
    def on_delete(self, status_id, user_id):
        self.delout.write( str(status_id) + "\n")
        return

    def on_limit(self, track):
        sys.stderr.write(track + "\n")
        return

    def on_error(self, status_code):
        sys.stderr.write('Error: ' + str(status_code) + "\n")
        return False

    def on_timeout(self):
        sys.stderr.write("Timeout, sleeping for 60 seconds...\n")
        time.sleep(60)
        return 
    
    def filter_tweet(**tweet):
    
        print(tweet)
        # REMOVE TWEETS THAT DONT MATCH FURTHER BUSINESS CRITERIA
        if not tweet_matches_criteria(tweet):
            return
        # Process the remaining tweets.
        self.store_tweet(**tweet)
    
    
    def store_tweet(**tweet): 
        # =============================================================================
        # WRITE RESULTS OF TWEEP EXTRACT TO LOCAL DB
        # =============================================================================   
        dbmgr = pyDB(g['DB'])
        q = r"""INSERT INTO {0} (MSMT_DTE_ID, DATA_TYPE, CNTRY_CDE, LOCATION, GEO, COORDS, UTC_OFFSET, TIME_ZONE, LANGUAGE, DESCRIPTION, TEXT, USER_NAME, USER_CREATED, RETWEET_COUNT, POLARITY, SUBJECTIVITY) 
            VALUES ({1}, '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}', '{9}', {10}, '{11}', '{12}', '{13}', {14})""".format(
             g['TBL_NME'] #[0]
            ,tweet['MSMT_DTE_ID'] #[1]
            ,tweet['DATA_TYPE'] #[2]
            ,tweet['CNTRY_CDE'] #[3]
            ,tweet['LOCATION'] #[4]
            ,tweet['GEO']  #[5]
            ,tweet['COORDS']  #[6]
            ,tweet['UTC_OFFSET']  #[7]
            ,tweet['TIME_ZONE']  #[8]
            ,tweet['LANGUAGE']  #[9]
            ,tweet['DESCRIPTION'] #[10]        
            ,tweet['TEXT'] #[11]
            ,tweet['USER_NAME'] #[12]
            ,tweet['USER_CREATED'] #[13]
            ,tweet['RETWEET_COUNT'] #[14]
            )
        dbmgr.query(q)