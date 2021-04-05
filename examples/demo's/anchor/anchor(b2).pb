XIncludeFile "../../../widgets.pbi" : Uselib(widget)
Global alpha = 125

If Open(OpenWindow(#PB_Any, 0, 0, 800, 450, "Exemple 2: Multiple object, different handles, cursors and selection styles as well as event management", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  a_init(root());, 0)
  SetColor(root(), #__color_back, RGBA(128, 192, 64, alpha))
  
  Container(20, 20, 200, 100, #__flag_nogadgets) 
  SetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
  SetColor(widget(), #__color_frame, RGB(64, 128, 192))
  
  Container(20, 140, 200, 100, #__flag_nogadgets)
  SetColor(widget(), #__color_back, RGBA(192, 64, 128, alpha))
  SetColor(widget(), #__color_frame, RGBA(192, 64, 128, 255))
  
  Container(20, 260, 200, 100, #__flag_nogadgets) 
  SetColor(widget(), #__color_back, RGBA(128, 192, 64, alpha))
  SetColor(widget(), #__color_frame, RGB(128, 192, 64))
  
  Container(240, 20, 200, 100, #__flag_nogadgets)
  SetColor(widget(), #__color_back, RGBA(192, 128, 64, alpha))
  SetColor(widget(), #__color_frame, RGBA(192, 128, 64, 255))
  
  Container(240, 140, 200, 100, #__flag_nogadgets) 
  SetColor(widget(), #__color_back, RGBA(128, 64, 192, alpha))
  SetColor(widget(), #__color_frame, RGB(128, 64, 192))
  
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP