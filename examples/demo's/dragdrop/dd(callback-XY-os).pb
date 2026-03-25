Procedure MyDropCallback(TargetHandle, State, Action, Format, X, Y)
  ; Определяем границы нашего квадрата (зоны сброса)
  ; Пусть это будет центр Canvas: x от 100 до 200, y от 100 до 200
  Protected IsInside = #False
  If X >= 40 And X <= 340 And Y >= 100 And Y <= 200
    IsInside = #True
  EndIf

  ; Рисуем на Canvas в зависимости от положения файла
  If StartDrawing(CanvasOutput(0))
    Box(0, 0, 300, 300, $FFFFFF) ; Очищаем фон (белый)
    
    If IsInside
      Box(40, 100, 300, 100, $00FF00) ; Зеленый, если файл ВНУТРИ зоны
      DrawText(130, 140, "ТУТ БРОСАЙ!", $000000, $00FF00)
    Else
     Box(40, 100, 300, 100, $AAAAAA)
     DrawText(55, 140, "ЗОНА КУДА МОЖНО БРОСАТЬ", $FFFFFF, $AAAAAA)
    EndIf
    
    StopDrawing()
  EndIf

  ; Самое важное: разрешаем дроп ТОЛЬКО если мы внутри квадрата
  If IsInside
    ProcedureReturn #PB_Drag_Copy
  Else
    ProcedureReturn #PB_Drag_None ; Вне квадрата курсор будет "запрещено"
  EndIf
EndProcedure

If OpenWindow(0, 0, 0, 320, 320, "Canvas Drop Zone", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  CanvasGadget(0, 10, 10, 300, 300)
  
  ; Рисуем начальное состояние
  If StartDrawing(CanvasOutput(0))
    Box(40, 100, 300, 100, $AAAAAA)
    DrawText(55, 140, "ЗОНА КУДА МОЖНО БРОСАТЬ", $FFFFFF, $AAAAAA)
    StopDrawing()
  EndIf

  ; Включаем поддержку Drop для Canvas
  EnableGadgetDrop(0, #PB_Drop_Files, #PB_Drag_Copy)
  SetDropCallback(@MyDropCallback())

  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_GadgetDrop
      ; Это сработает ТОВЬКО если MyDropCallback вернул не #PB_Drag_None
      MessageRequester("Успех", "Файл принят в зону: " + EventDropFiles())
      
      ; Сбрасываем цвет после дропа
      If StartDrawing(CanvasOutput(0))
        Box(100, 100, 100, 100, $AAAAAA)
        StopDrawing()
      EndIf
    EndIf
    
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 14
; Folding = --
; EnableXP
; DPIAware