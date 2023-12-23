XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   USELIB( WIDGET )
   Global tree
   
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
   
   Procedure ButtonEvents( )
      Select WidgetEventType( ) 
         Case #__event_Down
            ShowMessage( )
            
;          Case #__event_LeftClick
;             Debug "error"
;             AddItem(tree, -1, "add_item")
;             SetState(tree, 10);countitems(tree) - 1)
            
      EndSelect
   EndProcedure
   
   If Open( 0, 150, 150, 600, 300, "demo message", #PB_Window_SizeGadget | #PB_Window_SystemMenu )
      tree=Tree(10, 10, 150, 200, #__tree_nobuttons | #__tree_nolines) 
      Define i
      For i = 0 To 10
         AddItem(tree, -1, Str(i)+"_item")
      Next
      Button( 600-100, 10, 90,30, "test" )
      Define *showButton = Button( 600-100, 300-40, 90,30, "show" )
      Bind( *showButton, @ButtonEvents( ) )
      
      ShowMessage( )
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 57
; FirstLine = 23
; Folding = --
; EnableXP