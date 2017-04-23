"""------------------------------------"""
""" Creation date : 23/04/2017  (fr)   """
""" Last update :   23/04/2017  (fr)   """
""" Author(s) : Nicolas DUPONT         """
""" Contributor(s) : 				   """
"""------------------------------------"""

import numpy as np

def DecimalPart(nb):
    #res = nb % 1
    #res = nb - (1 * int(nb / 1))
    res = nb - (1 * np.fix(nb / 1))
    return res


a = 1
b = 1.12
c = -1.23
d = 5
e = 5.698

print(DecimalPart(a))
print(DecimalPart(b))
print(DecimalPart(c))
print(DecimalPart(d))
print(DecimalPart(e))


""" results :

0.0
0.12
-0.23
0.0
0.698

"""
