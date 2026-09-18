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
Structure _s_COLS
   ID.i        ; Жесткий внутренний ID (паспорт) этой колонки в памяти ячеек
   Title$          ; Название колонки (отображаемый текст)
   Width.i         ; Текущая ширина колонки в пикселях
                   ;MinWidth.i      ; Минимальная ширина (чтобы пользователь не сжал колонку в 0)
                   ;Alignment.b     ; Выравнивание текста в этой колонке (#Grid_Align_Left, и т.д.)
                   ;IsHidden.b      ; Флаг: скрыта ли колонка (на будущее)
EndStructure

; Описание одной ячейки данных
Structure _s_CELLS
   text$          ; Текст или значение внутри ячейки
   ColorText.i    ; Кастомный цвет текста для этой ячейки (-1, если стандартный)
   ColorBack.i    ; Кастомный цвет фона для этой ячейки (-1, если стандартный)
   ImageID.i      ; Ссылка на иконку внутри ячейки (если понадобится)
EndStructure

; Описание одной строки таблицы
Structure _s_ROWS
   IsHeader.b      ; Флаг: является ли эта строка шапкой
   IsChecked.b     ; Состояние чекбокса (для флага #__Flag_CheckBoxes)
   ColorBack.i     ; Кастомный цвет фона всей строки (например, для подсветки ошибок)
   Note$           ; Заметка для строки (ваше изначальное условие)
   
   Array Cells._s_CELLS(0) ; Список ячеек, лежащих в исходном порядке (ID)
EndStructure

Structure _s_ROW             
   count.i     ; Общее количество строк данных
   Height.i    ; Фиксированная высота строки
   selected.i  ; Индекс выделенной строки (-1 если нет)
   hovered.i   ; Строка под курсором мыши
   List _s._s_ROWS()       ; Список всех строк таблицы
EndStructure

Structure _s_COL  
   count.i     ; Общее количество колонок в шапке 
   Height.i    ; Высота шапки таблицы
   selected.i  ; Индекс выделенной колонки (визуальный, -1 если нет)
   hovered.i   ; Колонка под курсором мыши
   List _s._s_COLS() ; Список колонок шапки (управляет порядком вывода)
EndStructure

; Главная управляющая структура вашего кастомного гаджета (Мозг)
Structure _s_WIDGET
   CanvasID.i      ; Номер CanvasGadget, на котором рисуется этот грид
   
   ; Позиция скроллинга
   OffsetX.i       ; Текущий сдвиг по горизонтали
   OffsetY.i       ; Текущий сдвиг по вертикали
   
   ; Настройки/Стили (Копии флагов вашего конструктора)
   GridLines.b     ; Включена ли сетка (#True/#False)
   CheckBoxes.b    ; Включены ли чекбоксы (#True/#False)
   FullRowSelect.b ; Выделять ли строку целиком (#True/#False)
   
   
   ; Индексы состояний
   row._s_ROW
   col._s_COL
EndStructure

Global *this._s_WIDGET

; --- ФУНКЦИЯ ОТРИСОВКИ ---
Procedure DrawColumns(*this._s_WIDGET, W)
   Protected X
   Protected RowHeight = *this\row\height
   DrawingMode(#PB_2DDrawing_Default)
   ; Серый фон для шапки
   Box(0, 0, W, RowHeight, RGB(230, 232, 236))
   ; Нижняя разделительная черта шапки
   Line(0, RowHeight - 1, W, 1, RGB(180, 185, 190))
   
   X = *this\OffsetX ; Сбрасываем X для отрисовки шапки
   ForEach *this\col\_s()
      Protected ColumnWidth = *this\col\_s()\Width
      Protected title$ = *this\col\_s()\Title$
      
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

Procedure ReDraw(*this._s_WIDGET) 
   Protected CanvasID.i = *this\CanvasID
   Protected W = GadgetWidth(CanvasID)
   Protected H = GadgetHeight(CanvasID)
   Protected RowHeight = *this\row\height
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
      ForEach *this\row\_s()
         ; Y-координата строки: позиция + скролл + отступ под шапку
         Y = r * RowHeight + *this\OffsetY + RowHeight
         
         ; Рисуем только то, что видно между Шапкой и Статус-баром
         If Y >= RowHeight And Y <= H - 30
            
            ; Подсветка ховера или выделения строки
            DrawingMode(#PB_2DDrawing_Default)
            If r = *this\row\selected
               Box(0, Y, W, RowHeight, RGB(220, 235, 255)) ; Выдетенная строка
            ElseIf r = *this\row\hovered
               Box(0, Y, W, RowHeight, RGB(245, 247, 250)) ; Ховер строки
            EndIf
            
            ; --- СИНХРОННЫЙ РАСЧЕТ И ОТРИСОВКА ЯЧЕЕК СТРОКИ ---
            X = *this\OffsetX ; Стартуем X от текущего горизонтального скролла
            c = 0
            
            ForEach *this\col\_s() ; Бежим строго по текущему порядку колонок в шапке
               Protected CellWidth = *this\col\_s()\Width
               ; По паспорту ID достаем из памяти строки нужную ячейку "на лету"
               Define *Cell._s_CELLS = *this\row\_s()\Cells(*this\col\_s()\ID)
               
               ; Проверяем, видна ли ячейка на экране с учетом её индивидуальной ширины
               If X + CellWidth >= 0 And X <= W
                  
                  ; Сетка ячейки
                  DrawingMode(#PB_2DDrawing_Outlined)
                  Box(X, Y, CellWidth + 1, RowHeight + 1, RGB(220, 220, 220))
                  
                  ; Рамка для фокуса на конкретной ячейке (визуальный индекс колонки `c`)
                  If r = *this\row\selected And c = *this\col\selected
                     Box(X + 1, Y + 1, CellWidth - 1, RowHeight - 1, RGB(0, 102, 204))
                  EndIf
                  
                  ; Текст данных
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawText(X + 10, Y + (RowHeight - TextHeight("Y")) / 2, *Cell\text$, RGB(50, 50, 50))
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
      DrawColumns(*this, W)
      
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
Procedure HowerColumnn(*this._s_WIDGET, X)
   Protected HoverCol = -1
   Protected currentX = *this\OffsetX
   Protected visualCol = 0
   ForEach *this\col\_s()
      Protected CellWidth = *this\col\_s()\Width
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
   Protected RowHeight = *this\row\height
   
   ; Координаты клика/ховера по строкам рассчитываются с вычетом высоты шапки
   Protected GridX = X - *this\OffsetX
   Protected GridY = Y - *this\OffsetY - RowHeight
   
   Protected HoverRow = GridY / RowHeight
   Protected HoverCol = -1
   
   ; --- ИСПРАВЛЕНИЕ: Точный расчет колонки под мышью по их ширине ---
   HoverCol = HowerColumnn(*this, X)
   
   ; Если мышка находится в зоне шапки или статус-бара, отключаем ховер строк
   If Y < RowHeight Or Y > GadgetHeight(CanvasID) - 30
      HoverRow = -1
      HoverCol = -1
   EndIf
   
   If HoverCol < 0 Or HoverCol >= *this\col\count : HoverCol = -1 : EndIf
   If HoverRow < 0 Or HoverRow >= *this\row\count : HoverRow = -1 : EndIf
   
   Select EventType()
      Case #PB_EventType_MouseMove
         If *this\row\hovered <> HoverRow Or *this\col\hovered <> HoverCol
            *this\row\hovered = HoverRow
            *this\col\hovered = HoverCol
            ReDraw = 1
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If HoverRow >= 0 And HoverCol >= 0
            *this\row\selected = HoverRow
            *this\col\selected = HoverCol
            ReDraw = 1
         EndIf
         
      Case #PB_EventType_MouseWheel
         *this\OffsetY + (Delta * 15)
         ; Ограничиваем скролл вверх
         If *this\OffsetY > 0 : *this\OffsetY = 0 : EndIf
         ReDraw = 1
         
      Case #PB_EventType_MouseLeave
         *this\row\hovered = -1
         *this\col\hovered = -1
         ReDraw = 1
   EndSelect
   
   If ReDraw
      ReDraw(*this)
   EndIf
      
EndProcedure

Procedure GetColumn(*this._s_WIDGET, col.l)
   ; 1. Защита от выхода за границы количества колонок
   If col < 0 Or col >= *this\col\count : ProcedureReturn : EndIf
   
   ProcedureReturn SelectElement(*this\col\_s(), col)
EndProcedure

Procedure GetItem(*this._s_WIDGET, row.l)
   ; 1. Защита от выхода за границы количества колонок
   If row < 0 Or row >= *this\row\count : ProcedureReturn : EndIf
   
   ProcedureReturn SelectElement(*this\row\_s(), row)
EndProcedure

Procedure GetCell( *this._s_WIDGET, *row._s_ROWS, col.l )
   Protected *column._s_COLS = GetColumn(*this._s_WIDGET, col.l)
   If *column
      ProcedureReturn *row\Cells(*column\ID)
   EndIf
EndProcedure

Procedure.s GetItemText(*this._s_WIDGET, row.l, col.l)
   Protected *row._s_ROWS = GetItem(*this, row)
   If *row
      Protected *Cell._s_CELLS = GetCell(*this, *row, col.l)
      If *Cell
         ProcedureReturn *Cell\text$
      EndIf
   EndIf
EndProcedure

Procedure SetItemText(*this._s_WIDGET, row.l, col.l, text$)
   Protected *row._s_ROWS = GetItem(*this, row)
   If *row
      Protected *Cell._s_CELLS = GetCell(*this, *row, col.l)
      If *Cell
         *Cell\text$ = text$
         
         ; 5. Автоматически перерисовываем Grid, чтобы пользователь сразу увидел новый текст
         ; Передаем ID холста (в нашем коде это 0)
         ReDraw(*this) 
         ProcedureReturn #True ; Успешно
      EndIf 
   EndIf
EndProcedure

Procedure RemoveItem(*this._s_WIDGET, row.l)
   Protected *row._s_ROWS = GetItem(*this, row)
   If *row
      ; 3. Если удаляемая строка была выделена, сбрасываем выделение в -1
      If *this\row\selected = row
         *this\row\selected = -1
         *this\col\selected = -1
      ElseIf *this\row\selected > row
         ; Если выделенная строка была ниже удаляемой, сдвигаем индекс выделения вверх
         *this\row\selected - 1
      EndIf
      
      ; Сбрасываем ховер, чтобы не было фантомных подсветок
      *this\row\hovered = -1
      
      ; 4. Физически удаляем строку из памяти.
      ; PureBasic сам автоматически уничтожит вложенный массив Cells() для этой строки!
      DeleteElement(*this\row\_s())
      
      ; 5. Обновляем счетчик общего количества строк в таблице
      *this\row\count = ListSize(*this\row\_s())
      
      ; 6. Перерисовываем таблицу, чтобы строка моментально исчезла с экрана
      ReDraw(*this)
      ProcedureReturn #True ; Успешно удалено
   EndIf
   
   ProcedureReturn #False
EndProcedure

Procedure ClearItems(*this._s_WIDGET)
   ; 1. Полностью очищаем список строк из оперативной памяти
   ; PureBasic сам автоматически уничтожит все вложенные массивы Cells() и тексты ячеек!
   ClearList(*this\row\_s())
   
   ; 2. Обнуляем счетчик общего количества строк
   *this\row\count = 0
   
   ; 3. Сбрасываем все индексы состояний в исходное положение (-1)
   *this\row\selected = -1
   *this\col\selected = -1
   *this\row\hovered  = -1
   *this\col\hovered  = -1
   
   ; 4. Сбрасываем вертикальный скролл в самый верх
   *this\OffsetY = 0
   
   ; 5. Мгновенно перерисовываем пустую таблицу на Canvas (передаем ID холста 0)
   ReDraw(*this)
EndProcedure

Procedure MoveItem(*this._s_WIDGET, FromIndex.l, ToIndex.l)
   If FromIndex = ToIndex : ProcedureReturn #True : EndIf ; Смещать не нужно
                                                          ; 1. Защита от выхода за границы общего количества строк
   If FromIndex < 0 Or FromIndex >= *this\row\count : ProcedureReturn #False : EndIf
   If ToIndex < 0 Or ToIndex >= *this\row\count : ProcedureReturn #False : EndIf
   
   ; 2. Используем вашу функцию GetItem, чтобы найти перемещаемую строку
   Protected *sourceRow._s_ROWS = GetItem(*this, FromIndex)
   
   If *sourceRow
      ; 3. Перемещаем элемент внутри списка Rows() на новую позицию
      If ToIndex = 0
         ; Если перетащили на самое первое место в таблице
         MoveElement(*this\row\_s(), #PB_List_First)
      Else
         ; Если перетащили в середину или конец, находим целевую строку
         Protected *targetRow._s_ROWS
         SelectElement(*this\row\_s(), ToIndex)
         *targetRow = @*this\row\_s() ; Запоминаем её адрес в памяти
         
         ; Возвращаемся к перемещаемому элементу строки
         SelectElement(*this\row\_s(), FromIndex)
         
         ; Сдвигаем его относительно целевого элемента строки в зависимости от направления
         If FromIndex < ToIndex
            MoveElement(*this\row\_s(), #PB_List_After, *targetRow)
         Else
            MoveElement(*this\row\_s(), #PB_List_Before, *targetRow)
         EndIf
      EndIf
      
      ; 4. Корректируем индекс выделенной строки, чтобы фокус переместился вместе с данными
      If *this\row\selected = FromIndex
         *this\row\selected = ToIndex
      ElseIf FromIndex < ToIndex And *this\row\selected > FromIndex And *this\row\selected <= ToIndex
         *this\row\selected - 1
      ElseIf FromIndex > ToIndex And *this\row\selected >= ToIndex And *this\row\selected < FromIndex
         *this\row\selected + 1
      EndIf
      
      ; Сбрасываем ховер строки, чтобы избежать фантомных подсветок при перерисовке
      *this\row\hovered = -1
      
      ; 5. Автоматически перерисовываем таблицу на Canvas (передаем ID холста 0)
      ReDraw(*this)
      ProcedureReturn #True ; Успешно перемещено
   EndIf
   
   ProcedureReturn #False
EndProcedure

Procedure MoveColumn(*this._s_WIDGET, FromIndex.l, ToIndex.l)
   ; 1. Защита от выхода за границы общего количества колонок
   If FromIndex = ToIndex : ProcedureReturn #True : EndIf ; Перемещать никуда не надо
   If ToIndex < 0 Or ToIndex >= *this\col\count : ProcedureReturn #False : EndIf
   If FromIndex < 0 Or FromIndex >= *this\col\count : ProcedureReturn #False : EndIf
   
   ; 2. Используем вашу функцию GetColumn, чтобы найти колонку, которую хотим переместить
   Protected *sourceColumn._s_COLS = GetColumn(*this, FromIndex)
   
   If *sourceColumn
      ; 3. Перемещаем элемент внутри списка Columns() на новую позицию
      If ToIndex = 0
         ; Если перетащили на самое первое место
         MoveElement(*this\col\_s(), #PB_List_First)
      Else
         ; Если перетащили в середину или конец, находим целевой элемент
         Protected *targetColumn._s_COLS
         SelectElement(*this\col\_s(), ToIndex)
         *targetColumn = @*this\col\_s() ; Запоминаем его адрес в памяти
         
         ; Возвращаемся к перемещаемому элементу
         SelectElement(*this\col\_s(), FromIndex)
         
         ; Сдвигаем его относительно целевого элемента в зависимости от направления
         If FromIndex < ToIndex
            MoveElement(*this\col\_s(), #PB_List_After, *targetColumn)
         Else
            MoveElement(*this\col\_s(), #PB_List_Before, *targetColumn)
         EndIf
      EndIf
      
      ; 4. Корректируем индекс выделенной колонки, чтобы рамка фокуса не улетела на другие данные
      If *this\col\selected = FromIndex
         *this\col\selected = ToIndex
      ElseIf FromIndex < ToIndex And *this\col\selected > FromIndex And *this\col\selected <= ToIndex
         *this\col\selected - 1
      ElseIf FromIndex > ToIndex And *this\col\selected >= ToIndex And *this\col\selected < FromIndex
         *this\col\selected + 1
      EndIf
      
      ; Сбрасываем ховер, чтобы избежать фантомных подсветок при движении мыши
      *this\col\hovered = -1
      
      ; 5. Автоматически перерисовываем таблицу (колонка мгновенно меняет свое место на экране)
      ReDraw(*this)
      ProcedureReturn #True ; Успешно перемещено
   EndIf
   
   ProcedureReturn #False
EndProcedure

; --- ЗАПОЛНЕНИЕ ДАННЫМИ ---
Procedure AddItem(*this._s_WIDGET, position.l, text$, Image.i=-1, sublevel.l=0)
   ; 1. Добавляем или вставляем строку в список Rows()
   If position = -1
      LastElement(*this\row\_s())
      AddElement(*this\row\_s())
   Else
      SelectElement(*this\row\_s(), position)
      InsertElement(*this\row\_s())
   EndIf
   
   ; Инициализируем базовые поля строки
   *this\row\_s()\Note$ = ""
   *this\row\_s()\ColorBack = -1 
   
   ; Меняем размер массива ячеек под количество колонок
   ReDim *this\row\_s()\Cells(*this\col\count - 1)
   
   ; 2. ОПТИМИЗИРОВАННЫЙ СВЕРХБЫСТРЫЙ ПАРСИНГ
   Protected *ptr.Character = @text$
   Protected *colStart = *ptr
   Protected currentCol = 0
   Protected *Cell._s_CELLS
   
   While currentCol < *this\col\count
      ; Если нашли разделитель ИЛИ строка уже давно закончилась, но массив надо заполнить
      If *ptr\c = 10 Or *ptr\c = 0
         *Cell = @*this\row\_s()\Cells(currentCol)
         
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
   *this\row\count = ListSize(*this\row\_s())
EndProcedure

Procedure RemoveColumn(*this._s_WIDGET, col.l)
   Protected *Cell._s_CELLS
   Protected *column._s_COLS = GetColumn(*this, col)
   If *column
      ; 3. Пробегаемся по ВСЕМ строкам таблицы и освобождаем память от текста в этой ячейке
      ForEach *this\row\_s()
         *Cell = @*this\row\_s()\Cells(*column\ID)
         
         ; Присвоение пустой строки в PureBasic автоматически освобождает память,
         ; которую занимал текст этой конкретной ячейки в операционной системе
         *Cell\text$ = ""
         *Cell\ColorText = -1
         *Cell\ColorBack = -1
         *Cell\ImageID   = -1
      Next
      
      ; 4. Физически удаляем саму колонку из списка шапки Columns()
      ; Перед этим делаем её активной (GetColumn уже сделал SelectElement внутри себя)
      DeleteElement(*this\col\_s())
      
      ; 5. Обновляем счетчик общего количества колонок в таблице
      *this\col\count = ListSize(*this\col\_s())
      
      ; 6. Корректируем индексы выделения, чтобы не было фантомных подсветок ячеек
      If *this\col\selected = col
         *this\col\selected = -1
      ElseIf *this\col\selected > col
         *this\col\selected - 1
      EndIf
      *this\col\hovered = -1
      
      ; 7. Перерисовываем таблицу (колонка мгновенно исчезает с экрана)
      ReDraw(*this)
      ProcedureReturn #True ; Успешно удалено
   EndIf
   
   ProcedureReturn #False
EndProcedure

Procedure AddColumn(*this._s_WIDGET, title$, Width.l)
   *this\col\count = ListSize(*this\col\_s()) 
   AddElement(*this\col\_s()) 
   *this\col\_s()\Title$ = title$
   *this\col\_s()\Width = Width 
   *this\col\_s()\ID = *this\col\count
   *this\col\count + 1
EndProcedure

Procedure Open(window.i, X.l,Y.l,Width.l,Height.l, title$, Flag.i=0)
   OpenWindow(window, X,Y,Width,Height, title$, Flag)
   CanvasGadget(0, 0,0,Width,Height, #PB_Canvas_Keyboard)
   BindGadgetEvent(0, @CanvasCallback())
   ProcedureReturn 1
EndProcedure

Procedure ListIcon(X.l,Y.l,Width.l,Height.l, title$, titlewidth.l, Flag.i=0)
   Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
   *this\row\height = 30
   *this\row\selected = -1
   *this\row\hovered  = -1
   *this\col\selected = -1
   ProcedureReturn *this
EndProcedure

; --- ОКНО ПРИЛОЖЕНИЯ ---

If Open(0, 100, 100, 640, 480, "PureBasic 2D Grid with Header", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   *this = ListIcon(0, 0, 640, 480, "ID товара", 120)
   *this\CanvasID = 0
   
   ; 1. Заполняем ШАПКУ таблицы (тот самый верхний фиксированный ряд)
   AddColumn(*this, "ID товара", 120)
   AddColumn(*this, "Наименование", 120)
   AddColumn(*this, "Категория", 120)
   AddColumn(*this, "Цена", 120)
                              AddColumn(*this, "Остаток", 120)
   
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
      AddItem(*this, -1, rowText$)
   Next
   
   
   ;    Define a, LN=5000000, time = ElapsedMilliseconds() ; 25373 - add widget items time count - 
   ;     For a = 0 To LN
   ;        AddItem (*this, -1, "Item "+Str(a), 0,0) 
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
   
   ReDraw(*this)
   
;    SetItemText(*this, 1, 3, "12345")
;    Debug GetItemText(*this, 1, 3)
;    RemoveItem(*this, 1)
;    RemoveColumn(*this, 3)
;    MoveColumn(*this, 1, 3)
;    MoveItem(*this, 1, 3)
   
   Repeat
   Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 644
; FirstLine = 447
; Folding = ------N-0-8-
; EnableXP
; DPIAware