XIncludeFile "../../../widgets.pbi"

UseWidgets( )

Procedure events_gadgets()
  ;ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadGetWidgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
      SetWidgetState( WidgetID(EventGadget()), GetGadGetWidgetState(EventGadget()))
      Debug  ""+ EventGadget() +" - gadget change " + GetGadGetWidgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ;ClearDebugOutput()
  ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +WidgetEvent( )+ "  state - " GetWidgetState(EventWidget( )) ; 
  Protected state 
  Select WidgetEvent( )
    Case #__event_Change
      state = GetWidgetState(EventWidget( ))
      SetGadGetWidgetState(GetIndex(EventWidget( )), state)
      Debug  Str(GetIndex(EventWidget( )))+" - widget change " + state +" "+ WidgetHeight( WidgetID(0) ) +" "+ WidgetHeight( WidgetID(1) )
  EndSelect
EndProcedure

If OpenWindow(0, 0, 0, 230+230, 200, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  #Button0  = 0
  #Button1  = 1
  #Splitter2 = 2
  #Splitter4 = 4
  
  OpenRoot(0, 230,0, 230,200)
  ButtonWidget(0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
  ButtonWidget(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  SplitterWidget(5, 5, 220, 120, WidgetID(#Button0), WidgetID(#Button1));, #PB_Splitter_Separator)
  BindWidgetEvent( WidgetID(#Splitter2), @events_widgets())
  
  TextWidget(5, 135, 220, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Border|#__flag_Textcenter|#__flag_Texttop )
  SplitterWidget(5, 5, 220, 190, WidgetID(#Splitter2), WidgetID(3), #PB_Splitter_Separator)
  ;BindWidgetEvent( WidgetID(#Splitter4), @events_widgets())
  
  
  ButtonGadget(#Button0, 0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
  ButtonGadget(#Button1, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  SplitterGadget(#Splitter2, 5, 5, 220, 120, #Button0, #Button1, #PB_Splitter_Separator)
  BindGadgetEvent(#Splitter2, @events_gadgets())
  
  TextGadget(3, 5, 135, 220, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Border|#PB_Text_Center )
  SplitterGadget(#Splitter4, 5, 5, 220, 190, #Splitter2, 3, #PB_Splitter_Separator)
  ;BindGadgetEvent(#Splitter4, @events_gadgets())
  
  
  WaitCloseRoot( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 42
; FirstLine = 12
; Folding = -
; Optimizer
; EnableXP
; DPIAware