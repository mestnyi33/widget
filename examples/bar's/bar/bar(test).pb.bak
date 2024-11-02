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
            Protected state = GetState(*bar)
            Debug "#PB_EventType_Change "+state
            SetState(*splitter, state)
            SetState(*spin, state)
            SetState(*progress, state)
            SetState(*track, state)
            SetState(*scroll, state)
            SetWindowTitle(EventWindow(), Str(state))
      EndSelect
   EndProcedure
   
   Procedure Window_0()
      Protected h = 35 * 5
      Protected min 
      
      If OpenWindow(0, 0, 0, 400, 100 + h, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         ButtonGadget (0, 5, 65 + h, 390, 30, "set standart scrollbar", #PB_Button_Toggle)
         
         If Open(0, 10, 10, 380, 50 + h)
            g_Canvas  = GetGadget(root())
            Frame( 0,0,0,0, "demo bars", #__flag_autosize)
            *track    = Track(15, 10, 350, 30, min, 50, flags)
            *splitter = Splitter(15, 10 + 35 * 1, 350, 30, -1,  -1, flags | #__Bar_Vertical)
            *progress = Progress(15, 10 + 35 * 2 , 350, 30, min, 50, flags)
            *scroll   = Scroll(15, 10 + 35 * 3, 350, 30, min, 50, 8, flags)
            *spin     = Spin(15, 10 + 35 * 4, 350, 30, min, 50, 8, flags)
            
            
            SetState(*splitter, min+2)
            SetState(*spin, min+2)
            SetState(*progress, min+2)
            SetState(*track, min+2)
            SetState(*scroll, min+2)
            
            SetGadgetState(0, GetAttribute(*scroll, #__Bar_Invert))
            SetWindowTitle(0, Str(GetState(*scroll)))
            
            ;*bar = Scroll(15, 20+35*5, 350, 20, min, 50, 8)
            *bar = Track(15, 20 + 35 * 5, 350, 20, min, 50)
            ;*bar = Splitter(15, 20+35*5, 350, 30, -1,-1, #__Bar_Vertical)
            SetState(*bar, min+2)
            
            Bind( *bar, @events_widgets( ), #__event_Change )
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
                  
                  PostEventRepaint( root( ) )
                  
               Case g_Canvas
                  If widget( )\change
                     SetWindowTitle(0, Str(GetState(widget())))
                  EndIf
                  
            EndSelect
            
      EndSelect
      
      
   Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 14
; FirstLine = 10
; Folding = --
; EnableXP