XIncludeFile "../../../widgets.pbi" : Uselib(widget)

EnableExplicit
Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1

Procedure events_widgets()
  Select this()\event
    Case #PB_EventType_Change
      Select this()\widget
        Case Button_2
          this()\widget = Button_1
          this()\widget\round = GetState(Button_2)
          this()\widget\bar\button[#__b_1]\round = this()\widget\round
          this()\widget\bar\button[#__b_2]\round = this()\widget\round
            
        Case Button_3
          SetState(Button_1, GetState(Button_3))
          
        Case Button_4
          this()\widget = Button_0
          this()\widget\round = GetState(Button_4)
          this()\widget\bar\button[#__b_1]\round = this()\widget\round
          this()\widget\bar\button[#__b_2]\round = this()\widget\round
          
        Case Button_5
          SetState(Button_0, GetState(Button_5))
          
      EndSelect
  EndSelect
EndProcedure

If OpenWindow(0, 0, 0, 450+20, 290+20, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  If Open(0);, 425, 40)
    Button_0 = Progress(0, 0, 0, 0, 0,100,0, 120) ; as they will be sized automatically
    Button_1 = Progress(0, 0, 0, 0, 0,100,#PB_ProgressBar_Vertical,120) ; as they will be sized automatically
    
    Splitter_0 = Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    Splitter_1 = Splitter(10, 10, 400, 250, 0, Splitter_0, #PB_Splitter_FirstFixed)
  EndIf
  
  Button_3 = Track    (400+20, 10, 20,  250, 0,100, #PB_TrackBar_Vertical) 
  Button_2 = Track    (400+20+20, 10, 20,  250, 0, 100, #PB_TrackBar_Vertical)
  
  Button_5 = Track    (10, 260,  400, 20, 0, 100)
  Button_4 = Track    (10, 280,  400, 20, 0, 100)
  
  Bind(Button_2, @events_widgets())
  Bind(Button_3, @events_widgets())
  
  Bind(Button_4, @events_widgets())
  Bind(Button_5, @events_widgets())
  
  SetState(Button_3, 40)
  SetState(Button_5, 40)
  
  SetState(Button_2, 120)
  SetState(Button_4, 120)
  
  SetState(Splitter_0, 269)
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP