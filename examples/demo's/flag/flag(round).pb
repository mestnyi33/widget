XIncludeFile "../../../widgets.pbi" 

EnableExplicit
UseWidgets( )

Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, w_type

Procedure _SetRound( *this._S_WIDGET, round.a )
  *this\round = DesktopScaledX(round)
  ;
  If *this\type = #__type_Progress
    *this\bar\button[1]\round = *this\round
    *this\bar\button[2]\round = *this\round
  EndIf
EndProcedure

Procedure events_widgets()
  Select WidgetEvent( )
    Case #__event_Change
      Select EventWidget( )
        Case w_type
          
        Case Button_2
          SetRound( Button_1, GetState(EventWidget( )) )
          
        Case Button_3
          SetState(Button_1, GetState(EventWidget( )))
          
        Case Button_4
          SetRound( Button_0, GetState(EventWidget( )) )
         
        Case Button_5
          SetState(Button_0, GetState(EventWidget( )))
          
      EndSelect
  EndSelect
EndProcedure

If OpenWindow(0, 0, 0, 450+20, 290+20, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  If Open(0)
    Button_0 = Progress(0, 0, 0, 0, 0,100,0, 120) ; as they will be sized automatically
    Button_1 = Progress(0, 0, 0, 0, 0,100,#PB_ProgressBar_Vertical,120) ; as they will be sized automatically
    
    w_type = ListView(10, 10, 150, 200) 
    Define i
    For i=0 To 33
      AddItem(w_type, -1, TypeString(i))
    Next
    
    Splitter_0 = Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    Splitter_1 = Splitter(10, 10, 400, 250, w_type, Splitter_0, #PB_Splitter_FirstFixed)
  EndIf
  
  Button_3 = Track    (400+20, 10, 20,  250, 0,100, #PB_TrackBar_Vertical) 
  Button_2 = Track    (400+20+20, 10, 20,  250, 0, 100, #PB_TrackBar_Vertical)
  
  Button_5 = Track    (10, 260,  400, 20, 0, 100)
  Button_4 = Track    (10, 280,  400, 20, 0, 100)
  
  Bind(Button_2, @events_widgets())
  Bind(Button_3, @events_widgets())
  
  Bind(Button_4, @events_widgets())
  Bind(Button_5, @events_widgets())
  
  SetState(Button_2, 120)
  SetState(Button_3, 100)
  
  SetState(Button_4, 120)
  SetState(Button_5, 100)
  
  SetState(Splitter_0, 189)
  WaitClose( )
EndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 46
; FirstLine = 32
; Folding = --
; EnableXP
; DPIAware