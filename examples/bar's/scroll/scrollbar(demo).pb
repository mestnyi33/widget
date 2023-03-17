﻿XIncludeFile "../../../widgets.pbi" 
Uselib(widget)

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
  ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +this()\type+ "  state - " GetState(EventWidget( )) ; 
  
  Select WidgetEventType( )
    Case #PB_EventType_Change
      SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
      Debug  Str(GetIndex(EventWidget( )))+" - widget change " + GetState(EventWidget( ))
  EndSelect
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 305+305, 140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 305,0, 305,140)
  ScrollBarGadget  (0,  10, 42, 250,  20, 30, 100, 30)
  SetGadgetState   (0,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
  
  ScrollBarGadget  (1, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
  SetGadgetState   (1, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
  
  TextGadget       (#PB_Any,  10, 10, 250,  30, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
  TextGadget       (#PB_Any,  10,105, 250,  30, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
  
  Define i
  For i = 0 To 1
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Scroll(10, 42, 250,  20, 30, 100, 30)
  SetState   (GetWidget(0),  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
  
  Scroll(270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
  SetState   (GetWidget(1), 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
  
  Text(10, 10, 250,  30, "ScrollBar Standard  (start=50, page=30/100)",#__Text_Center)
  Text(10,105, 250,  30, "ScrollBar Vertical  (start=100, page=50/300)",#__Text_Right)
  
  For i = 0 To 1
    Bind(GetWidget(i), @events_widgets())
  Next
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP