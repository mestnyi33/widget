;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  UsePNGImageDecoder()
  
  Global *window, *buttonOpen, *buttonClose
  
  Procedure events_()
    Select WidgetEventType( ) 
      Case #PB_EventType_LeftClick
        If EventWidget( ) = *buttonOpen
          If Not *window
            *window = Window(100,100,200,200,"window", #__window_systemmenu|#__window_maximizegadget|#__window_minimizegadget)
          EndIf
        EndIf
        
        If EventWidget( ) = *buttonClose
          Free( *window )
          *window = 0
        EndIf
        
      Case #PB_EventType_MaximizeWindow
        Debug "maximize"
        ProcedureReturn #PB_Ignore
        
      Case #PB_EventType_MinimizeWindow
        Debug "minimize"
        ProcedureReturn #PB_Ignore
        
      Case #PB_EventType_CloseWindow
        Debug "close"
        ;Message("","",#PB_MessageRequester_Ok)
        
        ProcedureReturn #PB_Ignore
    EndSelect
  EndProcedure
  
  Open(#PB_Any, 150, 150, 500, 400, "demo close", #__Window_SizeGadget | #__Window_SystemMenu)
  *buttonOpen = Button( 500-100, 400-80, 90,30,"open")
  *buttonClose = Button( 500-100, 400-40, 90,30,"close")
  
  *window = Window(100,100,200,200,"window", #__window_systemmenu|#__window_maximizegadget|#__window_minimizegadget)
  
  Bind( *window, @events_() )
  Bind( *buttonOpen, @events_() )
  Bind( *buttonClose, @events_() )
  
  WaitClose()
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP