EnableExplicit

; --- КОНСТАНТЫ ---
#SIDE_TOP = 0 : #SIDE_RIGHT = 1 : #SIDE_BOTTOM = 2 : #SIDE_LEFT = 3
#GRID_SIZE = 20 

Structure POINT
   X.i : Y.i
EndStructure

Structure RECT
   left.i
   top.i
   right.i
   bottom.i
EndStructure

Structure PORT Extends POINT
   Side.i : Color.i : Radius.i
EndStructure

Structure BLOCK Extends POINT
   w.i : h.i : Color.i : OffX.i : OffY.i
   Title.s
   List Ports.PORT()
EndStructure

Structure LINK
   *Block.BLOCK[2] ; Массив указателей на блоки
   *Port.PORT[2]   ; Массив указателей на порты
   Ratio.f
   Color.i
   List Path.POINT() ; Список точек маршрута
EndStructure

Global NewList Blocks.BLOCK(), NewList Links.LINK()
Global *EnteredPort.PORT = 0, *EnteredBlock.BLOCK = 0 , *DragBlock.BLOCK = 0
Global *SelectedPort.PORT = 0, *SelectedBlock.BLOCK = 0 
Global *EnteredLink.LINK = 0, *SelectLink.LINK = 0

Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro

Macro IsMouseOver(mx, my, _ptr_)
   ((mx) >= _ptr_\x And (mx) <= _ptr_\x + _ptr_\w And (my) >= _ptr_\y And (my) <= _ptr_\y + _ptr_\h)
EndMacro

Macro IsMouseOverPort(mx, my, _blk_, _prt_, _dist_)
   (Abs((_blk_\x + _prt_\x) - (mx)) < (_dist_) And Abs((_blk_\y + _prt_\y) - (my)) < (_dist_))
EndMacro

Procedure.b IsMouseOverLinkCenter(mx, my, *L.LINK)
   Protected x1 = *L\Block[0]\x + *L\Port[0]\x, y1 = *L\Block[0]\y + *L\Port[0]\y
   Protected x2 = *L\Block[1]\x + *L\Port[1]\x, y2 = *L\Block[1]\y + *L\Port[1]\y
   Protected tol = 5 ; Чуть больше допуск для удобства захвата
   
   Select *L\Port[0]\Side
      Case #SIDE_LEFT, #SIDE_RIGHT
         Protected midX = x1 + (x2 - x1) * *L\Ratio
         ; Проверяем только вертикальный средний сегмент
         If mx >= midX - tol And mx <= midX + tol And my >= Min(y1, y2) And my <= Max(y1, y2)
            ProcedureReturn #True
         EndIf
         
      Case #SIDE_TOP, #SIDE_BOTTOM
         Protected midY = y1 + (y2 - y1) * *L\Ratio
         ; Проверяем только горизонтальный средний сегмент
         If my >= midY - tol And my <= midY + tol And mx >= Min(x1, x2) And mx <= Max(x1, x2)
            ProcedureReturn #True
         EndIf
   EndSelect
   ProcedureReturn #False
EndProcedure

Procedure.b IsMouseOverLine(mx, my, *L.LINK)
   ; ProcedureReturn IsMouseOverLinkCenter(mx, my, *L)
   Protected x1 = *L\Block[0]\x + *L\Port[0]\x, y1 = *L\Block[0]\y + *L\Port[0]\y
   Protected x2 = *L\Block[1]\x + *L\Port[1]\x, y2 = *L\Block[1]\y + *L\Port[1]\y
   Protected tol = 5
   
   Select *L\Port[0]\Side
      Case #SIDE_LEFT, #SIDE_RIGHT
         Protected midX = x1 + (x2 - x1) * *L\Ratio
         If my >= y1-tol And my <= y1+tol And mx >= Min(x1, midX) And mx <= Max(x1, midX) : ProcedureReturn #True : EndIf
         If mx >= midX-tol And mx <= midX+tol And my >= Min(y1, y2) And my <= Max(y1, y2) : ProcedureReturn #True : EndIf
         If my >= y2-tol And my <= y2+tol And mx >= Min(midX, x2) And mx <= Max(midX, x2) : ProcedureReturn #True : EndIf
         
      Case #SIDE_TOP, #SIDE_BOTTOM
         Protected midY = y1 + (y2 - y1) * *L\Ratio
         If mx >= x1-tol And mx <= x1+tol And my >= Min(y1, midY) And my <= Max(y1, midY) : ProcedureReturn #True : EndIf
         If my >= midY-tol And my <= midY+tol And mx >= Min(x1, x2) And mx <= Max(x1, x2) : ProcedureReturn #True : EndIf
         If mx >= x2-tol And mx <= x2+tol And my >= Min(midY, y2) And my <= Max(midY, y2) : ProcedureReturn #True : EndIf
   EndSelect
   
   ProcedureReturn #False
EndProcedure

; Проверяем, пересекается ли сегмент с вашим объектом BLOCK
Procedure.b IsSegmentBlocked(x1, y1, x2, y2, *b.BLOCK)
   Protected minX = x1, maxX = x2 : If x1 > x2 : minX = x2 : maxX = x1 : EndIf
   Protected minY = y1, maxY = y2 : If y1 > y2 : minY = y2 : maxY = y1 : EndIf
   
   ; Границы вашего блока: x, y, w, h
   Protected b_right = *b\x + *b\w
   Protected b_bottom = *b\y + *b\h
   
   If maxX < *b\x Or minX > b_right Or maxY < *b\y Or minY > b_bottom
      ProcedureReturn #False
   EndIf
   ProcedureReturn #True
EndProcedure

; 1. Процедура РАСЧЕТА (вызывать при перемещении блоков)
Procedure UpdatePath(*L.LINK, thick)
   ClearList(*L\Path())
   
   ; Координаты старта и финиша
   ; В начале UpdatePath проверьте это:
   Protected x1 = *L\Block[0]\x + *L\Port[0]\x, y1 = *L\Block[0]\y + *L\Port[0]\y
   Protected x2 = *L\Block[1]\x + *L\Port[1]\x, y2 = *L\Block[1]\y + *L\Port[1]\y
   
   Debug "Старт: " + x1 + "," + y1 + " Конец: " + x2 + "," + y2
   Protected margin = 20 + thick
   
   AddElement(*L\Path()): *L\Path()\x = x1: *L\Path()\y = y1
   
   Select *L\Port[0]\Side
      Case #SIDE_LEFT, #SIDE_RIGHT
         Protected midX = x1 + (x2 - x1) * *L\Ratio
         
         ForEach Blocks()
            If @Blocks() = *L\Block[0] Or @Blocks() = *L\Block[1] : Continue : EndIf
            
            If IsSegmentBlocked(midX, y1, midX, y2, @Blocks())
               If x1 < x2 
                  ; Проверка: не слишком ли близко стоит препятствие к целевому блоку?
                  Protected gap = *L\Block[1]\x - (Blocks()\x + Blocks()\w)
                  If gap > 0 And gap < margin * 2
                     midX = Blocks()\x + Blocks()\w + gap / 2 ; Втискиваемся ровно посередине
                  Else
                     midX = Blocks()\x + Blocks()\w + margin
                  EndIf
               Else
                  Protected gap2 = Blocks()\x - (*L\Block[1]\x + *L\Block[1]\w)
                  If gap2 > 0 And gap2 < margin * 2
                     midX = Blocks()\x - gap2 / 2
                  Else
                     midX = Blocks()\x - margin
                  EndIf
               EndIf
               Break
            EndIf
         Next
         AddElement(*L\Path()): *L\Path()\x = midX: *L\Path()\y = y1
         AddElement(*L\Path()): *L\Path()\x = midX: *L\Path()\y = y2
         
      Case #SIDE_TOP, #SIDE_BOTTOM
         Protected midY = y1 + (y2 - y1) * *L\Ratio
         
         ForEach Blocks()
            If @Blocks() = *L\Block[0] Or @Blocks() = *L\Block[1] : Continue : EndIf
            
            If IsSegmentBlocked(x1, midY, x2, midY, @Blocks())
               If y1 < y2 
                  Protected vGap = *L\Block[1]\y - (Blocks()\y + Blocks()\h)
                  If vGap > 0 And vGap < margin * 2
                     midY = Blocks()\y + Blocks()\h + vGap / 2
                  Else
                     midY = Blocks()\y + Blocks()\h + margin
                  EndIf
               Else
                  Protected vGap2 = Blocks()\y - (*L\Block[1]\y + *L\Block[1]\h)
                  If vGap2 > 0 And vGap2 < margin * 2
                     midY = Blocks()\y - vGap2 / 2
                  Else
                     midY = Blocks()\y - margin
                  EndIf
               EndIf
               Break
            EndIf
         Next
         AddElement(*L\Path()): *L\Path()\x = x1: *L\Path()\y = midY
         AddElement(*L\Path()): *L\Path()\x = x2: *L\Path()\y = midY
   EndSelect
   
   AddElement(*L\Path()): *L\Path()\x = x2: *L\Path()\y = y2
EndProcedure

; --- 1. ВАША ЛОГИКА ОТРИСОВКИ СЕГМЕНТА (вынесена для удобства) ---
Procedure DrawSegment(x1, y1, x2, y2, thick, color)
   Protected i, offset = thick / 2
   ; Рисуем сегмент с учетом толщины (ваша логика из Case)
   If x1 = x2 ; Вертикаль
      For i = -offset To thick - 1 - offset
         LineXY(x1 + i, y1, x1 + i, y2, color)
      Next
   ElseIf y1 = y2 ; Горизонталь
      For i = -offset To thick - 1 - offset
         LineXY(x1, y1 + i, x2, y2 + i, color)
      Next
   EndIf
EndProcedure

; 2. Процедура ОТРИСОВКИ (вызывать в цикле рендера)
Procedure DrawLink(*L.LINK, thick)
   ; Если в пути меньше 2 точек, рисовать нечего
   If ListSize(*L\Path()) < 2 : ProcedureReturn : EndIf
   
   ; Фиксируем текущий элемент, чтобы не сбить цикл извне
   PushListPosition(*L\Path())
   
   FirstElement(*L\Path())
   Protected px = *L\Path()\x
   Protected py = *L\Path()\y
   
   ; Перебираем все точки и рисуем сегменты
   While NextElement(*L\Path())
      ; Debug "Рисую сегмент: " + Str(px) + "," + Str(py) + " -> " + Str(*L\Path()\x) + "," + Str(*L\Path()\y)
      
      ; Вызываем вашу процедуру рисования сегмента
      DrawSegment(px, py, *L\Path()\x, *L\Path()\y, thick, *L\Color)
      
      ; Обновляем предыдущую точку
      px = *L\Path()\x
      py = *L\Path()\y
   Wend
   
   PopListPosition(*L\Path())
EndProcedure

; --- УМНАЯ ОТРИСОВКА (ЧЕРЕЗ АДРЕС) ---
Procedure DrawSmartLine(*L.LINK, thick)
   ProcedureReturn DrawLink(*L, thick)
   
   Protected x1 = *L\Block[0]\x + *L\Port[0]\x, y1 = *L\Block[0]\y + *L\Port[0]\y
   Protected x2 = *L\Block[1]\x + *L\Port[1]\x, y2 = *L\Block[1]\y + *L\Port[1]\y
   Protected offset = thick / 2
   
   Select *L\Port[0]\Side
      Case #SIDE_LEFT, #SIDE_RIGHT
         Protected midX.f = x1 + (x2 - x1) * *L\Ratio
         ; Используем Box для отрисовки толщины за один проход
         Box(Min(x1, midX), y1 - offset, Abs(x1 - midX), thick, *L\Color) ; Гор 1
         Box(midX - offset, Min(y1, y2), thick, Abs(y1 - y2), *L\Color)   ; Вертикаль
         Box(Min(midX, x2), y2 - offset, Abs(midX - x2), thick, *L\Color) ; Гор 2
         
      Case #SIDE_TOP, #SIDE_BOTTOM
         Protected midY.f = y1 + (y2 - y1) * *L\Ratio
         Box(x1 - offset, Min(y1, midY), thick, Abs(y1 - midY), *L\Color) ; Вер 1
         Box(Min(x1, x2), midY - offset, Abs(x1 - x2), thick, *L\Color)   ; Горизонталь
         Box(x2 - offset, Min(midY, y2), thick, Abs(midY - y2), *L\Color) ; Вер 2
   EndSelect
EndProcedure

; Пример логики в цикле событий:
Procedure MoveSmartLine( mx, my, *L.LINK )
   If *L <> 0
      Protected x1 = *L\Block[0]\x + *L\Port[0]\x
      Protected y1 = *L\Block[0]\y + *L\Port[0]\y
      Protected x2 = *L\Block[1]\x + *L\Port[1]\x
      Protected y2 = *L\Block[1]\y + *L\Port[1]\y
      
      Select *L\Port[0]\Side
         Case #SIDE_LEFT, #SIDE_RIGHT
            ; Вычисляем новое Ratio относительно X (с ограничением 0.05 - 0.95)
            If x1 <> x2
               *L\Ratio = (mx - x1) / (x2 - x1)
            EndIf
            
         Case #SIDE_TOP, #SIDE_BOTTOM
            ; Вычисляем новое Ratio относительно Y
            If y1 <> y2
               *L\Ratio = (my - y1) / (y2 - y1)
            EndIf
      EndSelect
      
      ; Ограничиваем, чтобы линия не уходила "внутрь" блоков
      If *L\Ratio < 0.05 : *L\Ratio = 0.05 : EndIf
      If *L\Ratio > 0.95 : *L\Ratio = 0.95 : EndIf
   EndIf
EndProcedure

Procedure GetSideColor(Side.i)
   Select Side
         Case #SIDE_TOP : ProcedureReturn $00D7FF : Case #SIDE_RIGHT : ProcedureReturn $0000FF
         Case #SIDE_BOTTOM : ProcedureReturn $00FF00 : Case #SIDE_LEFT : ProcedureReturn $FF0000
   EndSelect
EndProcedure

Procedure AddLink( *SelectedBlock.BLOCK, *SelectedPort.PORT, *EnteredBlock.BLOCK, *EnteredPort.PORT, Ratio.f = 0.5 )
  ; Проверяем, что переданы корректные указатели
  If *SelectedPort And *EnteredPort
    
    AddElement(Links())
    
    ; Устанавливаем связи для обоих концов (индексы 0 и 1)
    Links()\Block[0] = *SelectedBlock
    Links()\Port[0]  = *SelectedPort
    
    Links()\Block[1] = *EnteredBlock
    Links()\Port[1]  = *EnteredPort
    
    ; Наследуем визуальные свойства
    Links()\Color    = *SelectedPort\Color
    Links()\Ratio    = Ratio
    
    UpdatePath(@Links(), 3)
            
    ProcedureReturn #True
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure AddPort(*b.BLOCK, side.i, radius.i = 3)
   AddElement(*b\Ports()) : *b\Ports()\Side = side : *b\Ports()\Radius = radius : *b\Ports()\Color = GetSideColor(side)
   Select side
      Case #SIDE_TOP : *b\Ports()\X = *b\w/2 : *b\Ports()\Y = 0
      Case #SIDE_RIGHT : *b\Ports()\X = *b\w   : *b\Ports()\Y = *b\h/2
      Case #SIDE_BOTTOM : *b\Ports()\X = *b\w/2 : *b\Ports()\Y = *b\h
      Case #SIDE_LEFT : *b\Ports()\X = 0      : *b\Ports()\Y = *b\h/2
   EndSelect
EndProcedure

Procedure CreateBlock(X, Y, Title.s = "Node")
   AddElement(Blocks()) : Blocks()\x = X : Blocks()\y = Y : Blocks()\w = 60 : Blocks()\h = 40
   Blocks()\Color = $F9F9F9 : Blocks()\Title = Title
   AddPort(@Blocks(), 0) : AddPort(@Blocks(), 1) : AddPort(@Blocks(), 2) : AddPort(@Blocks(), 3)
EndProcedure

Procedure ReDraw(gad)
   Protected X, Y, ww = GadgetWidth(gad), hh = GadgetHeight(gad)
   If StartDrawing(CanvasOutput(gad))
      Box(0, 0, ww, hh, $FFFFFF)
      X = 0 : While X <= ww : Line(X, 0, 1, hh, $F3F3F3) : X + #GRID_SIZE : Wend
      Y = 0 : While Y <= hh : Line(0, Y, ww, 1, $F3F3F3) : Y + #GRID_SIZE : Wend
      ForEach Links()
         Protected th = 1 : If @Links() = *EnteredLink And Not *SelectedPort : th = 3 : EndIf
         DrawSmartLine(@Links(), th)
      Next
      ForEach Blocks()
         RoundBox(Blocks()\x, Blocks()\y, Blocks()\w, Blocks()\h, 4, 4, Blocks()\Color)
         DrawingMode(#PB_2DDrawing_Outlined) : RoundBox(Blocks()\x, Blocks()\y, Blocks()\w, Blocks()\h, 4, 4, $CCCCCC)
         DrawingMode(#PB_2DDrawing_Transparent) : DrawText(Blocks()\x + 10, Blocks()\y + 8, Blocks()\Title, $444444)
         DrawingMode(#PB_2DDrawing_Default)
         ForEach Blocks()\Ports()
            Protected r = Blocks()\Ports()\Radius : If @Blocks()\Ports() = *EnteredPort : r + 2 : EndIf
            Circle(Blocks()\x + Blocks()\Ports()\x, Blocks()\y + Blocks()\Ports()\y, r, Blocks()\Ports()\Color)
         Next
      Next
      If *SelectedPort
         LineXY(*SelectedBlock\x + *SelectedPort\x, *SelectedBlock\y + *SelectedPort\y, GetGadgetAttribute(gad, #PB_Canvas_MouseX), GetGadgetAttribute(gad, #PB_Canvas_MouseY), *SelectedPort\Color)
      EndIf
      StopDrawing()
   EndIf
EndProcedure

Procedure CanvasEvents()
   Protected mx = GetGadgetAttribute(0, #PB_Canvas_MouseX), my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
   Select EventType()
      Case #PB_EventType_MouseMove
         *EnteredPort = 0 : *EnteredBlock = 0 : *EnteredLink = 0
         
         ForEach Blocks()
            ForEach Blocks()\Ports()
               If IsMouseOverPort(mx, my, Blocks(), Blocks()\Ports(), 10)
                  *EnteredPort = @Blocks()\Ports() : *EnteredBlock = @Blocks() : Break 2
               EndIf
            Next
         Next
         
         If Not *EnteredPort And Not *SelectedPort And Not *DragBlock
            ForEach Links() : If IsMouseOverLine(mx, my, @Links()) : *EnteredLink = @Links() : Break : EndIf : Next
         EndIf
         
         If *SelectLink
            MoveSmartLine(mx, my, *SelectLink)
         ElseIf *DragBlock
            *DragBlock\x = Round((mx - *DragBlock\OffX) / #GRID_SIZE, #PB_Round_Nearest) * #GRID_SIZE
            *DragBlock\y = Round((my - *DragBlock\OffY) / #GRID_SIZE, #PB_Round_Nearest) * #GRID_SIZE
            
            ; 2. ОБНОВЛЯЕМ ПУТИ всех линий, связанных с этим блоком
            ForEach Links()
               If Links()\Block[0] = *DragBlock Or Links()\Block[1] = *DragBlock
                  UpdatePath(@Links(), 3)
               EndIf
            Next
         EndIf
         
         ReDraw(0)
      Case #PB_EventType_LeftButtonDown
         ; Сначала проверяем порты (у них приоритет над телом блока)
         If *EnteredPort
            ForEach Links()
               If Links()\Port[0] = *EnteredPort And Links()\Block[0] = *EnteredBlock
                  *SelectedPort = Links()\Port[1] : *SelectedBlock = Links()\Block[1] : DeleteElement(Links()) : Break 
               EndIf
               If Links()\Port[1] = *EnteredPort And Links()\Block[1] = *EnteredBlock
                  *SelectedPort = Links()\Port[0] : *SelectedBlock = Links()\Block[0] : DeleteElement(Links()) : Break 
               EndIf
            Next
            If Not *SelectedPort : *SelectedPort = *EnteredPort : *SelectedBlock = *EnteredBlock : EndIf
            
         ElseIf *EnteredLink
            *SelectLink = *EnteredLink
         Else
            ; Ищем блок, по которому кликнули (перебираем с конца, чтобы выбрать верхний)
            LastElement(Blocks())
            Repeat
               If IsMouseOver(mx, my, Blocks())
                  *DragBlock = @Blocks()
                  ; Запоминаем, за какое место схватили блок
                  *DragBlock\OffX = mx - Blocks()\x
                  *DragBlock\OffY = my - Blocks()\y
                  
                  ; Выносим блок на передний план (Z-order)
                  MoveElement(Blocks(), #PB_List_Last)
                  Break
               EndIf
            Until PreviousElement(Blocks()) = 0
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         If *SelectedPort And *EnteredPort And *EnteredPort <> *SelectedPort
            ; Соединяем только если порты "смотрят" друг на друга
            If Abs(*SelectedPort\Side - *EnteredPort\Side) = 2
               AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort, 0.5 )
            EndIf
         EndIf
         *SelectLink = 0 : *SelectedPort = 0 : *SelectedBlock = 0 : *DragBlock = 0 : ReDraw(0)
      Case #PB_EventType_RightButtonDown
         If *EnteredLink : ChangeCurrentElement(Links(), *EnteredLink) : DeleteElement(Links()) : *EnteredLink = 0 : EndIf
         ReDraw(0)
      Case #PB_EventType_KeyDown
         If GetGadgetAttribute(0, #PB_Canvas_Key) = #PB_Shortcut_Delete
            ; Логика удаления блока: сначала удаляем все связанные Links
            ForEach Blocks() : If IsMouseOver( mx, my, @Blocks())
                  Protected *TargetB.BLOCK = @Blocks()
                  ForEach Links()
                     If Links()\Block[0] = *TargetB Or Links()\Block[1] = *TargetB : DeleteElement(Links()) : EndIf
                  Next
                  ChangeCurrentElement(Blocks(), *TargetB) : DeleteElement(Blocks()) : Break
            EndIf : Next
            ReDraw(0)
         EndIf
   EndSelect
EndProcedure

If OpenWindow(0, 0, 0, 900, 700, "Node Editor Final", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 900, 700, #PB_Canvas_Keyboard)
   CreateBlock(100, 100, "Source") : CreateBlock(440, 260, "Target") : ReDraw(0)
   Repeat : Define Event = WaitWindowEvent() : If Event = #PB_Event_Gadget And EventGadget() = 0 : CanvasEvents() : EndIf : Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 384
; FirstLine = 372
; Folding = --------------
; EnableXP
; DPIAware