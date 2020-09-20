XIncludeFile "../../widgets.pbi" 

Uselib(widget)

Procedure active()
  If This()\widget\container =- 1
    Debug ""+This()\widget\class +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug "  "+This()\widget\class +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure deactive()
  If This()\widget\container =- 1
    Debug ""+This()\widget\class +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug "  "+This()\widget\class +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure active_0()
  If This()\widget\container =- 1
    Debug " - "+This()\widget\class +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug " -   "+This()\widget\class +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Procedure deactive_0()
  If This()\widget\container =- 1
    Debug " - "+This()\widget\class +" "+ #PB_Compiler_Procedure + " window"
  Else
    Debug " -   "+This()\widget\class +" "+ #PB_Compiler_Procedure + " gadget"
  EndIf
EndProcedure

Define width=500, height=400

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   Bind(#PB_All, @active(), #PB_EventType_Focus)
;   Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)

  Window(10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  setclass(widget(), widget()\caption\text\string)
  string(10,10,170,30,"1")
  setclass(widget(), gettext(widget()))
;   ;SetActive(widget())
;   Bind( widget(), @active_0(), #PB_EventType_Focus)
;   Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  string(10,50,170,30,"4")
  setclass(widget(), gettext(widget()))
;   ;SetActive(widget())
;   Bind( widget(), @active_0(), #PB_EventType_Focus)
;   Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  Window(110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  setclass(widget(), widget()\caption\text\string)
  string(10,10,170,30,"2")
  setclass(widget(), gettext(widget()))
;   ;SetActive(widget())
;   Bind( widget(), @active_0(), #PB_EventType_Focus)
;   Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  string(10,50,170,30,"5")
  setclass(widget(), gettext(widget()))
;   ;SetActive(widget())
;   Bind( widget(), @active_0(), #PB_EventType_Focus)
;   Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  Window(220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  setclass(widget(), widget()\caption\text\string)
  string(10,10,170,30,"3")
  setclass(widget(), gettext(widget()))
;   ;SetActive(widget())
;   Bind( widget(), @active_0(), #PB_EventType_Focus)
;   Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
  string(10,50,170,30,"6")
  setclass(widget(), gettext(widget()))
;   ;SetActive(widget())
;   Bind( widget(), @active_0(), #PB_EventType_Focus)
;   Bind( widget(), @deactive_0(), #PB_EventType_LostFocus)
  
    
;   Bind( #PB_All, @active_0(), #PB_EventType_Focus)
;   Bind( #PB_All, @deactive_0(), #PB_EventType_LostFocus)
  
  Bind(#PB_All, @active(), #PB_EventType_Focus)
  Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)

  
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
; Folding = +-
; EnableXP