CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Global.i gEvent, gQuit, g_Canvas
  Global *progress, *scroll, *track, *splitter, *spin, *bar
  
  Procedure events_widgets()
    Select EventType( )
      Case #PB_EventType_LeftClick
        Protected state = GetGadGetWidgetState(*bar)
        Debug "#PB_EventType_Change "+state
        SetGadGetWidgetState(*splitter, state)
        SetGadGetWidgetState(*spin, state)
        SetGadGetWidgetState(*progress, state)
        SetGadGetWidgetState(*track, state)
        SetGadGetWidgetState(*scroll, state)
    EndSelect
  EndProcedure
  
  Procedure Window_0()
    Protected h = 35 * 5
    Protected flag = 0;#__Bar_Inverted
    Protected min = 0
    
    If OpenWindow(0, 0, 0, 400, 100 + h, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget (0, 5, 65 + h, 390, 30, "set standart scrollbar", #PB_Button_Toggle)
      
      FrameGadget( -1, 5, 0, 390, 50 + h, "demo bars")
      *track    = TrackBarGadget(#PB_Any, 15, 10, 350, 30, min, 50, flag)
      *splitter = SplitterGadget(#PB_Any, 15, 10 + 35 * 1, 350, 30, ButtonGadget( - 1, 0, 0, 0, 0, ""), ButtonGadget( - 1, 0, 0, 0, 0, ""), #PB_Splitter_Vertical | flag)
      *progress = ProgressBarGadget(#PB_Any, 15, 10 + 35 * 2 , 350, 30, min, 50, flag)
      *spin     = SpinGadget(#PB_Any, 15, 10 + 35 * 3, 350, 30, min, 50, flag)
      *scroll   = ScrollBarGadget(#PB_Any, 15, 10 + 35 * 4, 350, 30, min, 50, 8, flag)
      
      
      SetGadGetWidgetState(*splitter, min+2)
      SetGadGetWidgetState(*spin, min+2)
      SetGadGetWidgetState(*progress, min+2)
      SetGadGetWidgetState(*track, min+2)
      SetGadGetWidgetState(*scroll, min+2)
      
      ;         SetGadGetWidgetState(0, GetWidgetAttribute(*scroll, #__Bar_Inverted))
      ;         SetWindowTitle(0, Str(GetWidgetState(*scroll)))
      
      ;*bar = ScrollBarGadget(#PB_Any, 15, 20+35*5, 350, 20, min, 50, 8)
      *bar = TrackBarGadget(#PB_Any, 15, 20 + 35 * 5, 350, 20, min, 50)
      ;*bar = SplitterGadget(#PB_Any, 15, 20+35*5, 350, 20, ButtonGadget(-1,0,0,0,0,""),ButtonGadget(-1,0,0,0,0,""), #PB_Splitter_Vertical)
      SetGadGetWidgetState(*bar, min+2)
      
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
            ;             SetWidgetAttribute(*scroll, #__Bar_Inverted, GetGadGetWidgetState(0))
            ;             SetWindowTitle(0, Str(GetWidgetState(*scroll)))
            ;
            ;             If GetGadGetWidgetState(0)
            ;               SetGadGetWidgetText(0, "set standart scrollbar")
            ;             Else
            ;               SetGadGetWidgetText(0, "set inverted scrollbar")
            ;             EndIf
            ;
            ;
            ;           Case g_Canvas
            ;             If widget()\change
            ;               SetWindowTitle(0, Str(GetWidgetState(widget())))
            ;             EndIf
            
        EndSelect
        
    EndSelect
    
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 74
; FirstLine = 57
; Folding = --
; EnableXP