'--------------------------------------
' Creation date : 27/04/2017  (fr)
' Last update :   27/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

' --------------------------------------------------------------------------------
' The function DirectoryExist() returns true if the folder exist
' --------------------------------------------------------------------------------

Function CreateFolder(Path As String) As Boolean

    MkDir (Path)
    CreateFolder = True
    
End Function


Function DirectoryExist(Path As String) As Boolean

'    If Right(Path, 1) <> "\" Then
'        Path = Path & "\"
'    End If

    If Len(Dir(Path, vbDirectory)) > 0 Then
        DirectoryExist = True
    Else
        DirectoryExist = False
    End If

End Function


' ----------------------------
' With FSO
' ----------------------------

Function DirectoryExistFso(Path As String) As Boolean

    'Dim ObjFso As Scripting.FileSystemObject
    'Set ObjFso = New Scripting.FileSystemObject
    Dim ObjFso As Object
    Set ObjFso = CreateObject("scripting.filesystemobject")
    
'    If Right(Path, 1) <> "\" Then
'        Path = Path & "\"
'    End If
    
    If ObjFso.FolderExists(Path) = False Then
        DirectoryExistFso = False
    Else
        DirectoryExistFso = True
    End If

End Function
