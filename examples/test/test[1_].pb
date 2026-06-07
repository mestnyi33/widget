
IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure Restore_Views( *this._s_PARENT, *parent._s_PARENT )
   ; Вызывается при MouseLeave. Полностью восстанавливает честный видимый Z-Order из абсолютного.
   ; Поля *parent\first и *parent\last не трогаем — они хранят братьев!
   If Not *this Or Not *parent : ProcedureReturn : EndIf
   
   Protected._s_PARENT *current
   
   ; Обходим всех братьев текущей ветки по их честному указателю next[2]
   *current = *parent\first
   While *current
      
      ; Полностью возвращаем видимые указатели [1] из эталонного слоя [0]
      *current\prev[1] = *current\prev[0]
      *current\next[1] = *current\next[0]
      
      ; Если у брата есть свои дети, восстанавливаем цепочку [1] и для их поддерева
      If *current\first
         Protected._s_PARENT *child = *current\first
         Protected._s_PARENT *lastChild = GetLast(*current, 0) ; Ищем крайнего потомка по честному Z-Order
         
         Protected._s_PARENT *subCurrent = *child
         While *subCurrent
            *subCurrent\prev[1] = *subCurrent\prev[0]
            *subCurrent\next[1] = *subCurrent\next[0]
            
            If *subCurrent = *lastChild : Break : EndIf
            *subCurrent = *subCurrent\next[2] ; Шаг по цепочке братьев внутри поддерева
         Wend
      EndIf
      
      *current = *current\next[2] ; Переход к следующему локальному брату
   Wend
EndProcedure


Procedure Update_Views( *this._s_PARENT, *parent._s_PARENT )
   ; Вызывается при входе мыши в виджет.
   If Not *this Or Not *parent : ProcedureReturn : EndIf
   
   Protected._s_PARENT *current
   
   ; Координаты нашего проверяемого виджета
   Protected.i x1 = *this\x
   Protected.i y1 = *this\y
   Protected.i r1 = *this\x + *this\width
   Protected.i b1 = *this\y + *this\height
   
   Protected.i x2, y2, r2, b2
   
   ; =========================================================================
   ; ШАГ 1: БЫСТРЫЙ ПОИСК ПЕРЕСЕЧЕНИЙ С БРАТЬЯМИ (По цепочке братьев)
   ; =========================================================================
   *current = *parent\first
   While *current
      If *current <> *this And Not (*current\mask & #__mask_hide)
         
         x2 = *current\x
         y2 = *current\y
         r2 = *current\x + *current\width
         b2 = *current\y + *current\height
         
         ; Проверка геометрии (AABB)
         If x1 < r2 And r1 > x2 And y1 < b2 And b1 > y2
            ; Найдено пересечение! Ничего не изолируем и сразу выходим.
            ProcedureReturn 
         EndIf
         
      EndIf
      *current = *current\next[2] ; Обходим строго локальных братьев
   Wend
   
   ; =========================================================================
   ; ШАГ 2: ПЕРЕСЕЧЕНИЙ НЕТ — ИЗОЛИРУЕМ МАТРЕШКУ В ВИДИМОМ Z-ORDER [1]
   ; =========================================================================
   ; Находим честные границы нашей матрешки в абсолютном Z-Order [0]
   Protected._s_PARENT *exFirst = *this
   Protected._s_PARENT *exLast  = GetLast( *this, 0 )
   
   ; Полностью обрубаем внешние связи этого блока СТРОГО в массиве видимого Z-Order [1]
   ; Поля first и last у родителя остаются нетронутыми и в безопасности!
   *exFirst\prev[1] = #Null
   *exLast\next[1]  = #Null
EndProcedure


Procedure EventsHandler( )
   Protected event = WidgetEvent( ) 
   Protected g = EventWidget( )
   
   If event = #__event_MouseMove
      Protected._s_WIDGET *newWidget = g
      Static._s_WIDGET *oldWidget
      
      ; Проверяем, изменился ли виджет под мышью
      If *oldWidget <> *newWidget
         
         ; 1. Если мы сходим с какого-то виджета — восстанавливаем всю ветку
         If *oldWidget
            Restore_Views( *oldWidget, *oldWidget\parent )
         EndIf
         
         ; 2. Теперь обрабатываем новый элемент, на который наступили
         If *newWidget
            Update_Views( *newWidget, *newWidget\parent )
         EndIf
         
         ; 3. ВАЖНО: Запоминаем текущий виджет как старый
         *oldWidget = *newWidget
         
         Debug "----------видимый draw [1]------------"
         ; Чтобы увидеть результат изоляции, отрисовку в тесте 
         ; запускаем непосредственно с активного виджета под мышью (g)
         Define *e._s_WIDGET = g
         While *e
            Debug "  " + *e\class + " " + *e\text\Str(0)
            *e = *e\next[1] ; Обход по ВИДИМОМУ списку отрисовки
         Wend
         
         ; Вызываем глобальный Redraw
         PostRepaint( Root() ) 
      EndIf
      
   EndIf
EndProcedure

If Open(0, 0, 0, 500, 500, "Тест Z-Order", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ; ГРУППА А (Пересекаются)
   Define BUTTON_0 = Button( 10, 10, 180, 50, "B1 (Перекрыта)")
   Define BUTTON_1 = Button( 30, 30, 180, 50, "B2 (Сверху над B1)")
   
   ; ГРУППА Б (Свободная кнопка)
   Define BUTTON_2 = Button( 10, 90, 180, 50, "B3 (Свободна)") ; Смещена по Y, пересечений нет
   
   WaitClose( @EventsHandler( ))
EndIf

CompilerEndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 146
; FirstLine = 103
; Folding = ---
; EnableXP
; DPIAware