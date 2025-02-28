EnableExplicit

Global WINDOW_0 = - 1

Global BUTTON_0 = - 1
Global TEXT_0 = - 1
Global BUTTON_1 = - 1
Global STRING_0 = - 1
Global SCROLLAREA_0 = - 1
Global BUTTON_2 = - 1
Global TEXT_1 = - 1
Global BUTTON_3 = - 1
Global TEXT_2 = - 1
Global PANEL_0 = - 1
Global BUTTON_4 = - 1
Global TEXT_3 = - 1
Global BUTTON_5 = - 1
Global TEXT_4 = - 1
Global BUTTON_6 = - 1
Global TEXT_5 = - 1
Global BUTTON_7 = - 1
Global TEXT_6 = - 1

Procedure Open_WINDOW_0( )
   WINDOW_0 = OpenWindow( #PB_Any, 7, 7, 498, 253, "window_0",  #PB_Window_SystemMenu | #PB_Window_SizeGadget  )
      BUTTON_0 = ButtonGadget( #PB_Any, 14, 28, 50, 29, "button_0",  #PB_Button_MultiLine  )
      TEXT_0 = TextGadget( #PB_Any, 28, 63, 50, 29, "text_0" )
      BUTTON_1 = ButtonGadget( #PB_Any, 35, 105, 50, 29, "button_1" )
      STRING_0 = StringGadget( #PB_Any, 42, 147, 50, 29, "string_0" )
      
      SCROLLAREA_0 = ScrollAreaGadget( #PB_Any, 119, 28, 169, 176, 165, 175, 5,  #PB_ScrollArea_Flat  )
         BUTTON_2 = ButtonGadget( #PB_Any, 14, 28, 29, 29, "button_2" )
         TEXT_1 = TextGadget( #PB_Any, 28, 63, 50, 29, "text_1" )
         BUTTON_3 = ButtonGadget( #PB_Any, 35, 105, 78, 29, "button_3" )
         TEXT_2 = TextGadget( #PB_Any, 42, 147, 50, 29, "text_2" )
      CloseGadgetList( ) ; SCROLLAREA_0

      PANEL_0 = PanelGadget( #PB_Any, 322, 28, 169, 176 )
         AddGadgetItem( PANEL_0, - 1, "panel_item_0" )  
         BUTTON_4 = ButtonGadget( #PB_Any, 14, 28, 29, 29, "button_4" )
         TEXT_3 = TextGadget( #PB_Any, 28, 63, 50, 29, "text_3" )
         BUTTON_5 = ButtonGadget( #PB_Any, 35, 105, 78, 29, "button_5" )
         TEXT_4 = TextGadget( #PB_Any, 42, 147, 50, 29, "text_4" )
         
         AddGadgetItem( PANEL_0, - 1, "panel_item_1" )  
         BUTTON_6 = ButtonGadget( #PB_Any, 112, 28, 29, 29, "button_6" )
         TEXT_5 = TextGadget( #PB_Any, 126, 63, 50, 29, "text_5" )
         BUTTON_7 = ButtonGadget( #PB_Any, 133, 105, 78, 29, "button_7" )
         TEXT_6 = TextGadget( #PB_Any, 147, 147, 50, 29, "text_6" )
      CloseGadgetList( ) ; PANEL_0
   
      DisableGadget( BUTTON_0, #True )
      SetGadgetState( PANEL_0, 1 )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_0( )

   Define event
   While IsWindow( WINDOW_0 )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case WINDOW_0
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If WINDOW_0 = EventWindow( )
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