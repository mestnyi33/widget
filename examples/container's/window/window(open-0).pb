XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
   Define width=800, height=600

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
  Window(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_0")
  button(10,50,170,30,"button_1")
  
  widget( )\parent\fs = 0
  widget( )\parent\bs = 0
  widget( )\parent\__height + 20
  Debug widget( )\parent\__height
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  Window(110, 30, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_2")
  button(10,50,170,30,"button_3")
  
  widget( )\parent\fs = 0
  widget( )\parent\__height + 30
  Debug widget( )\parent\__height
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  Window(220, 50, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_4")
  button(10,50,170,30,"button_5")
  
  widget( )\parent\fs = 20
  widget( )\parent\__height[1] + 40
  Debug widget( )\parent\__height
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  
  WaitClose()
EndIf

End  
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP