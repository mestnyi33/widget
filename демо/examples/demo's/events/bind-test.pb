IncludePath "../../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets()
   
   Global *root_1, *root_2
   Global *win_1, *win_2
   Global *btn_block_at_widget, *btn_block_at_window, *btn_full_bubble, *btn_unbind_test
   Global *btn_root2
   
   Declare  on_global_all()
   
   ; --- УРОВЕНЬ 1: Обработчики виджетов ---
   Procedure on_widget_first()
      Debug "1. [Widget - Первый]   Виджет: " + Str(EventWidget()) + " | Data: " + Str(WidgetEventData())
      
      If EventWidget() = *btn_block_at_widget
         Debug "   -> Остановлено на уровне виджета (#PB_Ignore)!"
         ProcedureReturn #PB_Ignore
      EndIf
   EndProcedure
   
   Procedure on_widget_second()
      Debug "1. [Widget - Второй]   Сработал вторым в очереди FIFO"
   EndProcedure
   
   Procedure on_unbind_click()
      Debug "1. [Unbind Test]       Снимаем глобальный перехватчик #PB_All!"
      Unbind(#PB_All, @on_global_all())
      Debug "   -> Теперь глобальный #PB_All больше не будет срабатывать."
   EndProcedure
   
   ; --- УРОВЕНЬ 2: Обработчики окон ---
   Procedure on_window_event()
      Debug "  2. [Window]          Событие дошло до окна"
      
      If EventWidget() = *btn_block_at_window
         Debug "     -> Остановлено на уровне окна (#PB_Ignore)!"
         ProcedureReturn #PB_Ignore
      EndIf
   EndProcedure
   
   ; --- УРОВЕНЬ 3: Обработчики конкретных корней ---
   Procedure on_root1_event()
      Debug "    3. [Root 1]        Событие в первом окне-корне"
   EndProcedure
   
   Procedure on_root2_event()
      Debug "    3. [Root 2]        Событие во втором окне-корне"
   EndProcedure
   
   ; --- УРОВЕНЬ 4: Глобальный перехватчик (#PB_All) ---
   Procedure on_global_all()
      Debug "      4. [#PB_All]     Глобальный перехватчик (всегда последний!)"
      Debug "------------------------------------------------------------"
   EndProcedure
   
   
   ; === СОЗДАНИЕ ИНТЕРФЕЙСА ===
   If OpenWindow(0, 100, 100, 420, 420, "Тест 1: Основной Root", #PB_Window_SystemMenu)
      *root_1 = Open(0, 10, 10, 400, 400)
      
      *win_1 = Window(20, 20, 360, 340, "Внутреннее окно #1", #PB_Window_SystemMenu)
      *btn_block_at_widget = Button(20, 30,  320, 45, "1. Стоп на кнопке (#PB_Ignore)")
      *btn_block_at_window = Button(20, 90,  320, 45, "2. Стоп на окне (#PB_Ignore)")
      *btn_full_bubble     = Button(20, 150, 320, 45, "3. Полное всплытие (1 -> 2 -> 3 -> 4)")
      *btn_unbind_test     = Button(20, 220, 320, 45, "4. Отвязать глобальный #PB_All")
   EndIf
   
   ; Второе независимое окно-корень (создаётся ПОСЛЕ или ДО Bind(#PB_All) — неважно!)
   If OpenWindow(1, 540, 100, 320, 220, "Тест 2: Второй Root", #PB_Window_SystemMenu)
      *root_2 = Open(1, 10, 10, 300, 200)
      *btn_root2 = Button(20, 40, 260, 50, "Клик во втором Root (без Root 1)")
   EndIf
   
   
   ; === ПРИВЯЗКА СОБЫТИЙ (НАМЕРЕННО В ОБРАТНОМ ПОРЯДКЕ) ===
   ; Сначала вешаем глобальный и корневые, а кнопки — в самом конце
   Bind(#PB_All, @on_global_all(), #__EVENT_Down)
   
   Bind(*root_1, @on_root1_event(), #__EVENT_Down)
   Bind(*root_2, @on_root2_event(), #__EVENT_Down)
   
   Bind(*win_1,  @on_window_event(), #__EVENT_Down)
   
   ; Проверяем FIFO: на *btn_full_bubble вешаем две функции подряд
   Bind(*btn_full_bubble, @on_widget_first(),  #__EVENT_Down, #PB_All, 111)
   Bind(*btn_full_bubble, @on_widget_second(), #__EVENT_Down, #PB_All, 222)
   
   Bind(*btn_block_at_widget, @on_widget_first(), #__EVENT_Down, #PB_All, 777)
   Bind(*btn_block_at_window, @on_widget_first(), #__EVENT_Down, #PB_All, 888)
   Bind(*btn_unbind_test,     @on_unbind_click(), #__EVENT_Down)
   
   Bind(*btn_root2, @on_widget_first(), #__EVENT_Down, #PB_All, 999)
   
   WaitClose()
CompilerEndIf

; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 11
; Folding = ---
; EnableXP
; DPIAware