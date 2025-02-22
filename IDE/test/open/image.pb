EnableExplicit

Global WINDOW_IMAGE = - 1


Procedure Open_WINDOW_IMAGE( )
   WINDOW_IMAGE = OpenWindow( #PB_Any, 7, 7, 386, 281, "Редактор изображения" )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_IMAGE( )

   Define event
   While IsWindow( WINDOW_IMAGE )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case WINDOW_IMAGE
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If EventWindow( ) = WINDOW_IMAGE
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


