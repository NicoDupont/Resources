'--------------------------------------
' Creation date : 07/04/2017  (fr)   
' Last update :   07/04/2017  (fr)   
' Author(s) : Nicolas DUPONT         
' Contributor(s) : 		             
' Tested on Excel 2010           
'--------------------------------------

Option Explicit
'-------------------------------------------------
' The function NumWeekYearEuro returns the week number of the year for a date.
' Here I use the european compute parameter. (21)
' If there is no parameter, the function returns the week number of the year for the current day.
'-------------------------------------------------

Function NumWeekYearEuro(Optional DateDay As Date) As Integer
    If DateDay = "00:00:00" Then DateDay = Date
    ' =NO.SEMAINE(DateDay;21) => FR function available directly in excel
    ' Format(DateDay, "ww") => another way
    NumWeekYearEuro = WorksheetFunction.WeekNum(DateDay, 21)
End Function

'-------------------------------------------------
' The function NumWeekYearDefault returns the week number of the year for a date.
    ' Here I use the default compute parameter (not european). (1)
' If there is no parameter, the function returns the week number of the year for the current day.
'-------------------------------------------------

Function NumWeekYearDefault(Optional DateDay As Date) As Integer
    If DateDay = "00:00:00" Then DateDay = Date
    ' =NO.SEMAINE(DateDay;21) => FR function available directly in excel
    ' Format(DateDay, "ww") => another way
    NumWeekYearDefault = WorksheetFunction.WeekNum(DateDay, 1)
End Function
