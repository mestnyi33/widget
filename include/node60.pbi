; =================================================================
; PROFESSIONAL NODE EDITOR: SMART POLYLINE & SELECTION
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
  (Bool(Abs(mx - (nodePtr\x + portPtr\x)) < 12 And Abs(my - (nodePtr\y + portPtr\y)) < 12))
EndMacro

; --- ПРОЦЕДУРЫ ---

Procedure ReDraw(Canvas)
  If StartDrawing(CanvasOutput(Canvas))
    Box(0, 0, OutputWidth(), OutputHeight(), $FDFDFD)
    ; Сетка
    For i = 0 To OutputWidth() Step #GridSize : Line(i, 0, 1, OutputHeight(), $F0F0F0) : Next
    For i = 0 To OutputHeight() Step #GridSize : Line(0, i, OutputWidth(), 1, $F0F0F0) : Next
    
    ; 1. ЛИНИИ
    ForEach Links()
      Protected curX = Links()\fromNode\x + Links()\fromPort\x
      Protected curY = Links()\fromNode\y + Links()\fromPort\y
      Protected color = Links()\color : If Links()\IsLineHovered : color = $00D7FF : EndIf
      
      ForEach Links()\Points()
        LineXY(curX, curY, Links()\Points()\X, Links()\Points()\Y, color)
        curX = Links()\Points()\X : curY = Links()\Points()\Y
        If Links()\Points()\IsHovered : Circle(curX, curY, 6, $00D7FF) : Else : Circle(curX, curY, 4, color) : EndIf
      Next
      LineXY(curX, curY, Links()\toNode\x + Links()\toPort\x, Links()\toNode\y + Links()\toPort\y, color)
    Next
    
    ; 2. РЕЗИНОВАЯ НИТЬ
    If *DragPort
      LineXY(*ActiveSourceNode\x + *DragPort\x, *ActiveSourceNode\y + *DragPort\y, GetGadgetAttribute(0, #PB_Canvas_MouseX), GetGadgetAttribute(0, #PB_Canvas_MouseY), $AAAAAA)
    EndIf
    
    ; 3. УЗЛЫ
    ForEach Nodes()
      Box(Nodes()\x, Nodes()\y, Nodes()\w, Nodes()\h, Nodes()\color)
      DrawingMode(#PB_2DDrawing_Transparent) : DrawText(Nodes()\x+12, Nodes()\y+12, Nodes()\text, $FFFFFF) : DrawingMode(#PB_2DDrawing_Default)
      ForEach Nodes()\Ports()
        Circle(Nodes()\x + Nodes()\Ports()\x, Nodes()\y + Nodes()\Ports()\y, 5, Nodes()\Ports()\color)
      Next
    Next
    StopDrawing()
  EndIf
EndProcedure

Procedure CreateNewNode(X, Y, txt.s)
  *n.Node = AddElement(Nodes())
  *n\x = Round(X/#GridSize, #PB_Round_Nearest)*#GridSize : *n\y = Round(Y/#GridSize, #PB_Round_Nearest)*#GridSize
  *n\w = 140 : *n\h = 80 : *n\text = txt : *n\color = RGB(50, 60, 70)
  AddElement(*n\Ports()) : *n\Ports()\x = 0 : *n\Ports()\y = 40 : *n\Ports()\color = $00FF00 ; Вход
  AddElement(*n\Ports()) : *n\Ports()\x = 140 : *n\Ports()\y = 40 : *n\Ports()\color = $0044FF ; Выход
EndProcedure

; --- MAIN ---
OpenWindow(0, 0, 0, 1100, 800, "Node Editor Pro: DoubleClick to add point, RightClick to delete", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1100, 800)
CreateNewNode(100, 100, "INPUT") : CreateNewNode(600, 400, "OUTPUT")

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
          Define  px = Links()\fromNode\x + Links()\fromPort\x, py = Links()\fromNode\y + Links()\fromPort\y
          ForEach Links()\Points()
            Links()\Points()\IsHovered = Bool(Abs(mx - Links()\Points()\X) < 10 And Abs(my - Links()\Points()\Y) < 10)
            If DistToLine(mx, my, px, py, Links()\Points()\X, Links()\Points()\Y) < 6 : Links()\IsLineHovered = #True : EndIf
            px = Links()\Points()\X : py = Links()\Points()\Y
          Next
          If DistToLine(mx, my, px, py, Links()\toNode\x + Links()\toPort\x, Links()\toNode\y + Links()\toPort\y) < 6 : Links()\IsLineHovered = #True : EndIf
        Next
        ReDraw(0)

      Case #PB_EventType_LeftButtonDown
        ForEach Links() : ForEach Links()\Points() : If Links()\Points()\IsHovered : *DragPoint = @Links()\Points() : Break 2 : EndIf : Next : Next
        If *DragPoint = #Null
          ForEach Nodes()
            ForEach Nodes()\Ports() : If IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports()) : *DragPort = @Nodes()\Ports() : *ActiveSourceNode = @Nodes() : Break 2 : EndIf : Next
            If mx > Nodes()\x And mx < Nodes()\x + Nodes()\w And my > Nodes()\y And my < Nodes()\y + Nodes()\h
              *DragNode = @Nodes() : DragOffX = mx - Nodes()\x : DragOffY = my - Nodes()\y : MoveElement(Nodes(), #PB_List_Last) : Break
            EndIf
          Next
        EndIf

      Case #PB_EventType_LeftDoubleClick
        ForEach Links()
          If Links()\IsLineHovered
            define x_prev = Links()\fromNode\x + Links()\fromPort\x, y_prev = Links()\fromNode\y + Links()\fromPort\y
            ; Умная вставка: ищем нужный сегмент
            ForEach Links()\Points()
              If DistToLine(mx, my, x_prev, y_prev, Links()\Points()\X, Links()\Points()\Y) < 6
                InsertElement(Links()\Points()) : Goto _set_pt
              EndIf
              x_prev = Links()\Points()\X : y_prev = Links()\Points()\Y
            Next
            AddElement(Links()\Points()) ; Если это последний сегмент
            _set_pt:
            Links()\Points()\X = Round(mx/#GridSize, #PB_Round_Nearest)*#GridSize
            Links()\Points()\Y = Round(my/#GridSize, #PB_Round_Nearest)*#GridSize
            Break
          EndIf
        Next

      Case #PB_EventType_RightButtonDown
        ; Удаление точки ИЛИ всей связи
        ForEach Links()
          ForEach Links()\Points()
            If Links()\Points()\IsHovered : DeleteElement(Links()\Points()) : Break 2 : EndIf
          Next
          If Links()\IsLineHovered : DeleteElement(Links()) : Break : EndIf
        Next

      Case #PB_EventType_LeftButtonUp
        If *DragPort
          ForEach Nodes() : If @Nodes() <> *ActiveSourceNode : ForEach Nodes()\Ports()
            If IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports())
              AddElement(Links()) : Links()\fromNode = *ActiveSourceNode : Links()\fromPort = *DragPort
              Links()\toNode = @Nodes() : Links()\toPort = @Nodes()\Ports() : Links()\color = $808080
            EndIf
          Next : EndIf : Next
        EndIf
        *DragPoint = #Null : *DragNode = #Null : *DragPort = #Null : ReDraw(0)
    EndSelect
  EndIf
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 134
; FirstLine = 130
; Folding = ------
; EnableXP
; DPIAware