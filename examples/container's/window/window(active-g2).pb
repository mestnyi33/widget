XIncludeFile "../../../widgets.pbi" : UseWidgets( )

test_focus_show = 1

Procedure active()
  Protected *ew._s_widget = EventWidget( )
  If is_window_( *ew )
    Debug ""+*ew\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug "  "+*ew\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure deactive()
  Protected *ew._s_widget = EventWidget( )
  If is_window_( *ew )
    Debug ""+*ew\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug "  "+*ew\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure active_0()
  Protected *ew._s_widget = EventWidget( )
  If is_window_( *ew )
    Debug " - "+*ew\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug " -   "+*ew\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure deactive_0()
  Protected *ew._s_widget = EventWidget( )
  If is_window_( *ew )
    Debug " - "+*ew\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug " -   "+*ew\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure


Define width=500, height=400

If OpenRoot(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If OpenRoot(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If WindowWidget(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   BindWidgetEvent(#PB_All, @active(), #__event_Focus)
;   BindWidgetEvent(#PB_All, @deactive(), #__event_LostFocus)

  WindowWidget(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *button_0 = ButtonWidget(10,10,170,30,"button_0")
  ;SetActiveWidget(*button_0)
  BindWidgetEvent( *button_0, @active_0(), #__event_Focus)
  BindWidgetEvent( *button_0, @deactive_0(), #__event_LostFocus)
  
  Define *button_1 = ButtonWidget(10,50,170,30,"button_1")
  ;SetActiveWidget(*button_1)
  BindWidgetEvent( *button_1, @active_0(), #__event_Focus)
  BindWidgetEvent( *button_1, @deactive_0(), #__event_LostFocus)
  
  WindowWidget(110, 30, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *button_2 = ButtonWidget(10,10,170,30,"button_2")
  ;SetActiveWidget(*button_2)
  BindWidgetEvent( *button_2, @active_0(), #__event_Focus)
  BindWidgetEvent( *button_2, @deactive_0(), #__event_LostFocus)
  
  Define *button_3 = ButtonWidget(10,50,170,30,"button_3")
  ;SetActiveWidget(*button_3)
  BindWidgetEvent( *button_3, @active_0(), #__event_Focus)
  BindWidgetEvent( *button_3, @deactive_0(), #__event_LostFocus)
  
  WindowWidget(220, 50, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *button_4 = ButtonWidget(10,10,170,30,"button_4")
  ;SetActiveWidget(*button_4)
  BindWidgetEvent( *button_4, @active_0(), #__event_Focus)
  BindWidgetEvent( *button_4, @deactive_0(), #__event_LostFocus)
  
  Define *button_5 = ButtonWidget(10,50,170,30,"button_5")
  ;SetActiveWidget(*button_5)
  BindWidgetEvent( *button_5, @active_0(), #__event_Focus)
  BindWidgetEvent( *button_5, @deactive_0(), #__event_LostFocus)
  
    
;   BindWidgetEvent( #PB_All, @active_0(), #__event_Focus)
;   BindWidgetEvent( #PB_All, @deactive_0(), #__event_LostFocus)
  
  WaitCloseRoot()

;   Repeat
;     Event = WaitWindowEvent()
;     
;     If Event = #PB_Event_CloseWindow 
;       Quit = 1
;     EndIf
;     
;   Until Quit = 1
  
EndIf

End  
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 3
; Folding = --
; EnableXP