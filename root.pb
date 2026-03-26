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


Structure _s_WIDGET
   class.s
   *Root._s_ROOT
   X.i : Y.i : w.i : h.i
   color.i
   name.s
   OnEvent.ProtoOnEvent[#__event] ; Указатель на процедуру событий
EndStructure

Structure _s_CANVAS
   window.i
   gadget.i
   ;    w.i
   ;    h.i
EndStructure

Structure _s_MOUSE
   X.i
   Y.i
   *widget._s_WIDGET[3]
EndStructure

Structure _s_ROOT Extends _s_WIDGET
   dpi.f
   ; Навигация по цепочке холстов (окон)
   *next._s_ROOT
   *prev._s_ROOT
   Canvas._s_CANVAS
   List Widget._s_WIDGET()
EndStructure

Structure _s_MyRoot
   *active._s_WIDGET
   *root._s_ROOT
   mouse._s_MOUSE
EndStructure

Declare Draw(*root._s_ROOT)

Global MyRoot._s_MyRoot

Macro Root()
   MyRoot\root
EndMacro

Macro Entered()
   MyRoot\mouse\widget[0]
EndMacro
Macro Leaved( )
   MyRoot\mouse\widget[1]
EndMacro
Macro Pressed()
   MyRoot\mouse\widget[2] ; Третий слот в массиве для нажатого виджета
EndMacro
Macro GetActive()
   MyRoot\active
EndMacro

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
Procedure SetParent(*this._s_WIDGET, *parent._s_ROOT)
   Protected *lastParent._s_ROOT = *this\root ; Сохраняем ссылку на старый холст
   
   If Not *this Or Not *parent Or *lastParent = *parent : ProcedureReturn : EndIf
   
   ; 1. Добавляем копию виджета в список нового родителя
   AddElement(*parent\Widget())
   CopyStructure(*this, *parent\Widget(), _s_WIDGET)
   *parent\Widget()\root = *parent ; Прописываем нового родителя
   
   ; 2. Удаляем виджет из старого списка
   ; (ChangeCurrentElement нужен, чтобы DeleteElement знал, кого удалять)
   ChangeCurrentElement(*lastParent\Widget(), *this)
   DeleteElement(*lastParent\Widget())
   
   ; 3. Перерисовываем оба холста, чтобы изменения сразу были видны
   Draw(*lastParent)
   Draw(*parent)
EndProcedure

;-
Procedure AtPoint(*root._s_ROOT, mx,my)
   ForEach *root\Widget()
      If mx >= *root\Widget()\x And mx <= *root\Widget()\x + *root\Widget()\w And 
         my >= *root\Widget()\y And my <= *root\Widget()\y + *root\Widget()\h
         ProcedureReturn *root\Widget()
      EndIf
   Next
   ProcedureReturn 0
EndProcedure

; --- Отрисовка ---
Procedure Draw(*root._s_ROOT)
   ; Рисуем в тот холст, который сейчас "подставлен" в root
   If StartDrawing(CanvasOutput(*root\Canvas\gadget))
      Box(0, 0, OutputWidth(), OutputHeight(), $F0F0F0) 
      
      ForEach *root\Widget()
         Box(*root\Widget()\x, *root\Widget()\y, *root\Widget()\w, *root\Widget()\h, *root\Widget()\color)
         
         ; Если этот виджет активен - рисуем рамку
         If Entered( ) = *root\Widget()
            Box( *root\Widget()\x, *root\Widget()\y, *root\Widget()\w, *root\Widget()\h, $00FF00) ; Синяя рамка
         EndIf
         ; Если этот виджет активен - рисуем рамку
         If GetActive( ) = *root\Widget()
            Box( *root\Widget()\x, *root\Widget()\y, *root\Widget()\w, *root\Widget()\h, $0000FF) ; Синяя рамка
         EndIf
      Next
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
      ; Debug "Отрисовка холста: " + *r + " (Имя: " + *r\Widget()\name + ")"
      Draw(*r)
      *r = *r\next ; Переходим к следующему
   Wend
EndProcedure


Procedure Create( *root._s_ROOT, X,Y,w,h, title.s, color  )
   Protected *this._s_WIDGET
   *this = AddElement(*root\Widget()) 
   *this\x = X * *root\dpi 
   *this\y = Y * *root\dpi 
   *this\w = w * *root\dpi 
   *this\h = h * *root\dpi 
   *this\color = color 
   *this\name = title
   *this\root = *root ; Теперь виджет знает свой "дом"
   ProcedureReturn *this
EndProcedure

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

Procedure Open( window, X,Y,w,h, title.s )
   Protected *root._s_ROOT = AllocateStructure(_s_ROOT)
   If IsWindow(window)
      *root\Canvas\window = window
      *root\Canvas\gadget = CanvasGadget(#PB_Any, X,Y, w, h)
   Else
      *root\Canvas\window = OpenWindow(#PB_Any, X,Y,w,h, title)
      *root\Canvas\gadget = CanvasGadget(#PB_Any, 0, 0, w, h)
   EndIf
   SetGadgetData(*root\Canvas\gadget, *root )
   
   Static i:*Root\class = Str(i):i+1
   
   ; Получаем масштаб окна (встроено в PB 5.70+)
   *root\dpi = DesktopResolutionX() 
   
   ;    *root\Canvas\w = w * *root\dpi
   ;    *root\Canvas\h = h * *root\dpi
   
   
   If Root( )
      Root( )\next = *root
      Root( )\next\prev = Root( )
   EndIf
   Root( ) = *root 
   
   ProcedureReturn *root
EndProcedure

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
            mx = GetGadgetAttribute(Root( )\Canvas\gadget, #PB_Canvas_MouseX) / Root()\dpi
            my = GetGadgetAttribute(Root( )\Canvas\gadget, #PB_Canvas_MouseY) / Root()\dpi
            
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

IncludeFile "FixedCanvasEvents.pbi"

Procedure all_events(*this._s_WIDGET, event)
   
   Select event
      Case #__event_MouseEnter
         Debug "Зашли на: " + *this\name
      Case #__event_MouseLeave
         Debug "Вышли из: " + *this\name
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
; CursorPosition = 468
; FirstLine = 408
; Folding = -----------4---
; EnableXP
; DPIAware