XIncludeFile "../../../widgets.pbi" 

Uselib(widget)
Global alpha = 192

If Open(OpenWindow(#PB_Any, 0, 0, 800, 450, "Example 4: Changing the order of the objects (context menu via right click)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  Container(0, 0, 800, 450) 
  a_init(widget(), 4) ; , 0)
  SetColor(widget(), #__color_back, RGBA(255, 255, 255, alpha))
  
  Container(20, 20, 200, 100, #__flag_nogadgets) 
  SetText(widget(), "Layer = 1")
  SetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
  SetColor(widget(), #__color_frame, RGB(64, 128, 192))
  
  Container(50, 50, 200, 100, #__flag_nogadgets)
  SetText(widget(), "Layer = 2")
  SetColor(widget(), #__color_back, RGBA(192, 64, 128, alpha))
  SetColor(widget(), #__color_frame, RGBA(192, 64, 128, 255))
  
  Container(80, 80, 200, 100, #__flag_nogadgets) 
  SetText(widget(), "Layer = 3")
  SetColor(widget(), #__color_back, RGBA(128, 192, 64, alpha))
  SetColor(widget(), #__color_frame, RGB(128, 192, 64))
  
  Container(110, 110, 200, 100, #__flag_nogadgets)
  SetText(widget(), "Layer = 4")
  SetColor(widget(), #__color_back, RGBA(192, 128, 64, alpha))
  SetColor(widget(), #__color_frame, RGBA(192, 128, 64, 255))
  
  Container(140, 140, 200, 100, #__flag_nogadgets) 
  SetText(widget(), "Layer = 5")
  SetColor(widget(), #__color_back, RGBA(128, 64, 192, alpha))
  SetColor(widget(), #__color_frame, RGB(128, 64, 192))
  
;   ContainerGadget( -1, 20, 20, 200, 100, #PB_Container_Flat )
;   CloseGadgetList()
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP