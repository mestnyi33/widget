Enumeration #PB_Event_FirstCustomValue     ;{ #Event
   #Event_Gadget
   #Event_Cursor
   #Event_Theme
   #Event_Timer
   #Event_ToolTip
   #Event_Message
   #Event_CanvasArea
EndEnumeration ;}

; _____ Theme-Support _____

Enumeration
   #Theme_Default
   #Theme_Blue  
   #Theme_Green
   #Theme_Dark
   #Theme_DarkBlue
EndEnumeration

Enumeration 1     ;{ Theme - Color
   #Color_Front
   #Color_Back
   #Color_Line
   #Color_Border
   #Color_Row
   #Color_Gadget
   #Color_FocusFront
   #Color_FocusBack
   #Color_HeaderFront
   #Color_HeaderBack
   #Color_HeaderLight
   #Color_ButtonFront
   #Color_ButtonBack
   #Color_ButtonBorder
   #Color_TitleFront
   #Color_TitleBack
   #Color_ProgressFront
   #Color_ProgressBack
   #Color_ProgressGradient
EndEnumeration ;}

Structure Theme_Font_Structure
   Num.i
   Name.s
   Size.i
   Style.i
EndStructure  

Structure Theme_Disable_Structure  ;{ ThemeGUI\...
   FrontColor.i
   BackColor.i
   BorderColor.i
EndStructure ;}

Structure Theme_Progress_Structure ;{ ThemeGUI\Progress\...
   TextColor.i
   FrontColor.i
   BackColor.i
   GradientColor.i
   BorderColor.i
EndStructure ;}

Structure Theme_Header_Structure   ;{ ThemeGUI\Header\...
   FrontColor.i
   BackColor.i
   BorderColor.i
   LightColor.i
EndStructure ;}

Structure Theme_Border_Structure   ;{ ThemeGUI\...
   FrontColor.i
   BackColor.i
   BorderColor.i
EndStructure ;}

Structure Theme_Button_Structure   ;{ ThemeGUI\...
   FrontColor.i
   BackColor.i
   BorderColor.i
   SwitchColor.i
EndStructure ;}

Structure Theme_Color_Structure    ;{ ThemeGUI\...
   FrontColor.i
   BackColor.i
EndStructure ;}

Structure Theme_Structure          ;{ ThemeGUI\...
   FrontColor.i
   BackColor.i
   BorderColor.i
   RowColor.i
   LineColor.i
   GreyTextColor.i
   Button.Theme_Button_Structure
   Disable.Theme_Disable_Structure
   Focus.Theme_Color_Structure
   Header.Theme_Header_Structure
   Progress.Theme_Progress_Structure
   Title.Theme_Border_Structure
   ScrollbarColor.i
   GadgetColor.i
   WindowColor.i
   Font.Theme_Font_Structure
   ScrollBar.i ; Flags
EndStructure   ;}
Global ThemeGUI.Theme_Structure


Procedure.i BlendColor_(Color1.i, Color2.i, Scale.i=50)
   Define.i R1, G1, B1, R2, G2, B2
   Define.f Blend = Scale / 100
   
   R1 = Red(Color1): G1 = Green(Color1): B1 = Blue(Color1)
   R2 = Red(Color2): G2 = Green(Color2): B2 = Blue(Color2)
   
   ProcedureReturn RGB((R1*Blend) + (R2 * (1-Blend)), (G1*Blend) + (G2 * (1-Blend)), (B1*Blend) + (B2 * (1-Blend)))
EndProcedure

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
   ; Addition of mk-soft
   
   Procedure OSX_NSColorToRGBA(NSColor)
      Protected.cgfloat red, green, blue, alpha
      Protected nscolorspace, rgba
      
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
         CocoaMessage(@red, nscolorspace, "redComponent")
         CocoaMessage(@green, nscolorspace, "greenComponent")
         CocoaMessage(@blue, nscolorspace, "blueComponent")
         CocoaMessage(@alpha, nscolorspace, "alphaComponent")
         rgba = RGBA(red * 255.9, green * 255.9, blue * 255.9, alpha * 255.)
         ProcedureReturn rgba
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
         rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
         ProcedureReturn rgb
      EndIf
   EndProcedure
   
   Procedure OSX_NSColorByNameToRGB(NSColorName.s)
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
   
   Procedure OSX_GadgetColor()
      Define.i UserDefaults, NSString
      
      UserDefaults = CocoaMessage(0, 0, "NSUserDefaults standardUserDefaults")
      NSString = CocoaMessage(0, UserDefaults, "stringForKey:$", @"AppleInterfaceStyle")
      If NSString And PeekS(CocoaMessage(0, NSString, "UTF8String"), -1, #PB_UTF8) = "Dark"
         ProcedureReturn BlendColor_(OSX_NSColorByNameToRGB("controlBackgroundColor"), #White, 85)
      Else
         ProcedureReturn BlendColor_(OSX_NSColorByNameToRGB("windowBackgroundColor"), #White, 85)
      EndIf 
      
   EndProcedure  
   
CompilerEndIf


Procedure   SetTheme(Theme.i=#PB_Default)
   ; On request and with the sponsorship of Cyllceaux
   
   ThemeGUI\Font\Num    = #PB_Default
   ThemeGUI\WindowColor = #PB_Default
   
   CompilerSelect  #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
         ThemeGUI\GadgetColor    = GetSysColor_(#COLOR_MENU)
         ThemeGUI\ScrollbarColor = GetSysColor_(#COLOR_MENU)
      CompilerCase #PB_OS_MacOS
         ThemeGUI\GadgetColor    = OSX_GadgetColor()
         ThemeGUI\ScrollbarColor = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
      CompilerCase #PB_OS_Linux
         ThemeGUI\GadgetColor    = $EDEDED
         ThemeGUI\ScrollbarColor = $C8C8C8
   CompilerEndSelect
   
   Select Theme
      Case #Theme_Blue     ;{ Blue Theme
                           ;  $3A2100 $43321C $764200 $B06400 $CB9755 $E5CBAA $EDDCC6 $F6EDE2 $FCF9F5
         ThemeGUI\FrontColor             = $490000
         ThemeGUI\BackColor              = $FEFDFB
         ThemeGUI\BorderColor            = $8C8C8C
         ThemeGUI\LineColor              = $C5C5C5
         ThemeGUI\GreyTextColor          = $6D6D6D
         ThemeGUI\RowColor               = $FAF5EE
         ThemeGUI\Focus\FrontColor       = $FCF9F5
         ThemeGUI\Focus\BackColor        = $B06400
         ThemeGUI\Header\FrontColor      = $43321C
         ThemeGUI\Header\BackColor       = $E5CBAA
         ThemeGUI\Header\BorderColor     = $A0A0A0
         ThemeGUI\Header\LightColor      = $F6EDE2
         ThemeGUI\Button\FrontColor      = $490000
         ThemeGUI\Button\BackColor       = $E3E3E3
         ThemeGUI\Button\BorderColor     = $B48246
         ThemeGUI\Button\SwitchColor     = $C8C8C8
         ThemeGUI\Title\FrontColor       = $FCF9F5
         ThemeGUI\Title\BackColor        = $764200
         ThemeGUI\Title\BorderColor      = $3A2100
         ThemeGUI\Progress\TextColor     = $FCF9F5
         ThemeGUI\Progress\FrontColor    = $CB9755
         ThemeGUI\Progress\BackColor     = #PB_Default 
         ThemeGUI\Progress\GradientColor = $B06400
         ThemeGUI\Progress\BorderColor   = $764200
         ThemeGUI\Disable\FrontColor     = $72727D
         ThemeGUI\Disable\BackColor      = $CCCCCA
         ThemeGUI\Disable\BorderColor    = $72727D
         ;}
         
      Case #Theme_Green    ;{ Green Theme
                           ; $2A3A1F $142D05 $295B0A $3E8910 $7EB05F $BED7AF $D4E4C9 $E2EDDB $F5F9F3
         ThemeGUI\FrontColor             = $0F2203
         ThemeGUI\BackColor              = $FCFDFC
         ThemeGUI\BorderColor            = $9B9B9B
         ThemeGUI\LineColor              = $CCCCCC
         ThemeGUI\GreyTextColor          = $6D6D6D
         ThemeGUI\RowColor               = $F3F7F0
         ThemeGUI\Focus\FrontColor       = $3E8910 
         ThemeGUI\Focus\BackColor        = $F5F9F3
         ThemeGUI\Header\FrontColor      = $142D05
         ThemeGUI\Header\BackColor       = $BED7AF
         ThemeGUI\Header\BorderColor     = $A0A0A0
         ThemeGUI\Header\LightColor      = $E2EDDB
         ThemeGUI\Button\FrontColor      = $0F2203
         ThemeGUI\Button\BackColor       = $E3E3E3
         ThemeGUI\Button\BorderColor     = $A0A0A0
         ThemeGUI\Button\SwitchColor     = $C8C8C8
         ThemeGUI\Title\FrontColor       = $F5F9F3
         ThemeGUI\Title\BackColor        = $295B0A
         ThemeGUI\Title\BorderColor      = $142D05
         ThemeGUI\Progress\TextColor     = $F5F9F3
         ThemeGUI\Progress\FrontColor    = $BED7AF
         ThemeGUI\Progress\BackColor     = #PB_Default
         ThemeGUI\Progress\GradientColor = $7EB05F
         ThemeGUI\Progress\BorderColor   = $295B0A
         ThemeGUI\Disable\FrontColor     = $72727D
         ThemeGUI\Disable\BackColor      = $CCCCCA
         ThemeGUI\Disable\BorderColor    = $72727D
         ;}
         
      Case #Theme_DarkBlue ;{ Dark Blue Theme
                           ;  $3A2100 $43321C $764200 $B06400 $CB9755 $E5CBAA $EDDCC6 $F6EDE2 $FCF9F5
         ThemeGUI\FrontColor             = $FCF9F5
         ThemeGUI\BackColor              = $764200
         ThemeGUI\BorderColor            = $8C8C8C
         ThemeGUI\LineColor              = $E5CBAA
         ThemeGUI\GreyTextColor          = $6D6D6D
         ThemeGUI\RowColor               = $814700
         ThemeGUI\Focus\FrontColor       = $FFFFFF
         ThemeGUI\Focus\BackColor        = $4AFFB7
         ThemeGUI\Header\FrontColor      = $EDDCC6
         ThemeGUI\Header\BackColor       = $B06400
         ThemeGUI\Header\BorderColor     = $CB9755
         ThemeGUI\Header\LightColor      = $C2863B
         ThemeGUI\Button\FrontColor      = $43321C
         ThemeGUI\Button\BackColor       = $F6EDE2
         ThemeGUI\Button\BorderColor     = $A87433
         ThemeGUI\Button\SwitchColor     = $C8C8C8
         ThemeGUI\Title\FrontColor       = $EDDCC6
         ThemeGUI\Title\BackColor        = $B06400
         ThemeGUI\Title\BorderColor      = $3A2100
         ThemeGUI\Progress\TextColor     = $EDDCC6
         ThemeGUI\Progress\FrontColor    = $CB9755
         ThemeGUI\Progress\BackColor     = #PB_Default 
         ThemeGUI\Progress\GradientColor = $B06400
         ThemeGUI\Progress\BorderColor   = $B88038
         ThemeGUI\Disable\FrontColor     = $72727D
         ThemeGUI\Disable\BackColor      = $CCCCCA
         ThemeGUI\Disable\BorderColor    = $72727D
         ;}  
         
      Case #Theme_Dark  ;{ Dark 
                        ;  $3A2100 $43321C $764200 $B06400 $CB9755 $E5CBAA $EDDCC6 $F6EDE2 $FCF9F5
         ThemeGUI\FrontColor             = $FCF9F5
         ThemeGUI\BackColor              = $3A2100
         ThemeGUI\BorderColor            = $8C8C8C
         ThemeGUI\LineColor              = $764200
         ThemeGUI\GreyTextColor          = $6D6D6D
         ThemeGUI\RowColor               = $422500
         ThemeGUI\Focus\FrontColor       = $764200
         ThemeGUI\Focus\BackColor        = $FFFFFF
         ThemeGUI\Header\FrontColor      = $E5CBAA
         ThemeGUI\Header\BackColor       = $764200
         ThemeGUI\Header\BorderColor     = $CB9755
         ThemeGUI\Header\LightColor      = $F6EDE2
         ThemeGUI\Button\FrontColor      = $FCF9F5
         ThemeGUI\Button\BackColor       = $5E3400
         ThemeGUI\Button\BorderColor     = $B06400
         ThemeGUI\Button\SwitchColor     = $C8C8C8
         ThemeGUI\Title\FrontColor       = $FCF9F5
         ThemeGUI\Title\BackColor        = $764200
         ThemeGUI\Title\BorderColor      = $3A2100
         ThemeGUI\Progress\TextColor     = $F6EDE2
         ThemeGUI\Progress\FrontColor    =  $CB9755
         ThemeGUI\Progress\BackColor     = #PB_Default
         ThemeGUI\Progress\GradientColor = $B06400
         ThemeGUI\Progress\BorderColor   = $B06400
         ThemeGUI\WindowColor            = $342B1D
         ThemeGUI\GadgetColor            = $342B1D
         ThemeGUI\Disable\FrontColor     = $72727D
         ThemeGUI\Disable\BackColor      = $CCCCCA
         ThemeGUI\Disable\BorderColor    = $72727D
         ;}
         
      Default           ;{ Default Theme
         
         ThemeGUI\RowColor               = $FCFCFC
         ThemeGUI\GreyTextColor          = $6D6D6D
         
         ThemeGUI\Title\FrontColor       = $FFFFFF
         ThemeGUI\Title\BackColor        = $FCF9F5
         
         ThemeGUI\Header\LightColor      = $F6EDE2
         
         ThemeGUI\Disable\FrontColor     = $72727D
         ThemeGUI\Disable\BackColor      = $CCCCCA
         ThemeGUI\Disable\BorderColor    = $72727D
         
         ThemeGUI\Progress\TextColor     = $F9FEF8
         ThemeGUI\Progress\FrontColor    = $31EE07
         ThemeGUI\Progress\BackColor     = #PB_Default
         ThemeGUI\Progress\GradientColor = $25B006
         ThemeGUI\Progress\BorderColor   = $A0A0A0
         
         ThemeGUI\Button\SwitchColor     = $C8C8C8
         
         CompilerSelect  #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
               ThemeGUI\FrontColor         = GetSysColor_(#COLOR_WINDOWTEXT)
               ThemeGUI\BackColor          = GetSysColor_(#COLOR_WINDOW)
               ThemeGUI\LineColor          = GetSysColor_(#COLOR_3DLIGHT)
               ThemeGUI\BorderColor        = GetSysColor_(#COLOR_WINDOWFRAME)
               ThemeGUI\Focus\FrontColor   = GetSysColor_(#COLOR_HIGHLIGHTTEXT)
               ThemeGUI\Focus\BackColor    = GetSysColor_(#COLOR_HIGHLIGHT)
               ThemeGUI\Header\FrontColor  = GetSysColor_(#COLOR_WINDOWTEXT)
               ThemeGUI\Header\BackColor   = GetSysColor_(#COLOR_WINDOW)
               ThemeGUI\Button\FrontColor  = GetSysColor_(#COLOR_WINDOWTEXT)
               ThemeGUI\Button\BackColor   = GetSysColor_(#COLOR_3DLIGHT) 
               ThemeGUI\Button\BorderColor = GetSysColor_(#COLOR_3DSHADOW)
               ThemeGUI\Button\SwitchColor = GetSysColor_(#COLOR_SCROLLBAR)
               ThemeGUI\Title\BorderColor  = GetSysColor_(#COLOR_WINDOWFRAME)
               ThemeGUI\ScrollbarColor     = GetSysColor_(#COLOR_MENU)
            CompilerCase #PB_OS_MacOS
               ThemeGUI\FrontColor         = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textColor"))
               ThemeGUI\BackColor          = BlendColor_(OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textBackgroundColor")), $FFFFFF, 80)
               ThemeGUI\LineColor          = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
               ThemeGUI\BorderColor        = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
               ThemeGUI\Focus\FrontColor   = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedTextColor"))
               ThemeGUI\Focus\BackColor    = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedControlColor"))
               ThemeGUI\Header\FrontColor  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textColor"))
               ThemeGUI\Header\BackColor   = BlendColor_(OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textBackgroundColor")), $FFFFFF, 80)
               ThemeGUI\Button\FrontColor  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textColor")) 
               ThemeGUI\Button\BackColor   = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
               ThemeGUI\Button\BorderColor = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
               ThemeGUI\Button\SwitchColor = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
               ThemeGUI\Title\BorderColor  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
            CompilerCase #PB_OS_Linux
               ThemeGUI\FrontColor          = $000000
               ThemeGUI\BackColor           = $FFFFFF
               ThemeGUI\LineColor           = $B4B4B4
               ThemeGUI\BorderColor         = $A0A0A0
               ThemeGUI\Focus\FrontColor    = $FFFFFF
               ThemeGUI\Focus\BackColor     = $D77800
               ThemeGUI\Header\FrontColor   = $000000
               ThemeGUI\Header\BackColor    = $FFFFFF
               ThemeGUI\Button\FrontColor   = $000000
               ThemeGUI\Button\BackColor    = $E3E3E3
               ThemeGUI\Button\BorderColor  = $A0A0A0
               ThemeGUI\Title\BorderColor   = $B4B4B4
               ThemeGUI\ScrollbarColor      = $C8C8C8
         CompilerEndSelect
         ;}
         ;SaveTheme_("Theme_Default.xml")
   EndSelect
   
   PostEvent(#Event_Theme)
   
EndProcedure

Procedure.i LoadTheme(File.s="ThemeGUI.xml")
   Define.i XML
   
   XML = LoadXML(#PB_Any, File)
   If XML
      ExtractXMLStructure(MainXMLNode(XML), @ThemeGUI, Theme_Structure)
      FreeXML(XML)
      
      PostEvent(#Event_Theme)
      
      ProcedureReturn #True
   EndIf
   
EndProcedure

Procedure.i SaveTheme(File.s="ThemeGUI.xml")
   Define.i XML, FontNum
   
   FontNum = ThemeGUI\Font\Num
   ThemeGUI\Font\Num = #False
   
   XML = CreateXML( #PB_Any )
   If XML
      InsertXMLStructure( RootXMLNode(XML), @ThemeGUI, Theme_Structure)
      FormatXML(XML, #PB_XML_ReFormat)
      SaveXML(XML, File)
      FreeXML(XML)
   EndIf
   
   ThemeGUI\Font\Num = FontNum
   
EndProcedure

; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 127
; FirstLine = 143
; Folding = ------
; EnableXP
; DPIAware