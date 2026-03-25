If OpenWindow(0, 0, 0, 300, 200, "Drag & Drop Тест", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Создаем поле и разрешаем в него бросать файлы с разными действиями
  StringGadget(0, 10, 10, 280, 180, "Брось файл сюда (с Ctrl или Alt)")
  EnableGadgetDrop(0, #PB_Drop_Files, #PB_Drag_Copy | #PB_Drag_Link | #PB_Drag_Move)

  Repeat
    Event = WaitWindowEvent()
    
    ; Ловим событие "что-то бросили в гаджет"
    If Event = #PB_Event_GadgetDrop
      
      ; Узнаем, какое именно действие выбрал пользователь
      Select EventDropAction()
        Case #PB_Drag_Copy
          Debug "Пользователь выбрал: КОПИРОВАНИЕ (Ctrl)"
        Case #PB_Drag_Link
          Debug "Пользователь выбрал: ССЫЛКА (Alt)"
        Case #PB_Drag_Move
          Debug "Пользователь выбрал: ПЕРЕМЕЩЕНИЕ (Shift)"
      EndSelect
      
      ; Выводим путь к файлу для примера
      Debug "Файл: " + EventDropFiles()
      
    EndIf
    
  Until Event = #PB_Event_CloseWindow
EndIf

; Как это выглядит для пользователя (Курсор)
; Windows: При нажатии Alt появляется маленькая изогнутая стрелочка (значок ярлыка). При Ctrl — плюсик (копирование).
; macOS: Обычно используется клавиша Option (Alt). Вместо стрелочки может появиться зеленый плюс или специальный значок ссылки.
; Linux (GTK): Поведение зависит от окружения (Gnome, KDE, XFCE). Обычно это тоже Ctrl+Shift или Alt, но графический индикатор может выглядеть иначе.
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 14
; Folding = -
; EnableXP
; DPIAware