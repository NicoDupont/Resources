'--------------------------------------
' Creation date : 12/04/2017  (fr)
' Last update :   13/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

' ---------------------------------------------------------
' The function FileExist() / FileExistFso() returns True if the file exist
' You must set a reference : "Microsoft Scripting Runtime" to use Fso
' ---------------------------------------------------------

Function FileExist(Path As String) As Boolean

    If Dir(Path) = "" Then
        FileExist = False
    Else
        FileExist = True
    End If
    
End Function


Function FileExistFso(Path As String) As Boolean

    'Dim ObjFso As Scripting.FileSystemObject
    'Set ObjFso = New Scripting.FileSystemObject
    Dim ObjFso As Object
    Set ObjFso = CreateObject("scripting.filesystemobject")
    If ObjFso.FileExists(Path) = False Then
        FileExistFso = False
    Else
        FileExistFso = True
    End If
    Set ObjFso = Nothing
    
End Function
