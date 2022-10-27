;-TOP
; by mk-soft
; v1.01
; 15.05.2019

DeclareModule NSColor
  Declare NSColorToRGB(NSColor)
  Declare NSColorToRGBA(NSColor)
  Declare NSColorByNameToRGB(NSColorName.s)
  Declare NSColorByNameToRGBA(NSColorName.s)
  Declare RGBtoNSColor(Color)
  Declare RGBAtoNSColor(Color)
  Declare BlendColor(Color1.i, Color2.i, Scale.i) ; Thanks to Thorsten
EndDeclareModule

Module NSColor
 
  Procedure NSColorToRGB(NSColor)
    Protected.cgfloat red, green, blue
    Protected nscolorspace, rgb
    nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
    If nscolorspace
      CocoaMessage(@red, nscolorspace, "redComponent")
      CocoaMessage(@green, nscolorspace, "greenComponent")
      CocoaMessage(@blue, nscolorspace, "blueComponent")
      rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
      ProcedureReturn rgb
    EndIf
  EndProcedure
 
  Procedure NSColorToRGBA(NSColor)
    Protected.cgfloat red, green, blue, alpha
    Protected nscolorspace, rgba
    nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
    If nscolorspace
      CocoaMessage(@red, nscolorspace, "redComponent")
      CocoaMessage(@green, nscolorspace, "greenComponent")
      CocoaMessage(@blue, nscolorspace, "blueComponent")
      CocoaMessage(@alpha, nscolorspace, "alphaComponent")
      rgba = RGBA(red * 255.0, green * 255.0, blue * 255.0, alpha * 255.0)
      ProcedureReturn rgba
    EndIf
  EndProcedure
 
  Procedure NSColorByNameToRGB(NSColorName.s)
    Protected.cgfloat red, green, blue
    Protected nscolorspace, rgb
    nscolorspace = CocoaMessage(0, CocoaMessage(0, 0, "NSColor " + NSColorName), "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
    If nscolorspace
      CocoaMessage(@red, nscolorspace, "redComponent")
      CocoaMessage(@green, nscolorspace, "greenComponent")
      CocoaMessage(@blue, nscolorspace, "blueComponent")
      rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
      ProcedureReturn rgb
    EndIf
  EndProcedure
 
  Procedure NSColorByNameToRGBA(NSColorName.s)
    Protected.cgfloat red, green, blue, alpha
    Protected nscolorspace, rgba
;     nscolorspace = CocoaMessage(#Null, #Null, "NSColor colorWithCatalogName:$",@"System","colorName:$",@NSColorName)
;     nscolorspace = CocoaMessage(#Null, nscolorspace, "colorUsingColorSpaceName:$",@"NSCalibratedRGBColorSpace")
        
    nscolorspace = CocoaMessage(0, CocoaMessage(0, 0, "NSColor " + NSColorName), "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
    If nscolorspace
      CocoaMessage(@red, nscolorspace, "redComponent")
      CocoaMessage(@green, nscolorspace, "greenComponent")
      CocoaMessage(@blue, nscolorspace, "blueComponent")
      CocoaMessage(@alpha, nscolorspace, "alphaComponent")
      rgb = RGBA(red * 255.0, green * 255.0, blue * 255.0, alpha * 255.0)
      ProcedureReturn rgb
    EndIf
  EndProcedure
 
  Procedure RGBtoNSColor(Color)
    Protected Alpha.CGFloat, Blue.CGFloat, Green.CGFloat, Red.CGFloat
    Red = Red(Color) / 255
    Green = Green(Color) / 255
    Blue = Blue(Color) / 255
    Alpha = 1.0
    ProcedureReturn CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@",
                 @Red, "green:@", @Green, "blue:@", @Blue, "alpha:@", @Alpha)
  EndProcedure
 
  Procedure RGBAtoNSColor(Color)
    Protected Alpha.CGFloat, Blue.CGFloat, Green.CGFloat, Red.CGFloat
    Red = Red(Color) / 255
    Green = Green(Color) / 255
    Blue = Blue(Color) / 255
    Alpha = Alpha(Color) / 255
    ProcedureReturn CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@",
                 @Red, "green:@", @Green, "blue:@", @Blue, "alpha:@", @Alpha)
  EndProcedure
 
  Procedure BlendColor(Color1.i, Color2.i, Scale.i) ; Thanks to Thorsten
    Protected.i R1, G1, B1, R2, G2, B2
    Protected.f Blend = Scale / 100
    R1 = Red(Color1): G1 = Green(Color1): B1 = Blue(Color1)
    R2 = Red(Color2): G2 = Green(Color2): B2 = Blue(Color2)
    ProcedureReturn RGB((R1*Blend) + (R2 * (1-Blend)), (G1*Blend) + (G2 * (1-Blend)), (B1*Blend) + (B2 * (1-Blend)))
  EndProcedure
 
EndModule

;- End Module

CompilerIf #PB_Compiler_IsMainFile
 
  UseModule NSColor
  
  Macro ShowColor(colorName)
    ShowColor_col.q = NSColorByNameToRGBA(colorName)
    
    If ShowColor_col = -1
        Debug Str(-1) + " ("+colorName+")"
    Else
        Debug "Color: " + Hex(ShowColor_col) + " ("+colorName+")"
    EndIf
  EndMacro



  If OpenWindow(0, 0, 0, 220, 220, "CanvasGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(0, 10, 10, 200, 200)
    If StartDrawing(CanvasOutput(0))
      ;nscolor = CocoaMessage(0, WindowID(0), "backgroundColor")
      ;color = BlendColor(NSColorToRGB(nscolor), $FFFFFF, 90) ; Correction for solid gadget
      color = BlendColor(NSColorByNameToRGB("controlBackgroundColor"), $FFFFFF, 85) ; Correction for solid gadget
      Box(0, 0, 200, 200, color)
      color = NSColorByNameToRGB("lightGrayColor")
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(10, 10, 180, 180, color)
      StopDrawing()
    EndIf
    
    
    
    
   
ShowColor("windowBackgroundColor")                  ; PATTERN -> Returns a pattern color that will draw the ruled lines for the window background.

ShowColor("windowFrameColor")                       ; Returns the system color used for window frames, except for their text.
ShowColor("windowFrameTextColor")                   ; Returns the system color used for the text in window frames.

ShowColor("alternateSelectedControlColor")          ; Returns the system color used for the face of a selected control.
ShowColor("alternateSelectedControlTextColor")      ; Returns the system color used for text in a selected control.

;ShowColor("controlAlternatingRowBackgroundColors")  ; ARRAY -> Returns an array containing the system specified background colors for alternating rows in tables and lists.

ShowColor("gridColor")                              ; Returns the system color used for the optional gridlines in, for example, a table view.
ShowColor("headerColor")                            ; Returns the system color used as the background color for header cells in table views and outline views.
ShowColor("headerTextColor")                        ; Returns the system color used for text in header cells in table views and outline views.

ShowColor("highlightColor")                         ; Returns the system color that represents the virtual light source on the screen.

ShowColor("keyboardFocusIndicatorColor")            ; Returns the system color that represents the keyboard focus ring around controls.
ShowColor("knobColor")                              ; Returns the system color used for the flat surface of a slider knob that hasn’t been selected.
ShowColor("selectedKnobColor")                      ; Returns the system color used for the slider knob when it is selected.

ShowColor("scrollBarColor")                         ; Returns the system color used for scroll “bars”—that is, for the groove in which a scroller’s knob moves

ShowColor("selectedMenuItemColor")                  ; Returns the system color used for the face of selected menu items.
ShowColor("selectedMenuItemTextColor")              ; Returns the system color used for the text in menu items.

ShowColor("selectedTextBackgroundColor")            ; Returns the system color used for the background of selected text.
ShowColor("selectedTextColor")                      ; Returns the system color used for selected text.

ShowColor("shadowColor")                            ; Returns the system color that represents the virtual shadows cast by raised objects on the screen.

ShowColor("textColor")                              ; Returns the system color used for text.
ShowColor("textBackgroundColor")                    ; Returns the system color used for the text background.

ShowColor("secondarySelectedControlColor")          ; Returns the system color used in non-key views.
ShowColor("selectedControlColor")                   ; Returns the system color used for the face of a selected control.
ShowColor("selectedControlTextColor")               ; Returns the system color used for text in a selected control—a control being clicked or dragged.


ShowColor("controlBackgroundColor")                 ; Returns the system color used for the background of large controls.
ShowColor("controlColor")                           ; Returns the system color used for the flat surfaces of a control.
ShowColor("controlDarkShadowColor")                 ; Returns the system color used for the dark edge of the shadow dropped from controls.
ShowColor("controlHighlightColor")                  ; Returns the system color used for the highlighted bezels of controls.
ShowColor("controlLightHighlightColor")             ; Returns the system color used for light highlights in controls.
ShowColor("controlShadowColor")                     ; Returns the system color used for the shadows dropped from controls.
ShowColor("controlTextColor")                       ; Returns the system color used for text on controls that aren’t disabled.
ShowColor("disabledControlTextColor")               ; Returns the system color used for text on disabled controls.


ShowColor("clearColor")                             ; Returns an NSColor object whose grayscale and alpha values are both 0.0.


ShowColor("whiteColor")                             ; color names
ShowColor("blackColor")
ShowColor("blueColor")
ShowColor("greenColor")
ShowColor("brownColor")
ShowColor("cyanColor")
ShowColor("grayColor")
ShowColor("lightGrayColor")
ShowColor("darkGrayColor")
ShowColor("magentaColor")
ShowColor("orangeColor")
ShowColor("purpleColor")
ShowColor("redColor")
ShowColor("yellowColor")

    Repeat
      Event = WaitWindowEvent()
     
    Until Event = #PB_Event_CloseWindow
  EndIf
 
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -P-
; EnableXP