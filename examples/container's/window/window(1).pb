XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Procedure Events_widgets( )
    Debug "event "+ EventString(WidgetEvent( )) +" "+ EventWidget( )\index
    ;
    ProcedureReturn #PB_Ignore
 EndProcedure
  
  ;
  Window(100, 100, 200, 200, "window_0", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  Button(0,0,80,20,"button")
  Button(200-80,200-20,80,20,"button")
  
  WaitClose( @Events_widgets( ) )
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 8
; Folding = -
; EnableXP
; DPIAware