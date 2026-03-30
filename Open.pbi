EnableExplicit

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

; Прототип функции, которую ты будешь привязывать через Bind
Prototype.i ProtoOnEvent(*this, Type.i)

Structure _s_SIZE
   Width.l
   Height.l
EndStructure

Structure _s_POINT
   Y.l
   X.l
EndStructure

Structure _s_COORDINATE Extends _s_SIZE
   X.l
   Y.l
EndStructure

Structure _s_MOUSE Extends _s_POINT
   *widget._s_WIDGET[3] ; entered - [0]; leaved - [1]; pressed - [2]
EndStructure

Structure _s_KEYBOARD  ; Ok
   *active._S_WIDGET   ; keyboard focus element ; GetActive( )\
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   class.s
   Type.i
   color.i
   name.s
   *address
   
   *root._s_ROOT
   *parent._s_WIDGET
   *first._s_WIDGET ; Указатель на первый виджет в глобальном списке для этого холста
   *last._s_WIDGET  ; Указатель на последний виджет этого холста

   OnEvent.ProtoOnEvent[#__event] ; Указатель на процедуру событий
EndStructure

Structure _s_CANVAS
   dpi.f
   window.i
   gadget.i
EndStructure

Structure _s_ROOT Extends _s_WIDGET
   *next._s_ROOT
   *prev._s_ROOT
   
   Canvas._s_CANVAS
EndStructure

Structure _s_GUI
   *root._s_ROOT
   *opened._s_WIDGET             ; last opened-list element
         
   mouse._s_MOUSE                ; mouse( )\
   keyboard._s_KEYBOARD          ; keyboard( )\
   List Widget._s_WIDGET()
EndStructure

Global GUI._s_GUI
Macro widgets(): GUI\Widget(): EndMacro

Macro Root()
   GUI\root
EndMacro
Macro Opened()
   GUI\opened
EndMacro
Macro Entered()
   GUI\mouse\widget[0]
EndMacro
Macro Leaved( )
   GUI\mouse\widget[1]
EndMacro
Macro Pressed()
   GUI\mouse\widget[2] ; Третий слот в массиве для нажатого виджета
EndMacro
Macro GetActive()
   GUI\keyboard\active
EndMacro

Macro StartEnum(_parent_ptr_)
   Bool(_parent_ptr_ And _parent_ptr_\first)
   ChangeCurrentElement(widgets(), _parent_ptr_\first)
   Repeat 
      If _parent_ptr_\root
         If widgets()\root = _parent_ptr_\root\next
            Break
         EndIf
      Else
         If widgets()\root = _parent_ptr_\next
            Break
         EndIf
      EndIf
   EndMacro
   Macro StopEnum( )
   Until Not NextElement(widgets())
EndMacro



Declare Draw(*root._s_ROOT)

;-
Procedure.i X(*this._s_WIDGET)
   Protected X.i = *this\x
   ; Если есть родитель, рекурсивно прибавляем его X
   If *this\parent
      X + X(*this\parent)
   EndIf
   ProcedureReturn X
EndProcedure

Procedure.i Y(*this._s_WIDGET)
   Protected Y.i = *this\y
   If *this\parent
      Y + Y(*this\parent)
   EndIf
   ProcedureReturn Y
EndProcedure

;-
; Отправка события (вызывает привязанную процедуру)
Procedure Post(*this._s_WIDGET, event.i)
   Protected result.i = 0
   Protected all_idx.i = #__event - 1
   
   ; 1. Твоя критическая проверка: превращаем #PB_All в индекс массива
   If event = #PB_All : event = all_idx : EndIf
   
   If Not *this : ProcedureReturn : EndIf
   
   ; --- 2. ОБРАБОТКА ВИДЖЕТА ---
   ; Если это НЕ универсальный индекс, вызываем специфический обработчик
   If event <> all_idx
      If *this\OnEvent[event]
         result = *this\OnEvent[event](*this, event)
      EndIf
   EndIf
   
   ; Вызываем универсальный обработчик (из последнего слота)
   ; только если специфический не вернул #PB_Ignore
   If result <> #PB_Ignore And *this\OnEvent[all_idx]
      result = *this\OnEvent[all_idx](*this, event)
   EndIf
   
   ; --- 3. ВСПЛЫТИЕ К ROOT ---
   If result <> #PB_Ignore And *this\root And *this\root <> *this
      ; Специфический корень
      If event <> all_idx And *this\root\OnEvent[event]
         result = *this\root\OnEvent[event](*this, event)
      EndIf
      
      ; Универсальный корень
      If result <> #PB_Ignore And *this\root\OnEvent[all_idx]
         *this\root\OnEvent[all_idx](*this, event)
      EndIf
   EndIf
EndProcedure

; Привязка процедуры к виджету
Procedure Bind(*this._s_WIDGET, *callback, event.i = #PB_All)
   Protected *r._s_ROOT
   Protected idx.i = event
   Protected all_idx.i = #__event - 1
   
   ; 1. Превращаем #PB_All в индекс универсального слота
   If event = #PB_All : idx = all_idx : EndIf
   
   ; 2. Проверка границ массива
   If idx < 0 Or idx >= #__event : ProcedureReturn : EndIf
   
   If *this = #PB_All
      *r = Root()
      If Not *r : ProcedureReturn : EndIf
      ; Отматываем в начало цепочки холстов
      While *r\prev : *r = *r\prev : Wend 
      
      While *r
         *r\OnEvent[idx] = *callback ; Теперь пишем строго в нужный индекс массива
         *r = *r\next
      Wend
   Else
      If *this
         *this\OnEvent[idx] = *callback
      EndIf
   EndIf
EndProcedure

Procedure Unbind(*this._s_WIDGET, event.i = #PB_All)
   Protected *r._s_ROOT
   Protected idx.i = event
   Protected all_idx.i = #__event - 1
   
   If event = #PB_All : idx = all_idx : EndIf
   If idx < 0 Or idx >= #__event : ProcedureReturn : EndIf
   
   If *this = #PB_All
      *r = Root()
      If Not *r : ProcedureReturn : EndIf
      While *r\prev : *r = *r\prev : Wend
      
      While *r
         *r\OnEvent[idx] = 0 ; Обнуляем конкретный слот у всех холстов
         *r = *r\next
      Wend
   Else
      If *this
         *this\OnEvent[idx] = 0 ; Обнуляем слот у конкретного виджета
      EndIf
   EndIf
EndProcedure

Procedure SetActive( *this._s_WIDGET )
   Protected *g._s_ROOT
   
   If GetActive() <> *this
      If GetActive() 
         *g = GetActive()
         GetActive() = 0
         Post(*g, #__event_LostFocus)
         Draw( *g\root )
      EndIf
      
      GetActive() = *this
      Post(*this, #__event_Focus)
   EndIf
EndProcedure

;-
Procedure MoveForward(*root._s_ROOT)
   ; Если впереди никого нет — выходим
   If Not *root Or Not *root\next : ProcedureReturn : EndIf
   
   ; 1. Связываем предыдущего со следующим (пропускаем текущий)
   If *root\prev : *root\prev\next = *root\next : EndIf
   *root\next\prev = *root\prev
   
   ; 2. Теперь вставляем текущий ПОСЛЕ того, кто был следующим
   *root\prev = *root\next           ; Теперь мой "прошлый" — это мой бывший "будущий"
   *root\next = *root\next\next      ; Мой "будущий" — это тот, кто был через одного
   
   ; 3. Завершаем цепочку
   If *root\next : *root\next\prev = *root : EndIf
   *root\prev\next = *root
   If *root\next = 0 : Root( ) = *root : EndIf
EndProcedure

Procedure MoveBackward(*root._s_ROOT)
   ; Если сзади никого нет — выходим
   If Not *root Or Not *root\prev : ProcedureReturn : EndIf
   
   ; 1. Связываем следующего с предыдущим (вынимаем текущий)
   If *root\next : *root\next\prev = *root\prev : EndIf
   *root\prev\next = *root\next
   
   ; 2. Вставляем текущий ПЕРЕД тем, кто был предыдущим
   *root\next = *root\prev           
   *root\prev = *root\prev\prev       
   
   ; 3. Завершаем цепочку
   If *root\prev : *root\prev\next = *root : EndIf
   *root\next\prev = *root
   If *root\next = 0 : Root( ) = *root : EndIf
EndProcedure

;-
Procedure.i SetParent(*this._s_WIDGET, *parent._s_WIDGET, tabindex.l = #PB_Default)
   Protected *r._s_ROOT, *old_r._s_ROOT, *new._s_WIDGET
   
   ; 1. Определяем целевой холст (root)
   If *parent
      If *parent\root : *r = *parent\root : Else : *r = *parent : EndIf
   Else
      *r = Root() 
   EndIf
   If Not *r : ProcedureReturn 0 : EndIf
   
   ; 2. ЛОГИКА ПЕРЕМЕЩЕНИЯ (Вместо создания копий)
   If *this And *this\root
      *old_r = *this\root
      
      If *old_r <> *r
         PushListPosition(widgets())
         ChangeCurrentElement(widgets(), *this) ; Встаем на сам виджет в списке
         
         ; --- ОБНОВЛЯЕМ УКАЗАТЕЛИ СТАРОГО ХОЛСТА ---
         ; Если виджет был единственным, первым или последним в своем старом холсте
         If *old_r\first = *this
            NextElement(widgets())
            If widgets()\root = *old_r : *old_r\first = @widgets() : Else : *old_r\first = 0 : EndIf
            ChangeCurrentElement(widgets(), *this) ; Возвращаемся на *this
         EndIf
         
         If *old_r\last = *this
            PreviousElement(widgets())
            If widgets()\root = *old_r : *old_r\last = @widgets() : Else : *old_r\last = 0 : EndIf
            ChangeCurrentElement(widgets(), *this) ; Возвращаемся на *this
         EndIf
         
         ; --- ПЕРЕНОСИМ В НОВЫЙ ХОЛСТ ---
         If *r\last
            ; Вставляем сразу после последнего виджета нового холста
            MoveElement(widgets(), #PB_List_After, *r\last)
         Else
            ; Если новый холст пуст — в самый конец общего списка
            LastElement(widgets())
            MoveElement(widgets(), #PB_List_After)
            *r\first = *this
         EndIf
         
         *r\last = *this ; Теперь этот виджет стал последним в новом холсте
         PopListPosition(widgets())
         
         Draw(*old_r) ; Перерисовываем старый (откуда ушли)
      EndIf
   Else
      ; --- ЕСЛИ ВИДЖЕТА ЕЩЕ НЕТ В СПИСКЕ (Новое создание) ---
      If *r\last
         ; Если у холста уже есть виджеты, встаем на последний из них
         ChangeCurrentElement(widgets(), *r\last)
         ; Добавляем новый СРАЗУ ПОСЛЕ него
         *new = AddElement(widgets())
      Else
         ; Если это самый первый виджет для этого холста
         LastElement(widgets()) ; Идем в конец общего списка
         *new = AddElement(widgets())
         *r\first = *new   ; Запоминаем как начало секции холста
      EndIf
      
      ; Копируем данные из временного шаблона *this в новый элемент списка
      CopyStructure(*this, *new, _s_WIDGET) 
      
      *r\last = *new ; Новый элемент теперь последний для этого холста
      *this = *new   ; Теперь работаем с элементом из списка
   EndIf
   
   ; 3. ОБНОВЛЯЕМ ИЕРАРХИЮ
   *this\root = *r
   *this\parent = *parent
   
   ; 4. ПЕРЕРИСОВЫВАЕМ
   Draw(*this\root)
   
   ProcedureReturn *this
EndProcedure

;-
Procedure AtPoint(*root._s_ROOT, mx, my)
   Protected result
   ; Перебор с конца в начало (LastElement -> Previous), 
   ; чтобы верхние виджеты ловили клик первыми
   PushListPosition(widgets())
   LastElement(widgets())
   Repeat  
      If widgets()\root = *root
         If mx >= widgets()\x And mx <= widgets()\x + widgets()\width And 
            my >= widgets()\y And my <= widgets()\y + widgets()\height
            result = widgets()
         EndIf
      EndIf
   Until Not PreviousElement(widgets())
   PopListPosition(widgets())
   ProcedureReturn result
EndProcedure

; --- Отрисовка ---
Procedure Draw(*root._s_ROOT)
   If Not *root\first : ProcedureReturn : EndIf
   
   If StartDrawing(CanvasOutput(*root\Canvas\gadget))
      Box(0, 0, OutputWidth(), OutputHeight(), $F0F0F0) 
      
      ; Прыгаем в начало секции этого холста
      ChangeCurrentElement(widgets(), *root\first)
      Repeat 
         Box(widgets()\x, widgets()\y, widgets()\Width, widgets()\Height, widgets()\color)
         
         ; Если этот виджет активен - рисуем рамку
         If Entered( ) = widgets()
            Box( widgets()\x, widgets()\y, widgets()\Width, widgets()\Height, $00FF00) ; Синяя рамка
         EndIf
         ; Если этот виджет активен - рисуем рамку
         If GetActive( ) = widgets()
            Box( widgets()\x, widgets()\y, widgets()\Width, widgets()\Height, $0000FF) ; Синяя рамка
         EndIf
         
         ; Если дошли до последнего виджета этого окна — выходим
         If widgets() = *root\last
            Break
         EndIf
      Until Not NextElement(widgets())
      
      StopDrawing()
   EndIf
EndProcedure

Procedure ReDraw(*root._s_ROOT)
   Protected *r._s_ROOT = *root ; Сохраняем входную точку в локальную переменную
   
   ; 1. Отматываем в самое начало (к первому/нижнему окну)
   While *r\prev
      *r = *r\prev
   Wend
   
   ; 2. Рисуем все элементы по порядку (снизу вверх)
   While *r
      ; Debug "Отрисовка холста: " + *r + " (Имя: " + widgets()\name + ")"
      Draw(*r)
      *r = *r\next ; Переходим к следующему
   Wend
EndProcedure

;-
Procedure Free( *this._s_WIDGET )
   
EndProcedure

Procedure.i Create(*parent._s_WIDGET, X, Y, Width, Height, title.s, color, Type = 0)
   Protected tmp._s_WIDGET 
   ; Заполняем только данные, остальное сделает SetParent
   tmp\Type   = Type
   tmp\x      = X ; DPI добавим внутри или в Draw
   tmp\y      = Y 
   tmp\Width  = Width 
   tmp\Height = Height 
   tmp\color  = color 
   tmp\name   = title
   
   ProcedureReturn SetParent(@tmp, *parent)
EndProcedure


Procedure Button(X,Y,Width,Height, Text.s, Flags.q=0)
   
EndProcedure

Procedure Container(X,Y,Width,Height, Flags.q=0)
   
EndProcedure

Procedure OpenList(*this._s_WIDGET, item.i = 0)
   ; Запоминаем, что теперь все новые виджеты будут дочерними для *this
   Opened() = *this
EndProcedure

Procedure CloseList()
   ; Возвращаемся на уровень выше или в корень
   If Opened()
      Opened() = Opened()\parent
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
      
      ; 3. ОЧИСТКА ПАМЯТИ
      If IsGadget(*root\Canvas\gadget)
         FreeGadget(*root\Canvas\gadget)
      EndIf
      FreeStructure(*root)
   EndIf
EndProcedure

Procedure Open( window, X,Y,Width,Height, title.s )
   Protected *root._s_ROOT = AllocateStructure(_s_ROOT)
   If IsWindow(window)
      *root\Canvas\window = window
      *root\Canvas\gadget = CanvasGadget(#PB_Any, X,Y,Width,Height)
   Else
      *root\Canvas\window = OpenWindow(#PB_Any, X,Y,Width,Height, title)
      *root\Canvas\gadget = CanvasGadget(#PB_Any, 0, 0, Width,Height)
   EndIf
   SetGadgetData(*root\Canvas\gadget, *root )
   
   Static i:*Root\class = Str(i):i+1
   
   ; Получаем масштаб окна (встроено в PB 5.70+)
   *root\canvas\dpi = DesktopResolutionX() 
   
   If Root( )
      Root( )\next = *root
      Root( )\next\prev = Root( )
   EndIf
   Root( ) = *root 
   
   ProcedureReturn *root
EndProcedure


;-
Procedure   EventHandler( EvGadget = - 1, EvType = - 1, eventdata = 0 )
   Protected mx,my
   ; 2. ОБРАБОТКА (Клик по виджету)
   If EvType = #PB_EventType_MouseEnter
      Root( ) = GetGadgetData(EvGadget)
   EndIf
   
   If Root( )
      If EvType = #PB_EventType_MouseMove
         If EvGadget = Root( )\Canvas\gadget 
            ; Debug "enter "+Root()\class
            mx = GetGadgetAttribute(Root( )\Canvas\gadget, #PB_Canvas_MouseX) / Root()\canvas\dpi
            my = GetGadgetAttribute(Root( )\Canvas\gadget, #PB_Canvas_MouseY) / Root()\canvas\dpi
            
            Entered( ) = AtPoint( Root( ), mx, my )
            ; --- Логика Enter / Leave ---
            If Entered() <> Leaved( )
               If Leaved( )
                  Post(Leaved( ), #__event_MouseLeave)
                  Draw(Leaved( )\root) ; Перерисовываем для отображения рамок
               EndIf
               
               If Entered()
                  Post(Entered(), #__event_MouseEnter)
               EndIf
               
               Leaved( ) = Entered()
               Draw(Root()) ; Перерисовываем для отображения рамок
            EndIf
         EndIf
      EndIf
      
      If EvType = #PB_EventType_LeftButtonDown
         If Entered()
            Pressed() = Entered()
            SetActive(Entered())
            Post(Entered(), #__event_Down)
            Draw(Root())
         EndIf
      EndIf
      
      If EvType = #PB_EventType_LeftButtonUp
         If Pressed()
            Post(Pressed(), #__event_Up)
            Pressed() = 0
            Draw(Root())
         EndIf
      EndIf
   EndIf
   
EndProcedure

; FIXED CANVAS EVENTS
IncludeFile "FCE.pbi"

Procedure all_events(*this._s_WIDGET, event)
   
   Select event
      Case #__event_MouseEnter
         Debug "Зашли на: " + *this\name
      Case #__event_MouseLeave
         Debug "Вышли из: " + *this\name
      Case #__event_DragStart
         Debug "Нвчали тащить: " + *this\name
      Case #__event_Down
         Debug "Нажали на: " + *this\name
      Case #__event_Up
         Debug "Отпустили на: " + *this\name
      Case #__event_Focus
         Debug "Фокус на: " + *this\name
      Case #__event_LostFocus
         Debug "Убрали фокус на: " + *this\name
   EndSelect
   
EndProcedure


Global *r, *r1,*r2,*r3,*r4,*r5, *g
; --- Создаем 2 окна ---
*r = Open(#PB_Any, 100, 200, 200, 200, "Окно 1")
Create(*r, 20,20,60,60,"Квадрат окна 1", $CCCCCC)
; Draw(*r)

*r = Open(#PB_Any, 350, 200, 200, 200, "Окно 2")
Create(*r, 100,100,80,40,"Квадрат окна 2", $AAAAAA)
; Draw(*r)

; В одном окне
Global win = OpenWindow(#PB_Any, 600, 100, 410, 410, "4 Холста в одном окне")

; Создаем 4 независимых корня/холста
*r1 = Open(win, 0,   0,   200, 200, "Топ-Лево")
*r2 = Open(win, 205, 0,   200, 200, "Топ-Право")
*r3 = Open(win, 0,   205, 200, 200, "Бот-Лево")
*r4 = Open(win, 205, 205, 200, 200, "Бот-Право")
*r5 = Open(win, 40,   40,   230, 230, "Топ-Лево")

*g = Create(*r1, 20,20,60,60,"Квадрат 1", $CCCCCC)
Create(*r2, 20,20,60,60,"Квадрат 2", $CCCCCC)
Create(*r3, 20,20,60,60,"Квадрат 3", $CCCCCC)
Create(*r4, 20,20,60,60,"Квадрат 4", $CCCCCC)
Create(*r5, 40,40,120,120,"Квадрат 5", $CCCCCC)

ReDraw(Root( ))

;-
Bind( #PB_All, @all_events())

; --- ГЛАВНЫЙ ЦИКЛ ---
Repeat
   Define Event = WaitWindowEvent()
   Define EvWin = EventWindow()
   
   If Event = #PB_Event_Gadget
      Define EvGadget = EventGadget()
      Define EvType = EventType()
      ; EventHandler( EvGadget, EvType, EventData() )
   EndIf
   
Until Event = #PB_Event_CloseWindow

Close(#PB_All)
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 96
; FirstLine = 101
; Folding = --------------------
; EnableXP
; DPIAware