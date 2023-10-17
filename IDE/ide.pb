XIncludeFile "ide(form).pb"
XIncludeFile "ide(code).pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile 
  Define event
  ide_open()
  Define *window = widget_add(id_design_form, "window", 30, 30, 400, 250)
   
  Repeat 
    event = WaitWindowEvent() 
    
    Select EventWindow()
      Case window_ide 
        ide_events()
    EndSelect
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 7
; Folding = -
; EnableXP