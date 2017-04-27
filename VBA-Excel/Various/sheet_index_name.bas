'--------------------------------------
' Creation date : 19/04/2017  (fr)
' Last update :   27/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

' --------------------------------------------------------------------------------
' The function SheetName() returns the name of the sheet relative to its number
' --------------------------------------------------------------------------------

Function SheetName(Optional Number As Byte) As String

    Dim res As String
    res = ""
    On Error Resume Next
    res = Sheets(Number).Name
    On Error GoTo 0
    If res = "" Then
            res = ActiveSheet.Name
        Else
            res = Sheets(Number).Name
    End If
    SheetName = res
    
End Function


' --------------------------------------------------------------------------------
' The function SheetNumber() returns the number of the sheet relative to its name
' --------------------------------------------------------------------------------

Function SheetNumber(Optional Name As String) As Byte
    
    Dim res As Byte
    res = 0
    On Error Resume Next
    res = Sheets(Name).Index
    On Error GoTo 0
    If res = 0 Then
        res = ActiveSheet.Index
        Else
        res = Sheets(Name).Index
    End If
    SheetNumber = res
    
End Function
