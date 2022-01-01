 ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Project name : ColorSpectrum - Module
; File Name : ColorSpectrum - Module.pb
; File version: 1.0.1
; Programming : OK
; Programmed by : StarBootics
; Date : 19-02-2019
; Last Update : 21-02-2019
; PureBasic code : V5.70 LTS
; Platform : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Programming notes
;
; Based on original code for GallyHC and Guimauve (French Forum)
; See here : https://www.purebasic.fr/french/viewtopic.php?f=6&t=12596
;            https://www.purebasic.fr/english/viewtopic.php?f=12&t=72323
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

DeclareModule ColorSpectrum
 
  Declare Initialize()
  Declare Requester(Color = -1)
  Declare Reset()
 
  Declare SetTextTitle(Title.s)
  Declare SetTextHue(Hue.s)
  Declare SetTextSaturation(Saturation.s)
  Declare SetTextLightness(Lightness.s)
  Declare SetTextRed(Red.s)
  Declare SetTextGreen(Green.s)
  Declare SetTextBlue(Blue.s)
  Declare SetTextRefresh(Refresh.s)
  Declare SetTextValidate(Validate.s)
  Declare SetTextCancel(Cancel.s)
 
EndDeclareModule

Module ColorSpectrum
 
  Enumeration
   
    #COLOR_SPECTRUM_TARGET_HUE
    #COLOR_SPECTRUM_TARGET_SATURATION
    #COLOR_SPECTRUM_TARGET_LIGHTNESS
    #COLOR_SPECTRUM_TARGET_RED
    #COLOR_SPECTRUM_TARGET_GREEN
    #COLOR_SPECTRUM_TARGET_BLUE
   
    #COLOR_SPECTRUM_TARGET_MAX
   
  EndEnumeration
 
  Enumeration
   
    #COLOR_SPECTRUM_TEXT_HUE
    #COLOR_SPECTRUM_TEXT_SATURATION
    #COLOR_SPECTRUM_TEXT_LIGHTNESS
    #COLOR_SPECTRUM_TEXT_RED
    #COLOR_SPECTRUM_TEXT_GREEN
    #COLOR_SPECTRUM_TEXT_BLUE
    #COLOR_SPECTRUM_TEXT_WIN_TITLE
    #COLOR_SPECTRUM_TEXT_BTN_REFRESH
    #COLOR_SPECTRUM_TEXT_BTN_VALIDATE
    #COLOR_SPECTRUM_TEXT_BTN_CANCEL
   
    #COLOR_SPECTRUM_TEXT_MAX
   
  EndEnumeration
 
  Enumeration
   
    #COLOR_SPECTRUM_BTN_REFRESH
    #COLOR_SPECTRUM_BTN_VALIDATE
    #COLOR_SPECTRUM_BTN_CANCEL
   
    #COLOR_SPECTRUM_BTN_MAX
   
  EndEnumeration
 
  #COLOR_SPECTRUM_SIZE_MAX = 255
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Déclaration des Structures <<<<<
 
  Structure Color
   
    StructureUnion
      Red.a
      Hue.a
    EndStructureUnion
   
    StructureUnion
      Green.a
      Saturation.a
    EndStructureUnion
   
    StructureUnion
      Blue.a
      Lightness.a
    EndStructureUnion
   
  EndStructure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Les observateurs <<<<<
 
  Macro GetColorRed(ColorA)
   
    ColorA\Red
   
  EndMacro
 
  Macro GetColorHue(ColorA)
   
    ColorA\Hue
   
  EndMacro
 
  Macro GetColorGreen(ColorA)
   
    ColorA\Green
   
  EndMacro
 
  Macro GetColorSaturation(ColorA)
   
    ColorA\Saturation
   
  EndMacro
 
  Macro GetColorBlue(ColorA)
   
    ColorA\Blue
   
  EndMacro
 
  Macro GetColorLightness(ColorA)
   
    ColorA\Lightness
   
  EndMacro
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Les mutateurs <<<<<
 
  Macro SetColorRed(ColorA, P_Red)
   
    GetColorRed(ColorA) = P_Red
   
  EndMacro
 
  Macro SetColorHue(ColorA, P_Hue)
   
    GetColorHue(ColorA) = P_Hue
   
  EndMacro
 
  Macro SetColorGreen(ColorA, P_Green)
   
    GetColorGreen(ColorA) = P_Green
   
  EndMacro
 
  Macro SetColorLightness(ColorA, P_Lightness)
   
    GetColorLightness(ColorA) = P_Lightness
   
  EndMacro
 
  Macro SetColorBlue(ColorA, P_Blue)
   
    GetColorBlue(ColorA) = P_Blue
   
  EndMacro
 
  Macro SetColorSaturation(ColorA, P_Saturation)
   
    GetColorSaturation(ColorA) = P_Saturation
   
  EndMacro
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Conversion vers couleur entier long <<<<<
 
  Macro ColorSpectrum_RGB()
   
    (Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_BLUE] << 16 + Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_GREEN] << 8 + Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_RED])
   
  EndMacro
 
  Macro Color_RGB(ColorA)
   
    (GetColorBlue(ColorA) << 16 + GetColorGreen(ColorA) << 8 + GetColorRed(ColorA))
   
  EndMacro
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Conversion RGB vers Hexa <<<<<
 
  Macro ColorSpectrum_RGB_To_Hexa()
   
    RSet(Hex(Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_RED]), 2, "0") + RSet(Hex(Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_GREEN]), 2, "0") + RSet(Hex(Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_BLUE]), 2, "0")
   
  EndMacro
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Min et Max de 3 nombres <<<<<
 
  Macro MinMaxNumber(P_Min, P_Max, P_Number01, P_Number02, P_Number03)
   
    P_Min = P_Number01
   
    If P_Number02 < P_Min
      P_Min = P_Number02
    EndIf
   
    If P_Number03 < P_Min
      P_Min = P_Number03
    EndIf
   
    P_Max = P_Number01
   
    If P_Number02 > P_Max
      P_Max = P_Number02
    EndIf
   
    If P_Number03 > P_Max
      P_Max = P_Number03
    EndIf
   
  EndMacro
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Déclaration de la Structure <<<<<
 
  Structure Instance
   
    HSLRGB.a[#COLOR_SPECTRUM_TARGET_MAX] ; Hue, Saturation, Lightness, Red, Green, Blue
    SafeHSLRGB.a[#COLOR_SPECTRUM_TARGET_MAX] ; SafeHue, SafeSaturation, SafeLightness, SafeRed, SafeGreen, SafeBlue
    BackgroundLayer.i
    SpectrumCanvas.i
    LightnessCanvas.i
    WindowHandle.i
    WindowBackgroundColor.i
    ColorPreviewHandle.i
    Text.s[#COLOR_SPECTRUM_TEXT_MAX]
    TextHandle.i[#COLOR_SPECTRUM_TARGET_MAX]
    StringHandle.i[#COLOR_SPECTRUM_TARGET_MAX]
    ButtonHandle.i[#COLOR_SPECTRUM_BTN_MAX]
   
  EndStructure
 
  Global Instance.Instance
 
  Procedure GetWindowBackgroundColor()
   
    CompilerSelect #PB_Compiler_OS
       
      CompilerCase #PB_OS_Windows
        BackgroundColor = GetSysColor_(#COLOR_3DFACE)
       
      CompilerCase #PB_OS_Linux
        BackgroundColor = RGB(232, 232, 231)
       
      CompilerCase #PB_OS_MacOS
        BackgroundColor = RGB(237, 235, 236)
       
    CompilerEndSelect
   
    ProcedureReturn BackgroundColor
  EndProcedure
 
  Procedure UpdateColorPreviewGadget(GadgetID, Color)
   
    If GetGadgetData(GadgetID) <> #Null
     
      Width = GadgetWidth(GadgetID)
      Height = GadgetHeight(GadgetID)
     
      If StartDrawing(ImageOutput(GetGadgetData(GadgetID)))
       
        Box(0, 0, Width, Height, Color)
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(0, 0, Width, Height, 0)
       
        StopDrawing()
       
        SetGadgetState(GadgetID, ImageID(GetGadgetData(GadgetID)))
       
      EndIf
     
    EndIf
   
  EndProcedure
 
  Procedure ColorPreviewGadget(GadgetID, x.w, y.w, Width.w, Height.w, Color)
   
    GadgetHandle = ImageGadget(GadgetID, x, y, Width, Height, 0)
   
    If GadgetID = #PB_Any
      GadgetID = GadgetHandle
    EndIf
   
    SetGadgetData(GadgetID, CreateImage(#PB_Any, Width, Height))
    UpdateColorPreviewGadget(GadgetID, Color)
   
    ProcedureReturn GadgetHandle
  EndProcedure
 
  Procedure FreeColorPreviewGadget(GadgetID)
   
    If GetGadgetData(GadgetID) <> #Null
      If IsImage(GetGadgetData(GadgetID))
        FreeImage(GetGadgetData(GadgetID))
      EndIf
    EndIf
   
  EndProcedure
 
  Procedure Private_ConvertRM(M1.f, M2.f, HueColor.f)
   
    ; ROUTINE DE CALCUL DE LA COMPOSANTE DE COULEUR.
   
    If HueColor > 360
      HueColor - 360
    EndIf
   
    If HueColor < 0
      HueColor + 360
    EndIf
   
    If HueColor < 60
      M1 = M1 + (M2 - M1) * HueColor / 60
    Else
     
      If HueColor < 180
        M1 = M2
      Else
       
        If HueColor < 240
          M1 = M1 + (M2 - M1) * (240 - HueColor) / 60
        EndIf
       
      EndIf
     
    EndIf
   
    ProcedureReturn M1 * 255
  EndProcedure
 
  Procedure Convert_HSL_To_RGB(HueColor.f, LightnessColor.f, SaturationColor.f, *RGBColorA.Color)
   
    ; ROUTINE DE CONSERTION DU HSL EN RGB.
   
    HueColor = HueColor * 360 / #COLOR_SPECTRUM_SIZE_MAX
    SaturationColor = SaturationColor / #COLOR_SPECTRUM_SIZE_MAX
    LightnessColor = LightnessColor / #COLOR_SPECTRUM_SIZE_MAX
   
    If SaturationColor = 0.0
     
      SetColorRed(*RGBColorA, LightnessColor * #COLOR_SPECTRUM_SIZE_MAX)
      SetColorGreen(*RGBColorA, LightnessColor * #COLOR_SPECTRUM_SIZE_MAX)
      SetColorBlue(*RGBColorA, LightnessColor * #COLOR_SPECTRUM_SIZE_MAX)
     
    Else
     
      If LightnessColor <= 0.5
        M2.f = LightnessColor + LightnessColor * SaturationColor
      Else
        M2 = LightnessColor + SaturationColor - LightnessColor * SaturationColor
      EndIf
     
      M1.f = 2 * LightnessColor - M2
     
      SetColorRed(*RGBColorA, Private_ConvertRm(M1, M2, HueColor + 120))
      SetColorGreen(*RGBColorA, Private_ConvertRm(M1, M2, HueColor))
      SetColorBlue(*RGBColorA, Private_ConvertRm(M1, M2, HueColor - 120))
     
    EndIf
   
  EndProcedure
 
  Procedure Convert_RGB_To_HSL(*RGBColorA.Color, *HSLColorA.Color)
   
    ; ROUTINE DE CONVERTION DU RGB EN HLS.
   
    MinMaxNumber(Min, Max, GetColorRed(*RGBColorA), GetColorGreen(*RGBColorA), GetColorBlue(*RGBColorA))
   
    DeltaMaxMin = Max - Min
    SumMaxMin = Max + Min
   
    LightnessColor.f = SumMaxMin / 510
   
    If Max = Min
     
      HueColor.f = 0
      SaturationColor.f = 0
     
    Else
     
      NormalizedRed = (Max - GetColorRed(*RGBColorA)) / DeltaMaxMin
      NormalizedGreen = (Max - GetColorGreen(*RGBColorA)) / DeltaMaxMin
      NormalizedBlue = (Max - GetColorBlue(*RGBColorA)) / DeltaMaxMin
     
      If LightnessColor <= 0.5
        SaturationColor = DeltaMaxMin / SumMaxMin
      Else
        SaturationColor = DeltaMaxMin / (510 - SumMaxMin)
      EndIf
     
      If GetColorRed(*RGBColorA) = Max
        HueColor = 60 * (6 + NormalizedBlue - NormalizedGreen)
      EndIf
     
      If GetColorGreen(*RGBColorA) = Max
        HueColor = 60 * (2 + NormalizedRed - NormalizedBlue)
      EndIf
     
      If GetColorBlue(*RGBColorA) = Max
        HueColor = 60 * (4 + NormalizedGreen - NormalizedRed)
      EndIf
     
    EndIf
   
    If HueColor = 360
      HueColor = 0
    EndIf
   
    HueColor = HueColor / 360 * #COLOR_SPECTRUM_SIZE_MAX
    LightnessColor = LightnessColor * #COLOR_SPECTRUM_SIZE_MAX
    SaturationColor = SaturationColor * #COLOR_SPECTRUM_SIZE_MAX
   
    SetColorHue(*HSLColorA, Int(HueColor))
    SetColorSaturation(*HSLColorA, Int(SaturationColor))
    SetColorLightness(*HSLColorA, Int(LightnessColor))
   
  EndProcedure
 
  Procedure GenerateColorSpectrumBackgroundLayer()
   
    ; ROUTINE DE PRECALCUL DU SPECTRE DE COULEUR.
   
    Instance\BackgroundLayer = CreateImage(#PB_Any, #COLOR_SPECTRUM_SIZE_MAX + 2, #COLOR_SPECTRUM_SIZE_MAX + 2)
   
    If Instance\BackgroundLayer <> #Null
     
      If StartDrawing(ImageOutput(Instance\BackgroundLayer))
       
        Box(0, 0, #COLOR_SPECTRUM_SIZE_MAX + 2, #COLOR_SPECTRUM_SIZE_MAX + 2, $000000)
       
        For SaturationID = 1 To #COLOR_SPECTRUM_SIZE_MAX
         
          For HueID = 1 To #COLOR_SPECTRUM_SIZE_MAX
           
            Convert_HSL_To_RGB(HueID, #COLOR_SPECTRUM_SIZE_MAX >> 1, SaturationID, RGBColor.Color)
           
            Plot(HueID, (#COLOR_SPECTRUM_SIZE_MAX - SaturationID) + 1, Color_RGB(RGBColor))
           
          Next
         
        Next
       
        StopDrawing()
       
      EndIf
     
    EndIf
   
  EndProcedure
 
  Procedure ColorSpectrum_DrawCross()
   
    ; ROUTINE DE TRACAGE DE LA CROIX DU SPECTRE.
   
    PosX = Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_HUE]
    PosY = #COLOR_SPECTRUM_SIZE_MAX - Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_SATURATION]
   
    If PosX < #COLOR_SPECTRUM_SIZE_MAX
      PosX + 1
    EndIf
   
    If PosY < #COLOR_SPECTRUM_SIZE_MAX
      PosY + 1
    EndIf
   
    Box(PosX - 1, PosY - 9, 3, 5, 0)
    Box(PosX - 1, PosY + 5, 3, 5, 0)
    Box(PosX - 9, PosY - 1, 5, 3, 0)
    Box(PosX + 5, PosY - 1, 5, 3, 0)
   
  EndProcedure
 
  Procedure ColorSpectrum_DrawArrow()
   
    ; ROUTINE DE TRACAGE DE LA BARRE DE LIGHTNESS
   
    y1 = #COLOR_SPECTRUM_SIZE_MAX - Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS]
   
    If y1 => #COLOR_SPECTRUM_SIZE_MAX
      y1 = #COLOR_SPECTRUM_SIZE_MAX - 1
    EndIf
   
    x1 = 22
    x2 = 33
    y1 + 1
    y2 = y1 + 5
    y3 = y1 - 5
    xm = (x1 + x2) >> 1
   
    LineXY(x1, y1, x2, y2, 0)
    LineXY(x2, y2, x2, y3, 0)
    LineXY(x2, y3, x1, y1, 0)
    FillArea(xm, y1, 0, 0)
   
  EndProcedure
 
  Procedure ColorSpectrum_SpectrumRedraw()
   
    ; ROUTINE D'AFFICHAGE DU SPECTRE ET CROIX.
   
    If StartDrawing(CanvasOutput(Instance\SpectrumCanvas))
     
      If Instance\BackgroundLayer <> #Null
        DrawImage(ImageID(Instance\BackgroundLayer), 0, 0)
      EndIf
     
      ColorSpectrum_DrawCross()
     
      StopDrawing()
     
      Convert_HSL_To_RGB(Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_HUE], Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS], Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_SATURATION], RGBColor.Color)
      UpdateColorPreviewGadget(Instance\ColorPreviewHandle, Color_RGB(RGBColor))
     
    EndIf
   
  EndProcedure
 
  Procedure ColorSpectrum_LightnessRedraw()
   
    ; ROUTINE DE TRACAGE DE LA BARRE LUMIERE.
   
    If StartDrawing(CanvasOutput(Instance\LightnessCanvas))
     
      CurrentLightness = Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS]
     
      Box(0, 0, #COLOR_SPECTRUM_SIZE_MAX + 2, #COLOR_SPECTRUM_SIZE_MAX + 2, Instance\WindowBackgroundColor)     
      Box(0, 0, 20, #COLOR_SPECTRUM_SIZE_MAX + 2, $000000)
     
      For LightnessID = 1 To #COLOR_SPECTRUM_SIZE_MAX
       
        Convert_HSL_To_RGB(Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_HUE], LightnessID, Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_SATURATION], RGBColor.Color)
        LineXY(1, (#COLOR_SPECTRUM_SIZE_MAX - LightnessID) + 1, 18, (#COLOR_SPECTRUM_SIZE_MAX - LightnessID) + 1, Color_RGB(RGBColor))
       
      Next
     
      Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS] = CurrentLightness
     
      ColorSpectrum_DrawArrow()   
      StopDrawing()
     
      Convert_HSL_To_RGB(Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_HUE], Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS], Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_SATURATION], RGBColor.Color)
      UpdateColorPreviewGadget(Instance\ColorPreviewHandle, Color_RGB(RGBColor))
     
    EndIf
   
  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur RefeshHSLColorOutput <<<<<
 
  Procedure RefreshHSLColorOutput()
   
    For TargetID = #COLOR_SPECTRUM_TARGET_HUE To #COLOR_SPECTRUM_TARGET_LIGHTNESS
      SetGadgetText(Instance\StringHandle[TargetID], Str(Instance\HSLRGB[TargetID]))
    Next

  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur RefeshRGBColorOutput <<<<<
 
  Procedure RefreshRGBColorOutput()
   
    Convert_HSL_To_RGB(Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_HUE], Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS], Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_SATURATION], RGBColor.Color)
   
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_RED] = GetColorRed(RGBColor)
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_GREEN] = GetColorGreen(RGBColor)
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_BLUE] = GetColorBlue(RGBColor)

    For TargetID = #COLOR_SPECTRUM_TARGET_RED To #COLOR_SPECTRUM_TARGET_BLUE
      SetGadgetText(Instance\StringHandle[TargetID], Str(Instance\HSLRGB[TargetID]))
    Next
   
  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur CatchSafeHSLRGB <<<<<
 
  Procedure CatchSafeHSLRGB()
   
    For TargetID = #COLOR_SPECTRUM_TARGET_HUE To #COLOR_SPECTRUM_TARGET_BLUE
      Instance\SafeHSLRGB[TargetID] = Val(GetGadgetText(Instance\StringHandle[TargetID]))
    Next
   
  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur CatchRGBColorInput <<<<<
 
  Procedure CatchRGBColorInput()
   
    For TargetID = #COLOR_SPECTRUM_TARGET_RED To #COLOR_SPECTRUM_TARGET_BLUE
      Instance\HSLRGB[TargetID]  = Val(GetGadgetText(Instance\StringHandle[TargetID]))
    Next
   
    SetColorRed(RGBColor.Color, Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_RED])
    SetColorGreen(RGBColor, Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_GREEN])
    SetColorBlue(RGBColor, Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_BLUE])
   
    Convert_RGB_To_HSL(RGBColor, HSLColor.Color)
   
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_HUE] = GetColorHue(HSLColor)
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_SATURATION] = GetColorSaturation(HSLColor)
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS] = GetColorLightness(HSLColor)
   
  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur RefeshSpectrum <<<<<
 
  Procedure RefeshColorSpectrum()
   
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_HUE] = 0
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_SATURATION] = 0
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS] = 127
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_RED] = 0
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_GREEN] = 0
    Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_BLUE] = 0
   
    ColorSpectrum_SpectrumRedraw()
    ColorSpectrum_LightnessRedraw()
    RefreshHSLColorOutput()
    RefreshRGBColorOutput()
    CatchSafeHSLRGB()
   
  EndProcedure
 
  Procedure ForceColorSpectrumStartColor(Color)
   
    If Color <> - 1
     
      Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_RED] = Red(Color)
      Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_GREEN] = Green(Color)
      Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_BLUE] = Blue(Color)
     
      For TargetID = #COLOR_SPECTRUM_TARGET_RED To #COLOR_SPECTRUM_TARGET_BLUE
        SetGadgetText(Instance\StringHandle[TargetID], Str(Instance\HSLRGB[TargetID]))
      Next
     
      CatchRGBColorInput()
      RefreshHSLColorOutput()
     
    Else
     
      RefreshRGBColorOutput()
      RefreshHSLColorOutput()
     
    EndIf
   
  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur ColorSpectrum_SpectrumCanvas_EventManager <<<<<
 
  Procedure ColorSpectrum_SpectrumCanvas_EventManager()
   
    EventType = EventType()
   
    If EventType = #PB_EventType_LeftButtonDown Or ( EventType = #PB_EventType_MouseMove And GetGadgetAttribute(Instance\SpectrumCanvas, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)
     
      MouseX = GetGadgetAttribute(Instance\SpectrumCanvas, #PB_Canvas_MouseX)
      MouseY = GetGadgetAttribute(Instance\SpectrumCanvas, #PB_Canvas_MouseY)
     
      If MouseX < 0
        MouseX = 0
      Else
        If MouseX > #COLOR_SPECTRUM_SIZE_MAX
          MouseX = #COLOR_SPECTRUM_SIZE_MAX
        EndIf
       
      EndIf
     
      If MouseY < 0
        MouseY = 0
      Else
        If MouseY > #COLOR_SPECTRUM_SIZE_MAX
          MouseY = #COLOR_SPECTRUM_SIZE_MAX
        EndIf
      EndIf
     
      Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_HUE] = MouseX
      Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_SATURATION] = #COLOR_SPECTRUM_SIZE_MAX - MouseY
     
      ColorSpectrum_SpectrumRedraw()
      ColorSpectrum_LightnessRedraw()
      RefreshHSLColorOutput()
      RefreshRGBColorOutput()
      CatchSafeHSLRGB()
     
    EndIf
   
  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur ColorSpectrum_LightnessCanvas_EventManager <<<<<
 
  Procedure ColorSpectrum_LightnessCanvas_EventManager()
   
    EventType = EventType()
   
    If EventType = #PB_EventType_LeftButtonDown Or (EventType = #PB_EventType_MouseMove And GetGadgetAttribute(Instance\LightnessCanvas, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)
     
      MouseY = GetGadgetAttribute(Instance\LightnessCanvas, #PB_Canvas_MouseY)
     
      If MouseY < 0
        MouseY = 0
      Else
       
        If MouseY > #COLOR_SPECTRUM_SIZE_MAX
          MouseY = #COLOR_SPECTRUM_SIZE_MAX
        EndIf
       
      EndIf
     
      Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS] = #COLOR_SPECTRUM_SIZE_MAX - MouseY
     
      ColorSpectrum_LightnessRedraw()
     
      RefreshHSLColorOutput()
      RefreshRGBColorOutput()
     
      CatchSafeHSLRGB()
     
    EndIf
   
  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur Hue Input Control <<<<<
 
  Procedure ColorSpectrum_Input_Control(Target.b)
   
    EventType = EventType()
   
    If EventType = #PB_EventType_Change
     
      Instance\SafeHSLRGB[Target] = Val(GetGadgetText(Instance\StringHandle[Target]))
     
      If Instance\SafeHSLRGB[Target] < 0
        Instance\SafeHSLRGB[Target] = 0
      EndIf
     
      If Instance\SafeHSLRGB[Target] > 255
        Instance\SafeHSLRGB[Target] = 255
      EndIf
     
      Select Target
         
        Case #COLOR_SPECTRUM_TARGET_HUE, #COLOR_SPECTRUM_TARGET_LIGHTNESS, #COLOR_SPECTRUM_TARGET_SATURATION
          Instance\HSLRGB[Target] = Instance\SafeHSLRGB[Target]
         
        Case #COLOR_SPECTRUM_TARGET_RED, #COLOR_SPECTRUM_TARGET_GREEN, #COLOR_SPECTRUM_TARGET_BLUE
          Instance\HSLRGB[Target] = Instance\SafeHSLRGB[Target]
         
          SetColorRed(RGBColor.Color, Instance\SafeHSLRGB[#COLOR_SPECTRUM_TARGET_RED])
          SetColorGreen(RGBColor, Instance\SafeHSLRGB[#COLOR_SPECTRUM_TARGET_GREEN])
          SetColorBlue(RGBColor, Instance\SafeHSLRGB[#COLOR_SPECTRUM_TARGET_BLUE])
          Convert_RGB_To_HSL(RGBColor, HSLColor.Color)
          Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_HUE] = GetColorHue(HSLColor)
          Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_SATURATION] = GetColorSaturation(HSLColor)
          Instance\HSLRGB[#COLOR_SPECTRUM_TARGET_LIGHTNESS] = GetColorLightness(HSLColor)
         
      EndSelect
     
      ColorSpectrum_SpectrumRedraw()
      ColorSpectrum_LightnessRedraw()
     
    ElseIf EventType = #PB_EventType_LostFocus
     
      SetGadgetText(Instance\StringHandle[Target], Str(Instance\SafeHSLRGB[Target]))
     
    EndIf
   
  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur Initialize <<<<<
 
  Procedure Initialize()
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_WIN_TITLE] = "Цветовой спектр" ; "Color Spectrum"
    Instance\Text[#COLOR_SPECTRUM_TEXT_HUE] = "Оттенок" ; "Hue"
    Instance\Text[#COLOR_SPECTRUM_TEXT_SATURATION] = "Насыщенность" ; "Saturation"
    Instance\Text[#COLOR_SPECTRUM_TEXT_LIGHTNESS] = "Яркость" ; "Lightness" "Brightness"
    Instance\Text[#COLOR_SPECTRUM_TEXT_RED] = "Красный"
    Instance\Text[#COLOR_SPECTRUM_TEXT_GREEN] = "Зеленый"
    Instance\Text[#COLOR_SPECTRUM_TEXT_BLUE] = "Синий"
    Instance\Text[#COLOR_SPECTRUM_TEXT_BTN_REFRESH] = "Сбросить" ; "Refresh"
    Instance\Text[#COLOR_SPECTRUM_TEXT_BTN_VALIDATE] = "Выбирать" ; "Validate"
    Instance\Text[#COLOR_SPECTRUM_TEXT_BTN_CANCEL] = "Отменить" ; "Cancel"
 
  EndProcedure
 
  Procedure SetTextTitle(Title.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_WIN_TITLE] = Title
   
  EndProcedure
 
  Procedure SetTextHue(Hue.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_HUE] = Hue
   
  EndProcedure
 
  Procedure SetTextSaturation(Saturation.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_SATURATION] = Saturation
   
  EndProcedure
 
  Procedure SetTextLightness(Lightness.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_LIGHTNESS] = Lightness
   
  EndProcedure
 
  Procedure SetTextRed(Red.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_RED] = Red
   
  EndProcedure
 
  Procedure SetTextGreen(Green.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_GREEN] = Green
   
  EndProcedure
 
  Procedure SetTextBlue(Blue.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_BLUE] = Blue
   
  EndProcedure
 
  Procedure SetTextRefresh(Refresh.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_BTN_REFRESH] = Refresh
   
  EndProcedure
 
  Procedure SetTextValidate(Validate.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_BTN_VALIDATE] = Validate
   
  EndProcedure
 
  Procedure SetTextCancel(Cancel.s)
   
    Instance\Text[#COLOR_SPECTRUM_TEXT_BTN_CANCEL] = Cancel
   
  EndProcedure
 
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur Reset <<<<<
 
  Procedure Reset()
   
    For HSLRGBID = 0 To #COLOR_SPECTRUM_TARGET_MAX - 1
      Instance\HSLRGB[HSLRGBID] = 0
      Instance\SafeHSLRGB[HSLRGBID] = 0
    Next
   
    If IsImage(Instance\BackgroundLayer)
      FreeImage(Instance\BackgroundLayer)
      Instance\BackgroundLayer = 0
    EndIf
   
    Instance\SpectrumCanvas = 0
    Instance\LightnessCanvas = 0
    Instance\WindowHandle = 0
    Instance\WindowBackgroundColor = 0
    Instance\ColorPreviewHandle = 0
   
    For TextID = 0 To #COLOR_SPECTRUM_TEXT_MAX - 1
      Instance\Text[TextID] = ""
    Next
   
    For Index = 0 To #COLOR_SPECTRUM_TARGET_MAX - 1
      Instance\TextHandle[Index] = 0
      Instance\StringHandle[Index] = 0
    Next
   
    For BtnID = 0 To #COLOR_SPECTRUM_BTN_MAX - 1
      Instance\ButtonHandle[BtnID] = 0
    Next
   
  EndProcedure
 
 
  Procedure Requester(Color = -1)
   
    Instance\WindowHandle = OpenWindow(#PB_Any, 0, 0, #COLOR_SPECTRUM_SIZE_MAX + 197, #COLOR_SPECTRUM_SIZE_MAX + 34+15, Instance\Text[#COLOR_SPECTRUM_TEXT_WIN_TITLE] , #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
    If Instance\WindowHandle <> #Null

      Instance\SpectrumCanvas = CanvasGadget(#PB_Any, 5, 5, #COLOR_SPECTRUM_SIZE_MAX + 2, #COLOR_SPECTRUM_SIZE_MAX + 2)
      Instance\LightnessCanvas = CanvasGadget(#PB_Any, #COLOR_SPECTRUM_SIZE_MAX + 15, 5, 35, #COLOR_SPECTRUM_SIZE_MAX + 2)
     

      PosY = 5
     
      For Index = 0 To #COLOR_SPECTRUM_TARGET_MAX - 1
        Instance\TextHandle[Index] = StringGadget(#PB_Any, #COLOR_SPECTRUM_SIZE_MAX + 55, PosY, 95, 34,  Instance\Text[Index], #PB_String_ReadOnly)
        Instance\StringHandle[Index] = StringGadget(#PB_Any, #COLOR_SPECTRUM_SIZE_MAX + 150, PosY, 42, 34, "000")
        PosY + 34
      Next
     
      Instance\ColorPreviewHandle = ColorPreviewGadget(#PB_Any, #COLOR_SPECTRUM_SIZE_MAX + 55, PosY+5, 137, 47, 0)

      PosX = ((#COLOR_SPECTRUM_SIZE_MAX + 197) - 135*3+10) >> 1
     
      For BtnID = 0 To #COLOR_SPECTRUM_BTN_MAX - 1
        Instance\ButtonHandle[BtnID] = ButtonGadget(#PB_Any, PosX, #COLOR_SPECTRUM_SIZE_MAX+10, 135, 34, Instance\Text[BtnID + #COLOR_SPECTRUM_TEXT_BTN_REFRESH])
        PosX + 140
      Next
     
      Instance\WindowBackgroundColor = GetWindowBackgroundColor()
      GenerateColorSpectrumBackgroundLayer()
     
      ForceColorSpectrumStartColor(Color)
      CatchSafeHSLRGB()
      ColorSpectrum_SpectrumRedraw()
      ColorSpectrum_LightnessRedraw()
      ReturnSelectedColor = -1
     
      Repeat
       
        EventID = WaitWindowEvent()
       
        Select EventID
           
          Case #PB_Event_Gadget
           
            Select EventGadget()
               
              Case Instance\SpectrumCanvas
                ColorSpectrum_SpectrumCanvas_EventManager()
               
              Case Instance\LightnessCanvas
                ColorSpectrum_LightnessCanvas_EventManager()
               
              Case Instance\StringHandle[#COLOR_SPECTRUM_TARGET_HUE]
                ColorSpectrum_Input_Control(#COLOR_SPECTRUM_TARGET_HUE)
               
              Case Instance\StringHandle[#COLOR_SPECTRUM_TARGET_LIGHTNESS]
                ColorSpectrum_Input_Control(#COLOR_SPECTRUM_TARGET_LIGHTNESS)
               
              Case Instance\StringHandle[#COLOR_SPECTRUM_TARGET_SATURATION]
                ColorSpectrum_Input_Control(#COLOR_SPECTRUM_TARGET_SATURATION)
               
              Case Instance\StringHandle[#COLOR_SPECTRUM_TARGET_RED]
                ColorSpectrum_Input_Control(#COLOR_SPECTRUM_TARGET_RED)
               
              Case Instance\StringHandle[#COLOR_SPECTRUM_TARGET_GREEN]
                ColorSpectrum_Input_Control(#COLOR_SPECTRUM_TARGET_GREEN)
               
              Case Instance\StringHandle[#COLOR_SPECTRUM_TARGET_BLUE]
                ColorSpectrum_Input_Control(#COLOR_SPECTRUM_TARGET_BLUE)
               
              Case Instance\ButtonHandle[#COLOR_SPECTRUM_BTN_REFRESH]
                RefeshColorSpectrum()
               
              Case Instance\ButtonHandle[#COLOR_SPECTRUM_BTN_VALIDATE]
                ReturnSelectedColor = ColorSpectrum_RGB()
                EventID = #PB_Event_CloseWindow
               
              Case Instance\ButtonHandle[#COLOR_SPECTRUM_BTN_CANCEL]
                EventID = #PB_Event_CloseWindow
               
            EndSelect
           
        EndSelect
       
      Until EventID = #PB_Event_CloseWindow
     
      If IsImage(Instance\BackgroundLayer)
        FreeImage(Instance\BackgroundLayer)
        Instance\BackgroundLayer = 0
      EndIf
     
      FreeColorPreviewGadget(Instance\ColorPreviewHandle)
      CloseWindow(Instance\WindowHandle)
     
    EndIf
   
    ProcedureReturn ReturnSelectedColor
  EndProcedure
 
EndModule

CompilerIf #PB_Compiler_IsMainFile
 
  ColorSpectrum::Initialize()
 
  Color = ColorSpectrum::Requester()
 
  If Color <> -1
    Debug "RGB(" + Str(Red(Color)) + ", " + Str(Green(Color)) + ", " + Str(Blue(Color)) + ")"
  Else
    Debug "The User click the Cancel button"
  EndIf
 
  ; Translation in French
  ColorSpectrum::SetTextTitle("Выбираем цвет") ; "Choix d'une couleur")
  ColorSpectrum::SetTextHue("Оттенок") ; "Teinte")
  ColorSpectrum::SetTextSaturation("Насыщенность") ; "Saturation")
  ColorSpectrum::SetTextLightness("Яркость") ; "Luminosité")
  ColorSpectrum::SetTextRed("красный") ; "Rouge")
  ColorSpectrum::SetTextGreen("Зеленый") ; "Vert")
  ColorSpectrum::SetTextBlue("Синий") ; "Bleu")
  ColorSpectrum::SetTextRefresh("Сбросить") ; "Rafraichir")
  ColorSpectrum::SetTextValidate("Выбирать") ; "Sélectionner")
  ColorSpectrum::SetTextCancel("Отменить") ; "Annuler")
 
 
  Color = ColorSpectrum::Requester()
 
  If Color <> -1
    Debug "RGB(" + Str(Red(Color)) + ", " + Str(Green(Color)) + ", " + Str(Blue(Color)) + ")"
  Else
    Debug "The User click the Cancel button"
  EndIf
 
  ColorSpectrum::Reset()
 
CompilerEndIf

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----------------
; EnableXP