XIncludeFile "../../widgets.pbi" : Uselib(widget)

If Open(OpenWindow(#PB_Any, 0, 0, 270+270, 160, "(TextGadget & TexWidget) - demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  TextGadget(0, 10,  10, 250, 20, "TextGadget Standard (Left)")
  TextGadget(1, 10,  70, 250, 20, "TextGadget Center", #PB_Text_Center)
  TextGadget(2, 10,  40, 250, 20, "TextGadget Right", #PB_Text_Right)
  TextGadget(3, 10, 100, 250, 20, "TextGadget Border", #PB_Text_Border)
  TextGadget(4, 10, 130, 250, 20, "TextGadget Center + Border", #PB_Text_Center | #PB_Text_Border)
  
  Text(10+270,  10, 250, 20, "TextGadget Standard (Left)")
  Text(10+270,  70, 250, 20, "TextGadget Center", #__Text_Center)
  Text(10+270,  40, 250, 20, "TextGadget Right", #__Text_Right)
  Text(10+270, 100, 250, 20, "TextGadget Border", #__Text_Border)
  Text(10+270, 130, 250, 20, "TextGadget Center + Border", #__Text_Center | #__Text_Border)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf



; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 7
; Folding = -
; EnableXP