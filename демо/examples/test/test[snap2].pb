IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure.i Update_Views( *this._s_PARENT )
      If Not *this Or Not *this\parent : ProcedureReturn #False : EndIf
      
      Protected._s_PARENT *current
      Protected._s_PARENT *parent = *this\parent\root
      
      ; Координаты нашего проверяемого виджета
      Protected.i x1 = *this\x
      Protected.i y1 = *this\y
      Protected.i r1 = *this\x + *this\width
      Protected.i b1 = *this\y + *this\height
      
      Protected.i x2, y2, r2, b2
      
      ; =========================================================================
      ; ШАГ 1: БЫСТРЫЙ ПОИСК ПЕРЕСЕЧЕНИЙ (СТРОГО ПО ЛОКАЛЬНОЙ ЦЕПОЧКЕ БРАТЬЕВ)
      ; =========================================================================
      *current = *this 
      While *current
         If *current <> *this And Not (*current\mask & #__mask_hide)
            
            x2 = *current\x
            y2 = *current\y
            r2 = *current\x + *current\width
            b2 = *current\y + *current\height
            
            ; Проверка геометрии (AABB)
            If x1 < r2 And r1 > x2 And y1 < b2 And b1 > y2
               ProcedureReturn #False ; Реальное перекрытие сверху — выходим
            EndIf
            
         EndIf
         *current = *current\next[2] ; Шагаем строго по братьям текущего уровня
      Wend
      
      ; =========================================================================
      ; ШАГ 2: ПЕРЕСЕЧЕНИЙ НЕТ — УМНОЕ ПЕРЕНАПРАВЛЕНИЕ СКВОЗНОГО Z-ORDER [1]
      ; =========================================================================
      
      ProcedureReturn #True
   EndProcedure
   
   Procedure EventsHandler( )
      Protected event = WidgetEvent( ) 
      Protected g = EventWidget( )
      
      If event = #__event_MouseMove
         Protected._s_ROOT *root
         Protected._s_WIDGET *newWidget = g
         Static._s_WIDGET *oldWidget
         
         ; Проверяем, изменился ли виджет под мышью
         If *oldWidget <> *newWidget
            
            ; 1. Если мы сходим с виджета — восстанавливаем цепь и гасим снапшот
            If *oldWidget
               *root = *oldWidget\root
               
               ; Отключаем активный снапшот на холсте корня
               *root\canvas\snap\active = #Null
              
            EndIf
            
            ; 2. Теперь обрабатываем новый элемент, на который наступили
            If *newWidget
               *root = *newWidget\root
               
               ; ИСПРАВЛЕНО: Полная перерисовка дерева для сброса старых состояний холста
               ReDraw(*root)
               
               If Update_Views( *newWidget )
                  ; Фиксируем активный изолированный элемент в структуре холста
                  *root\canvas\snap\active = *newWidget
                  
                  If IsImage(*root\canvas\snap\img[0])
                     FreeImage(*root\canvas\snap\img[0])
                  EndIf
                  
                  If StartDrawing(CanvasOutput(*root\canvas\gadget))
                     *root\canvas\snap\img[0] = GrabDrawingImage(#PB_Any, *root\x, *root\y, *root\width, *root\height)
                     StopDrawing()
                  EndIf
               EndIf
            EndIf
            
            *oldWidget = *newWidget
            
            ; --- ВАШ ВЕЛИКОЛЕПНЫЙ ОТЛАДОЧНЫЙ ЦИКЛ ПРОВЕРКИ ---
            If *root\canvas\snap\active
               Debug "[]-" + *root\canvas\snap\active\class
            EndIf
            ; Сигнал графическому движку перерисовать Canvas
            ;PostRepaint( Root() ) 
         EndIf
         
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 500, 500, "Тест Z-Order", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ; ГРУППА А (Пересекаются)
      Define CONTAINER_1 = Container( 5, 5, 200, 200 )
      Define BUTTON_0 = Button( 10, 10, 180, 50, "B1 (Перекрыта)")
      Define BUTTON_1 = Button( 30, 30, 180, 50, "B2 (Сверху над B1)")
      
      ; ГРУППА Б (Свободная кнопка)
      Define BUTTON_2 = Button( 10, 90, 180, 50, "B3 (Свободна)") ; Смещена по Y, пересечений нет
      CloseList( )
      
      WaitClose( @EventsHandler( ))
   EndIf
   
CompilerEndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 97
; FirstLine = 71
; Folding = ---
; EnableXP
; DPIAware