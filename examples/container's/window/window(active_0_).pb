XIncludeFile "../../../widgets.pbi" : Uselib(widget)

Procedure active()
  If This()\widget\container =- 1
    Debug ""+This()\widget\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug "  "+This()\widget\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure deactive()
  If This()\widget\container =- 1
    Debug ""+This()\widget\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug "  "+This()\widget\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure active_0()
  If This()\widget\container =- 1
    Debug " - "+This()\widget\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug " -   "+This()\widget\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure deactive_0()
  If This()\widget\container =- 1
    Debug " - "+This()\widget\index +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug " -   "+This()\widget\index +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Define width=500, height=400

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   Bind(#PB_All, @active(), #PB_EventType_Focus)
;   Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)

  Window(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_0")
  ;SetActive(widget())
  Bind( widget(), @active_0(), #PB_EventType_Focus)
  Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  button(10,50,170,30,"button_1")
  ;SetActive(widget())
  Bind( widget(), @active_0(), #PB_EventType_Focus)
  Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  Window(110, 30, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_2")
  ;SetActive(widget())
  Bind( widget(), @active_0(), #PB_EventType_Focus)
  Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  button(10,50,170,30,"button_3")
  ;SetActive(widget())
  Bind( widget(), @active_0(), #PB_EventType_Focus)
  Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  Window(220, 50, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_4")
  ;SetActive(widget())
  Bind( widget(), @active_0(), #PB_EventType_Focus)
  Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  button(10,50,170,30,"button_5")
  ;SetActive(widget())
  Bind( widget(), @active_0(), #PB_EventType_Focus)
  Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
    
;   Bind( #PB_All, @active_0(), #PB_EventType_Focus)
;   Bind( #PB_All, @deactive_0(), #PB_EventType_LostFocus)
  
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
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = 7-
; EnableXP