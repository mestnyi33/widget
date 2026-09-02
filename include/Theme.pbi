; ==============================================================================
; ЧАСТЬ 1: ПЕРЕЧИСЛЕНИЯ И СТРУКТУРЫ (КОНФИГУРАЦИЯ ТЕМЫ)
; ==============================================================================

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
; ==============================================================================
; ЧАСТЬ 2: ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ И СИСТЕМНЫЙ API (КРОССПЛАТФОРМА)
; ==============================================================================

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
; ==============================================================================
; ЧАСТЬ 3: ОСНОВНЫЕ ЦВЕТОВЫЕ ТЕМЫ (BLUE, GREEN, DARKBLUE, DARK)
; ==============================================================================

Procedure SetTheme(Theme.i=#PB_Default)
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
         ThemeGUI\Progress\FrontColor    = $CB9755
         ThemeGUI\Progress\BackColor     = #PB_Default
         ThemeGUI\Progress\GradientColor = $B06400
         ThemeGUI\Progress\BorderColor   = $B06400
         ThemeGUI\WindowColor            = $342B1D
         ThemeGUI\GadgetColor            = $342B1D
         ThemeGUI\Disable\FrontColor     = $72727D
         ThemeGUI\Disable\BackColor      = $CCCCCA
         ThemeGUI\Disable\BorderColor    = $72727D
         ;}
         ; ==============================================================================
         ; ЧАСТЬ 4: ДЕФОЛТНАЯ ТЕМА ПО ОС И ФУНКЦИИ XML СОХРАНЕНИЯ/ЗАГРУЗКИ
         ; ==============================================================================
         
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
   
   XML = CreateXML(#PB_Any)
   If XML
      InsertXMLStructure(RootXMLNode(XML), @ThemeGUI, Theme_Structure)
      FormatXML(XML, #PB_XML_ReFormat)
      SaveXML(XML, File)
      FreeXML(XML)
   EndIf
   
   ThemeGUI\Font\Num = FontNum
EndProcedure


;-
CompilerIf #PB_Compiler_IsMainFile
   
   Enumeration
      #Window_Main
      #Canvas_Player
      #Button_LoadXML
      #Button_SaveXML
   EndEnumeration
   
   ; Переменные состояния для интерактива
   Global VolumeLevel.f = 0.75   ; Значение слайдера громкости (0.0 - 1.0)
   Global TrackProgress.f = 0.42 ; Значение прогресса трека (0.0 - 1.0)
   Global HoveredControl.i = 0   ; 1 = Назад, 2 = Плей, 3 = Вперед, 4 = Прогресс, 5 = Громкость
   
   Procedure Triangle(X1.i, Y1.i, X2.i, Y2.i, X3.i, Y3.i, Color.i)
      ; Создаем векторный контекст на базе текущего 2D-Drawing вывода
      If StartVectorDrawing(CanvasVectorOutput(#Canvas_Player))
         
         ; Переносим курсор в первую точку
         MovePathCursor(X1, Y1)
         
         ; Чертим линии до второй и третьей точек
         AddPathLine(X2, Y2)
         AddPathLine(X3, Y3)
         
         ; Замыкаем треугольник обратно на первую точку
         ClosePath()
         
         ; Задаем цвет (поддерживается прозрачность, если нужно)
         VectorSourceColor(Color | $FF000000)
         
         ; Заливаем внутреннюю область треугольника сглаженным цветом
         FillPath()
         
         StopVectorDrawing()
      EndIf
   EndProcedure
   
   ; Процедура отрисовки мощного медиаплеера на Canvas
   Procedure RedrawPlayer()
      Protected TargetColor.i, FillW.i
      
      If StartDrawing(CanvasOutput(#Canvas_Player))
         
         ; 1. ФОН ПЛЕЕРА И ОКРЫВАЮЩАЯ РАМКА
         Box(0, 0, OutputWidth(), OutputHeight(), ThemeGUI\BackColor)
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(0, 0, OutputWidth(), OutputHeight(), ThemeGUI\BorderColor)
         
         ; 2. ШАПКА ТРЕКА (Используем структуру Title)
         DrawingMode(#PB_2DDrawing_Default)
         Box(1, 1, OutputWidth()-2, 45, ThemeGUI\Title\BackColor)
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(15, 14, "Сейчас играет: PureBasic Crossplatform Synth.wav", ThemeGUI\Title\FrontColor)
         
         ; Разделительная линия (LineColor)
         DrawingMode(#PB_2DDrawing_Default)
         Box(0, 46, OutputWidth(), 1, ThemeGUI\LineColor)
         
         ; 3. ДЕКОРАТИВНЫЙ СПЕКТРОГРАММНЫЙ СЕТОЧНЫЙ ФОН (RowColor / GreyTextColor)
         Protected X.i, BarH.i
         For X = 15 To OutputWidth() - 15 Step 8
            BarH = 20 + Sin(X * 0.05 + TrackProgress * 10) * 15 + Random(5)
            Box(X, 110 - BarH, 5, BarH, ThemeGUI\RowColor)
         Next
         
         ; 4. ТРЭК-БАР / ПРОГРЕСС (Используем структуру Progress)
         ; Фон дорожки
         Box(15, 130, OutputWidth()-30, 8, ThemeGUI\Progress\BackColor)
         ; Рамка дорожки
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(15, 130, OutputWidth()-30, 8, ThemeGUI\Progress\BorderColor)
         ; Заполнение (Градиент имитируем смешиванием FrontColor и GradientColor)
         DrawingMode(#PB_2DDrawing_Default)
         FillW = (OutputWidth()-32) * TrackProgress
         If FillW > 0
            Box(16, 131, FillW, 6, ThemeGUI\Progress\FrontColor)
         EndIf
         ; Ползунок прогресса (если наведен - подсвечиваем Focus)
         If HoveredControl = 4
            TargetColor = ThemeGUI\Focus\BackColor
         Else 
            TargetColor = ThemeGUI\Progress\GradientColor
         EndIf
         Box(15 + FillW - 3, 126, 8, 16, TargetColor)
         
         ; Текст времени
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(15, 145, "02:14", ThemeGUI\GreyTextColor)
         DrawText(OutputWidth() - 55, 145, "-03:05", ThemeGUI\GreyTextColor)
         
         ; 5. КНОПКИ УПРАВЛЕНИЯ (Используем структуру Button и Disable)
         ; Кнопка "Назад"
         If HoveredControl = 1
            TargetColor = ThemeGUI\Focus\BackColor
         Else 
            TargetColor = ThemeGUI\Button\BackColor
         EndIf
         Box(110, 180, 40, 40, TargetColor)
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(110, 180, 40, 40, ThemeGUI\Button\BorderColor)
         ; Стрелочка влево
         DrawingMode(#PB_2DDrawing_Default)
         Triangle(133, 193, 133, 207, 122, 200, ThemeGUI\Button\FrontColor)
         Triangle(125, 193, 125, 207, 114, 200, ThemeGUI\Button\FrontColor)
         
         ; Кнопка "PLAY / PAUSE" (Главная кнопка)
         If HoveredControl = 2
            TargetColor = ThemeGUI\Focus\BackColor
         Else 
            TargetColor = ThemeGUI\Button\BackColor
         EndIf
         Box(165, 175, 50, 50, TargetColor)
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(165, 175, 50, 50, ThemeGUI\Button\BorderColor)
         ; Иконка Паузы
         DrawingMode(#PB_2DDrawing_Default)
         Box(183, 190, 5, 20, ThemeGUI\Button\FrontColor)
         Box(192, 190, 5, 20, ThemeGUI\Button\FrontColor)
         
         ; Кнопка "Вперед"
         If HoveredControl = 3
            TargetColor = ThemeGUI\Focus\BackColor
         Else 
            TargetColor = ThemeGUI\Button\BackColor
         EndIf
         Box(230, 180, 40, 40, TargetColor)
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(230, 180, 40, 40, ThemeGUI\Button\BorderColor)
         ; Стрелочка вправо
         DrawingMode(#PB_2DDrawing_Default)
         Triangle(237, 193, 237, 207, 248, 200, ThemeGUI\Button\FrontColor)
         Triangle(245, 193, 245, 207, 256, 200, ThemeGUI\Button\FrontColor)
         
         ; 6. КОНТРОЛ ГРОМКОСТИ (Используем SwitchColor и Slider-логику)
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(20, 243, "VOL:", ThemeGUI\GreyTextColor)
         ; Линия слайдера громкости
         DrawingMode(#PB_2DDrawing_Default)
         Box(60, 250, 100, 4, ThemeGUI\Button\SwitchColor)
         ; Заполненная часть
         Box(60, 250, 100 * VolumeLevel, 4, ThemeGUI\Progress\FrontColor)
         ; Круглый ползунок громкости
         If HoveredControl = 5
            TargetColor = ThemeGUI\Focus\BackColor
         Else 
            TargetColor = ThemeGUI\Button\BorderColor
         EndIf
         Circle(60 + (100 * VolumeLevel), 252, 6, TargetColor)
         
         ; Текст состояния инфо-панели (Используем Disable структуру для симуляции неактивного текста)
         Box(180, 244, 190, 22, ThemeGUI\Disable\BackColor)
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(180, 244, 190, 22, ThemeGUI\Disable\BorderColor)
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(190, 247, "РЕЖИМ СТЕРЕО 44.1 kHz", ThemeGUI\Disable\FrontColor)
         
         StopDrawing()
      EndIf
   EndProcedure
   
   ; --- ТОЧКА ВХОДА ПРИЛОЖЕНИЯ ---
   
   ; Инициализируем стартовую тему
   SetTheme(#Theme_Default)
   
   If OpenWindow(#Window_Main, 0, 0, 400, 360, "Демонстрация мощи Theme Library", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      ; Создаем наш кастомный Canvas-виджет плеера
      CanvasGadget(#Canvas_Player, 10, 10, 380, 290)
      
      ; Стандартные кнопки для демонстрации XML-сохранения / загрузки
      ButtonGadget(#Button_LoadXML, 10, 315, 185, 30, "Загрузить тему из XML")
      ButtonGadget(#Button_SaveXML, 205, 315, 185, 30, "Сохранить тему в XML")
      
      ; Первичный рендер плеера
      RedrawPlayer()
      
      ; Добавим таймер для анимации спектрограммы и трека (симулируем проигрывание)
      AddWindowTimer(#Window_Main, #Event_Timer, 80)
      
      ; ГЛАВНЫЙ ЦИКЛ ОБРАБОТКИ СОБЫТИЙ
      Repeat
         Define Event = WaitWindowEvent()
         
         Select Event
            Case #PB_Event_Timer
               If EventTimer() = #Event_Timer
                  ; Продвигаем трек вперед и обновляем анимацию
                  TrackProgress + 0.002
                  If TrackProgress > 1.0 : TrackProgress = 0.0 : EndIf
                  RedrawPlayer()
               EndIf
               
            Case #PB_Event_Gadget
               Select EventGadget()
                     
                  Case #Button_SaveXML
                     ; Демонстрируем сохранение структуры со всеми подструктурами в читаемый XML файл!
                     ; Сначала переключимся на интересную тему, чтобы файл не был пустым
                     SetTheme(#Theme_DarkBlue)
                     If SaveTheme("DemoTheme.xml")
                        MessageRequester("Успех", "Текущая палитра (DarkBlue) полностью выгружена в файл DemoTheme.xml!", #PB_MessageRequester_Info)
                     EndIf
                     
                  Case #Button_LoadXML
                     ; Демонстрируем горячую загрузку внешней конфигурации
                     If FileSize("DemoTheme.xml") > 0
                        If LoadTheme("DemoTheme.xml")
                           MessageRequester("Успех", "Структура ThemeGUI мгновенно перестроена из внешнего XML-файла!", #PB_MessageRequester_Info)
                        EndIf
                     Else
                        MessageRequester("Ошибка", "Сначала нажмите кнопку 'Сохранить тему в XML' для генерации файла!", #PB_MessageRequester_Error)
                     EndIf
                     
                  Case #Canvas_Player
                     ; Интерактивная обработка мыши над плеером
                     Define MouseX.i = GetGadgetAttribute(#Canvas_Player, #PB_Canvas_MouseX)
                     Define MouseY.i = GetGadgetAttribute(#Canvas_Player, #PB_Canvas_MouseY)
                     Define OldHover.i = HoveredControl
                     
                     Select EventType()
                        Case #PB_EventType_MouseMove, #PB_EventType_LeftButtonDown
                           
                           ; Вычисляем, над каким элементом управления находится мышь
                           If MouseY >= 180 And MouseY <= 220 And MouseX >= 110 And MouseX <= 150
                              HoveredControl = 1 ; Назад
                           ElseIf MouseY >= 175 And MouseY <= 225 And MouseX >= 165 And MouseX <= 215
                              HoveredControl = 2 ; Плей
                           ElseIf MouseY >= 180 And MouseY <= 220 And MouseX >= 230 And MouseX <= 270
                              HoveredControl = 3 ; Вперед
                           ElseIf MouseY >= 125 And MouseY <= 142 And MouseX >= 15 And MouseX <= 365
                              HoveredControl = 4 ; Таймлайн прогресса
                                                 ; Если зажата кнопка мыши - перематываем
                              If GetGadgetAttribute(#Canvas_Player, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton
                                 TrackProgress = (MouseX - 15) / 350.0
                                 If TrackProgress < 0 : TrackProgress = 0 : EndIf
                                 If TrackProgress > 1 : TrackProgress = 1 : EndIf
                              EndIf
                           ElseIf MouseY >= 240 And MouseY <= 265 And MouseX >= 60 And MouseX <= 160
                              HoveredControl = 5 ; Ползунок громкости
                              If GetGadgetAttribute(#Canvas_Player, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton
                                 VolumeLevel = (MouseX - 60) / 100.0
                                 If VolumeLevel < 0 : VolumeLevel = 0 : EndIf
                                 If VolumeLevel > 1 : VolumeLevel = 1 : EndIf
                              EndIf
                           Else
                              HoveredControl = 0 ; Мимо
                           EndIf
                           
                           ; Динамически меняем темы интерфейса в зависимости от зоны фокуса!
                           If HoveredControl <> OldHover
                              Select HoveredControl
                                 Case 2     : SetTheme(#Theme_Green)    ; Кнопка Плей окрашивает плеер в зеленый
                                 Case 4     : SetTheme(#Theme_Blue)     ; Прогресс-бар уходит в синий тон
                                 Case 5     : SetTheme(#Theme_Dark)     ; Управление громкостью переводит в ночной режим
                                 Default    : SetTheme(#Theme_DarkBlue) ; Обычное состояние — стильный DarkBlue
                              EndSelect
                           EndIf
                           
                        Case #PB_EventType_MouseLeave
                           HoveredControl = 0
                           SetTheme(#Theme_Default) ; Когда мышь уходит, плеер сбрасывается в нативный цвет ОС
                     EndSelect
                     
               EndSelect
               
               ; 3. ГЛОБАЛЬНЫЙ ОТВЕТ НА СМЕНУ ТЕМЫ СИСТЕМЫ
            Case #Event_Theme
               ; Синхронно перекрашиваем бэкграунд самого системного окна Windows/macOS/Linux
               If ThemeGUI\WindowColor <> #PB_Default
                  SetWindowColor(#Window_Main, ThemeGUI\WindowColor)
               Else
                  SetWindowColor(#Window_Main, #PB_Default)
               EndIf
               ; Перерисовываем Canvas-элемент новыми цветами из структуры ThemeGUIRedrawPlayer()
            Case #PB_Event_CloseWindow
               End
         EndSelect
      ForEver
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 723
; FirstLine = 706
; Folding = -----------
; EnableXP
; DPIAware