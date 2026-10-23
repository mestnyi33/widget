; =========================================================================
; 1. КОНСТАНТЫ, ПЕРЕЧИСЛЕНИЯ И СТРУКТУРЫ
; =========================================================================
EnableExplicit
Enumeration
   #_BTN_Title    ; Сам заголовок (Иконка + Текст). Занимает всё свободное место!
                  ; --- Кнопки управления (выстраиваются справа) ---
   #_BTN_Close
   #_BTN_Maximize
   #_BTN_Minimize
   #_BTN_Help        
   #_BTN_Pin         
   #_BTN_Menu        
EndEnumeration

; Битовые флаги для процедурного создания заголовка
#_STYLE_Close = 1 << 0
#_STYLE_Minimize = 1 << 1
#_STYLE_Maximize = 1 << 2
#_STYLE_Help     = 1 << 3
#_STYLE_Pin      = 1 << 4
#_STYLE_Menu     = 1 << 5
#_STYLE_Default  = #_STYLE_Minimize | #_STYLE_Maximize|#_STYLE_Close ; Стандартная тройка кнопок

#__flag_Left   = 1<<0
#__flag_Top  = 1<<1
#__flag_Right  = 1<<2
#__flag_Bottom  = 1<<3
#__flag_Center = 1<<4

#__MASK_Hover     = 1 << 6
; Маски состояний виджетов
#_MASK_Hover    = 1 << 0
#_MASK_Pressed  = 1 << 1

Structure _s_POINT     : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure
Structure _s_IMG        Extends _s_COORDINATE : change.b : Image.i : EndStructure
Structure _s_TXT        Extends _s_COORDINATE : change.b : Text.s : EndStructure


Structure _s_TITLE_BUTTON Extends _s_COORDINATE
   txt._s_TXT
   img._s_IMG
   type.l       
   mask.q   
   align.q
   size.l
EndStructure

Structure _s_TITLE
   indent.a
   spacing.a 
   slant.a
   
   bar._s_TITLE_BUTTON
   List btn._s_TITLE_BUTTON()
   *data
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   change.b
   padding.a
   ;    spacing.a             
   ; tab._s_TABS
   
   ; --- ИНТЕГРАЦИЯ ЗАГОЛОВКА ---
   *title._s_TITLE ; Заголовок теперь является частью виджета!
                      ; ----------------------------
   
   dragOffSet.i     ; Точка захвата мыши
   canvasID     .i  
   fontID       .i  
   bgcolor      .l  ; Наш фон холста
EndStructure

LoadFont(0, "tahoma", 12)

; =========================================================================
; 2. ПРОЦЕДУРНЫЙ ДВИЖОК ЗАГОЛОВКА (СВЕТЛАЯ ПАЛИТРА)
; =========================================================================
Procedure.i MakeAlignPosition(alignFlags.l, contentSize.i, objectSize.i, Offset.i = 10)
   If alignFlags & #__flag_Center
      ProcedureReturn (contentSize - objectSize) / 2
   ElseIf alignFlags & #__flag_Right
      ProcedureReturn contentSize - objectSize - Offset
   Else ; #__flag_Left
      ProcedureReturn Offset
   EndIf
EndProcedure

Procedure ChromeBox(vertical.b, x, y, w, h, isactive, currentcolor.l, localslant, GradientDepth = 25, outerbordercolor.l = -1, innerhighlightcolor.l = -1)
   Protected dy, dh = h - 1, dw = w - 1
   ;Protected localslant = slant
   ; dh = h
   If h <= 0 Or w <= 0 : ProcedureReturn : EndIf 
   
   ; Корректируем скос в зависимости от режима
   If vertical
      If localslant > w : localslant = w : EndIf
   Else
      If localslant > h : localslant = h : EndIf
   EndIf
   
   ; 1. Выбор базового цвета
   Protected.a currentalpha = Alpha(currentcolor)
   
   ; 2. Расчет цветов рамок
   If outerbordercolor = -1
      outerbordercolor = RGBA(Red(currentcolor) * 0.6, Green(currentcolor) * 0.6, Blue(currentcolor) * 0.6, currentalpha)
   EndIf
   If innerhighlightcolor = -1
      Protected.a r = Red(currentcolor), g = Green(currentcolor), b = Blue(currentcolor)
      innerhighlightcolor = RGBA(r + (255 - r) * 0.3, g + (255 - g) * 0.3, b + (255 - b) * 0.3, currentalpha)
   EndIf
   
   ; 3. Заливка тела вкладки
   If isactive : GradientDepth = 0 : EndIf
   Protected baser = Red(currentcolor), baseg = Green(currentcolor), bgb = Blue(currentcolor)
   
   ; Защита цвета от Underflow
   Protected MaxDrop = baser
   If baseg < MaxDrop : MaxDrop = baseg : EndIf
   If bgb < MaxDrop : MaxDrop = bgb : EndIf
   If GradientDepth > MaxDrop : GradientDepth = MaxDrop : EndIf 
   
   ; Настройка шагов для циклов fixed-point (в зависимости от ориентации)
   Protected Steps = dh
   If vertical : Steps = dw : EndIf
   
   Protected ColorStepFixed = (GradientDepth << 16) / Steps
   Protected SlantStepFixed = (localslant << 16) / Steps
   
   Protected ColorAccum = 0
   Protected SlantAccum = localslant << 16
   
   Protected stepVar
   For stepVar = 0 To Steps
      Protected currentSlantVal = (SlantAccum + $8000) >> 16
      
      ; Вычисляем динамический размер линии (для горизонтальной — это длина, для вертикальной — высота)
      Protected currentLength = w - (currentSlantVal << 1)
      If vertical : currentLength = h - (currentSlantVal << 1) : EndIf
      
      If currentLength <= 0 : Break : EndIf 
      
      Protected currentColorStep = ColorAccum >> 16
      Protected color = RGBA(baser - currentColorStep, baseg - currentColorStep, bgb - currentColorStep, currentalpha)
      
      ; Отрисовка линии в зависимости от направления
      If vertical
         ; Рисуем вертикальные полоски слева направо
         Line(x + stepVar, y + currentSlantVal, 1, currentLength, color)
      Else
         ; Рисуем горизонтальные полоски сверху вниз
         Line(x + currentSlantVal, y + stepVar, currentLength, 1, color)
      EndIf
      
      ColorAccum + ColorStepFixed
      SlantAccum - SlantStepFixed
   Next
   
   ; 4. Отрисовка контуров
   If vertical
      ; === ВЕРТИКАЛЬНЫЙ РЕЖИМ (Вкладка «смотрит» вверх, основание справа) ===
      LineXY(x + dw, y, x, y + localslant, outerbordercolor)             
      LineXY(x, y + localslant, x, y + h - 1 - localslant, outerbordercolor)         
      LineXY(x, y + h - 1 - localslant, x + dw, y + h - 1, outerbordercolor)     
      
      If isactive
         LineXY(x + dw, y + 1, x + 1, y + localslant + 1, innerhighlightcolor)
         LineXY(x + 1, y + localslant + 1, x + 1, y + h - 1 - localslant - 1, innerhighlightcolor)
         LineXY(x + 1, y + h - 1 - localslant - 1, x + dw, y + h - 2, innerhighlightcolor)
      Else
         ; Замыкающая линия справа (стык с панелью)
         LineXY(x + dw, y, x + dw, y + h - 1, outerbordercolor)
      EndIf
   Else
      ; === ГОРИЗОНТАЛЬНЫЙ РЕЖИМ (Классический Chrome) ===
      LineXY(x, y + dh, x + localslant, y, outerbordercolor)             
      LineXY(x + localslant, y, x + w - 1 - localslant, y, outerbordercolor)         
      LineXY(x + w - 1 - localslant, y, x + w - 1, y + dh, outerbordercolor)     
      
      If isactive
         LineXY(x + 1, y + dh, x + localslant + 1, y + 1, innerhighlightcolor)
         LineXY(x + localslant + 1, y + 1, x + w - 1 - localslant - 1, y + 1, innerhighlightcolor)
         LineXY(x + w - 1 - localslant - 1, y + 1, x + w - 2, y + dh, innerhighlightcolor)
      Else
         ; Замыкающая линия снизу
         LineXY(x, y + dh, x + w - 1, y + dh, outerbordercolor)
      EndIf
   EndIf
