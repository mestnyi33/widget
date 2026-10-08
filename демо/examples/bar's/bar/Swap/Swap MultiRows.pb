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
#__flag_Top    = 1
#__flag_Right  = 2
#__flag_Bottom = 3
#__flag_Center = 4

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
   row.l            ; Номер ряда, в котором сейчас находится вкладка (0, 1, 2...)
   
   ; Поля для идеальной математики плавного двумерного сдвига
   offsetX.i        ; Динамический визуальный сдвиг по оси X
   offsetY.i        ; Динамический визуальный сдвиг по оси Y
EndStructure

Structure _s_TABS
   *active._s_TAB   
   *press._s_TAB    ; Указатель на перетаскиваемую вкладку
   
   vertical.b       ; Будет использоваться для переключения глобальных режимов
   
   align.a               
   indent.a 
   spacing.a             
   
   TotalSize.i          
   List _s._s_TAB() ; Заголовки вкладок
EndStructure

Structure _s_WIDGET
   Tab._s_TABS
   dragOffSet.i     ; Точка захвата мыши по оси X
   dragOffSetY.i    ; Точка захвата мыши по оси Y
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

; Функция автоматического распределения вкладок по рядам (Multi-row)
Procedure UpdateTabs(*this._s_WIDGET, MaxWidth.i, RowHeight.i = 30, spacingY.i = 4)
   Protected curX.i = *this\tab\indent
   Protected curY.i = DesktopScaledY(10) ; Стартовый отступ сверху холста
   Protected current_row.l = 0
   Protected *tab._s_TAB
   
   If *this\tab\press = #Null
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         
         ; Если вкладка не помещается в текущем ряду по ширине, переносим на следующий
         If curX + *tab\Width > MaxWidth And curX > *this\tab\indent
            curX = *this\tab\indent
            curY + RowHeight + spacingY
            current_row + 1
         EndIf
         
         *tab\X = curX
         *tab\Y = curY
         *tab\Height = RowHeight
         *tab\row = current_row
         *tab\offsetX = 0
         *tab\offsetY = 0
         
         curX + *tab\Width + *this\tab\spacing
      Next
      ; Запоминаем общую высоту, занятую всеми рядами вкладок
      *this\tab\TotalSize = curY + RowHeight
   EndIf
EndProcedure

; Обновленная процедура с умным заполнением рядов без ложных переносов
Procedure _UpdateTabs(*this._s_WIDGET, MaxWidth.i, RowHeight.i = 30, spacingY.i = 4)
   Protected *tab._s_TAB
   Protected i.l, row.l, fitFound.b
   
   ; Создаем массив для отслеживания текущего заполнения X в каждом возможном ряду
   ; Поддерживаем до 20 рядов вкладок (этого более чем достаточно)
   Dim rowX.i(20)
   
   ; Инициализируем начальную координату X для всех рядов
   For i = 0 To 20
      rowX(i) = *this\tab\indent
   Next i
   
   If *this\tab\press = #Null
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         
         row = 0
         fitFound = #False
         
         ; Ищем САМЫЙ ПЕРВЫЙ ряд, начиная с нулевого, куда физически поместится текущая вкладка
         While row < 20
            If rowX(row) + *tab\Width <= MaxWidth
               fitFound = #True
               Break
            EndIf
            row + 1
         Wend
         
         ; Если в существующих рядах места нет, принудительно уходим на новый ряд
         If Not fitFound
            row = 0
            While row < 20
               If rowX(row) = *this\tab\indent
                  Break
               EndIf
               row + 1
            Wend
         EndIf
         
         ; Рассчитываем точные координаты на основе найденного ряда
         *tab\X = rowX(row)
         *tab\Y = 10 + row * (RowHeight + spacingY)
         *tab\Height = RowHeight
         *tab\row = row
         *tab\offsetX = 0
         *tab\offsetY = 0
         
         ; Сдвигаем координату X для этого конкретного ряда под следующую вкладку
         rowX(row) + *tab\Width + *this\tab\spacing
      Next
      
      ; Вычисляем общую высоту холста на основе самого нижнего занятого ряда
      Protected maxRow.l = 0
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         If *tab\row > maxRow
            maxRow = *tab\row
         EndIf
      Next
      
      *this\tab\TotalSize = 10 + (maxRow + 1) * (RowHeight + spacingY) - spacingY
   EndIf
EndProcedure

; Процедура добавления новой вкладки
Procedure AddTab(*this._s_WIDGET, ID.i, Text.s, size.i, align.a = #__flag_Left, Image.i = 0)
   Protected *tab._s_TAB = AddElement(*this\tab\_s())
   
   *tab\ID        = ID
   *tab\align     = align
   *tab\Width     = DesktopScaledX(size) ; В горизонтальном многорядном режиме size — это всегда ширина
   
   If Text
      *tab\txt\text  = Text
      *tab\txt\change = 1
   EndIf
   If IsImage(Image)
      *tab\img\image = Image 
      *tab\img\change = 1
   EndIf
EndProcedure

; Будущая рабочая процедура отрисовки отдельной вкладки
Procedure DrawTab(*tab._s_TAB, gWidth.i, gHeight.i, vertical.b, isDragged.b, isResize.b=0)
   Protected contentX.i, contentY.i, contentW.i, contentH.i
   
   ; Учитываем динамические смещения мыши при перетаскивании во все стороны
   Protected rx.i = *tab\x + *tab\offsetX
   Protected ry.i = *tab\y + *tab\offsetY
   
   ; UPDATE ROW
   If *tab\txt\change Or *tab\img\change Or isResize
      Protected padding.i = DesktopScaledX(8)
      Protected iconSpacing.i = 0
      
      ; 1. Замеры метрик
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
      
      ; Расчет отступа, если присутствуют оба элемента
      If (*tab\img\width Or *tab\img\height) And 
         (*tab\txt\Width Or *tab\txt\height)
         iconSpacing = DesktopScaledX(6)
      EndIf
      
      ; 2. ВНЕШНЕЕ ПОЗИЦИОНИРОВАНИЕ ВСЕГО БЛОКА ВНУТРИ ВКЛАДКИ
      ; Горизонтальный многорядный режим: складываем ширину, по высоте берем максимум
      contentW = *tab\img\width + *tab\txt\width + iconSpacing
      If *tab\img\height > *tab\txt\height
         contentH = *tab\img\height
      Else
         contentH = *tab\txt\height
      EndIf
      contentX = GetAlignPosition(*tab\align, *tab\Width, contentW, padding)
      contentY = GetAlignPosition(*tab\align, *tab\Height, contentH, padding)
      
      ; 3. ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ
      If *tab\txt\change Or isResize
         *tab\txt\y = (*tab\Height - *tab\txt\height) >> 1
         If *tab\align & #__flag_Right
            *tab\txt\x = contentX
         Else
            *tab\txt\x = contentX + *tab\img\width
            If *tab\img\width : *tab\txt\x + iconSpacing : EndIf
         EndIf
         *tab\txt\change = 0
      EndIf
      If *tab\img\change Or isResize
         *tab\img\y = (*tab\Height - *tab\img\height) >> 1
         If *tab\align & #__flag_Right
            *tab\img\x = contentX + *tab\txt\width
            If *tab\txt\width : *tab\img\x + iconSpacing : EndIf
         Else
            *tab\img\x = contentX
         EndIf
         *tab\img\change = 0
      EndIf
   EndIf
   
   ; DRAW ROW
   ; 1. ОТРИСОВКА ФОНА
   If isDragged
      Box(rx, ry, *tab\Width, *tab\Height, $A00000FF) ; Синий цвет для летящей вкладки
   Else
      Box(rx, ry, *tab\Width, *tab\Height, $FF808080) ; Серый для статичных
   EndIf
   
   ; 2. ОТРИСОВКА ИКОНКИ
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
         DrawTab(*tab, gWidth, gHeight, vertical, #False)
      EndIf
   Next
   
   ; Слой 2: Летящая поверх остальных
   If *current_tab
      DrawTab(*current_tab, gWidth, gHeight, vertical, #True)
   EndIf
EndProcedure

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDrawTabs(Gadget.i, *this._s_WIDGET)
   Protected gWidth.i = DesktopScaledX(GadgetWidth(Gadget))
   Protected gHeight.i = DesktopScaledY(GadgetHeight(Gadget))
   
   If Not StartDrawing(CanvasOutput(Gadget))
      ProcedureReturn
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Box(0, 0, gWidth, gHeight, RGBA(255, 255, 255, 255)) 
   
   DrawTabs(*this, *this\tab\press, gWidth, gHeight)
   
   StopDrawing()
EndProcedure

; Вспомогательный алгоритм геометрического расстояния между центрами двух вкладок
Procedure.f GetTabDistance(x1.i, y1.i, w1.i, h1.i, x2.i, y2.i, w2.i, h2.i)
   Protected cx1.f = x1 + w1 / 2
   Protected cy1.f = y1 + h1 / 2
   Protected cx2.f = x2 + w2 / 2
   Protected cy2.f = y2 + h2 / 2
   
   Protected dx.f = cx1 - cx2
   Protected dy.f = cy1 - cy2
   
   ProcedureReturn Sqr(dx * dx + dy * dy)
EndProcedure


Procedure DoTabEvents(*this._s_WIDGET, event.i, mx.i, my.i, MaxWidth.i = 400)
   Protected *current_tab._s_TAB = *this\tab\press
   Protected *tab._s_TAB
   Protected minDistance.f = 999999.0
   Protected targetIndex.i = -1
   Protected currentIndex.i = 0
   
   Select event
         
      Case #PB_EventType_LeftButtonDown
         ; ЦИКЛ 1: Находим вкладку по двумерной сетке, на которую кликнули
         ForEach *this\tab\_s()
            *tab = @*this\tab\_s()
            If mx >= *tab\X And mx < *tab\X + *tab\Width And my >= *tab\Y And my < *tab\Y + *tab\Height
               *current_tab = *tab
               Break
            EndIf
         Next
         
         *this\tab\press = *current_tab
         
         ; Инициализируем двумерные точки захвата мыши внутри выбранного прямоугольника
         If *current_tab
            *this\dragOffSet  = mx - *current_tab\X
            *this\dragOffSetY = my - *current_tab\Y
            
            ; Обнуляем визуальные смещения для всех вкладок, подготавливая к движению
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               If *tab <> *current_tab
                  *tab\offsetX = 0
                  *tab\offsetY = 0
               EndIf
            Next
            ProcedureReturn #True
         EndIf
      Case #PB_EventType_MouseMove
         If *current_tab
            ; Свободно перемещаем вкладку вслед за курсором мыши по двум осям
            *current_tab\offsetX = mx - *current_tab\X - *this\dragOffSet
            *current_tab\offsetY = my - *current_tab\Y - *this\dragOffSetY
            ProcedureReturn #True
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         If *current_tab
            ; Вычисляем, где физически на экране находится центр брошенной вкладки
            Protected DropX.i = *current_tab\X + *current_tab\offsetX
            Protected DropY.i = *current_tab\Y + *current_tab\offsetY
            
            currentIndex = 0
            targetIndex = -1
            
            ; Ищем геометрически ближайшего соседа по двум осям
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               If *tab <> *current_tab
                  Protected dist.f = GetTabDistance(DropX, DropY, *current_tab\Width, *current_tab\Height, *tab\X, *tab\Y, *tab\Width, *tab\Height)
                  If dist < minDistance
                     minDistance = dist
                     targetIndex = currentIndex
                  EndIf
               EndIf
               currentIndex + 1
            Next
            
            ; Переставляем элемент в связанном списке на позицию перед найденным соседом
            If targetIndex <> -1
               SelectElement(*this\tab\_s(), targetIndex)
               MoveElement(*this\tab\_s(), #PB_List_Before, *current_tab)
            EndIf
            
            ; Сбрасываем флаг удержания и пересчитываем сетку рядов заново
            *this\tab\press = #Null
            UpdateTabs(*this, MaxWidth, DesktopScaledX(30), DesktopScaledX(4))
            ProcedureReturn #True
         EndIf
         
   EndSelect
   ProcedureReturn #False
EndProcedure

; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

Define MyThis._s_WIDGET
MyThis\tab\vertical = 0
MyThis\tab\indent = DesktopScaledX(10)  ; Отступ панели слева
MyThis\tab\spacing = DesktopScaledX(4) ; Расстояние между вкладками

; Наполняем тестовым набором вкладок
AddTab(@MyThis, 0, "0 - 100", 100)
AddTab(@MyThis, 1, "1 - 160", 160, #__flag_Center, 1)
AddTab(@MyThis, 2, "2 - 150", 150, #__flag_Right, 1)
AddTab(@MyThis, 3, "3 - 120", 120, 0, 1)

; Задаем фиксированную тестовую ширину Canvas, чтобы вкладки гарантированно разбились на 2 ряда
Define w = 350 

; Первичный расчет многорядной сетки
UpdateTabs(@MyThis, DesktopScaledX(w), DesktopScaledY(30), DesktopScaledX(4))

; Высота Canvas подстраивается автоматически под количество получившихся рядов
Define h = MyThis\tab\TotalSize + 20
 
#Win = 0
#Canvas = 0

If OpenWindow(#Win, 0, 0, w + 20, h + 20, "Многорядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, w, h)
   
   ReDrawTabs(#Canvas, @MyThis)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         
         ; Передаем текущую доступную ширину w в обработчик событий для правильного расчета
         If DoTabEvents(@MyThis, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY), DesktopScaledX(w))
            ; Если высота рядов изменилась в процессе (например, изменился порядок), адаптируем размер Canvas
            If GadgetHeight(#Canvas) <> MyThis\tab\TotalSize + DesktopScaledY(20)
               ResizeGadget(#Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, MyThis\tab\TotalSize + DesktopScaledY(20))
            EndIf
            ReDrawTabs(#Canvas, @MyThis)
         EndIf
         
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 114
; FirstLine = 77
; Folding = -----------
; EnableXP
; DPIAware