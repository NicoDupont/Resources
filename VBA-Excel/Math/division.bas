'--------------------------------------
' Creation date : 19/04/2017  (fr)
' Last update :   19/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function Division() returns "" if denominator or numerator = 0
'-------------------------------------------------

Function Division(Numerator As Double, Denominator As Double) As Variant
    
    On Error Resume Next
    If IsError(Numerator / Denominator) Then
        Division = ""  ' or 0 ?
        Else
        Division = Numerator / Denominator
    End If
    
End Function
