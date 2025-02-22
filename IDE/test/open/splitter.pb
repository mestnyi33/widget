EnableExplicit

Global WINDOW_1 =-1, 
       Window_0_ScrollArea_0 =-1, 
       Window_0_Tree_0 =-1, 
       Window_0_Panel_0 =-1, 
       Window_0_Splitter_0 =-1, 
       Window_0_Splitter_1 =-1


Procedure Open_WINDOW_1( )
   
   WINDOW_1 = OpenWindow(#PB_Any, 470, 230, 501, 401, "Window_0", #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget )                                                                                                                                                                                
   Window_0_ScrollArea_0 = ScrollAreaGadget(#PB_Any, 0, 0, 241, 391, 0, 0, 0)  
   CloseGadgetList()
   Window_0_Tree_0 = TreeGadget(#PB_Any, 0, 0, 241, 192)   
    
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_1( )

   Define event
   While IsWindow( WINDOW_1 )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case WINDOW_1
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If EventWindow( ) = WINDOW_1
               If #PB_MessageRequester_Yes = MessageRequester( "Message", 
                                                               "Are you sure you want To go out?", 
                                                               #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
                  CloseWindow( EventWindow( ) )
               EndIf
            Else
               CloseWindow( EventWindow( ) )
            EndIf
      EndSelect
   Wend
   End
CompilerEndIf



; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 15
; Folding = --
; EnableXP
; DPIAware