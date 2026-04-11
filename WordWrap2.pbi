EnableExplicit

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
#__type_AreaBar       = - 9

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


#__flag_Left            = 1<<56
#__flag_Top             = 1<<57
#__flag_Right           = 1<<58
#__flag_Bottom          = 1<<59
#__flag_Center          = 1<<60 
#__flag_AutoSize        = 1<<61
#__flag_integral        = 1 << 62

#_align_left   = 0
#_align_center = 1
#_align_right  = 2


; ==============================================================================
; МАСКИ (Quad #__mask_*)
; ==============================================================================
#__mask_active    = 1 << 0  ; Фокус (Виджет) / Выделение (Строка)
#__mask_node      = 1 << 1  ; Является узлом (Строка) / Деревом (Виджет)
#__mask_collapsed = 1 << 2  ; Свернуто (Узел/Ветка)
#__mask_shift     = 1 << 3  ; Зажат Shift (Мышь) / Режим диапазона
#__mask_ctrl      = 1 << 4  ; Зажат Ctrl (Мышь) / Режим инверсии
#__mask_update    = 1 << 5  ; Флаг: Требуется пересчет геометрии (TextWidth и т.д.)
#__mask_redraw    = 1 << 6  ; Флаг: Требуется перерисовка
#__mask_drag      = 1 << 7  ; Состояние перетаскивания
#__mask_edit      = 1 << 8  ; Режим активного редактирования текста
#__mask_press     = 1 << 9
#__mask_hover     = 1 << 10
#__mask_hidden    = 1 << 11
#__mask_disabled  = 1 << 12
#__mask_resize    = 1 << 13

; ==========================================================
; (Цветовая схема и Маски)
; ==========================================================
#COLOR_BACK_NORMAL   = $FFFFFF ; Белый
#COLOR_BACK_SELECTED = $EBD8BD ; Голубой (Active)
#COLOR_BACK_DISABLE  = $F5F5F5 ; Светло-серый
#COLOR_BACK_HOVER    = $F5F5F5
#COLOR_TEXT_NORMAL   = $333333 ; Темно-серый
#COLOR_TEXT_DISABLE  = $AAAAAA ; Серый (Disabled)
#COLOR_LINE          = $EEEEEE ; Разделитель



; ==============================================================================
;- СТРУКТУРЫ ДАННЫХ
; ==============================================================================
Structure _s_POINT : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure

Structure _s_CARET Extends _s_COORDINATE
   pos.i[3]
EndStructure
Structure _s_TEXTINFO Extends _s_COORDINATE
   pos.i
   len.i
   Array str.s(0) 
EndStructure
Structure _s_EDIT Extends _s_TEXTINFO
   caret._s_caret
EndStructure
Structure _s_TEXTITEM Extends _s_TEXTINFO
   edit._s_EDIT[3]
   change.b
EndStructure
Structure _s_TEXT Extends _s_TEXTITEM
   caret.l[2]            ; [0] - точка старта (push), [1] - точка конца (cursor)
   padding._s_POINT      ; ВНУТРЕННИЙ ОТСТУП ТЕКСТА (слева + справа)
   align.a
   ;    mode.a    
   ;    
   ;    multiline.b
   ;    invert.b
   ;    vertical.b
   ;    rotate.d
   ;    
   ;    ;align._s_align
EndStructure

Structure _s_MOUSE Extends _s_POINT
   mask.q                ; Битовые состояния (Shift, Ctrl, Drag)
   press._s_POINT        ; Точка начала нажатия
   *widget._s_WIDGET[3]  ; Текущий виджет под мышью (Entered)
EndStructure

Structure _s_KEYBOARD  ; Ok
   *active._s_WIDGET   ; keyboard focus element ; GetActive( )\
EndStructure

Structure _s_VISIBLE_ROW
   *first._s_rows        ; Указатель на первую видимую строку
   *last._s_rows         ; Указатель на последнюю видимую строку
EndStructure


Structure _s_ROWS Extends _s_COORDINATE
   Array str.s(0)        ; Динамический массив ячеек данных
   Level.i               ; Уровень вложенности для дерева
   mask.q                ; Состояние строки (#__mask_active, #__mask_node...)
   sel_start.l
   sel_end.l
EndStructure

Structure _s_HEADER ; ЗАГОЛОВОК
   ID.l             ; <--- Номер элемента в списке данных строки (0, 1, 2...) 
   X.l              ; Относительный X вкладки в шапке
   Width.l          ; Ширина вкладки
   mask.q           ; Маска конкретной вкладки
   Title.s
   offset_x.i      ; Визуальное смещение для анимации/зазора
EndStructure

Structure _s_COLUMN
   Height.l  ; Высота шапки (заголовков)
             ;    align.a               ; Выравнивание (0-лево, 1-центр, 2-право)
             ;    indent.a              ; ОТСТУП ПЕРВОЙ ВКЛАДКИ СЛЕВА
   spacing.a ; РАССТОЯНИЕ МЕЖДУ ВКЛАДКАМИ
   *active._s_HEADER 
   List __s._s_HEADER( )
EndStructure

Structure _s_TAB
   align.a               ; Выравнивание (0-лево, 1-центр, 2-право)
   indent.a              ; ОТСТУП ПЕРВОЙ ВКЛАДКИ СЛЕВА
   spacing.a             ; РАССТОЯНИЕ МЕЖДУ ВКЛАДКАМИ
   totalwidth.l          ; Общая ширина всех вкладок (уже считаем в update_tab)
   *active._s_HEADER 
   List __s._s_HEADER()  ; Заголовки вкладок
EndStructure

Structure _s_ROW
   Height.l         ; Высота строки данных ; 0 = авто по шрифту
   indent.l         ; Отступ веток дерева
   padding._s_POINT ; Внутренний отступ текста
   *active._s_ROWS
   *press._s_ROWS
   List __s._s_ROWS()        ; Строки данных
EndStructure

Structure _s_BAR Extends _s_COORDINATE
   pos.i : max.i : thumb_h.i : is_drag.b
EndStructure

Structure _s_SCROLL Extends _s_COORDINATE
   v._s_BAR
   h._s_BAR
EndStructure
Structure _s_ITEMS
   *row._s_ROWS  ; Ссылка на физическую строку (абзац)
   pos.l         ; С какого символа начинаем (1...)
   len.l         ; Сколько символов отображаем
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   fs.a[5]
   ; fs[1] — ширина левой панели (или табов слева)
   ; fs[2] — высота шапки (табы сверху или заголовок окна)
   ; fs[3] — ширина правой панели (место под вертикальный скроллбар)
   ; fs[4] — высота подвала (место под горизонтальный скроллбар или табы снизу)
   
   Scroll._s_SCROLL      ; Текущее смещение контента (куда прокручено) и полный размер внутреннего содержимого
   Clip._s_COORDINATE    ; ГРАНИЦЫ ОТСЕЧЕНИЯ (Кешированные); Предрассчитанная область отсечения (reclip)
   real._s_POINT         ; Абсолютные на холсте (считает система)
   
   class.s
   Type.l                ; EDIT или TREE
   color.l
   Level.l
   
   mask.q                ; Состояние виджета (#__mask_update, #__mask_active...)
   
   haschildren.l
   
   
   tabindex.l ; Номер страницы родителя к которому будеть привязан          
   tabpage.l  ; Активная страница (используется если у родителя есть таб бар)
   
   *tab._s_TAB
   *row._s_ROW
   *column._s_COLUMN       
   
   Text._s_TEXT
   visible._s_VISIBLE_ROW
   ; OnEvent.ProtoOnEvent[#__event] ; Указатель на процедуру событий
   
   *address
   *root._s_ROOT                ; Ссылка на корень (холст)
   *parent._s_WIDGET            ; Ссылка на родителя
   
   *first._s_WIDGET             ; Голова всей семьи (всех табов вместе)
   *last._s_WIDGET              ; Хвост всей семьи
   *next._s_WIDGET              ; Следующий брат
   *prev._s_WIDGET              ; Предыдущий брат
   
   *tabbar._s_WIDGET           ; Виджет-шапка Ссылка на дочерний виджет-полосу вкладок
   *areabar._s_WIDGET          ; Виджет-контейнер для скроллинга контента
   
   List __items._s_ITEMS( )     ; Развернутый рулон (указатели)
EndStructure

Structure _s_PARENT Extends _s_WIDGET
   
EndStructure

Structure _s_CANVAS Extends _s_COORDINATE
   dpi.f
   gadget.i              ; Системный номер CanvasGadget
   window.i              ; Номер родительского окна
   
   *next._s_ROOT
   *prev._s_ROOT
EndStructure

Structure _s_ROOT Extends _s_WIDGET
   Canvas._s_CANVAS
EndStructure

Structure _s_GUI
   *root._s_ROOT
   *opened._s_WIDGET             ; last opened-list element
   
   mouse._s_MOUSE                ; mouse( )\
   keyboard._s_KEYBOARD          ; keyboard( )\
EndStructure

Global GUI._s_GUI
Global NewList widgets._s_WIDGET() ; Список всех виртуальных виджетов на холсте

;
Macro Opened( ): GUI\opened: EndMacro
;Macro widgets( ): GUI\root\Widget( ): EndMacro
Macro Root( ): GUI\root: EndMacro
Macro NextRoot( ) : Canvas\next : EndMacro
Macro PrevRoot( ) : Canvas\prev : EndMacro

Macro mouse( ): GUI\mouse: EndMacro
Macro Entered( ): GUI\mouse\widget[0]: EndMacro
Macro Leaved( ): GUI\mouse\widget[1]: EndMacro
Macro Pressed( ): GUI\mouse\widget[2]: EndMacro
Macro keyboard( ): GUI\keyboard: EndMacro
Macro GetActive( ): GUI\keyboard\active: EndMacro
Procedure SetActive(*this._s_WIDGET)
   If GetActive( ) 
      GetActive( )\mask &~ #__mask_active 
   EndIf
   GetActive( ) = *this
   Root( ) = *this\root
   *this\mask | (#__mask_active | #__mask_redraw)
EndProcedure

; Macro RowFocused( _this_ )
;    _this_\row\active ; GUI\rowactive
; EndMacro

; Macro ColumnFocused( _this_ )
;    _this_\column\active ; GUI\rowactive
; EndMacro

;-
Macro __tabs( )
   Tab\__s( )
EndMacro
Macro __columns( )
   column\__s( )
EndMacro
Macro __rows( )
   row\__s( )
EndMacro

;-
Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro

;-
Macro Clip(_widget_) : ClipOutput(_widget_\clip\x, _widget_\clip\y, _widget_\clip\width, _widget_\clip\height) : EndMacro
Macro UnClip() : UnclipOutput() : EndMacro

Procedure ReClip(*this._s_WIDGET)
   *this\clip\x = *this\real\x : *this\clip\width = *this\Width
   *this\clip\y = *this\real\y : *this\clip\height = *this\Height
   
   If *this\parent And *this\parent\Type <> #__type_Root
      ; Определяем границы контента родителя (за вычетом всех рамок)
      Protected px = *this\parent\clip\x + *this\parent\fs[0] + *this\parent\fs[1]
      Protected py = *this\parent\clip\y + *this\parent\fs[0] + *this\parent\fs[2]
      Protected pw = *this\parent\clip\width - (*this\parent\fs[0] * 2) - *this\parent\fs[1] - *this\parent\fs[3]
      Protected ph = *this\parent\clip\height - (*this\parent\fs[0] * 2) - *this\parent\fs[2] - *this\parent\fs[4]
      
      ; Стандартное пересечение (чтобы ребенок не вылезал за границы родителя)
      If *this\clip\x < px : *this\clip\width - (px - *this\clip\x) : *this\clip\x = px : EndIf
      If *this\clip\y < py : *this\clip\height - (py - *this\clip\y) : *this\clip\y = py : EndIf
      If *this\clip\x + *this\clip\width > px + pw : *this\clip\width = (px + pw) - *this\clip\x : EndIf
      If *this\clip\y + *this\clip\height > py + ph : *this\clip\height = (py + ph) - *this\clip\y : EndIf
   EndIf
EndProcedure
;-
Macro hidden( _this_, _parent_, _tabpage_ )
   If _parent_
      ; 1. НАСЛЕДОВАНИЕ: Если родитель скрыт — мы скрыты автоматически
      If _parent_\mask & #__mask_hidden
         _this_\mask | #__mask_hidden
      Else
         ; 2. ЛОГИКА СТРАНИЦ
         If is_integral_(_this_)
            ; Системные виджеты всегда видны
            _this_\mask & ~#__mask_hidden
            
         Else
            ; СЛУЧАЙ А: Мы лежим в AreaBar (смотрим на дедушку)
            If _parent_\Type = #__type_AreaBar And _parent_\parent
               If _tabpage_ <> _parent_\parent\tabpage
                  _this_\mask | #__mask_hidden
               Else
                  _this_\mask & ~#__mask_hidden
               EndIf
               
               ; СЛУЧАЙ Б: Мы лежим прямо в Панели (смотрим на отца)
            ElseIf _parent_\tabbar
               If _tabpage_ <> _parent_\tabpage
                  _this_\mask | #__mask_hidden
               Else
                  _this_\mask & ~#__mask_hidden
               EndIf
               
            Else
               ; В обычном контейнере без вкладок — всегда видны
               _this_\mask & ~#__mask_hidden
            EndIf
         EndIf
      EndIf
      
      ; ОТЛАДКА (внутри If _parent_)
      If _this_\mask & #__mask_hidden
         Debug "СКРЫТ: " + _this_\class + " (Стр: " + Str(_this_\tabindex) + " Род.Инд: " + Str(_parent_\tabpage) + ")"
      Else
         Debug "ВИДИМ: " + _this_\class + " (Стр: " + Str(_this_\tabindex) + " Род.Инд: " + Str(_parent_\tabpage) + ")"
      EndIf
   EndIf
EndMacro

Macro is_integral_(_this_)
   Bool(_this_\tabindex = -1) ; ( @_this_ = _this_\parent\tabbar Or @_this_ = _this_\parent\areabar)
EndMacro

;-
Macro StartEnum(_parent_ptr_, _tabpage_ = #PB_All)
   ; Проверка, что у родителя вообще есть дети
   Bool(_parent_ptr_ And _parent_ptr_\first )
   ; PushListPosition(widgets())
   ChangeCurrentElement(widgets(), _parent_ptr_\first)
   Repeat 
      ; 2. ВЫХОД: Конец всей родительской ветки
      If widgets() = _parent_ptr_\next Or (_parent_ptr_\areabar And widgets() = _parent_ptr_\areabar\next)
         Break
      EndIf
      
      ; 3. ФИЛЬТР: Пропускаем чужие табы, но оставляем наш и -1
      If _tabpage_ <> #PB_All
         ; Если это прямой потомок
         If widgets()\parent = _parent_ptr_ Or widgets()\parent = _parent_ptr_\areabar
            ; Если таб не совпал и это не универсальный (-1) — ПРЫГАЕМ
            If widgets()\tabindex <> _tabpage_ And widgets()\tabindex <> -1
               ; Прыжок к следующему соседу через его детей
               If widgets()\next
                  ChangeCurrentElement(widgets(), widgets()\next)
                  PreviousElement(widgets())
                  Continue ; Проверяем нового соседа
               Else
                  Break ; Больше детей нет
               EndIf
            EndIf
         EndIf
      EndIf
      
      ; --- ТВОЙ КОД ---
   EndMacro
   
   Macro StopEnum()
   Until Not NextElement(widgets())
   ; PopListPosition(widgets())
EndMacro

Macro Start(_ptr_, _parent_)
   _ptr_ = _parent_\first
   While _ptr_
      ; Если нужно работать с widgets(), раскомментируй:
      ; ChangeCurrentElement(widgets(), _ptr_) 
   EndMacro
   
   Macro Stop(_ptr_, _parent_)
      _ptr_ = _ptr_\next
      ; Если вышли за пределы ветки этого родителя — обнуляем указатель
      If _ptr_ = _parent_\next : _ptr_ = 0 : EndIf
   Wend
EndMacro


;-
; ==============================================================================
; ГЕОМЕТРИЯ И ОБНОВЛЕНИЕ
; ==============================================================================
Procedure SetOSData(handle.i, Value.i)
   CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
         SetProp_(handle, "MyOSData", Value)
         
      CompilerCase #PB_OS_Linux
         CompilerIf Subsystem("Qt")
            ; QtScript(~"qt.object("+Str(handle)+").setProperty('MyOSData', "+Str(Value)+")")
            q_object_set_property(handle, "MyOSData", Value)
         CompilerElse
            g_object_set_data_(handle, "MyOSData", Value)
         CompilerEndIf
         
      CompilerCase #PB_OS_MacOS
         objc_setAssociatedObject_(handle, "MyOSData", Value, 0)
   CompilerEndSelect
EndProcedure

Procedure.i GetOSData(handle.i)
   CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
         ProcedureReturn GetProp_(handle, "MyOSData")
         
      CompilerCase #PB_OS_Linux
         CompilerIf Subsystem("Qt")
            ; ProcedureReturn Val(QtScript(~"qt.object("+Str(handle)+").property('MyOSData')"))
            ProcedureReturn q_object_get_property(handle, "MyOSData")
         CompilerElse
            ProcedureReturn g_object_get_data_(handle, "MyOSData")
         CompilerEndIf
         
      CompilerCase #PB_OS_MacOS
         ProcedureReturn objc_getAssociatedObject_(handle, "MyOSData")
   CompilerEndSelect
EndProcedure

;-



Procedure.i edit_make_textcaret_position(*this._s_WIDGET, *item._s_ITEMS, rx, ry)
   Protected i.i, mouse_x.i, textcaret.i = -1
   
   ; Если мы передали корректный визуальный элемент
   If *item And *item\row
      ; 1. Берем текст ТОЛЬКО текущего визуального сегмента (то, что видит глаз)
      Protected Text.s = Mid(*item\row\Str(0), *item\pos, *item\len)
      Protected LenText = Len(Text)
      
      ; 2. Базовый X начала текста (дерево + паддинги)
      Protected offset = 5 + (*item\row\Level * *this\row\indent)
      If (*item\row\mask & #__mask_node) : offset + 15 : EndIf
      
      ; Рассчитываем X мыши относительно начала ЭТОГО сегмента
      mouse_x = mouse()\x - (rx + offset)
      
      ; 3. Ищем ближайший символ внутри сегмента
      Protected MinDistance.d = 1e308
      
      ; ВАЖНО: StartDrawing нужен для работы TextWidth
      If StartDrawing(CanvasOutput(*this\root\Canvas\gadget))
         For i = 0 To LenText
            Protected textcaret_x = TextWidth(Left(Text, i))
            Protected Distance = (mouse_x - textcaret_x) * (mouse_x - textcaret_x)
            
            If Distance <= MinDistance
               MinDistance = Distance
               ; ИТОГ: позиция в абзаце = (Старт сегмента - 1) + индекс внутри сегмента
               textcaret = (*item\pos - 1) + i
            Else
               ; Если расстояние начало расти — мы нашли ближайшую точку
               Break
            EndIf
         Next
         StopDrawing()
      EndIf
   EndIf
   
   ProcedureReturn textcaret
EndProcedure


Procedure caret(*this._s_WIDGET)
   Protected result
   ;StartDrawing(CanvasOutput(*this\root\Canvas\gadget))
   ; 1. Всегда обновляем текущую позицию каретки (конец выделения)
   result = edit_make_textcaret_position(*this, *this\row\active, *this\real\x, *this\real\y)
   ;StopDrawing()
   ProcedureReturn result    
EndProcedure


;-
Procedure resize_column(*this._s_WIDGET, *column._s_HEADER, new_w.i)
   If *column
      ; Устанавливаем минимальный порог, чтобы колонка не исчезла совсем
      If new_w < 20 : new_w = 20 : EndIf 
      
      If *column\width <> new_w
         ; Записываем новую ширину
         *column\width = new_w
         
         ; Поднимаем флаги: 
         ; 1. update — чтобы в redraw вызвался update_columns (пересчет X)
         ; 2. redraw — чтобы холст обновился визуально
         *this\mask | (#__mask_update | #__mask_redraw)
      EndIf
   EndIf
EndProcedure

Procedure resize_row(*this._s_WIDGET, *row._s_rows, new_h.i)
   If *row
      ; Ограничиваем минимальную высоту
      If new_h < 15 : new_h = 15 : EndIf 
      
      If *row\height <> new_h
         ; Записываем новую высоту конкретной строке
         *row\height = new_h
         
         ; Поднимаем флаги для вызова update_rows (пересчет Y всех строк ниже)
         *this\mask | (#__mask_update | #__mask_redraw)
      EndIf
   EndIf
EndProcedure

Procedure Resize(*this._s_WIDGET, X.l, Y.l, Width.l, Height.l)
   Protected *g._s_WIDGET ; Наш локальный указатель для рекурсии
   
   *this\X = X : *this\Y = Y
   *this\Width = Width : *this\Height = Height
   
   ; 1. СЧИТАЕМ РЕАЛЬНЫЕ КООРДИНАТЫ
   If *this\parent And *this\parent\Type <> #__type_Root
      ; Считаем реальные координаты относительно "внутреннего мира" родителя
      ; fs[0] - общий отступ, fs[1] - лево, fs[2] - верх
      *this\real\x = *this\parent\real\x + *this\parent\fs[0] + *this\X ; + *this\parent\fs[1] 
      *this\real\y = *this\parent\real\y + *this\parent\fs[0] + *this\Y ; + *this\parent\fs[2]
      
      ; Скролл игнорируем только для системных (is_integral_) элементов
      If Not is_integral_(*this)
         *this\real\x - *this\parent\scroll\x
         *this\real\y - *this\parent\scroll\y
      EndIf
   Else
      *this\real\x = *this\X : *this\real\y = *this\Y
   EndIf
   
   ; 2. ОБНОВЛЯЕМ НОЖНИЦЫ (Clips)
   ReClip(*this) 
   
   ; 3. КАСКАД ДЕТЕЙ (Рекурсия)
   Start(*g, *this)
   ; Передаем управление вглубь дерева. 
   ; Каждый вызов Resize создаст свой *g на стеке.
   Resize(*g, *g\X, *g\Y, *g\Width, *g\Height)
   Stop(*g, *this)
   
   ; 4. Поднимаем маску обновления
   *this\mask | (#__mask_update | #__mask_redraw)
EndProcedure

;-
Procedure update_tab(*this._s_WIDGET)
   Protected cur_x = 0
   PushListPosition(*this\__tabs())
   ForEach *this\__tabs()
      *this\__tabs( )\x = cur_x
      ; Замеряем текст и добавляем отступы (по 10px с каждой стороны)
      *this\__tabs()\width = TextWidth(*this\__tabs()\title) + *this\text\padding\x * 2
      cur_x + *this\__tabs( )\Width
   Next
   ; Максимальный сдвиг = (Общая ширина колонок) - (Ширина виджета)
   *this\tab\totalwidth = cur_x ; - *this\Width
   PopListPosition(*this\__tabs())
EndProcedure

Procedure update_visible_rows(*this._s_WIDGET)
   If Not *this Or ListSize(*this\__items( )) = 0
      *this\visible\first = 0 : *this\visible\last = 0
      ProcedureReturn
   EndIf
   
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   
   Protected view_top = *v\pos
   Protected view_bottom = *v\pos + *this\height - *this\column\height
   
   *this\visible\first = 0
   *this\visible\last = 0
   
   ForEach *this\__items( )
      Protected row_top = *this\__items( )\row\y - *this\column\height
      Protected row_bottom = row_top + *this\__items( )\row\height 
      
      ; Ищем ПЕРВУЮ видимую (верхний край строки выше низа экрана И нижний ниже верха)
      If Not *this\visible\first
         If row_bottom > view_top
            *this\visible\first = @*this\__items( )
         EndIf
      EndIf
      
      ; Ищем ПОСЛЕДНЮЮ видимую
      If *this\visible\first
         *this\visible\last = @*this\__items( )
         ; Если верх этой строки уже ниже видимой области — это точно последняя
         If row_top > view_bottom
            Break 
         EndIf
      EndIf
   Next
EndProcedure

Procedure update_nodes(*this._s_WIDGET)
   PushListPosition(*this\__rows( ))
   ForEach *this\__rows( )
      Protected current_level = *this\__rows( )\Level
      *this\__rows( )\mask &~ #__mask_node ; Сбрасываем старый флаг
      
      ; Заглядываем в следующую строку
      If NextElement(*this\__rows( ))
         If *this\__rows( )\Level > current_level
            ; Предыдущий элемент — это родитель (узел)
            PreviousElement(*this\__rows( ))
            *this\__rows( )\mask | #__mask_node
            NextElement(*this\__rows( ))
         Else
            PreviousElement(*this\__rows( ))
         EndIf
      EndIf
   Next
   PopListPosition(*this\__rows( ))
EndProcedure

Procedure _update_columns(*this._s_WIDGET)
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   
   Protected cur_x = 0
   ForEach *this\__columns( )
      *this\__columns( )\x = cur_x
      cur_x + *this\__columns( )\Width
   Next
   ; Максимальный сдвиг = (Общая ширина колонок) - (Ширина виджета)
   *h\max = cur_x - *this\Width
   
   ; Если колонки уже узкие и влезают в экран, скролл не нужен (0)
   If *h\max < 0 : *h\max = 0 : EndIf
   
   ; Защита: если скролл был в конце, а мы сузили колонки, корректируем позицию
   If *h\pos > *h\max
      *h\pos = *h\max
   EndIf
EndProcedure
Procedure update_columns(*this._s_WIDGET)
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   Protected cur_x = 0
   
   ; --- 1. АВТОПОДБОР ШИРИНЫ (SCAN-PASS) ---
   ; Проходим по колонкам и, если нужно, считаем ширину по контенту
   ForEach *this\__columns()
      ; Условие: например, если ширина колонки <= 0, считаем её автоматически
      If *this\__columns()\Width <= 0
         Protected max_w = 40 ; Минимальная базовая ширина
         Protected col_idx = *this\__columns()\id
         
         ; Сканируем строки (в идеале — только видимые или первые N для скорости)
         PushListPosition(*this\__rows())
         ForEach *this\__rows()
            Protected text_w = TextWidth(*this\__rows()\Str(col_idx))
            
            ; Если это первая колонка, учитываем отступ дерева
            If col_idx = 0 And *this\row\indent > 0
               text_w + (*this\__rows()\Level * *this\row\indent) + 20 ; + иконка
            EndIf
            
            If text_w > max_w : max_w = text_w : EndIf
         Next
         PopListPosition(*this\__rows())
         
         *this\__columns()\Width = max_w + 10 ; + небольшой паддинг справа
      EndIf
      
      ; --- 2. РАСЧЕТ ГЕОМЕТРИИ ---
      *this\__columns()\x = cur_x
      cur_x + *this\__columns()\Width
   Next
   
   ; Максимальный сдвиг
   *h\max = cur_x - *this\Width
   If *h\max < 0 : *h\max = 0 : EndIf
   
   ; Корректировка позиции при изменении размеров
   If *h\pos > *h\max : *h\pos = *h\max : EndIf
EndProcedure

Procedure update_rows(*this._s_WIDGET)
   If Not *this : ProcedureReturn : EndIf
   
   Protected._s_BAR *v = *this\Scroll\v
   ClearList(*this\__items()) 
   
   *this\visible\first = 0
   *this\visible\last = 0
   
   Protected h_item = *this\row\Height
   If h_item <= 0 : h_item = 22 : EndIf 
   
   ; Доступная ширина для текста
   Protected max_w = *this\Width - (*this\row\padding\x * 2)
   ; Если есть скроллбар, вычитаем его ширину (примерно 16-20 пикселей)
   If max_w > 40 : max_w - 20 : EndIf 
   
   Protected cur_y = 0
   Protected skip_level = -1

   
   ForEach *this\row\__s()
      Protected *row._s_ROWS = @*this\row\__s()
      
      ; --- ЛОГИКА TREE (Схлопывание) ---
      If *this\Type = #__type_Tree
         If skip_level <> -1
            If *row\Level > skip_level : Continue : Else : skip_level = -1 : EndIf
         EndIf
         If (*row\mask & #__mask_node) And (*row\mask & #__mask_collapsed)
            skip_level = *row\Level
         EndIf
      EndIf

      Protected txt.s = *row\Str(0)
      Protected total = Len(txt)
      
      ; --- ЛОГИКА EDITOR (WORD WRAP) ---
      If *this\Type = #__type_Editor And total > 0
         Protected start = 1
         While start <= total
            AddElement(*this\__items())
            *this\__items()\row    = *row
            *this\__items()\row\y      = cur_y
            *this\__items()\row\Height = h_item
            *this\__items()\pos    = start
            
            ; Ищем, сколько символов влезет в ширину max_w
            Protected l = 1
            ; Пока кусок строки от start длиной l влезает в ширину
            While (start + l - 1) <= total And TextWidth(Mid(txt, start, l)) <= max_w
               l + 1
            Wend
            
            ; Если ни один символ не влез (очень узкое окно) - берем хотя бы один
            If l = 1 : l = 2 : EndIf 
            
            *this\__items()\len = l - 1
            start + (l - 1)
            cur_y + h_item
         Wend
      Else
         ; --- ОБЫЧНЫЙ РЕЖИМ (Grid, Tree или пустая строка) ---
         AddElement(*this\__items())
         *this\__items()\row    = *row
         *this\__items()\row\y      = cur_y
         *this\__items()\row\Height = h_item
         *this\__items()\pos    = 1
         *this\__items()\len    = total
         cur_y + h_item
      EndIf
   Next
   
   *v\max = cur_y - (*this\height - *this\column\height)
   If *v\max < 0 : *v\max = 0 : EndIf
   
   update_visible_rows(*this)
EndProcedure

Procedure update_level(*this._s_WIDGET, new_level.l)
   Protected *child._s_WIDGET
   *this\Level = new_level
   
   ; Рекурсивно обновляем всех детей
   *child = *this\first
   While *child
      update_level(*child, new_level + 1)
      *child = *child\next
   Wend
EndProcedure

;-
Procedure.i GetTabStartX(*this._s_WIDGET)
   ; Если вкладок нет или ширина не посчитана
   If *this\tab\totalwidth <= 0 : ProcedureReturn *this\tab\indent : EndIf
   
   Select *this\tab\align
      Case #_align_center ; ПО ЦЕНТРУ (#_align_center)
                          ; (Ширина бара - Ширина всех вкладок) / 2
         ProcedureReturn (*this\Width - *this\tab\totalwidth) / 2
         
      Case #_align_right ; СПРАВА (#_align_right)
                         ; Ширина бара - Ширина всех вкладок - Отступ
         ProcedureReturn *this\Width - *this\tab\totalwidth - *this\tab\indent - (*this\tab\spacing * (ListSize( *this\__tabs())-1)) - 1
         
      Case #_align_left ; СЛЕВА (0, #_align_left)
         ProcedureReturn *this\tab\indent
   EndSelect
EndProcedure

Procedure draw_button(*this._s_WIDGET, rx.l, ry.l)
   Protected tx, ty, tw, th
   Protected text_shift.i = 0      ; Смещение текста при нажатии
   Protected c1.i, c2.i, border.i, round = 0
   
   ; --- ЦВЕТОВАЯ СХЕМА ---
   
   If *this\mask & #__mask_disabled
      c1 = $F5F5F5 : c2 = $E0E0E0 : border = $D0D0D0 ; Серый (выключен)
      
   ElseIf *this\mask & #__mask_press
      c1 = $D0D0D0 : c2 = $BCBCBC : border = $707070 ; Вдавленная (темная)
      text_shift = 1                                 ; Эффект нажатия
      
   ElseIf *this\mask & #__mask_hover
      c1 = $FFFFFF : c2 = $F0F0F0 : border = $808080 ; Подсветка (светлее)
      
   Else ; Обычное состояние
      c1 = $FCFCFC : c2 = $EAEAEA : border = $A0A0A0
   EndIf
   
   ; --- ОТРИСОВКА ГЕОМЕТРИИ ---
   
   ; 1. Рисуем градиентный фон
   DrawingMode(#PB_2DDrawing_Gradient)
   BackColor(c1)
   GradientColor(1.0, c2)
   LinearGradient(rx, ry, rx, ry + *this\Height)
   
   ; Используем RoundBox для мягких углов (3 пикселя радиус)
   RoundBox(rx, ry, *this\Width, *this\Height, round, round)
   
   ; 2. Рисуем рамку
   DrawingMode(#PB_2DDrawing_Outlined)
   RoundBox(rx, ry, *this\Width, *this\Height, round, round, border)
   
   ; 3. Фокус ввода (тонкий пунктир или внутренняя рамка)
   If *this\mask & #__mask_active
      ; Рисуем еле заметную внутреннюю рамку фокуса
      RoundBox(rx+2, ry+2, *this\Width-4, *this\Height-4, 2, 2, $3399FF)
   EndIf
   
   ; Вычисляем координаты текста для центровки
   tw = TextWidth(*this\class)
   th = TextHeight(*this\class)
   
   ; Центрируем по вертикали всегда
   ty = ry + (*this\Height - th) / 2
   
   ; Выбираем rx по горизонтали
   Select *this\text\align
      Case #_align_center
         tx = rx + (*this\Width - tw) / 2
      Case #_align_right
         tx = rx + *this\Width - tw - *this\text\padding\X ; 5 пикселей отступ справа
      Case #_align_left
         tx = rx + *this\text\padding\X                 ; 5 пикселей отступ слева
   EndSelect
   
   ; Рисуем текст по центру кнопки
   DrawingMode(#PB_2DDrawing_Transparent)
   DrawText(tx + text_shift, ty + text_shift, *this\class, $333333, $EAEAEA)
EndProcedure

Procedure draw_tab(*this._s_WIDGET, rx.l, ry.l)
   ; 1. ВЫЧИСЛЯЕМ СТАРТ (с учетом выравнивания и скролла самого таббара)
   Protected X = rx + GetTabStartX(*this) - *this\scroll\x
   Protected tx, tw, th, i = 0
   Protected color, txtColor
   Protected active_x = -1, active_w = 0 
   
   th = TextHeight( "A" )
   
   PushListPosition(*this\__tabs())
   ForEach *this\__tabs()
      If *this\__tabs()\mask & #__mask_hidden : Continue : EndIf
      
      ; ИСПОЛЬЗУЕМ ИНДЕКС РОДИТЕЛЯ
      If *this\__tabs()\mask & #__mask_active
         active_x = X : active_w = *this\__tabs()\width
         color = $FFFFFF : txtColor = $000000
      ElseIf *this\__tabs()\mask & #__mask_disabled
         color = $D0D0D0 : txtColor = $888888 
      ElseIf *this\__tabs()\mask & #__mask_hover
         color = $F8F8F8 : txtColor = $000000
      Else
         color = $E0E0E0 : txtColor = $000000
      EndIf
      
      ; Вычисляем координаты текста для центровки
      tw = TextWidth( *this\__tabs()\title)
      
      ; РИСУЕМ ТЕЛО ТАБА
      Box(X, ry, *this\__tabs()\width, *this\Height, color)
      
      ; Выбираем rx по горизонтали
      Select *this\text\align
         Case #_align_center
            tx = X + (*this\Width - tw) / 2
         Case #_align_right
            tx = X + *this\Width - tw - *this\text\padding\x ; 5 пикселей отступ справа
         Case #_align_left
            tx = X + *this\text\padding\x                 ; 5 пикселей отступ слева
      EndSelect
      
      DrawText(tx, ry + (*this\Height - th)/2, *this\__tabs()\title, txtColor, color)
      
      ; РАМКА (Верх, Лево, Право)
      Line(X, ry, *this\__tabs()\width, 1, $CCCCCC) 
      Line(X, ry, 1, *this\Height, $CCCCCC)                   
      Line(X + *this\__tabs()\width, ry, 1, *this\Height, $CCCCCC) 
      
      X + *this\__tabs()\width + *this\tab\spacing 
      i + 1
   Next
   PopListPosition(*this\__tabs())
   
   ; --- 2. ЛИНИЯ-РАЗДЕЛИТЕЛЬ ---
   Line(rx, ry + *this\Height, *this\Width, 1, $CCCCCC)
   
   ; Стираем линию под активным табом (только если он виден в пределах Areabar)
   If active_x >= rx And active_x < rx + *this\Width
      Line(active_x + 1, ry + *this\Height, active_w - 1, 1, $FFFFFF)
   EndIf
EndProcedure

Procedure draw_panel(*this._s_WIDGET, rx.l, ry.l)
   Protected tabheight = *this\fs[2]
   ; --- 1. ФОН КОНТЕНТА ---
   ; Рисуем белое тело панели под шапкой
   Box(rx, ry + tabheight, *this\Width, *this\Height - tabheight, $FFFFFF) 
   If *this\tabbar 
      ; --- 2. РАМКА ПЕРИМЕТРА ---
      ; Рисуем бока и низ (верхнюю линию нарисует draw_tab или сама панель частями)
      Line(rx, ry + *this\Height - 1, *this\Width, 1, $CCCCCC) ; Низ
      Line(rx, ry + tabheight, 1, *this\Height - tabheight, $CCCCCC)                   ; Лево
      Line(rx + *this\Width - 1, ry + tabheight, 1, *this\Height - tabheight, $CCCCCC) ; Право
      
      If  *this\tabbar\mask & #__mask_hidden
         ; Если нужно, чтобы рамка была и сверху над табами:
         Line(rx, ry, *this\Width, 1, $CCCCCC) ; Верх
      Else
         ; --- 3. ОТРИСОВКА ВКЛАДОК ---
         ; Вызываем табы ПОВЕРХ рамки, чтобы активный таб мог "стереть" границу
         draw_tab(*this\tabbar, rx, ry)
      EndIf
   EndIf
EndProcedure

Procedure draw_columns(*this._s_WIDGET, rx.l, ry.l)
   Protected dx = rx
   Protected dy = ry
   Protected color
   Protected *column._s_HEADER
   
   ; 1. Рисуем общий фон шапки высота columnheight
   Box(rx, dy, *this\Width, *this\column\height, $F5F5F5)
   
   ForEach *this\__columns( )
      *column = *this\__columns( )
      If *column
         Protected col_x = dx + *column\x
         
         If *column\mask & #__mask_hover
            color = $E0E0E0 ; Цвет при наведении
         Else
            color = $F5F5F5
         EndIf
         
         ; 2. Рисуем фон колонки и текст заголовка
         Box(col_x, dy, *column\Width, *this\column\height, color)
         DrawText(col_x + 5, dy + 5, *column\Title, $333333, color)
         
         ;          ; --- ДОБАВЛЕНО: Линия на середине колонки под мышью ---
         ;          If *this\mask & #__mask_press
         ;             If *column\mask & #__mask_hover And Not *column\mask & #__mask_active
         ;                ; Рисуем яркую вертикальную линию ровно по центру ховер-колонки
         ;                Protected mid_x = col_x + (*column\Width / 2)
         ;                Line(mid_x, dy, 1, *this\column\height, $0000FF) ; Синяя линия
         ;             EndIf
         ;          EndIf
         ; --- ДОБАВЛЕНО: Линия на середине колонки с засечками ---
         If *this\mask & #__mask_press
            If *column\mask & #__mask_hover And Not *column\mask & #__mask_active
               ; 1. Рассчитываем центр
               Protected mid_x = col_x + (*column\Width / 2)
               Protected c_blue = $FF0000 ; Синий в BGR
               
               ; 2. Рисуем основную вертикальную линию
               Line(mid_x, dy, 1, *this\column\height, c_blue)
               
               ; 3. Рисуем верхнюю засечку (горизонтальная перекладина)
               Line(mid_x - 3, dy, 7, 1, c_blue)
               
               ; 4. Рисуем нижнюю засечку
               Line(mid_x - 3, dy + *this\column\height - 1, 7, 1, c_blue)
            EndIf
         EndIf
         
         ; 3. Рисуем вертикальный разделитель (сетку) на всю высоту виджета
         Line(col_x + *column\Width, dy, 1, *this\height , $CCCCCC)
      EndIf
   Next
   
   ; Нижняя граница шапки
   Line(*this\real\x, dy + *this\column\height, *this\Width, 1, $AAAAAA)
EndProcedure

Procedure draw_rows(*this._s_WIDGET, rx.l, ry.l)
   If Not *this\visible\first : ProcedureReturn : EndIf
   Protected._s_rows *row
   ; Рассчитываем базовое смещение по X ОДИН РАЗ (экранный X виджета - скролл)
   Protected dx = rx
   
   ; 1. Прыгаем сразу к первой видимой строке
   ChangeCurrentElement(*this\__items( ), *this\visible\first)
   Repeat 
      ; Берем адрес текущей строки (безопасный доступ)
      *row = *this\__items( )\row
      If *row 
         ; Рассчитываем экранный Y для текущей строки
         Protected dy = ry + *row\y
         
         ; --- ЛОГИКА ЦВЕТА ФОНА ---
         Protected color = #COLOR_BACK_NORMAL
         
         ; Приоритет 1: Выделение (Active)
         If *row\mask & #__mask_active And Not *this\Type = #__type_Editor
            color = #COLOR_BACK_SELECTED
            
            ; Приоритет 2: Наведение (Hover) - только если мышь внутри виджета
         ElseIf *row\mask & #__mask_hover
            color = #COLOR_BACK_HOVER 
         EndIf
         
         ; Рисуем подложку строки
         Box(rx + 1, dy, *this\width - 2, *row\height - 1, color)
         
         ; --- ОТРИСОВКА ТЕКСТА ПО КОЛОНКАМ ---
         PushListPosition(*this\__columns( ))
         ; --- ВНУТРИ ЦИКЛА ПО КОЛОНКАМ ---
         ForEach *this\__columns( )
            Protected col_x    = dx + *this\__columns( )\x
            Protected col_w    = *this\__columns( )\Width
            Protected data_idx = *this\__columns( )\id
            
            ; 1. Проверяем, видна ли колонка вообще (Оптимизация)
            If col_x + col_w > rx And col_x < rx + *this\Width
               
               ; 2. РАСЧЕТ УМНОГО КЛИПА (Пересечение колонки и виджета)
               ; Берем максимальное из левых границ
               Protected clip_x = Max(col_x, rx) 
               ; Берем минимальное из правых границ и вычитаем левую, чтобы получить ширину
               Protected clip_width = Min(col_x + col_w, rx + *this\Width) - clip_x
               
               ; Если ширина клипа получилась отрицательной (вне видимости) — пропускаем
               If clip_width > 0
                  ClipOutput(clip_x, dy, clip_width, *row\height )
                  
                  If data_idx <= ArraySize(*row\Str( ))
                     Protected Text.s = *row\Str(data_idx)
                     Protected offset = 5
                     
                     ; --- ЛОГИКА ДЕРЕВА (ДЛЯ ПЕРВОЙ КОЛОНКИ) ---
                     If *this\row\indent > 0 And data_idx = 0
                        ; Рассчитываем базовый отступ для текущего уровня вложенности
                        offset = 5 + (*row\Level * *this\row\indent)
                        
                        ; Если строка является узлом (папкой) — РИСУЕМ ТРЕУГОЛЬНИК
                        If (*row\mask & #__mask_node)
                           ; Точные экранные координаты для иконки
                           Protected tx = col_x + offset
                           Protected ty = dy + (*row\height / 2) - 4
                           
                           ; Цвет иконки (серый)
                           FrontColor($888888)
                           
                           If *row\mask & #__mask_collapsed
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
                     
                     
                     ; 1. РИСУЕМ ВЫДЕЛЕНИЕ (между якорем и курсором)
                     If *row\sel_start <> *row\sel_end 
                        Protected sel_x = col_x + offset + TextWidth(Left(Text, *row\sel_start))
                        Protected sel_w = TextWidth(Mid(Text, *row\sel_start + 1, *row\sel_end - *row\sel_start))
                        
                        Box(sel_x, dy + 2, sel_w, *row\height - 4, #COLOR_BACK_SELECTED)
                     EndIf
                     
                     
                     ; --- РИСУЕМ ТЕКСТ (ПОВЕРХ ВЫДЕЛЕНИЯ) ---
                     DrawingMode(#PB_2DDrawing_Transparent) ; Включаем прозрачность
                     DrawText(col_x + offset, dy + 5, Text, #COLOR_TEXT_NORMAL)
                     DrawingMode(#PB_2DDrawing_Default)     ; Возвращаем как было
                     
                     If *row\mask & #__mask_edit 
                        ; --- РИСУЕМ КАРЕТКУ (КУРСОР) ---
                        If *this\mask & #__mask_active 
                           If *row\mask & #__mask_active 
                              ; 1. Берем подстроку от начала до индекса каретки
                              ; Если textcaret = 0, Left вернет пустую строку, и TextWidth будет 0 (начало строки)
                              Protected textcaret_text.s = Left(Text, *this\text\caret)
                              
                              ; 2. Считаем ширину только этой части текста
                              Protected textcaret_x_offset = TextWidth(textcaret_text)
                              
                              ; 3. Итоговая экранная координата линии
                              ; col_x (экранный X колонки) + offset (дерево) + ширина текста до курсора
                              Protected cx = col_x + offset + textcaret_x_offset
                              
                              ; Рисуем мигающую линию
                              ; If (ElapsedMilliseconds( ) / 500) % 2
                              Line(cx, dy + 2, 1, *row\height - 4, $000000)
                              ; EndIf
                           EndIf
                        EndIf
                     Else
                        ; --- ДОБАВЛЕНО: Линия на середине строки под мышью ---
                        If *this\mask & #__mask_press
                           If *row\mask & #__mask_hover And *row\mask & #__mask_active 
                              ; Рисуем яркую горизонтальную линию ровно по центру ховер-колонки
                              Protected mid_y = dy + (*row\Height / 2)
                              Protected c_blue = $FF0000 ; Синий в BGR
                              
                              ; 2. Рисуем основную горизонтальную линию
                              Line(dx, mid_y, clip_width, 1, c_blue)
                              
                              ; 3. Рисуем слева засечку (вертикальная перекладина)
                              Line(dx, mid_y-3, 1, 7, c_blue)
                              
                              ; 4. Рисуем справа засечку
                              Line(dx + clip_width - 1, mid_y-3, 1, 7, c_blue)
                           EndIf
                        EndIf
                     EndIf
                  EndIf
                  
                  ; 3. СБРОС КЛИПА (обратно в границы виджета)
                  Clip(*this)
               EndIf
            EndIf
         Next
         PopListPosition(*this\__columns( ))
         
         ; Горизонтальный разделитель
         Line(rx, dy + *row\height - 1, *this\Width, 1, #COLOR_LINE)
         
         ; --- ПРОВЕРКА ЗАВЕРШЕНИЯ ---
         If *row = *this\visible\last
            Break
         EndIf
      EndIf
   Until NextElement(*this\__items( )) = 0 
EndProcedure

Procedure draw_container(*this._s_WIDGET, rx.l, ry.l)
   Protected border_color.i = $D0D0D0
   Protected bg_color.i = $F9F9F9 ; Чуть светлее или темнее основного фона
   
   ; 1. Рисуем фон контейнера
   ; Если контейнер "активен" (например, выбран в редакторе), можно подсветить фон
   If *this\mask & #__mask_active
      bg_color = $F0F8FF ; Легкий голубой оттенок (AliceBlue)
      border_color = $3399FF
   EndIf
   
   ; Заливка
   Box(rx, ry, *this\Width, *this\Height, bg_color)
   
   ; 2. Рисуем рамку (тонкая линия в 1 пиксель)
   DrawingMode(#PB_2DDrawing_Outlined)
   Box(rx, ry, *this\Width, *this\Height, border_color)
   
   ; 3. Добавим "дизайнерскую" фишку: если у контейнера есть имя (class), 
   ; рисуем его маленьким шрифтом в углу или сверху (опционально)
   If *this\class <> ""
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(rx + 5, ry - 15, *this\class, $888888) ; Подпись над контейнером
   EndIf
   
   DrawingMode(#PB_2DDrawing_Default)
EndProcedure

Procedure Draw(*root._s_ROOT)
   Protected *r._s_ROOT = *root ; Сохраняем входную точку в локальную переменную
   Protected color.l
   
   If StartDrawing(CanvasOutput(*r\Canvas\gadget))
      ; 1. Фон всего холста
      Box(0, 0, OutputWidth( ), OutputHeight( ), *r\color) 
      
      ; Прыгаем в начало секции этого холста
      If StartEnum(*r)
         Protected *this._s_WIDGET = @widgets()
         If *this\tabindex = -1 : Continue : EndIf
         If *this\mask & #__mask_hidden : Continue : EndIf
         ;Debug ""+ *this\class +" "+ *r\last\class
         
         ; Считаем реальные координаты
         Protected rx = *this\real\x
         Protected ry = *this\real\y
         
         If GetActive( ) = *this
            color = $0000FF
         ElseIf Entered( ) = *this
            color = $00FF00 
         Else
            color = *this\color
         EndIf
         
         ; Расчет геометрии (если нужно)
         If *this\mask & #__mask_update
            If *this\tabbar
               update_tab(*this\tabbar)
            EndIf
            
            If *this\column
               update_columns(*this)
               If *this\row
                  update_rows(*this)
               EndIf
            EndIf
            
            *this\mask &~ #__mask_update
         EndIf
         
         ;
         If *this\mask & #__mask_edit
            Protected *start_r._s_ITEMS = *this\row\press
            Protected *end_r._s_ITEMS   = *this\row\active
            
            If *start_r And *end_r
               Protected min_y = *start_r\row\y
               Protected max_y = *end_r\row\y
               Protected is_down = Bool(max_y >= min_y)
               If Not is_down : Swap min_y, max_y : EndIf
               
               ForEach *this\__rows()
                  Protected *rw._s_rows = *this\__rows()
                  
                  ; 1. ПЕРВЫМ ДЕЛОМ проверяем, не одна ли это строка
                  If *rw = *start_r And *rw = *end_r
                     *rw\sel_start = Min(*this\text\caret[1], *this\text\caret[0])
                     *rw\sel_end   = Max(*this\text\caret[1], *this\text\caret[0])
                     
                     ; 2. ВТОРЫМ ДЕЛОМ — те, что вне диапазона
                  ElseIf *rw\y < min_y Or *rw\y > max_y
                     *rw\sel_start = 0 
                     *rw\sel_end = 0
                     
                     ; 3. ТРЕТЬИМ — те, что строго посередине
                  ElseIf *rw\y > min_y And *rw\y < max_y
                     *rw\sel_start = 0 
                     *rw\sel_end = Len(*rw\Str(0))
                     
                     ; 4. И в конце — границы (старт и конец)
                  ElseIf *rw = *start_r
                     ; Начальная строка
                     If is_down 
                        *rw\sel_start = *this\text\caret[1] 
                        *rw\sel_end = Len(*rw\Str(0))
                     Else       
                        *rw\sel_start = 0 
                        *rw\sel_end = *this\text\caret[1] 
                     EndIf
                  ElseIf *rw = *end_r
                     ; Конечная строка
                     If is_down 
                        *rw\sel_start = 0 
                        *rw\sel_end = *this\text\caret[0]
                     Else       
                        *rw\sel_start = *this\text\caret[0] 
                        *rw\sel_end = Len(*rw\Str(0)) 
                     EndIf
                  EndIf
               Next
            EndIf
            *this\mask &~ #__mask_edit
         EndIf
         
         ; Ограничиваем рисование областью виджета
         Clip(*this)
         
         If *this\Type = #__type_Panel
            draw_panel(*this, rx, ry)
         ElseIf *this\Type = #__type_Container
            draw_container(*this, rx, ry)
         ElseIf *this\Type = #__type_Button
            draw_button(*this, rx, ry)
         ElseIf *this\Type = #__type_TabBar
            draw_tab(*this, rx, ry)
         ElseIf *this\Type = #__type_AreaBar
            
         Else
            If *this\row\height
               ; --- СЛОИ ОТРИСОВКИ ---
               ; Слой 1: Фон и данные строк
               draw_rows(*this, rx, ry) 
            EndIf
            
            If *this\column\height
               ; Слой 2: Шапка и вертикальные линии сетки
               draw_columns(*this, rx, ry) 
            EndIf
            
            ; Слой 3: Внешняя рамка виджета (рисуем ПОВЕРХ всего)
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(rx, ry, *this\Width, *this\height , $CCCCCC) ; Цвет рамки
         EndIf
         
         UnClip( )
         
         ; Сбрасываем флаг перерисовки после завершения
         *this\mask &~ #__mask_redraw
         
         StopEnum()
      EndIf
      
      StopDrawing()
   EndIf
EndProcedure

Procedure ReDraw(*root._s_ROOT)
   If Not *root : ProcedureReturn : EndIf
   Protected *r._s_ROOT = *root ; Сохраняем входную точку в локальную переменную
   
   ; 1. Отматываем в самое начало (к первому/нижнему окну)
   While *r\PrevRoot( )
      *r = *r\PrevRoot( )
   Wend
   
   ; 2. Рисуем все элементы по порядку (снизу вверх)
   While *r
      ; Debug "Отрисовка холста: " + *r + " (Имя: " + widgets()\name + ")"
      Draw(*r)
      *r = *r\NextRoot( ) ; Переходим к следующему
   Wend
EndProcedure

;-
Procedure swap_column(*this._s_WIDGET, *pressed_column._s_HEADER, *hover_column._s_HEADER, mx.i)
   Protected._s_BAR *h = *this\scroll\h
   Protected mode
   
   ; Проверяем: есть ли что тащить, над чем висим, и что это разные колонки
   If *pressed_column And *hover_column And *hover_column <> *pressed_column
      ; 1. Находим экранный X левой границы колонки, над которой мышь
      ; Формула: X виджета + X колонки во внутреннем списке - Смещение скролла
      Protected col_left_x = *this\real\x + *hover_column\x - *h\pos
      
      ; 2. Находим середину этой колонки
      Protected col_middle_x = col_left_x + (*hover_column\width / 2)
      
      ; Узнаем позиции в списке, чтобы понять: цель ПРАВЕЕ или ЛЕВЕЕ зажатой
      PushListPosition(*this\__columns())
      ChangeCurrentElement(*this\__columns(), *hover_column)   : Protected hover_idx = ListIndex(*this\__columns())
      ChangeCurrentElement(*this\__columns(), *pressed_column) : Protected pressed_idx = ListIndex(*this\__columns())
      
      ; УСЛОВИЕ ПЕРЕСЕЧЕНИЯ СЕРЕДИНЫ:
      If hover_idx > pressed_idx And mx > col_middle_x
         ; Мы тянем ВПРАВО и пересекли середину правой колонки
         mode = #PB_List_After
      ElseIf hover_idx < pressed_idx And mx < col_middle_x
         ; Мы тянем ВЛЕВО и пересекли середину левой колонки
         mode = #PB_List_Before
      EndIf
      
      If mode
         MoveElement(*this\__columns(), mode, *hover_column)
         ; Обновляем логические координаты X в списке (чтобы колонки не "схлопнулись")
         *this\mask | #__mask_update 
      EndIf
      PopListPosition(*this\__columns())
      
      ; Мы всегда просим перерисовать, чтобы видеть движение зажатой колонки за мышью
      *this\mask | #__mask_redraw
   EndIf
EndProcedure

Procedure swap_row(*this._s_WIDGET, *pressed_row._s_rows, *hover_row._s_rows, my.i)
   Protected mode
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   
   ; Если есть что тащить, над чем висеть и это разные строки
   If *pressed_row And *hover_row And *hover_row <> *pressed_row
      
      ; 1. Находим экранный Y верхней границы строки, над которой мышь
      ; Формула: Y виджета + Y строки в списке - Смещение скролла
      Protected row_top_y = *this\real\y + *hover_row\y - *v\pos
      
      ; 2. Находим середину этой строки
      Protected row_middle_y = row_top_y + (*hover_row\height / 2)
      
      PushListPosition(*this\__rows( ))
      ChangeCurrentElement(*this\__rows(), *hover_row)   : Protected hover_idx = ListIndex(*this\__rows())
      ChangeCurrentElement(*this\__rows(), *pressed_row) : Protected pressed_idx = ListIndex(*this\__rows())
      
      ; УСЛОВИЕ ПЕРЕСЕЧЕНИЯ СЕРЕДИНЫ:
      If hover_idx > pressed_idx And my > row_middle_y
         ; Мы тянем ВПРАВО и пересекли середину правой колонки
         mode = #PB_List_After
      ElseIf hover_idx < pressed_idx And my < row_middle_y
         ; Мы тянем ВЛЕВО и пересекли середину левой колонки
         mode = #PB_List_Before
      EndIf
      
      If mode
         MoveElement(*this\__rows(), mode, *hover_row)
         ; Обновляем логические координаты X в списке (чтобы колонки не "схлопнулись")
         *this\mask | #__mask_update 
      EndIf
      PopListPosition(*this\__rows( ))
      
      ; 4. Обновляем координаты Y для всего списка (чтобы не было наложений)
      update_rows(*this)
      *this\mask | #__mask_redraw
   EndIf
EndProcedure

;-
Procedure.i GetLast(*this._s_WIDGET, tabindex.l = #PB_Default)
   Protected *current._s_WIDGET
   
   ; 0. ПРОВЕРКА НА ВАЛИДНОСТЬ (Защита от вылета)
   If Not *this : ProcedureReturn 0 : EndIf
   
   ; 1. БАЗОВЫЙ СЛУЧАЙ
   ; Если детей нет — виджет сам свой хвост
   If Not *this\last 
      ProcedureReturn *this 
   EndIf
   
   ; 2. ПОИСК ХВОСТА
   If tabindex = #PB_Default
      ; Рекурсивно ныряем в самого последнего ребенка всей ветки.
      ; Передаем #PB_Default, чтобы поиск шел только вглубь, а не по вкладкам.
      ProcedureReturn GetLast(*this\last, #PB_Default)
   Else
      ; Ищем последнего ребенка на указанной странице
      *current = *this\last
      While *current
         ; Нашли ребенка на нужной странице или системный виджет
         If *current\tabindex = tabindex Or is_integral_(*current)
            ; Ныряем в его абсолютный физический конец
            ProcedureReturn GetLast(*current, #PB_Default)
         EndIf
         *current = *current\prev
      Wend
      
      ; 3. ЛОГИКА "ЯКОРЯ" (Откат по вкладкам)
      Protected t.l = tabindex - 1
      While t >= 0
         ; Здесь ВАЖНО: вызываем GetLast для поиска хвоста конкретной вкладки 't'
         *current = GetLast(*this, t) 
         If *current <> *this 
            ProcedureReturn *current 
         EndIf
         t - 1
      Wend
   EndIf
   
   ; 4. ТУПИК: Если всё пусто — якорем становится сам родитель
   ProcedureReturn *this
EndProcedure

Procedure.i GetPosition( *this._s_PARENT, position.l, tabindex.l = #PB_Default )
   Protected *g._s_WIDGET
   
   If tabindex = #PB_Default
      Select position
         Case #PB_List_First    : ProcedureReturn *this\first
         Case #PB_List_Last     : ProcedureReturn *this\last
         Case #PB_List_Before   : ProcedureReturn *this\prev
         Case #PB_List_After    : ProcedureReturn *this\next
      EndSelect
   EndIf
   
   Select position
      Case #PB_List_Before
         ProcedureReturn *this\prev 
      Case #PB_List_After
         ProcedureReturn *this\next
      Case #PB_List_First
         *g = *this\first
         ; Пропускаем все предыдущие вкладки
         While *g And *g\tabindex < tabindex : *g = *g\next : Wend
      Case #PB_List_Last
         *g = *this\last
         ; Пропускаем все последующие вкладки (идем назад)
         While *g And *g\tabindex > tabindex : *g = *g\prev : Wend
   EndSelect
   
   ; ПРОВЕРКА: Если мы нашли элемент именно этой вкладки
   If *g And *g\tabindex = tabindex : ProcedureReturn *g : EndIf : ProcedureReturn 0 ; Если на вкладке пусто
EndProcedure

Procedure.i GetParent( *this._s_WIDGET )
   ProcedureReturn *this\parent
EndProcedure

Procedure.i SetPosition( *this._s_WIDGET, position.l, *target._s_WIDGET = #Null )
   Protected *parent._s_WIDGET = *this\parent
   Protected *anchor_el._s_WIDGET = #Null
   Protected move_mode.l = #PB_List_After
   
   If Not *this Or Not *parent : ProcedureReturn 0 : EndIf
   
   ; --- ШАГ 1: НАХОДИМ ЛОГИЧЕСКУЮ ЦЕЛЬ (КТО наш сосед) ---
   If *target = #Null
      *target = GetPosition( *this, position, *this\tabindex )
   EndIf
   
   ; Если цели нет или это мы сами — ничего не делаем
   If Not *target Or *target = *this : ProcedureReturn 0 : EndIf
   
   ; --- 1. Извлекаем (Detach) ---
   If *this\prev : *this\prev\next = *this\next : Else : *parent\first = *this\next : EndIf
   If *this\next : *this\next\prev = *this\prev : Else : *parent\last = *this\prev : EndIf
   
   ; --- ШАГ 2: НАХОДИМ ФИЗИЧЕСКУЮ ТОЧКУ (Только через GetLast) ---
   Select position
      Case #PB_List_First
         If *this\tabindex > 0
            ; Ищем хвост предыдущей вкладки
            *anchor_el = GetLast(*parent, *this\tabindex - 1)
            move_mode = #PB_List_After
         Else
            ; На первой вкладке якорем будет текущий первый ребенок
            *anchor_el = *parent\first
            move_mode = #PB_List_Before
         EndIf
         
      Case #PB_List_Last
         ; Чтобы стать последним на своей вкладке, встаем ПОСЛЕ её текущего хвоста
         ; GetLast вернет хвост последнего ребенка на этой вкладке
         *anchor_el = GetLast(*parent, *this\tabindex)
         move_mode  = #PB_List_After
         
      Case #PB_List_Before
         *anchor_el = *target
         move_mode  = #PB_List_Before
         
      Case #PB_List_After
         ; Встаем ПОСЛЕ "хвоста" целевого виджета
         *anchor_el = GetLast(*target, #PB_Default)
         move_mode  = #PB_List_After
   EndSelect
   
   If Not *anchor_el : ProcedureReturn 0 : EndIf
   Debug ""+*this\class +" "+ *target\class +" "+ *anchor_el\class
   
   ; --- ШАГ 3: ФИЗИЧЕСКИЙ ПЕРЕНОС БЛОКА (this + дети) ---
   Protected *last_el_in_block = GetLast(*this, #PB_Default)
   Protected NewList *items()
   
   PushListPosition(widgets())
   ; Собираем адреса всех элементов нашей ветки
   ChangeCurrentElement(widgets(), *this\address) 
   Repeat
      AddElement(*items())
      *items() = @widgets()
      If @widgets() = *last_el_in_block : Break : EndIf
   Until Not NextElement(widgets())
   
   ; Переносим элементы пачкой
   If *anchor_el\address
      ForEach *items()
         ChangeCurrentElement(widgets(), *items())
         MoveElement(widgets(), move_mode, *anchor_el\address)
         
         ; После переноса первого элемента (родителя), 
         ; остальные (дети) всегда ложатся строго ПОСЛЕ него
         *anchor_el = @widgets()
         move_mode  = #PB_List_After
      Next
   EndIf
   PopListPosition(widgets())
   
   ; --- ШАГ 4: ЛОГИЧЕСКАЯ ПЕРЕВЯЗКА (Связи \next \prev) ---
   Select position
      Case #PB_List_First
         ; Становимся самым первым
         *this\prev = #Null
         *this\next = *parent\first
         If *parent\first : *parent\first\prev = *this : EndIf
         *parent\first = *this
         If Not *parent\last : *parent\last = *this : EndIf
         
      Case #PB_List_Last
         ; Становимся самым последним
         *this\next = #Null
         *this\prev = *parent\last
         If *parent\last : *parent\last\next = *this : EndIf
         *parent\last = *this
         If Not *parent\first : *parent\first = *this : EndIf
         
      Case #PB_List_Before
         *this\next = *target
         *this\prev = *target\prev
         If *target\prev : *target\prev\next = *this : Else : *parent\first = *this : EndIf
         *target\prev = *this
         
      Case #PB_List_After
         *this\prev = *target
         *this\next = *target\next
         If *target\next : *target\next\prev = *this : Else : *parent\last = *this : EndIf
         *target\next = *this
   EndSelect
   
   *parent\mask | #__mask_redraw
   ProcedureReturn #True
EndProcedure

Procedure.i SetParent(*this._s_WIDGET, *parent._s_WIDGET, tabpage.l = #PB_Default)
   Protected *r._s_ROOT, *new._s_WIDGET, *insert_after._s_WIDGET
   
   ; --- 1. КОНТЕКСТ ---
   If *parent 
      *r = *parent\root 
      If Not *r
         *r = *parent
      EndIf
   Else 
      *r = Root() 
   EndIf
   If Not *r : ProcedureReturn 0 : EndIf
   
   ; Страница и AreaBar
   If tabpage = #PB_Default And *parent : tabpage = *parent\tabpage : EndIf
   If *parent And *parent\areabar : *parent = *parent\areabar : EndIf
   
   ; --- 2. ПОИСК ТОЧКИ ВСТАВКИ (ВЕЗДЕ GetLast) ---
   If *parent
      *insert_after = GetLast(*parent, tabpage)
   Else
      ; Если родитель - Root, ищем физический "хвост" всего холста
      *insert_after = GetLast(*r, #PB_Default)
   EndIf
   
   ; --- 3. ФИЗИЧЕСКИЙ ПЕРЕНОС / СОЗДАНИЕ ---
   PushListPosition(widgets())
   
   If *this And *this\address ; ПЕРЕНОС
                              ; Отвязка
      If *this\prev : *this\prev\next = *this\next : ElseIf *this\parent : *this\parent\first = *this\next : EndIf
      If *this\next : *this\next\prev = *this\prev : ElseIf *this\parent : *this\parent\last = *this\prev : EndIf
      
      ; Определяем конец перемещаемого блока (хвост виджета)
      Protected *last_el_in_block = GetLast(*this, #PB_Default)
      Protected NewList *items()
      ChangeCurrentElement(widgets(), *this\address) 
      Repeat
         AddElement(*items()) : *items() = @widgets()
         If @widgets() = *last_el_in_block : Break : EndIf
      Until Not NextElement(widgets())
      
      ; Физический адрес
      Protected *physical_addr = #Null
      Protected move_mode.l = #PB_List_After
      
      If *insert_after\address
         *physical_addr = *insert_after\address
      ElseIf *r\first And *r\first <> *this
         *physical_addr = *r\first\address
         move_mode = #PB_List_Before
      EndIf
      
      ForEach *items()
         ChangeCurrentElement(widgets(), *items())
         If *physical_addr
            MoveElement(widgets(), move_mode, *physical_addr)
            *physical_addr = @widgets()
            move_mode = #PB_List_After
         EndIf
      Next
      *new = *this
      
   Else ; СОЗДАНИЕ
      If *insert_after\address
         ChangeCurrentElement(widgets(), *insert_after\address)
         *new = AddElement(widgets())
      Else
         LastElement(widgets())
         *new = AddElement(widgets())
      EndIf
      CopyStructure(*this, *new, _s_WIDGET)
      *new\address = *new
   EndIf
   PopListPosition(widgets())
   
   ; --- 4. ЛОГИЧЕСКИЕ СВЯЗИ ---
   *new\parent = *parent
   *new\root   = *r
   *new\next   = #Null
   
   If *parent
      *parent\haschildren = 1
      If *parent\last
         *new\prev = *parent\last
         *new\prev\next = *new
      Else
         *new\prev = #Null
         *parent\first = *new
      EndIf
      *parent\last = *new
   Else
      *new\prev = #Null
   EndIf
   
   ; --- 5. ФИНАЛИЗАЦИЯ ---
   If Not *r\first : *r\first = *new : EndIf
   If Not is_integral_(*new) : *new\tabindex = tabpage : EndIf
   
   If *parent : update_level(*new, *parent\Level + 1) : Else : update_level(*new, 0) : EndIf
   
   hidden(*new, *parent, 0)
   If *parent : *parent\mask | #__mask_redraw : EndIf
   
   ProcedureReturn *new
EndProcedure

;-
Procedure OpenList(*this._s_WIDGET, tabpage.i = 0)
   ; Если у виджета есть выделенная область контента — открываем её
   If *this\areabar
      Opened( ) = *this\areabar
   Else
      Opened( ) = *this
   EndIf
   Opened()\tabpage = tabpage
EndProcedure

Procedure CloseList()
   If Opened( ) 
      If Opened( )\parent
         If Opened( ) = Opened( )\parent\areabar
            Opened( ) = Opened( )\parent
         EndIf
      EndIf
      Opened( ) = Opened( )\parent 
   EndIf
EndProcedure

Procedure Hide(*this._s_WIDGET, state.b)
   Protected *g._s_WIDGET 
   
   If Not *this : ProcedureReturn : EndIf
   
   ; 1. УСТАНОВКА СОСТОЯНИЯ РОДИТЕЛЯ
   If state
      *this\mask | #__mask_hidden
   Else
      hidden(*this, *this\parent, *this\tabindex)
   EndIf
   
   ; 2. РЕКУРСИЯ ПО ВСЕМ БЕЗ ИСКЛЮЧЕНИЯ ДЕТЯМ
   ; Мы вызываем макрос hidden для КАЖДОГО ребенка (и для кнопок, и для TabBar)
   Start(*g, *this)
   ; Макрос сам решит: 
   ; - Если родитель (*this) скрыт -> ребенок скроется 100%
   ; - Если родитель виден -> макрос проверит tabindex ребенка
   hidden(*g, *this, *g\tabindex)
   
   ; Проваливаемся глубже к внукам
   Hide(*g, Bool(*g\mask & #__mask_hidden))
   Stop(*g, *this)
   
   *this\mask | #__mask_redraw
EndProcedure

Procedure SetTab(*this._s_WIDGET, tabpage.l)
   Protected *g._s_WIDGET ; Локальный указатель для этого уровня рекурсии
   If Not *this : ProcedureReturn : EndIf
   If *this\tabbar : *this\tabpage = tabpage : EndIf
   
   *this\mask | #__mask_redraw
   
   Start(*g, *this)
   ; 1. Логика видимости
   hidden(*g, *this, *g\tabindex) 
   
   ; 2. Рекурсия (каждый вызов создаст свой *g на стеке)
   If *g = *this\areabar
      SetTab(*g, tabpage) 
   ElseIf *g\tabbar
      SetTab(*g, *g\tabpage)
   EndIf
   Stop(*g, *this)
EndProcedure

;-
Procedure add_column(*this._s_WIDGET, Title.s, Width.i)
   If Not *this : ProcedureReturn : EndIf
   *this\column\height = 25
   
   AddElement(*this\__columns( ))
   *this\__columns( )\Title = Title
   *this\__columns( )\width     = Width
   ; Мы не ставим x здесь, его поставит update_columns( ) перед отрисовкой
   
   ; Запоминаем текущий порядковый номер (0 для первой, 1 для второй и т.д.)
   *this\__columns( )\id = ListSize(*this\__columns( )) - 1 
   
   ; ГЛАВНОЕ: поднимаем флаги, чтобы redraw понял, что нужно пересчитать геометрию
   *this\mask | #__mask_update | #__mask_redraw
EndProcedure

Procedure add_row(*this._s_WIDGET, Text.s = "", Index.i = -1, Level.i = 0, *start = 0, len.i = -1)
   If Not *this : ProcedureReturn : EndIf
   
   ; --- 1. Позиционирование (как мы обсуждали ранее) ---
   If Index < 0 Or Index > ListSize(*this\__rows()) - 1
      LastElement(*this\__rows())
      AddElement(*this\__rows())
   Else
      SelectElement(*this\__rows(), Index)
      InsertElement(*this\__rows())
   EndIf
   
   *this\__rows()\Level = Level
   Protected i, TotalCols = ListSize(*this\__columns()) - 1
   ReDim *this\__rows()\Str(TotalCols)
   
   ; --- 2. Быстрый разбор ---
   ; Если передали указатель - берем его, иначе адрес строки Text
   If Not *start : *start = @Text : EndIf
   
   Protected *ptr.Character = *start
   Protected *colStart = *start
   Protected count.i = 0
   
   ; Если длина не указана - ищем конец строки (0 или LF)
   While i <= TotalCols
      ; Условие остановки: либо дошли до конца переданной длины, либо до спецсимвола
      If (len <> -1 And (*ptr - *start) >> 1 >= len) Or *ptr\c = 0 Or *ptr\c = 10
         *this\__rows()\Str(i) = PeekS(*colStart, (*ptr - *colStart) >> 1)
         Break
      EndIf
      
      ; Разбор колонок через '|'
      If *ptr\c = '|' 
         *this\__rows()\Str(i) = PeekS(*colStart, (*ptr - *colStart) >> 1)
         *colStart = *ptr + SizeOf(Character)
         i + 1
      EndIf
      
      *ptr + SizeOf(Character)
   Wend
   
   *this\mask | #__mask_update | #__mask_redraw
EndProcedure

Procedure add_tab(*this._s_WIDGET, Text.s)
   If Not *this : ProcedureReturn : EndIf
   
   ; 1. Добавляем элемент в список вкладок Таббара
   AddElement(*this\__tabs())
   *this\__tabs()\title = Text
   
   ; 2. Обновляем индекс в самом виджете (он главный "дирижер")
   *this\__tabs()\id = ListSize(*this\__tabs()) - 1
   If *this\__tabs()\id = 0
      *this\__tabs()\mask | #__mask_active
      *this\tab\active = @*this\__tabs()
   EndIf
   
   ; 3. Обновляем ширины текста и перерисовываем
   If is_integral_(*this)
      If *this\parent
         *this\parent\tabpage = *this\__tabs()\id
         *this\parent\mask | #__mask_update | #__mask_redraw
      EndIf
   Else
      *this\mask | #__mask_update | #__mask_redraw
   EndIf
EndProcedure

Procedure   AddItem( *this._s_WIDGET, Item.l, Text.s, img.i = - 1, Flag.q = 0 )
   If *this\type = #__type_Panel Or 
      *this\type = #__type_TabBar
      ProcedureReturn add_tab(*this\tabbar, Text)
   EndIf
   If *this\type = #__type_Tree Or
      *this\type = #__type_ListIcon Or
      *this\type = #__type_Editor
      ProcedureReturn add_row(*this, Text, Item, Flag)
   EndIf
EndProcedure

Procedure SetText(*this._s_WIDGET, Text.s)
   If Not *this : ProcedureReturn : EndIf
   Protected *start, *ptr.Character = @Text
   ClearList(*this\__rows())
   
   If *ptr
      *start = *ptr
      
      ;
      While #True
         If *ptr\c = 10 Or *ptr\c = 0
            ; Передаем только адрес начала и количество символов
            add_row(*this, "", -1, 0, *start, (*ptr - *start) >> 1)
            ;
            ;             AddElement(*this\__rows())
            ;             ReDim *this\__rows()\Str(TotalCols)
            ;             *this\__rows()\Str(0) = PeekS(*start, (*ptr - *start) >> 1)

            If *ptr\c = 0 : Break : EndIf
            *start = *ptr + SizeOf(Character)
         EndIf
         *ptr + SizeOf(Character)
      Wend
      
      ;       ; Цикл работает, пока символ не равен 0 (конец строки)
;       While *ptr\c 
;          If *ptr\c = 10 ; Нашли LF
;             AddElement(*this\__rows())
;             ReDim *this\__rows()\Str(TotalCols)
;             *this\__rows()\Str(0) = PeekS(*start, (*ptr - *start) >> 1)
;             
;             *ptr + SizeOf(Character)
;             *start = *ptr
;          Else
;             *ptr + SizeOf(Character)
;          EndIf
;       Wend
;       
;       ; Добавляем последний хвост, который остался после последнего LF 
;       ; (или если текст вообще без LF)
;       AddElement(*this\__rows())
;       ReDim *this\__rows()\Str(TotalCols)
;       *this\__rows()\Str(0) = PeekS(*start)
   EndIf

   ; Сбрасываем старое состояние
   *this\row\active = 0
   *this\row\press = 0
   
   ; Даем команду на пересчет координат и перерисовку
   *this\mask | #__mask_update | #__mask_redraw
EndProcedure


;-
; Скрыть/Показать вкладку
Procedure hide_tab(*this._s_WIDGET, Index.l, state.b = #True)
   If Not *this Or *this\Type <> #__type_Panel : ProcedureReturn : EndIf
   
   PushListPosition(*this\__tabs())
   If SelectElement(*this\__tabs(), Index)
      If state
         *this\__tabs()\mask | #__mask_hidden
         ; Если скрыли активную — прыгаем на первую попавшуюся видимую
         If *this\tabpage = Index : SetTab(*this, 0) : EndIf
      Else
         *this\__tabs()\mask & ~#__mask_hidden
      EndIf
      ; Помечаем, что геометрия шапки изменилась (нужен пересчет X табов)
      *this\mask | #__mask_update | #__mask_redraw
   EndIf
   PopListPosition(*this\__tabs())
EndProcedure

; Заблокировать/Разблокировать вкладку
Procedure disable_tab(*this._s_WIDGET, Index.l, state.b = #True)
   If Not *this Or *this\Type <> #__type_Panel : ProcedureReturn : EndIf
   
   PushListPosition(*this\__tabs())
   If SelectElement(*this\__tabs(), Index)
      If state
         *this\__tabs()\mask | #__mask_disabled
         *this\__tabs()\mask & ~#__mask_hover ; Сразу гасим ховер, если он был
      Else
         *this\__tabs()\mask & ~#__mask_disabled
      EndIf
      *this\mask | #__mask_redraw
   EndIf
   PopListPosition(*this\__tabs())
EndProcedure

;-
Procedure.i hover_tab(*this._s_WIDGET, mx.l, my.l)
   If Not *this Or *this\Type <> #__type_TabBar : ProcedureReturn 0 : EndIf
   
   Protected rx = *this\real\x
   Protected ry = *this\real\y
   ; 1. СТАРТОВАЯ ТОЧКА должна быть такой же, как в DRAW_TAB
   Protected tx = rx + GetTabStartX(*this) - *this\scroll\x
   Protected *found_tab = 0 
   
   ; Проверка попадания в сам прямоугольник Таббара
   If mx >= rx And mx <= rx + *this\Width And my >= ry And my <= ry + *this\Height
      PushListPosition(*this\__tabs())
      ForEach *this\__tabs()
         If *this\__tabs()\mask & #__mask_hidden : Continue : EndIf
         
         ; Проверяем конкретную вкладку
         If mx >= tx And mx <= tx + *this\__tabs()\width
            If Not (*this\__tabs()\mask & #__mask_disabled)
               *found_tab = @*this\__tabs()
            EndIf
            Break 
         EndIf
         
         ; Сдвигаем tx точно так же, как при отрисовке
         tx + *this\__tabs()\width + *this\tab\spacing 
      Next
      PopListPosition(*this\__tabs())
   EndIf
   
   ProcedureReturn *found_tab 
EndProcedure

Procedure.i hover_column(*this._s_WIDGET, mx.i, my.i, *is_edge.Byte)
   Protected *res
   Protected dx = *this\real\x
   Protected dy = *this\real\y
   *is_edge\b = #False
   
   ; Проверяем только в области шапки
   If my >= dy And my < dy + *this\column\height
      PushListPosition(*this\__columns( ))
      ForEach *this\__columns( )
         Protected col_edge = dx + *this\__columns( )\x + *this\__columns( )\Width
         ; Проверка на край (для ресайза)
         If Abs(mx - col_edge) < 5
            *is_edge\b = #True
            *res = @*this\__columns( )
            Break
         EndIf
         ; Проверка на тело колонки
         If mx >= (dx + *this\__columns( )\x) And mx < col_edge
            *res = @*this\__columns( )
            Break
         EndIf
      Next
      PopListPosition(*this\__columns( ))
   EndIf
   ProcedureReturn *res
EndProcedure

Procedure.i hover_row(*this._s_WIDGET, my.i)
   Protected *res = 0
   ; Переводим экранный Y во внутренний Y (с учетом скролла и шапки)
   Protected my_rel = my - (*this\real\y + *this\column\height) + *this\scroll\v\pos
   
   If ListSize(*this\__items()) > 0
      PushListPosition(*this\__items())
      ForEach *this\__items()
         ; Ищем, в какой виртуальный Y попала мышь
         If my_rel >= *this\__items()\row\y - *this\column\height And 
            my_rel < *this\__items()\row\y - *this\column\height + *this\__items()\row\Height 
            
            *res = @*this\__items() ; Возвращаем адрес элемента в рулоне
            Break
         EndIf
      Next
      PopListPosition(*this\__items())
   EndIf
   ProcedureReturn *res
EndProcedure

Procedure.i hover_widget(*root._s_ROOT, mx, my)
   Protected *result._s_WIDGET = *root ; По умолчанию под мышью сам холст
   
   PushListPosition(widgets())
   LastElement(widgets()) ; Идем с конца (верхние слои первыми)
   
   Repeat  
      If widgets()\root = *root And Not (widgets()\mask & #__mask_hidden)
         
         ; Используем расчет реальных координат (с учетом вложенности)
         Protected rx = widgets()\real\x
         Protected ry = widgets()\real\y
         
         If mx >= rx And mx <= rx + widgets()\Width And 
            my >= ry And my <= ry + widgets()\Height
            
            *result = @widgets() ; Нашли самый верхний видимый виджет
            Break                ; Нашли — выходим из цикла
         EndIf
      EndIf
   Until Not PreviousElement(widgets())
   
   PopListPosition(widgets())
   ProcedureReturn *result
EndProcedure

;-
Procedure tab_events(*this._s_WIDGET, event)
   Static *hover_tab._s_HEADER
   Static *pressed_tab._s_HEADER
   
   Select event
      Case #PB_EventType_MouseLeave
         ; Если мышь совсем ушла с виджета
         If *hover_tab
            *this\mask | #__mask_redraw
            *hover_tab\mask &~ #__mask_hover
            *hover_tab = 0
         EndIf
         
      Case #PB_EventType_MouseMove
         Protected._s_HEADER *tab = hover_tab(*this, mouse( )\x, mouse( )\y)
         If *hover_tab <> *tab
            ; 1. Уходим со старой вкладки
            If *hover_tab
               *hover_tab\mask & ~#__mask_hover
            EndIf
            ; 2. Заходим на новую
            If *tab
               *tab\mask | #__mask_hover
            EndIf
            *this\mask | #__mask_redraw
            ; 3. Запоминаем текущий для следующего раза
            *hover_tab = *tab
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         If *pressed_tab
            *pressed_tab\mask &~ #__mask_press
            *pressed_tab = 0
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If *hover_tab
            *pressed_tab = *hover_tab
            *hover_tab\mask & #__mask_press
            *this\tab\active = *hover_tab
            
            ; set active tab
            If Not *hover_tab\mask & #__mask_active
               PushListPosition(*this\__tabs( ))
               ForEach *this\__tabs( )
                  If *this\__tabs( )\mask & #__mask_active
                     *this\__tabs( )\mask &~ #__mask_active
                  EndIf
               Next
               PopListPosition(*this\__tabs( ))
               *hover_tab\mask | #__mask_active
            EndIf
            
            PushListPosition(*this\__tabs())
            ChangeCurrentElement(*this\__tabs(), *hover_tab)
            Protected new_index = ListIndex(*this\__tabs())
            PopListPosition(*this\__tabs())
            
            Debug "КЛИК ПО ТАБУ: " + Str(new_index) + " НА ПАНЕЛИ: " + *this\parent\class
            
            ; ВЫЗЫВАЕМ ПЕРЕКЛЮЧЕНИЕ У ПАНЕЛИ
            SetTab(*this\parent, new_index) 
         EndIf
         
   EndSelect
EndProcedure

Procedure column_events(*this._s_WIDGET, event)
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   
   Static is_edge.b = #False
   Static *hover_column._s_HEADER
   Static *pressed_column._s_HEADER
   
   Select event
      Case #PB_EventType_MouseLeave
         If *hover_column
            *this\mask | #__mask_redraw
            *hover_column\mask &~ #__mask_hover
            *hover_column = 0
         EndIf
         
      Case #PB_EventType_MouseMove
         Protected._s_HEADER *column = hover_column(*this, mouse( )\x, mouse( )\y, @is_edge)
         If *hover_column <> *column
            If *hover_column
               *hover_column\mask &~ #__mask_hover
            EndIf
            If *column
               *column\mask | #__mask_hover
            EndIf
            *this\mask | #__mask_redraw
            *hover_column = *column
         EndIf
         
         If Not *this\mask & #__mask_edit
            ; --- КУРСОР ---
            If (is_edge And Not *this\mask & #__mask_drag ) Or (*pressed_column And *pressed_column\mask & #__mask_resize)
               SetGadgetAttribute(*this\root\Canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
            Else
               SetGadgetAttribute(*this\root\Canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
            EndIf
            
            ; --- ДЕЙСТВИЯ ---
            If *this\mask & #__mask_active
               If *pressed_column
                  If *pressed_column\mask & #__mask_resize ; Режим Resize
                     resize_column(*this, *pressed_column, mouse( )\x - (*this\real\x + *pressed_column\x - *h\pos))
                  Else ; Режим Swap
                     swap_column(*this, *pressed_column, *hover_column, mouse( )\x)
                  EndIf
               EndIf
            EndIf
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         If *pressed_column
            *pressed_column\mask &~ #__mask_press
            *pressed_column\mask &~ #__mask_resize
            *pressed_column = 0
         EndIf
         is_edge.b = #False
         
      Case #PB_EventType_LeftButtonDown
         If *hover_column
            *pressed_column = *hover_column
            *hover_column\mask | #__mask_press
            *this\column\active = *hover_column
            
            ;
            If Not *pressed_column\mask & #__mask_active
               PushListPosition(*this\__columns( ))
               ForEach *this\__columns( )
                  If *this\__columns( )\mask & #__mask_active
                     *this\__columns( )\mask &~ #__mask_active
                  EndIf
               Next
               PopListPosition(*this\__columns( ))
               *hover_column\mask | #__mask_active
            EndIf
            
            If is_edge
               ; А. Попали в КРАЙ — включаем Resize
               *hover_column\mask | #__mask_resize
               mouse( )\press\x = mouse( )\x ; Фиксируем точку старта для дельты
            EndIf
         EndIf
         
   EndSelect
   
EndProcedure

Procedure row_events(*this._s_WIDGET,  event)
   Static *hover_row._s_ITEMS
   Static *pressed_row._s_ITEMS
   
   Select event
      Case #PB_EventType_MouseLeave
         If *hover_row
            *this\mask | #__mask_redraw
            *hover_row\row\mask &~ #__mask_hover
            *hover_row = 0
         EndIf
         
      Case #PB_EventType_MouseMove
         Protected._s_ITEMS *row = hover_row(*this, mouse( )\y)
         If *hover_row <> *row
            If *hover_row
               *hover_row\row\mask &~ #__mask_hover
            EndIf
            If *row
               *row\row\mask | #__mask_hover
               
               ; Если мышь зажата и у начальной строки ЕСТЬ флаг редактирования
               If *pressed_row And 
                  *pressed_row\row\mask & #__mask_edit
                  
                  ; 1. Определяем границы диапазона по Y
                  Protected max_y = *row\row\y
                  Protected min_y = *pressed_row\row\y
                  If min_y > max_y : Swap min_y, max_y : EndIf
                  
                  ; 2. Пересчитываем маски для всех ВИДИМЫХ строк
                  PushListPosition(*this\__items())
                  ForEach *this\__items()
                     Protected *current_row._s_ITEMS = *this\__items()
                     
                     If *current_row <> *pressed_row
                        If *current_row\row\y >= min_y And 
                           *current_row\row\y <= max_y
                           ; Если строка в физическом диапазоне между кликом и курсором
                           *current_row\row\mask | #__mask_edit
                        Else
                           ; Снимаем выделение, если строка вышла из диапазона
                           *current_row\row\mask &~ #__mask_edit
                        EndIf
                     EndIf
                  Next
                  PopListPosition(*this\__items())
                  
                  ; 3. Синхронизируем активную строку
                  If *this\row\active <> *row
                     If *this\row\active 
                        *this\row\active\mask &~ #__mask_active 
                     EndIf
                     *row\row\mask | #__mask_active
                     *this\row\active = *row
                  EndIf
                  ;
                  *this\mask | #__mask_edit
               EndIf
               
               *this\mask | #__mask_redraw
               *hover_row = *row
            EndIf
         EndIf
         
         If *pressed_row
            If *pressed_row\row\mask & #__mask_edit
               If *this\mask & #__mask_drag
                  Protected caret = caret(*this)
                  If *this\text\caret[0] <> caret 
                     *this\text\caret[0] = caret 
                     *this\mask | (#__mask_edit | #__mask_redraw)
                  EndIf
               EndIf
            Else
               If *this\mask & #__mask_active
                  swap_row(*this, *pressed_row, *hover_row, mouse( )\y)
               EndIf
            EndIf
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         If *pressed_row
            *pressed_row\row\mask &~ #__mask_press
            *pressed_row = 0
            *this\row\press = 0
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If *hover_row
            *hover_row\row\mask | #__mask_press
            
            *pressed_row = *hover_row 
            *this\row\active = *hover_row
            *this\row\press = *hover_row 
            
            *this\text\caret[0] = caret( *this )
            *this\text\caret[1] = *this\text\caret[0]
            
            ;
            If Not *hover_row\row\mask & #__mask_active
               PushListPosition(*this\__rows( ))
               ForEach *this\__rows( )
                  If *this\__rows( )\mask & #__mask_active
                     *this\__rows( )\mask &~ #__mask_active
                  EndIf
                  If *this\__rows( )\mask & #__mask_edit
                     *this\__rows( )\mask &~ #__mask_edit
                  EndIf
               Next
               PopListPosition(*this\__rows( ))
               *hover_row\row\mask | #__mask_active
            EndIf
            
            If *this\Type = #__type_Editor
               *hover_row\row\mask | #__mask_edit
               *this\mask | #__mask_edit
            EndIf
            
            ; 4. Если это папка (узел) — переключаем схлопывание
            If *hover_row\row\mask & #__mask_node
               *hover_row\row\mask ! #__mask_collapsed
               ; Если ветка закрылась/открылась — пересобираем рулон
               *this\mask | #__mask_update 
            EndIf
            
            *this\mask | #__mask_redraw
         EndIf
         
   EndSelect
EndProcedure

Procedure key_events(*this._s_WIDGET, event.i)
   If Not *this : ProcedureReturn : EndIf
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   
   ; Нам нужно знать, какая строка сейчас активна (фокус)
   Protected *current_row._s_rows = 0
   ForEach *this\__rows( )
      If *this\__rows( )\mask & #__mask_active
         *current_row = @*this\__rows( )
         Break
      EndIf
   Next
   
   Select event
      Case #PB_EventType_Input
         If *this\Type = #__type_Editor And (*this\mask & #__mask_active)
            ; Получаем символ, который ввел пользователь
            Protected char = GetGadgetAttribute(*this\root\Canvas\gadget, #PB_Canvas_Input)
            
            If char 
               ; Ищем активную строку (или создаем новую, если список пуст)
               ForEach *this\__rows( )
                  If *this\__rows( )\mask & #__mask_active
                     ; Добавляем символ в массив ячейки
                     *this\__rows( )\Str(0) + Chr(char)
                     *this\mask | #__mask_redraw
                     Break
                  EndIf
               Next
            EndIf
         EndIf
         
      Case #PB_Shortcut_Back
         If *this\Type = #__type_Editor
            ForEach *this\__rows( )
               If *this\__rows( )\mask & #__mask_active
                  Protected current_text.s = *this\__rows( )\Str(0)
                  If Len(current_text) > 0
                     ; Удаляем последний символ
                     *this\__rows( )\Str(0) = Left(current_text, Len(current_text) - 1)
                     *this\mask | #__mask_redraw
                  EndIf
                  Break
               EndIf
            Next
         EndIf
         
      Case #PB_Shortcut_Up
         If *current_row
            PushListPosition(*this\__rows( ))
            ChangeCurrentElement(*this\__rows( ), *current_row)
            If PreviousElement(*this\__rows( ))
               ; Снимаем старое выделение (если не зажат Shift)
               If Not (mouse( )\mask & #__mask_shift)
                  ForEach *this\__rows( ) : *this\__rows( )\mask &~ #__mask_active : Next
               EndIf
               
               *this\__rows( )\mask | #__mask_active
               ; Проверяем, не ушла ли строка за верхнюю границу (автоскролл)
               If *this\__rows( )\y < *v\pos + *this\column\height
                  *v\pos = *this\__rows( )\y - *this\column\height
               EndIf
            EndIf
            PopListPosition(*this\__rows( ))
         EndIf
         
      Case #PB_Shortcut_Down
         If *current_row
            PushListPosition(*this\__rows( ))
            ChangeCurrentElement(*this\__rows( ), *current_row)
            If NextElement(*this\__rows( ))
               If Not (mouse( )\mask & #__mask_shift)
                  ForEach *this\__rows( ) : *this\__rows( )\mask &~ #__mask_active : Next
               EndIf
               
               *this\__rows( )\mask | #__mask_active
               ; Автоскролл вниз
               If *this\__rows( )\y + *this\__rows( )\height > *v\pos + *this\height 
                  *v\pos = (*this\__rows( )\y + *this\__rows( )\Height ) - *this\height 
                  
                  ; ВАЖНО: Раз скролл изменился, пересчитываем видимые строки!
                  update_visible_rows(*this) 
               EndIf
            EndIf
            PopListPosition(*this\__rows( ))
         EndIf
         
      Case #PB_Shortcut_Delete
         If *current_row
            ChangeCurrentElement(*this\__rows( ), *current_row)
            DeleteElement(*this\__rows( ))
            *this\mask | #__mask_update ; Пересчитываем Y для всех строк ниже
         EndIf
         
      Case #PB_Shortcut_A
         ; Если зажат Ctrl (маска из твоей структуры)
         If mouse( )\mask & #__mask_ctrl
            ForEach *this\__rows( )
               *this\__rows( )\mask | #__mask_active
            Next
         EndIf
   EndSelect
   
   *this\mask | #__mask_redraw
EndProcedure

Procedure do_events(*this._s_WIDGET, event)
   Select event
      Case #PB_EventType_MouseEnter
         
   EndSelect
   
   If *this\column
      If *this\column\height
         column_events(*this, event)
      EndIf
      If *this\row
         If *this\row\height
            row_events(*this, event)
         EndIf
      EndIf
   EndIf
   If *this\Type = #__type_TabBar
      tab_events(*this,  event)
   EndIf
EndProcedure

Procedure canvas_events( )
   Protected Gadget = EventGadget( )
   Protected eventtype = EventType( )
   Protected *this._s_WIDGET
   
   If eventtype = #PB_EventType_MouseEnter      ; The mouse cursor Entered the gadget
      Root( ) = GetOsData(GadgetID(Gadget))
   EndIf
   If eventtype = #PB_EventType_MouseLeave      ; The mouse cursor left the gadget
   EndIf
   If eventtype = #PB_EventType_MouseMove       ; The mouse cursor moved
   EndIf
   If eventtype = #PB_EventType_MouseWheel      ; The mouse wheel was moved
   EndIf
   If eventtype = #PB_EventType_LeftButtonDown  ; The left mouse Button was Pressed
   EndIf
   If eventtype = #PB_EventType_LeftButtonUp    ; The left mouse Button was released
   EndIf
   If eventtype = #PB_EventType_LeftClick       ; A click With the left mouse Button
   EndIf
   If eventtype = #PB_EventType_LeftDoubleClick ; A double-click With the left mouse Button
   EndIf
   If eventtype = #PB_EventType_RightButtonDown ; The right mouse Button was Pressed
   EndIf
   If eventtype = #PB_EventType_RightButtonUp   ; The right mouse Button was released
   EndIf
   If eventtype = #PB_EventType_RightClick      ; A click With the right mouse Button
   EndIf
   If eventtype = #PB_EventType_RightDoubleClick; A double-click With the right mouse Button
   EndIf
   If eventtype = #PB_EventType_MiddleButtonDown; The middle mouse Button was Pressed
   EndIf
   If eventtype = #PB_EventType_MiddleButtonUp  ; The middle mouse Button was released
   EndIf
   If eventtype = #PB_EventType_Focus           ; The gadget gained keyboard focus
   EndIf
   If eventtype = #PB_EventType_LostFocus       ; The gadget lost keyboard focus
   EndIf
   If eventtype = #PB_EventType_KeyDown Or       ; A key was Pressed
      eventtype = #PB_EventType_KeyUp  Or        ; A key was released
      eventtype = #PB_EventType_Input            ; Text input was generated
      If GetActive()
         key_events( GetActive(), eventtype )
      EndIf
   EndIf
   If eventtype = #PB_EventType_Resize          ; The gadget has been resized
   EndIf
   
   If Gadget = Root( )\Canvas\gadget
      ; Обновляем мышь в корне
      mouse( )\x = GetGadgetAttribute(Root( )\Canvas\gadget, #PB_Canvas_MouseX)
      mouse( )\y = GetGadgetAttribute(Root( )\Canvas\gadget, #PB_Canvas_MouseY)
      
      If eventtype = #PB_EventType_MouseLeave
         Entered( ) = 0
      Else
         ; Если мышь над виджетом — передаем событие
         Entered( ) = hover_widget( Root( ), mouse( )\x, mouse( )\y )
      EndIf
      
      ; --- Логика Enter / Leave ---
      If Leaved( ) <> Entered( )
         If Leaved( )
            Leaved( )\mask &~ #__mask_hover
            do_events(Leaved( ), #PB_EventType_MouseLeave)
            If Leaved( )\mask & #__mask_redraw
               Draw(Leaved( )\root) ; Перерисовываем для отображения рамок
            EndIf
         EndIf
         
         If Entered( )
            Entered( )\mask | #__mask_hover
            do_events(Entered( ), #PB_EventType_MouseEnter)
         EndIf
         
         Leaved( ) = Entered( )
      EndIf
      
      If Entered( ) 
         If eventtype <> #PB_EventType_MouseEnter And 
            eventtype <> #PB_EventType_DragStart And 
            eventtype <> #PB_EventType_MouseLeave
            
            If eventtype = #PB_EventType_MouseWheel
               Protected delta = GetGadgetAttribute(Entered( )\root\Canvas\gadget, #PB_Canvas_WheelDelta)
               Protected._s_BAR *v = Entered( )\scroll\v
               Protected._s_BAR *h = Entered( )\scroll\h
               
               ; Если зажат Shift крутим по горизонтали
               If mouse( )\mask & #__mask_shift
                  *h\pos - (delta * 30)
                  If *h\pos < 0 : *h\pos = 0 : EndIf
                  If *h\pos > *h\max : *h\pos = *h\max : EndIf
               Else
                  ; Обычный вертикальный скролл
                  *v\pos - (delta * 30)
                  If *v\pos < 0 : *v\pos = 0 : EndIf
                  If *v\pos > *v\max : *v\pos = *v\max : EndIf
                  Entered( )\mask | #__mask_update
               EndIf
               
               Entered( )\mask | #__mask_redraw
            EndIf
            
            If eventtype = #PB_EventType_LeftButtonDown
               Pressed( ) = Entered( )
               Pressed( )\mask | #__mask_press
               If GetActive( ) <> Pressed( )
                  SetActive(Pressed( ))
               EndIf
            EndIf
            
            If eventtype = #PB_EventType_MouseMove
               If Pressed( )
                  If Pressed( )\mask & #__mask_press
                     If Not Pressed( )\mask & #__mask_drag
                        Pressed( )\mask | #__mask_drag
                        Debug "real drag"
                        do_events(Pressed( ), #PB_EventType_DragStart)
                     EndIf
                     ;
                     do_events(Pressed( ), eventtype)
                  EndIf
               EndIf
            EndIf
            
            If Entered( )\root
               do_events(Entered( ), eventtype)
            EndIf
            
            If eventtype = #PB_EventType_LeftButtonUp
               If Pressed( )
                  Pressed( )\mask &~ #__mask_press
                  Pressed( )\mask &~ #__mask_drag
                  Pressed( ) = 0
               EndIf
            EndIf
         EndIf
         
         If Entered( )\mask & #__mask_redraw
            ReDraw(Entered( )\root)
         EndIf
      EndIf
   EndIf
EndProcedure
;-
Procedure.i Create(*parent._s_WIDGET, class.s, Type.i, X, Y, Width, Height, title.s, flags.q=0, param1=0,param2=0,param3=0)
   Protected this._s_WIDGET
   Protected *new._s_WIDGET 
   
   ; 1. Подготовка данных
   If Not *parent : *parent = Opened() : EndIf
   this\Type = Type
   this\class = class
   
   
   If flags & #__flag_integral
      this\tabindex = - 1 ; Помечаем как "всегда видимый"
   EndIf
   If Type = #__type_Tree Or
      Type = #__type_ListIcon Or
      Type = #__type_Editor
      this\column._s_COLUMN = AllocateStructure(_s_COLUMN)
      this\row._s_ROW = AllocateStructure(_s_ROW)
      this\row\height = 25
      this\row\indent = 20 ; (отступ веток)
      this\row\padding\y = 5
   EndIf
   
   ; --- В конструкторе или блоке создания ---
   Select this\Type
      Case #__type_Window
         this\fs[2] = 25 ; Высота заголовка (Top)
         this\fs[0] = 2  ; Общая рамка (Border)
         
      Case #__type_Panel
         this\fs[0] = 1  ; Тонкая рамка вокруг контента
         this\fs[2] = 25 ; Высота таббара (Top)
                         ; Если табы слева, то this\fs[1] = 100
         Protected tabheight = 25
         ;this\row\height = 25
         
      Case #__type_Container
         this\fs[0] = 1  ; Тонкая рамка вокруг контента
         
      Case #__type_TabBar
         this\tab._s_TAB = AllocateStructure(_s_TAB)
         this\tab\align = #_align_left
         this\tab\indent = 5 ; Начальный отступ (чтобы первый таб не прилипал к рамке)
         this\tab\spacing = 5; По умолчанию минимальный зазор
         this\text\padding\X = 10
         
      Case #__type_Button
         this\text\padding\X = 5
         
         If flags & #__flag_Left
            this\text\align = #_align_left
         ElseIf flags & #__flag_Right
            this\text\align = #_align_right
         Else
            this\text\align = #_align_center
         EndIf
         
   EndSelect
   
   ; Здесь Resize НЕ ВЫЗЫВАЕМ, так как parent еще не привязан к этой 'this'
   ; 2. РЕГИСТРАЦИЯ (теперь у виджета в списке ЕСТЬ родитель)
   *new = SetParent(@this, *parent)
   
   ; 3. УСТАНОВКА КООРДИНАТ (теперь Resize увидит родителя и посчитает real\x/y правильно)
   If *new
      If Type = #__type_Panel Or 
         Type = #__type_Container Or 
         Type = #__type_ScrollArea 
         OpenList(*new) 
      EndIf
      
      ; 3. ТЕПЕРЬ ЗАПОЛНЯЕМ КОЛОНКИ (работаем с постоянным *new)
      If Type = #__type_Tree
         add_column(*new, "tree", Width) 
      ElseIf Type = #__type_Editor
         add_column(*new, "едит", Width) 
      ElseIf Type = #__type_ListIcon
         add_column(*new, title, param1) 
      EndIf
      
      Resize(*new, X, Y, Width, Height)
      
      ; 4. КОНТЕКСТ ДЛЯ ПАНЕЛИ
      If Type = #__type_Panel 
         ; Создаем "голову" и "тело"
         *new\tabbar = Create(*new, "TabBar", #__type_TabBar, 0, 0, Width, tabheight, "", #__flag_integral)
         ;
         *new\areabar = Create(*new, "AreaBar", #__type_AreaBar, 0, tabheight, Width, Height - tabheight, "", #__flag_integral)
      EndIf
      
      ; 4. КОНТЕКСТ ДЛЯ СКРОЛЛ-ОБЛАСТИ
      If Type = #__type_ScrollArea 
         *new\areabar = Create(*new, "AreaBar", #__type_AreaBar, 0, 0, Width, Height, "", #__flag_integral)
      EndIf
      
      ProcedureReturn *new
   EndIf
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
Procedure.i Panel( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_Panel, X, Y, Width, Height, #Null$, Flag )
EndProcedure
Procedure.i Button( X.l, Y.l, Width.l, Height.l, Text.s, Flag.q = 0, round.l = 0 )
   ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_Button, X, Y, Width, Height, Text, Flag )
EndProcedure
Procedure.i Container( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_Container, X, Y, Width, Height, #Null$, Flag )
EndProcedure

;-
Procedure Free(*this._s_WIDGET)
   If Not *this : ProcedureReturn : EndIf
   
   ; 1. РЕКУРСИЯ: Сначала находим и убиваем всех детей
   ; 1. Убиваем детей, пока они есть (рекурсия сама всё вычистит)
   While *this\first
      Free(*this\first) 
   Wend
   
   ; 2. ПЕРЕПРИВЯЗКА СОСЕДЕЙ (Вот здесь магия!)
   If *this\parent
      ; Если мы были ПЕРВЫМ ребенком, то теперь ПЕРВЫМ становится наш СОСЕД
      If *this\parent\first = *this 
         *this\parent\first = *this\next 
      EndIf
      
      ; Если мы были ПОСЛЕДНИМ ребенком, то теперь ПОСЛЕДНИМ становится наш ПРЕДЫДУЩИЙ сосед
      If *this\parent\last = *this 
         *this\parent\last = *this\prev 
      EndIf
   EndIf
   
   ; 3. Сшиваем соседей между собой (чтобы не было дырки в списке)
   If *this\prev : *this\prev\next = *this\next : EndIf
   If *this\next : *this\next\prev = *this\prev : EndIf
   
   ; 4. ОЧИСТКА ПАМЯТИ ВНУТРИ ВИДЖЕТА
   ; Если у виджета были списки (вкладки в TabBar или строки в ListIcon)
   ClearList(*this\__tabs())
   ClearList(*this\__rows())
   
   ; 5. УДАЛЕНИЕ САМОГО ВИДЖЕТА ИЗ ГЛОБАЛЬНОГО СПИСКА
   PushListPosition(widgets())
   ChangeCurrentElement(widgets(), *this)
   DeleteElement(widgets())
   PopListPosition(widgets())
   
   ; 6. БЕЗОПАСНОСТЬ: Обнуляем глобальные указатели, если удалили активный виджет
   If *this = Entered() : Entered() = 0 : EndIf
   If *this = Pressed() : Pressed() = 0 : EndIf
   If *this = GetActive() : SetActive(0) : EndIf
   
   ; 7. Помечаем, что холст надо перерисовать (пустое место осталось)
   If Root() And *this <> Root()
      Root()\mask | #__mask_redraw
   EndIf
EndProcedure

Procedure Close( *root._s_ROOT )
   Protected *next._s_ROOT ; Временная переменная для безопасного перехода
   
   If *root = #PB_All
      *root = Root( )
      If Not *root : ProcedureReturn : EndIf
      
      ; 1. Отматываем в самое начало
      While *root\PrevRoot( ) : *root = *root\PrevRoot( ) : Wend
      
      ; 2. Удаляем всех по очереди
      While *root
         *next = *root\NextRoot( ) ; ЗАПОМИНАЕМ следующий адрес ДО удаления
         Close(*root)              ; Теперь удаляем текущий
         *root = *next             ; Переходим к запомненному адресу
      Wend
      
   Else
      ; ...
      If Entered( ) And Entered( )\root = *root : Entered( ) = 0 : EndIf
      If Leaved( ) And Leaved( )\root = *root : Leaved( ) = 0 : EndIf
      If Pressed( ) And Pressed( )\root = *root : Pressed( ) = 0 : EndIf
      If GetActive( ) And GetActive( )\root = *root : GetActive( ) = 0 : EndIf
      
      ; --- Одиночное удаление ---
      ; 1. СВЯЗЫВАЕМ СОСЕДЕЙ (вырезаем из цепи)
      If *root\PrevRoot( ) : *root\PrevRoot( )\NextRoot( ) = *root\NextRoot( ) : EndIf
      If *root\NextRoot( ) : *root\NextRoot( )\PrevRoot( ) = *root\PrevRoot( ) : EndIf
      
      ; 2. ПЕРЕНОСИМ ГЛОБАЛЬНЫЙ УКАЗАТЕЛЬ
      If Root( ) = *root
         If *root\PrevRoot( )
            Root( ) = *root\PrevRoot( )
         Else
            Root( ) = *root\NextRoot( )
         EndIf
      EndIf
      
      ; 3. Удаляем все виджеты один за другим через их персональный free( )
      ForEach widgets( )
         Free(@widgets( ))
      Next
      
      ; 4. ОЧИСТКА ПАМЯТИ
      If IsGadget(*root\Canvas\gadget)
         FreeGadget(*root\Canvas\gadget)
      EndIf
      
      ; 5. Если сам объект ROOT выделялся динамически
      FreeStructure(*root)
   EndIf
EndProcedure


Procedure.i Open(window, X, Y, Width, Height, title.s="", flags.q = 0)
   Protected *root._s_ROOT = AllocateStructure(_s_ROOT)
   
   If IsWindow(window)
      *root\Canvas\window = window
      *root\Canvas\gadget = CanvasGadget(#PB_Any, X, Y, Width, Height, #PB_Canvas_Keyboard)
   Else
      *root\Canvas\window = OpenWindow(#PB_Any, X, Y, Width, Height, title, #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
      *root\Canvas\gadget = CanvasGadget(#PB_Any, 0, 0, Width, Height, #PB_Canvas_Keyboard)
   EndIf
   SetOsData(GadgetID(*root\Canvas\gadget), *root)
   
   Static i:*Root\class = Str(i):i+1
   *root\canvas\dpi = DesktopResolutionX( ) 
   *root\color = $D4FAFAFA
   
   *root\root = *root
   *root\class = "ROOT"
   *root\type = #__type_Root
   
   If Root( )
      Root( )\NextRoot( ) = *root
      Root( )\NextRoot( )\PrevRoot( ) = Root( )
   EndIf
   Root( ) = *root 
   OpenList(*root)
   
   BindGadgetEvent(*root\Canvas\gadget, @Canvas_Events())
   ProcedureReturn *root
EndProcedure

;-
; ==============================================================================
;- 1 ПРИМЕР ИНИЦИАЛИЗАЦИИ И ЗАПУСКА
; ==============================================================================
CompilerIf #PB_Compiler_IsMainFile
   Define Event.i, Event_Gadget.i, Event_Type.i
   Define w = 865, h = 500
   Define._s_WIDGET *g, *g1, *t, *t1, *e, *e1, *p
   Define chr.s = "|"
   
   Open(0, 0, 0, w, h, "PureBasic UI Engine", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ; 1. Главная панель
   ; СОЗДАЕМ виджеты (выделяем память, задаем тип и координаты)
   *p = Panel(10, 10, w-20, h-20)
   AddItem(*p, -1, "Вкладка А") 
;    *e = Editor(10, 10, 265, 235)
;    *e1 = Editor(10, 255, 265, 235)
   *e = Editor(10, 10, 265, 480)
   *e1 = Editor(285, 10, 165, 480)
   AddItem(*p, -1, "Вкладка B") 
   *t = Tree(300-15, 10, 280, 480)
   AddItem(*p, -1, "Вкладка C") 
   *g = ListIcon(590-15, 10, 280, 480, "Имя", 120)
   CloseList()
   
   ; Наполняем данными через твои add_column / add_row
   If *g
      add_column(*g, "возраст", 50)
      add_column(*g, "город", 150)
                              
      add_row(*g, "grid node")
      add_row(*g, "Александр" + chr + "31" + chr + "Москва",1)
      add_row(*g, "Елена" + chr + "24" + chr + "Владивосток",1)
      add_row(*g, "Дмитрий" + chr + "45" + chr + "Тула",1)
      
      add_row(*g, "greed node")
      add_row(*g, "Александр" + chr + "31" + chr + "Москва",1)
      add_row(*g, "Елена" + chr + "24" + chr + "Владивосток",1)
      add_row(*g, "Дмитрий" + chr + "45" + chr + "Тула",1)
   EndIf
   
   ;                  
   If *t
      add_row(*t, "tree node")
      add_row(*t, "Александр" + chr + "31" + chr + "Москва",1)
      add_row(*t, "Елена" + chr + "24" + chr + "Владивосток",1)
      add_row(*t, "Дмитрий" + chr + "45" + chr + "Тула",1)
      
      add_row(*t, "tree node")
      add_row(*t, "Александр" + chr + "31" + chr + "Москва",1)
      add_row(*t, "Елена" + chr + "24" + chr + "Владивосток",1)
      add_row(*t, "Дмитрий" + chr + "45" + chr + "Тула",1)
   EndIf
   
   ;
   If *e
      Define Text.s, m.s   = #LF$
      Text.s = "This is a long line." + m.s +
               "Who should show." + m.s +
               m.s +
               m.s +
               "I have to write the text in the box or not." + m.s +
               m.s +
               m.s +
               "The string must be very long." + m.s +
               "Otherwise it will not work."
      SetText(*e, Text.s)
      AddItem(*e, 0, "add line first")
      AddItem(*e, 4, "add line "+Str(4))
      AddItem(*e, 8, "add line "+Str(8))
      AddItem(*e, -1, "add line last")
   EndIf
   
   ;
   If *e1
      Define a  = - 1
      AddItem(*e1, a, "This is a long row.")
      AddItem(*e1, a, "Who should show.")
      AddItem(*e1, a, "")
      AddItem(*e1, a, "")
      ; AddItem(*e1, a, "")
      AddItem(*e1, a, "I have to write the text in the box or not.")
      ; AddItem(*e1, a, "")
      AddItem(*e1, a, "")
      AddItem(*e1, a, "")
      AddItem(*e1, a, "The string must be very long.")
      AddItem(*e1, a, "Otherwise it will not work.")
      ;    For a = 0 To 2
      ;       AddItem(*e1, a, Str(a) + " Row " + Str(a))
      ;    Next
      ;    AddItem(*e1, 7 + a, "_")
      ;    For a = 4 To 6
      ;       AddItem(*e1, a, Str(a) + " Row " + Str(a))
      ;    Next
      AddItem(*e1, 0, "add row first")
      AddItem(*e1, 4, "add row "+Str(4))
      AddItem(*e1, 8, "add row "+Str(8))
      AddItem(*e1, -1, "add row last")
   EndIf
   
   
   ; Отрисовываем всё, что создали
   ReDraw(Root( ))
   
   ;-  2. ГЛАВНЫЙ ЦИКЛ СОБЫТИЙ
   Repeat
      Event = WaitWindowEvent( )
      
      If Event = #PB_Event_Gadget
         
         ; canvas_events( )
         
      ElseIf Event = #PB_Event_CloseWindow
         Close(Root( ))
         Break
      EndIf
   ForEver
   
   ; --- ВОТ ЗДЕСЬ ВЫЗЫВАЕМ CLOSE ---
   Close(Root( )) 
   Root( ) = 0
   End ; Завершение программы
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 3022
; FirstLine = 3003
; Folding = ----------------------------------------------------------------------------
; EnableXP
; DPIAware