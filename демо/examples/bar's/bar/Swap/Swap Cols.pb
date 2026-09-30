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
Structure _s_TXT
   Text.s
EndStructure

Structure _s_IMG
   Image.i
EndStructure

Structure _s_COL 
   X.i              ; Логический базовый X вкладки
   Width.i          ; Ширина вкладки
   ID.i             ; Номер элемента в списке данных строки (0, 1, 2...) 
   txt._s_TXT       ; Имя поля заголовка
   img._s_IMG
   align.a          ; Выравнивание
   mask.q           ; Маска конкретной вкладки
   
   ; Поля для идеальной математики плавного сдвига
   offsetX.i        ; Динамический визуальный сдвиг
   minOffset.i      ; Левый ограничитель хода
   maxOffset.i      ; Правый ограничитель хода
EndStructure

Structure _s_TAB Extends _s_COL 
EndStructure

Structure _s_TABS
   *active._s_TAB   
   *dragged._s_TAB  ; Указатель на перетаскиваемую вкладку
   
   align.a               
   indent.a              
   spacing.a             
   totalWidth.l          
   List _s._s_TAB()  ; Заголовки вкладок
EndStructure

Structure _s_WIDGET
   Tab._s_TABS
   vertical.b
   dragStartX.i     ; Точка захвата мыши
EndStructure

; =====================================================================
; 3. ЛОГИКА АЛГОРИТМА И ОТРИСОВКИ
; =====================================================================

; Функция линейного расчета базовых координат X
Procedure UpdateTabs(*this._s_WIDGET)
   Protected *tabs._s_TABS = *this\tab
   Protected currentX.i = *tabs\indent
   Protected *tab._s_TAB
   
   If *tabs\dragged = #Null
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         *tab\X = currentX
         *tab\offsetX = 0
         currentX + *tab\Width + *tabs\spacing
      Next
      *tabs\totalWidth = currentX - *tabs\spacing
   EndIf
EndProcedure

; Процедура добавления вкладки
; Обновленная процедура добавления вкладки с поддержкой иконок и выравнивания
Procedure AddTab(*this._s_WIDGET, ID.i, Text.s, Width.i, align.a = #__flag_Left, Image.i = 0)
   AddElement(*this\tab\_s())
   Protected *tab._s_TAB = @*this\tab\_s()
   
   *tab\ID        = ID
   *tab\Width     = DesktopScaledX(Width)
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

Procedure DrawTab(*tab._s_TAB, currentDrawX.i, gadgetHeight.i, isDragged.b)
   Protected contentW.i, txtW.i, imgW.i, imgH.i
   ; Масштабируем пиксельные отступы под системный DPI
   Protected iconSpacing.i = DesktopScaledX(6) 
   Protected padding.i = DesktopScaledX(8)
   
   ; 1. Отрисовка фона вкладки
   If isDragged
      Box(currentDrawX, 0, *tab\Width, gadgetHeight, RGBA(255, 0, 0, 160)) ; Летящая
   Else
      Box(currentDrawX, 0, *tab\Width, gadgetHeight, RGBA(128, 128, 128, 255)) ; Статичная
   EndIf
   
   ; Размеры текста из TextWidth() возвращаются с учетом DPI шрифта холста
   txtW = TextWidth(*tab\txt\Text)
   
   If IsImage(*tab\img\Image)
      ; ВНИМАНИЕ: картинка УЖЕ растянута через ResizeImage, 
      ; поэтому берем ее реальную ширину и высоту БЕЗ DesktopScaled!
      imgW = ImageWidth(*tab\img\Image)
      imgH = ImageHeight(*tab\img\Image)
      contentW = imgW + iconSpacing + txtW
   Else
      contentW = txtW
   EndIf
   
   ; 1. ВНЕШНЕЕ ПОЗИЦИОНИРОВАНИЕ ВСЕГО БЛОКА ВНУТРИ ВКЛАДКИ
   Protected blockX.i = currentDrawX + GetAlignPosition(*tab\align, *tab\Width, contentW, padding)
   
   ; 2. ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ ПОРЯДКА ЭЛЕМЕНТОВ
   Protected ImgX.i, TxtX.i
   
   If *tab\align & #__flag_Right
      ; Направление RIGHT: Текст слева, Иконка справа
      TxtX = blockX
      ImgX = blockX + txtW + Bool(txtW)*iconSpacing
   Else
      ; Направление LEFT / По умолчанию: Иконка слева, Текст справа
      ImgX = blockX
      TxtX = blockX + imgW + Bool(imgW)*iconSpacing
   EndIf
   
   ; Вывод графики на Canvas (с вертикальным центрованием по Y)
   If IsImage(*tab\img\Image)
      ; Отрисовываем картинку 1:1, так как ее физический размер уже правильный
      DrawAlphaImage(ImageID(*tab\img\Image), ImgX, (gadgetHeight - imgH) / 2)
   EndIf
   
   DrawText(TxtX, (gadgetHeight - TextHeight(*tab\txt\Text)) / 2, *tab\txt\Text, RGBA(255, 255, 255, 255))
EndProcedure

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDrawTabs(gadget.i, *this._s_WIDGET)
   Protected *tab._s_TAB
   Protected gHeight.i = DesktopScaledY(GadgetHeight(gadget))
   
   If Not StartDrawing(CanvasOutput(gadget))
      ProcedureReturn
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Box(0, 0, DesktopScaledY(GadgetWidth(gadget)), gHeight, RGBA(255, 255, 255, 255)) 
   
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
   
   ; Слой 1: Статичные
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      If *tab <> *this\tab\dragged
         DrawTab(*tab, *tab\X + *tab\offsetX, gHeight, #False)
      EndIf
   Next
   
   ; Слой 2: Летящая поверх
   If *this\tab\dragged
      DrawTab(*this\tab\dragged, *this\tab\dragged\X + *this\tab\dragged\offsetX, gHeight, #True)
   EndIf
   
   StopDrawing()
EndProcedure

; --- НАЖАТИЕ ЛЕВОЙ КНОПКИ ---
Procedure event_LeftButtonDown(*this._s_WIDGET, mx.i)
   Protected *current_tab._s_TAB
   Protected *tab._s_TAB
   
   *this\dragStartX = mx
   
   ; ЦИКЛ 1: Находим вкладку, на которую кликнули
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      If mx >= *tab\X And mx < *tab\X + *tab\Width
         *current_tab = *tab
         Break
      EndIf
   Next
   
   *this\tab\dragged = *current_tab
   
   ; ЦИКЛ 2: Выполняем раздвижку, лимиты и расчет стартового offsetX за один проход
   If *current_tab
      Protected accumulatedWidth.i = *this\tab\indent 
      Protected isBeforeDragged.b = #True 
      Protected stepWidth.i = *current_tab\Width + *this\tab\spacing
      
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         
         If *tab = *current_tab
            isBeforeDragged = #False 
            *tab\offsetX = mx - *this\dragStartX
            Continue ; Лимиты для dragged запишем сразу после цикла
         EndIf
         
         ; 1. Сдвигаем базовый X только для вкладок левее нажатой
         If isBeforeDragged
            *tab\X + stepWidth
         EndIf
         
         ; 2. Расчет лимитов хода (использует уже обновленный *tab\X)
         *tab\minOffset = accumulatedWidth - *tab\X
         *tab\maxOffset = accumulatedWidth - *tab\X + stepWidth
         accumulatedWidth + *tab\Width + *this\tab\spacing
         
         ; 3. Ваша оригинальная пропорция инициализации offsetX (использует обновленный *tab\X)
         *tab\offsetX = *tab\X - *current_tab\X - *current_tab\offsetX
         *tab\offsetX - stepWidth
         *tab\offsetX * stepWidth / (*tab\Width + *this\tab\spacing)
         
         ; Ограничители хода
         If *tab\offsetX < *tab\minOffset : *tab\offsetX = *tab\minOffset : EndIf
         If *tab\offsetX > *tab\maxOffset : *tab\offsetX = *tab\maxOffset : EndIf
      Next
      
      ; Финальная запись лимитов и проверка границ для самой перетаскиваемой вкладки
      *current_tab\minOffset = *this\tab\indent - *current_tab\X
      *current_tab\maxOffset = -*current_tab\X + accumulatedWidth
      
      If *current_tab\offsetX < *current_tab\minOffset : *current_tab\offsetX = *current_tab\minOffset : EndIf
      If *current_tab\offsetX > *current_tab\maxOffset : *current_tab\offsetX = *current_tab\maxOffset : EndIf
      
      ProcedureReturn #True
   EndIf
EndProcedure

; --- ДВИЖЕНИЕ МЫШИ ---
Procedure event_MouseMove(*this._s_WIDGET, mx.i)
   Protected *current_tab._s_TAB = *this\tab\dragged
   
   If *current_tab
      Protected *tab._s_TAB
      
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         
         If *tab = *current_tab
            *tab\offsetX = mx - *this\dragStartX
         Else
            *tab\offsetX = *tab\X - *current_tab\X - *current_tab\offsetX
            *tab\offsetX - (*current_tab\Width + *this\tab\spacing)
            *tab\offsetX * (*current_tab\Width + *this\tab\spacing) / (*tab\Width + *this\tab\spacing)
         EndIf
         
         If *tab\offsetX < *tab\minOffset : *tab\offsetX = *tab\minOffset : EndIf
         If *tab\offsetX > *tab\maxOffset : *tab\offsetX = *tab\maxOffset : EndIf
      Next
      ProcedureReturn #True
   EndIf
EndProcedure

; --- ОТПУСКАНИЕ ЛЕВОЙ КНОПКИ ---
Procedure event_LeftButtonUp(*this._s_WIDGET)
   Protected *current_tab._s_TAB = *this\tab\dragged
   
   If *current_tab
      Protected *tab._s_TAB
      
      ; Переносим визуальный сдвиг в постоянную координату X и обнуляем offsetX
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         *tab\X + *tab\offsetX
         *tab\offsetX = 0
      Next
      
      ; Сортируем список вкладок в памяти по их новым физическим координатам X
      SortStructuredList(*this\tab\_s(), #PB_Sort_Ascending, OffsetOf(_s_TAB\X), TypeOf(_s_TAB\X))
      
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
Define w = DesktopUnscaledX(MyThis\tab\totalWidth + MyThis\tab\indent)

If OpenWindow(#Win, 0, 0, w + 20, 60, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, w, 40)
   
   ReDrawTabs(#Canvas, @MyThis)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         Select EventType()
               
            Case #PB_EventType_LeftButtonDown
               If event_LeftButtonDown(@MyThis, GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX))
                  ReDrawTabs(#Canvas, @MyThis)
               EndIf
               
            Case #PB_EventType_MouseMove
               If event_MouseMove(@MyThis, GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX))
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
; CursorPosition = 190
; FirstLine = 206
; Folding = --------
; EnableXP
; DPIAware