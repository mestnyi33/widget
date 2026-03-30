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
   mask.q
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
   
   *next._s_ROOT
   *prev._s_ROOT
EndStructure

Structure _s_ROOT Extends _s_WIDGET
   Canvas._s_CANVAS
EndStructure

Structure _s_GUI
   *root._s_ROOT
   ; *opened._s_WIDGET             ; last opened-list element
   
   mouse._s_MOUSE                ; mouse( )\
   keyboard._s_KEYBOARD          ; keyboard( )\
   List *OpenList._s_WIDGET()
   List Widget._s_WIDGET()
EndStructure

Global GUI._s_GUI
Macro widgets(): GUI\Widget(): EndMacro

Macro Root()
   GUI\root
EndMacro
Macro NextRoot()
   Canvas\next
EndMacro
Macro PrevRoot()
   Canvas\prev
EndMacro

Macro Opened()
   GUI\OpenList( ) ;opened
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
         If widgets()\root = _parent_ptr_\root\NextRoot( )
            Break
         EndIf
      Else
         If widgets()\root = _parent_ptr_\NextRoot( )
            Break
         EndIf
      EndIf
   EndMacro
   Macro StopEnum( )
   Until Not NextElement(widgets())
EndMacro

Macro ChangeCurrentCanvas( _canvasID_, _change_root_ = 1 )
   Root( ) = GetGadgetData( ) ; FindMapElement( GUI\roots( ), Str( _canvasID_ ) )
EndMacro

Declare Draw(*root._s_ROOT)

;-
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
   CompilerIf Subsystem("Qt")
      ; Импортируем нужные функции из библиотеки Qt
      ImportC "-lQt5Core" ; Для систем с Qt5 (стандарт для текущих версий PB)
                          ; QObject::setProperty(const char *name, const QVariant &value)
                          ; Мы упрощаем вызов, так как PB передает указатели
         q_object_set_property(obj.i, name.p-utf8, value.i) 
         q_object_get_property(obj.i, name.p-utf8)
      EndImport
   CompilerEndIf
CompilerEndIf

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

; Получить реальный X на холсте (с учетом всех родителей)
Procedure.i X(*this._s_WIDGET)
   Protected X = *this\x
   Protected *p._s_WIDGET = *this\parent
   While *p
      X + *p\x
      *p = *p\parent
   Wend
   ProcedureReturn X
EndProcedure

Procedure.i Y(*this._s_WIDGET)
   Protected Y = *this\y
   Protected *p._s_WIDGET = *this\parent
   While *p
      Y + *p\y
      *p = *p\parent
   Wend
   ProcedureReturn Y
EndProcedure

Procedure.i AbstractX(*this._s_WIDGET)
   Protected X.i = *this\x
   ; Если есть родитель, рекурсивно прибавляем его X
   If *this\parent
      X + AbstractX(*this\parent)
   EndIf
   ProcedureReturn X
EndProcedure

Procedure.i AbstractY(*this._s_WIDGET)
   Protected Y.i = *this\y
   If *this\parent
      Y + AbstractY(*this\parent)
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
      While *r\PrevRoot( ) : *r = *r\PrevRoot( ) : Wend 
      
      While *r
         *r\OnEvent[idx] = *callback ; Теперь пишем строго в нужный индекс массива
         *r = *r\NextRoot( )
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
      While *r\PrevRoot( ) : *r = *r\PrevRoot( ) : Wend
      
      While *r
         *r\OnEvent[idx] = 0 ; Обнуляем конкретный слот у всех холстов
         *r = *r\NextRoot( )
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
   If Not *root Or Not *root\NextRoot( ) : ProcedureReturn : EndIf
   
   ; 1. Связываем предыдущего со следующим (пропускаем текущий)
   If *root\PrevRoot( ) : *root\PrevRoot( )\NextRoot( ) = *root\NextRoot( ) : EndIf
   *root\NextRoot( )\PrevRoot( ) = *root\PrevRoot( )
   
   ; 2. Теперь вставляем текущий ПОСЛЕ того, кто был следующим
   *root\PrevRoot( ) = *root\NextRoot( )           ; Теперь мой "прошлый" — это мой бывший "будущий"
   *root\NextRoot( ) = *root\NextRoot( )\NextRoot( )      ; Мой "будущий" — это тот, кто был через одного
   
   ; 3. Завершаем цепочку
   If *root\NextRoot( ) : *root\NextRoot( )\PrevRoot( ) = *root : EndIf
   *root\PrevRoot( )\NextRoot( ) = *root
   If *root\NextRoot( ) = 0 : Root( ) = *root : EndIf
