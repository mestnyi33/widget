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
#__flag_Left   = 0
#__flag_Top  = 1
#__flag_Right  = 2
#__flag_Bottom  = 3
#__flag_Center = 4

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

Structure _s_TAB Extends _s_COORDINATE
    ID.l             ; Номер элемента в списке данных строки (0, 1, 2...) 
   pos.l
   size.l
   
   ; Поля для идеальной математики плавного сдвига
   offset.l           ; Динамический визуальный сдвиг
   minOffset.l     ; Левый ограничитель хода
   maxOffset.l     ; Правый ограничитель хода
   
   align.a             ; Выравнивание
   ; mask.q           ; Маска конкретной вкладки
   
   txt._s_TXT       ; Имя поля заголовка
   img._s_IMG
   
   StructureUnion
      *data 
      ContainerID.i  ; id контейнера, привязанного к этой вкладке
   EndStructureUnion
EndStructure

Structure _s_TABS
   *active._s_TAB   
   *press._s_TAB  ; Указатель на перетаскиваемую вкладку
    plus._s_TAB ; <--- Одиночная структура кнопки ПЛЮС

    slant.a
    align.a               
   indent.a 
   spacing.a             
   
   vertical.b
   TotalSize.l          
   List _s._s_TAB()  ; Заголовки вкладок
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   change.b
   ;    padding.a
   ;    spacing.a             
   Tab._s_TABS
   dragOffSet.i     ; Точка захвата мыши
   
   canvasid     .i  
   fontid       .i  
   bgcolor      .l ; <--- добавь это поле для управления общим фоном холста
   
EndStructure

Global bottomSpacing.i = DesktopScaledX(3) 


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
   If alignFlags & #__flag_Center
      ProcedureReturn (contentSize - objectSize) / 2
   ElseIf alignFlags & #__flag_Right
      ProcedureReturn contentSize - objectSize - Offset
   Else ; #__flag_Left
      ProcedureReturn Offset
   EndIf
EndProcedure

Procedure ChromeBox(vertical.b, x, y, w, h, isactive, currentcolor.l, localslant.a, GradientDepth = 65, outerbordercolor.l = -1, innerhighlightcolor.l = -1)
  Protected dy, dh = h - 1, dw = w - 1
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

Procedure UpdateContentPos(*tab._s_TAB, indent.a, Spacing.a, vertical.b)
   Protected contentX.l, contentY.l
   Protected._s_TXT *txt = *tab\txt
   Protected._s_IMG *img = *tab\img
   If Not (*img\width And *txt\width) : Spacing  = 0 : EndIf
   
   ; 3. ЕДИНОВРЕМЕННОЕ ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ (Работаем напрямую со структурой)
   If vertical
      *txt\x = (*tab\width - *txt\width) >> 1
      *img\x = (*tab\width - *img\width) >> 1
      
      contentY = MakeAlignPosition(*tab\align, *tab\Height, *img\height + *txt\height + Spacing, indent)
      *txt\y = contentY
      *img\y = contentY
      
      If Not (*tab\align & #__flag_Bottom)
         If *img\height > 0 : *txt\y + *img\height + Spacing : EndIf
      Else
         If *txt\height > 0 : *img\y + *txt\height + Spacing : EndIf
      EndIf
   Else
      *txt\y = (*tab\height - *txt\height) >> 1
      *img\y = (*tab\height - *img\height) >> 1
      
      contentX = MakeAlignPosition(*tab\align, *tab\Width, *img\width + *txt\width + Spacing, indent)
      *txt\x = contentX
      *img\x = contentX
      
      If Not (*tab\align & #__flag_Right)
         If *img\width > 0 : *txt\x + *img\width + Spacing : EndIf
      Else
         If *txt\width > 0 : *img\x + *txt\width + Spacing : EndIf
      EndIf
   EndIf
EndProcedure

Procedure UpdateTab(*this._s_WIDGET, *tab._s_TAB, position.l, change.b=0)
   Protected contentX.l, contentY.l
   Protected gWidth.l =*this\Width
   Protected gHeight.l = *this\Height
   Protected indent.a = *this\tab\slant
   Protected vertical.b = *this\tab\vertical
   
   Protected._s_TXT *txt = *tab\txt
   Protected._s_IMG *img = *tab\img
   
   If *txt\change Or *img\change Or change
      *tab\pos = position 
      
      ; 1. Замеры метрик (Пишем сразу в структуру только при изменениях)
      UpdateContentSize(*tab)
      
     ; 2. Расчет отступа и размеров таба напрямую через структуру
      If *img\width And *txt\width
         Protected Spacing.i  = DesktopScaledX(6)
      EndIf
      
      Protected tab_size = Spacing + indent * 2
      If vertical 
         tab_size + *img\height + *txt\height 
      Else 
         tab_size + *img\width + *txt\width 
      EndIf
      
      ; Твоя проверенная защита фиксированного размера
      If *tab\size < tab_size : *tab\size = tab_size : EndIf
      
      ; Общие размеры самой вкладки
      If vertical
         *tab\y = *this\y + *this\tab\indent + position
         *tab\width = gWidth - BottomSpacing
         *tab\height = *tab\size
      Else
         *tab\x = *this\x + *this\tab\indent + position
         *tab\width = *tab\size
         *tab\height = gHeight - BottomSpacing
      EndIf 
      
       ; 3. ЕДИНОВРЕМЕННОЕ ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ (Работаем напрямую со структурой)
      UpdateContentPos(*tab, indent, Spacing, vertical)
   EndIf
   
   ProcedureReturn (*tab\size - *this\tab\slant) + *this\tab\spacing
EndProcedure


; Функция линейного расчета базовых координат X
Procedure TotalSize(*this._s_WIDGET)
   Protected position.i
   Protected *tab._s_TAB
   
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      *tab\pos = position 
      
      If *this\tab\vertical
         *tab\x = *this\x
         *tab\y =  *this\y + *this\tab\indent  + *tab\pos
      Else
         *tab\y = *this\y
         *tab\x =  *this\x + *this\tab\indent  + *tab\pos
      EndIf
      
      position + (*tab\size - *this\tab\slant) + *this\tab\spacing
   Next
   
   ; Чистый размер блока вкладок с учетом финального скоса
   *this\tab\TotalSize = position + *this\tab\slant - *this\tab\spacing
   If *this\tab\vertical
      *this\Height =  *this\tab\TotalSize +  *this\tab\indent * 2
   Else
      *this\Width =  *this\tab\TotalSize +  *this\tab\indent * 2
   EndIf
EndProcedure

Procedure DrawTab(*tab._s_TAB, slant, bgColor.l=$FF808080, vertical.b=0, isActive.b=0)
   Protected txColor 
   
    If isActive ; *tab\mask & #__MASK_active
      txColor = $FF000000
      ChromeBox(vertical, *tab\x, *tab\y, *tab\width, *tab\Height+bottomSpacing, 1, bgColor, slant)
   Else
      txColor = $FFFFFFFF
      ChromeBox(vertical, *tab\x, *tab\y, *tab\width, *tab\Height, 0, bgColor, slant)
   EndIf
   
   ; 2. ОТРИСОВКА ИКОНКИ
   If *tab\img\Width Or *tab\img\Height
      DrawAlphaImage(ImageID(*tab\img\Image), *tab\x + *tab\img\x, *tab\y + *tab\img\y)
   EndIf
   
   ; 3. ОТРИСОВКА ТЕКСТА
   If *tab\txt\Width Or *tab\txt\Height
       DrawText(*tab\x + *tab\txt\x, *tab\y + *tab\txt\y, *tab\txt\Text, txColor,  bgColor)
   EndIf
EndProcedure


Procedure DrawTabs(*this._s_WIDGET, *current_tab._s_TAB)
   Protected position.i, change
   Protected *tab._s_TAB
   Protected vertical.b = *this\tab\vertical
   Protected bgColor.l = *this\bgcolor
   ; линия пола
   Protected floorcolor =  MakeColor( bgColor, -30)
   
   ;LineXY(*this\x, *this\y+*this\Height - 1, *this\x+*this\Width, *this\y+*this\Height - 1, $ff000000);floorcolor)
    If *this\change 
       change = *this\change
       *this\change = 0
    EndIf
    
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      ;
     position + UpdateTab(*this, *tab, position, change)
      
      ; Слой 1: Статичные
      If *tab <> *current_tab
         DrawTab(*tab, *this\tab\slant, bgColor, vertical, 0)
      EndIf
   Next
   
   ; Слой 2: Летящая поверх
   If *current_tab
      DrawTab(*current_tab, *this\tab\slant, *current_tab\data, vertical, 1)
      Protected lineX, lineY
      floorcolor = $ff000000
      If vertical
         ; ВЕРТИКАЛЬНЫЙ РЕЖИМ: Линия пола строится по оси Y справа от вкладки, обходя её
         lineX = *current_tab\x + *current_tab\Width+BottomSpacing - 1
         lineY = *current_tab\y + *current_tab\Height
         ; Верхний отрезок пола (от начала виджета до начала активного таба)
         Line(lineX, *this\y, 1, *current_tab\y - *this\y, floorcolor) 
         ; Нижний отрезок пола (от конца активного таба до конца виджета)
         Line(lineX, lineY, 1, (*this\y + *this\Height) - lineY, floorcolor)
      Else
         ; ГОРИЗОНТАЛЬНЫЙ РЕЖИМ: Твоя оригинальная попиксельная логика
         lineX = *current_tab\x+*current_tab\Width
         lineY = *current_tab\y + *current_tab\Height+BottomSpacing - 1
         Line(*this\x, lineY, *current_tab\x-*this\x, 1, floorcolor) 
         Line(lineX, lineY, (*this\x+*this\Width)-lineX, 1, floorcolor) 
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
Procedure DoTabEvents(*this._s_WIDGET, event.i, mousePos.i)
   Protected *current_tab._s_TAB
   Protected *tab._s_TAB
   Protected stepSize.i
   Protected slant = *this\tab\slant
   Protected accumulatedSize.i = 0
   Protected isBeforeDragged.b = #True 
   mousePos - *this\tab\indent 
   
   Select event
      Case #PB_EventType_LeftButtonDown
         
         *this\dragOffSet = mousePos
         
         ; ЦИКЛ 1: Находим вкладку, на которую кликнули (с учетом наложения скосов)
         ForEach *this\tab\_s()
            *tab = @*this\tab\_s()
            If mousePos >= *tab\pos And mousePos < *tab\pos + *tab\size
               *current_tab = *tab
               Break
            EndIf
         Next
         
         *this\tab\active = *current_tab
         *this\tab\press = *current_tab
         
         ; ЦИКЛ 2: Выполняем раздвижку, лимиты и расчет стартового offset за один проход
         If *current_tab
            ; Шаг сдвига уменьшен на величину наложения скоса (slant)
            stepSize = (*current_tab\size - slant) + *this\tab\spacing
            
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               
               If *tab = *current_tab
                  isBeforeDragged = #False 
                  *tab\offset = mousePos - *this\dragOffSet
                  Continue ; Лимиты для dragged запишем сразу после цикла
               EndIf
               
               ; 1. Сдвигаем базовый X только для вкладок левее нажатой
               If isBeforeDragged
                  *tab\pos + stepSize
               EndIf
               
               ; 2. Расчет лимитов хода (использует уже обновленный *tab\pos)
               *tab\minOffset = accumulatedSize - *tab\pos
               *tab\maxOffset = accumulatedSize - *tab\pos + stepSize
               accumulatedSize + (*tab\size - slant) + *this\tab\spacing
               
               ; 3. Пропорция инициализации offset (модифицирована под размер с учетом наложения)
               *tab\offset = *tab\pos - *current_tab\pos - *current_tab\offset
               *tab\offset - stepSize
               *tab\offset * stepSize / ((*tab\size - slant) + *this\tab\spacing)
               
               ; Ограничители хода
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
            Next
            
            ; Финальная запись лимитов и проверка границ для самой перетаскиваемой вкладки
            *current_tab\minOffset = -*current_tab\pos 
            *current_tab\maxOffset = -*current_tab\pos + accumulatedSize 
            
            If *current_tab\offset < *current_tab\minOffset : *current_tab\offset = *current_tab\minOffset : EndIf
            If *current_tab\offset > *current_tab\maxOffset : *current_tab\offset = *current_tab\maxOffset : EndIf
            
            ProcedureReturn #True
         EndIf
         
      Case #PB_EventType_MouseMove
         *current_tab = *this\tab\press
         If *current_tab
            stepSize = (*current_tab\size - slant) + *this\tab\spacing
            ;
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               
               If *tab = *current_tab
                  *tab\offset = mousePos - *this\dragOffSet
               Else
                  *tab\offset = *tab\pos - *current_tab\pos - *current_tab\offset
                  *tab\offset - stepSize
                  *tab\offset * stepSize / ((*tab\size - slant) + *this\tab\spacing)
               EndIf
               
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
               
               ; Применяем координаты визуального отображения
               If *this\tab\vertical
                  *tab\y =  *this\y + *this\tab\indent  + *tab\pos + *tab\offset
               Else
                  *tab\x =  *this\x + *this\tab\indent  + *tab\pos + *tab\offset
               EndIf
            Next
            ProcedureReturn #True
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         *current_tab = *this\tab\press
         If *current_tab
            ; Переносим визуальный сдвиг в постоянную координату X и обнуляем offset
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               *tab\pos + *tab\offset
               *tab\offset = 0
            Next
            
            ; Сортируем список вкладок в памяти по их новым физическим координатам X
            SortStructuredList(*this\tab\_s(), #PB_Sort_Ascending, OffsetOf(_s_tab\pos), TypeOf(_s_tab\pos))
            
            ; Сбрасываем указатель перетаскивания
            *this\tab\press = #Null
            
            ; Вызываем внутренние процедуры обновления состояния и перерисовки
            TotalSize(*this)
            ProcedureReturn #True
         EndIf
         
   EndSelect
EndProcedure

Procedure AddTab(*this._s_WIDGET, ID.i, Text.s, size.i, Image.i = 0, align.a = #__flag_Left)
   Protected *tab._s_TAB = AddElement(*this\tab\_s())
   
   *tab\ID        = ID
   *tab\align     = align
   *tab\size      = DesktopScaledY(size)
   If Text
      *tab\txt\text  = Text
      *tab\txt\change = 1
   EndIf
   If IsImage(Image)
      *tab\img\image = Image 
      *tab\img\change = 1
   EndIf
   
   If ListSize(*this\Tab\_s()) = 1
      *this\tab\active = *tab
   EndIf
   
   *tab\data =RGBA(Random(50)+200, Random(50)+200, Random(50)+200, 255)
   ProcedureReturn *tab
EndProcedure

Procedure CreateTab( Canvas, x.l,y.l,width.l,height.l )
   Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
   *this\tab\vertical = 0
   *this\canvasid  = Canvas
   *this\X = DesktopScaledX(x)
   *this\y = DesktopScaledY(y)
   *this\Width = DesktopScaledX(width)
   *this\Height = DesktopScaledY(height)
   
   *this\tab\slant = DesktopScaledX(20)
   *this\tab\indent = DesktopScaledX(50) ; Отступ панели слева
   *this\tab\spacing = DesktopScaledX(2) ; Расстояние между вкладками
   *this\fontid  = LoadFont(0, "tahoma", 12)
   *this\bgcolor = RGBA(180, 195, 215, 160)
   ProcedureReturn *this
EndProcedure

; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

#Win = 0
#Canvas = 0

Procedure Resize_(*this._s_WIDGET)
   *this\change = 1
   *this\Width = 240
   *this\Height = 40
   TotalSize(*this)
   Define w = *this\Width
   Define h = *this\Height
   ResizeWindow(#Win, #PB_Ignore, #PB_Ignore, w + 40, h + 40)
   ResizeGadget(#Canvas, #PB_Ignore, #PB_Ignore, w + 20, h + 20)
   HideWindow(#Win, 0, #PB_Window_ScreenCentered)
   ReDraw( *this)
EndProcedure

If OpenWindow(#Win, 0,0,0,0, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, 0, 0)
   
   Define *this._s_WIDGET = CreateTab(#Canvas, 10,10,240,40 )
   ; Наполняем вашим тестовым набором
   AddTab(*this, 0, "0 - 60", 0)
   AddTab(*this, 1, "1 - 160", 160, (1), #__flag_Center)
   AddTab(*this, 2, "2 - 150", 150, (1), #__flag_Right)
   AddTab(*this, 3, "3 - 90", 90, (1))
   ;
   ReDraw(*this)
   Resize_(*this)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         If EventType() = #PB_EventType_RightClick
            HideWindow(#Win, 1)
            *this\tab\vertical ! 1
            ClearList(*this\Tab\_s())
            AddTab(*this, 0, "0 - 60", 60)
            AddTab(*this, 1, "1 - 160", 160, (1), #__flag_Center)
            AddTab(*this, 2, "2 - 150", 150, (1), #__flag_Right)
            AddTab(*this, 3, "3 - 90", 90, (1))
            ;
            ReDraw(*this)
            Resize_( *this )
         EndIf
         
         If *this\tab\vertical
            If DoTabEvents( *this, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
               ReDraw(*this)
            EndIf
         Else
            If DoTabEvents( *this, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX))
               ReDraw( *this)
            EndIf
         EndIf
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 321
; FirstLine = 311
; Folding = P----------------
; EnableXP
; EnableOnError
; EnableUnicode