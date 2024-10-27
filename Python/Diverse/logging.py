"""
------------------------------------
 Creation date : 27/10/2024  (fr)
 Last update :   27/10/2024  (fr)
 Author(s) : Nicolas DUPONT
 Contributor(s) :
 Tested on Python 3.7.3 +
------------------------------------
"""

import logging
import datetime

def ConfigLogging(logger,logfile,stream_level,file_level,rotating) -> None:
	logger_levels = {
	'ERROR' : logging.ERROR,
	'INFO' : logging.INFO,
	'DEBUG' : logging.DEBUG,
	'NOTSET' : logging.NOTSET,
	'WARNING' : logging.WARNING,
	'CRITICAL' : logging.CRITICAL
	}
	logger.setLevel(logger_levels[stream_level])
	# Format for our loglines
	#formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(funcName)s - %(message)s")
	formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(funcName)s - %(message)s")
	# Setup console logging
	ch = logging.StreamHandler()
	ch.setLevel(logger_levels[stream_level])
	ch.setFormatter(formatter)
	logger.addHandler(ch)
	# Setup file logging as well
	if rotating:
		fh = TimedRotatingFileHandler(logfile,encoding='utf-8',when='d',backupCount=10,interval=1)
	else:
		fh = logging.FileHandler(logfile,encoding='utf-8')
	fh.setLevel(logger_levels[file_level])
	fh.setFormatter(formatter)
	logger.addHandler(fh)
 
 
#--------------------------------------
# initialise logging config
# Choose if you want one log file or a daily log file
# choose the logging level for stream and file
dat = datetime.datetime.now()
logger = logging.getLogger(__name__)#.addHandler(logging.NullHandler())
#logfile = "log/arrosage_"+str(day.day)+"_"+str(day.month)+"_" +str(day.year)+".txt"
logfile = "log/log.txt"
func.ConfigLogging(logger,logfile,'INFO','INFO',True)