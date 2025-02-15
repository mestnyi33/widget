EnableExplicit

Global WINDOW_1 = - 1

Global BUTTON_8 = - 1
Global BUTTON_9 = - 1
Global BUTTON_10 = - 1
Global CONTAINER_0 = - 1
Global BUTTON_11 = - 1
Global BUTTON_12 = - 1
Global BUTTON_13 = - 1
Global CONTAINER_1 = - 1
Global BUTTON_14 = - 1
Global BUTTON_15 = - 1
Global BUTTON_16 = - 1

Procedure Open_WINDOW_1( )
   CloseGadgetList( )
WINDOW_1 = OpenWindow( #PB_Any, 217, 66, 498, 253, "window_1" )
      BUTTON_8 = ButtonGadget( #PB_Any, 21, 14, 120, 64, "button_8" )
      BUTTON_9 = ButtonGadget( #PB_Any, 21, 91, 120, 71, "button_9" )
      BUTTON_10 = ButtonGadget( #PB_Any, 21, 175, 120, 64, "button_10" )
            
      CONTAINER_0 = ContainerGadget( #PB_Any, 154, 14, 330, 225 )
         BUTTON_11 = ButtonGadget( #PB_Any, 14, 21, 141, 43, "button_11" )
         BUTTON_12 = ButtonGadget( #PB_Any, 14, 77, 141, 71, "button_12" )
         BUTTON_13 = ButtonGadget( #PB_Any, 14, 161, 141, 50, "button_13" )
                  
         CONTAINER_1 = ContainerGadget( #PB_Any, 168, 21, 148, 183 )
            BUTTON_14 = ButtonGadget( #PB_Any, 7, 14, 134, 29, "button_14" )
            BUTTON_15 = ButtonGadget( #PB_Any, 7, 56, 134, 71, "button_15" )
            BUTTON_16 = ButtonGadget( #PB_Any, 7, 140, 134, 36, "button_16" )
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


