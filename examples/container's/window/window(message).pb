XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
  ; test_draw_repaint = 1
   
   Global Tree, *showButton
   
;    Macro Message( title, Text, flag=0, parentID=0 ) : MessageRequester( title, Text, flag, parentID ) : EndMacro
   
   Procedure ShowMessage(  )
      ; Debug "open - Title"
      Define Result = Message( "Title", "Please make your input:", #__message_YesNoCancel ) 
      ; Debug " close - Title " + Result
      
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
      
      ; Debug "open - Information"
      Result = Message("Information", a$, flag)
      ; Debug "close - Information "+Result
      
     ; Result = Message("Title", "text without image")
   EndProcedure
   
   Procedure ButtonEvents( )
      Select WidgetEvent( ) 
         Case #__event_KeyDown
            If keyboard( )\key = #PB_Shortcut_Return
               If GetActive( ) = *showButton
                  ShowMessage( )
               EndIf
            EndIf
              
         Case #__event_Down
            ShowMessage( )
       EndSelect
   EndProcedure
   
   If Open( 0, 150, 150, 600, 300, "demo message", #PB_Window_SizeGadget | #PB_Window_SystemMenu )
      Tree=Tree(10, 10, 150, 200, #__flag_nobuttons | #__flag_nolines) 
      Define i
      For i = 0 To 10
         AddItem(Tree, -1, Str(i)+"_item")
      Next
      Button( 600-100, 10, 90,30, "test" )
      *showButton = Button( 600-100, 300-40, 90,30, "show" )
      Bind( *showButton, @ButtonEvents( ) )
      SetActive( *showButton )
      
      ShowMessage( )
      
      WaitClose( )
   EndIf
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
  EnableExplicit
  UseWidgets( )
  
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
    If WidgetEvent( ) = #__event_LeftClick
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
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 61
; FirstLine = 26
; Folding = -8-
; EnableXP
; DPIAware