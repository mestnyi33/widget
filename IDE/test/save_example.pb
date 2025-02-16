EnableExplicit

Global WINDOW_1 = - 1

Global CONTAINER_0 = - 1
Global OPTION_0 = - 1
Global OPTION_1 = - 1
Global PANEL_0 = - 1
Global COMBOBOX_0 = - 1
Global CHECKBOX_0 = - 1
Global CHECKBOX_1 = - 1
Global TEXT_1 = - 1
Global SPIN_0 = - 1
Global TEXT_0 = - 1

Procedure Open_WINDOW_1( )
   WINDOW_1 = OpenWindow( #PB_Any, 217, 66, 365, 302, "window_1" )
      CONTAINER_0 = ContainerGadget( #PB_Any, 35, 21, 288, 260, #PB_Container_Flat )
         OPTION_0 = OptionGadget( #PB_Any, 21, 35, 246, 22, "Выровнять по сетке" )
         OPTION_1 = OptionGadget( #PB_Any, 21, 63, 246, 22, "Выровнять по линии" )
                  
         PANEL_0 = PanelGadget( #PB_Any, 21, 98, 246, 148 )
            COMBOBOX_0 = ComboBoxGadget( #PB_Any, 7, 7, 232, 22 )
            CHECKBOX_0 = CheckBoxGadget( #PB_Any, 7, 35, 232, 22, "Показать сетку" )
            CHECKBOX_1 = CheckBoxGadget( #PB_Any, 7, 63, 232, 22, "Привязать к сетке" )
            TEXT_1 = TextGadget( #PB_Any, 7, 91, 141, 22, "Размер:" )
            SPIN_0 = SpinGadget( #PB_Any, 154, 91, 85, 22, 0, 50, #PB_Spin_Numeric )
         CloseGadgetList( )
      CloseGadgetList( )
         
      TEXT_0 = TextGadget( #PB_Any, 56, 7, 246, 22, "Параметры выравнивания" )
   
      SetGadgetState( OPTION_0, 1 )
      SetGadgetState( PANEL_0, 0 )
      SetGadgetState( CHECKBOX_0, 1 )
      SetGadgetState( SPIN_0, 7 )
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
; CursorPosition = 26
; FirstLine = 15
; Folding = --
; EnableXP
; DPIAware