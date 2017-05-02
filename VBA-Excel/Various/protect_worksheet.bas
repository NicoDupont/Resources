'--------------------------------------
' Creation date : 02/05/2017  (fr)
' Last update :   02/05/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

' ---------------------------------------------------------
' The function ProtectWs() returns True if the worksheet is protected (with a password)
' ---------------------------------------------------------

Function ProtectWs(name As String, Optional pass As String, Optional wb As Workbook) As Boolean

    If IsMissing(wb) Or wb Is Nothing Then Set wb = ThisWorkbook
    If IsMissing(pass) Or pass = "" Then pass = "testpass"  '"DefaultPassword?"
    On Error Resume Next
    wb.Sheets(name).protect Password:=pass
    If Err.Number = 0 Then
        ProtectWs = True
    Else
        ProtectWs = False
    End If

End Function


' ---------------------------------------------------------
' The function UnProtectWs() returns True if the worksheet is unprotected (password is needed)
' ---------------------------------------------------------

Function UnProtectWs(name As String, Optional pass As String, Optional wb As Workbook) As Boolean

    If IsMissing(wb) Or wb Is Nothing Then Set wb = ThisWorkbook
    If IsMissing(pass) Or pass = "" Then pass = "testpass"  '"DefaultPassword?"
    On Error Resume Next
    wb.Sheets(name).unprotect Password:=pass
    If Err.Number = 0 Then
        UnProtectWs = True
    Else
        UnProtectWs = False
    End If

End Function
