XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  ;
  Procedure _events( )
     If is_root_(EventWidget())
        If #__event_MouseMove = WidgetEvent()
           
           
        EndIf
        If #__event_LeftUp = WidgetEvent()
        EndIf
        ProcedureReturn 0
     EndIf
     If #__event_MouseMove = WidgetEvent()
        ProcedureReturn 0
     EndIf
     
    ; Debug "" + Index( EventWidget()) +" "+ EventString( WidgetEvent()) 
  EndProcedure
  
  If Open(0, 0, 0, 800, 450, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetColor(Root( ), #PB_Gadget_BackColor, RGBA(245, 245, 245, 255))
    ;
    ;\\
    a_init(Root( ))
    ;a_init(Window(40,40,720,370,"window", #PB_Window_systemmenu))
    ;a_init(MDI(40,40,720,370)) : OpenList(widget())
    ;a_init(Container(40,40,720,370))
    ;a_init(ScrollArea(40,40,720,370, 800,500))
    ;a_init(Panel(40,40,720,370)) : AddItem(widget(), -1, "panel")
    ;
    ;\\
    a_object(50, 50, 200, 100, "Layer = 1", RGBA(128, 192, 64, 125))
    a_object(300, 50, 200, 100, "Layer = 2", RGBA(192, 64, 128, 125))
    a_object(50, 200, 200, 100, "Layer = 3", RGBA(92, 64, 128, 125))
    a_object(300, 200, 200, 100, "Layer = 4", RGBA(192, 164, 128, 125))
    ;
    ;\\
    Bind( Root( ), @_events( ))
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 20
; FirstLine = 5
; Folding = --
; EnableXP
; DPIAware