'--------------------------------------
' Creation date : 27/04/2017  (fr)
' Last update :   27/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

' ---------------------------------------------------------
' The function WbIsOpen() returns True if the workbook is open
' ---------------------------------------------------------

Function WbIsOpen(Wb As String) As Boolean
    
    Dim IsOpen As Workbook
    Set IsOpen = Nothing
    On Error Resume Next
    Set IsOpen = Workbooks(Wb)
    On Error GoTo 0
    If IsOpen Is Nothing Then
        WbIsOpen = False
    Else
        WbIsOpen = True
    End If
    
End Function
