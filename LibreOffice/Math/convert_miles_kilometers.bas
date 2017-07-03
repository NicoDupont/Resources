'--------------------------------------
' Creation date : 03/07/2017  (fr)
' Last update :   03/07/2017
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on LibreOffice 5.3.3.2 Ubuntu 16.04LTS
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function ToKm() returns the input in kilometers (we expected to have the entry in miles..)
'-------------------------------------------------

Function ToKm(Mi As Double) As Double
    ToKm = Mi * 1.609344
End Function

'-------------------------------------------------
' The function ToMile() returns the input in miles (we expected to have the entry in kilometers..)
'-------------------------------------------------

Function ToMile(Km As Double) As Double
    ToMile = Km * 0.621371192237334
End Function
