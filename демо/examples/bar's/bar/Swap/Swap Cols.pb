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

; =====================================================================
; 2. СТРУКТУРЫ ДАННЫХ
; =====================================================================
Structure _s_POINT : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure
Structure _s_TXT
   Text.s
EndStructure

Structure _s_IMG
   Image.i
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
   
   align.a               
   indent.a              
   spacing.a             
   TotalSize.l          
   List _s._s_TAB()  ; Заголовки вкладок
EndStructure

Structure _s_WIDGET
   Tab._s_TABS
   vertical.b
   dragOffSet.i     ; Точка захвата мыши
EndStructure

; =====================================================================
; 3. ЛОГИКА АЛГОРИТМА И ОТРИСОВКИ
; =====================================================================

; Функция линейного расчета базовых координат X
Procedure UpdateTabs(*this._s_WIDGET)
   Protected *tabs._s_TABS = *this\tab
   Protected position.i = *tabs\indent
   Protected *tab._s_TAB
   
   If *tabs\dragged = #Null
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         *tab\offset = 0
         If *this\vertical 
            *tab\Y = position : position + *tab\Height + *tabs\spacing
         Else
            *Tab\X = position : position + *tab\Width + *tabs\spacing
         EndIf
      Next
      *tabs\TotalSize = position - *tabs\spacing
   EndIf
EndProcedure

; Процедура добавления вкладки
; Обновленная процедура добавления вкладки с поддержкой иконок и выравнивания
Procedure AddTab(*this._s_WIDGET, ID.i, Text.s, size.i, align.a = #__flag_Left, Image.i = 0)
   AddElement(*this\tab\_s())
   Protected *tab._s_TAB = @*this\tab\_s()
   
   *tab\ID        = ID
   If *this\vertical 
      *tab\height = DesktopScaledY(size)
   Else
      *tab\width  = DesktopScaledX(size)
   EndIf
   *tab\align     = align
   *tab\txt\Text  = Text
   *tab\img\Image = Image 
EndProcedure

Procedure.i GetAlignPosition(alignFlags.l, contentSize.i, objectSize.i, Offset.i = 10)
   If alignFlags & #__flag_Center
      ProcedureReturn (contentSize - objectSize) / 2
   ElseIf alignFlags & #__flag_Right
      ProcedureReturn contentSize - objectSize - Offset
   Else ; #__flag_Left
      ProcedureReturn Offset
   EndIf
EndProcedure

Procedure DrawTab(vertical.b, *Tab._s_TAB, currentDrawX.i, currentDrawY.i, gadgetWidth.i, gadgetHeight.i, isDragged.b)
   Protected contentW.i, contentH.i, txtW.i, txtH.i, imgW.i, imgH.i
   ; Масштабируем пиксельные отступы под системный DPI
   Protected iconSpacing.i = DesktopScaledX(6) 
   Protected padding.i = DesktopScaledX(8)
   
   ; 1. Отрисовка фона вкладки
   If vertical
      If isDragged
         Box(0, currentDrawY, gadgetWidth, *tab\Height, RGBA(255, 0, 0, 160)) ; Летящая
      Else
         Box(0, currentDrawY, gadgetWidth, *tab\Height, RGBA(128, 128, 128, 255)) ; Статичная
      EndIf
   Else
      If isDragged
         Box(currentDrawX, 0, *tab\Width, gadgetHeight, RGBA(255, 0, 0, 160)) ; Летящая
      Else
         Box(currentDrawX, 0, *tab\Width, gadgetHeight, RGBA(128, 128, 128, 255)) ; Статичная
      EndIf
   EndIf
   
   ; Размеры текста из TextWidth() возвращаются с учетом DPI шрифта холста
   txtW = TextWidth(*tab\txt\Text)
   txtH = TextHeight(*Tab\txt\Text)
   
   If IsImage(*tab\img\Image)
      ; ВНИМАНИЕ: картинка УЖЕ растянута через ResizeImage, 
      ; поэтому берем ее реальную ширину и высоту БЕЗ DesktopScaled!
      imgW = ImageWidth(*tab\img\Image)
      imgH = ImageHeight(*tab\img\Image)
      contentW = imgW + iconSpacing + txtW
      contentH = imgH + iconSpacing + txtH
   Else
      contentW = txtW
      contentH = txtH
   EndIf
   
   Protected ImgX.i, ImgY.i, TxtX.i, TxtY.i, blockX.i, blockY.i
   
   If vertical
      TxtX = (gadgetWidth - TextWidth(*Tab\txt\Text)) / 2
      ImgX = (gadgetWidth - imgW) / 2
      
      ; 1. ВНЕШНЕЕ ПОЗИЦИОНИРОВАНИЕ ВСЕГО БЛОКА ВНУТРИ ВКЛАДКИ
      blockY.i = currentDrawY + GetAlignPosition(*tab\align, *tab\Height, contentH, padding)
      
      ; 2. ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ ПОРЯДКА ЭЛЕМЕНТОВ
      If *tab\align & #__flag_Right
         ; Направление RIGHT: Текст слева, Иконка справа
         TxtY = blockY
         ImgY = blockY + txtH + Bool(txtH)*iconSpacing
      Else
         ; Направление LEFT / По умолчанию: Иконка слева, Текст справа
         ImgY = blockY
         TxtY = blockY + imgH + Bool(imgH)*iconSpacing
      EndIf
      
   Else
      TxtY = (gadgetHeight - TextHeight(*tab\txt\Text)) / 2
      ImgY = (gadgetHeight - imgH) / 2
      
      ; 1. ВНЕШНЕЕ ПОЗИЦИОНИРОВАНИЕ ВСЕГО БЛОКА ВНУТРИ ВКЛАДКИ
      blockX.i = currentDrawX + GetAlignPosition(*tab\align, *tab\Width, contentW, padding)
      
      ; 2. ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ ПОРЯДКА ЭЛЕМЕНТОВ
      If *tab\align & #__flag_Right
         ; Направление RIGHT: Текст слева, Иконка справа
         TxtX = blockX
         ImgX = blockX + txtW + Bool(txtW)*iconSpacing
      Else
         ; Направление LEFT / По умолчанию: Иконка слева, Текст справа
         ImgX = blockX
         TxtX = blockX + imgW + Bool(imgW)*iconSpacing
      EndIf
   EndIf
   
   ; Вывод графики на Canvas (с вертикальным центрованием по Y)
   If IsImage(*tab\img\Image)
      ; Отрисовываем картинку 1:1, так как ее физический размер уже правильный
      DrawAlphaImage(ImageID(*tab\img\Image), ImgX, ImgY)
   EndIf
   
   DrawText(TxtX, TxtY, *tab\txt\Text, RGBA(255, 255, 255, 255))
EndProcedure

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDrawTabs(gadget.i, *this._s_WIDGET)
   Protected *tab._s_TAB
   Protected gWidth.i = DesktopScaledX(GadgetWidth(gadget))
   Protected gHeight.i = DesktopScaledY(GadgetHeight(gadget))
   
   If Not StartDrawing(CanvasOutput(gadget))
      ProcedureReturn
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Box(0, 0, gWidth, gHeight, RGBA(255, 255, 255, 255)) 
   
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
   
   ; Слой 1: Статичные
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      If *tab <> *this\tab\dragged
         If *this\vertical 
            DrawTab(1, *Tab, *tab\X, *tab\Y + *tab\offset, gWidth, gHeight, #False)
         Else
            DrawTab(0, *Tab, *tab\X + *tab\offset, *tab\Y, gWidth, gHeight, #False)
         EndIf
      EndIf
   Next
   
   ; Слой 2: Летящая поверх
   If *this\tab\dragged
      If *this\vertical 
         DrawTab(1, *this\tab\dragged, *this\tab\dragged\X, *this\tab\dragged\Y + *this\tab\dragged\offset, gWidth, gHeight, #True)
      Else
         DrawTab(0, *this\tab\dragged, *this\tab\dragged\X + *this\tab\dragged\offset, *this\tab\dragged\Y, gWidth, gHeight, #True)
      EndIf
   EndIf
   
   StopDrawing()
EndProcedure

; --- НАЖАТИЕ ЛЕВОЙ КНОПКИ ---
Procedure event_LeftButtonDown(*this._s_WIDGET, mx.i,my.i)
   Protected *current_tab._s_TAB
   Protected *tab._s_TAB
   
   If *this\vertical
      *this\dragOffSet = mY
   Else
      *this\dragOffSet = mx
   EndIf
   
   ; ЦИКЛ 1: Находим вкладку, на которую кликнули
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      If *this\vertical
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
      Protected accumulatedSize.i = *this\tab\indent 
      Protected isBeforeDragged.b = #True 
      Protected stepSize.i
      If *this\vertical
         stepSize = *current_tab\Height + *this\tab\spacing
      Else
         stepSize = *current_tab\Width + *this\tab\spacing
      EndIf
      
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         
         If *tab = *current_tab
            isBeforeDragged = #False 
            If *this\vertical
               *tab\offset = mY - *this\dragOffSet
            Else
               *tab\offset = mx - *this\dragOffSet
            EndIf
            Continue ; Лимиты для dragged запишем сразу после цикла
         EndIf
         
         If *this\vertical
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
      If *this\vertical
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
EndProcedure

; --- ДВИЖЕНИЕ МЫШИ ---
Procedure event_MouseMove(*this._s_WIDGET, mx.i,my.i)
   Protected *current_tab._s_TAB = *this\tab\dragged
   
   If *current_tab
      Protected *tab._s_TAB
      
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         
         If *this\vertical
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
EndProcedure

; --- ОТПУСКАНИЕ ЛЕВОЙ КНОПКИ ---
Procedure event_LeftButtonUp(*this._s_WIDGET)
   Protected *current_tab._s_TAB = *this\tab\dragged
   
   If *current_tab
      Protected *tab._s_TAB
      
      ; Переносим визуальный сдвиг в постоянную координату X и обнуляем offset
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         If *this\vertical
            *tab\Y + *tab\offset
         Else
            *Tab\X + *tab\offset
         EndIf
         *Tab\offset = 0
      Next
      
      ; Сортируем список вкладок в памяти по их новым физическим координатам X
      If *this\vertical
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
EndProcedure


; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

Define MyThis._s_WIDGET
MyThis\vertical = 1
MyThis\tab\indent = DesktopScaledX(50) ; Отступ панели слева
MyThis\tab\spacing = DesktopScaledX(2) ; Расстояние между вкладками

; Наполняем вашим тестовым набором
AddTab(@MyThis, 0, "0 - 60", 60)
AddTab(@MyThis, 1, "1 - 160", 160, #__flag_Center, 1)
AddTab(@MyThis, 2, "2 - 150", 150, #__flag_Right, 1)
AddTab(@MyThis, 3, "3 - 90", 90,0, 1)
UpdateTabs(@MyThis)

#Win = 0
#Canvas = 0

If MyThis\vertical
   Define h = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
   Define w = 240
Else
   Define h = 40
   Define w = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
EndIf

If OpenWindow(#Win, 0, 0, w + 20, h + 20, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, w, h)
   
   ReDrawTabs(#Canvas, @MyThis)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         Select EventType()
               
            Case #PB_EventType_LeftButtonDown
               If event_LeftButtonDown(@MyThis, GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
                  ReDrawTabs(#Canvas, @MyThis)
               EndIf
               
            Case #PB_EventType_MouseMove
               If event_MouseMove(@MyThis, GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
                  ReDrawTabs(#Canvas, @MyThis)
               EndIf
               
            Case #PB_EventType_LeftButtonUp
               If event_LeftButtonUp(@MyThis)
                  ReDrawTabs(#Canvas, @MyThis)
               EndIf
               
         EndSelect
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 153
; FirstLine = 148
; Folding = ------------
; EnableXP
; DPIAware