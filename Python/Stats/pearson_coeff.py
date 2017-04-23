"""
------------------------------------
 Creation date : 22/04/2017  (fr)
 Last update :   23/04/2017  (fr)
 Author(s) : Nicolas DUPONT
 Contributor(s) :
 Tested on Python 3.6
------------------------------------
"""

import numpy as np

def PersonCorrCoeff(x, y):
    # Compute Pearson correlation coefficient between two arrays.
    # Compute correlation matrix: corr_mat
    corr_mat = np.corrcoef(x,y)
    # Return entry [0,1]
    return corr_mat[0,1]

# Compute Pearson correlation coefficient
r = PersonCorrCoeff(var1, var2)

print(r)



# Without numpy => look at variance_covarience.py
def PersonCorrCoeff(series_one, series_two):
    cov = calc_covariance(series_one, series_two)
    std1 = calc_variance(series_one) ** (1/2)
    std2 = calc_variance(series_two) ** (1/2)
    corr =  cov / (std1 * std2)
    return corr
