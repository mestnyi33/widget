
CompilerIf #PB_Compiler_IsMainFile
   CompilerIf Not Defined( structures, #PB_Module )
      XIncludeFile "../structures.pbi"
   CompilerEndIf
CompilerEndIf
;
DeclareModule colors
   ;    Светлая тема (Light) 
   ;    Тёмная тема (Dark).
   Structure _s_PALETTE 
      Light.structures::_s_color
      Dark.structures::_s_color
      black.structures::_s_color
      grey.structures::_s_color
      blue.structures::_s_color
      green.structures::_s_color
      red.structures::_s_color
   EndStructure
   
   Global PALETTE._s_PALETTE
   
     Macro _get_colors_( ) 
      colors::PALETTE\Dark 
   EndMacro
   Declare  Init()
   Declare.l Extract(SourceColor.l, Factor.f, MakeLight.b = #True)
EndDeclareModule

Module colors
   Procedure Init()
       With PALETTE                        
      \Light\_alpha = 255
      \Dark\_alpha = 255
      \green\_alpha = 255
      \red\_alpha = 255
      \grey\_alpha = 255
      \black\_alpha = 255
      
      ; Светлая тема (Light) 
      ; Цвета по умолчанию
      \Light\front[0] = $ff2C2C2C ; $ff000001
      \Light\back[0] = $ffE2E2E2
      \Light\fore[0] = colors::Extract(\Light\back[0], 0.75, #True ) ; $ffF8F8F8
      \Light\frame[0] = $DE777D7E
      ; Debug Hex(colors::Extract(\Light\back[0], 0.75, #True ) , #PB_Long) 
      
      ; Цвета если мышь на виджете
      \Light\front[1] = $ff000000
      \Light\fore[1] = $FFFAF8F8
      \Light\back[1] = $ffFCEADA
      \Light\frame[1] = $ffFFC288
      
      ; Цвета если нажали на виджет
      \Light\front[2] = $FFFEFEFE
      \Light\fore[2] = $FFE9BA81
      \Light\back[2] = $FFE89C3D
      \Light\frame[2] = $FFDC9338
      
      ; Цвета если отключили виджет
      \Light\front[3] = $FFBABABA
      \Light\fore[3] = $FFF6F6F6 
      \Light\back[3] = $FFE2E2E2
      \Light\frame[3] = $FFCECECE
      
      ; Темная тема (Dark)
      ; Цвета по умолчанию
      \Dark\front[0] = $ffF8F8F8  ; Светлый текст
      \Dark\fore[0]  = $ff2D2D2D  ; Темный передний план виджета
      \Dark\back[0]  = $ff1E1E1E  ; Глубокий темный фон
      \Dark\frame[0] = $DE404040  ; Темно-серая рамка
      
      ; Цвета если мышь на виджете
      \Dark\front[1] = $ffFFFFFF  ; Яркий белый текст
      \Dark\fore[1]  = $ff3D3D3D  ; Чуть более светлый фон при наведении
      \Dark\back[1]  = $ff4A3B2C  ; Темно-оранжевый/коричневатый оттенок фона
      \Dark\frame[1] = $ffD48A37  ; Приглушенная оранжевая рамка
      
      ; Цвета если нажали на виджет
      \Dark\front[2] = $ff1E1E1E  ; Темный текст для контраста на ярком фоне
      \Dark\fore[2]  = $ffE89C3D  ; Яркий оранжевый передний план
      \Dark\back[2]  = $ffFFB354  ; Светло-оранжевый акцентный фон
      \Dark\frame[2] = $ffE89C3D  ; Оранжевая рамка
      
      ; Цвета если отключили виджет
      \Dark\front[3] = $ff5A5A5A  ; Заблокированный (серый) текст
      \Dark\fore[3]  = $ff252525  ; Очень темный fore-план
      \Dark\back[3]  = $ff1E1E1E  ; Стандартный темный фон
      \Dark\frame[3] = $ff333333  ; Едва заметная серая рамка
      
      ;- green - (зеленые цвета)
      ; Цвета по умолчанию
      \green\front[0] = $FF000000
      \green\fore[0] = $FFFFFFFF
      \green\back[0] = $FFDAFCE1  
      \green\frame[0] = $FF6AFF70 
      
      ; Цвета если мышь на виджете
      \green\front[1] = $FF000000
      \green\fore[1] = $FFE7FFEC
      \green\back[1] = $FFBCFFC5
      \green\frame[1] = $FF46E064
      
      ; Цвета если нажали на виджет
      \green\front[2] = $FFFEFEFE
      \green\fore[2] = $FFC3FDB7
      \green\back[2] = $FF00B002
      \green\frame[2] = $FF23BE03
      
      ; Цвета если отключили виджет
      \green\front[3] = $FFBABABA
      \green\fore[3] = $FFFFFFFF
      \green\back[3] = $FFDAFCE1  
      \green\frame[3] = $CA6AFF70 
      
      ;- red - (красные цвета)
      ; Цвета по умолчанию
      \red\front[0] = $FF000000
      \red\fore[0] = $FFFFFFFF
      \red\back[0] = $FFB4B4E1  
      \red\frame[0] = $FF7878E1 
      
      ; Цвета если мышь на виджете
      \red\front[1] = $FF000000
      \red\fore[1] = $FFE7FFEC
      \red\back[1] = $FF9696E1
      \red\frame[1] = $FF4646E1
      
      ; Цвета если нажали на виджет
      \red\front[2] = $FFFEFEFE
      \red\fore[2] = $FFC3FDB7
      \red\back[2] = $FF5F5EEE
      \red\frame[2] = $FF3333F0
      
      ; Цвета если отключили виджет
      \red\front[3] = $FFBABABA
      \red\fore[3] = $FFFFFFFF
      \red\back[3] = $FFDAFCE1  
      \red\frame[3] = $CA6AFF70 
      
      ;- blue - (синие цвета)
      ;- grey - (серые цвета)
      ; Цвета по умолчанию
      \grey\front[0] = $ff000000
      \grey\fore[0] = $FFF6F6F6
      \grey\back[0] = $FFE8E8E8
      \grey\frame[0] = $FFBABABA
      
      ; Цвета если курсор на виджете
      \grey\front[1] = $ff000000
      \grey\fore[1] = $FFF2F2F2 
      \grey\back[1] = $FFDCDCDC 
      \grey\frame[1] = $FFB0B0B0 
      
      ; Цвета если нажали на виджет
      \grey\front[2] = $ff000000
      \grey\fore[2] = $FFE2E2E2
      \grey\back[2] = $FFB4B4B4
      \grey\frame[2] = $FF6F6F6F
      
      ; Цвета если отключили виджет
      \grey\front[3] = $FFBABABA
      \grey\fore[3] = $FFF6F6F6 
      \grey\back[3] = $FFE2E2E2 
      \grey\frame[3] = $FFCECECE
      
      ;- black - (настоящие черные/темные цвета)
      ; Цвета по умолчанию (темная тема)
      \black\front[0] = $FFDDDDDD   ; Светло-серый текст на темном фоне
      \black\fore[0]  = $FF2D2D2D   ; Внутренние элементы
      \black\back[0]  = $FF1E1E1E   ; Глубокий темно-серый/черный фон
      \black\frame[0] = $FF3F3F3F   ; Темная рамка
      
      ; Цвета если курсор на виджете (чуть светлее)
      \black\front[1] = $FFFFFFFF   ; Белый текст
      \black\fore[1]  = $FF3D3D3D 
      \black\back[1]  = $FF2D2D2D   ; Фон подсвечивается
      \black\frame[1] = $FF555555   ; Рамка светлеет
      
      ; Цвета если нажали на виджет (акцентный серый)
      \black\front[2] = $FFFFFFFF
      \black\fore[2]  = $FF4A4A4A
      \black\back[2]  = $FF3A3A3A
      \black\frame[2] = $FF6E6E6E
      
      ; Цвета если отключили виджет (блеклый темный)
      \black\front[3] = $FF666666   ; Заблокированный текст
      \black\fore[3]  = $FF222222 
      \black\back[3]  = $FF1A1A1A 
      \black\frame[3] = $FF2A2A2A
   EndWith
   

      EndProcedure
   
    ; Универсальная функция изменения яркости цвета
   Procedure.l Extract(SourceColor.l, Factor.f, MakeLight.b = #True)
      ;    Factor: от 0.0 до 1.0 (0.0 — исходный цвет, 1.0 — чистый белый или черный)
      ;    • 0.10 (или 10%) — Едва заметное изменение. Отлично подходит для подсветки кнопки, когда на неё наводят курсор мыши (чуть-чуть подсветить или притемнить).
      ;    • 0.20 (или 20%) — Мягкое изменение. Хорошо подходит для создания границ, рамок или разделения блоков в интерфейсе.
      ;    • 0.40 (или 40%) — Контрастное изменение. Используется для создания красивых градиентов или выделения активных элементов.
      ;    • 0.70 (или 70%) — Сильное изменение. Идеально, чтобы сделать из обычного цвета глубокий темный (для ночной темы) или почти белый (для светлой темы).
      ;
      ; 1. Извлекаем отдельные каналы исходного цвета
      Protected r.l = Red(SourceColor)
      Protected g.l = Green(SourceColor)
      Protected b.l = Blue(SourceColor)
      Protected a.l = Alpha(SourceColor)
      
      ; Ограничиваем фактор в разумных пределах (0.0 - 1.0)
      If Factor < 0.0 : Factor = 0.0 : EndIf
      If Factor > 1.0 : Factor = 1.0 : EndIf
      
      Protected NewR.l, NewG.l, NewB.l
      
      If MakeLight
         ; ФОРМУЛА ОСВЕТЛЕНИЯ (смешивание с белым цветом 255)
         ; New = Current + (255 - Current) * Factor
         NewR = r + (255 - r) * Factor
         NewG = g + (255 - g) * Factor
         NewB = b + (255 - b) * Factor
      Else
         ; ФОРМУЛА ЗАТЕМНЕНИЯ (смешивание с черным цветом 0)
         ; New = Current - Current * Factor
         NewR = r - r * Factor
         NewG = g - g * Factor
         NewB = b - b * Factor
      EndIf
      
      ; Собираем цвет обратно в формат RGBA
      ProcedureReturn RGBA(NewR, NewG, NewB, a)
   EndProcedure
   
EndModule

colors::Init()

; CompilerSelect #PB_Compiler_OS
;   CompilerCase #PB_OS_Windows
;     CanvasEx()\Scrollbar\Color\Front  = GetSysColor_(#COLOR_SCROLLBAR)
;     CanvasEx()\Scrollbar\Color\Button = GetSysColor_(#COLOR_BTNFACE)
;     CanvasEx()\Scrollbar\Color\Focus  = GetSysColor_(#COLOR_MENUHILIGHT)
;     CanvasEx()\Scrollbar\Color\Hover  = GetSysColor_(#COLOR_ACTIVEBORDER)
;     CanvasEx()\Scrollbar\Color\Arrow  = GetSysColor_(#COLOR_GRAYTEXT)
;     CanvasEx()\Scrollbar\Color\Back   = GetSysColor_(#COLOR_MENU)
;     CanvasEx()\Color\Gadget           = GetSysColor_(#COLOR_MENU)
;   CompilerCase #PB_OS_MacOS
;     CanvasEx()\Scrollbar\Color\Front  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
;     CanvasEx()\Scrollbar\Color\Button = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
;     CanvasEx()\Scrollbar\Color\Focus  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedControlColor"))
;     CanvasEx()\Scrollbar\Color\Hover  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
;     CanvasEx()\Scrollbar\Color\Arrow  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
;     CanvasEx()\Scrollbar\Color\Back   = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
;     CanvasEx()\Color\Gadget           = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
;   CompilerCase #PB_OS_Linux
;     
; CompilerEndSelect

;     CompilerSelect #PB_Compiler_OS ;{ Color
;       CompilerCase #PB_OS_Windows
;         colors::_get_colors_( )\Front         = GetSysColor_(#COLOR_WINDOWTEXT)
;         colors::_get_colors_( )\Back          = GetSysColor_(#COLOR_WINDOW)
;         colors::_get_colors_( )\Focus         = GetSysColor_(#COLOR_HIGHLIGHT)
;         colors::_get_colors_( )\Gadget        = GetSysColor_(#COLOR_mENU)
;         colors::_get_colors_( )\Button        = GetSysColor_(#COLOR_3DLIGHT)
;         colors::_get_colors_( )\Border        = GetSysColor_(#COLOR_WINDOWFRAME)
;         colors::_get_colors_( )\WordColor     = GetSysColor_(#COLOR_HOTLIGHT)
;         colors::_get_colors_( )\Highlight     = GetSysColor_(#COLOR_HIGHLIGHT)
;         colors::_get_colors_( )\HighlightText = GetSysColor_(#COLOR_HIGHLIGHTTEXT)
;
;       CompilerCase #PB_OS_MacOS
;         colors::_get_colors_( )\Front         = OSX_NSColorToRGBa(CocoaMessage(0, 0, "NSColor textColor"))
;         ;colors::_get_colors_( )\Back          = BlendColor_(OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textBackgroundColor")), $FFFFFF, 80)
;         ;colors::_get_colors_( )\back[2]      = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor keyboardFocusIndicatorColor"))
;         ;colors::_get_colors_( )\Back         = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
;         colors::_get_colors_( )\Back         = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
;         colors::_get_colors_( )\frame         = OSX_NSColorToRGBa(CocoaMessage(0, 0, "NSColor grayColor"))
;         ;colors::_get_colors_( )\back[2]       = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedTextBackgroundColor"))
;         ;colors::_get_colors_( )\front[2]      = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedTextColor"))
;       CompilerCase #PB_OS_Linux
;
;     CompilerEndSelect ;}

CompilerIf #PB_Compiler_IsMainFile
  ;- --- ПРОВЕРКА НА ВАШИХ ЦВЕТАХ ---
   ; Наш исходный цвет (светло-серый из первого вопроса)
   BaseColor = $ffE2E2E2 
   
   ; 1. Чтобы получить ТОЧНЫЙ темно-серый $ff404040 из $ffE2E2E2, фактор затемнения должен быть ~0.716
   DarkGray = Colors::Extract(BaseColor, 0.716, #False)
   Debug "Получили темно-серый: $" + Hex(DarkGray, #PB_Long) ; Выведет $FF404040
   
   ; 2. Чтобы получить ТОЧНЫЙ светло-серый $ffD3D3D3, мы можем взять стандартный серый ($ff808080)
   ; и применить фактор осветления ~0.65
   StandardGray = $ff808080
   LightGray = Colors::Extract(StandardGray, 0.65, #True)
   Debug "Получили светло-серый: $" + Hex(LightGray, #PB_Long) ; Выведет $FFD3D3D3
   
   
   ;- --- РАБОТА С ДРУГИМИ ЦВЕТАМИ (Пример) ---
   
   BlueColor = RGBA(0, 0, 255, 255) ; Чистый синий
   
   ; Делаем светло-синий (небесный)
   LightBlue = Colors::Extract(BlueColor, 0.5, #True)
   Debug "Светло-синий: R=" + Red(LightBlue) + " G=" + Green(LightBlue) + " B=" + Blue(LightBlue)
   
   ; Делаем темно-синий (navy)
   DarkBlue = Colors::Extract(BlueColor, 0.5, #False)
   Debug "Темно-синий: R=" + Red(DarkBlue) + " G=" + Green(DarkBlue) + " B=" + Blue(DarkBlue)
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 23
; FirstLine = 12
; Folding = -0-
; EnableXP