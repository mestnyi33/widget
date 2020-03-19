XIncludeFile "form(ide).pb"
XIncludeFile "code(ide).pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile 
  Define event
  window_ide_open()
  
  Repeat 
    event = WaitWindowEvent() 
    
    Select EventWindow()
      Case window_ide 
        window_ide_events(event)
    EndSelect
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP