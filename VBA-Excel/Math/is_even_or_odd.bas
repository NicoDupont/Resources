'--------------------------------------
' Creation date : 19/04/2017  (fr)
' Last update :   19/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function IsEven() (Paire) returns 1 if is even or 0 if odd (Impaire)
'-------------------------------------------------

Function IsEven(nb As Double) As Byte
    
    Dim res As Double
    res = nb - (2 * Fix(nb / 2))
    If res = 0 Then
        IsEven = 1
        Else
        IsEven = 0
    End If
    
End Function
