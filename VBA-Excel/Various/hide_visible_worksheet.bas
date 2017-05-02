'--------------------------------------
' Creation date : 02/05/2017  (fr)
' Last update :   02/05/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

' ---------------------------------------------------------
' The function HideWs() returns True if the worksheet is hided
' The worksheet can be display by a rigth click
' ---------------------------------------------------------

Function HideWs(name As String, Optional wb As Workbook) As Boolean
    
    If IsMissing(wb) Or wb Is Nothing Then Set wb = ThisWorkbook
    On Error Resume Next
    wb.Sheets(name).Visible = False
    If Err.Number = 0 Then
        HideWs = True
    Else
        HideWs = False
    End If

End Function


' ---------------------------------------------------------
' The function VHiddenWs() returns True if the worksheet is very hided
' The worksheet can not be display by a rigth click
' ---------------------------------------------------------

Function VHiddenWs(name As String, Optional wb As Workbook) As Boolean
    
    If IsMissing(wb) Or wb Is Nothing Then Set wb = ThisWorkbook
    On Error Resume Next
    wb.Sheets(name).Visible = xlVeryHidden
    If Err.Number = 0 Then
        VHiddenWs = True
    Else
        VHiddenWs = False
    End If

End Function


' ---------------------------------------------------------
' The function VisibleWs() returns True if the worksheet is visible
' ---------------------------------------------------------

Function VisibleWs(name As String, Optional wb As Workbook) As Boolean
    
    If IsMissing(wb) Or wb Is Nothing Then Set wb = ThisWorkbook
    On Error Resume Next
    wb.Sheets(name).Visible = True
    If Err.Number = 0 Then
        VisibleWs = True
    Else
        VisibleWs = False
    End If

End Function
