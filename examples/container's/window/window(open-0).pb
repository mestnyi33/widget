XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
   Define Width=800, Height=600

 If Open(1, 100, 200, Width, Height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, Width, Height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ;a_init(Root())
  SetColor( root( ), #__color_back, $ff00ffff)
  
  ;\\
  Window(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Button(10,10,170,30,"button_0")
  Button(10,50,170,30,"button_1")
  
  widget( )\parent\fs = 0
  widget( )\parent\bs = 0
  widget( )\parent\TitleBarHeight + 20
  widget( )\parent\fs[2] + 20
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(270, 10, 190, 90, "Window_1_1", #PB_Window_BorderLess); | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Button(10,10,170,30,"button_2")
  Button(10,50,170,30,"button_3")
  
  widget( )\parent\fs = 15
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(570, 10, 190, 90, "Window_0_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Button(10,10,170,30,"button_2")
  Button(10,50,170,30,"button_3")
  
  widget( )\parent\round = 19
  widget( )\parent\fs = 15
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(570, 350, 190, 90, "Window_0_2", #PB_Window_BorderLess)
  Button(10,10,170,30,"button_2")
  Button(10,50,170,30,"button_3")
  
  widget( )\parent\round = 80
  widget( )\parent\fs = 15
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(150, 150, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Button(10,10,170,30,"button_2")
  Button(10,50,170,30,"button_3")
  
  widget( )\parent\fs = 1
  widget( )\parent\TitleBarHeight + 30
  widget( )\parent\fs[2] + 20
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(360, 150, 190, 90, "Window_1_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Button(10,10,170,30,"button_2")
  Button(10,50,170,30,"button_3")
  
  widget( )\parent\fs = 4
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(570, 180, 190, 90, "Window_1_1", #PB_Window_BorderLess); | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Button(10,10,170,30,"button_2")
  Button(10,50,170,30,"button_3")
  
  widget( )\parent\round = 19
  widget( )\parent\fs = 15
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(250, 350, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Button(10,10,170,30,"button_4")
  Button(10,50,170,30,"button_5")
  
  widget( )\parent\fs = 20
  widget( )\parent\fs[1] + 40
  Resize( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  
  WaitClose()
EndIf

End  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 59
; FirstLine = 45
; Folding = -
; EnableXP