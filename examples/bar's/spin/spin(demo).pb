XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure events_gadgets()
  ;ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - gadget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_Change
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
     
    Case #PB_EventType_Up
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget up " + GetGadgetState(EventGadget())
     
   Case #PB_EventType_Down
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget down " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ;ClearDebugOutput()
  ; Debug ""+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(*event\widget) ; 
  
  Select *event\event
    Case #PB_EventType_Up
      SetGadgetState(GetIndex(*event\widget), GetState(*event\widget))
      Debug  ""+GetIndex(*event\widget)+" - widget up " + GetState(*event\widget)
      
    Case #PB_EventType_Down
      SetGadgetState(GetIndex(*event\widget), GetState(*event\widget))
      Debug  ""+GetIndex(*event\widget)+" - widget down " + GetState(*event\widget)
       
    Case #PB_EventType_Change
      SetGadgetState(GetIndex(*event\widget), GetState(*event\widget))
      Debug  ""+GetIndex(*event\widget)+" - widget change " + GetState(*event\widget)
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 320+320, 200, "SpinGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 320,0,320,200)
  SpinGadget(0, 10,  40, 250, 20, 0, 10000)
  SetGadgetState(0, 5000)
  
  SpinGadget(1, 10, 120, 250, 20, 0, 30, #PB_Spin_Numeric)
  SetGadgetState(1, 3000)
  
; ; ;   SpinGadget(2, 270, 10, 20, 170, 0, 10000, #PB_Spin_ReadOnly)
; ; ;   SetGadgetState(2, 8000)
  
  TextGadget    (#PB_Any, 10,  20, 250, 20,"Spin Standard", #PB_Text_Center)
  TextGadget    (#PB_Any, 10, 100, 250, 20, "Spin Ticks", #PB_Text_Center)
;   TextGadget    (#PB_Any,  90, 180, 200, 20, "Spin Vertical", #PB_Text_Right)
  
  For i = 0 To 1
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Spin(10,  40, 250, 20, 0, 10000)
  SetState(GetWidget(0), 5000)
  
  Spin(10, 120, 250, 20, 0, 30, #__Spin_Numeric)
  SetState(GetWidget(1), 3000)
  
; ; ;   Spin(270, 10, 20, 170, 0, 10000, #__Spin_Vertical)
; ; ;   SetState(GetWidget(2), 8000)
  
  Text(10,  20, 250, 20,"Spin Standard", #__Text_Center)
  Text(10, 100, 250, 20, "Spin Ticks", #__Text_Center)
;   Text(90, 180, 200, 20, "Spin Vertical", #__Text_Right)
  
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 1
    Bind(GetWidget(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = +
; EnableXP