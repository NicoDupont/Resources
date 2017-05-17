'--------------------------------------
' Creation date : 17/05/2017  (fr)
' Last update :   17/05/2017
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on LibreOffice 5.3.3.2 Ubuntu 16.04LTS
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function Factorial() returns the factorial (here it's recursive)
'-------------------------------------------------

Function Factorial(Number As Double) As Double

    Dim res As Double
	res = 0
    if int(Number) = Number Then
	    If Number = 0 or Number = 1 Then
	        res = 1
	        Else
	        res = Factorial(Number - 1) * Number
	    End If
	else
		res = 0
	end if
	Factorial = res

End Function
