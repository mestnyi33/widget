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

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   Bind(#PB_All, @active(), #__event_Focus)
;   Bind(#PB_All, @deactive(), #__event_LostFocus)

  Window(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *button_0 = ButtonWidget(10,10,170,30,"button_0")
  ;SetActive(*button_0)
  Bind( *button_0, @active_0(), #__event_Focus)
  Bind( *button_0, @deactive_0(), #__event_LostFocus)
  
  Define *button_1 = ButtonWidget(10,50,170,30,"button_1")
  ;SetActive(*button_1)
  Bind( *button_1, @active_0(), #__event_Focus)
  Bind( *button_1, @deactive_0(), #__event_LostFocus)
  
  Window(110, 30, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *button_2 = ButtonWidget(10,10,170,30,"button_2")
  ;SetActive(*button_2)
  Bind( *button_2, @active_0(), #__event_Focus)
  Bind( *button_2, @deactive_0(), #__event_LostFocus)
  
  Define *button_3 = ButtonWidget(10,50,170,30,"button_3")
  ;SetActive(*button_3)
  Bind( *button_3, @active_0(), #__event_Focus)
  Bind( *button_3, @deactive_0(), #__event_LostFocus)
  
  Window(220, 50, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *button_4 = ButtonWidget(10,10,170,30,"button_4")
  ;SetActive(*button_4)
  Bind( *button_4, @active_0(), #__event_Focus)
  Bind( *button_4, @deactive_0(), #__event_LostFocus)
  
  Define *button_5 = ButtonWidget(10,50,170,30,"button_5")
  ;SetActive(*button_5)
  Bind( *button_5, @active_0(), #__event_Focus)
  Bind( *button_5, @deactive_0(), #__event_LostFocus)
  
    
;   Bind( #PB_All, @active_0(), #__event_Focus)
;   Bind( #PB_All, @deactive_0(), #__event_LostFocus)
  
  WaitClose()

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