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
   padding.b
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
   
   multirow.b
   vertical.b
   size.l 
   
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

Declare ResizeCanvas(*this._s_WIDGET)
Global bottomSpacing.i = 2
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

Procedure UpdateContentPos(*tab._s_TAB, contentLimit, vertical=0, Spacing=0, Padding=0)
   Protected contentX, contentY
   Protected._s_TXT *txt   = *tab\txt
   Protected._s_IMG *img   = *tab\img
   
   ; 6. Позиционирование текста и иконки
   If vertical
      *txt\x = (*tab\width - *txt\width) >> 1
      *img\x = (*tab\width - *img\width) >> 1
      
      contentY = MakeAlignPosition(*tab\mask, contentLimit, *img\height + *txt\height + Spacing, Padding)
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
      
      contentX = MakeAlignPosition(*tab\mask, contentLimit, *img\width + *txt\width + Spacing, Padding)
      *txt\x = contentX
      *img\x = contentX
      
      If Not (*tab\mask & #__MASK_Right)
         If *img\width > 0 : *txt\x + *img\width + Spacing : EndIf
      Else
         If *txt\width > 0 : *img\x + *txt\width + Spacing : EndIf
      EndIf
   EndIf
EndProcedure

Procedure UpdateTabPos(*this._s_WIDGET, *tab._s_TAB, position, row.i = 0)
   Protected Spacing.i, tab_size.i, contentX.l, contentY.l
   Protected gWidth.l      = *this\Width
   Protected gHeight.l     = *this\tab\size ; Height
   Protected indent.i      = *this\tab\indent
   Protected localslant    = *this\tab\slant
   Protected vertical.b    = *this\tab\vertical
   Protected padding.i     = *this\tab\padding
   Protected._s_TXT *txt   = *tab\txt
   Protected._s_IMG *img   = *tab\img
   Protected._s_BTN *btn
   
   ; 1. Отступ между иконкой и текстом
   If *img\width And *txt\width
      If vertical
         Spacing = DesktopScaledY(6)
      Else
         Spacing = DesktopScaledX(6)
      EndIf
   Else
      Spacing = 0
   EndIf
   
   ; 2. Считаем место, которое займут кнопки вкладки
   Protected btnCount.i     = ListSize(*tab\btn())
   Protected btnTotalSize.i = 0
   
   If btnCount > 0
      ForEach *tab\btn()
         If vertical
            btnTotalSize + *tab\btn()\Height
         Else
            btnTotalSize + *tab\btn()\Width
         EndIf
      Next
      
      ; Отступы между кнопками + отступ от текста (если нет скоса slant)
      btnTotalSize + (padding * (btnCount - 1))
      If localslant = 0
         btnTotalSize + padding
      EndIf
   EndIf
   
   *tab\pos = position
   
   ; 3. Расчет минимального размера вкладки
   tab_size = Spacing + btnTotalSize + (padding * 2) 
   If vertical
      tab_size + *img\height + *txt\height
   Else
      tab_size + *img\width + *txt\width
   EndIf
   
   If *tab\size < tab_size 
      *tab\size = tab_size 
   EndIf
   
   ; 4. Позиционирование самой вкладки
   If vertical
      *tab\x      = *this\x + row * gWidth
      *tab\y      = *this\y + indent + position
      *tab\width  = gWidth - BottomSpacing
      *tab\height = *tab\size + (localslant * 2)
   Else
      *tab\y      = *this\y + row * gHeight
      *tab\x      = *this\x + indent + position
      *tab\width  = *tab\size + (localslant * 2)
      *tab\height = gHeight - BottomSpacing
   EndIf
   
   ; 5. Позиционирование кнопок и расчет доступной области (contentLimit)
   Protected innerIndent.i  = localslant + padding
   Protected innerBtnSpace.i = Bool(localslant <> 0) * padding
   Protected mainSize.l, crossSize.l, contentLimit.l
   
   If vertical
      mainSize  = *tab\height
      crossSize = *tab\width
   Else
      mainSize  = *tab\width
      crossSize = *tab\height
   EndIf
   
   If btnCount
      Protected btnPos.l = mainSize - innerIndent + innerBtnSpace
      Protected isFirst.b = #True
      
      ForEach *tab\btn()
         *btn = @*tab\btn()
         
         If Not isFirst
            btnPos - padding ; Зазор между соседними кнопками
         EndIf
         isFirst = #False
         
         If vertical
            btnPos - *btn\Height
            *btn\X = (crossSize - *btn\Width) >> 1
            *btn\Y = btnPos
         Else
            btnPos - *btn\Width
            *btn\Y = (crossSize - *btn\Height) >> 1
            *btn\X = btnPos
         EndIf
      Next
      
      contentLimit = btnPos + localslant
   Else
      contentLimit = mainSize
   EndIf
   
   ; 6. Позиционирование текста и иконки
   UpdateContentPos(*tab, contentLimit, vertical, Spacing, innerIndent )
EndProcedure

Procedure.i UpdateTotalSize(*this._s_WIDGET, gWidth, widgetChanged)
   ; --- ОБЪЯВЛЕНИЕ ПЕРЕМЕННЫХ И ПАРАМЕТРОВ ИЗ СТРУКТУРЫ ВИДЖЕТА ---
   Protected *tab._s_TAB                         ; Указатель на текущую обрабатываемую вкладку
   Protected indent = *this\tab\indent             ; Внешний отступ полосы вкладок от левого и правого краев виджета
   Protected spacing = *this\tab\spacing           ; Зазор между центральными частями соседних вкладок (как в однорядном режиме)
   Protected localslant = *this\tab\slant          ; Ширина одного скоса (трапеции) вкладки
   Protected TopSpacing = indent;DesktopScaledX(6)      ; Отступ сверху над самым верхним рядом вкладок
   Protected RowSpacing = DesktopScaledX(1)      ; Вертикальный зазор между рядами вкладок
   Protected currentx = 0                        ; Текущая накопленная координата X при заполнении ряда
   Protected currentrow = 0                      ; Индекс текущего формируемого ряда (0 — нижний ряд до инверсии)
   Protected maxheight = 0                       ; Итоговая вычисленная высота области вкладок
   Protected i.i, k.i, startIDx.i, endIDx.i      ; Счетчики циклов и индексы первой/последней вкладки в текущем ряду
   Protected totalrowWidth.i                     ; Полная фактическая ширина сформированного ряда (с учетом внешних скосов)
   Protected extraspace.i                        ; Свободные пиксели справа до границы maxWidth (для выравнивания Justify)
   Protected addpixels.i                         ; Целая часть прибавки ширины на каждую вкладку в ряду
   Protected remainder.i                         ; Остаток от деления свободных пикселей (раздается по 1px первым вкладкам)
   Protected tabcount = ListSize(*this\tab\_s()) ; Общее количество вкладок в списке
   bottomSpacing = RowSpacing
   
   ; Шаг сетки по вертикали: высота одной вкладки + зазор между рядами
   Protected RowStep = (*this\tab\size - bottomSpacing) + RowSpacing

   ; --- РАСЧЕТ ДОСТУПНОЙ ШИРИНЫ ДЛЯ ВКЛАДОК ---
   Protected plusGap = -*this\tab\plus\Width/2 ;  DesktopScaledX(4)         ; Минимальный зазор между крайней вкладкой и кнопкой "+"
   ; Правая граница для вкладок: ширина виджета минус правый отступ, ширина кнопки "+" и зазор до нее
   Protected maxWidth = gWidth - indent - *this\tab\plus\Width - plusGap
   
   ; --- ОБРАБОТКА ПУСТОГО СПИСКА ВКЛАДОК ---
   If tabcount = 0 
      ; Ставим кнопку "+" в начальную позицию с учетом смещения самого виджета (*this\x, *this\y)
      *this\tab\plus\x = *this\x + indent
      *this\tab\plus\y = *this\y + TopSpacing
      *this\Width = gWidth
      *this\Height = *this\tab\size + TopSpacing
      ; Возвращаем высоту в логических (немасштабированных) пикселях для ResizeGadget
      ProcedureReturn DesktopUnscaledY(*this\Height)
   EndIf
   
   ; Временный массив указателей на вкладки для удобного разбиения на ряды и выравнивания
   Dim *rowtabs._s_TAB(tabcount - 1)
   i = 0
   
   ; =========================================================================
   ; ЭТАП 1: Замер контента и расчет минимальной (базовой) ширины вкладок
   ; =========================================================================
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      Protected._s_TXT *txt = *tab\txt
      Protected._s_IMG *img = *tab\img
      
      ; Если изменился шрифт или масштаб виджета, принудительно помечаем контент на перерасчет
      If widgetChanged
         *txt\change = #True
         *img\change = #True
      EndIf
      
      ; Замеряем текст и иконку (вызывается внутри активного блока StartDrawing/StopDrawing)
      If *txt\change Or *img\change
         UpdateContentSize(*tab)
      EndIf
      
      ; Сбрасываем size в 0, чтобы вкладка могла сжаться при уменьшении текста или удалении кнопки
      *tab\size = 0
      ; Вычисляем минимальный размер *tab\size (без скосов) и габаритную ширину *tab\Width (со скосами)
      UpdateTabPos(*this, *tab, 0)
      
      *rowtabs(i) = *tab
      i + 1
   Next
   
   startIDx = 0       ; Индекс первой вкладки текущего ряда
   currentx = indent  ; Начинаем заполнение ряда с левого внешнего отступа
   
   ; =========================================================================
   ; ЭТАП 2: Раскладка по рядам (шаг = size + spacing, как в однорядном коде)
   ; =========================================================================
   ; Идем до tabcount включительно: виртуальная итерация i = tabcount закрывает последний ряд
   For i = 0 To tabcount
      ; Полная габаритная ширина проверяемой вкладки (включая оба скоса: size + localslant * 2)
      Protected tabFullWidth = 0
      If i < tabcount
         tabFullWidth = *rowtabs(i)\Width
      EndIf
      
      ; Закрываем ряд, если дошли до конца списка ИЛИ текущая вкладка (вместе со скосами) не влезает в maxWidth
      ; Проверка (i > startIDx) гарантирует, что хотя бы одна вкладка попадет в ряд, даже если окно очень узкое
      If (i = tabcount) Or (currentx + tabFullWidth > maxWidth And i > startIDx)
         endIDx = i - 1 ; Индекс последней вкладки, вошедшей в этот ряд
         
         ; Растягиваем по ширине (Justify) ТОЛЬКО полные ряды (i < tabcount). Последний "хвост" не растягиваем
         If i < tabcount
            ; Считаем фактическую ширину ряда по формуле однорядного режима:
            ; отступ + оба внешних скоса ряда (localslant * 2) + сумма центральных частей (size) и зазоров (spacing)
            totalrowWidth = indent + (localslant * 2)
            For k = startIDx To endIDx
               totalrowWidth + *rowtabs(k)\size
               If k < endIDx : totalrowWidth + spacing : EndIf
            Next
            
            ; Вычисляем свободное место до границы maxWidth и делим его поровну между вкладками ряда
            extraspace = maxWidth - totalrowWidth
            Protected tabsinrow = (endIDx - startIDx) + 1
            
            If extraspace > 0 And tabsinrow > 0
               addpixels = extraspace / tabsinrow ; Базовая прибавка каждой вкладке
               remainder = extraspace % tabsinrow ; Остаток пикселей (распределяется по 1px первым вкладкам)
               
               For k = startIDx To endIDx
                  ; Увеличиваем именно внутренний size, чтобы сохранить корректную геометрию скосов
                  *rowtabs(k)\size + addpixels
                  If remainder > 0
                     *rowtabs(k)\size + 1
                     remainder - 1
                  EndIf
                  
                  ; Повторно вызываем UpdateTabPos, чтобы кнопки закрытия и текст внутри вкладки
                  ; выровнялись по новой растянутой ширине
                  UpdateTabPos(*this, *rowtabs(k), 0)
               Next
            EndIf
         EndIf
         
         ; Записываем финальные горизонтальные координаты для всех вкладок закрытого ряда
         Protected localPos = 0 ; Локальная позиция от начала ряда (для совместимости с DoEventTAB)
         For k = startIDx To endIDx
            *rowtabs(k)\pos = localPos                  ; Чистый локальный сдвиг (без *this\x и indent)
            *rowtabs(k)\x = *this\x + indent + localPos ; Абсолютная координата X на экране для отрисовки
            *rowtabs(k)\ID = currentrow                 ; Номер ряда, в который попала вкладка
            ; Сдвигаем позицию на центральную часть + зазор (скосы соседних вкладок идут внахлест)
            localPos + *rowtabs(k)\size + spacing
         Next
         
         ; Сбрасываем счетчики для формирования следующего ряда
         currentrow + 1
         currentx = indent
         startIDx = i
      EndIf
      
      ; Накапливаем шаг текущей вкладки для проверки следующей итерации
      If i < tabcount
         currentx + *rowtabs(i)\size + spacing
      EndIf
   Next
   
   ; Индекс самого последнего (нижнего после инверсии) ряда
   Protected TotalRows = currentrow - 1
   
   ; =========================================================================
   ; ЭТАП 3: Инверсия рядов по вертикали и позиционирование кнопки "Плюс"
   ; =========================================================================
   Protected lastTabRight = 0
   For k = 0 To tabcount - 1
      ; Инвертируем ряды: ряд 0 уходит наверх, а последний ряд с "хвостом" (TotalRows) оказывается внизу
      Protected InvertedRow = TotalRows - *rowtabs(k)\ID
      *rowtabs(k)\y = *this\y + TopSpacing + InvertedRow * RowStep
      
      ; Запоминаем правый край самой последней вкладки в нижнем ряду
      If *rowtabs(k)\ID = TotalRows
         lastTabRight = *rowtabs(k)\x + *rowtabs(k)\Width
      EndIf
   Next
   
;    ; Координата X кнопки "+" (всегда прижата к правому краю виджета с отступом indent)
   Protected plusX = *this\x + gWidth - *this\tab\plus\Width - indent
   
   ; Страховка: если единственная очень широкая вкладка в нижнем ряду всё же дотянулась до кнопки "+",
   ; переносим кнопку "+" на дополнительную строку ниже
   If lastTabRight + plusGap > plusX
      TotalRows + 1
   EndIf
   
   ; Записываем итоговые координаты кнопки "+"
   *this\tab\plus\x = plusX
   *this\tab\plus\y = *this\y + TopSpacing + TotalRows * RowStep
   
   ; Вычисляем итоговую высоту виджета (локально, без *this\y; последний RowSpacing вычитается)
   maxheight = TopSpacing + (TotalRows + 1) * RowStep - RowSpacing
   
   *this\Width = gWidth
   *this\Height = maxheight
   
   ; Возвращаем итоговую высоту в DPI-независимых единицах
   ProcedureReturn DesktopUnscaledY(*this\Height)
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
   Protected TotalSize.i
   Protected lineX, lineY
   frColor = $ff000000
   ;bgColor = $FF808080
   
   ; 1. Сохраняем факт глобального изменения виджета до сброса флага
   If *this\change 
      widgetChanged = #True
      updateSize = #True
      *this\change = 0
   EndIf
   
   ; 2. Если стоит маска пересчета — сдвигаем все вкладки и обновляем общий размер
   If *this\mask & #__MASK_UpdateTotalSize
      *this\mask &~ #__MASK_UpdateTotalSize
      updateSize = #True
   EndIf
   
   If updateSize
      If *this\tab\multirow
         UpdateTotalSize(*this, gWidth, widgetChanged)
      Else
         ForEach *this\tab\_s()
            *tab = @*this\tab\_s()
            Protected._s_TXT *txt = *tab\txt
            Protected._s_IMG *img = *tab\img
            
            ; Проверяем, нужно ли заново замерить текст/картинку конкретно этой вкладки
            If *txt\change Or *img\change Or widgetChanged
               UpdateContentSize(*tab)
               *txt\change = 0
               *img\change = 0
               updateSize = #True
            EndIf
            
            ; Пересчитываем геометрию и позицию вкладки
            If updateSize
               UpdateTabPos(*this, *tab, position)
            EndIf
            
            ; Сдвигаем позицию на полную ширину/высоту вкладки (включая оба скоса) + spacing
            position + *tab\size + *this\tab\spacing
         Next
         
         If updateSize
            If ListSize(*this\tab\_s()) > 0
               TotalSize = position + localslant * 2 - *this\tab\spacing
            Else
               TotalSize = 0
            EndIf
            
            If *this\tab\vertical
               *this\Height = TotalSize + *this\tab\indent * 2
            Else
               *this\Width = TotalSize + *this\tab\indent * 2
            EndIf
         EndIf
      EndIf
   EndIf
   
   ; 2. Отрисовка кнопки ПЛЮС (вызываем её личную изолированную процедуру)
   If *this\tab\plus
      If *this\tab\plus\txt\change Or *this\tab\plus\img\change
         UpdateContentSize(*this\tab\plus)
         *this\tab\plus\txt\change = 0
         *this\tab\plus\img\change = 0
         If vertical
            UpdateContentPos(*this\tab\plus, *this\tab\plus\Height, 1)
         Else
            UpdateContentPos(*this\tab\plus, *this\tab\plus\Width, 0)
         EndIf
      EndIf
      DrawTAB(*this\tab\plus, bgColor, frColor, vertical, 8);, *this\tab\plus\ID )      
   EndIf
         
   
   ; Слой 1: Статичные
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      If *tab <> *activeTAB
         DrawTAB(*tab, bgColor, frColor, vertical, localslant)
      EndIf
   Next
   
   ; Слой 2: Летящая поверх
   If *activeTAB
      If IsGadget(*activeTAB\containerID)
         bgColor = GetGadgetColor(*activeTAB\containerID, #PB_Gadget_BackColor)
      Else
         bgColor = *activeTAB\data
      EndIf
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
Procedure.i AddTabBTN(*tab._s_TAB, btnType.l = #__BTN_Close, round.a = 1)
   Protected *btn._s_BTN
   If *tab
      *btn = AddElement(*tab\btn())
      If *btn
         *btn\Type   = btnType
         *btn\round  = round
         *btn\Width  = DesktopScaledX(16)
         *btn\Height = *btn\Width
         ; *tab\txt\change = 1 ; Сигнал для DrawTabs пересчитать ширину вкладки
      EndIf
      ProcedureReturn *btn
   EndIf
   ProcedureReturn #Null
EndProcedure

Procedure RemoveTabBTN(*tab._s_TAB, *btn._s_BTN = 0)
   If Not *tab
      ProcedureReturn #False
   EndIf
   
   If ListSize(*tab\btn())
      If *btn
         ChangeCurrentElement(*tab\btn(), *btn)
         DeleteElement(*tab\btn())
      Else
         ClearList(*tab\btn())
      EndIf
      ; *tab\txt\change = 1 ; Сигнал для DrawTabs пересчитать ширину вкладки
   EndIf
   
   ProcedureReturn #True
EndProcedure


;-
Procedure ActivateTab(*this._s_WIDGET, *NewActive._s_TAB)
   If *this\tab\active <> *NewActive
      ; Прячем старый контейнер
      If *this\tab\active
         *this\tab\active\mask &~ #__MASK_active
         If IsGadget(*this\tab\active\ContainerID)
            HideGadget(*this\tab\active\ContainerID, #True)
         EndIf
         RemoveTabBTN( *this\tab\active)
      EndIf
      
      ; Переключаем простой указатель
      *this\tab\active = *NewActive
      If *NewActive
         *NewActive\mask | #__MASK_active
         
         ; Показываем новый контейнер
         If IsGadget(*NewActive\ContainerID)
            HideGadget(*NewActive\ContainerID, #False)
         EndIf
         AddTabBTN( *NewActive, #__BTN_Close, 10)
         ProcedureReturn #True
      EndIf
   EndIf
EndProcedure

Procedure CloseTab(*this._s_WIDGET, *tab._s_TAB, *mouse._s_MOUSE = 0)
   If Not *this Or Not *tab
      ProcedureReturn #False
   EndIf
   
   ChangeCurrentElement( *this\tab\_s(), *tab)
   
   ; Сбрасываем состояния мыши, если курсор был на этой вкладке или её тащили
   If *mouse
      If *mouse\press = *tab : *mouse\press = 0 : EndIf
      If *mouse\enter = *tab : *mouse\enter = 0 : EndIf
   EndIf
   
   Protected isActive.b = Bool(*this\Tab\active = *tab)
   Protected *nextActive._s_TAB = 0
   
   ; Определяем следующую активную вкладку (сначала правую/нижнюю, затем левую/верхнюю)
   If isActive
      If NextElement(*this\Tab\_s())
         *nextActive = @*this\Tab\_s()
         PreviousElement(*this\Tab\_s())
      ElseIf PreviousElement(*this\Tab\_s())
         *nextActive = @*this\Tab\_s()
         NextElement(*this\Tab\_s())
      EndIf
      
      ActivateTab( *this, *nextActive)
   EndIf
   
   
   ; Очищаем список кнопок вкладки и удаляем саму вкладку
   ClearList(*tab\btn())
   DeleteElement(*this\Tab\_s())
   
   ; Сигнализируем DrawTabs о необходимости пересчитать позиции и общую ширину
   If  *this\mask & #__MASK_UpdateTotalSize = 0
      *this\mask | #__MASK_UpdateTotalSize
      ReDraw(*this)
   EndIf
   *this\mask | #__MASK_redraw
   ProcedureReturn #True
EndProcedure

Procedure AddTab(*this._s_WIDGET, ID.i, Text.s, size.i=0, Image.i = 0, align.q = #__MASK_Left, closeBtn.b = #True)
   Protected *tab._s_TAB = AddElement(*this\tab\_s())
   
   *tab\ID   = ID
   *tab\mask = align
   ;*tab\size = DesktopScaledX(size)
   
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
      ; AddTabBTN( *tab, #__BTN_Close, 10)
   EndIf
   
   Protected tabcolor = RGB(Random(50)+200, Random(50)+200, Random(50)+200) : tabcolor & $FFFFFF | 238 << 24
   ; создаем скрытый контейнер под размеры окна (ниже холста)
   ; внутри него ты сможешь создавать любые кнопки, строки ввода и т.д.
   ;*tab\data = RGBA(Random(50)+200, Random(50)+200, Random(50)+200, 255)
   *tab\containerID = ContainerGadget(#PB_Any, 0, 0, 0, 0, #PB_Container_BorderLess)
   ; для наглядности покрасим фоны контейнеров в разные случайные цвета
   SetGadgetColor(*tab\containerID, #PB_Gadget_BackColor, tabcolor)
   CloseGadgetList()
   
   If ListSize(*this\Tab\_s()) = 1
      *this\tab\active = *tab
      *this\tab\active\mask | #__MASK_active
      AddTabBTN( *tab, #__BTN_Close, 10)
   Else
      ; по умолчанию скрываем все контейнеры
      HideGadget(*tab\containerID, #True)
   EndIf
   
   *this\mask | #__MASK_UpdateTotalSize
   ProcedureReturn *tab
EndProcedure

Procedure FreeTab(*this._s_WIDGET, *tabtoclose._s_TAB)
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

Procedure CreateTab( Canvas, X.l,Y.l,Width.l,Height.l )
   Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
   *this\fontid  = LoadFont(0, "tahoma", 12)
   *this\bgcolor = RGBA(180, 195, 215, 160)
   *this\canvasid  = Canvas
   *this\X = DesktopScaledX(X)
   *this\y = DesktopScaledY(Y)
   *this\Width = DesktopScaledX(Width)
   *this\Height = DesktopScaledY(Height)
   ; *this\change = 1
   
   *this\tab\multirow = 1
   *this\tab\vertical = 0
   *this\tab\size = *this\Height 
   
   If *this\tab\multirow
      *this\tab\size = DesktopScaledY(29)
   EndIf
   
   *this\tab\padding = DesktopScaledX(5) ; Отступ контента
   *this\tab\indent = DesktopScaledX(10) ; Отступ панели
   *this\tab\spacing = DesktopScaledX(2) ; Растояние между вкладками
   *this\tab\slant = DesktopScaledX(20) : *this\tab\spacing = *this\tab\slant - DesktopScaledX(2)
   
   *this\tab\plus\txt\change = 1
   *this\tab\plus\txt\text = "+"
   *this\tab\plus\mask = #__MASK_center
   *this\tab\plus\Width = DesktopScaledX(24) ; *this\tab\slant*2 ; 
   *this\tab\plus\Height = *this\tab\size - bottomSpacing
   
   
  ProcedureReturn *this
EndProcedure


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

;-
Procedure DoEventBTN( *this._s_WIDGET, *tab._s_TAB, *btn._s_BTN, event )
   Protected windowID = EventWindow()
   
   Select event
      Case #PB_EventType_LeftButtonDown
         Select *btn\Type
            Case #__BTN_Close
               CloseTab( *this, *tab )
               
         EndSelect        
         
      Case #PB_EventType_MouseEnter
         
      Case #PB_EventType_MouseLeave
         
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
      Case #PB_EventType_LeftButtonDown
         *current_tab = *hoverTAB
         If *current_tab = *this\tab\plus
            ; КЛИК ПО ПЛЮСУ: Добавляем новую вкладку
            Protected NewIDx = ListSize(*this\tab\_s()) + 1
            AddTab(*this, -1, "Вкладка " + Str(NewIDx))
;                ; Пересчитываем чистые координаты \pos, \x, \y по новому порядку
;             *this\mask | #__MASK_UpdateTotalSize
;             *this\mask | #__MASK_Redraw
         
             ResizeCanvas( *this)
;             needredraw = #False
         Else
            If *current_tab
               dragOffSet = mousePos
               PressedTAB() = *current_tab
               *current_tab\mask | #__MASK_press
               
               If ActivateTab( *this, *current_tab)
                  *this\mask | #__MASK_UpdateTotalSize
                  ReDraw(*this)
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
         
      Case #PB_EventType_MouseMove
         *current_tab = PressedTAB()
         If *current_tab 
            If *current_tab\mask & #__MASK_drag
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
            *current_tab\mask | #__MASK_drag
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
               
              ; 1. ТЕСТ КНОПКИ ПЛЮС (+): Так как она закреплена справа над контейнером, проверяем её первой
               If my >= *this\tab\plus\y And my <= *this\tab\plus\y + *this\tab\plus\Height
                  If mx >= *this\tab\plus\x And mx <= *this\tab\plus\x + *this\tab\plus\Width
                     *hoverTAB = @*this\tab\plus
                  EndIf
               EndIf
               
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
                  DoEventBTN(*this, *hoverTAB, *hoverBTN, #PB_EventType_MouseLeave)
               EndIf
               
               *hoverBTN = *newHoverBTN
               
               If *hoverBTN
                  *hoverBTN\mask | #__MASK_Hover
                  DoEventBTN(*this, *hoverTAB, *hoverBTN, #PB_EventType_MouseEnter)
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
            DoEventBTN( *this, EnteredTAB( ), *hoverBTN, event )
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

;-
Procedure OpenList( *this._s_WIDGET, item.i)
   If ListSize(*this\tab\_s())
      Protected *tab._s_TAB = SelectElement(*this\tab\_s(), item)
      If IsGadget(*tab\containerID)
         OpenGadgetList(*tab\containerID)
      EndIf
   EndIf
EndProcedure

Procedure CloseList( )
   CloseGadgetList()
EndProcedure
; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

#Win = 0
#Canvas = 0

Procedure ResizeCanvas(*this._s_WIDGET)
   Protected *Tab._s_TAB, windowID.i = EventWindow()
   Protected gWidth.i  = WindowWidth(windowID)
   Protected gHeight.i = WindowHeight(windowID)
   
   ; 1. Обновляем ширину виджета под новое окно и ставим флаг пересчёта рядов
   *this\Width = DesktopScaledX(gWidth - 40)
   *this\mask | #__MASK_UpdateTotalSize
   
   ; 2. Первый проход: UpdateTotalSize пересчитает переносы
   ReDraw(*this)
   
   Protected newheight.i  = DesktopUnscaledY(*this\Height)+20 
   
   ; 3. Меняем размер канваса под итоговую высоту всех рядов
   ResizeGadget(*this\canvasid, #PB_Ignore, #PB_Ignore, gWidth - 20, newheight)
   
   ; 4. Сдвигаем и ресайзим контейнеры
   ForEach *this\tab\_s() : *tab = @*this\tab\_s()
      ResizeGadget(*tab\containerID, 10, newheight + 10, gWidth - 20, gHeight - newheight - 20)
   Next
   
   ; 5. Отрисовываем канвас уже с новым размером
   ReDraw(*this)
EndProcedure

If OpenWindow(#Win, 0,0,400,300, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   CanvasGadget(#Canvas, 10, 10, 0, 0)
   
   Define *this._s_WIDGET = CreateTab(#Canvas, 10,10,240,40 )
   ; Наполняем вашим тестовым набором
   AddTab(*this, 0, "0 - 60", 0)
   AddTab(*this, 1, "1 - 160", 160, (1), #__MASK_Center)
   AddTab(*this, 2, "2 - 150", 150, (1), #__MASK_Right)
   AddTab(*this, 3, "3 - 90", 90, (1))
   ;
   ; наполним первый и второй контейнер чем-нибудь для теста
   ; для этого временно переключаемся на нужный контейнер через opengadgetlist
   OpenList(*this, 0)
   ButtonGadget(#PB_Any, 20, 20, 150, 30, "кнопка на вкладке 1")
   StringGadget(#PB_Any, 20, 60, 200, 25, "текст на вкладке 1")
   CloseList()
   
   OpenList(*this, 1)
   CheckBoxGadget(#PB_Any, 20, 20, 200, 20, "галочка на второй вкладке")
   CloseList()
   
   ResizeCanvas(*this)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      Select Event 
         Case #PB_Event_Gadget 
            If EventGadget() = #Canvas
               If EventType() = #PB_EventType_RightClick
                  HideWindow(#Win, 1)
                  *this\tab\vertical ! 1
                  Swap *this\Width, *this\Height
                  ClearList(*this\Tab\_s())
                  AddTab(*this, 0, "0 - 60", 60)
                  AddTab(*this, 1, "1 - 160", 160, (1), #__MASK_Center)
                  AddTab(*this, 2, "2 - 150", 150, (1), #__MASK_Right)
                  AddTab(*this, 3, "3 - 90", 90, (1))
                  ;
                  ResizeCanvas( *this )
               EndIf
               
               If DoEvent( *this, EventType(),
                           GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX), 
                           GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
               EndIf
            EndIf
            
         Case #PB_Event_SizeWindow
            ; вызываем единую процедуру ресайза для холста и дочерних контейнеров
            ResizeCanvas(*this)
            
      EndSelect
      
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 541
; FirstLine = 389
; Folding = ---8-4-0---8---8-0-----------------
; EnableXP
; DPIAware