EndProcedure

;-
Procedure UpdateContentSize(*btn._s_TITLE_BUTTON)
   Protected._s_TXT *txt = *btn\txt
   Protected._s_IMG *img = *btn\img
   
   ; 1. Замеры метрик (Пишем сразу в структуру только при изменениях)
   If *txt\change 
      *txt\change = #False
      If *txt\Text 
         *txt\width  = TextWidth(*txt\Text)
         *txt\height = TextHeight(*txt\Text)
      Else
         *txt\width  = 0 : *txt\height = 0
      EndIf
   EndIf
   
   If *img\change
      *img\change = #False
      If IsImage(*img\Image)
         *img\width  = ImageWidth(*img\Image)
         *img\height = ImageHeight(*img\Image)
      Else
         *img\width  = 0 : *img\height = 0
      EndIf
   EndIf
EndProcedure

Procedure UpdateContentPos(vertical.b, *btn._s_TITLE_BUTTON, indent.a, Spacing.a)
   Protected contentX.l, contentY.l
   Protected._s_TXT *txt = *btn\txt
   Protected._s_IMG *img = *btn\img
   
   If Not (*img\width And *txt\width) : Spacing  = 0 : EndIf
     
   ; 3. ЕДИНОВРЕМЕННОЕ ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ (Работаем напрямую со структурой)
   If vertical
      *txt\x = (*btn\width - *txt\width) >> 1
      *img\x = (*btn\width - *img\width) >> 1
      
      *txt\y = MakeAlignPosition(*btn\align, *btn\Height, *txt\height, indent)
      *img\y = indent
      
      If Not (*btn\align & #__flag_Bottom)
         If *img\height > 0 : *txt\y + *img\height + Spacing : EndIf
      EndIf
   Else
      *txt\y = (*btn\height - *txt\height) >> 1
      *img\y = (*btn\height - *img\height) >> 1
      
      *txt\x = MakeAlignPosition(*btn\align, *btn\Width,  *txt\width, indent)
      *img\x = indent
      
      If Not (*btn\align & #__flag_Right)
         If *img\width > 0 : *txt\x + *img\width + Spacing : EndIf
      EndIf
   EndIf
EndProcedure

; Расчет геометрии (расстановка элементов)
Procedure UpdateTitleBar(*this._s_WIDGET)
   Protected right_x = *this\Width
   Protected._s_TITLE_BUTTON *btn
   Protected._s_TITLE *t = *this\title
   
   If *t\slant
     right_x  - *t\slant + *t\spacing
   EndIf
   
   ; Этот цикл считает ТОЛЬКО кнопки управления. Никаких проверок типов!
   ForEach *t\btn()
      *btn = @*t\btn()
      *btn\Width = *this\Height - *t\spacing*2
      *btn\Height = *btn\Width
      right_x - *btn\Width - *t\spacing
      *btn\X = *this\X + right_x 
      *btn\Y = *this\Y + (*this\Height - *btn\Height) / 2
      *btn\size = *btn\Height/4
   Next
   
   ; Настраиваем изолированный заголовок напрямую
   If *t\bar
      Protected *title._s_TITLE_BUTTON = *t\bar
      If ListSize(*t\btn())
         If *t\slant
            *title\X = *this\X + *t\slant
            *title\Y = *this\Y
            *title\Width = right_x - *t\slant - *t\spacing
            *title\Height = *this\Height
         Else
            *title\X = *this\X + *t\spacing
            *title\Y = *this\Y
            *title\Width = right_x - *t\spacing*2
            *title\Height = *this\Height
         EndIf
      Else
         If *t\slant
            *title\X = *this\X + *t\slant
            *title\Y = *this\Y
            *title\Width = right_x - *t\slant - *t\spacing 
            *title\Height = *this\Height
         Else
            *title\X = *this\X + *t\spacing 
            *title\Y = *this\Y + *t\spacing 
            *title\Width = right_x - *t\spacing * 2 
            *title\Height = *this\Height - *t\spacing * 2
         EndIf
      EndIf
   EndIf
EndProcedure

; Внутренняя процедура добавления элемента значка/кнопки
Procedure AddTitleBar(*t._s_TITLE, type.l, text.s = "", image.i = 0, align.a = #__flag_Left)
   Protected._s_TITLE_BUTTON *btn
   
   If type = #_BTN_Title
      *btn = @*t\bar
   Else
      *btn = AddElement(*t\btn())
   EndIf
   
   *btn\type = type
   
   If text
      *btn\txt\change = 1
      *btn\txt\Text = text
      *btn\txt\Width = DesktopScaledX(10)
      *btn\txt\Height = DesktopScaledY(10)
   EndIf
   
   If type = #_BTN_Title
      *btn\size = DesktopScaledX(10) 
      *btn\align = align
      If IsImage(image)
         *btn\img\change = 1
      Else
         *btn\img\Width = *btn\size*2
         *btn\img\Height = *btn\size*2
      EndIf
   EndIf
EndProcedure

; Создание и инициализация заголовка окна
Procedure CreateTitleBar(*t._s_TITLE, text.s, image.i = 0, flags.l = #_STYLE_Default)
   *t\indent = DesktopScaledX(10)
  ;*t\spacing = DesktopScaledX(10)
  ;*t\slant = DesktopScaledX(20)
  If *t\slant : *t\indent = 0 : EndIf
  If *t\spacing : *t\indent = 0 : EndIf
  
   ; 1. В списке btn() теперь живут ТОЛЬКО кнопки управления справа
   If flags & #_STYLE_Close :  AddTitleBar(*t, #_BTN_Close): EndIf
   If flags & #_STYLE_Maximize : AddTitleBar(*t, #_BTN_Maximize) : EndIf
   If flags & #_STYLE_Minimize : AddTitleBar(*t, #_BTN_Minimize) : EndIf
   If flags & #_STYLE_Help     : AddTitleBar(*t, #_BTN_Help)     : EndIf
   If flags & #_STYLE_Pin      : AddTitleBar(*t, #_BTN_Pin)      : EndIf
   If flags & #_STYLE_Menu     : AddTitleBar(*t, #_BTN_Menu)     : EndIf
   
   Protected flag=#__flag_Left
   Static i
   If i = 1
     flag = #__flag_Center
  EndIf
   If i = 2
     flag = #__flag_Right
  EndIf
  AddTitleBar(*t, #_BTN_Title, text.s, image, flag)
  i+1
 EndProcedure


Procedure DrawTitleBar(*t._s_TITLE, bgColor.l, change.b = 0)
   ; Настройки светлой палитры
   Protected.l crossColor, symbolColor
   Protected.l defaultColor = RGBA(80, 80, 80, 255)      ; Серые значки по умолчанию (хорошая читаемость)
   Protected.l winSymbolColor = RGBA(50, 50, 50, 255)    ; Более темные значки при ховере
   Protected.l textColor = RGBA(30, 30, 30, 255)         ; Почти черный текст заголовка
   Protected round ;= DesktopScaledX(20)
   
   Protected *btn._s_TITLE_BUTTON = *t\bar
   Protected size.l, paddingX.l, paddingY.l
   
   ; 1. Отрисовка заголовка
   If *btn\type = #_BTN_Title
      If *btn\txt\change Or *btn\img\change Or change
         UpdateContentSize(*btn)
         UpdateContentPos(0, *btn, *t\indent, DesktopScaledX(6))
      EndIf
      
      size = *btn\size
      Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
      Circle(*btn\X+*btn\img\X+size, *btn\Y+*btn\img\Y+size, size, RGBA(0, 120, 215, 255))
      DrawText(*btn\X+*btn\txt\X, *btn\Y+*btn\txt\Y, *btn\txt\Text, textColor, 0)
   EndIf
   
   ;
   ForEach *t\btn()
      *btn = @*t\btn()
      
      size = *btn\size 
      round = *btn\Height
      
      If Not *t\spacing
         Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
      EndIf
      
      ; 2. Обработка фона кнопок при наведении (Ховер в светлой теме)
      If *btn\mask & #_MASK_Hover
         If *btn\type = #_BTN_Close
            ; Классический красный ховер закрытия (не меняется, но крестик становится белым)
            If *t\spacing
               size-DesktopScaledX(2)
               symbolColor = RGBA(232, 17, 35, 255)
               RoundBox(*btn\X, *btn\Y, *btn\Width, *btn\Height, round, round, RGBA(232, 17, 35, 255)) 
            Else
               Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(232, 17, 35, 255)) 
            EndIf
            crossColor = RGBA(255, 255, 255, 255) 
         Else
            ; Мягкий полупрозрачный серый ховер для остальных кнопок под светлую тему
            If Not *t\spacing
               Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
            EndIf
            symbolColor = winSymbolColor
         EndIf
      Else
         crossColor = defaultColor
         symbolColor = defaultColor
      EndIf
      
      paddingX = *btn\X + (*btn\Width - size) / 2
      paddingY = *btn\Y + (*btn\Height - size) / 2
      
      
      ; 3. Отрисовка значков
      Select *btn\type
         Case #_BTN_Close ; Жирный крестик со смещением
            LineXY(paddingX,        paddingY, paddingX + size,     paddingY + size, crossColor)
            LineXY(paddingX + 1,    paddingY, paddingX + size + 1, paddingY + size, crossColor)
            LineXY(paddingX + 2,    paddingY, paddingX + size + 2, paddingY + size, crossColor)
            LineXY(paddingX + size,     paddingY, paddingX,        paddingY + size, crossColor)
            LineXY(paddingX + size - 1, paddingY, paddingX - 1,    paddingY + size, crossColor)
            LineXY(paddingX + size - 2, paddingY, paddingX - 2,    paddingY + size, crossColor)
            
         Case #_BTN_Maximize ; Квадрат
            DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
            Box(paddingX, paddingY, size, size, symbolColor)
            Box(paddingX + 1, paddingY + 1, size - 2, size - 2, symbolColor) 
            DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
            
         Case #_BTN_Minimize ; Черточка
            LineXY(paddingX, paddingY + size/2 - 1, paddingX + size, paddingY + size/2 - 1, symbolColor)
            LineXY(paddingX, paddingY + size/2,     paddingX + size, paddingY + size/2,     symbolColor)
            
         Case #_BTN_Help ; Знак вопроса
            DrawText(paddingX + DesktopScaledX(1), paddingY - DesktopScaledY(2), "?", symbolColor, 0)
      EndSelect
      
      If *t\spacing
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
         If *btn\mask & #_MASK_Hover
            RoundBox(*btn\X-1, *btn\Y-1, *btn\Width+2, *btn\Height+2,  round, round, symbolColor)    
         EndIf
         RoundBox(*btn\X, *btn\Y, *btn\Width, *btn\Height, round, round, symbolColor)    
         RoundBox(*btn\X+1, *btn\Y+1, *btn\Width-2, *btn\Height-2,  round, round, symbolColor)    
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
      EndIf
      
   Next
EndProcedure

Procedure DoEventTitleBar( *btn._s_TITLE_BUTTON, event )
   Protected windowID = EventWindow()
   
   Select event
      Case #PB_EventType_MouseEnter
         If *btn\type <> #_BTN_Title
            *btn\size = *btn\Height/2 
         EndIf
         
      Case #PB_EventType_MouseLeave
         If *btn\type <> #_BTN_Title
            *btn\size = *btn\Height/4
         EndIf
      
      Case #PB_EventType_LeftButtonDown
         Select *btn\type
            Case #_BTN_Close    
               PostEvent(#PB_Event_CloseWindow, windowID, 0)
            Case #_BTN_Maximize 
               If GetWindowState(windowID) = #PB_Window_Maximize : SetWindowState(windowID, #PB_Window_Normal) : Else : SetWindowState(windowID, #PB_Window_Maximize) : EndIf
            Case #_BTN_Minimize : SetWindowState(windowID, #PB_Window_Minimize)
            Case #_BTN_Help     : MessageRequester("Инфо", "Нажата кнопка Справка")
            Case #_BTN_Title     
               CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                  SendMessage_(WindowID(windowID), #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
               CompilerEndIf
         EndSelect
         
      Case  #PB_EventType_LeftDoubleClick
         If *btn\type = #_BTN_Title
            If GetWindowState(windowID) = #PB_Window_Maximize
               SetWindowState(windowID, #PB_Window_Normal)
            Else
               SetWindowState(windowID, #PB_Window_Maximize)
            EndIf
         EndIf
   EndSelect
EndProcedure

;-
Procedure RedrawCanvas(canvasID.i, List widgets._s_WIDGET())
   Protected gWidth = DesktopScaledX(GadgetWidth(canvasID))
   Protected gHeight = DesktopScaledY(GadgetHeight(canvasID))
   Protected._s_WIDGET *this
   
   If StartDrawing(CanvasOutput(canvasID))
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
      ; Заливаем холст общим светлым фоном
      Box(0, 0, gWidth, gHeight, RGBA(255, 255, 255, 255))
      
      ForEach widgets() : *this = widgets()
         If *this\fontID : DrawingFont( *this\fontID) : EndIf
         
         ; 1. Рисуем подложку под панель заголовка
         If  *this\title\slant
            ChromeBox(0, *this\x, *this\y, *this\Width, *this\Height, 0, RGBA(180, 195, 215, 160), *this\title\slant, 70)
         Else
            Box(*this\X, *this\Y, *this\Width, *this\Height, RGBA(230, 235, 240, 255))
         EndIf
         
         DrawTitleBar(*this\title, RGBA(230, 235, 240, 255))
      Next
      
      StopDrawing()
   EndIf
EndProcedure

Procedure DoEvent( *this._s_WIDGET, event, mx, my)
   Protected needRedraw = #False
   Protected *btn._s_TITLE_BUTTON = *this\title\bar
   Protected shouldHover.b
   Static._s_TITLE_BUTTON *hoverBTN
   
   Select event
      Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave, #PB_EventType_LeftButtonUp
         If Bool(*btn\mask & #_MASK_Hover) <> Bool( mx >= *btn\X And mx < *btn\X + *btn\Width And my >= *btn\Y And my < *btn\Y + *btn\Height )
            *btn\mask ! #_MASK_Hover ; Переключаем тумблер ховера (XOR)
         EndIf
         
         ; Меням размеры геометрии значка
         If *btn\mask & #_MASK_Hover
            ; ТРЮК СБРОСА: Если мышь ушла с кнопок управления на главный заголовок,
            ; принудительно гасим маску и размер у старой кнопки из списка
            If *hoverBTN And *hoverBTN <> *btn
               *hoverBTN\mask &~ #_MASK_Hover
               DoEventTitleBar( *hoverBTN, #PB_EventType_MouseLeave )
            EndIf
            
            *hoverBTN = *btn
            needredraw = #True
         Else
            ; Всего ОДИН цикл для поиска и одновременного сброса/включения ховеров
            ForEach *this\title\btn()
               *btn = @*this\title\btn()
               
               ; 2. Если текущее состояние маски кнопки не совпадает с реальностью
               If Bool(*btn\mask & #_MASK_Hover) <> Bool( mx >= *btn\X And mx < *btn\X + *btn\Width And my >= *btn\Y And my < *btn\Y + *btn\Height )
                  *btn\mask ! #_MASK_Hover ; Переключаем тумблер ховера (XOR)
                  
                  ; Меням размеры геометрии значка
                  If *btn\mask & #_MASK_Hover
                     *hoverBTN = *btn
                     DoEventTitleBar( *btn, #PB_EventType_MouseEnter )
                  Else
                     *hoverBTN = 0
                     DoEventTitleBar( *btn, #PB_EventType_MouseLeave )
                  EndIf
                  needredraw = #True
               EndIf
            Next
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If *hoverBTN
            DoEventTitleBar( *hoverBTN, event )
            
            ; Пересчитываем ширину, если окно развернули одинарным кликом:
            If *hoverBTN\type = #_BTN_Maximize
               UpdateTitleBar(*this)
               needRedraw = #True
            EndIf
         EndIf
         
      Case  #PB_EventType_LeftDoubleClick
         If *hoverBTN
            If *hoverBTN\type = #_BTN_Title
               DoEventTitleBar( *hoverBTN, event )
               UpdateTitleBar(*this)
               needRedraw = #True
            EndIf
         EndIf
         
   EndSelect
   
   ProcedureReturn needRedraw
EndProcedure

Procedure Create( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l, text.s, flags.l = #_STYLE_Default, image.i = 0)
   *this\fontID = FontID(0)
   *this\X = DesktopScaledX(X)
   *this\Y = DesktopScaledY(Y)
   *this\Width = DesktopScaledX(Width)
   *this\Height = DesktopScaledY(Height)
   *this\title = AllocateStructure(_s_TITLE)
   CreateTitleBar(*this\title, text, image, flags)
   UpdateTitleBar(*this)
EndProcedure

; =========================================================================
; 3. ОСНОВНОЙ ЦИКЛ ПРИЛОЖЕНИЯ И ИНИЦИАЛИЗАЦИЯ
; =========================================================================
NewList Windows._s_WIDGET()
; Создаем заголовки процедурно
Create(AddElement(Windows()), 10, 20, 780, 40, "Главное окно программы (Window 1)", #_STYLE_Default, 101)
Create(AddElement(Windows()), 10, 90, 780, 40, "Окно настроек системы (Window 2)", #_STYLE_Help|#_STYLE_Close, 102)
Create(AddElement(Windows()), 10, 160, 780, 40, "Информационное сообщение (Window 3)", 0, 103)

Define Event.i, mx.i, my.i, needRedraw.b
If OpenWindow(0, 0, 0, 800, 230, "Light Titlebar Custom UI Demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 800, 230)
   RedrawCanvas(0, Windows())
   Repeat
      Event = WaitWindowEvent()
      Select Event
         Case #PB_Event_Gadget
            If EventGadget() = 0
               mx = GetGadgetAttribute(0, #PB_Canvas_MouseX)
               my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
               
               ForEach Windows()
                  If DoEvent( @Windows(), EventType(), mx, my )
                     needRedraw = #True
                  EndIf
               Next
               
               If needRedraw 
                  RedrawCanvas(0, Windows()) 
               EndIf
            EndIf
      EndSelect
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 338
; FirstLine = 235
; Folding = -4--------fn+-----
; EnableXP
; DPIAware