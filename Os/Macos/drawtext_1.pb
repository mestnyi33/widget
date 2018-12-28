#NSItalicFontMask = 1

OpenWindow(0, 0, 0, 220, 220, "CanvasGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 10, 10, 200, 200)

S.s = "Hello, let's draw this line of text"

Procedure DrawText_(x, y, Text.s, FrontColor.i=0)
  Protected Point.NSPoint
  Point\x = x
  Point\y = OutputHeight()-TextHeight("A")-y
  Protected AttrRed
  Protected NSString
  
 If FrontColor
    AttrRed = CocoaMessage(0, 0, "NSMutableDictionary new")
    CocoaMessage(0, AttrRed, "setValue:", FrontColor, "forKey:$", @"NSColorSpace")
  EndIf
  
  NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
  CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", AttrRed)
EndProcedure


StartDrawing(CanvasOutput(0))

;ClipOutput( 10,6,200,100)

DrawText_(100,10, "os draw text", $FFFF3B00)
DrawText(10,10, "pb draw text");, $FFFF3B00)

StopDrawing()

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP