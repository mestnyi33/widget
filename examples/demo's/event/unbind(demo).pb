﻿IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure events_widgets1()
    Debug ""+#PB_Compiler_Procedure+ " event - " +this()\event
  EndProcedure
  
  Procedure events_widgets2()
    ; ClearDebugOutput()
    Debug " "+#PB_Compiler_Procedure+ " event - " +this()\event
  EndProcedure
  
  Procedure events_windows()
    Debug "   "+#PB_Compiler_Procedure+ " event - " +this()\event+ "  item - " +this()\item +" (window)"
  EndProcedure
  
  Procedure events_roots()
    Debug "     "+#PB_Compiler_Procedure+ " event - " +this()\event+ "  item - " +this()\item +" (root)"
  EndProcedure
  
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 500, 500, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Define Editable ; = #__flag_AnchorsGadget
      
      If Open(0, 10,10, 480, 480)
        ; Bind(#PB_All, @events_roots())
        Window(80, 100, 300, 280, "Window_2", Editable)
        ;;Bind(widget(), @events_windows())
        
        Define *id._s_widget = Button(10,  10, 280, 260, "press", Editable)
        
        ; post this events
        ;;Bind(*id, @events_roots())
        Bind(*id, @events_widgets1(), #PB_EventType_LeftButtonDown)
        Bind(*id, @events_widgets1(), #PB_EventType_LeftButtonUp)
        
        Bind(*id, @events_widgets2(), #PB_EventType_LeftButtonDown)
        Bind(*id, @events_widgets2(), #PB_EventType_LeftButtonUp)
        
        ;;Unbind(*id, @events_roots())
        Unbind(*id, @events_widgets1(), #PB_EventType_LeftButtonDown)
       
;         Debug @events_widgets()
;         
;         ForEach *id\bind()
;           Debug ""+ *id\bind() +" "+ *id\bind()\events();\call() ;+""
;         Next
        
        ReDraw(Root())
      EndIf
    EndIf
  EndProcedure
  
  Window_0()
  
  WaitClose()
  
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP