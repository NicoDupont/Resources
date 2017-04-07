'--------------------------------------
' Creation date : 07/04/2017  (fr)   
' Last update :   07/04/2017  (fr)   
' Author(s) : Nicolas DUPONT         
' Contributor(s) : 		             
' Tested on Excel 2010           
'--------------------------------------

Option Explicit
'-------------------------------------------------
' The function Quarter() returns the quarter for a date.
' By default, the function returns "QX"
' IF you specify "FR" as the second parameter, the function will return "TX"
' If there is no DateDay parameter, the function returns the quarter for the current day.
'-------------------------------------------------

Function Quarter(Optional DateDay As Date, Optional Language As String) As String
    
    ' Test on Language parameter
    If Language = "" Then Language = "EN"
    Dim ArrayLang(4) As String
    If UCase(Language) = "FR" Then
        ArrayLang(0) = "T1"
        ArrayLang(1) = "T2"
        ArrayLang(2) = "T3"
        ArrayLang(3) = "T4"
    Else
        ArrayLang(0) = "Q1"
        ArrayLang(1) = "Q2"
        ArrayLang(2) = "Q3"
        ArrayLang(3) = "Q4"
    End If
    
    ' Test on DateDay parameter
    If DateDay = "00:00:00" Then DateDay = Date
    Select Case month(DateDay)
        Case Is = "1": Quarter = ArrayLang(0)
        Case Is = "2": Quarter = ArrayLang(0)
        Case Is = "3": Quarter = ArrayLang(0)
        Case Is = "4": Quarter = ArrayLang(1)
        Case Is = "5": Quarter = ArrayLang(1)
        Case Is = "6": Quarter = ArrayLang(1)
        Case Is = "7": Quarter = ArrayLang(2)
        Case Is = "8": Quarter = ArrayLang(2)
        Case Is = "9": Quarter = ArrayLang(2)
        Case Is = "10": Quarter = ArrayLang(3)
        Case Is = "11": Quarter = ArrayLang(3)
        Case Is = "12": Quarter = ArrayLang(3)
    End Select
    
End Function

'-------------------------------------------------
' The function Semester() returns the semester for a date.
' If there is no DateDay parameter, the function returns the semester for the current day.
'-------------------------------------------------

Function Semester(Optional DateDay As Date) As String
    If DateDay = "00:00:00" Then DateDay = Date
    Select Case month(DateDay)
        Case Is = "1": Semester = "S1"
        Case Is = "2": Semester = "S1"
        Case Is = "3": Semester = "S1"
        Case Is = "4": Semester = "S1"
        Case Is = "5": Semester = "S1"
        Case Is = "6": Semester = "S1"
        Case Is = "7": Semester = "S2"
        Case Is = "8": Semester = "S2"
        Case Is = "9": Semester = "S2"
        Case Is = "10": Semester = "S2"
        Case Is = "11": Semester = "S2"
        Case Is = "12": Semester = "S2"
    End Select
End Function


'-------------------------------------------------
' It's the same function as Quarter() function but with the concatenated year
'-------------------------------------------------

Function QuarterYear(Optional DateDay As Date, Optional Language As String) As String
    
    ' Test on Language parameter
    If Language = "" Then Language = "EN"
    Dim ArrayLang(4) As String
    If UCase(Language) = "FR" Then
        ArrayLang(0) = "T1"
        ArrayLang(1) = "T2"
        ArrayLang(2) = "T3"
        ArrayLang(3) = "T4"
    Else
        ArrayLang(0) = "Q1"
        ArrayLang(1) = "Q2"
        ArrayLang(2) = "Q3"
        ArrayLang(3) = "Q4"
    End If
    
    ' Test on DateDay parameter
    If DateDay = "00:00:00" Then DateDay = Date
    Dim ye As Integer
    ye = year(DateDay)
    Select Case month(DateDay)
        Case Is = "1": QuarterYear = ArrayLang(0) & "-" & ye
        Case Is = "2": QuarterYear = ArrayLang(0) & "-" & ye
        Case Is = "3": QuarterYear = ArrayLang(0) & "-" & ye
        Case Is = "4": QuarterYear = ArrayLang(1) & "-" & ye
        Case Is = "5": QuarterYear = ArrayLang(1) & "-" & ye
        Case Is = "6": QuarterYear = ArrayLang(1) & "-" & ye
        Case Is = "7": QuarterYear = ArrayLang(2) & "-" & ye
        Case Is = "8": QuarterYear = ArrayLang(2) & "-" & ye
        Case Is = "9": QuarterYear = ArrayLang(2) & "-" & ye
        Case Is = "10": QuarterYear = ArrayLang(3) & "-" & ye
        Case Is = "11": QuarterYear = ArrayLang(3) & "-" & ye
        Case Is = "12": QuarterYear = ArrayLang(3) & "-" & ye
    End Select
    
End Function


'-------------------------------------------------
' It's the same function as Semester() function but with the concatenated year
'-------------------------------------------------

Function SemesterYear(Optional DateDay As Date) As String
    If DateDay = "00:00:00" Then DateDay = Date
    Dim ye As String
    ye = year(DateDay)
    Select Case month(DateDay)
        Case Is = "1": SemesterYear = "S1-" & ye
        Case Is = "2": SemesterYear = "S1-" & ye
        Case Is = "3": SemesterYear = "S1-" & ye
        Case Is = "4": SemesterYear = "S1-" & ye
        Case Is = "5": SemesterYear = "S1-" & ye
        Case Is = "6": SemesterYear = "S1-" & ye
        Case Is = "7": SemesterYear = "S2-" & ye
        Case Is = "8": SemesterYear = "S2-" & ye
        Case Is = "9": SemesterYear = "S2-" & ye
        Case Is = "10": SemesterYear = "S2-" & ye
        Case Is = "11": SemesterYear = "S2-" & ye
        Case Is = "12": SemesterYear = "S2-" & ye
    End Select
End Function
