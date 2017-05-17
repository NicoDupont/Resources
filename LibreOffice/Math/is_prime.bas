'--------------------------------------
' Creation date : 17/05/2017  (fr)
' Last update :   17/05/2017
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on LibreOffice 5.3.3.2 Ubuntu 16.04LTS
'--------------------------------------

Option Explicit

'-------------------------------------------------
' The function IsPrime() returns 1 if the number is a prime number. if not 0.
'-------------------------------------------------

Function IsPrime(Nb As Single) As Boolean

    IsPrime = False
    Dim i As Long
    If Nb < 2 Or (Nb <> 2 And Nb Mod 2 = 0) Or (Nb <> Int(Nb)) Then Exit Function
    For i = 3 To Sqr(Nb) Step 2
        If Nb Mod i = 0 Then Exit Function
    Next
    IsPrime = True

End Function
