"""
------------------------------------
 Creation date : 09/02/2018  (fr)
 Last update :   09/02/2018
 Author(s) : Nicolas DUPONT
 Tested on Python 3.6
------------------------------------
"""

def rmse(y_test,y_pred):
    #import numpy as np
    #rmse = math.sqrt(np.mean((y_pred - y_test) ** 2))
    rmse = np.sqrt(np.mean((y_pred - y_test) ** 2))
    return rmse
