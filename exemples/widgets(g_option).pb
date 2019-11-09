IncludePath "../"
XIncludeFile "widgets().pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  Global *w
  
  If Open(#PB_Any, 0, 0, 180, 210, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetWindowTitle(GetWindow(Root()), "OptionGadget")
    
    Checkbox( 50, 20, 80, 20, "Checkbox 1")
    SetState(widget(), 1) 
    
    *w=Option( 50, 45, 80, 20, "Option 2")
    Option( 50, 70, 80, 20, "Option 3")
    SetState(*w, 1)   ; set second option as active one
    
    Button( 50, 95, 80,20,"button")
    
    Checkbox( 50, 120, 80, 20, "Checkbox 1")
    SetState(widget(), 1) 
    
    *w=Option( 50, 145, 80, 20, "Option 2")
    Option( 50, 170, 80, 20, "Option 3")
    SetState(*w, 1)   ; set second option as active one
    
    redraw(root())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP