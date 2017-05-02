'--------------------------------------
' Creation date : 02/05/2017  (fr)
' Last update :   02/05/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit


' --------------------------------------------------------------------------------
' The function OpenWorkbook() returns false if we can not open the workbook
' --------------------------------------------------------------------------------

Function OpenWorkbook(WorkbookName As String, WorkbookPath As String, Optional Reseau As String) As Boolean
    
    If IsMissing(Reseau) Or Reseau = "" Then Reseau = "NO"
    Dim ObjFso As Object
    Set ObjFso = CreateObject("scripting.filesystemobject")
    'test if the workbook is already open or not
    On Error Resume Next
    Workbooks(WorkbookName).Activate
    ' attention at Err.Number if there is an error, the value is not updated if there is no more error
    If Err.Number <> 0 Then
        If ObjFso.FolderExists(WorkbookPath) Then
            ChDir WorkbookPath
            ' Chdrive is useless if you don't work with a letter (\\reseau\directory)
            If Reseau = "NO" Then
                ChDrive Left(WorkbookPath, 2)
                'ChDrive Drive
            End If
            Err.Clear
            Workbooks.Open (WorkbookName)
            If Err.Number <> 0 Then OpenWorkbook = False
            If Err.Number = 0 Then OpenWorkbook = True
        Else
            OpenWorkbook = False
        End If
    End If
    'initialize error
    'On Error GoTo 0
    'or Err.Clear
    'MsgBox Err.Number
    If Err.Number = 0 Then OpenWorkbook = True
    Set ObjFso = Nothing
    
End Function
