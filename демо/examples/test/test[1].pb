
IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure Restore_Views( *this._s_PARENT, *parent._s_PARENT )
   ; Вызывается при MouseLeave. Восстанавливает видимый Z-Order [1] из честного [0]
   If Not *this Or Not *parent : ProcedureReturn : EndIf
   
   Protected._s_PARENT *current
   
   ; Обходим всех братьев по честной локальной цепочке [2]
   *current = *parent\first
   While *current
      
      ; Восстанавливаем видимые указатели [1] из эталонного слоя [0]
      *current\prev[1] = *current\prev[0]
      *current\next[1] = *current\next[0]
      
      ; Если у брата есть свои дети, возвращаем честные связи [1] и для его поддерева
      If *current\first
         Protected._s_PARENT *child = *current\first
         Protected._s_PARENT *lastChild = GetLast(*current, 0) ; Ищем крайнего потомка по честному Z-Order [0]
         
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
   ; ИСПРАВЛЕНО: Стартуем строго с самого себя, чтобы проверять только тех, кто СВЕРХУ!
   *current = *this 
   
   While *current
      ; Себя самого по координатам не проверяем (проверка начнется со следующего элемента в next[2])
      If *current <> *this And Not (*current\mask & #__mask_hide)
         
         x2 = *current\x
         y2 = *current\y
         r2 = *current\x + *current\width
         b2 = *current\y + *current\height
         
         ; Проверка геометрии (AABB)
         If x1 < r2 And r1 > x2 And y1 < b2 And b1 > y2
            ; Найдено реальное перекрытие сверху от более позднего брата! Выходим.
            ProcedureReturn 
         EndIf
         
      EndIf
      
      *current = *current\next[2] ; Идем строго вперед по локальным братьям
   Wend
   
   ; =========================================================================
   ; ШАГ 2: ПЕРЕСЕЧЕНИЙ НЕТ — СРЕЗАЕМ ВИДИМУЮ ЦЕПОЧКУ В ОБХОД ЛИШНИХ ЭЛЕМЕНТОВ
   ; =========================================================================
   Protected._s_PARENT *firstVisible = *parent\first ; Наша неизменяемая голова списка (B1)
   Protected._s_PARENT *exFirst = *this             ; Начало нашей матрешки
   Protected._s_PARENT *exLast  = GetLast( *this, 1 ) ; Хвост нашей матрешки в слое
   
   ; Если мы и так являемся самым первым элементом в списке, перед нами никого нет
   If *firstVisible = *this
      *exLast\next[1] = #Null ; Просто обрубаем хвост за нашей матрешкой
   Else
      ; МАТРИЦА СВЯЗЕЙ ДЛЯ ВАШЕГО УСЛОВИЯ:
      ; А) Насильно направляем next[1] у самой головы (B1) сразу на нас (B2 или B3)
      *firstVisible\next[1] = *exFirst
      
      ; Б) Нашу матрешку полностью изолируем (обнуляем прев у *this)
      *exFirst\prev[1]      = #Null ; <--- ТУТ СРАБОТАЕТ ВАШЕ УСЛОВИЕ В ДИСПЕТЧЕРЕ!
      *exLast\next[1]       = #Null
   EndIf
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
         
         Debug "---------- НАВЕЛИ ------------ " +*newWidget\class
         ; Чтобы увидеть результат изоляции, отрисовку в тесте 
         ; запускаем непосредственно с активного виджета под мышью (g)
         Define *e._s_WIDGET = *newWidget\root\first ; СТАРТУЕМ С ГОЛОВЫ
         If *e\next[1]
            If *e <> *e\next[1]\prev[1]
               *e = *e\next[1]
            EndIf
         EndIf
         While *e
            Debug "  " + *e\class + " " + *e\text\Str(0)
            *e = *e\next[1] ; Обход строго по видимой цепочке [1]
         Wend
         
         ; Вызываем глобальный Redraw
        ; PostRepaint( Root() ) 
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
; CursorPosition = 143
; FirstLine = 12
; Folding = d---
; EnableXP
; DPIAware