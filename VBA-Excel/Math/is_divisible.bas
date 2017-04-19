'--------------------------------------
' Creation date : 19/04/2017  (fr)
' Last update :   19/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit


'-------------------------------------------------
' The function IsDivisibleBy() returns 1 if the number is divisble by the second paramater
'-------------------------------------------------

Function IsDivisibleBy(Number As Double, Divider As Double) As Byte
    
    Dim res As Double
    res = Number - (Divider * Fix(Number / Divider))
    If res = 0 Then
        IsDivisibleBy = 1
        Else
        IsDivisibleBy = 0
    End If
    
End Function
