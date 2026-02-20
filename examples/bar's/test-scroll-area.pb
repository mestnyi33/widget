XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile = 99
   UseWidgets( )
   Define i, 
   ;
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Widget = Tree(0, 0, 0, 0)
      For i=0 To 20
         AddItem(Widget, -1, "test item test item test item "+Str(i))
      Next
      ;
      Splitter(0, 0, 180, 120, Widget, -1, #PB_Splitter_Vertical)
      WaitClose( )
   EndIf
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile ;= 99
   UseWidgets( )
   
   Global Widget, v_bar, h_bar
   Global w = 420-40
   Global h = 280-40
   
   Procedure track_v_events( )
      Resize(Widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(EventWidget()))
   EndProcedure
   Procedure track_h_events( )
      Resize(Widget, #PB_Ignore, #PB_Ignore, GetState(EventWidget()), #PB_Ignore)
   EndProcedure
   
   Procedure track_vh_events( )
      If GetState( EventWidget( ) )
         SetState(h_bar, 120)
         SetState(v_bar, 120)
      Else
         SetState(h_bar, w-10)
         SetState(v_bar, h-10)
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Widget()\bs = 0
      Widget()\fs = 0
      Container(0,0, w,h, #PB_Container_Double)
      SetBackColor(Widget(), $FFB3FDFF)
      Widget()\bs = 20
      Widget()\fs = 20
      Resize(Widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
     
      test_resize = 1
     ; test_resize_area = 1
      Widget = Tree(0, 0, 0, 0, #__flag_Borderless)
      Define i
      AddItem(Widget, -1, Str(i)+"test item ")
      For i=1 To 20
         If i%2
            AddItem(Widget, -1, Str(i)+"test item test item test item ", -1, 1)
         Else
            AddItem(Widget, -1, Str(i)+"test item test item test item ")
         EndIf
      Next
      
      Widget()\bs = 0
      Widget()\fs = 0
      
      Widget()\scroll\v\round = 0
      Widget()\scroll\v\bar\button\round = 0
      Widget()\scroll\v\bar\button[1]\round = 0
      Widget()\scroll\v\bar\button[2]\round = 0
      
      Widget()\scroll\h\round = 0
      Widget()\scroll\h\bar\button\round = 0
      Widget()\scroll\h\bar\button[1]\round = 0
      Widget()\scroll\h\bar\button[2]\round = 0
      CloseList()
      
;        Resize(widget(), 0, #PB_Ignore, 0, 120) 
;       widget() = widget
;       Debug widget()\scroll\v\x
   
      ; v
      ;v_bar=Splitter( w+10,10,20,h, -1, -1, #__bar_invert)
       v_bar=Track( w+10,10,20,h, 0, h-10, #PB_TrackBar_Vertical|#__bar_invert)
      SetBackColor(Widget(), $FF80BE8E)
      SetState(Widget(), 120)
      Bind( Widget(), @track_v_events( ), #__event_change )
      ; h
      ;h_bar=Splitter( 10,h+10,w,20, -1, -1 , #PB_Splitter_Vertical)
       h_bar=Track( 10,h+10,w,20, 0, w-10 )
      SetBackColor(Widget(), $FF80BE8E)
      SetState(Widget(), 213)
      Bind( widget(), @track_h_events( ), #__event_change )
      
      
      Button(w+10,h+10,20,20,"", #PB_Button_Toggle)
      SetRound( Widget(), 10 )
      Bind( Widget(), @track_vh_events( ), #__event_Down )
;       
      ClearDebugOutput()
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 92
; FirstLine = 75
; Folding = --
; EnableXP
; DPIAware