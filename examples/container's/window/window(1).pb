XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Procedure Events_widgets( )
    Debug "event "+ WidgetEvent( ) +" "+ EventWidget( )\index
  EndProcedure
  
  ;
  WindowWidget(100, 100, 200, 200, "window_0", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  ButtonWidget(0,0,80,20,"button")
  ButtonWidget(200-80,200-20,80,20,"button")
  
  WaitEvent( #PB_All, @Events_widgets( ) )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 8
; Folding = -
; EnableXP
; DPIAware