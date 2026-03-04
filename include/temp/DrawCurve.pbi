; =================================================================
; NODE EDITOR: ПЛАВНЫЕ U-ОБРАЗНЫЕ ЛИНИИ НА 2D DRAWING
; =================================================================

#GridSize = 20

Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro

Structure PointF : X.i : Y.i : EndStructure

Structure Node
  X.i : Y.i : w.i : h.i : color.i : Text.s
  List Ports.PointF() 
EndStructure

Structure Connection
  *fromNode.Node : *fromPort.PointF : *toNode.Node : *toPort.PointF
  ManualOffset.i : IsHovered.b
EndStructure

Global NewList Nodes.Node()
Global NewList Links.Connection()
Global *DragNode.Node = #Null, *DragPort.PointF = #Null, *DragLink.Connection = #Null
Global *ActiveSourceNode.Node = #Null, DragOffX.i, DragOffY.i

; --- РИСОВАНИЕ ПЛАВНОЙ U/S КРИВОЙ ---
Procedure DrawCurve(x1, y1, x2, y2, offset, color, side1, side2)
  Protected.f t, xt, yt, lastX = x1, lastY = y1
  Protected.f cp1x, cp1y, cp2x, cp2y
  Protected strength = 60 + Abs(offset)

  ; Определяем положение контрольных точек в зависимости от стороны выхода порта
  ; side: 1-L, 2-T, 3-R, 4-B
  Select side1
    Case 1 : cp1x = x1 - strength : cp1y = y1
    Case 2 : cp1x = x1 : cp1y = y1 - strength
    Case 3 : cp1x = x1 + strength : cp1y = y1
    Case 4 : cp1x = x1 : cp1y = y1 + strength
  EndSelect

  Select side2
    Case 1 : cp2x = x2 - strength : cp2y = y2
    Case 2 : cp2x = x2 : cp2y = y2 - strength
    Case 3 : cp2x = x2 + strength : cp2y = y2
    Case 4 : cp2x = x2 : cp2y = y2 + strength
  EndSelect

  ; Рисование сегментами
  For i = 1 To 30
    t = i / 30
    xt = (1-t)*(1-t)*(1-t)*x1 + 3*(1-t)*(1-t)*t*cp1x + 3*(1-t)*t*t*cp2x + t*t*t*x2
    yt = (1-t)*(1-t)*(1-t)*y1 + 3*(1-t)*(1-t)*t*cp1y + 3*(1-t)*t*t*cp2y + t*t*t*y2
    LineXY(lastX, lastY, xt, yt, color)
    lastX = xt : lastY = yt
  Next
EndProcedure

Procedure.i GetSide(*n.Node, *p.PointF)
  If *p\X <= 0 : ProcedureReturn 1 : ElseIf *p\Y <= 0 : ProcedureReturn 2
  ElseIf *p\X >= *n\w : ProcedureReturn 3 : ElseIf *p\Y >= *n\h : ProcedureReturn 4
  EndIf : ProcedureReturn 3
EndProcedure

Procedure ReDraw(Canvas)
  If StartDrawing(CanvasOutput(Canvas))
    Box(0, 0, OutputWidth(), OutputHeight(), $FDFDFD)
    For X = 0 To OutputWidth()-1 Step #GridSize : For Y = 0 To OutputHeight()-1 Step #GridSize : Plot(X,Y, $E0E0E0) : Next : Next
    
    ForEach Links()
      Protected c = $888888 : If Links()\IsHovered : c = $00A5FF : EndIf
      DrawCurve(Links()\fromNode\X + Links()\fromPort\X, Links()\fromNode\Y + Links()\fromPort\Y, 
                Links()\toNode\X + Links()\toPort\X, Links()\toNode\Y + Links()\toPort\Y, 
                Links()\ManualOffset, c, GetSide(Links()\fromNode, Links()\fromPort), GetSide(Links()\toNode, Links()\toPort))
    Next
    
    ForEach Nodes()
      Box(Nodes()\X, Nodes()\Y, Nodes()\w, Nodes()\h, Nodes()\color)
      DrawingMode(#PB_2DDrawing_Transparent) : DrawText(Nodes()\X+10, Nodes()\Y+10, Nodes()\Text, $FFFFFF) : DrawingMode(#PB_2DDrawing_Default)
      ForEach Nodes()\Ports() : Circle(Nodes()\X + Nodes()\Ports()\X, Nodes()\Y + Nodes()\Ports()\Y, 5, $00FF00) : Next
    Next
    
    If *DragPort : LineXY(*ActiveSourceNode\X + *DragPort\X, *ActiveSourceNode\Y + *DragPort\Y, GetGadgetAttribute(0, #PB_Canvas_MouseX), GetGadgetAttribute(0, #PB_Canvas_MouseY), $CCCCCC) : EndIf
    StopDrawing()
  EndIf
EndProcedure

Procedure CreateNewNode(X, Y, t.s)
  *n.Node = AddElement(Nodes())
  *n\X = Round(X/20, #PB_Round_Nearest)*20 : *n\Y = Round(Y/20, #PB_Round_Nearest)*20
  *n\w = 120 : *n\h = 80 : *n\Text = t : *n\color = $2D2D2D
  AddElement(*n\Ports()) : *n\Ports()\X = 0 : *n\Ports()\Y = 40   ; L
  AddElement(*n\Ports()) : *n\Ports()\X = 120 : *n\Ports()\Y = 40 ; R
  AddElement(*n\Ports()) : *n\Ports()\X = 60 : *n\Ports()\Y = 0   ; T
  AddElement(*n\Ports()) : *n\Ports()\X = 60 : *n\Ports()\Y = 80  ; B
EndProcedure

OpenWindow(0, 0, 0, 1000, 750, "Node Editor: U-Curves & S-Curves", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 750)
CreateNewNode(400, 400, "Node A") : CreateNewNode(400, 150, "Node B")

Repeat
  Event = WaitWindowEvent()
  mx = GetGadgetAttribute(0, #PB_Canvas_MouseX) : my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
  Select EventType()
    Case #PB_EventType_MouseMove
      If *DragLink
        *DragLink\ManualOffset = (mx - (*DragLink\fromNode\X + *DragLink\fromPort\X))
      ElseIf *DragNode
        *DragNode\X = Round((mx-DragOffX)/20, #PB_Round_Nearest)*20 : *DragNode\Y = Round((my-DragOffY)/20, #PB_Round_Nearest)*20
      EndIf
      ; Подсветка
      ForEach Links()
        midX = (Links()\fromNode\X + Links()\fromPort\X + Links()\toNode\X + Links()\toPort\X) / 2
        midY = (Links()\fromNode\Y + Links()\fromPort\Y + Links()\toNode\Y + Links()\toPort\Y) / 2
        Links()\IsHovered = Bool(Abs(mx - midX) < 20 And Abs(my - midY) < 20)
      Next
      ReDraw(0)
    Case #PB_EventType_LeftButtonDown
      ForEach Links() : If Links()\IsHovered : *DragLink = @Links() : Break 2 : EndIf : Next
      ForEach Nodes()
        ForEach Nodes()\Ports() : If Abs(mx - (Nodes()\X + Nodes()\Ports()\X)) < 10 And Abs(my - (Nodes()\Y + Nodes()\Ports()\Y)) < 10 : *DragPort = @Nodes()\Ports() : *ActiveSourceNode = @Nodes() : Break 2 : EndIf : Next
        If mx > Nodes()\X And mx < Nodes()\X + Nodes()\w And my > Nodes()\Y And my < Nodes()\Y + Nodes()\h : *DragNode = @Nodes() : DragOffX = mx - Nodes()\X : DragOffY = my - Nodes()\Y : MoveElement(Nodes(), #PB_List_Last) : Break : EndIf
      Next
    Case #PB_EventType_LeftButtonUp
      If *DragPort : ForEach Nodes() : If @Nodes() <> *ActiveSourceNode : ForEach Nodes()\Ports() : If Abs(mx - (Nodes()\X + Nodes()\Ports()\X)) < 10 : AddElement(Links()) : Links()\fromNode = *ActiveSourceNode : Links()\fromPort = *DragPort : Links()\toNode = @Nodes() : Links()\toPort = @Nodes()\Ports() : EndIf : Next : EndIf : Next : EndIf
      *DragNode = #Null : *DragPort = #Null : *DragLink = #Null : ReDraw(0)
  EndSelect
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 27
; FirstLine = 20
; Folding = ----
; EnableXP
; DPIAware