'--------------------------------------
' Creation date : 07/04/2017  (fr)   
' Last update :   07/04/2017  (fr)   
' Author(s) : Nicolas DUPONT         
' Contributor(s) : 		             
' Tested on Excel 2010           
'--------------------------------------

'-------------------------------------------------
' The function NumWeekYearEur returns the week number of the year for the date in parameter.
' here I use the european compute parameter
' If there is no parameter, then function return the week number of the year for the current day
'-------------------------------------------------

Function NumWeekYearEur(Optional DateDay As Date) As Integer
    If DateDay = "00:00:00" Then DateDay = Date
    ' =NO.SEMAINE(DateDay;21) => FR function available directly in excel
    ' Format(DateDay, "ww") => another way
    NumWeekYearEur = WorksheetFunction.WeekNum(DateDay, 21)
End Function

'-------------------------------------------------
' The function NumWeekYearDefault returns the week number of the year for the date in parameter.
' here I use the default compute parameter (not european)
' If there is no parameter, then function return the week number of the year for the current day
'-------------------------------------------------

Function NumWeekYearDefault(Optional DateDay As Date) As Integer
    If DateDay = "00:00:00" Then DateDay = Date
    ' =NO.SEMAINE(DateDay;21) => FR function available directly in excel
    ' Format(DateDay, "ww") => another way
    NumWeekYearDefault = WorksheetFunction.WeekNum(DateDay, 1)
End Function
