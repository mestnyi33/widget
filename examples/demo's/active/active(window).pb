XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure CallBack( )
;       Select WidgetEvent( )
;          Case #__event_Focus
;             Debug "active - event " + EventWidget( )\class
;             
;          Case #__event_LostFocus
;             Debug "deactive - event " + EventWidget( )\class
;             
;       EndSelect
   EndProcedure
   
   If OpenRootWidget(0, 0, 0, 800, 600, " focus demo ", #PB_Window_SystemMenu |
                                              #PB_Window_ScreenCentered )
      
      ;\\
      WindowWidget( 30, 30, 300, 200, "window_0", #PB_Window_SystemMenu |
                                            #PB_Window_MaximizeGadget |
                                            #PB_Window_MinimizeGadget )
      
      SetWidgetClass(widget( ), "window_0" )
      PanelWidget( 30,30,240,140 ) : SetWidgetClass(widget( ), "panel_1_window_0" )
      AddItem(widget(), -1, "item_0" )
      ButtonWidget(10,10,200,50,"window_0_button_1")
      SetWidgetClass(widget( ), "window_0_button_1" )
      ButtonWidget(10,65,200,50,"window_0_button_2")
      SetWidgetClass(widget( ), "window_0_button_2" )
      CloseWidgetList( )
      
      ;\\
      WindowWidget( 230, 130, 300, 200, "window_1", #PB_Window_SystemMenu |
                                              #PB_Window_MaximizeGadget |
                                              #PB_Window_MinimizeGadget )
      
      SetWidgetClass(widget( ), "window_1" )
      PanelWidget( 30,30,240,140 ) : SetWidgetClass(widget( ), "panel_1_window_1" )
      AddItem(widget(), -1, "item_0" )
      ButtonWidget(10,10,200,50,"window_1_button_1")
      SetWidgetClass(widget( ), "window_1_button_1" )
      ButtonWidget(10,65,200,50,"window_1_button_2")
      SetWidgetClass(widget( ), "window_1_button_2" )
      CloseWidgetList( )
      
      ;\\
      WindowWidget( 430, 230, 300, 200, "window_2", #PB_Window_SystemMenu |
                                              #PB_Window_MaximizeGadget |
                                              #PB_Window_MinimizeGadget )
      
      SetWidgetClass(widget( ), "window_2" )
      PanelWidget( 30,30,240,140 ) : SetWidgetClass(widget( ), "panel_1_window_2" )
      AddItem(widget(), -1, "item_0" )
      ButtonWidget(10,10,200,50,"window_2_button_1")
      SetWidgetClass(widget( ), "window_2_button_1" )
      ButtonWidget(10,65,200,50,"window_2_button_2")
      SetWidgetClass(widget( ), "window_2_button_2" )
      CloseWidgetList( )
      
      WaitEvent( @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 53
; FirstLine = 24
; Folding = -
; EnableXP
; DPIAware