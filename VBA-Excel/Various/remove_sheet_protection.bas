'--------------------------------------
' Creation date : 19/04/2017  (fr)
' Last update :   19/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

'-------------------------------------------------
' Don't ask me how this function work..
'-------------------------------------------------

Sub RemoveSheetProtection() 
	Dim a, b, c, d, e, f, g, h, i, j, k, l As Integer 
		On Error Resume Next 
		For a = 65 To 66 
			For b = 65 To 66 
				For c = 65 To 66 
					For d = 65 To 66 
						For e = 65 To 66 
							For f = 65 To 66 
								For g = 65 To 66 
									For h = 65 To 66 
										For i = 65 To 66 
											For j = 65 To 66 
												For k = 65 To 66 
												For l = 32 To 126 
													ActiveSheet.Unprotect Chr(a) & Chr(b) & Chr(c) & Chr(d) & Chr(e) & Chr(f) & Chr(g) & Chr(h) & Chr(i) & Chr(j) & Chr(k) & Chr(l) 
													If ActiveSheet.ProtectContents = False Then 
														MsgBox "Protection of the sheet has been successfully removed !" & Chr(10) & Chr(10) & "The characters that have achieved this feat are :" & Chr(10) & Chr(10) & Chr(a) & Chr(b) & Chr(c) & Chr(d) & Chr(e) & Chr(f) & Chr(g) & Chr(h) & Chr(i) & Chr(j) & Chr(k) & Chr(l), vbInformation, "It's Done !" 
														Exit Sub 
													End If 
												Next 
											Next 
										Next 
									Next 
								Next 
							Next 
						Next 
					Next 
				Next 
			Next 
		Next 
	Next 
End Sub
