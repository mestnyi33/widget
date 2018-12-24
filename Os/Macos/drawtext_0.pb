#NSItalicFontMask = 1
FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")

FontSize.CGFloat = 12
BoldItalicFont = CocoaMessage(0, FontManager, "fontWithFamily:$", @"Helvetica",
                            "traits:", #NSItalicFontMask, 
                            "weight:", 9, "size:@", @FontSize)

AttrBlueItalic = CocoaMessage(0, 0, "NSMutableDictionary new")
CocoaMessage(0, AttrBlueItalic, "setValue:", CocoaMessage(0, 0, "NSColor blueColor"), "forKey:$", @"NSColor")
CocoaMessage(0, AttrBlueItalic, "setValue:", BoldItalicFont, "forKey:$", @"NSFont")

AttrRed = CocoaMessage(0, 0, "NSMutableDictionary new")
CocoaMessage(0, AttrRed, "setValue:", CocoaMessage(0, 0, "NSColor redColor"), "forKey:$", @"NSColor")


OpenWindow(0, 0, 0, 220, 220, "CanvasGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 10, 10, 200, 200)

S.s = "Hello, let's draw this line of text"
NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @S)

Point.NSPoint\x = 10
Point\y = 200-15-10

Rect.NSRect\origin\x = 20
Rect\origin\y = 60
Rect\size\width = 160
Rect\size\height = 50 


StartDrawing(CanvasOutput(0))
CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", AttrRed)
CocoaMessage(0, NSString, "drawInRect:@", @Rect, "withAttributes:", AttrBlueItalic)
StopDrawing()

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; EnableXP