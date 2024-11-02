Procedure getcolor( )
  
;   + alternateSelectedControlColor
;   + alternateSelectedControlTextColor
;   + controlBackgroundColor
;   + controlColor
;   + controlAlternatingRowBackgroundColors
;   + controlHighlightColor
;   + controlLightHighlightColor
;   + controlShadowColor
;   + controlDarkShadowColor
;   + controlTextColor
;   + currentControlTint
;   + disabledControlTextColor
;   + gridColor
;   + headerColor
;   + headerTextColor
;   + highlightColor
;   + keyboardFocusIndicatorColor
;   + knobColor
;   + scrollBarColor
;   + secondarySelectedControlColor
;   + selectedControlColor
;   + selectedControlTextColor
;   + selectedMenuItemColor
;   + selectedMenuItemTextColor
;   + selectedTextBackgroundColor
;   + selectedTextColor
;   + selectedKnobColor
;   + shadowColor
;   + textBackgroundColor
;   + textColor
;   + windowBackgroundColor
;   + windowFrameColor
;   + windowFrameTextColor
;   + underPageBackgroundColor

;CompilerCase #PB_OS_MacOS
  Protected ColorName.s, Color.i
  Protected.CGFloat R, G, B, A
;   Select Type
;     Case #GtkGadgetColorBg
      ColorName = "windowBackgroundColor"
;     Case #GtkGadgetColorLight
;       ColorName = "controlHighlightColor"
;   EndSelect
  Color = CocoaMessage(0, 0, "NSColor " + ColorName)
  If Color : Color = CocoaMessage(0, Color, "colorUsingColorSpaceName:$", @"NSDeviceRGBColorSpace") : EndIf
  If Color : CocoaMessage(0, Color, "getRed:", @R, "green:", @G, "blue:", @B, "alpha:", @A) : EndIf
 ;ProcedureReturn RGBA(R * 255, G * 255, B * 255, A * 255)  
   ProcedureReturn RGBA(R * 260, G * 260, B * 260, A * 260)  
;CompilerEndSelect
EndProcedure
Color = getcolor() ;$ff00ff
OpenWindow(0,0,0,300,300,"Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
CanvasGadget(1,100,0,300,300)
CreateImage(2,300,300,32,#PB_Image_Transparent)

StartDrawing(ImageOutput(2))
 DrawingMode(#PB_2DDrawing_AlphaBlend)
 Box(100,100,100,100,RGBA(255,0,0,255))
StopDrawing()

StartDrawing(CanvasOutput(1))
Box(0,0,300,300,Color)
FillMemory( DrawingBuffer( ), 150000, $f0 )

DrawingMode(#PB_2DDrawing_AlphaBlend)
DrawImage(ImageID(2),0,0)
StopDrawing()
Repeat
Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP