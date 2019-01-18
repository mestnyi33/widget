;/////////////////////////////////////////////////////////////////////////////////
;Font ascent / Descent.
;======================
;
;This little prog shows how to use the cross-platform vector lib to calculate the ascents/descents of a given font.
;With this info it is possible to draw text in multiple fonts on a single line sharing a common baseline as we demonstrate.
;
;Platforms : ALL.  Tested on Windows only.
;
;NOTES.
;
;     i)  Oddly, the vector lib returns text metrics (ascent and descent) which do not agree 100% with those returned through GetTextMetrics_().
;         However, the values are nevertheless close enough. Could be due to rounding beings as the vector lib uses floating point values.
;/////////////////////////////////////////////////////////////////////////////////



;The following global records the max ascent of the various fonts we are using. 
;This will allow us to draw a single line of text along a common baseline with multiple fonts etc.
  Global gMaxAscent.d

;The following structure will hold ascent/descent info on each of our fonts.
  Structure fontData
    font.i
    ascent.d
    descent.d
  EndStructure

;We place all our fonts in an array for convenience.
  Dim fonts.fontData(3)
  fonts(1)\font = LoadFont(#PB_Any, "Arial", 42)
  fonts(2)\font = LoadFont(#PB_Any, "Times New Roman", 20, #PB_Font_Italic)
  fonts(3)\font = LoadFont(#PB_Any, "Arial", 30)

Declare GetFontData(Array fonts.fontData(1))

;Calculate font ascents/descents for all of our fonts.
  GetFontData(fonts())

;A quick test to check all is well.
;We simply use DrawText() 3 times (once for each font) to display a single line of repeated text adjusting the vertical position to ensure
;all the text shares the same baseline.
If OpenWindow(0, 0, 0, 800, 400, "Font Data", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 780, 380)
  text$ = "ABCDefghIJK"
  If StartDrawing(CanvasOutput(0))
    ;Draw a single line of text in the various fonts sharing the same baseline.
      DrawingMode(#PB_2DDrawing_Transparent)
      For i = 1 To ArraySize(fonts())      
        DrawingFont(FontID(fonts(i)\font))
        x=DrawText(x, 20 + gMaxAscent - fonts(i)\ascent, text$, 0)
      Next
    ;Draw the baseline.
      Line(0, 20 + gMaxAscent, x, 1, $0000FF)
    StopDrawing()
  EndIf
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

End

;The following procedure calculates all font ascents/descents.
;It uses the vector lib for cross platform purposes.
Procedure GetFontData(Array fonts.fontData(1))
  Protected image, i, TextHeight
  ;Create a dummy image.
    image = CreateImage(#PB_Any, 1, 1)
  If image
    If StartVectorDrawing(ImageVectorOutput(image))
      For i = 1 To ArraySize(fonts())  
        VectorFont(FontID(fonts(i)\font))
        fonts(i)\ascent = VectorTextHeight(" ", #PB_VectorText_Baseline)
        If fonts(i)\ascent > gMaxAscent
          gMaxAscent = fonts(i)\ascent
        EndIf
        fonts(i)\descent = VectorTextHeight(" ") - fonts(i)\ascent
      Next
      StopVectorDrawing()
    EndIf
    FreeImage(image)  
  EndIf
EndProcedure
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP