XIncludeFile "../../../widgets.pbi" : UseWidgets( )

test_focus_show = 1

Procedure active()
  If EventWidget( )\type = #PB_WidgetType_Window
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " - window_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure deactive()
  If EventWidget( )\type = #PB_WidgetType_Window
    Debug ""+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " - window_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure active_0()
  If EventWidget( )\type = #PB_WidgetType_Window
    Debug " - "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " - window_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure deactive_0()
  If EventWidget( )\type = #PB_WidgetType_Window
    Debug " - "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " - window_"+EventWidget( )\index
  EndIf
EndProcedure


Define width=500, height=400

If OpenRoot(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If OpenRoot(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If WindowWidget(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   BindWidgetEvent(#PB_All, @active(), #__event_Focus)
;   BindWidgetEvent(#PB_All, @deactive(), #__event_LostFocus)

  WindowWidget(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  WindowWidget(110, 30, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  WindowWidget(220, 50, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
BindWidgetEvent(#PB_All, @active_0(), #__event_Focus)
BindWidgetEvent(#PB_All, @deactive_0(), #__event_LostFocus)

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
; Folding = r-
; EnableXP