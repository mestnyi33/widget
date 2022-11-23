IncludePath "../../"
XIncludeFile "widget-events.pbi"
;XIncludeFile "widgets.pbi"
;XIncludeFile "widgets-bar.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  UseModule constants
  
  Global.i gEvent, gQuit, g_Canvas
  Global *progress, *scroll, *track, *splitter, *spin, *bar
  
  Procedure events_widgets()
    Select WidgetEventType( )
      Case #PB_EventType_Change
        Debug  "#PB_EventType_Change"
        Protected state = GetState(*bar)
        SetState(*splitter, state)
        SetState(*spin, state)
        SetState(*progress, state)
        SetState(*track, state)
        SetState(*scroll, state)
        ;;SetWindowTitle(EventWindow(), Str(state))
    EndSelect
  EndProcedure
  
  Procedure Window_0()
    Protected h = 35*5
    Protected flag = 0;#__Bar_Invert
    If OpenWindow(0, 0, 0, 400, 100+h, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65+h, 390,  30, "set standart scrollbar", #PB_Button_Toggle)
      
      If Open(0,10,10, 380, 50+h)
        g_Canvas = GetGadget(root())
        *splitter = Splitter(5, 10, 370, 30, -1,-1, #__Bar_Vertical|flag)
        *track = Track(5, 10+35*1, 370, 30, 20, 50, flag)
        *progress = Progress(5, 10+35*2     , 370, 30, 20, 50, flag)
        *spin = Spin(5, 10+35*3, 370, 30, 20, 50, 8, flag)
        *scroll = Scroll(5, 10+35*4, 370, 30, 20, 50, 8, flag)
        
        
        SetState(*splitter, 22)
        SetState(*spin, 22)
        SetState(*progress, 22)
        SetState(*track, 22)
        SetState(*scroll, 22)
        
        SetGadgetState(0, GetAttribute(*scroll, #__Bar_Invert))
        SetWindowTitle(0, Str(GetState(*scroll)))
        
        ;*bar = Scroll(5, 10+35*5, 370, 30, 20, 50, 8)
        *bar = Track(5, 10+35*5, 370, 30, 20, 50)
        ;*bar = Splitter(5, 10+35*5, 370, 30, -1,-1, #__Bar_Vertical)
        SetState(*bar, 22)
        Bind( *bar, @events_widgets( ), #PB_EventType_Change )
      EndIf
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
          Case 0
            SetAttribute(*scroll, #__Bar_Invert, GetGadgetState(0))
            SetAttribute(*spin, #__Bar_Invert, GetGadgetState(0))
            SetAttribute(*splitter, #__Bar_Invert, GetGadgetState(0))
            SetAttribute(*progress, #__Bar_Invert, GetGadgetState(0))
            SetAttribute(*track, #__Bar_Invert, GetGadgetState(0))
            SetWindowTitle(0, Str(GetState(*scroll)))
            
            If GetGadgetState(0)
              SetGadgetText(0, "set standart scrollbar")
            Else
              SetGadgetText(0, "set inverted scrollbar")
            EndIf
            
            ReDraw(root())
            
          Case g_Canvas
            If widget()\change
              SetWindowTitle(0, Str(GetState(widget())))
            EndIf
            
        EndSelect
        
    EndSelect
    
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP