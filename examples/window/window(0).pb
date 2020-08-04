
  
  Open(OpenWindow(#PB_Any, 150, 150, 600, 300, "PB (window_1)", #__Window_SizeGadget | #__Window_SystemMenu))
    
 ; Window(200, 10, 400,120, "Window_0", #__window_titlebar)
  
  ;   Result = Message("Title", "Please make your input:", #PB_MessageRequester_Ok) 
  ;   Result = Message("Title", "Please make your input:", #PB_MessageRequester_YesNo) 
  Result = Message("Title", "Please make your input:", #PB_MessageRequester_YesNoCancel) 
  a$ = "Result of the previously requester was: "
  If Result = #PB_MessageRequester_Yes       ; pressed Yes button
    a$ + "Yes"
  ElseIf Result = #PB_MessageRequester_No    ; pressed No button
    a$ + "No"
  Else                                       ; pressed Cancel button or Esc
    a$ + "Cancel"
  EndIf
  ;MessageRequester("Information", a$, #PB_MessageRequester_Ok)
  
Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP