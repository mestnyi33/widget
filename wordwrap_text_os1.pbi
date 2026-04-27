Procedure DrawWinAPIWrap(CanvasGadget, Text$)
  Protected rect.RECT
  Protected hdc.i
  
  ; Настраиваем границы
  rect\left = 20
  rect\top = 20
  rect\right = GadgetWidth(CanvasGadget) - 20
  rect\bottom = GadgetHeight(CanvasGadget) - 20
  
  If StartDrawing(CanvasOutput(CanvasGadget))
    ; Чистим фон средствами PureBasic
    Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF)
    
    ; 1. Получаем системный контекст для гаджета
    hdc = GetDC_(GadgetID(CanvasGadget))
    
    If hdc
      ; 2. Выбираем шрифт, который сейчас установлен в StartDrawing
      ; (Если не выбрать, API будет рисовать стандартным системным шрифтом)
      SelectObject_(hdc, DrawingFont()) 
      
      ; 3. Настраиваем прозрачность фона для текста
      SetBkMode_(hdc, #TRANSPARENT)
      
      ; 4. Рисуем
      DrawText_(hdc, Text$, -1, @rect, #DT_WORDBREAK)
      
      ; 5. Освобождаем контекст (обязательно для Windows)
      ReleaseDC_(GadgetID(CanvasGadget), hdc)
    EndIf
    
    StopDrawing()
  EndIf
EndProcedure

; --- Пример запуска ---
If OpenWindow(0, 0, 0, 400, 300, "WinAPI WordWrap", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 400, 300)
  Txt$ = "Теперь это чистый WinAPI. Используем GetDC_ и ReleaseDC_ напрямую. " +
         "Этот метод переносит текст автоматически и работает максимально быстро."
  
  DrawWinAPIWrap(0, Txt$)

  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_SizeWindow
        ResizeGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
        DrawWinAPIWrap(0, Txt$)
      Case #PB_Event_CloseWindow : End
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 53
; Folding = -
; EnableXP
; DPIAware