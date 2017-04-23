"""
------------------------------------
 Creation date : 23/04/2017  (fr)
 Last update :   23/04/2017  (fr)
 Author(s) : Nicolas DUPONT
 Contributor(s) :
 Tested on Python 3.6
------------------------------------
"""


def Factorial(nb):
    res = 1
    if nb < 2:
        res = 1
    else:
        for i in range(2,nb+1):
            res = i * res
    return res

""" recursive :
def Factorial(nb):
    res = 1
    if nb < 2:
        res = 1
    else:
        res = Factorial(nb - 1) * nb
    return res
"""

# Third way :
# fact = lambda z : reduce(lambda x,y:x*y,range(1,z+1),1)

a = 1
b = 3
c = 4
d = 8
e = 10

print(Factorial(a))
print(Factorial(b))
print(Factorial(c))
print(Factorial(d))
print(Factorial(e))


""" results :

1
6
24
40320
3628800

"""
