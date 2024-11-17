XIncludeFile "../../../widgets.pbi"
; надо исправить scroll\v draw width

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=100,y=100, Width=350, Height=350 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "form no child's", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget(Open(0, 10, 10))
  a_init(root())
  
  
  ;\\
  ;Define *g = window(50,50,100,100, "window", #PB_Window_SystemMenu|#__flag_autosize) : SetWidgetClass(*g, "window")
  Define *g = window(50,50,400,400, "window", #PB_Window_SystemMenu) : SetWidgetClass(*g, "window")
  
  ;\\
  Define *g0 = window(10,10,200,200, "form_0-window", #PB_Window_SystemMenu, *g) : SetWidgetClass(*g0, "form_0")
  
  ;\\
  Define *g1 = window(30,10,200,200, "form_1-form_0", #PB_Window_SystemMenu, *g0) : SetWidgetClass(*g1, "form_1")
  ButtonWidget(10,10,100,30,"button_1_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,100,30,"button_1_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,100,30,"button_1_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
  
  ;\\
  Define *g2 = window(50,10,200,200, "form_2-form_1", #PB_Window_SystemMenu, *g1) : SetWidgetClass(*g2, "form_2")
  ButtonWidget(10,10,100,30,"button_2_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,100,30,"button_2_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,100,30,"button_2_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
  
  ;\\ "form_0"
  OpenList(*g0)
  ButtonWidget(10,10,130,30,"button_0_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,130,30,"button_0_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,130,30,"button_0_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
  CloseList()
  
  
  Debug "---->>"
  ForEach widgets( )
    Debug "  "+ widgets(  )\parent\class +" <- "+ widgets(  )\class
  Next
  Debug "<<----"
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 48
; FirstLine = 33
; Folding = -
; EnableXP