; =================================================================
; Block EDITOR: ВЫДЕЛЕНИЕ И ПРАВКА ЛИНИЙ
; =================================================================
EnableExplicit
#GridSize = 20

Structure Port : X.i : Y.i : color.i : round.b : Active.b : EndStructure
Structure Block : X.i : Y.i : Width.i : Height.i : color.i : Text.s : List Ports.Port() : EndStructure
Structure Connection : *fromBlock.Block : *fromPort.Port : *toBlock.Block : *toPort.Port : List Path.Port() : IsHovered.b : IsDragging.b : color.i : EndStructure

Global *DragLink.Connection = #Null ; Ссылка на перемещаемую линию

Global NewList Blocks.Block()
Global NewList Links.Connection()
Global *DragBlock.Block = #Null, *DragPort.Port = #Null, *ActiveSourceBlock.Block = #Null
Global *SelectedPathPoint.Port = #Null, *ActiveLink.Connection = #Null
Global *HoverEdgeBlock.Block = #Null
Global *TargetTempPort.Port = #Null ; Временная точка входа
Global *TargetTempBlock.Block = #Null ; Блок, в который мы "входим"

Global HoverSide.i = 0
Global HoverPos.f = 0.0

Global DragOffX.f = 0
Global DragOffY.f = 0

Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro
Macro IsMouseOnPort(mx, my, BlockPtr, portPtr)
   (Abs(mx - (BlockPtr\x + portPtr\x)) < portPtr\round And Abs(my - (BlockPtr\y + portPtr\y)) < portPtr\round)
EndMacro

Macro IsMouseOnBlock(mx, my, BlockPtr)
   (mx > BlockPtr\x And mx < BlockPtr\x + BlockPtr\width And my > BlockPtr\y And my < BlockPtr\y + BlockPtr\height)
EndMacro

Procedure IsMouseOnSide(*Block.Block, mx,my, sidesize )
   If mx >= *Block\x - sidesize And 
      mx <= *Block\x + *Block\width + sidesize And
      my >= *Block\y - sidesize And
      my <= *Block\y + *Block\height + sidesize
      ;
      If Abs(mx - *Block\x) <= sidesize 
         HoverSide = 1 
         HoverPos = (my - *Block\y) / *Block\height 
         ProcedureReturn @*Block
      ElseIf Abs(my - *Block\y) <= sidesize 
         HoverSide = 2 
         HoverPos = (mx - *Block\x) / *Block\width 
         ProcedureReturn @*Block
      ElseIf Abs(mx - (*Block\x + *Block\width)) <= sidesize 
         HoverSide = 3 
         HoverPos = (my - *Block\y) / *Block\height 
         ProcedureReturn @*Block
      ElseIf Abs(my - (*Block\y + *Block\height)) <= sidesize 
         HoverSide = 4 
         HoverPos = (mx - *Block\x) / *Block\width 
         ProcedureReturn @*Block
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

Procedure GetPortSide(*n.Block, *p.Port)
   If *p\X <= 0 : ProcedureReturn 1 : ElseIf *p\Y <= 0 : ProcedureReturn 2
      ElseIf *p\X >= *n\width : ProcedureReturn 3 : ElseIf *p\Y >= *n\height : ProcedureReturn 4
   EndIf : ProcedureReturn 1
EndProcedure


Procedure RecalculatePath(*link.Connection)
   ClearList(*link\Path())
   Protected x1 = *link\fromBlock\X + *link\fromPort\X
   Protected y1 = *link\fromBlock\Y + *link\fromPort\Y
   Protected x2 = *link\toBlock\X + *link\toPort\X
   Protected y2 = *link\toBlock\Y + *link\toPort\Y
   
   Protected s1 = GetPortSide(*link\fromBlock, *link\fromPort)
   Protected s2 = GetPortSide(*link\toBlock, *link\toPort)
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

Procedure.i AddBlockPort(*n.Block, side, position.f, color = $00FF00)
   AddElement(*n\Ports())
   *n\Ports()\color = color
   *n\Ports()\round = 12
   Select side
      Case 1 ; Лево
         *n\Ports()\x = 0
         *n\Ports()\y = *n\height * position 
      Case 2 ; Верх
         *n\Ports()\x = *n\width * position
         *n\Ports()\y = 0               
      Case 3 ; Право
         *n\Ports()\x = *n\width
         *n\Ports()\y = *n\height * position 
      Case 4 ; Низ
         *n\Ports()\x = *n\width * position
         *n\Ports()\y = *n\height            
   EndSelect
   ProcedureReturn @*n\Ports()
EndProcedure

Procedure UpdateDynamicTarget(mx, my, *sourceBlock.Block)
   ; Если мы тянем линию и навели на грань другого блока
   If *HoverEdgeBlock And *HoverEdgeBlock <> *sourceBlock
      
      ; Если точка еще не создана - создаем
      If *TargetTempPort = #Null
         *TargetTempPort = AddBlockPort(*HoverEdgeBlock, HoverSide, HoverPos, $A0A0A0)
         *TargetTempBlock = *HoverEdgeBlock
      Else
         ; Если мы перемещаем мышь вдоль той же грани - обновляем координаты точки
         ; Чтобы она плавно скользила за курсором
         Select HoverSide
            Case 2, 4 : *TargetTempPort\x = *TargetTempBlock\width * HoverPos
            Case 1, 3 : *TargetTempPort\y = *TargetTempBlock\height * HoverPos
         EndSelect
      EndIf
      
   Else
      ; Если мышь ушла с грани или вернулась на исходный блок - удаляем "призрака"
      If *TargetTempPort
         ChangeCurrentElement(*TargetTempBlock\Ports(), *TargetTempPort)
         DeleteElement(*TargetTempBlock\Ports())
         *TargetTempPort = #Null
         *TargetTempBlock = #Null
      EndIf
   EndIf
EndProcedure


Procedure CreateNewBlock(X, Y, label.s = "Блок", w = 120, h = 80, color = -1)
   Protected *n.Block = AddElement(Blocks())
   *n\x = X - w/2
   *n\y = Y - h/2
   *n\width = w
   *n\height = h
   *n\text = label
   If color = -1
      *n\color = RGB(Random(150), Random(150), Random(150))
   Else
      *n\color = color
   EndIf
   
   ; УЛУЧШЕНИЕ: Создаем 4 точки с отступом 0.1 от краев для красоты
   AddBlockPort(*n, 1, 0.1, $00FF00) ; Слева (отступ сверху)
   AddBlockPort(*n, 2, 0.1, $0000FF) ; Сверху (отступ слева)
   AddBlockPort(*n, 3, 0.1, $FF0000) ; Справа (отступ сверху)
   AddBlockPort(*n, 4, 0.1, $00FFFF) ; Снизу (отступ слева)
   
   ProcedureReturn *n
EndProcedure

Procedure CreateEditorBlock(X, Y, t.s)
   ProcedureReturn CreateNewBlock(X, Y, t.s)
   Protected *n.Block = AddElement(Blocks())
   *n\X = X : *n\Y = Y : *n\width = 120 : *n\height = 80 : *n\Text = t : *n\color = $444444
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
      ;        LineXY(Links()\fromBlock\x + Links()\fromPort\x, Links()\fromBlock\y + Links()\fromPort\y, 
      ;               Links()\toBlock\x + Links()\toPort\x, Links()\toBlock\y + Links()\toPort\y, Links()\color)
      ;     Next
      
      ForEach Blocks()
         Box(Blocks()\X, Blocks()\Y, Blocks()\width, Blocks()\height, Blocks()\color)
         
         ; Визуальная подсветка грани при наведении
         If *HoverEdgeBlock = @Blocks()
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(Blocks()\x - 1, Blocks()\y - 1, Blocks()\width + 2, Blocks()\height + 2, $00D7FF)
         EndIf
         
         DrawingMode(#PB_2DDrawing_Transparent) 
         DrawText(Blocks()\X+10, Blocks()\Y+10, Blocks()\Text, $FFFFFF) 
         DrawingMode(#PB_2DDrawing_Default)
         
         ForEach Blocks()\Ports()
            c = Blocks()\Ports()\color
            r = 4
            If Blocks()\Ports()\active
               c = $FF00FF
               r = 7
            EndIf
            Circle(Blocks()\x + Blocks()\Ports()\x, Blocks()\y + Blocks()\Ports()\y, r, c)
         Next
      Next
      
      ;If *DragPort : LineXY(*ActiveSourceBlock\X + *DragPort\X, *ActiveSourceBlock\Y + *DragPort\Y, GetGadgetAttribute(0, #PB_Canvas_MouseX), GetGadgetAttribute(0, #PB_Canvas_MouseY), $FFBB00) : EndIf
      If *DragPort : LineXY(*ActiveSourceBlock\x + *DragPort\x, *ActiveSourceBlock\y + *DragPort\y, WindowMouseX(0), WindowMouseY(0), $AAAAAA) : EndIf
      StopDrawing()
   EndIf
EndProcedure

OpenWindow(0, 0, 0, 1000, 750, "Block Editor: Line Interaction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 750)
CreateEditorBlock(100, 100, "Block A") : CreateEditorBlock(500, 300, "Block B")
ReDraw(0)

Repeat
   Define Event = WaitWindowEvent()
   Define mx = GetGadgetAttribute(0, #PB_Canvas_MouseX) 
   Define my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
   
   Select EventType()
      Case #PB_EventType_MouseMove
         If *DragBlock
            *DragBlock\X = Round((mx-DragOffX) / #GridSize, #PB_Round_Nearest) * #GridSize
            *DragBlock\Y = Round((my-DragOffY) / #GridSize, #PB_Round_Nearest) * #GridSize
            
            ForEach Links() 
               If Links()\fromBlock = *DragBlock Or
                  Links()\toBlock = *DragBlock 
                  RecalculatePath(Links()) 
               EndIf 
            Next
            
         ElseIf *SelectedPathPoint
            *SelectedPathPoint\X = mx 
            *SelectedPathPoint\Y = my
;          ElseIf *DragLink
;             Define dx = mx - DragOffX, dy = my - DragOffY
;             ForEach *DragLink\Path()
;                *DragLink\Path()\X + dx
;                *DragLink\Path()\Y + dy
;             Next
;             DragOffX = mx : DragOffY = my ; Обновляем базу для следующего шага
            ElseIf *DragLink
               Define dx = mx - DragOffX 
               Define dy = my - DragOffY
        Define  count = ListSize(*DragLink\Path()), i = 0
        ForEach *DragLink\Path()
          ; Двигаем только если это НЕ первая и НЕ последняя точка пути
          If i > 1 And i < count - 2
            *DragLink\Path()\X + dx
            *DragLink\Path()\Y + dy
          EndIf
          i + 1
        Next
        DragOffX = mx : DragOffY = my

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
         
         *HoverEdgeBlock = #Null
         HoverSide = 0
         ForEach Blocks()
            ForEach Blocks()\Ports() 
               If IsMouseOnPort(mx, my, Blocks(), Blocks()\Ports()) 
                  Blocks()\Ports()\active = #True 
               Else
                  Blocks()\Ports()\active = #False 
               EndIf
            Next
            
            ; Определение наведения на грань (точность 6 пикселей)
            If IsMouseOnSide( Blocks(), mx, my, 6)
               *HoverEdgeBlock = @Blocks()
            EndIf
         Next
         
         ; ... (после блока определения *HoverEdgeBlock) ...
         If *DragPort
            UpdateDynamicTarget(mx, my, *ActiveSourceBlock)
         EndIf
         
         ReDraw(0)
         
      Case #PB_EventType_LeftButtonDown
         *DragPort = #Null
         *DragBlock = #Null
         ; 1. Проверка портов и нод
         ForEach Blocks()
            ForEach Blocks()\Ports()
               If Blocks()\Ports()\active 
                  *DragPort = @Blocks()\Ports() 
                  *ActiveSourceBlock = @Blocks() 
                  Break 2
               EndIf
            Next
            ; 3. Если клик в тело блока — перемещаем
            If IsMouseOnBlock(mx, my, Blocks())
               *DragBlock = @Blocks() 
               ; ИСПРАВЛЕНИЕ: Запоминаем дистанцию от мыши до левого верхнего угла ноды
               DragOffX = mx - Blocks()\X 
               DragOffY = my - Blocks()\Y 
               MoveElement(Blocks(), #PB_List_Last) 
               Break
            EndIf
         Next
         
         ; 2. Проверка точек на линиях (если не схватили ноду)
         If Not *DragBlock And Not *DragPort
            ForEach Links()
               ForEach Links()\Path()
                  If Abs(mx - Links()\Path()\X) < 8 And Abs(my - Links()\Path()\Y) < 8
                     *SelectedPathPoint = @Links()\Path() : Break 2
                  EndIf
               Next
            Next
         EndIf
         
         ; В CASE #PB_EventType_LeftButtonDown (после проверки точек):
         If Not *DragBlock And Not *DragPort And Not *SelectedPathPoint
            ForEach Links()
               If Links()\IsHovered
                  *DragLink = @Links()
                  DragOffX = mx 
                  DragOffY = my
                  Break
               EndIf
            Next
         EndIf

      Case #PB_EventType_LeftButtonUp
         If *DragPort
            ForEach Blocks() : If @Blocks() <> *ActiveSourceBlock : ForEach Blocks()\Ports()
                     If Abs(mx - (Blocks()\X + Blocks()\Ports()\X)) < 10 And Abs(my - (Blocks()\Y + Blocks()\Ports()\Y)) < 10
                        AddElement(Links()) : Links()\fromBlock = *ActiveSourceBlock : Links()\fromPort = *DragPort : Links()\toBlock = @Blocks() : Links()\toPort = @Blocks()\Ports()
                        RecalculatePath(Links()) : Break 2
                     EndIf
            Next : EndIf : Next
         EndIf
         *SelectedPathPoint = #Null 
         *DragBlock = #Null 
         *DragPort = #Null 
         *DragLink = #Null
         ReDraw(0)
         
      Case #PB_EventType_RightButtonDown ; Удаление связей порта
         ForEach Blocks()
            ForEach Blocks()\Ports()
               If Blocks()\Ports()\active
                  ForEach Links()
                     If Links()\fromPort = @Blocks()\Ports() Or 
                        Links()\toPort = @Blocks()\Ports()
                        DeleteElement(Links())
                     EndIf
                  Next
               EndIf
            Next
         Next
         ReDraw(0)
         
      Case #PB_EventType_LeftDoubleClick
         CreateNewBlock(mx, my)
         
   EndSelect
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 7
; FirstLine = 127
; Folding = -----------
; EnableXP
; DPIAware