;IncludePath "../"
XIncludeFile "widgets().pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  Global *w
  
  Procedure SizeWindowHandler()
      Debug GetState(*w)
  
    ; Resize the gadget to fit the new window dimensions
    ;
    ResizeGadget(getgadget(getroot(*w)), #PB_Ignore, #PB_Ignore, #PB_Ignore, WindowHeight(EventWindow()))
    ;Resize(getroot(*w), #PB_Ignore, #PB_Ignore, #PB_Ignore, WindowHeight(EventWindow())-20)
    Resize(*w, #PB_Ignore, #PB_Ignore, #PB_Ignore, WindowHeight(EventWindow())-20)
  EndProcedure
    

  If Open(#PB_Any, 100, 0, 180, 210, "", #PB_Flag_BorderLess | #PB_Window_SystemMenu | #PB_Window_SizeGadget)
    SetWindowTitle(GetWindow(Root()), "openlist1")
    *w = scroll( 10, 10, 20,180,0, 500, 180, #pb_flag_vertical)
  EndIf
  
  BindEvent(#PB_Event_SizeWindow, @SizeWindowHandler())
  
  ReDraw(Root())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf

; ;IncludePath "../"
; XIncludeFile "bar().pbi"
; 
; 
; ;- EXAMPLE
; CompilerIf #PB_Compiler_IsMainFile
;   EnableExplicit
;   UseModule Bar
;   Global *w
;   
;   Procedure SizeWindowHandler()
;       Debug GetGadgetState(EventGadget())
;   
;     ; Resize the gadget to fit the new window dimensions
;     ;
;     Resize(*w, #PB_Ignore, #PB_Ignore, #PB_Ignore, WindowHeight(EventWindow())-20)
;   EndProcedure
;     
; 
;   If Open(#PB_Any, 100, 0, 180, 210, "", #PB_Flag_BorderLess | #PB_Window_SystemMenu)
;     SetWindowTitle(GetWindow(Root()), "openlist1")
;     *w = Button( 10, 10, 20,180,"button")
;   EndIf
;   
;   
;   ReDraw(Root())
;   
;   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP