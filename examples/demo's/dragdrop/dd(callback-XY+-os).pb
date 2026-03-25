Procedure MyDropCallback(TargetHandle, State, Action, Format, X, Y)
  
  ; Нам нужно перерисовывать Canvas только при движении или входе
  If State = #PB_Drag_Update Or State = #PB_Drag_Enter
    
    If StartDrawing(CanvasOutput(0))
      ; 1. Очищаем фон (белый)
      Box(0, 0, 400, 400, $FFFFFF)
      
      ; 2. Рисуем "активную зону" (серый квадрат)
      Box(50, 50, 300, 200, $EEEEEE)
      DrawText(60, 60, "БРОСАЙ СЮДА", $888888, $EEEEEE)
      
      ; 3. Рисуем ПРЕВЬЮ (полупрозрачная рамка за курсором)
      ; Рисуем синий квадрат 40x40, центрированный по мыши
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(X - 20, Y - 20, 40, 40, $FF0000) ; Синяя рамка
      
      ; Добавляем текст-подсказку рядом с курсором
      DrawingMode(#PB_2DDrawing_Default)
      DrawText(X + 10, Y + 10, "Файл: +", $FFFFFF, $FF0000)
      
      StopDrawing()
    EndIf
    
  ElseIf State = #PB_Drag_Leave
    ; Если файл унесли — очищаем Canvas до исходного состояния
    If StartDrawing(CanvasOutput(0))
      Box(0, 0, 400, 400, $FFFFFF)
      Box(50, 50, 300, 200, $EEEEEE)
      StopDrawing()
    EndIf
  EndIf

  ProcedureReturn #PB_Drag_Copy
EndProcedure

If OpenWindow(0, 0, 0, 420, 320, "Превью за курсором", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  CanvasGadget(0, 10, 10, 400, 300)
  
  ; Рисуем начальный вид
  If StartDrawing(CanvasOutput(0))
    Box(50, 50, 300, 200, $EEEEEE)
    StopDrawing()
  EndIf

  EnableGadgetDrop(0, #PB_Drop_Files, #PB_Drag_Copy)
  SetDropCallback(@MyDropCallback())

  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_GadgetDrop
      ; Очищаем после сброса
      If StartDrawing(CanvasOutput(0))
        Box(0, 0, 400, 400, $FFFFFF)
        DrawText(10, 10, "ПРИНЯТО!", $008800)
        StopDrawing()
      EndIf
      Debug "Файл(ы): " + EventDropFiles()
    EndIf
    
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 65
; Folding = --
; EnableXP
; DPIAware