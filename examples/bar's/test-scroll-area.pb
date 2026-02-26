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
    test_resize = 1
   ; test_resize_area = 1
   ;test_iclip = 1
   ;test_focus_draw = 3
   test_draw_area = 1
   no_resize_mdi_child = 1
    
   Global *g._S_WIDGET, v_bar, h_bar
   Global w = 420-40
   Global h = 280-40
   
   Procedure track_v_events( )
      Resize(*g, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(EventWidget()))
   EndProcedure
   Procedure track_h_events( )
      Resize(*g, #PB_Ignore, #PB_Ignore, GetState(EventWidget()), #PB_Ignore)
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
   
   
   Procedure Test(Type, Flag.q)
      Define i
      Protected._s_WIDGET *g
      
      If Type = #__type_Tree
         *g = Tree(0, 0, 0, 0, Flag)
         AddItem(*g, -1, Str(i)+"test item ")
         For i=1 To 7
            If i%2
               AddItem(*g, -1, Str(i)+"test item test item test item ", -1, 1)
            Else
               AddItem(*g, -1, Str(i)+"test item test item test item ")
            EndIf
         Next
         *g\bs = 0
         *g\fs = 0
      EndIf
      
      If Type = #__type_ScrollArea
         *g = ScrollArea(0, 0, 0, 0, 200,200,1, Flag)
         SetBackColor(*g, $D477DCE8)
         Button(160,50,80,30,"button")
         CloseList( )
      EndIf
      
      If Type = #__type_MDI
         ;*g = MDI(0,0,180,130, Flag)
         *g = MDI(0,0,0,0, Flag)
         SetBackColor(*g, $D477DCE8)
         Define *g1=AddItem(*g, -1, Str(i)+"test item ", -1, #PB_Window_BorderLess)
         Button(0,0,0,0,"button", #__flag_AutoSize)
         Resize(*g1, 160,50,80,30)
         Debug "---"
         Resize(*g, 0,0,180,130)
         Debug "---"
         CloseList( )
         CloseList( )
      EndIf
      
          
      *g\scroll\v\round = 0
      *g\scroll\v\bar\button\round = 0
      *g\scroll\v\bar\button[1]\round = 0
      *g\scroll\v\bar\button[2]\round = 0
      
      *g\scroll\h\round = 0
      *g\scroll\h\bar\button\round = 0
      *g\scroll\h\bar\button[1]\round = 0
      *g\scroll\h\bar\button[2]\round = 0
      
      ProcedureReturn *g
   EndProcedure
   
   
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Widget()\bs = 0
      Widget()\fs = 0
      Container(0,0, w,h, #PB_Container_Double)
      SetBackColor(Widget(), $FFB3FDFF)
      Widget()\bs = 20
      Widget()\fs = 20
      Resize(Widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
      
      ClearDebugOutput()
      ;*g = Test( #__type_Tree, #__flag_Borderless )
      ;*g = Test( #__type_ScrollArea, #__flag_Borderless )
      *g = Test( #__type_MDI, #__flag_Borderless )
      
      
      CloseList()
      
;        Resize(*g, 0, #PB_Ignore, 0, 120) 
;       *g = widget
;       Debug *g\scroll\v\x
   
      ; v
      ;v_bar=Splitter( w+10,10,20,h, -1, -1, #__bar_invert)
       v_bar=Track( w+10,10,20,h, 0, h-10, #PB_TrackBar_Vertical|#__bar_invert)
      SetBackColor(v_bar, $FF80BE8E)
      SetState(v_bar, 120)
      Bind( v_bar, @track_v_events( ), #__event_change )
      ; h
      ;h_bar=Splitter( 10,h+10,w,20, -1, -1 , #PB_Splitter_Vertical)
       h_bar=Track( 10,h+10,w,20, 0, w-10 )
      SetBackColor(h_bar, $FF80BE8E)
      SetState(h_bar, 213)
      Bind( h_bar, @track_h_events( ), #__event_change )
      
      
      Button(w+10,h+10,20,20,"", #PB_Button_Toggle)
      SetRound( Widget(), 10 )
      Bind( Widget(), @track_vh_events( ), #__event_Down )
;       
     ClearDebugOutput()
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 125
; FirstLine = 102
; Folding = ---
; EnableXP
; DPIAware