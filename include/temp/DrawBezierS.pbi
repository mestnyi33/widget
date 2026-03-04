; =================================================================
; NODE EDITOR: ПЛАВНЫЕ S-ЛИНИИ НА 2D DRAWING (CANVAS)
; =================================================================

#GridSize = 20

; --- МАКРОСЫ ---
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

; --- РИСОВАНИЕ S-ОБРАЗНОЙ КРИВОЙ ---
Procedure DrawBezierS(x1, y1, x2, y2, offset, color)
  Protected.f t, xt, yt, lastX = x1, lastY = y1
  ; Контрольные точки для S-изгиба
  Protected.f cp1x = x1 + (x2 - x1) * 0.5 + offset
  Protected.f cp2x = x1 + (x2 - x1) * 0.5 + offset
  
  ; Рисуем кривую Безье через 20 сегментов
  For i = 1 To 20
    t = i / 20
    ; Формула кубического Безье упрощенная для S-образной траектории
    xt = (1-t)*(1-t)*(1-t)*x1 + 3*(1-t)*(1-t)*t*cp1x + 3*(1-t)*t*t*cp2x + t*t*t*x2
    yt = (1-t)*(1-t)*(1-t)*y1 + 3*(1-t)*(1-t)*t*y1 + 3*(1-t)*t*t*y2 + t*t*t*y2
    LineXY(lastX, lastY, xt, yt, color)
    lastX = xt : lastY = yt
  Next
EndProcedure

Procedure ReDraw(Canvas)
  If StartDrawing(CanvasOutput(Canvas))
    Box(0, 0, OutputWidth(), OutputHeight(), $FDFDFD)
    ; Сетка
    For i = 0 To OutputWidth() Step #GridSize : Line(i, 0, 1, OutputHeight(), $F2F2F2) : Next
    For i = 0 To OutputHeight() Step #GridSize : Line(0, i, OutputWidth(), 1, $F2F2F2) : Next
    
    ; Линии
    ForEach Links()
      Protected c = $AAAAAA : If Links()\IsHovered : c = $FF8800 : EndIf
      DrawBezierS(Links()\fromNode\X + Links()\fromPort\X, Links()\fromNode\Y + Links()\fromPort\Y, 
                  Links()\toNode\X + Links()\toPort\X, Links()\toNode\Y + Links()\toPort\Y, Links()\ManualOffset, c)
    Next
    
    ; Узлы
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
  *n\w = 120 : *n\h = 80 : *n\Text = t : *n\color = $333333
  AddElement(*n\Ports()) : *n\Ports()\X = 0 : *n\Ports()\Y = 40 
  AddElement(*n\Ports()) : *n\Ports()\X = 120 : *n\Ports()\Y = 40
  AddElement(*n\Ports()) : *n\Ports()\X = 60 : *n\Ports()\Y = 0 
  AddElement(*n\Ports()) : *n\Ports()\X = 60 : *n\Ports()\Y = 80 
EndProcedure

; --- MAIN ---
OpenWindow(0, 0, 0, 1000, 750, "Node Editor: Smooth S-Lines", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 750)
CreateNewNode(100, 300, "Node 1") : CreateNewNode(600, 100, "Node 2")

Repeat
  Event = WaitWindowEvent()
  mx = GetGadgetAttribute(0, #PB_Canvas_MouseX) : my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
  Select EventType()
    Case #PB_EventType_MouseMove
      If *DragLink
        *DragLink\ManualOffset = (mx - (*DragLink\fromNode\X + *DragLink\fromPort\X)) - (Abs(*DragLink\toNode\X - *DragLink\fromNode\X) * 0.5)
      ElseIf *DragNode
        *DragNode\X = Round((mx-DragOffX)/20, #PB_Round_Nearest)*20 : *DragNode\Y = Round((my-DragOffY)/20, #PB_Round_Nearest)*20
      EndIf
      ; Подсветка центра линии
      ForEach Links()
        midX = (Links()\fromNode\X + Links()\fromPort\X + Links()\toNode\X + Links()\toPort\X) / 2 + Links()\ManualOffset
        midY = (Links()\fromNode\Y + Links()\fromPort\Y + Links()\toNode\Y + Links()\toPort\Y) / 2
        Links()\IsHovered = Bool(Abs(mx - midX) < 15 And Abs(my - midY) < 15)
      Next
      ReDraw(0)
    Case #PB_EventType_LeftButtonDown
      ForEach Links() : If Links()\IsHovered : *DragLink = @Links() : Break 2 : EndIf : Next
      ForEach Nodes()
        ForEach Nodes()\Ports() : If Abs(mx - (Nodes()\X + Nodes()\Ports()\X)) < 10 : *DragPort = @Nodes()\Ports() : *ActiveSourceNode = @Nodes() : Break 2 : EndIf : Next
        If mx > Nodes()\X And mx < Nodes()\X + Nodes()\w And my > Nodes()\Y And my < Nodes()\Y + Nodes()\h
          *DragNode = @Nodes() : DragOffX = mx - Nodes()\X : DragOffY = my - Nodes()\Y : MoveElement(Nodes(), #PB_List_Last) : Break
        EndIf
      Next
    Case #PB_EventType_LeftButtonUp
      If *DragPort : ForEach Nodes() : If @Nodes() <> *ActiveSourceNode : ForEach Nodes()\Ports() : If Abs(mx - (Nodes()\X + Nodes()\Ports()\X)) < 10
              AddElement(Links()) : Links()\fromNode = *ActiveSourceNode : Links()\fromPort = *DragPort : Links()\toNode = @Nodes() : Links()\toPort = @Nodes()\Ports()
      EndIf : Next : EndIf : Next : EndIf
      *DragNode = #Null : *DragPort = #Null : *DragLink = #Null : ReDraw(0)
  EndSelect
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 28
; FirstLine = 23
; Folding = ---
; EnableXP
; DPIAware