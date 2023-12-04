XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  USELIB( WIDGET )
  UsePNGImageDecoder()
  
  Procedure ShowMessage(  )
    Debug "open - Title"
    Define Result = Message("Title", "Please make your input:", #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Info) 
    Debug " close - Title " + Result
    
    Define flag, a$ = "Result of the previously requester was: "
    
    If Result = #PB_MessageRequester_Yes       ; pressed Yes button
      flag = #PB_MessageRequester_Ok|#PB_MessageRequester_Info
      a$ +#LF$+ "Yes"
    ElseIf Result = #PB_MessageRequester_No    ; pressed No button
      flag = #PB_MessageRequester_YesNo|#PB_MessageRequester_Error
      a$ +#LF$+ "No"
    Else                                       ; pressed Cancel button or Esc
      flag = #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Warning
      a$ +#LF$+ "Cancel"
    EndIf
    
    Debug "open - Information"
    Result = Message("Information", a$, flag)
    Debug "close - Information "+Result
    
  EndProcedure
  
  Procedure EventClick( )
    If WidgetEventType( ) = #__event_LeftClick
      ShowMessage( )
    EndIf
  EndProcedure
  
  If Open( 0, 150, 150, 600, 300, "demo message", #__Window_SizeGadget | #__Window_SystemMenu )
    Define *showButton = Button( 600-100, 300-40, 90,30,"show")
    Bind( *showButton, @EventClick() )
    
    ShowMessage( )
    Debug 88888
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 42
; FirstLine = 9
; Folding = --
; EnableXP