EnableExplicit

;- --- 1. КОНСТАНТЫ СОСТОЯНИЙ ---
EnumerationBinary
   #State_None
   #State_Hovered
   #State_Splitter
   #State_ColumnDrag
   #State_ItemDrag
   #State_Captured
EndEnumeration

;- --- 2. СТРУКТУРЫ ---

Structure _s_TEXT
   Array Str.s(0) ; Массив строк, где индекс соответствует номеру колонки  
EndStructure

Structure _s_ITEMs
   Text._s_TEXT : Level.i : Height.i : Hide.b : IsSelected.b : IsGroup.b : IsFolded.b
EndStructure

Structure _s_COLUMN
   Text._s_TEXT : Width.i : X.i : Hide.b
EndStructure

Structure _s_ROWS Extends _s_ITEMS
   
EndStructure

Structure _s_VISIBLEITEMS
   *first._s_rows           ; first draw-elemnt in the list
   *last._s_rows            ; last draw-elemnt in the list
EndStructure

Structure _s_ROW
   ; Окошко видимости (Указатели)
   visible._s_VISIBLEITEMS
EndStructure

Structure _s_PAGE
   pos.l
   len.l
   End.l
EndStructure

Structure _s_BAR
   page._s_page
EndStructure

Structure _s_Scroll
   *v._s_WIDGET
   *h._s_WIDGET
   increment.d
EndStructure

Structure _s_WIDGET
   X.i : Y.i : Width.i : Height.i
   HeaderHeight.i : RowHeight.i : State.i
   
   Scroll._s_SCROLL
   
   ; Наведение
   *HoverItem._s_ROWS
   *HoverColumn._s_COLUMN
   
   *bar._s_BAR
   *row._s_ROW
   *root._s_ROOT
   
   ; Данные
   List __rows._s_ROWS()            ; База
   List *__Items._s_ROWS()          ; Развернутый рулон (указатели)
   List __columns._s_COLUMN()       ; Колонки
EndStructure

Structure _s_CANVAS
   Gadget.i : Window.i : Width.i : Height.i
EndStructure

Structure _s_ROOT
   Canvas._s_CANVAS
   *EnteredWidget._s_WIDGET
   *ActiveWidget._s_WIDGET
   *DragColumn._s_COLUMN : *DragItem._s_ROWS : *ResizingColumn._s_COLUMN
   List widgets._s_WIDGET()
EndStructure

Global Root._s_ROOT

;- --- 3. МАКРОСЫ ---
Macro GetActive() : Root\ActiveWidget : EndMacro
Macro Entered() : Root\EnteredWidget : EndMacro

;- --- 4. ЯДРО (ЛОГИКА) ---

; Пересчет X-координат колонок
Procedure Column_UpdateLayout(*this._s_WIDGET)
   Protected cur_x = 0
   ForEach *this\__columns()
      If Not *this\__columns()\Hide
         *this\__columns()\X = cur_x
         cur_x + *this\__columns()\Width
      EndIf
   Next
EndProcedure

; Синхронизация развернутого списка (после Folding или добавления)
Procedure Column_Sync(*this._s_WIDGET)
   ClearList(*this\__Items())
   ForEach *this\__rows()
      If Not *this\__rows()\Hide
         AddElement(*this\__Items())
         *this\__Items() = @*this\__rows()
      EndIf
   Next
EndProcedure

; Схлопывание групп
Procedure Column_ToggleGroup(*this._s_WIDGET, *group._s_ROWS)
   If Not *group\IsGroup : ProcedureReturn : EndIf
   *group\IsFolded ! 1
   Protected CurrentLevel = *group\Level
   
   PushListPosition(*this\__rows())
   ChangeCurrentElement(*this\__rows(), *group)
   While NextElement(*this\__rows()) And *this\__rows()\Level > CurrentLevel
      *this\__rows()\Hide = *group\IsFolded
   Wend
   PopListPosition(*this\__rows())
   
   Column_Sync(*this)
EndProcedure

;- --- 5. РЕНДЕРИНГ (2D) ---

Procedure ReDraw(*root._s_ROOT)
   If StartDrawing(CanvasOutput(*root\Canvas\Gadget))
      ; Общий фон Canvas
      Box(0, 0, *root\Canvas\Width, *root\Canvas\Height, $F0F0F0)
      
      ForEach *root\Widgets()
         Protected *this._s_WIDGET = @*root\Widgets()
         
         ; 1. ШАПКА (Header)
         ClipOutput(*this\X, *this\Y, *this\Width, *this\HeaderHeight)
         Box(*this\X, *this\Y, *this\Width, *this\HeaderHeight, $E5E5E5)
         ForEach *this\__columns()
            If Not *this\__columns()\Hide
               Protected cx = (*this\X + *this\__columns()\X) - *this\scroll\h\bar\page\pos
               ; Отрисовка ячейки заголовка
               Box(cx, *this\Y, *this\__columns()\Width, *this\HeaderHeight, $E5E5E5)
               DrawingMode(#PB_2DDrawing_Transparent)
               DrawText(cx + 5, *this\Y + 7, *this\__columns()\text\Str(0), $000000)
               Line(cx + *this\__columns()\Width - 1, *this\Y, 1, *this\HeaderHeight, $B0B0B0)
            EndIf
         Next
         UnclipOutput()
         
         ; 2. ТЕЛО (Итемы через Окошко)
         Protected cur_y = (*this\Y + *this\HeaderHeight) - *this\scroll\v\bar\page\pos
         *this\row\visible\first = 0 : *this\row\visible\last = 0
         
         ClipOutput(*this\X, *this\Y + *this\HeaderHeight, *this\Width - *this\scroll\increment, *this\Height - *this\HeaderHeight)
         Box(*this\X, *this\Y + *this\HeaderHeight, *this\Width, *this\Height, $FFFFFF)
         
         ForEach *this\__Items()
            Protected *row._s_ROWS = *this\__Items()
            
            ; Фильтр окошка
            If cur_y + *row\Height < *this\Y + *this\HeaderHeight 
               cur_y + *row\Height 
               Continue 
            EndIf
            If cur_y > *this\Y + *this\Height 
               Break 
            EndIf
            
            If Not *this\row\visible\first 
               *this\row\visible\first = *row 
            EndIf
            *this\row\visible\last = *row
            
            DrawingMode(#PB_2DDrawing_Default)
               ; Фон выделения
            If *row\IsSelected 
               Box(*this\X, cur_y, *this\Width, *row\Height, $D1E5FE) 
            EndIf
            ; Фантом при Drag-and-Drop
            If *row = *root\DragItem 
               Box(*this\X, cur_y, *this\Width, *row\Height, $F0F0F0) 
            EndIf
            
            ; Отрисовка колонок итема
            ForEach *this\__columns()
               Protected col_x = (*this\X + *this\__columns()\X) - *this\scroll\h\bar\page\pos
               Protected txt$ = *row\text\Str(ListIndex(*this\__columns()))
               
               Protected off = 0 : If ListIndex(*this\__columns()) = 0 : off = *row\Level * 16 + 18 : EndIf
               DrawingMode(#PB_2DDrawing_Transparent)
               DrawText(col_x + 5 + off, cur_y + 4, txt$, $000000)
               
               ; Иконка группы (Folding)
               If *row\IsGroup And ListIndex(*this\__columns()) = 0
                  Protected icol = $808080 : If *row\IsFolded : icol = $0000FF : EndIf
                  Circle(col_x + off - 10, cur_y + 12, 4, icol)
               EndIf
            Next
            
            Line(*this\X, cur_y + *row\Height - 1, *this\Width, 1, $EEEEEE)
            cur_y + *row\Height
         Next
         UnclipOutput()
         
         ; 3. СКРОЛЛБАРЫ (2D Рисование)
         Protected vh = *this\Height - *this\HeaderHeight
         Protected total_h = ListSize(*this\__Items()) * *this\RowHeight
         If total_h > vh
            Protected th = (vh * vh) / total_h
            Protected ty = *this\Y + *this\HeaderHeight + (*this\scroll\v\bar\page\pos * (vh - th)) / (total_h - vh)
            Box(*this\X + *this\Width - 6, ty, 4, th, $A0A0A0)
         EndIf
         
         ; Рамка виджета
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(*this\X, *this\Y, *this\Width, *this\Height, $A0A0A0)
         DrawingMode(#PB_2DDrawing_Default)
      Next
      StopDrawing()
   EndIf
EndProcedure

;- --- 6. СОБЫТИЯ И SWAP ---

Procedure _Column_HandleSwap(*root._s_ROOT, mx, my)
   Protected *this._s_WIDGET = *root\ActiveWidget
   If Not *this : ProcedureReturn : EndIf
   
   ; --- 1. ПЕРЕМЕЩЕНИЕ КОЛОНОК ---
   If *root\DragColumn
      ForEach *this\__columns()
         Protected *col._s_COLUMN = @*this\__columns()
         If *col = *root\DragColumn : Continue : EndIf ; Пропускаем саму себя
         
         Protected cx = *this\X + *col\X - *this\scroll\h\bar\page\pos
         ; Если мышь пересекла середину другой колонки
         If mx > cx And mx < cx + *col\Width
            Protected mid = cx + *col\Width / 2
            If mx < mid
               MoveElement(*this\__columns(), #PB_List_Before, *col)
            Else
               MoveElement(*this\__columns(), #PB_List_After, *col)
            EndIf
            Column_UpdateLayout(*this) ; Пересчитываем X-координаты
            Break
         EndIf
      Next
      
   ; --- 2. ПЕРЕМЕЩЕНИЕ СТРОК (Drag-and-Drop) ---
   ElseIf *root\DragItem
      ; Используем HoverItem, который уже нашелся в HandleEvents
      If *this\HoverItem And *this\HoverItem <> *root\DragItem
         ; Находим положение DragItem в визуальном списке
         PushListPosition(*this\__Items())
         
         ; Находим элемент-донор (тот, что тащим)
         ForEach *this\__Items()
            If *this\__Items() = *root\DragItem
               *root\DragItem = *this\__Items() ; Гарантируем корректный указатель
               Break
            EndIf
         Next
         
         ; Перемещаем его относительно HoverItem (над кем мышь)
         MoveElement(*this\__Items(), #PB_List_Before, *this\HoverItem)
         
         PopListPosition(*this\__Items())
      EndIf
   EndIf
EndProcedure
Procedure Column_HandleSwap(*root._s_ROOT, mx, my)
   Protected *this._s_WIDGET = GetActive()
   If Not *this : ProcedureReturn : EndIf
   
   ; --- ПЕРЕМЕЩЕНИЕ КОЛОНОК ---
   If *root\DragColumn
      ForEach *this\__columns()
         If @*this\__columns() = *root\DragColumn : Continue : EndIf
         
         Protected cx = *this\X + *this\__columns()\X - *this\scroll\h\bar\page\pos
         ; Если мышь зашла на территорию соседней колонки
         If mx > cx And mx < cx + *this\__columns()\Width
            ; Запоминаем текущую, чтобы не потерять итератор
            Protected *target = @*this\__columns()
            PushListPosition(*this\__columns())
            ChangeCurrentElement(*this\__columns(), *root\DragColumn)
            MoveElement(*this\__columns(), #PB_List_Before, *target)
            PopListPosition(*this\__columns())
            
            Column_UpdateLayout(*this)
            Break
         EndIf
      Next
      
   ; --- ПЕРЕМЕЩЕНИЕ СТРОК ---
   ElseIf *root\DragItem And *this\HoverItem
      If *this\HoverItem <> *root\DragItem
         PushListPosition(*this\__Items())
         ; Ищем DragItem в визуальном списке
         ForEach *this\__Items()
            If *this\__Items() = *root\DragItem
               ; Перемещаем его относительно HoverItem
               MoveElement(*this\__Items(), #PB_List_Before, *this\HoverItem)
               Break
            EndIf
         Next
         PopListPosition(*this\__Items())
      EndIf
   EndIf
EndProcedure

Procedure  DoEvents( *this._s_WIDGET, event.i, mx.i,my.i )
   Protected *root._s_ROOT = *this\root
   Select event
      Case #PB_EventType_LeftButtonDown
         GetActive() = Entered()
         
         If *this\HoverColumn
            Protected edge = *this\X + *this\HoverColumn\X + *this\HoverColumn\Width - *this\scroll\h\bar\page\pos
            ; Проверка Сплиттера (Multi-Splitter)
            If Abs(mx - edge) < 6 
               *root\ResizingColumn = *this\HoverColumn ; Тянем край (Resize)
            Else
               *root\DragColumn = *this\HoverColumn     ; ТЯНЕМ ВСЮ КОЛОНКУ (Drag)
            EndIf
         EndIf
         
         If Not *root\ResizingColumn And *this\HoverItem
            *root\DragItem = *this\HoverItem            ; ТЯНЕМ СТРОКУ (Drag)
                                                        ; ... твой код выделения и фолдинга ...
             ; Клик по иконке группы (Folding)
            If Not *root\ResizingColumn And *this\HoverItem
               If mx < *this\X + 60 And *this\HoverItem\IsGroup : Column_ToggleGroup(*this, *this\HoverItem) : EndIf
               ForEach *this\__rows() : *this\__rows()\IsSelected = #False : Next
               *this\HoverItem\IsSelected = #True
            EndIf
         EndIf
         ReDraw(*root)
         
      Case #PB_EventType_MouseMove
         If *root\ResizingColumn
            ; Твой код изменения ширины...
            *root\ResizingColumn\Width = (mx + *this\scroll\h\bar\page\pos) - (*this\X + *root\ResizingColumn\X)
            Column_UpdateLayout(*this)
         ElseIf *root\DragColumn Or *root\DragItem
            Column_HandleSwap(*root, mx, my)
         EndIf
         ReDraw(*root)
         
      Case #PB_EventType_MouseWheel
         Protected delta = GetGadgetAttribute(*root\Canvas\Gadget, #PB_Canvas_WheelDelta)
         *this\scroll\v\bar\page\pos - (delta * *this\RowHeight * 2)
         If *this\scroll\v\bar\page\pos < 0 : *this\scroll\v\bar\page\pos = 0 : EndIf
         ReDraw(*root)
         
      Case #PB_EventType_LeftButtonUp
         *root\ResizingColumn = 0
         *root\DragColumn = 0
         *root\DragItem = 0
         
   EndSelect

EndProcedure

Procedure Column_HandleEvents(*root._s_ROOT, et)
   Protected mx = GetGadgetAttribute(*root\Canvas\Gadget, #PB_Canvas_MouseX)
   Protected my = GetGadgetAttribute(*root\Canvas\Gadget, #PB_Canvas_MouseY)
   
   ; --- HIT-TEST ---
   *root\ActiveWidget = 0
   ForEach *root\Widgets()
      Protected *this._s_WIDGET = @*root\Widgets()
      If mx >= *this\X And mx <= *this\X + *this\Width And my >= *this\Y And my <= *this\Y + *this\Height
         *root\EnteredWidget = *this
         ; Ищем колонку
         ForEach *this\__columns()
            If mx - *this\X + *this\scroll\h\bar\page\pos >= *this\__columns()\X And mx - *this\X + *this\scroll\h\bar\page\pos <= *this\__columns()\X + *this\__columns()\Width
               *this\HoverColumn = @*this\__columns() : Break
            EndIf
         Next
         ; Ищем итем (от First до Last)
         If *this\row\visible\first
            Protected cy = (*this\Y + *this\HeaderHeight) - *this\scroll\v\bar\page\pos
            ChangeCurrentElement(*this\__Items(), *this\row\visible\first)
            Repeat
               If my >= cy And my < cy + *this\__Items()\Height : *this\HoverItem = *this\__Items() : Break : EndIf
               cy + *this\__Items()\Height
            Until *this\__Items() = *this\row\visible\last Or Not NextElement(*this\__Items())
         EndIf
      EndIf
   Next
   
   If Not Entered( ) : ProcedureReturn : EndIf
   DoEvents( Entered(), et, mx,my )
EndProcedure

;- --- 7. API ---

Procedure OpenRoot(Window, X, Y, Width, Height)
   Root\Canvas\Window = Window : Root\Canvas\Gadget = CanvasGadget(#PB_Any, X, Y, Width, Height, #PB_Canvas_Keyboard)
   Root\Canvas\Width = Width : Root\Canvas\Height = Height : ProcedureReturn Root\Canvas\Gadget
EndProcedure

Procedure.i Column_Create(X, Y, Width, Height)
   AddElement(Root\Widgets()) : Protected *this._s_WIDGET = @Root\Widgets()
   *this\root = Root
   *this\row = AllocateStructure(_s_ROW)
   *this\scroll\v = AllocateStructure(_s_WIDGET)
   *this\scroll\v\bar = AllocateStructure(_s_BAR)
   *this\scroll\h = AllocateStructure(_s_WIDGET)
   *this\scroll\h\bar = AllocateStructure(_s_BAR)
   *this\scroll\increment = 10
   
   *this\X = X : *this\Y = Y : *this\Width = Width : *this\Height = Height : *this\HeaderHeight = 30 : *this\RowHeight = 25 
   ProcedureReturn *this
EndProcedure

Procedure Column_AddColumn(*this._s_WIDGET, title$, Width)
   AddElement(*this\__columns()) : *this\__columns()\text\Str(0) = title$ : *this\__columns()\Width = Width
   Column_UpdateLayout(*this)
EndProcedure

Procedure Column_AddItem(*this._s_WIDGET, item, Text$, Level=0, isgroup=#False)
   AddElement(*this\__rows()) 
   Protected i, TotalCols = ListSize(*this\__columns()) - 1
   ;    
   ;    ; 1. Выделяем массив СРАЗУ (используем заранее известное число)
   ;    ReDim *this\__rows()\text\str(0)(TotalCols) 
   ;    
   ;    ; 2. Заполняем через простой цикл (без ForEach по колонкам!)
   ;    ; Если используете StringField (самый простой путь):
   ;    For i = 0 To TotalCols
   ;       *this\__rows()\text\str(0)(i) = StringField(Text$, i + 1, #LF$)
   ;    Next
   
   ; 2. Выделяем массив СРАЗУ под все колонки (экономим 320 МБ RAM)
   ; Один ReDim на итем — это в 200 раз быстрее, чем ReDim в цикле
   ReDim *this\__rows()\text\Str(TotalCols)
   
   ; 3. Ультра-быстрый разбор строки через указатели (O(N))
   Protected *ptr.Character = @Text$ 
   Protected *start = *ptr           
   
   While *ptr\c <> 0 And i <= TotalCols
      If *ptr\c = 10 ; Если встретили Chr(10)
                     ; Записываем текст колонки в массив
                     ; *this\__rows()\text\str(i) = PeekS(*start, (*ptr - *start) / SizeOf(Character))
         *this\__rows()\text\Str(i) = PeekS(*start, (*ptr - *start) >> 1)
         
         *start = *ptr + 2 ; SizeOf(Character) ; Сдвигаем начало следующей колонки
         i + 1
      EndIf
      *ptr + SizeOf(Character)
   Wend
   
   ; Добавляем последнюю колонку (хвост строки)
   If i <= TotalCols
      *this\__rows()\text\Str(i) = PeekS(*start)
   EndIf
   
   *this\__rows()\Level = Level : *this\__rows()\Height = *this\RowHeight : *this\__rows()\IsGroup = isgroup
   Column_Sync(*this)
EndProcedure

;- --- 8. ЗАПУСК ---

OpenWindow(0, 0, 0, 800, 600, "Master 2D Listicon", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
OpenRoot(0, 0, 0, 800, 600)

Define *this1._s_WIDGET = Column_Create(10, 10, 350, 580)
Column_AddColumn(*this1, "Settings", 150) : Column_AddColumn(*this1, "Value", 150)
Column_AddItem(*this1, -1, "User Interface", 0, #True)
Define i
For i = 1 To 20 : Column_AddItem(*this1, -1, "Option " + Str(i)+ Chr(10) +"Enabled", 1) : Next
Column_AddItem(*this1, -1, "Advanced", 0, #True)
Column_AddItem(*this1, -1, "Debug Mode" +Chr(10) + "Off", 1)

Define *this2 = Column_Create(370, 10, 420, 580)
Column_AddColumn(*this2, "Settings", 150) : Column_AddColumn(*this2, "Value", 150)
Column_AddItem(*this2, -1, "Александр" + Chr(10) + "31" + Chr(10) + "Москва", 0)
Column_AddItem(*this2, -1, "Елена" + Chr(10) + "24" + Chr(10) + "Владивосток")
Column_AddItem(*this2, -1, "Дмитрий" + Chr(10) + "45" + Chr(10) + "Тула")

ReDraw(@Root)

Repeat
   Define ev = WaitWindowEvent()
   If ev = #PB_Event_Gadget And EventGadget() = Root\Canvas\Gadget
      Column_HandleEvents(@Root, EventType())
   EndIf
Until ev = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 500
; FirstLine = 473
; Folding = ------------
; EnableXP
; DPIAware