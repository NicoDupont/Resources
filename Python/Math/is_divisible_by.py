"""------------------------------------"""
""" Creation date : 22/04/2017  (fr)   """
""" Last update :   22/04/2017  (fr)   """
""" Author(s) : Nicolas DUPONT         """
""" Contributor(s) : 				   """
"""------------------------------------"""

def IsDivisbleBy(nb,x):
    if nb % x == 0:
        return True
    else:
        return False


nb = 2
nb2 = 3
nb3 = 4

print("----------------")
By = IsDivisbleBy(nb,2)
print(By)
print("----------------")
By = IsDivisbleBy(nb2,2)
print(By)
print("----------------")
By = IsDivisbleBy(nb3,3)
print(By)
print("----------------")
By = IsDivisbleBy(nb3,4)
print(By)
print("----------------")
