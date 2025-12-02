CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Global.i gEvent, gQuit, g_Canvas
  Global *progress, *scroll, *track, *splitter, *spin, *bar
  
  Procedure events_widgets()
    Select EventType( )
      Case #PB_EventType_LeftClick
        Protected state = GetGadgetState(*bar)
        Debug "#PB_EventType_Change "+state
        SetGadgetState(*splitter, state)
        SetGadgetState(*spin, state)
        SetGadgetState(*progress, state)
        SetGadgetState(*track, state)
        SetGadgetState(*scroll, state)
    EndSelect
  EndProcedure
  
  Procedure Window_0()
    Protected h = 35 * 5
    Protected flag = 0;#__flag_Inverted
    Protected min = 0
    
    If OpenWindow(0, 0, 0, 400, 100 + h, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget (0, 5, 65 + h, 390, 30, "set standart scrollbar", #PB_Button_Toggle)
      
      FrameGadget( -1, 5, 0, 390, 50 + h, "demo bars")
      *track    = TrackBarGadget(#PB_Any, 15, 10, 350, 30, min, 50, flag)
      *splitter = SplitterGadget(#PB_Any, 15, 10 + 35 * 1, 350, 30, ButtonGadget( - 1, 0, 0, 0, 0, ""), ButtonGadget( - 1, 0, 0, 0, 0, ""), #PB_Splitter_Vertical | flag)
      *progress = ProgressBarGadget(#PB_Any, 15, 10 + 35 * 2 , 350, 30, min, 50, flag)
      *spin     = SpinGadget(#PB_Any, 15, 10 + 35 * 3, 350, 30, min, 50, flag|#PB_Spin_Numeric)
      *scroll   = ScrollBarGadget(#PB_Any, 15, 10 + 35 * 4, 350, 30, min, 50, 8, flag)
      
      
      SetGadgetState(*splitter, min+2)
      SetGadgetState(*spin, min+2)
      SetGadgetState(*progress, min+2)
      SetGadgetState(*track, min+2)
      SetGadgetState(*scroll, min+2)
      
      ;         SetGadgetState(0, GetAttribute(*scroll, #__flag_Inverted))
      ;         SetWindowTitle(0, Str(GetState(*scroll)))
      
      ;*bar = ScrollBarGadget(#PB_Any, 15, 20+35*5, 350, 20, min, 50, 8)
      *bar = TrackBarGadget(#PB_Any, 15, 20 + 35 * 5, 350, 20, min, 50)
      ;*bar = SplitterGadget(#PB_Any, 15, 20+35*5, 350, 20, ButtonGadget(-1,0,0,0,0,""),ButtonGadget(-1,0,0,0,0,""), #PB_Splitter_Vertical)
      SetGadgetState(*bar, min+2)
      
      BindGadgetEvent( *bar, @events_widgets( ));, #PB_EventType_Change )
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent = WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit = #True
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
            ;           Case 0
            ;             SetAttribute(*scroll, #__flag_Inverted, GetGadgetState(0))
            ;             SetWindowTitle(0, Str(GetState(*scroll)))
            ;
            ;             If GetGadgetState(0)
            ;               SetGadgetText(0, "set standart scrollbar")
            ;             Else
            ;               SetGadgetText(0, "set inverted scrollbar")
            ;             EndIf
            ;
            ;
            ;           Case g_Canvas
            ;             If widget()\change
            ;               SetWindowTitle(0, Str(GetState(widget())))
            ;             EndIf
            
        EndSelect
        
    EndSelect
    
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 30
; FirstLine = 12
; Folding = --
; EnableXP