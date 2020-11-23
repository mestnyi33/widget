IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure events_widgets()
    ClearDebugOutput()
    Debug ""+GetIndex(this()\widget)+ " - widget  event - " +this()\event+ "  item - " +this()\item +" (gadget)"
    
    Select this()\event 
      Case #PB_EventType_LeftClick
        If GetIndex(this()\widget) = 1
          ProcedureReturn #PB_Ignore ; no send to (window & root) - event
        EndIf
    EndSelect
  EndProcedure
  
  Procedure events_windows()
    Debug "  "+GetIndex(this()\widget)+ " - widget  event - " +this()\event+ "  item - " +this()\item +" (window)"
    
    Select this()\event 
      Case #PB_EventType_LeftClick
        If GetIndex(this()\widget) = 2
          ProcedureReturn #PB_Ignore ; no send to (root) - event
        EndIf
    EndSelect
  EndProcedure
  
  Procedure events_roots()
    Debug "    "+GetIndex(this()\widget)+ " - widget  event - " +this()\event+ "  item - " +this()\item +" (root)"
  EndProcedure
  
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 500, 500, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Define Editable ; = #__flag_AnchorsGadget
      
      If Open(0, 10,10, 480, 480)
        Bind(#PB_All, @events_roots())
        Bind(Window(80, 100, 300, 280, "Window_2", Editable), @events_windows())
        
        Bind(Button(10,  10, 280, 80, "post event for one procedure", Editable), @events_widgets())
        Bind(Button(10, 100, 280, 80, "post event for to two procedure", Editable), @events_widgets())
        Bind(Button(10, 190, 280, 80, "post event for all procedures", Editable), @events_widgets())
        
        ReDraw(Root())
      EndIf
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---
; EnableXP