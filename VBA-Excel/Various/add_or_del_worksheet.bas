'--------------------------------------
' Creation date : 02/05/2017  (fr)
' Last update :   02/05/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

' ---------------------------------------------------------
' The function DelWorksheet() returns True if the worksheet is deleted
' ---------------------------------------------------------

Function DelWorksheet(name As String, Optional wb As Workbook) As Boolean

    If IsMissing(wb) Or wb Is Nothing Then Set wb = ThisWorkbook
    Application.DisplayAlerts = False
    On Error Resume Next
    wb.Sheets(name).Delete
    Application.DisplayAlerts = True
    If Err.Number = 0 Then
        DelWorksheet = True
    Else
        DelWorksheet = False
    End If

End Function

' ---------------------------------------------------------
' The function AddWorksheet() returns True if the worksheet is added to the workbook
' ---------------------------------------------------------

Function AddWorksheet(name As String, Optional wb As Workbook) As Boolean

    If IsMissing(wb) Or wb Is Nothing Then Set wb = ThisWorkbook
    On Error Resume Next
    ' you can specify an index. here it's the last worksheet by default
    ' you can add the sheet before the last worksheet (after => before)
    wb.Sheets.Add after:=Worksheets(Worksheets.Count)
    wb.Sheets(Sheets.Count).name = name
    If Err.Number = 0 Then
        AddWorksheet = True
    Else
        AddWorksheet = False
    End If

End Function