EndProcedure

Procedure MoveBackward(*root._s_ROOT)
   ; Если сзади никого нет — выходим
   If Not *root Or Not *root\PrevRoot( ) : ProcedureReturn : EndIf
   
   ; 1. Связываем следующего с предыдущим (вынимаем текущий)
   If *root\NextRoot( ) : *root\NextRoot( )\PrevRoot( ) = *root\PrevRoot( ) : EndIf
   *root\PrevRoot( )\NextRoot( ) = *root\NextRoot( )
   
   ; 2. Вставляем текущий ПЕРЕД тем, кто был предыдущим
   *root\NextRoot( ) = *root\PrevRoot( )           
   *root\PrevRoot( ) = *root\PrevRoot( )\PrevRoot( )       
   
   ; 3. Завершаем цепочку
   If *root\PrevRoot( ) : *root\PrevRoot( )\NextRoot( ) = *root : EndIf
   *root\NextRoot( )\PrevRoot( ) = *root
   If *root\NextRoot( ) = 0 : Root( ) = *root : EndIf
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
   Protected color.l
   
   If StartDrawing(CanvasOutput(*root\Canvas\gadget))
      Box(0, 0, OutputWidth(), OutputHeight(), $F0F0F0) 
      
      ; Прыгаем в начало секции этого холста
      If *root\first 
         ChangeCurrentElement(widgets(), *root\first)
         Repeat 
            If GetActive( ) = widgets()
               color = $0000FF
            ElseIf Entered( ) = widgets()
               color = $00FF00 
            Else
               color = widgets()\color
            EndIf
            
            Box( widgets()\x, widgets()\y, widgets()\Width, widgets()\Height, color) ; Синяя рамка
            DrawText( widgets()\x, widgets()\y, widgets()\name, $000000, color )
            
            ; Если дошли до последнего виджета этого окна — выходим
            If widgets() = *root\last
               Break
            EndIf
         Until Not NextElement(widgets())
      EndIf
      
      StopDrawing()
   EndIf
EndProcedure

