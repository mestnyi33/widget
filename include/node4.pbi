; --- СТРУКТУРЫ ---

Structure Port
  X.f
  Y.f
  color.i   ; Индивидуальный цвет точки
  Active.b
EndStructure

Structure Node
  X.f
  Y.f
  w.f
  h.f
  color.i
  Text.s
  List Ports.Port() 
EndStructure

Structure Connection
  *fromNode.Node
  *fromPort.Port
  *toNode.Node
  *toPort.Port
  color.i   ; Цвет линии (берется от порта-источника)
EndStructure

Global NewList Nodes.Node()
Global NewList Links.Connection()
Global *DragNode.Node = #Null
Global *DragPort.Port = #Null
Global *ActiveSourceNode.Node = #Null

; --- МАКРОСЫ ---

Macro IsMouseOnPort(mx, my, nodePtr, portPtr)
  (Abs(mx - (nodePtr\x + portPtr\x)) < 12 And Abs(my - (nodePtr\y + portPtr\y)) < 12)
EndMacro

Macro IsMouseOnNode(mx, my, nodePtr)
  (mx > nodePtr\x And mx < nodePtr\x + nodePtr\w And my > nodePtr\y And my < nodePtr\y + nodePtr\h)
EndMacro

; --- ПРОЦЕДУРЫ ---

Procedure AddNotePoint(*n.Node, side, position.f, color = $00FF00)
  AddElement(*n\Ports())
  *n\Ports()\color = color
  Select side
    Case 0 ; Верх
      *n\Ports()\x = *n\w * position
      *n\Ports()\y = 0               
    Case 1 ; Право
      *n\Ports()\x = *n\w
      *n\Ports()\y = *n\h * position 
    Case 2 ; Низ
      *n\Ports()\x = *n\w * position
      *n\Ports()\y = *n\h            
    Case 3 ; Лево
      *n\Ports()\x = 0
      *n\Ports()\y = *n\h * position 
  EndSelect
EndProcedure

Procedure CreateNewNode(X, Y, label.s = "Блок", w = 120, h = 80, color = -1)
  *n.Node = AddElement(Nodes())
  *n\x = X - w/2
  *n\y = Y - h/2
  *n\w = w
  *n\h = h
  *n\text = label
  If color = -1
    *n\color = RGB(Random(150), Random(150), Random(150))
  Else
    *n\color = color
  EndIf
  ; Разные цвета портов при создании
  AddNotePoint(*n, 0, 0.5, $0000FF) ; Красный
  AddNotePoint(*n, 1, 0.5, $FF0000) ; Синий
  AddNotePoint(*n, 2, 0.5, $00FFFF) ; Желтый
  AddNotePoint(*n, 3, 0.5, $00FF00) ; Зеленый
  ProcedureReturn *n
EndProcedure

Procedure ConnectNodes(*srcNode.Node, *srcPort.Port)
  ForEach Nodes()
    If @Nodes() <> *srcNode
      ForEach Nodes()\Ports()
        If Nodes()\Ports()\active
          AddElement(Links())
          Links()\fromNode = *srcNode
          Links()\fromPort = *srcPort
          Links()\toNode = @Nodes()
          Links()\toPort = @Nodes()\Ports()
          Links()\color = *srcPort\color ; Линия наследует цвет порта
          ProcedureReturn #True
        EndIf
      Next
    EndIf
  Next
  ProcedureReturn #False
EndProcedure

Procedure ReDraw(Canvas)
  StartDrawing(CanvasOutput(Canvas))
    Box(0, 0, OutputWidth(), OutputHeight(), $FDFDFD)
    ; Отрисовка линий цветом их источников
    ForEach Links()
      LineXY(Links()\fromNode\x + Links()\fromPort\x, Links()\fromNode\y + Links()\fromPort\y, 
             Links()\toNode\x + Links()\toPort\x, Links()\toNode\y + Links()\toPort\y, Links()\color)
    Next
    ; Временная линия
    If *DragPort
      LineXY(*ActiveSourceNode\x + *DragPort\x, *ActiveSourceNode\y + *DragPort\y, WindowMouseX(0), WindowMouseY(0), $AAAAAA)
    EndIf
    ; Отрисовка блоков
    ForEach Nodes()
      Box(Nodes()\x, Nodes()\y, Nodes()\w, Nodes()\h, Nodes()\color)
      DrawingMode(#PB_2DDrawing_Transparent)
      tw = TextWidth(Nodes()\text)
      th = TextHeight(Nodes()\text)
      DrawText(Nodes()\x + (Nodes()\w - tw)/2, Nodes()\y + (Nodes()\h - th)/2, Nodes()\text, $FFFFFF)
      ForEach Nodes()\Ports()
        c = Nodes()\Ports()\color
        r = 4
        If Nodes()\Ports()\active
          c = $FFFFFF
          r = 7
        EndIf
        Circle(Nodes()\x + Nodes()\Ports()\x, Nodes()\y + Nodes()\Ports()\y, r, c)
      Next
    Next
  StopDrawing()
EndProcedure

RandomSeed(ElapsedMilliseconds())
OpenWindow(0, 0, 0, 1000, 700, "Editor: ПКМ на точку - удалить связи", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 700)

CreateNewNode(300, 350, "Блок 1")
CreateNewNode(700, 350, "Блок 2")

Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget And EventGadget() = 0
    mx = GetGadgetAttribute(0, #PB_Canvas_MouseX)
    my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
    Select EventType()
      Case #PB_EventType_MouseMove
        ForEach Nodes()
          ForEach Nodes()\Ports()
            Nodes()\Ports()\active = #False
            If IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports())
              Nodes()\Ports()\active = #True
            EndIf
          Next
        Next
        If *DragNode
          *DragNode\x = mx - *DragNode\w/2
          *DragNode\y = my - *DragNode\h/2
        EndIf
        ReDraw(0)

      Case #PB_EventType_LeftButtonDown
        *DragPort = #Null
        *DragNode = #Null
        ForEach Nodes()
          ForEach Nodes()\Ports()
            If Nodes()\Ports()\active
              *DragPort = @Nodes()\Ports()
              *ActiveSourceNode = @Nodes()
              Break 2
            EndIf
          Next
        Next
        If *DragPort = #Null
          ForEach Nodes()
            If IsMouseOnNode(mx, my, Nodes())
              *DragNode = @Nodes()
              Break
            EndIf
          Next
        EndIf

      Case #PB_EventType_RightButtonDown ; УДАЛЕНИЕ СВЯЗЕЙ ПОРТА
        ForEach Nodes()
          ForEach Nodes()\Ports()
            If Nodes()\Ports()\active
              ForEach Links()
                If Links()\fromPort = @Nodes()\Ports() Or Links()\toPort = @Nodes()\Ports()
                  DeleteElement(Links())
                EndIf
              Next
            EndIf
          Next
        Next
        ReDraw(0)

      Case #PB_EventType_LeftButtonUp
        If *DragPort
          ConnectNodes(*ActiveSourceNode, *DragPort)
          *DragPort = #Null
        EndIf
        *DragNode = #Null
        ReDraw(0)

      Case #PB_EventType_LeftDoubleClick
        CreateNewNode(mx, my)
    EndSelect
  EndIf
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 211
; FirstLine = 190
; Folding = -----
; EnableXP
; DPIAware