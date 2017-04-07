'--------------------------------------
' Creation date : 07/04/2017  (fr)   
' Last update :   07/04/2017  (fr)   
' Author(s) : Nicolas DUPONT         
' Contributor(s) : 		             
' Tested on Excel 2010           
'--------------------------------------

Option Explicit
'-------------------------------------------------
' The function DayWeek() returns the day as string for a date.
' Here the first day of the week is Monday.
' By default, the function returns the day in english
' IF you specify "FR" as the second parameter, the function will return the day in french
' If there is no parameter, the function returns the day as string for the current day.
'-------------------------------------------------

Function DayWeek(Optional DateDay As Date, Optional Language As String) As String
    
    ' Test on Language parameter
    If Language = "" Then Language = "EN"
    Dim ArrayLang(7) As String
    If UCase(Language) = "FR" Then
        ArrayLang(0) = "lundi"
        ArrayLang(1) = "mardi"
        ArrayLang(2) = "mercredi"
        ArrayLang(3) = "jeudi"
        ArrayLang(4) = "vendredi"
        ArrayLang(5) = "samedi"
        ArrayLang(6) = "dimanche"
    Else
        ArrayLang(0) = "monday"
        ArrayLang(1) = "tuesday"
        ArrayLang(2) = "wednesday"
        ArrayLang(3) = "thursday"
        ArrayLang(4) = "friday"
        ArrayLang(5) = "saturday"
        ArrayLang(6) = "sunday"
    End If
    
    ' Test on DateDay parameter
    If DateDay = "00:00:00" Then DateDay = Date
    Select Case Weekday(DateDay, vbMonday)
        Case Is = 1: DayWeek = ArrayLang(0)
        Case Is = 2: DayWeek = ArrayLang(1)
        Case Is = 3: DayWeek = ArrayLang(2)
        Case Is = 4: DayWeek = ArrayLang(3)
        Case Is = 5: DayWeek = ArrayLang(4)
        Case Is = 6: DayWeek = ArrayLang(5)
        Case Is = 7: DayWeek = ArrayLang(6)
    End Select

End Function

'-------------------------------------------------
' The function NumDayWeek() returns the day number of the week for a date.
' Here the first day of the week is Monday
' If there is no parameter, the function returns the day number of the week for the current day
'-------------------------------------------------

Function NumDayWeek(Optional DateDay As Date) As String

    ' Test on DateDay parameter
    If DateDay = "00:00:00" Then DateDay = Date
    Select Case Weekday(DateDay, vbMonday)
        Case Is = 1: NumDayWeek = "1"
        Case Is = 2: NumDayWeek = "2"
        Case Is = 3: NumDayWeek = "3"
        Case Is = 4: NumDayWeek = "4"
        Case Is = 5: NumDayWeek = "5"
        Case Is = 6: NumDayWeek = "6"
        Case Is = 7: NumDayWeek = "7"
    End Select

End Function
