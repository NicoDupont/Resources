"""
------------------------------------
 Creation date : 09/02/2018  (fr)
 Last update :   09/02/2018
 Author(s) : Nicolas DUPONT
 Tested on Python 3.6
------------------------------------
"""

def accuracy(y_test,y_pred):
    #import numpy as np
    #accuracy = (Number of elements correctly classified)/(Number of total elements)
    #accuracy = np.count_nonzero(A == B) / len(y_test)
    accuracy = np.sum(y_pred == y_test) / len(y_test)
    return accuracy
