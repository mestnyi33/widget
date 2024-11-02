XIncludeFile "../../widgets.pbi"
; надо исправить Reclip()

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=100,y=100, Width=350, Height=350 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "form", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0))
  a_init(root())
  
  ;\\
  Define *g = window(50,50,100,100, "window", #PB_Window_SystemMenu|#__flag_autosize) : SetClass(*g, "window")
  ;Define *g = window(50,50,400,400, "window", #PB_Window_SystemMenu) : SetClass(*g, "window")
  ;Define *g = window(50,50,50,50, "window", #PB_Window_SystemMenu) : SetClass(*g, "window_0")
  Button(185,10,100,30,"button_0") : SetClass(widget(), GetText(widget()))
  
  ;\\
  Define *g0 = window(10,10,200,200, "form_0-window", #PB_Window_SystemMenu) : SetClass(*g0, "form_0")
  ;Define *g0 = Container(10,10,200,200) : SetClass(*g0, "form_0")
  
  ;\\
  OpenList(*g)
  Button(185,50,100,30,"button_1") : SetClass(widget(), GetText(widget()))
  
  Debug "---->>"
  ForEach widgets()
    Debug "  "+ widget( )\parent\class +" <- "+ widget( )\class +"  "+ widget( )\window\class
  Next
  Debug "<<----"
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 33
; FirstLine = 21
; Folding = -
; EnableXP