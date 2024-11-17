XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Global i, w_0,w_1,w_2, event = 1
   
   
   Procedure events_gadgets()
      Select EventType()
         Case #PB_EventType_LeftClick, #PB_EventType_Change
            Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
            
            Select EventGadget()
               Case 0 : SetState(w_0, GetGadgetState(EventGadget()))
               Case 1 : SetState(w_1, GetGadgetState(EventGadget()))
               Case 2 : SetState(w_2, GetGadgetState(EventGadget()))
            EndSelect
            
            ; 
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
               ReDraw( Root( ) )
            CompilerEndIf
      EndSelect
   EndProcedure
   
   Procedure events_widgets()
      Select WidgetEvent( )
         Case #__event_LeftClick, #__event_Change
            Debug  ""+GetIndex(EventWidget( ))+" - widget change " + GetState(EventWidget( ))
            
            Select EventWidget( )
               Case w_0 : SetGadgetState(0, GetState(EventWidget( )))
               Case w_1 : SetGadgetState(1, GetState(EventWidget( )))
               Case w_2 : SetGadgetState(2, GetState(EventWidget( )))
            EndSelect
      EndSelect
   EndProcedure
   
   ; Shows possible flags of ButtonGadget in action...
   If Open(0, 0, 0, 350+350, 220, "TrackBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      TrackBarGadget(0, 10,  40, 250, 20, 0, 30)
      SplitterGadget(100, 10,  40, 250, 20, 0,  TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border), #PB_Splitter_Vertical ) : SetGadgetState(100, 250)
      SetGadgetState(0, 25)
      
      TrackBarGadget(1, 10, 120, 250, 20, -10, 10, #PB_TrackBar_Ticks)
      SplitterGadget(101, 10,  120, 250, 20, 1,  TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border), #PB_Splitter_Vertical ) : SetGadgetState(101, 250)
      ;SetGadgetState(1, 30)
      
      TrackBarGadget(2, 280, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
      SplitterGadget(102, 280, 10, 20, 170, 2,  TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border) ) : SetGadgetState(102, 250)
      SetGadgetState(2, 8000)
      
      TrackBarGadget(22, 320, 10, 20, 170, 0, 10, #PB_TrackBar_Vertical|#PB_TrackBar_Ticks)
      SplitterGadget(122, 320, 10, 20, 170, 22,  TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border) ) : SetGadgetState(122, 250)
      
      TextGadget    (#PB_Any, 10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
      TextGadget    (#PB_Any, 10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
      TextGadget    (#PB_Any,  90, 190, 200, 20, "TrackBar Vertical", #PB_Text_Right)
      
      If event
         BindGadgetEvent(0, @events_gadgets())
         BindGadgetEvent(1, @events_gadgets())
         BindGadgetEvent(2, @events_gadgets())
      EndIf
      
      ;\\
      Define x = 350
      w_0 = Track(10+x,  40, 250, 20, 0, 30)
      SetState(Splitter(10+x,  40, 250, 20, w_0,  #PB_Default, #PB_Splitter_Vertical ), 250)
      SetState(w_0, 25)
      
      w_1 = Track(10+x, 120, 250, 20, -10, 10, #PB_TrackBar_Ticks)
      SetState(Splitter(10+x,  120, 250, 20, w_1,  #PB_Default, #PB_Splitter_Vertical ), 250)
      ;SetState(w_1, 30)
      
      w_2 = Track(280+x, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
      SetState(Splitter(280+x, 10, 20, 170, w_2,  #PB_Default ), 170)
      SetState(w_2, 8000)
      
      w_2 = Track(320+x, 10, 20, 170, 0, 10, #PB_TrackBar_Vertical|#PB_TrackBar_Ticks)
      SetState(Splitter(320+x, 10, 20, 170, w_2,  #PB_Default ), 170)
      
      Text(10+x,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
      Text(10+x, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
      Text(90+x, 190, 200, 20, "TrackBar Vertical", #PB_Text_Right)
      
      If event
         Bind(w_0, @events_widgets())
         Bind(w_1, @events_widgets())
         Bind(w_2, @events_widgets())
      EndIf
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 21
; FirstLine = 18
; Folding = --
; EnableXP
; DPIAware