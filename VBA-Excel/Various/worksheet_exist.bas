'--------------------------------------
' Creation date : 27/04/2017  (fr)
' Last update :   27/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

' ---------------------------------------------------------
' The function Sheetexist() returns True if the worksheet exist on the workbook
' ---------------------------------------------------------

Function SheetExist(WSheet As String) As Boolean

    Dim res As Byte
    res = 0
    On Error Resume Next
    res = Sheets(WSheet).Index
    On Error GoTo 0
    If res > 0 Then
        SheetExist = True
    Else
        SheetExist = False
    End If

End Function
