; --- ГЛОБАЛЬНЫЕ НАСТРОЙКИ ---
Global EdgeSize.i = 8   ; Чувствительность захвата грани
Global GridSize.i = 20  ; Шаг сетки для выравнивания блоков

; --- СТРУКТУРЫ ---

Structure Port
  X.f
  Y.f
  color.i
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
  color.i
EndStructure

Global NewList Nodes.Node()
Global NewList Links.Connection()

Global *DragNode.Node = #Null
Global *DragPort.Port = #Null
Global *ActiveSourceNode.Node = #Null
Global *HoverEdgeNode.Node = #Null
Global HoverSide.i = -1
Global HoverPos.f = 0.0
Global DragOffX.f
Global DragOffY.f

; --- МАКРОСЫ ---

Macro IsMouseOnPort(mx, my, nodePtr, portPtr)
  (Abs(mx - (nodePtr\x + portPtr\x)) < 12 And Abs(my - (nodePtr\y + portPtr\y)) < 12)
EndMacro

Macro IsMouseOnNode(mx, my, nodePtr)
  (mx > nodePtr\x And mx < nodePtr\x + nodePtr\w And my > nodePtr\y And my < nodePtr\y + nodePtr\h)
EndMacro

; Привязка к сетке (округление координат)
Procedure.f SnapToGrid(val.f)
  ProcedureReturn Round(val / GridSize, #PB_Round_Nearest) * GridSize
EndProcedure

Procedure.f GetSnappedPos(pos.f)
  If pos < 0.15 : ProcedureReturn 0.0 : EndIf
  If pos > 0.35 And pos < 0.65 : ProcedureReturn 0.5 : EndIf
  If pos > 0.85 : ProcedureReturn 1.0 : EndIf
  ProcedureReturn pos
EndProcedure

Macro CheckEdgeHover(mx, my, nodePtr)
  If mx >= nodePtr\x - EdgeSize And mx <= nodePtr\x + nodePtr\w + EdgeSize And my >= nodePtr\y - EdgeSize And my <= nodePtr\y + nodePtr\h + EdgeSize
    If Abs(my - nodePtr\y) <= EdgeSize : HoverSide = 0 : HoverPos = (mx - nodePtr\x) / nodePtr\w : *HoverEdgeNode = nodePtr
    ElseIf Abs(mx - (nodePtr\x + nodePtr\w)) <= EdgeSize : HoverSide = 1 : HoverPos = (my - nodePtr\y) / nodePtr\h : *HoverEdgeNode = nodePtr
    ElseIf Abs(my - (nodePtr\y + nodePtr\h)) <= EdgeSize : HoverSide = 2 : HoverPos = (mx - nodePtr\x) / nodePtr\w : *HoverEdgeNode = nodePtr
    ElseIf Abs(mx - nodePtr\x) <= EdgeSize : HoverSide = 3 : HoverPos = (my - nodePtr\y) / nodePtr\h : *HoverEdgeNode = nodePtr : EndIf
    If *HoverEdgeNode And (GetGadgetAttribute(0, #PB_Canvas_Modifiers) & #PB_Canvas_Shift)
      HoverPos = GetSnappedPos(HoverPos)
    EndIf
  EndIf
EndMacro

; --- ПРОЦЕДУРЫ ---

Procedure.i AddNotePoint(*n.Node, side, position.f, color = $00FF00)
  Protected LocalX.f, LocalY.f
  Select side
    Case 0 : LocalX = *n\w * position : LocalY = 0
    Case 1 : LocalX = *n\w : LocalY = *n\h * position
    Case 2 : LocalX = *n\w * position : LocalY = *n\h
    Case 3 : LocalX = 0 : LocalY = *n\h * position
  EndSelect
  ForEach *n\Ports()
    If Abs(*n\Ports()\x - LocalX) < 5 And Abs(*n\Ports()\y - LocalY) < 5 : ProcedureReturn #Null : EndIf
  Next
  AddElement(*n\Ports())
  *n\Ports()\color = color : *n\Ports()\x = LocalX : *n\Ports()\y = LocalY
  ProcedureReturn @*n\Ports()
EndProcedure

Procedure CreateNewNode(X, Y, label.s = "Блок", w = 120, h = 80, color = -1)
  *n.Node = AddElement(Nodes())
  *n\x = SnapToGrid(X - w/2) : *n\y = SnapToGrid(Y - h/2) : *n\w = w : *n\h = h : *n\text = label
  If color = -1 : *n\color = RGB(Random(150), Random(150), Random(150)) : Else : *n\color = color : EndIf
  AddNotePoint(*n, 0, 0.0, $0000FF) : AddNotePoint(*n, 1, 0.0, $FF0000) : AddNotePoint(*n, 2, 0.0, $00FFFF) : AddNotePoint(*n, 3, 0.0, $00FF00)
  ProcedureReturn *n
EndProcedure

; --- ГЛОБАЛЬНЫЕ НАСТРОЙКИ ---
Global GridVisible.b = #True ; Флаг видимости сетки
Global GridSize.i = 20       ; Шаг сетки

; --- ОБНОВЛЕННАЯ ПРОЦЕДУРА REDRAW С ЛИНИЯМИ ---

Procedure ReDraw(Canvas)
  StartDrawing(CanvasOutput(Canvas))
    Protected cw = GadgetWidth(Canvas)
    Protected ch = GadgetHeight(Canvas)
    
    ; Очистка фона
    Box(0, 0, cw, ch, $FFFFFF)
    
    ; --- ОТРИСОВКА СЕТКИ ЛИНИЯМИ ---
    If GridVisible
      Protected gl = 0
      Protected GridColor = $F0F0F0 ; Очень светлый серый для линий
      
      ; Рисуем вертикальные линии
      gl = 0
      While gl < cw
        Line(gl, 0, 1, ch, GridColor)
        gl + GridSize
      Wend
      
      ; Рисуем горизонтальные линии
      gl = 0
      While gl < ch
        Line(0, gl, cw, 1, GridColor)
        gl + GridSize
      Wend
    EndIf
    ; ------------------------------
    
    ; Отрисовка связей (линий)
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
      
      ; Подсветка грани
      If *HoverEdgeNode = @Nodes() 
        DrawingMode(#PB_2DDrawing_Outlined) 
        Box(Nodes()\x - 1, Nodes()\y - 1, Nodes()\w + 2, Nodes()\h + 2, $00D7FF) 
        DrawingMode(#PB_2DDrawing_Default) 
      EndIf
      
      ; Текст
      DrawingMode(#PB_2DDrawing_Transparent) 
      DrawText(Nodes()\x + (Nodes()\w - TextWidth(Nodes()\text))/2, 
               Nodes()\y + (Nodes()\h - TextHeight(Nodes()\text))/2, Nodes()\text, $FFFFFF)
      
      ; Порты
      ForEach Nodes()\Ports()
        c = Nodes()\Ports()\color 
        r = 4 
        If Nodes()\Ports()\active : c = $FFFFFF : r = 7 : EndIf
        Circle(Nodes()\x + Nodes()\Ports()\x, Nodes()\y + Nodes()\Ports()\y, r, c)
      Next
    Next
  StopDrawing()
EndProcedure


RandomSeed(ElapsedMilliseconds())
OpenWindow(0, 0, 0, 1000, 700, "Node Editor: Grid Snap Enabled", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 700, #PB_Canvas_Keyboard)

CreateNewNode(300, 300, "Блок А")
CreateNewNode(700, 300, "Блок B")

Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget And EventGadget() = 0
    mx = GetGadgetAttribute(0, #PB_Canvas_MouseX) : my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
    Select EventType()
      ; --- В ОСНОВНОЙ ЦИКЛ (Repeat) ДОБАВЬТЕ ЭТОТ БЛОК ---

; Внутри Select EventType() добавьте:
Case #PB_EventType_KeyDown
  If GetGadgetAttribute(0, #PB_Canvas_Key) = #PB_Shortcut_G
    GridVisible = 1 - GridVisible ; Переключение 0/1
    ReDraw(0)
  EndIf
          
       Case #PB_EventType_MouseMove
        *HoverEdgeNode = #Null : HoverSide = -1
        ForEach Nodes()
          ForEach Nodes()\Ports() : Nodes()\Ports()\active = #False : If IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports()) : Nodes()\Ports()\active = #True : EndIf : Next
          CheckEdgeHover(mx, my, Nodes())
        Next
        If *DragNode 
          ; При перемещении учитываем смещение клика и примагничиваем к сетке
          *DragNode\x = SnapToGrid(mx - DragOffX) : *DragNode\y = SnapToGrid(my - DragOffY) 
        EndIf
        ReDraw(0)
      Case #PB_EventType_LeftButtonDown
        *DragPort = #Null : *DragNode = #Null
        ForEach Nodes() : ForEach Nodes()\Ports() : If IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports()) : *DragPort = @Nodes()\Ports() : *ActiveSourceNode = @Nodes() : Break 2 : EndIf : Next : Next
        If *DragPort = #Null And *HoverEdgeNode
          *DragPort = AddNotePoint(*HoverEdgeNode, HoverSide, HoverPos, $A0A0A0) : *ActiveSourceNode = *HoverEdgeNode
        ElseIf *DragPort = #Null
          ForEach Nodes() : If IsMouseOnNode(mx, my, Nodes()) : *DragNode = @Nodes() : DragOffX = mx - *DragNode\x : DragOffY = my - *DragNode\y : Break : EndIf : Next
        EndIf
      Case #PB_EventType_RightButtonDown
        *PortFound = #Null : ForEach Nodes() : ForEach Nodes()\Ports() : If IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports()) : *PortFound = @Nodes()\Ports() : ForEach Links() : If Links()\fromPort = *PortFound Or Links()\toPort = *PortFound : DeleteElement(Links()) : EndIf : Next : Break 2 : EndIf : Next : Next
        If *PortFound = #Null : ForEach Nodes() : If IsMouseOnNode(mx, my, Nodes()) : ForEach Links() : If Links()\fromNode = @Nodes() Or Links()\toNode = @Nodes() : DeleteElement(Links()) : EndIf : Next : DeleteElement(Nodes()) : Break : EndIf : Next : EndIf
        ReDraw(0)
      Case #PB_EventType_LeftButtonUp
        If *DragPort : ForEach Nodes() : If @Nodes() <> *ActiveSourceNode : ForEach Nodes()\Ports() : If Nodes()\Ports()\active : AddElement(Links()) : Links()\fromNode = *ActiveSourceNode : Links()\fromPort = *DragPort : Links()\toNode = @Nodes() : Links()\toPort = @Nodes()\Ports() : Links()\color = *DragPort\color : EndIf : Next : EndIf : Next : *DragPort = #Null : EndIf
        *DragNode = #Null : ReDraw(0)
      Case #PB_EventType_LeftDoubleClick : CreateNewNode(mx, my)
    EndSelect
  EndIf
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 109
; FirstLine = 109
; Folding = ------
; EnableXP
; DPIAware