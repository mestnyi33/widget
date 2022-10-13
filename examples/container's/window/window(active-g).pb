;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 
Uselib(widget)

Procedure active()
  If EventWidget( )\type > 0
    Debug "  "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure deactive()
  If EventWidget( )\type > 0
    Debug "  "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure active_0()
  If EventWidget( )\type > 0
    Debug " -   "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure deactive_0()
  If EventWidget( )\type > 0
    Debug " -   "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget_"+EventWidget( )\index
  EndIf
EndProcedure


Define width=500, height=400

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   Bind(#PB_All, @active(), #PB_EventType_Focus)
;   Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)

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
  
    
  Bind( #PB_All, @active_0(), #PB_EventType_Focus)
  Bind( #PB_All, @deactive_0(), #PB_EventType_LostFocus)
  
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP