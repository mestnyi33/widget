CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Global.i gEvent, gQuit, g_Canvas
  Global *progress, *scroll, *track, *splitter, *spin, *bar
  
  Procedure events_widgets()
    Select EventType( )
      Case #PB_EventType_LeftClick
        Debug  "#PB_EventType_Change"
        Protected state = GetGadgetState(*bar)
        SetGadgetState(*splitter, state)
        SetGadgetState(*spin, state)
        SetGadgetState(*progress, state)
        SetGadgetState(*track, state)
        SetGadgetState(*scroll, state)
    EndSelect
  EndProcedure
  
  Procedure Window_0()
    Protected h = 35*5
    Protected flag = 0;#__Bar_Inverted
    If OpenWindow(0, 0, 0, 400, 100+h, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65+h, 390,  30, "set standart scrollbar", #PB_Button_Toggle)
      
      *splitter = SplitterGadget(#PB_Any,5, 10, 370, 30, ButtonGadget(-1,0,0,0,0,""),ButtonGadget(-1,0,0,0,0,""), #PB_Splitter_Vertical|flag)
      *track = TrackBarGadget(#PB_Any,5, 10+35*1, 370, 30, 20, 50, flag)
      *progress = ProgressBarGadget(#PB_Any,5, 10+35*2     , 370, 30, 20, 50, flag)
      *spin = SpinGadget(#PB_Any,5, 10+35*3, 370, 30, 20, 50, flag)
      *scroll = ScrollBarGadget(#PB_Any,5, 10+35*4, 370, 30, 20, 50, 8, flag)
      
      
      SetGadgetState(*splitter, 22)
      SetGadgetState(*spin, 22)
      SetGadgetState(*progress, 22)
      SetGadgetState(*track, 22)
      SetGadgetState(*scroll, 22)
      
      ;         SetGadgetState(0, GetAttribute(*scroll, #__Bar_Inverted))
      ;         SetWindowTitle(0, Str(GetState(*scroll)))
      
      ;*bar = ScrollBarGadget(#PB_Any, 5, 10+35*5, 370, 30, 20, 50, 8)
      ;*bar = TrackBarGadget(#PB_Any, 5, 10+35*5, 370, 30, 20, 50)
      *bar = SplitterGadget(#PB_Any, 5, 10+35*5, 370, 30, ButtonGadget(-1,0,0,0,0,""),ButtonGadget(-1,0,0,0,0,""), #PB_Splitter_Vertical)
      SetGadgetState(*bar, 20)
      BindGadgetEvent( *bar, @events_widgets( ));, #PB_EventType_Change )
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
            ;           Case 0
            ;             SetAttribute(*scroll, #__Bar_Inverted, GetGadgetState(0))
            ;             SetWindowTitle(0, Str(GetState(*scroll)))
            ;             
            ;             If GetGadgetState(0)
            ;               SetGadgetText(0, "set standart scrollbar")
            ;             Else
            ;               SetGadgetText(0, "set inverted scrollbar")
            ;             EndIf
            ;             
            ;             ReDraw(root())
            ;             
            ;           Case g_Canvas
            ;             If widget()\change
            ;               SetWindowTitle(0, Str(GetState(widget())))
            ;             EndIf
            
        EndSelect
        
    EndSelect
    
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP