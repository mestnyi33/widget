XIncludeFile "../../../widgets.pbi" 

Uselib(widget)
Global alpha = 128
  
If Open(OpenWindow(#PB_Any, 0, 0, 800, 450, "Example 3: Object boundaries to position and size", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  a_init(root(), 0)
  SetColor(root(), #__color_back, RGBA(64, 128, 192, alpha))
  
  Container(50, 50, 200, 100, #__flag_nogadgets) 
  SetFrame(widget(), 3);, -1)
  SetText(widget(), "Canvas boundaries")
  SetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
  SetColor(widget(), #__color_frame, RGB(64, 128, 192))
  SetColor(widget(), #__color_front, RGB(64, 128, 192))
  
  Container(300, 50, 200, 100, #__flag_nogadgets)
  SetFrame(widget(), 3);5, -2) ; bug
  SetText(widget(), "Boundary in X")
  SetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
  SetColor(widget(), #__color_frame, RGBA(64, 128, 192, 255))
  SetColor(widget(), #__color_front, RGB(64, 128, 192))
  
  Container(550, 50, 200, 100, #__flag_nogadgets) 
  SetFrame(widget(), 3)
  SetText(widget(), "Boundary in Y")
  SetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
  SetColor(widget(), #__color_frame, RGB(64, 128, 192))
  SetColor(widget(), #__color_front, RGB(64, 128, 192))
  
  Container(50, 250, 200, 100, #__flag_nogadgets)
  SetFrame(widget(), 3)
  SetText(widget(), "Limit in width")
  SetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
  SetColor(widget(), #__color_frame, RGBA(64, 128, 192, 255))
  SetColor(widget(), #__color_front, RGB(64, 128, 192))
  
  Container(300, 250, 200, 100, #__flag_nogadgets) 
  SetFrame(widget(), 3)
  SetText(widget(), "Limit in height")
  SetColor(widget(), #__color_back, RGBA(64, 128, 192, alpha))
  SetColor(widget(), #__color_frame, RGB(64, 128, 192))
  SetColor(widget(), #__color_front, RGB(64, 128, 192))
  
  ;TextGadget( -1, 50, 50, 200, 100, "",#PB_Text_Border )
  ContainerGadget( -1, 50, 50, 200, 100, #PB_Container_Flat )
  CloseGadgetList()
  ContainerGadget( -1, 300, 50, 200, 100, #PB_Container_Flat )
  CloseGadgetList()
  ContainerGadget( -1, 550, 50, 200, 100, #PB_Container_Flat )
  CloseGadgetList()
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP