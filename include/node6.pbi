; =================================================================
; ИСПРАВЛЕННЫЙ РЕДАКТОР: СОЗДАНИЕ СВЯЗЕЙ + ТОЧКИ ИЗГИБА
; =================================================================

#GridSize = 20
Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro

Structure PointF
  X.f : Y.f : IsHovered.b : color.i
EndStructure

Structure Node
  X.f : Y.f : w.f : h.f : color.i : Text.s
  List Ports.PointF() 
EndStructure

Structure Connection
  *fromNode.Node : *fromPort.PointF : *toNode.Node : *toPort.PointF : color.i
  List Points.PointF() 
  IsLineHovered.b 
EndStructure

Global NewList Nodes.Node()
Global NewList Links.Connection()
Global *DragNode.Node = #Null, *DragPoint.PointF = #Null, *DragPort.PointF = #Null
Global *ActiveSourceNode.Node = #Null, DragOffX.f = 0, DragOffY.f = 0

; --- МАТЕМАТИКА ---
Procedure.f DistToLine(px.f, py.f, x1.f, y1.f, x2.f, y2.f)
  Protected L2.f = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)
  If L2 = 0 : ProcedureReturn Sqr((px-x1)*(px-x1) + (py-y1)*(py-y1)) : EndIf
  Protected t.f = ((px-x1)*(x2-x1) + (py-y1)*(y2-y1)) / L2
  t = Max(0, Min(1, t))
  ProcedureReturn Sqr((px-(x1+t*(x2-x1)))*(px-(x1+t*(x2-x1))) + (py-(y1+t*(y2-y1)))*(py-(y1+t*(y2-y1))))
EndProcedure

Macro IsMouseOnPort(mx, my, nodePtr, portPtr)
  (Bool(Abs(mx - (nodePtr\x + portPtr\x)) < 10 And Abs(my - (nodePtr\y + portPtr\y)) < 10))
EndMacro

; --- ПРОЦЕДУРЫ ---

Procedure ReDraw(Canvas)
  If StartDrawing(CanvasOutput(Canvas))
    Box(0, 0, OutputWidth(), OutputHeight(), $FDFDFD)
    ; Сетка
    For i = 0 To OutputWidth() Step #GridSize : Line(i, 0, 1, OutputHeight(), $F0F0F0) : Next
    For i = 0 To OutputHeight() Step #GridSize : Line(0, i, OutputWidth(), 1, $F0F0F0) : Next
    
    ; 1. Линии
    ForEach Links()
      Protected curX = Links()\fromNode\x + Links()\fromPort\x
      Protected curY = Links()\fromNode\y + Links()\fromPort\y
      Protected color = Links()\color : If Links()\IsLineHovered : color = $00D7FF : EndIf
      
      ForEach Links()\Points()
        LineXY(curX, curY, Links()\Points()\X, Links()\Points()\Y, color)
        curX = Links()\Points()\X : curY = Links()\Points()\Y
        If Links()\Points()\IsHovered : Circle(curX, curY, 5, $00D7FF) : Else : Circle(curX, curY, 3, color) : EndIf
      Next
      LineXY(curX, curY, Links()\toNode\x + Links()\toPort\x, Links()\toNode\y + Links()\toPort\y, color)
    Next
    
    ; 2. Тянущаяся линия
    If *DragPort
      LineXY(*ActiveSourceNode\x + *DragPort\x, *ActiveSourceNode\y + *DragPort\y, GetGadgetAttribute(0, #PB_Canvas_MouseX), GetGadgetAttribute(0, #PB_Canvas_MouseY), $AAAAAA)
    EndIf
    
    ; 3. Узлы
    ForEach Nodes()
      Box(Nodes()\x, Nodes()\y, Nodes()\w, Nodes()\h, Nodes()\color)
      DrawingMode(#PB_2DDrawing_Transparent) : DrawText(Nodes()\x+10, Nodes()\y+10, Nodes()\text, $FFFFFF) : DrawingMode(#PB_2DDrawing_Default)
      ForEach Nodes()\Ports()
        c = Nodes()\Ports()\color : If Bool(Abs(GetGadgetAttribute(0, #PB_Canvas_MouseX) - (Nodes()\x + Nodes()\Ports()\x)) < 10) : c = $FF00FF : EndIf
        Circle(Nodes()\x + Nodes()\Ports()\x, Nodes()\y + Nodes()\Ports()\y, 5, c)
      Next
    Next
    StopDrawing()
  EndIf
EndProcedure

Procedure CreateNewNode(X, Y, txt.s)
  *n.Node = AddElement(Nodes())
  *n\x = Round(X/#GridSize, #PB_Round_Nearest)*#GridSize : *n\y = Round(Y/#GridSize, #PB_Round_Nearest)*#GridSize
  *n\w = 120 : *n\h = 60 : *n\text = txt : *n\color = RGB(Random(100), 50, 150)
  AddElement(*n\Ports()) : *n\Ports()\x = 0 : *n\Ports()\y = 30 : *n\Ports()\color = $00FF00
  AddElement(*n\Ports()) : *n\Ports()\x = 120 : *n\Ports()\y = 30 : *n\Ports()\color = $0000FF
EndProcedure

; --- ЦИКЛ ---
OpenWindow(0, 0, 0, 1000, 700, "Fixed Node Editor: Drag from port to connect", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 700)
CreateNewNode(100, 100, "Node A") : CreateNewNode(500, 300, "Node B")

Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget And EventGadget() = 0
    mx = GetGadgetAttribute(0, #PB_Canvas_MouseX) : my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
    Select EventType()
      Case #PB_EventType_MouseMove
        If *DragPoint
          *DragPoint\X = Round(mx / #GridSize, #PB_Round_Nearest) * #GridSize
          *DragPoint\Y = Round(my / #GridSize, #PB_Round_Nearest) * #GridSize
        ElseIf *DragNode
          *DragNode\x = Round((mx - DragOffX) / #GridSize, #PB_Round_Nearest) * #GridSize
          *DragNode\y = Round((my - DragOffY) / #GridSize, #PB_Round_Nearest) * #GridSize
        EndIf
        
        ForEach Links()
          Links()\IsLineHovered = #False
          x1 = Links()\fromNode\x + Links()\fromPort\x
          y1 = Links()\fromNode\y + Links()\fromPort\y
          ForEach Links()\Points()
            Links()\Points()\IsHovered = Bool(Abs(mx - Links()\Points()\X) < 8 And Abs(my - Links()\Points()\Y) < 8)
            If DistToLine(mx, my, x1, y1, Links()\Points()\X, Links()\Points()\Y) < 5 : Links()\IsLineHovered = #True : EndIf
            x1 = Links()\Points()\X : y1 = Links()\Points()\Y
          Next
          If DistToLine(mx, my, x1, y1, Links()\toNode\x + Links()\toPort\x, Links()\toNode\y + Links()\toPort\y) < 5 : Links()\IsLineHovered = #True : EndIf
        Next
        ReDraw(0)

      Case #PB_EventType_LeftButtonDown
        ; 1. Проверяем точки перелома
        ForEach Links() : ForEach Links()\Points() : If Links()\Points()\IsHovered : *DragPoint = @Links()\Points() : Break 2 : EndIf : Next : Next
        
        ; 2. Проверяем порты (начало связи)
        If *DragPoint = #Null
          ForEach Nodes()
            ForEach Nodes()\Ports()
              If IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports()) : *DragPort = @Nodes()\Ports() : *ActiveSourceNode = @Nodes() : Break 2 : EndIf
            Next
            If mx > Nodes()\x And mx < Nodes()\x + Nodes()\w And my > Nodes()\y And my < Nodes()\y + Nodes()\h
              *DragNode = @Nodes() : DragOffX = mx - Nodes()\x : DragOffY = my - Nodes()\y : MoveElement(Nodes(), #PB_List_Last) : Break
            EndIf
          Next
        EndIf

      Case #PB_EventType_LeftDoubleClick
        ForEach Links()
          If Links()\IsLineHovered
            AddElement(Links()\Points())
            Links()\Points()\X = Round(mx/#GridSize, #PB_Round_Nearest)*#GridSize
            Links()\Points()\Y = Round(my/#GridSize, #PB_Round_Nearest)*#GridSize
            Break
          EndIf
        Next

      Case #PB_EventType_RightButtonDown ; Удаление точки изгиба
        ForEach Links() : ForEach Links()\Points()
            If Links()\Points()\IsHovered : DeleteElement(Links()\Points()) : Break 2 : EndIf
        Next : Next

      Case #PB_EventType_LeftButtonUp
        ; ЗАВЕРШЕНИЕ СВЯЗИ
        If *DragPort
          ForEach Nodes()
            If @Nodes() <> *ActiveSourceNode
              ForEach Nodes()\Ports()
                If IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports())
                  AddElement(Links())
                  Links()\fromNode = *ActiveSourceNode : Links()\fromPort = *DragPort
                  Links()\toNode = @Nodes() : Links()\toPort = @Nodes()\Ports() : Links()\color = $666666
                  Break 2
                EndIf
              Next
            EndIf
          Next
        EndIf
        *DragPoint = #Null : *DragNode = #Null : *DragPort = #Null : ReDraw(0)
    EndSelect
  EndIf
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 112
; FirstLine = 107
; Folding = -----
; EnableXP
; DPIAware