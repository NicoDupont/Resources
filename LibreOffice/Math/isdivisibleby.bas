'--------------------------------------
' Creation date : 25/06/2017  (fr)
' Last update :   25/06/2017
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on LibreOffice 5.3.3.2 Ubuntu 16.04LTS
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function IsDivisibleBy() returns 1 if the number is divisble by the second paramater
'-------------------------------------------------

Function IsDivisibleBy(Number As Double, Divider As Double) As Byte
    
    Dim res As Double
    if Divider = 0 then 
    	IsDivisibleBy = 0 
    	else
		    res = Number - (Divider * Fix(Number / Divider))
		    If res = 0 Then
		        IsDivisibleBy = 1
		        Else
		        IsDivisibleBy = 0
		    End If
	end if
    
End Function
