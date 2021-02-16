XIncludeFile "../../../widgets-bar.pbi" : Uselib(widget)

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  Global i, w_0,w_1,w_2
    
  
  Procedure events_gadgets()
    ;;ClearDebugOutput()
    ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
    
    Select EventType()
      Case #PB_EventType_LeftClick, #PB_EventType_Change
        Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
        
        Select EventGadget()
         Case 0 : SetState(w_0, GetGadgetState(EventGadget()))
         Case 1 : SetState(w_1, GetGadgetState(EventGadget()))
         Case 2 : SetState(w_2, GetGadgetState(EventGadget()))
        EndSelect
    EndSelect
  EndProcedure
  
  Procedure events_widgets()
    ;;;ClearDebugOutput()
    ; Debug ""+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(*event\widget) ; 
    
    Select WidgetEventType( )
      Case #PB_EventType_LeftClick, #PB_EventType_Change
        Debug  ""+GetIndex(*event\widget)+" - widget change " + GetState(*event\widget)
        
        Select *event\widget
         Case w_0 : SetGadgetState(0, GetState(*event\widget))
         Case w_1 : SetGadgetState(1, GetState(*event\widget))
         Case w_2 : SetGadgetState(2, GetState(*event\widget))
        EndSelect
    EndSelect
  EndProcedure
  
  ; Shows possible flags of ButtonGadget in action...
  If Open(OpenWindow(#PB_Any, 0, 0, 320+320, 200, "TrackBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    TrackBarGadget(0, 10,  40, 250, 20, 0, 30)
    SplitterGadget(100, 10,  40, 250, 20, 0,  TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border), #PB_Splitter_Vertical ) : SetGadgetState(100, 250)
    SetGadgetState(0, 25)
    
    TrackBarGadget(1, 10, 120, 250, 20, -10, 10, #PB_TrackBar_Ticks)
    SplitterGadget(101, 10,  120, 250, 20, 1,  TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border), #PB_Splitter_Vertical ) : SetGadgetState(101, 250)
    ;SetGadgetState(1, 30)
    
    TrackBarGadget(2, 270, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
    SplitterGadget(102, 270, 10, 20, 170, 2,  TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border) ) : SetGadgetState(102, 250)
    SetGadgetState(2, 8000)
    
    TextGadget    (#PB_Any, 10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
    TextGadget    (#PB_Any, 10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    TextGadget    (#PB_Any,  90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    
    For i = 0 To 2
      BindGadgetEvent(i, @events_gadgets())
    Next
    
    w_0 = Track(10+320,  40, 250, 20, 0, 30)
    Splitter(10 + 320,  40, 250, 20, widget( ),  #Null, #PB_Splitter_Vertical ) : SetState(widget( ), 250)
    SetState(w_0, 25)
    
    w_1 = Track(10+320, 120, 250, 20, -10, 10, #PB_TrackBar_Ticks)
    Splitter(10 + 320,  120, 250, 20, widget( ),  #Null, #PB_Splitter_Vertical ) : SetState(widget( ), 250)
    ;SetState(w_1, 30)
    
    w_2 = Track(270+320, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
    Splitter(270+320, 10, 20, 170, widget( ),  #Null ) : SetState(widget( ), 170)
    SetState(w_2, 8000)
    
    Text(10+320,  20, 250, 20,"TrackBar Standard", #__Text_Center)
    Text(10+320, 100, 250, 20, "TrackBar Ticks", #__Text_Center)
    Text(90+320, 180, 200, 20, "TrackBar Vertical", #__Text_Right)
    
    ;Bind(#PB_All, @events_widgets())
    
    ;For i = 0 To 2
        Bind(w_0, @events_widgets())
        Bind(w_1, @events_widgets())
        Bind(w_2, @events_widgets())
    ;Next
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP