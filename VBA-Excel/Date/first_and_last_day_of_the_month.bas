'--------------------------------------
' Creation date : 07/04/2017  (fr)   
' Last update :   07/04/2017  (fr)   
' Author(s) : Nicolas DUPONT         
' Contributor(s) : 		             
' Tested on Excel 2010           
'--------------------------------------


Option Explicit
'-------------------------------------------------
' The function BeginMonth returns the first day of the month
' of the date passed as a parameter.
' If there is no parameter, the function returns the first day of the current month
'-------------------------------------------------

Function BeginMonth(Optional DateDay As Date) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    Dim mo As Integer
    Dim ye As Integer
    mo = month(DateDay)
    ye = year(DateDay)
    BeginMonth = DateSerial(ye, mo, 1)
End Function


'-------------------------------------------------
' The function EndMonth returns the last day of the month
' of the date passed as a parameter.
' If there is no parameter, the function returns the last day of the current month
'-------------------------------------------------

Function EndMonth(Optional DateDay As Date) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    Dim mo As Integer
    Dim ye As Integer
    mo = month(DateDay)
    ye = year(DateDay)
    EndMonth = DateSerial(ye, mo + 1, 0)
End Function
