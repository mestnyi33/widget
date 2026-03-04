; =================================================================
; NODE EDITOR: ВЫДЕЛЕНИЕ И ПРАВКА ЛИНИЙ
; =================================================================
EnableExplicit
#GridSize = 20

Structure Port : X.i : Y.i : color.i : Active.b : EndStructure

;- struct node
Structure Node
   X.i : Y.i : w.i : h.i : color.i : Text.s
   List Ports.Port() 
EndStructure

;- struct connect
Structure Connection
   *fromNode.Node : *toNode.Node : *fromPort.Port : *toPort.Port
   List Path.Port() 
   IsHovered.b
   color.i   ; Цвет линии (берется от порта-источника)
EndStructure

Global NewList Nodes.Node()
Global NewList Links.Connection()
Global *DragNode.Node = #Null, *DragPort.Port = #Null, *ActiveSourceNode.Node = #Null
Global *SelectedPathPoint.Port = #Null, *ActiveLink.Connection = #Null
; Переменные для отслеживания наведения на грань
Global *HoverEdgeNode.Node = #Null
Global HoverSide.i = 0
Global HoverPos.f = 0.0

; --- Добавьте эти переменные в начало к остальным Global ---
Global DragOffX.f = 0
Global DragOffY.f = 0

Global *TargetTempPort.Port = #Null ; Временная точка входа
Global *TargetTempNode.Node = #Null ; Блок, в который мы "входим"


Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro
Macro IsMouseOnPort(mx, my, nodePtr, portPtr)
   (Abs(mx - (nodePtr\x + portPtr\x)) < 12 And Abs(my - (nodePtr\y + portPtr\y)) < 12)
EndMacro

Macro IsMouseOnNode(mx, my, nodePtr)
   (mx > nodePtr\x And mx < nodePtr\x + nodePtr\w And my > nodePtr\y And my < nodePtr\y + nodePtr\h)
EndMacro

Procedure IsMouseOnSide(mx,my,  *node.Node, sidesize )
   If mx >= *node\x - sidesize And 
      mx <= *node\x + *node\w + sidesize And
      my >= *node\y - sidesize And
      my <= *node\y + *node\h + sidesize
      ;
      If Abs(mx - *node\x) <= sidesize 
         HoverSide = 1 
         HoverPos = (my - *node\y) / *node\h 
         ProcedureReturn @*node
      ElseIf Abs(my - *node\y) <= sidesize 
         HoverSide = 2 
         HoverPos = (mx - *node\x) / *node\w 
         ProcedureReturn @*node
      ElseIf Abs(mx - (*node\x + *node\w)) <= sidesize 
         HoverSide = 3 
         HoverPos = (my - *node\y) / *node\h 
         ProcedureReturn @*node
      ElseIf Abs(my - (*node\y + *node\h)) <= sidesize 
         HoverSide = 4 
         HoverPos = (mx - *node\x) / *node\w 
         ProcedureReturn @*node
      EndIf
   EndIf
EndProcedure

; --- ЛОГИКА ---

; Дистанция от точки до отрезка (для выделения линий)
Procedure.f DistToSegment(px, py, x1, y1, x2, y2)
   Protected dx = x2 - x1, dy = y2 - y1
   If dx = 0 And dy = 0 : ProcedureReturn Sqr(Pow(px-x1, 2) + Pow(py-y1, 2)) : EndIf
   Protected t.f = ((px - x1) * dx + (py - y1) * dy) / (dx * dx + dy * dy)
   If t < 0 : t = 0 : ElseIf t > 1 : t = 1 : EndIf
   ProcedureReturn Sqr(Pow(px - (x1 + t * dx), 2) + Pow(py - (y1 + t * dy), 2))
EndProcedure

Procedure GetPortSide(*n.Node, *p.Port)
   If *p\X <= 0 : ProcedureReturn 1 : ElseIf *p\Y <= 0 : ProcedureReturn 2
      ElseIf *p\X >= *n\w : ProcedureReturn 3 : ElseIf *p\Y >= *n\h : ProcedureReturn 4
   EndIf : ProcedureReturn 1
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
   offset = 20
   ;Select s1 : Case 1 : offset = 10 : Case 2 : offset = 100 : Case 3 : offset = 50 : Case 4 : offset = 50 : EndSelect
   Select s1 : Case 1 : tx1 - offset : Case 2 : ty1 - offset : Case 3 : tx1 + offset : Case 4 : ty1 + offset : EndSelect
   AddElement(*link\Path()) : *link\Path()\X = tx1 : *link\Path()\Y = ty1
   
   ; Точка 3: Подготовка входа (Stub)
   Protected tx2 = x2, ty2 = y2
   offset = 20
   ;Select s2 : Case 1 : offset = 10 : Case 2 : offset = 10 : Case 3 : offset = 50 : Case 4 : offset = 5 : EndSelect
   Select s2 : Case 1 : tx2 - offset : Case 2 : ty2 - offset : Case 3 : tx2 + offset : Case 4 : ty2 + offset : EndSelect
   
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

Procedure.i AddNotePort(*n.Node, side, position.f, color = $00FF00)
   AddElement(*n\Ports())
   *n\Ports()\color = color
   Select side
      Case 1 ; Лево
         *n\Ports()\x = 0
         *n\Ports()\y = *n\h * position 
      Case 2 ; Верх
         *n\Ports()\x = *n\w * position
         *n\Ports()\y = 0               
      Case 3 ; Право
         *n\Ports()\x = *n\w
         *n\Ports()\y = *n\h * position 
      Case 4 ; Низ
         *n\Ports()\x = *n\w * position
         *n\Ports()\y = *n\h            
   EndSelect
   ProcedureReturn @*n\Ports()
EndProcedure

Procedure UpdateDynamicTarget(mx, my, *sourceNode.Node)
   ; Если мы тянем линию и навели на грань другого блока
   If *HoverEdgeNode And *HoverEdgeNode <> *sourceNode
      
      ; Если точка еще не создана - создаем
      If *TargetTempPort = #Null
         *TargetTempPort = AddNotePort(*HoverEdgeNode, HoverSide, HoverPos, $A0A0A0)
         *TargetTempNode = *HoverEdgeNode
      Else
         ; Если мы перемещаем мышь вдоль той же грани - обновляем координаты точки
         ; Чтобы она плавно скользила за курсором
         Select HoverSide
            Case 2, 4 : *TargetTempPort\x = *TargetTempNode\w * HoverPos
            Case 1, 3 : *TargetTempPort\y = *TargetTempNode\h * HoverPos
         EndSelect
      EndIf
      
   Else
      ; Если мышь ушла с грани или вернулась на исходный блок - удаляем "призрака"
      If *TargetTempPort
         ChangeCurrentElement(*TargetTempNode\Ports(), *TargetTempPort)
         DeleteElement(*TargetTempNode\Ports())
         *TargetTempPort = #Null
         *TargetTempNode = #Null
      EndIf
   EndIf
EndProcedure


Procedure CreateNewNode(X, Y, label.s = "Блок", w = 120, h = 80, color = -1)
   Protected *n.Node = AddElement(Nodes())
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
   
   ; УЛУЧШЕНИЕ: Создаем 4 точки с отступом 0.1 от краев для красоты
   AddNotePort(*n, 1, 0.1, $00FF00) ; Слева (отступ сверху)
   AddNotePort(*n, 2, 0.1, $0000FF) ; Сверху (отступ слева)
   AddNotePort(*n, 3, 0.1, $FF0000) ; Справа (отступ сверху)
   AddNotePort(*n, 4, 0.1, $00FFFF) ; Снизу (отступ слева)
   
   ProcedureReturn *n
EndProcedure

Procedure CreateEditorNode(X, Y, t.s)
   ProcedureReturn CreateNewNode(X, Y, t.s)
   Protected *n.Node = AddElement(Nodes())
   *n\X = X : *n\Y = Y : *n\w = 120 : *n\h = 80 : *n\Text = t : *n\color = $444444
   AddElement(*n\Ports()) : *n\Ports()\X = 0 : *n\Ports()\Y = 40 
   AddElement(*n\Ports()) : *n\Ports()\X = 120 : *n\Ports()\Y = 40
   AddElement(*n\Ports()) : *n\Ports()\X = 60 : *n\Ports()\Y = 0 
   AddElement(*n\Ports()) : *n\Ports()\X = 60 : *n\Ports()\Y = 80 
