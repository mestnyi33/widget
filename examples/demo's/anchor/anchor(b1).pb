XIncludeFile "../../../widgets.pbi" : Uselib(widget)

If Open(OpenWindow(#PB_Any, 0, 0, 800, 450, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  a_init(root())
  SetColor(root(), #__color_back, RGBA(128, 192, 64, 125))
  
  Container(20, 20, 200, 100, #__flag_nogadgets) 
  SetText(widget(), "Layer = 1")
  SetColor(widget(), #__color_back, RGBA(128, 192, 64, 125))
  SetColor(widget(), #__color_frame, RGB(128, 192, 64))
  
  Container(320, 20, 200, 100, #__flag_nogadgets)
  SetText(widget(), "Layer = 2")
  SetColor(widget(), #__color_back, RGBA(192, 64, 128, 125))
  SetColor(widget(), #__color_frame, RGBA(192, 64, 128, 255))
  
  Container(20, 320, 200, 100, #__flag_nogadgets)
  SetText(widget(), "Layer = 3")
  SetColor(widget(), #__color_back, RGBA(92, 64, 128, 125))
  SetColor(widget(), #__color_frame, RGBA(92, 64, 128, 255))
  
  Container(320, 320, 200, 100, #__flag_nogadgets)
  SetText(widget(), "Layer = 4")
  SetColor(widget(), #__color_back, RGBA(192, 164, 128, 125))
  SetColor(widget(), #__color_frame, RGBA(192, 164, 128, 255))
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP