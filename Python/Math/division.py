"""
------------------------------------
 Creation date : 23/04/2017  (fr)
 Last update :   23/04/2017  (fr)
 Author(s) : Nicolas DUPONT
 Contributor(s) :
 Tested on Python 3.6
------------------------------------
"""


def Division(num,dem):
    if num in ('NaN',0) or dem in ('NaN',0):
        res = float('nan')  # or 0 ?
    else:
        res = num/dem
    return res


a = 0
b = 3
c = 4
d = 8
e = 10
f = float('nan')

print(Division(a,b))
print(Division(c,b))
print(Division(c,d))
print(Division(e,f))
print(f)


""" results :

nan
1.3333333333333333
0.5
nan
nan

"""
