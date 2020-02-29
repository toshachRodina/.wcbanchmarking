# =======================================================================================================================================================================================================
# SUBJECT        : lib - assortment of hany utilities
# OBJECT TYPE    : python
# OBJECT NAME    : py_util_lib
# CREATED BY     : Harold Delaney
# CREATED ON     : 20170409
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
import shutil
import re # REGEX
import datetime as dt

# =============================================================================
# ENVIRNMENT AND LIBRARY SETUP -- END
# =============================================================================
__version__ = '1.0.0'
__author__ = "Harold Delaney"

class pyLIB(object):
    def __init__(self):
        pass
    
    def codeGen(arg):
        '''
            pyLIB.codeGen( arg )
            generates a number code based on a string of words/text
                arg is a string containing 1 or more words
            returns a number as a char
        '''
        lg = dict()
        lg['ALPHA_NBR_CNVRT'] = {' ':  1
                                ,'A':  2 ,'B':  3 ,'C':  4 ,'D':  5 ,'E':  6 ,'F':  7 ,'G':  8 ,'H':  9 ,'I':  10 ,'J': 11
                                ,'K': 12 ,'L': 13 ,'M': 14 ,'N': 15 ,'O': 16 ,'P': 17 ,'Q': 18 ,'R': 19 ,'S': 20 ,'T': 21
                                ,'U': 22 ,'V': 23 ,'W': 24 ,'X': 25 ,'Y': 26 ,'Z': 27
                                }
        # CLEAN INPUT STRING
        inp = arg.strip().split(' ')
        # GET SOME NUMBERS BASED ON INPUT TO USE WHILE DERIVING FINAL CODE
        nbrLetters = len(arg)
        nbrWords = len(inp)        
        # BREAK DOWN EACH LETTER
        algNbr = 1
        for char in list(arg):
            if char.isalpha():
                charNbr = lg['ALPHA_NBR_CNVRT'].get(char)            
                algNbr = algNbr + charNbr
           
        cde = (algNbr * (nbrLetters * nbrWords)) / (nbrWords + nbrLetters) 
        cde = str(round(cde,2))
        
        return cde
    
    def subDate(date, year=0, month=0):
        year, month = divmod(year*12 + month, 12)
        if date.month <= month:
            year = date.year - year - 1
            month = date.month - month + 12
        else:
            year = date.year - year
            month = date.month - month
        return date.replace(year = year, month = month)
    
    def moveFiles(srceDir, trgtDir, fileNameSearch):        
        files = os.listdir(srceDir)        
        for f in files:
            if (f.find(fileNameSearch) == -1):  # OLD - if (f.endswith(fileNameSearch)):
                None # FILE WITH STRING NOT FOUND
            else:
                shutil.move(srceDir + '\\' + f, trgtDir)
            
                
                
