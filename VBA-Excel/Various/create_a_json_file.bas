'--------------------------------------
' Creation date : 12/04/2017  (fr)
' Last update :   12/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

'--------------------------------
' A procedure to create a simple json file without special struture
'--------------------------------

Sub range_to_json()

    Dim fs As Object
    Dim jsonfile
    Dim rangetoexport As Range
    Dim rowcounter As Long
    Dim columncounter As Long
    Dim linedata As String

    Set rangetoexport = Sheets("test").Range("a1:e3")

    Set fs = CreateObject("Scripting.FileSystemObject")

    Set jsonfile = fs.CreateTextFile("PathToYourJson.json", True)

    linedata = "{""events"": ["

    jsonfile.WriteLine linedata

    ' for each row except column name
    For rowcounter = 2 To rangetoexport.Rows.Count
        linedata = ""
        'for each column
        For columncounter = 1 To rangetoexport.Columns.Count
            linedata = linedata & """" & rangetoexport.Cells(1, columncounter) & """" & ":" & """" & rangetoexport.Cells(rowcounter, columncounter) & """" & ","
        Next
        linedata = Left(linedata, Len(linedata) - 1)
        If rowcounter = rangetoexport.Rows.Count Then
            linedata = "{" & linedata & "}"
        Else
            linedata = "{" & linedata & "},"
        End If

        jsonfile.WriteLine linedata
    Next

    linedata = "]}"
    jsonfile.WriteLine linedata
    jsonfile.Close

    Set fs = Nothing

End Sub


'--------------------------------
' For a personnal project.
' I adapted the code to get a structure that could be read by the framework TimelineJs in a web browser.
' But I have a problem : the encoding is not in utf-8 ..
'--------------------------------

' json with special struture for TimelineJs
Sub range_to_json_timelinejs()

    Dim fs As Object
    Dim jsonfile
    Dim rangetoexport As Range

    Dim rowcounter As Long
    Dim columncounter As Long
    Dim linedata As String

    ' here the range of your Data. Don't change the number of column, or you need to adapt that script
    Set rangetoexport = Range("a1:e3")

    Set fs = CreateObject("Scripting.FileSystemObject")

    Set jsonfile = fs.CreateTextFile("PathToYourJsonFile.json", True, False)

    linedata = "{""events"": ["
    jsonfile.WriteLine linedata

    Dim namecol1 As String, namecol2 As String, namecol3 As String, namecol4 As String, namecol5 As String
    Dim valcol1 As String, valcol2 As String, valcol3 As String, valcol4 As String, valcol5 As String

    namecol1 = rangetoexport.Cells(1, 1)
    namecol2 = rangetoexport.Cells(1, 2)
    namecol3 = rangetoexport.Cells(1, 3)
    namecol4 = rangetoexport.Cells(1, 4)
    namecol5 = rangetoexport.Cells(1, 5)

    ' for each row except column name
    For rowcounter = 2 To rangetoexport.Rows.Count

        linedata = ""

        valcol1 = rangetoexport.Cells(rowcounter, 1)
        valcol2 = rangetoexport.Cells(rowcounter, 2)
        valcol3 = rangetoexport.Cells(rowcounter, 3)
        valcol4 = rangetoexport.Cells(rowcounter, 4)
        valcol5 = rangetoexport.Cells(rowcounter, 5)

        linedata = """start_date"": {"
        'col1
        linedata = linedata & """" & namecol1 & """" & ":" & """" & valcol1 & """" & ","
        'col2
        linedata = linedata & """" & namecol2 & """" & ":" & """" & valcol2 & """" & ","
        'col3
        linedata = linedata & """" & namecol3 & """" & ":" & """" & valcol3 & """" & "}, ""text"": {"
        'col4
        linedata = linedata & """" & namecol4 & """" & ":" & """" & valcol4 & """" & ","
        'col5
        linedata = linedata & """" & namecol5 & """" & ":" & """" & valcol5 & """" & "}" & vbCrLf


        If rowcounter = rangetoexport.Rows.Count Then
            linedata = "{" & linedata & "}"
        Else
            linedata = "{" & linedata & "},"
        End If

        jsonfile.WriteLine linedata
    Next


    linedata = "]}"
    jsonfile.WriteLine linedata
    jsonfile.Close

    Set fs = Nothing


End Sub



'--------------------------------
' I modified the code to write directly in utf-8 with another method.
' You must activate a "Reference" : Microsoft ActiveX Data Objects (ADO)
' Inspiration (Thanks for the help) : http://developer.rhino3d.com/guides/rhinoscript/read-write-utf8/
'--------------------------------

Sub range_to_json_timelinejs_utf8()

    Dim fs As Object
    Dim jsonfile
    Dim rangetoexport As Range

    Dim rowcounter As Long
    Dim columncounter As Long
    Dim linedata As String

    ' here the range of your Data. Don't change the number of column, or you need to adapt that script
    Set rangetoexport = Range("a1:e4")

    Set fs = CreateObject("ADODB.Stream")
    fs.Charset = "utf-8"
    fs.Open

    linedata = "{""events"": ["
    fs.WriteText "" & linedata & ""

    Dim namecol1 As String, namecol2 As String, namecol3 As String, namecol4 As String, namecol5 As String
    Dim valcol1 As String, valcol2 As String, valcol3 As String, valcol4 As String, valcol5 As String

    namecol1 = rangetoexport.Cells(1, 1)
    namecol2 = rangetoexport.Cells(1, 2)
    namecol3 = rangetoexport.Cells(1, 3)
    namecol4 = rangetoexport.Cells(1, 4)
    namecol5 = rangetoexport.Cells(1, 5)

    ' for each row except column name
    For rowcounter = 2 To rangetoexport.Rows.Count
        MsgBox "ligne : " & rowcounter

        linedata = ""

        valcol1 = rangetoexport.Cells(rowcounter, 1)
        valcol2 = rangetoexport.Cells(rowcounter, 2)
        valcol3 = rangetoexport.Cells(rowcounter, 3)
        valcol4 = rangetoexport.Cells(rowcounter, 4)
        valcol5 = rangetoexport.Cells(rowcounter, 5)

        linedata = """start_date"": {"
        'col1
        linedata = linedata & """" & namecol1 & """" & ":" & """" & valcol1 & """" & ","
        'col2
        linedata = linedata & """" & namecol2 & """" & ":" & """" & valcol2 & """" & ","
        'col3
        linedata = linedata & """" & namecol3 & """" & ":" & """" & valcol3 & """" & "}, ""text"": {"
        'col4
        linedata = linedata & """" & namecol4 & """" & ":" & """" & valcol4 & """" & ","
        'col5
        linedata = linedata & """" & namecol5 & """" & ":" & """" & valcol5 & """" & "}" & vbCrLf


        If rowcounter = rangetoexport.Rows.Count Then
            linedata = "{" & linedata & "}"
        Else
            linedata = "{" & linedata & "},"
        End If

        fs.WriteText linedata
    Next


    linedata = "]}"
    fs.WriteText linedata

    fs.SaveToFile "PathToYourJsonFile.json", 2

    Set fs = Nothing

End Sub
