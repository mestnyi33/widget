; =========================================================================
; 1. КОНСТАНТЫ, ПЕРЕЧИСЛЕНИЯ И СТРУКТУРЫ
; =========================================================================
EnableExplicit
Enumeration 1
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

#__MASK_Update    = 1 << 0
#__MASK_Left      = 1 << 1;#__left   ; 2   move to left
#__MASK_Top       = 1 << 2;#__top    ; 4   move to top
#__MASK_Right     = 1 << 3;#__right  ; 8   move to right
#__MASK_Bottom    = 1 << 4;#__bottom ; 16  move to bottom
#__MASK_Center    = 1 << 5
#__MASK_Hover     = 1 << 6
#__MASK_Press  = 1 << 7

Structure _s_POINT     : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure
Structure _s_IMG        Extends _s_COORDINATE : change.b : Image.i : EndStructure
Structure _s_TXT        Extends _s_COORDINATE : change.b : Text.s : EndStructure

Structure _s_ARROW
   direction.b
   type.b
   size.a
EndStructure

Structure _s_BOX Extends _s_COORDINATE
   round.a
   size.w
   mask.q
   ; checked.b
EndStructure

Structure _s_BTN Extends _s_BOX
   ; color._s_color
   arrow._s_arrow
   type.l       
EndStructure

Structure _s_TITLEBAR
   spacing.a 
   indent.a
   List btn._s_BTN()
EndStructure

Structure _s_TITLE  Extends _s_BOX
   spacing.a 
   indent.a
   slant.a
   
   txt._s_TXT
   img._s_IMG
   bar._s_TITLEBAR
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
   If alignFlags & #__MASK_Center
      ProcedureReturn (contentSize - objectSize) / 2
   ElseIf alignFlags & #__MASK_Right
      ProcedureReturn contentSize - objectSize - Offset
   Else ; #__MASK_Left
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


; Расчет геометрии (расстановка элементов)
Procedure UpdateTitleBar(*this._s_WIDGET)
   Protected._s_BTN *btn
   Protected._s_TITLE *t = *this\title
   Protected Spacing = *t\bar\spacing
   Protected Indent = *t\bar\indent
   Protected right_x = *this\Width - *t\slant
   
   ; Этот цикл считает ТОЛЬКО кнопки управления. Никаких проверок типов!
   If ListSize(*t\bar\btn())
      right_x + Spacing - (Indent * 2)
      ForEach *t\bar\btn()
         *btn = @*t\bar\btn()
         *btn\Width = *this\Height - Indent * 2
         *btn\Height = *btn\Width
         right_x - Spacing - *btn\Width
         *btn\X = *this\X + right_x + Indent
         *btn\Y = *this\Y + (*this\Height - *btn\Height) / 2
         *btn\size = *btn\Height/4
      Next
   EndIf

   ; Настраиваем изолированный заголовок напрямую
   If *t
      *t\Y = *this\Y
      *t\X = *this\X + *t\slant 
      *t\Width = right_x - *t\slant 
      *t\Height = *this\Height
   EndIf
EndProcedure

Procedure DrawTitleBar(*this._s_WIDGET, bgColor.l)
   ; Настройки светлой палитры
   Protected.l crossColor, symbolColor
   Protected.l defaultColor = RGBA(80, 80, 80, 255)      ; Серые значки по умолчанию (хорошая читаемость)
   Protected.l winSymbolColor = RGBA(50, 50, 50, 255)    ; Более темные значки при ховере
   Protected.l textColor = RGBA(30, 30, 30, 255)         ; Почти черный текст заголовка
   Protected size.l, paddingX.l, paddingY.l, vertical.b, round                                       ;= DesktopScaledX(20)
   Protected contentX.l, contentY.l
   Protected._s_TITLE *t = *this\title
   Protected._s_TXT *txt = *t\txt
   Protected._s_IMG *img = *t\img
   Protected._s_BTN *btn
   
   Protected indent =  *t\indent ; (*this\Height - *t\img\Height)/2
   
   ; 1. Замеры метрик (Пишем сразу в структуру только при изменениях)
   If *txt\change : *t\mask | #__MASK_Update
      *txt\change = #False
      If *txt\Text 
         *txt\width  = TextWidth(*txt\Text)
         *txt\height = TextHeight(*txt\Text)
      Else
         *txt\width  = 0 : *txt\height = 0
      EndIf
   EndIf
   
   If *img\change : *t\mask | #__MASK_Update
      *img\change = #False
      If IsImage(*img\Image)
         *img\width  = ImageWidth(*img\Image)
         *img\height = ImageHeight(*img\Image)
      Else
         *img\width  = 0 : *img\height = 0
      EndIf
   EndIf
   
   If *t\mask & #__MASK_Update
      UpdateTitleBar(*this)
      
      If vertical
         *txt\x = (*t\width - *txt\width) >> 1
         *img\x = (*t\width - *img\width) >> 1
         
         *img\y = indent
         *txt\y = MakeAlignPosition(*t\mask, *t\Height, *txt\height, indent)
         
         If Not (*t\mask & #__MASK_Bottom)
            If *img\height > 0 : *txt\y + *img\height + *t\spacing : EndIf
         EndIf
      Else
         *txt\y = (*t\height - *txt\height) >> 1
         *img\y = (*t\height - *img\height) >> 1
         
         *img\x = indent
         *txt\x = MakeAlignPosition(*t\mask, *t\Width,  *txt\width, indent)
         
         If Not (*t\mask & #__MASK_Right)
            If *img\width > 0 : *txt\x + *img\width + *t\spacing : EndIf
         EndIf
      EndIf
   EndIf
   
   ; 1. Отрисовка заголовка
   size = *t\size
   Box(*t\X, *t\Y, *t\Width, *t\Height, RGBA(0, 0, 0, 20))    
   Circle(*t\X+*t\img\X+size, *t\Y+*t\img\Y+size, size, RGBA(0, 120, 215, 255))
   DrawText(*t\X+*t\txt\X, *t\Y+*t\txt\Y, *t\txt\Text, textColor, 0)
   
   ;
   ForEach *t\bar\btn()
      *btn = @*t\bar\btn()
      
      size = *btn\size 
      round = *btn\Height
      
      If Not *btn\round
         Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
      EndIf
      
      ; 2. Обработка фона кнопок при наведении (Ховер в светлой теме)
      If *btn\mask & #__MASK_Hover
         If *btn\type = #_BTN_Close
            ; Классический красный ховер закрытия (не меняется, но крестик становится белым)
            If *btn\round
               size-DesktopScaledX(2)
               symbolColor = RGBA(232, 17, 35, 255)
               RoundBox(*btn\X, *btn\Y, *btn\Width, *btn\Height, round, round, RGBA(232, 17, 35, 255)) 
            Else
               Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(232, 17, 35, 255)) 
            EndIf
            crossColor = RGBA(255, 255, 255, 255) 
         Else
            ; Мягкий полупрозрачный серый ховер для остальных кнопок под светлую тему
            If Not *btn\round
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
      
      If *btn\round
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
         If *btn\mask & #__MASK_Hover
            RoundBox(*btn\X-1, *btn\Y-1, *btn\Width+2, *btn\Height+2,  round, round, symbolColor)    
         EndIf
         RoundBox(*btn\X, *btn\Y, *btn\Width, *btn\Height, round, round, symbolColor)    
         RoundBox(*btn\X+1, *btn\Y+1, *btn\Width-2, *btn\Height-2,  round, round, symbolColor)    
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
      EndIf
      
   Next
   
   *t\mask &~ #__MASK_Update
EndProcedure

; Создание и инициализация заголовка окна
Procedure CreateTitleBar(text.s, image.i = 0, flags.l = #_STYLE_Default)
   Protected *t._s_TITLE = AllocateStructure(_s_TITLE)
   Protected._s_BTN *btn
   Protected round
  
   *t\mask | #__MASK_Left : Static i : If i = 1 :   *t\mask | #__MASK_Center :  EndIf :  If i = 2 :  *t\mask | #__MASK_Right :  EndIf :  i+1
   
   round = DesktopScaledX(20)
   ;*t\slant = DesktopScaledX(20)
   *t\bar\indent = DesktopScaledX(8)
   *t\bar\spacing = DesktopScaledX(4)
   
   *t\indent  = DesktopScaledX(8)
   *t\spacing  = DesktopScaledX(6)
     
   If *t\slant : *t\indent = 0 : EndIf
   
   *t\size = DesktopScaledX(10) 
   
   If text
      *t\txt\Text = text
      *t\txt\change = #True
   EndIf
   ;
   If IsImage(image)
      *t\img\image = Image 
      *t\img\change = #True
   Else
      *t\img\Width = *t\size*2
      *t\img\Height = *t\size*2
   EndIf
   
   ; 1. В списке btn() теперь живут ТОЛЬКО кнопки управления справа
   If flags & #_STYLE_Close :  *btn = AddElement(*t\bar\btn()) : *btn\type = #_BTN_Close : *btn\round = round : EndIf
   If flags & #_STYLE_Maximize : *btn = AddElement(*t\bar\btn()) : *btn\type = #_BTN_Maximize : *btn\round = round : EndIf
   If flags & #_STYLE_Minimize : *btn = AddElement(*t\bar\btn()) : *btn\type = #_BTN_Minimize : *btn\round = round : EndIf
   If flags & #_STYLE_Help     : *btn = AddElement(*t\bar\btn()) : *btn\type = #_BTN_Help     : *btn\round = round : EndIf
   If flags & #_STYLE_Pin      : *btn = AddElement(*t\bar\btn()) : *btn\type = #_BTN_Pin      : *btn\round = round : EndIf
   If flags & #_STYLE_Menu     : *btn = AddElement(*t\bar\btn()) : *btn\type = #_BTN_Menu     : *btn\round = round : EndIf
   ProcedureReturn *t
EndProcedure

;-
Procedure Resize( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l)
   If X <> #PB_Ignore
      *this\X = DesktopScaledX(X)
   EndIf
   If Y <> #PB_Ignore
      *this\Y = DesktopScaledY(Y)
   EndIf
   If Width <> #PB_Ignore
      *this\Width = DesktopScaledX(Width)
   EndIf
   If Height <> #PB_Ignore
      *this\Height = DesktopScaledY(Height)
   EndIf
   
   *this\title\mask | #__MASK_Update
EndProcedure

Procedure Create( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l, text.s, flags.l = #_STYLE_Default, image.i = 0)
   *this\fontID = FontID(0)
   *this\title = CreateTitleBar(text, image, flags)
   Resize( *this, X, Y, Width, Height)
EndProcedure

Procedure SetStateTitleBar(*this._s_WIDGET, btn)
   Protected windowID = EventWindow()
   Select btn
      Case #_BTN_Help : MessageRequester("Инфо", "Нажата кнопка Справка")
      Case #_BTN_Close : PostEvent(#PB_Event_CloseWindow, windowID, 0)
      Case #_BTN_Minimize : SetWindowState(windowID, #PB_Window_Minimize)
      Case #_BTN_Maximize 
         If GetWindowState(windowID) = #PB_Window_Maximize 
            SetWindowState(windowID, #PB_Window_Normal) 
         Else 
            SetWindowState(windowID, #PB_Window_Maximize) 
         EndIf
         
         ResizeGadget( *this\canvasID, #PB_Ignore, #PB_Ignore, WindowWidth(windowID), WindowHeight(windowID))
         Resize( *this, #PB_Ignore, #PB_Ignore, WindowWidth(windowID)-20, #PB_Ignore)
         ProcedureReturn #True
   EndSelect        
EndProcedure

Procedure DoEvent( *this._s_WIDGET, event, mx, my)
   Protected windowID = EventWindow()
   Protected needRedraw = #False
   Protected *t._s_TITLE = *this\title
   Protected *btn._s_BTN
   Protected shouldHover.b
   Static._s_BTN *hoverBTN, *PressBTN
   
   If *hoverBTN And Not Bool( mx >= *hoverBTN\X And mx < *hoverBTN\X + *hoverBTN\Width And my >= *hoverBTN\Y And my < *hoverBTN\Y + *hoverBTN\Height )
      *hoverBTN\mask &~ #__MASK_Hover
      *hoverBTN\size = *hoverBTN\Height/4
      *hoverBTN = 0
   EndIf   
   
   If  Bool( mx >= *this\X And mx < *this\X + *this\Width And my >= *this\Y And my < *this\Y + *this\Height ) 
      Select event
         Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave, #PB_EventType_LeftButtonUp
            If Bool(*t\mask & #__MASK_Hover) <> Bool( mx >= *t\X And mx < *t\X + *t\Width And my >= *t\Y And my < *t\Y + *t\Height )
               *t\mask ! #__MASK_Hover ; Переключаем тумблер ховера (XOR)
            EndIf
            
            If Not *t\mask & #__MASK_Hover
               ; Всего ОДИН цикл для поиска и одновременного сброса/включения ховеров
               ForEach *t\bar\btn()
                  *btn = @*t\bar\btn()
                  
                  ; 2. Если текущее состояние маски кнопки не совпадает с реальностью
                  If Bool(*btn\mask & #__MASK_Hover) <> Bool( mx >= *btn\X And mx < *btn\X + *btn\Width And my >= *btn\Y And my < *btn\Y + *btn\Height )
                     *btn\mask ! #__MASK_Hover ; Переключаем тумблер ховера (XOR)
                     
                     ; Меням размеры геометрии значка
                     If *btn\mask & #__MASK_Hover
                        *btn\size = *btn\Height/2 
                        *hoverBTN = *btn
                     Else
                        *btn\size = *btn\Height/4
                     EndIf
                     needredraw = #True
                     Break
                  EndIf
               Next
            EndIf
            
         Case #PB_EventType_LeftButtonDown
            If *hoverBTN
               *PressBTN = *hoverBTN
               *PressBTN\mask | #__MASK_Press
               
               needRedraw = SetStateTitleBar( *this, *hoverBTN\type)
            EndIf
            
         Case  #PB_EventType_LeftDoubleClick
            If *PressBTN
               *PressBTN\mask &~ #__MASK_Press
               *PressBTN = 0
            EndIf
            
            If *t\mask & #__MASK_Hover
               needRedraw = SetStateTitleBar( *this, #_BTN_Maximize)
            EndIf
            
      EndSelect
   EndIf
   
   ProcedureReturn needRedraw
EndProcedure


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
         
         DrawTitleBar(*this, RGBA(230, 235, 240, 255))
         
      Next
      
      StopDrawing()
   EndIf
EndProcedure


; =========================================================================
; 3. ОСНОВНОЙ ЦИКЛ ПРИЛОЖЕНИЯ И ИНИЦИАЛИЗАЦИЯ
; =========================================================================
NewList Windows._s_WIDGET()
Define Event.i, mx.i, my.i, needRedraw.b, *this._s_WIDGET
If OpenWindow(0, 0, 0, 800, 230, "Light Titlebar Custom UI Demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 800, 230)
   
   ; Создаем заголовки процедурно
   Create(AddElement(Windows()), 10, 20, 780, 40, "Главное окно программы (Window 1)", #_STYLE_Default, 101)
   Create(AddElement(Windows()), 10, 90, 780, 40, "Окно настроек системы (Window 2)", #_STYLE_Help|#_STYLE_Close, 102)
   Create(AddElement(Windows()), 10, 160, 780, 40, "Информационное сообщение (Window 3)", 0, 103)
   RedrawCanvas(0, Windows())
   
   Repeat
      Event = WaitWindowEvent()
      Select Event
         Case #PB_Event_Gadget
            If EventGadget() = 0
               mx = GetGadgetAttribute(0, #PB_Canvas_MouseX)
               my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
               
               ForEach Windows() : *this = @Windows()
                  If DoEvent( *this, EventType(), mx, my )
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
; CursorPosition = 44
; FirstLine = 37
; Folding = ----------------
; EnableXP
; DPIAware