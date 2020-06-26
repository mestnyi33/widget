XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure active()
  If This()\widget\container =- 1
    Debug "window "+#PB_Compiler_Procedure +" "+ This()\widget\index
  Else
    Debug "gadget "+#PB_Compiler_Procedure +" "+ This()\widget\index
  EndIf
EndProcedure

Procedure deactive()
  If This()\widget\container =- 1
    Debug "window "+#PB_Compiler_Procedure +" "+ This()\widget\index
  Else
    Debug "gadget "+#PB_Compiler_Procedure +" "+ This()\widget\index
  EndIf
EndProcedure

Procedure active_0()
  If This()\widget\container =- 1
    Debug "window "+#PB_Compiler_Procedure +" "+ This()\widget\index
  Else
    Debug "gadget "+#PB_Compiler_Procedure +" "+ This()\widget\index
  EndIf
EndProcedure

Procedure deactive_0()
  If This()\widget\container =- 1
    Debug "window "+#PB_Compiler_Procedure +" "+ This()\widget\index
  Else
    Debug "gadget "+#PB_Compiler_Procedure +" "+ This()\widget\index
  EndIf
EndProcedure

Define width=500, height=400

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
  Bind(#PB_All, @active(), #PB_EventType_Focus)
  Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)

  Window(10, 10, 150, 100, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  String(10,10,180,30,"string_0")
  SetActive(widget())
  
  String(10,50,180,30,"string_1")
  SetActive(widget())
  
  Window(110, 30, 150, 100, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  String(10,10,180,30,"string_2")
  SetActive(widget())
  
  String(10,50,180,30,"string_3")
  SetActive(widget())
  
  Window(220, 50, 150, 100, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  String(10,10,180,30,"string_4")
  SetActive(widget())
  
  String(10,50,180,30,"string_5")
  SetActive(widget())
  
    
  Bind( #PB_All, @active_0(), #PB_EventType_Focus)
  Bind( #PB_All, @deactive_0(), #PB_EventType_LostFocus)
  
  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_CloseWindow 
      Quit = 1
    EndIf
    
  Until Quit = 1
  
EndIf

End  
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP