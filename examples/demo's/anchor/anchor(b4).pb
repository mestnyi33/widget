XIncludeFile "../../../widgets.pbi" 

EnableExplicit
Uselib(widget)
Global alpha = 192

Procedure _Object( x.l,y.l,width.l,height.l, text.s, Color.l, flag.i=#Null  )
  Container(x,y,width,height, #__flag_nogadgets) 
  If text
    SetText(widget(), text)
  EndIf
  SetColor(widget(), #__color_back, Color)
  SetColor(widget(), #__color_frame, Color&$FFFFFF | 255<<24)
  ProcedureReturn widget( )
EndProcedure

If Open(#PB_Any, 0, 0, 800, 450, "Example 4: Changing the order of the objects (context menu via right click)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Container(0, 0, 800, 450) 
  a_init(widget());, 0) ; , 4)
  SetColor(widget(), #__color_back, RGBA(255, 255, 255, alpha))
  
  _Object(20, 20, 200, 100, "Layer = 1", RGBA(64, 128, 192, alpha))
  _Object(50, 50, 200, 100, "Layer = 2", RGBA(192, 64, 128, alpha))
  _Object(80, 80, 200, 100, "Layer = 3", RGBA(128, 192, 64, alpha))
  _Object(110, 110, 200, 100, "Layer = 4", RGBA(192, 128, 64, alpha))
  _Object(140, 140, 200, 100, "Layer = 5", RGBA(128, 64, 192, alpha))
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP