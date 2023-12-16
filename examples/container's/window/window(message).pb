XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  USELIB( WIDGET )
  
  Procedure ShowMessage(  )
     
    Debug "open - Title"
    Define Result = Message( "Title", "Please make your input:", #__message_YesNoCancel|#__message_Info ) 
    Debug " close - Title " + Result
    
    Define flag, a$ = "Result of the previously requester was: "
    
    If Result = #__message_Yes       ; pressed Yes button
      flag = #__message_Ok|#__message_Info
      a$ +#LF$+ "Yes"
    ElseIf Result = #__message_No    ; pressed No button
      flag = #__message_YesNo|#__message_Error
      a$ +#LF$+ "No"
    Else                                       ; pressed Cancel button or Esc
      flag = #__message_YesNoCancel|#__message_Warning
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
  
  If Open( 0, 150, 150, 600, 300, "demo message", #PB_Window_SizeGadget | #PB_Window_SystemMenu )
    Button( 600-100, 10, 90,30, "test" )
    Define *showButton = Button( 600-100, 300-40, 90,30, "show" )
    Bind( *showButton, @EventClick( ) )
    
    ;ShowMessage( )
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 38
; FirstLine = 8
; Folding = --
; EnableXP