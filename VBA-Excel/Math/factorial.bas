'--------------------------------------
' Creation date : 19/04/2017  (fr)
' Last update :   19/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function Factorial() returns the factorial (here it's recursive)
'-------------------------------------------------

Function Factorial(Number As Double) As Double
    
    Dim res As Double
    res = 0
    If Number = 0 Then
        res = 1
        Else
        res = Factorial(Number - 1) * Number
    End If
    Factorial = res
 
End Function
