'--------------------------------------
' Creation date : 26/04/2017  (fr)
' Last update :   26/04/2017  (fr)
' Author(s) : Nicolas DUPONT
' Contributor(s) :
' Tested on Excel 2010
'--------------------------------------

Option Explicit

'-------------------
' Cube or rectangle :
'-------------------
'-------------------------------------------------
' The function SquarePerimeter() returns the perimeter of a cube or a rectangle
'-------------------------------------------------

Function SquarePerimeter(La As Double, Lo As Double) As Double
    SquarePerimeter = (La + Lo) * 2
End Function


'-------------------------------------------------
' The function SquareArea() returns the area of a cube or a rectangle
'-------------------------------------------------

Function SquareArea(La As Double, Lo As Double) As Double
    SquareArea = La * Lo
End Function


'-------------------------------------------------
' The function VolumeCube() returns the volume of a cube or a rectangle
'-------------------------------------------------

Function VolumeCube(La As Double, Lo As Double, H As Double) As Double
    VolumeCube = La * Lo * H
End Function


'---------
' Circle :
'---------

'-------------------------------------------------
' The function CirclePerimeter() returns the perimeter of a circle
'-------------------------------------------------

Function CirclePerimeter(R As Double) As Double
    CirclePerimeter = 2 * R * Application.Pi()
End Function


'-------------------------------------------------
' The function CircleArea() returns the area of a circle
'-------------------------------------------------

Function CircleArea(R As Double) As Double
    CircleArea = Application.Pi() * (R ^ 2)
End Function


'-------------------------------------------------
' The function VolumeSphere() returns the volume of a sphere
'-------------------------------------------------

Function VolumeSphere(R As Double) As Double
    VolumeSphere = (4 * Application.Pi() * (R ^ 3)) / 3
End Function
