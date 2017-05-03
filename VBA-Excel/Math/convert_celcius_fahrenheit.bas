'--------------------------------------
' Creation date : 03/05/2017  (fr)
' Last update :   03/05/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function ToCelcius() returns the input in Fahrenheit (we expected to have the entry in celcius..)
'-------------------------------------------------

Function ToCelcius(Fah As Double) As Double
    ToCelcius = ((Fah - 32) / (1.8))
End Function

'-------------------------------------------------
' The function ToFahr() returns the input in celcius (we expected to have the entry in Fahrenheit..)
'-------------------------------------------------

Function ToFahr(Cel As Double) As Double
    ToFahr = ((Cel * (1.8)) + 32)
End Function
