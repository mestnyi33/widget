If OpenWindow(0, 0, 0, 220, 220, "Canvas container example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  SetWindowColor( 0, $00ff00)
  
  CanvasGadget(0, 10, 10, 200, 200)
  
  If StartDrawing(CanvasOutput(0))
    FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ));, $0000ff, #PB_Byte)
    StopDrawing()
  EndIf
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP