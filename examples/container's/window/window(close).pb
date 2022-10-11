;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  UsePNGImageDecoder()
  
  Global *window, *button
  
  Procedure events_()
    Select WidgetEventType( ) 
      Case #PB_EventType_LeftClick
        If EventWidget( ) = *button
          Free( *window )
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
  
  Open(#PB_Any, 150, 150, 500, 400, "window_0", #__Window_SizeGadget | #__Window_SystemMenu)
  
  *window = Window(100,100,200,200,"form_0", #__window_systemmenu|#__window_maximizegadget|#__window_minimizegadget)
  *button = Button( 600-100, 300-40, 90,30,"close")
  
  Bind( *window, @events_() )
  Bind( *button, @events_() )
  
  WaitClose()
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP