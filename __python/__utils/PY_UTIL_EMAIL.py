# =======================================================================================================================================================================================================
# SUBJECT        : email - email status and data of recent job runs
# OBJECT TYPE    : python
# OBJECT NAME    : py_util_email
# CREATED BY     : Harold Delaney
# CREATED ON     : 20170324
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
import sys
import ast
from datetime import datetime
import time # date time operations
 
import smtplib
import mimetypes
from email.mime.multipart import MIMEMultipart
from email import encoders
from email.message import Message
from email.mime.audio import MIMEAudio
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
 
from PY_UTIL_DB import pyDB
# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- END
# =============================================================================
 
class pyMail:
    def __init__(self,subject,**g):
        self.subject = subject
        self.db = g['DB']
        self.htmlbody = ''
        self.sender = g['EMAIL_SNDR_USRNME'] 
        self.senderpass = g['EMAIL_SNDR_PWORD'] 
        self.recipients = g['EMAIL_DSTRBTN_LST'] # needs to be converted to a list rather than the string its held in DB
        self.attachments = []

    def send(self, **g):
        # =============================================================================
        # ATTEMPT TO SEND EMAIL 3 TIMES BEFORE FAILING WITH ERROR 
        # ============================================================================= 
        for i in range(3):
            try:
                db = self.db
                # =============================================================================
                # CONVERT STRING TO ARRAY FOR EMAIL DISTRIBUTION SEND 
                # =============================================================================
                recipients = self.recipients
                recipient_array = []
                # CONVERTS LIST OBJECT TO ARRAY
                for item in recipients.split(','): # COMMA, OR OTHER
                    recipient_array.append(item)
                
                msg = MIMEMultipart('alternative')
                msg['From']=self.sender
                msg['Subject']=self.subject
                msg['To'] = ", ".join(recipient_array) # TO:MUST BE ARRAY OF THE FORM ['mailsender135@gmail.com'] 
                msg.preamble = "preamble goes here"
                # CHECKS FOR ATTACHEMNTS AND ADDS IF FOUND 
                if self.attachments:
                    self.attach(msg)
                # ADD HTML BODY AFTER ATTACHMENTS
                msg.attach(MIMEText(self.htmlbody, 'html'))
                # SEND
                s = smtplib.SMTP('smtp.gmail.com:587')
                s.ehlo()
                s.starttls()
                s.login(self.sender,self.senderpass)
                s.sendmail(self.sender, self.recipients, msg.as_string())
                # TEST
                print (msg)
                s.quit()
                # BREAK FROM LOOP
                break
            except:
                # capture a finish time to be entered into the db
                finished_at = time.strftime("%Y-%m-%d %H:%M:%S")
                # =============================================================================
                # WRITE RESULTS OF ERROR TO LOCAL DB 
                # =============================================================================   
                e = sys.exc_info()
                dbmgr = pyDB(db)
                dbmgr.write_log(finished_at,'EMAIL ERROR: ' + str(e),**g)
    
    def htmladd(self, html):
        self.htmlbody = self.htmlbody+'<p></p>'+html
 
    def attach(self,msg):
        for f in self.attachments:
        
            ctype, encoding = mimetypes.guess_type(f)
            if ctype is None or encoding is not None:
                ctype = "application/octet-stream"
                
            maintype, subtype = ctype.split("/", 1)
 
            if maintype == "text":
                fp = open(f)
                # NOTE: SHOULD HANDLE CALCULATING THE CHARSET
                attachment = MIMEText(fp.read(), _subtype=subtype)
                fp.close()
            elif maintype == "image":
                fp = open(f, "rb")
                attachment = MIMEImage(fp.read(), _subtype=subtype)
                fp.close()
            elif maintype == "audio":
                fp = open(f, "rb")
                attachment = MIMEAudio(fp.read(), _subtype=subtype)
                fp.close()
            else:
                fp = open(f, "rb")
                attachment = MIMEBase(maintype, subtype)
                attachment.set_payload(fp.read())
                fp.close()
                encoders.encode_base64(attachment)
            attachment.add_header("Content-Disposition", "attachment", filename=f)
            attachment.add_header('Content-ID', '<{}>'.format(f))
            msg.attach(attachment)
    
    def addattach(self, files):
        self.attachments = self.attachments + files
