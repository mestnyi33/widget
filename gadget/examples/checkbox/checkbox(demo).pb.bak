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

Define cr.s = #LF$, text.s = "this long" + cr + " multiline " + cr + "text"
  
If OpenWindow(#PB_Any, 0, 0, 160, 110, "CheckBoxGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CheckBoxGadget(0, 10, 10, 140, 20, "CheckBox 1")
  CheckBoxGadget(1, 10, 35, 140, 40, text, #PB_CheckBox_ThreeState)
  CheckBoxGadget(2, 10, 80, 140, 20, "CheckBox 3")
  SetGadgetState(0, #PB_Checkbox_Checked)   ; set first option as active one
  SetGadgetState(1, #PB_Checkbox_Inbetween)   ; set second option as active one
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP