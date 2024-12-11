XIncludeFile "../../../widgets.pbi"
; надо исправить Reclip()

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=100,y=100, Width=350, Height=350 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "form", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget(Open(0))
  a_init(root())
  
  ;\\
  Define *g = window(50,50,100,100, "window", #PB_Window_SystemMenu|#__flag_autosize) : SetClass(*g, "window")
  ;Define *g = window(50,50,400,400, "window", #PB_Window_SystemMenu) : SetClass(*g, "window")
  ;Define *g = window(50,50,50,50, "window", #PB_Window_SystemMenu) : SetClass(*g, "window_0")
  
  ;\\
  Define *g0 = window(10,10,200,200, "form_0-window", #PB_Window_SystemMenu) : SetClass(*g0, "form_0")
  
  ;\\
  Define *g1 = window(30,30,200,200, "form_1-form_0", #PB_Window_SystemMenu) : SetClass(*g1, "form_1")
  Button(10,10,100,30,"button_1_0") : SetClass(widget(), GetText(widget()))
  Button(10,50,100,30,"button_1_1") : SetClass(widget(), GetText(widget()))
  Button(10,90,100,30,"button_1_2") : SetClass(widget(), GetText(widget()))
  
  ;\\
  Define *g2 = window(60,60,200,200, "form_2-form_1", #PB_Window_SystemMenu) : SetClass(*g2, "form_2")
  Button(10,10,100,30,"button_2_0") : SetClass(widget(), GetText(widget()))
  Button(10,50,100,30,"button_2_1") : SetClass(widget(), GetText(widget()))
  Button(10,90,100,30,"button_2_2") : SetClass(widget(), GetText(widget()))
  
  ;\\ "form_0"
  OpenList(*g0)
  Button(10,10,130,30,"button_0_0") : SetClass(widget(), GetText(widget()))
  Button(10,50,130,30,"button_0_1") : SetClass(widget(), GetText(widget()))
  Button(10,90,130,30,"button_0_2") : SetClass(widget(), GetText(widget()))
  CloseList()
  
  If GetClass(*g) = "window_0"
    Resize( *g, #PB_Ignore, #PB_Ignore, 400, 400)
  EndIf
  
  Debug "---->>"
  ForEach widgets( )
    Debug "  "+ widgets( )\parent\class +" <- "+ widgets( )\class
  Next
  Debug "<<----"
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 51
; FirstLine = 39
; Folding = -
; EnableXP