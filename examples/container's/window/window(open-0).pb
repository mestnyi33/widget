XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
   Define width=800, height=600

 ; If OpenRootWidget(1, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ; If OpenRootWidget(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  If WindowWidget(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ;a_init(Root())
  SetWidgetColor( Root( ), #__color_back, $ff00ffff)
  
  ;\\
  WindowWidget(10, 10, 190, 90, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ButtonWidget(10,10,170,30,"button_0")
  ButtonWidget(10,50,170,30,"button_1")
  
  widget( )\parent\fs = 0
  widget( )\parent\bs = 0
  widget( )\parent\barheight + 20
  ResizeWidget( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  WindowWidget(270, 10, 190, 90, "Window_1_1", #PB_Window_BorderLess); | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ButtonWidget(10,10,170,30,"button_2")
  ButtonWidget(10,50,170,30,"button_3")
  
  widget( )\parent\fs = 15
  ResizeWidget( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  WindowWidget(570, 10, 190, 90, "Window_0_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ButtonWidget(10,10,170,30,"button_2")
  ButtonWidget(10,50,170,30,"button_3")
  
  widget( )\parent\round = 19
  widget( )\parent\fs = 15
  ResizeWidget( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  WindowWidget(570, 350, 190, 90, "Window_0_2", #PB_Window_BorderLess)
  ButtonWidget(10,10,170,30,"button_2")
  ButtonWidget(10,50,170,30,"button_3")
  
  widget( )\parent\round = 80
  widget( )\parent\fs = 15
  ResizeWidget( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  WindowWidget(150, 150, 190, 90, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ButtonWidget(10,10,170,30,"button_2")
  ButtonWidget(10,50,170,30,"button_3")
  
  widget( )\parent\fs = 1
  widget( )\parent\barheight + 30
  ResizeWidget( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  WindowWidget(360, 150, 190, 90, "Window_1_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ButtonWidget(10,10,170,30,"button_2")
  ButtonWidget(10,50,170,30,"button_3")
  
  widget( )\parent\fs = 4
  ResizeWidget( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  WindowWidget(570, 180, 190, 90, "Window_1_1", #PB_Window_BorderLess); | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ButtonWidget(10,10,170,30,"button_2")
  ButtonWidget(10,50,170,30,"button_3")
  
  widget( )\parent\round = 19
  widget( )\parent\fs = 15
  ResizeWidget( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  ;\\
  WindowWidget(250, 350, 190, 90, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ButtonWidget(10,10,170,30,"button_4")
  ButtonWidget(10,50,170,30,"button_5")
  
  widget( )\parent\fs = 20
  widget( )\parent\fs[1] + 40
  ResizeWidget( widget( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  
  
  WaitCloseRootWidget()
EndIf

End  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP