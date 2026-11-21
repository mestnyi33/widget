EnableExplicit

;-
UsePNGImageDecoder()
If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
   End
EndIf
If DesktopResolutionX() > 1
   ResizeImage(1, DesktopScaledX(ImageWidth(1)),DesktopScaledY(ImageHeight(1)))
EndIf

; =====================================================================
; 1. КОНСТАНТЫ И ФЛАГИ
; =====================================================================
Enumeration
   #__BTN_Title    ; Сам заголовок (Иконка + Текст). Занимает всё свободное место!
                   ; --- Кнопки управления (выстраиваются справа) ---
   #__BTN_Close
   #__BTN_Maximize
   #__BTN_Minimize
   #__BTN_Check
   #__BTN_Help        
   #__BTN_Pin         
   #__BTN_Menu        
EndEnumeration

; Битовые флаги для процедурного создания заголовка
#_STYLE_Close = 1 << 0
#_STYLE_Minimize = 1 << 1
#_STYLE_Maximize = 1 << 2
#_STYLE_Help     = 1 << 3
#_STYLE_Pin      = 1 << 4
#_STYLE_Menu     = 1 << 5
#_STYLE_Default  = #_STYLE_Minimize | #_STYLE_Maximize|#_STYLE_Close ; Стандартная тройка кнопок

; ==============================================================================
; МАСКИ - Единые битовые константы (Quad)
; ==============================================================================
#__MASK_none      = 0
#__MASK_update    = 1 << 0         ; Флаг: Требуется пересчет геометрии (для всех) (TextWidth и т.д.) нужно пересчитать координаты X для каретки/выделения.

#__MASK_left      = 1 << 1   ; 2   move to left
#__MASK_top       = 1 << 2   ; 4   move to top
#__MASK_right     = 1 << 3   ; 8   move to right
#__MASK_bottom    = 1 << 4   ; 16  move to bottom
#__MASK_center    = 1 << 5

#__MASK_hover     = 1 << 6
#__MASK_press     = 1 << 7         ; 64  button press
#__MASK_release   = 1 << 8         ; 128 button release
#__MASK_dragstart = 1 << 9         ; 256
#__MASK_drag      = 1 << 10        ; Состояние перетаскивания Объект в процессе перетаскивания
#__MASK_active    = 1 << 11        ; Виджет в фокусе / Строка выбрана / Окно активно
#__MASK_redraw    = 1 << 12        ; Флаг: Требуется перерисовка

#__MASK_hidden    = 1 << 16        ; Объект полностью скрыт
#__MASK_disabled   = 1 << 17       ; Объект заблокирован
#__MASK_cursor    = 1 << 21
#__MASK_resize    = 1 << 22
;
#__maskflag_wordwrap  = 1 << 25
#__maskflag_tokken    = 1 << 18
;
#__maskrow_change    = 1 << 20        ; текст изменился, надо перепарсить токены.
#__maskrow_edit      = 1 << 19        ; Выделение (Строка)
#__maskrow_node      = 1 << 23        ; Является узлом (Строка) / Деревом (Виджет)
#__maskrow_collapsed = 1 << 24        ; Свернуто (Узел/Ветка)

#__MASK_change    = #__maskrow_change
#__MASK_UpdateTotalSize = 1<<25

; =====================================================================
; 2. СТРУКТУРЫ ДАННЫХ
; =====================================================================
Structure _s_POINT : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure
Structure _s_TXT Extends _s_COORDINATE
   Text.s
   change.b
EndStructure

Structure _s_IMG Extends _s_COORDINATE
   Image.i
   change.b
EndStructure

Structure _s_MOUSE
   *press._s_TAB  ; Указатель на перетаскиваемую вкладку
   *enter._s_TAB
EndStructure

Structure _s_BOX Extends _s_COORDINATE
   size.l
   round.a
   checked.b
   mask.q
EndStructure

Structure _s_BTN Extends _s_BOX
   ;color._s_color
   ;arrow._s_arrow
   Type.l       
EndStructure

Structure _s_TAB  Extends _s_BOX
   ID.i          ; Номер элемента в списке данных строки (0, 1, 2...) 
   pos.l
   
   ; Поля для идеальной математики плавного сдвига
   offset.l        ; Динамический визуальный сдвиг
   minOffset.l     ; Левый ограничитель хода
   maxOffset.l     ; Правый ограничитель хода
   
   txt._s_TXT    ; Имя поля заголовка
   img._s_IMG
   List btn._s_BTN()
   ;btn._s_BTN      ; Кнопка закрытия (вложенная структура — не требует AllocateStructure!)
   
   StructureUnion
      *data 
      ContainerID.i  ; id контейнера, привязанного к этой вкладке
   EndStructureUnion
EndStructure

Structure _s_TABS
   *active._s_TAB   
   plus._s_TAB    ; <--- Одиночная структура кнопки ПЛЮС
   
   slant.a
   align.a               
   indent.a 
   spacing.a             
   padding.b
   
   vertical.b
   TotalSize.l       
   
   List _s._s_TAB()  ; Заголовки вкладок
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   mask.q
   change.b
   ;    padding.a
   ;    spacing.a             
   Tab._s_TABS
   
   canvasid     .i  
   fontid       .i  
   bgcolor      .l ; <--- добавь это поле для управления общим фоном холста
   
EndStructure

Global bottomSpacing.i = DesktopScaledX(3) 
Global mouse._s_MOUSE
Macro PressedTAB( )
   mouse\press
EndMacro
Macro EnteredTAB( )
   mouse\enter
EndMacro

; =====================================================================
; 3. ЛОГИКА АЛГОРИТМА И ОТРИСОВКИ
; =====================================================================
Procedure.l MakeColor(bgColor.l, value.l = 0)
   ; Извлекаем каналы с помощью побитового "И" (&) и сдвигов (>>)
   Protected.l r = (bgColor & $FF) +  value 
   Protected.l g = ((bgColor >> 8) & $FF) + value
   Protected.l b = ((bgColor >> 16) & $FF) + value
   Protected.l a = (bgColor >> 24) & $FF ; Альфа-канал просто двигаем
   
   ; Быстрое ограничение (Clamp) от 0 до 255
   If r > 255 : r = 255 : ElseIf r < 0 : r = 0 : EndIf
   If g > 255 : g = 255 : ElseIf g < 0 : g = 0 : EndIf
   If b > 255 : b = 255 : ElseIf b < 0 : b = 0 : EndIf
   
   ; Собираем цвет обратно в один Long
   ProcedureReturn r | (g << 8) | (b << 16) | (a << 24)
EndProcedure

Procedure.i MakeAlignPosition(alignFlags.l, contentSize.i, objectSize.i, Offset.i = 10)
   If alignFlags & #__MASK_Center
      ProcedureReturn (contentSize - objectSize) / 2
   ElseIf alignFlags & #__MASK_Right
      ProcedureReturn contentSize - objectSize - Offset
   Else ; #__MASK_Left
      ProcedureReturn Offset
   EndIf
EndProcedure

;-
Procedure.l UpdateBTNPos(*tab._s_TAB, indent.a, btnSpacing.a, vertical.b)
   Protected._s_BTN *btn
   Protected mainSize.l, crossSize.l, maxBtn.l
   
   If vertical
      mainSize  = *tab\Height
      crossSize = *tab\Width
      maxBtn    = DesktopScaledY(16)
   Else
      mainSize  = *tab\Width
      crossSize = *tab\Height
      maxBtn    = DesktopScaledX(16)
   EndIf
   
   ; Если кнопок нет — возвращаем всю длину вкладки без вычетов
   If ListSize(*tab\btn()) = 0
      ProcedureReturn mainSize
   EndIf
   
   Protected pos.l = mainSize - indent
   Protected btnSize.l = crossSize - indent * 2
   If btnSize > maxBtn : btnSize = maxBtn : EndIf
   
   pos + btnSpacing
   ForEach *tab\btn()
      *btn = @*tab\btn()
      *btn\Width  = btnSize
      *btn\Height = btnSize
      ;pos - btnSpacing - btnSize
      
      If vertical
         *btn\X = (crossSize - btnSize) >> 1
         *btn\Y = pos
      Else
         *btn\X = pos
         *btn\Y = (crossSize - btnSize) >> 1
      EndIf
   Next
   
   ProcedureReturn pos ;- DesktopScaledX(6) + indent
EndProcedure

Procedure UpdateContentPos(*tab._s_TAB, indent.a, Spacing.a, btnSpacing.a, vertical.b)
   Protected contentX.l, contentY.l
   Protected._s_TXT *txt = *tab\txt
   Protected._s_IMG *img = *tab\img
   If Not (*img\width And *txt\width) : Spacing = 0 : EndIf
   
   Protected contentLimit.l = UpdateBTNPos(*tab, indent, btnSpacing, vertical)
   
   If vertical
      *txt\x = (*tab\width - *txt\width) >> 1
      *img\x = (*tab\width - *img\width) >> 1
      
      contentY = MakeAlignPosition(*tab\mask, contentLimit, *img\height + *txt\height + Spacing, indent)
      *txt\y = contentY
      *img\y = contentY
      
      If Not (*tab\mask & #__MASK_Bottom)
         If *img\height > 0 : *txt\y + *img\height + Spacing : EndIf
      Else
         If *txt\height > 0 : *img\y + *txt\height + Spacing : EndIf
      EndIf
   Else
      *txt\y = (*tab\height - *txt\height) >> 1
      *img\y = (*tab\height - *img\height) >> 1
      
      contentX = MakeAlignPosition(*tab\mask, contentLimit, *img\width + *txt\width + Spacing, indent)
      *txt\x = contentX
      *img\x = contentX
      
      If Not (*tab\mask & #__MASK_Right)
         If *img\width > 0 : *txt\x + *img\width + Spacing : EndIf
      Else
         If *txt\width > 0 : *img\x + *txt\width + Spacing : EndIf
      EndIf
   EndIf
EndProcedure

Procedure UpdateContentSize(*tab._s_TAB)
   Protected._s_TXT *txt = *tab\txt
   Protected._s_IMG *img = *tab\img
   
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

;-
Procedure DrawBTN(*btn._s_BTN, offsetX.l = 0, offsetY.l = 0)
   Protected.l crossColor, symbolColor
   Protected.l defaultColor = RGBA(80, 80, 80, 255)      ; Серые значки по умолчанию
   Protected.l winSymbolColor = RGBA(50, 50, 50, 255)    ; Более темные значки при ховере
   Protected size.l, paddingX.l, paddingY.l, round.l
   
   Protected bx = offsetX + *btn\X
   Protected by = offsetY + *btn\Y
   
   If *btn\mask & #__MASK_Hover : size = *btn\Height / 2 : Else : size = *btn\Height / 4 : EndIf
   size + Bool(size % 2)
   round = *btn\Height
   
   If Not *btn\round
      Box(bx, by, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
   EndIf
   
   ; 1. Обработка фона кнопок при наведении
   If *btn\mask & #__MASK_Hover
      If *btn\type = #__BTN_Close
         If *btn\round
            size - DesktopScaledX(1)
            symbolColor = RGBA(232, 17, 35, 255)
            RoundBox(bx, by, *btn\Width, *btn\Height, round, round, RGBA(232, 17, 35, 255)) 
         Else
            Box(bx, by, *btn\Width, *btn\Height, RGBA(232, 17, 35, 255)) 
         EndIf
         crossColor = RGBA(255, 255, 255, 255) 
      Else
         size + DesktopScaledX(1)
         If Not *btn\round
            Box(bx, by, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
         EndIf
         symbolColor = winSymbolColor
      EndIf
   Else
      crossColor = defaultColor
      symbolColor = defaultColor
   EndIf
   
   paddingX = bx + (*btn\Width - size) / 2
   paddingY = by + (*btn\Height - size) / 2
   
   ; 2. Отрисовка значков
   Select *btn\type
      Case #__BTN_Close ; Крестик
         LineXY(paddingX + 1, paddingY,     paddingX + size + 1, paddingY + size,     crossColor)
         LineXY(paddingX,     paddingY,     paddingX + size,     paddingY + size,     crossColor)
         LineXY(paddingX,     paddingY + 1, paddingX + size,     paddingY + size + 1, crossColor)
         
         LineXY(paddingX + size - 1, paddingY,     paddingX - 1, paddingY + size,     crossColor)
         LineXY(paddingX + size,     paddingY,     paddingX,     paddingY + size,     crossColor)
         LineXY(paddingX + size,     paddingY + 1, paddingX,     paddingY + size + 1, crossColor)
         
      Case #__BTN_Maximize ; Квадрат
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
         Box(paddingX, paddingY, size, size, symbolColor)
         Box(paddingX + 1, paddingY + 1, size - 2, size - 2, symbolColor) 
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
         
      Case #__BTN_Minimize ; Черточка
         LineXY(paddingX, paddingY + size/2 - 1, paddingX + size, paddingY + size/2 - 1, symbolColor)
         LineXY(paddingX, paddingY + size/2,     paddingX + size, paddingY + size/2,     symbolColor)
         
      Case #__BTN_Check ; Галочка
         Protected.l chkX1, chkY1, chkX2, chkY2, chkX3, chkY3
         size + DesktopScaledX(4)
         paddingX = bx + (*btn\Width - size) / 2
         paddingY = by + (*btn\Height - size) / 2
         
         chkX2 = paddingX + (size * 0.30)
         chkY2 = paddingY + (size * 0.80)
         
         chkX1 = chkX2 - (size * 0.25)
         chkY1 = chkY2 - (size * 0.25)
         
         chkX3 = chkX2 + (size * 0.60)
         chkY3 = chkY2 - (size * 0.60)
         
         ; Левое плечо
         LineXY(chkX1 - 1, chkY1 - 2, chkX2, chkY2 - 1, symbolColor) 
         LineXY(chkX1,     chkY1,     chkX2, chkY2,     symbolColor) 
         LineXY(chkX1 + 1, chkY1 + 2, chkX2, chkY2 + 1, symbolColor) 
         
         ; Правое плечо
         LineXY(chkX2, chkY2 - 1, chkX3 + 1, chkY3 - 2, symbolColor) 
         LineXY(chkX2, chkY2,     chkX3,     chkY3,     symbolColor) 
         LineXY(chkX2, chkY2 + 1, chkX3 - 1, chkY3 + 2, symbolColor)
         
      Case #__BTN_Help ; Знак вопроса
         DrawText(paddingX + DesktopScaledX(1), paddingY - DesktopScaledY(2), "?", symbolColor, 0)
         
   EndSelect
   
   ; 3. Двойной сглаженный контур круглой кнопки
   If *btn\round
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
      RoundBox(bx - 1, by - 1, *btn\Width + 2, *btn\Height + 2, round, round, symbolColor)    
      RoundBox(bx,     by,     *btn\Width,     *btn\Height,     round, round, symbolColor)    
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
   EndIf
EndProcedure

Procedure DrawTAB(*tab._s_TAB, bgColor.l = $FF808080, frColor.l = $FF000000, vertical.b = 0, localslant.a = 0, GradientDepth = 65)
   Protected X = *tab\x 
   Protected Y = *tab\y
   Protected w = *tab\width
   Protected h = *tab\Height 
   
   ; 1. Модификация цвета и размеров от состояния вкладки
   If *tab\mask & #__MASK_Hover 
      bgColor = MakeColor(bgColor, 30)
   EndIf
   If *tab\mask & #__MASK_drag
      bgColor = $A00000FF
   EndIf
   
   Protected isactive = Bool(*tab\mask & #__MASK_active)
   If isactive
      h + bottomSpacing
   EndIf
   
   If h <= 0 Or w <= 0 : ProcedureReturn : EndIf
   
   Protected txColor = $FFFFFFFF
   If *tab\mask & #__MASK_Hover Or isactive
      txColor = $FF000000
   EndIf
   
   ; Расчет цветов (вычисляем ПОСЛЕ всех изменений bgColor при Hover/Drag)
   Protected.a currentalpha = Alpha(bgColor)
   Protected baser = Red(bgColor), baseg = Green(bgColor), baseb = Blue(bgColor)
   Protected innerhighlightcolor.l = RGBA(baser + (255 - baser) * 0.3, baseg + (255 - baseg) * 0.3, baseb + (255 - baseb) * 0.3, currentalpha)
   
   Protected dh = h - 1, dw = w - 1
   
   ; 2. ЗАЛИВКА ТЕЛА ВКЛАДКИ (градиент со скосом или обычный прямоугольник)
   If localslant > 0
      If isactive : GradientDepth = 0 : EndIf
      
      ; Защита цвета от Underflow
      Protected MaxDrop = baser
      If baseg < MaxDrop : MaxDrop = baseg : EndIf
      If baseb < MaxDrop : MaxDrop = baseb : EndIf
      If GradientDepth > MaxDrop : GradientDepth = MaxDrop : EndIf 
      
      Protected Steps = dh : If vertical : Steps = dw : EndIf
      
      If Steps > 0
         Protected ColorStepFixed = (GradientDepth << 16) / Steps
         Protected SlantStepFixed = (localslant << 16) / Steps
         Protected ColorAccum = 0
         Protected SlantAccum = localslant << 16
         Protected stepVar
         
         For stepVar = 0 To Steps
            Protected currentSlantVal = (SlantAccum + $8000) >> 16
            Protected currentLength = w - (currentSlantVal << 1)
            If vertical : currentLength = h - (currentSlantVal << 1) : EndIf
            
            If currentLength <= 0 : Break : EndIf 
            
            Protected currentColorStep = ColorAccum >> 16
            Protected color = RGBA(baser - currentColorStep, baseg - currentColorStep, baseb - currentColorStep, currentalpha)
            
            If vertical
               Line(X + stepVar, Y + currentSlantVal, 1, currentLength, color)
            Else
               Line(X + currentSlantVal, Y + stepVar, currentLength, 1, color)
            EndIf
            
            ColorAccum + ColorStepFixed
            SlantAccum - SlantStepFixed
         Next
      Else
         Box(X, Y, w, h, bgColor)
      EndIf
   Else
      Box(X, Y, w, h, bgColor)
   EndIf
   
   ; 3. ОТРИСОВКА ИКОНКИ
   If *tab\img\Width Or *tab\img\Height
      DrawAlphaImage(ImageID(*tab\img\Image), X + *tab\img\x, Y + *tab\img\y)
   EndIf
   
   ; 4. ОТРИСОВКА ТЕКСТА
   If *tab\txt\Width Or *tab\txt\Height
      ; Примечание: если текст рисуется поверх градиента, возможно стоит использовать DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(X + *tab\txt\x, Y + *tab\txt\y, *tab\txt\Text, txColor, bgColor)
   EndIf
   
   ; 4.5. ОТРИСОВКА КНОПКИ ЗАКРЫТИЯ (если ширина > 0)
   ForEach *tab\btn()
      DrawBTN(@*tab\btn(), X, Y)
   Next
   
   ; 5. ОТРИСОВКА КОНТУРОВ
   If vertical
      ; === ВЕРТИКАЛЬНЫЙ РЕЖИМ ===
      LineXY(X + dw, Y, X, Y + localslant, frColor)             
      LineXY(X, Y + localslant, X, Y + dh - localslant, frColor)         
      LineXY(X, Y + dh - localslant, X + dw, Y + dh, frColor)     
      
      If isactive
         LineXY(X + dw, Y + 1, X + 1, Y + localslant + 1, innerhighlightcolor)
         LineXY(X + 1, Y + localslant + 1, X + 1, Y + dh - localslant - 1, innerhighlightcolor)
         LineXY(X + 1, Y + dh - localslant - 1, X + dw, Y + dh - 1, innerhighlightcolor)
      Else
         LineXY(X + dw, Y, X + dw, Y + dh, frColor)
      EndIf
   Else
      ; === ГОРИЗОНТАЛЬНЫЙ РЕЖИМ ===
      LineXY(X, Y + dh, X + localslant, Y, frColor)             
      LineXY(X + localslant, Y, X + dw - localslant, Y, frColor)         
      LineXY(X + dw - localslant, Y, X + dw, Y + dh, frColor)     
      
      If isactive
         LineXY(X + 1, Y + dh, X + localslant + 1, Y + 1, innerhighlightcolor)
         LineXY(X + localslant + 1, Y + 1, X + dw - localslant - 1, Y + 1, innerhighlightcolor)
         LineXY(X + dw - localslant - 1, Y + 1, X + dw - 1, Y + dh, innerhighlightcolor)
      Else
         LineXY(X, Y + dh, X + dw, Y + dh, frColor)
      EndIf
   EndIf
EndProcedure


Procedure DrawTabs(*this._s_WIDGET, *activeTAB._s_TAB)
   Protected position.i, widgetChanged.b, shiftTabs.b, updateSize.b
   Protected *tab._s_TAB
   Protected vertical.b = *this\tab\vertical
   Protected bgColor.l = *this\bgcolor
   Protected frColor = MakeColor(bgColor, -30)
   Protected gWidth.l = *this\Width
   Protected gHeight.l = *this\Height
   Protected indent.a = *this\tab\indent
   Protected localslant = *this\tab\slant
   Protected Spacing.i
   Protected tab_size.i
   Protected lineX, lineY
   frColor = $ff000000
   bgColor = $FF808080
   
   ; 1. Сохраняем факт глобального изменения виджета до сброса флага
   If *this\change 
      widgetChanged = #True
      shiftTabs = #True
      updateSize = #True
      *this\change = 0
   EndIf
   
   ; 2. Если стоит маска пересчета — сдвигаем все вкладки и обновляем общий размер
   If *this\mask & #__MASK_UpdateTotalSize
      *this\mask &~ #__MASK_UpdateTotalSize
      shiftTabs = #True
      updateSize = #True
   EndIf
   
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      Protected._s_TXT *txt = *tab\txt
      Protected._s_IMG *img = *tab\img
      
      ; Проверяем, нужно ли заново замерить текст/картинку конкретно этой вкладки
      If *txt\change Or *img\change Or widgetChanged
         UpdateContentSize(*tab)
         *txt\change = 0
         *img\change = 0
         
         shiftTabs = #True
         updateSize = #True
      EndIf
      
      ; Пересчитываем геометрию и позицию вкладки
      If shiftTabs
         *tab\pos = position 
         
         If *img\width And *txt\width
            Spacing = DesktopScaledX(6)
         Else
            Spacing = 0
         EndIf
         
         ; Считаем место, которое займут кнопки вкладки
         Protected btnCount = ListSize(*tab\btn())
         Protected btnTotalSize.i = 0
         Protected btnSize.i = 0
         Protected btnSpacing.i = DesktopScaledX(4)
         
         If btnCount > 0
            If vertical
               btnSize = gWidth - BottomSpacing - *this\tab\padding * 2
            Else
               btnSize = gHeight - BottomSpacing - *this\tab\padding * 2
            EndIf
            If btnSize > DesktopScaledX(16) : btnSize = DesktopScaledX(16) : EndIf ; ограничиваем макс. размер кнопки на вкладке
            
            btnTotalSize = btnCount * btnSize + (btnCount - 1) * btnSpacing
            If *img\width Or *txt\width
               btnTotalSize + DesktopScaledX(6) ; отступ между текстом/иконкой и блоком кнопок
            EndIf
         EndIf
         
         tab_size = Spacing + *this\tab\padding * 2 + btnTotalSize
         If vertical 
            tab_size + *img\height + *txt\height 
         Else 
            tab_size + *img\width + *txt\width 
         EndIf
         If *tab\size < tab_size : *tab\size = tab_size : EndIf
         
         If vertical
            *tab\x = *this\x
            *tab\y = *this\y + indent + position
            *tab\width = gWidth - BottomSpacing
            *tab\height = *tab\size +  localslant * 2
         Else
            *tab\y = *this\y
            *tab\x = *this\x + indent + position 
            *tab\width = *tab\size + localslant * 2
            *tab\height = gHeight - BottomSpacing
         EndIf 
         
         UpdateContentPos(*tab, localslant + *this\tab\padding, Spacing, btnSpacing, vertical)
      EndIf
      
      ; Сдвигаем позицию на полную ширину/высоту вкладки (включая оба скоса) + spacing
      position + *tab\size + *this\tab\spacing
      
      ; Слой 1: Статичные
      If *tab <> *activeTAB
         DrawTAB(*tab, bgColor, frColor, vertical, localslant)
      EndIf
   Next
   
   If updateSize
      If ListSize(*this\tab\_s()) > 0
         *this\tab\TotalSize = position + localslant * 2 - *this\tab\spacing
      Else
         *this\tab\TotalSize = 0
      EndIf
      
      If *this\tab\vertical
         *this\Height = *this\tab\TotalSize + *this\tab\indent * 2
      Else
         *this\Width = *this\tab\TotalSize + *this\tab\indent * 2
      EndIf
   EndIf
   
   ; Слой 2: Летящая поверх
   If *activeTAB
      bgColor = *activeTAB\data
      DrawTAB(*activeTAB, bgColor, frColor, vertical, localslant)
      
      If vertical
         lineX = *activeTAB\x + *activeTAB\Width + BottomSpacing - 1
         lineY = *activeTAB\y + *activeTAB\Height
         Line(lineX, *this\y, 1, *activeTAB\y - *this\y, frColor) 
         Line(lineX, lineY, 1, (*this\y + *this\Height) - lineY, frColor)
      Else
         lineX = *activeTAB\x + *activeTAB\Width
         lineY = *activeTAB\y + *activeTAB\Height + BottomSpacing - 1
         Line(*this\x, lineY, *activeTAB\x - *this\x, 1, frColor) 
         Line(lineX, lineY, (*this\x + *this\Width) - lineX, 1, frColor) 
      EndIf
   EndIf
EndProcedure

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDraw(*this._s_WIDGET)
   Protected Gadget.i = *this\canvasid
   Protected gWidth.i = *this\Width ; DesktopScaledX(GadgetWidth(Gadget))
   Protected gHeight.i = *this\Height ; DesktopScaledY(GadgetHeight(Gadget))
   
   If StartDrawing(CanvasOutput(Gadget))
      If *this\fontid : DrawingFont(*this\fontid) :  EndIf
      
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
      Box(0, 0, OutputWidth(), OutputHeight(), $ffffffff) 
      Box(*this\x, *this\y, gWidth, gHeight, *this\bgcolor) 
      
      DrawTabs(*this, *this\tab\active)
      StopDrawing()
   EndIf
   
EndProcedure

;-
Procedure.i AddTabButton(*this._s_WIDGET, *tab._s_TAB, btnType.l = #__BTN_Close, round.a = 1)
   If *tab
      AddElement(*tab\btn())
      *tab\btn()\Type  = btnType
      *tab\btn()\round = round
      If *this : *this\mask | #__MASK_UpdateTotalSize | #__MASK_Redraw : EndIf
      ProcedureReturn @*tab\btn()
   EndIf
   ProcedureReturn #Null
EndProcedure

Procedure RemoveTabButton(*tab._s_TAB)
   ;    If *tab
   ;       *tab\btn\Width  = 0
   ;       *tab\btn\Height = 0
   ;    EndIf
EndProcedure

;-
Procedure CloseTab(*this._s_WIDGET, *tabtoclose._s_TAB)
   ; 1. Переводим список на удаляемую вкладку
   ChangeCurrentElement(*this\tab\_s(), *tabtoclose)
   
   ; 2. Уничтожаем привязанный containergadget
   If IsGadget(*tabtoclose\containerID)
      FreeGadget(*tabtoclose\containerID)
   EndIf
   
   ; 3. УДАЛЕНИЕ И АВТОМАТИЧЕСКИЙ ПОИСК ЗАМЕНЫ
   If *this\tab\active = *tabtoclose
      ; Флаг 1 заставляет PureBasic перешагнуть на следующую вкладку (или на предыдущую, если этой не стало)
      If DeleteElement(*this\tab\_s(), 1)
         *this\tab\active = @*this\tab\_s() ; Новая вкладка успешно подхвачена!
      Else
         *this\tab\active = 0 ; Вкладок больше вообще не осталось
      EndIf
   Else
      ; Если закрыли неактивную вкладку, просто удаляем её без смены активности
      DeleteElement(*this\tab\_s())
   EndIf
   
   ; 4. Если нашли новый активный таб — показываем его контейнер
   If *this\tab\active <> 0
      HideGadget(*this\tab\active\containerID, #False)
   EndIf
EndProcedure

Procedure AddTab(*this._s_WIDGET, ID.i, Text.s, size.i, Image.i = 0, align.q = #__MASK_Left, closeBtn.b = #True)
   Protected *tab._s_TAB = AddElement(*this\tab\_s())
   
   *tab\ID   = ID
   *tab\mask = align
   *tab\size = DesktopScaledX(size)
   
   If Text
      *tab\txt\text   = Text
      *tab\txt\change = 1
   EndIf
   If IsImage(Image)
      *tab\img\image  = Image 
      *tab\img\change = 1
   EndIf
   
   ; Добавляем кнопку закрытия (крестик), если closeBtn = #True
   If closeBtn
      AddElement(*tab\btn())
      *tab\btn()\Type  = #__BTN_Close
      *tab\btn()\round = 1
   EndIf
   
   If ListSize(*this\Tab\_s()) = 1
      *this\tab\active = *tab
      *this\tab\active\mask | #__MASK_active
   EndIf
   
   *tab\data = RGBA(Random(50)+200, Random(50)+200, Random(50)+200, 255)
   *this\mask | #__MASK_UpdateTotalSize
   ProcedureReturn *tab
EndProcedure


Procedure CreateTab( Canvas, X.l,Y.l,Width.l,Height.l )
   Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
   ; *this\change = 1
   *this\tab\vertical = 0
   *this\canvasid  = Canvas
   *this\X = DesktopScaledX(X)
   *this\y = DesktopScaledY(Y)
   *this\Width = DesktopScaledX(Width)
   *this\Height = DesktopScaledY(Height)
   
   *this\tab\padding = DesktopScaledX(5) 
   *this\tab\indent = DesktopScaledX(50) ; Отступ панели слева
   *this\tab\spacing = DesktopScaledX(2)
   *this\tab\slant = DesktopScaledX(20) : *this\tab\spacing = *this\tab\slant - DesktopScaledX(2)
   *this\fontid  = LoadFont(0, "tahoma", 12)
   *this\bgcolor = RGBA(180, 195, 215, 160)
   ProcedureReturn *this
EndProcedure

; Procedure Create( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l, Text.s, flags.l = 0, Image.i = 0)
;    With *this
;       \fontID = FontID(0)
;       \X = DesktopScaledX(X)
;       \Y = DesktopScaledY(Y)
;       \Width = DesktopScaledX(Width)
;       \Height = DesktopScaledY(Height)
;       \canvasID  = CanvasGadget(#PB_Any, X, Y, Width, Height)
;       \tab\TotalSize = DesktopScaledY(29)
;       \tab\slant = DesktopScaledX(20)
; 
;       \padding  = DesktopScaledX(6)
;       \change = 1
;       \bgcolor     = RGBA(180, 195, 215, 160) ; RGB(Random(255), Random(255), Random(255)) ; твой любимый цвет. сделай его зеленым или серым — и весь интерфейс сам перестроится!
;       \tab\plus\txt\text = "+"
;    EndWith
; EndProcedure


;-
Procedure.b IsPointInCloseBtn(*tab._s_TAB, mx.i, my.i)
   ;    If *tab = 0 Or *tab\btn\Width <= 0 : ProcedureReturn #False : EndIf
   ;    
   ;    Protected bx = *tab\x + *tab\btn\x
   ;    Protected by = *tab\y + *tab\btn\y
   ;    
   ;    If mx >= bx And mx < bx + *tab\btn\Width And my >= by And my < by + *tab\btn\Height
   ;       ProcedureReturn #True
   ;    EndIf
   ;    
   ;    ProcedureReturn #False
EndProcedure


Procedure.b IsPointInTab(*tab._s_TAB, mx.i, my.i, vertical.b, localslant.i)
   If *tab = 0 : ProcedureReturn #False : EndIf
   
   If my >= *tab\Y And my < *tab\Y + *tab\Height And mx >= *tab\X And mx < *tab\X + *tab\Width
      If localslant > 0
         Protected delta, currentSlant
         If vertical
            ; Для вертикальной вкладки скос идет по X (слева направо)
            delta = mx - *tab\X
            currentSlant = ((*tab\Width - 1 - delta) * localslant) / *tab\Width
            If my >= (*tab\Y + currentSlant) And my < (*tab\Y + *tab\Height - currentSlant)
               ProcedureReturn #True
            EndIf
         Else
            ; Для горизонтальной вкладки скос идет по Y (снизу вверх)
            delta = my - *tab\Y
            currentSlant = ((*tab\Height - 1 - delta) * localslant) / *tab\Height
            If mx >= (*tab\X + currentSlant) And mx < (*tab\X + *tab\Width - currentSlant)
               ProcedureReturn #True
            EndIf
         EndIf
      Else
         ; Если скос = 0 (обычный прямоугольник)
         ProcedureReturn #True
      EndIf
   EndIf
   
   ProcedureReturn #False
EndProcedure

Procedure.i GetTabAtPoint(*this._s_WIDGET, mx.i, my.i)
   Protected *tab._s_TAB
   Protected localslant = *this\tab\slant
   Protected vertical = *this\tab\vertical
   
   ; 1. Сначала проверяем активную вкладку (верхний слой)
   If IsPointInTab(*this\tab\active, mx, my, vertical, localslant)
      ProcedureReturn *this\tab\active
   EndIf
   
   ; 2. Иначе проверяем остальные с конца списка (от верхнего слоя к нижнему)
   If LastElement(*this\tab\_s())
      Repeat
         *tab = @*this\tab\_s()
         If *tab <> *this\tab\active And IsPointInTab(*tab, mx, my, vertical, localslant)
            ProcedureReturn *tab
         EndIf
      Until PreviousElement(*this\tab\_s()) = 0
   EndIf
   
   ProcedureReturn #Null
EndProcedure

Procedure DoEventBTN( *btn._s_BTN, event )
   Protected windowID = EventWindow()
   
   Select event
      Case #PB_EventType_MouseEnter
         
      Case #PB_EventType_MouseLeave
         
      Case #PB_EventType_LeftButtonDown
         
      Case  #PB_EventType_LeftDoubleClick
         
   EndSelect
EndProcedure

Procedure DoEventTAB(*this._s_WIDGET, *hoverTAB._s_TAB, event.i, mousePos.i)
   Static dragOffSet.i
   Protected stepSize.i
   Protected accumulatedSize.i = 0
   Protected isBeforeDragged.b = #True 
   Protected *current_tab._s_TAB, *tab._s_TAB
   
   Select event
      Case #PB_EventType_MouseMove
         *current_tab = PressedTAB()
         If *current_tab
            *current_tab\mask | #__MASK_drag
            stepSize = *current_tab\size + *this\tab\spacing
            
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               
               If *tab = *current_tab
                  *tab\offset = mousePos - dragOffSet
               Else
                  *tab\offset = *tab\pos - *current_tab\pos - *current_tab\offset
                  *tab\offset - stepSize
                  *tab\offset * stepSize / (*tab\size + *this\tab\spacing)
               EndIf
               
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
               
               ; Применяем координаты визуального отображения
               If *this\tab\vertical
                  *tab\y = *this\y + *this\tab\indent + *tab\pos + *tab\offset
               Else
                  *tab\x = *this\x + *this\tab\indent + *tab\pos + *tab\offset
               EndIf
            Next
            *this\mask | #__MASK_Redraw
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         *current_tab = *hoverTAB
         If *current_tab
            dragOffSet = mousePos
            PressedTAB() = *current_tab
            *current_tab\mask | #__MASK_press
            
            If *this\tab\active <> *current_tab
               If *this\tab\active
                  *this\tab\active\mask &~ #__MASK_active
               EndIf
               
               *this\tab\active = *current_tab
               *current_tab\mask | #__MASK_active
            EndIf
            
            stepSize = *current_tab\size + *this\tab\spacing
            
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               
               If *tab = *current_tab
                  isBeforeDragged = #False 
                  *tab\offset = 0
                  Continue ; Лимиты для dragged запишем сразу после цикла
               EndIf
               
               ; 1. Сдвигаем базовую позицию только для вкладок левее/выше нажатой
               If isBeforeDragged
                  *tab\pos + stepSize
               EndIf
               
               ; 2. Расчет лимитов хода
               *tab\minOffset = accumulatedSize - *tab\pos
               *tab\maxOffset = accumulatedSize - *tab\pos + stepSize
               accumulatedSize + *tab\size + *this\tab\spacing
               
               ; 3. Инициализация offset
               *tab\offset = *tab\pos - *current_tab\pos - stepSize
               *tab\offset * stepSize / (*tab\size + *this\tab\spacing)
               
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
            Next
            
            ; Лимиты для самой перетаскиваемой вкладки
            *current_tab\minOffset = -*current_tab\pos 
            *current_tab\maxOffset = -*current_tab\pos + accumulatedSize 
            
            *this\mask | #__MASK_Redraw
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         *current_tab = PressedTAB()
         If *current_tab
            *current_tab\mask &~ #__MASK_press
            *current_tab\mask &~ #__MASK_drag
            
            ; Считаем ТЕКУЩИЙ визуальный центр каждой вкладки (с учетом её сдвига offset!)
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               *tab\pos = *tab\pos + *tab\offset + (*tab\size >> 1)
               *tab\offset = 0
            Next
            
            ; Сортируем вкладки по их текущим визуальным центрам
            SortStructuredList(*this\tab\_s(), #PB_Sort_Ascending, OffsetOf(_s_tab\pos), TypeOf(_s_tab\pos))
            
            PressedTAB() = #Null
            
            ; Пересчитываем чистые координаты \pos, \x, \y по новому порядку
            *this\mask | #__MASK_UpdateTotalSize
            *this\mask | #__MASK_Redraw
         EndIf
         
   EndSelect
EndProcedure

Procedure DoEvent( *this._s_WIDGET, event, mx, my)
   Protected *btn._s_TAB; = *this\tab\bar
   Protected shouldHover.b, mousePos
   Protected._s_TAB *leaveTAB, *hoverTAB
   Protected._s_BTN *newHoverBTN
   Static._s_BTN *hoverBTN
   
   Select event
      Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave, #PB_EventType_LeftButtonUp
         
         ; Блокируем смену ховера только если вкладка реально тащится (выставлен флаг #__MASK_drag)
         If Not (PressedTAB() And (PressedTAB()\mask & #__MASK_drag))
            Protected._s_TAB *tab
            Protected localslant = *this\tab\slant
            If *this\tab\vertical
               mousePos = my - *this\tab\indent
            Else
               mousePos = mx - *this\tab\indent
            EndIf
            
            ; 1. Определяем ОДНУ верхнюю вкладку под курсором
            If event <> #PB_EventType_MouseLeave
               *hoverTAB = GetTabAtPoint(*this, mx, my)
               
               ; Если мы над вкладкой проверяем её кнопку закрытия
               If *hoverTAB 
                  If *hoverTAB
                     ForEach *hoverTAB\btn()
                        Protected bx = *hoverTAB\x + *hoverTAB\btn()\X
                        Protected by = *hoverTAB\y + *hoverTAB\btn()\Y
                        If mx >= bx And mx < bx + *hoverTAB\btn()\Width And my >= by And my < by + *hoverTAB\btn()\Height
                           *newHoverBTN = @*hoverTAB\btn()
                           Break
                        EndIf
                     Next
                  EndIf
               EndIf
            EndIf
            
            ; 2. Обновляем состояние КНОПКИ (крестика или плюса) через DoEventBTN
            If *hoverBTN <> *newHoverBTN
               If *hoverBTN
                  *hoverBTN\mask &~ #__MASK_Hover
                  DoEventBTN(*hoverBTN, #PB_EventType_MouseLeave)
               EndIf
               
               *hoverBTN = *newHoverBTN
               
               If *hoverBTN
                  *hoverBTN\mask | #__MASK_Hover
                  DoEventBTN(*hoverBTN, #PB_EventType_MouseEnter)
               EndIf
               
               *this\mask | #__MASK_Redraw
            EndIf
            
            ; 2. Если вкладка под курсором изменилась — обновляем состояния
            If EnteredTAB() <> *hoverTAB
               *leaveTAB = EnteredTAB() 
               EnteredTAB() = *hoverTAB
               
               If *leaveTAB
                  *leaveTAB\mask &~ #__MASK_Hover
                  DoEventTAB(*this, *leaveTAB, #PB_EventType_MouseLeave, mousePos)
               EndIf
               
               If *hoverTAB
                  *hoverTAB\mask | #__MASK_Hover
                  DoEventTAB(*this, *hoverTAB, #PB_EventType_MouseEnter, mousePos)
               EndIf
               
               *this\mask | #__MASK_Redraw
            EndIf
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If *hoverBTN
            DoEventBTN( *hoverBTN, event )
         EndIf
         
   EndSelect
   
   If Not *hoverBTN
      If *this\tab\vertical
         If DoEventTAB( *this, EnteredTAB( ), event, my)
            *this\mask | #__MASK_Redraw 
            ;ProcedureReturn #True
         EndIf
      Else
         If DoEventTAB( *this, EnteredTAB( ), event, mx)
            *this\mask | #__MASK_Redraw 
            ;ProcedureReturn #True
         EndIf
      EndIf
   EndIf
   
   If *this\mask & #__MASK_Redraw
      *this\mask &~ #__MASK_Redraw
      ReDraw(*this)
      ProcedureReturn #True
   EndIf
   
EndProcedure


; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

#Win = 0
#Canvas = 0

Procedure ResizeCanvas(*this._s_WIDGET)
   ReDraw(*this)
   Define w = DesktopUnscaledX(*this\Width)
   Define h = DesktopUnscaledY(*this\Height)
   ResizeWindow(#Win, #PB_Ignore, #PB_Ignore, w + 40, h + 40)
   ResizeGadget(#Canvas, #PB_Ignore, #PB_Ignore, w + 20, h + 20)
   HideWindow(#Win, 0, #PB_Window_ScreenCentered)
   ReDraw( *this)
EndProcedure

If OpenWindow(#Win, 0,0,0,0, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, 0, 0)
   Define *this._s_WIDGET = CreateTab(#Canvas, 10,10,240,40 )
   ; Наполняем вашим тестовым набором
   AddTab(*this, 0, "0 - 76", 76)
   AddTab(*this, 1, "1 - 176", 176, (1), #__MASK_Center)
   AddTab(*this, 2, "2 - 166", 166, (1), #__MASK_Right)
   AddTab(*this, 3, "3 - 106", 106, (1))
   ;
   ResizeCanvas(*this)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         If EventType() = #PB_EventType_RightClick
            HideWindow(#Win, 1)
            *this\tab\vertical ! 1
            Swap *this\Width, *this\Height
            ClearList(*this\Tab\_s())
            AddTab(*this, 0, "0 - 76", 76)
            AddTab(*this, 1, "1 - 176", 176, (1), #__MASK_Center)
            AddTab(*this, 2, "2 - 166", 166, (1), #__MASK_Right)
            AddTab(*this, 3, "3 - 106", 106, (1))
            ;
            ResizeCanvas( *this )
         EndIf
         
         If DoEvent( *this, EventType(),
                     GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX), 
                     GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
         EndIf
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 220
; FirstLine = 213
; Folding = -----v---------------------
; EnableXP
; DPIAware