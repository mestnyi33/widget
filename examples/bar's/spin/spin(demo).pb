XIncludeFile "../../../widgets.pbi" : Uselib(widget)

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
  ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(EventWidget( )) ; 
  
  Select WidgetEventType( )
    Case #PB_EventType_Up
      SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
      Debug  ""+GetIndex(EventWidget( ))+" - widget up " + GetState(EventWidget( ))
      
    Case #PB_EventType_Down
      SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
      Debug  ""+GetIndex(EventWidget( ))+" - widget down " + GetState(EventWidget( ))
       
    Case #PB_EventType_Change
      SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
      Debug  ""+GetIndex(EventWidget( ))+" - widget change " + GetState(EventWidget( ))
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 320+320, 200, "SpinGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 320,0,320,200)
  SpinGadget(0, 10,  40, 250, 18, 0, 10000)
  SetGadgetState(0, 5000)
  
  SpinGadget(1, 10, 120, 250, 25, 0, 30, #PB_Spin_Numeric)
  SetGadgetState(1, 2000)
  
; ; ;   SpinGadget(2, 270, 10, 20, 170, 0, 10000, #PB_Spin_ReadOnly)
; ; ;   SetGadgetState(2, 8000)
  
  TextGadget    (#PB_Any, 10,  20, 250, 20,"Spin Standard", #PB_Text_Center)
  TextGadget    (#PB_Any, 10, 100, 250, 20, "Spin Ticks", #PB_Text_Center)
;   TextGadget    (#PB_Any,  90, 180, 200, 20, "Spin Vertical", #PB_Text_Right)
  
  For i = 0 To 1
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Spin(10,  40, 250, 18, 0, 10000)
  SetState(GetWidget(0), 5000)
  
  Spin(10, 120, 250, 25, 5, 30, #__Spin_Numeric);|#__bar_Vertical)
  SetState(GetWidget(1), 2000)
  
; ; ;   Spin(270, 10, 20, 170, 0, 10000, #__Spin_Vertical)
; ; ;   SetState(GetWidget(2), 8000)
  
  Text(10,  20, 250, 20,"Spin Standard", #__Text_Center)
  Text(10, 100, 250, 20, "Spin Ticks", #__Text_Center)
;   Text(90, 180, 200, 20, "Spin Vertical", #__Text_Right)
  
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 1
    Bind(GetWidget(i), @events_widgets())
  Next
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = +
; EnableXP