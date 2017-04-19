'--------------------------------------
' Creation date : 19/04/2017  (fr)
' Last update :   19/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function DecimalPart() returns the decimal part (0.xx..)
'-------------------------------------------------

Function DecimalPart(nb As Double) As Double
    
    Dim res As Double
    res = nb - (1 * Fix(nb / 1))
    'res = nb Mod 1  => https://msdn.microsoft.com/fr-fr/library/se0w9esz.aspx
    DecimalPart = res
    
End Function
