XIncludeFile "../../../widgets.pbi" : Uselib(widget)


Procedure active()
  If EventWidget( )\type = #__type_Window
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " - window_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure deactive()
  If EventWidget( )\type = #__type_Window
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " - window_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure active_0()
  If EventWidget( )\type = #__type_Window
    Debug " - "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " - window_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure deactive_0()
  If EventWidget( )\type = #__type_Window
    Debug " - "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " - window_"+EventWidget( )\index
  EndIf
EndProcedure


Define width=500, height=400

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   Bind(#PB_All, @active(), #__event_Focus)
;   Bind(#PB_All, @deactive(), #__event_LostFocus)

  Window(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Window(110, 30, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Window(220, 50, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
Bind(#PB_All, @active_0(), #__event_Focus)
Bind(#PB_All, @deactive_0(), #__event_LostFocus)

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
; CursorPosition = 22
; Folding = r-
; EnableXP