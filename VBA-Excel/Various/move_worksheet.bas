'--------------------------------------
' Creation date : 03/05/2017  (fr)
' Last update :   03/05/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

option explicit

' ---------------------------------------------------------
' The function MvWs() returns True if the worksheet is moved
' For target : you can use an index number or a name
' ---------------------------------------------------------

Function MvWs(name As String, Optional Targetws As Variant, Optional wb As Workbook) As Boolean

    If IsMissing(wb) Or wb Is Nothing Then Set wb = ThisWorkbook
    If IsMissing(Targetws) Or IsEmpty(Targetws) Then Targetws = wb.Worksheets.Count
    On Error Resume Next
    ' You can use before or after
    wb.Worksheets(name).Move after:=wb.Worksheets(Targetws)
    If Err.Number = 0 Then
        MvWs = True
    Else
        MvWs = False
    End If

End Function
