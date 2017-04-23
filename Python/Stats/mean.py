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

#Array
def calc_mean(arr):
    l = len(arr)
    for i in range(1,l):
        s += arr[i] 
    mean = s/l
    return mean

#series
def calc_mean(serie):
    vals = serie.values
    return sum(vals)/len(vals)

# numpy
import numpy as np

def calc_mean(nparray):
    mean = np.mean(nparray)
    return mean
  
# Pandas 
import pandas as pd

def calc_mean(dfs):
    mean = dfs.mean
    return mean
