XIncludeFile "../../../widgets.pbi"
Uselib(widget)

;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 0)
  
  Window(150, 150, 300, 300, "Resize me !", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  SizeBounds(widget(), 200, 200, 400, 400)
  ;MoveBounds(widget(), 200, 200, 400, 400)
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP