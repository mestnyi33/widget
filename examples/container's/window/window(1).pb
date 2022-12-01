;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 


CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  Uselib(widget)
  
  Procedure Events_windows( )
    Debug "gw "+Event( ) +" "+ EventType( ) +" "+ EventWindow( )
  EndProcedure
  
  Procedure Events_widgets( )
    Debug "ww "+ WidgetEventType( ) +" "+ EventWidget( )\index
  EndProcedure
  
  ;
  Window(100, 100, 200, 200, "window_0", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  Button(0,0,80,20,"button")
  Button(200-80,200-20,80,20,"button")
  
  Bind(Root( ), @Events_widgets( ))
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP