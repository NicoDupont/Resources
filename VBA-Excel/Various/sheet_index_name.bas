'--------------------------------------
' Creation date : 19/04/2017  (fr)
' Last update :   19/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

' --------------------------------------------------------------------------------
' The function SheetName() returns the name of the sheet relative to its number (index)
' --------------------------------------------------------------------------------

Function SheetName(Optional Number As Byte) As String

    Dim res As String
    If Number = 0 Or IsMissing(Number) Then
        res = ActiveSheet.Name
        Else
        res = Sheets(Number).Name
    End If
    SheetName = res
    
End Function


' --------------------------------------------------------------------------------
' The function SheetNumber() returns the number (index) of the sheet relative to its name
' --------------------------------------------------------------------------------

Function SheetNumber(Optional Name As String) As Byte
    
    Dim res As Byte
    If Name = "" Then
        res = ActiveSheet.Index
        Else
        res = Sheets(Name).Index
    End If
    SheetNumber = res
    
End Function
