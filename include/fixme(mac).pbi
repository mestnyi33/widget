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
    
    Macro PB(Function)
      Function
    EndMacro
    
    Macro PB_(Function)
      ;Function#_
      mac_#Function
    EndMacro
    
    Macro TextHeight(Text)
      mac_TextHeight(Text)
    EndMacro
    
    Macro TextWidth(Text)
      mac_TextWidth(Text)
    EndMacro
    
    Macro DrawingMode(_mode_)
      mac_DrawingMode(_mode_)
      PB(DrawingMode)(_mode_) 
    EndMacro
    
    Macro DrawingFont(FontID)
      mac_DrawingFont_(FontID)
      ; PB(DrawingFont)(FontID)
    EndMacro
    
    Macro ClipOutput(x, y, width, height)
      PB(ClipOutput)(x, y, width, height)
      PB_(ClipOutput)(x, y, width, height)
    EndMacro
    
    Macro UnclipOutput()
      PB(UnclipOutput)()
      PB_(ClipOutput)(0, 0, OutputWidth(), OutputHeight())
    EndMacro
    
    Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      mac_DrawRotatedText(x, y, Text, 0, FrontColor, BackColor)
    EndMacro
    
    Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
      mac_DrawRotatedText(x, y, Text, Angle, FrontColor, BackColor)
    EndMacro
    
    
    Declare.i mac_GetGadgetFont(Gadget.i)
    Declare.i mac_FreeFont(Font.i)
    Declare.i mac_TextHeight(Text.s)
    Declare.i mac_TextWidth(Text.s)
    Declare.i mac_DrawingMode(Mode.i)
    Declare.i mac_DrawingFont_(FontID.i)
    Declare.i mac_DrawRotatedText(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
    Declare.i mac_ClipOutput(x.i, y.i, width.i, height.i)
  CompilerEndIf
EndDeclareModule 

Module fixme
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Procedure.i mac_FreeFont(Font.i)
      If FontID(Font) = PB(GetGadgetFont)(#PB_Default)
        SetGadgetFont(#PB_Default, #PB_Default)
      EndIf
      
      ProcedureReturn PB(FreeFont)(Font)
    EndProcedure

;     Procedure.i mac_SetGadgetFont(Gadget.i, FontID.i)
;       If Gadget =- 1 And FontID =- 1
;         Debug #PB_Compiler_Procedure
;         Protected fs.CGFloat 
;         CocoaMessage(@fs, 0, "NSFont systemFontSize") : fs - 1
;         FontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @fs) 
;       EndIf
;       
;       ProcedureReturn PB(SetGadgetFont)(Gadget, FontID)
;     EndProcedure
    
    Procedure.i mac_GetGadgetFont(Gadget.i)
      Protected FontID = PB(GetGadgetFont)(Gadget)
      
      If Gadget =- 1 And Not FontID
        ; Debug #PB_Compiler_Procedure
        Protected fs.CGFloat 
        CocoaMessage(@fs, 0, "NSFont systemFontSize") : fs - 1
        FontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @fs) 
      EndIf
      
      ProcedureReturn FontID
    EndProcedure
    
    Procedure.i mac_TextHeight(Text.s)
      If *drawing
        If Not *drawing\size\height
          *drawing\size\height = PB(TextHeight)("A")
        EndIf
        ProcedureReturn *drawing\size\height
      EndIf
    EndProcedure
    
    Procedure.i mac_TextWidth(Text.s)
      If Text And *drawing And *drawing\fontID
        Protected NSString, Attributes, NSSize.NSSize
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
        CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", Attributes)
        ProcedureReturn NSSize\width
      EndIf
    EndProcedure
    
    Procedure.i mac_DrawingFont_(FontID.i)
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
    
    Procedure.i mac_DrawingMode(Mode.i)
      If Not *drawing
        *drawing = AllocateStructure(_S_drawing)
      EndIf
      *drawing\mode = Mode
    EndProcedure
    
    Procedure.i mac_DrawRotatedText(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
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
    
    Procedure.i mac_ClipOutput(x.i, y.i, width.i, height.i)
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
; ;       mac_ClipOutput(x, y, width, height)
; ;     EndMacro
; ;     
; ;     Macro UnclipOutput()
; ;       PB(UnclipOutput)()
; ;       mac_ClipOutput(0, 0, OutputWidth(), OutputHeight())
; ;     EndMacro
; ;     
; ;     Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
; ;       mac_DrawRotatedText(x, y, Text, 0, FrontColor, BackColor)
; ;     EndMacro
; ;     
; ;     Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
; ;       mac_DrawRotatedText(x, y, Text, Angle, FrontColor, BackColor)
; ;     EndMacro
; ;     
; ;     Declare.i mac_DrawRotatedText(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
; ;     Declare.i mac_ClipOutput(x.i, y.i, width.i, height.i)
; ;     Declare.i OSX_NSColorToRGBA(NSColor)
; ;     Declare.i OSX_NSColorToRGB(NSColor)
; ;  
; ; EndDeclareModule
; ; 
; ; Module fixme
; ;    
; ;     
; ;     Procedure.i mac_DrawRotatedText(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
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
; ;     Procedure.i mac_ClipOutput(x.i, y.i, width.i, height.i)
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
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -------
; EnableXP