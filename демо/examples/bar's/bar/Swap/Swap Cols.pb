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
  
  dragStartX.i     ; Точка захвата мыши
  
  align.a               
  indent.a              
  spacing.a             
  totalWidth.l          
  List _s._s_TAB()  ; Заголовки вкладок
EndStructure

; =====================================================================
; 3. ЛОГИКА АЛГОРИТМА И ОТРИСОВКИ
; =====================================================================

; Функция линейного расчета базовых координат X
Procedure UpdateTabs(*tabs._s_TABS)
  Protected currentX.i = *tabs\indent
  Protected *tab._s_TAB
  
  If *tabs\dragged = #Null
    ForEach *tabs\_s()
      *tab = @*tabs\_s()
      *tab\X = currentX
      *tab\offsetX = 0
      currentX + *tab\Width + *tabs\spacing
    Next
    *tabs\totalWidth = currentX - *tabs\spacing
  EndIf
EndProcedure

; Процедура добавления вкладки
; Обновленная процедура добавления вкладки с поддержкой иконок и выравнивания
Procedure AddTab(*tabs._s_TABS, id.i, Text.s, width.i, align.a = #__flag_Left, Image.i = 0)
   AddElement(*tabs\_s())
   Protected *tab._s_TAB = @*tabs\_s()
   
   *tab\ID        = id
   *tab\Width     = width
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

; ИСПРАВЛЕННАЯ СИММЕТРИЧНАЯ ОТРИСОВКА ОДНОЙ ВКЛАДКИ
Procedure DrawTab(*tab._s_TAB, currentDrawX.i, gadgetHeight.i, isDragged.b)
  Protected contentW.i, txtW.i, imgW.i, imgH.i
  Protected iconSpacing.i = 6 
  
  ; 1. Отрисовка фона вкладки
  If isDragged
    Box(currentDrawX, 0, *tab\Width, gadgetHeight, RGBA(255, 0, 0, 160)) ; Летящая
  Else
    Box(currentDrawX, 0, *tab\Width, gadgetHeight, RGBA(128, 128, 128, 255)) ; Статичная
  EndIf
  
  ; Вычисляем чистые размеры текста и картинки
  txtW = TextWidth(*Tab\txt\Text)
  If IsImage(*tab\img\Image)
    imgW = ImageWidth(*tab\img\Image)
    imgH = ImageHeight(*tab\img\Image)
    contentW = imgW + iconSpacing + txtW
  Else
    contentW = txtW
  EndIf
  
    ; 1. ВНЕШНЕЕ ПОЗИЦИОНИРОВАНИЕ ВСЕГО БЛОКА ВНУТРИ ВКЛАДКИ (Через отлаженную процедуру)
  Protected blockX.i = currentDrawX + GetAlignPosition(*tab\align, *tab\Width, contentW, 8)
  
  ; 2. ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ ПОРЯДКА ЭЛЕМЕНТОВ (Ваш лаконичный вариант)
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
    DrawAlphaImage(ImageID(*tab\img\Image), ImgX, (gadgetHeight - imgH) / 2)
  EndIf
  
  DrawText(TxtX, (gadgetHeight - TextHeight(*tab\txt\Text)) / 2, *tab\txt\Text, RGBA(255, 255, 255, 255))
EndProcedure

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDrawTabs(gadget.i, *tabs._s_TABS)
   Protected *tab._s_TAB
   Protected gHeight.i = GadgetHeight(gadget)
   
   If Not StartDrawing(CanvasOutput(gadget))
      ProcedureReturn
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Box(0, 0, GadgetWidth(gadget), gHeight, RGBA(255, 255, 255, 255)) 
   
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
   
   ; Слой 1: Статичные
   ForEach *tabs\_s()
      *tab = @*tabs\_s()
      If *tab <> *tabs\dragged
         DrawTab(*tab, *tab\X + *tab\offsetX, gHeight, #False)
      EndIf
   Next
   
   ; Слой 2: Летящая поверх
   If *tabs\dragged
      DrawTab(*tabs\dragged, *tabs\dragged\X + *tabs\dragged\offsetX, gHeight, #True)
   EndIf
   
   StopDrawing()
EndProcedure

; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

Define MyTabs._s_TABS
MyTabs\indent = 50 ; Отступ панели слева
MyTabs\spacing = 2 ; Расстояние между вкладками

; Наполняем вашим тестовым набором
AddTab(@MyTabs, 0, "0 - 60", 60)
AddTab(@MyTabs, 1, "1 - 160", 160, #__flag_Center, 1)
AddTab(@MyTabs, 2, "2 - 150", 150, #__flag_Right, 1)
AddTab(@MyTabs, 3, "3 - 90", 90,0, 1)
UpdateTabs(@MyTabs)

#Win = 0
#Canvas = 0

If OpenWindow(#Win, 0, 0, MyTabs\totalWidth + 20 + MyTabs\indent, 60, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(#Canvas, 10, 10, MyTabs\totalWidth + MyTabs\indent, 40)
  
  ReDrawTabs(#Canvas, @MyTabs)
  
  Repeat
    Define Event = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget And EventGadget() = #Canvas
      Define mx.i = GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX)
      Define type.i = EventType()
      Define *tab._s_TAB ; Единый указатель *tab используется теперь и в событиях
      
      Select type
          
        Case #PB_EventType_LeftButtonDown
          MyTabs\dragStartX = mx
          ForEach MyTabs\_s()
            *tab = @MyTabs\_s()
            If mx >= *tab\X And mx < *tab\X + *tab\Width
              MyTabs\dragged = *tab
              Break
            EndIf
          Next
          
          If MyTabs\dragged
            ForEach MyTabs\_s()
              *tab = @MyTabs\_s()
              If *tab = MyTabs\dragged : Break : EndIf
              *tab\X + MyTabs\dragged\Width + MyTabs\spacing
            Next
            
            Define accumulatedWidth.i = MyTabs\indent 
            ForEach MyTabs\_s()
              *tab = @MyTabs\_s()
              If *tab <> MyTabs\dragged
                *tab\minOffset = accumulatedWidth - *tab\X
                *tab\maxOffset = accumulatedWidth - *tab\X + MyTabs\dragged\Width + MyTabs\spacing
                accumulatedWidth + *tab\Width + MyTabs\spacing
              EndIf
            Next
            
            MyTabs\dragged\minOffset = MyTabs\indent - MyTabs\dragged\X
            MyTabs\dragged\maxOffset = -MyTabs\dragged\X + accumulatedWidth
          EndIf
          
        Case #PB_EventType_MouseMove
          If MyTabs\dragged
            ForEach MyTabs\_s()
              *tab = @MyTabs\_s()
              
              If *tab = MyTabs\dragged
                *tab\offsetX = mx - MyTabs\dragStartX
              Else
                *tab\offsetX = *tab\X - MyTabs\dragged\X - MyTabs\dragged\offsetX
                *tab\offsetX - (MyTabs\dragged\Width + MyTabs\spacing)
                *tab\offsetX * (MyTabs\dragged\Width + MyTabs\spacing) / (*tab\Width + MyTabs\spacing)
              EndIf
              
              If *tab\offsetX < *tab\minOffset : *tab\offsetX = *tab\minOffset : EndIf
              If *tab\offsetX > *tab\maxOffset : *tab\offsetX = *tab\maxOffset : EndIf
            Next
            ReDrawTabs(#Canvas, @MyTabs)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MyTabs\dragged
            ForEach MyTabs\_s()
              *tab = @MyTabs\_s()
              *tab\X + *tab\offsetX
              *tab\offsetX = 0
            Next
            SortStructuredList(MyTabs\_s(), #PB_Sort_Ascending, OffsetOf(_s_TAB\X), TypeOf(_s_TAB\X))
            MyTabs\dragged = #Null
            UpdateTabs(@MyTabs)
            ReDrawTabs(#Canvas, @MyTabs)
          EndIf
          
      EndSelect
    EndIf
    
  Until Event = #PB_Event_CloseWindow
EndIf




; EnableExplicit
; 
; ; =====================================================================
; ; 1. КОНСТАНТЫ И ФЛАГИ (Для будущих настроек гаджета)
; ; =====================================================================
; #__align_Left   = 0
; #__align_Center = 1
; #__align_Right  = 2
; 
; ; ==========================================
; ; СТРУКТУРЫ ДАННЫХ
; ; ==========================================
; 
; Structure _s_TXT
;    Text.s
; EndStructure
; 
; Structure _s_COL 
;    X.i              ; Логический базовый X вкладки (её "домашняя" позиция)
;    Width.i          ; Ширина вкладки в пикселях
;    ID.i             ; Уникальный номер элемента данных (не меняется при перестановках)
;    txt._s_TXT
;    img.i
;    align.a          
;    mask.q           
;    
;    ; --- МАТЕМАТИЧЕСКИЙ ДВИЖОК ЭФФЕКТА ---
;    offsetX.i        ; Динамический сдвиг на экране относительно базового X. 
;                     ; Именно он заставляет вкладку плавно "плыть".
;    minOffset.i      ; Крайняя левая граница, дальше которой вкладка физически не может уйти
;    maxOffset.i      ; Крайняя правая граница движения
; EndStructure
; 
; Structure _s_TAB Extends _s_COL 
;    text_x.l 
; EndStructure
; 
; Structure _s_TABS
;    *active._s_TAB   
;    *dragged._s_TAB  ; Указатель на структуру вкладки, которую мы сейчас держим мышкой
;    
;    dragStartX.i     ; Точка на Canvas, где находился курсор мыши в момент клика
;    
;    align.a               
;    indent.a              
;    spacing.a             
;    totalWidth.l          
;    List _s._s_TAB()  
; EndStructure
; 
; ; ==========================================
; ; ЛОГИКА АЛГОРИТМА
; ; ==========================================
; 
; ; Функция чистой расстановки вкладок (выстраивает их по цепочке «друг за другом»)
; Procedure UpdateTabs(*tabs._s_TABS)
;    Protected currentX.i = *tabs\indent
;    Protected *tab._s_TAB
;    
;    ; Расчет делаем только если сейчас ничего не перетаскивается
;    If *tabs\dragged = #Null
;       ForEach *tabs\_s()
;          *tab = @*tabs\_s()     ; Берем прямой адрес текущего элемента из списка
;          *tab\X = currentX      ; Присваиваем ему логический X
;          *tab\offsetX = 0       ; В покое никакого визуального сдвига нет
;          currentX + *tab\Width + *tabs\spacing ; Высчитываем стартовую точку для следующего соседа
;       Next
;       *tabs\totalWidth = currentX - *tabs\spacing ; Запоминаем общую ширину всей панели
;    EndIf
; EndProcedure
; 
; Procedure AddTab(*tabs._s_TABS, id.i, Text.s, width.i, align.q=0)
;    AddElement(*tabs\_s())
;    Protected *tab._s_TAB = @*tabs\_s()
;    *tab\ID = id
;    *tab\txt\Text = Text
;    *tab\Width = width
;    *tab\align = align
; EndProcedure
; 
; ; Процедура отрисовки. Она разделена на 2 слоя, чтобы "летящая" вкладка не перекрывалась статичными.
; Procedure DrawTabs(gadget.i, *tabs._s_TABS)
;    Protected *tab._s_TAB
;    Protected textW.i, currentDrawX.i
;    
;    If Not StartDrawing(CanvasOutput(gadget))
;       ProcedureReturn
;    EndIf
;    
;    ; 1. Включаем режим слияния цветов (для полупрозрачности)
;    DrawingMode(#PB_2DDrawing_AlphaBlend)
;    Box(0, 0, GadgetWidth(gadget), GadgetHeight(gadget), RGBA(255, 255, 255, 255)) ; Чистим фон в белый
;    
;    DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
;    
;    ; СЛОЙ 1: Рисуем все вкладки, которые стоят на месте (или расступаются)
;    ForEach *tabs\_s()
;       *tab = @*tabs\_s()
;       ; Если этот адрес памяти не совпадает с адресом удерживаемой вкладки — рисуем её
;       If *tab <> *tabs\dragged
;          ; Текущая визуальная координата X вкладки на экране
;          currentDrawX = *tab\X + *tab\offsetX
;          
;          ; Отрисовка геометрии вкладки
;          Box(currentDrawX, 0, *tab\Width, 20, RGBA(128, 128, 128, 255))
;          
;          ; --- РАСЧЕТ ВЫРАВНИВАНИЯ ТЕКСТА ---
;          textW = TextWidth(*tab\txt\Text) ; Измеряем ширину строки в пикселях
;          
;          Select *tab\align
;             Case #__align_Center
;                *tab\text_x = currentDrawX + (*tab\Width - textW) / 2
;             Case #__align_Right
;                *tab\text_x = currentDrawX + *tab\Width - textW - 8 ; 8 пикселей — отступ справа
;             Default ; #__align_Left
;                *tab\text_x = currentDrawX + 8                      ; 8 пикселей — отступ слева
;          EndSelect
;          
;          ; Рисуем текст в предрассчитанной координате text_x
;          DrawText(*tab\text_x, 2, *tab\txt\Text, RGBA(255, 255, 255, 255))
;       EndIf
;    Next
;    
;    ; СЛОЙ 2: Рисуем перетаскиваемую вкладку поверх всех остальных
;    If *tabs\dragged
;       ; Считаем её текущее положение на экране
;       currentDrawX = *tabs\dragged\X + *tabs\dragged\offsetX
;       
;       ; Рисуем её с альфа-каналом 160 (полупрозрачность ~40%), чтобы видеть подложку
;       Box(currentDrawX, 0, *tabs\dragged\Width, 20, RGBA(255, 0, 0, 160)) 
;       
;       ; Расчет выравнивания текста для летящей вкладки
;       textW = TextWidth(*tabs\dragged\txt\Text)
;       
;       Select *tabs\dragged\align
;          Case #__align_Center
;             *tabs\dragged\text_x = currentDrawX + (*tabs\dragged\Width - textW) / 2
;          Case #__align_Right
;             *tabs\dragged\text_x = currentDrawX + *tabs\dragged\Width - textW - 8
;          Default ; #__align_Left
;             *tabs\dragged\text_x = currentDrawX + 8
;       EndSelect
;       
;       DrawText(*tabs\dragged\text_x, 2, *tabs\dragged\txt\Text, RGBA(255, 255, 255, 255))
;    EndIf
;    
;    StopDrawing()
; EndProcedure
; 
; ; ==========================================
; ; ОКОННЫЙ ЦИКЛ СОБЫТИЙ
; ; ==========================================
; 
; Define MyTabs._s_TABS
; MyTabs\indent = 50
; MyTabs\spacing = 2
; 
; AddTab(@MyTabs, 0, "0 - 40", 40)
; AddTab(@MyTabs, 1, "1 - 140", 140, #__align_Center)
; AddTab(@MyTabs, 2, "2 - 70", 70)
; AddTab(@MyTabs, 3, "3 - 130", 130, #__align_Right)
; UpdateTabs(@MyTabs)
; 
; #Win = 0
; #Canvas = 0
; 
; If OpenWindow(#Win, 0, 0, MyTabs\totalWidth + 20 + MyTabs\indent, 40, "Анатомия Swap Tabs", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;    CanvasGadget(#Canvas, 10, 10, MyTabs\totalWidth + MyTabs\indent, 20)
;    DrawTabs(#Canvas, @MyTabs)
;    
;    Repeat
;       Define Event = WaitWindowEvent()
;       
;       If Event = #PB_Event_Gadget And EventGadget() = #Canvas
;          Define mx.i = GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX)
;          Define type.i = EventType()
;          Define *tab._s_TAB ; Технический указатель для итераций
;          
;          Select type
;                
;                ; ------------------------------------------------------------------
;                ; ТОЧКА А: КЛИК МЫШКИ (ПОДГОТОВКА ИЛЛЮЗИИ РАЗДВИГАНИЯ)
;                ; ------------------------------------------------------------------
;             Case #PB_EventType_LeftButtonDown
;                MyTabs\dragStartX = mx ; Запоминаем точку, где мышь впилась в Canvas
;                
;                ; Находим, по какому именно адресу памяти кликнули
;                ForEach MyTabs\_s()
;                   *tab = @MyTabs\_s()
;                   If mx >= *tab\X And mx < *tab\X + *tab\Width
;                      MyTabs\dragged = *tab ; Сохраняем указатель на зажатый элемент
;                      Break
;                   EndIf
;                Next
;                
;                If MyTabs\dragged
;                   
;                   ; МАТЕМАТИЧЕСКАЯ МАГИЯ №1:
;                   ; Мы виртуально "сдвигаем" базовые логические координаты всех элементов, 
;                   ; которые находятся СЛЕВА от зажатого, в правую сторону. 
;                   ; Зачем? Чтобы освободить пустое место в массиве координат, имитируя,
;                   ; что зажатая вкладка физически исчезла из общего строя.
;                   ForEach MyTabs\_s()
;                      *tab = @MyTabs\_s()
;                      If *tab = MyTabs\dragged : Break : EndIf
;                      *tab\X + MyTabs\dragged\Width + MyTabs\spacing
;                   Next
;                   
;                   ; МАТЕМАТИЧЕСКАЯ МАГИЯ №2: Расчет лимитов (min/max границ сдвига)
;                   ; Мы проходим по списку и жестко рассчитываем для каждой вкладки её персональные
;                   ; упоры. Эти упоры не дадут вкладкам вылететь за края панели Canvas или 
;                   ; налететь друг на друга сильнее, чем на ширину зажатой вкладки.
;                   Define accumulatedWidth.i = MyTabs\indent 
;                   ForEach MyTabs\_s()
;                      *tab = @MyTabs\_s()
;                      If *tab <> MyTabs\dragged
;                         *tab\minOffset = accumulatedWidth - *tab\X
;                         *tab\maxOffset = accumulatedWidth - *tab\X + MyTabs\dragged\Width + MyTabs\spacing
;                         accumulatedWidth + *tab\Width + MyTabs\spacing
;                      EndIf
;                   Next
;                   
;                   ; Выставляем персональные лимиты хода для самой перетаскиваемой вкладки
; ;                   MyTabs\dragged\minOffset = -MyTabs\dragged\X
; ;                   MyTabs\dragged\maxOffset = MyTabs\indent-MyTabs\dragged\X + accumulatedWidth
;                   MyTabs\dragged\minOffset = MyTabs\indent - MyTabs\dragged\X
;                   MyTabs\dragged\maxOffset = -MyTabs\dragged\X + accumulatedWidth
;                EndIf
;                
;                ; ------------------------------------------------------------------
;                ; ТОЧКА Б: ДВИЖЕНИЕ МЫШИ (РАБОТА СЕРДЦА АЛГОРИТМА)
;                ; ------------------------------------------------------------------
;             Case #PB_EventType_MouseMove
;                If MyTabs\dragged
;                   ForEach MyTabs\_s()
;                      *tab = @MyTabs\_s()
;                      
;                      If *tab = MyTabs\dragged
;                         ; Если это сама летящая вкладка — её сдвиг равен чистой дельте мыши
;                         *tab\offsetX = mx - MyTabs\dragStartX
;                      Else
;                         ; СЕРДЦЕ АЛГОРИТМА (СИНХРОННАЯ ПРОПОРЦИЯ):
;                         ; Эта математика высчитывает расстояние между текущим соседом и летящей вкладкой.
;                         ; Затем она делит это расстояние на ширину соседа.
;                         ; В результате сосед получает команду смещаться ровно на столько процентов,
;                         ; на сколько летящая вкладка приблизилась к его центру.
;                         *tab\offsetX = *tab\X - MyTabs\dragged\X - MyTabs\dragged\offsetX
;                         *tab\offsetX - (MyTabs\dragged\Width + MyTabs\spacing)
;                         *tab\offsetX * (MyTabs\dragged\Width + MyTabs\spacing) / (*tab\Width + MyTabs\spacing)
;                      EndIf
;                      
;                      ; ПРЕДОХРАНИТЕЛИ:
;                      ; Если математика выше из-за резкого движения мыши насчитала лишнего,
;                      ; эти условия жестко срезают сдвиг по рассчитанным в Точке А лимитам.
;                      If *tab\offsetX < *tab\minOffset : *tab\offsetX = *tab\minOffset : EndIf
;                      If *tab\offsetX > *tab\maxOffset : *tab\offsetX = *tab\maxOffset : EndIf
;                   Next
;                   
;                   DrawTabs(#Canvas, @MyTabs) ; Мгновенно перерисовываем
;                EndIf
;                
;                ; ------------------------------------------------------------------
;                ; ТОЧКА В: ОТПУСКАНИЕ МЫШИ (ФИКСАЦИЯ НОВОГО ПОРЯДКА)
;                ; ------------------------------------------------------------------
;             Case #PB_EventType_LeftButtonUp
;                If MyTabs\dragged
;                   
;                   ; Переносим временные визуальные сдвиги (offsetX) в постоянные координаты (X).
;                   ; То есть то, что было иллюзией на экране, становится реальным физическим значением X.
;                   ForEach MyTabs\_s()
;                      *tab = @MyTabs\_s()
;                      *tab\X + *tab\offsetX
;                      *tab\offsetX = 0 ; Обнуляем сдвиг, так как X теперь обновился
;                   Next
;                   
;                   ; СОРТИРОВКА СПИСКА:
;                   ; Так как во время движения мы физически не меняли элементы местами в памяти (чтобы не тормозить),
;                   ; их индексы в списке сейчас нарушены. 
;                   ; Эта встроенная функция PureBasic берет весь список и за наносекунды выстраивает элементы
;                   ; в правильном порядке, просто сравнивая их новые физические координаты X в оперативной памяти.
;                   SortStructuredList(MyTabs\_s(), #PB_Sort_Ascending, OffsetOf(_s_TAB\X), TypeOf(_s_TAB\X))
;                   ; Сбрасываем указатели в исходное состояние покоя
;                   MyTabs\dragged = #Null
;                   UpdateTabs(@MyTabs) ; Делаем финальный чистый пересчет "без швов"
;                   DrawTabs(#Canvas, @MyTabs)
;                EndIf
;          EndSelect
;       EndIf
;    Until Event = #PB_Event_CloseWindow
; EndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 126
; FirstLine = 112
; Folding = ------
; EnableXP
; DPIAware