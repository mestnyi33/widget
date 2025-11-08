XIncludeFile "../../../widgets.pbi"
; надо исправить scroll\v draw width

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i
  Global X=100,Y=100, Width=350, Height=350 , focus
  
  If Not Open(0, 0, 0, Width+X*2+20, Height+Y*2+20, "form no child's", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  a_init(root())
  
  
  ;\\
  ;Define *g = window(50,50,100,100, "window", #PB_Window_SystemMenu|#__flag_autosize) : SetClass(*g, "window")
  Define *g = window(50,50,400,400, "window", #PB_Window_SystemMenu) : SetClass(*g, "window")
  
  ;\\
  Define *g0 = window(10,10,200,200, "form_0-window", #PB_Window_SystemMenu, *g) : SetClass(*g0, "form_0")
  
  ;\\
  Define *g1 = window(30,10,200,200, "form_1-form_0", #PB_Window_SystemMenu, *g0) : SetClass(*g1, "form_1")
  Button(10,10,100,30,"button_1_0") : SetClass(widget(), GetText(widget()))
  Button(10,50,100,30,"button_1_1") : SetClass(widget(), GetText(widget()))
  Button(10,90,100,30,"button_1_2") : SetClass(widget(), GetText(widget()))
  
  ;\\
  Define *g2 = window(50,10,200,200, "form_2-form_1", #PB_Window_SystemMenu, *g1) : SetClass(*g2, "form_2")
  Button(10,10,100,30,"button_2_0") : SetClass(widget(), GetText(widget()))
  Button(10,50,100,30,"button_2_1") : SetClass(widget(), GetText(widget()))
  Button(10,90,100,30,"button_2_2") : SetClass(widget(), GetText(widget()))
  
  ;\\ "form_0"
  OpenList(*g0)
  Button(10,10,130,30,"button_0_0") : SetClass(widget(), GetText(widget()))
  Button(10,50,130,30,"button_0_1") : SetClass(widget(), GetText(widget()))
  Button(10,90,130,30,"button_0_2") : SetClass(widget(), GetText(widget()))
  CloseList()
  
  
  Debug "---->>"
  ForEach widgets( )
    Debug "  "+ widgets(  )\parent\class +" <- "+ widgets(  )\class
  Next
  Debug "<<----"
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP