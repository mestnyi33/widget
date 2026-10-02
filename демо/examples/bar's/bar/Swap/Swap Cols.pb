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

Structure _s_TAB Extends _s_COORDINATE
   ID.i             ; Номер элемента в списке данных строки (0, 1, 2...) 
   txt._s_TXT       ; Имя поля заголовка
   img._s_IMG
   align.a          ; Выравнивание
   mask.q           ; Маска конкретной вкладки
   
   ; Поля для идеальной математики плавного сдвига
   offset.i        ; Динамический визуальный сдвиг
   minOffset.i     ; Левый ограничитель хода
   maxOffset.i     ; Правый ограничитель хода
EndStructure

Structure _s_TABS
   *active._s_TAB   
   *dragged._s_TAB  ; Указатель на перетаскиваемую вкладку
   
   vertical.b
   align.a               
   indent.a              
   spacing.a             
   TotalSize.l          
   List _s._s_TAB()  ; Заголовки вкладок
EndStructure

Structure _s_WIDGET
   Tab._s_TABS
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
Procedure UpdateTabs(*this._s_WIDGET)
   Protected position.i = *this\tab\indent
   Protected *tab._s_TAB
   
   If *this\tab\dragged = #Null
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         If *this\tab\vertical 
            *tab\Y = position : position + *tab\Height + *this\tab\spacing
         Else
            *tab\X = position : position + *tab\Width + *this\tab\spacing
         EndIf
         *tab\offset = 0
      Next
      *this\tab\TotalSize = position - *this\tab\spacing
   EndIf
EndProcedure

Procedure UpdateTab(vertical.b, *tab._s_TAB, gadgetWidth.i, gadgetHeight.i, isResize.b)
   Protected contentX.i, contentY.i, contentW.i, contentH.i
   
   If vertical
      *tab\Width = gadgetWidth
   Else
      *tab\Height = gadgetHeight
   EndIf
   
   ; 1. Замеры метрик (оставляем ленивое обновление, но убираем лишние вложенные проверки)
   If *tab\txt\change
      If *tab\txt\Text <> ""
         *tab\txt\Width = TextWidth(*tab\txt\Text)
         *tab\txt\height = TextHeight(*tab\txt\Text)
      Else
         *tab\txt\Width = 0 : *tab\txt\height = 0
      EndIf
   EndIf
   
   If *tab\img\change
      If IsImage(*tab\img\Image)
         *tab\img\width = ImageWidth(*tab\img\Image)
         *tab\img\height = ImageHeight(*tab\img\Image)
      Else
         *tab\img\width = 0 : *tab\img\height = 0
      EndIf
   EndIf
   
   ; 2. ВНЕШНЕЕ ПОЗИЦИОНИРОВАНИЕ ВСЕГО БЛОКА
   If *tab\txt\change Or *tab\img\change Or isResize
      ; Заменили сложение (+), которое могло давать ложные срабатывания, на битовое ИЛИ или явную проверку флагов
      If *tab\img\width Or *tab\img\height
         Protected iconSpacing.i = DesktopScaledX(6) ; Масштабируем отступ только если есть иконка
         contentW = *tab\img\width + iconSpacing + *tab\txt\width
         contentH = *tab\img\height + iconSpacing + *tab\txt\height
      Else
         contentW = *tab\txt\width
         contentH = *tab\txt\height
      EndIf
      
      Protected padding.i = DesktopScaledX(8)
      If vertical
         contentY = GetAlignPosition(*tab\align, *tab\Height, contentH, padding)
      Else
         contentX = GetAlignPosition(*tab\align, *tab\Width, contentW, padding)
      EndIf
   EndIf
   
   ; 3. ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ (Оптимизировано: убран Bool() из расчетов, так как наличие иконки проверено выше)
   If *tab\txt\change Or isResize
      If vertical
         *tab\txt\x = (gadgetWidth - *tab\txt\width) >> 1 ; Быстрое деление на 2 через битовый сдвиг
         If *tab\align & #__flag_Bottom
            *tab\txt\y = contentY
         Else
            *tab\txt\y = contentY + *tab\img\height
            If *tab\img\height : *tab\txt\y + iconSpacing : EndIf
         EndIf
      Else
         *tab\txt\y = (gadgetHeight - *tab\txt\height) >> 1
         If *tab\align & #__flag_Right
            *tab\txt\x = contentX
         Else
            *tab\txt\x = contentX + *tab\img\width
            If *tab\img\width : *tab\txt\x + iconSpacing : EndIf
         EndIf
      EndIf
      *tab\txt\change = 0
   EndIf
   
   If *tab\img\change Or isResize
      If vertical
         *tab\img\x = (gadgetWidth - *tab\img\width) >> 1
         If *tab\align & #__flag_Bottom
            *tab\img\y = contentY + *tab\txt\height
            If *tab\txt\height : *tab\img\y + iconSpacing : EndIf
         Else
            *tab\img\y = contentY
         EndIf
      Else
         *tab\img\y = (gadgetHeight - *tab\img\height) >> 1
         If *tab\align & #__flag_Right
            *tab\img\x = contentX + *tab\txt\width
            If *tab\txt\width : *tab\img\x + iconSpacing : EndIf
         Else
            *tab\img\x = contentX
         EndIf
      EndIf
      *tab\img\change = 0
   EndIf
   
EndProcedure

; Процедура добавления вкладки
; Обновленная процедура добавления вкладки с поддержкой иконок и выравнивания
Procedure AddTab(*this._s_WIDGET, ID.i, Text.s, size.i, align.a = #__flag_Left, Image.i = 0)
   Protected *tab._s_TAB = AddElement(*this\tab\_s())
   
   *tab\ID        = ID
   *tab\align     = align
   If *this\tab\vertical 
      *tab\height = DesktopScaledY(size)
   Else
      *tab\width  = DesktopScaledX(size)
   EndIf
   If Text
      *tab\txt\text  = Text
      *tab\txt\change = 1
   EndIf
   If IsImage(Image)
      *tab\img\image = Image 
      *tab\img\change = 1
   EndIf
EndProcedure

; Будущая рабочая процедура (когда все метрики уже посчитаны при создании)
Procedure DrawTab(vertical.b, *tab._s_TAB, isDragged.b)
   Protected rx.i = *tab\x
   Protected ry.i = *tab\y
   
   If vertical
      ry + *tab\offset
   Else
      rx + *tab\offset
   EndIf
   
   ; 1. ОТРИСОВКА ФОНА
   If isDragged
      Box(rx, ry, *tab\Width, *tab\Height, $A00000FF)
   Else
      Box(rx, ry, *tab\Width, *tab\Height, $FF808080)
   EndIf
   
   ; 2. ОТРИСОВКА ИКОНКИ (Координаты уже намертво вшиты в структуру)
   If *tab\img\width Or *tab\img\height
      DrawAlphaImage(ImageID(*tab\img\Image), rx + *tab\img\X, ry + *tab\img\Y)
   EndIf
   
   ; 3. ОТРИСОВКА ТЕКСТА
   If *tab\txt\Text <> ""
      DrawText(rx + *tab\txt\X, ry + *tab\txt\Y, *tab\txt\Text, $FFFFFFFF)
   EndIf
EndProcedure

Procedure DrawTabs(*this._s_WIDGET, *current_tab._s_TAB, gWidth, gHeight)
   Protected *tab._s_TAB
   Protected vertical.b = *this\tab\vertical
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
   
   ; Слой 1: Статичные
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      If *tab <> *current_tab
         UpdateTab(vertical, *tab, gWidth, gHeight, #False)
         ;
         DrawTab(vertical, *tab, #False)
      EndIf
   Next
   
   ; Слой 2: Летящая поверх
   If *current_tab
      UpdateTab(vertical, *current_tab, gWidth, gHeight, #False)
      ;
      DrawTab(vertical, *current_tab, #True)
   EndIf
EndProcedure

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDrawTabs(gadget.i, *this._s_WIDGET)
   Protected gWidth.i = DesktopScaledX(GadgetWidth(gadget))
   Protected gHeight.i = DesktopScaledY(GadgetHeight(gadget))
   
   If Not StartDrawing(CanvasOutput(gadget))
      ProcedureReturn
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Box(0, 0, gWidth, gHeight, RGBA(255, 255, 255, 255)) 
   
   DrawTabs(*this, *this\tab\dragged, gWidth, gHeight)
   
   StopDrawing()
EndProcedure

Procedure DoTabEvents(*this._s_WIDGET, event.i, mx.i, my.i)
   Protected *current_tab._s_TAB
   Protected *tab._s_TAB
   Protected accumulatedSize.i = *this\tab\indent 
   Protected isBeforeDragged.b = #True 
   Protected stepSize.i
   
   Select event
         
      Case #PB_EventType_LeftButtonDown
         If *this\tab\vertical
            *this\dragOffSet = mY
         Else
            *this\dragOffSet = mx
         EndIf
         
         ; ЦИКЛ 1: Находим вкладку, на которую кликнули
         ForEach *this\tab\_s()
            *tab = @*this\tab\_s()
            If *this\tab\vertical
               If my >= *tab\Y And mY < *tab\Y + *tab\Height
                  *current_tab = *tab
                  Break
               EndIf
            Else
               If mx >= *tab\X And mx < *tab\X + *tab\Width
                  *current_tab = *tab
                  Break
               EndIf
            EndIf
         Next
         
         *this\tab\dragged = *current_tab
         
         ; ЦИКЛ 2: Выполняем раздвижку, лимиты и расчет стартового offset за один проход
         If *current_tab
            If *this\tab\vertical
               stepSize = *current_tab\Height + *this\tab\spacing
            Else
               stepSize = *current_tab\Width + *this\tab\spacing
            EndIf
            
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               
               If *tab = *current_tab
                  isBeforeDragged = #False 
                  If *this\tab\vertical
                     *tab\offset = mY - *this\dragOffSet
                  Else
                     *tab\offset = mx - *this\dragOffSet
                  EndIf
                  Continue ; Лимиты для dragged запишем сразу после цикла
               EndIf
               
               If *this\tab\vertical
                  ; 1. Сдвигаем базовый Y только для вкладок левее нажатой
                  If isBeforeDragged
                     *tab\y + stepSize
                  EndIf
                  
                  ; 2. Расчет лимитов хода (использует уже обновленный *tab\Y)
                  *tab\minOffset = accumulatedSize - *tab\y
                  *tab\maxOffset = accumulatedSize - *tab\y + stepSize
                  accumulatedSize + *tab\Height + *this\tab\spacing
                  
                  ; 3. Ваша оригинальная пропорция инициализации offset (использует обновленный *tab\X)
                  *tab\offset = *tab\y - *current_tab\y - *current_tab\offset
                  *tab\offset - stepSize
                  *tab\offset * stepSize / (*tab\Height + *this\tab\spacing)
               Else
                  ; 1. Сдвигаем базовый X только для вкладок левее нажатой
                  If isBeforeDragged
                     *tab\X + stepSize
                  EndIf
                  
                  ; 2. Расчет лимитов хода (использует уже обновленный *tab\X)
                  *tab\minOffset = accumulatedSize - *tab\X
                  *tab\maxOffset = accumulatedSize - *tab\X + stepSize
                  accumulatedSize + *tab\Width + *this\tab\spacing
                  
                  ; 3. Ваша оригинальная пропорция инициализации offset (использует обновленный *tab\X)
                  *tab\offset = *tab\X - *current_tab\X - *current_tab\offset
                  *tab\offset - stepSize
                  *tab\offset * stepSize / (*tab\Width + *this\tab\spacing)
               EndIf
               
               ; Ограничители хода
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
            Next
            
            ; Финальная запись лимитов и проверка границ для самой перетаскиваемой вкладки
            If *this\tab\vertical
               *current_tab\minOffset = *this\tab\indent - *current_tab\y
               *current_tab\maxOffset = -*current_tab\y + accumulatedSize
            Else
               *current_tab\minOffset = *this\tab\indent - *current_tab\X
               *current_tab\maxOffset = -*current_tab\X + accumulatedSize
            EndIf
            
            If *current_tab\offset < *current_tab\minOffset : *current_tab\offset = *current_tab\minOffset : EndIf
            If *current_tab\offset > *current_tab\maxOffset : *current_tab\offset = *current_tab\maxOffset : EndIf
            
            ProcedureReturn #True
         EndIf
         
      Case #PB_EventType_MouseMove
         *current_tab = *this\tab\dragged
         If *current_tab
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               
               If *this\tab\vertical
                  If *tab = *current_tab
                     *tab\offset = my - *this\dragOffSet
                  Else
                     *tab\offset = *tab\y - *current_tab\y - *current_tab\offset
                     *tab\offset - (*current_tab\Height + *this\tab\spacing)
                     *tab\offset * (*current_tab\Height + *this\tab\spacing) / (*tab\Height + *this\tab\spacing)
                  EndIf
               Else
                  If *tab = *current_tab
                     *tab\offset = mx - *this\dragOffSet
                  Else
                     *tab\offset = *tab\X - *current_tab\X - *current_tab\offset
                     *tab\offset - (*current_tab\Width + *this\tab\spacing)
                     *tab\offset * (*current_tab\Width + *this\tab\spacing) / (*tab\Width + *this\tab\spacing)
                  EndIf
               EndIf
               
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
            Next
            ProcedureReturn #True
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         *current_tab = *this\tab\dragged
         If *current_tab
            ; Переносим визуальный сдвиг в постоянную координату X и обнуляем offset
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               If *this\tab\vertical
                  *tab\Y + *tab\offset
               Else
                  *tab\X + *tab\offset
               EndIf
               *tab\offset = 0
            Next
            
            ; Сортируем список вкладок в памяти по их новым физическим координатам X
            If *this\tab\vertical
               SortStructuredList(*this\tab\_s(), #PB_Sort_Ascending, OffsetOf(_s_TAB\Y), TypeOf(_s_TAB\Y))
            Else
               SortStructuredList(*this\tab\_s(), #PB_Sort_Ascending, OffsetOf(_s_TAB\X), TypeOf(_s_TAB\X))
            EndIf
            
            ; Сбрасываем указатель перетаскивания
            *this\tab\dragged = #Null
            
            ; Вызываем ваши внутренние процедуры обновления состояния и перерисовки
            UpdateTabs(*this)
            ProcedureReturn #True
         EndIf
         
   EndSelect
EndProcedure

; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

Define MyThis._s_WIDGET
MyThis\tab\vertical = 0
MyThis\tab\indent = DesktopScaledX(50) ; Отступ панели слева
MyThis\tab\spacing = DesktopScaledX(2) ; Расстояние между вкладками

; Наполняем вашим тестовым набором
AddTab(@MyThis, 0, "0 - 60", 60)
AddTab(@MyThis, 1, "1 - 160", 160, #__flag_Center, 1)
AddTab(@MyThis, 2, "2 - 150", 150, #__flag_Right, 1)
AddTab(@MyThis, 3, "3 - 90", 90,0, 1)
;
UpdateTabs(@MyThis)

If MyThis\tab\vertical
   Define h = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
   Define w = 240
Else
   Define h = 40
   Define w = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
EndIf
 
#Win = 0
#Canvas = 0

If OpenWindow(#Win, 0, 0, w + 20, h + 20, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, w, h)
   
   ReDrawTabs(#Canvas, @MyThis)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         If EventType() = #PB_EventType_LeftDoubleClick
            HideWindow(#Win, 1)
            MyThis\tab\vertical ! 1
            ClearList(MyThis\Tab\_s())
            AddTab(@MyThis, 0, "0 - 60", 60)
            AddTab(@MyThis, 1, "1 - 160", 160, #__flag_Center, 1)
            AddTab(@MyThis, 2, "2 - 150", 150, #__flag_Right, 1)
            AddTab(@MyThis, 3, "3 - 90", 90,0, 1)
            UpdateTabs(@MyThis)
            If MyThis\tab\vertical
               Define h = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
               Define w = 240
            Else
               Define h = 40
               Define w = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
            EndIf
            ResizeWindow(#Win, #PB_Ignore, #PB_Ignore, w + 20, h + 20)
            ResizeGadget(#Canvas, #PB_Ignore, #PB_Ignore, w, h)
            ReDrawTabs(#Canvas, @MyThis)
            HideWindow(#Win, 0, #PB_Window_ScreenCentered)
         EndIf
         
         If DoTabEvents( @MyThis, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
            ReDrawTabs(#Canvas, @MyThis)
         EndIf
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 456
; FirstLine = 449
; Folding = --------------
; EnableXP
; DPIAware