EnableExplicit

Global WINDOW_1 = - 1

Global CONTAINER_0 = - 1
Global BUTTON_0 = - 1
Global CONTAINER_1 = - 1
Global BUTTON_1 = - 1
Global CONTAINER_2 = - 1
Global BUTTON_2 = - 1

Procedure Open_WINDOW_1( )
   WINDOW_1 = OpenWindow( #PB_Any, 7, 7, 351, 204, "window_1" )
      CONTAINER_0 = ContainerGadget( #PB_Any, 7, 7, 323, 183, #PB_Container_Flat )
         BUTTON_0 = ButtonGadget( #PB_Any, 7, 21, 99, 29, "button_0" )
                  
         CONTAINER_1 = ContainerGadget( #PB_Any, 133, 21, 92, 141, #PB_Container_Flat )
            BUTTON_1 = ButtonGadget( #PB_Any, 7, 21, 29, 29, "button_1" )
         CloseGadgetList( )
         
         CONTAINER_2 = ContainerGadget( #PB_Any, 231, 21, 92, 141, #PB_Container_Flat )
            BUTTON_2 = ButtonGadget( #PB_Any, 7, 21, 29, 29, "button_2" )
         CloseGadgetList( )
      CloseGadgetList( )
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
; CursorPosition = 8
; Folding = --
; EnableXP
; DPIAware