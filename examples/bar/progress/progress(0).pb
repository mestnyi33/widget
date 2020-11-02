XIncludeFile "../../../widgets.pbi" : Uselib(widget)

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
If Open(OpenWindow(#PB_Any, 0, 0, 320+320, 160, "Progress", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  ProgressBarGadget(0,  10, 30, 250,  30, 0, 100)
  SetGadgetState   (0, 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  ProgressBarGadget(1,  10, 90, 250,  30, 0, 200, #PB_ProgressBar_Smooth)
  SetGadgetState   (1, 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  ProgressBarGadget(2, 270, 10,  30, 120, 0, 300, #PB_ProgressBar_Vertical)
  SetGadgetState   (2, 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
  TextGadget       (3,  10, 10, 250,  20, "ProgressBar Standard  (50/100)", #PB_Text_Center)
  TextGadget       (4,  10, 70, 250,  20, "ProgressBar Smooth  (50/200)", #PB_Text_Center)
  TextGadget       (5, 100,135, 200,  20, "ProgressBar Vertical  (100/300)", #PB_Text_Right)
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Progress(10+320, 30, 250,  30, 0, 100, 0, 40)
  SetState(widget( ), 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  Progress(10+320, 90, 250,  30, 0, 200, #PB_ProgressBar_Smooth, 17)
  SetState(widget( ), 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  Progress(270+320, 10,  30, 120, 0, 300, #PB_ProgressBar_Vertical)
  SetState(widget( ), 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
  Track    (10+320, 60, 250,  20, 0,100)
  Track    (10+320, 120, 250,  20, 0, 200)
  Track    (300+320,10, 20,  120, 0, 300, #PB_TrackBar_Vertical)
  
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 2
    Bind(GetWidget(i), @events_widgets())
  Next
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP