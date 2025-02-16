If OpenWindow(1, 515, 162, 367, 328, "Главное Окно", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)                                                                                                                                                                                                                       
  ButtonGadget(11, 10, 10, 210, 25, "Кнопка id(11)")
  
  OpenWindow(3, 615, 312, 201, 110, "3Дочернее Окно", #PB_Window_TitleBar | #PB_Window_WindowCentered | #PB_Window_NoGadgets, WindowID(1)) 
    
  If OpenWindow(2, 615, 312, 201, 110, "Дочернее Окно", #PB_Window_TitleBar | #PB_Window_WindowCentered | #PB_Window_NoGadgets, WindowID(1)) 
    OldGadgetList = UseGadgetList(WindowID(2)) ; Создать GadgetList и сохранить старый GadgetList
    ButtonGadget(21, 10, 10, 180, 25, "Кнопка Дочернего Окна")
    
    UseGadgetList( OldGadgetList )               ; Вернуться к предыдущему GadgetList
  EndIf
  
  ButtonGadget(12, 10, 45, 210, 25, "Кнопка id(12)") ; Это будет снова в главном окне
  
  ;     OldGadgetList = UseGadgetList(WindowID(2)) ; Создать GadgetList и сохранить старый GadgetList
  ;     ButtonGadget(22, 10, 45, 150, 25, "это тоже") ; Это будет снова в главном окне
  ;     UseGadgetList(OldGadgetList)               ; Вернуться к предыдущему GadgetList
  ;     
  ;     ButtonGadget(102, 10, 80, 150, 25, "Кнопка 102") ; Это будет снова в главном окне
  
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 15
; EnableXP
; CompileSourceDirectory