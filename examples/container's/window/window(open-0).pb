XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
   Define width=800, height=600

If Open(1, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ;a_init(Root())
  SetColor( Root( ), #__color_back, $ff00ffff)
  
  ;\\
  Window(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_0")
  button(10,50,170,30,"button_1")
  
  widget( )\_parent( )\fs = 0
  widget( )\_parent( )\bs = 0
  widget( )\_parent( )\barheight + 20
  Resize( widget( )\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(270, 10, 190, 90, "Window_1_1", #PB_Window_BorderLess); | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_2")
  button(10,50,170,30,"button_3")
  
  widget( )\_parent( )\fs = 15
  Resize( widget( )\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(570, 10, 190, 90, "Window_0_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_2")
  button(10,50,170,30,"button_3")
  
  widget( )\_parent( )\round = 19
  widget( )\_parent( )\fs = 15
  Resize( widget( )\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(570, 350, 190, 90, "Window_0_2", #PB_Window_BorderLess)
  button(10,10,170,30,"button_2")
  button(10,50,170,30,"button_3")
  
  widget( )\_parent( )\round = 80
  widget( )\_parent( )\fs = 15
  Resize( widget( )\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(150, 150, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_2")
  button(10,50,170,30,"button_3")
  
  widget( )\_parent( )\fs = 1
  widget( )\_parent( )\barheight + 30
  Resize( widget( )\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(360, 150, 190, 90, "Window_1_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_2")
  button(10,50,170,30,"button_3")
  
  widget( )\_parent( )\fs = 4
  Resize( widget( )\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(570, 180, 190, 90, "Window_1_1", #PB_Window_BorderLess); | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_2")
  button(10,50,170,30,"button_3")
  
  widget( )\_parent( )\round = 19
  widget( )\_parent( )\fs = 15
  Resize( widget( )\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  Window(250, 350, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  button(10,10,170,30,"button_4")
  button(10,50,170,30,"button_5")
  
  widget( )\_parent( )\fs = 20
  widget( )\_parent( )\fs[1] + 40
  Resize( widget( )\_parent( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  
  WaitClose()
EndIf

End  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP