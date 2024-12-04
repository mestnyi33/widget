;
; **************************************************************
;
;                   Zapman Color Requester
;                         Dec 2024
;
; **************************************************************
;
; https://www.purebasic.fr/english/viewtopic.php?t=85808&sid=88589940fa4c70e687c38b679de08d61
; If your language is not english, look at the ZCR_SetText() procedure
; to translate all strings used in this library.
;
Structure EditColorGadgetsStruct
  EditColorWindow.i
  BackColor.i
  ForeColor.i
  Color.i ; This value will be updated on the fly.
  ;
  ; Layout parameters:
  MarginLeft.i
  MarginRight.i
  MarginTop.i
  MarginBottom.i
  MarginButtonsBottom.i
  HorizGadgetsMargin.i
  LegendWidth.i
  InputWidth.i
  HexColorWidth.i
  HexFieldVPos.i
  ButtonsWidth.i
  ;
  ; Gadgets numbers:
  PreviewCanvas.i
  RainbowCanvas.i
  CanvasDim.i
  TargetGadget.i
  TargetDim.i
  CursorWidth.i
  LineHeight.i
  TrackBarsWidth.i
  ;
  Red_Legend.i
  Green_Legend.i
  Blue_Legend.i
  Red_Input.i
  Green_Input.i
  Blue_Input.i
  Red_Trackbar.i
  Red_Cursor.i
  Green_Trackbar.i
  Green_Cursor.i
  Blue_Trackbar.i
  Blue_Cursor.i
  ;
  Hue_Legend.i
  Sat_Legend.i
  Lum_Legend.i
  Hue_Input.i
  Sat_Input.i
  Lum_Input.i
  Hue_Trackbar.i
  Hue_Cursor.i
  Sat_Trackbar.i
  Sat_Cursor.i
  Lum_Trackbar.i
  Lum_Cursor.i
  ;
  SeparatorGadget1.i
  SeparatorGadget2.i
  ;
  HexColor_Legend.i
  HexColor_Input.i
  BOk.i
  BCancel.i
EndStructure
;
EnumerationBinary
  #DontSetRGBString
  #DontSetRGBTrackBars
  #DontSetHSLString
  #DontSetHexField
EndEnumeration
;
Procedure MinOf3(value1, value2, value3)
  ;
  ; Procedure to find the minimum value among the given arguments
  ;
  Protected result = value1
  ;
  If value2 < result
    result = value2
  EndIf
  If value3 < result
    result = value3
  EndIf
  ProcedureReturn result
EndProcedure
;
Procedure MaxOf3(value1, value2, value3)
  ;
  ; Procedure to find the maximum value among the given arguments
  ;
  Protected result = value1
  ;
  If value2 > result
    result = value2
  EndIf
  If value3 > result
    result = value3
  EndIf
  ProcedureReturn result
EndProcedure
;
Procedure Hue(rgbColor)
  ; Extract the red, green, and blue components  
  Protected red = Red(rgbColor)
  Protected green = Green(rgbColor)
  Protected blue = Blue(rgbColor)
  ;
  ; Find minimum and maximum values among the components
  Protected maxValue = MaxOf3(red, green, blue)
  Protected minValue = MinOf3(red, green, blue)
  ;
  ; Calculate the range (delta)
  Protected delta = maxValue - minValue
  ;
  ; Initialize hue
  Protected hue.f = 0
  ;
  If delta
    ; Calculate hue based on which component is the maximum
    If maxValue = red
      hue = (green - blue) / delta
    ElseIf maxValue = green
      hue = 2.0 + (blue - red) / delta
    Else
      hue = 4.0 + (red - green) / delta
    EndIf
    ;
    ; Scale hue to 0-240 range
    hue * 40
    If hue < 0
      hue + 240
    EndIf
  EndIf
  ;
  ProcedureReturn hue
EndProcedure
;
Procedure Saturation(rgbColor)
  ; Extract the red, green, and blue components  
  Protected red = Red(rgbColor)
  Protected green = Green(rgbColor)
  Protected blue = Blue(rgbColor)
  ;
  Protected saturation.f
  ;
  ; Find minimum and maximum values among the components
  Protected maxValue = MaxOf3(red, green, blue)
  Protected minValue = MinOf3(red, green, blue)
  ;
  ; Calculate the range (delta)
  Protected delta = maxValue - minValue
  ; Calculate lightness (average of max and min)
  Protected lightness.f = (maxValue + minValue) / (2 * 255)
  ;
  If delta
    If lightness < 0.5
      saturation = delta / (maxValue + minValue)
    Else
      saturation = delta / (510 - maxValue - minValue)
    EndIf
  EndIf
  ;
  ProcedureReturn saturation * 240
EndProcedure
;
Procedure Lightness(rgbColor)
  ; Extract the red, green, and blue components  
  Protected red = Red(rgbColor)
  Protected green = Green(rgbColor)
  Protected blue = Blue(rgbColor)
  ;
  ; Find minimum and maximum values among the components
  Protected maxValue = MaxOf3(red, green, blue)
  Protected minValue = MinOf3(red, green, blue)
  ;
  ; Calculate lightness (average of max and min)
  ProcedureReturn 240 * (maxValue + minValue) / (2 * 255)
EndProcedure
;
Procedure.i HSLToRGB(hue.i, saturation.i, lightness.i)
  ; Hue: 0 - 240
  ; Saturation: 0 - 240
  ; Lightness: 0 - 240
  Protected MaxHue = 240
  Protected MaxSL = 240
  ;
  Protected r.f, g.f, b.f
  Protected c.f, X.f, m.f
  ;
  ; Normalize SL values to [0, 1] range
  Protected normalizedSaturation.f = saturation / MaxSL
  Protected normalizedLightness.f = Round(lightness * 100 / MaxSL, #PB_Round_Down) / 100
  ;
  Protected HueSlice = MaxHue / 6
  ;
  ; Calculate intermediary values
  c = (1 - Abs(2 * normalizedLightness - 1)) * normalizedSaturation
  Protected vi = Int(Hue * 1000 / HueSlice) % 2000
  X = c * (1 - Abs(vi/1000 - 1))
  m = normalizedLightness - c / 2
  ;
  ; Determine RGB components based on the hue sector
  Select Int((Hue-1) / HueSlice)
    Case 0 : r = c : g = X : b = 0
    Case 1 : r = X : g = c : b = 0
    Case 2 : r = 0 : g = c : b = X
    Case 3 : r = 0 : g = X : b = c
    Case 4 : r = X : g = 0 : b = c
    Case 5 : r = c : g = 0 : b = X
  EndSelect
  ;
  ; Adjust RGB components to final range [0, 255]
  r = (r + m) * 255
  g = (g + m) * 255
  b = (b + m) * 255
  ;
  ; Return the RGB color
  ProcedureReturn RGB(r, g, b)
EndProcedure
;
Procedure LimitGadgetValue(Gadget, Min, Max)
  Protected Value = Val(GetGadgetText(Gadget))
  If Value > Max Or Value < Min
    If Value > Max : Value = Max : EndIf
    If Value < Min : Value = Min : EndIf
    SetGadgetText(Gadget, Str(Value))
  EndIf
  ProcedureReturn Value
EndProcedure
;
Procedure ColorShiftLum(CUnit)
  If CUnit < 127
    CUnit + 80
  Else
    CUnit - 100
  EndIf
  If CUnit > 200
    CUnit = 200
  EndIf
  If CUnit < 60
    CUnit = 60
  EndIf
  ProcedureReturn Cunit
EndProcedure
;
Procedure InvertedColor(Color)
  ProcedureReturn HSLToRGB(Abs(120 - hue(Color)), 240, ColorShiftLum(lightness(Color)))
EndProcedure
;
Macro DrawTrackBarBox()
  ; Repaint box background:
  Box(0, 0, DesktopScaledX(*ECGadgets\TrackBarsWidth), DesktopScaledY(*ECGadgets\LineHeight), *ECGadgets\BackColor)
  ; Draw trackbar box
  Box(GStart - 1, 0, GWidth + 1, *ECGadgets\LineHeight, *ECGadgets\ForeColor)
  ;
  ; Init graduation counter
  tl = stl
EndMacro
;
Macro DrawOneTrackBarLine(Color)
  X = ct + GStart - 1
  ; Draw color vertical line:
  Line(X, 1, 1, *ECGadgets\LineHeight - 2, Color)
  ; Draw center lines points:
  Plot(X, GHalfHeight - 1, GradColor)
  Plot(X, GHalfHeight + 1, GradColor)
  ; Draw graduations:
  If ct = Int(tl)
    tl + stl
    Line(X, 1, 1, 3, GradColor)
  EndIf
EndMacro
;
Procedure ZCR_DrawTrackbarsAndPreviewCanvas(*ECGadgets.EditColorGadgetsStruct)
  ;
  Protected X, Y, GWidth, GStart, GHalfHeight, GHalfWidth
  Protected Increase.f, Decrease.f, DecreasingGrey, IncreasingWhite
  Protected Red, Green, Blue, Nred, Ngreen, Nblue, RefColor, GradColor, GreyColor
  Protected Saturation, Lightness, Hue
  Protected stl.f, tl.f, ct, ct2, ci
  Protected Trackbar
  ;
  ;
  ; DRAW PREVIEW CANVAS:
  If StartDrawing(CanvasOutput(*ECGadgets\PreviewCanvas))
    Box(0, 0, DesktopScaledX(*ECGadgets\CanvasDim), DesktopScaledY(*ECGadgets\CanvasDim), *ECGadgets\ForeColor)
    Box(1, 1, DesktopScaledX(*ECGadgets\CanvasDim) - 2, DesktopScaledY(*ECGadgets\CanvasDim) - 2, *ECGadgets\Color)
    StopDrawing()
  EndIf
  ;
  ; *********************************************************************
  ;
  ; Initialize some values for trackbars drawing:
  ;
  ; Values for drawing area:
  GWidth  = DesktopScaledX(*ECGadgets\TrackBarsWidth) - *ECGadgets\CursorWidth + 1
  GStart = *ECGadgets\CursorWidth/2
  ; Value for center horizontal lines
  GHalfHeight = *ECGadgets\LineHeight / 2
  ; Values for graduations:
  stl = (GWidth + 1) / 6
  ;
  ; *********************************************************************
  ;
  ; DRAW RGB_Trackbars:
  ;
  If Lightness(*ECGadgets\Color) <60
    GradColor = RGB(160, 160, 160)
  ElseIf Lightness(*ECGadgets\Color) > 130
    GradColor = RGB(140, 140, 50)
  Else
    GradColor = RGB(255, 255, 255)
  EndIf
  ;
  For ci = 1 To 3
    Red = Red(*ECGadgets\Color)
    Green = Green(*ECGadgets\Color)
    Blue = Blue(*ECGadgets\Color)
    If ci = 1 : Trackbar = *ECGadgets\Red_Trackbar
    ElseIf ci = 2 : Trackbar = *ECGadgets\Green_Trackbar
    ElseIf ci = 3 : Trackbar = *ECGadgets\Blue_Trackbar
    EndIf
    If StartDrawing(CanvasOutput(Trackbar))
      ;
      DrawTrackBarBox()
      ;
      For ct = 1 To GWidth - 1
        If ci = 1 : Red = ct * 255 / GWidth
        ElseIf ci = 2 : Green = ct * 255 / GWidth
        ElseIf ci = 3 : Blue = ct * 255 / GWidth
        EndIf
        DrawOneTrackBarLine(RGB(Red, Green, Blue))
      Next
      StopDrawing()
    EndIf
  Next
  ;
  ; *********************************************************************
  ;
  ; DRAW Hue_Trackbar:
  ;
  If StartDrawing(CanvasOutput(*ECGadgets\Hue_Trackbar))
    ;
    Saturation = Saturation(*ECGadgets\Color)
    Lightness = Lightness(*ECGadgets\Color)
    ;
    DrawTrackBarBox()

    GradColor = HSLToRGB(120, 120, ColorShiftLum(Lightness))
    ;
    For ct = 1 To GWidth - 1
      Hue = ct * 240 / GWidth
      DrawOneTrackBarLine(HSLToRGB(Hue, Saturation, Lightness))
    Next
    StopDrawing()
  EndIf
  ;
  ; *********************************************************************
  ;
  ; DRAW Lum_Trackbar:
  ;
  If StartDrawing(CanvasOutput(*ECGadgets\Lum_Trackbar))
    ;
    ; Calculate color with a half luminosity:
    RefColor = HSLToRGB(LimitGadgetValue(*ECGadgets\Hue_Input, 0, 240), LimitGadgetValue(*ECGadgets\Sat_Input, 0, 240), 120)
    ;
    DrawTrackBarBox()

    Red = Red(RefColor)
    Green = Green(RefColor)
    Blue = Blue(RefColor)
    GradColor = RGB(127, 127, 127)
    GHalfWidth = GWidth / 2
    ;
    For ct = 1 To GWidth - 1
      If ct < GHalfWidth
        Increase.f = ct / GHalfWidth
        NRed   = Red   * Increase
        NGreen = Green * Increase
        NBlue  = Blue  * Increase
      Else
        ct2 = ct - GHalfWidth
        IncreasingWhite = 255 * ct2 / GHalfWidth
        Decrease.f = (GHalfWidth - ct2) / GHalfWidth
        NRed   = Red   * Decrease + IncreasingWhite
        NGreen = Green * Decrease + IncreasingWhite
        NBlue  = Blue  * Decrease + IncreasingWhite
      EndIf
      ;
      DrawOneTrackBarLine(RGB(Nred, Ngreen, Nblue))
      ;
    Next
    StopDrawing()
  EndIf
  ;
  ; *********************************************************************
  ;
  ; DRAW Sat_Trackbar:
  ;
  If StartDrawing(CanvasOutput(*ECGadgets\Sat_Trackbar))
    ;
    ; Calculate color with a full saturation:
    RefColor = HSLToRGB(LimitGadgetValue(*ECGadgets\Hue_Input, 0, 240), 240, LimitGadgetValue(*ECGadgets\Lum_Input, 0, 240) + 1)
    ;
    DrawTrackBarBox()
    
    Red = Red(RefColor)
    Green = Green(RefColor)
    Blue = Blue(RefColor)
    GradColor = InvertedColor(RefColor)
    GreyColor = LimitGadgetValue(*ECGadgets\Lum_Input, 0, 240) * 255 / 240
    ;
    For ct = 1 To GWidth - 1
      Increase.f = ct / GWidth
      DecreasingGrey = GreyColor * (GWidth - ct) / GWidth
      Nred   = (Red   * Increase) + DecreasingGrey
      Ngreen = (Green * Increase) + DecreasingGrey
      Nblue  = (Blue  * Increase) + DecreasingGrey
      ;
      DrawOneTrackBarLine(RGB(Nred, Ngreen, Nblue))
      ;
    Next
    StopDrawing()
  EndIf
  ;
  X = GadgetX(*ECGadgets\RainbowCanvas) + LimitGadgetValue(*ECGadgets\Hue_Input, 0, 240) * *ECGadgets\CanvasDim / 240 - DesktopUnscaledX(*ECGadgets\TargetDim/2)
  Y = GadgetY(*ECGadgets\RainbowCanvas) + (240 - LimitGadgetValue(*ECGadgets\Lum_Input, 0, 240)) * *ECGadgets\CanvasDim / 240 - DesktopUnscaledY(*ECGadgets\TargetDim/2)
  ResizeGadget(*ECGadgets\TargetGadget, X, Y, #PB_Ignore, #PB_Ignore)
EndProcedure
;
Procedure ZCR_SetHexFieldFromColor(*ECGadgets.EditColorGadgetsStruct)
  Protected HStr$ = Hex(*ECGadgets\Color, #PB_Long)
  While Len(HStr$) < 6 : HStr$ = "0" + HStr$ : Wend
  SetGadgetText(*ECGadgets\HexColor_Input, HStr$)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    SendMessage_(GadgetID(*ECGadgets\HexColor_Input), #EM_SETSEL, Len(HStr$), Len(HStr$))
  CompilerEndIf
EndProcedure
;
Procedure ZCR_DrawRainbowCanvas(*ECGadgets.EditColorGadgetsStruct)
  ;
  Protected ColorWidth, ColorHeight, HalfColorHeight
  Protected cx, X, cy, cy2, Y
  Protected DecreasingWhite, RefColor, Decrease.f, Increase.f
  Protected NRed, NGreen, NBlue
  Protected Saturation, Lightness, Hue, Red, Green, Blue
  ;
  Saturation = Val(GetGadgetText(*ECGadgets\Sat_Input))
  Lightness = 120
  ;
  If StartDrawing(CanvasOutput(*ECGadgets\RainbowCanvas))
    Box(0, 0, DesktopScaledX(*ECGadgets\CanvasDim), DesktopScaledY(*ECGadgets\CanvasDim), *ECGadgets\ForeColor)
    ColorWidth = (DesktopScaledX(*ECGadgets\CanvasDim) - 2) * 20 - 20
    ColorHeight = (DesktopScaledY(*ECGadgets\CanvasDim) - 2) * 20
    HalfColorHeight = ColorHeight / 2
    ;
    For cx = 0 To ColorWidth Step 20
      ;
      Hue = cx * 239 / ColorWidth
      RefColor = HSLToRGB(Hue, Saturation, Lightness)
      Red = Red(RefColor)
      Green = Green(RefColor)
      Blue = Blue(RefColor)
      ;
      X = (cx / 20) + 1
      For cy = 0 To ColorHeight Step 20
        Y = (cy / 20) + 1
        If cy < HalfColorHeight
          DecreasingWhite = 255 * (HalfColorHeight - cy) / HalfColorHeight
          Increase.f = cy / HalfColorHeight
          NRed   = Red   * Increase + DecreasingWhite
          NGreen = Green * Increase + DecreasingWhite
          NBlue  = Blue  * Increase + DecreasingWhite
        Else
          cy2 = cy - HalfColorHeight
          Decrease.f = (HalfColorHeight - cy2) / HalfColorHeight
          NRed   = Red   * Decrease
          NGreen = Green * Decrease
          NBlue  = Blue  * Decrease
        EndIf
        Plot(X, Y, RGB(Nred, Ngreen, Nblue))
      Next
    Next
    StopDrawing()
  EndIf
EndProcedure
;
Procedure ZCR_SetRGBStringsFromColor(*ECGadgets.EditColorGadgetsStruct)
  SetGadgetText(*ECGadgets\Red_Input, Str(Red(*ECGadgets\Color)))
  SetGadgetText(*ECGadgets\Green_Input, Str(Green(*ECGadgets\Color)))
  SetGadgetText(*ECGadgets\Blue_Input, Str(Blue(*ECGadgets\Color)))
EndProcedure
;
Procedure ZCR_SetHSLStringsFromColor(*ECGadgets.EditColorGadgetsStruct)
  SetGadgetText(*ECGadgets\Hue_Input, Str(Hue(*ECGadgets\Color)))
  SetGadgetText(*ECGadgets\Sat_Input, Str(Saturation(*ECGadgets\Color)))
  SetGadgetText(*ECGadgets\Lum_Input, Str(Lightness(*ECGadgets\Color)))
EndProcedure
;
Procedure ZCR_SetCursor(CanvasGadget, Value, *ECGadgets.EditColorGadgetsStruct)
  ;
  Protected CursorGadget, MaxValue, UWidth, X, Y
  ;
  If CanvasGadget = *ECGadgets\Red_Trackbar
    CursorGadget = *ECGadgets\Red_Cursor
    MaxValue = 255
  ElseIf CanvasGadget = *ECGadgets\Green_Trackbar
    CursorGadget = *ECGadgets\Green_Cursor
    MaxValue = 255
  ElseIf CanvasGadget = *ECGadgets\Blue_Trackbar
    CursorGadget = *ECGadgets\Blue_Cursor
    MaxValue = 255
  ElseIf CanvasGadget = *ECGadgets\Hue_Trackbar
    CursorGadget = *ECGadgets\Hue_Cursor
    MaxValue = 240
  ElseIf CanvasGadget = *ECGadgets\Sat_Trackbar
    CursorGadget = *ECGadgets\Sat_Cursor
    MaxValue = 240
  ElseIf CanvasGadget = *ECGadgets\Lum_Trackbar
    CursorGadget = *ECGadgets\Lum_Cursor
    MaxValue = 240
  EndIf
  UWidth = GadgetWidth(CanvasGadget) - DesktopUnscaledX(*ECGadgets\CursorWidth)
  X = GadgetX(CanvasGadget) + (Value * UWidth / MaxValue)
  Y = GadgetY(CanvasGadget)
  ResizeGadget(CursorGadget, X, Y, #PB_Ignore, #PB_Ignore)
EndProcedure
;
Procedure ZCR_SetTrackBarsFromStrings(*ECGadgets.EditColorGadgetsStruct)
  ZCR_SetCursor(*ECGadgets\Red_Trackbar, Val(GetGadgetText(*ECGadgets\Red_Input)), *ECGadgets)
  ZCR_SetCursor(*ECGadgets\Green_Trackbar, Val(GetGadgetText(*ECGadgets\Green_Input)), *ECGadgets)
  ZCR_SetCursor(*ECGadgets\Blue_Trackbar, Val(GetGadgetText(*ECGadgets\Blue_Input)), *ECGadgets)
  ZCR_SetCursor(*ECGadgets\Hue_Trackbar, Val(GetGadgetText(*ECGadgets\Hue_Input)), *ECGadgets)
  ZCR_SetCursor(*ECGadgets\Lum_Trackbar, Val(GetGadgetText(*ECGadgets\Lum_Input)), *ECGadgets)
  ZCR_SetCursor(*ECGadgets\Sat_Trackbar, Val(GetGadgetText(*ECGadgets\Sat_Input)), *ECGadgets)
EndProcedure
;
Procedure ZCR_SetGadgetsFromColor(*ECGadgets.EditColorGadgetsStruct, DontSet = 0)
  If DontSet & #DontSetRGBString = 0
    ZCR_SetRGBStringsFromColor(*ECGadgets)
  EndIf
  If DontSet & #DontSetHSLString = 0
    ZCR_SetHSLStringsFromColor(*ECGadgets)
  EndIf
  If DontSet & #DontSetHexField = 0
    ZCR_SetHexFieldFromColor(*ECGadgets)
  EndIf
  ZCR_DrawTrackbarsAndPreviewCanvas(*ECGadgets)
  ZCR_DrawRainbowCanvas(*ECGadgets)
  ZCR_SetTrackBarsFromStrings(*ECGadgets.EditColorGadgetsStruct)
EndProcedure
;
Procedure ZCR_ResizeGadgets()
  ;
  Shared ECGadgets.EditColorGadgetsStruct
  ;
  Protected HexFieldVPos
  ;
  Protected TextHeight = ECGadgets\LineHeight / DesktopResolutionY()
  Protected ButtonHeight = TextHeight + 3
  ;
  ; Reserve room for the Cancel & OK buttons:
  ;
  If ECGadgets\MarginBottom = 0
    ECGadgets\MarginBottom = 2*ECGadgets\MarginButtonsBottom + ButtonHeight
  EndIf
  ;
  ; Calculate available area for all gadgets:
  ;
  Protected AreaHeight = WindowHeight(ECGadgets\EditColorWindow) - ECGadgets\MarginTop - ECGadgets\MarginBottom
  Protected AreaWidth = WindowWidth(ECGadgets\EditColorWindow) - ECGadgets\MarginLeft - ECGadgets\MarginRight
  ;
  ; Calculate general values for gadgets:
  ;
  Protected HorizLineShift = 3 ; Shift value for horizontal lines.
  Protected InterLine = (AreaHeight - 2 * TextHeight + (2 * HorizLineShift)) / 4.75
  ;
  ECGadgets\CanvasDim = InterLine * 2 + TextHeight
  ECGadgets\TrackBarsWidth = AreaWidth - ECGadgets\LegendWidth - ECGadgets\InputWidth - ECGadgets\CanvasDim - (ECGadgets\HorizGadgetsMargin * 3)
  ;
  Protected VPos = ECGadgets\MarginTop
  ;
  Protected LegendHPos = ECGadgets\MarginLeft
  Protected InputHPos = LegendHPos + ECGadgets\LegendWidth + ECGadgets\HorizGadgetsMargin
  Protected TrackBarHPos = InputHPos + ECGadgets\InputWidth + ECGadgets\HorizGadgetsMargin
  Protected CanvasHPos = TrackBarHPos + ECGadgets\TrackBarsWidth + ECGadgets\HorizGadgetsMargin
  ;
  ResizeGadget(ECGadgets\PreviewCanvas, CanvasHPos, VPos - 2, ECGadgets\CanvasDim * DesktopResolutionX() / DesktopResolutionY(), ECGadgets\CanvasDim)
  ;
  ResizeGadget(ECGadgets\Red_Legend, LegendHPos, VPos, ECGadgets\LegendWidth, TextHeight)
  ResizeGadget(ECGadgets\Red_Input, InputHPos, VPos - 2, ECGadgets\InputWidth, TextHeight)
  ResizeGadget(ECGadgets\Red_Trackbar, TrackBarHPos, VPos-2, ECGadgets\TrackBarsWidth, TextHeight)
  ;
  VPos + InterLine
  ResizeGadget(ECGadgets\Green_Legend, LegendHPos, VPos, ECGadgets\LegendWidth, TextHeight)
  ResizeGadget(ECGadgets\Green_Input, InputHPos, VPos - 2, ECGadgets\InputWidth, TextHeight)
  ResizeGadget(ECGadgets\Green_Trackbar, TrackBarHPos, VPos-2, ECGadgets\TrackBarsWidth, TextHeight)
  ;
  VPos + InterLine
  ResizeGadget(ECGadgets\Blue_Legend, LegendHPos, VPos, ECGadgets\LegendWidth, TextHeight)
  ResizeGadget(ECGadgets\Blue_Input, InputHPos, VPos - 2, ECGadgets\InputWidth, TextHeight)
  ResizeGadget(ECGadgets\Blue_Trackbar, TrackBarHPos, VPos-2, ECGadgets\TrackBarsWidth, TextHeight)
  ;
  VPos + TextHeight - HorizLineShift + InterLine * 0.25
  ResizeGadget(ECGadgets\SeparatorGadget1, ECGadgets\MarginLeft, VPos, AreaWidth, 1) ; Draw a horizontal line
  If StartDrawing(CanvasOutput(ECGadgets\SeparatorGadget1))
    Box(0, 0, DesktopScaledX(GadgetWidth(ECGadgets\SeparatorGadget1)), DesktopScaledY(GadgetHeight(ECGadgets\SeparatorGadget1)), ECGadgets\ForeColor)
    StopDrawing()
  EndIf
  ;
  VPos + InterLine * 0.25 + HorizLineShift
  ResizeGadget(ECGadgets\RainbowCanvas, TrackBarHPos + ECGadgets\TrackBarsWidth + ECGadgets\HorizGadgetsMargin, VPos - 2, ECGadgets\CanvasDim * DesktopResolutionX() / DesktopResolutionY(), ECGadgets\CanvasDim)
  ResizeGadget(ECGadgets\TargetGadget, TrackBarHPos + ECGadgets\TrackBarsWidth + ECGadgets\HorizGadgetsMargin, VPos, ECGadgets\TargetDim, ECGadgets\TargetDim)
  ;
  ResizeGadget(ECGadgets\Hue_Legend, LegendHPos, VPos, ECGadgets\LegendWidth, TextHeight)
  ResizeGadget(ECGadgets\Hue_Input, InputHPos, VPos - 2, ECGadgets\InputWidth, TextHeight)
  ResizeGadget(ECGadgets\Hue_Trackbar, TrackBarHPos, VPos-2, ECGadgets\TrackBarsWidth, TextHeight)
  ;
  VPos + InterLine
  ResizeGadget(ECGadgets\Lum_Legend, LegendHPos, VPos, ECGadgets\LegendWidth, TextHeight)
  ResizeGadget(ECGadgets\Lum_Input, InputHPos, VPos - 2, ECGadgets\InputWidth, TextHeight)
  ResizeGadget(ECGadgets\Lum_Trackbar, TrackBarHPos, VPos-2, ECGadgets\TrackBarsWidth, TextHeight)
  ;
  VPos + InterLine
  ResizeGadget(ECGadgets\Sat_Legend, LegendHPos, VPos, ECGadgets\LegendWidth, TextHeight)
  ResizeGadget(ECGadgets\Sat_Input, InputHPos, VPos - 2, ECGadgets\InputWidth, TextHeight)
  ResizeGadget(ECGadgets\Sat_Trackbar, TrackBarHPos, VPos-2, ECGadgets\TrackBarsWidth, TextHeight)
  ;
  VPos + TextHeight - HorizLineShift + InterLine * 0.25
  ;
  ResizeGadget(ECGadgets\SeparatorGadget2, ECGadgets\MarginLeft, VPos, AreaWidth, 1) ; Draw a horizontal line
  If StartDrawing(CanvasOutput(ECGadgets\SeparatorGadget2))
    Box(0, 0, DesktopScaledX(GadgetWidth(ECGadgets\SeparatorGadget1)), DesktopScaledY(GadgetHeight(ECGadgets\SeparatorGadget1)), ECGadgets\ForeColor)
    StopDrawing()
  EndIf
  ;
  ; 'Cancel' and 'OK' buttons:
  ;
  VPos = WindowHeight(ECGadgets\EditColorWindow) - ECGadgets\MarginButtonsBottom - TextHeight - 3 * DesktopResolutionX()
  ;
  If ECGadgets\HexFieldVPos = -1
    HexFieldVPos = VPos + 1
  Else
    HexFieldVPos = ECGadgets\HexFieldVPos
  EndIf
  ;
  ResizeGadget(ECGadgets\HexColor_Legend, ECGadgets\MarginLeft, HexFieldVPos + 1, ECGadgets\LegendWidth, TextHeight)
  ResizeGadget(ECGadgets\HexColor_Input, ECGadgets\MarginLeft + ECGadgets\LegendWidth + ECGadgets\HorizGadgetsMargin, HexFieldVPos, ECGadgets\HexColorWidth, TextHeight)
  ResizeGadget(ECGadgets\BCancel, WindowWidth(ECGadgets\EditColorWindow) - ECGadgets\MarginRight - 2 * ECGadgets\ButtonsWidth - ECGadgets\HorizGadgetsMargin, VPos, ECGadgets\ButtonsWidth, ButtonHeight)
  ResizeGadget(ECGadgets\BOk, WindowWidth(ECGadgets\EditColorWindow) - ECGadgets\MarginRight - ECGadgets\ButtonsWidth, VPos, ECGadgets\ButtonsWidth, ButtonHeight)
  ;
  ZCR_DrawRainbowCanvas(ECGadgets)
  ZCR_DrawTrackbarsAndPreviewCanvas(ECGadgets)
  ZCR_SetTrackBarsFromStrings(ECGadgets)
  ;
EndProcedure
;
Procedure ZCR_SetText()
  ;
  Shared ECGadgets.EditColorGadgetsStruct
  ;
  SetGadgetText(ECGadgets\Red_Legend,   "Red:")
  SetGadgetText(ECGadgets\Green_Legend, "Green:")
  SetGadgetText(ECGadgets\Blue_Legend,  "Blue:")
  ;
  SetGadgetText(ECGadgets\Hue_Legend, "Hue:")
  SetGadgetText(ECGadgets\Sat_Legend, "Saturation:")
  SetGadgetText(ECGadgets\Lum_Legend, "Lightness:")
  ;
  SetGadgetText(ECGadgets\HexColor_Legend, "Hex value:")
  SetGadgetText(ECGadgets\BCancel, "Cancel")
  SetGadgetText(ECGadgets\BOk, "OK")
  ;
  GadgetToolTip(ECGadgets\RainbowCanvas, "Click to adjust color. Use the mouse wheel to adjust saturation.")
  ;
EndProcedure
;
Procedure ZCR_CreateGadgets()
  ;
  Shared ECGadgets.EditColorGadgetsStruct
  ;
  If ECGadgets\BackColor = -1
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ECGadgets\BackColor = GetSysColor_(#COLOR_BTNFACE)
    CompilerElse
      ECGadgets\BackColor = RGB(255, 255, 255)
    CompilerEndIf
  EndIf
  ;
  ECGadgets\PreviewCanvas = CanvasGadget(#PB_Any, 1, 1, 1, 1) ; Preview Color
  ;
  ECGadgets\Red_Legend = TextGadget(#PB_Any, 1, 1, 1, 1, "")
  ECGadgets\Red_Input = StringGadget(#PB_Any, 1, 1, 1, 1, "", #PB_String_Numeric)
  ECGadgets\Red_Trackbar = CanvasGadget(#PB_Any, 1, 1, 1, 1)
  ;
  ECGadgets\Green_Legend = TextGadget(#PB_Any, 1, 1, 1, 1, "")
  ECGadgets\Green_Input = StringGadget(#PB_Any, 1, 1, 1, 1, "", #PB_String_Numeric)
  ECGadgets\Green_Trackbar = CanvasGadget(#PB_Any, 1, 1, 1, 1)
  ;
  ECGadgets\Blue_Legend = TextGadget(#PB_Any, 1, 1, 1, 1, "")
  ECGadgets\Blue_Input = StringGadget(#PB_Any, 1, 1, 1, 1, "", #PB_String_Numeric)
  ECGadgets\Blue_Trackbar = CanvasGadget(#PB_Any, 1, 1, 1, 1)
  ;
  ECGadgets\SeparatorGadget1 = CanvasGadget(#PB_Any, 1, 1, 1, 1)
  ;
  ECGadgets\RainbowCanvas = CanvasGadget(#PB_Any, 1, 1, 1, 1) ; Preview Color
  ;
  ECGadgets\Hue_Legend = TextGadget(#PB_Any, 1, 1, 1, 1, "")
  ECGadgets\Hue_Input = StringGadget(#PB_Any, 1, 1, 1, 1, "", #PB_String_Numeric)
  ECGadgets\Hue_Trackbar = CanvasGadget(#PB_Any, 1, 1, 1, 1)
  ;
  ECGadgets\Lum_Legend = TextGadget(#PB_Any, 1, 1, 1, 1, "")
  ECGadgets\Lum_Input = StringGadget(#PB_Any, 1, 1, 1, 1, "", #PB_String_Numeric)
  ECGadgets\Lum_Trackbar = CanvasGadget(#PB_Any, 1, 1, 1, 1)
  ;
  ECGadgets\Sat_Legend = TextGadget(#PB_Any, 1, 1, 1, 1, "")
  ECGadgets\Sat_Input = StringGadget(#PB_Any, 1, 1, 1, 1, "", #PB_String_Numeric)
  ECGadgets\Sat_Trackbar = CanvasGadget(#PB_Any, 1, 1, 1, 1)
  ;
  ECGadgets\SeparatorGadget2 = CanvasGadget(#PB_Any, 1, 1, 1, 1)
  ;
  ECGadgets\HexColor_Legend = TextGadget(#PB_Any, 1, 1, 1, 1, "")
  ECGadgets\HexColor_Input = StringGadget(#PB_Any, 1, 1, 1, 1, "")
  ;
  ECGadgets\BCancel = ButtonGadget(#PB_Any, 1, 1, 1, 22, "")
  ECGadgets\BOk = ButtonGadget(#PB_Any, 1, 1, 1, 22, "")
EndProcedure
;
Procedure ZCR_CreateTargetAndCursors()
  ;
  Shared ECGadgets.EditColorGadgetsStruct
  ;
  Protected TargetImage, CursorImage, ct
  ;
  TargetImage  = CreateImage(#PB_Any, ECGadgets\TargetDim, ECGadgets\TargetDim, 32, #PB_Image_Transparent)
  If StartVectorDrawing(ImageVectorOutput(TargetImage))
    AddPathCircle(ECGadgets\TargetDim/2, ECGadgets\TargetDim/2, ECGadgets\TargetDim/2 - 2)
    ClosePath()
    VectorSourceColor(RGBA(120, 120, 120, 255))
    StrokePath(1)
    AddPathCircle(ECGadgets\TargetDim/2, ECGadgets\TargetDim/2, ECGadgets\TargetDim/2 - 3)
    ClosePath()
    VectorSourceColor(RGBA(255, 255, 255, 255))
    StrokePath(1)
    StopVectorDrawing()
  EndIf
  ECGadgets\TargetGadget = ImageGadget(#PB_Any, 1, 1, 1, 1, ImageID(TargetImage))
  ;
  CursorImage  = CreateImage(#PB_Any, ECGadgets\CursorWidth, ECGadgets\LineHeight, 32, #PB_Image_Transparent)
  If StartVectorDrawing(ImageVectorOutput(CursorImage))
    For ct = 1 To 3
      MovePathCursor(ECGadgets\CursorWidth/2 - ct + 2, 3)
      AddPathLine(ECGadgets\CursorWidth/2 - ct + 2, ECGadgets\LineHeight - 3)
      ClosePath()
      If ct = 2
        VectorSourceColor(RGBA(255, 255, 255, 255))
      Else
        VectorSourceColor(RGBA(120, 120, 120, 255))
      EndIf
      StrokePath(1)
    Next
    AddPathCircle(ECGadgets\CursorWidth/2, ECGadgets\LineHeight/2, ECGadgets\TargetDim/2 - 2)
    ClosePath()
    VectorSourceColor(RGBA(120, 120, 120, 255))
    StrokePath(1)
    AddPathCircle(ECGadgets\CursorWidth/2, ECGadgets\LineHeight/2, ECGadgets\TargetDim/2 - 3)
    ClosePath()
    VectorSourceColor(RGBA(255, 255, 255, 255))
    StrokePath(1)
    StopVectorDrawing()
  EndIf
  ECGadgets\Red_Cursor   = ImageGadget(#PB_Any, 1, 1, 1, 1, ImageID(CursorImage))
  ECGadgets\Green_Cursor = ImageGadget(#PB_Any, 1, 1, 1, 1, ImageID(CursorImage))
  ECGadgets\Blue_Cursor  = ImageGadget(#PB_Any, 1, 1, 1, 1, ImageID(CursorImage))
  ECGadgets\Hue_Cursor   = ImageGadget(#PB_Any, 1, 1, 1, 1, ImageID(CursorImage))
  ECGadgets\Lum_Cursor   = ImageGadget(#PB_Any, 1, 1, 1, 1, ImageID(CursorImage))
  ECGadgets\Sat_Cursor   = ImageGadget(#PB_Any, 1, 1, 1, 1, ImageID(CursorImage))
EndProcedure
;
Procedure ZCR_SetFieldsSizeAndMargins()
  ;
  Shared ECGadgets.EditColorGadgetsStruct
  ;
  Protected LegendHeight, HexColorWidth, InputWidth, tx$, LegendWidth, MarginCircular
  ;
  ; Here, an identical margin is set for the forth sides of the window.
  ; But you can adjust these values if you want to add some gadgets
  ; inside the window.
  MarginCircular = 15
  ECGadgets\MarginButtonsBottom = MarginCircular
  ECGadgets\MarginLeft = MarginCircular
  ECGadgets\MarginRight = MarginCircular
  ECGadgets\MarginTop = MarginCircular
  ECGadgets\HexFieldVPos = -1      ; Vertical position of the 'Hexa value' fields (-1 is at the bottom of the window).
  ECGadgets\HorizGadgetsMargin = 5 ; Vertical margins between gadgets.
  ;
  ECGadgets\TargetDim = 10     ; Width of the moving target over the rainbow canvas.
  ECGadgets\CursorWidth = 10   ; Width of the moving cursors over trackbars.
  ;
  ; Examine texts width and height
  If StartDrawing(WindowOutput(ECGadgets\EditColorWindow))
    DrawingFont(GetGadgetFont(#PB_Default))
    LegendHeight  = TextHeight("A")                        ; Memorize the text height.
    HexColorWidth = TextWidth("1234567890ABCDEF") * 6 / 16 ; Calculate the average width for 6 hexa chars.
    InputWidth = TextWidth("1234567890") * 3 / 10          ; Calculate the average width for 3 numeric chars.
    ;
    ; Look for the maximum legend width
    tx$ = GetGadgetText(ECGadgets\Red_Legend)
    LegendWidth   = TextWidth(tx$)
    tx$ = GetGadgetText(ECGadgets\Green_Legend)
    If TextWidth(tx$) > LegendWidth : LegendWidth = TextWidth(tx$) : EndIf
    tx$ = GetGadgetText(ECGadgets\Blue_Legend)
    If TextWidth(tx$) > LegendWidth : LegendWidth = TextWidth(tx$) : EndIf
    tx$ = GetGadgetText(ECGadgets\Hue_Legend)
    If TextWidth(tx$) > LegendWidth : LegendWidth = TextWidth(tx$) : EndIf
    tx$ = GetGadgetText(ECGadgets\Sat_Legend)
    If TextWidth(tx$) > LegendWidth : LegendWidth = TextWidth(tx$) : EndIf
    tx$ = GetGadgetText(ECGadgets\Lum_Legend)
    If TextWidth(tx$) > LegendWidth : LegendWidth = TextWidth(tx$) : EndIf
    tx$ = GetGadgetText(ECGadgets\HexColor_Legend)
    If TextWidth(tx$) > LegendWidth : LegendWidth = TextWidth(tx$) : EndIf
    StopDrawing()
  EndIf
  ;
  ECGadgets\LegendWidth = LegendWidth / DesktopResolutionX() + 5      ; This value set the width of 'Red', 'Green', Blue', 'Hue', Lightness', 'Saturation' and 'Hex value' legends.
  ECGadgets\LineHeight = LegendHeight + 5      ; Height of one line.
  ECGadgets\InputWidth = InputWidth / DesktopResolutionX() + 10       ; Width of all input fields (except the 'Hex value' input field).
  ECGadgets\HexColorWidth = HexColorWidth / DesktopResolutionX() + 10 ; Width of the 'Hex value' input field.
  ECGadgets\ButtonsWidth = 80                  ; Change this value to modify the width of 'OK' and 'Cancel' buttons.
  ;
EndProcedure
;
Procedure ZCR_TrackBarEvents(MouseButton, EventType, InputGadget, CanvasGadget, *ECGadgets.EditColorGadgetsStruct)
  ;
  Protected Value, localX, DontSet, VMax
  ;
  If EventType = #PB_EventType_MouseWheel Or MouseButton = #PB_EventType_LeftButtonDown
    Select InputGadget
      Case *ECGadgets\Red_Input, *ECGadgets\Green_Input, *ECGadgets\Blue_Input
        VMax = 255
        DontSet = #DontSetRGBString
      Case *ECGadgets\Hue_Input
        VMax = 239
        DontSet = #DontSetHSLString
      Case *ECGadgets\Lum_Input, *ECGadgets\Sat_Input
        VMax = 240
        DontSet = #DontSetHSLString
    EndSelect
    ;
    If EventType = #PB_EventType_MouseWheel
      Value = Val(GetGadgetText(InputGadget)) + GetGadgetAttribute(CanvasGadget, #PB_Canvas_WheelDelta) * 4
      If Value > VMax : Value = VMax : EndIf
      If Value < 0 : Value = 0 : EndIf
    EndIf
    If MouseButton = #PB_EventType_LeftButtonDown
      localX = GetGadgetAttribute(CanvasGadget, #PB_Canvas_MouseX)
      ;
      If localX > DesktopScaledX(GadgetWidth(CanvasGadget))
        localX = DesktopScaledX(GadgetWidth(CanvasGadget))
      ElseIf localX < 0
        localX = 0
      EndIf
      ;
      Value = localX / DesktopResolutionX() * VMax / GadgetWidth(CanvasGadget)
    EndIf
    If Val(GetGadgetText(InputGadget)) <> Value
      SetGadgetText(InputGadget, Str(Value))
      If DontSet = #DontSetHSLString
        *ECGadgets\Color = HSLToRGB(Val(GetGadgetText(*ECGadgets\Hue_Input)), Val(GetGadgetText(*ECGadgets\Sat_Input)), Val(GetGadgetText(*ECGadgets\Lum_Input)))
      Else
        *ECGadgets\Color = RGB(Val(GetGadgetText(*ECGadgets\Red_Input)), Val(GetGadgetText(*ECGadgets\Green_Input)), Val(GetGadgetText(*ECGadgets\Blue_Input)))
      EndIf
      ;
      ZCR_SetGadgetsFromColor(*ECGadgets, DontSet)
    EndIf
  EndIf
EndProcedure
;
Procedure ZCR_Events(Event, EventType, InitialColor)
  ;
  Shared ECGadgets.EditColorGadgetsStruct
  ;
  Static MouseButton, CanvasXDim, CanvasYDim
  ;
  Protected Red, Green, Blue, Saturation, Hue, Lightness
  Protected HStr$, mHStr$, ct, CChar$, localX, localY, GetOut
  ;
  If EventType = #PB_EventType_LeftButtonDown Or EventType = #PB_EventType_LeftButtonUp
    MouseButton = EventType
  EndIf
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case ECGadgets\HexColor_Input
          HStr$ = UCase(GetGadgetText(ECGadgets\HexColor_Input))
          If HStr$
            mHStr$ = HStr$
            For ct = 1 To Len(HStr$)
              CChar$ = Mid(HStr$, ct, 1)
              If FindString("0123456789ABCDEF", CCHar$) = 0
                HStr$ = ReplaceString(HStr$, CChar$, "")
                ct - 1
              EndIf
            Next
            If HStr$ <> mHStr$
              SetGadgetText(ECGadgets\HexColor_Input, HStr$)
              CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                SendMessage_(GadgetID(ECGadgets\HexColor_Input), #EM_SETSEL, Len(HStr$), Len(HStr$))
              CompilerEndIf
            EndIf
            ECGadgets\Color = Val("$" + HStr$)
            ZCR_SetGadgetsFromColor(ECGadgets, #DontSetHexField)
          EndIf
          ;
        Case ECGadgets\Red_Trackbar
          ZCR_TrackBarEvents(MouseButton, EventType, ECGadgets\Red_Input, ECGadgets\Red_Trackbar, ECGadgets)
          ;
        Case ECGadgets\Green_Trackbar
          ZCR_TrackBarEvents(MouseButton, EventType, ECGadgets\Green_Input, ECGadgets\Green_Trackbar, ECGadgets)
          ;
        Case ECGadgets\Blue_Trackbar
          ZCR_TrackBarEvents(MouseButton, EventType, ECGadgets\Blue_Input, ECGadgets\Blue_Trackbar, ECGadgets)
          ;
        Case ECGadgets\Hue_Trackbar
          ZCR_TrackBarEvents(MouseButton, EventType, ECGadgets\Hue_Input, ECGadgets\Hue_Trackbar, ECGadgets)
          ;
        Case ECGadgets\Lum_Trackbar
          ZCR_TrackBarEvents(MouseButton, EventType, ECGadgets\Lum_Input, ECGadgets\Lum_Trackbar, ECGadgets)
          ;
        Case ECGadgets\Sat_Trackbar
          ZCR_TrackBarEvents(MouseButton, EventType, ECGadgets\Sat_Input, ECGadgets\Sat_Trackbar, ECGadgets)
          ;
        Case ECGadgets\RainbowCanvas
          If EventType = #PB_EventType_MouseWheel Or MouseButton = #PB_EventType_LeftButtonDown
            Saturation = LimitGadgetValue(ECGadgets\Sat_Input, 0, 240)
            If EventType = #PB_EventType_MouseWheel
              Saturation + GetGadgetAttribute(ECGadgets\RainbowCanvas, #PB_Canvas_WheelDelta) * 10
              If Saturation > 240 : Saturation = 240 : EndIf
              If Saturation < 0 : Saturation = 0 : EndIf
            EndIf
            If MouseButton = #PB_EventType_LeftButtonDown
              localX = GetGadgetAttribute(ECGadgets\RainbowCanvas, #PB_Canvas_MouseX)
              localY = GetGadgetAttribute(ECGadgets\RainbowCanvas, #PB_Canvas_MouseY) 
              ;
              If localX > DesktopScaledX(ECGadgets\CanvasDim)
                localX = DesktopScaledX(ECGadgets\CanvasDim)
              ElseIf localX < 0
                localX = 0
              EndIf
              If localY > DesktopScaledY(ECGadgets\CanvasDim)
                localY = DesktopScaledY(ECGadgets\CanvasDim)
              ElseIf localY < 0
                localY = 0
              EndIf
              ;
              CanvasXDim = ECGadgets\CanvasDim * DesktopResolutionX()
              CanvasYDim = ECGadgets\CanvasDim * DesktopResolutionY()
              Hue = localX * 240 / CanvasXDim
              Lightness = (CanvasYDim - localY) * 240 / CanvasYDim
              If Saturation = 0 : Saturation = 1 : EndIf
            Else
              Hue = LimitGadgetValue(ECGadgets\Hue_Input, 0, 240)
              Lightness = LimitGadgetValue(ECGadgets\Lum_Input, 0, 240)
            EndIf

            ECGadgets\Color = HSLToRGB(Hue, Saturation, Lightness)
            ;
            SetGadgetText(ECGadgets\Sat_Input, Str(Saturation))
            SetGadgetText(ECGadgets\Hue_Input, Str(Hue))
            SetGadgetText(ECGadgets\Lum_Input, Str(Lightness))
            ;
            ZCR_SetGadgetsFromColor(ECGadgets, #DontSetHSLString)
            ;
          EndIf
          ;
        Case ECGadgets\Red_Input, ECGadgets\Green_Input, ECGadgets\Blue_Input
          Red = LimitGadgetValue(ECGadgets\Red_Input, 0, 255)
          Green = LimitGadgetValue(ECGadgets\Green_Input, 0, 255)
          Blue = LimitGadgetValue(ECGadgets\Blue_Input, 0, 255)
          ECGadgets\Color = RGB(Red, Green, Blue)
          ;
          ZCR_SetGadgetsFromColor(ECGadgets, #DontSetRGBString)
          ;
        Case ECGadgets\Hue_Input, ECGadgets\Sat_Input, ECGadgets\Lum_Input
          Hue = LimitGadgetValue(ECGadgets\Hue_Input, 0, 240)
          Saturation = LimitGadgetValue(ECGadgets\Sat_Input, 0, 240)
          Lightness = LimitGadgetValue(ECGadgets\Lum_Input, 0, 240)
          ECGadgets\Color = HSLToRGB(Hue, Saturation, Lightness)
          ;
          ZCR_SetGadgetsFromColor(ECGadgets, #DontSetHSLString)
          ;
        Case ECGadgets\BOk ; OK button
          GetOut = 1
        Case ECGadgets\BCancel ; Cancel button
          ECGadgets\Color = InitialColor
          GetOut = 1
      EndSelect
      ;
  EndSelect
  ProcedureReturn GetOut
EndProcedure
;
Procedure ZapmanColorRequester(InitialColor)
  ;
  ; Window and gadget numbers:
  Shared ECGadgets.EditColorGadgetsStruct
  ; Other variables
  Protected WWidth, WHeight, GetOut
  Protected Event, EventType, EventMenu
  ;
  ECGadgets\Color = InitialColor
  ;
  WWidth = 420
  WHeight = 280
  ;
  ECGadgets\EditColorWindow = OpenWindow(#PB_Any, 0, 0, WWidth, WHeight, "Edit Color", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  If ECGadgets\EditColorWindow
    ;
    StickyWindow(ECGadgets\EditColorWindow, 1)
    WindowBounds(ECGadgets\EditColorWindow, 340, 220, 600, 340) 
    BindEvent(#PB_Event_SizeWindow, @ZCR_ResizeGadgets(), ECGadgets\EditColorWindow)
    ;
    ECGadgets\BackColor = GetWindowColor(ECGadgets\EditColorWindow) ; Background color for gadgets.
    ECGadgets\ForeColor = RGB(150, 150, 150)                        ; Color for gadgets borders.
    ;
    ZCR_CreateGadgets()
    ZCR_SetText()
    ;
    ZCR_SetFieldsSizeAndMargins()
    ;
    ZCR_CreateTargetAndCursors()
    ZCR_ResizeGadgets()
    ;
    ; Initialize cursor's positions for trackbars and gadget's colors:
    ZCR_SetGadgetsFromColor(ECGadgets)
    ;
    #ZCR_Escape_Cmd = 1
    AddKeyboardShortcut(ECGadgets\EditColorWindow, #PB_Shortcut_Escape, #ZCR_Escape_Cmd)
    ;
    Repeat
      Event     = WaitWindowEvent()
      EventType = EventType()
      ; Manage trackbars aned input events:
      GetOut = ZCR_Events(Event, EventType, InitialColor)
      If Event = #PB_Event_Menu
        EventMenu = EventMenu()
        If EventMenu = #ZCR_Escape_Cmd
          ECGadgets\Color = InitialColor
          GetOut = 1
        EndIf
      EndIf
    Until Event = #PB_Event_CloseWindow Or GetOut
    ;
    If Event = #PB_Event_CloseWindow
      ECGadgets\Color = InitialColor
    EndIf
    CloseWindow(ECGadgets\EditColorWindow)
  EndIf
  ;
  ProcedureReturn ECGadgets\Color
EndProcedure
;
CompilerIf #PB_Compiler_IsMainFile
  ; The following won't run when this file is used as 'Included'.
  ;
  Hex(ZapmanColorRequester($EA5D8))
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 695
; FirstLine = 683
; Folding = ------------------
; EnableXP
; DPIAware