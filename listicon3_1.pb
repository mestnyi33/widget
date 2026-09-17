
EnableExplicit

; ; --- СТРУКТУРЫ ДАННЫХ ---

EnableExplicit

; =====================================================================
; 1. КОНСТАНТЫ И ФЛАГИ (Для будущих настроек гаджета)
; =====================================================================
#Grid_Align_Left   = 0
#Grid_Align_Center = 1
#Grid_Align_Right  = 2

; =====================================================================
; 2. СТРУКТУРЫ ДАННЫХ ГРИДА
; =====================================================================

; Описание одной колонки в шапке
Structure GridColumn
   DataID.i        ; Жесткий внутренний ID (паспорт) этой колонки в памяти ячеек
   Title$          ; Название колонки (отображаемый текст)
   Width.i         ; Текущая ширина колонки в пикселях
                   ;MinWidth.i      ; Минимальная ширина (чтобы пользователь не сжал колонку в 0)
                   ;Alignment.b     ; Выравнивание текста в этой колонке (#Grid_Align_Left, и т.д.)
                   ;IsHidden.b      ; Флаг: скрыта ли колонка (на будущее)
EndStructure

; Описание одной ячейки данных
Structure GridCell
   text$          ; Текст или значение внутри ячейки
   ColorText.i    ; Кастомный цвет текста для этой ячейки (-1, если стандартный)
   ColorBack.i    ; Кастомный цвет фона для этой ячейки (-1, если стандартный)
   ImageID.i      ; Ссылка на иконку внутри ячейки (если понадобится)
EndStructure

; Описание одной строки таблицы
Structure GridRow
   IsHeader.b      ; Флаг: является ли эта строка шапкой
   IsChecked.b     ; Состояние чекбокса (для флага #__Flag_CheckBoxes)
   ColorBack.i     ; Кастомный цвет фона всей строки (например, для подсветки ошибок)
   Note$           ; Заметка для строки (ваше изначальное условие)
   
   List Cells.GridCell() ; Список ячеек, лежащих в исходном порядке (DataID)
EndStructure

; Главная управляющая структура вашего кастомного гаджета (Мозг)
Structure PureGrid
   CanvasID.i      ; Номер CanvasGadget, на котором рисуется этот грид
   
   ; Позиция скроллинга
   OffsetX.i       ; Текущий сдвиг по горизонтали
   OffsetY.i       ; Текущий сдвиг по вертикали
   
   ; Размеры и лимиты
   TotalRows.i     ; Общее количество строк данных
   TotalCols.i     ; Общее количество колонок в шапке
   RowHeight.i     ; Фиксированная высота строки
   ColHeight.i     ; Высота шапки таблицы
   
   ; Индексы состояний
   SelectedRow.i   ; Индекс выделенной строки (-1 если нет)
   SelectedCol.i   ; Индекс выделенной колонки (визуальный, -1 если нет)
   HoveredRow.i    ; Строка под курсором мыши
   HoveredCol.i    ; Колонка под курсором мыши
   
   ; Настройки/Стили (Копии флагов вашего конструктора)
   GridLines.b     ; Включена ли сетка (#True/#False)
   CheckBoxes.b    ; Включены ли чекбоксы (#True/#False)
   FullRowSelect.b ; Выделять ли строку целиком (#True/#False)
   
   
   ; Динамическая память гаджета
   List Columns.GridColumn() ; Список колонок шапки (управляет порядком вывода)
   List Rows.GridRow()       ; Список всех строк таблицы
EndStructure

Global *MyGrid.PureGrid

; --- ФУНКЦИЯ ОТРИСОВКИ ---
Procedure DrawColumns(*MyGrid.PureGrid, W)
   Protected X
   Protected RowHeight = *MyGrid\RowHeight
   DrawingMode(#PB_2DDrawing_Default)
   ; Серый фон для шапки
   Box(0, 0, W, RowHeight, RGB(230, 232, 236))
   ; Нижняя разделительная черта шапки
   Line(0, RowHeight - 1, W, 1, RGB(180, 185, 190))
   
   X = *MyGrid\OffsetX ; Сбрасываем X для отрисовки шапки
   ForEach *MyGrid\Columns()
      Protected ColumnWidth = *MyGrid\Columns()\Width
      Protected title$ = *MyGrid\Columns()\Title$
      
      If X + ColumnWidth >= 0 And X <= W
         ; Вертикальная граница между колонками в шапке
         Line(X + ColumnWidth, 0, 1, RowHeight, RGB(190, 195, 200))
         
         ; Текст колонки
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(X + 10, (RowHeight - TextHeight("Y")) / 2, title$, RGB(40, 45, 55))
      EndIf
      
      ; Сдвигаем X на ширину текущей колонки шапки
      X + ColumnWidth
   Next
   
EndProcedure

Procedure DrawGrid(*MyGrid.PureGrid) 
   Protected CanvasID.i = *MyGrid\CanvasID
   Protected W = GadgetWidth(CanvasID)
   Protected H = GadgetHeight(CanvasID)
   Protected RowHeight = *MyGrid\RowHeight
   Protected r, c, X, Y
   
   If StartDrawing(CanvasOutput(CanvasID))
      
      ; Белый фон для рабочей области таблицы
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, W, H, RGB(255, 255, 255))
      
      ; ----------------------------------------------------
      ; ЭТАП 1: Рисуем строки данных (с учетом вертикального скролла)
      ; Данные начинают рисоваться ПОД шапкой (смещаем на RowHeight)
      ; ----------------------------------------------------
      r = 0
      ForEach *MyGrid\Rows()
         ; Y-координата строки: позиция + скролл + отступ под шапку
         Y = r * RowHeight + *MyGrid\OffsetY + RowHeight
         
         ; Рисуем только то, что видно между Шапкой и Статус-баром
         If Y >= RowHeight And Y <= H - 30
            
            ; Подсветка ховера или выделения строки
            DrawingMode(#PB_2DDrawing_Default)
            If r = *MyGrid\SelectedRow
               Box(0, Y, W, RowHeight, RGB(220, 235, 255)) ; Выдетенная строка
            ElseIf r = *MyGrid\HoveredRow
               Box(0, Y, W, RowHeight, RGB(245, 247, 250)) ; Ховер строки
            EndIf
            
            ; --- СИНХРОННЫЙ РАСЧЕТ И ОТРИСОВКА ЯЧЕЕК СТРОКИ ---
            X = *MyGrid\OffsetX ; Стартуем X от текущего горизонтального скролла
            c = 0
            
            ForEach *MyGrid\Columns() ; Бежим строго по текущему порядку колонок в шапке
               ; По паспорту DataID достаем из памяти строки нужную ячейку "на лету"
               Define *Cell.GridCell = SelectElement(*MyGrid\Rows()\Cells(), *MyGrid\Columns()\DataID)
               Protected CellWidth = *MyGrid\Columns()\Width
               Protected text$ = *Cell\text$
               
               ; Проверяем, видна ли ячейка на экране с учетом её индивидуальной ширины
               If X + CellWidth >= 0 And X <= W
                  
                  ; Сетка ячейки
                  DrawingMode(#PB_2DDrawing_Outlined)
                  Box(X, Y, CellWidth + 1, RowHeight + 1, RGB(220, 220, 220))
                  
                  ; Рамка для фокуса на конкретной ячейке (визуальный индекс колонки `c`)
                  If r = *MyGrid\SelectedRow And c = *MyGrid\SelectedCol
                     Box(X + 1, Y + 1, CellWidth - 1, RowHeight - 1, RGB(0, 102, 204))
                  EndIf
                  
                  ; Текст данных
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawText(X + 10, Y + (RowHeight - TextHeight("Y")) / 2, text$, RGB(50, 50, 50))
               EndIf
               
               ; Сдвигаем координату X на ширину ТЕКУЩЕЙ отрисованной колонки
               X + CellWidth
               c + 1
            Next
         EndIf
         r + 1
      Next
      
      ; ----------------------------------------------------
      ; ЭТАП 2: ФИКСИРОВАННАЯ ШАПКА (Рисуется ПОВЕРХ строк, всегда на Y = 0)
      ; Она сдвигается по горизонтали (OffsetX), но никогда по вертикали!
      ; ----------------------------------------------------
      DrawColumns(*MyGrid, W)
      
      ; ----------------------------------------------------
      ; ЭТАП 3: Нижний Статус-бар (Всегда поверх всего в самом низу)
      ; ----------------------------------------------------
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, H - 30, W, 30, RGB(235, 235, 240))
      Line(0, H - 30, W, 1, RGB(180, 180, 180))
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(10, H - 22, "Классический Grid: Верхняя шапка зафиксирована, строки скроллятся.", RGB(100, 100, 100))
      
      StopDrawing()
   EndIf
EndProcedure


; --- ОБРАБОТКА МЫШИ (Исправленная под динамические колонки) ---
Procedure HowerColumnn(*MyGrid.PureGrid, X)
   Protected HoverCol = -1
   Protected currentX = *MyGrid\OffsetX
   Protected visualCol = 0
   ForEach *MyGrid\Columns()
      Protected CellWidth = *MyGrid\Columns()\Width
      If X >= currentX And X < currentX + CellWidth
         HoverCol = visualCol
         Break
      EndIf
      currentX + CellWidth
      visualCol + 1
   Next
   ProcedureReturn HoverCol
EndProcedure

Procedure CanvasCallback()
   Protected ReDraw.b
   Protected CanvasID.i = EventGadget()
   Protected X = GetGadgetAttribute(CanvasID, #PB_Canvas_MouseX)
   Protected Y = GetGadgetAttribute(CanvasID, #PB_Canvas_MouseY)
   Protected Delta = GetGadgetAttribute(CanvasID, #PB_Canvas_WheelDelta)
   Protected RowHeight = *MyGrid\RowHeight
   
   ; Координаты клика/ховера по строкам рассчитываются с вычетом высоты шапки
   Protected GridX = X - *MyGrid\OffsetX
   Protected GridY = Y - *MyGrid\OffsetY - RowHeight
   
   Protected HoverRow = GridY / RowHeight
   ; --- ИСПРАВЛЕНИЕ: Точный расчет колонки под мышью по их ширине ---
   Protected HoverCol = HowerColumnn(*MyGrid, X)
   
   ; Если мышка находится в зоне шапки или статус-бара, отключаем ховер строк
   If Y < RowHeight Or Y > GadgetHeight(CanvasID) - 30
      HoverRow = -1
      HoverCol = -1
   EndIf
   
   If HoverCol < 0 Or HoverCol >= *MyGrid\TotalCols : HoverCol = -1 : EndIf
   If HoverRow < 0 Or HoverRow >= *MyGrid\TotalRows : HoverRow = -1 : EndIf
   
   Select EventType()
      Case #PB_EventType_MouseMove
         If *MyGrid\HoveredRow <> HoverRow Or *MyGrid\HoveredCol <> HoverCol
            *MyGrid\HoveredRow = HoverRow
            *MyGrid\HoveredCol = HoverCol
            ReDraw = 1
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If HoverRow >= 0 And HoverCol >= 0
            *MyGrid\SelectedRow = HoverRow
            *MyGrid\SelectedCol = HoverCol
            ReDraw = 1
         EndIf
         
      Case #PB_EventType_MouseWheel
         *MyGrid\OffsetY + (Delta * 15)
         ; Ограничиваем скролл вверх
         If *MyGrid\OffsetY > 0 : *MyGrid\OffsetY = 0 : EndIf
         ReDraw = 1
         
      Case #PB_EventType_MouseLeave
         *MyGrid\HoveredRow = -1
         *MyGrid\HoveredCol = -1
         ReDraw = 1
   EndSelect
   
   If ReDraw
      DrawGrid(*MyGrid)
   EndIf
      
EndProcedure

Procedure GetColumn(*MyGrid.PureGrid, col.l)
   ; 1. Защита от выхода за границы количества колонок
   If col < 0 Or col >= *MyGrid\TotalCols : ProcedureReturn : EndIf
   
   ProcedureReturn SelectElement(*MyGrid\Columns(), col)
EndProcedure

Procedure GetItem(*MyGrid.PureGrid, row.l)
   ; 1. Защита от выхода за границы количества колонок
   If row < 0 Or row >= *MyGrid\TotalRows : ProcedureReturn : EndIf
   
   ProcedureReturn SelectElement(*MyGrid\Rows(), row)
EndProcedure

Procedure GetCell( *MyGrid.PureGrid, *row.GridRow, col.l )
   Protected *column.GridColumn = GetColumn(*MyGrid.PureGrid, col.l)
   If *column
      ProcedureReturn SelectElement(*row\Cells(), *column\DataID)
   EndIf
EndProcedure

Procedure.s GetItemText(*MyGrid.PureGrid, row.l, col.l)
   Protected *row.GridRow = GetItem(*MyGrid, row)
   If *row
      Protected *Cell.GridCell = GetCell(*MyGrid, *row, col.l)
      If *Cell
         ProcedureReturn *Cell\text$
      EndIf
   EndIf
EndProcedure

Procedure SetItemText(*MyGrid.PureGrid, row.l, col.l, text$)
   Protected *row.GridRow = GetItem(*MyGrid, row)
   If *row
      Protected *Cell.GridCell = GetCell(*MyGrid, *row, col.l)
      If *Cell
         *Cell\text$ = text$
         
         ; 5. Автоматически перерисовываем Grid, чтобы пользователь сразу увидел новый текст
         ; Передаем ID холста (в нашем коде это 0)
         DrawGrid(*MyGrid) 
         ProcedureReturn #True ; Успешно
      EndIf 
   EndIf
EndProcedure

Procedure RemoveItem(*MyGrid.PureGrid, row.l)
   Protected *row.GridRow = GetItem(*MyGrid, row)
   If *row
      ; 3. Если удаляемая строка была выделена, сбрасываем выделение в -1
      If *MyGrid\SelectedRow = row
         *MyGrid\SelectedRow = -1
         *MyGrid\SelectedCol = -1
      ElseIf *MyGrid\SelectedRow > row
         ; Если выделенная строка была ниже удаляемой, сдвигаем индекс выделения вверх
         *MyGrid\SelectedRow - 1
      EndIf
      
      ; Сбрасываем ховер, чтобы не было фантомных подсветок
      *MyGrid\HoveredRow = -1
      
      ; 4. Физически удаляем строку из памяти.
      ; PureBasic сам автоматически уничтожит вложенный массив Cells() для этой строки!
      DeleteElement(*MyGrid\Rows())
      
      ; 5. Обновляем счетчик общего количества строк в таблице
      *MyGrid\TotalRows = ListSize(*MyGrid\Rows())
      
      ; 6. Перерисовываем таблицу, чтобы строка моментально исчезла с экрана
      DrawGrid(*MyGrid)
      ProcedureReturn #True ; Успешно удалено
   EndIf
   
   ProcedureReturn #False
EndProcedure

Procedure ClearItems(*MyGrid.PureGrid)
   ; 1. Полностью очищаем список строк из оперативной памяти
   ; PureBasic сам автоматически уничтожит все вложенные массивы Cells() и тексты ячеек!
   ClearList(*MyGrid\Rows())
   
   ; 2. Обнуляем счетчик общего количества строк
   *MyGrid\TotalRows = 0
   
   ; 3. Сбрасываем все индексы состояний в исходное положение (-1)
   *MyGrid\SelectedRow = -1
   *MyGrid\SelectedCol = -1
   *MyGrid\HoveredRow  = -1
   *MyGrid\HoveredCol  = -1
   
   ; 4. Сбрасываем вертикальный скролл в самый верх
   *MyGrid\OffsetY = 0
   
   ; 5. Мгновенно перерисовываем пустую таблицу на Canvas (передаем ID холста 0)
   DrawGrid(*MyGrid)
EndProcedure

Procedure MoveItem(*MyGrid.PureGrid, FromIndex.l, ToIndex.l)
   If FromIndex = ToIndex : ProcedureReturn #True : EndIf ; Смещать не нужно
                                                          ; 1. Защита от выхода за границы общего количества строк
   If FromIndex < 0 Or FromIndex >= *MyGrid\TotalRows : ProcedureReturn #False : EndIf
   If ToIndex < 0 Or ToIndex >= *MyGrid\TotalRows : ProcedureReturn #False : EndIf
   
   ; 2. Используем вашу функцию GetItem, чтобы найти перемещаемую строку
   Protected *sourceRow.GridRow = GetItem(*MyGrid, FromIndex)
   
   If *sourceRow
      ; 3. Перемещаем элемент внутри списка Rows() на новую позицию
      If ToIndex = 0
         ; Если перетащили на самое первое место в таблице
         MoveElement(*MyGrid\Rows(), #PB_List_First)
      Else
         ; Если перетащили в середину или конец, находим целевую строку
         Protected *targetRow.GridRow
         SelectElement(*MyGrid\Rows(), ToIndex)
         *targetRow = @*MyGrid\Rows() ; Запоминаем её адрес в памяти
         
         ; Возвращаемся к перемещаемому элементу строки
         SelectElement(*MyGrid\Rows(), FromIndex)
         
         ; Сдвигаем его относительно целевого элемента строки в зависимости от направления
         If FromIndex < ToIndex
            MoveElement(*MyGrid\Rows(), #PB_List_After, *targetRow)
         Else
            MoveElement(*MyGrid\Rows(), #PB_List_Before, *targetRow)
         EndIf
      EndIf
      
      ; 4. Корректируем индекс выделенной строки, чтобы фокус переместился вместе с данными
      If *MyGrid\SelectedRow = FromIndex
         *MyGrid\SelectedRow = ToIndex
      ElseIf FromIndex < ToIndex And *MyGrid\SelectedRow > FromIndex And *MyGrid\SelectedRow <= ToIndex
         *MyGrid\SelectedRow - 1
      ElseIf FromIndex > ToIndex And *MyGrid\SelectedRow >= ToIndex And *MyGrid\SelectedRow < FromIndex
         *MyGrid\SelectedRow + 1
      EndIf
      
      ; Сбрасываем ховер строки, чтобы избежать фантомных подсветок при перерисовке
      *MyGrid\HoveredRow = -1
      
      ; 5. Автоматически перерисовываем таблицу на Canvas (передаем ID холста 0)
      DrawGrid(*MyGrid)
      ProcedureReturn #True ; Успешно перемещено
   EndIf
   
   ProcedureReturn #False
EndProcedure

; --- ЗАПОЛНЕНИЕ ДАННЫМИ ---
Procedure AddItem(*MyGrid.PureGrid, position.l, text$, Image.i=-1, sublevel.l=0)
   ; 1. Добавляем или вставляем строку в список Rows()
   If position = -1
      LastElement(*MyGrid\Rows())
      AddElement(*MyGrid\Rows())
   Else
      SelectElement(*MyGrid\Rows(), position)
      InsertElement(*MyGrid\Rows())
   EndIf
   
   ; Инициализируем базовые поля строки
   *MyGrid\Rows()\Note$ = ""
   *MyGrid\Rows()\ColorBack = -1 
   
   ; Меняем размер массива ячеек под количество колонок
   ;ReDim *MyGrid\Rows()\Cells(*MyGrid\TotalCols - 1)
   
   ; 2. ОПТИМИЗИРОВАННЫЙ СВЕРХБЫСТРЫЙ ПАРСИНГ
   Protected *ptr.Character = @text$
   Protected *colStart = *ptr
   Protected currentCol = 0
   Protected *Cell.GridCell
   
   While currentCol < *MyGrid\TotalCols
      ; Если нашли разделитель ИЛИ строка уже давно закончилась, но массив надо заполнить
      If *ptr\c = 10 Or *ptr\c = 0
         ;*Cell = @*MyGrid\Rows()\Cells(currentCol)
         *Cell = AddElement(*MyGrid\Rows()\Cells())
         
         ; Если старт совпадает с ptr (строка закончилась), PeekS автоматически запишет ""
         *Cell\text$ = PeekS(*colStart, (*ptr - *colStart) >> 1)
         *Cell\ColorText = -1 
         *Cell\ColorBack = -1 
         *Cell\ImageID = Image
         
         ; Сдвигаем указатель начала следующей колонки (безопасно, если не вышли за 0)
         If *ptr\c = 10
            *colStart = *ptr + SizeOf(Character)
         Else
            *colStart = *ptr ; Строка закончилась, фиксируем указатель на нуль-терминаторе
         EndIf
         
         currentCol + 1
      EndIf
      
      ; Двигаем указатель вперед, только если строка еще физически не закончилась
      If *ptr\c <> 0
         *ptr + SizeOf(Character)
      EndIf
   Wend
   
   ; Обновляем счетчик строк таблицы
   *MyGrid\TotalRows = ListSize(*MyGrid\Rows())
EndProcedure

Procedure MoveColumn(*MyGrid.PureGrid, FromIndex.l, ToIndex.l)
   ; 1. Защита от выхода за границы общего количества колонок
   If FromIndex = ToIndex : ProcedureReturn #True : EndIf ; Перемещать никуда не надо
   If ToIndex < 0 Or ToIndex >= *MyGrid\TotalCols : ProcedureReturn #False : EndIf
   If FromIndex < 0 Or FromIndex >= *MyGrid\TotalCols : ProcedureReturn #False : EndIf
   
   ; 2. Используем вашу функцию GetColumn, чтобы найти колонку, которую хотим переместить
   Protected *sourceColumn.GridColumn = GetColumn(*MyGrid, FromIndex)
   
   If *sourceColumn
      ; 3. Перемещаем элемент внутри списка Columns() на новую позицию
      If ToIndex = 0
         ; Если перетащили на самое первое место
         MoveElement(*MyGrid\Columns(), #PB_List_First)
      Else
         ; Если перетащили в середину или конец, находим целевой элемент
         Protected *targetColumn.GridColumn
         SelectElement(*MyGrid\Columns(), ToIndex)
         *targetColumn = @*MyGrid\Columns() ; Запоминаем его адрес в памяти
         
         ; Возвращаемся к перемещаемому элементу
         SelectElement(*MyGrid\Columns(), FromIndex)
         
         ; Сдвигаем его относительно целевого элемента в зависимости от направления
         If FromIndex < ToIndex
            MoveElement(*MyGrid\Columns(), #PB_List_After, *targetColumn)
         Else
            MoveElement(*MyGrid\Columns(), #PB_List_Before, *targetColumn)
         EndIf
      EndIf
      
      ; 4. Корректируем индекс выделенной колонки, чтобы рамка фокуса не улетела на другие данные
      If *MyGrid\SelectedCol = FromIndex
         *MyGrid\SelectedCol = ToIndex
      ElseIf FromIndex < ToIndex And *MyGrid\SelectedCol > FromIndex And *MyGrid\SelectedCol <= ToIndex
         *MyGrid\SelectedCol - 1
      ElseIf FromIndex > ToIndex And *MyGrid\SelectedCol >= ToIndex And *MyGrid\SelectedCol < FromIndex
         *MyGrid\SelectedCol + 1
      EndIf
      
      ; Сбрасываем ховер, чтобы избежать фантомных подсветок при движении мыши
      *MyGrid\HoveredCol = -1
      
      ; 5. Автоматически перерисовываем таблицу (колонка мгновенно меняет свое место на экране)
      DrawGrid(*MyGrid)
      ProcedureReturn #True ; Успешно перемещено
   EndIf
   
   ProcedureReturn #False
EndProcedure

Procedure RemoveColumn(*MyGrid.PureGrid, col.l)
   Protected *Cell.GridCell
   Protected *column.GridColumn = GetColumn(*MyGrid, col)
   If *column
      ; 3. Пробегаемся по ВСЕМ строкам таблицы и освобождаем память от текста в этой ячейке
      ForEach *MyGrid\Rows()
         *Cell = SelectElement(*MyGrid\Rows()\Cells(), *column\DataID)
         
         ; Присвоение пустой строки в PureBasic автоматически освобождает память,
         ; которую занимал текст этой конкретной ячейки в операционной системе
         *Cell\text$ = ""
         *Cell\ColorText = -1
         *Cell\ColorBack = -1
         *Cell\ImageID   = -1
      Next
      
      ; 4. Физически удаляем саму колонку из списка шапки Columns()
      ; Перед этим делаем её активной (GetColumn уже сделал SelectElement внутри себя)
      DeleteElement(*MyGrid\Columns())
      
      ; 5. Обновляем счетчик общего количества колонок в таблице
      *MyGrid\TotalCols = ListSize(*MyGrid\Columns())
      
      ; 6. Корректируем индексы выделения, чтобы не было фантомных подсветок ячеек
      If *MyGrid\SelectedCol = col
         *MyGrid\SelectedCol = -1
      ElseIf *MyGrid\SelectedCol > col
         *MyGrid\SelectedCol - 1
      EndIf
      *MyGrid\HoveredCol = -1
      
      ; 7. Перерисовываем таблицу (колонка мгновенно исчезает с экрана)
      DrawGrid(*MyGrid)
      ProcedureReturn #True ; Успешно удалено
   EndIf
   
   ProcedureReturn #False
EndProcedure

Procedure AddColumn(*MyGrid.PureGrid, title$, Width.l)
   *MyGrid\TotalCols = ListSize(*MyGrid\Columns()) 
   AddElement(*MyGrid\Columns()) 
   *MyGrid\Columns()\Title$ = title$
   *MyGrid\Columns()\Width = Width 
   *MyGrid\Columns()\DataID = *MyGrid\TotalCols
   *MyGrid\TotalCols + 1
EndProcedure

Procedure Open(window.i, X.l,Y.l,Width.l,Height.l, title$, Flag.i=0)
   OpenWindow(window, X,Y,Width,Height, title$, Flag)
   CanvasGadget(0, 0,0,Width,Height, #PB_Canvas_Keyboard)
   BindGadgetEvent(0, @CanvasCallback())
   ProcedureReturn 1
EndProcedure

Procedure ListIcon(X.l,Y.l,Width.l,Height.l, title$, titlewidth.l, Flag.i=0)
   Protected *MyGrid.PureGrid = AllocateStructure(PureGrid)
   *MyGrid\RowHeight = 30
   *MyGrid\SelectedRow = -1
   *MyGrid\SelectedCol = -1
   *MyGrid\HoveredRow  = -1
   ProcedureReturn *MyGrid
EndProcedure

; --- ОКНО ПРИЛОЖЕНИЯ ---

If Open(0, 100, 100, 640, 480, "PureBasic 2D Grid with Header", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   *MyGrid = ListIcon(0, 0, 640, 480, "ID товара", 120)
   *MyGrid\CanvasID = 0
   
   ; 1. Заполняем ШАПКУ таблицы (тот самый верхний фиксированный ряд)
   AddColumn(*MyGrid, "ID товара", 120)
   AddColumn(*MyGrid, "Наименование", 120)
   AddColumn(*MyGrid, "Категория", 120)
   AddColumn(*MyGrid, "Цена", 120)
                              AddColumn(*MyGrid, "Остаток", 120)
   
   ; 2. Заполняем обычные строки с данными (вниз)
   Define r.l
   For r = 1 To 20
      ; Формируем единую строку, разделенную #LF$
      Define rowText$ = "#" + Str(1000 + r) + #LF$ +
                        "Товар " + Str(r) + #LF$ +
      "Электроника" + #LF$ +
      Str(r * 150) + " руб" + #LF$ +
      Str(Random(50, 5)) + " шт"
      
      ; Вызываем вашу новую функцию (добавляем всегда в конец: параметр -1)
      AddItem(*MyGrid, -1, rowText$)
   Next
   
   
   ;    Define a, LN=5000000, time = ElapsedMilliseconds() ; 25373 - add widget items time count - 
   ;     For a = 0 To LN
   ;        AddItem (*MyGrid, -1, "Item "+Str(a), 0,0) 
   ;        
   ;       If A & $f=$f
   ;         WindowEvent() ; ýòî íóæíî ÷òîáû íåìíîãî îáíîâëÿëñÿ
   ;       EndIf
   ;       If A & $8ff=$8ff
   ;         WindowEvent() ; ýòî ïîçâîëÿåò ïîêàçûâàòü ñêîêî öèêëîâ ïðîéøëî
   ;         Debug a
   ;       EndIf
   ;     Next
   ;     Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " ;+ CountItems(*w)
   
   DrawGrid(*MyGrid)
   
   SetItemText(*MyGrid, 1, 3, "12345")
   Debug GetItemText(*MyGrid, 1, 3)
   RemoveItem(*MyGrid, 1)
   RemoveColumn(*MyGrid, 3)
   MoveColumn(*MyGrid, 1, 3)
   MoveItem(*MyGrid, 1, 3)
   
   Repeat
   Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf


; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 146
; FirstLine = 140
; Folding = ------------
; EnableXP
; DPIAware