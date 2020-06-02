XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure events_gadgets()
  ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ClearDebugOutput()
  ; Debug ""+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(*event\widget) ; 
  
  Select *event\type
    Case #PB_EventType_Change
      SetGadgetState(GetIndex(*event\widget), GetState(*event\widget))
      Debug  Str(GetIndex(*event\widget))+" - widget change " + GetState(*event\widget)
  EndSelect
EndProcedure

Define cr.s = #LF$, text.s = "this long" + cr + " multiline " + cr + "text"
  
; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 140+140, 100, "CheckBoxGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  CheckBoxGadget(0, 10, 10, 140, 20, "CheckBox 1")
  CheckBoxGadget(1, 10, 30, 140, 40, text, #PB_CheckBox_ThreeState)
  CheckBoxGadget(2, 10, 70, 140, 20, "CheckBox 3")
  SetGadgetState(0, #PB_Checkbox_Checked)   ; set first option as active one
  SetGadgetState(1, #PB_Checkbox_Inbetween)   ; set second option as active one
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  CheckBox(10+140, 10, 140, 20, "CheckBox 1")
  CheckBox(10+140, 30, 140, 40, text, #PB_CheckBox_ThreeState);, #__text_center)
  CheckBox(10+140, 70, 140, 20, "CheckBox 3", #__text_right)
  SetState(GetWidget(0), #PB_Checkbox_Checked)   ; set first option as active one
  SetState(GetWidget(1), #PB_Checkbox_Inbetween)   ; set second option as active one
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 2
    Bind(GetWidget(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP