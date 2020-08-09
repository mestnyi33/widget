XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure events_gadgets()
  ;ClearDebugOutput()
  Debug ""+EventType()+ " - event widget - " +EventGadget() +" state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
      SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
      ; Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ;ClearDebugOutput()
  Debug ""+this()\event+ " - event widget - " +Str(GetIndex(this()\widget)) + " state - "+ GetState(this()\widget) ; 
  
  Select this()\event
    Case #PB_EventType_Change
      SetGadgetState(GetIndex(this()\widget), GetState(this()\widget))
      ; Debug  Str(GetIndex(this()\widget))+" - widget change " + GetState(this()\widget)
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 140+140, 200, "OptionGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  OptionGadget(0, 10, 20, 115, 20, "Option 1")
  OptionGadget(1, 10, 45, 115, 20, "Option 2")
  OptionGadget(2, 10, 70, 115, 20, "Option 3")
  SetGadgetState(1, 1)   ; set second option as active one
  
  CheckBoxGadget(3, 10,  95, 115, 20, "CheckBox", #PB_CheckBox_ThreeState)
  OptionGadget(4, 10, 120, 115, 20, "Option 2")
  OptionGadget(5, 10, 145, 115, 20, "Option 3")
  
  SetGadgetState(3, #PB_Checkbox_Inbetween)   
  SetGadgetState(4, 1)   
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Option(10+140, 20, 115, 20, "Option 1")
  Option(10+140, 45, 115, 20, "Option 2")
  Option(10+140, 70, 115, 20, "Option 3")
  SetState(GetWidget(1), 1)   ; set second option as active one
  
  CheckBox(10+140,  95, 115, 20, "CheckBox", #PB_CheckBox_ThreeState)
  Option(10+140, 120, 115, 20, "Option 2")
  Option(10+140, 145, 115, 20, "Option 3")
  
  SetState(GetWidget(3), #PB_Checkbox_Inbetween)  
  SetState(GetWidget(4), 1)  
  
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 2
    Bind(GetWidget(i), @events_widgets())
  Next
  
  ;ClearDebugOutput()
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP