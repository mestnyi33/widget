CompilerIf #PB_Compiler_IsMainFile
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Macro PB(Function)
      Function
    EndMacro
    
    Global _drawing_mode_
    
    Procedure ClipOutput_(x, y, width, height)
      Protected Rect.NSRect
      Rect\origin\x = x 
      Rect\origin\y = OutputHeight()-height-y
      Rect\size\width = width 
      Rect\size\height = height
      CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "setClip")
    EndProcedure
    
    Procedure DrawText_(x, y, Text.s, FrontColor=$ffffff, BackColor=0)
      Protected.CGFloat r,g,b,a
      Protected.i NSString, Attributes, Color
      Protected Size.NSSize, Point.NSPoint
      
      CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
      
      r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
      Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
      CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
      
      r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(_drawing_mode_<>#PB_2DDrawing_Transparent)
      Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
      CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
      
      NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
      CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
      Point\x = x : Point\y = OutputHeight()-Size\height-y
      CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
    EndProcedure
    
    Macro DrawingMode(_mode_)
      PB(DrawingMode)(_mode_) : _drawing_mode_ = _mode_
    EndMacro
    
    Macro ClipOutput(x, y, width, height)
      ClipOutput_(x, y, width, height)
      ;PB(ClipOutput)(x, y, width, height)
    EndMacro
    
    Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      DrawText_(x, y, Text, FrontColor, BackColor)
    EndMacro
  CompilerEndIf
  
  If OpenWindow(0, 0, 0, 200, 200, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(16, 0, 0, 400, 200)
    
    If StartDrawing(CanvasOutput(16))
      ClipOutput(50, 50, 100, 100) ; restrict all drawing to this region
      
      DrawingMode(#PB_2DDrawing_Default)
      Circle( 50,  50, 50, $FF0000FF)  
      Circle( 50, 150, 50, $Ff00FF00)  
      Circle(150,  50, 50, $FFFF0000)  
      Circle(150, 150, 50, $FF00FFFF)  
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(40,50+(100-TextHeight("A"))/2,"error clip text in mac os", $FF000000)  
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(50, 50, 100, 100, $FF000000)
      
      StopDrawing() 
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = r-
; EnableXP