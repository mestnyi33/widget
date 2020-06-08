; comment uncomment to see
XIncludeFile "../../gadgets.pbi" : UseModule gadget

Procedure events_gadgets()
  ClearDebugOutput()
  
  Select EventType()
    Case #PB_EventType_Change
      Debug  ""+ EventGadget() +" - gadget change state " + GetGadgetState(EventGadget())
      
    Case #PB_EventType_LeftClick
      Debug  ""+ EventGadget() +" - gadget click state " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

If OpenWindow(#PB_Any, 0, 0, 140+140, 200, "OptionGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  OptionGadget(0, 30, 20, 80, 20, "Option 1")
  OptionGadget(1, 30, 45, 80, 20, "Option 2")
  OptionGadget(2, 30, 70, 80, 20, "Option 3")
  SetGadgetState(1, 1)   ; set second option as active one
  
  CheckBoxGadget(3, 30,  95, 80, 20, "CheckBox", #PB_CheckBox_ThreeState)
  OptionGadget(4, 30, 120, 80, 20, "Option 2")
  OptionGadget(5, 30, 145, 80, 20, "Option 3")
  
  SetGadgetState(3, #PB_Checkbox_Inbetween)   
  SetGadgetState(4, 1)   
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP