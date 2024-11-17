;- MACOS
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  DeclareModule draw
    
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
      
      Macro FIXME(Function)
        draw::mac_#Function
      EndMacro
      
      Macro TextHeight(Text)
        FIXME(TextHeight)(Text)
      EndMacro
      
      Macro TextWidth(Text)
        FIXME(TextWidth)(Text)
      EndMacro
      
      Macro DrawingMode(_mode_)
        FIXME(DrawingMode)(_mode_)
        PB(DrawingMode)(_mode_) 
      EndMacro
      
      Macro GetGadgetFont(FontID)
        FIXME(GetGadgetFont)(FontID)
      EndMacro
      
      Macro DrawingFont(FontID)
        FIXME(DrawingFont)(FontID)
      EndMacro
      
      Macro ClipOutput(x, y, width, height)
        PB(ClipOutput)(x, y, width, height)
        FIXME(ClipOutput)(x, y, width, height)
      EndMacro
      
      Macro UnclipOutput()
        PB(UnclipOutput)()
        FIXME(ClipOutput)(0, 0, OutputWidth(), OutputHeight())
      EndMacro
      
      Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
        FIXME(DrawRotatedText)(x, y, Text, 0, FrontColor, BackColor)
      EndMacro
      
      Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
        FIXME(DrawRotatedText)(x, y, Text, Angle, FrontColor, BackColor)
      EndMacro
      
      Macro SetOrigin( x, y )
        FIXME(SetOrigin)(x ,y)
      EndMacro
      
      
      Declare.i mac_SetOrigin( x.l, y.l )
      Declare.i mac_GetGadgetFont(Gadget.i)
      Declare.i mac_FreeFont(Font.i)
      Declare.i mac_TextHeight(Text.s)
      Declare.i mac_TextWidth(Text.s)
      Declare.i mac_DrawingMode(Mode.i)
      Declare.i mac_DrawingFont(FontID.i)
      Declare.i mac_DrawRotatedText(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
      Declare.i mac_ClipOutput(x.i, y.i, width.i, height.i)
    CompilerEndIf
    
  EndDeclareModule 
  
  Module draw
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      ;
      ;
      ;
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
        ; ProcedureReturn PB(TextHeight)(Text.s)
        If *drawing
          If Not *drawing\size\height
            *drawing\size\height = PB(TextHeight)("A")
          EndIf
          ProcedureReturn *drawing\size\height
        EndIf
      EndProcedure
      
      Procedure.i mac_TextWidth(Text.s)
        ; ProcedureReturn PB(TextWidth)(Text.s)
        If Text And *drawing And *drawing\fontID
          Protected NSString, Attributes, NSSize.NSSize
          NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
          Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
          CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", Attributes)
          ProcedureReturn NSSize\width
        EndIf
      EndProcedure
      
      Procedure.i mac_DrawingFont(FontID.i)
        ;  If FontID
        If Not *drawing
          *drawing = AllocateStructure(_S_drawing)
        EndIf
        *drawing\fontID = FontID
        
        If *drawing\fontID
          *drawing\attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
          ;  *drawing\attributes = CocoaMessage(0, 0, "NSMutableDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
        EndIf
        
        CocoaMessage(@*drawing\size, CocoaMessage(0, 0, "NSString stringWithString:$", @""), "sizeWithAttributes:", *drawing\attributes)
        ;;*drawing\size\height - 2 
      EndProcedure
      
      Procedure.i mac_DrawingMode(Mode.i)
        If Not *drawing
          *drawing = AllocateStructure(_S_drawing)
        EndIf
        *drawing\mode = Mode
      EndProcedure
      
      Procedure.i mac_SetOrigin( x.l, y.l )
        Debug "no-fix SetOrigin( )"
        PB(SetOrigin)( x,y )
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
          
          r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 
          a = Alpha(FrontColor)/255
          If a = 0
            If *drawing\mode&#PB_2DDrawing_AlphaClip
            ElseIf *drawing\mode&#PB_2DDrawing_AlphaBlend
            ElseIf *drawing\mode&#PB_2DDrawing_AlphaChannel
            ElseIf *drawing\mode&#PB_2DDrawing_AllChannels
            Else
              a = 1
            EndIf
          EndIf
          Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
          CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
          
          ; ;           r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(*drawing\mode&#PB_2DDrawing_Transparent=0)
          ; ;           Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
          ; ;           CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
          
          NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
          CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
          ;;Size\height - 1 ;; bug
          
          
          ; ;           If Angle = 0
          ; ;             y - 2
          ; ;           ElseIf Angle = 90
          ; ;             ;;y - 1
          ; ;           ElseIf Angle = 180
          ; ;             y + 3
          ; ;           ElseIf Angle = 270
          ; ;             ;;y - 1
          ; ;           EndIf
          
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
  
  ;;UseModule draw
  
CompilerEndIf

; ; ;- MACOS
; ; CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
; ;   DeclareModule draw
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
; ; Module draw
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

CompilerIf #PB_Compiler_IsMainFile
  UseModule draw
  
  Global x,y
  ; https://www.purebasic.fr/english/viewtopic.php?p=394079#p394079
  ; *** test ***
  Procedure events_gadgets()
    Select EventType()
      Case #PB_EventType_LeftButtonDown,
           #PB_EventType_LeftButtonUp
        
        Debug #PB_Compiler_Procedure +" "+ EventGadget() +" "+ EventType()
    EndSelect
  EndProcedure
  
  Procedure draw_demo(x,y)
    ClipOutput(x, y, 100, 100) ; restrict all drawing to this region
    
    DrawingMode(#PB_2DDrawing_Default)
    Circle( x,  y, 50, $FF0000FF)  
    Circle( x, y+100, 50, $Ff00FF00)  
    Circle(x+100,  y, 50, $FFFF0000)  
    Circle(x+100, y+100, 50, $FF00FFFF)  
    
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(x-10,y+(100-TextHeight("A"))/2,"error clip text in mac os", $FF000000)  
    
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(x, y, 100, 100, $FF000000)
  EndProcedure
  
  If PB(OpenWindow)(2, 200, 100, 460, 220, "bug clip and set origin then drawing", #PB_Window_SystemMenu)
    PB(CanvasGadget)(2, 10, 10, 440, 200)
    StringGadget(12, 400, 10, 40, 25, "????")
    StringGadget(13, 400, 40, 40, 25, "????", #PB_String_Password)
    Define FontID = PB(GetGadgetFont)( #PB_Default )
    
    If PB(StartDrawing)( PB(CanvasOutput)( 2 ) )
      If FontID
        PB(DrawingFont)( FontID )
      Else
        Debug "no-pb-FontID"
      EndIf
      ; bug 
      x = 50 : y = 50
      PB(ClipOutput)(x, y, 100, 100) ; restrict all drawing to this region
      
      PB(DrawingMode)(#PB_2DDrawing_Default)
      PB(Circle)( x,  y, 50, $FF0000FF)  
      PB(Circle)( x, y+100, 50, $Ff00FF00)  
      PB(Circle)(x+100,  y, 50, $FFFF0000)  
      PB(Circle)(x+100, y+100, 50, $FF00FFFF)  
      
      PB(DrawingMode)(#PB_2DDrawing_Transparent)
      PB(DrawText)(x-10,y+(100-PB(TextHeight)("A"))/2,"error clip text ???? in mac os", $FF000000)  
      
      PB(DrawingMode)(#PB_2DDrawing_Outlined)
      PB(Box)(x, y, 100, 100, $FF000000)
      
      PB(SetOrigin)( 20,20 )
      x = 200 : y = 50
      PB(ClipOutput)(x, y, 100, 100) ; restrict all drawing to this region
      
      PB(DrawingMode)(#PB_2DDrawing_Default)
      PB(Circle)( x,  y, 50, $FF0000FF)  
      PB(Circle)( x, y+100, 50, $Ff00FF00)  
      PB(Circle)(x+100,  y, 50, $FFFF0000)  
      PB(Circle)(x+100, y+100, 50, $FF00FFFF)  
      
      PB(DrawingMode)(#PB_2DDrawing_Transparent)
      PB(DrawText)(x-10,y+(100-PB(TextHeight)("A"))/2,"error set origin in mac os", $FF000000)  
      
      PB(DrawingMode)(#PB_2DDrawing_Outlined)
      PB(Box)(x, y, 100, 100, $FF000000)
      
      PB(StopDrawing)( )
    EndIf
  EndIf
  
  If OpenWindow(1, 350, 250, 460, 220, "fix clip then drawing", #PB_Window_SystemMenu)   ; and set origin
    CanvasGadget(1, 10, 10, 440, 200)
    FontID = GetGadgetFont( #PB_Default )
    
    If StartDrawing( CanvasOutput( 1 ) )
      If FontID
        DrawingFont( FontID )
      Else
        Debug "no-FontID"
      EndIf
      ; fix
      x = 50 : y = 50
      ClipOutput(x, y, 100, 100) ; restrict all drawing to this region
      
      DrawingMode(#PB_2DDrawing_Default)
      Circle( x,  y, 50, $FF0000FF)  
      Circle( x, y+100, 50, $Ff00FF00)  
      Circle(x+100,  y, 50, $FFFF0000)  
      Circle(x+100, y+100, 50, $FF00FFFF)  
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(x-10,y+(100-TextHeight("A"))/2,"error clip text ???? in mac os", $FF000000)  
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(x, y, 100, 100, $FF000000)
      
      SetOrigin( 20,20 )
      x = 200 : y = 50
      ClipOutput(x, y, 100, 100) ; restrict all drawing to this region
      
      DrawingMode(#PB_2DDrawing_Default)
      Circle( x,  y, 50, $FF0000FF)  
      Circle( x, y+100, 50, $Ff00FF00)  
      Circle(x+100,  y, 50, $FFFF0000)  
      Circle(x+100, y+100, 50, $FF00FFFF)  
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(x-10,y+(100-TextHeight("A"))/2,"error clip text in mac os", $FF000000)  
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(x, y, 100, 100, $FF000000)
      
      StopDrawing( )
    EndIf
  EndIf
  
  BindEvent( #PB_Event_Gadget, @events_gadgets() )
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 411
; FirstLine = 406
; Folding = -------43-
; EnableXP