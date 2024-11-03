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
   
   If Open(0, 0, 0, 800, 600, " focus demo ", #PB_Window_SystemMenu |
                                              #PB_Window_ScreenCentered )
      
      ;\\
      Window( 30, 30, 300, 200, "window_0", #PB_Window_SystemMenu |
                                            #PB_Window_MaximizeGadget |
                                            #PB_Window_MinimizeGadget )
      
      SetClass(widget( ), "window_0" )
      Panel( 30,30,240,140 ) : SetClass(widget( ), "panel_1_window_0" )
      AddItem(widget(), -1, "item_0" )
      Button(10,10,200,50,"window_0_button_1")
      SetClass(widget( ), "window_0_button_1" )
      Button(10,65,200,50,"window_0_button_2")
      SetClass(widget( ), "window_0_button_2" )
      CloseList( )
      
      ;\\
      Window( 230, 130, 300, 200, "window_1", #PB_Window_SystemMenu |
                                              #PB_Window_MaximizeGadget |
                                              #PB_Window_MinimizeGadget )
      
      SetClass(widget( ), "window_1" )
      Panel( 30,30,240,140 ) : SetClass(widget( ), "panel_1_window_1" )
      AddItem(widget(), -1, "item_0" )
      Button(10,10,200,50,"window_1_button_1")
      SetClass(widget( ), "window_1_button_1" )
      Button(10,65,200,50,"window_1_button_2")
      SetClass(widget( ), "window_1_button_2" )
      CloseList( )
      
      ;\\
      Window( 430, 230, 300, 200, "window_2", #PB_Window_SystemMenu |
                                              #PB_Window_MaximizeGadget |
                                              #PB_Window_MinimizeGadget )
      
      SetClass(widget( ), "window_2" )
      Panel( 30,30,240,140 ) : SetClass(widget( ), "panel_1_window_2" )
      AddItem(widget(), -1, "item_0" )
      Button(10,10,200,50,"window_2_button_1")
      SetClass(widget( ), "window_2_button_1" )
      Button(10,65,200,50,"window_2_button_2")
      SetClass(widget( ), "window_2_button_2" )
      CloseList( )
      
      WaitEvent( @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 7
; FirstLine = 3
; Folding = -
; EnableXP
; DPIAware