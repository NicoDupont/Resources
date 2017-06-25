'--------------------------------------
' Creation date : 25/06/2017  (fr)
' Last update :   25/06/2017
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on LibreOffice 5.3.3.2 Ubuntu 16.04LTS
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function Division() returns "" if denominator or numerator = 0
'-------------------------------------------------

Function Division(Numerator As Double, Denominator As Double) As Double

    if Numerator = 0 or Denominator = 0 Then
    	Division = 0
    	Else
			Division = (Numerator / Denominator)
	end if

End Function
