'--------------------------------------
' Creation date : 18/04/2017  (fr)   
' Last update :   18/04/2017  (fr)   
' Author(s) : Nicolas DUPONT         
' Contributor(s) : 		             
' Tested on Excel 2010           
'--------------------------------------


Option Explicit

'-------------------------------------------------
' The function AgeToday() returns the age compared to today
'-------------------------------------------------

Function AgeToday(BirthDate As Date) As Integer
    Dim res As Integer
    res = Int(DateDiff("d", BirthDate, Date) / 365.25)
    AgeToday = res
End Function

'-------------------------------------------------
' The function AgeDate() returns the age compared to a date
'-------------------------------------------------

Function AgeDate(BirthDate As Date, Datelast As Date) As Integer
    Dim res As Integer
    res = Int(DateDiff("d", BirthDate, Datelast) / 365.25)
    AgeDate = res
End Function
