'--------------------------------------
' Creation date : 25/06/2017  (fr)
' Last update :   25/06/2017
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on LibreOffice 5.3.3.2 Ubuntu 16.04LTS
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function IsEven() (Paire) returns 1 if is even or 0 if odd (Impaire) or not integer
'-------------------------------------------------

Function IsEven(nb As Double) As Byte
    
    Dim res As Double
    If res <> Int(res) Then 
    		IsEven = 0
	    else
		    res = nb - (2 * Fix(nb / 2))
		    If res = 0 Then
		        IsEven = 1
		        Else
		        IsEven = 0
		    End If
	end if
    
End Function
