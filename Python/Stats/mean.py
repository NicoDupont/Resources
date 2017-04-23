"""
------------------------------------
 Creation date : 23/04/2017  (fr)
 Last update :   23/04/2017  (fr)
 Author(s) : Nicolas DUPONT
 Contributor(s) :
 Tested on Python 3.6
------------------------------------
"""

# compute the mean

def calc_mean(serie):
    vals = serie.values
    return sum(vals)/len(vals)


import numpy as np

def calc_mean(nparray):
    mean = np.mean(nparray)
    return mean
