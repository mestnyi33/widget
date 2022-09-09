IncludePath "../../"
XIncludeFile "widget-events.pbi"
;XIncludeFile "widgets.pbi"
;XIncludeFile "widgets-bar.pbi"
  
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  UseModule constants
  
  #__Bar_Inverted = #__Bar_Invert : #__Bar_NoButtons = #__bar_buttonsize
 
  Global.i gEvent, gQuit, g_Canvas
  Global *Bar_0
  
  Procedure events_widgets()
    Select WidgetEvent()
      Case #PB_EventType_LeftClick
        Debug  ""+EventIndex()+" - widget click"
    EndSelect
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 100, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
       ButtonGadget   (0,    5,   65, 390,  30, "set standart scrollbar", #PB_Button_Toggle)
      
     If Open(0,10,10, 380, 50)
        g_Canvas = GetGadget(root())
        *Bar_0 = Scroll(5, 10, 370, 30, 20, 50, 8, #__Bar_Inverted)
        ;;SetState(widget(), 22)
        
        SetGadgetState(0, GetAttribute(widget(), #__Bar_Inverted))
        SetWindowTitle(0, Str(GetState(widget())))
        redraw(root())
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
            SetAttribute(*Bar_0, #__Bar_Inverted, GetGadgetState(0))
            SetWindowTitle(0, Str(GetState(*Bar_0)))
            
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