Procedure ReDraw(*root._s_ROOT)
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
   ProcedureReturn Create(Opened(), X, Y, Width, Height, Text.s, $CCCCCC, #__type_Button )
EndProcedure

Procedure Container(X,Y,Width,Height, Flags.q=0)
   ProcedureReturn Create(Opened(), X, Y, Width, Height, "", $CCCCCC, #__type_Container )
EndProcedure

; Procedure.i _OpenList(*this._s_WIDGET, item.l = 0)
;    If Not *this : ProcedureReturn #False : EndIf
;    
;    ; Если уже есть открытый контекст — запоминаем его как "предыдущий"
;    If Opened() And Opened() <> *this
;       *this\parent[1] = Opened()
;    EndIf
; 
;    ; Устанавливаем текущий активный элемент
;    Opened() = *this
;    ProcedureReturn #True
; EndProcedure
; 
; Procedure.i _CloseList()
;    ; Если у текущего элемента есть записанный "путь назад" — идем по нему
;    If Opened() And Opened()\parent[1]
;       Opened() = Opened()\parent[1]
;    EndIf
;    
;    ProcedureReturn Opened()
; EndProcedure

Procedure.i OpenList(*this._s_WIDGET, item.l = 0)
   If Not *this : ProcedureReturn #False : EndIf
   
   ; Добавляем новый "слой" в стек и записываем туда адрес виджета
   AddElement(Opened())
   Opened() = *this
   
   ProcedureReturn #True
EndProcedure

Procedure.i CloseList()
   ; Если в стеке есть элементы — удаляем текущий (последний)
   If ListSize(Opened()) > 1
      DeleteElement(Opened())
      ; Переходим на предыдущий элемент стека
      LastElement(Opened())
   EndIf
   
   ; Теперь Opened() указывает на того, кто был в стеке до этого
   ProcedureReturn Opened()
EndProcedure

;-
Procedure Close( *root._s_ROOT )
   Protected *next._s_ROOT ; Временная переменная для безопасного перехода
   
   If *root = #PB_All
      *root = Root()
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
      If Entered() And Entered()\root = *root : Entered() = 0 : EndIf
      If Leaved() And Leaved()\root = *root : Leaved() = 0 : EndIf
      If Pressed() And Pressed()\root = *root : Pressed() = 0 : EndIf
      If GetActive() And GetActive()\root = *root : GetActive() = 0 : EndIf
      
      ; --- Одиночное удаление ---
      ; 1. СВЯЗЫВАЕМ СОСЕДЕЙ (вырезаем из цепи)
      If *root\PrevRoot( ) : *root\PrevRoot( )\NextRoot( ) = *root\NextRoot( ) : EndIf
      If *root\NextRoot( ) : *root\NextRoot( )\PrevRoot( ) = *root\PrevRoot( ) : EndIf
      
      ; 2. ПЕРЕНОСИМ ГЛОБАЛЬНЫЙ УКАЗАТЕЛЬ
      If Root() = *root
         If *root\PrevRoot( )
            Root() = *root\PrevRoot( )
         Else
            Root() = *root\NextRoot( )
         EndIf
      EndIf
      
      ; 3. ОЧИСТКА ПАМЯТИ
      If IsGadget(*root\Canvas\gadget)
         FreeGadget(*root\Canvas\gadget)
      EndIf
      FreeStructure(*root)
   EndIf
EndProcedure

Procedure Open( window, X,Y,Width,Height, title.s, flags.q=0 )
   Protected *root._s_ROOT = AllocateStructure(_s_ROOT)
   If IsWindow(window)
      *root\Canvas\window = window
      *root\Canvas\gadget = CanvasGadget(#PB_Any, X,Y,Width,Height)
   Else
      *root\Canvas\window = OpenWindow(#PB_Any, X,Y,Width,Height, title)
      *root\Canvas\gadget = CanvasGadget(#PB_Any, 0, 0, Width,Height)
   EndIf
   SetOsData(GadgetID(*Root\Canvas\gadget), *root )
   
   Static i:*Root\class = Str(i):i+1
   
   ; Получаем масштаб окна (встроено в PB 5.70+)
   *root\canvas\dpi = DesktopResolutionX() 
   
   If Root( )
      Root( )\NextRoot( ) = *root
      Root( )\NextRoot( )\PrevRoot( ) = Root( )
   EndIf
   Root( ) = *root 
   
   ; --- ИЕРАРХИЯ ОТКРЫТИЯ (OpenList) ---
   OpenList(*root)
   
   ProcedureReturn *root
EndProcedure

;-
Procedure   EventHandler( EvGadget = - 1, EvType = - 1, eventdata = 0 )
   Protected mx,my
   ; 2. ОБРАБОТКА (Клик по виджету)
   If EvType = #PB_EventType_MouseEnter
      Root( ) = GetOsData(GadgetID(EvGadget))
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
;IncludeFile "widget/FCE.pbi"

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
If Open(0, 100, 0, 180, 130, "openlist1", #PB_Window_SystemMenu)
  EndIf
  
  If Open(1, 300, 0, 180, 130, "openlist2", #PB_Window_SystemMenu)
    CloseList()
  EndIf
  
  If Open(2, 500, 0, 180, 130, "openlist3", #PB_Window_SystemMenu)
    CloseList()
  EndIf
  
  Button( 30, 55, 120,20,"openlist1")
  
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
      EventHandler( EvGadget, EvType, EventData() )
   EndIf
   
Until Event = #PB_Event_CloseWindow

Close(#PB_All)
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 621
; FirstLine = 617
; Folding = ----------------+-----
; EnableXP
; DPIAware