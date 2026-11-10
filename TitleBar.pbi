; =========================================================================
; 1. КОНСТАНТЫ, ПЕРЕЧИСЛЕНИЯ И СТРУКТУРЫ
; =========================================================================
EnableExplicit
Enumeration 1
   #__BTN_Close
   #__BTN_Maximize
   #__BTN_Minimize
   #__BTN_Help        
   #__BTN_Pin         
   #__BTN_Menu     
   #__BTN_Check
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
#__MASK_Hide      = 1 << 14        ; Объект скрыт изначально (базовый флаг)
      
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
   size.w
   round.a
   checked.b
   mask.q
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

; Macro __draw_check_button( _address_, _size_, _color_ )
;       LineXY(( _address_\x + 0 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 4 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 5 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; Левая линия
;       LineXY(( _address_\x + 0 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 5 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; Левая линия
;       
;       LineXY(( _address_\x + 5 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 0 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 2 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; правая линия
;       LineXY(( _address_\x + 6 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 0 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 3 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; правая линия
;    EndMacro
;    Macro __draw_check_button( _address_, _size_, _color_ )
;   ; --- ЛЕВАЯ ЛИНИЯ (Толщина 2 пикселя) ---
;   LineXY(( _address_\x + ( _address_\width - _size_ ) / 2 ), ( _address_\y + ( _size_ * 2 / 3 ) + ( _address_\height - _size_ ) / 2 ), ( _address_\x + ( _size_ / 3 ) + ( _address_\width - _size_ ) / 2 ), ( _address_\y + _size_ - 1 + ( _address_\height - _size_ ) / 2 ), _color_ )
;   LineXY(( _address_\x + ( _address_\width - _size_ ) / 2 ), ( _address_\y + ( _size_ * 2 / 3 ) + 1 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + ( _size_ / 3 ) + ( _address_\width - _size_ ) / 2 ), ( _address_\y + _size_ + ( _address_\height - _size_ ) / 2 ), _color_ )
;   
;   ; --- ПРАВАЯ ЛИНИЯ (Толщина 2 пикселя) ---
;   LineXY(( _address_\x + _size_ - 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ), ( _address_\x + ( _size_ / 3 ) + 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + _size_ - 1 + ( _address_\height - _size_ ) / 2 ), _color_ )
;   LineXY(( _address_\x + _size_ + ( _address_\width - _size_ ) / 2 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ), ( _address_\x + ( _size_ / 3 ) + 2 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + _size_ - 1 + ( _address_\height - _size_ ) / 2 ), _color_ )
; EndMacro

Macro __draw_check_button( _address_, _size_, _color_ )
  ; --- ЛЕВОЕ ПЛЕЧО (Толщина в 3 линии) ---
  
  ; Верхняя линия: длиннее с внутренней стороны
  LineXY(( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ) - ( _size_ * 25 / 100 ) - 1, ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) - ( _size_ * 25 / 100 ) - 2, ( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) - 1, _color_ ) 
  
  ; Центральная линия: базовая длина
  LineXY(( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ) - ( _size_ * 25 / 100 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) - ( _size_ * 25 / 100 ), ( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ), _color_ ) 
  
  ; Нижняя линия: короче с внешней стороны
  LineXY(( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ) - ( _size_ * 25 / 100 ) + 1, ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) - ( _size_ * 25 / 100 ) + 2, ( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) + 1, _color_ ) 


  ; --- ПРАВОЕ ПЛЕЧО (Толщина в 3 линии) ---
  
  ; Верхняя линия: длиннее с внутренней стороны
  LineXY(( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) - 1, ( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ) + ( _size_ * 60 / 100 ) + 1, ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) - ( _size_ * 60 / 100 ) - 2, _color_ ) 
  
  ; Центральная линия: базовая длина
  LineXY(( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ), ( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ) + ( _size_ * 60 / 100 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) - ( _size_ * 60 / 100 ), _color_ ) 
  
  ; Нижняя линия: короче с внешней стороны
  LineXY(( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ), ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) + 1, ( _address_\x + ( _address_\width - _size_ ) / 2 ) + ( _size_ * 30 / 100 ) + ( _size_ * 60 / 100 ) - 1, ( _address_\y + ( _address_\height - _size_ ) / 2 ) + ( _size_ * 80 / 100 ) - ( _size_ * 60 / 100 ) + 2, _color_ )
EndMacro

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

Procedure ChromeBox(vertical.b, X, Y, w, h, isactive, currentcolor.l, localslant, GradientDepth = 25, outerbordercolor.l = -1, innerhighlightcolor.l = -1)
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
         Line(X + stepVar, Y + currentSlantVal, 1, currentLength, color)
      Else
         ; Рисуем горизонтальные полоски сверху вниз
         Line(X + currentSlantVal, Y + stepVar, currentLength, 1, color)
      EndIf
      
      ColorAccum + ColorStepFixed
      SlantAccum - SlantStepFixed
   Next
   
   ; 4. Отрисовка контуров
   If vertical
      ; === ВЕРТИКАЛЬНЫЙ РЕЖИМ (Вкладка «смотрит» вверх, основание справа) ===
      LineXY(X + dw, Y, X, Y + localslant, outerbordercolor)             
      LineXY(X, Y + localslant, X, Y + h - 1 - localslant, outerbordercolor)         
      LineXY(X, Y + h - 1 - localslant, X + dw, Y + h - 1, outerbordercolor)     
      
      If isactive
         LineXY(X + dw, Y + 1, X + 1, Y + localslant + 1, innerhighlightcolor)
         LineXY(X + 1, Y + localslant + 1, X + 1, Y + h - 1 - localslant - 1, innerhighlightcolor)
         LineXY(X + 1, Y + h - 1 - localslant - 1, X + dw, Y + h - 2, innerhighlightcolor)
      Else
         ; Замыкающая линия справа (стык с панелью)
         LineXY(X + dw, Y, X + dw, Y + h - 1, outerbordercolor)
      EndIf
   Else
      ; === ГОРИЗОНТАЛЬНЫЙ РЕЖИМ (Классический Chrome) ===
      LineXY(X, Y + dh, X + localslant, Y, outerbordercolor)             
      LineXY(X + localslant, Y, X + w - 1 - localslant, Y, outerbordercolor)         
      LineXY(X + w - 1 - localslant, Y, X + w - 1, Y + dh, outerbordercolor)     
      
      If isactive
         LineXY(X + 1, Y + dh, X + localslant + 1, Y + 1, innerhighlightcolor)
         LineXY(X + localslant + 1, Y + 1, X + w - 1 - localslant - 1, Y + 1, innerhighlightcolor)
         LineXY(X + w - 1 - localslant - 1, Y + 1, X + w - 2, Y + dh, innerhighlightcolor)
      Else
         ; Замыкающая линия снизу
         LineXY(X, Y + dh, X + w - 1, Y + dh, outerbordercolor)
      EndIf
   EndIf
EndProcedure

;-
; Расчет геометрии (расстановка элементов)
Procedure UpdateTitleBar(*this._s_WIDGET)
   Protected._s_BTN *btn
   Protected._s_TITLE *title = *this\title
   Protected Spacing = *title\bar\spacing
   Protected Indent = *title\bar\indent
   Protected right_x = *this\Width - *title\slant
   
   ; Этот цикл считает ТОЛЬКО кнопки управления. Никаких проверок типов!
   If ListSize(*title\bar\btn())
      right_x + Spacing - Indent
      ForEach *title\bar\btn()
         *btn = @*title\bar\btn()
         *btn\Width = *this\Height - Indent * 2
         *btn\Height = *btn\Width
         right_x - Spacing - *btn\Width 
         *btn\X = *this\X + right_x
         *btn\Y = *this\Y + (*this\Height - *btn\Height) / 2
      Next
      right_x - Indent 
   EndIf
   
   ; Настраиваем изолированный заголовок напрямую
   If *title
      *title\Y = *this\Y 
      *title\X = *this\X + *title\slant 
      *title\Width = right_x - *title\slant
      *title\Height = *this\Height
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
   Protected._s_TITLE *title = *this\title
   Protected._s_TXT *txt = *title\txt
   Protected._s_IMG *img = *title\img
   Protected._s_BTN *btn
   
   Protected indent =  *title\indent ; (*this\Height - *title\img\Height)/2
   
   ; 1. Замеры метрик (Пишем сразу в структуру только при изменениях)
   If *txt\change : *title\mask | #__MASK_Update
      *txt\change = #False
      If *txt\Text 
         *txt\width  = TextWidth(*txt\Text)
         *txt\height = TextHeight(*txt\Text)
      Else
         *txt\width  = 0 : *txt\height = 0
      EndIf
   EndIf
   
   If *img\change : *title\mask | #__MASK_Update
      *img\change = #False
      If IsImage(*img\Image)
         *img\width  = ImageWidth(*img\Image)
         *img\height = ImageHeight(*img\Image)
      Else
         *img\width  = 0 : *img\height = 0
      EndIf
   EndIf
   
   If *title\mask & #__MASK_Update
      UpdateTitleBar(*this)
      
      If vertical
         *txt\x = (*title\width - *txt\width) >> 1
         *img\x = (*title\width - *img\width) >> 1
         
         *img\y = indent
         *txt\y = MakeAlignPosition(*title\mask, *title\Height, *txt\height, indent)
         
         If Not (*title\mask & #__MASK_Bottom)
            If *img\height > 0 : *txt\y + *img\height + *title\spacing : EndIf
         EndIf
      Else
         *txt\y = (*title\height - *txt\height) >> 1
         *img\y = (*title\height - *img\height) >> 1
         
         *img\x = indent
         *txt\x = MakeAlignPosition(*title\mask, *title\Width,  *txt\width, indent)
         
         If Not (*title\mask & #__MASK_Right)
            If *img\width > 0 : *txt\x + *img\width + *title\spacing : EndIf
         EndIf
      EndIf
   EndIf
   
   ; 1. Отрисовка заголовка
   size = *title\size
   Box(*title\X, *title\Y, *title\Width, *title\Height, RGBA(0, 0, 0, 20))    
   Circle(*title\X+*title\img\X+size, *title\Y+*title\img\Y+size, size, RGBA(0, 120, 215, 255))
   DrawText(*title\X+*title\txt\X, *title\Y+*title\txt\Y, *title\txt\Text, textColor, 0)
   
   ;
   ForEach *title\bar\btn()
      *btn = @*title\bar\btn()
      
      ;       size = *btn\size 
      If *btn\mask & #__MASK_Hover : size = *btn\Height/2 : Else :  size = *btn\Height/4 : EndIf  : size + Bool( size % 2 )
      round = *btn\Height
     ;Debug ""+*btn\Height +" "+ *title\Height
      If Not *btn\round
         Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
      EndIf
      
      ; 2. Обработка фона кнопок при наведении (Ховер в светлой теме)
      If *btn\mask & #__MASK_Hover
         If *btn\type = #__BTN_Close
            ; Классический красный ховер закрытия (не меняется, но крестик становится белым)
            If *btn\round
                size-DesktopScaledX(1)
           symbolColor = RGBA(232, 17, 35, 255)
               RoundBox(*btn\X, *btn\Y, *btn\Width, *btn\Height, round, round, RGBA(232, 17, 35, 255)) 
            Else
               Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(232, 17, 35, 255)) 
            EndIf
            crossColor = RGBA(255, 255, 255, 255) 
         Else
             size+DesktopScaledX(1)
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
            ;  Крестик
         Case #__BTN_Close 
            ; Первая диагональ (сверху-слева -> снизу-справа)
            LineXY(paddingX + 1, paddingY,     paddingX + size + 1, paddingY + size,     crossColor) ; Смещение вправо
            LineXY(paddingX,     paddingY,     paddingX + size,     paddingY + size,     crossColor)
            LineXY(paddingX,     paddingY + 1, paddingX + size,     paddingY + size + 1, crossColor) ; Смещение вниз
            
            ; Вторая диагональ (сверху-справа -> снизу-слева)
            LineXY(paddingX + size - 1, paddingY,     paddingX - 1, paddingY + size,     crossColor) ; Смещение влево
            LineXY(paddingX + size,     paddingY,     paddingX,     paddingY + size,     crossColor)
            LineXY(paddingX + size,     paddingY + 1, paddingX,     paddingY + size + 1, crossColor) ; Смещение вниз
           
            ; Квадрат
         Case #__BTN_Maximize
            DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
            Box(paddingX, paddingY, size, size, symbolColor)
            Box(paddingX + 1, paddingY + 1, size - 2, size - 2, symbolColor) 
            DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
         
            ; Черточка   
         Case #__BTN_Minimize
            LineXY(paddingX, paddingY + size/2 - 1, paddingX + size, paddingY + size/2 - 1, symbolColor)
            LineXY(paddingX, paddingY + size/2,     paddingX + size, paddingY + size/2,     symbolColor)
          
         Case #__BTN_Check ; Галочка: управление углом и точкой перелома
            ; __draw_check_button( *btn, (size+8), symbolColor )
            Protected.l chkX1, chkY1, chkX2, chkY2, chkX3, chkY3
              ; Искусственное увеличение под вес крестика
            size + DesktopScaledX(4)
            paddingX = *btn\X + (*btn\Width - size) / 2
            paddingY = *btn\Y + (*btn\Height - size) / 2
            
            chkX2 = paddingX + (size * 0.30)
            chkY2 = paddingY + (size * 0.80)
            
            chkX1 = chkX2 - (size * 0.25)
            chkY1 = chkY2 - (size * 0.25)
            
            chkX3 = chkX2 + (size * 0.60)
            chkY3 = chkY2 - (size * 0.60)
            
            ; --- Отрисовка левого плеча ---
            ; Верхняя линия: длиннее с внутренней стороны (вычитаем 1 из X, вычитаем 1 из Y на конце)
            LineXY(chkX1 - 1, chkY1 - 2, chkX2, chkY2 - 1, symbolColor) 
            ; Центральная линия: базовая длина
            LineXY(chkX1,     chkY1,     chkX2, chkY2,     symbolColor) 
            ; Нижняя линия: короче с внешней стороны (прибавляем 1 к X, прибавляем 1 к Y на конце)
            LineXY(chkX1 + 1, chkY1 + 2, chkX2, chkY2 + 1, symbolColor) 
            
            ; --- Отрисовка правого плеча ---
            ; Верхняя линия: длиннее с внутренней стороны (прибавляем 1 к X, вычитаем 1 из Y на конце)
            LineXY(chkX2, chkY2 - 1, chkX3 + 1, chkY3 - 2, symbolColor) 
            ; Центральная линия: базовая длина
            LineXY(chkX2, chkY2,     chkX3,     chkY3,     symbolColor) 
            ; Нижняя линия: короче с внешней стороны (вычитаем 1 из X, прибавляем 1 к Y на конце)
            LineXY(chkX2, chkY2 + 1, chkX3 - 1, chkY3 + 2, symbolColor)

            ; Знак вопроса   
         Case #__BTN_Help
            DrawText(paddingX + DesktopScaledX(1), paddingY - DesktopScaledY(2), "?", symbolColor, 0)
            
      EndSelect
      
      If *btn\round
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
         ;If *btn\mask & #__MASK_Hover
            RoundBox(*btn\X-1, *btn\Y-1, *btn\Width+2, *btn\Height+2,  round, round, symbolColor)    
         ;EndIf
         RoundBox(*btn\X, *btn\Y, *btn\Width, *btn\Height, round, round, symbolColor)    
         ;RoundBox(*btn\X+1, *btn\Y+1, *btn\Width-2, *btn\Height-2,  round, round, symbolColor)    
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
      EndIf
      
   Next
   
   *title\mask &~ #__MASK_Update
EndProcedure

; Создание и инициализация заголовка окна
Procedure CreateTitleBar(Text.s, Image.i = 0, flags.l = #_STYLE_Default)
   Protected._s_TITLE *title = AllocateStructure(_s_TITLE)
   Protected._s_BTN *btn
   Protected round
   
   *title\mask | #__MASK_Left : Static i : If i = 1 :   *title\mask | #__MASK_Center :  EndIf :  If i = 2 :  *title\mask | #__MASK_Right :  EndIf :  i+1
   
   round = DesktopScaledX(20)
   *title\slant = DesktopScaledX(20)
   *title\bar\indent = DesktopScaledX(4) ;+ DesktopScaledX(4)
   *title\bar\spacing = DesktopScaledX(4)
   
   *title\indent  = DesktopScaledX(8)
   *title\spacing  = DesktopScaledX(6)
   
   If *title\slant : *title\indent = 0 : EndIf
   
   *title\size = DesktopScaledX(10) 
   
   If Text
      *title\txt\Text = Text
      *title\txt\change = #True
   EndIf
   ;
   If IsImage(Image)
      *title\img\image = Image 
      *title\img\change = #True
   Else
      *title\img\Width = *title\size*2
      *title\img\Height = *title\size*2
   EndIf
   
   ; 1. В списке btn() теперь живут ТОЛЬКО кнопки управления справа
   If flags & #_STYLE_Close :  *btn = AddElement(*title\bar\btn()) : *btn\type = #__BTN_Close : *btn\round = round : EndIf
   If flags & #_STYLE_Maximize : *btn = AddElement(*title\bar\btn()) : *btn\type = #__BTN_Maximize : *btn\round = round : EndIf
   If flags & #_STYLE_Minimize : *btn = AddElement(*title\bar\btn()) : *btn\type = #__BTN_Minimize : *btn\round = round : EndIf
   ;If flags & #_STYLE_Help     : *btn = AddElement(*title\bar\btn()) : *btn\type = #__BTN_Help     : *btn\round = round : EndIf
   If flags & #_STYLE_Help     : *btn = AddElement(*title\bar\btn()) : *btn\type = #__BTN_Check     : *btn\round = round : EndIf
   If flags & #_STYLE_Pin      : *btn = AddElement(*title\bar\btn()) : *btn\type = #__BTN_Pin      : *btn\round = round : EndIf
   If flags & #_STYLE_Menu     : *btn = AddElement(*title\bar\btn()) : *btn\type = #__BTN_Menu     : *btn\round = round : EndIf
   ProcedureReturn *title
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

Procedure Create( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l, Text.s, flags.l = #_STYLE_Default, Image.i = 0)
   *this\fontID = FontID(0)
   *this\title = CreateTitleBar(Text, Image, flags)
   Resize( *this, X, Y, Width, Height)
EndProcedure

Procedure SetStateTitleBar(*this._s_WIDGET, btn)
   Protected windowID = EventWindow()
   Select btn
      Case #__BTN_Help : MessageRequester("Инфо", "Нажата кнопка Справка")
      Case #__BTN_Close : PostEvent(#PB_Event_CloseWindow, windowID, 0)
      Case #__BTN_Minimize : SetWindowState(windowID, #PB_Window_Minimize)
      Case #__BTN_Maximize 
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
   Protected._s_TITLE *title = *this\title
   Protected._s_BTN *btn
   Protected shouldHover.b
   Static._s_BTN *hoverBTN, *PressBTN
   
   If *hoverBTN And Not Bool( mx >= *hoverBTN\X And mx < *hoverBTN\X + *hoverBTN\Width And my >= *hoverBTN\Y And my < *hoverBTN\Y + *hoverBTN\Height )
      *hoverBTN\mask &~ #__MASK_Hover
;       *hoverBTN\size = *hoverBTN\Height/4
;       *hoverBTN\size + Bool( *hoverBTN\size % 2 )
      *hoverBTN = 0
      needredraw = #True
   EndIf   
   
   If  Bool( mx >= *this\X And mx < *this\X + *this\Width And my >= *this\Y And my < *this\Y + *this\Height ) 
      Select event
         Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave, #PB_EventType_LeftButtonUp
            If Bool(*title\mask & #__MASK_Hover) <> Bool( mx >= *title\X And mx < *title\X + *title\Width And my >= *title\Y And my < *title\Y + *title\Height )
               *title\mask ! #__MASK_Hover ; Переключаем тумблер ховера (XOR)
            EndIf
            
            If Not *title\mask & #__MASK_Hover
               ; Всего ОДИН цикл для поиска и одновременного сброса/включения ховеров
               ForEach *title\bar\btn()
                  *btn = @*title\bar\btn()
                  
                  ; 2. Если текущее состояние маски кнопки не совпадает с реальностью
                  If Bool(*btn\mask & #__MASK_Hover) <> Bool( mx >= *btn\X And mx < *btn\X + *btn\Width And my >= *btn\Y And my < *btn\Y + *btn\Height )
                     *btn\mask ! #__MASK_Hover ; Переключаем тумблер ховера (XOR)
                     
                     ; Меням размеры геометрии значка
                     If *btn\mask & #__MASK_Hover
;                         *btn\size = *btn\Height/2 
                        *hoverBTN = *btn
                     Else
;                         *btn\size = *btn\Height/4
                     EndIf
;                      *btn\size + Bool( *btn\size % 2 )
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
            
            If *title\mask & #__MASK_Hover
               needRedraw = SetStateTitleBar( *this, #__BTN_Maximize)
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
   Define titleHeight = 20+8
   ; Создаем заголовки процедурно
   Create(AddElement(Windows()), 10, 20, 780, titleHeight, "Главное окно программы (Window 1)", #_STYLE_Default, 101)
   Create(AddElement(Windows()), 10, 90, 780, titleHeight, "Окно настроек системы (Window 2)", #_STYLE_Help|#_STYLE_Close, 102)
   Create(AddElement(Windows()), 10, 160, 780, titleHeight, "Информационное сообщение (Window 3)", 0, 103)
   RedrawCanvas(0, Windows())
   
   Repeat
      Event = WaitWindowEvent()
      Select Event
         Case #PB_Event_Gadget
            needRedraw = #False
            
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
; CursorPosition = 479
; FirstLine = 332
; Folding = -f0--fN0--------
; EnableXP
; DPIAware