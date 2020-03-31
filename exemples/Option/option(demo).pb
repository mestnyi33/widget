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
      SetGadgetState((*event\widget\index - 1), GetState(*event\widget))
      Debug  Str(*event\widget\index - 1)+" - widget change " + GetState(*event\widget)
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 140+140, 200, "OptionGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  OptionGadget(0, 30, 20, 80, 20, "Option 1")
  OptionGadget(1, 30, 45, 80, 20, "Option 2")
  OptionGadget(2, 30, 70, 80, 20, "Option 3")
  SetGadgetState(1, 1)   ; set second option as active one
  
  CheckBoxGadget(3, 30,  95, 80, 20, "CheckBox")
  OptionGadget(4, 30, 120, 80, 20, "Option 2")
  OptionGadget(5, 30, 145, 80, 20, "Option 3")
  
  SetGadgetState(3, 1)   
  SetGadgetState(4, 1)   
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Option(30+140, 20, 80, 20, "Option 1")
  Option(30+140, 45, 80, 20, "Option 2")
  Option(30+140, 70, 80, 20, "Option 3")
  SetState(GetWidget(1), 1)   ; set second option as active one
  
  CheckBox(30+140,  95, 80, 20, "CheckBox")
  Option(30+140, 120, 80, 20, "Option 2")
  Option(30+140, 145, 80, 20, "Option 3")
  
  SetState(GetWidget(3), 1)  
  SetState(GetWidget(4), 1)  
  
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 2
    Bind(GetWidget(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP