;
; https://www.purebasic.fr/english/viewtopic.php?f=12&t=75829&sid=33c9ab42cd7bd8ad2e4494ad235e4568
; Он находит выпуклую оболочку, в которой можно разместить набор точек, вогнутый многоугольник и т. Д.
;

Macro CopyPoint(cpp1,cpp2)
  cpp2\x=cpp1\x
  cpp2\y=cpp1\y
EndMacro

Macro SwapPoints(spp1,spp2)
  slave.PointD
  slave\x = spp1\x
  spp1\x = spp2\x
  spp2\x = slave\x
 
  slave\y = spp1\y
  spp1\y = spp2\y
  spp2\y = slave\y
EndMacro

Structure PointD
  x.d
  y.d
EndStructure


Structure CHPointD
  x.d
  y.d
  d.d
EndStructure

Procedure.d ccw(*p1.CHPointD, *p2.CHPointD, *p3.CHPointD)
  ProcedureReturn ((*p2\x - *p1\x)*(*p3\y - *p1\y)) - ((*p2\y - *p1\y)*(*p3\x - *p1\x))
EndProcedure

Procedure.i ComputeConvexHull(pnts.i,Array opnt.PointD(1),Array chpnt.PointD(1))
 
  Dim tempchpnt.CHPointD(pnts)
  For a = 1 To pnts
    CopyPoint(opnt(a),tempchpnt(a))
  Next
 
  SortStructuredArray(tempchpnt(), #PB_Sort_Descending, OffsetOf(CHPointD\y), #PB_Double, 1, pnts)
 
  For a = 2 To pnts
    tempchpnt(a)\d = ATan2(tempchpnt(1)\y - tempchpnt(a)\y, tempchpnt(1)\x - tempchpnt(a)\x)
  Next
 
  SortStructuredArray(tempchpnt(), #PB_Sort_Descending, OffsetOf(CHPointD\d), #PB_Double, 2, pnts)
 
  tempchpnt(0)\x=tempchpnt(pnts)\x : tempchpnt(0)\y=tempchpnt(pnts)\y
 
  M = 1
  For i = 2 To pnts
    While ccw(tempchpnt(M-1), tempchpnt(M), tempchpnt(i)) <= 0
      If M > 1
        M - 1
        Continue
      Else
        If i = pnts
          Break
        Else
          i + 1
        EndIf
      EndIf
    Wend
   
    M + 1
    SwapPoints( tempchpnt(M) , tempchpnt(i) )
  Next i
 
  ReDim chpnt(M)
  For p = 1 To M
    CopyPoint(tempchpnt(p),chpnt(p))
  Next p
  ProcedureReturn M
 
EndProcedure

;
; demo
; Нажмите ПРОБЕЛ для перехода или ESCAPE для выхода.
;

iw = 1000
ih = 800
img = CreateImage(#PB_Any,iw,ih)
win = OpenWindow(#PB_Any,0,0,iw,ih,"Convex hull",#PB_Window_ScreenCentered)
imgad = ImageGadget(#PB_Any,0,0,iw,ih,ImageID(img))
space = 5
AddKeyboardShortcut(win,#PB_Shortcut_Space,space)
esc = 6
AddKeyboardShortcut(win,#PB_Shortcut_Escape,esc)


Repeat
 
  pnts = Random(40,4)
  Dim pnt.PointD(pnts)
  For p = 1 To pnts
    pnt(p)\x = Random(iw-50,50)
    pnt(p)\y = Random(ih-50,50)
  Next p
 
  Dim chpnt.PointD(1)
  convex_hull_pnts = ComputeConvexHull(pnts,pnt(),chpnt())
 
 
  StartDrawing(ImageOutput(img))
  Box(0,0,OutputWidth(),OutputHeight(),#Black)
  For p = 1 To pnts
    Circle(pnt(p)\x,pnt(p)\y,5,#Red)
  Next p
  StopDrawing()
  SetGadgetState(imgad,ImageID(img))
  Repeat : Until WaitWindowEvent(5)=#PB_Event_Menu
  If EventMenu()=esc : Break : EndIf
 
 
  StartDrawing(ImageOutput(img))
  For p = 1 To convex_hull_pnts
    p2=p+1
    If p=convex_hull_pnts
      p2=1
    EndIf
    LineXY(chpnt(p)\x,chpnt(p)\y,chpnt(p2)\x,chpnt(p2)\y,#Green)
  Next p
  StopDrawing()
  SetGadgetState(imgad,ImageID(img))
  Repeat : Until WaitWindowEvent(5)=#PB_Event_Menu
  If EventMenu()=esc : Break : EndIf
ForEver
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP