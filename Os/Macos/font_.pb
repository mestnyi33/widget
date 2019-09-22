Global DrawingFont

Procedure DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
  Protected.CGFloat r,g,b,a
  Protected.i Transform, NSString, Attributes, Color
  Protected Size.NSSize, ZeroPoint.NSPoint
   
  CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
  
  If DrawingFont
    CocoaMessage(0, Attributes, "setValue:", DrawingFont, "forKey:$", @"NSFont")
  EndIf
  
  r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
  Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
  CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
 
  r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = 0
  Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
  CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")
 
  NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
  CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
 
  CocoaMessage(0, 0, "NSGraphicsContext saveGraphicsState")
 
  y = OutputHeight()-y
  Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
  CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
  CocoaMessage(0, Transform, "rotateByDegrees:@", @Angle)
  x = 0 : y = -Size\height
  CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
  CocoaMessage(0, Transform, "concat")
  CocoaMessage(0, NSString, "drawAtPoint:@", @ZeroPoint, "withAttributes:", Attributes)
 
  CocoaMessage(0, 0,  "NSGraphicsContext restoreGraphicsState")
   
EndProcedure

Procedure ClipOutput_(x, y, width, height)
  Protected Rect.NSRect
  Rect\origin\x = x
  Rect\origin\y = OutputHeight()-height-y
  Rect\size\width = width
  Rect\size\height = height
  CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "setClip")
EndProcedure

Macro PB(Function)
  Function
EndMacro

Macro ClipOutput(x, y, width, height)
  PB(ClipOutput)(x, y, width, height)
  ClipOutput_(x, y, width, height)
EndMacro

Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
 DrawRotatedText_(x, y, Text, Angle, FrontColor, BackColor)
EndMacro

Macro DrawingFont(FontID)
  DrawingFont = FontID
  
  ;PB(DrawingFont)(FontID)
EndMacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; example
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Procedure stringHeight(string.s)
;   Protected NSSize.NSSize, Attributes, NSDictionary, Size.CGFloat
;   
;   NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @string)
;   
;   ;NSDictionary = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:",  DrawingFont, "forKey:$", @"NSFontAttributeName")
;   ;CocoaMessage(NSSize, NSString, "sizeWithAttributes:", NSDictionary)
;   
;   CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
;   CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
;     
;   ProcedureReturn Size ;NSSize\height
; EndProcedure

Procedure StringHeight(String.s)
  Protected NSString, Attributes, NSSize.NSSize
  NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @String)
  Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", DrawingFont, "forKey:$", @"NSFont")
  CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", Attributes)
  ProcedureReturn NSSize\height
EndProcedure

Procedure StringWidth(String.s)
  Protected NSString, Attributes, NSSize.NSSize
  NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @String)
  Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", DrawingFont, "forKey:$", @"NSFont")
  CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", Attributes)
  ProcedureReturn NSSize\width
EndProcedure

LoadFont(0, "arial", 18)
LoadFont(1, "Lucida Grande", 12)
;LoadFont(1, "Helvetica Neue", 12)
;LoadFont(1, "Helvetica", 12)
;
Procedure draw_gadget(x, y, w, h)
  Protected i, ix, iy
  ClipOutput(x, y, w, h)
 
  ; item of the gadget
  For i=0 To 10
    ix = i*24
   
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(x,y+ix, h,24)
    Protected FontSize.CGFloat, Size.CGFloat
    
    ; text of the item
    If i=2
      FontID = FontID(0)
    Else
      FontID = FontID(1)
    EndIf
    
    DrawingFont(FontID)
    CocoaMessage(@FontSize, FontID, "pointSize")
    ;Debug PeekS(CocoaMessage(0, CocoaMessage(0, FontID, "displayName"), "UTF8String"), -1, #PB_UTF8)
    
    ;Protected fontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @FontSize)
    ;           CocoaMessage(@FontSize, fontID, "pointSize")
    ;Debug CocoaMessage(0, fontID, "pixelsHigh")
    ;CocoaMessage(0, fontID, "setSize:@", @FontSize)
    
;     NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @string)
;     CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
    Debug ""+TextHeight("a") +" "+ stringHeight("aa") +" "+ StringWidth(" ") + " "+ FontSize + " "+ Size
    
    DrawingMode(#PB_2DDrawing_Transparent)
    ;DrawRotatedText(x, y+ix+(24-TextHeight("a"))/2, "clip line "+Str(i)+" rotated text", 0, 0)
    DrawRotatedText(x, y+ix+(24-(FontSize+7))/2, "clip line "+Str(i)+" rotated text", 0, 0)
  Next
 
  ; frame gadget
  DrawingMode(#PB_2DDrawing_Outlined)
  Box(x,y, w,h, $FFFF00)
EndProcedure


OpenWindow(0, 0, 0, 300, 300, "sample demonstration fixes clip output", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

CreateImage(0, 300, 300, 24, $c0c0c0)
StartDrawing(ImageOutput(0))


; 1 - gadget
draw_gadget(50, 30, 80, 100)

; 2 - gadget
draw_gadget(150, 90, 80, 100)

; 3 - gadget
draw_gadget(50, 180, 80, 100)


StopDrawing()
ImageGadget(0, 0, 0, 200, 200, ImageID(0))     

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP