;- MACOS
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  DeclareModule fixme
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Structure _S_drawing
      mode.i
      Attributes.i
      FontID.i
      size.NSSize
    EndStructure
    
    Global *drawing._S_drawing ; = AllocateStructure(_S_drawing)
    
;     Macro PB(Function)
;       Function
;     EndMacro
    
    Macro TextHeight(Text)
      TextHeight_(Text)
    EndMacro
    
    Macro TextWidth(Text)
      TextWidth_(Text)
    EndMacro
    
    Macro DrawingMode(_mode_)
      DrawingMode_(_mode_)
      PB(DrawingMode)(_mode_) 
    EndMacro
    
    Macro DrawingFont(FontID)
      DrawingFont_(FontID)
      ; PB(DrawingFont)(FontID)
    EndMacro
    
    Macro ClipOutput(x, y, width, height)
      PB(ClipOutput)(x, y, width, height)
      ClipOutput_(x, y, width, height)
    EndMacro
    
    Macro UnclipOutput()
      PB(UnclipOutput)()
      ClipOutput_(0, 0, OutputWidth(), OutputHeight())
    EndMacro
    
    Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, 0, FrontColor, BackColor)
    EndMacro
    
    Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, Angle, FrontColor, BackColor)
    EndMacro
    
    Declare.i TextHeight_(Text.s)
    Declare.i TextWidth_(Text.s)
    Declare.i DrawingMode_(Mode.i)
    Declare.i DrawingFont_(FontID.i)
    Declare.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
    Declare.i ClipOutput_(x.i, y.i, width.i, height.i)
  CompilerEndIf
EndDeclareModule 

Module fixme
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Procedure.i TextHeight_(Text.s)
      If *drawing
        ;       Protected NSString, Attributes, NSSize.NSSize
      ;       NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
      ;       ;Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
      ;       CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", *drawing\attributes)
      ;       ProcedureReturn NSSize\height
      ProcedureReturn *drawing\size\height
    EndIf
  EndProcedure
    
    Procedure.i TextWidth_(Text.s)
      If Text And *drawing And *drawing\fontID
        Protected NSString, Attributes, NSSize.NSSize
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        
        Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
;         If NSString And *drawing And *drawing\attributes
;            Debug ""+Attributes+" "+*drawing\attributes
          CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", Attributes);*drawing\attributes)
;         EndIf
          
          ProcedureReturn NSSize\width
      EndIf
    EndProcedure
    
    Procedure.i DrawingFont_(FontID.i)
    ;  If FontID
      If Not *drawing
        *drawing = AllocateStructure(_S_drawing)
      EndIf
      *drawing\fontID = FontID
      
      ; *drawing\attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
      *drawing\attributes = CocoaMessage(0, 0, "NSMutableDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
      CocoaMessage(@*drawing\size, CocoaMessage(0, 0, "NSString stringWithString:$", @""), "sizeWithAttributes:", *drawing\attributes)
   ; EndIf
  EndProcedure
    
    Procedure.i DrawingMode_(Mode.i)
      If Not *drawing
        *drawing = AllocateStructure(_S_drawing)
      EndIf
      *drawing\mode = Mode
    EndProcedure
    
    Procedure.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
      Protected.CGFloat r,g,b,a
      Protected.i Transform, NSString, Attributes, Color
      Protected Size.NSSize, Point.NSPoint
      
      If Text.s
        CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
        ;Attributes = *drawing\attributes
        
        ;         Protected FontSize.CGFloat = 24.0
        ;          Protected Font = CocoaMessage(0, 0, "NSFont fontWithName:$", @"Arial", "size:@", @FontSize)
        CocoaMessage(0, Attributes, "setValue:", *drawing\fontID, "forKey:$", @"NSFont")
        
        r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
        
        r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(*drawing\mode&#PB_2DDrawing_Transparent=0)
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
        
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
        
        
        If Angle
          CocoaMessage(0, 0, "NSGraphicsContext saveGraphicsState")
          
          y = OutputHeight()-y
          Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "rotateByDegrees:@", @Angle)
          x = 0 : y = -Size\height
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "concat")
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
          
          CocoaMessage(0, 0,  "NSGraphicsContext restoreGraphicsState")
        Else
          Point\x = x : Point\y = OutputHeight()-Size\height-y
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i ClipOutput_(x.i, y.i, width.i, height.i)
      Protected Rect.NSRect
      Rect\origin\x = x 
      Rect\origin\y = OutputHeight()-height-y
      Rect\size\width = width 
      Rect\size\height = height
      
      CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "setClip")
      ;CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "addClip")
    EndProcedure
    
    Procedure OSX_NSColorToRGBA(NSColor)
      ;Protected.i NSColor = CocoaMessage(#Null, #Null, "NSColor windowBackgroundColor")
     
      If NSColor
        Protected.cgfloat red, green, blue, alpha
        Protected nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
       
        If nscolorspace
          CocoaMessage(@red, nscolorspace, "redComponent")
          CocoaMessage(@green, nscolorspace, "greenComponent")
          CocoaMessage(@blue, nscolorspace, "blueComponent")
          CocoaMessage(@alpha, nscolorspace, "alphaComponent")
          ProcedureReturn RGBA(red * 260.0, green * 260.0, blue * 260.0, alpha * 260.0)
        EndIf
      Else
        ProcedureReturn -1
      EndIf
    EndProcedure
    
    Procedure OSX_NSColorToRGB(NSColor)
      Protected.cgfloat red, green, blue
      Protected r, g, b, a
      Protected nscolorspace, rgb
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        rgb = RGB(red * 260.0, green * 260.0, blue * 260.0)
        ProcedureReturn rgb
      EndIf
      
    EndProcedure
    
  CompilerEndIf
EndModule 

UseModule fixme

 CompilerEndIf

; ; ;- MACOS
; ; CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
; ;   DeclareModule fixme
; ;   
; ;     Global _drawing_mode_
; ;     
; ;     ;     Macro PB(Function)
; ;     ;       Function
; ;     ;     EndMacro
; ;     
; ;     Macro DrawingMode(_mode_)
; ;       PB(DrawingMode)(_mode_) : _drawing_mode_ = _mode_
; ;     EndMacro
; ;     
; ;     Macro ClipOutput(x, y, width, height)
; ;       PB(ClipOutput)(x, y, width, height)
; ;       ClipOutput_(x, y, width, height)
; ;     EndMacro
; ;     
; ;     Macro UnclipOutput()
; ;       PB(UnclipOutput)()
; ;       ClipOutput_(0, 0, OutputWidth(), OutputHeight())
; ;     EndMacro
; ;     
; ;     Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
; ;       DrawRotatedText_(x, y, Text, 0, FrontColor, BackColor)
; ;     EndMacro
; ;     
; ;     Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
; ;       DrawRotatedText_(x, y, Text, Angle, FrontColor, BackColor)
; ;     EndMacro
; ;     
; ;     Declare.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
; ;     Declare.i ClipOutput_(x.i, y.i, width.i, height.i)
; ;     Declare.i OSX_NSColorToRGBA(NSColor)
; ;     Declare.i OSX_NSColorToRGB(NSColor)
; ;  
; ; EndDeclareModule
; ; 
; ; Module fixme
; ;    
; ;     
; ;     Procedure.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
; ;       Protected.CGFloat r,g,b,a
; ;       Protected.i Transform, NSString, Attributes, Color
; ;       Protected Size.NSSize, Point.NSPoint
; ;       
; ;       If Text.s
; ;         CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
; ;         
; ;         r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
; ;         Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
; ;         CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
; ;         
; ;         r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(_drawing_mode_&#PB_2DDrawing_Transparent=0)
; ;         Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
; ;         CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
; ;         
; ;         NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
; ;         CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
; ;         
; ;         If Angle
; ;           CocoaMessage(0, 0, "NSGraphicsContext saveGraphicsState")
; ;           
; ;           y = OutputHeight()-y
; ;           Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
; ;           CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
; ;           CocoaMessage(0, Transform, "rotateByDegrees:@", @Angle)
; ;           x = 0 : y = -Size\height
; ;           CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
; ;           CocoaMessage(0, Transform, "concat")
; ;           CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
; ;           
; ;           CocoaMessage(0, 0,  "NSGraphicsContext restoreGraphicsState")
; ;         Else
; ;           Point\x = x : Point\y = OutputHeight()-Size\height-y
; ;           CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
; ;         EndIf
; ;       EndIf
; ;     EndProcedure
; ;     
; ;     Procedure.i ClipOutput_(x.i, y.i, width.i, height.i)
; ;       Protected Rect.NSRect
; ;       Rect\origin\x = x 
; ;       Rect\origin\y = OutputHeight()-height-y
; ;       Rect\size\width = width 
; ;       Rect\size\height = height
; ;       
; ;       CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "setClip")
; ;       ;CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "addClip")
; ;     EndProcedure
; ;     
; ;     Procedure.i OSX_NSColorToRGBA(NSColor)
; ;       Protected.cgfloat red, green, blue, alpha
; ;       Protected nscolorspace, rgba
; ;       nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
; ;       If nscolorspace
; ;         CocoaMessage(@red, nscolorspace, "redComponent")
; ;         CocoaMessage(@green, nscolorspace, "greenComponent")
; ;         CocoaMessage(@blue, nscolorspace, "blueComponent")
; ;         CocoaMessage(@alpha, nscolorspace, "alphaComponent")
; ;         rgba = RGBA(red * 255.9, green * 255.9, blue * 255.9, alpha * 255.)
; ;         ProcedureReturn rgba
; ;       EndIf
; ;     EndProcedure
; ;     
; ;     Procedure.i OSX_NSColorToRGB(NSColor)
; ;       Protected.cgfloat red, green, blue
; ;       Protected r, g, b, a
; ;       Protected nscolorspace, rgb
; ;       nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
; ;       If nscolorspace
; ;         CocoaMessage(@red, nscolorspace, "redComponent")
; ;         CocoaMessage(@green, nscolorspace, "greenComponent")
; ;         CocoaMessage(@blue, nscolorspace, "blueComponent")
; ;         rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
; ;         ProcedureReturn rgb
; ;       EndIf
; ;     EndProcedure
; ;     
; ;    
; ;   EndModule
; ;   CompilerEndIf
; ;   
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ------
; EnableXP