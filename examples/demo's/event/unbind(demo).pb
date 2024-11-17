IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure events_widgets1()
    Debug ""+#PB_Compiler_Procedure+ " event - " +WidgetEvent( )
  EndProcedure
  
  Procedure events_widgets2()
    ; ClearDebugOutput()
    Debug " "+#PB_Compiler_Procedure+ " event - " +WidgetEvent( )
  EndProcedure
  
  Procedure events_windows()
    Debug "   "+#PB_Compiler_Procedure+ " event - " +WidgetEvent( )+ "  item - " +WidgetEventItem( ) +" (window)"
  EndProcedure
  
  Procedure events_roots()
    Debug "     "+#PB_Compiler_Procedure+ " event - " +WidgetEvent( )+ "  item - " +WidgetEventItem( ) +" (root)"
  EndProcedure
  
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 500, 500, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Define Editable ; = 
      
      If Open(0, 10,10, 480, 480)
        ; Bind(#PB_All, @events_roots())
        Window(80, 100, 300, 280, "Window_2", Editable)
        ;;Bind(widget(), @events_windows())
        
        Define *id._s_widget = ButtonWidget(10,  10, 280, 260, "press", Editable)
        
        ; post this events
        ;;Bind(*id, @events_roots())
        Bind(*id, @events_widgets1(), #__event_LeftDown)
        Bind(*id, @events_widgets1(), #__event_LeftUp)
        
        Bind(*id, @events_widgets2(), #__event_LeftDown)
        Bind(*id, @events_widgets2(), #__event_LeftUp)
        
        ;;Unbind(*id, @events_roots())
        Unbind(*id, @events_widgets1(), #__event_LeftDown)
       
;         Debug @events_widgets()
;         
;         ForEach *id\bind()
;           Debug ""+ *id\bind() +" "+ *id\bind()\events();\call() ;+""
;         Next
      EndIf
    EndIf
  EndProcedure
  
  Window_0()
  
  WaitClose()
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 45
; FirstLine = 38
; Folding = --
; EnableXP