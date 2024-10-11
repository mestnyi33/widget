XIncludeFile "../../../widgets.pbi"

Uselib(widget)

Procedure events_gadgets()
  ;ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
     SetState(WidgetID(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ;ClearDebugOutput()
  ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +this()\event+ "  state - " GetState(EventWidget( )) ; 
  
  Select WidgetEventType( )
    Case #__event_Change
      SetGadgetState(IDWidget(EventWidget( )), GetState(EventWidget( )))
      Debug  Str(IDWidget(EventWidget( )))+" - widget change " + GetState(EventWidget( )) +" "+ Height( WidgetID(0) ) +" "+ Height( WidgetID(1) )
  EndSelect
EndProcedure

If OpenWindow(0, 0, 0, 230+230, 200, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(0, 230,0, 230,200)
    
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
    Splitter(5, 5, 220, 120, WidgetID(#Button1), WidgetID(#Button2));, #PB_Splitter_Separator)
    Bind(WidgetID(#Splitter), @events_widgets())
    
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
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 22
; FirstLine = 19
; Folding = -
; EnableXP
; DPIAware