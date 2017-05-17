'--------------------------------------
' Creation date : 17/05/2017  (fr)
' Last update :   17/05/2017
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on LibreOffice 5.3.3.2 Ubuntu 16.04LTS
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
