'--------------------------------------
' Creation date : 07/04/2017  (fr)   
' Last update :   07/04/2017  (fr)   
' Author(s) : Nicolas DUPONT         
' Contributor(s) : 		             
' Tested on Excel 2010           
'--------------------------------------



Option Explicit
'-------------------------------------------------
' The function MonthText() returns the month as a string.
' By default, the function returns the month in english
' IF you specify "FR" as the second parameter, the function will return the month in french
' If there is no DateDay parameter, the function returns the month for the current day.
'-------------------------------------------------

Function MonthText(Optional DateDay As Date, Optional Language As String) As String
    
    ' Test on Language parameter
    If Language = "" Then Language = "EN"
    Dim ArrayLang(12) As String
    If UCase(Language) = "FR" Then
        ArrayLang(0) = "janvier"
        ArrayLang(1) = "février"
        ArrayLang(2) = "mars"
        ArrayLang(3) = "avril"
        ArrayLang(4) = "mai"
        ArrayLang(5) = "juin"
        ArrayLang(6) = "juillet"
        ArrayLang(7) = "aout"
        ArrayLang(8) = "septembre"
        ArrayLang(9) = "octobre"
        ArrayLang(10) = "novembre"
        ArrayLang(11) = "décembre"
    Else
        ArrayLang(0) = "january"
        ArrayLang(1) = "february"
        ArrayLang(2) = "march"
        ArrayLang(3) = "april"
        ArrayLang(4) = "may"
        ArrayLang(5) = "june"
        ArrayLang(6) = "july"
        ArrayLang(7) = "august"
        ArrayLang(8) = "september"
        ArrayLang(9) = "october"
        ArrayLang(10) = "november"
        ArrayLang(11) = "december"
    End If
    
    ' Test on DateDay parameter
    If DateDay = "00:00:00" Then DateDay = Date
    Select Case month(DateDay)
        Case Is = "1": MonthText = ArrayLang(0)
        Case Is = "2": MonthText = ArrayLang(1)
        Case Is = "3": MonthText = ArrayLang(2)
        Case Is = "4": MonthText = ArrayLang(3)
        Case Is = "5": MonthText = ArrayLang(4)
        Case Is = "6": MonthText = ArrayLang(5)
        Case Is = "7": MonthText = ArrayLang(6)
        Case Is = "8": MonthText = ArrayLang(7)
        Case Is = "9": MonthText = ArrayLang(8)
        Case Is = "10": MonthText = ArrayLang(9)
        Case Is = "11": MonthText = ArrayLang(10)
        Case Is = "12": MonthText = ArrayLang(11)
    End Select
    
End Function



'-------------------------------------------------
' It's the same function as MonthText() function but with the concatenated year
'-------------------------------------------------

Function MonthYear(Optional DateDay As Date, Optional Language As String) As String
    
    ' Test on Language parameter
    If Language = "" Then Language = "EN"
    Dim ArrayLang(12) As String
    If UCase(Language) = "FR" Then
        ArrayLang(0) = "janvier"
        ArrayLang(1) = "février"
        ArrayLang(2) = "mars"
        ArrayLang(3) = "avril"
        ArrayLang(4) = "mai"
        ArrayLang(5) = "juin"
        ArrayLang(6) = "juillet"
        ArrayLang(7) = "aout"
        ArrayLang(8) = "septembre"
        ArrayLang(9) = "octobre"
        ArrayLang(10) = "novembre"
        ArrayLang(11) = "décembre"
    Else
        ArrayLang(0) = "january"
        ArrayLang(1) = "february"
        ArrayLang(2) = "march"
        ArrayLang(3) = "april"
        ArrayLang(4) = "may"
        ArrayLang(5) = "june"
        ArrayLang(6) = "july"
        ArrayLang(7) = "august"
        ArrayLang(8) = "september"
        ArrayLang(9) = "october"
        ArrayLang(10) = "november"
        ArrayLang(11) = "december"
    End If
    
    ' Test on DateDay parameter
    If DateDay = "00:00:00" Then DateDay = Date
    Dim ye As String
    ye = year(DateDay)
    Select Case month(DateDay)
        Case Is = "1": MonthYear = ArrayLang(0) & "-" & ye
        Case Is = "2": MonthYear = ArrayLang(1) & "-" & ye
        Case Is = "3": MonthYear = ArrayLang(2) & "-" & ye
        Case Is = "4": MonthYear = ArrayLang(3) & "-" & ye
        Case Is = "5": MonthYear = ArrayLang(4) & "-" & ye
        Case Is = "6": MonthYear = ArrayLang(5) & "-" & ye
        Case Is = "7": MonthYear = ArrayLang(6) & "-" & ye
        Case Is = "8": MonthYear = ArrayLang(7) & "-" & ye
        Case Is = "9": MonthYear = ArrayLang(8) & "-" & ye
        Case Is = "10": MonthYear = ArrayLang(9) & "-" & ye
        Case Is = "11": MonthYear = ArrayLang(10) & "-" & ye
        Case Is = "12": MonthYear = ArrayLang(11) & "-" & ye
    End Select
    
End Function
