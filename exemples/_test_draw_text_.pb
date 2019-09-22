If OpenWindow(0, 0, 0, 220, 220, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  CanvasGadget(0, 10, 10, 200, 200)
  
  If StartDrawing(CanvasOutput(0))
    ; DrawingFont(GetGadgetFont(#PB_Default))
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, 0, 50, 20, $FFFFFF)
    Box(50, 0, 50, 20, $000000)
    
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(0, 0, 100, 20, RGB(Random(255), Random(255), Random(255)))
    
    DrawingMode(#PB_2DDrawing_XOr)
    DrawText(8,3, "PUREBASIC")
    StopDrawing()
  EndIf
  
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP