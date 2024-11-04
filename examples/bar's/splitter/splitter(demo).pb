XIncludeFile "../../../widgets.pbi"

UseWidgets( )

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
  ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +WidgetEvent( )+ "  state - " GetState(EventWidget( )) ; 
  Protected state 
  Select WidgetEvent( )
    Case #__event_Change
      state = GetState(EventWidget( ))
      SetGadgetState(IDWidget(EventWidget( )), state)
      Debug  Str(IDWidget(EventWidget( )))+" - widget change " + state +" "+ WidgetHeight( WidgetID(0) ) +" "+ WidgetHeight( WidgetID(1) )
  EndSelect
EndProcedure

If OpenWindow(0, 0, 0, 230+230, 200, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  #Button0  = 0
  #Button1  = 1
  #Splitter2 = 2
  #Splitter4 = 4
  
  Open(0, 230,0, 230,200)
  Button(0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
  Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  Splitter(5, 5, 220, 120, WidgetID(#Button0), WidgetID(#Button1));, #PB_Splitter_Separator)
  Bind(WidgetID(#Splitter2), @events_widgets())
  
  Text(5, 135, 220, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Border|#__flag_Textcenter|#__flag_Texttop )
  Splitter(5, 5, 220, 190, WidgetID(#Splitter2), WidgetID(3), #PB_Splitter_Separator)
  ;Bind(WidgetID(#Splitter4), @events_widgets())
  
  
  ButtonGadget(#Button0, 0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
  ButtonGadget(#Button1, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  SplitterGadget(#Splitter2, 5, 5, 220, 120, #Button0, #Button1, #PB_Splitter_Separator)
  BindGadgetEvent(#Splitter2, @events_gadgets())
  
  TextGadget(3, 5, 135, 220, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Border|#PB_Text_Center )
  SplitterGadget(#Splitter4, 5, 5, 220, 190, #Splitter2, 3, #PB_Splitter_Separator)
  ;BindGadgetEvent(#Splitter4, @events_gadgets())
  
  
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 2
; Folding = -
; Optimizer
; EnableXP
; DPIAware