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

; ==============================================================================
; МАСКИ (Quad #__mask_*)
; ==============================================================================
#__mask_redraw    = 1 << 1   ; Флаг: Требуется перерисовка
#__mask_update    = 1 << 2   ; Флаг: Требуется пересчет геометрии (TextWidth и т.д.) нужно пересчитать координаты X для каретки/выделения.
#__mask_hover     = 1 << 3
#__mask_press     = 1 << 4
#__mask_active    = 1 << 5   ; Фокус (Виджет) 
#__mask_hidden    = 1 << 6
#__mask_disabled  = 1 << 7
#__mask_drag      = 1 << 8   ; Состояние перетаскивания
#__mask_edit      = 1 << 9   ; Выделение (Строка)
#__mask_change    = 1 << 10  ; текст изменился, надо перепарсить токены.
#__mask_cursor    = 1 << 11
#__mask_resize    = 1 << 12
#__mask_node      = 1 << 13  ; Является узлом (Строка) / Деревом (Виджет)
#__mask_collapsed = 1 << 14  ; Свернуто (Узел/Ветка)
                             ; #__mask_caret     = 1 << 15
#__mask_tokken = 1 << 15

; --- Константы ---
#__align_left    = 1 ; (бинарно 0001)
#__align_right   = 2 ; (бинарно 0010)
#__align_center  = 4 ; (бинарно 0100)
; и так далее

; ==========================================================
; (Цветовая схема и Маски)
; ==========================================================
#COLOR_BACK_NORMAL   = $FFFFFF ; Белый
#COLOR_BACK_SELECTED = $EBD8BD ; Голубой (Active)
#COLOR_BACK_ACTIVED  = $FFEDE6
#COLOR_BACK_DISABLE  = $F5F5F5 ; Светло-серый
#COLOR_BACK_HOVER    = $F5F5F5
#COLOR_TEXT_NORMAL   = $333333 ; Темно-серый
#COLOR_TEXT_DISABLE  = $AAAAAA ; Серый (Disabled)

#ROW_COLOR_LINE    = $EEEEEE ; Разделитель строк

#COL_COLOR_BACK_NORMAL    = $F5F5F5
#COL_COLOR_BACK_HOVER   = $E0E0E0
#COL_COLOR_BACK_PRESS   = $D0D0D0
#COL_COLOR_LINE    = $CCCCCC
#COL_COLOR_TEXT    = $333333
#COL_COLOR_BORDER  = $AAAAAA

#COL_RESIZE_ZONE = 5      ; Зона захвата края колонки (px)
#COL_MIN_WIDTH   = 40     ; Минимальная ширина колонки
#COL_AUTO_PAD    = 10     ; Добавочная ширина при автоподборе

#TREE_Padding = 5
#TREE_ButtonSize = 9
#TREE_Indent   = 20 ; Шаг вложенности ; Отступ для подуровней дерева
#TREE_LineOffset = #TREE_Indent - #TREE_ButtonSize/2 ; - (#TREE_ButtonSize%2) ; Отступ линии от текста


; ==============================================================================
;- СТРУКТУРЫ ДАННЫХ
; ==============================================================================
Structure _s_POINT : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure
Structure _s_TEXTINFO Extends _s_COORDINATE
;    pos.i
;    len.i
;    Array str.s(0) 
EndStructure
Structure _s_TEXTITEM Extends _s_TEXTINFO
;    change.b
EndStructure
Structure _s_TEXT Extends _s_TEXTITEM
   align.q
   
   ;    mode.a    
   ;    
   ;    multiline.b
   ;    invert.b
   ;    vertical.b
   ;    rotate.d
EndStructure

Structure _s_MOUSE Extends _s_POINT
   mask.q                ; Битовые состояния (Shift, Ctrl, Drag)
   click.b
   press._s_POINT        ; Точка начала нажатия
   *widget._s_WIDGET[3]  ; Текущий виджет под мышью (Entered)
EndStructure

Structure _s_KEYBOARD  ; Ok
   input.c
   key.l[2]
   *active._s_WIDGET   ; keyboard focus element ; GetActive( )\
EndStructure

Structure _s_CARET
   start.l           ; Индекс начала выделения (символ)
   stop.l            ; Индекс конца выделения (символ)
   X.l               ; X-смещение начала выделения в пикселях
EndStructure
Structure _s_SEL Extends _s_CARET 
   Width.l           ; Ширина выделения в пикселях
EndStructure

Structure _s_COLUMNS ; ЗАГОЛОВОК
   ID.l              ; <--- Номер элемента в списке данных строки (0, 1, 2...) 
   X.l               ; Относительный X вкладки в шапке
   Width.l           ; Ширина вкладки
   title.s
   mask.q            ; Маска конкретной вкладки
   align.q
EndStructure
Structure _s_TABS Extends _s_COLUMNS 
   tx.l
EndStructure

Structure _s_COLUMN
   spacing.a ; РАССТОЯНИЕ
   Height.l  ; Высота шапки (заголовков)
             ;
   *active._s_COLUMNS 
   List __s._s_COLUMNS( )
EndStructure

Structure _s_TAB
   spacing.a             ; РАССТОЯНИЕ МЕЖДУ ВКЛАДКАМИ
                         ;
   indent.a              ; ОТСТУП ВКЛАДОК
   totalwidth.l          ; Общая ширина всех вкладок (уже считаем в update_tab)
   align.q               ; Выравнивание (0-лево, 1-центр, 2-право)
                         ;
   *active._s_TABS 
   List __s._s_TABS()  ; Заголовки вкладок
EndStructure

; Структура правила (Чертеж)
Structure _s_KEYWORD
   word.s  ; Правильное написание ("Structure")
   color.l ; Цвет ($BBGGRR)
   font.i  ; ID шрифта (Bold)
EndStructure

; Структура визуального фрагмента (Команда для отрисовки)
Structure _s_TOKEN
   pos.l    ; Позиция начала в строке (от 1)
   len.l    ; Длина куска
   color.l  ; Цвет ($BBGGRR)
   X.l
   Width.l  ; <--- КЭШ: Ширина сегмента в пикселях
   Height.l ; <--- КЭШ: Высота сегмента в пикселях
   font.i   ; Сюда пишем FontID(Ваш_Шрифт)
EndStructure

; Структура темы оформления
Structure _s_THEME
   Map Keywords._s_KEYWORD() ; Карта ключевых слов
   Map Operators.l()         ; Карта операторов (просто цвет)
   
   Normal.l  ; Цвет обычного текста
   String.l  ; Цвет строк в кавычках
   Comment.l ; Цвет комментариев
   Number.l  ; Цвет чисел
   Constant.l; 
EndStructure

;
Structure _s_VISIBLE_ROW
   *first._s_rows        ; Указатель на первую видимую строку
   *last._s_rows         ; Указатель на последнюю видимую строку
EndStructure

Structure _s_ROWS Extends _s_COORDINATE
   sublevel.i               ; Уровень вложенности для дерева
   mask.q                ; Состояние строки (#__mask_active, #__mask_node...)
   sel._s_SEL
   Array str.s(0)        ; Динамический массив ячеек данных
   List tokens._s_TOKEN(); Список раскрашенных сегментов
EndStructure
Structure _s_ROW
   indent.l         ; Отступ веток дерева
   Height.l         ; Высота строки данных ; 0 = авто по шрифту
   *caret._s_CARET
   *active._s_ROWS[2]
   List __s._s_ROWS()        ; Строки данных
EndStructure

Structure _s_BAR Extends _s_COORDINATE
   pos.i 
   max.i
   is_drag.b
   thumb_w.l
   thumb_h.l
EndStructure

Structure _s_SCROLL Extends _s_COORDINATE
   v._s_BAR
   h._s_BAR
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   font.i
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
   padding._s_POINT      ; ВНУТРЕННИЙ ОТСТУП ТЕКСТА (слева + справа)
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
   
   List *__items._s_ROWS( )     ; Развернутый рулон (указатели)
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
Global Theme._s_THEME
Global NewList widgets._s_WIDGET() ; Список всех виртуальных виджетов на холсте

Global Font_Editor_Normal = GetGadgetFont(#PB_Default) ; LoadFont(#PB_Any, "Consolas", 15)
Global Font_Editor_Bold   = FontID(LoadFont(#PB_Any, "Consolas", 25, #PB_Font_Bold))
   
Declare AddOperator(chars.s, color.l)
Declare AddKeyword(word.s, color.l, font.i = 0)

; --- ИНИЦИАЛИЗАЦИЯ (сделай это один раз при старте) ---
; --- Базовые цвета ---
Theme\Normal  = $000000 ; Черный
Theme\Number  = $0000FF ; Красный (BGR)
Theme\String  = $008800 ; Зеленый
Theme\Comment = $888888 ; Серый
Theme\Constant = $956111

; --- Ключевые слова (Синие и жирные) ---
AddKeyword("Structure",    $FF0000) ; Синий в BGR
AddKeyword("EndStructure", $FF0000)
AddKeyword("Procedure",    $FF0000)
AddKeyword("EndProcedure", $FF0000)
AddKeyword("If",           $FF0000)
AddKeyword("Else",         $FF0000)

AddKeyword("EndIf",        $FF0000)
AddKeyword("While",        $FF0000)
AddKeyword("Wend",         $FF0000)
AddKeyword("ForEach",      $FF0000)
AddKeyword("Next",         $FF0000)
AddKeyword("Global",       $FF0000)
AddKeyword("Protected",    $FF0000)
AddKeyword("Define",       $FF0000)

; --- Операторы (Серые) ---
AddOperator("+-*/=<>()[]{},", $888888)

; --- Структурные разделители (Маджента) ---
AddOperator(".\", $FF00FF)

Global test_cursor 
; ==============================================================================
;- МАКРОС 
; ==============================================================================
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

;-
Macro activate(_address_, _active_)
   Bool(_address_\mask & #__mask_active = 0)
   If _active_ And 
      _active_\mask & #__mask_active
      _active_\mask &~ #__mask_active
   EndIf
   _active_ = _address_
   _active_\mask | #__mask_active
EndMacro
Macro GetActive( ): GUI\keyboard\active: EndMacro
Procedure SetActive(*this._s_WIDGET)
   If GetActive( ) 
      GetActive( )\mask &~ #__mask_active 
   EndIf
   GetActive( ) = *this
   *this\mask | (#__mask_active | #__mask_redraw)
   Root( ) = *this\root
EndProcedure

; Macro RowFocused( _this_ )
;    _this_\row\active[0] ; GUI\rowactive
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
; Macro Mid(txt, pos, length = -1) : PeekS(@txt + (pos - 1) * SizeOf(Character), length) : EndMacro


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
Macro MouseClick( ): mouse( )\click: EndMacro                                               ; Returns mouse click count

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
            _this_\mask &~ #__mask_hidden
            
         Else
            ; СЛУЧАЙ А: Мы лежим в AreaBar (смотрим на дедушку)
            If _parent_\Type = #__type_AreaBar And _parent_\parent
               If _tabpage_ <> _parent_\parent\tabpage
                  _this_\mask | #__mask_hidden
               Else
                  _this_\mask &~ #__mask_hidden
               EndIf
               
               ; СЛУЧАЙ Б: Мы лежим прямо в Панели (смотрим на отца)
            ElseIf _parent_\tabbar
               If _tabpage_ <> _parent_\tabpage
                  _this_\mask | #__mask_hidden
               Else
                  _this_\mask &~ #__mask_hidden
               EndIf
               
            Else
               ; В обычном контейнере без вкладок — всегда видны
               _this_\mask &~ #__mask_hidden
            EndIf
         EndIf
      EndIf
      
      ;       ; ОТЛАДКА (внутри If _parent_)
      ;       If _this_\mask & #__mask_hidden
      ;          Debug "СКРЫТ: " + _this_\class + " (Стр: " + Str(_this_\tabindex) + " Род.Инд: " + Str(_parent_\tabpage) + ")"
      ;       Else
      ;          Debug "ВИДИМ: " + _this_\class + " (Стр: " + Str(_this_\tabindex) + " Род.Инд: " + Str(_parent_\tabpage) + ")"
      ;       EndIf
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

Procedure.l ChangeColor(Type.l, mask.q, colortype.l, Index.l=-1)
   Protected color.l
   
   If Type = #__type_TabBar
      If mask & #__mask_active
         If colortype = #PB_Gadget_BackColor
            color = $FFFFFF 
         ElseIf colortype = #PB_Gadget_FrontColor
            color = $000000
         EndIf
      ElseIf mask & #__mask_disabled
         If colortype = #PB_Gadget_BackColor
            color = $D0D0D0 
         ElseIf colortype = #PB_Gadget_FrontColor
            color = $888888 
         EndIf
      ElseIf mask & #__mask_hover
         If colortype = #PB_Gadget_BackColor
            color = $F8F8F8 
         ElseIf colortype = #PB_Gadget_FrontColor
            color = $000000
         EndIf
      Else
         If colortype = #PB_Gadget_BackColor
            color = $E0E0E0 
         ElseIf colortype = #PB_Gadget_FrontColor
            color = $000000
         EndIf
      EndIf
   EndIf
   
   If Type = #__type_Editor Or Type = #__type_Tree Or Type = #__type_ListIcon
      color = #COLOR_BACK_NORMAL
      ; Фон (Зебра / Hover / Select)
      If Index % 2 = 0  
         color = $FAFAFA
      EndIf
      
      If mask & #__mask_active 
         If mask & #__mask_edit 
            color = #COLOR_BACK_ACTIVED 
         Else
            color = #COLOR_BACK_SELECTED 
         EndIf
      ElseIf mask & #__mask_hover
         color = #COLOR_BACK_HOVER 
      EndIf
   EndIf
   
   ProcedureReturn color
EndProcedure

;-
Procedure auto_scroll_y(*this._s_WIDGET)
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h  
   Protected._s_ROWS *active = *this\row\active[0]
   Protected result
   
   ; Проверка автоскролла по Y
   If *v\pos < (*active\y + *active\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
      *v\pos = (*active\y + *active\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
      result = 1
   ElseIf *v\pos > (*active\y - *this\column\height)
      *v\pos = (*active\y - *this\column\height)
      result = -1
   EndIf
   
   If *v\pos < 0 : *v\pos = 0 : EndIf
   If *v\pos > *v\max : *v\pos = *v\max : EndIf
   
   ProcedureReturn result
EndProcedure

; СКРОЛЛИНГ
Procedure auto_scroll_x(*this._s_WIDGET)
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h  
   Protected._s_ROWS *active = *this\row\active[0]
   
   Protected offset = *this\padding\x + (*active\sublevel * *this\row\indent)
   If (*active\mask & #__mask_node) : offset + 15 : EndIf
   Protected cx = *this\row\caret\x + offset
   Protected view_w = *this\width - Bool(*v\max > 0) * *this\fs[3]
   
   If *h\pos < cx - view_w + *this\padding\x : *h\pos = cx - view_w + *this\padding\x
      ElseIf *h\pos > cx - *this\padding\x : *h\pos = cx - *this\padding\x : EndIf
   If *h\pos < 0 : *h\pos = 0 : ElseIf *h\pos > *h\max : *h\pos = *h\max : EndIf
EndProcedure

Procedure.i edit_make_caret(*this._s_WIDGET)
   Protected i.i, mouse_x.i, caret_x.i, caret.i = -1
   Protected Distance.q, MinDistance.q = 9223372036854775807 
   Protected *row._s_rows = *this\row\active
   
   If *row
      *row\mask | #__mask_update
      Protected offset = *this\padding\x + (*row\sublevel * *this\row\indent)
      If (*row\mask & #__mask_node) : offset + 15 : EndIf
      Protected dx = *this\real\x + offset - *this\scroll\h\pos
      mouse_x = mouse()\x - dx
      
      Protected txt.s = *row\Str(0)
      Protected LenText = Len(txt)
      Protected HasTokens = Bool(ListSize(*row\tokens()) > 0)
      
      If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
         DrawingFont(Font_Editor_Normal)
         
         ; Временные переменные для накопления X
         Protected current_x = 0
         
         ; Мы идем по символам, как в твоем коде (это дает 100% точность)
         For i = 0 To LenText
            
            ; --- РАСЧЕТ caret_x (точно как в update_sel) ---
            If i = 0
               caret_x = 0
            Else
               If Not HasTokens
                  caret_x = TextWidth(Left(txt, i))
               Else
                  ; Считаем через токены, используя кэш ширины
                  caret_x = 0
                  PushListPosition(*row\tokens())
                  ForEach *row\tokens()
                     If i >= *row\tokens()\pos + *row\tokens()\len
                        caret_x + *row\tokens()\width
                     Else
                        If *row\tokens()\font : DrawingFont(*row\tokens()\font) : Else : DrawingFont(Font_Editor_Normal) : EndIf
                        caret_x + TextWidth(Mid(txt, *row\tokens()\pos, i - *row\tokens()\pos + 1))
                        Break
                     EndIf
                  Next
                  PopListPosition(*row\tokens())
               EndIf
            EndIf
            
            ; --- ТВОЯ ЛОГИКА ДИСТАНЦИИ ---
            Distance = (mouse_x - caret_x) * (mouse_x - caret_x)
            
            If Distance <= MinDistance
               MinDistance = Distance
               caret = i
               *this\row\caret\x = caret_x 
            Else
               ; Как только начали отдаляться — это была самая близкая точка
               Break
            EndIf
         Next
         StopDrawing()
      EndIf
   EndIf
   
   ProcedureReturn caret
EndProcedure

Procedure.i edit_reset_selection(*this._s_WIDGET, direction = 0) ; -1 - Left, 1 - Right
   
   ; Вместо поиска через ForEach, берем готовые указатели границ
   Protected *first_s._s_ROWS = *this\row\active[1] ; Якорь (откуда начали)
   Protected *last_s._s_ROWS  = *this\row\active[0] ; Каретка (где сейчас)
   
   If Not *first_s Or Not *last_s : ProcedureReturn #False : EndIf
   If *first_s = *last_s And *first_s\sel\start = *first_s\sel\stop : ProcedureReturn #False : EndIf
   
   ; Нормализуем: чтобы first всегда был ВЫШЕ по списку, чем last
   If *first_s\y > *last_s\y
      Swap *first_s, *last_s
   EndIf
   
   If direction
      ; ЛОГИКА СХЛОПЫВАНИЕ: 
      If direction = -1 ; Нажали ВЛЕВО -> прыгаем в начало выделения (вверх)
         *this\row\active[0] = *first_s
         *this\row\caret\start = *first_s\sel\start
      ElseIf direction = 1 ; Нажали ВПРАВО -> прыгаем в конец выделения (вниз)
         *this\row\active[0] = *last_s
         *this\row\caret\start = *last_s\sel\stop
      EndIf
      
      ;
      If *first_s <> *last_s
         ChangeCurrentElement(*this\__rows(), *first_s)
         Repeat
            If @*this\__rows() = *this\row\active[0]
               If @*this\__rows() = *last_s
                  Break
               Else
                  Continue
               EndIf
            EndIf
            *this\__rows()\sel\start = 0
            *this\__rows()\sel\stop = 0
            *this\__rows()\mask &~ (#__mask_active | #__mask_edit | #__mask_update)
            If @*this\__rows() = *last_s
               Break
            EndIf
         Until Not NextElement(*this\__rows())
      EndIf
      
   Else
      ; 1. Сохраняем куски текста (используем правильные индексы выделения)
      Protected head.s = Left(*first_s\Str(0), *first_s\sel\start)
      Protected tail.s = Mid(*last_s\Str(0), *last_s\sel\stop + 1)
      
      ; 2. Удаляем лишние строки
      If *first_s <> *last_s
         ChangeCurrentElement(*this\__rows(), *first_s)
         While NextElement(*this\__rows())
            If @*this\__rows() = *last_s
               DeleteElement(*this\__rows())
               Break
            Else
               DeleteElement(*this\__rows(), 1)
            EndIf
         Wend
      EndIf
      
      ; 3. Обновляем выжившую строку
      *first_s\Str(0) = head + tail
      *first_s\mask | #__mask_change   ; <-- ОБЯЗАТЕЛЬНО! Чтобы перепарсить токены
      *this\row\caret\start = Len(head)
      *this\row\active[0] = *first_s
      *this\mask | (#__mask_update)
   EndIf
   
   ; Сброс масок (только для выжившей, остальные и так удалены)
   *this\row\active[0]\sel\start = 0
   *this\row\active[0]\sel\stop = 0
   *this\row\active[0]\mask | (#__mask_active | #__mask_edit | #__mask_update)
   
   ; Подтягиваем "якорь" к "голове"
   *this\row\active[1] = *this\row\active[0]
   *this\row\caret\stop = *this\row\caret\start
   
   ProcedureReturn #True
EndProcedure


Procedure edit_key_events(*this._s_WIDGET, *row._s_rows, event.i)
   If Not *this Or Not *row : ProcedureReturn : EndIf
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   Protected txt.s, pos.i, i.i
   
   Select event
      Case #PB_EventType_Input ; --- ТЕКСТОВЫЙ ВВОД ---    
         
         ; Если не зажат Ctrl (чтобы не печатать символы при Ctrl+C/V)
         If Not (keyboard()\key[1] & #PB_Canvas_Control)
            ; 1. Удаляем всё выделенное (одна или много строк)
            edit_reset_selection(*this)
            *row = *this\row\active[0] ; Актуализируем после склейки
            
            ; 2. Вставляем символ
            txt = *row\Str(0)
            pos = *this\row\caret\start
            *row\Str(0) = Left(txt, pos) + Chr(keyboard()\input) + Mid(txt, pos + 1)
            
            ; 3. Сдвигаем каретку и просим обновить WordWrap
            *this\row\caret\start + 1
            *this\row\caret\stop = *this\row\caret\start
            
            
            *this\mask | (#__mask_update)
            *row\mask |  #__mask_change
         EndIf
         
      Case #PB_EventType_KeyDown ; --- ГОРЯЧИЕ КЛАВИШИ ---
         Select keyboard()\key
            Case #PB_Shortcut_Back ; --- BACKSPACE ---
               If Not edit_reset_selection(*this) 
                  txt = *row\Str(0)
                  pos = *this\row\caret\start
                  
                  If pos = 0
                     ; Слияние с предыдущей строкой
                     ChangeCurrentElement(*this\__rows(), *row)
                     If PreviousElement(*this\__rows())
                        *v\max - *row\Height
                        *row = @*this\__rows()
                        *this\row\active[0] = *row
                        *this\row\active[1] = *row
                        *this\row\caret\start = Len(*row\Str(0))
                        
                        *row\mask | (#__mask_active | #__mask_edit | #__mask_change)
                        *row\Str(0) + txt
                        
                        NextElement(*this\__rows())
                        DeleteElement(*this\__rows())
                        
                        ; auto_scroll_y(*this)
                        If *v\pos > (*row\y - *this\column\height)
                           *v\pos = (*row\y - *this\column\height)
                        Else
                           If *v\pos > *v\max 
                              *v\pos = *v\max
                           EndIf
                        EndIf
                     EndIf
                  Else
                     *row\Str(0) = Left(txt, pos - 1) + Mid(txt, pos + 1)
                     *this\row\caret\start - 1
                     *row\mask | #__mask_change 
                  EndIf
                  
                  *this\row\caret\stop = *this\row\caret\start
                  *this\mask | #__mask_update 
               EndIf
               
            Case #PB_Shortcut_Delete ; --- DELETE ---
               If Not edit_reset_selection(*this) ; Если нечего удалять блоком
                  txt = *row\Str(0)
                  pos = *this\row\caret\start
                  
                  If pos = Len(txt)
                     ; Используем стек позиций для безопасности
                     PushListPosition(*this\__rows()) 
                     ; Притягивание нижней строки к текущей
                     ChangeCurrentElement(*this\__rows(), *row)
                     If NextElement(*this\__rows())
                        *row\Str(0) + *this\__rows()\Str(0)
                        DeleteElement(*this\__rows())
                     EndIf
                     PopListPosition(*this\__rows()) ; Мы снова на *row
                  Else
                     *row\Str(0) = Left(txt, pos) + Mid(txt, pos + 2)
                  EndIf
                  
                  ; Строка изменилась — нужно перепарсить токены
                  *row\mask | #__mask_change 
                  *this\mask | (#__mask_update)
               EndIf
               
               ; --- ENTER (Разрыв строки) ---  
            Case #PB_Shortcut_Return 
               ; 1. Удаляем всё выделенное (одна или много строк)
               edit_reset_selection(*this)
               ;
               *row = *this\row\active[0]
               If *row
                  txt = *row\Str(0)
                  pos = *this\row\caret\start
                  
                  PushListPosition(*this\__rows())
                  ChangeCurrentElement(*this\__rows(), *row)
                  If AddElement(*this\__rows())
                     *this\__rows()\sublevel = *row\sublevel 
                     *this\__rows()\Height = *row\Height
                     *this\__rows()\y = *row\y + *row\Height
                     *this\__rows()\Str(0) = Mid(txt, pos + 1)
                     *this\__rows()\mask | (#__mask_active | #__mask_edit)
                     ;
                     *row\Str(0) = Left(txt, pos)
                     *row\mask | (#__mask_change)
                     *row\mask &~ (#__mask_active | #__mask_edit)
                     *row = @*this\__rows()
                     *v\max + *row\Height ; Временно увеличиваем, чтобы автоскролл пропустил значение
                     *row\mask | (#__mask_change)
                     *this\mask | (#__mask_update)
                  EndIf
                  PopListPosition(*this\__rows())
                  
                  *this\row\active[0] = *row
                  *this\row\active[1] = *row
                  ;
                  *this\row\caret\start = 0
                  *this\row\caret\stop = 0
                  
                  ; auto_scroll_y(*this)
                  If *v\pos < (*row\y + *row\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
                     *v\pos = (*row\y + *row\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
                  EndIf
               EndIf
               
            Case #PB_Shortcut_Up ; --- ВВЕРХ (по рулону) ---
               If *row
                  If (keyboard()\key[1] & #PB_Canvas_Shift) = 0
                     edit_reset_selection(*this,-1)
                     *row = *this\row\active[0]
                  EndIf
                  ;
                  PushListPosition(*this\__items())
                  ChangeCurrentElement(*this\__items(), *row)
                  
                  ; Переход на ПРЕДЫДУЩИЙ визуальный фрагмент
                  If PreviousElement(*this\__items())
                     If (keyboard()\key[1] & #PB_Canvas_Shift)
                        If *row\y > *this\row\active[1]\y
                           *row\mask &~ (#__mask_edit)
                        EndIf
                        *row\mask | #__mask_update
                     Else
                        *row\mask &~ (#__mask_edit)
                        *this\row\active[1] = @*this\__items()
                     EndIf
                     *row\mask &~ (#__mask_active)
                     *row = @*this\__items()
                     *this\row\active[0] = *row
                     *this\row\active[0]\mask | (#__mask_active | #__mask_edit | #__mask_update)
                     
                     ; Проверка автоскролла по Y
                     If *v\pos > (*row\y - *this\column\height)
                        *v\pos = (*row\y - *this\column\height)
                        *this\mask | #__mask_update
                     EndIf
                  EndIf
                  PopListPosition(*this\__items())
               EndIf
               
            Case #PB_Shortcut_Down ; --- ВНИЗ (по рулону) ---
               If *row
                  If (keyboard()\key[1] & #PB_Canvas_Shift) = 0
                     edit_reset_selection(*this,1)
                     *row = *this\row\active[0]
                  EndIf
                  ;
                  PushListPosition(*this\__items())
                  ChangeCurrentElement(*this\__items(), *row)
                  
                  ; Переход на СЛЕДУЮЩИЙ визуальный фрагмент
                  If NextElement(*this\__items())
                     If (keyboard()\key[1] & #PB_Canvas_Shift)
                        If *row\y < *this\row\active[1]\y
                           *row\mask &~ (#__mask_edit)
                        EndIf
                        *row\mask | #__mask_update
                     Else
                        *row\mask &~ (#__mask_edit)
                        *this\row\active[1] = @*this\__items()
                     EndIf
                     *row\mask &~ (#__mask_active)
                     *row = @*this\__items()
                     *this\row\active[0] = @*this\__items()
                     *this\row\active[0]\mask | (#__mask_active | #__mask_edit | #__mask_update)
                     
                     ; Проверка автоскролла по Y
                     If *v\pos < (*row\y + *row\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
                        *v\pos = (*row\y + *row\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
                        *this\mask | #__mask_update
                     EndIf
                  EndIf
                  PopListPosition(*this\__items())
               EndIf
               
            Case #PB_Shortcut_Left
               If *row
                  If *this\row\caret\start > Len(*row\Str(0))
                     *this\row\caret\start = Len(*row\Str(0))
                  EndIf
                  If *this\row\caret\start = 0
                     ; 1. Мы в самом начале физической строки — прыгаем на строку выше
                     PushListPosition(*this\__items())
                     ChangeCurrentElement(*this\__items(), *row)
                     If PreviousElement(*this\__items())
                        *row\mask &~ (#__mask_active | #__mask_edit)
                        *row = @*this\__items()
                        *row\mask | (#__mask_active | #__mask_edit)
                        
                        ; Каретка уходит в КОНЕЦ предыдущей строки
                        *this\row\caret\start = Len(*row\Str(0))
                        
                        ; Проверка автоскролла по Y
                        If *v\pos > (*row\y - *this\column\height)
                           *v\pos = (*row\y - *this\column\height)
                           *this\mask | #__mask_update
                        EndIf
                     EndIf
                     PopListPosition(*this\__items())
                  Else
                     ; 2. Просто двигаемся влево внутри текста
                     *this\row\caret\start - 1
                  EndIf
                  If (keyboard()\key[1] & #PB_Canvas_Shift)
                     If *this\row\active[0] <> *row
                        If *this\row\active[0]\y =< *this\row\active[1]\y
                           *this\row\active[0]\mask | (#__mask_edit)
                        EndIf
                        *this\row\active[0] = *row
                     EndIf
                  Else 
                     If Not edit_reset_selection(*this, -1) 
                        *this\row\active[0] = *row
                        *this\row\active[1] = *this\row\active[0]
                        *this\row\caret\stop = *this\row\caret\start
                     EndIf
                  EndIf
                  
                  *row\mask | #__mask_update
               EndIf
               
            Case #PB_Shortcut_Right
               If *row
                  If *this\row\caret\start > Len(*row\Str(0))
                     *this\row\caret\start = Len(*row\Str(0))
                  EndIf
                  If *this\row\caret\start = Len(*row\Str(0))
                     ; 1. Мы в конце физической строки — прыгаем на начало следующей
                     PushListPosition(*this\__items())
                     ChangeCurrentElement(*this\__items(), *row)
                     If NextElement(*this\__items())
                        *row\mask &~ (#__mask_active | #__mask_edit)
                        *row = @*this\__items()
                        *row\mask | (#__mask_active | #__mask_edit)
                        
                        ; Каретка в начало следующей строки
                        *this\row\caret\start = 0
                        
                        ; Проверка автоскролла по Y
                        If *v\pos < (*row\y + *row\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
                           *v\pos = (*row\y + *row\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
                           *this\mask | #__mask_update
                        EndIf
                     EndIf
                     PopListPosition(*this\__items())
                  Else
                     ; 2. Двигаемся вправо внутри текста
                     *this\row\caret\start + 1
                  EndIf
                  If (keyboard()\key[1] & #PB_Canvas_Shift)
                     If *this\row\active[0] <> *row
                        If *this\row\active[0]\y >= *this\row\active[1]\y
                           *this\row\active[0]\mask | (#__mask_edit)
                        EndIf
                        *this\row\active[0] = *row
                     EndIf
                  Else  
                     If Not edit_reset_selection(*this, 1) 
                        *this\row\active[0] = *row
                        *this\row\active[1] = *this\row\active[0]
                        *this\row\caret\stop = *this\row\caret\start 
                     EndIf
                  EndIf
                  *row\mask | #__mask_update
               EndIf
               
            Case #PB_Shortcut_Home
               If *row
                  ; 1. Если зажат CTRL — прыгаем в начало документа
                  If (keyboard()\key[1] & #PB_Canvas_Control)
                     If FirstElement(*this\__rows())
                        *row\mask &~ (#__mask_active | #__mask_edit)
                        *row = @*this\__rows()
                        *row\mask | (#__mask_active | #__mask_edit)
                        *this\row\active[0] = *row
                        
                        ; Проверка автоскролла по Y
                        If *v\pos > (*row\y - *this\column\height)
                           *v\pos = (*row\y - *this\column\height)
                           *this\mask | #__mask_update
                        EndIf
                     EndIf
                  EndIf
                  
                  ; 2. Каретку в ноль
                  *this\row\caret\start = 0
                  
                  ; 3. Если SHIFT не зажат — сбрасываем выделение (якорь к курсору)
                  If (keyboard()\key[1] & #PB_Canvas_Shift) = 0
                     *this\row\caret\stop = *this\row\caret\start
                     *this\row\active[1] = *this\row\active[0]
                  EndIf
                  
                  *row\mask | (#__mask_update)
               EndIf
               
            Case #PB_Shortcut_End
               If *row
                  ; 1. Если зажат CTRL — прыгаем в самый конец документа
                  If (keyboard()\key[1] & #PB_Canvas_Control)
                     If LastElement(*this\__rows())
                        *row\mask &~ (#__mask_active | #__mask_edit)
                        *row = @*this\__rows()
                        *row\mask | (#__mask_active | #__mask_edit)
                        *this\row\active[1] = *row
                        
                        ; Проверка автоскролла по Y
                        If *v\pos < (*row\y + *row\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
                           *v\pos = (*row\y + *row\height) - (*this\height - Bool(*h\max > 0) * *this\fs[4])
                           *this\mask | #__mask_update
                        EndIf
                     EndIf
                  EndIf
                  
                  ; 2. Каретку в конец строки данных
                  *this\row\caret\stop = Len(*row\Str(0))
                  
                  ; 3. Если SHIFT не зажат — сбрасываем выделение
                  If (keyboard()\key[1] & #PB_Canvas_Shift) = 0
                     *this\row\caret\start = *this\row\caret\stop
                     *this\row\active[0] = *this\row\active[1]
                  EndIf
                  
                  *row\mask | (#__mask_update)
               EndIf
               
            Case #PB_Shortcut_PageUp, #PB_Shortcut_PageDown
               If *row
                  ; 1. Определяем высоту страницы
                  Protected page_h.l = *this\height - *this\column\height - Bool(*h\max > 0) * *this\fs[4]
                  Protected current_h.l = 0
                  
                  PushListPosition(*this\__rows())
                  ChangeCurrentElement(*this\__rows(), *row)
                  
                  ; Снимаем активность со старой строки ПЕРЕД поиском новой
                  *row\mask &~ (#__mask_active | #__mask_edit)
                  
                  ; 2. Цикл по реальной высоте строк
                  While current_h < page_h
                     If keyboard()\key = #PB_Shortcut_PageUp
                        If Not PreviousElement(*this\__rows()) : Break : EndIf
                     Else
                        If Not NextElement(*this\__rows()) : Break : EndIf
                     EndIf
                     
                     ; Пропускаем скрытые (схлопнутые) строки
                     If *this\__rows()\mask & #__mask_hidden : Continue : EndIf
                     
                     current_h + *this\__rows()\height ; Накапливаем реальные пиксели
                  Wend
                  
                  ; 3. Теперь мы стоим на новой строке
                  *row = @*this\__rows()
                  *row\mask | (#__mask_active | #__mask_edit | #__mask_update)
                  
                  ; Обновляем данные в структуре виджета
                  *this\row\active[0] = *row
                  *this\row\caret\start = Min(*this\row\caret\start, Len(*row\Str(0)))
                  
                  If Not (keyboard()\key[1] & #PB_Canvas_Shift)
                     *this\row\active[1] = *this\row\active[0]
                     *this\row\caret\stop = *this\row\caret\start
                  EndIf
                  
                  ; 4. Синхронизируем скролл
                  If keyboard()\key = #PB_Shortcut_PageUp 
                     ; Синхронизируем скролл (по пикселям)
                     ; *v\pos - page_h
                     ;
                     ; Для PageUp: ставим новую активную строку по верхней границе (учитывая шапку)
                     *v\pos = *row\y - *this\column\height
                     
                  Else 
                     ; Синхронизируем скролл (по пикселям)
                     ; *v\pos + page_h
                     ;
                     ; Для PageDown: ставим новую строку так, чтобы её НИЗ был у НИЖНЕГО края виджета
                     ; Это предотвращает "прыжки" лишнего пустого пространства
                     *v\pos = (*row\y + *row\height) - *this\column\height - page_h
                  EndIf
                  
                  ; И финальная страховка
                  If *v\pos < 0 : *v\pos = 0 : EndIf
                  If *v\pos > *v\max : *v\pos = *v\max : EndIf
                  
                  PopListPosition(*this\__rows())
                  *this\mask | #__mask_update
               EndIf
               
            Case #PB_Shortcut_A ; --- SELECT ALL ---
               If keyboard()\key[1] & #PB_Canvas_Control
                  If FirstElement(*this\__rows())
                     *this\row\active[1] = @*this\__rows()
                     *this\row\caret\stop = 0
                  EndIf
                  PushListPosition(*this\__rows())
                  ForEach *this\__rows()
                     *this\__rows()\sel\start = 0
                     *this\__rows()\sel\stop = Len(*this\__rows()\Str(0))
                     *this\__rows()\mask &~ #__mask_active
                     *this\__rows()\mask | (#__mask_edit | #__mask_update)
                  Next
                  PopListPosition(*this\__rows())
                  If LastElement(*this\__rows())
                     *this\row\caret\start = Len(*this\__rows()\Str(0))
                     *this\row\active[0] = @*this\__rows()
                     *this\__rows()\mask | #__mask_active
                  EndIf
               EndIf
               
            Case #PB_Shortcut_C, #PB_Shortcut_X ; --- COPY / CUT ---
               If keyboard()\key[1] & #PB_Canvas_Control
                  Protected Clip.s = ""
                  PushListPosition(*this\__rows())
                  ForEach *this\__rows()
                     If *this\__rows()\mask & #__mask_edit
                        Clip + Mid(*this\__rows()\Str(0), *this\__rows()\sel\start + 1, *this\__rows()\sel\stop - *this\__rows()\sel\start) + #LF$
                     EndIf
                  Next
                  PopListPosition(*this\__rows())
                  If Clip : SetClipboardText(RTrim(Clip, #LF$)) : EndIf
                  If keyboard()\key = #PB_Shortcut_X : edit_reset_selection(*this) : EndIf
               EndIf
               
            Case #PB_Shortcut_V ; --- PASTE ---
               If keyboard()\key[1] & #PB_Canvas_Control
                  ; 1. Если есть выделение — удаляем его перед вставкой
                  edit_reset_selection(*this)
                  
                  txt = GetClipboardText()
                  If txt = "" : ProcedureReturn 0 : EndIf
                  
                  ; 2. Приводим все переносы к одному виду (LF)
                  txt = ReplaceString(txt, #CRLF$, #LF$)
                  txt = ReplaceString(txt, #CR$, #LF$)
                  
                  ;
                  *row = *this\row\active[0]
                  pos = *this\row\caret\start
                  Protected head.s = Left(*row\Str(0), pos)
                  Protected tail.s = Mid(*row\Str(0), pos + 1)
                  
                  ; Разбираем текст из буфера на строки
                  Protected count = CountString(txt, #LF$) + 1
                  PushListPosition(*this\__rows())
                  ChangeCurrentElement(*this\__rows(), *row)
                  
                  For i = 1 To count
                     Protected current_line.s = StringField(txt, i, #LF$)
                     
                     If i = 1
                        ; Первая строка из буфера клеится к "голове" текущей строки
                        *row\Str(0) = head + current_line
                        If count = 1
                           ; Если в буфере была всего одна строка — клеим и "хвост"
                           *row\Str(0) + tail
                           *this\row\caret\start = Len(head + current_line)
                        EndIf
                     Else
                        ; Остальные строки добавляем как новые элементы
                        *row\mask &~ (#__mask_active | #__mask_edit)
                        *row = AddElement(*this\__rows())
                        *row\mask | (#__mask_active | #__mask_edit)
                        
                        If i = count
                           ; Последняя строка из буфера получает "хвост" старой строки
                           *row\Str(0) = current_line + tail
                           *this\row\caret\start = Len(current_line)
                        Else
                           *row\Str(0) = current_line
                        EndIf
                     EndIf
                     *row\mask | #__mask_change 
                  Next
                  PopListPosition(*this\__rows())
                  
                  *this\row\active[0] = *row
                  *this\row\active[1] = *row
                  *this\row\caret\stop = *this\row\caret\start
                  *this\mask | (#__mask_update)
               EndIf
               
         EndSelect
   EndSelect
   
   *this\mask | #__mask_redraw
EndProcedure

;-
Procedure resize_column(*this._s_WIDGET, *column._s_COLUMNS, new_w.i)
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
Procedure add_column(*this._s_WIDGET, Title.s, Width.i)
   If Not *this : ProcedureReturn : EndIf
   *this\column\height = 25
   
   AddElement(*this\__columns( ))
   *this\__columns( )\Title = Title
   *this\__columns( )\width = Width
   ; Мы не ставим x здесь, его поставит update_columns( ) перед отрисовкой
   
   ; Запоминаем текущий порядковый номер (0 для первой, 1 для второй и т.д.)
   *this\__columns( )\id = ListSize(*this\__columns( )) - 1 
   
   ; ГЛАВНОЕ: поднимаем флаги, чтобы redraw понял, что нужно пересчитать геометрию
   *this\mask | #__mask_update | #__mask_redraw
   ProcedureReturn @*this\__columns( )
EndProcedure

Procedure add_row(*this._s_WIDGET, Text.s = "", Index.i = -1, Level.i = 0, *start = 0, len.i = -1)
   Protected._s_ROWS *row
   If Not *this : ProcedureReturn : EndIf
   
   ; --- 1. Позиционирование (как мы обсуждали ранее) ---
   If Index < 0 Or Index > ListSize(*this\__rows()) - 1
      LastElement(*this\__rows())
      AddElement(*this\__rows())
   Else
      SelectElement(*this\__rows(), Index)
      InsertElement(*this\__rows())
   EndIf
   *row = @*this\__rows()
   
   *row\sublevel = Level
   Protected i, TotalCols = ListSize(*this\__columns()) - 1
   ReDim *row\Str(TotalCols)
   
   ; --- 2. Быстрый разбор ---
   ; Если передали указатель - берем его, иначе адрес строки Text
   If Not *start : *start = @Text : EndIf
   
   Protected *ptr.Character = *start
   Protected *colStart = *start
   Protected count.i = 0
   
   ; Если длина не указана - ищем конец строки (0 или LF)
   While i <= TotalCols
      ; Условие остановки: либо дошли до конца переданной длины, либо до спецсимвола
      If (len <> -1 And (*ptr - *start) >> 1 >= len) Or *ptr\c = 0
         *row\Str(i) = PeekS(*colStart, (*ptr - *colStart) >> 1)
         Break
      EndIf
      
      ; Разбор колонок через '|'
      If *ptr\c = #LF 
         *row\Str(i) = PeekS(*colStart, (*ptr - *colStart) >> 1)
         *colStart = *ptr + SizeOf(Character)
         i + 1
      EndIf
      
      *ptr + SizeOf(Character)
   Wend
   
   ;*row\sel = AllocateStructure(_s_SEL)
   *row\mask | #__mask_change
   *this\mask | (#__mask_update | #__mask_redraw | #__mask_change)
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

Procedure add_token(*row._s_ROWS, pos.l, len.l, color.l, font.i=0)
   If Not *row : ProcedureReturn : EndIf
   
   AddElement(*row\tokens())
   *row\tokens()\pos   = pos
   *row\tokens()\len   = len
   *row\tokens()\color = color
   *row\tokens()\font  = font  ; Записываем FontID(шрифта)
EndProcedure

;-
; Процедура для добавления ключевых слов
Procedure AddKeyword(word.s, color.l, font.i = 0)
   ; Если шрифт не указан, используем стандартный
   If font = 0 : font = Font_Editor_Bold : EndIf 
   
   ; Ключ карты — всегда маленькими (для поиска)
   Protected key.s = LCase(word)
   
   Theme\Keywords(key)\word  = word  ; Сохраняем как есть: "Structure"
   Theme\Keywords(key)\color = color ; Цвет
   Theme\Keywords(key)\font  = font  ; Шрифт
EndProcedure

; Процедура для массового добавления операторов
Procedure AddOperator(chars.s, color.l)
   Protected i.l, char.s
   ; Пробегаем по всей строке символов и каждый добавляем в карту
   For i = 1 To Len(chars)
      char = Mid(chars, i, 1)
      Theme\Operators(char) = color
   Next
EndProcedure

;-
Procedure.i AddColumn(*this._s_WIDGET, position.l, Text.s, Width.l, img.i = -1, Align.a = #__align_left)
   Protected._s_COLUMNS *coumn
   *coumn = add_column(*this, Text, Width);, img.i = -1)
   *coumn\Align = Align
   ProcedureReturn *coumn
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
      Repeat
         If *ptr\c = #LF Or *ptr\c = 0
            add_row(*this, "", -1, 0, *start, (*ptr - *start) >> 1)
            
            ; AddElement(*this\__rows())
            ; ReDim *this\__rows()\Str(TotalCols)
            ; *this\__rows()\Str(0) = PeekS(*start, (*ptr - *start) >> 1)
      
            If *ptr\c
               *start = *ptr + SizeOf(Character)
            Else
               Break
            EndIf
         EndIf
         *ptr + SizeOf(Character)
      ForEver
   EndIf
   
   ; Сбрасываем старое состояние
   *this\row\active[0] = 0
   *this\row\active[1] = 0
   
   ; Даем команду на пересчет координат и перерисовку
   *this\mask | #__mask_update | #__mask_redraw
EndProcedure

;-
Procedure update_token(*this._s_WIDGET, *row._s_ROWS)
   If Not *row : ProcedureReturn : EndIf
   
   ClearList(*row\tokens())
   Protected txt.s = *row\Str(0)
   Protected *c.Character = @txt
   Protected pos.l = 1, start.l
   Protected row_width.l = 0
   Protected max_row_h.l = 0
   Protected last_font = -1 
   Protected word.s
   
   ; Базовая высота (эталон)
   DrawingFont(Font_Editor_Normal)
   max_row_h = TextHeight("Ag")
   
   If (*this\mask & #__mask_tokken) = 0
      AddElement(*row\tokens())
      *row\tokens()\pos    = 1
      *row\tokens()\len    = Len(txt)
      *row\tokens()\x      = 0 ; Важно для расчетов каретки
      *row\tokens()\color  = Theme\Normal
      *row\tokens()\font   = 0 
      
      ; Текстовые замеры
      *row\tokens()\width  = TextWidth(txt)
      *row\tokens()\height = max_row_h
      
      *row\width  = *row\tokens()\width
      *row\height = *row\tokens()\height + (*this\padding\y * 2)
      If *row\height < 16 : *row\height = 16 : EndIf ; Держим минимальную высоту
      ProcedureReturn 
   EndIf
   
   
   While *c\c
      start = pos
      Protected cur_font = Font_Editor_Normal 
      Protected cur_color = Theme\Normal
      Protected is_comment.b = #False
      
      ; --- 1. ОПРЕДЕЛЯЕМ ТИП ТОКЕНА ---
      If *c\c = ' ' Or *c\c = 9
         While *c\c = ' ' Or *c\c = 9 : *c + SizeOf(Character) : pos + 1 : Wend
      ElseIf *c\c = ';'
         pos = Len(txt) + 1 
         cur_color = Theme\Comment
         is_comment = #True
         *c = @txt + (pos - 1) * SizeOf(Character)
      ElseIf *c\c = '"'
         *c + SizeOf(Character) : pos + 1 
         While *c\c And *c\c <> '"' : *c + SizeOf(Character) : pos + 1 : Wend
         If *c\c = '"' : *c + SizeOf(Character) : pos + 1 : EndIf 
         cur_color = Theme\String
      ElseIf *c\c = '#'
         *c + SizeOf(Character) : pos + 1
         While (*c\c >= 'a' And *c\c <= 'z') Or (*c\c >= 'A' And *c\c <= 'Z') Or (*c\c >= '0' And *c\c <= '9') Or *c\c = '_'
            *c + SizeOf(Character) : pos + 1
         Wend
         cur_color = Theme\Constant 
      ElseIf *c\c >= '0' And *c\c <= '9'
         While *c\c >= '0' And *c\c <= '9' : *c + SizeOf(Character) : pos + 1 : Wend
         cur_color = Theme\Number
      ElseIf (*c\c >= 'a' And *c\c <= 'z') Or (*c\c >= 'A' And *c\c <= 'Z') Or *c\c = '_'
         While (*c\c >= 'a' And *c\c <= 'z') Or (*c\c >= 'A' And *c\c <= 'Z') Or (*c\c >= '0' And *c\c <= '9') Or *c\c = '_'
            *c + SizeOf(Character) : pos + 1
         Wend
         word = Mid(txt, start, pos - start)
         If FindMapElement(Theme\Keywords(), LCase(word))
            Protected correct.s = Theme\Keywords()\word
            If word <> correct
               ; Добавляем флаг #PB_String_NoZero, чтобы не портить остаток строки
               PokeS(@txt + (start - 1) * SizeOf(Character), correct, Len(correct), #PB_String_NoZero)
               ; *row\Str(0) = txt 
               word = correct
            EndIf
            cur_color = Theme\Keywords()\color
            cur_font  = Theme\Keywords()\font
         EndIf
      Else 
         If FindMapElement(Theme\Operators(), Mid(txt, pos, 1))
            cur_color = Theme\Operators()
         EndIf
         *c + SizeOf(Character) : pos + 1
      EndIf
      
      ; --- 2. ГЕОМЕТРИЯ (Считаем один раз здесь) ---
      If last_font <> cur_font
         DrawingFont((cur_font))
         last_font = cur_font
      EndIf
      
      Protected t_width = TextWidth(Mid(txt, start, pos - start))
      Protected t_height = TextHeight("Ag")
      
      ; --- 3. ДОБАВЛЯЕМ ТОКЕН ---
      AddElement(*row\tokens())
      *row\tokens()\x      = row_width ; Записываем накопленный X
      *row\tokens()\pos    = start
      *row\tokens()\len    = pos - start
      *row\tokens()\color  = cur_color
      *row\tokens()\font   = cur_font
      *row\tokens()\width  = t_width 
      *row\tokens()\height = t_height
      
      row_width + t_width
      If t_height > max_row_h : max_row_h = t_height : EndIf
      
      If is_comment : Break : EndIf 
   Wend
   
   If *row\Str(0) <> txt 
      *row\Str(0) = txt 
   EndIf
   
   ; Финальные замеры строки сохраняем в структуру строки
   *row\width  = row_width ; Чистая ширина текста
   *row\height = max_row_h + (*this\padding\y * 2)
   If *row\height < 16 : *row\height = 16 : EndIf
EndProcedure

Procedure update_sel(*this._s_WIDGET, *row._s_ROWS)
   Protected *active._s_ROWS = *this\row\active[0]
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h  
   
   ; 1. Ленивое обновление токенов
   If *row\mask & #__mask_change 
      update_token(*this, *row)
      *row\mask &~ #__mask_change
      *row\mask | #__mask_update 
   EndIf
   
   ; Работаем только если взведен флаг обновления строки
   If *row\mask & #__mask_update
      Protected *start_r._s_ROWS = *this\row\active[1]
      Protected *end_r._s_ROWS   = *this\row\active[0]
      Protected caret_pos = *this\row\caret\start
      
      ; Debug ""+ *this\row\caret\stop +" "+ *this\row\caret\start +" "+ *start_r +" "+ *end_r
      
      If *start_r And *end_r
         Protected txt_active.s = *active\Str(0)
         Protected txt.s = *row\Str(0)
         Protected *txt_ptr = @txt
         Protected min_y = *start_r\y
         Protected max_y = *end_r\y
         Protected is_down = Bool(max_y >= min_y)
         If Not is_down : Swap min_y, max_y : EndIf
         
         ; --- 1. ОПРЕДЕЛЕНИЕ ИНДЕКСОВ СИМВОЛОВ ---
         If *row = *start_r And *row = *end_r
            *row\sel\start = Min(*this\row\caret\stop, *this\row\caret\start)
            *row\sel\stop   = Max(*this\row\caret\stop, *this\row\caret\start)
         ElseIf *row\y < min_y Or *row\y > max_y
            *row\sel\start = 0 : *row\sel\stop = 0
         ElseIf *row\y > min_y And *row\y < max_y
            *row\sel\start = 0 : *row\sel\stop = MemoryStringLength(*txt_ptr)
         ElseIf *row = *start_r
            If is_down : *row\sel\start = *this\row\caret\stop : *row\sel\stop = MemoryStringLength(*txt_ptr)
               Else    : *row\sel\start = 0 : *row\sel\stop = *this\row\caret\stop : EndIf
         ElseIf *row = *end_r
            If is_down : *row\sel\start = 0 : *row\sel\stop = *this\row\caret\start
               Else    : *row\sel\start = *this\row\caret\start : *row\sel\stop = MemoryStringLength(*txt_ptr) : EndIf
         EndIf
         
         ; --- 2. РАСЧЕТ ПИКСЕЛЕЙ ВЫДЕЛЕНИЯ (ДЛЯ ТЕКУЩЕЙ СТРОКИ) ---
         ;          If *rw\sel\start > 0
         ;             *rw\sel\x = TextWidth(Left(txt, *rw\sel\start))
         ;          Else
         ;             *rw\sel\x = 0
         ;          EndIf
         ;          If *rw\sel\start = *rw\sel\stop
         ;             *rw\sel\width = 0
         ;          Else
         ;             *rw\sel\width = TextWidth(Mid(txt, *rw\sel\start + 1, *rw\sel\stop - *rw\sel\start))
         ;          EndIf
         
         If *row\sel\start = *row\sel\stop And *row\sel\start = 0
            *row\sel\x = 0 : *row\sel\width = 0
         Else
            If ListSize(*row\tokens()) = 0
               DrawingFont(Font_Editor_Normal)
               *row\sel\x = TextWidth(Mid(txt, 1, *row\sel\start))
               *row\sel\width = TextWidth(Mid(txt, *row\sel\start + 1, *row\sel\stop - *row\sel\start))
            Else
               Protected x1 = -1, x2 = -1
               PushListPosition(*row\tokens())
               ForEach *row\tokens()
                  Protected ts = *row\tokens()\pos
                  Protected tl = *row\tokens()\len
                  
                  ; Ищем X для начала выделения
                  If x1 = -1 And *row\sel\start >= ts - 1 And *row\sel\start < ts + tl
                     If *row\tokens()\font : DrawingFont(*row\tokens()\font) : Else : DrawingFont(Font_Editor_Normal) : EndIf
                     x1 = *row\tokens()\x + TextWidth(Mid(txt, ts, *row\sel\start - ts + 1))
                  EndIf
                  
                  ; Ищем X для конца выделения
                  If x2 = -1 And *row\sel\stop >= ts - 1 And *row\sel\stop < ts + tl
                     If *row\tokens()\font : DrawingFont(*row\tokens()\font) : Else : DrawingFont(Font_Editor_Normal) : EndIf
                     x2 = *row\tokens()\x + TextWidth(Mid(txt, ts, *row\sel\stop - ts + 1))
                  EndIf
                  
                  If x1 <> -1 And x2 <> -1 : Break : EndIf
               Next
               
               ; Если индексы за пределами последнего токена (конец строки)
               If x1 = -1 : x1 = *row\width : EndIf 
               If x2 = -1 : x2 = *row\width : EndIf
               
               PopListPosition(*row\tokens())
               
               *row\sel\x = x1 
               *row\sel\width = x2 - x1
            EndIf
         EndIf
         
         ; --- 3. РАСЧЕТ КАРЕТКИ И СКРОЛЛИНГ (ТОЛЬКО ЕСЛИ СТРОКА АКТИВНА) ---
         If *row = *active And Not *this\mask & #__mask_drag 
            Protected edit_caret_x = *this\row\caret\x
            
            If caret_pos <= 0
               *this\row\caret\x = 0
            Else
               If ListSize(*active\tokens()) = 0
                  DrawingFont(Font_Editor_Normal)
                  *this\row\caret\x = TextWidth(Mid(txt_active, 1, caret_pos))
               Else
                  PushListPosition(*active\tokens())
                  ForEach *active\tokens()
                     ts = *active\tokens()\pos : tl = *active\tokens()\len
                     ; Если каретка внутри этого токена
                     If caret_pos >= ts - 1 And caret_pos < ts + tl
                        If *active\tokens()\font : DrawingFont(*active\tokens()\font) : Else : DrawingFont(Font_Editor_Normal) : EndIf
                        
                        ; X каретки = Начало токена + смещение внутри него
                        *this\row\caret\x = *active\tokens()\x + TextWidth(Mid(txt_active, ts, caret_pos - ts + 1))
                        Break
                     EndIf
                  Next
                  
                  ; Если каретка в самом конце строки (за последним токеном)
                  If ListIndex(*active\tokens()) = ListSize(*active\tokens()) - 1 And caret_pos >= ts + tl - 1
                     *this\row\caret\x = *active\width
                  EndIf
                  
                  PopListPosition(*active\tokens())
               EndIf
            EndIf
            
            
            ;*h\max + (*this\row\caret\x-edit_caret_x)
            
            ; СКРОЛЛИНГ
            Protected offset = *this\padding\x + (*active\sublevel * *this\row\indent)
            If (*active\mask & #__mask_node) : offset + 15 : EndIf
            Protected cx = *this\row\caret\x + offset
            Protected view_w = *this\width - Bool(*v\max > 0) * *this\fs[3]
            
            If *h\pos < cx - view_w + *this\padding\x : *h\pos = cx - view_w + *this\padding\x
               ElseIf *h\pos > cx - *this\padding\x : *h\pos = cx - *this\padding\x : EndIf
            If *h\pos < 0 : *h\pos = 0 : ElseIf *h\pos > *h\max : *h\pos = *h\max : EndIf
            
            ; Debug *this\row\caret\x
         EndIf
      EndIf
      *row\mask &~ #__mask_update
   EndIf
EndProcedure

Procedure update_nodes(*this._s_WIDGET)
   PushListPosition(*this\__rows( ))
   ForEach *this\__rows( )
      Protected current_level = *this\__rows( )\sublevel
      *this\__rows( )\mask &~ #__mask_node ; Сбрасываем старый флаг
      
      ; Заглядываем в следующую строку
      If NextElement(*this\__rows( ))
         If *this\__rows( )\sublevel > current_level
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

Procedure update_rows(*this._s_WIDGET)
   If Not *this : ClearList(*this\__items( )) : ProcedureReturn : EndIf
   Protected._s_ROWS *row
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   
   If *this\Type = #__type_Tree
      update_nodes(*this)
   EndIf
   ClearList(*this\__items( ))
   *this\visible\first = 0
   *this\visible\last = 0
   
   Protected max_w = 0 
   Protected cur_y = *this\column\height 
   Protected view_top = *v\pos
   Protected view_bottom = view_top + *this\height - *this\column\height
   Protected skip_level = -1 ; Заменил Static на Protected для многопоточности/многооконности
   
   ForEach *this\__rows( )
      *row = @*this\__rows( )
      
      ; --- 1. ЛОГИКА СХЛОПЫВАНИЯ ---
      If *this\row\indent
         If skip_level <> -1
            If *row\sublevel > skip_level : Continue : Else : skip_level = -1 : EndIf
         EndIf
         If (*row\mask & #__mask_node) And (*row\mask & #__mask_collapsed)
            skip_level = *row\sublevel
         EndIf
      EndIf
      
      ; --- 2. ОБНОВЛЕНИЕ ДАННЫХ (Ленивое) ---
      If *row\mask & #__mask_change 
         update_token(*this, *row)
         *row\mask &~ #__mask_change
         *row\mask | #__mask_update    ; А вот координаты каретки теперь надо пересчитать!
      EndIf
      
      ; --- 3. ГЕОМЕТРИЯ (Просто чтение готового) ---
      *row\y = cur_y
      
      ; Расчет горизонтального отступа
      Protected offset = *this\padding\x + (*row\sublevel * *this\row\indent)
      If (*row\mask & #__mask_node) : offset + 15 : EndIf
      
      ; Общая ширина строки для скроллбара
      Protected row_full_w = offset + *row\width + *this\padding\x
      If row_full_w > max_w : max_w = row_full_w : EndIf
      
      ; --- 4. ПРОВЕРКА ВИДИМОСТИ ---
      Protected r_top = *row\y - *this\column\height
      Protected r_bottom = r_top + *row\height 
      
      If r_bottom > view_top And r_top < view_bottom 
         AddElement(*this\__items())
         *this\__items() = *row
         
         If Not *this\visible\first : *this\visible\first = *row : EndIf
         *this\visible\last = *row
      EndIf
      
      cur_y + *row\height 
   Next
   
   ; --- 5. ФИКСИРУЕМ СКРОЛЛБАРЫ ---
   Protected v_bar_w = 0 : If (cur_y - *this\column\height) > (*this\height - *this\column\height) : v_bar_w = *this\fs[3] : EndIf
   Protected h_bar_h = 0 : If max_w > (*this\width - v_bar_w) : h_bar_h = *this\fs[4] : EndIf
   
   ; Пересчет максов
   Protected view_w = *this\width - v_bar_w
   Protected view_h = *this\height - *this\column\height - h_bar_h
   
   *v\max = (cur_y - *this\column\height) - view_h : If *v\max < 0 : *v\max = 0 : EndIf
   If ListSize(*this\__columns()) <= 1
      If max_w < *this\width
         max_w = *this\width
      EndIf
      *h\max = max_w - view_w : If *h\max < 0 : *h\max = 0 : EndIf
      
      ; Синхронизация единственной колонки (если надо)
      FirstElement(*this\__columns())
      *this\__columns()\Width = max_w 
   EndIf
EndProcedure

Procedure update_tab(*this._s_WIDGET)
   Protected tw, th, tw_all = 0, count = 0
   Protected._s_TABS *tab
   
   PushListPosition(*this\__tabs())
   
   ; 1. ЗАМЕРЯЕМ ВСЁ
   ForEach *this\__tabs()
      *tab = @*this\__tabs()
      If *tab\mask & #__mask_hidden : Continue : EndIf
      
      tw = TextWidth(*tab\title)
;       th = TextWidth("Ay")
      ;*tab\th = th
      ;*tab\tw = tw
      *tab\width = tw + *this\padding\x * 2
      
      ; Локальное выравнивание текста внутри таба
      If *this\text\align & #__align_center
         *tab\tx = (*tab\width - tw) / 2
      ElseIf *this\text\align & #__align_right
         *tab\tx = *tab\width - tw - *this\padding\x
      Else
         *tab\tx = *this\padding\x 
      EndIf
      
;       ; Локальное выравнивание текста внутри таба
;       If *this\text\align & #__align_center
;          *tab\ty = (*tab\height - th) / 2
;       ElseIf *this\text\align & #__align_bottom
;          *tab\ty = *tab\height - th - *this\padding\y
;       Else
;          *tab\ty = *this\padding\y 
;       EndIf
      
      tw_all + *tab\width
      If count > 0 : tw_all + *this\tab\spacing : EndIf
      count + 1
   Next
   
   *this\tab\totalwidth = tw_all
   
   ; 2. СЧИТАЕМ СТАРТОВЫЙ ОТСТУП
   Protected start_offset = 0
   If *this\tab\align & #__align_right
      start_offset = *this\Width - tw_all - *this\tab\indent - 1
   ElseIf *this\tab\align & #__align_center
      start_offset = (*this\Width - tw_all) / 2
   Else
      start_offset = *this\tab\indent
   EndIf
   
   ; 3. РАССТАВЛЯЕМ ТАБЫ
   Protected cur_x = start_offset
   ForEach *this\__tabs()
      If *this\__tabs()\mask & #__mask_hidden : Continue : EndIf
      *this\__tabs()\x = cur_x
      cur_x + *this\__tabs()\width + *this\tab\spacing
   Next
   
   PopListPosition(*this\__tabs())
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
         Protected max_w = #COL_MIN_WIDTH ; Минимальная базовая ширина
         Protected col_idx = *this\__columns()\id
         
         ; Сканируем строки (в идеале — только видимые или первые N для скорости)
         PushListPosition(*this\__rows())
         ForEach *this\__rows()
            Protected text_w = TextWidth(*this\__rows()\Str(col_idx))
            
            ; Если это первая колонка, учитываем отступ дерева
            If col_idx = 0 And *this\row\indent > 0
               text_w + (*this\__rows()\sublevel * *this\row\indent) + #COL_AUTO_PAD*2 ; + иконка
            EndIf
            
            If text_w > max_w : max_w = text_w : EndIf
         Next
         PopListPosition(*this\__rows())
         
         *this\__columns()\Width = max_w + #COL_AUTO_PAD ; + небольшой паддинг справа
      EndIf
      
      ; --- 2. РАСЧЕТ ГЕОМЕТРИИ ---
      *this\__columns()\x = cur_x
      cur_x + *this\__columns()\Width
   Next
   
   ; 3. cur_x теперь равен ОБЩЕЙ ширине всех колонок.
   ; Вычисляем макс для горизонтального скролла:
   ; (Общая ширина) - (Ширина виджета - место под вертикальный скролл)
   Protected v_bar_w = 0
   If *this\scroll\v\max > 0 : v_bar_w = *this\fs : EndIf
   
   *h\max = cur_x - (*this\width - v_bar_w)
   
   ; Если контент уже виджета, сбрасываем макс в 0
   If *h\max < 0 : *h\max = 0 : EndIf
   
   ; Если скролл уехал дальше нового максимума (например, при уменьшении ширины)
   If *h\pos > *h\max : *h\pos = *h\max : EndIf
EndProcedure

Procedure update_level(*this._s_WIDGET, new_level.l)
   Protected *child._s_WIDGET
   *this\level = new_level
   
   ; Рекурсивно обновляем всех детей
   *child = *this\first
   While *child
      update_level(*child, new_level + 1)
      *child = *child\next
   Wend
EndProcedure


;-
Procedure draw_scroll(*this._s_WIDGET, vertical.b, rx.l, ry.l)
   Protected *v._s_BAR = @*this\scroll\v
   Protected *h._s_BAR = @*this\scroll\h
   
   Protected mx = mouse()\x - rx
   Protected my = mouse()\y - ry
   Protected is_hover.b = #False
   
   ; Цвета
   Protected color_bg = $F0F0F0     
   Protected color_thumb = $CDCDCD  
   
   ; Определяем наличие "соседа" для корректной отрисовки длины
   Protected fsv.l = 0 : If *v\max > 0 : fsv = *this\fs[3] : EndIf
   Protected fsh.l = 0 : If *h\max > 0 : fsh = *this\fs[4] : EndIf
   
   If vertical
      If *v\max > 0
         If Not (*this\mask & #__mask_drag)
            is_hover = Bool(mx > (*this\width - *this\fs[3]) And mx <= *this\width And 
                            my > *this\column\height And my <= (*this\height - fsh))
         EndIf
         
         Protected.f view_h = *this\height - *this\column\height - fsh
         Protected.f total_h = *v\max + view_h
         
         ; Сохраняем высоту ползунка в структуру
         *v\thumb_h = view_h * (view_h / total_h)
         If *v\thumb_h < 20 : *v\thumb_h = 22 : EndIf
         
         Protected.f scroll_ratio = *v\pos / *v\max
         Protected thumb_y = ry + *this\column\height + scroll_ratio * (view_h - *v\thumb_h)
         
         If *v\is_drag 
            color_thumb = $808080 
         ElseIf is_hover
            color_thumb = $A0A0A0 
         EndIf
         
         DrawingMode(#PB_2DDrawing_Default)
         Box(rx + *this\width - *this\fs[3] - 1, ry + *this\column\height, *this\fs[3], view_h, color_bg)
         Box(rx + *this\width - *this\fs[3] + 3, thumb_y, *this\fs[3] - 6, *v\thumb_h, color_thumb)
      EndIf
      
   Else
      If *h\max > 0
         If Not (*this\mask & #__mask_drag)
            is_hover = Bool(my > (*this\height - *this\fs[4]) And my <= *this\height And 
                            mx > *this\fs[1] And mx <= (*this\width - fsv))
         EndIf
         
         Protected.f view_w = *this\width - *this\fs[1] - fsv
         Protected.f total_w = *h\max + view_w
         
         ; Сохраняем ширину ползунка в структуру (УБРАНО Protected thumb_w)
         *h\thumb_w = view_w * (view_w / total_w)
         If *h\thumb_w < 20 : *h\thumb_w = 22 : EndIf
         
         Protected.f scroll_ratio_h = *h\pos / *h\max
         Protected thumb_x = rx + *this\fs[1] + scroll_ratio_h * (view_w - *h\thumb_w)
         
         If *h\is_drag 
            color_thumb = $808080
         ElseIf is_hover
            color_thumb = $A0A0A0
         EndIf
         
         DrawingMode(#PB_2DDrawing_Default)
         Box(rx + *this\fs[1], ry + *this\height - *this\fs[4]-1, view_w, *this\fs[4], color_bg)
         Box(thumb_x, ry + *this\height - *this\fs[4] + 3, *h\thumb_w, *this\fs[4] - 6, color_thumb)
      EndIf
   EndIf
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
   th = TextHeight("Ay")
   
   ; Центрируем по вертикали всегда
   ty = ry + (*this\Height - th) / 2
   
   ; Выбираем rx по горизонтали
   If *this\text\align & #__align_right
      tx = rx + *this\Width - tw - *this\padding\X
   ElseIf *this\text\align & #__align_center
      tx = rx + (*this\Width - tw) / 2
   Else
      tx = rx + *this\padding\X 
   EndIf

   ; Рисуем текст по центру кнопки
   DrawingMode(#PB_2DDrawing_Transparent)
   DrawText(tx + text_shift, ty + text_shift, *this\class, $333333, $EAEAEA)
EndProcedure

Procedure draw_tab(*this._s_WIDGET, rx.l, ry.l)
   Protected th = TextHeight("Ay") ; Высоту строки можно тоже в Update, если шрифт не меняется
   Protected color, txtColor
   Protected active_x = -1, active_w = 0 
   
   PushListPosition(*this\__tabs())
   ForEach *this\__tabs()
      Protected *tab._s_TABS = @*this\__tabs()
      If *tab\mask & #__mask_hidden : Continue : EndIf
      
      ; Координата на экране (сложение — это мгновенно)
      Protected cur_x = rx + *tab\x - *this\scroll\x
      
      color = ChangeColor(*this\Type, *tab\mask, #PB_Gadget_BackColor)
      txtColor = ChangeColor(*this\Type, *tab\mask, #PB_Gadget_FrontColor)
      
      ; Отрисовка
      Box(cur_x, ry, *tab\width, *this\Height, color)
      DrawText(cur_x + *tab\tx, ry + (*this\Height - th)/2, *tab\title, txtColor, color)
      ;DrawText(cur_x + *tab\tx, ry + *tab\ty, *tab\title, txtColor, color)
      
      ; Рамка
      Line(cur_x, ry, *tab\width, 1, $CCCCCC) 
      Line(cur_x, ry, 1, *this\Height, $CCCCCC)                   
      Line(cur_x + *tab\width, ry, 1, *this\Height, $CCCCCC) 
      
      If *tab\mask & #__mask_active
         active_x = cur_x : active_w = *tab\width
      EndIf
   Next
   PopListPosition(*this\__tabs())
   
   ; Линия-разделитель
   Line(rx, ry + *this\Height, *this\Width, 1, $CCCCCC)
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
   Protected dx = rx - *this\scroll\h\pos 
   
   ; 1. Рисуем фон всей шапки (статично)
   Box(rx, ry, *this\Width, *this\column\height, #COL_COLOR_BACK_NORMAL)
   
   ; 2. Заходим в цикл отрисовки колонок
   ForEach *this\__columns()
      Protected *column._s_COLUMNS = @*this\__columns()
      Protected col_x = dx + *column\x
      Protected col_w = *column\Width
      
      ; Проверка видимости колонки в окне виджета
      If (col_x + col_w) > *this\clip\x And col_x < (*this\clip\x + *this\clip\width)
         
         ; Рассчитываем клип для ТЕКСТА (чтобы он не вылазил на соседние колонки)
         Protected clip_x = Max(col_x, *this\clip\x)
         Protected clip_w = Min(col_x + col_w, *this\clip\x + *this\clip\width) - clip_x
         
         If clip_w > 0
            ; --- СЛОЙ 1: ТЕКСТ (в узком клипе) ---
            ClipOutput(clip_x, *this\clip\y, clip_w, *this\clip\height)
            
            ; Рисуем фон ячейки (если нужно, например при Hover)
            If *column\mask & #__mask_hover
               Box(col_x, ry, col_w, *this\column\height, #COL_COLOR_BACK_HOVER)
            EndIf
            
            Define tx, tw = TextWidth(*column\Title)
            If *column\align & #__align_right
               tx = col_x + *column\Width - tw - *this\padding\x
            ElseIf *column\align & #__align_center
               tx = col_x + (*column\Width - tw) / 2
            Else
               tx = col_x + *this\padding\x
            EndIf

            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText(tx, ry + *this\padding\y, *column\Title, #COL_COLOR_TEXT)
            
            ; --- СЛОЙ 2: ЛИНИЯ СЕТКИ (в широком клипе) ---
            ; Сначала возвращаем клип виджета, чтобы линия не "отсеклась" 
            ; по правой границе текста (которая на 1 пиксель левее линии)
            Clip(*this) 
            
            ; Теперь рисуем вертикальную линию
            DrawingMode(#PB_2DDrawing_Default)
            Line(col_x + col_w - 1, ry, 1, *this\height, #COL_COLOR_LINE)
         EndIf
      EndIf
   Next
   
   ; Линия отделения шапки от строк
   Line(rx, ry + *this\column\height - 1, *this\Width, 1, #COL_COLOR_BORDER)
EndProcedure

Procedure draw_rows(*this._s_WIDGET, rx.l, ry.l)
   If Not *this\visible\first : ProcedureReturn : EndIf
   
   ; 1. Реактивный скролл (делаем один раз перед циклом)
   If *this\row\active[0] And 
      *this\row\active[0]\mask & (#__mask_change | #__mask_update)
      update_sel(*this, *this\row\active[0])
   EndIf
   
   Protected._s_rows *row
   Protected._s_COLUMNS *column
   Protected *v._s_BAR = *this\scroll\v
   Protected *h._s_BAR = *this\scroll\h
   Protected dx = rx - *h\pos
   
   ChangeCurrentElement(*this\__items(), *this\visible\first)
   Repeat 
      *row = @*this\__items()
      If Not *row : Break : EndIf
      
      ; --- ЛОГИКА ОБНОВЛЕНИЯ (Ленивая) ---
      If *row\mask & (#__mask_change | #__mask_update)
         update_sel(*this, *row)
      EndIf
      
      Protected dy = ry + (*row\y - *v\pos)
      
      ; --- 1. ФОН СТРОКИ ---
      Box(rx + 1, dy, *this\width - 2, *row\height - 1, ChangeColor(*this\Type, *row\mask, #PB_Gadget_BackColor, ListIndex(*this\__items())))
      
      ; --- 2. ЦИКЛ ПО КОЛОНКАМ ---
      PushListPosition(*this\__columns())
      ForEach *this\__columns()
         *column = @*this\__columns()
         
         Protected col_x = dx + *column\x
         Protected col_w = *column\Width
         Protected data_idx = *column\id
         
         If col_x + col_w > rx And col_x < rx + *this\Width
            ; Клиппинг
            Protected clip_x = Max(col_x, *this\clip\x) 
            Protected clip_y = Max(dy, *this\clip\y)
            Protected clip_w = Min(col_x + col_w, *this\clip\x + *this\clip\width) - clip_x
            Protected clip_h = Min(dy + *row\height, *this\clip\y + *this\clip\height) - clip_y
            
            If clip_w > 0 And clip_h > 0
               ClipOutput(clip_x, clip_y, clip_w, clip_h)
               
               If data_idx <= ArraySize(*row\Str())
                  Protected txt.s = *row\Str(data_idx)
                  Protected offset = *this\padding\x
                  
                  ; --- РИСУЕМ ТЕКСТ (ПОВЕРХ) ---
                  DrawingMode(#PB_2DDrawing_Transparent)
                  
                  ; 1. ПЕРЕСЧИТЫВАЕМ OFFSET (Твоя оригинальная логика дерева)
                  If *this\row\indent > 0 And data_idx = 0
                     offset = *this\padding\x + (*row\sublevel * *this\row\indent)
                     
                     If (*row\mask & #__mask_node)
                        Protected tx = col_x + offset
                        Protected ty = dy + (*row\height / 2) - 4
                        FrontColor($888888)
                        
                        If *row\mask & #__mask_collapsed
                           Line(tx, ty, 1, 9) : Line(tx, ty, 5, 4) : Line(tx, ty + 8, 5, -4)
                        Else
                           Line(tx, ty + 2, 9, 1) : Line(tx, ty + 2, 4, 5) : Line(tx + 8, ty + 2, -4, 5)
                        EndIf
                        offset + 15
                     EndIf
                  EndIf
                    
                  ; 2. РИСУЕМ ВЫДЕЛЕНИЕ (Под текстом)
                  If *this\row\active[1] And data_idx = 0
                     If *row\mask & #__mask_edit
                        Protected s_x = col_x + offset + *row\sel\x
                        If *this\row\active[1]\y > *this\row\active[0]\y And *row <> *this\row\active[1] Or 
                           (Len(txt) = *row\sel\stop And *row\y < *this\row\active[0]\y)
                           Box(s_x, dy + 2, *row\sel\width + 7, *row\height - 4, #COLOR_BACK_SELECTED)
                        Else
                           Box(s_x, dy + 2, *row\sel\width, *row\height - 4, #COLOR_BACK_SELECTED)
                        EndIf
                     EndIf
                  EndIf
                  
                  Protected  text_y 
                  ; 3. РИСУЕМ ТОКЕНЫ И СЧИТАЕМ CARET_X
                  If ListSize(*row\tokens()) > 0 And data_idx = 0
                     Protected cur_x = col_x + offset
                     Protected last_font = -1
                     
                     ForEach *row\tokens()
                        ; ОПТИМИЗАЦИЯ ШРИФТА
                        If last_font <> *row\tokens()\font
                           last_font = *row\tokens()\font
                           If last_font : DrawingFont(last_font) : Else : DrawingFont(Font_Editor_Normal) : EndIf
                        EndIf
                        
                        ; Внутри цикла ForEach *row\tokens()
                        Protected token_txt.s = Mid(txt, *row\tokens()\pos, *row\tokens()\len)
                        
                        ; Считаем Y так, чтобы текст был по центру высоты строки (учитывая падинги)
                        text_y = dy + (*row\height - *row\tokens()\height) / 2
                        
                        ; РИСУЕМ (Используем твой макрос Mid/PeekS)
                        cur_x = col_x + offset + *row\tokens()\x
                        DrawText(cur_x, text_y, token_txt, *row\tokens()\color)
                        
                        ;cur_x + *row\tokens()\Width 
                     Next
                  Else
                     ; Если токенов нет
                     DrawingFont(Font_Editor_Normal)
                     text_y = dy + (*row\height - TextHeight("Ay")) / 2
                     
                     Define tx, tw = TextWidth(txt)
                     If *column\align & #__align_right
                        tx = col_x + *column\Width - tw - *this\padding\x
                     ElseIf *column\align & #__align_center
                        tx = col_x + (*column\Width - tw) / 2
                     Else
                        tx = col_x + offset
                     EndIf

                     DrawText(tx, text_y, txt, #COLOR_TEXT_NORMAL)
                  EndIf
                  
                  ; 4. РИСУЕМ КАРЕТКУ
                  If *row\mask & #__mask_edit 
                     If *this\mask & #__mask_active And *row\mask & #__mask_active 
                        Line(col_x + offset + *this\row\caret\x, dy + 2, 1, *row\height - 4, $000000)
                     EndIf
                  Else
                     ; --- ЛИНИЯ ПОД МЫШЬЮ (DRAG) ---
                     If *this\mask & #__mask_drag And *row\mask & #__mask_hover And Not *row\mask & #__mask_active 
                        Protected mid_y = dy + (*row\Height / 2)
                        Line(*this\clip\x+2, mid_y, *this\clip\width-4, 1, $FF0000)
                        Line(*this\clip\x+2, mid_y-3, 1, 7, $FF0000)
                        Line(*this\clip\x + *this\clip\width - 2, mid_y-3, 1, 7, $FF0000)
                     EndIf
                  EndIf
               EndIf
               
               Clip(*this) ; Сброс клипа для следующей итерации
            EndIf
         EndIf
      Next
      PopListPosition(*this\__columns())
      
      ; Разделитель строк
      Line(rx, dy + *row\height - 1, *this\Width, 1, #ROW_COLOR_LINE)
      
      If *row = *this\visible\last : Break : EndIf
   Until NextElement(*this\__items()) = 0 
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
         If *this\font : DrawingFont(*this\font) : EndIf 
         
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
         
         ; не уверень что нужно
         If *this\mask & #__mask_change
            ; Пробегаем по всем строкам данных и обновляем только помеченные
            PushListPosition(*this\row\__s())
            ForEach *this\row\__s()
               If *this\row\__s()\mask & #__mask_change
                  update_token(*this, @*this\row\__s())
                  *this\row\__s()\mask &~ #__mask_change
               EndIf
            Next
            PopListPosition(*this\row\__s())
            
            *this\mask &~ #__mask_change
         EndIf
         
         ;
         ; Расчет геометрии (если нужно)
         If *this\mask & #__mask_update
            If *this\tabbar
               update_tab(*this\tabbar)
            EndIf
            
            If *this\column
               If ListSize(*this\__columns()) > 1
                  update_columns(*this)
               EndIf
               If *this\row
                  update_rows(*this)
               EndIf
            EndIf
            
            *this\mask &~ #__mask_update
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
            ;If *this\row\height
            ; --- СЛОИ ОТРИСОВКИ ---
            ; Слой 1: Фон и данные строк
            DrawingMode(#PB_2DDrawing_Default)
            draw_rows(*this, rx, ry) 
            ;EndIf
            
            If *this\column\height
               ; Слой 2: Шапка и вертикальные линии сетки
               DrawingMode(#PB_2DDrawing_Default)
               draw_columns(*this, rx, ry) 
            EndIf
            
            ; Слой 3: Внешняя рамка виджета (рисуем ПОВЕРХ всего)
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(rx, ry, *this\Width, *this\height , $CCCCCC) ; Цвет рамки
         EndIf
         
         ; Теперь рисуем скроллбары поверх всего, в границах виджета
         If *this\Scroll
            If *this\Scroll\v\max > 0
               draw_scroll(*this, 1, rx, ry) ; Вертикальный
            EndIf
            If *this\Scroll\h\max > 0
               draw_scroll(*this, 0, rx, ry) ; Горизонтальный
            EndIf
         EndIf
         
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
Procedure swap_column(*this._s_WIDGET, *pressed_column._s_COLUMNS, *hover_column._s_COLUMNS, mx.i)
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
      *this\mask | (#__mask_update | #__mask_redraw)
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

Procedure.i GetParent( *this._s_WIDGET )
   ProcedureReturn *this\parent
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
   If *parent And tabpage = #PB_Default : tabpage = *parent\tabpage : EndIf
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
   
   If *parent : update_level(*new, *parent\level + 1) : Else : update_level(*new, 0) : EndIf
   
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

;-
Procedure tab_state(*this._s_WIDGET, tabpage.l)
   Protected *g._s_WIDGET ; Локальный указатель для этого уровня рекурсии
   If Not *this : ProcedureReturn : EndIf
   If *this\tabbar : *this\tabpage = tabpage : EndIf
   
   Start(*g, *this)
   ; 1. Логика видимости
   hidden(*g, *this, *g\tabindex) 
   
   ; 2. Рекурсия (каждый вызов создаст свой *g на стеке)
   If *g = *this\areabar
      tab_state(*g, tabpage) 
   ElseIf *g\tabbar
      tab_state(*g, *g\tabpage)
   EndIf
   Stop(*g, *this)
EndProcedure

; Скрыть/Показать вкладку
Procedure hide_tab(*this._s_WIDGET, Index.l, state.b = #True)
   If Not *this Or *this\Type <> #__type_Panel : ProcedureReturn : EndIf
   
   PushListPosition(*this\__tabs())
   If SelectElement(*this\__tabs(), Index)
      If state
         *this\__tabs()\mask | #__mask_hidden
         ; Если скрыли активную — прыгаем на первую попавшуюся видимую
         If *this\tabpage = Index : tab_state(*this, 0) : EndIf
      Else
         *this\__tabs()\mask &~ #__mask_hidden
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
         *this\__tabs()\mask &~ #__mask_hover ; Сразу гасим ховер, если он был
      Else
         *this\__tabs()\mask &~ #__mask_disabled
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
   Protected tx = rx - *this\scroll\x
   Protected *found_tab = 0 
   
   ; Проверка попадания в сам прямоугольник Таббара
   If mx >= rx And mx <= rx + *this\Width And my >= ry And my <= ry + *this\Height
      PushListPosition(*this\__tabs())
      ForEach *this\__tabs()
         If *this\__tabs()\mask & #__mask_hidden : Continue : EndIf
         
         ; Проверяем конкретную вкладку
         If mx >= tx + *this\__tabs()\x And mx <= tx + *this\__tabs()\x + *this\__tabs()\width
            If Not (*this\__tabs()\mask & #__mask_disabled)
               *found_tab = @*this\__tabs()
            EndIf
            Break 
         EndIf
      Next
      PopListPosition(*this\__tabs())
   EndIf
   
   ProcedureReturn *found_tab 
EndProcedure

Procedure.i hover_column(*this._s_WIDGET, mx.i, my.i)
   Protected *res
   If *this\column\height
      mx - *this\real\x
      my - *this\real\y
      
      ; Проверяем только в области шапки
      If my >= 0 And my < *this\column\height
         PushListPosition(*this\__columns( ))
         ForEach *this\__columns( )
            ; Проверка на тело колонки
            If mx >= *this\__columns( )\x And mx < (*this\__columns( )\x + *this\__columns( )\Width)
               *res = @*this\__columns( )
               Break
            EndIf
         Next
         PopListPosition(*this\__columns( ))
      EndIf
   EndIf
   ProcedureReturn *res
EndProcedure

Procedure.i hover_row(*this._s_WIDGET, my.i)
   Protected *res
   ; Локальная координата внутри виджета
   my = (my - *this\real\y) + *this\scroll\v\pos
   
   ; Становимся на первую видимую строку
   PushListPosition(*this\__items())
   If *this\visible\first
      ChangeCurrentElement(*this\__items(), *this\visible\first)
      
      ; Перебираем только до последней видимой
      Repeat
         Protected *row._s_rows = @*this\__items()
         If my >= *row\y And my < (*row\y + *row\height)
            *res = *row
            Break
         EndIf
         
         If *row = *this\visible\last : Break : EndIf
      Until Not NextElement(*this\__items())
   EndIf
   PopListPosition(*this\__items())
   
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
Procedure key_events(*this._s_WIDGET, event.i)
   If Not *this : ProcedureReturn : EndIf
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   
   ; Нам нужно знать, какая строка сейчас активна (фокус)
   Protected *row._s_rows = *this\row\active[0]
   If *row And *row\mask & #__mask_edit
      ProcedureReturn edit_key_events(*this, *row, event)
   EndIf
   
EndProcedure


;-
Procedure tab_events(*this._s_WIDGET, event)
   Protected._s_TABS *tab
   Static._s_TABS *hover_tab
   Static._s_TABS *pressed_tab
   
   Select event
      Case #PB_EventType_MouseLeave
         ; Если мышь совсем ушла с виджета
         If *hover_tab
            *this\mask | #__mask_redraw
            *hover_tab\mask &~ #__mask_hover
            *hover_tab = 0
         EndIf
         
      Case #PB_EventType_MouseMove
         *tab = hover_tab(*this, mouse( )\x, mouse( )\y)
         If *hover_tab <> *tab
            ; 1. Уходим со старой вкладки
            If *hover_tab
               *hover_tab\mask &~ #__mask_hover
            EndIf
            ; 2. Заходим на новую
            If *tab
               *tab\mask | #__mask_hover
            EndIf
            ; 3. Запоминаем текущий для следующего раза
            *hover_tab = *tab
            *this\mask | #__mask_redraw
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         If *pressed_tab
            *pressed_tab\mask &~ #__mask_press
            *pressed_tab = 0
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If *hover_tab
            *pressed_tab = *hover_tab
            *hover_tab\mask | #__mask_press
            
            ; set active tab
            If activate(*hover_tab, *this\tab\active)
               PushListPosition(*this\__tabs())
               ChangeCurrentElement(*this\__tabs(), *hover_tab)
               Protected new_index = ListIndex(*this\__tabs())
               PopListPosition(*this\__tabs())
               
               Debug "КЛИК ПО ТАБУ: " + Str(new_index) + " : " + Str(*hover_tab\id) + " НА ПАНЕЛИ: " + *this\parent\class
               
               ; ВЫЗЫВАЕМ ПЕРЕКЛЮЧЕНИЕ У ПАНЕЛИ
               tab_state(*this\parent, new_index) 
               *this\mask | #__mask_redraw
            EndIf
         EndIf
         
   EndSelect
EndProcedure

Procedure column_events(*this._s_WIDGET, event)
   Protected._s_BAR *v = *this\scroll\v
   Protected._s_BAR *h = *this\scroll\h
   Protected._s_COLUMNS *column
   
   Static._s_COLUMNS *hover_column
   Static._s_COLUMNS *pressed_column
   
   Select event
      Case #PB_EventType_MouseLeave
         If *hover_column
            *this\mask | #__mask_redraw
            *hover_column\mask &~ #__mask_hover
            *hover_column = 0
         EndIf
         
      Case #PB_EventType_MouseMove
         If Not (*pressed_column And *pressed_column\mask & #__mask_resize)
            *column = hover_column(*this, mouse( )\x, mouse( )\y)
            If *hover_column <> *column
               If *hover_column
                  *hover_column\mask &~ #__mask_hover
               EndIf
               If *column
                  *column\mask | #__mask_hover
               EndIf
               *hover_column = *column
               *this\mask | #__mask_redraw
            EndIf
         EndIf
         
         If ListSize(*this\__columns( )) > 1
            ; --- КУРСОР ---
            ; change cursor
            If *column
               If Not *this\mask & #__mask_drag 
                  ;Protected is_edge.b = Bool(Abs(mouse( )\x - (*this\real\x + *column\x + *column\Width)) < 5)
                  ;Protected is_edge.b = Bool(Abs(mouse( )\x - (*this\real\x + *column\x)) < 5 Or Abs(mouse( )\x - (*this\real\x + *column\x + *column\Width)) < 5)
                  ; Проверка на край (для ресайза)
                  If Bool(Abs(mouse( )\x - (*this\real\x + *column\x + *column\Width)) < #COL_RESIZE_ZONE)
                     ;Debug " in "
                     If Not *this\mask & #__mask_cursor
                        *this\mask | #__mask_cursor
                        If test_cursor : Debug "col set cursor" : EndIf
                        SetGadgetAttribute( *this\root\Canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
                     EndIf
                  Else
                     ;Debug " out "
                     If *this\mask & #__mask_cursor
                        *this\mask &~ #__mask_cursor
                        If test_cursor : Debug "col reset cursor2" : EndIf
                        SetGadgetAttribute( *this\root\Canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                     EndIf
                  EndIf
               EndIf
            EndIf
            
            ; --- ДЕЙСТВИЯ ---
            If *this\mask & #__mask_drag 
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
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         If *pressed_column
            *pressed_column\mask &~ #__mask_press
            *pressed_column\mask &~ #__mask_resize
            *pressed_column = 0
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If *hover_column
            *pressed_column = *hover_column
            *hover_column\mask | #__mask_press
            
            ;
            activate(*hover_column, *this\column\active)
            
            ; 
            If *this\mask & #__mask_cursor
               ; А. Попали в КРАЙ — включаем Resize
               *hover_column\mask | #__mask_resize
               
               mouse( )\press\x = mouse( )\x ; Фиксируем точку старта для дельты
            EndIf
         EndIf
         
   EndSelect
   
EndProcedure

Procedure row_events(*this._s_WIDGET,  event)
   Protected._s_ROWS *row
   Static._s_ROWS *hover_row
   Static._s_ROWS *pressed_row
   
   Select event
      Case #PB_EventType_MouseLeave
         If *hover_row
            *this\mask | #__mask_redraw
            *hover_row\mask &~ #__mask_hover
            *hover_row = 0
         EndIf
         If *this\mask & #__mask_cursor
            *this\mask &~ #__mask_cursor
            If test_cursor : Debug "reset cursor" : EndIf
            SetGadgetAttribute( *this\root\Canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
         EndIf
         
      Case #PB_EventType_MouseMove    
         Protected mx = mouse()\x - *this\real\x
         Protected my = mouse()\y - *this\real\y
         
         ; --- ЛОГИКА АВТОСКРОЛЛА ПРИ ВЫДЕЛЕНИИ ---
         If *pressed_row And *pressed_row\mask & #__mask_edit
            Protected scroll_speed = 1 ; Скорость скролла в пикселях
            Protected scroll_changed.b = #False
            
            ; Вертикальный автоскролл
            If my < *this\column\height                                         + *this\row\Height
               *this\scroll\v\pos - scroll_speed : scroll_changed = #True
            ElseIf my > *this\height - Bool(*this\scroll\h\max>0) * *this\fs[4] - *this\row\Height 
               *this\scroll\v\pos + scroll_speed : scroll_changed = #True
            EndIf
            
            ; Горизонтальный автоскролл
            If mx < *this\fs[1]                                                + *this\row\Height
               *this\scroll\h\pos - scroll_speed : scroll_changed = #True
            ElseIf mx > *this\width - Bool(*this\scroll\v\max>0) * *this\fs[3] - *this\row\Height
               *this\scroll\h\pos + scroll_speed : scroll_changed = #True
            EndIf
            
            If scroll_changed
               ; Ограничители
               If *this\scroll\v\pos < 0 : *this\scroll\v\pos = 0 : EndIf
               If *this\scroll\h\pos < 0 : *this\scroll\h\pos = 0 : EndIf
               
               If *this\scroll\v\pos > *this\scroll\v\max : *this\scroll\v\pos = *this\scroll\v\max : EndIf
               If *this\scroll\h\pos > *this\scroll\h\max : *this\scroll\h\pos = *this\scroll\h\max : EndIf
               
               ; Пересобираем рулон и перерисовываем, чтобы edit_make_caret ниже 
               ; получил актуальные координаты строк после сдвига
               *this\mask | (#__mask_update | #__mask_redraw)
            EndIf
         EndIf
         
         ;
         *row = hover_row(*this, mouse( )\y)   
         If *hover_row <> *row
            If *hover_row
               *hover_row\mask &~ #__mask_hover
            EndIf
            
            If *row
               *row\mask | #__mask_hover
               
               ; Если мышь зажата и у начальной строки ЕСТЬ флаг редактирования
               If *pressed_row And 
                  *pressed_row\mask & #__mask_edit
                  
                  ; 1. Определяем границы диапазона по Y
                  Protected max_y = *row\y
                  Protected min_y = *pressed_row\y
                  If min_y > max_y : Swap min_y, max_y : EndIf
                  
                  ; 2. Пересчитываем маски для всех ВИДИМЫХ строк
                  PushListPosition(*this\__items())
                  ForEach *this\__items()
                     Protected *current_row._s_rows = *this\__items()
                     If *current_row\y >= min_y And 
                        *current_row\y <= max_y
                        ; Если строка в физическом диапазоне между кликом и курсором
                        *current_row\mask | (#__mask_edit | #__mask_update)
                     Else
                        ; Снимаем выделение, если строка вышла из диапазона
                        *current_row\mask &~ (#__mask_edit | #__mask_update)
                     EndIf
                  Next
                  PopListPosition(*this\__items())
                  
                  ; 3. Синхронизируем активную строку
                  If *this\row\active[0] <> *row
                     If *this\row\active[0] 
                        *this\row\active[0]\mask &~ #__mask_active 
                     EndIf
                     *row\mask | #__mask_active
                     *this\row\active[0] = *row
                  EndIf
               EndIf
            EndIf
            
            *hover_row = *row
            *this\mask | #__mask_redraw
         EndIf
         
         If *pressed_row
            If *pressed_row\mask & #__mask_edit
               If *this\mask & #__mask_drag
                  Protected caret = edit_make_caret(*this)
                  If *this\row\caret\start <> caret 
                     *this\row\caret\start = caret 
                     *this\mask | (#__mask_redraw)
                  EndIf
               EndIf
            Else
               If *this\mask & #__mask_active
                  swap_row(*this, *pressed_row, *hover_row, mouse( )\y)
               EndIf
            EndIf
         EndIf
         
         
         ; change cursor
         If *this\row\caret
            If Not *this\mask & #__mask_drag 
               If *row
                  If Not *this\mask & #__mask_cursor
                     *this\mask | #__mask_cursor
                     If test_cursor : Debug "set cursor" : EndIf
                     SetGadgetAttribute( *this\root\Canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
                  EndIf
               Else
                  If *this\mask & #__mask_cursor
                     *this\mask &~ #__mask_cursor
                     If test_cursor : Debug "reset cursor2" : EndIf
                     SetGadgetAttribute( *this\root\Canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  EndIf
               EndIf
            EndIf
         EndIf
         
         
      Case #PB_EventType_LeftButtonUp
         If *pressed_row
            *pressed_row\mask &~ #__mask_press
            *pressed_row = 0
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If *hover_row
            *pressed_row = *hover_row 
            *hover_row\mask | #__mask_press
            
            If MouseClick() = 1
               *this\row\active[1] = *hover_row
               activate(*hover_row, *this\row\active[0])
               ;
               If *this\row\caret
                  PushListPosition(*this\__rows( ))
                  ForEach *this\__rows( )
                     If *this\__rows( )\mask & #__mask_edit
                        *this\__rows( )\sel\start = 0
                        *this\__rows( )\sel\stop = 0
                        *this\__rows( )\mask &~ #__mask_edit
                     EndIf
                  Next
                  PopListPosition(*this\__rows( ))
                  ;
                  *this\row\caret\start = edit_make_caret(*this)
                  *this\row\caret\stop = *this\row\caret\start
                  ;
                  *hover_row\mask | #__mask_edit
               EndIf
               
               ; 4. Если это папка (узел) — переключаем схлопывание
               If *hover_row\mask & #__mask_node
                  *hover_row\mask ! #__mask_collapsed
                  ; Если ветка закрылась/открылась — пересобираем рулон
                  *this\mask | #__mask_update 
               EndIf
               
               *this\mask | #__mask_redraw
            EndIf
            
            If MouseClick() > 1
               If *hover_row\mask & #__mask_edit
                  Protected txt.s = *hover_row\Str(0)
                  Protected len.i = Len(txt)
                  
                  ; Находим начало и конец слова от текущей позиции
                  If MouseClick() = 2
                     Protected start.i = *this\row\caret\stop
                     Protected stop.i = *this\row\caret\start + 1 ; Начинаем со следующего символа
                     
                     ; Уменьшаем индекс, пока символ не станет пробелом или не дойдем до начала (0)
                     While start > 0 And Mid(txt, start, 1) <> " " : start - 1 : Wend
                     ; Увеличиваем индекс, пока не встретим пробел или конец текста
                     While stop <= len And Mid(txt, stop, 1) <> " " : stop + 1 : Wend
                     
                     *this\row\caret\start = stop - 1
                     *this\row\caret\stop = start
                  EndIf
                  If MouseClick() = 3
                     *this\row\caret\stop = 0
                     *this\row\caret\start = Len
                  EndIf
                  If *this\row\caret\start <> *this\row\caret\stop
                     *hover_row\mask | #__mask_update
                     *this\mask | (#__mask_redraw)
                  EndIf
               EndIf
            EndIf
            
         EndIf
   EndSelect
EndProcedure

Procedure scroll_events(*this._s_WIDGET, event)
   Protected *v._s_BAR = @*this\scroll\v
   Protected *h._s_BAR = @*this\scroll\h
   Protected mx = mouse()\x - *this\real\x
   Protected my = mouse()\y - *this\real\y
   
   ; Определяем наличие "соседа" для корректного расчета длины трека
   Protected fsv.l = 0 : If *v\max > 0 : fsv = *this\fs[3] : EndIf
   Protected fsh.l = 0 : If *h\max > 0 : fsh = *this\fs[4] : EndIf
   
   ; Проверяем попадание в зону любого из скроллбаров
   Protected in_v.b = #False
   Protected in_h.b = #False
   
   If Not (*this\mask & #__mask_drag)
      If *v\max > 0
         ; Вертикальный: от колонки до низа (минус горизонтальный, если он есть)
         in_v = Bool(mx > (*this\width - *this\fs[3]) And mx <= *this\width And 
                     my > *this\column\height And my <= (*this\height - fsh))
      EndIf
      If *h\max > 0
         ; Горизонтальный: от номеров строк до края (минус вертикальный, если он есть)
         in_h = Bool(my > (*this\height - *this\fs[4]) And my <= *this\height And 
                     mx > *this\fs[1] And mx <= (*this\width - fsv))
      EndIf
   EndIf
   
   Static is_drag_v, is_drag_h, drag_start_pos
   
   Select event
      Case #PB_EventType_MouseLeave
         *this\mask | #__mask_redraw
         
      Case #PB_EventType_MouseWheel
         If *v\max > 0
            Protected delta = GetGadgetAttribute(*this\root\Canvas\gadget, #PB_Canvas_WheelDelta)
            *v\pos - (delta * (*this\row\height * 3))
            
            If *v\pos < 0 : *v\pos = 0 : EndIf
            If *v\pos > *v\max : *v\pos = *v\max : EndIf
            
            *this\mask | (#__mask_update | #__mask_redraw)
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         is_drag_v = #False : *v\is_drag = #False
         is_drag_h = #False : *h\is_drag = #False
         
      Case #PB_EventType_LeftButtonDown
         If in_v
            is_drag_v = #True : *v\is_drag = #True
            ; Расчет точки хвата (абсолютный)
            Protected view_h_down.f = *this\height - *this\column\height - fsh
            Protected track_v_down.f = view_h_down - *v\thumb_h
            Protected current_thumb_y = 0
            If *v\max > 0 : current_thumb_y = (*v\pos * track_v_down) / *v\max : EndIf
            drag_start_pos = (my - *this\column\height) - current_thumb_y
            ProcedureReturn #True 
            
         ElseIf in_h
            is_drag_h = #True : *h\is_drag = #True
            ; Расчет точки хвата (абсолютный)
            Protected view_w_down.f = *this\width - *this\fs[1] - fsv
            Protected track_h_down.f = view_w_down - *h\thumb_w
            Protected current_thumb_x = 0
            If *h\max > 0 : current_thumb_x = (*h\pos * track_h_down) / *h\max : EndIf
            drag_start_pos = (mx - *this\fs[1]) - current_thumb_x
            ProcedureReturn #True 
         EndIf
         
      Case #PB_EventType_MouseMove
         If *this\mask & #__mask_press
            If is_drag_v
               Protected view_h.f = *this\height - *this\column\height - fsh
               Protected track_v.f = view_h - *v\thumb_h
               If track_v > 0
                  *v\pos = (((my - *this\column\height) - drag_start_pos) * *v\max) / track_v
               EndIf
               
               If *v\pos < 0 : *v\pos = 0 : EndIf
               If *v\pos > *v\max : *v\pos = *v\max : EndIf
               *this\mask | #__mask_update | #__mask_redraw
               
            ElseIf is_drag_h
               Protected view_w.f = *this\width - *this\fs[1] - fsv
               Protected track_h.f = view_w - *h\thumb_w
               If track_h > 0
                  *h\pos = (((mx - *this\fs[1]) - drag_start_pos) * *h\max) / track_h
               EndIf
               
               If *h\pos < 0 : *h\pos = 0 : EndIf
               If *h\pos > *h\max : *h\pos = *h\max : EndIf
               *this\mask | #__mask_redraw
            EndIf
         EndIf
         
         If in_v Or in_h Or is_drag_v Or is_drag_h
            If (in_v Or in_h) And (*this\mask & #__mask_cursor)
               If Not (*this\mask & #__mask_drag) 
                  row_events(*this, #PB_EventType_MouseLeave)
               EndIf
            EndIf
            *this\mask | #__mask_redraw
            ProcedureReturn #True 
         EndIf
   EndSelect
EndProcedure

Procedure do_events(*this._s_WIDGET, event)
   If *this\scroll
      If scroll_events(*this,  event)
         ProcedureReturn 1
      EndIf
   EndIf
   If *this\column
      If *this\column\height
         column_events(*this, event)
      EndIf
   EndIf
   If *this\row
      ;If *this\row\height
      row_events(*this, event)
      ;EndIf
   EndIf
   If *this\type = #__type_TabBar
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
      If Root( )
         keyboard( )\key[1] = GetGadgetAttribute( Root( )\canvas\gadget, #PB_Canvas_Modifiers )
      EndIf
   EndIf
   If eventtype = #PB_EventType_LeftButtonDown  ; The left mouse Button was Pressed
                                                ;
                                                ;\\ double click
                                                ;
      Static ClickTime.q
      Protected ElapsedMilliseconds.q = ElapsedMilliseconds( )
      If MouseClick( ) < 3 And 
         DoubleClickTime( ) > ( ElapsedMilliseconds - ClickTime )
         MouseClick( ) + 1
      Else
         MouseClick( ) = 1
      EndIf
      ClickTime = ElapsedMilliseconds
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
                                                 ;
      If GetActive()
         keyboard( )\key[1] = GetGadgetAttribute( GetActive()\root\canvas\gadget, #PB_Canvas_Modifiers )
         CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            If keyboard( )\key[1] & #PB_Canvas_Command
               keyboard( )\key[1] &~ #PB_Canvas_Command
               keyboard( )\key[1] | #PB_Canvas_Control
            EndIf
         CompilerEndIf
         ;
         ;\\
         If eventtype = #PB_EventType_Input
            keyboard( )\Key = 0
            keyboard( )\input = GetGadgetAttribute( GetActive()\root\canvas\gadget, #PB_Canvas_Input )
         Else
            keyboard( )\input = 0
            keyboard( )\Key = GetGadgetAttribute( GetActive()\root\canvas\gadget, #PB_Canvas_Key )
         EndIf
         
         key_events( GetActive(), eventtype )
         If GetActive( )\mask & #__mask_redraw
            Draw(GetActive( )\root)
            GetActive( )\mask &~ #__mask_redraw
         EndIf
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
               If (keyboard()\key[1] & #PB_Canvas_Shift)
                  If *h\max > 0
                     *h\pos - (delta * 30)
                     If *h\pos < 0 : *h\pos = 0 : EndIf
                     If *h\pos > *h\max : *h\pos = *h\max : EndIf
                     Entered( )\mask | #__mask_redraw
                  EndIf
               Else
                  ; Обычный вертикальный скролл
                  If *v\max > 0
                     *v\pos - (delta * 30)
                     If *v\pos < 0 : *v\pos = 0 : EndIf
                     If *v\pos > *v\max : *v\pos = *v\max : EndIf
                     Entered( )\mask | (#__mask_update | #__mask_redraw)
                  EndIf
               EndIf
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
         
         ;          If Entered( )\mask & #__mask_cursor
         ;             Debug "cursor"
         ;             Entered( )\mask &~ #__mask_cursor
         ;          EndIf
         If Entered( )\mask & #__mask_redraw
            Draw(Entered( )\root)
            Entered( )\mask &~ #__mask_redraw
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
   this\font = (Font_Editor_Normal)
   
   If flags & #__flag_integral
      this\tabindex = - 1 ; Помечаем как "всегда видимый"
   EndIf
   If Type = #__type_Tree Or
      Type = #__type_ListIcon Or
      Type = #__type_Editor
      this\column._s_COLUMN = AllocateStructure(_s_COLUMN)
      this\row._s_ROW = AllocateStructure(_s_ROW)
      this\row\height = 0
      this\row\indent = 20 ; (отступ веток)
      
      this\padding\X = 5
      this\padding\y = 5
      
      this\fs[3] = 16 ; Ширина вертикального скролла
      this\fs[4] = 16 ; Высота горизонтального скролла
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
         
      Case #__type_Container
         this\fs[0] = 1  ; Тонкая рамка вокруг контента
         
      Case #__type_TabBar
         this\tab._s_TAB = AllocateStructure(_s_TAB)
         this\tab\align = #__align_left
         this\tab\indent = 5 ; Начальный отступ (чтобы первый таб не прилипал к рамке)
         this\tab\spacing = 5; По умолчанию минимальный зазор
         this\padding\X = 10
         
      Case #__type_Editor
         this\row\caret = AllocateStructure(_s_CARET)
         
      Case #__type_Button
         this\padding\X = 5
         
         If flags & #__flag_Left
            this\text\align = #__align_left
         ElseIf flags & #__flag_Right
            this\text\align = #__align_right
         Else
            this\text\align = #__align_center
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


Procedure.i Open(window, X, Y, Width, Height, title.s="", flags.q = #PB_Window_ScreenCentered)
   Protected *root._s_ROOT = AllocateStructure(_s_ROOT)
   
   If IsWindow(window)
      *root\Canvas\window = window
      *root\Canvas\gadget = CanvasGadget(#PB_Any, X, Y, Width, Height, #PB_Canvas_Keyboard)
   Else
      *root\Canvas\window = OpenWindow(#PB_Any, X, Y, Width, Height, title, #PB_Window_SystemMenu|flags)
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
   
   Open(0, 0, 0, w, h, "PureBasic UI Engine", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ; 1. Главная панель
   ; СОЗДАЕМ виджеты (выделяем память, задаем тип и координаты)
   *p = Panel(10, 10, w-20, h-20)
   AddItem(*p, -1, "Вкладка А") 
   ;    *e = Editor(10, 10, 265, 235)
   ;    *e1 = Editor(10, 255, 265, 235)
   *e = Editor(10, 10, 265, 430)
   *e1 = Editor(285, 10, 265, 430)
   AddItem(*p, -1, "Вкладка B") 
   *t = Tree(300-15, 10, 280, 280)
   AddItem(*p, -1, "Вкладка C") 
   *g = ListIcon(570, 10, 260, 280, "Имя", 120)
   
   AddItem(*p, -1, "test (grid)") 
   Global *MyList = ListIcon(10, 10, 620, 300, "Имя (Left)", 200)
   AddColumn(*MyList, -1, "Возраст (Center)", 150, 0, #__ALIGN_CENTER)
   AddColumn(*MyList, -1, "Город (Right)", 180, -1, #__ALIGN_RIGHT)
   
   AddItem(*MyList, -1, "Александр" + #LF$ + "31" + #LF$ + "Москва", 0)
   AddItem(*MyList, -1, "Елена" + #LF$ + "24" + #LF$ + "Владивосток")
   AddItem(*MyList, -1, "Дмитрий" + #LF$ + "45" + #LF$ + "Тула")
   
   Define i
   For i = 1 To 5;000
      AddItem(*MyList, -1, "Пользователь " + Str(i) + #LF$ + Str(Random(60, 18)) + #LF$ + "неизвестно")
   Next
   
;    ; Кнопки для теста новых функций
;    ButtonGadget(1, 10, 320, 150, 30, "Удалить 1-ю строку")
;    ButtonGadget(2, 170, 320, 150, 30, "Удалить 2-ю колонку")
;    ButtonGadget(3, 330, 320, 150, 30, "Очистить всё")
   CloseList()
   
   ; Наполняем данными через твои add_column / add_row
   If *g
      add_column(*g, "возраст", 50)
      add_column(*g, "город", 150)
                              
      add_row(*g, "grid node")
      add_row(*g, "Александр" + #LF$ + "31" + #LF$ + "Москва",1)
      add_row(*g, "Елена" + #LF$ + "24" + #LF$ + "Владивосток",1)
      add_row(*g, "Дмитрий" + #LF$ + "45" + #LF$ + "Тула",1)
      
      add_row(*g, "greed node")
      add_row(*g, "Александр" + #LF$ + "31" + #LF$ + "Москва",1)
      add_row(*g, "Елена" + #LF$ + "24" + #LF$ + "Владивосток",1)
      add_row(*g, "Дмитрий" + #LF$ + "45" + #LF$ + "Тула",1)
   EndIf
   
   ;                  
   If *t
;       add_row(*t, "tree node")
;       add_row(*t, "Александр" + #LF$ + "31" + #LF$ + "Москва",1)
;       add_row(*t, "Елена" + #LF$ + "24" + #LF$ + "Владивосток",1)
;       add_row(*t, "Дмитрий" + #LF$ + "45" + #LF$ + "Тула",1)
;       
;       add_row(*t, "tree node")
;       add_row(*t, "Александр" + #LF$ + "31" + #LF$ + "Москва",1)
;       add_row(*t, "Елена" + #LF$ + "24" + #LF$ + "Владивосток",1)
;       add_row(*t, "Дмитрий" + #LF$ + "45" + #LF$ + "Тула",1)
      AddItem(*T, 0, "Tree_0", -1 )
AddItem(*T, 1, "Tree_1_1", 0, 1) 
AddItem(*T, 4, "Tree_1_1_2", -1, 2) 
AddItem(*T, 5, "Tree_1_1_3", -1, 2) 
AddItem(*T, 6, "Tree_1_1_3_1", -1, 3) 
AddItem(*T, 8, "Tree_1_1_3_1_1", -1, 4) 
AddItem(*T, 7, "Tree_1_1_3_2", -1, 3) 
AddItem(*T, 2, "Tree_1_1_1", -1, 1) 
AddItem(*T, 3, "Tree_1_1_1_1", -1, 4) 
AddItem(*T, 9, "Tree_1",-1 )

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
      AddItem(*e, -1, "add long long long long long long long long long long long long long long long long long")
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
      AddItem(*e1, a, "The String must be very long.")
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
      For a = 0 To 16
         AddItem(*e1, -1, Str(a) + " Row " + Str(a))
      Next
      
      
      ;       ; Допустим, берем первую строку
      ;       FirstElement(*e1\__rows())
      ;       *e1\__rows()\Str(0) = "Structure _s_POINT : X.l : Y.l"
      ;       
      ;       ; Вручную добавим пару токенов для теста:
      ;       ClearList(*e1\__rows()\tokens())
      ;       
      ;       ; "Structure" - Красный
      ;       add_token(*e1\__rows(), 1, 9, $0000FF)
      ;       
      ;       ; " _s_POINT" - Черный
      ;       add_token(*e1\__rows(), 10, 9, $FF0000)
      ;       
      ;       ; " : X.l" - Зеленый
      ;       add_token(*e1\__rows(), 19, 5, $00FF00)
      ;       
      ; Допустим, у нас есть виджет *this и в нем список строк
      FirstElement(*e1\row\__s())
      AddElement(*e1\row\__s())
      Define  *test_row._s_ROWS = @*e1\row\__s()
      
      ; Записываем текст, где есть и слово, и число, и оператор
      *test_row\Str(0) = "Structure _s_POINT : X.l : 123"
      
      ; Помечаем для перекраски
      *test_row\mask | #__mask_change
      *e1\mask | #__mask_tokken
      
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
; CursorPosition = 4292
; FirstLine = 4035
; Folding = -------------------------------------------4---------4-----------------------------------------------------------
; EnableXP
; DPIAware