EndProcedure

Procedure ReDraw(Canvas)
   Protected i, c, r
   If StartDrawing(CanvasOutput(Canvas))
      Box(0, 0, OutputWidth(), OutputHeight(), $FDFDFD)
      For i = 0 To OutputWidth() Step #GridSize : Line(i, 0, 1, OutputHeight(), $F5F5F5) : Next
      For i = 0 To OutputHeight() Step #GridSize : Line(0, i, OutputWidth(), 1, $F5F5F5) : Next
      
      ForEach Links()
         Protected first = #True, px, py, color = $AAAAAA, thickness = 1
         If Links()\IsHovered : color = $FF8800 : thickness = 3 : EndIf
         
         ForEach Links()\Path()
            If Not first
               LineXY(px, py, Links()\Path()\X, Links()\Path()\Y, color)
               If thickness > 1 ; Жирная линия
                  LineXY(px+1, py, Links()\Path()\X+1, Links()\Path()\Y, color) : LineXY(px, py+1, Links()\Path()\X, Links()\Path()\Y+1, color)
               EndIf
            EndIf
            px = Links()\Path()\X : py = Links()\Path()\Y : first = #False
            If Links()\IsHovered : Circle(px, py, 3, $FF8800) : EndIf ; Показываем узлы линии
         Next
      Next
      
      ;     ForEach Links()
      ;        LineXY(Links()\fromNode\x + Links()\fromPort\x, Links()\fromNode\y + Links()\fromPort\y, 
      ;               Links()\toNode\x + Links()\toPort\x, Links()\toNode\y + Links()\toPort\y, Links()\color)
      ;     Next
      
      ForEach Nodes()
         Box(Nodes()\X, Nodes()\Y, Nodes()\w, Nodes()\h, Nodes()\color)
         
         ; Визуальная подсветка грани при наведении
         If *HoverEdgeNode = @Nodes()
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(Nodes()\x - 1, Nodes()\y - 1, Nodes()\w + 2, Nodes()\h + 2, $00D7FF)
         EndIf
         
         DrawingMode(#PB_2DDrawing_Transparent) 
         DrawText(Nodes()\X+10, Nodes()\Y+10, Nodes()\Text, $FFFFFF) 
         DrawingMode(#PB_2DDrawing_Default)
         
         ForEach Nodes()\Ports()
            c = Nodes()\Ports()\color
            r = 4
            If Nodes()\Ports()\active
               c = $FF00FF
               r = 7
            EndIf
            Circle(Nodes()\x + Nodes()\Ports()\x, Nodes()\y + Nodes()\Ports()\y, r, c)
         Next
      Next
      
      ;If *DragPort : LineXY(*ActiveSourceNode\X + *DragPort\X, *ActiveSourceNode\Y + *DragPort\Y, GetGadgetAttribute(0, #PB_Canvas_MouseX), GetGadgetAttribute(0, #PB_Canvas_MouseY), $FFBB00) : EndIf
      If *DragPort : LineXY(*ActiveSourceNode\x + *DragPort\x, *ActiveSourceNode\y + *DragPort\y, WindowMouseX(0), WindowMouseY(0), $AAAAAA) : EndIf
      StopDrawing()
   EndIf
EndProcedure

OpenWindow(0, 0, 0, 1000, 750, "Node Editor: Line Interaction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 750)
CreateEditorNode(100, 100, "Node A") : CreateEditorNode(500, 300, "Node B")
ReDraw(0)

Repeat
   Define Event = WaitWindowEvent()
   Define mx = GetGadgetAttribute(0, #PB_Canvas_MouseX) 
   Define my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
   
   Select EventType()
      Case #PB_EventType_MouseMove
         If *DragNode
            *DragNode\X = Round((mx-DragOffX) / #GridSize, #PB_Round_Nearest) * #GridSize
            *DragNode\Y = Round((my-DragOffY) / #GridSize, #PB_Round_Nearest) * #GridSize
            
            ForEach Links() 
               If Links()\fromNode = *DragNode Or
                  Links()\toNode = *DragNode 
                  RecalculatePath(Links()) 
               EndIf 
            Next
            
         ElseIf *SelectedPathPoint
            *SelectedPathPoint\X = mx 
            *SelectedPathPoint\Y = my
         Else
            ; Проверка наведения на линии
            ForEach Links()
               Links()\IsHovered = #False
               Define lastX = -1, lastY = -1
               ForEach Links()\Path()
                  If lastX <> -1
                     If DistToSegment(mx, my, lastX, lastY, Links()\Path()\X, Links()\Path()\Y) < 5
                        Links()\IsHovered = #True : Break
                     EndIf
                  EndIf
                  lastX = Links()\Path()\X 
                  lastY = Links()\Path()\Y
               Next
            Next
         EndIf
         
         *HoverEdgeNode = #Null
         HoverSide = 0
         ForEach Nodes()
            ForEach Nodes()\Ports() 
               If IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports()) 
                  Nodes()\Ports()\active = #True 
               Else
                  Nodes()\Ports()\active = #False 
               EndIf
            Next
            
            ; Определение наведения на грань (точность 6 пикселей)
            If IsMouseOnSide( mx, my, Nodes(), 6)
               *HoverEdgeNode = @Nodes()
            EndIf
         Next
         
         ; ... (после блока определения *HoverEdgeNode) ...
         If *DragPort
            UpdateDynamicTarget(mx, my, *ActiveSourceNode)
         EndIf
         
         ReDraw(0)
         
      Case #PB_EventType_LeftButtonDown
         *DragPort = #Null
         *DragNode = #Null
         ; 1. Проверка портов и нод
         ForEach Nodes()
            ForEach Nodes()\Ports()
               If Nodes()\Ports()\active 
                  *DragPort = @Nodes()\Ports() 
                  *ActiveSourceNode = @Nodes() 
                  Break 2
               EndIf
            Next
            ; 3. Если клик в тело блока — перемещаем
            If IsMouseOnNode(mx, my, Nodes())
               *DragNode = @Nodes() 
               ; ИСПРАВЛЕНИЕ: Запоминаем дистанцию от мыши до левого верхнего угла ноды
               DragOffX = mx - Nodes()\X 
               DragOffY = my - Nodes()\Y 
               MoveElement(Nodes(), #PB_List_Last) 
               Break
            EndIf
         Next
         
         ; 2. Проверка точек на линиях (если не схватили ноду)
         If Not *DragNode And Not *DragPort
            ForEach Links()
               ForEach Links()\Path()
                  If Abs(mx - Links()\Path()\X) < 8 And Abs(my - Links()\Path()\Y) < 8
                     *SelectedPathPoint = @Links()\Path() : Break 2
                  EndIf
               Next
            Next
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         If *DragPort
            ForEach Nodes() : If @Nodes() <> *ActiveSourceNode : ForEach Nodes()\Ports()
                     If Abs(mx - (Nodes()\X + Nodes()\Ports()\X)) < 10 And Abs(my - (Nodes()\Y + Nodes()\Ports()\Y)) < 10
                        AddElement(Links()) : Links()\fromNode = *ActiveSourceNode : Links()\fromPort = *DragPort : Links()\toNode = @Nodes() : Links()\toPort = @Nodes()\Ports()
                        RecalculatePath(Links()) : Break 2
                     EndIf
            Next : EndIf : Next
         EndIf
         *DragNode = #Null : *DragPort = #Null : *SelectedPathPoint = #Null : ReDraw(0)
         
      Case #PB_EventType_RightButtonDown ; Удаление связей порта
         ForEach Nodes()
            ForEach Nodes()\Ports()
               If Nodes()\Ports()\active
                  ForEach Links()
                     If Links()\fromPort = @Nodes()\Ports() Or 
                        Links()\toPort = @Nodes()\Ports()
                        DeleteElement(Links())
                     EndIf
                  Next
               EndIf
            Next
         Next
         ReDraw(0)
         
      Case #PB_EventType_LeftDoubleClick
         CreateNewNode(mx, my)
         
   EndSelect
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 430
; FirstLine = 405
; Folding = -----------
; EnableXP
; DPIAware