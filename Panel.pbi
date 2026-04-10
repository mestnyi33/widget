EnableExplicit

;- --- КОНСТАНТЫ ---
;
;-\\ create-flags
#__flag_button_Default   = 1<<0
; #__flag_ = 1<<1
; #__flag_ = 1<<2
; #__flag_ = 1<<3
; #__flag_ = 1<<4
; #__flag_ = 1<<5
; #__flag_ = 1<<6
#__flag_Collapsed       = 1<<6
#__flag_OptionBoxes     = 1<<7
; #__flag_ = 1<<8
#__flag_CheckBoxes      = 1<<8 
; #__flag_ = 1<<9
; #__flag_ = 1<<10
; #__flag_ = 1<<11
; #__flag_ = 1<<12
#__flag_ThreeState      = 1<<12 
; #__flag_ = 1<<13
; #__flag_ = 1<<14
; #__flag_ = 1<<15
#__flag_RowClickSelect  = 1<<16   
; #__flag_ = 1<<17
; #__flag_ = 1<<18
; #__flag_ = 1<<19
; #__flag_ = 1<<20
; #__flag_ = 1<<21
#__flag_RowMultiSelect  = 1<<21
; #__flag_ = 1<<22
#__flag_RowFullSelect   = 1<<22
; #__flag_ = 1<<23
; #__flag_ = 1<<24
; #__flag_ = 1<<25
#__flag_GridLines       = 1<<25
#__flag_BorderRaised    = 1<<26
#__flag_BorderDouble    = 1<<27
; #__flag_ = 1<<28
#__flag_BorderSingle    = 1<<29  
; #__flag_ = 1<<30
#__flag_Borderless      = 1<<31
#__flag_BorderFlat      = 1<<32
;
#__flag_Child           = 1<<33
#__flag_Invert          = 1<<34
#__flag_Vertical        = 1<<35
#__flag_Transparent     = 1<<36
;
#__flag_NoFocus         = 1<<37
#__flag_NoLines         = 1<<38
#__flag_NoButtons       = 1<<39
#__flag_NoGadgets       = 1<<40
;#__flag_NoScrollBars    = 1<<41
;
#__flag_TextPassword    = 1<<42
#__flag_TextWordWrap    = 1<<43
#__flag_TextMultiLine   = 1<<44
#__flag_TextInLine      = 1<<45
#__flag_TextNumeric     = 1<<46
#__flag_TextReadonly    = 1<<47
#__flag_TextLowerCase   = 1<<48
#__flag_TextUpperCase   = 1<<49
;
; #__flag_Modal         = 1<<50
; #__flag_AllEvents     = 1<<51
; #__flag_              = 1<<52
; #__flag_              = 1<<53

;- \\ align-flag
;#__align_text           = 1<<54
;#__align_image          = 1<<55
#__flag_Left            = 1<<56
#__flag_Top             = 1<<57
#__flag_Right           = 1<<58
#__flag_Bottom          = 1<<59
#__flag_Center          = 1<<60 
#__flag_AutoSize        = 1<<61
;
#__align_proportional   = 1<<62
#__align_Full           = 1<<63
#__align_none           = 0

;
#__align_Left           = #__flag_Left
#__align_Top            = #__flag_Top 
#__align_Right          = #__flag_Right 
#__align_Bottom         = #__flag_Bottom 
#__align_Center         = #__flag_Center
#__align_Auto           = #__flag_AutoSize

;
;-\\ Window
#__window_FrameSize      = 4
#__window_CaptionHeight  = 24

;-\\ Text
#__flag_TextInvert       = #__flag_Invert
#__flag_TextVertical     = #__flag_Vertical

#__flag_TextLeft         = #__align_Left
#__flag_TextTop          = #__align_Top
#__flag_TextRight        = #__align_Right
#__flag_TextBottom       = #__align_Bottom
#__flag_TextCenter       = #__align_Center

Enumeration
   #__type_Root
   #__type_Panel
   #__type_Button
   #__type_Tree
   #__type_TabBar
   #__type_AreaBar
   #__type_Container
   #__type_ScrollArea
EndEnumeration

#__mask_update    = 1 << 5  ; Флаг: Требуется пересчет геометрии (TextWidth и т.д.)
#__mask_redraw    = 1 << 6  ; Флаг: Требуется перерисовка
#__mask_edit      = 1 << 7  ; Режим активного редактирования текста
#__mask_drag      = 1 << 8  ; Состояние перетаскивания
#__mask_press     = 1 << 9
#__mask_hover     = 1 << 10
#__mask_hidden    = 1 << 11
#__mask_disabled  = 1 << 12
#__mask_active    = 1 << 0  ; Фокус (Виджет) / Выделение (Строка)
#__mask_node      = 1 << 1  ; Является узлом (Строка) / Деревом (Виджет)
#__mask_collapsed = 1 << 2  ; Свернуто (Узел/Ветка)
#__mask_shift     = 1 << 13 ; Зажат Shift (Мышь) / Режим диапазона
#__mask_ctrl      = 1 << 14 ; Зажат Ctrl (Мышь) / Режим инверсии
                            ;#__mask_system    = 1 << 15

#_align_left   = 0
#_align_center = 1
#_align_right  = 2

#__flag_integral = 1 << 10

;- --- СТРУКТУРЫ ---
Structure _s_POINT
   X.i : Y.i
EndStructure

Structure _s_COORDINATE Extends _s_POINT
   Width.i : Height.i
EndStructure

Structure _s_TAB
   Text.s
   mask.l   ; Маска конкретной вкладки
   Width.i  ; Ширина вкладки
   X.i      ; Относительный X вкладки в шапке
EndStructure

Structure _s_SCROLL Extends _s_COORDINATE
   pos.i : max.i : thumb_h.i : is_drag.b
EndStructure

Structure _s_MOUSE Extends _s_POINT
   mask.q                ; Битовые состояния (Shift, Ctrl, Drag)
   press._s_POINT        ; Точка начала нажатия
   *widget._s_WIDGET[3]  ; Текущий виджет под мышью (Entered)
EndStructure

Structure _s_KEYBOARD  ; Ok
   *active._S_WIDGET   ; keyboard focus element ; GetActive( )\
EndStructure

Structure _s_ROWS
   Text.s
EndStructure

Structure _s_PAGE
   *first._s_WIDGET
   *last._s_WIDGET
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   ; Абсолютные на холсте (считает система)
   real_x.i : real_y.i 
   
   ; ГРАНИЦЫ ОТСЕЧЕНИЯ (Кешированные)
   clip_x.i : clip_y.i : clip_w.i : clip_h.i
   
   scroll_x.i : scroll_y.i          ; Текущее смещение контента (куда прокручено)
   scroll_width.i : scroll_height.i ; Полный размер внутреннего содержимого
   
   class.s
   Type.i                         ; EDIT или TREE
   color.i
   Level.l
   
   haschildren.l
   
   mask.q                ; Состояние виджета (#__mask_update, #__mask_active...)
   Image.i
   
   RowHeight.i           ; Высота строки данных ; 0 = авто по шрифту
   ColumnHeight.i        ; Высота шапки (заголовков)
   
   padding.i             ; Внутренний отступ текста
   indent.i              ; Отступ веток дерева
   caret.i[2]            ; [0] - точка старта (push), [1] - точка конца (cursor)
   
   tabindex.l            ; Активная вкладка (используется только если Type = #__type_Panel)
   tabpage.l             ; Номер страницы родителя, на которой сидит этот виджет
   tabspacing.i          ; РАССТОЯНИЕ МЕЖДУ ВКЛАДКАМИ
   tabindent.i           ; ОТСТУП ПЕРВОЙ ВКЛАДКИ СЛЕВА
   tab_scroll_x.i        ; СКРОЛЛ ШАПКИ (для вкладок)
   tabs_width.i          ; Общая ширина всех вкладок (уже считаем в update_tab)
   
   
   tabpadding.i          ; ВНУТРЕННИЙ ОТСТУП ТЕКСТА (слева + справа)
   tabalign.i            ; Выравнивание (0-лево, 1-центр, 2-право)
   textalign.i
   textpadding.i
   
   *address
   
   scroll_v._s_SCROLL
   scroll_h._s_SCROLL
   ;visible._s_VISIBLE_ROW
   
   Clip._s_COORDINATE    ; Предрассчитанная область отсечения (reclip)
                         ;OnEvent.ProtoOnEvent[#__event] ; Указатель на процедуру событий
   
   ; *address
   *root._s_ROOT         ; Ссылка на корень (холст)
   *parent._s_WIDGET     ; Ссылка на родителя
   
   *first._s_WIDGET ; Голова всей семьи (всех табов вместе)
   *last._s_WIDGET  ; Хвост всей семьи
   *next._s_WIDGET  ; Следующий брат
   *prev._s_WIDGET  ; Предыдущий брат
                    ;Array _page._s_PAGE(0) ; Динамический массив страниц
   
   *tabbar. _s_WIDGET ; Виджет-шапка Ссылка на дочерний виджет-полосу вкладок
   *areabar._s_WIDGET ; Виджет-контейнер для скроллинга контента
   
   ; List __columns._s_columns( )
   List *__Items._s_ROWS( )          ; Развернутый рулон (указатели)
                                     ; List __rows._s_rows( )
   List __tabs._s_TAB()              ; Заголовки вкладок
   List __rows._s_ROWS()             ; Строки данных
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

Structure _s_ROOT Extends _s_PARENT
   *DragItem._s_ROWS
   *DragColumn._s_columns 
   
   Canvas._s_CANVAS
   *widget._s_WIDGET ; List Widget._s_WIDGET( ) ; Список всех виртуальных виджетов на холсте
EndStructure

Structure _s_GUI
   *root._s_ROOT
   *opened._s_WIDGET             ; last opened-list element
   *tableaved._s_TAB
   
   mouse._s_MOUSE                ; mouse( )\
   keyboard._s_KEYBOARD          ; keyboard( )\
EndStructure
; Structure _s_ROOT Extends _s_WIDGET
;    Canvas._s_CANVAS
;    *first._s_WIDGET
;    *last._s_WIDGET
; EndStructure

;- --- ГЛОБАЛЫ ---
Global GUI._s_GUI
Global *GUI_widget._s_WIDGET
Global NewList widgets._s_WIDGET()

;- --- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ---
Macro Opened( ): GUI\opened: EndMacro
;Macro Widget( ): GUI\root\widget: EndMacro
Macro Root( ): GUI\root: EndMacro
Macro NextRoot( ) : Canvas\next : EndMacro
Macro PrevRoot( ) : Canvas\prev : EndMacro
Macro mouse( ): GUI\mouse: EndMacro
Macro Entered( ): GUI\mouse\widget[0]: EndMacro
Macro Leaved( ): GUI\mouse\widget[1]: EndMacro
Macro Pressed( ): GUI\mouse\widget[2]: EndMacro
Macro keyboard( ): GUI\keyboard: EndMacro
Macro GetActive( ): GUI\keyboard\active: EndMacro
Macro TabEntered()
   GUI\tableaved
EndMacro
Macro Widget( ): *GUI_widget: EndMacro

;-
Macro Clip(_widget_) : ClipOutput(_widget_\clip_x, _widget_\clip_y, _widget_\clip_w, _widget_\clip_h) 
 : EndMacro
Macro UnClip() : UnclipOutput() : EndMacro

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
Macro is_level_( _address_1, _address_2 )
   Bool( _address_1 <> _address_2 And _address_1\parent = _address_2\parent And _address_1\tabindex = _address_2\tabindex )
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
Procedure ReClip(*this._s_WIDGET)
   *this\clip_x = *this\real_x : *this\clip_w = *this\Width
   *this\clip_y = *this\real_y : *this\clip_h = *this\Height
   
   If *this\parent And *this\parent\Type <> #__type_Root
      Protected px = *this\parent\clip_x
      Protected py = *this\parent\clip_y
      Protected pw = *this\parent\clip_w
      Protected ph = *this\parent\clip_h
      
      ; Если родитель — Панель без AreaBar, сужаем окно клиппинга под шапку
      If *this\parent\tabbar And Not *this\parent\areabar
         py + *this\parent\rowheight
         ph - *this\parent\rowheight
      EndIf
      
      ; Пересечение прямоугольников... (стандартный код Intersection)
      If *this\clip_x < px : *this\clip_w - (px - *this\clip_x) : *this\clip_x = px : EndIf
      If *this\clip_y < py : *this\clip_h - (py - *this\clip_y) : *this\clip_y = py : EndIf
      If *this\clip_x + *this\clip_w > px + pw : *this\clip_w = (px + pw) - *this\clip_x : EndIf
      If *this\clip_y + *this\clip_h > py + ph : *this\clip_h = (py + ph) - *this\clip_y : EndIf
   EndIf
EndProcedure

Procedure Resize(*this._s_WIDGET, X.l, Y.l, Width.l, Height.l)
   Protected *g._s_WIDGET ; Наш локальный указатель для рекурсии
   
   *this\X = X : *this\Y = Y
   *this\Width = Width : *this\Height = Height
   
   ; 1. СЧИТАЕМ РЕАЛЬНЫЕ КООРДИНАТЫ
   If *this\parent And *this\parent\Type <> #__type_Root
      ; Базовое положение
      *this\real_x = *this\parent\real_x + *this\X
      *this\real_y = *this\parent\real_y + *this\Y
      
      ; ИСКЛЮЧЕНИЕ: Системные виджеты (шапка/тело) игнорируют скролл родителя
      If Not is_integral_( *this )
         *this\real_x - *this\parent\scroll_x
         *this\real_y - *this\parent\scroll_y
      EndIf
   Else
      *this\real_x = *this\X : *this\real_y = *this\Y
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
   *this\mask | #__mask_update | #__mask_redraw
EndProcedure

Procedure SetActive(*this._s_WIDGET)
   If GetActive( ) 
      GetActive( )\mask &~ #__mask_active 
   EndIf
   GetActive( ) = *this
   Root( ) = *this\root
   *this\mask | #__mask_active | #__mask_redraw
EndProcedure

;-
Procedure update_tab(*this._s_WIDGET)
   PushListPosition(*this\__tabs())
   ForEach *this\__tabs()
      ; Замеряем текст и добавляем отступы (по 10px с каждой стороны)
      *this\__tabs()\width = TextWidth(*this\__tabs()\text) + *this\tabpadding * 2
   Next
   PopListPosition(*this\__tabs())
EndProcedure

;-
Procedure.i GetTabStartX(*this._s_WIDGET)
   ; Если вкладок нет или ширина не посчитана
   If *this\tabs_width <= 0 : ProcedureReturn *this\tabindent : EndIf
   
   Select *this\tabalign
      Case 1 ; ПО ЦЕНТРУ (#_align_center)
             ; (Ширина бара - Ширина всех вкладок) / 2
         ProcedureReturn (*this\Width - *this\tabs_width) / 2
         
      Case 2 ; СПРАВА (#_align_right)
             ; Ширина бара - Ширина всех вкладок - Отступ
         ProcedureReturn *this\Width - *this\tabs_width - *this\tabindent
         
      Default ; СЛЕВА (0, #_align_left)
         ProcedureReturn *this\tabindent
   EndSelect
EndProcedure


Procedure draw_generic_element(X.i, Y.i, Width.i, Height.i, Text.s, Mask.i, Align.i, Padding.i, ImageID.i = -1, IsTab.b = #False)
   Protected tx, ty, tw, th, ix, iy, iw, ih, text_shift.i = 0
   Protected c1.i, c2.i, border.i, accent.i = -1
   
   ; --- ЛОГИКА СОСТОЯНИЙ (Alpha-цвета $AA-BB-CC-DD) ---
   
   If Mask & #__mask_disabled
      c1 = $FFFAFAFA : c2 = $FFF0F0F0 : border = $FFD0D0D0
      
   ElseIf Mask & #__mask_press
      c1 = $FFD0D0D0 : c2 = $FFE0E0E0 : border = $FF808080
      text_shift = 1
      
   ElseIf Mask & #__mask_active
      ; Активное состояние (например, выбранная вкладка)
      c1 = $FFFFFFFF : c2 = $FFFFFFFF : border = $FFCCCCCC
      accent = $FF3399FF ; Яркий акцент
      
   ElseIf Mask & #__mask_hover
      ; Эффект "подсветки" (белый полупрозрачный градиент)
      c1 = $FFFFFFFF : c2 = $FFF8F8F8 : border = $FFA0A0A0
      If IsTab : accent = $FF3399FF : EndIf ; Синяя полоска сверху для таба при наведении
      
   Else ; Обычное состояние
      c1 = $FFF8F8F8 : c2 = $FFEAEAEA : border = $FFCCCCCC
   EndIf
   ; --- РИСОВАНИЕ ФОНА И РАМКИ ---
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   LinearGradient(X, Y, X, Y + Height)
   BackColor(c1) : GradientColor(1.0, c2)
   Box(X, Y, Width, Height) 
   
   ; Рамка
   Line(X, Y, Width, 1, border) ; Top
   Line(X, Y, 1, Height, border); Left
   Line(X + Width - 1, Y, 1, Height, border) ; Right
   If Not (Mask & #__mask_active And IsTab)
      Line(X, Y + Height - 1, Width, 1, border) ; Bottom
   EndIf
   
   ; Акцентная полоска
   If accent <> -1 : Box(X, Y, Width, 3, accent) : EndIf
   
   ; --- ЛОГИКА ИКОНКИ И ТЕКСТА ---
   tw = TextWidth(Text)
   th = TextHeight(Text)
   
   ; Если есть иконка, получаем её размеры
   If IsImage(ImageID)
      iw = ImageWidth(ImageID)
      ih = ImageHeight(ImageID)
      ; Общая ширина контента (иконка + отступ 5px + текст)
      Protected content_w = iw + 5 + tw
   Else
      iw = 0 : content_w = tw
   EndIf
   
   ; Расчет X для всего контента сразу
   Select Align
      Case #_align_center : tx = X + (Width - content_w) / 2
      Case #_align_right  : tx = X + Width - content_w - Padding
      Default             : tx = X + Padding ; Left
   EndSelect
   
   ; Рисуем иконку
   If iw > 0
      iy = Y + (Height - ih) / 2
      DrawAlphaImage(ImageID(ImageID), tx + text_shift, iy + text_shift)
      tx + iw + 5 ; Сдвигаем X для текста
   EndIf
   
   ; Рисуем текст
   ty = Y + (Height - th) / 2
   DrawText(tx + text_shift, ty + text_shift, Text, $FF333333, $00000000)
EndProcedure

Procedure draw_button(*this._s_WIDGET, X.i, Y.i)
   ProcedureReturn draw_generic_element(X, Y, *this\Width, *this\Height, *this\class, *this\mask, *this\textalign, *this\textpadding, *this\image, #False)
   
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
   LinearGradient(X, Y, X, Y + *this\Height)
   
   ; Используем RoundBox для мягких углов (3 пикселя радиус)
   RoundBox(X, Y, *this\Width, *this\Height, round, round)
   
   ; 2. Рисуем рамку
   DrawingMode(#PB_2DDrawing_Outlined)
   RoundBox(X, Y, *this\Width, *this\Height, round, round, border)
   
   ; 3. Фокус ввода (тонкий пунктир или внутренняя рамка)
   If *this\mask & #__mask_active
      ; Рисуем еле заметную внутреннюю рамку фокуса
      RoundBox(X+2, Y+2, *this\Width-4, *this\Height-4, 2, 2, $3399FF)
   EndIf
   
   ; Вычисляем координаты текста для центровки
   tw = TextWidth(*this\class)
   th = TextHeight(*this\class)
   
   ; Центрируем по вертикали всегда
   ty = Y + (*this\Height - th) / 2
   
   ; Выбираем X по горизонтали
   Select *this\textalign
      Case #_align_center
         tx = X + (*this\Width - tw) / 2
      Case #_align_right
         tx = X + *this\Width - tw - *this\textpadding ; 5 пикселей отступ справа
      Case #_align_left
         tx = X + *this\textpadding                 ; 5 пикселей отступ слева
   EndSelect
   
   ; Рисуем текст по центру кнопки
   DrawingMode(#PB_2DDrawing_Transparent)
   DrawText(tx + text_shift, ty + text_shift, *this\class, $333333, $EAEAEA)
EndProcedure

Procedure draw_tab(*this._s_WIDGET, rx.l, ry.l)
   ; 1. ВЫЧИСЛЯЕМ СТАРТ (с учетом выравнивания и скролла самого таббара)
   Protected tx = rx + GetTabStartX(*this) - *this\scroll_x
   Protected i = 0
   Protected color, txtColor
   Protected active_x = -1, active_w = 0 
   
   PushListPosition(*this\__tabs())
   ForEach *this\__tabs()
      If *this\__tabs()\mask & #__mask_hidden : Continue : EndIf
      
      Protected m = *this\__tabs()\mask
      If i = *this\parent\tabpage : m | #__mask_active : EndIf
      
      ; Передаем IsTab = #True (включает логику акцентных линий и скрытия нижней границы)
      draw_generic_element(tx, ry, *this\__tabs()\width, *this\Height, *this\__tabs()\text, m, #_align_center, *this\tabpadding/2, 0, #True)
      
      ;       ; ИСПОЛЬЗУЕМ ИНДЕКС РОДИТЕЛЯ
      ;       If i = *this\parent\tabpage
      ;          color = $FFFFFF
      ;          txtColor = $000000
      ;          active_x = tx      
      ;          active_w = *this\__tabs()\width
      ;       ElseIf *this\__tabs()\mask & #__mask_disabled
      ;          color = $D0D0D0 : txtColor = $888888 
      ;       ElseIf *this\__tabs()\mask & #__mask_hover
      ;          color = $F8F8F8 : txtColor = $000000
      ;       Else
      ;          color = $E0E0E0 : txtColor = $000000
      ;       EndIf
      ;       
      ;       ; РИСУЕМ ТЕЛО ТАБА
      ;       Box(tx, ry, *this\__tabs()\width, *this\Height, color)
      ;       
      ;       ; ЦЕНТРУЕМ ТЕКСТ (используем tabpadding как отступ)
      ;       ; (tw - text_w) / 2 даст идеальный центр
      ;       DrawText(tx + *this\tabpadding/2, ry + (*this\Height - TextHeight("A"))/2, *this\__tabs()\text, txtColor, color)
      ;       
      ;       ; РАМКА (Верх, Лево, Право)
      ;       Line(tx, ry, *this\__tabs()\width, 1, $CCCCCC) 
      ;       Line(tx, ry, 1, *this\Height, $CCCCCC)                   
      ;       Line(tx + *this\__tabs()\width, ry, 1, *this\Height, $CCCCCC) 
      ;       
      ; ;       ; Внутри draw_tab вместо Box/DrawText/Line:
      ; ;       Protected tab_mask = *this\__tabs()\mask
      ; ;       
      ; ;       ; Если индекс совпадает с активной страницей — подмешиваем флаг ACTIVE
      ; ;       If i = *this\parent\tabpage
      ; ;          tab_mask | #__mask_active
      ; ;       EndIf
      ; ;       
      ; ;       ; Рисуем таб как кнопку
      ; ;       draw_generic_button(tx, ry, *this\__tabs()\width, *this\Height, *this\__tabs()\text, tab_mask, #_align_center, *this\tabpadding/2, 0)
      ; ;       
      ; ;       ; Лайфхак: если это активный таб, стираем нижнюю линию
      ; ;       If i = *this\parent\tabpage
      ; ;          Line(tx + 1, ry + *this\Height - 1, *this\__tabs()\width - 2, 1, $FFFFFF)
      ; ;       EndIf
      ; ;       
      tx + *this\__tabs()\width + *this\tabspacing 
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
   ; --- 1. ФОН КОНТЕНТА ---
   ; Рисуем белое тело панели под шапкой
   If *this\tabbar
      Box(rx, ry + *this\rowheight, *this\Width, *this\Height - *this\rowheight, $FFFFFF) 
   EndIf
   
   ; --- 2. РАМКА ПЕРИМЕТРА ---
   ; Рисуем бока и низ (верхнюю линию нарисует draw_tab или сама панель частями)
   Line(rx, ry + *this\Height - 1, *this\Width, 1, $CCCCCC) ; Низ
   Line(rx, ry + *this\rowheight, 1, *this\Height - *this\rowheight, $CCCCCC)                   ; Лево
   Line(rx + *this\Width - 1, ry + *this\rowheight, 1, *this\Height - *this\rowheight, $CCCCCC) ; Право
   
   ; Если нужно, чтобы рамка была и сверху над табами:
   ;Line(rx, ry, *this\Width, 1, $CCCCCC) ; Верх
   
   ; --- 3. ОТРИСОВКА ВКЛАДОК ---
   ; Вызываем табы ПОВЕРХ рамки, чтобы активный таб мог "стереть" границу
   If *this\tabbar
      If Not *this\tabbar\mask & #__mask_hidden
         draw_tab(*this\tabbar, rx, ry)
      EndIf
   EndIf
EndProcedure

Procedure draw_container(*this._s_WIDGET, X.i, Y.i)
   Protected border_color.i = $D0D0D0
   Protected bg_color.i = $F9F9F9 ; Чуть светлее или темнее основного фона
   
   ; 1. Рисуем фон контейнера
   ; Если контейнер "активен" (например, выбран в редакторе), можно подсветить фон
   If *this\mask & #__mask_active
      bg_color = $F0F8FF ; Легкий голубой оттенок (AliceBlue)
      border_color = $3399FF
   EndIf
   
   ; Заливка
   Box(X, Y, *this\Width, *this\Height, bg_color)
   
   ; 2. Рисуем рамку (тонкая линия в 1 пиксель)
   DrawingMode(#PB_2DDrawing_Outlined)
   Box(X, Y, *this\Width, *this\Height, border_color)
   
   ; 3. Добавим "дизайнерскую" фишку: если у контейнера есть имя (class), 
   ; рисуем его маленьким шрифтом в углу или сверху (опционально)
   If *this\class <> ""
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(X + 5, Y - 15, *this\class, $888888) ; Подпись над контейнером
   EndIf
   
   DrawingMode(#PB_2DDrawing_Default)
EndProcedure

Procedure Draw(*r._s_ROOT)
   Protected *g._s_WIDGET
   If Not *r Or Not IsGadget(*r\Canvas\gadget) : ProcedureReturn : EndIf
   
   If StartDrawing(CanvasOutput(*r\Canvas\gadget))
      ; Очистка фона окна
      Box(0, 0, OutputWidth(), OutputHeight(), $F0F0F0)
      
      If StartEnum(*r) : *g = @widgets()
         If *g\tabindex = -1 : Continue : EndIf
         ; --- ВОТ ЭТА СТРОКА ОБЯЗАТЕЛЬНА ---
         If *g\mask & #__mask_hidden : Continue : EndIf
         
         ; Считаем реальные координаты
         Protected rx = *g\real_x
         Protected ry = *g\real_y
         
         ; --- АВТО-ОБНОВЛЕНИЕ ШИРИНЫ ТАБОВ ---
         If (*g\mask & #__mask_update) 
            If *g\tabbar
               update_tab(*g\tabbar)
            EndIf
            
            ; Сбрасываем флаг обновления
            *g\mask & ~#__mask_update
         EndIf
         
         ; 1. ВКЛЮЧАЕМ НОЖНИЦЫ ДАННОГО ВИДЖЕТА
         Clip(*g) 
         
         ; Если это панель — вызываем специализированную отрисовку
         If *g\Type = #__type_Panel
            draw_panel(*g, rx, ry)
         ElseIf *g\Type = #__type_Container
            draw_container(*g, rx, ry)
         ElseIf *g\Type = #__type_Button
            draw_button(*g, rx, ry)
         EndIf
         
         ; 3. ОБЯЗАТЕЛЬНО ВЫКЛЮЧАЕМ НОЖНИЦЫ
         ; Чтобы следующий виджет в списке не наследовал обрезку текущего
         UnClip() 
         
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
      Draw(*r)
      *r = *r\NextRoot( ) ; Переходим к следующему
   Wend
EndProcedure

;- --- ТВОИ ПРОЦЕДУРЫ ---

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
      Opened( )\tabpage = 0
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

Procedure Move(*this._s_WIDGET, *new_parent._s_WIDGET)
   If Not *this Or Not *new_parent : ProcedureReturn : EndIf
   
   ; --- 1. ОТВЯЗЫВАЕМ ОТ СТАРОГО РОДИТЕЛЯ ---
   If *this\parent
      If *this\parent\first = *this : *this\parent\first = *this\next : EndIf
      If *this\parent\last = *this  : *this\parent\last = *this\prev  : EndIf
   EndIf
   If *this\prev : *this\prev\next = *this\next : EndIf
   If *this\next : *this\next\prev = *this\prev : EndIf
   
   ; --- 2. ПРИВЯЗЫВАЕМ К НОВОМУ РОДИТЕЛЮ (в конец списка) ---
   *this\parent = *new_parent
   *this\prev = *new_parent\last
   *this\next = 0
   
   If *new_parent\last
      *new_parent\last\next = *this
   EndIf
   If Not *new_parent\first
      *new_parent\first = *this
   EndIf
   *new_parent\last = *this
   
   ; Обновляем уровень вложенности
   *this\Level = *new_parent\Level + 1
EndProcedure

Procedure SetGroup(*this._s_WIDGET, *container._s_WIDGET)
   If Not *this Or Not *container : ProcedureReturn : EndIf
   
   ; Контейнер становится родителем
   Move(*this, *container)
   
   ; Корректируем координаты: теперь они считаются относительно контейнера
   *this\X - *container\real_x
   *this\Y - *container\real_y
   
   ; Пересчитываем реальные координаты
   Resize(*this, *this\X, *this\Y, *this\Width, *this\Height)
EndProcedure

Procedure BringToFront(*this._s_WIDGET)
   If Not *this Or Not *this\parent : ProcedureReturn : EndIf
   Protected *p._s_WIDGET = *this\parent
   
   ; Если он и так последний — ничего не делаем
   If *p\last = *this : ProcedureReturn : EndIf
   
   ; 1. Вырезаем из текущей позиции
   If *p\first = *this : *p\first = *this\next : EndIf
   If *this\prev : *this\prev\next = *this\next : EndIf
   If *this\next : *this\next\prev = *this\prev : EndIf
   
   ; 2. Вставляем в самый конец
   *this\prev = *p\last
   *this\next = 0
   *p\last\next = *this
   *p\last = *this
EndProcedure

;-
; Procedure.i GetLast(*this._s_WIDGET, tabindex.l = #PB_Default)
;    Protected *current._s_WIDGET
;    If Not *this\last : ProcedureReturn 0 : EndIf
;    
;    ; Если страница не важна — ищем абсолютный физический конец ветки
;    If tabindex = #PB_Default
;       Protected *deep = GetLast(*this\last, #PB_Default)
;       If *deep : ProcedureReturn *deep : Else : ProcedureReturn *this\last : EndIf
;    EndIf
;    
;    ; Ищем последнего ребенка на конкретной странице
;    *current = *this\last
;    While *current
;       If *current\tabindex = tabindex Or is_integral_(*current)
;          Protected *sub_deep = GetLast(*current, #PB_Default)
;          If *sub_deep : ProcedureReturn *sub_deep : Else : ProcedureReturn *current : EndIf
;       EndIf
;       *current = *current\prev
;    Wend
;    
;    ; На этой странице детей нет
;    ProcedureReturn 0
; EndProcedure
; 
; Procedure.i _GetAnchor(*parent._s_WIDGET, tabindex.l = #PB_Default)
;    Protected *anchor._s_WIDGET
;    
;    ; 1. Пробуем найти последнего ребенка на текущей странице
;    *anchor = GetLast(*parent, tabindex)
;    If *anchor : ProcedureReturn *anchor : EndIf
;    
;    ; 2. Если на странице пусто — ищем хвост предыдущих страниц
;    If tabindex <> #PB_Default
;       Protected t.l = tabindex - 1
;       While t >= 0
;          *anchor = GetLast(*parent, t)
;          If *anchor : ProcedureReturn *anchor : EndIf
;          t - 1
;       Wend
;    EndIf
;    
;    ; 3. Если совсем всё пусто — якорем становится сам родитель
;    ProcedureReturn *parent
; EndProcedure

Procedure.i GetAnchor(*this._s_WIDGET, tabindex.l = #PB_Default)
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
      ProcedureReturn GetAnchor(*this\last, #PB_Default)
   Else
      ; Ищем последнего ребенка на указанной странице
      *current = *this\last
      While *current
         ; Нашли ребенка на нужной странице или системный виджет
         If *current\tabindex = tabindex Or is_integral_(*current)
            ; Ныряем в его абсолютный физический конец
            ProcedureReturn GetAnchor(*current, #PB_Default)
         EndIf
         *current = *current\prev
      Wend
      
      ; 3. ЛОГИКА "ЯКОРЯ" (Откат по вкладкам)
      Protected t.l = tabindex - 1
      While t >= 0
         ; Здесь ВАЖНО: вызываем GetAnchor для поиска хвоста конкретной вкладки 't'
         *current = GetAnchor(*this, t) 
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
   
   ; --- ШАГ 2: НАХОДИМ ФИЗИЧЕСКУЮ ТОЧКУ (ГДЕ он заканчивается) ---
;    Select position
; ;       Case #PB_List_First
; ;          ; 1. Пробуем найти, где закончилась ПРЕДЫДУЩАЯ вкладка
; ;          If *this\tabindex > 0
; ;             *anchor_el = GetLast(*parent, *this\tabindex - 1)
; ;          EndIf
; ;          
; ;          If *anchor_el
; ;             ; Если нашли хвост предыдущей вкладки — встаем СРАЗУ ЗА НИМ
; ;             move_mode = #PB_List_After
; ;          Else
; ;             ; Если предыдущих вкладок нет (мы на Tab 0) — 
; ;             ; встаем ПЕРЕД самым первым элементом родителя
; ;             *anchor_el = *parent\first
; ;             move_mode = #PB_List_Before
; ;          EndIf
;         Case #PB_List_First
;          If *this\tabindex > 0
;             ; Ищем, где закончилась предыдущая вкладка
;             *anchor_el = GetAnchor(*parent, *this\tabindex - 1)
;             move_mode = #PB_List_After
;          Else
;             ; На самой первой вкладке (0) якорем будет сам родитель
;             *anchor_el = *parent\first
;             move_mode = #PB_List_Before
;          EndIf
;          ; Во всех этих случаях мы встаем СРАЗУ ЗА найденным якорем
;          
;       Case #PB_List_Last
;          ; Чтобы стать последним, нужно встать ПОСЛЕ текущего хвоста этой вкладки
;          *anchor_el = GetLast(*parent, *this\tabindex)
;          move_mode  = #PB_List_After
;          
;       Case #PB_List_Before
;          *anchor_el = *target
;          move_mode  = #PB_List_Before
;          
;       Case #PB_List_After
;          *anchor_el = GetAnchor(*target, #PB_Default)
;          move_mode  = #PB_List_After
;    EndSelect
;    
      ; --- ШАГ 2: НАХОДИМ ФИЗИЧЕСКУЮ ТОЧКУ (Только через GetAnchor) ---
   Select position
      Case #PB_List_First
         If *this\tabindex > 0
            ; Ищем хвост предыдущей вкладки
            *anchor_el = GetAnchor(*parent, *this\tabindex - 1)
            move_mode = #PB_List_After
         Else
            ; На первой вкладке якорем будет текущий первый ребенок
            *anchor_el = *parent\first
            move_mode = #PB_List_Before
         EndIf
         
      Case #PB_List_Last
         ; Чтобы стать последним на своей вкладке, встаем ПОСЛЕ её текущего хвоста
         ; GetAnchor вернет хвост последнего ребенка на этой вкладке
         *anchor_el = GetAnchor(*parent, *this\tabindex)
         move_mode  = #PB_List_After
         
      Case #PB_List_Before
         *anchor_el = *target
         move_mode  = #PB_List_Before
         
      Case #PB_List_After
         ; Встаем ПОСЛЕ "хвоста" целевого виджета
         *anchor_el = GetAnchor(*target, #PB_Default)
         move_mode  = #PB_List_After
   EndSelect

   If Not *anchor_el : ProcedureReturn 0 : EndIf
   Debug ""+*this\class +" "+ *target\class +" "+ *anchor_el\class
   
   ; --- ШАГ 3: ФИЗИЧЕСКИЙ ПЕРЕНОС БЛОКА (this + дети) ---
   Protected *last_el_in_block = GetAnchor(*this, #PB_Default)
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

; Procedure.i _SetParent(*this._s_WIDGET, *parent._s_WIDGET, tabpage.l = #PB_Default)
;    Protected *r._s_ROOT, *new._s_WIDGET, *insert_after._s_WIDGET
;    
;    ; --- 1. КОНТЕКСТ ---
;    If *parent : *r = *parent\root : Else : *r = Root() : EndIf
;    If Not *r : ProcedureReturn 0 : EndIf
;    
;    ; Определяем страницу и заходим в контейнер
;    If tabpage = #PB_Default And *parent : tabpage = *parent\tabpage : EndIf
;    If *parent And *parent\areabar : *parent = *parent\areabar : EndIf
;    
;    ; --- 2. ПОИСК ТОЧКИ ВСТАВКИ ---
;    If *parent
;       *insert_after = GetAnchor(*parent, tabpage)
;    ElseIf *r\first
;       *insert_after = GetLast(*r\first, #PB_Default)
;    EndIf
;    
;    ; --- 3. ФИЗИЧЕСКИЙ ПЕРЕНОС / СОЗДАНИЕ ---
;    PushListPosition(widgets())
;    
;    ; ПЕРЕНОС СУЩЕСТВУЮЩЕГО
;    If *this And *this\address
;       
;       ; Логическая отвязка от старого родителя (Detach)
;       If *this\prev : *this\prev\next = *this\next : ElseIf *this\parent : *this\parent\first = *this\next : EndIf
;       If *this\next : *this\next\prev = *this\prev : ElseIf *this\parent : *this\parent\last = *this\prev : EndIf
;       
;       ; Перенос всего блока (родитель + дети)
;       Protected *last_el_in_block = GetLast(*this, #PB_Default)
;       Protected NewList *items()
;       ChangeCurrentElement(widgets(), *this\address) 
;       Repeat
;          AddElement(*items()) : *items() = @widgets()
;          If @widgets() = *last_el_in_block : Break : EndIf
;       Until Not NextElement(widgets())
;       
;       ; Определяем физический адрес
;       Protected *physical_addr = #Null
;       Protected move_mode.l = #PB_List_After
;       If *insert_after And *insert_after\address
;          *physical_addr = *insert_after\address
;       ElseIf *r\first And *r\first <> *this
;          *physical_addr = *r\first\address
;          move_mode = #PB_List_Before
;       EndIf
;       
;       ForEach *items()
;          ChangeCurrentElement(widgets(), *items())
;          If *physical_addr
;             MoveElement(widgets(), move_mode, *physical_addr)
;             *physical_addr = @widgets()
;             move_mode = #PB_List_After
;          EndIf
;       Next
;       *new = *this
;       
;    Else ; НОВОЕ СОЗДАНИЕ
;       If *insert_after And *insert_after\address
;          ChangeCurrentElement(widgets(), *insert_after\address)
;          *new = AddElement(widgets())
;       Else
;          LastElement(widgets())
;          *new = AddElement(widgets())
;       EndIf
;       CopyStructure(*this, *new, _s_WIDGET)
;       *new\address = *new
;    EndIf
;    PopListPosition(widgets())
;    
;    ; --- 4. ЛОГИЧЕСКИЕ СВЯЗИ ---
;    *new\parent = *parent
;    *new\root   = *r
;    *new\next   = #Null
;    
;    If *parent
;       *parent\haschildren = 1
;       If *parent\last
;          *new\prev = *parent\last
;          *new\prev\next = *new
;       Else
;          *new\prev = #Null
;          *parent\first = *new
;       EndIf
;       *parent\last = *new
;    Else
;       *new\prev = #Null
;    EndIf
;    
;    ; --- 5. ФИНАЛИЗАЦИЯ (Твоё добавление) ---
;    If Not *r\first : *r\first = *new : EndIf
;    If Not is_integral_(*new) : *new\tabindex = tabpage : EndIf
;    
;    ; Обновляем уровни вложенности всей ветки
;    If *parent : update_level(*new, *parent\Level + 1) : Else : update_level(*new, 0) : EndIf
;    
;    hidden(*new, *parent, *new\tabindex)
;    If *parent : *parent\mask | #__mask_redraw : EndIf
;    
;    ProcedureReturn *new
; EndProcedure

Procedure.i SetParent(*this._s_WIDGET, *parent._s_WIDGET, tabpage.l = #PB_Default)
   Protected *r._s_ROOT, *new._s_WIDGET, *insert_after._s_WIDGET
   
   ; --- 1. КОНТЕКСТ ---
   If *parent : *r = *parent\root : Else : *r = Root() : EndIf
   If Not *r : ProcedureReturn 0 : EndIf
   
   ; Страница и AreaBar
   If tabpage = #PB_Default And *parent : tabpage = *parent\tabpage : EndIf
   If *parent And *parent\areabar : *parent = *parent\areabar : EndIf
   
   ; --- 2. ПОИСК ТОЧКИ ВСТАВКИ (ВЕЗДЕ GetAnchor) ---
   If *parent
      *insert_after = GetAnchor(*parent, tabpage)
   Else
      ; Если родитель - Root, ищем физический "хвост" всего холста
      *insert_after = GetAnchor(*r, #PB_Default)
   EndIf
   
   ; --- 3. ФИЗИЧЕСКИЙ ПЕРЕНОС / СОЗДАНИЕ ---
   PushListPosition(widgets())
   
   If *this And *this\address ; ПЕРЕНОС
      ; Отвязка
      If *this\prev : *this\prev\next = *this\next : ElseIf *this\parent : *this\parent\first = *this\next : EndIf
      If *this\next : *this\next\prev = *this\prev : ElseIf *this\parent : *this\parent\last = *this\prev : EndIf
      
      ; Определяем конец перемещаемого блока (хвост виджета)
      Protected *last_el_in_block = GetAnchor(*this, #PB_Default)
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

Procedure.i Clone(*original._s_WIDGET)
   If Not *original : ProcedureReturn 0 : EndIf
   
   Protected *new._s_WIDGET = AllocateStructure(_s_WIDGET)
   CopyStructure(*original, *new, _s_WIDGET)
   
   ; --- КРИТИЧЕСКАЯ ПЕРЕПРИВЯЗКА ---
   ; Обнуляем связи, чтобы SetParent прописал их заново для нового места
   *new\parent = 0
   *new\first = 0
   *new\last = 0
   *new\next = 0
   *new\prev = 0
   
   ; Теперь регистрируем его как новый виджет
   ; (Используем твой SetParent, он создаст элемент в списке widgets())
   ProcedureReturn SetParent(*new, *original\parent)
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

Procedure.i Create(*parent._s_WIDGET, class.s, Type.i, X, Y, Width, Height, title.s, flags.q=0)
   Protected this._s_WIDGET
   Protected *new._s_WIDGET 
   
   ; 1. Подготовка данных
   If Not *parent : *parent = Opened() : EndIf
   
   this\Type = Type
   this\class = class
   
   If flags & #__flag_integral
      this\tabindex = - 1 ; Помечаем как "всегда видимый"
   EndIf
   If Type = #__type_Panel
      this\rowheight = 25
   EndIf
   
   If Type = #__type_TabBar
      this\tabindent = 5 ; Начальный отступ (чтобы первый таб не прилипал к рамке)
      this\tabspacing = 5; По умолчанию минимальный зазор
      this\tabpadding = 10
   EndIf

   If Type = #__type_Button
      this\textpadding = 5
      If flags & #__flag_Left
         this\textalign = #_align_left
      ElseIf flags & #__flag_Right
         this\textalign = #_align_right
      Else
         this\textalign = #_align_center
      EndIf
   EndIf
   
   ; Здесь Resize НЕ ВЫЗЫВАЕМ, так как parent еще не привязан к этой 'this'
   ; 2. РЕГИСТРАЦИЯ (теперь у виджета в списке ЕСТЬ родитель)
   *new = SetParent(@this, *parent)
   
   ; 3. УСТАНОВКА КООРДИНАТ (теперь Resize увидит родителя и посчитает real_x/y правильно)
   If *new
      If Type = #__type_Panel Or 
         Type = #__type_Container Or 
         Type = #__type_ScrollArea 
         OpenList(*new) 
      EndIf
      
      Resize(*new, X, Y, Width, Height)
      
      ; 4. КОНТЕКСТ ДЛЯ ПАНЕЛИ
      If Type = #__type_Panel 
         ; Создаем "голову" и "тело"
         *new\tabbar = Create(*new, "TabBar", #__type_TabBar, 0, 0, Width, *new\rowheight, "", #__flag_integral)
         ;
          *new\areabar = Create(*new, "AreaBar", #__type_AreaBar, 0, *new\rowheight, Width, Height - *new\rowheight, "", #__flag_integral)
      EndIf
      
      ; 4. КОНТЕКСТ ДЛЯ СКРОЛЛ-ОБЛАСТИ
      If Type = #__type_ScrollArea 
         *new\areabar = Create(*new, "AreaBar", #__type_AreaBar, 0, 0, Width, Height, "", #__flag_integral)
      EndIf
      
      Widget( ) = *new
      ProcedureReturn *new
   EndIf
EndProcedure

Procedure.i Button( X.l, Y.l, Width.l, Height.l, Text.s, Flag.q = 0, round.l = 0 )
   ProcedureReturn Create( Opened( ), Text, #__type_Button, X, Y, Width, Height, Text, Flag )
EndProcedure
Procedure.i Container( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   ProcedureReturn Create( Opened( ), #PB_Compiler_Procedure, #__type_Container, X, Y, Width, Height, #Null$, Flag )
EndProcedure
Procedure.i Panel(X, Y, W, H, Flag.q = 0)
   ProcedureReturn Create(Opened(), "Panel", #__type_Panel, X, Y, W, H, "", Flag)
EndProcedure

Declare canvas_events( )
Procedure.i Open(window, X, Y, Width, Height, title.s="", flags.q = 0)
   Protected *root._s_ROOT = AllocateStructure(_s_ROOT)
   If IsWindow(window)
      *root\Canvas\window = window
      *root\Canvas\gadget = CanvasGadget(#PB_Any, X, Y, Width, Height)
   Else
      *root\Canvas\window = OpenWindow(#PB_Any, X, Y, Width, Height, title, #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
      *root\Canvas\gadget = CanvasGadget(#PB_Any, 0, 0, Width, Height)
   EndIf
   SetOsData(GadgetID(*root\Canvas\gadget), *root)
   
   Static i:*Root\class = Str(i):i+1
   *root\canvas\dpi = DesktopResolutionX( ) 
   *root\color = $D4FAFAFA
   
   *root\root = *root
   *root\class = "ROOT"
   
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
Procedure add_tab(*this._s_WIDGET, Text.s)
   ; Если у виджета нет таббара — он не поддерживает вкладки. Выходим.
   If Not *this\tabbar : ProcedureReturn : EndIf
   
   Protected *tb._s_WIDGET = *this\tabbar
   
   ; 1. Добавляем элемент в список вкладок Таббара
   AddElement(*tb\__tabs())
   *tb\__tabs()\text = Text
   
   ; 2. Обновляем индекс в самом виджете (он главный "дирижер")
   *this\tabpage = ListSize(*tb\__tabs()) - 1
   
   ; 4. Обновляем ширины текста и перерисовываем
   *this\mask | #__mask_update | #__mask_redraw
EndProcedure

Procedure add_item(*this._s_WIDGET, Text.s)
   If Not *this : ProcedureReturn : EndIf
   AddElement(*this\__rows()) : *this\__rows()\Text = Text
   *this\mask | #__mask_redraw : Draw(*this\root)
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
   
   Protected rx = *this\real_x
   Protected ry = *this\real_y
   ; 1. СТАРТОВАЯ ТОЧКА должна быть такой же, как в DRAW_TAB
   Protected tx = rx + GetTabStartX(*this) - *this\scroll_x
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
         tx + *this\__tabs()\width + *this\tabspacing 
      Next
      PopListPosition(*this\__tabs())
   EndIf
   
   ProcedureReturn *found_tab 
EndProcedure

Procedure.i hover_widget(*root._s_ROOT, mx, my)
   Protected *result._s_WIDGET = *root ; По умолчанию под мышью сам холст
   
   PushListPosition(widgets())
   LastElement(widgets()) ; Идем с конца (верхние слои первыми)
   
   Repeat  
      If widgets()\root = *root And Not (widgets()\mask & #__mask_hidden)
         
         ; Используем расчет реальных координат (с учетом вложенности)
         Protected rx = widgets()\real_x
         Protected ry = widgets()\real_y
         
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
;- --- ОБРАБОТКА КЛИКОВ ---
Procedure UpdateScrollRange(*this._s_WIDGET)
   Protected *g._s_WIDGET ; Наш локальный указатель
   Protected max_h = 0
   
   If Not *this : ProcedureReturn : EndIf
   
   ; Используем наш метод обхода ПРЯМЫХ детей
   Start(*g, *this)
   
   ; 1. Пропускаем скрытые (они не должны раздувать скролл)
   ; и системные элементы (TabBar и т.д.)
   If Not (*g\mask & #__mask_hidden) And Not is_integral_(*g)
      
      ; 2. Проверяем "дно" виджета
      If *g\Y + *g\Height > max_h
         max_h = *g\Y + *g\Height
      EndIf
      
   EndIf
   
   Stop(*g, *this)
   
   ; Записываем реальную высоту контента
   *this\scroll_height = max_h 
   
   ; Здесь же можно сразу обновить состояние полос прокрутки, если они есть
   *this\mask | #__mask_update | #__mask_redraw
EndProcedure

Procedure do_events(*this._s_WIDGET, event)
   Protected *tab._s_TAB
   
   Select event
      Case #PB_EventType_MouseMove
         *tab = hover_tab(*this, mouse()\x, mouse()\y)
         
         ; --- Логика TabEnter / TabLeave ---
         If TabEntered() <> *tab
            ; 1. Уходим со старой вкладки
            If TabEntered()
               TabEntered()\mask & ~#__mask_hover
               *this\mask | #__mask_redraw
            EndIf
            
            ; 2. Заходим на новую
            If *tab
               *tab\mask | #__mask_hover
               *this\mask | #__mask_redraw
            EndIf
            
            TabEntered() = *tab ; Запоминаем текущий для следующего раза
         EndIf
         
      Case #PB_EventType_MouseLeave
         ; Если мышь совсем ушла с виджета
         If TabEntered()
            TabEntered()\mask & ~#__mask_hover
            TabEntered() = 0
            *this\mask | #__mask_redraw
         EndIf
         
         ;       Case #PB_EventType_LeftButtonDown
         ;          If TabEntered()
         ;             ; Debug *this\parent
         ;             If *this
         ;                ; Используем ListIndex напрямую, переключив список на элемент *tab
         ;                PushListPosition(*this\__tabs())
         ;                ChangeCurrentElement(*this\__tabs(), TabEntered())
         ;                SetTab(*this\parent, ListIndex(*this\__tabs())) 
         ;                PopListPosition(*this\__tabs())
         ;                *this\mask | #__mask_redraw
         ;             EndIf
         ;          EndIf
      Case #PB_EventType_LeftButtonDown
         If TabEntered()
            Protected *panel._s_WIDGET = *this\parent 
            ;
            PushListPosition(*this\__tabs())
            ChangeCurrentElement(*this\__tabs(), TabEntered())
            Protected new_index = ListIndex(*this\__tabs())
            PopListPosition(*this\__tabs())
            
            Debug "КЛИК ПО ТАБУ: " + Str(new_index) + " НА ПАНЕЛИ: " + *panel\class
            
            ; ВЫЗЫВАЕМ ПЕРЕКЛЮЧЕНИЕ У ПАНЕЛИ
            SetTab(*panel, new_index) 
         EndIf
         
   EndSelect
EndProcedure

Procedure canvas_events( )
   Protected Gadget = EventGadget( )
   Protected eventtype = EventType( )
   
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
   If eventtype = #PB_EventType_KeyDown         ; A key was Pressed
   EndIf
   If eventtype = #PB_EventType_KeyUp           ; A key was released
   EndIf
   If eventtype = #PB_EventType_Input           ; Text input was generated
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
      
      ;       ; Внутри canvas_events, сразу после получения Entered()
      ;       If eventtype = #PB_EventType_MouseMove
      ;          If Entered()
      ;             Debug "МЫШЬ НАД: " + Entered()\class + " (Тип: " + Str(Entered()\Type) + ")"
      ;          Else
      ;             Debug "МЫШЬ НАД: ПУСТОТОЙ"
      ;          EndIf
      ;       EndIf
      
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
                        Debug "real drag"
                        Pressed( )\mask | #__mask_drag
                        do_events(Pressed( ), #PB_EventType_DragStart)
                     EndIf
                  EndIf
               EndIf
            EndIf
            
            If eventtype = #PB_EventType_MouseWheel
               ;                Protected delta = GetGadgetAttribute(Entered( )\root\Canvas\gadget, #PB_Canvas_WheelDelta)
               ;                Protected *v._s_SCROLL = Entered( )\scroll_v
               ;                Protected *h._s_SCROLL = Entered( )\scroll_h
               ;                
               ;                ; Если зажат Shift крутим по горизонтали
               ;                If mouse( )\mask & #__mask_shift
               ;                   *h\pos - (delta * 30)
               ;                   If *h\pos < 0 : *h\pos = 0 : EndIf
               ;                   If *h\pos > *h\max : *h\pos = *h\max : EndIf
               ;                Else
               ;                   ; Обычный вертикальный скролл
               ;                   *v\pos - (delta * 30)
               ;                   If *v\pos < 0 : *v\pos = 0 : EndIf
               ;                   If *v\pos > *v\max : *v\pos = *v\max : EndIf
               ;                   ;update_visible_rows(Entered( )) ; Не забываем обновлять видимость строк
               ;                EndIf
               ;                
               ;                Entered( )\mask | #__mask_redraw
               
               ;                Protected delta = GetGadgetAttribute(Entered( )\root\Canvas\Gadget, #PB_Canvas_WheelDelta)
               ;                Protected *Target._s_WIDGET = Entered() ; Кто сейчас под мышью?
               ;                
               ;                If *Target
               ;                   ; 2. КТО БУДЕТ СКРОЛЛИТЬСЯ?
               ;                   ; Если мышь над кнопкой, скроллим её родителя (AreaBar или Panel)
               ;                   Protected *ScrollObj._s_WIDGET = *Target
               ;                   If Not *Target\areabar And *Target\parent
               ;                      *ScrollObj = *Target\parent
               ;                   EndIf
               ;                   
               ;                   ; 3. ОБНОВЛЯЕМ ГРАНИЦЫ (чтобы знать, где дно)
               ;                   UpdateScrollRange(*ScrollObj)
               ;                   
               ;                   ; 4. МЕНЯЕМ ПОЗИЦИЮ (30 пикселей за один "щелчок" колеса)
               ;                   *ScrollObj\scroll_y - (delta * 30)
               ;                   
               ;                   ; 5. ЖЕСТКИЕ ОГРАНИЧЕНИЯ (Чтобы не уехать в космос)
               ;                   Protected max_scroll = *ScrollObj\scroll_height - *ScrollObj\Height
               ;                   If max_scroll < 0 : max_scroll = 0 : EndIf
               ;                   
               ;                   If *ScrollObj\scroll_y > max_scroll : *ScrollObj\scroll_y = max_scroll : EndIf
               ;                   If *ScrollObj\scroll_y < 0 : *ScrollObj\scroll_y = 0 : EndIf
               ;                   
               ;                   ; 6. ПРИМЕНЯЕМ ИЗМЕНЕНИЯ
               ;                   ; Resize пересчитает real_y для всех детей внутри с учетом нового scroll_y
               ;                   Resize(*ScrollObj, *ScrollObj\X, *ScrollObj\Y, *ScrollObj\Width, *ScrollObj\Height)
               ;                   
               ;                   ; Перерисовываем холст
               ;                   *ScrollObj\mask | #__mask_redraw
               ;                EndIf
               ;                
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
            Draw(Entered( )\root)
         EndIf
      EndIf
   EndIf
EndProcedure

;-
Procedure.b SetState( *this._s_WIDGET, state.i )
   SetTab( *this, state )
EndProcedure

Procedure   AddItem( *this._s_WIDGET, Item.l, Text.s, img.i = - 1, Flag.q = 0 )
   add_tab( *this, Text)
EndProcedure

Procedure.s GetClass( *this._s_WIDGET )
   If Not *this 
      ProcedureReturn 
   EndIf
   ProcedureReturn *this\class
EndProcedure

Procedure.s GetText( *this._s_WIDGET )
   ProcedureReturn *this\class
EndProcedure

Procedure.l SetColor( *this._s_WIDGET, ColorType.l, color.i, ColorState.b = 0 )
EndProcedure

Procedure   SetClass( *this._s_WIDGET, class.s )
   If *this\class <> class
      *this\class = class
      ProcedureReturn *this
   EndIf
EndProcedure

Macro UseWidgets( )
   ;    UseModule lng
   ;    UseModule Widget
   ;    UseModule constants
   ;    UseModule structures
EndMacro


CompilerIf #PB_Compiler_IsMainFile ;= 99
   EnableExplicit
   ;UseWidgets( )
   
   Global i, X = 220, Panel, butt1, butt2
   Global._s_WIDGET *panel, *butt0, *butt1, *butt2
   
   If Open( #PB_Any, 0, 0, X+170, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      ; ;     Panel = PanelGadget(#PB_Any, 10, 65, 160,95 ) 
      ; ;     For i = 0 To 5 
      ; ;       AddGadgetItem( Panel, i, Hex(i) ) 
      ; ;       If i
      ; ;         ButtonGadget(#PB_Any, 10,5,80,35, "_"+Str(i) ) 
      ; ;       EndIf
      ; ;     Next 
      ; ;     CloseGadgetList( )
      ; ;     
      ; ;     OpenGadgetList( Panel, 0 )
      ; ;     ButtonGadget(#PB_Any, 10,5,80,35, "_0" ) 
      ; ;     CloseGadgetList( )
      ; ;     
      ; ;     ;
      ; ;     butt1 = ButtonGadget(#PB_Any, 10,5,80,25, "*butt1" ) 
      ; ;     butt2 = ButtonGadget(#PB_Any, 10,35,80,25, "*butt2" ) 
      ; ;     
      ; ;     SetGadgetState( Panel, 2 )
      ; ;     
      ; ;     
      
      *panel = Panel( X, 65, 160,95 ) 
      For i = 0 To 5 
         AddItem( *panel, i, Hex(i) ) 
         If i
            Button( 10,5,80,35, "_"+Str(i) ) 
         EndIf
      Next 
      CloseList( )
      
      OpenList( *panel, 0 )
      Button( 20,25,80,35, "_0" ) 
      CloseList( )
      
      ;     *butt0 = Button( 20,25,80,35, "_0" )
      ;     SetParent( *butt0, *panel, 0 )
      
     ; Debug Opened()\class
      ;
      *butt1 = Button( X,5,80,25, "*butt1" ) 
      *butt2 = Button( X,35,80,25, "*butt2" ) 
     ; Debug *butt2\parent\class
      
      If *panel
       ;  SetState( *panel, 2 )
      EndIf
      
      ReDraw(Root())
      
      Repeat: Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf   
CompilerEndIf
CompilerIf #PB_Compiler_IsMainFile = 99
   ;- --- ТЕСТ ---
   Root( ) = Open(0, 0, 0, 500, 400, "My Custom Framework")
   
   ; Define._s_WIDGET *P = Panel(20, 20, 400, 300)
   ;   add_tab(*P, "Вкладка 1") ; индекс 0
   ;   add_tab(*P, "Вкладка 2") ; индекс 1
   ;   add_tab(*P, "Вкладка 3") ; индекс 2
   ; CloseList()
   ; 
   ; ; ТЕСТ:
   ; disable_tab(*P, 1) ; Вторая вкладка станет серой и не нажмется
   ; hide_tab(*P, 2)    ; Третья вкладка просто исчезнет из шапки
   
   ; 1. Главная панель
   Define._s_WIDGET *P1 = Panel(20, 20, 400, 300)
   add_tab(*P1, "Вкладка А") ; Индекс 0
                             ;Create(*P1, "Кнопка на А", #__type_Button, 10, 40, 100, 30,"")
   Button(10, 40, 100, 30, "Кнопка на А")
   
   add_tab(*P1, "Вкладка Б") ; Индекс 1
   Define._s_WIDGET *P2 = Panel(10, 40, 300, 200) ; Создана на Вкладке Б
   add_tab(*P2, "Sub 1")
   Create(*P2, "Я в Sub 1", #__type_Button, 10, 10, 100, 30,"") ; X,Y теперь ОТ КРАЯ ПАНЕЛИ
   
   add_tab(*P2, "Sub 2")
   Create(*P2, "Я в Sub 2", #__type_Button, -10, 10, 100, 30,"")
   
   add_tab(*P2, "Sub 3")
   Create(*P2, "Я в Sub 3", #__type_Button, 30, 50, 100, 30,"")
   CloseList()
   
   CloseList()
   
   ; 1. Главная панель
   ; Define._s_WIDGET *P1 = Panel(20, 20, 400, 300)
   ; add_tab(*P1, "Вкладка А") ; Индекс 0
   ; add_tab(*P1, "Вкладка Б") ; Индекс 1
   ; 
   ; ; 2. Наполняем "Вкладку А"
   ; *P1\tabpage = 0
   ; Create(*P1, "Кнопка на А", #__type_Button, 10, 40, 100, 30,"")
   ; 
   ; ; 3. Наполняем "Вкладку Б" и ВНУТРЬ КЛАДЕМ ЕЩЕ ПАНЕЛЬ
   ; *P1\tabpage = 1
   ; Define._s_WIDGET *P2 = Panel(10, 40, 300, 200) ; Создана на Вкладке Б
   ; add_tab(*P2, "Sub 1")
   ; add_tab(*P2, "Sub 2")
   ; 
   ; ; Наполняем вложенную панель
   ; *P2\tabpage = 0
   ; Create(*P2, "Я в Sub 1", #__type_Button, 10, 10, 100, 30,"") ; X,Y теперь ОТ КРАЯ ПАНЕЛИ
   ; 
   ; *P2\tabpage = 1
   ; Create(*P2, "Я в Sub 2", #__type_Button, 10, 10, 100, 30,"")
   
   ; ; Сбросим в начало
   *P1\tabpage = 0 : *P2\tabpage = 0
   Draw(Root( ))
   
   Procedure DebugWidgets()
      Debug "--- ДАМП СПИСКА ВИДЖЕТОВ (Z-Order) ---"
      PushListPosition(widgets())
      ForEach widgets()
         Protected indent.s = ""
         ; Визуальный отступ для вложенности
         Protected *p._s_WIDGET = widgets()\parent
         While *p
            indent + "  "
            *p = *p\parent
         Wend
         
         Debug indent + "[" + widgets()\class + "] ID: " + Str(@widgets()) + 
               " | Type: " + Str(widgets()\Type) + 
               " | RY: " + Str(widgets()\real_y) + 
               " | H: " + Str(widgets()\Height) +
               " | Hidden: " + Str(widgets()\mask & #__mask_hidden) +
               " | Page: " + Str(widgets()\tabindex) 
         
      Next
      PopListPosition(widgets())
      Debug "---------------------------------------"
   EndProcedure
   ; DebugWidgets()
   
   ; If StartEnum( *P2, 2 )
   ;    If widgets()\tabindex = -1 : Continue : EndIf
   ;    Debug widgets( )\class
   ;    StopEnum( )
   ; EndIf
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 1505
; FirstLine = 984
; Folding = -----w----8u8-vv0--vvP------8----+---4---------8
; EnableXP
; DPIAware