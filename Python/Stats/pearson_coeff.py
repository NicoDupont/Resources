"""------------------------------------"""
""" Creation date : 22/04/2017  (fr)   """
""" Last update :   22/04/2017  (fr)   """
""" Author(s) : Nicolas DUPONT         """
""" Contributor(s) : 				   """
"""------------------------------------"""

import numpy as np

def PersonCorrCoeff(x, y):
    """Compute Pearson correlation coefficient between two arrays."""
    # Compute correlation matrix: corr_mat
    corr_mat = np.corrcoef(x,y)

    # Return entry [0,1]
    return corr_mat[0,1]

# Compute Pearson correlation coefficient for I. versicolor: r
r = PersonCorrCoeff(var1, var2)

print(r)
