
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   Global Tree
   
;    Macro Message( title, Text, flag=0, parentID=0 ) : MessageRequester( title, Text, flag, parentID ) : EndMacro
   Procedure WaitClose( )
     Repeat 
     Until WaitWindowEvent( ) = #PB_Event_CloseWindow
  EndProcedure
  
   Procedure ShowMessage(  )
      
      Debug "open - Title"
      Define Result = MessageRequester( "Title", "Please make your input:", #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Info ) 
      Debug " close - Title " + Result
      
      Define flag, a$ = "Result of the previously requester was: "
      
      If Result = #PB_MessageRequester_Yes       ; pressed Yes button
         flag = #PB_MessageRequester_Ok|#PB_MessageRequester_Info
         a$ +#LF$+ "Yes"
      ElseIf Result = #PB_MessageRequester_No    ; pressed No button
         flag = #PB_MessageRequester_YesNo|#PB_MessageRequester_Error
         a$ +#LF$+ "No"
      Else                                       ; pressed Cancel button or Esc
         flag = #PB_MessageRequester_YesNoCancel|#pb_MessageRequester_Warning
         a$ +#LF$+ "Cancel"
      EndIf
      
      Debug "open - Information"
      Result = MessageRequester("Information", a$, flag)
      Debug "close - Information "+Result
      
   EndProcedure
   
   Procedure ButtonEvents( )
      Select EventType( ) 
         Case #PB_EventType_LeftClick
            ShowMessage( )
       EndSelect
   EndProcedure
   
   If OpenWindow( 0, 150, 150, 600, 300, "demo message", #PB_Window_SizeGadget | #PB_Window_SystemMenu )
      Tree=TreeGadget(-1, 10, 10, 150, 200, #PB_Tree_NoButtons | #PB_Tree_NoLines) 
      Define i
      For i = 0 To 10
         AddGadgetItem(Tree, -1, Str(i)+"_item")
      Next
      ButtonGadget(-1, 600-100, 10, 90,30, "test" )
      Define *showButton = ButtonGadget(-1, 600-100, 300-40, 90,30, "show" )
      BindGadgetEvent( *showButton, @ButtonEvents( ) )
      
      ShowMessage( )
      
      WaitClose( )
   EndIf
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 32
; FirstLine = 11
; Folding = --
; EnableXP
; DPIAware