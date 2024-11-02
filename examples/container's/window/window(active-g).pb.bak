XIncludeFile "../../../widgets.pbi" 
;XIncludeFile "../../../widget-events.pbi" 
Uselib(widget)

test_focus_show = 1

Procedure active()
  Protected *ew._s_widget = EventWidget( )
  If *ew\type > 0
    Debug "  "+*ew\index +" "+ #PB_Compiler_Procedure + " gadget_"+*ew\index
  EndIf
EndProcedure

Procedure deactive()
  Protected *ew._s_widget = EventWidget( )
  If *ew\type > 0
    Debug "  "+*ew\index +" "+ #PB_Compiler_Procedure + " gadget_"+*ew\index
  EndIf
EndProcedure

Procedure active_0()
  Protected *ew._s_widget = EventWidget( )
  If *ew\type > 0
    Debug " -   "+*ew\index +" "+ #PB_Compiler_Procedure + " gadget_"+*ew\index
  EndIf
EndProcedure

Procedure deactive_0()
  Protected *ew._s_widget = EventWidget( )
  If *ew\type > 0
    Debug " -   "+*ew\index +" "+ #PB_Compiler_Procedure + " gadget_"+*ew\index
  EndIf
EndProcedure


Define width=500, height=400

If Open(0, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   Bind(#PB_All, @active(), #__event_Focus)
;   Bind(#PB_All, @deactive(), #__event_LostFocus)

  Window(10, 10, 190, 150, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *string_0 = String(10,10,170,60,"string_0")
  ;SetActive(*string_0)
  
  Define *string_1 = String(10,80,170,60,"string_1")
  ;SetActive(*string_1)
  
  Window(110, 30, 190, 150, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *string_2 = String(10,10,170,60,"string_2")
  ;SetActive(*string_2)
  
  Define *string_3 = String(10,80,170,60,"string_3")
  ;SetActive(*string_3)
  
  Window(220, 50, 190, 150, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *string_4 = String(10,10,170,60,"string_4")
  SetActive(*string_4)
  
  Define *string_5 = String(10,80,170,60,"string_5")
  ;SetActive(*string_5)
  
    
  Bind( #PB_All, @active_0(), #__event_Focus)
  Bind( #PB_All, @deactive_0(), #__event_LostFocus)
  
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
; CursorPosition = 5
; Folding = --
; EnableXP