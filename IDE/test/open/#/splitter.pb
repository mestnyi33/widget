EnableExplicit

Enumeration 
   #WINDOW_1
   #SPLITTER_0 
   #BUTTON_0
   #BUTTON_1
EndEnumeration

Procedure Open_WINDOW_1( ) ;
   OpenWindow( #WINDOW_1, 7, 7, 400, 253, "window_1" )
   ButtonGadget ( #BUTTON_0, 0, 0, 386, 116, "button_0" )
   ButtonGadget  ( #BUTTON_1, 0, 125, 386, 114, "button_1" )
   SplitterGadget( #SPLITTER_0, 7, 7, 386, 239, #BUTTON_0, #BUTTON_1 )
   
   SetGadgetState( #SPLITTER_0, 116 )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_1( )
   
   Define event
   While IsWindow( #WINDOW_1 )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case #WINDOW_1
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If EventWindow( ) = #WINDOW_1
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
; CursorPosition = 46
; FirstLine = 8
; Folding = --
; EnableXP
; DPIAware