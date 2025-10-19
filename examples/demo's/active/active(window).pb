XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_show = 1
   
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
   
   If Open(0, 0, 0, 600, 400, " focus demo ", #PB_Window_SystemMenu |
                                              #PB_Window_ScreenCentered )
      
      ;\\
      Window( 30, 30, 200, 150, "window_0", #PB_Window_TitleBar )
      
      SetClass(widget( ), "window_0" )
      Panel( 15,15,170,110 ) : SetClass(widget( ), "panel_1_window_0" )
      AddItem(widget(), -1, "item_0" )
      Button(10,10,150,30,"window_0_button_1")
      SetClass(widget( ), "window_0_button_1" )
      Button(10,45,150,30,"window_0_button_2")
      SetClass(widget( ), "window_0_button_2" )
      CloseList( )
      
      ;\\
      Window( 180, 80, 200, 150, "window_1", #PB_Window_TitleBar )
      
      SetClass(widget( ), "window_1" )
      Panel( 15,15,170,110 ) : SetClass(widget( ), "panel_1_window_1" )
      AddItem(widget(), -1, "item_0" )
      Button(10,10,150,30,"window_1_button_1")
      SetClass(widget( ), "window_1_button_1" )
      Button(10,45,150,30,"window_1_button_2")
      SetClass(widget( ), "window_1_button_2" )
      CloseList( )
      
      ;\\
      Window( 330, 130, 200, 150, "window_2", #PB_Window_TitleBar )
      
      SetClass(widget( ), "window_2" )
      Panel( 15,15,170,110 ) : SetClass(widget( ), "panel_1_window_2" )
      AddItem(widget(), -1, "item_0" )
      Button(10,10,150,30,"window_2_button_1")
      SetClass(widget( ), "window_2_button_1" )
      Button(10,45,150,30,"window_2_button_2")
      SetClass(widget( ), "window_2_button_2" )
      CloseList( )
      
      WaitClose( @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 57
; FirstLine = 20
; Folding = -
; EnableXP
; DPIAware