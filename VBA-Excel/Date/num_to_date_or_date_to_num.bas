'--------------------------------------
' Creation date : 18/04/2017  (fr)
' Last update :   18/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit
'-------------------------------------------------
' The function DateToNum() returns the date in numerical value (21/09/2017 => 20170921 "AAAAMMJJ")
'-------------------------------------------------

Function DateToNum(Optional DateDay As Date) As Double
    If DateDay = "00:00:00" Then DateDay = Date
    DateToNum = year(DateDay) * 10000 + month(DateDay) * 100 + Day(DateDay)
End Function

'-------------------------------------------------
' The function NumToDate() returns a date value ("AAAAMMJJ" 20170921 => 21/09/2017) for a numerical value in entry
'-------------------------------------------------

Function NumToDate(Optional DateDay As Double) As Date
    If IsMissing(DateDay) Then DateDay = DateToNum()
    Dim ye As Double
    Dim mo As Double
    Dim da As Double
    ye = Int(DateDay / 10000)
    mo = Int(DateDay / 100) - (ye * 100)
    da = DateDay - (Int(DateDay / 100) * 100)
    NumToDate = DateSerial(ye, mo, da)
End Function
