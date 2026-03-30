; Прототип функции, которую ты будешь привязывать через Bind
Prototype.i ProtoOnEvent(*this, Type.i)
Enumeration 1
   ;#__event_Create
   #__event_Focus
   #__event_LostFocus
   ;
   #__event_MouseEnter
   #__event_MouseMove
   #__event_MouseLeave
   ;
   #__event_Down
   #__event_Up
   #__event_Click
   
   #__event_DragStart
   #__event_Drop
   ;
   #__event
EndEnumeration

;
;-\\ create-type
#__type_Root          = - 1
#__type_Window        = - 2
#__type_Message       = - 3
#__type_PopupBar      = - 4
#__type_MenuBar       = - 5
#__type_ToolBar       = - 6
#__type_TabBar        = - 7
#__type_StatusBar     = - 8
#__type_Properties    = - 9
;
; #__type_Toggled       = - 10
; #__type_ImageButton   = - 11
; #__type_StringButton  = - 12
; #__type_Hiasm         = - 13
;
#__type_Unknown       = #PB_GadgetType_Unknown       ; 0
#__type_Button        = #PB_GadgetType_Button        ; 1
#__type_String        = #PB_GadgetType_String        ; 2
#__type_Text          = #PB_GadgetType_Text          ; 3
#__type_CheckBox      = #PB_GadgetType_CheckBox      ; 4
#__type_Option        = #PB_GadgetType_Option        ; 5
#__type_ListView      = #PB_GadgetType_ListView      ; 6
#__type_Frame         = #PB_GadgetType_Frame         ; 7
#__type_ComboBox      = #PB_GadgetType_ComboBox      ; 8
#__type_Image         = #PB_GadgetType_Image         ; 9
#__type_HyperLink     = #PB_GadgetType_HyperLink     ; 10
#__type_Container     = #PB_GadgetType_Container     ; 11
#__type_ListIcon      = #PB_GadgetType_ListIcon      ; 12
#__type_IPAddress     = #PB_GadgetType_IPAddress     ; 13
#__type_Progress      = #PB_GadgetType_ProgressBar   ; 14   ;
#__type_Scroll        = #PB_GadgetType_ScrollBar     ; 15   ;
#__type_ScrollArea    = #PB_GadgetType_ScrollArea    ; 16
#__type_Track         = #PB_GadgetType_TrackBar      ; 17   ;
#__type_Web           = #PB_GadgetType_Web           ; 18
#__type_ButtonImage   = #PB_GadgetType_ButtonImage   ; 19
#__type_Calendar      = #PB_GadgetType_Calendar      ; 20
#__type_Date          = #PB_GadgetType_Date          ; 21
#__type_Editor        = #PB_GadgetType_Editor        ; 22
#__type_ExplorerList  = #PB_GadgetType_ExplorerList  ; 23
#__type_ExplorerTree  = #PB_GadgetType_ExplorerTree  ; 24
#__type_ExplorerCombo = #PB_GadgetType_ExplorerCombo ; 25
#__type_Spin          = #PB_GadgetType_Spin          ; 26
#__type_Tree          = #PB_GadgetType_Tree          ; 27
#__type_Panel         = #PB_GadgetType_Panel         ; 28
#__type_Splitter      = #PB_GadgetType_Splitter      ; 29
#__type_MDI           = #PB_GadgetType_MDI           ; 30
                                                     ;
#__type_Scintilla     = #PB_GadgetType_Scintilla     ; 31
#__type_Shortcut      = #PB_GadgetType_Shortcut      ; 32
#__type_Canvas        = #PB_GadgetType_Canvas        ; 33
#__type_OpenGL        = #PB_GadgetType_OpenGL        ; 34

; ==============================================================================
; МАСКИ (Quad #__mask_*)
; ==============================================================================
#___mask_active    = 1 << 0  ; Фокус (Виджет) / Выделение (Строка)
#___mask_node      = 1 << 1  ; Является узлом (Строка) / Деревом (Виджет)
#___mask_collapsed = 1 << 2  ; Свернуто (Узел/Ветка)
#___mask_shift     = 1 << 3  ; Зажат Shift (Мышь) / Режим диапазона
#___mask_ctrl      = 1 << 4  ; Зажат Ctrl (Мышь) / Режим инверсии
#___mask_update    = 1 << 5  ; Флаг: Требуется пересчет геометрии (TextWidth и т.д.)
#___mask_redraw    = 1 << 6  ; Флаг: Требуется перерисовка
#___mask_drag      = 1 << 7  ; Состояние перетаскивания
#___mask_edit      = 1 << 8  ; Режим активного редактирования текста
#___mask_press     = 1 << 9

; ==========================================================
; (Цветовая схема и Маски)
; ==========================================================
#COLOR_BACK_NORMAL   = $FFFFFF ; Белый
#COLOR_BACK_SELECTED = $EBD8BD ; Голубой (Active)
#COLOR_BACK_DISABLE  = $F5F5F5 ; Светло-серый
#COLOR_TEXT_NORMAL   = $333333 ; Темно-серый
#COLOR_TEXT_DISABLE  = $AAAAAA ; Серый (Disabled)
#COLOR_LINE          = $EEEEEE ; Разделитель


; ==============================================================================
;- СТРУКТУРЫ ДАННЫХ
; ==============================================================================
Structure _s_POINT
   X.i : Y.i
EndStructure

Structure _s_COORDINATE Extends _s_POINT
   w.i : h.i
EndStructure

Structure _s_MOUSE Extends _s_POINT
   mask.q                ; Битовые состояния (Shift, Ctrl, Drag)
   press._s_POINT        ; Точка начала нажатия
   *widget._s_WIDGET[3]  ; Текущий виджет под мышью (Entered)
EndStructure
Structure _s_KEYBOARD  ; Ok
   *active._S_WIDGET   ; keyboard focus element ; GetActive( )\
EndStructure

Structure _s_columns Extends _s_COORDINATE
   Title.s
   Index.i  ; <--- Номер элемента в списке данных строки (0, 1, 2...)
EndStructure

Structure _s_VISIBLE_ROW
   *first._s_rows        ; Указатель на первую видимую строку
   *last._s_rows         ; Указатель на последнюю видимую строку
EndStructure

Structure _s_rows Extends _s_COORDINATE
   Array str.s(0)        ; Динамический массив ячеек данных
   Level.i               ; Уровень вложенности для дерева
   mask.q                ; Состояние строки (#___mask_active, #___mask_node...)
EndStructure

Structure _s_SCROLL Extends _s_COORDINATE
   pos.i : max.i : thumb_h.i : is_drag.b
EndStructure

Structure _s_CANVAS Extends _s_COORDINATE
   gadget.i              ; Системный номер CanvasGadget
   window.i              ; Номер родительского окна
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   class.s
   Type.i                         ; EDIT или TREE
   color.i
   
   mask.q                ; Состояние виджета (#___mask_update, #___mask_active...)
   
   rowheight.i           ; Высота строки данных ; 0 = авто по шрифту
   columnheight.i        ; Высота шапки (заголовков)
   
   padding.i             ; Внутренний отступ текста
   indent.i              ; Отступ веток дерева
   caret.i[2]            ; [0] - точка старта (push), [1] - точка конца (cursor)
   
   scroll_v._s_SCROLL
   scroll_h._s_SCROLL
   visible._s_VISIBLE_ROW
   
   clip._s_COORDINATE    ; Предрассчитанная область отсечения (reclip)
   OnEvent.ProtoOnEvent[#__event] ; Указатель на процедуру событий
   
   
   *parent._s_WIDGET     ; Ссылка на родителя
   *root._s_ROOT         ; Ссылка на корень (холст)
   
   List __columns._s_columns()
   List *__Items._s_ROWS()          ; Развернутый рулон (указатели)
   List __rows._s_rows()
EndStructure

Structure _s_ROOT Extends _s_WIDGET
   dpi.f
   *next._s_ROOT
   *prev._s_ROOT
   
   *DragItem._s_ROWS
   *DragColumn._s_columns 
   
   Canvas._s_CANVAS
   List Widget._s_WIDGET() ; Список всех виртуальных виджетов на холсте
EndStructure

Structure _s_GUI
   *root._s_ROOT
   *opened._s_WIDGET             ; last opened-list element
   
   mouse._s_MOUSE                ; mouse( )\
   keyboard._s_KEYBOARD          ; keyboard( )\
EndStructure


;-
Global GUI._s_GUI

Macro Root(): GUI\root: EndMacro
Macro Opened(): GUI\opened: EndMacro
Macro Entered(): GUI\mouse\widget[0]: EndMacro
Macro Leaved( ): GUI\mouse\widget[1]: EndMacro
Macro Pressed(): GUI\mouse\widget[2]: EndMacro
Macro GetActive(): GUI\keyboard\active: EndMacro
Macro widgets(): GUI\root\Widget(): EndMacro
Macro mouse( ): GUI\mouse: EndMacro
Macro keyboard( ): GUI\keyboard: EndMacro

; Глобальный указатель на текущий активный корень
Root() = AllocateStructure(_s_ROOT)

; ==============================================================================
; ГЕОМЕТРИЯ И ОБНОВЛЕНИЕ
; ==============================================================================
Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro

;-
; Универсальная проверка попадания точки в объект (с учетом скролла)
Procedure.b atpoint(*obj._s_COORDINATE, mx.i, my.i, offset_x.i = 0, offset_y.i = 0)
   If *obj
      If (mx + offset_x) >= *obj\x And (mx + offset_x) < *obj\x + *obj\w
         If (my + offset_y) >= *obj\y And (my + offset_y) < *obj\y + *obj\h
            ProcedureReturn #True
         EndIf
      EndIf
   EndIf
   ProcedureReturn #False
EndProcedure

Procedure SetActive(*this._s_WIDGET)
   If GetActive() 
      GetActive()\mask & ~#___mask_active 
   EndIf
   GetActive() = *this
   Root( ) = *this\root
   *this\mask | #___mask_active | #___mask_redraw
EndProcedure


Procedure.i edit_make_caret_position(*this._s_WIDGET, *rowLine._s_rows)
   Protected i.i, mouse_x.i, caret_x.i, caret.i = -1
   Protected Distance.d, MinDistance.d = 1e308 ; Аналог Infinity()
   
   If *rowLine
      ; 1. Находим экранный X начала текста первой колонки
      ; X_виджета + Отступ_Level - Скролл + Базовый_отступ(5)
      Protected dx = *this\x - *this\scroll_h\pos
      Protected offset = 5 + (*rowLine\Level * *this\indent)
      
      ; Если есть треугольник, текст смещен еще на 15 пикселей
      If (*rowLine\mask & #___mask_node) : offset + 15 : EndIf
      
      ; 2. Рассчитываем X мыши относительно начала текста
      ; (Учитываем, что mouse\x — это экранная координата из root)
      mouse_x = mouse( )\x - (dx + offset)
      
      ; 3. Текст из первой ячейки массива
      Protected Text.s = *rowLine\Str(0)
      Protected LenText = Len(Text)
      
      ; 4. Перебор позиций между символами
      For i = 0 To LenText
         ; Ширина текста от начала до текущего индекса i
         caret_x = TextWidth(Left(Text, i))
         
         ; Квадрат расстояния для поиска ближайшей точки (примагничивание)
         Distance = (mouse_x - caret_x) * (mouse_x - caret_x)
         
         If MinDistance >= Distance
            MinDistance = Distance
            caret = i
         Else
            ; Если расстояние начало расти — мы прошли точку минимума
            Break
         EndIf
      Next
   EndIf
   
   ProcedureReturn caret
EndProcedure

;-
Procedure Free(*this._s_WIDGET)
   If Not *this : ProcedureReturn : EndIf
   
   ; 1. Очищаем основные списки
   ; Массивы внутри структур __rows() удалятся АВТОМАТИЧЕСКИ 
   ; при вызове FreeList() или ClearList().
   FreeList(*this\__rows())
   FreeList(*this\__columns())
   
   ; Очищаем список указателей (рулон)
   FreeList(*this\__Items())
   
   ; 2. Удаляем сам виджет из глобального списка
   If *this\root
      ; Важно: используем адрес виджета для поиска в списке
      ChangeCurrentElement(*this\root\Widget(), *this)
      DeleteElement(*this\root\Widget())
   EndIf
EndProcedure

;-
; Расчет области отсечения (вызывается при изменении размера)
Procedure reclip(*this._s_WIDGET)
   *this\clip\x = *this\x : *this\clip\y = *this\y
   *this\clip\w = *this\w : *this\clip\h = *this\h
   
   If *this\parent ; Если вложен в другой виджет, обрезаем по нему
      If *this\clip\x < *this\parent\clip\x : *this\clip\x = *this\parent\clip\x : EndIf
      If *this\clip\y < *this\parent\clip\y : *this\clip\y = *this\parent\clip\y : EndIf
      ; ... аналогично для w/h (логика пересечения прямоугольников)
   EndIf
EndProcedure

; Главная процедура сборки (вызывается внутри StartDrawing)
Procedure Resize(*this._s_WIDGET, X.l, Y.l, w.l, h.l)
   ; 1. Обновляем виртуальные координаты (относительно ROOT)
   *this\x = X
   *this\y = Y
   *this\w = w
   *this\h = h
   
   ; 2. Пересчитываем область отсечения (чтобы не рисовать лишнего)
   ; Эта функция теперь вызывается АВТОМАТИЧЕСКИ внутри resize
   reclip(*this)
   
   ; 3. Поднимаем маску обновления
   ; Мы не считаем текст здесь, а помечаем, что это нужно сделать при отрисовке
   *this\mask | #___mask_update | #___mask_redraw
   
   ; 4. Если есть вложенные дети — рекурсивно обновляем их (опционально)
   ; ForEach *this\root\widget() ... If \parent = *this ...
EndProcedure

;-
Procedure update_visible_rows(*this._s_WIDGET)
   If Not *this Or ListSize(*this\__rows()) = 0
      *this\visible\first = 0 : *this\visible\last = 0
      ProcedureReturn
   EndIf
   
   Protected view_top = *this\scroll_v\pos
   Protected view_bottom = *this\scroll_v\pos + *this\h - *this\columnheight
   
   *this\visible\first = 0
   *this\visible\last = 0
   
   ForEach *this\__rows()
      Protected row_top = *this\__rows()\y - *this\columnheight
      Protected row_bottom = row_top + *this\__rows()\h
      
      ; Ищем ПЕРВУЮ видимую (верхний край строки выше низа экрана И нижний ниже верха)
      If Not *this\visible\first
         If row_bottom > view_top
            *this\visible\first = @*this\__rows()
         EndIf
      EndIf
      
      ; Ищем ПОСЛЕДНЮЮ видимую
      If *this\visible\first
         *this\visible\last = @*this\__rows()
         ; Если верх этой строки уже ниже видимой области — это точно последняя
         If row_top > view_bottom
            Break 
         EndIf
      EndIf
   Next
EndProcedure

Procedure update_nodes(*this._s_WIDGET)
   PushListPosition(*this\__rows())
   ForEach *this\__rows()
      Protected current_level = *this\__rows()\Level
      *this\__rows()\mask & ~#___mask_node ; Сбрасываем старый флаг
      
      ; Заглядываем в следующую строку
      If NextElement(*this\__rows())
         If *this\__rows()\Level > current_level
            ; Предыдущий элемент — это родитель (узел)
            PreviousElement(*this\__rows())
            *this\__rows()\mask | #___mask_node
            NextElement(*this\__rows())
         Else
            PreviousElement(*this\__rows())
         EndIf
      EndIf
   Next
   PopListPosition(*this\__rows())
EndProcedure

; Пересчет координат строк (Virtualization)
Procedure update_columns(*this._s_WIDGET)
   Protected cur_x = 0
   ForEach *this\__columns()
      *this\__columns()\x = cur_x
      cur_x + *this\__columns()\w
   Next
   ; Максимальный сдвиг = (Общая ширина колонок) - (Ширина виджета)
   *this\scroll_h\max = cur_x - *this\w
   
   ; Если колонки уже узкие и влезают в экран, скролл не нужен (0)
   If *this\scroll_h\max < 0 : *this\scroll_h\max = 0 : EndIf
   
   ; Защита: если скролл был в конце, а мы сузили колонки, корректируем позицию
   If *this\scroll_h\pos > *this\scroll_h\max
      *this\scroll_h\pos = *this\scroll_h\max
   EndIf
EndProcedure

Procedure update_rows(*this._s_WIDGET)
   If Not *this : ClearList(*this\__Items()) : ProcedureReturn : EndIf
   update_nodes(*this)
   ClearList(*this\__Items())
   
   Protected h_item = *this\rowheight
   If h_item <= 0
      h_item = TextHeight("Ag") + (*this\padding * 2)
      If h_item < 16 : h_item = 22 : EndIf 
   EndIf
   
   Protected cur_y = *this\columnheight 
   Protected view_top = *this\scroll_v\pos
   Protected view_bottom = view_top + *this\h - *this\columnheight
   
   *this\visible\first = 0
   *this\visible\last = 0
   
   Protected skip_level = -1 ; <--- ПЕРЕМЕННАЯ ДЛЯ ФИЛЬТРАЦИИ
   
   ForEach *this\__rows()
      ; --- ЛОГИКА СХЛОПЫВАНИЯ (TREE) ---
      If *this\indent
         ; 1. Если мы в режиме пропуска (родитель выше по списку был свернут)
         If skip_level <> -1
            If *this\__rows()\Level > skip_level
               Continue ; <--- ПРОПУСКАЕМ СТРОКУ (не добавляем в рулон)
            Else
               skip_level = -1 ; Встретили строку того же уровня или выше — стоп пропуск
            EndIf
         EndIf
         
         ; 2. Проверяем: не является ли текущая строка свернутым узлом?
         If (*this\__rows()\mask & #___mask_node) And (*this\__rows()\mask & #___mask_collapsed)
            skip_level = *this\__rows()\Level ; Запоминаем уровень "папы", чтобы скрыть всех его "детей"
         EndIf
      EndIf
      
      ; 1. Добавляем в рулон (ВСЕГДА, без Break)
      AddElement(*this\__Items())
      *this\__Items() = @*this\__rows()
      
      ; 2. Считаем геометрию
      *this\__rows()\x = 0
      *this\__rows()\y = cur_y
      If *this\__rows()\h <= 0 : *this\__rows()\h = h_item : EndIf
      
      ; 3. Логика видимости (БЕЗ Break)
      Protected r_top = *this\__rows()\y - *this\columnheight
      Protected r_bottom = r_top + *this\__rows()\h
      
      If Not *this\visible\first
         If r_bottom > view_top : *this\visible\first = @*this\__Items() : EndIf
      EndIf
      
      ; Если мы уже нашли начало и текущая строка попадает в окно — обновляем "last"
      If *this\visible\first
         If r_top < view_bottom
            *this\visible\last = @*this\__Items()
         EndIf
      EndIf
      
      cur_y + *this\__rows()\h
   Next
   
   *this\scroll_v\max = cur_y - *this\h
   If *this\scroll_v\max < 0 : *this\scroll_v\max = 0 : EndIf
EndProcedure

Procedure _update_rows(*this._s_WIDGET)
   If Not *this : ProcedureReturn : EndIf
   
   ClearList(*this\__Items())
   
   ; 1. Определяем базовую высоту строки (мы уже внутри ReDraw, поэтому TextHeight работает)
   Protected h_item = *this\rowheight
   If h_item <= 0
      h_item = TextHeight("Ag") + (*this\padding * 2)
      If h_item < 16 : h_item = 22 : EndIf 
   EndIf
   
   Protected cur_y = *this\columnheight ; Стартуем под шапкой
   
   ; 2. Проходим по основному списку один раз
   ForEach *this\__rows()
      
      ; --- ЛОГИКА ВЫБОРА (GRID / TREE) ---
      ; В будущем здесь будет проверка: If ParentIsCollapsed -> Continue
      
      ; Добавляем в рулон отрисовки
      AddElement(*this\__Items())
      *this\__Items() = @*this\__rows()
      
      ; --- ГЕОМЕТРИЯ (СРАЗУ ТУТ) ---
      ; Записываем координаты прямо в структуру строки через указатель в рулоне
      *this\__Items()\x = 0
      *this\__Items()\y = cur_y
      *this\__Items()\w = *this\w
      
      ; Если у строки нет индивидуальной высоты, ставим вычисленную h_item
      If *this\__Items()\h <= 0
         *this\__Items()\h = h_item
      EndIf
      
      ; Двигаем Y для следующей строки
      cur_y + *this\__Items()\h
   Next
   
   ; 3. Финальные штрихи по скроллу и видимости
   *this\scroll_v\max = cur_y - *this\h
   If *this\scroll_v\max < 0 : *this\scroll_v\max = 0 : EndIf
   
   ; Обновляем границы first/last для draw_rows
   update_visible_rows(*this) 
EndProcedure

;-
Procedure swap_column(*this._s_WIDGET, *HoverColumn._s_columns, mx.i)
   ; Проверяем: есть ли что тащить, над чем висим, и что это разные колонки
   If *this\root\DragColumn And *HoverColumn And *HoverColumn <> *this\root\DragColumn
      
      ; 1. Находим экранный X левой границы колонки, над которой мышь
      ; Формула: X виджета + X колонки во внутреннем списке - Смещение скролла
      Protected col_left_x = *this\x + *HoverColumn\x - *this\scroll_h\pos
      
      ; 2. Находим середину этой колонки
      Protected col_middle_x = col_left_x + (*HoverColumn\w / 2)
      
      PushListPosition(*this\__columns())
      
      ; Переходим к зажатой колонке в списке
      ChangeCurrentElement(*this\__columns(), *this\root\DragColumn)
      
      ; 3. Сравниваем текущий X мыши с серединой целевой колонки
      If mx > col_middle_x
         ; Мышь правее середины -> перемещаем ПОСЛЕ цели
         MoveElement(*this\__columns(), #PB_List_After, *HoverColumn)
      Else
         ; Мышь левее середины -> перемещаем ПЕРЕД целью
         MoveElement(*this\__columns(), #PB_List_Before, *HoverColumn)
      EndIf
      
      PopListPosition(*this\__columns())
      
      ; 4. ВАЖНО: Обновляем координаты X для всего списка (цепочка X)
      update_columns(*this)
      
      ; Просим перерисовать, так как порядок изменился
      *this\mask | #___mask_redraw
   EndIf
EndProcedure

Procedure swap_row(*this._s_WIDGET, *HoverRow._s_rows, my.i)
   ; Если есть что тащить, над чем висеть и это разные строки
   If *this\root\DragItem And *HoverRow And *HoverRow <> *this\root\DragItem
      
      ; 1. Находим экранный Y верхней границы строки, над которой мышь
      ; Формула: Y виджета + Y строки в списке - Смещение скролла
      Protected row_top_y = *this\y + *HoverRow\y - *this\scroll_v\pos
      
      ; 2. Находим середину этой строки
      Protected row_middle_y = row_top_y + (*HoverRow\h / 2)
      
      PushListPosition(*this\__rows())
      
      ; Переходим к зажатой строке
      ChangeCurrentElement(*this\__rows(), *this\root\DragItem)
      
      ; 3. Сравниваем текущий Y мыши с серединой целевой строки
      If my > row_middle_y
         ; Мышь ниже середины -> перемещаем ПОСЛЕ цели
         MoveElement(*this\__rows(), #PB_List_After, *HoverRow)
      Else
         ; Мышь выше середины -> перемещаем ПЕРЕД целью
         MoveElement(*this\__rows(), #PB_List_Before, *HoverRow)
      EndIf
      
      PopListPosition(*this\__rows())
      
      ; 4. Обновляем координаты Y для всего списка (чтобы не было наложений)
      update_rows(*this)
      *this\mask | #___mask_redraw
   EndIf
EndProcedure

;-
Procedure resize_column(*this._s_WIDGET, *column._s_columns, new_w.i)
   If *column
      ; Устанавливаем минимальный порог, чтобы колонка не исчезла совсем
      If new_w < 20 : new_w = 20 : EndIf 
      
      ; Записываем новую ширину
      *column\w = new_w
      
      ; Поднимаем флаги: 
      ; 1. update — чтобы в redraw вызвался update_columns (пересчет X)
      ; 2. redraw — чтобы холст обновился визуально
      *this\mask | #___mask_update | #___mask_redraw
   EndIf
EndProcedure

Procedure resize_row(*this._s_WIDGET, *row._s_rows, new_h.i)
   If *row
      ; Ограничиваем минимальную высоту
      If new_h < 15 : new_h = 15 : EndIf 
      
      ; Записываем новую высоту конкретной строке
      *row\h = new_h
      
      ; Поднимаем флаги для вызова update_rows (пересчет Y всех строк ниже)
      *this\mask | #___mask_update | #___mask_redraw
   EndIf
EndProcedure

;-
Procedure draw_columns(*this._s_WIDGET)
   Protected dx = *this\x - *this\scroll_h\pos
   Protected dy = *this\y
   
   ; 1. Рисуем общий фон шапки (высота 25)
   Box(*this\x, dy, *this\w, *this\columnheight, $F5F5F5)
   
   ForEach *this\__columns()
      Protected col_x = dx + *this\__columns()\x
      Protected col_w = *this\__columns()\w
      ; Debug "Рисую колонку: " + *this\__columns()\Title ; <--- СЮДА
      
      ; --- ЛОГИКА ОЖИВЛЕНИЯ (HOVER) ---
      Protected color = $F5F5F5
      ; Проверяем, находится ли мышь над текущим заголовком
      If mouse( )\y >= dy And mouse( )\y < dy + *this\columnheight
         If mouse( )\x >= col_x And mouse( )\x < col_x + col_w
            color = $E0E0E0 ; Цвет при наведении
         EndIf
      EndIf
      
      ; 2. Рисуем фон колонки и текст заголовка
      Box(col_x, dy, col_w, *this\columnheight, color)
      DrawText(col_x + 5, dy + 5, *this\__columns()\Title, $333333, color)
      
      ; 3. Рисуем вертикальный разделитель (сетку) на всю высоту виджета
      Line(col_x + col_w, dy, 1, *this\h, $CCCCCC)
   Next
   
   ; Нижняя граница шапки
   Line(*this\x, dy + *this\columnheight, *this\w, 1, $AAAAAA)
EndProcedure

Procedure draw_rows(*this._s_WIDGET, List *rows._s_rows())
   If Not *this\visible\first : ProcedureReturn : EndIf
   
   ; 1. Прыгаем сразу к первой видимой строке
   ChangeCurrentElement(*rows(), *this\visible\first)
   
   ; Рассчитываем базовое смещение по X ОДИН РАЗ (экранный X виджета - скролл)
   Protected dx = *this\x - *this\scroll_h\pos
   
   Repeat 
      ; Берем адрес текущей строки (безопасный доступ)
      Protected *row._s_rows = *rows()
      
      ; Рассчитываем экранный Y для текущей строки
      Protected dy = *this\y + *row\y - *this\scroll_v\pos
      
      ; --- ЛОГИКА ЦВЕТА ФОНА ---
      Protected color = #COLOR_BACK_NORMAL
      
      ; Приоритет 1: Выделение (Active)
      If *row\mask & #___mask_active And Not *this\Type = #__type_Editor
         color = #COLOR_BACK_SELECTED
         
         ; Приоритет 2: Наведение (Hover) - только если мышь внутри виджета
      ElseIf mouse( )\x >= *this\x And mouse( )\x < *this\x + *this\w
         If mouse( )\y >= dy And mouse( )\y < dy + *row\h
            color = $F5F5F5 
         EndIf
      EndIf
      
      ; Рисуем подложку строки
      Box(*this\x + 1, dy, *this\w - 2, *row\h - 1, color)
      
      ; --- ОТРИСОВКА ТЕКСТА ПО КОЛОНКАМ ---
      PushListPosition(*this\__columns())
      ; --- ВНУТРИ ЦИКЛА ПО КОЛОНКАМ ---
      ForEach *this\__columns()
         Protected col_x    = dx + *this\__columns()\x
         Protected col_w    = *this\__columns()\w
         Protected data_idx = *this\__columns()\Index
         
         ; 1. Проверяем, видна ли колонка вообще (Оптимизация)
         If col_x + col_w > *this\x And col_x < *this\x + *this\w
            
            ; 2. РАСЧЕТ УМНОГО КЛИПА (Пересечение колонки и виджета)
            ; Берем максимальное из левых границ
            Protected clip_x = Max(col_x, *this\x) 
            ; Берем минимальное из правых границ и вычитаем левую, чтобы получить ширину
            Protected clip_w = Min(col_x + col_w, *this\x + *this\w) - clip_x
            
            ; Если ширина клипа получилась отрицательной (вне видимости) — пропускаем
            If clip_w > 0
               ClipOutput(clip_x, dy, clip_w, *row\h)
               
               If data_idx <= ArraySize(*row\Str())
                  Protected Text.s = *row\Str(data_idx)
                  Protected offset = 5
                  
                  ; --- ЛОГИКА ДЕРЕВА (ДЛЯ ПЕРВОЙ КОЛОНКИ) ---
                  If *this\indent > 0 And data_idx = 0
                     ; Рассчитываем базовый отступ для текущего уровня вложенности
                     offset = 5 + (*row\Level * *this\indent)
                     
                     ; Если строка является узлом (папкой) — РИСУЕМ ТРЕУГОЛЬНИК
                     If (*row\mask & #___mask_node)
                        ; Точные экранные координаты для иконки
                        Protected tx = col_x + offset
                        Protected ty = dy + (*row\h / 2) - 4
                        
                        ; Цвет иконки (серый)
                        FrontColor($888888)
                        
                        If *row\mask & #___mask_collapsed
                           ; ЗАКРЫТО: Рисуем стрелочку вправо
                           Line(tx, ty, 1, 9)
                           Line(tx, ty, 5, 4)
                           Line(tx, ty + 8, 5, -4)
                        Else
                           ; ОТКРЫТО: Рисуем стрелочку вниз
                           Line(tx, ty + 2, 9, 1)
                           Line(tx, ty + 2, 4, 5)
                           Line(tx + 8, ty + 2, -4, 5)
                        EndIf
                        
                        ; Важно: текст должен стоять ПРАВЕЕ треугольника
                        offset + 15
                     EndIf
                  EndIf
                  
                  ; 1. Рисуем ВЫДЕЛЕНИЕ (между якорем и курсором)
                  If *row\mask & #___mask_edit
                     If *this\caret[0] <> *this\caret[1]
                        Protected s_min = Min(*this\caret[0], *this\caret[1])
                        Protected s_max = Max(*this\caret[0], *this\caret[1])
                        
                        Protected sel_x = col_x + offset + TextWidth(Left(Text, s_min))
                        Protected sel_w = TextWidth(Mid(Text, s_min + 1, s_max - s_min))
                        
                        Box(sel_x, dy + 2, sel_w, *row\h - 4, #COLOR_BACK_SELECTED)
                     EndIf
                  EndIf
                  
                  ; РИСУЕМ ТЕКСТ
                  ; --- ТЕКСТ (ПОВЕРХ ВЫДЕЛЕНИЯ) ---
                  DrawingMode(#PB_2DDrawing_Transparent) ; Включаем прозрачность
                  DrawText(col_x + offset, dy + 5, Text, #COLOR_TEXT_NORMAL)
                  DrawingMode(#PB_2DDrawing_Default)     ; Возвращаем как было
                  
                  ; --- РИСУЕМ КАРЕТКУ (КУРСОР) ---
                  If *this\Type = #__type_Editor And (*row\mask & #___mask_active)
                     
                     ; 1. Берем подстроку от начала до индекса каретки
                     ; Если caret = 0, Left вернет пустую строку, и TextWidth будет 0 (начало строки)
                     Protected caret_text.s = Left(Text, *this\caret)
                     
                     ; 2. Считаем ширину только этой части текста
                     Protected caret_x_offset = TextWidth(caret_text)
                     
                     ; 3. Итоговая экранная координата линии
                     ; col_x (экранный X колонки) + offset (дерево) + ширина текста до курсора
                     Protected cx = col_x + offset + caret_x_offset
                     
                     ; Рисуем мигающую линию
                     ; If (ElapsedMilliseconds() / 500) % 2
                     Line(cx, dy + 2, 1, *row\h - 4, $000000)
                     ; EndIf
                  EndIf
               EndIf
               
               ; 3. СБРОС КЛИПА (обратно в границы виджета)
               ClipOutput(*this\x, *this\y, *this\w, *this\h)
            EndIf
         EndIf
      Next
      PopListPosition(*this\__columns())
      
      ; Горизонтальный разделитель
      Line(*this\x, dy + *row\h - 1, *this\w, 1, #COLOR_LINE)
      
      ; --- ПРОВЕРКА ЗАВЕРШЕНИЯ ---
      If *row = *this\visible\last
         Break
      EndIf
      
   Until NextElement(*rows()) = 0 
EndProcedure

;-
Procedure add_column(*this._s_WIDGET, Title.s, Width.i)
   If Not *this : ProcedureReturn : EndIf
   *this\columnheight = 25
   
   AddElement(*this\__columns())
   *this\__columns()\Title = Title
   *this\__columns()\w     = Width
   ; Мы не ставим x здесь, его поставит update_columns() перед отрисовкой
   
   ; Запоминаем текущий порядковый номер (0 для первой, 1 для второй и т.д.)
   *this\__columns()\Index = ListSize(*this\__columns()) - 1 
   
   ; ГЛАВНОЕ: поднимаем флаги, чтобы redraw понял, что нужно пересчитать геометрию
   *this\mask | #___mask_update | #___mask_redraw
EndProcedure

Procedure add_row(*this._s_WIDGET, Text.s, Level.i = 0)
   If Not *this : ProcedureReturn : EndIf
   
   AddElement(*this\__rows())
   *this\__rows()\Level = Level
   
   Protected i, TotalCols = ListSize(*this\__columns()) - 1
   ReDim *this\__rows()\Str(TotalCols)
   
   ; 3. Ультра-быстрый разбор строки через указатели (O(N))
   Protected *start, *ptr.Character = @Text 
   If *ptr
      *start = *ptr           
      
      While *ptr\c And i <= TotalCols
         If *ptr\c = '|' 
            *this\__rows()\Str(i) = PeekS(*start, (*ptr - *start) >> 1)
            
            *start = *ptr + 2 ; SizeOf(Character) ; Сдвигаем начало следующей колонки
            i + 1
         EndIf
         *ptr + SizeOf(Character)
      Wend
   EndIf
   
   ; Добавляем последнюю колонку (хвост строки)
   If i <= TotalCols : *this\__rows()\Str(i) = PeekS(*start) : EndIf
   
   ; Поднимаем флаги: нужно пересчитать Y строк и перерисовать
   *this\mask | #___mask_update | #___mask_redraw
EndProcedure

;-
Procedure.i create_edit(*root._s_ROOT, X.i, Y.i, w.i, h.i)
   AddElement(*root\Widget())
   Protected *this._s_WIDGET = @*root\Widget()
   
   *this\Type = #__type_Editor
   *this\root = *root
   *this\rowheight = 25
   *this\indent = 20 ; Специфично для дерева (отступ веток)
   
   ; Сразу создаем одну невидимую колонку на всю ширину
   add_column(*this, "едит", w) 
                             
   ; Устанавливаем положение и размер
   ; Resize внутри себя вызовет reclip() и поднимет флаг #___mask_update
   Resize(*this, X, Y, w, h) 
   
   ProcedureReturn *this
EndProcedure

Procedure.i create_grid(*root._s_ROOT, X.i, Y.i, w.i, h.i)
   AddElement(*root\Widget())
   Protected *this._s_WIDGET = @*root\Widget()
   
   *this\Type = #__type_ListIcon
   *this\root = *root
   *this\rowheight = 25
   
   ; Устанавливаем положение и размер
   ; Resize внутри себя вызовет reclip() и поднимет флаг #___mask_update
   Resize(*this, X, Y, w, h) 
   
   ProcedureReturn *this
EndProcedure

Procedure.i create_tree(*root._s_ROOT, X.i, Y.i, w.i, h.i)
   AddElement(*root\Widget())
   Protected *this._s_WIDGET = @*root\Widget()
   
   *this\Type = #__type_Tree
   *this\root = *root
   *this\indent = 20 ; Специфично для дерева (отступ веток)
   *this\rowheight = 25
   
   Resize(*this, X, Y, w, h)
   
   ProcedureReturn *this
EndProcedure

Procedure.i Create(*parent._s_WIDGET, class.s, Type.i, X, Y, Width, Height, title.s, flags.q=0, param1=0,param2=0,param3=0 )
   Protected *Root._s_ROOT = Root();*parent\root
   If Not *Root
      *Root = *parent
   EndIf
   
   AddElement(*root\Widget())
   Protected *this._s_WIDGET = @*root\Widget()
   *this\Type = Type
   *this\class = class
   *this\root = *root
   
   If Type = #__type_Tree
      *this\indent = 20 ; (отступ веток)
      *this\rowheight = 25
   EndIf
   If Type = #__type_ListIcon
      *this\rowheight = 25
   EndIf
   If Type = #__type_Editor
      *this\rowheight = 25
      *this\indent = 20 ; (отступ веток)
      
      ; Сразу создаем одну невидимую колонку на всю ширину
      add_column(*this, "едит", w) 
                                
   EndIf
   
   Resize(*this, X, Y, Width, Height)
   ProcedureReturn *this
EndProcedure

Procedure.i Tree( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_Tree, X, Y, Width, Height, "", Flag )
EndProcedure
Procedure.i Editor( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_Editor, X, Y, Width, Height, "", Flag )
EndProcedure
Procedure.i ListIcon( X.l, Y.l, Width.l, Height.l, ColumnTitle.s, ColumnWidth.i, Flag.q = 0 )
   ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_ListIcon, X, Y, Width, Height, ColumnTitle, Flag, ColumnWidth )
EndProcedure

;-
Procedure ReDraw(*root._s_ROOT)
   If Not *root : ProcedureReturn : EndIf
   
   StartDrawing(CanvasOutput(*root\Canvas\gadget))
   ; 1. Фон всего холста
   Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF) 
   
   ForEach *root\Widget()
      Protected *this._s_WIDGET = @*root\Widget()
      
      ; Расчет геометрии (если нужно)
      If *this\mask & #___mask_update
         update_columns(*this)
         update_rows(*this)
         *this\mask & ~#___mask_update
      EndIf
      
      ; Внутри ReDraw в цикле ForEach *root\Widget()
      If *this\mask & #___mask_edit
         If *root\DragItem 
            ; 1. Всегда обновляем текущую позицию каретки (конец выделения)
            *this\caret = edit_make_caret_position(*this, *root\DragItem)
            
            ; 2. Если это ПЕРВЫЙ клик (был флаг press) — приравниваем старт к концу
            If *this\mask & #___mask_press And Not *this\mask & #___mask_drag
               *this\caret[1] = *this\caret
            EndIf
         EndIf
      EndIf  
      
      ; Ограничиваем рисование областью виджета
      ClipOutput(*this\x, *this\y, *this\w, *this\h)
      
      ; --- СЛОИ ОТРИСОВКИ ---
      ; Слой 1: Фон и данные строк
      draw_rows(*this, *this\__Items()) 
      
      ; Слой 2: Шапка и вертикальные линии сетки
      draw_columns(*this) 
      
      ; Слой 3: Внешняя рамка виджета (рисуем ПОВЕРХ всего)
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(*this\x, *this\y, *this\w, *this\h, $CCCCCC) ; Цвет рамки
      DrawingMode(#PB_2DDrawing_Default)
      
      UnclipOutput()
      
      ; Сбрасываем флаг перерисовки после завершения
      If *this\mask & #___mask_edit
         If *this\mask & #___mask_drag
            *this\mask & ~#___mask_edit
         EndIf
      EndIf
      *this\mask & ~#___mask_redraw
   Next
   StopDrawing()
EndProcedure

;-
Procedure.i hover_column(*this._s_WIDGET, mx.i, my.i, *is_edge.Byte)
   Protected *res
   Protected dx = *this\x - *this\scroll_h\pos
   Protected dy = *this\y
   *is_edge\b = #False
   
   ; Проверяем только в области шапки
   If my >= dy And my < dy + *this\columnheight
      PushListPosition(*this\__columns())
      ForEach *this\__columns()
         Protected col_edge = dx + *this\__columns()\x + *this\__columns()\w
         ; Проверка на край (для ресайза)
         If Abs(mx - col_edge) < 5
            *is_edge\b = #True
            *res = @*this\__columns()
            Break
         EndIf
         ; Проверка на тело колонки
         If mx >= (dx + *this\__columns()\x) And mx < col_edge
            *res = @*this\__columns()
            Break
         EndIf
      Next
      PopListPosition(*this\__columns())
   EndIf
   ProcedureReturn *res
EndProcedure

Procedure.i hover_row(*this._s_WIDGET, List *rows._s_rows(), my.i)
   Protected *res
   ; Переводим экранный Y во внутренний Y данных
   Protected my_rel = my - *this\y + *this\scroll_v\pos
   If *this\rowheight
      PushListPosition(*rows())
      ForEach *rows()
         If my_rel >= *rows()\y And my_rel < *rows()\y + *rows()\h
            *res = *rows()
            Break
         EndIf
      Next
      PopListPosition(*rows())
   EndIf
   ProcedureReturn *res
EndProcedure

;-
Procedure column_events(*this._s_WIDGET, *column._s_columns, event, is_edge.b = #False)
   Select event
      Case #PB_EventType_LeftButtonDown
         If *column
            *this\root\DragColumn = *column
            
            If is_edge
               ; А. Попали в КРАЙ — включаем Resize
               *this\mask | #___mask_drag
               mouse( )\press\x = mouse( )\x ; Фиксируем точку старта для дельты
            EndIf
         EndIf
         
      Case #PB_EventType_MouseMove
         If Not *this\mask & #___mask_edit
            If *column 
               *this\mask | #___mask_redraw
            EndIf
            
            ; --- КУРСОР ---
            If is_edge Or *this\root\DragColumn
               SetGadgetAttribute(*this\root\Canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
            Else
               SetGadgetAttribute(*this\root\Canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
            EndIf
            
            ; --- ДЕЙСТВИЯ ---
            If *this\mask & #___mask_active
               If *this\root\DragColumn
                  If *this\mask & #___mask_drag ; Режим Resize
                     resize_column(*this, *this\root\DragColumn, mouse( )\x - (*this\x + *this\root\DragColumn\x - *this\scroll_h\pos))
                  Else ; Режим Swap
                     swap_column(*this, *column, mouse( )\x)
                  EndIf
               EndIf
            EndIf
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         *this\root\DragColumn = 0
         
   EndSelect
   
EndProcedure

Procedure row_events(*this._s_WIDGET, *row._s_ROWS,  event)
   Select event
      Case #PB_EventType_LeftButtonDown
         If *row
            PushListPosition(*this\__rows())
            ForEach *this\__rows()
               *this\__rows()\mask & ~#___mask_active
               *this\__rows()\mask & ~#___mask_edit
            Next
            PopListPosition(*this\__rows())
            
            *row\mask | #___mask_active
            
            If *this\Type = #__type_Editor
               *row\mask | #___mask_edit
               *this\mask | #___mask_edit
            EndIf
            
            ; 4. Если это папка (узел) — переключаем схлопывание
            If *row\mask & #___mask_node
               *row\mask ! #___mask_collapsed
               ; Если ветка закрылась/открылась — пересобираем рулон
               *this\mask | #___mask_update 
            EndIf
            
            *this\mask | #___mask_redraw
            *this\root\DragItem = *row 
         EndIf
         
      Case #PB_EventType_MouseMove
         If *row
            *this\mask | #___mask_redraw
         EndIf
         
         If *this\root\DragItem
            If *this\root\DragItem\mask & #___mask_edit
               If *this\mask & #___mask_drag
                  *this\mask | #___mask_edit
               EndIf
            Else
               If *this\mask & #___mask_active
                  swap_row(*this, *row, mouse( )\y)
               EndIf
            EndIf
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         *this\root\DragItem = 0
         
   EndSelect
EndProcedure

;-
Procedure key_events(*this._s_WIDGET, key.i)
   If Not *this : ProcedureReturn : EndIf
   
   ; Нам нужно знать, какая строка сейчас активна (фокус)
   Protected *current._s_rows = 0
   ForEach *this\__rows()
      If *this\__rows()\mask & #___mask_active
         *current = @*this\__rows()
         Break
      EndIf
   Next
   
   Select key
      Case #PB_EventType_Input
         If *this\Type = #__type_Editor And (*this\mask & #___mask_active)
            ; Получаем символ, который ввел пользователь
            Protected char = GetGadgetAttribute(*this\root\Canvas\gadget, #PB_Canvas_Input)
            
            If char 
               ; Ищем активную строку (или создаем новую, если список пуст)
               ForEach *this\__rows()
                  If *this\__rows()\mask & #___mask_active
                     ; Добавляем символ в массив ячейки
                     *this\__rows()\Str(0) + Chr(char)
                     *this\mask | #___mask_redraw
                     Break
                  EndIf
               Next
            EndIf
         EndIf
         
      Case #PB_Shortcut_Back
         If *this\Type = #__type_Editor
            ForEach *this\__rows()
               If *this\__rows()\mask & #___mask_active
                  Protected current_text.s = *this\__rows()\Str(0)
                  If Len(current_text) > 0
                     ; Удаляем последний символ
                     *this\__rows()\Str(0) = Left(current_text, Len(current_text) - 1)
                     *this\mask | #___mask_redraw
                  EndIf
                  Break
               EndIf
            Next
         EndIf
         
      Case #PB_Shortcut_Up
         If *current
            PushListPosition(*this\__rows())
            ChangeCurrentElement(*this\__rows(), *current)
            If PreviousElement(*this\__rows())
               ; Снимаем старое выделение (если не зажат Shift)
               If Not (mouse( )\mask & #___mask_shift)
                  ForEach *this\__rows() : *this\__rows()\mask & ~#___mask_active : Next
               EndIf
               
               *this\__rows()\mask | #___mask_active
               ; Проверяем, не ушла ли строка за верхнюю границу (автоскролл)
               If *this\__rows()\y < *this\scroll_v\pos + *this\columnheight
                  *this\scroll_v\pos = *this\__rows()\y - *this\columnheight
               EndIf
            EndIf
            PopListPosition(*this\__rows())
         EndIf
         
      Case #PB_Shortcut_Down
         If *current
            PushListPosition(*this\__rows())
            ChangeCurrentElement(*this\__rows(), *current)
            If NextElement(*this\__rows())
               If Not (mouse( )\mask & #___mask_shift)
                  ForEach *this\__rows() : *this\__rows()\mask & ~#___mask_active : Next
               EndIf
               
               *this\__rows()\mask | #___mask_active
               ; Автоскролл вниз
               If *this\__rows()\y + *this\__rows()\h > *this\scroll_v\pos + *this\h
                  *this\scroll_v\pos = (*this\__rows()\y + *this\__rows()\h) - *this\h
                  
                  ; ВАЖНО: Раз скролл изменился, пересчитываем видимые строки!
                  update_visible_rows(*this) 
               EndIf
            EndIf
            PopListPosition(*this\__rows())
         EndIf
         
      Case #PB_Shortcut_Delete
         If *current
            ChangeCurrentElement(*this\__rows(), *current)
            DeleteElement(*this\__rows())
            *this\mask | #___mask_update ; Пересчитываем Y для всех строк ниже
         EndIf
         
      Case #PB_Shortcut_A
         ; Если зажат Ctrl (маска из твоей структуры)
         If mouse( )\mask & #___mask_ctrl
            ForEach *this\__rows()
               *this\__rows()\mask | #___mask_active
            Next
         EndIf
   EndSelect
   
   *this\mask | #___mask_redraw
EndProcedure

Procedure do_events(*this._s_WIDGET, event)
   Select event
      Case #PB_EventType_LeftButtonDown
         *this\mask | #___mask_press
         SetActive(*this)
         
      Case #PB_EventType_MouseMove
         If *this\mask & #___mask_edit
            If *this\mask & #___mask_press
               If Not *this\mask & #___mask_drag
                  Debug "real drag"
                  *this\mask | #___mask_drag
               EndIf
            EndIf
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         *this\mask & ~#___mask_press
         *this\mask & ~#___mask_drag
         
      Case #PB_EventType_MouseWheel
         Protected delta = GetGadgetAttribute(*this\root\Canvas\gadget, #PB_Canvas_WheelDelta)
         
         ; Если зажат Shift (маска из твоей структуры), крутим по горизонтали
         If mouse( )\mask & #___mask_shift
            *this\scroll_h\pos - (delta * 30)
            If *this\scroll_h\pos < 0 : *this\scroll_h\pos = 0 : EndIf
            If *this\scroll_h\pos > *this\scroll_h\max : *this\scroll_h\pos = *this\scroll_h\max : EndIf
         Else
            ; Обычный вертикальный скролл
            *this\scroll_v\pos - (delta * 30)
            If *this\scroll_v\pos < 0 : *this\scroll_v\pos = 0 : EndIf
            If *this\scroll_v\pos > *this\scroll_v\max : *this\scroll_v\pos = *this\scroll_v\max : EndIf
            update_visible_rows(*this) ; Не забываем обновлять видимость строк
         EndIf
         
         *this\mask | #___mask_redraw
   EndSelect
   
   Define is_edge.b, *h_col._s_columns = hover_column(*this, mouse( )\x, mouse( )\y, @is_edge)
   column_events(*this, *h_col, event, is_edge)
   If Not *h_col
      row_events(*this, hover_row(*this, *this\__Items(), mouse( )\y),  event)
   EndIf
   
EndProcedure

;-
Procedure Close( *root._s_ROOT )
   Protected *next._s_ROOT ; Временная переменная для безопасного перехода
   
   If *root = #PB_All
      *root = Root()
      If Not *root : ProcedureReturn : EndIf
      
      ; 1. Отматываем в самое начало
      While *root\prev : *root = *root\prev : Wend
      
      ; 2. Удаляем всех по очереди
      While *root
         *next = *root\next ; ЗАПОМИНАЕМ следующий адрес ДО удаления
         Close(*root)       ; Теперь удаляем текущий
         *root = *next      ; Переходим к запомненному адресу
      Wend
      
   Else
      ; ...
      If Entered() And Entered()\root = *root : Entered() = 0 : EndIf
      If Leaved() And Leaved()\root = *root : Leaved() = 0 : EndIf
      If Pressed() And Pressed()\root = *root : Pressed() = 0 : EndIf
      If GetActive() And GetActive()\root = *root : GetActive() = 0 : EndIf
      
      ; --- Одиночное удаление ---
      ; 1. СВЯЗЫВАЕМ СОСЕДЕЙ (вырезаем из цепи)
      If *root\prev : *root\prev\next = *root\next : EndIf
      If *root\next : *root\next\prev = *root\prev : EndIf
      
      ; 2. ПЕРЕНОСИМ ГЛОБАЛЬНЫЙ УКАЗАТЕЛЬ
      If Root() = *root
         If *root\prev
            Root() = *root\prev
         Else
            Root() = *root\next
         EndIf
      EndIf
      
      ; 3. Удаляем все виджеты один за другим через их персональный free()
      ForEach *root\Widget()
         Free(@*root\Widget())
      Next
      
      ; 4. ОЧИСТКА ПАМЯТИ
      If IsGadget(*root\Canvas\gadget)
         FreeGadget(*root\Canvas\gadget)
      EndIf
      
      ; 5. Если сам объект ROOT выделялся динамически
      FreeStructure(*root)
   EndIf
EndProcedure

Procedure CloseList()
   ; Возвращаемся на уровень выше или в корень
   If Opened()
      Opened() = Opened()\parent
   EndIf
EndProcedure

Procedure OpenList(*this._s_WIDGET, item.i = 0)
   ; Запоминаем, что теперь все новые виджеты будут дочерними для *this
   Opened() = *this
EndProcedure

Procedure Open( window, X,Y,Width,Height, title.s, flags.q )
   Protected *root._s_ROOT = AllocateStructure(_s_ROOT)
   
   If IsWindow(window)
      *root\Canvas\window = window
      *root\Canvas\gadget = CanvasGadget(#PB_Any, X,Y,Width,Height, flags)
   Else
      ; Создаем системное окно PureBasic
      *root\Canvas\window = OpenWindow(#PB_Any, X,Y,Width,Height, title, flags)
      *root\Canvas\gadget = CanvasGadget(#PB_Any, 0, 0, Width,Height)
   EndIf
   SetGadgetData(*root\Canvas\gadget, *root )
   
   Static i:*Root\class = Str(i):i+1
   
   ; Получаем масштаб окна (встроено в PB 5.70+)
   *root\dpi = DesktopResolutionX() 
   
   If Root( )
      Root( )\next = *root
      Root( )\next\prev = Root( )
   EndIf
   Root( ) = *root 
   
   OpenList( *root )
   ProcedureReturn *root
EndProcedure

; ==============================================================================
;- ПРИМЕР ИНИЦИАЛИЗАЦИИ И ЗАПУСКА
; ==============================================================================
Procedure InitApp(*root._s_ROOT)
   Protected w = 865, h = 500
   
   *root = Open(0, 0, 0, w, h, "PureBasic UI Engine", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ; СОЗДАЕМ виджеты (выделяем память, задаем тип и координаты)
   Protected *g._s_WIDGET = create_grid(*root, 10, 10, 280, 480)
   Protected *t._s_WIDGET = create_Tree(*root, 300, 10, 280, 480)
;    Protected *e._s_WIDGET = create_edit(*root, 590, 10, 265, 480)
;    Protected *g._s_WIDGET = ListIcon(10, 10, 280, 480, "Имя", 120)
;    Protected *t._s_WIDGET = Tree(300, 10, 280, 480)
   
   Debug ""+*root +" "+ Root()
   Protected *e._s_WIDGET = Editor(590, 10, 265, 480)
   Protected chr.s = "|"
   
   ; Наполняем данными через твои add_column / add_row
   add_column(*g, "Имя", 120) 
   add_column(*g, "возраст", 50)
                             add_column(*g, "город", 150)
   
   add_row(*g, "Александр" + chr + "31" + chr + "Москва")
   add_row(*g, "Елена" + chr + "24" + chr + "Владивосток")
   add_row(*g, "Дмитрий" + chr + "45" + chr + "Тула")
   
   
   add_column(*t, "Имя", 150) 
   add_column(*t, "возраст", 50)
   add_column(*t, "город", 150)
   
   add_row(*t, "node")
   add_row(*t, "Александр" + chr + "31" + chr + "Москва",1)
   add_row(*t, "Елена" + chr + "24" + chr + "Владивосток",1)
   add_row(*t, "Дмитрий" + chr + "45" + chr + "Тула",1)
   
   add_row(*t, "node")
   add_row(*t, "Александр" + chr + "31" + chr + "Москва",1)
   add_row(*t, "Елена" + chr + "24" + chr + "Владивосток",1)
   add_row(*t, "Дмитрий" + chr + "45" + chr + "Тула",1)
   
   add_row(*e, "node")
   add_row(*e, "Александр" + chr + "31" + chr + "Москва",1)
   add_row(*e, "Елена" + chr + "24" + chr + "Владивосток",1)
   add_row(*e, "Дмитрий" + chr + "45" + chr + "Тула",1)
   
   
   ; Отрисовываем всё, что создали
   ReDraw(*root)
   
EndProcedure

; 2. ГЛАВНЫЙ ЦИКЛ СОБЫТИЙ
InitApp(Root( ))

Define Event.i, Event_Gadget.i, Event_Type.i
Define NeedRepaint.b

Repeat
   Event = WaitWindowEvent()
   
   If Event = #PB_Event_Gadget
      Event_Gadget = EventGadget()
      
      If Event_Gadget = Root( )\Canvas\gadget
         Event_Type = EventType()
         
         ; Обновляем мышь в корне
         mouse( )\x = GetGadgetAttribute(Root( )\Canvas\gadget, #PB_Canvas_MouseX)
         mouse( )\y = GetGadgetAttribute(Root( )\Canvas\gadget, #PB_Canvas_MouseY)
         
         NeedRepaint = #False
         
         ForEach widgets( )
            ; Если мышь над виджетом — передаем событие
            If atpoint(widgets( ), mouse( )\x, mouse( )\y)
               do_events(widgets( ), Event_Type)
            EndIf
            
            ; Проверяем, нужна ли перерисовка хотя бы одному виджету
            If widgets( )\mask & #___mask_redraw
               NeedRepaint = #True
            EndIf
         Next
         
         If NeedRepaint
            ReDraw(Root( ))
         EndIf
      EndIf
      
   ElseIf Event = #PB_Event_CloseWindow
      Close(Root( ))
      Break
   EndIf
ForEver

; --- ВОТ ЗДЕСЬ ВЫЗЫВАЕМ CLOSE ---
Close(Root( )) 
Root( ) = 0
End ; Завершение программы
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; FirstLine = 1451
; Folding = ------------------------------------
; EnableXP
; DPIAware