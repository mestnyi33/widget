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
#__flag_Center = 1
#__flag_Right  = 2
#__flag_Bottom  = 4

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

Structure _s_COL ;Extends _s_COORDINATE
   x.l
   width.l
   ID.i             ; Номер элемента в списке данных строки (0, 1, 2...) 
   txt._s_TXT       ; Имя поля заголовка
   img._s_IMG
   align.a          ; Выравнивание
   ;mask.q           ; Маска конкретной вкладки
   
   ; Поля для идеальной математики плавного сдвига
   offset.i        ; Динамический визуальный сдвиг
   minOffset.i     ; Левый ограничитель хода
   maxOffset.i     ; Правый ограничитель хода
EndStructure

Structure _s_COLS
   *active._s_COL   
   *dragged._s_COL  ; Указатель на перетаскиваемую вкладку
   
   ;vertical.b
   align.a               
   ;indent.a              
   spacing.a             
   TotalSize.l          
   List _s._s_COL()  ; Заголовки вкладок
EndStructure

Structure _s_WIDGET
   Col._s_COLS
   dragOffSet.i     ; Точка захвата мыши
EndStructure

; =====================================================================
; 3. ЛОГИКА АЛГОРИТМА И ОТРИСОВКИ
; =====================================================================

Procedure.i GetAlignPosition(alignFlags.l, contentSize.i, objectSize.i, Offset.i = 10)
   If alignFlags & #__flag_Center
      ProcedureReturn (contentSize - objectSize) / 2
   ElseIf alignFlags & #__flag_Right
      ProcedureReturn contentSize - objectSize - Offset
   Else ; #__flag_Left
      ProcedureReturn Offset
   EndIf
EndProcedure


; Функция линейного расчета базовых координат X
Procedure UpdateCols(*this._s_WIDGET)
   Protected position.i = 0;*this\col\indent
   Protected *col._s_COL
   
   If *this\col\dragged = #Null
      ForEach *this\col\_s()
         *col = @*this\col\_s()
;          If *this\col\vertical 
;             *col\Y = position : position + *col\Height + *this\col\spacing
;          Else
            *col\X = position : position + *col\Width + *this\col\spacing
;          EndIf
         *col\offset = 0
      Next
      *this\col\TotalSize = position - *this\col\spacing
   EndIf
EndProcedure

; Процедура добавления вкладки
; Обновленная процедура добавления вкладки с поддержкой иконок и выравнивания
Procedure AddCol(*this._s_WIDGET, ID.i, Text.s, size.i, align.a = #__flag_Left, Image.i = 0)
   Protected *col._s_COL = AddElement(*this\col\_s())
   
   *col\ID        = ID
   *col\align     = align
;    If *this\col\vertical 
;       *col\height = DesktopScaledY(size)
;    Else
      *col\width  = DesktopScaledX(size)
;    EndIf
   If Text
      *col\txt\text  = Text
      *col\txt\change = 1
   EndIf
   If IsImage(Image)
      *col\img\image = Image 
      *col\img\change = 1
   EndIf
EndProcedure

; Будущая рабочая процедура (когда все метрики уже посчитаны при создании)
Procedure DrawCol(*col._s_COL, gadgetHeight.l, isDragged.b, isResize.b=0)
   Protected rx.i = *col\x
   Protected ry.i = 0;*col\y

       Protected contentX.i, contentY.i, contentW.i, contentH.i
   
;    If vertical
;       *col\Width = gadgetWidth
;    Else
;       *col\Height = gadgetHeight
;    EndIf
   
   ; 1. Замеры метрик (оставляем ленивое обновление, но убираем лишние вложенные проверки)
   If *col\txt\change
      If *col\txt\Text <> ""
         *col\txt\Width = TextWidth(*col\txt\Text)
         *col\txt\height = TextHeight(*col\txt\Text)
      Else
         *col\txt\Width = 0 : *col\txt\height = 0
      EndIf
   EndIf
   
   If *col\img\change
      If IsImage(*col\img\Image)
         *col\img\width = ImageWidth(*col\img\Image)
         *col\img\height = ImageHeight(*col\img\Image)
      Else
         *col\img\width = 0 : *col\img\height = 0
      EndIf
   EndIf
   
   ; 2. ВНЕШНЕЕ ПОЗИЦИОНИРОВАНИЕ ВСЕГО БЛОКА
   If *col\txt\change Or *col\img\change Or isResize
      ; Заменили сложение (+), которое могло давать ложные срабатывания, на битовое ИЛИ или явную проверку флагов
      If *col\img\width Or *col\img\height
         Protected iconSpacing.i = DesktopScaledX(6) ; Масштабируем отступ только если есть иконка
         contentW = *col\img\width + iconSpacing + *col\txt\width
         contentH = *col\img\height + iconSpacing + *col\txt\height
      Else
         contentW = *col\txt\width
         contentH = *col\txt\height
      EndIf
      
      Protected padding.i = DesktopScaledX(8)
;       If vertical
;          contentY = GetAlignPosition(*col\align, *col\Height, contentH, padding)
;       Else
         contentX = GetAlignPosition(*col\align, *col\Width, contentW, padding)
;       EndIf
   EndIf
   
   ; 3. ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ (Оптимизировано: убран Bool() из расчетов, так как наличие иконки проверено выше)
   If *col\txt\change Or isResize
;       If vertical
;          *col\txt\x = (gadgetWidth - *col\txt\width) >> 1 ; Быстрое деление на 2 через битовый сдвиг
;          If *col\align & #__flag_Bottom
;             *col\txt\y = contentY
;          Else
;             *col\txt\y = contentY + *col\img\height
;             If *col\img\height : *col\txt\y + iconSpacing : EndIf
;          EndIf
;       Else
         *col\txt\y = (gadgetHeight - *col\txt\height) >> 1
         If *col\align & #__flag_Right
            *col\txt\x = contentX
         Else
            *col\txt\x = contentX + *col\img\width
            If *col\img\width : *col\txt\x + iconSpacing : EndIf
         EndIf
;       EndIf
      *col\txt\change = 0
   EndIf
   
   If *col\img\change Or isResize
;       If vertical
;          *col\img\x = (gadgetWidth - *col\img\width) >> 1
;          If *col\align & #__flag_Bottom
;             *col\img\y = contentY + *col\txt\height
;             If *col\txt\height : *col\img\y + iconSpacing : EndIf
;          Else
;             *col\img\y = contentY
;          EndIf
;       Else
         *col\img\y = (gadgetHeight - *col\img\height) >> 1
         If *col\align & #__flag_Right
            *col\img\x = contentX + *col\txt\width
            If *col\txt\width : *col\img\x + iconSpacing : EndIf
         Else
            *col\img\x = contentX
         EndIf
;       EndIf
      *col\img\change = 0
   EndIf
   
     ;
         
;    If vertical
;       ry + *col\offset
;    Else
      rx + *col\offset
;    EndIf
   
   ; 1. ОТРИСОВКА ФОНА
   If isDragged
      Box(rx, ry, *col\Width, gadgetHeight, $A00000FF)
   Else
      Box(rx, ry, *col\Width, gadgetHeight, $FF808080)
   EndIf
   
   ; 2. ОТРИСОВКА ИКОНКИ (Координаты уже намертво вшиты в структуру)
   If *col\img\width Or *col\img\height
      DrawAlphaImage(ImageID(*col\img\Image), rx + *col\img\X, ry + *col\img\Y)
   EndIf
   
   ; 3. ОТРИСОВКА ТЕКСТА
   If *col\txt\Text <> ""
      DrawText(rx + *col\txt\X, ry + *col\txt\Y, *col\txt\Text, $FFFFFFFF)
   EndIf
EndProcedure

Procedure DrawCols(*this._s_WIDGET, *current_Col._s_COL, gWidth, gHeight)
   Protected *col._s_COL
   Protected vertical.b = 0;*this\col\vertical
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
   
   ; Слой 1: Статичные
   ForEach *this\col\_s()
      *col = @*this\col\_s()
      If *col <> *current_Col
         DrawCol(*col, gHeight, #False)
      EndIf
   Next
   
   ; Слой 2: Летящая поверх
   If *current_Col
      DrawCol(*current_Col, gHeight, #True)
   EndIf
EndProcedure

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDrawCols(gadget.i, *this._s_WIDGET)
   Protected gWidth.i = DesktopScaledX(GadgetWidth(gadget))
   Protected gHeight.i = DesktopScaledY(GadgetHeight(gadget))
   
   If Not StartDrawing(CanvasOutput(gadget))
      ProcedureReturn
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Box(0, 0, gWidth, gHeight, RGBA(255, 255, 255, 255)) 
   
   DrawCols(*this, *this\col\dragged, gWidth, gHeight)
   
   StopDrawing()
EndProcedure

Procedure DoColEvents(*this._s_WIDGET, event.i, mx.i, my.i)
   Protected *current_Col._s_COL
   Protected *col._s_COL
   Protected accumulatedSize.i = 0;*this\col\indent 
   Protected isBeforeDragged.b = #True 
   Protected stepSize.i
   
   Select event
         
      Case #PB_EventType_LeftButtonDown
;          If *this\col\vertical
;             *this\dragOffSet = mY
;          Else
            *this\dragOffSet = mx
;          EndIf
         
         ; ЦИКЛ 1: Находим вкладку, на которую кликнули
         ForEach *this\col\_s()
            *col = @*this\col\_s()
;             If *this\col\vertical
;                If my >= *col\Y And mY < *col\Y + *col\Height
;                   *current_Col = *col
;                   Break
;                EndIf
;             Else
               If mx >= *col\X And mx < *col\X + *col\Width
                  *current_Col = *col
                  Break
               EndIf
;             EndIf
         Next
         
         *this\col\dragged = *current_Col
         
         ; ЦИКЛ 2: Выполняем раздвижку, лимиты и расчет стартового offset за один проход
         If *current_Col
;             If *this\col\vertical
;                stepSize = *current_Col\Height + *this\col\spacing
;             Else
               stepSize = *current_Col\Width + *this\col\spacing
;             EndIf
            
            ForEach *this\col\_s()
               *col = @*this\col\_s()
               
               If *col = *current_Col
                  isBeforeDragged = #False 
;                   If *this\col\vertical
;                      *col\offset = mY - *this\dragOffSet
;                   Else
                     *col\offset = mx - *this\dragOffSet
;                   EndIf
                  Continue ; Лимиты для dragged запишем сразу после цикла
               EndIf
               
;                If *this\col\vertical
;                   ; 1. Сдвигаем базовый Y только для вкладок левее нажатой
;                   If isBeforeDragged
;                      *col\y + stepSize
;                   EndIf
;                   
;                   ; 2. Расчет лимитов хода (использует уже обновленный *col\Y)
;                   *col\minOffset = accumulatedSize - *col\y
;                   *col\maxOffset = accumulatedSize - *col\y + stepSize
;                   accumulatedSize + *col\Height + *this\col\spacing
;                   
;                   ; 3. Ваша оригинальная пропорция инициализации offset (использует обновленный *col\X)
;                   *col\offset = *col\y - *current_Col\y - *current_Col\offset
;                   *col\offset - stepSize
;                   *col\offset * stepSize / (*col\Height + *this\col\spacing)
;                Else
                  ; 1. Сдвигаем базовый X только для вкладок левее нажатой
                  If isBeforeDragged
                     *col\X + stepSize
                  EndIf
                  
                  ; 2. Расчет лимитов хода (использует уже обновленный *col\X)
                  *col\minOffset = accumulatedSize - *col\X
                  *col\maxOffset = accumulatedSize - *col\X + stepSize
                  accumulatedSize + *col\Width + *this\col\spacing
                  
                  ; 3. Ваша оригинальная пропорция инициализации offset (использует обновленный *col\X)
                  *col\offset = *col\X - *current_Col\X - *current_Col\offset
                  *col\offset - stepSize
                  *col\offset * stepSize / (*col\Width + *this\col\spacing)
;                EndIf
               
               ; Ограничители хода
               If *col\offset < *col\minOffset : *col\offset = *col\minOffset : EndIf
               If *col\offset > *col\maxOffset : *col\offset = *col\maxOffset : EndIf
            Next
            
;             ; Финальная запись лимитов и проверка границ для самой перетаскиваемой вкладки
;             If *this\col\vertical
;                *current_Col\minOffset = *current_Col\y ; *this\col\indent - 
;                *current_Col\maxOffset = -*current_Col\y + accumulatedSize
;             Else
               *current_Col\minOffset = -*current_Col\X  ; *this\col\indent - 
               *current_Col\maxOffset = -*current_Col\X + accumulatedSize
;             EndIf
            
            If *current_Col\offset < *current_Col\minOffset : *current_Col\offset = *current_Col\minOffset : EndIf
            If *current_Col\offset > *current_Col\maxOffset : *current_Col\offset = *current_Col\maxOffset : EndIf
            
            ProcedureReturn #True
         EndIf
         
      Case #PB_EventType_MouseMove
         *current_Col = *this\col\dragged
         If *current_Col
            ForEach *this\col\_s()
               *col = @*this\col\_s()
               
;                If *this\col\vertical
;                   If *col = *current_Col
;                      *col\offset = my - *this\dragOffSet
;                   Else
;                      *col\offset = *col\y - *current_Col\y - *current_Col\offset
;                      *col\offset - (*current_Col\Height + *this\col\spacing)
;                      *col\offset * (*current_Col\Height + *this\col\spacing) / (*col\Height + *this\col\spacing)
;                   EndIf
;                Else
                  If *col = *current_Col
                     *col\offset = mx - *this\dragOffSet
                  Else
                     *col\offset = *col\X - *current_Col\X - *current_Col\offset
                     *col\offset - (*current_Col\Width + *this\col\spacing)
                     *col\offset * (*current_Col\Width + *this\col\spacing) / (*col\Width + *this\col\spacing)
                  EndIf
;                EndIf
               
               If *col\offset < *col\minOffset : *col\offset = *col\minOffset : EndIf
               If *col\offset > *col\maxOffset : *col\offset = *col\maxOffset : EndIf
            Next
            ProcedureReturn #True
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         *current_Col = *this\col\dragged
         If *current_Col
            ; Переносим визуальный сдвиг в постоянную координату X и обнуляем offset
            ForEach *this\col\_s()
               *col = @*this\col\_s()
;                If *this\col\vertical
;                   *col\Y + *col\offset
;                Else
                  *col\X + *col\offset
;                EndIf
               *col\offset = 0
            Next
            
            ; Сортируем список вкладок в памяти по их новым физическим координатам X
;             If *this\col\vertical
;                SortStructuredList(*this\col\_s(), #PB_Sort_Ascending, OffsetOf(_s_COL\Y), TypeOf(_s_COL\Y))
;             Else
               SortStructuredList(*this\col\_s(), #PB_Sort_Ascending, OffsetOf(_s_COL\X), TypeOf(_s_COL\X))
;             EndIf
            
            ; Сбрасываем указатель перетаскивания
            *this\col\dragged = #Null
            
            ; Вызываем ваши внутренние процедуры обновления состояния и перерисовки
            UpdateCols(*this)
            ProcedureReturn #True
         EndIf
         
   EndSelect
EndProcedure

; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

Define MyThis._s_WIDGET
; MyThis\col\vertical = 0
;MyThis\col\indent = DesktopScaledX(50) ; Отступ панели слева
MyThis\col\spacing = DesktopScaledX(2) ; Расстояние между вкладками

; Наполняем вашим тестовым набором
AddCol(@MyThis, 0, "0 - 60", 60)
AddCol(@MyThis, 1, "1 - 160", 160, #__flag_Center, 1)
AddCol(@MyThis, 2, "2 - 150", 150, #__flag_Right, 1)
AddCol(@MyThis, 3, "3 - 90", 90,0, 1)
;
UpdateCols(@MyThis)

; If MyThis\col\vertical
;    Define h = DesktopUnscaledX(MyThis\col\TotalSize );+ MyThis\col\indent)
;    Define w = 240
; Else
   Define h = 40
   Define w = DesktopUnscaledX(MyThis\col\TotalSize );+ MyThis\col\indent)
; EndIf
 
#Win = 0
#Canvas = 0

If OpenWindow(#Win, 0, 0, w + 20, h + 20, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, w, h)
   
   ReDrawCols(#Canvas, @MyThis)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         If EventType() = #PB_EventType_LeftDoubleClick
            HideWindow(#Win, 1)
;             MyThis\col\vertical ! 1
            ClearList(MyThis\col\_s())
            AddCol(@MyThis, 0, "0 - 60", 60)
            AddCol(@MyThis, 1, "1 - 160", 160, #__flag_Center, 1)
            AddCol(@MyThis, 2, "2 - 150", 150, #__flag_Right, 1)
            AddCol(@MyThis, 3, "3 - 90", 90,0, 1)
            UpdateCols(@MyThis)
;             If MyThis\col\vertical
;                Define h = DesktopUnscaledX(MyThis\col\TotalSize );+ MyThis\col\indent)
;                Define w = 240
;             Else
               Define h = 40
               Define w = DesktopUnscaledX(MyThis\col\TotalSize );+ MyThis\col\indent)
;             EndIf
            ResizeWindow(#Win, #PB_Ignore, #PB_Ignore, w + 20, h + 20)
            ResizeGadget(#Canvas, #PB_Ignore, #PB_Ignore, w, h)
            ReDrawCols(#Canvas, @MyThis)
            HideWindow(#Win, 0, #PB_Window_ScreenCentered)
         EndIf
         
         If DoColEvents( @MyThis, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
            ReDrawCols(#Canvas, @MyThis)
         EndIf
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 99
; FirstLine = 86
; Folding = --0-------
; EnableXP
; DPIAware