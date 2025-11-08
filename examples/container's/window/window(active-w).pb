XIncludeFile "../../../widgets.pbi" : UseWidgets( )

test_focus_draw = 1

Procedure Active()
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


Define Width=500, Height=400

If Open(0, 100, 200, Width, Height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
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
EndIf

End  
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 33
; Folding = --
; EnableXP