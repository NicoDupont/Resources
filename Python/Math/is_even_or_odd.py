"""
------------------------------------
 Creation date : 22/04/2017  (fr)
 Last update :   23/04/2017  (fr)
 Author(s) : Nicolas DUPONT
 Contributor(s) :
 Tested on Python 3.6
------------------------------------
"""

def IsEven(x):
    if x % 2 == 0:
        return True
    else:
        return False


nb = 2
nb2 = 3

even = IsEven(nb)
print(even)
even = IsEven(nb2)
print(even)
