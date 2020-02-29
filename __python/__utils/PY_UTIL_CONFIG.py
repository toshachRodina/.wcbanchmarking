# =======================================================================================================================================================================================================
# SUBJECT        : config - simple configuration setup
# OBJECT TYPE    : python
# OBJECT NAME    : py_util_config
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

__version__ = '1.0.0'
__author__ = "Harold Delaney"

class pyConfig:
    ''' simple config file support '''
    _recs = {}
    def __init__(self, fn):
        self._fh = open(fn, 'rt')
        self.parse(self._fh)

    def parseline(self, line):
        if line[0] == '#': return
        if '#' in line: line = line.split('#', 2)[0]
        if '=' not in line: return
        ( lhs, rhs ) = line.split('=', 2)
        self._recs[lhs.strip()] = rhs.strip()

    def parse(self, fh):
        for line in fh.readlines():
            self.parseline(line)

    def recs(self):
        return self._recs

def test():
    import sys
    fn = sys.argv[1] if len(sys.argv) > 1 else 'test.conf'

    try:
        conf = configFile(fn)
    except IOError as e:
        print('could not open {},'.format(fn), e)
    else:
        recs = conf.recs()
        for k in sorted(recs):
            print('{} is [{}]'.format(k, recs[k]))

if __name__ == "__main__": test()

