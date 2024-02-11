﻿XIncludeFile "../../../widgets.pbi"

Uselib(widget)

Procedure events_gadgets()
  ;ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ;ClearDebugOutput()
  ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +this()\event+ "  state - " GetState(EventWidget( )) ; 
  
  Select WidgetEventType( )
    Case #__event_Change
      SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
      Debug  Str(GetIndex(EventWidget( )))+" - widget change " + GetState(EventWidget( )) +" "+ Height( GetWidget(0) ) +" "+ Height( GetWidget(1) )
  EndSelect
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 230+230, 200, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 230,0, 230,200)
    #Button1  = 0
    #Button2  = 1
    #Splitter = 2

    ButtonGadget(#Button1, 0, 0, 0, 0, "Button 1") ; No need to specify size or coordinates
    ButtonGadget(#Button2, 0, 0, 0, 0, "Button 2") ; as they will be sized automatically
    SplitterGadget(#Splitter, 5, 5, 220, 120, #Button1, #Button2, #PB_Splitter_Separator)
    BindGadgetEvent(#Splitter, @events_gadgets())
    
    TextGadget(3, 5, 135, 220, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Border|#PB_Text_Center )

    Button(0, 0, 0, 0, "Button 1") ; No need to specify size or coordinates
    Button(0, 0, 0, 0, "Button 2") ; as they will be sized automatically
    Splitter(5, 5, 220, 120, GetWidget(#Button1), GetWidget(#Button2));, #PB_Splitter_Separator)
    Bind(GetWidget(#Splitter), @events_widgets())
    
    Text(5, 135, 220, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Border|#__Text_Center|#__text_top )
    
    WaitClose( )
    
;     Define event
;     Repeat
;       event = WaitWindowEvent()
;       If event = #PB_Event_Gadget
;         ;If GadgetType(EventGadget()) = #PB_GadgetType_Canvas
;           eventhandler( )
;         ;EndIf
;       EndIf
;     Until event = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 5
; FirstLine = 1
; Folding = -
; EnableXP