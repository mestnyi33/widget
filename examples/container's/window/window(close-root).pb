XIncludeFile "../../../widgets.pbi" 
; XIncludeFile "../../../widget-events.pbi" 


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define flag = #PB_Window_SystemMenu |
         #PB_Window_SizeGadget |
         #PB_Window_MinimizeGadget |
         #PB_Window_MaximizeGadget
  
  ; Open(0, 100, 100, 200, 200, "window_0", flag )
  Window(100, 100, 200, 200, "window_0", flag )
  
  Button(0,0,80,20,"button_0")
  Button(200-80,200-20,80,20,"button_1")
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP