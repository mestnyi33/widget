EnableExplicit

; ==========================================
; СТРУКТУРЫ ДАННЫХ
; ==========================================

Structure CUSTOM_COLUMN
  Title.s       ; Заголовок колонки
  Width.i       ; Ширина в пикселях
EndStructure

Structure CUSTOM_ITEM
   Array CellText.s(0) ; Динамический массив строк. Никаких жестких лимитов!
  Level.i         ; Уровень вложенности (0 = корень, 1 = подветка и т.д.)
  IsExpanded.b    ; Развернута ли ветка (только для Tree)
  HasChildren.b   ; Есть ли у элемента дети (нужно ли рисовать стрелочку)
  IsSelected.b    ; Выделен ли элемент
  IsVisible.b     ; Виден ли элемент в данный момент (зависит от того, свернуты ли родители)
EndStructure

Structure CUSTOM_GADGET
  CanvasID.i      ; ID Canvas-гаджета
  ItemHeight.i    ; Высота строки
  HeaderHeight.i  ; Высота шапки
  ScrollY.i       ; Смещение скролла по вертикали
  SelectedIdx.i   ; Индекс выбранной строки (-1 если нет)
  IndentSize.i    ; Размер отступа для уровней дерева (в пикселях)
  X.l
  Y.l
  Width.l
  Height.l
  List Columns.CUSTOM_COLUMN() ; Список колонок (для ListIcon)
  List Items.CUSTOM_ITEM()     ; Список всех элементов (и для Tree, и для ListIcon)
EndStructure

Global MyControl.CUSTOM_GADGET

; ==========================================
; ПРОЦЕДУРЫ УПРАВЛЕНИЯ ДАННЫМИ (API)
; ==========================================

; Шаг 1: Инициализация гаджета
Procedure CustomControl_Init(*Gadget.CUSTOM_GADGET, CanvasGadget.i, ItemHeight.i = 24, HeaderHeight.i = 28)
  *Gadget\CanvasID = CanvasGadget
  *Gadget\ItemHeight = ItemHeight
  *Gadget\HeaderHeight = HeaderHeight
  *Gadget\ScrollY = 0
  *Gadget\SelectedIdx = -1
  *Gadget\IndentSize = 20 ; Отступ ветки дерева на один уровень
  ClearList(*Gadget\Columns())
  ClearList(*Gadget\Items())
EndProcedure

; Шаг 2: Добавление колонки (AddColumn - для ListIcon / TreeGrid)
Procedure CustomControl_AddColumn(*Gadget.CUSTOM_GADGET, Title.s, Width.i)
  AddElement(*Gadget\Columns())
  *Gadget\Columns()\Title = Title
  *Gadget\Columns()\Width = Width
EndProcedure

; Шаг 3: Добавление элемента (AddItem - универсальный для дерева и списка)
Procedure CustomControl_AddItem(*Gadget.CUSTOM_GADGET, Text.s, Level.i = 0, HasChildren.b = #False)
  AddElement(*Gadget\Items())
  *Gadget\Items()\Level = Level
  *Gadget\Items()\HasChildren = HasChildren
  *Gadget\Items()\IsExpanded = #False
  *Gadget\Items()\IsVisible = #True
  
  ; 1. Считаем реальное количество колонок в переданной строке
  Protected Count.i = CountString(Text, Chr(10)) + 1
  
  ; 2. Инициализируем массив строго под это количество
  Dim *Gadget\Items()\CellText(Count - 1)
  
  ; 3. Заполняем массив один раз
  Protected i.i
  For i = 0 To Count - 1
    *Gadget\Items()\CellText(i) = StringField(Text, i + 1, Chr(10))
  Next
EndProcedure

; Шаг 4: Обновление видимости элементов дерева (UpdateVisibility)
; Процедура проходит по дереву и прячет элементы, чьи родители свернуты
Procedure CustomControl_UpdateVisibility(*Gadget.CUSTOM_GADGET)
  Protected IsParentCollapsed.b = #False
  Protected CollapsedLevel.i = 0
  
  ForEach *Gadget\Items()
    If IsParentCollapsed
      If *Gadget\Items()\Level > CollapsedLevel
        *Gadget\Items()\IsVisible = #False
        Continue
      Else
        IsParentCollapsed = #False ; Мы вышли из свернутой ветки
      EndIf
    EndIf
    
    *Gadget\Items()\IsVisible = #True
    
    ; Если этот элемент сам свернут и у него есть дети, то все следующие элементы с большим Level будут скрыты
    If *Gadget\Items()\HasChildren And *Gadget\Items()\IsExpanded = #False
      IsParentCollapsed = #True
      CollapsedLevel = *Gadget\Items()\Level
    EndIf
  Next
EndProcedure


; ==========================================
; ПРОЦЕДУРЫ ОТРИСОВКИ (RENDER)
; ==========================================

; Шаг 5: Отрисовка базовой ячейки текста (DrawCell)
Procedure CustomControl_DrawCell(Text.s, X.i, Y.i, Width.i, Height.i, ColorText.i, ColorBg.i, IsHeader.b = #False)
  ClipOutput(X, Y, Width, Height)
  DrawingMode(#PB_2DDrawing_Default)
  Box(X, Y, Width, Height, ColorBg)
  
  If IsHeader
    Line(X, Y + Height - 1, Width, 1, $A0A0A0) ; Граница шапки снизу
    Line(X + Width - 1, Y, 1, Height, $A0A0A0) ; Граница шапки справа
  EndIf
  
  DrawText(X + 6, Y + (Height - TextHeight(Text)) / 2, Text, ColorText, ColorBg)
  UnclipOutput()
EndProcedure

; Шаг 6: Отрисовка узла дерева / стрелочки (DrawExpander)
Procedure CustomControl_DrawExpander(X.i, Y.i, Size.i, IsExpanded.b)
  Protected CenterY.i = Y + Size / 2
  Protected CenterX.i = X + Size / 2
  
  DrawingMode(#PB_2DDrawing_Default)
  ; Рисуем маленький треугольник/стрелочку в зависимости от состояния ветки
  If IsExpanded
    ; Стрелочка вниз
    LineXY(CenterX - 4, CenterY - 2, CenterX + 4, CenterY - 2, $555555)
    LineXY(CenterX - 4, CenterY - 2, CenterX, CenterY + 3, $555555)
    LineXY(CenterX + 4, CenterY - 2, CenterX, CenterY + 3, $555555)
  Else
    ; Стрелочка вправо
    LineXY(CenterX - 2, CenterY - 4, CenterX - 2, CenterY + 4, $555555)
    LineXY(CenterX - 2, CenterY - 4, CenterX + 3, CenterY, $555555)
    LineXY(CenterX - 2, CenterY + 4, CenterX + 3, CenterY, $555555)
  EndIf
EndProcedure

; Шаг 7: Отрисовка строки элемента (DrawItem)
Procedure CustomControl_DrawItem(*Gadget.CUSTOM_GADGET, Index.i, Y.i)
  SelectElement(*Gadget\Items(), Index)
  
  ; Узнаем ширину первой колонки (где рисуется базовое дерево)
  SelectElement(*Gadget\Columns(), 0)
  Protected TreeColWidth.i = *Gadget\Columns()\Width
  
  ; 1. Рисуем базовое дерево в первой колонке (текст берется из CellText(0))
  ; Для этого временно подменяем поле Text, либо переписываем CustomTree_DrawItem на чтение CellText(0)
  Protected MainText.s = ""
  If ArraySize(*Gadget\Items()\CellText()) >= 0
    MainText = *Gadget\Items()\CellText(0)
  EndIf
  
  ; Отрисовка фона первой ячейки (дерева)
  Protected ColorBg.i = $FFFFFF, ColorTxt.i = $000000
  If *Gadget\Items()\IsSelected
    ColorBg = $E68B23 : ColorTxt = $FFFFFF
  ElseIf Index % 2 = 0
    ColorBg = $F9F9F9
  EndIf
  
  Box(*Gadget\X, Y, TreeColWidth, *Gadget\ItemHeight, ColorBg)
  
  ; Отрисовка стрелочки дерева
  Protected TreeOffset.i = *Gadget\Items()\Level * *Gadget\IndentSize
  If *Gadget\Items()\HasChildren
    CustomControl_DrawExpander(*Gadget\X + TreeOffset + 4, Y, *Gadget\ItemHeight, *Gadget\Items()\IsExpanded)
  EndIf
  
  ; Вывод текста первой колонки дерева
  ClipOutput(*Gadget\X + TreeOffset + 20, Y, TreeColWidth - TreeOffset - 20, *Gadget\ItemHeight)
  DrawText(*Gadget\X + TreeOffset + 20, Y + (*Gadget\ItemHeight - TextHeight(MainText)) / 2, MainText, ColorTxt, ColorBg)
  UnclipOutput()
  
  ; 2. ДОРИСОВЫВАЕМ ОСТАЛЬНЫЕ КОЛОНКИ (Берем данные из массива напрямую)
  Protected X.i = *Gadget\X + TreeColWidth
  Protected ColIdx.i
  Protected TotalCols.i = ListSize(*Gadget\Columns())
  
  For ColIdx = 1 To TotalCols - 1
    SelectElement(*Gadget\Columns(), ColIdx)
    
    ; Безопасно извлекаем текст из массива по индексу колонки
    Protected CellText.s = ""
    If ColIdx <= ArraySize(*Gadget\Items()\CellText())
      CellText = *Gadget\Items()\CellText(ColIdx)
    EndIf
    
    ; Отрисовываем ячейку таблицы без лишних вычислений парсинга строки
    CustomControl_DrawCell(CellText, X, Y, *Gadget\Columns()\Width, *Gadget\ItemHeight, ColorTxt, ColorBg, #False)
    X + *Gadget\Columns()\Width
  Next
  
  ; Разделительная линия снизу строки
  Line(*Gadget\X, Y + *Gadget\ItemHeight - 1, *Gadget\X + *Gadget\Width, 1, $E0E0E0)
EndProcedure

; Шаг 8: Отрисовка шапки колонок (DrawHeader)
Procedure CustomControl_DrawHeader(*Gadget.CUSTOM_GADGET)
  Protected X.i = 0
  ForEach *Gadget\Columns()
    CustomControl_DrawCell(*Gadget\Columns()\Title, X, 0, *Gadget\Columns()\Width, *Gadget\HeaderHeight, $000000, $E0E0E0, #True)
    X + *Gadget\Columns()\Width
  Next
EndProcedure

; Шаг 9: Главный рендер контрола (Redraw)
Procedure CustomControl_Redraw(*Gadget.CUSTOM_GADGET)
  Protected i.i
  Protected CurrentY.i = *Gadget\HeaderHeight
  
  If StartDrawing(CanvasOutput(*Gadget\CanvasID))
    ; Очистка фона
    Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF)
    
    ; Отрисовка только видимых элементов с учетом скролла
    Protected VisibleRowIdx.i = 0
    For i = 0 To ListSize(*Gadget\Items()) - 1
      SelectElement(*Gadget\Items(), i)
      
      ; Пропускаем элементы, скрытые свернутыми ветками дерева
      If *Gadget\Items()\IsVisible = #False : Continue : EndIf
      
      Protected ItemY.i = CurrentY + (VisibleRowIdx * *Gadget\ItemHeight) - *Gadget\ScrollY
      
      ; Отрезаем невидимое за границами экрана
      If ItemY + *Gadget\ItemHeight > *Gadget\HeaderHeight And ItemY < OutputHeight()
        CustomControl_DrawItem(*Gadget, i, ItemY)
      EndIf
      
      VisibleRowIdx + 1
    Next
    
    ; Рисуем шапку поверх всего
    CustomControl_DrawHeader(*Gadget)
    StopDrawing()
  EndIf
EndProcedure



; ==========================================
; ОБРАБОТКА СОБЫТИЙ (EVENTS / CALLBACK)
; ==========================================

; Шаг 10: Полная процедура обработки кликов и развертывания дерева
Procedure CustomControl_Callback()
  Protected Gadget.i = EventGadget()
  Protected MouseX.i = GetGadgetAttribute(Gadget, #PB_Canvas_MouseX)
  Protected MouseY.i = GetGadgetAttribute(Gadget, #PB_Canvas_MouseY)
  Protected EventType.i = EventType()
  
  Select EventType
    Case #PB_EventType_LeftButtonDown
      ; Проверяем, что кликнули ниже шапки (заголовка таблицы)
      If MouseY > MyControl\HeaderHeight
        
        ; 1. Находим, на какой ИМЕННО ВИДИМЫЙ элемент нажали
        Protected VisibleRowIdx.i = 0
        Protected RealIdx.i = -1
        Protected i.i
        
        For i = 0 To ListSize(MyControl\Items()) - 1
          SelectElement(MyControl\Items(), i)
          
          ; Проверяем только те элементы, которые сейчас развернуты и видны
          If MyControl\Items()\IsVisible
            Protected ItemY.i = MyControl\HeaderHeight + (VisibleRowIdx * MyControl\ItemHeight) - MyControl\ScrollY
            
            ; Если координаты мыши попали в эту строку
            If MouseY >= ItemY And MouseY < ItemY + MyControl\ItemHeight
              RealIdx = i
              Break
            EndIf
            VisibleRowIdx + 1
          EndIf
        Next
        
        ; 2. Если элемент под курсором найден, обрабатываем клик
        If RealIdx <> -1
          SelectElement(MyControl\Items(), RealIdx)
          
          ; Вычисляем зону "плюсика/стрелочки" дерева в первой колонке
          Protected TreeOffset.i = MyControl\Items()\Level * MyControl\IndentSize
          Protected ExpanderZoneStart.i = TreeOffset
          Protected ExpanderZoneEnd.i = TreeOffset + 20 ; Ширина зоны клика по стрелочке
          
          ; Если у элемента есть дети и кликнули точно по стрелочке — разворачиваем/сворачиваем ветку дерева
          If MyControl\Items()\HasChildren And MouseX >= ExpanderZoneStart And MouseX <= ExpanderZoneEnd
            MyControl\Items()\IsExpanded ! 1 ; Инвертируем флаг (был 0 станет 1, был 1 станет 0)
            CustomControl_UpdateVisibility(@MyControl) ; Пересчитываем, какие подветки теперь видны
          Else
            ; Иначе — это обычный выбор строки (как в ListIcon)
            ; Сначала сбрасываем выделение с предыдущего элемента
            If MyControl\SelectedIdx <> -1
              SelectElement(MyControl\Items(), MyControl\SelectedIdx)
              MyControl\Items()\IsSelected = #False
            EndIf
            
            ; Устанавливаем выделение на новый элемент
            MyControl\SelectedIdx = RealIdx
            SelectElement(MyControl\Items(), RealIdx)
            MyControl\Items()\IsSelected = #True
          EndIf
          
          ; После любого клика обновляем картинку на экране
          CustomControl_Redraw(@MyControl)
        EndIf
      EndIf
      
    Case #PB_EventType_MouseWheel
      ; Вертикальный скроллинг колесиком мыши
      Protected Delta.i = GetGadgetAttribute(Gadget, #PB_Canvas_WheelDelta)
      MyControl\ScrollY - (Delta * MyControl\ItemHeight)
      
      ; Ограничиваем скролл сверху, чтобы не уходить в минус
      If MyControl\ScrollY < 0 : MyControl\ScrollY = 0 : EndIf
      
      ; Перерисовываем гаджет
      CustomControl_Redraw(@MyControl)
  EndSelect
EndProcedure

; ==========================================
; ДЕМОНСТРАЦИЯ (MAIN) - ИСПРАВЛЕННАЯ
; ==========================================

If OpenWindow(0, 0, 0, 650, 450, "Кастомный Tree + ListIcon на Canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  CanvasGadget(0, 10, 10, 630, 430, #PB_Canvas_Keyboard)
  
  ; Инициализируем наш объединенный гаджет
  CustomControl_Init(@MyControl, 0, 24, 30)
  
  ; Добавляем колонки (Первая колонка держит Дерево, остальные — свойства ListIcon)
  CustomControl_AddColumn(@MyControl, "Элементы дерева (Узел)", 250)
  CustomControl_AddColumn(@MyControl, "Размер файла", 120)
  CustomControl_AddColumn(@MyControl, "Тип данных", 120)
  CustomControl_AddColumn(@MyControl, "Описание", 120)
  
  ; Заполнение структуры (Текст колонок через Chr(10), затем Level, затем флаг HasChildren)
  CustomControl_AddItem(@MyControl, "Мой компьютер" + Chr(10) + "" + Chr(10) + "Система" + Chr(10) + "Корневой узел", 0, #True)
    CustomControl_AddItem(@MyControl, "Диск C:" + Chr(10) + "119 ГБ" + Chr(10) + "Раздел NTFS" + Chr(10) + "Системный диск", 1, #True)
      CustomControl_AddItem(@MyControl, "PureBasic" + Chr(10) + "45 МБ" + Chr(10) + "Папка" + Chr(10) + "Среда разработки", 2, #True)
        CustomControl_AddItem(@MyControl, "PureBasic.exe" + Chr(10) + "4.2 МБ" + Chr(10) + "Программа" + Chr(10) + "Исполняемый файл", 3, #False)
        CustomControl_AddItem(@MyControl, "History.txt" + Chr(10) + "12 КБ" + Chr(10) + "Документ" + Chr(10) + "Лог изменений", 3, #False) ; <- ТУТ БЫЛА ОШИБКА (& исправлен на @)
      CustomControl_AddItem(@MyControl, "Windows" + Chr(10) + "24 ГБ" + Chr(10) + "Папка" + Chr(10) + "ОС", 2, #False)
    CustomControl_AddItem(@MyControl, "Диск D:" + Chr(10) + "931 ГБ" + Chr(10) + "Раздел NTFS" + Chr(10) + "Данные", 1, #True)
      CustomControl_AddItem(@MyControl, "Фильмы" + Chr(10) + "450 ГБ" + Chr(10) + "Папка" + Chr(10) + "Медиа", 2, #False)
      CustomControl_AddItem(@MyControl, "Проекты PB" + Chr(10) + "2 МБ" + Chr(10) + "Папка" + Chr(10) + "Исходный код", 2, #False)
  CustomControl_AddItem(@MyControl, "Сетевое окружение" + Chr(10) + "" + Chr(10) + "Сеть" + Chr(10) + "Устройства в сети", 0, #False)

  ; Изначально пересчитываем видимость
  CustomControl_UpdateVisibility(@MyControl)
  
  ; Привязываем события
  BindGadgetEvent(0, @CustomControl_Callback())
  
  ; Первая отрисовка
  CustomControl_Redraw(@MyControl)
  
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 42
; FirstLine = 106
; Folding = ------
; EnableXP
; DPIAware