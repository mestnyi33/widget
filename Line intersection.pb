Structure SPoint
  x.i
  y.i
EndStructure

Structure SLine
  p.SPoint[2]
  color.i
EndStructure

Structure SIntersection
  p.SPoint
  Color.i
  Size.i
EndStructure

#W = 512
#H = 384

Global NewList Lines.SLine()
Global NewList Intersections.SIntersection()

AddElement(Lines())
Lines()\p[0]\x = 10
Lines()\p[0]\y = 10
Lines()\p[1]\x = 100
Lines()\p[1]\y = 100
Lines()\color = #Red

AddElement(Lines())
Lines()\p[0]\x = 100
Lines()\p[0]\y = 10
Lines()\p[1]\x = 200
Lines()\p[1]\y = 100
Lines()\color = #Blue

AddElement(Lines())
Lines()\p[0]\x = 300
Lines()\p[0]\y = 10
Lines()\p[1]\x = 120
Lines()\p[1]\y = 100
Lines()\color = #Green

For I = 0 To 3
  AddElement(Lines())
  Lines()\p[0]\x = Random(512)
  Lines()\p[0]\y = Random(384)
  Lines()\p[1]\x = Random(512)
  Lines()\p[1]\y = Random(384)
  Lines()\color = RGB(Random(255), Random(255), Random(255))
Next

Procedure Max(A, B)
  If A > B
    ProcedureReturn A
  EndIf
  ProcedureReturn B
EndProcedure

Procedure Min(A, B)
  If A < B
    ProcedureReturn A
  EndIf
  ProcedureReturn B
EndProcedure

Procedure PointDistance(*a.SPoint, *b.SPoint)
  xd = Abs(*a\x-*b\x)
  yd = Abs(*a\y-*b\y)
  ProcedureReturn Sqr(xd*xd + yd*yd)
EndProcedure

Procedure Repaint()
  CreateImage(0, WindowWidth(0), WindowHeight(0))
  StartDrawing(ImageOutput(0))
    Box(0, 0, WindowWidth(0), WindowHeight(0), #White)
    ForEach Lines()
      LineXY(Lines()\p[0]\x, Lines()\p[0]\y, Lines()\p[1]\x, Lines()\p[1]\y, Lines()\color)
    Next
    ForEach Intersections()
      Circle(Intersections()\p\x, Intersections()\p\y, Intersections()\Size, Intersections()\Color)
    Next
  StopDrawing()
  StartDrawing(WindowOutput(0))
    DrawImage(ImageID(0), 0, 0)
  StopDrawing()
EndProcedure

Procedure FindClosestLineEnd(*p.SPoint)
  M.d = 1000000
  For I = 0 To 1
    ForEach Lines()
      D = PointDistance(@Lines()\p[I], *p)
      If D < M
        M = D
        *r = @Lines()\p[I]
      EndIf
    Next
  Next
  ProcedureReturn *R
EndProcedure

Procedure LineIntersection(*L1.SLine, *L2.SLine, *Cross.SPoint)
  A1 = *L1\p[1]\y - *L1\p[0]\y
  B1 = *L1\p[0]\x - *L1\p[1]\x
  C1 = A1 * *L1\p[0]\x + B1 * *L1\p[0]\y
  
  A2 = *L2\p[1]\y - *L2\p[0]\y
  B2 = *L2\p[0]\x - *L2\p[1]\x
  C2 = A2 * *L2\p[0]\x + B2 * *L2\p[0]\y
  
  det.d = A1*B2 - A2*B1
  If det = 0
    ProcedureReturn 0 ; No intersection
  Else
    *cross\x = (B2*C1 - B1*C2)/det
    *Cross\y = (A1*C2 - A2*C1)/det
    
    With *L1 ; On *L1 line segment?
      If Min(\p[0]\x, \p[1]\x) <= *cross\x And Max(\p[0]\x, \p[1]\x) >= *cross\x
        If Min(\p[0]\y, \p[1]\y) <= *cross\y And Max(\p[0]\y, \p[1]\y) >= *cross\y
    EndWith
    With *L2 ; On *L2 line segment?
          If Min(\p[0]\x, \p[1]\x) <= *cross\x And Max(\p[0]\x, \p[1]\x) >= *cross\x
            If Min(\p[0]\y, \p[1]\y) <= *cross\y And Max(\p[0]\y, \p[1]\y) >= *cross\y
    EndWith
              ProcedureReturn 1
            EndIf
         EndIf
      EndIf
    EndIf
    
    ProcedureReturn 2 ; Lines intersect, but line segments do not
  EndIf
EndProcedure

Procedure UpdateIntersections()
  ClearList(Intersections())
  Protected P.SPoint
  Protected NewList LinesCopy.SLine()
  
  CopyList(Lines(), LinesCopy())
  
  ForEach LinesCopy()
    ForEach Lines()
      If ListIndex(Lines()) <> ListIndex(LinesCopy())
          i = LineIntersection(Lines(), LinesCopy(), @P)
          If i
            AddElement(Intersections())
            Intersections()\p = P
            Intersections()\Color = RGB(255, 127*(i-1), 127*(i-1))
            If i = 1
              Intersections()\Size = 3
            Else
              Intersections()\Size = 2
            EndIf
          EndIf
      EndIf
    Next
  Next
EndProcedure

OpenWindow(0, 0, 0, #W, #H, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)


Repeat
  Select WaitWindowEvent()
    Case #WM_LBUTTONDOWN
      drag = 1
      mouse.SPoint\x = WindowMouseX(0)
      mouse.SPoint\y = WindowMouseY(0)
      *dragpoint.SPoint = FindClosestLineEnd(mouse)
    Case #WM_LBUTTONUP
      drag = 0
    Case #WM_MOUSEMOVE
      If drag
        *dragpoint\x = WindowMouseX(0)
        *dragpoint\y = WindowMouseY(0)
        UpdateIntersections()
        Repaint()
      EndIf
    Case #PB_Event_Repaint
        Repaint()
    Case #PB_Event_CloseWindow
      Break
  EndSelect
ForEver

; IDE Options = PureBasic 5.72 (Windows - x64)
; Folding = ----
; EnableXP