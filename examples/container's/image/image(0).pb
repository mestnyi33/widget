IncludePath "../../"
XIncludeFile "widgets.pbi"

UseLib(widget)

LN=1000; количесвто итемов 
Global *w._S_widget

If Open(OpenWindow(#PB_Any, 100, 50, 400, 500, "ListViewGadget", #PB_Window_SystemMenu))
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
  EndIf
  
  Image(10, 10, 380, 380, (0)) 
  
  Button(10,390, 95, 25, "")
  WaitClose()
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP