XIncludeFile "../../widgets.pbi" 

Uselib(widget)

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

Define width=500, height=400

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  a_init(root())
      
  Window(50, 50, 390, 250, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget); | #__flag_anchorsgadget)
  string(10,10,170,30,"string_0")
  ;SetAlignment(widget(), #__align_center)
  
  ;SetActive(widget())
  Bind( widget(), @active(), #PB_EventType_Focus)
  Bind( widget(), @deactive(), #PB_EventType_LostFocus)
  
  
  
  WaitClose()
EndIf

End  
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP