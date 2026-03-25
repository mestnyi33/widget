; Функция-колбэк, которая следит за движением мыши с файлом
Procedure DragHandler(TargetHandle, State, Action, Format, X, Y)
   
   Select State
    Case #PB_Drag_Enter
       SetGadgetColor(0, #PB_Gadget_BackColor, $00FF00) ; Зеленый при входе
      
    Case #PB_Drag_Leave
      SetGadgetColor(0, #PB_Gadget_BackColor, $FFFFFF) ; Белый при выходе
      
  EndSelect
  
  ProcedureReturn #True ; Разрешаем дроп
EndProcedure

If OpenWindow(0, 0, 0, 300, 200, "Drop Callback Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  StringGadget(0, 20, 20, 260, 160, "Наведи файл сюда!", #PB_String_ReadOnly)
  
  ; 1. Разрешаем дроп
  EnableGadgetDrop(0, #PB_Drop_Files, #PB_Drag_Copy)
  
  ; 2. Устанавливаем колбэк для отслеживания процесса
  SetDropCallback(@DragHandler())

  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_GadgetDrop
      ; Когда бросили — сбрасываем цвет и пишем путь
      SetGadgetColor(0, #PB_Gadget_BackColor, $FFFFFF)
      SetGadgetText(0, EventDropFiles())
    EndIf
    
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 8
; Folding = -
; EnableXP
; DPIAware