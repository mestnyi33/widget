XIncludeFile "../../../widgets.pbi" : Uselib(widget)

Procedure events_gadgets()
  ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
     ;SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ClearDebugOutput()
  ; Debug ""+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(*event\widget) ; 
  
  Select WidgetEventType( )
    Case #PB_EventType_Change
      ;SetGadgetState(GetIndex(*event\widget), GetState(*event\widget))
      Debug  ""+GetIndex(*event\widget)+" - widget change " + GetState(*event\widget)
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 320+320, 200, "TrackBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  ;;TrackBarGadget(0, 10,  40, 250, 20, 0, 10000)
  ;;SetGadgetState(0, 5000)
  TrackBarGadget(0, 10,  40, 250, 20, -10000, 10000)
  
  TrackBarGadget(1, 10, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
  SetGadgetState(1, 3000)
  
  TrackBarGadget(2, 270, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
  SetGadgetState(2, 8000)
  
  TextGadget    (#PB_Any, 10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
  TextGadget    (#PB_Any, 10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
  TextGadget    (#PB_Any,  90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  ;;Track(10+320,  40, 250, 20, 0, 10000)
  ;;SetState(GetWidget(0), 5000)
  Track(10+320,  40, 250, 20, -10000, 10000)
  
  Track(10+320, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
  SetState(GetWidget(1), 3000)
  
  Track(270+320, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
  SetState(GetWidget(2), 8000)
  
  Text(10+320,  20, 250, 20,"TrackBar Standard", #__Text_Center)
  Text(10+320, 100, 250, 20, "TrackBar Ticks", #__Text_Center)
  Text(90+320, 180, 200, 20, "TrackBar Vertical", #__Text_Right)
  
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 2
    Bind(GetWidget(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = q
; EnableXP