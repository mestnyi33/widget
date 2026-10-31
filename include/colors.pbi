
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
      light.structures::_s_color
      dark.structures::_s_color
      black.structures::_s_color
      gray.structures::_s_color
      blue.structures::_s_color
      green.structures::_s_color
      red.structures::_s_color
   EndStructure
   
   Global PALETTE._s_PALETTE
   
   Macro _get_colors_( ) 
      colors::PALETTE\light
   EndMacro
   Declare  Init()
   Declare.l Extract(SourceColor.l, Factor.f, MakeLight.b = #True)
EndDeclareModule

Module colors
   Procedure Init()
      Protected i 
      With PALETTE                        
         \Light\_alpha = 255
         \green\_alpha = 255
         \red\_alpha = 255
         \blue\_alpha = 255
         \gray\_alpha = 255
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
         
         ;- Dark - (Правильная темная тема с оранжевым акцентом)
         ; Цвета по умолчанию (Спокойный благородный темный стиль)
         i=0
         \Dark\front[i] = $FFF8F8F8   ; Белый текст
         \Dark\fore[i]  = $FF2A2A2A   ; Темное тело виджета
         \Dark\back[i]  = $FF1E1E1E   ; Глубокий фон
         \Dark\frame[i] = $FF454545   ; Аккуратная рамка
         
         ; Цвета если мышь на виджете (Появляется мягкий оранжевый акцент)
         i=1
         \Dark\front[i] = $FFFFFFFF   ; Текст горит белым
         \Dark\fore[i]  = $FF353535   ; Тело виджета чуть светлеет
         \Dark\back[i]  = $FF1E1E1E 
         \Dark\frame[i] = $FF0070E5   ; НАСТОЯЩАЯ оранжевая рамка в PureBasic (BB=00, GG=70, RR=E5)
         
         ; Цвета если нажали на виджет (Интенсивный клик)
         i=2
         \Dark\front[i] = $FFFFFFFF 
         \Dark\fore[i]  = $FF0050B5   ; Темно-оранжевое зажатое тело виджета
         \Dark\back[i]  = $FF1E1E1E 
         \Dark\frame[i] = $FF0080FF   ; Яркая оранжевая вспышка на рамке
         
         ; Цвета если отключили виджет
         i=3
         \Dark\front[i] = $FF5A5A5A   ; Выключенный текст
         \Dark\fore[i]  = $FF222222 
         \Dark\back[i]  = $FF1E1E1E 
         \Dark\frame[i] = $FF333333   ; Оранжевый полностью пропадает, виджет «тухнет»

         ;- green - (зеленые цвета)
         ; Цвета по умолчанию (Мягкий пастельно-зеленый фон, четкая рамка)
         \green\front[0] = $FF000000  ; Черный текст (отлично читается на светлом фоне)
         \green\fore[0]  = $FFFFFFFF  ; Белый внутренний элемент
         \green\back[0]  = $FFB4E1B4  ; Светло-салатовый / пастельно-зеленый фон (GG = E1)
         \green\frame[0] = $FF78E178  ; Чистый зеленый для рамки (темнее и строже фона)
         
         ; Цвета если мышь на виджете (Цвета становятся сочнее и ярче)
         \green\front[1] = $FF000000  ; Черный текст
         \green\fore[1]  = $FFE7FFE7  ; Очень светлый, почти белый мятный оттенок
         \green\back[1]  = $FF96E196  ; Насыщенный салатовый фон
         \green\frame[1] = $FF46E146  ; Яркая, сочная зеленая рамка
         
         ; Цвета если нажали на виджет (Инверсия: глубокий темно-зеленый фон, белый текст)
         \green\front[2] = $FFFEFEFE  ; Белый текст (для контраста на темном)
         \green\fore[2]  = $FFB7FDB7  ; Светло-зеленый элемент
         \green\back[2]  = $FF5FE15F  ; Глубокий, плотный зеленый фон
         \green\frame[2] = $FF33F033  ; Очень темная, изумрудно-зеленая рамка (GG = F0)
         
         ; Цвета если отключили виджет (Полупрозрачный блекло-зеленый)
         \green\front[3] = $FFBABABA  ; Серый неактивный текст
         \green\fore[3]  = $FFFFFFFF  ; Белый элемент
         \green\back[3]  = $FFDAFCDA  ; Выцветший, приглушенный серо-зеленый фон
         \green\frame[3] = $CA6AF06A  ; Полупрозрачная ($CA) аккуратная зеленая рамка (GG = F0)

         ;- red - (красные цвета)
         ; Цвета по умолчанию (Мягкий красный фон, четкая рамка)
         \red\front[0] = $FF000000  ; Черный текст (максимально читаемый)
         \red\fore[0]  = $FFFFFFFF  ; Белый внутренний элемент
         \red\back[0]  = $FFB4B4E1  ; Светло-розово-красный фон
         \red\frame[0] = $FF7878E1  ; Приглушенный красный для рамки (темнее фона)
         
         ; Цвета если мышь на виджете (Цвета становятся ярче и сочнее)
         \red\front[1] = $FF000000  ; Черный текст
         \red\fore[1]  = $FFE7E7FF  ; Очень светлый розовый (вместо зеленоватого $FFE7FFEC)
         \red\back[1]  = $FF9696E1  ; Насыщенный красный фон
         \red\frame[1] = $FF4646E1  ; Яркая, глубокая красная рамка
         
         ; Цвета если нажали на виджет (Инверсия: темный фон, белый текст)
         \red\front[2] = $FFFEFEFE  ; Белый текст (чтобы читался на темном)
         \red\fore[2]  = $FFB7C3FD  ; Светло-багровый элемент (вместо зеленого $FFC3FDB7)
         \red\back[2]  = $FF5E5FE1  ; Глубокий, плотный красный фон (исправили $FF5F5EEE, где доминировал синий)
         \red\frame[2] = $FF3333F0  ; Очень темная, почти бордовая рамка ($F0 на конце — максимум красного!)
         
         ; Цвета если отключили виджет (Полупрозрачный блекло-красный)
         \red\front[3] = $FFBABABA  ; Серый неактивный текст
         \red\fore[3]  = $FFFFFFFF  ; Белый элемент
         \red\back[3]  = $FFE1DAFC  ; Выцветший, пастельный красно-серый фон (исправили зеленый $FFDAFCE1)
         \red\frame[3] = $CA706AF0  ; Полупрозрачная ($CA) аккуратная красная рамка ($F0 на конце вместо $70)

        ;- blue - (синие цвета)
         ; Цвета по умолчанию (Нежный пастельно-синий фон, четкая рамка)
         i=0
         \blue\front[i] = $FF000000  ; Черный текст (отлично читается на светлом фоне)
         \blue\fore[i]  = $FFFFFFFF  ; Белый внутренний элемент
         \blue\back[i]  = $FFE1B4B4  ; Светло-голубой / пастельно-синий фон (BB = E1)
         \blue\frame[i] = $FFE17878  ; Спокойный синий для рамки (темнее и строже фона)
         
         ; Цвета если мышь на виджете (Цвета становятся глубже и сочнее)
         i=1
         \blue\front[i] = $FF000000  ; Черный текст
         \blue\fore[i]  = $FFFFE7E7  ; Очень светлый, почти белый ледяной оттенок
         \blue\back[i]  = $FFE19696  ; Насыщенный сине-голубой фон
         \blue\frame[i] = $FFE14646  ; Яркая, выразительная синяя рамка
         
         ; Цвета если нажали на виджет (Инверсия: глубокий темно-синий фон, белый текст)
         i=2
         \blue\front[i] = $FFFEFEFE  ; Белый текст (для контраста на темном фоне)
         \blue\fore[i]  = $FFFDB7B7  ; Светло-синий элемент
         \blue\back[i]  = $FFE15F5F  ; Глубокий, плотный синий фон
         \blue\frame[i] = $FFF03333  ; Очень темная, ультрамариновая рамка (BB = F0)
         
         ; Цвета если отключили виджет (Полупрозрачный блекло-синий)
         i=3
         \blue\front[i] = $FFBABABA  ; Серый неактивный текст
         \blue\fore[i]  = $FFFFFFFF  ; Белый элемент
         \blue\back[i]  = $FFFCDADA  ; Выцветший, приглушенный серо-синий фон
         \blue\frame[i] = $CAF06A6A  ; Полупрозрачная ($CA) аккуратная синяя рамка (BB = F0)
         
         ;- gray - (серые цвета)
         ; Цвета по умолчанию (Светло-серый офисный стиль)
         i=0
         \gray\front[i] = $FF000000  ; Черный текст (максимальный контраст)
         \gray\fore[i]  = $FFFFFFFF  ; Белый внутренний элемент
         \gray\back[i]  = $FFE0E0E0  ; Светло-серый фон кнопки
         \gray\frame[i] = $FFA0A0A0  ; Умеренно-серый цвет для аккуратной рамки
         
         ; Цвета если мышь на виджете (Кнопка слегка темнеет, показывая фокус)
         i=1
         \gray\front[i] = $FF000000  ; Черный текст
         \gray\fore[i]  = $FFF5F5F5  ; Почти белый элемент
         \gray\back[i]  = $FFCCCCCC  ; Более насыщенный серый фон
         \gray\frame[i] = $FF888888  ; Четкая темно-серая рамка
         
         ; Цвета если нажали на виджет (Инверсия: темно-серый/графитовый виджет)
         i=2
         \gray\front[i] = $FFFEFEFE  ; Белый текст (чтобы отлично читался на темном)
         \gray\fore[i]  = $FFE0E0E0  ; Светло-серый элемент внутри кнопки
         \gray\back[i]  = $FF555555  ; Темно-серый (графитовый) фон
         \gray\frame[i] = $FF333333  ; Очень темная, почти черная рамка
         
         ; Цвета если отключили виджет (Полупрозрачный размытый серый)
         i=3
         \gray\front = $FFBABABA  ; Серый неактивный текст
         \gray\fore  = $FFFFFFFF  ; Белый элемент
         \gray\back  = $FFF0F0F0  ; Очень блеклый, почти белый фон
         \gray\frame = $CA888888  ; Полупрозрачная ($CA) аккуратная серая рамка
         
         ;- black - (Правильная строгая темная тема)
         ; Цвета по умолчанию (Кнопка слегка выделяется на фоне окна)
         i=2
         \black\front[i] = $FFDDDDDD   ; Светло-серый читаемый текст
         \black\fore[i]  = $FF252525   ; Тело виджета (чуть светлее фона окна)
         \black\back[i]  = $FF1E1E1E   ; Общий фон подложки/окна
         \black\frame[i] = $FF555555   ; Четкая, видимая серая рамка
         
         ; Цвета если курсор на виджете (Эффект подсветки)
         i=0
         \black\front[i] = $FFFFFFFF   ; Чистый белый текст
         \black\fore[i]  = $FF353535   ; Тело виджета заметно светлеет
         \black\back[i]  = $FF1E1E1E 
         \black\frame[i] = $FF888888   ; Рамка ярко подсвечивается
         
         ; Цвета если нажали на виджет (Эффект ухода в тень / нажатия)
         i=1
         \black\front[i] = $FFAAAAAA   ; Текст чуть приглушается
         \black\fore[i]  = $FF151515   ; Тело виджета становится очень темным (вдавилось)
         \black\back[i]  = $FF1E1E1E 
         \black\frame[i] = $FF3A3A3A   ; Рамка темнеет
         
         ; Цвета если отключили виджет (Блеклый, плоский вид)
         i=3
         \black\front[i] = $FF666666   ; Заблокированный серый текст
         \black\fore[i]  = $FF1E1E1E   ; Сливается с фоном окна
         \black\back[i]  = $FF1E1E1E 
         \black\frame[i] = $FF2A2A2A   ; Едва заметный контур

;          ;- black - (настоящие черные/темные цвета)
;          ; Цвета по умолчанию (темная тема)
;          i = 0
;          \black\front[i] = $FFDDDDDD   ; Светло-серый текст на темном фоне
;          \black\fore[i]  = $FF2D2D2D   ; Внутренние элементы
;          \black\back[i]  = $FF1E1E1E   ; Глубокий темно-серый/черный фон
;          \black\frame[i] = $FF3F3F3F   ; Темная рамка
;          i=1
;          ; Цвета если курсор на виджете (чуть светлее)
;          \black\front[i] = $FFFFFFFF   ; Белый текст
;          \black\fore[i]  = $FF3D3D3D 
;          \black\back[i]  = $FF2D2D2D   ; Фон подсвечивается
;          \black\frame[i] = $FF555555   ; Рамка светлеет
;          i=2
;          ; Цвета если нажали на виджет (акцентный серый)
;          \black\front[i] = $FFFFFFFF
;          \black\fore[i]  = $FF4A4A4A
;          \black\back[i]  = $FF3A3A3A
;          \black\frame[i] = $FF6E6E6E
;          i=3
;          ; Цвета если отключили виджет (блеклый темный)
;          \black\front[i] = $FF666666   ; Заблокированный текст
;          \black\fore[i]  = $FF222222 
;          \black\back[i]  = $FF1A1A1A 
;          \black\frame[i] = $FF2A2A2A
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
;     CanvasEx()\Scrollbar\Color\Arrow  = GetSysColor_(#COLOR_grayTEXT)
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
   
   
   
   ; --- НОМЕРА ГАДЖЕТОВ ДЛЯ УДОБСТВА ---
Enumeration
  #MainCanvas
  #SliderR
  #SliderG
  #SliderB
  #SliderA
  #LabelR
  #LabelG
  #LabelB
  #LabelA
EndEnumeration

   ; --- СТРУКТУРЫ И ЛОГИКА ---
Structure WidgetPalette
   bgNormal.l 
   bgHover.l 
   bgActive.l 
   bgPressed.l
   
   borderNormal.l 
   borderHover.l 
   borderActive.l 
   borderPressed.l
   
   textNormal.l 
   textHover.l
EndStructure

Structure WidgetState
   isHover.b
   isActive.b
   isPressed.b
EndStructure

; Единая структура для всех элементов UI
Structure Widget
   logX.i : logY.i : logW.i : logH.i ; Логические (исходные) координаты
   physX.i : physY.i : physW.i : physH.i : physRadius.i ; Физические (скалированные) координаты
   text.s
   color.l
   state.WidgetState
EndStructure

Global MainBtn.Widget
; Круглые селекторы цвета (теперь как массив виджетов со своими координатами)
Global Dim LogSelX.i(2) : LogSelX(0) = 65  : LogSelX(1) = 105 : LogSelX(2) = 145
Global Dim ColorSels.Widget(2)
; --- ГЛОБАЛЬНЫЕ ДАННЫЕ И ИНИЦИАЛИЗАЦИЯ ---
Global ButtonPalette.WidgetPalette
Global AppFont.i
Global ActiveColorIndex.i = 0

Procedure.w ClampChannel(value.l)
   If value > 255 : ProcedureReturn 255 : EndIf
   If value < 0   : ProcedureReturn 0   : EndIf
   ProcedureReturn value
EndProcedure

Procedure CalcWidgetPalette(baseColor.l, *p.WidgetPalette)
   Protected.l r = Red(baseColor), g = Green(baseColor), b = Blue(baseColor), a = Alpha(baseColor)
   Protected.l brightness = (r * 299 + g * 587 + b * 114) / 1000
   
   SetGadgetState(#SliderR, r)
   SetGadgetState(#SliderG, g)
   SetGadgetState(#SliderB, b)
   SetGadgetState(#SliderA, a)
   
   SetGadgetText(#LabelR, "R: "+Str(r))
   SetGadgetText(#LabelG, "G: "+Str(g))
   SetGadgetText(#LabelB, "B: "+Str(b))
   SetGadgetText(#LabelA, "A: "+Str(a))
   
   *p\bgNormal     = baseColor
   *p\bgHover      = RGBA(ClampChannel(r + 20), ClampChannel(g + 20), ClampChannel(b + 20), a)
   *p\bgActive     = RGBA(ClampChannel(r + 35), ClampChannel(g + 35), ClampChannel(b + 35), a)
   *p\bgPressed    = RGBA(ClampChannel(r - 30), ClampChannel(g - 30), ClampChannel(b - 30), a)
   *p\borderNormal = RGBA(ClampChannel(r - 40), ClampChannel(g - 40), ClampChannel(b - 40), a)
   *p\borderHover  = RGBA(ClampChannel(r - 10), ClampChannel(g - 10), ClampChannel(b - 10), a)
   *p\borderActive = RGBA(ClampChannel(r + 10), ClampChannel(g + 10), ClampChannel(b + 10), a)
   *p\borderPressed = *p\borderActive
   
   If brightness > 128
      *p\textNormal = RGBA(40, 40, 40, a)
      *p\textHover  = RGBA(0, 0, 0, a)
   Else
      *p\textHover  = RGBA(255, 255, 255, a)
      *p\textNormal = RGBA(240, 240, 240, a)
   EndIf
   
   
EndProcedure

; Универсальная функция проверки мыши по физическим координатам структуры
Procedure.b CheckMouseInWidget(*w.Widget, mx.i, my.i)
   ProcedureReturn Bool(mx >= *w\physX And mx <= *w\physX + *w\physW And my >= *w\physY And my <= *w\physY + *w\physH)
EndProcedure

; --- ФУНКЦИИ ОТРИСОВКИ ---
Procedure DrawButton(*w.Widget, *palette.WidgetPalette, fontID.i = 0)
   If fontID : DrawingFont(fontID) : EndIf
   Protected.i textWidth = TextWidth(*w\text)
   Protected.i textHeight = TextHeight(*w\text)
   Protected.l currentBg, currentBorder, currentText
   
   If *w\state\isPressed And *w\state\isHover
      currentBg = *palette\bgPressed : currentBorder = *palette\borderPressed : currentText = *palette\textNormal
   ElseIf *w\state\isHover
      currentBg = *palette\bgHover   : currentBorder = *palette\borderHover   : currentText = *palette\textHover
   ElseIf *w\state\isActive
      currentBg = *palette\bgActive  : currentBorder = *palette\borderActive  : currentText = *palette\textNormal
   Else
      currentBg = *palette\bgNormal  : currentBorder = *palette\borderNormal  : currentText = *palette\textNormal
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   RoundBox(*w\physX, *w\physY, *w\physW, *w\physH, *w\physRadius, *w\physRadius, currentBg)
   
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
   RoundBox(*w\physX, *w\physY, *w\physW, *w\physH, *w\physRadius, *w\physRadius, currentBorder)
   
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
   DrawText(*w\physX + (*w\physW - textWidth) / 2, *w\physY + (*w\physH - textHeight) / 2, *w\text, currentText)
EndProcedure

; Процедура пересчета ВСЕХ метрик разом
Procedure ApplyLayoutDPI()
   ; Масштабируем главную кнопку
   MainBtn\physX = DesktopScaledX(MainBtn\logX)
   MainBtn\physY = DesktopScaledY(MainBtn\logY)
   MainBtn\physW = DesktopScaledX(MainBtn\logW)
   MainBtn\physH = DesktopScaledY(MainBtn\logH)
   MainBtn\physRadius = DesktopScaledX(6)
   
   ; Масштабируем селекторы в цикле
   Define i
   For i = 0 To 2
      ColorSels(i)\physX = DesktopScaledX(ColorSels(i)\logX)
      ColorSels(i)\physY = DesktopScaledY(ColorSels(i)\logY)
      ColorSels(i)\physW = DesktopScaledX(ColorSels(i)\logW)
      ColorSels(i)\physH = DesktopScaledY(ColorSels(i)\logH)
      ColorSels(i)\physRadius = ColorSels(i)\physW / 2 ; Радиус окружности
   Next
EndProcedure

; --- ОБНОВЛЕНИЕ ЭКРАНА ---
Procedure RefreshCanvas()
   If StartDrawing(CanvasOutput(0))
      Protected.i canvasW = OutputWidth()
      Protected.i canvasH = OutputHeight()
      
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, canvasW, canvasH, RGB(245, 245, 245))
      
      Box(0, DesktopScaledY(45), canvasW, DesktopScaledY(10), RGB(220, 220, 220))
      
      ; 1. Рисуем главную кнопку из структуры
      DrawButton(@MainBtn, @ButtonPalette, FontID(AppFont))
      
      ; 2. Рисуем переключатели цвета из массива структур
      Protected.i i
      For i = 0 To 2
         Protected.i radius = ColorSels(i)\physRadius
         Protected.i centerX = ColorSels(i)\physX + radius
         Protected.i centerY = ColorSels(i)\physY + radius
         
         DrawingMode(#PB_2DDrawing_AlphaBlend)
         Circle(centerX, centerY, radius, ColorSels(i)\color)
         
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
         Circle(centerX, centerY, radius, RGBA(100, 100, 100, 255))
         
         If i = ActiveColorIndex
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            Protected.i dotRadius = DesktopScaledX(3)
            Protected.l dotColor
            If i = 1 : dotColor = RGBA(40, 40, 40, 255) : Else : dotColor = RGBA(255, 255, 255, 255) : EndIf
            Circle(centerX, centerY, dotRadius, dotColor)
         EndIf
      Next i
      
      StopDrawing()
   EndIf
EndProcedure


; Главная кнопка
MainBtn\logX = 50 : MainBtn\logY = 30 : MainBtn\logW = 150 : MainBtn\logH = 40 : MainBtn\text = "Тестовый виджет"

Global Dim Colors.l(2) 
Colors(0) = RGBA(52, 152, 219,160) 
Colors(1) = RGBA(46, 204, 113, 160) 
Colors(2) = RGBA(231, 76, 60, 160)

Define i
For i = 0 To 2
   ColorSels(i)\logX = LogSelX(i)
   ColorSels(i)\logY = 100
   ColorSels(i)\logW = 24
   ColorSels(i)\logH = 24
   ColorSels(i)\color = Colors(i)
Next

AppFont = LoadFont(#PB_Any, "Segoe UI", 10, #PB_Font_HighQuality)


If OpenWindow(0, 0, 0, 500, 160, "Structured DPI Demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 250, 160)
   
   
   ContainerGadget(-1, 260,0,250,160)
   ; Добавляем текстовые подписи и трекбары под холстом
   TextGadget(#LabelR, 10,  10, 60, 20, "R: ")
   TrackBarGadget(#SliderR, 20,  30, 30, 125, 0, 255, #PB_TrackBar_Vertical)
   
   TextGadget(#LabelG, 70, 10, 60, 20, "G: ")
   TrackBarGadget(#SliderG, 80, 30, 30, 125, 0, 255, #PB_TrackBar_Vertical)
   
   TextGadget(#LabelB, 130, 10, 60, 20, "B: ")
   TrackBarGadget(#SliderB, 140, 30, 30, 125, 0, 255, #PB_TrackBar_Vertical)
  
   TextGadget(#LabelA, 190, 10, 60, 20, "A: ")
   TrackBarGadget(#SliderA, 200, 30, 30, 125, 0, 255, #PB_TrackBar_Vertical)
  CloseGadgetList()
   
   CalcWidgetPalette( ColorSels(ActiveColorIndex)\color, @ButtonPalette)
   ApplyLayoutDPI()
   RefreshCanvas()
  
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget 
         Select EventGadget() 
            Case #SliderR, #SliderG, #SliderB, #SliderA
              ; If EventType() = #PB_EventType_Change
                 ; Debug 444
                  CalcWidgetPalette( RGBA(GetGadgetState(#SliderR), GetGadgetState(#SliderG), GetGadgetState(#SliderB), GetGadgetState(#SliderA)), @ButtonPalette)
                  RefreshCanvas()
               ;EndIf
         EndSelect
         
         If EventGadget() = 0
            Define EventType = EventType()
            Define mx = GetGadgetAttribute(0, #PB_Canvas_MouseX)
            Define my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
            
            Define inBtn.b = CheckMouseInWidget(@MainBtn, mx, my)
            Define needRefresh.b = #False
            
            Select EventType
               Case #PB_EventType_MouseMove
                  If inBtn
                     If MainBtn\state\isHover = #False
                        MainBtn\state\isHover = #True
                        needRefresh = #True
                     EndIf
                  Else
                     If MainBtn\state\isHover = #True
                        MainBtn\state\isHover = #False
                        needRefresh = #True
                     EndIf
                  EndIf
                  
               Case #PB_EventType_MouseLeave
                  If MainBtn\state\isHover
                     MainBtn\state\isHover = #False
                     needRefresh = #True
                  EndIf
                  
               Case #PB_EventType_LeftButtonDown
                  If inBtn
                     MainBtn\state\isPressed = #True
                     needRefresh = #True
                  Else
                     Define i
                     For i = 0 To 2
                        If CheckMouseInWidget(@ColorSels(i), mx, my)
                           If ActiveColorIndex <> i
                              ActiveColorIndex = i
                              CalcWidgetPalette(ColorSels(i)\color, @ButtonPalette)
                              needRefresh = #True
                           EndIf
                           Break
                        EndIf
                     Next i
                  EndIf
                  
               Case #PB_EventType_LeftButtonUp
                  If MainBtn\state\isPressed
                     MainBtn\state\isPressed = #False
                     If inBtn
                        If MainBtn\state\isActive : MainBtn\state\isActive = #False : Else : MainBtn\state\isActive = #True : EndIf
                     EndIf
                     needRefresh = #True
                  EndIf
            EndSelect
            
            If needRefresh
               RefreshCanvas()
            EndIf
         EndIf
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf

   ;- --- ПРОВЕРКА НА ВАШИХ ЦВЕТАХ ---
   ; Наш исходный цвет (светло-серый из первого вопроса)
   BaseColor = $ffE2E2E2 
   
   ; 1. Чтобы получить ТОЧНЫЙ темно-серый $ff404040 из $ffE2E2E2, фактор затемнения должен быть ~0.716
   Darkgray = Colors::Extract(BaseColor, 0.716, #False)
   Debug "Получили темно-серый: $" + Hex(Darkgray, #PB_Long) ; Выведет $FF404040
   
   ; 2. Чтобы получить ТОЧНЫЙ светло-серый $ffD3D3D3, мы можем взять стандартный серый ($ff808080)
   ; и применить фактор осветления ~0.65
   Standardgray = $ff808080
   Lightgray = Colors::Extract(Standardgray, 0.65, #True)
   Debug "Получили светло-серый: $" + Hex(Lightgray, #PB_Long) ; Выведет $FFD3D3D3
   
   
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
; FirstLine = 15
; Folding = --------
; EnableXP