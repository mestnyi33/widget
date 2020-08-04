XIncludeFile "../../widgets.pbi" 
Uselib(widget)

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UsePNGImageDecoder()
  Define flag
  
  Open(OpenWindow(#PB_Any, 150, 150, 600, 300, "PB (window_1)", #__Window_SizeGadget | #__Window_SystemMenu))
  
  Define Result = Message("Title", "Please make your input:", #PB_MessageRequester_YesNoCancel) 
  Define a$ = "Result of the previously requester was: "
  
  If Result = #PB_MessageRequester_Yes       ; pressed Yes button
    flag = #PB_MessageRequester_Ok|#PB_MessageRequester_Info
    a$ + "Yes"
  ElseIf Result = #PB_MessageRequester_No    ; pressed No button
    flag = #PB_MessageRequester_YesNo|#PB_MessageRequester_Error
    a$ + "No"
  Else                                       ; pressed Cancel button or Esc
    flag = #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Warning
    a$ + "Cancel"
  EndIf
  Message("Information", a$, flag)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP