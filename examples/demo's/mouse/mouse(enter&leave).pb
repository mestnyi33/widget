; #__from_mouse_state = 1

XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Declare EventsHandler( )
Declare ChangeMode( )

; Настройки теста по умолчанию
Global.b Mode_DeepHover = 0 

; Цвета для визуализации теста
Global.l colorback = colors::*this\blue\fore,
      colorframe  = colors::*this\blue\frame, 
      colorback1  = $ff00ff00, ; Зеленый при наведении
      colorframe1 = $ff0000ff  ; Синяя рамка

; Используем глобальные ID для элементов управления тестом, чтобы исключить их из логики hover
Global.i g_btn_single, g_btn_deep, g_txt_status

; Процедура переключения режимов теста «на лету»
Procedure EventsHandler( )
   Protected Repaint = 0 
   Protected ElementChanged = 0 
   Protected *Widget._S_WIDGET = EventWidget()
   Protected *Current._S_WIDGET
   Protected statusText$ = ""
   
   ; Игнорируем корневое окно и сами элементы управления тестом, чтобы не забивать логи
   If is_root_(*Widget) Or *Widget = g_btn_single Or *Widget = g_btn_deep Or *Widget = g_txt_status
      ProcedureReturn 
   EndIf
   
   Select WidgetEvent( )
         
      Case #__event_MouseEnter
         *Current = *Widget
         
         While Not is_root_(*Current)
            ElementChanged = 0 
            
            ; Меням цвета текущего элемента
            If *Current\color\frame <> colorframe1 
               *Current\color\frame = colorframe1
               ElementChanged = 1 
            EndIf
            If *Current\color\back <> colorback1 
               *Current\color\back = colorback1
               ElementChanged = 1 
            EndIf
            
            If ElementChanged
               Repaint = 1
               Debug "[TEST] MouseEnter ID: " + Str(GetData(*Current))
            EndIf
            
            ; Строим визуальную цепочку для вывода на экран (от дочернего к родителю)
            statusText$ + Str(GetData(*Current)) + " <- "
            
            If Mode_DeepHover = 0 : Break : EndIf
            
            ; Для каскадного режима управляем маской
            If Not *Current\mask & #__mask_hover
               *Current\mask | #__mask_hover
            EndIf
            
            *Current = GetParent(*Current)
         Wend
         
         ; Выводим текущую иерархию на экранную панель
         If statusText$ <> ""
            SetText(g_txt_status, "Hover Chain: " + statusText$ + "Root")
         EndIf
         
      Case #__event_MouseLeave
         *Current = *Widget
         
         While Not is_root_(*Current)
            ElementChanged = 0 
            
            ; Возвращаем исходные цвета
            If *Current\color\back = colorback1
               *Current\color\back = colorback
               ElementChanged = 1
            EndIf
            If *Current\color\frame = colorframe1 
               *Current\color\frame = colorframe
               ElementChanged = 1 
            EndIf
            
            If ElementChanged
               Repaint = 1
               Debug "[TEST] MouseLeave ID: " + Str(GetData(*Current)) + " -> Restored"
            EndIf
            
            If Mode_DeepHover = 0 : Break : EndIf
            
            ; Снимаем маску в каскадном режиме
            If *Current\mask & #__mask_hover
               *Current\mask &~ #__mask_hover
            EndIf
            
            *Current = GetParent(*Current)
         Wend
         
         ; Очищаем текстовый статус при выходе мыши из тестируемой зоны
         SetText(g_txt_status, "Hover Chain: None")
         
   EndSelect
   
   ; Если ваша система требует явного вызова обновления холста при смене цветов:
   ; If Repaint : ReDraw(Root()) : EndIf
EndProcedure

; Процедура переключения режимов теста «на лету»
Procedure ChangeMode()
   Protected *Widget = EventWidget()
   
   If *Widget = g_btn_single
      Mode_DeepHover = 0
      
      ; Блокируем Single (1), разблокируем Deep (0)
      Disable(g_btn_single, 1)
      Disable(g_btn_deep, 0)
      
      SetText(g_txt_status, "Switch to: SINGLE MODE")
      Debug "--- TEST MODE CHANGED: SINGLE HOVER ---"
      
   ElseIf *Widget = g_btn_deep
      Mode_DeepHover = 1
      
      ; Блокируем Deep (1), разблокируем Single (0)
      Disable(g_btn_deep, 1)
      Disable(g_btn_single, 0)
      
      SetText(g_txt_status, "Switch to: DEEP/MULTI HOVER")
      Debug "--- TEST MODE CHANGED: DEEP HOVER ---"
   EndIf
EndProcedure


;\\ Создаем тестовое окружение
Open( 0, 0, 0, 260, 310, "Enter/Leave Advanced Demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
; Текстовая панель для вывода живой иерархии
g_txt_status = Text( 10, 10, 240, 45, "Hover Chain: None", #__flag_BorderFlat )

; --- ТЕСТОВАЯ ЗОНА (Ваша структура виджетов) ---
Define *g._S_WIDGET = ScrollArea( 30, 65, 200, 200, 300, 300, 1, #__flag_BorderFlat )
SetData( *g, 0 )
SetData( *g\scroll\v, -1 )
SetData( *g\scroll\h, -2 )

SetData( Container( 70, 10, 70, 200, #__Flag_NoGadgets|#__flag_BorderFlat ), 1 ) 
SetData( Container( 40, 20, 200, 200, #__flag_BorderFlat ), 2 )
SetData( Container( 20, 20, 200, 200, #__flag_BorderFlat ), 21 )

SetData( Container( 5, 30, 200, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 211 ) 
SetData( Container( 5, 45, 200, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 212 ) 
SetData( Container( 5, 60, 200, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 213 ) 

Define w1 = Container( 0,0,0,0, #__Flag_NoGadgets|#__flag_BorderFlat )
Define w2 = Container( 0,0,0,0, #__Flag_NoGadgets|#__flag_BorderFlat )
SetData( w1, 2141 )
SetData( w2, 2142 )
SetData( Splitter( 5, 80, 200, 50, w1, w2, #PB_Splitter_Vertical|#__flag_BorderFlat ), 214 ) 

CloseList( )
CloseList( )

; --- ИСПРАВЛЕННЫЙ БЛОК: ID ТЕПЕРЬ СТРОГО ПОКАЗЫВАЮТ УРОВЕНЬ ВЛОЖЕННОСТИ ---
SetData( Container( 10, 45, 70, 200, #__flag_BorderFlat ), 3 ) ; Уровень 11 (Базовый родитель)
SetData( Container( 10, 10, 70, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 31 ) ; Уровень 12 (Внутри 11)
SetData( Container( 10, 20, 70, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 32 ) ; Уровень 13 (Внутри 11)
SetData( Container( 10, 30, 170, 130, #__Flag_NoGadgets|#__flag_BorderFlat ), 33 ) ; Уровень 14 (Внутри 11) 

; Создаем каскад вложенности дальше:
SetData( Container( 10, 45, 70, 200, #__flag_BorderFlat ), 34 ) 
SetData( Container( 10, 5, 70, 200, #__flag_BorderFlat ), 341 ) 
SetData( Container( 10, 5, 70, 200, #__flag_BorderFlat ), 3411 ) 
SetData( Container( 10, 10, 70, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 34111 ) 

CloseList( ) ; Закрывает Уровень 14
CloseList( ) ; Закрывает Уровень 13
CloseList( ) ; Закрывает Уровень 12
CloseList( ) ; Закрывает Уровень 11
CloseList( ) ; Пятый CloseList: Закрывает ScrollArea(ID 1)


; --- ПАНЕЛЬ УПРАВЛЕНИЯ ТЕСТОМ (Вне списка CloseList тестовой зоны) ---
; Кнопки переключения режимов
g_btn_single = Button( 10, 275, 115, 25, "Single Mode" )
g_btn_deep   = Button( 135, 275, 115, 25, "Deep Mode" )

; Инициализация начального состояния кнопок:
; Так как по умолчанию Mode_DeepHover = 1, кнопка каскадного режима должна быть заблокирована
Disable(g_btn_single, 1)

; Назначаем события для переключателей теста
Bind( g_btn_single, @ChangeMode(), #__event_LeftClick )
Bind( g_btn_deep,   @ChangeMode(), #__event_LeftClick )

; Назначаем основные события мыши для всего окна
Bind( #PB_All, @EventsHandler( ), #__event_MouseEnter )
Bind( #PB_All, @EventsHandler( ), #__event_MouseLeave )

;\\
WaitClose( )
End
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 207
; FirstLine = 184
; Folding = ---
; EnableXP
; DPIAware