IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseModule widget
   UseModule constants
   
   Global  flags ;= #__Bar_Invert
   Global.i gEvent, gQuit, g_Canvas
   Global *progress, *scroll, *track, *splitter, *spin, *bar
   
   Procedure events_widgets()
      Select WidgetEvent( )
         Case #__event_Change
            Protected state = GetWidgetState(*bar)
            Debug "#PB_EventType_Change "+state
            SetWidgetState(*splitter, state)
            SetWidgetState(*spin, state)
            SetWidgetState(*progress, state)
            SetWidgetState(*track, state)
            SetWidgetState(*scroll, state)
            SetWindowTitle(EventWindow(), Str(state))
      EndSelect
   EndProcedure
   
   Procedure Window_0()
      Protected h = 35 * 5
      Protected min 
      
      If OpenWindow(0, 0, 0, 400, 100 + h, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         ButtonGadget (0, 5, 65 + h, 390, 30, "set standart scrollbar", #PB_Button_Toggle)
         
         If OpenRoot(0, 10, 10, 380, 50 + h)
            g_Canvas  = GetCanvasGadget(root())
            FrameWidget( 0,0,0,0, "demo bars", #__flag_autosize)
            *track    = TrackBarWidget(15, 10, 350, 30, min, 50, flags)
            *splitter = SplitterWidget(15, 10 + 35 * 1, 350, 30, -1,  -1, flags | #__Bar_Vertical)
            *progress = ProgressBarWidget(15, 10 + 35 * 2 , 350, 30, min, 50, flags)
            *scroll   = ScrollBarWidget(15, 10 + 35 * 3, 350, 30, min, 50, 8, flags)
            *spin     = SpinWidget(15, 10 + 35 * 4, 350, 30, min, 50, 8, flags)
            
            
            SetWidgetState(*splitter, min+2)
            SetWidgetState(*spin, min+2)
            SetWidgetState(*progress, min+2)
            SetWidgetState(*track, min+2)
            SetWidgetState(*scroll, min+2)
            
            SetGadGetWidgetState(0, GetWidgetAttribute(*scroll, #__Bar_Invert))
            SetWindowTitle(0, Str(GetWidgetState(*scroll)))
            
            ;*bar = ScrollBarWidget(15, 20+35*5, 350, 20, min, 50, 8)
            *bar = TrackBarWidget(15, 20 + 35 * 5, 350, 20, min, 50)
            ;*bar = SplitterWidget(15, 20+35*5, 350, 30, -1,-1, #__Bar_Vertical)
            SetWidgetState(*bar, min+2)
            
            BindWidgetEvent( *bar, @events_widgets( ), #__event_Change )
         EndIf
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
               Case 0
                  SetWidgetAttribute(*scroll, #__Bar_Invert, GetGadGetWidgetState(0))
                  SetWidgetAttribute(*spin, #__Bar_Invert, GetGadGetWidgetState(0))
                  SetWidgetAttribute(*splitter, #__Bar_Invert, GetGadGetWidgetState(0))
                  SetWidgetAttribute(*progress, #__Bar_Invert, GetGadGetWidgetState(0))
                  SetWidgetAttribute(*track, #__Bar_Invert, GetGadGetWidgetState(0))
                  SetWindowTitle(0, Str(GetWidgetState(*scroll)))
                  
                  If GetGadGetWidgetState(0)
                     SetGadGetWidgetText(0, "set standart scrollbar")
                  Else
                     SetGadGetWidgetText(0, "set inverted scrollbar")
                  EndIf
                  
                  PostEventRepaint( root( ) )
                  
               Case g_Canvas
                  If widget( )\change
                     SetWindowTitle(0, Str(GetWidgetState(widget())))
                  EndIf
                  
            EndSelect
            
      EndSelect
      
      
   Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 53
; FirstLine = 36
; Folding = --
; EnableXP