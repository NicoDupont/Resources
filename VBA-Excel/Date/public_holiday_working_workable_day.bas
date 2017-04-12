'-------------------------------------
' Creation date : 10/04/2017  (fr)  
' Last update :   10/04/2017  (fr) 
' Author(s) : Nicolas DUPONT       
' Contributor(s) : 		         
' Tested on Excel 2010          
'-------------------------------------

'-------------------------------------
' List of functions :
' - 1 - PublicHolidayFr
' - 2 - WorkingDay
' - 3 - WorkableDay
' - 4 - NextWorkingDay
' - 5 - NextWorkableDay
' - 6 - PrevWorkingDay
' - 7 - PrevWorkableDay
' - 8 - NextPublicHoliday
'-------------------------------------



option explicit
'-------------------------------------------------
' The function PublicHolidayFr returns 1 if the date is a public holiday.
' If there is no DateDay parameter, the function returns 1 if the current date is a public holiday.
' Note : actually it's just for France
'-------------------------------------------------

Function PublicHolidayFr(Optional DateDay As Date) As Byte
    If DateDay = "00:00:00" Then DateDay = Date
    Dim res As Byte
    ' year
    Dim ye As Integer
    ye = year(DateDay)
    ' compute Paques day
    Dim Pa As Date
    Dim Mod4 As Integer, Mod7 As Integer, Mod9 As Integer
    Mod9 = (19 * (ye Mod 19) + 24) Mod 30
    Mod4 = ye Mod 4
    Mod7 = ye Mod 7
    Pa = DateSerial(ye, 4, (Mod9 + (2 * Mod4 + 4 * Mod7 + 6 * Mod9 + 5) Mod 7) - 9)
    ' if Dateday is a public holiday
    Select Case DateDay
        Case Is = DateSerial(ye, 1, 1): res = 1
        Case Is = DateSerial(ye, 5, 1): res = 1
        Case Is = DateSerial(ye, 5, 8): res = 1
        Case Is = DateSerial(ye, 7, 14): res = 1
        Case Is = DateSerial(ye, 8, 15): res = 1
        Case Is = DateSerial(ye, 11, 1): res = 1
        Case Is = DateSerial(ye, 11, 11): res = 1
        Case Is = DateSerial(ye, 12, 25): res = 1
        Case Is = Pa: res = 1  ' Dimanche Paques
        Case Is = Pa + 1: res = 1   ' Lundi de Paques
        Case Is = Pa + 39: res = 1 'Ascension
        Case Is = Pa + 49: res = 1 'Pentecôte
        Case Is = Pa + 50: res = 1 'Lundi de Pentecôte
        Case Else
          res = 0
    End Select
    'return result
    PublicHolidayFr = res
End Function


'-------------------------------------------------
' The function WorkingDay returns 1 if the date is a Working Day (Monday => Friday).
' If there is no DateDay parameter, the function returns 1 if the current date is a Working Day.
'-------------------------------------------------

Function WorkingDay(Optional DateDay As Date) As Byte
    If DateDay = "00:00:00" Then DateDay = Date
    Dim res As Byte
    Dim nda As Byte
    Dim phl As Byte
    phl = PublicHolidayFr(DateDay)
    nda = Weekday(DateDay, vbMonday)
    If (nda = 6 Or nda = 7 Or phl = 1) Then
        res = 0
    Else
        res = 1
    End If
    WorkingDay = res
End Function


'-------------------------------------------------
' The function WorkableDay returns 1 if the date is a Workable Day (Monday => Saturday).
' If there is no DateDay parameter, the function returns 1 if the current date is a Workable Day.
'-------------------------------------------------

Function WorkableDay(Optional DateDay As Date) As Byte
    If DateDay = "00:00:00" Then DateDay = Date
    Dim res As Byte
    Dim nda As Byte
    Dim phl As Byte
    phl = PublicHolidayFr(DateDay)
    nda = Weekday(DateDay, vbMonday)
    If (nda = 7 Or phl = 1) Then
        res = 0
    Else
        res = 1
    End If
    WorkableDay = res
End Function


'-------------------------------------------------
' The function NextWorkingDay returns the date in parameter if it's a Working Day and not a public holiday or the next Working Day if not.
' If there is no DateDay parameter, the function returns the next Working Day for the current date.
'-------------------------------------------------

Function NextWorkingDay(Optional DateDay As Date) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    Dim res As Date
    Dim wda As Byte, wda1 As Byte, wda2 As Byte, wda3 As Byte, wda4 As Byte
    wda = WorkingDay(DateDay)
    wda1 = WorkingDay(DateDay + 1)
    wda2 = WorkingDay(DateDay + 2)
    wda3 = WorkingDay(DateDay + 3)
    wda4 = WorkingDay(DateDay + 4)
    If wda = 1 Then
                    res = DateDay
        ElseIf wda1 = 1 Then
                        res = DateDay + 1
            ElseIf wda2 = 1 Then
                            res = DateDay + 2
                ElseIf wda3 = 1 Then
                                res = DateDay + 3
                    ElseIf wda4 = 1 Then
                                    res = DateDay + 4
    End If
    NextWorkingDay = res
End Function



'-------------------------------------------------
' The function NextWorkableDay returns the date in parameter if it's a Workable Day and not a public holiday or the next Workable Day if not.
' If there is no DateDay parameter, the function returns the next Workable Day for the current date.
'-------------------------------------------------

Function NextWorkableDay(Optional DateDay As Date) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    Dim res As Date
    Dim wda As Byte, wda1 As Byte, wda2 As Byte, wda3 As Byte
    wda = WorkableDay(DateDay)
    wda1 = WorkableDay(DateDay + 1)
    wda2 = WorkableDay(DateDay + 2)
    wda3 = WorkableDay(DateDay + 3)
    If wda = 1 Then
                    res = DateDay
        ElseIf wda1 = 1 Then
                        res = DateDay + 1
            ElseIf wda2 = 1 Then
                            res = DateDay + 2
                ElseIf wda3 = 1 Then
                                res = DateDay + 3
    End If
    NextWorkableDay = res
End Function
                    
                    
'-------------------------------------------------
' The function PrevWorkableDay returns the previous Workable Day for the date in parameter.
' If there is no DateDay parameter, the function returns the previous Workable Day for the current date.
'-------------------------------------------------

Function PrevWorkableDay(Optional DateDay As Date) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    Dim res As Date
    Dim wda1 As Byte, wda2 As Byte, wda3 As Byte
    wda1 = WorkableDay(DateDay - 1)
    wda2 = WorkableDay(DateDay - 2)
    wda3 = WorkableDay(DateDay - 3)
    If wda1 = 1 Then
                    res = DateDay - 1
        ElseIf wda2 = 1 Then
                        res = DateDay - 2
            ElseIf wda3 = 1 Then
                            res = DateDay - 3
    End If
    PrevWorkableDay = res
End Function



'-------------------------------------------------
' The function PrevWorkingDay returns the previous Working Day for the date in parameter.
' If there is no DateDay parameter, the function returns the previous Working Day for the current date.
'-------------------------------------------------

Function PrevWorkingDay(Optional DateDay As Date) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    Dim res As Date
    Dim wda1 As Byte, wda2 As Byte, wda3 As Byte, wda4 As Byte
    wda1 = WorkableDay(DateDay - 1)
    wda2 = WorkableDay(DateDay - 2)
    wda3 = WorkableDay(DateDay - 3)
    wda4 = WorkableDay(DateDay - 4)
    If wda1 = 1 Then
                    res = DateDay - 1
        ElseIf wda2 = 1 Then
                        res = DateDay - 2
            ElseIf wda3 = 1 Then
                            res = DateDay - 3
                ElseIf wda4 = 1 Then
                                res = DateDay - 4
    End If
    PrevWorkingDay = res
End Function



'-------------------------------------------------
' The function NextPublicHoliday returns the next public holiday for the date in parameter.
' If there is no DateDay parameter, the function returns the next public holiday for the current date.
'-------------------------------------------------

Function NextPublicHoliday(Optional DateDay As Date) As Date
    If DateDay = "00:00:00" Then DateDay = Date
    Dim res As Date
    Dim i As Integer
    For i = 1 To 365 Step 1  'Normally, it is impossible to go as far as 365
        If PublicHolidayFr(DateDay + i) = 1 Then Exit For
    Next i
    res = DateDay + i
    NextPublicHoliday = res
End Function

