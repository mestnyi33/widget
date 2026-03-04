; =================================================================
; NODE EDITOR: 4 ПОРТА + ИСПРАВЛЕННЫЕ ИМЕНА ФУНКЦИЙ
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
  List Path.PointF() 
EndStructure

Global NewList Nodes.Node()
Global NewList Links.Connection()
Global *DragNode.Node = #Null, *DragPort.PointF = #Null, *ActiveSourceNode.Node = #Null
Global DragOffX.i, DragOffY.i

; --- ЛОГИКА ---

Procedure GetPortSide(*n.Node, *p.PointF)
  If *p\X <= 0 : ProcedureReturn 1 : EndIf ; Лево
  If *p\Y <= 0 : ProcedureReturn 2 : EndIf ; Верх
  If *p\X >= *n\w : ProcedureReturn 3 : EndIf ; Право
  If *p\Y >= *n\h : ProcedureReturn 4 : EndIf ; Низ
  ProcedureReturn 1
EndProcedure

Procedure RecalculatePath(*link.Connection)
  ClearList(*link\Path())
  Protected x1 = *link\fromNode\X + *link\fromPort\X
  Protected y1 = *link\fromNode\Y + *link\fromPort\Y
  Protected x2 = *link\toNode\X + *link\toPort\X
  Protected y2 = *link\toNode\Y + *link\toPort\Y
  
  Protected s1 = GetPortSide(*link\fromNode, *link\fromPort)
  Protected s2 = GetPortSide(*link\toNode, *link\toPort)
  Protected offset = 50

  ; Точка 1: Старт
  AddElement(*link\Path()) : *link\Path()\X = x1 : *link\Path()\Y = y1
  
  ; Точка 2: Выход из порта (Stub)
  Protected tx1 = x1, ty1 = y1
  Select s1
    Case 1 : tx1 - offset : Case 2 : ty1 - offset : Case 3 : tx1 + offset : Case 4 : ty1 + offset
  EndSelect
  AddElement(*link\Path()) : *link\Path()\X = tx1 : *link\Path()\Y = ty1

  ; Точка 3: Подготовка входа (Stub)
  Protected tx2 = x2, ty2 = y2
  Select s2
    Case 1 : tx2 - offset : Case 2 : ty2 - offset : Case 3 : tx2 + offset : Case 4 : ty2 + offset
  EndSelect

  ; --- УЛУЧШЕННАЯ ЛОГИКА ОБХОДА ---
  
  ; Проверяем, не находится ли цель "позади" выхода
  Protected Conflict.b = #False
  If (s1 = 4 And ty2 < ty1) Or (s1 = 2 And ty2 > ty1) ; Выход вниз, а цель выше (или наоборот)
    Conflict = #True
  ElseIf (s1 = 3 And tx2 < tx1) Or (s1 = 1 And tx2 > tx1) ; Выход вправо, а цель левее (или наоборот)
    Conflict = #True
  EndIf

  If Conflict
    ; Если конфликт - делаем петлю (обход через промежуточную точку сбоку)
    If s1 = 2 Or s1 = 4 ; Вертикальные порты
      Protected bypassX
      If tx2 > tx1 : bypassX = Max(tx1, tx2) + offset * 2 : Else : bypassX = Min(tx1, tx2) - offset * 2 : EndIf
      AddElement(*link\Path()) : *link\Path()\X = bypassX : *link\Path()\Y = ty1
      AddElement(*link\Path()) : *link\Path()\X = bypassX : *link\Path()\Y = ty2
    Else ; Горизонтальные порты
      Protected bypassY
      If ty2 > ty1 : bypassY = Max(ty1, ty2) + offset * 2 : Else : bypassY = Min(ty1, ty2) - offset * 2 : EndIf
      AddElement(*link\Path()) : *link\Path()\X = tx1 : *link\Path()\Y = bypassY
      AddElement(*link\Path()) : *link\Path()\X = tx2 : *link\Path()\Y = bypassY
    EndIf
  Else
    ; Обычный Z-излом (если пути ничего не мешает)
    If s1 = 1 Or s1 = 3
      AddElement(*link\Path()) : *link\Path()\X = tx1 + (tx2-tx1)/2 : *link\Path()\Y = ty1
      AddElement(*link\Path()) : *link\Path()\X = tx1 + (tx2-tx1)/2 : *link\Path()\Y = ty2
    Else
      AddElement(*link\Path()) : *link\Path()\X = tx1 : *link\Path()\Y = ty1 + (ty2-ty1)/2
      AddElement(*link\Path()) : *link\Path()\X = tx2 : *link\Path()\Y = ty1 + (ty2-ty1)/2
    EndIf
  EndIf

  ; Финальные точки
  AddElement(*link\Path()) : *link\Path()\X = tx2 : *link\Path()\Y = ty2
  AddElement(*link\Path()) : *link\Path()\X = x2 : *link\Path()\Y = y2
EndProcedure

; ПЕРЕИМЕНОВАНО: Чтобы не конфликтовать с CreateNode() из Ogre3D
Procedure CreateEditorNode(X, Y, t.s)
  *n.Node = AddElement(Nodes())
  *n\X = X : *n\Y = Y : *n\w = 120 : *n\h = 80 : *n\Text = t : *n\color = $333333
  ; 4 порта: Лево, Право, Верх, Низ
  AddElement(*n\Ports()) : *n\Ports()\X = 0 : *n\Ports()\Y = 40 
  AddElement(*n\Ports()) : *n\Ports()\X = 120 : *n\Ports()\Y = 40
  AddElement(*n\Ports()) : *n\Ports()\X = 60 : *n\Ports()\Y = 0 
  AddElement(*n\Ports()) : *n\Ports()\X = 60 : *n\Ports()\Y = 80 
EndProcedure

Procedure ReDraw(Canvas)
  If StartDrawing(CanvasOutput(Canvas))
    Box(0, 0, OutputWidth(), OutputHeight(), $FDFDFD)
    For i = 0 To OutputWidth() Step #GridSize : Line(i, 0, 1, OutputHeight(), $F2F2F2) : Next
    For i = 0 To OutputHeight() Step #GridSize : Line(0, i, OutputWidth(), 1, $F2F2F2) : Next
    
    ForEach Links()
      Protected first = #True, px, py
      ForEach Links()\Path()
        If Not first : LineXY(px, py, Links()\Path()\X, Links()\Path()\Y, $555555) : EndIf
        px = Links()\Path()\X : py = Links()\Path()\Y : first = #False
      Next
    Next
    
    ForEach Nodes()
      Box(Nodes()\X, Nodes()\Y, Nodes()\w, Nodes()\h, Nodes()\color)
      DrawingMode(#PB_2DDrawing_Transparent) : DrawText(Nodes()\X+10, Nodes()\Y+10, Nodes()\Text, $FFFFFF) : DrawingMode(#PB_2DDrawing_Default)
      ForEach Nodes()\Ports() : Circle(Nodes()\X + Nodes()\Ports()\X, Nodes()\Y + Nodes()\Ports()\Y, 5, $00FF00) : Next
    Next
    
    If *DragPort : LineXY(*ActiveSourceNode\X + *DragPort\X, *ActiveSourceNode\Y + *DragPort\Y, GetGadgetAttribute(0, #PB_Canvas_MouseX), GetGadgetAttribute(0, #PB_Canvas_MouseY), $AAAAAA) : EndIf
    StopDrawing()
  EndIf
EndProcedure

OpenWindow(0, 0, 0, 1000, 750, "Node Editor: Fixed Names & 4 Ports", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 750)
CreateEditorNode(100, 300, "Node A") : CreateEditorNode(500, 100, "Node B")

Repeat
  Event = WaitWindowEvent()
  mx = GetGadgetAttribute(0, #PB_Canvas_MouseX) : my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
  Select EventType()
    Case #PB_EventType_MouseMove
      If *DragNode
        *DragNode\X = Round((mx-DragOffX) / #GridSize, #PB_Round_Nearest) * #GridSize
        *DragNode\Y = Round((my-DragOffY) / #GridSize, #PB_Round_Nearest) * #GridSize
        ForEach Links() : RecalculatePath(Links()) : Next
      EndIf
      ReDraw(0)
    Case #PB_EventType_LeftButtonDown
      ForEach Nodes()
        ForEach Nodes()\Ports()
          If Abs(mx - (Nodes()\X + Nodes()\Ports()\X)) < 10 And Abs(my - (Nodes()\Y + Nodes()\Ports()\Y)) < 10
            *DragPort = @Nodes()\Ports() : *ActiveSourceNode = @Nodes() : Break 2
          EndIf
        Next
        If mx > Nodes()\X And mx < Nodes()\X + Nodes()\w And my > Nodes()\Y And my < Nodes()\Y + Nodes()\h
          *DragNode = @Nodes() : DragOffX = mx - Nodes()\X : DragOffY = my - Nodes()\Y : MoveElement(Nodes(), #PB_List_Last) : Break
        EndIf
      Next
    Case #PB_EventType_LeftButtonUp
      If *DragPort
        ForEach Nodes() : If @Nodes() <> *ActiveSourceNode : ForEach Nodes()\Ports()
          If Abs(mx - (Nodes()\X + Nodes()\Ports()\X)) < 10 And Abs(my - (Nodes()\Y + Nodes()\Ports()\Y)) < 10
            AddElement(Links()) : Links()\fromNode = *ActiveSourceNode : Links()\fromPort = *DragPort : Links()\toNode = @Nodes() : Links()\toPort = @Nodes()\Ports()
            RecalculatePath(Links()) : Break 2
          EndIf
        Next : EndIf : Next
      EndIf
      *DragNode = #Null : *DragPort = #Null : ReDraw(0)
  EndSelect
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; FirstLine = 27
; Folding = ------
; EnableXP
; DPIAware