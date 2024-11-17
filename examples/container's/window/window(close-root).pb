XIncludeFile "../../../widgets.pbi" 
; XIncludeFile "../../../widget-events.pbi" 


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define flag = #PB_Window_SystemMenu |
         #PB_Window_SizeGadget |
         #PB_Window_MinimizeGadget |
         #PB_Window_MaximizeGadget
  
  ; OpenRootWidget(0, 100, 100, 200, 200, "window_0", flag )
  WindowWidget(100, 100, 200, 200, "window_0", flag )
  
  ButtonWidget(0,0,80,20,"button_0")
  ButtonWidget(200-80,200-20,80,20,"button_1")
  
  WaitCloseRootWidget( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP