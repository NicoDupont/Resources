'----------------------------------
' Creation date : 10/04/2017  (fr)
' Last update :   12/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'----------------------------------

'----------------------------------
' List of functions :
' - 1 - AddDay
' - 2 - AddMonth
' - 3 - AddYear
' - 4 - DateDiffDay
' - 5 - DateDiffMonth
' - 6 - DateDiffYear
'----------------------------------

'-------------------------------------------------
' The function AddDay returns the date increased or decreased by the number of days passed in parameter.
' If there is no dateday parameter, the function increased or decreased the current date
' If there is no Cpt parameter, just the current date or the date in parameter without modification is returned.
'-------------------------------------------------

Function AddDay(Optional DateDay As Date, Optional Cpt As Integer) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    If TypeName(Cpt) <> "Integer" Then Cpt = 0
    AddDay = DateAdd("d", Cpt, DateDay)
End Function

'-------------------------------------------------
' The function AddMonth returns the date increased or decreased by the number of months passed in parameter.
        ' If there is no dateday parameter, the function increased or decreased the current date
' If there is no Cpt parameter, just the current date or the date in parameter without modification is returned.
'-------------------------------------------------

Function AddMonth(Optional DateDay As Date, Optional Cpt As Integer) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    If TypeName(Cpt) <> "Integer" Then Cpt = 0
    AddMonth = DateAdd("m", Cpt, DateDay)
End Function

'-------------------------------------------------
' The function AddYear returns the date increased or decreased by the number of days passed in parameter.
' If there is no dateday parameter, the function increased or decreased the current date
' If there is no Cpt parameter, just the current date or the date in parameter without modification is returned.
'-------------------------------------------------

Function AddYear(Optional DateDay As Date, Optional Cpt As Integer) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    If TypeName(Cpt) <> "Integer" Then Cpt = 0
    AddYear = DateAdd("yyyy", Cpt, DateDay)
End Function

                    
 '-------------------------------------------------
' The function DateDiffDay returns the number of days between the two dates in parameters.
'-------------------------------------------------

Function DateDiffDay(DateFirst As Date, DateLast As Date) As Integer
    Dim res As Integer
    Dim da As Date
    res = DateDiff("d", DateFirst, DateLast)
    DateDiffDay = res
End Function


'-------------------------------------------------
' The function DateDiffMonth returns the number of months between the two dates in parameters.
'-------------------------------------------------

Function DateDiffMonth(DateFirst As Date, DateLast As Date) As Integer
    Dim res As Integer
    Dim da As Date
    res = DateDiff("m", DateFirst, DateLast)
    DateDiffMonth = res
End Function


'-------------------------------------------------
' The function DateDiffYear returns the number of years between the two dates in parameters.
'-------------------------------------------------

Function DateDiffYear(DateFirst As Date, DateLast As Date) As Integer
    Dim res As Integer
    Dim da As Date
    res = DateDiff("yyyy", DateFirst, DateLast)
    DateDiffYear = res
End Function
