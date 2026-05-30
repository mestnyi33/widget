IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure EventsHandler( )
      Protected event = WidgetEvent( ) 
      Protected g = EventWidget( )
   EndProcedure
   
   If Open(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
;       ; 1. Создаем первый пустой контейнер
;       Define CONTAINER_0 = Container( 5, 5, 200, 150 )
;       Define BUTTON_0 = Button( 10, 10, 180, 50, "B0")
;       Define BUTTON_2 = Button( 10, 60, 180, 50, "B3")
;      CloseList( )
;       
;       ; 3. Создаем второй пустой контейнер
;       Define CONTAINER_2 = Container( 5, 30, 200, 150 )
;       CloseList( )
;       SetParent( CONTAINER_0, CONTAINER_2)
;       
; ;       ; --- ПРОВЕРКА 2 ---
; ;       ; Динамически добавляем ПЕРВУЮ кнопку в CONTAINER_1 (тут *after = #Null)
; ;       OpenList( CONTAINER_2 )
; ;       Define BUTTON_2 = Button( 10, 10, 180, 50, "B3")
; ;       CloseList( )
; ;       
; ;       
; ;       ;1. TEST
; ;        Hide(CONTAINER_1, 1)
; ;        Hide(CONTAINER_1, 0)
;       
;       ;          Debug GetText(GetLast(CONTAINER_1,0))
;       ;          Debug GetText(GetLast(CONTAINER_1,1))
;       ;          Debug GetClass(GetLast(CONTAINER_1,0))
;       ;          Debug GetClass(GetLast(CONTAINER_1,1))
;       
;       Debug "----------next------------"
;       Define *root._s_ROOT = Root( )
;       Define *e._s_WIDGET = *root\first
;       While *e
;          Debug "  "+*e\class +" "+ *e\text\Str(0)
;          *e = *e\next[0]
;       Wend
;       Debug "----------prev------------"
;       Define._s_WIDGET *e = GetLast(*root) ; BUTTON_2
;       While *e
;          Debug "  "+*e\class +" "+ *e\text\Str(0)
;          *e = *e\prev[0]
;       Wend
;       Debug "----------end-------------"
      
      
; ; ;      ; =========================================================================
; ; ; ;          МАКСИМАЛЬНЫЙ СТРЕСС-ТЕСТ: ПАНЕЛЬ + СПЛИТТЕР + РЕПАРЕНТИНГ
; ; ; ; =========================================================================
; ; ; 
; ; ; Debug "--- ШАГ 1: Создаем Панель с двумя вкладками ---"
; ; ; ; Создаем панель. По умолчанию открыта вкладка 0.
; ; ; Define PANEL_0 = Panel( 10, 10, 300, 200 )
; ; ; AddItem(PANEL_0, -1,"tabindex")
; ; ; ; Добавляем кнопку на Вкладку 0 (tabindex = 0)
; ; ; Define BUTTON_TAB0 = Button( 5, 5, 100, 30, "На вкладке 0" )
; ; ; 
; ; ; AddItem(PANEL_0, -1,"tabindex")
; ; ; ; Добавляем кнопку на Вкладку 1 (tabindex = 1)
; ; ; Define BUTTON_TAB1 = Button( 5, 5, 100, 30, "На вкладке 1" )
; ; ; CloseList()
; ; ; ; Переключаемся на Вкладку 1
; ; ; ; (Код должен автоматически вызывать HideState/Views для скрытия BUTTON_TAB0)
; ; ; SetState( PANEL_0, 1 ) 
; ; ; 
; ; ; 
; ; ; Debug "--- ШАГ 2: Создаем Сплиттер с двумя кнопками ---"
; ; ; Define BUTTON_SPLIT1 = Button( 0, 0, 50, 50, "Лево" )
; ; ; Define BUTTON_SPLIT2 = Button( 0, 0, 50, 50, "Право" )
; ; ; ; Связываем их через сплиттер (сработает твоя логика bar_update и split_1/split_2)
; ; ; Define SPLITTER_0 = Splitter( 10, 220, 300, 150, BUTTON_SPLIT1, BUTTON_SPLIT2 )
; ; ; 
; ; ; Debug "--- ШАГ 3: Упаковываем все в финальный Контейнер ---"
; ; ; Define CONTAINER_MAIN = Container( 0, 0, 400, 400 ) : CloseList()
; ; ; 
; ; ; ; ВЫЗОВ 1: Переносим сложную Панель (внутри которой скрытые и видимые дети) внутрь главного контейнера
; ; ; SetParent( PANEL_0, CONTAINER_MAIN )
; ; ; 
; ; ; ; ВЫЗОВ 2: Переносим Сплиттер (который сам управляет детьми) внутрь главного контейнера
; ; ; SetParent( SPLITTER_0, CONTAINER_MAIN )
; ; ; 
; ; ; 
; ; ; Debug "--- ШАГ 4: Финальный аудит указателей Z-Order ---"
; ; ; Debug "---------- Абсолютный NEXT ------------"
; ; ; Define *root._s_ROOT = Root()
; ; ; Define *e._s_WIDGET = *root\first
; ; ; Define *absoluteLast._s_WIDGET = #Null
; ; ; 
; ; ; While *e
; ; ;    Debug "  " + *e\class + " [id: " + Str(*e) + "] - parent: " + Str(*e\parent) + " - tab: " + Str(*e\tabindex)
; ; ;    *absoluteLast = *e
; ; ;    *e = *e\next
; ; ; Wend
; ; ; 
; ; ; Debug "---------- Абсолютный PREV ------------"
; ; ; *e = *absoluteLast 
; ; ; While *e
; ; ;    Debug "  " + *e\class + " [id: " + Str(*e) + "]"
; ; ;    *e = *e\prev
; ; ; Wend
; ; ; Debug "---------------------------------------"
; ; ; 
; ; ; Debug " [+] REPAINT слоев видимости"
; ; ; Debug "start"
; ; ; *e = *root\first
; ; ; While *e
; ; ;    Debug "  " + *e\class
; ; ;    *e = *e\next
; ; ; Wend
; ; ; Debug "stop"
; =========================================================================
;          ФИНАЛЬНЫЙ СТРЕСС-ТЕСТ: ПАНЕЛЬ (AddItem) + СПЛИТТЕР + РЕПАРЕНТИНГ
; =========================================================================

Debug "--- ШАГ 1: Создаем Панель через AddItem ---"
Define PANEL_0 = Panel( 10, 10, 300, 200 )
   AddItem( PANEL_0, -1, "Вкладка 0" )
   ; Эта кнопка автоматически получит tabindex = 0
   Define BUTTON_TAB0 = Button( 5, 5, 100, 30, "На вкладке 0" )

   AddItem( PANEL_0, -1, "Вкладка 1" )
   ; Эта кнопка автоматически получит tabindex = 1
   Define BUTTON_TAB1 = Button( 5, 5, 100, 30, "На вкладке 1" )
CloseList()

; Переключаемся на Вкладку 1 (Вкладка 0 и BUTTON_TAB0 должны скрыться через HideState/Views)
SetState( PANEL_0, 1 )


Debug "--- ШАГ 2: Создаем Сплиттер с двумя кнопками ---"
Define BUTTON_SPLIT1 = Button( 0, 0, 50, 50, "Лево" )
Define BUTTON_SPLIT2 = Button( 0, 0, 50, 50, "Право" )
Define SPLITTER_0 = Splitter( 10, 220, 300, 150, BUTTON_SPLIT1, BUTTON_SPLIT2 )


Debug "--- ШАГ 3: Создаем Главный Контейнер и переносим структуры ---"
Define CONTAINER_MAIN = Container( 0, 0, 400, 400 ) : CloseList()

; ВЕТКА ДИНАМИЧЕСКОГО ПЕРЕНОСА МАТРЕШКИ №1 (Перенос Панели со всеми вкладками)
SetParent( PANEL_0, CONTAINER_MAIN )

; ВЕТКА ДИНАМИЧЕСКОГО ПЕРЕНОСА МАТРЕШКИ №2 (Перенос Сплиттера с его половинками)
SetParent( SPLITTER_0, CONTAINER_MAIN )


Debug "--- ШАГ 4: Финальный аудит указателей Z-Order ---"
Debug "---------- Абсолютный NEXT [0] ------------"
Define *root._s_ROOT = Root()
Define *e._s_WIDGET = *root\first
Define  *absoluteLast._s_WIDGET = #Null

While *e
   Debug "  " + *e\class + " [id: " + Str(*e) + "] - parent: " + Str(*e\parent) + " - tab: " + Str(*e\tabindex)
   *absoluteLast = *e
   *e = *e\next[0]
Wend

Debug "---------- Абсолютный PREV [0] ------------"
*e = *absoluteLast 
While *e
   Debug "  " + *e\class + " [id: " + Str(*e) + "]"
   *e = *e\prev[0]
Wend
Debug "---------------------------------------"

Debug " [+] REPAINT слоев видимости"
Debug "start"
*e = *root\first
While *e
   Debug "  " + *e\class
   *e = *e\next[1]
Wend
Debug "stop"

      WaitClose( @EventsHandler( ))
   EndIf
CompilerEndIf


; ; IncludePath "../../../"
; ; XIncludeFile "widgets.pbi"
; ; 
; ; ;- EXAMPLE
; ; CompilerIf #PB_Compiler_IsMainFile
; ;    EnableExplicit
; ;    UseWidgets( )
; ;    
; ;    Procedure EventsHandler( )
; ;       Protected event = WidgetEvent( ) 
; ;       Protected g = EventWidget( )
; ;    EndProcedure
; ;    
; ;    If Open(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
; ;       ; 1. Создаем первый пустой контейнер
; ;       Define CONTAINER_0 = Container( 5, 5, 200, 150 )
; ;       Define BUTTON_0 = Button( 10, 10, 180, 50, "B0")
; ;       CloseList( )
; ;       
; ;       ; 2. Создаем второй пустой контейнер
; ;       Define CONTAINER_1 = Panel( 5, 170, 200, 150 )
; ;       AddItem(CONTAINER_1, -1, "0-tab")
; ;       AddItem(CONTAINER_1, -1, "1-tab")
; ;       CloseList( )
; ;       
; ;       ; 3. Создаем второй пустой контейнер
; ;       Define CONTAINER_2 = Container( 5, 340, 200, 150 )
; ;       CloseList( )
; ;       
; ;       ; --- ПРОВЕРКА 1 ---
; ;       ; Динамически добавляем ПЕРВУЮ кнопку в CONTAINER_0 (тут *after = #Null)
; ;       OpenList( CONTAINER_1,0 )
; ;       Define BUTTON_0 = Button( 10, 10, 180, 50, "B1")
; ;       CloseList( )
; ;       
; ;       ; --- ПРОВЕРКА 2 ---
; ;       ; Динамически добавляем ПЕРВУЮ кнопку в CONTAINER_1 (тут *after = #Null)
; ;       OpenList( CONTAINER_2 )
; ;       Define BUTTON_2 = Button( 10, 10, 180, 50, "B3")
; ;       CloseList( )
; ;       
; ;       ; --- ПРОВЕРКА 3 ---
; ;       ; Добавляем ВТОРУЮ кнопку в CONTAINER_0, чтобы проверить, что цепочка не порвалась
; ;       OpenList( CONTAINER_1,1 )
; ;       Define BUTTON_1 = Button( 10, 70, 180, 50, "B2")
; ;       CloseList( )
; ;       
; ;       ;1. TEST
; ;        Hide(CONTAINER_1, 1)
; ;        Hide(CONTAINER_1, 0)
; ;       
; ;       ;          Debug GetText(GetLast(CONTAINER_1,0))
; ;       ;          Debug GetText(GetLast(CONTAINER_1,1))
; ;       ;          Debug GetClass(GetLast(CONTAINER_1,0))
; ;       ;          Debug GetClass(GetLast(CONTAINER_1,1))
; ;       
; ;       Debug "----------next------------"
; ;       Define *root._s_ROOT = Root( )
; ;       Define *e._s_WIDGET = *root\first
; ;       While *e
; ;          Debug "  "+*e\class +" "+ *e\text\Str(0)
; ;          *e = *e\next[0]
; ;       Wend
; ;       Debug "----------prev------------"
; ;       Define._s_WIDGET *e = GetLast(*root) ; BUTTON_2
; ;       While *e
; ;          Debug "  "+*e\class +" "+ *e\text\Str(0)
; ;          *e = *e\prev[0]
; ;       Wend
; ;       Debug "----------end-------------"
; ;       
; ;       WaitClose( @EventsHandler( ))
; ;    EndIf
; ; CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 160
; FirstLine = 160
; Folding = -
; EnableXP
; DPIAware