EnableExplicit

; ; --- СТРУКТУРЫ ДАННЫХ ---

EnableExplicit

; =====================================================================
; 1. КОНСТАНТЫ И ФЛАГИ (Для будущих настроек гаджета)
; =====================================================================
#__align_Left   = 0
#__align_Center = 1
#__align_Right  = 2

; =====================================================================
; 2. СТРУКТУРЫ ДАННЫХ ГРИДА
; =====================================================================
; Описание одной ячейки данных (теперь она хранит и данные ячейки, и свойства строки)
Structure _s_CELLS
   text$          ; Текст или значение внутри ячейки
   ColorText.i    ; Кастомный цвет текста для этой ячейки (-1, если стандартный)
   ColorBack.i    ; Кастомный цвет фона для этой ячейки (-1, если стандартный)
   ImageID.i      ; Ссылка на иконку внутри ячейки (если понадобится)
   
   ; Свойства строки переехали сюда, так как ячейка теперь представляет пересечение строки и колонки
   IsChecked.b     ; Состояние чекбокса
   RowColorBack.i  ; Кастомный цвет фона всей строки (для этого сегмента)
   Note$           ; Заметка для строки
EndStructure

; Описание одной колонки в шапке
Structure _s_COLS
   ID.i        ; Жесткий внутренний ID (паспорт) этой колонки в памяти
   Title$      ; Название колонки (отображаемый текст)
   Width.i     ; Текущая ширина колонки в пикселях
   align.b     ; Выравнивание текста в этой колонке
   
   ; ВЛОЖЕННОСТЬ: Динамический список ячеек (строк) внутри этой конкретной колонки!
   List row._s_CELLS()
EndStructure

; Управляющая структура строк (теперь без глобального связного списка, только метаданные)
Structure _s_ROW             
   count.i     ; Общее количество строк данных
   Height.i    ; Фиксированная высота строки
   selected.i  ; Индекс выделенной строки (-1 если нет)
   hovered.i   ; Строка под курсором мыши
EndStructure

; Управляющая структура колонок
Structure _s_COL  
   count.i     ; Общее количество колонок в шапке 
   Height.i    ; Высота шапки таблицы
   Width.i     ; Сюда мы запишем суммарную ширину всех колонок в пикселях
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
   
   ; Настройки/Стили
   GridLines.b     ; Включена ли сетка (#True/#False)
   CheckBoxes.b    ; Включены ли чекбоксы (#True/#False)
   FullRowSelect.b ; Выделять ли строку целиком (#True/#False)
   
   ; Индексы состояний (row теперь содержит только счетчики и высоты)
   row._s_ROW
   col._s_COL
   
   ; Поля для ресайза колонок мышкой
   IsResizing.b          ; Флаг: зажата ли граница колонки прямо сейчас
   ResizeColVisual.i     ; Какую именно колонку тянут (индекс)
   ResizeStartMouseX.i   ; Начальная координата мыши X при клике
   ResizeStartWidth.i    ; Исходная ширина колонки до изменения размера
EndStructure

Global *this._s_WIDGET
Global StatusBarHeight = 30
Global SplittSize = 0

; --- ФУНКЦИЯ ОТРИСОВКИ ---
; Возвращает точную координату X для текста с учетом выравнивания и ширины колонки
Procedure.i GetTextX(ColumnX.i, ColumnWidth.i, TextWidth.i, AlignFlags.l, Offset.i = 10)
  If AlignFlags & #__align_right
    ProcedureReturn ColumnX + ColumnWidth - TextWidth - Offset
  ElseIf AlignFlags & #__align_center
    ProcedureReturn ColumnX + (ColumnWidth - TextWidth) / 2
  Else
    ProcedureReturn ColumnX + Offset
  EndIf
EndProcedure

Procedure ReDraw(*this._s_WIDGET) 
   Protected CanvasID.i = *this\CanvasID
   Protected W = GadgetWidth(CanvasID)
   Protected H = GadgetHeight(CanvasID)
   Protected RowHeight = *this\row\height
   Protected ColHeight = *this\col\height
   Protected r, c, X, Y
   
   If StartDrawing(CanvasOutput(CanvasID))
      
      ; 1. Заливаем рабочую область базовым белым цветом
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, W, H, RGB(255, 255, 255))
      
      ; ====================================================
      ; ГЛАВНЫЙ ЦИКЛ: Итерируем список колонок ровно ОДИН раз
      ; ====================================================
      X = *this\OffsetX ; Стартуем X с учетом горизонтального скролла
      c = 0
      
      ForEach *this\col\_s()
         Protected *col._s_COLS = @*this\col\_s()
         Protected ColumnWidth = *col\Width
         Protected title$ = *col\Title$
         
         ; Отрисовываем колонку, только если она видна на экране по горизонтали
         If X + ColumnWidth >= 0 And X <= W
            
            ; ------------------------------------------------
            ; ЧАСТЬ 1: Вложенный цикл строк внутри ТЕКУЩЕЙ колонки
            ; ------------------------------------------------
            ; Ограничиваем область рисования: строго под шапкой и до статус-бара.
            ; Благодаря этому ячейки при скролле не вылезут на шапку, а текст не налезет на соседа при ресайзе!
            ClipOutput(X, ColHeight, ColumnWidth, H - ColHeight - statusbarHeight)
            
            r = 0
            ForEach *col\row() ; Перебираем встроенный список строк (ячеек) этой колонки
               Y = r * RowHeight + *this\OffsetY + ColHeight
               
               ; Проверяем видимость ячейки по вертикали
               If Y >= ColHeight - RowHeight And Y <= H - statusbarHeight
                  
                  ; Фон строки (рисуется сегментом под текущей колонкой)
                  DrawingMode(#PB_2DDrawing_Default)
                  If r = *this\row\selected
                     Box(X, Y, ColumnWidth, RowHeight, RGB(220, 235, 255))
                  ElseIf r = *this\row\hovered
                     Box(X, Y, ColumnWidth, RowHeight, RGB(245, 247, 250))
                  EndIf
                  
                  ; Сетка ячейки
                  DrawingMode(#PB_2DDrawing_Outlined)
                  Box(X, Y, ColumnWidth + 1, RowHeight + 1, RGB(220, 220, 220))
                  
                  ; Рамка фокуса на ячейке
                  If r = *this\row\selected And c = *this\col\selected
                     Box(X + 1, Y + 1, ColumnWidth - 1, RowHeight - 1, RGB(0, 102, 204))
                  EndIf
                  
                  ; Текст ячейки
                  DrawingMode(#PB_2DDrawing_Transparent)
                  Protected text$ = *col\row()\text$
                  Protected text_x = GetTextX(X, ColumnWidth, TextWidth(text$), *col\align)
                  DrawText(text_x, Y + (RowHeight - TextHeight("Y")) / 2, text$, RGB(50, 50, 50))
                  
               EndIf
               r + 1
            Next
            
            ; Сбрасываем ClipOutput, чтобы нарисовать фиксированную шапку поверх данных
            ClipOutput(X, 0, ColumnWidth, ColHeight)
       
            ; ------------------------------------------------
            ; ЧАСТЬ 2: Рисуем сегмент шапки для этой колонки
            ; ------------------------------------------------
            DrawingMode(#PB_2DDrawing_Default)
            Box(X, 0, ColumnWidth, ColHeight, RGB(230, 232, 236)) ; Серый фон
            
            ; Подсветка ховера или выделения самой шапки
            If ListIndex(*this\col\_s()) = *this\col\selected
               Box(X, 0, ColumnWidth, ColHeight, RGB(220, 235, 255))
            ElseIf ListIndex(*this\col\_s()) = *this\col\hovered And *this\row\hovered = -1
               Box(X, 0, ColumnWidth, ColHeight, RGB(245, 247, 250))
            EndIf
            
            ; Вертикальные границы шапки
            Line(X, 0, 1, ColHeight, RGB(190, 195, 200))
            Line(X + ColumnWidth, 0, 1, ColHeight, RGB(190, 195, 200))
            
            ; Текст шапки
            DrawingMode(#PB_2DDrawing_Transparent)
            Protected title_x = GetTextX(X, ColumnWidth, TextWidth(title$), *col\align)
            DrawText(title_x, (ColHeight - TextHeight("Y")) / 2, title$, RGB(40, 45, 55))
            
         EndIf
         
         ; Сдвигаем X на ширину текущей колонки
         X + ColumnWidth + SplittSize
         c + 1
      Next
      
      ; Нижняя сплошная разделительная черта шапки (рисуем поверх всех сегментов)
      DrawingMode(#PB_2DDrawing_Default)
      Line(0, ColHeight - 1, W, 1, RGB(180, 185, 190))
      
      ; ----------------------------------------------------
      ; ЭТАП 3: НИЖНИЙ СТАТУС-БАР (Всегда поверх всего в самом низу)
      ; ----------------------------------------------------
      Box(0, H - statusbarHeight, W, statusbarHeight, RGB(235, 235, 240))
      Line(0, H - statusbarHeight, W, 1, RGB(180, 180, 180))
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(10, H - 22, "Колоночный Grid: Строки внутри Колонок. Один цикл.", RGB(100, 100, 100))
      
      StopDrawing()
   EndIf
EndProcedure


; --- ОБРАБОТКА МЫШИ (Исправленная под динамические колонки) ---
Procedure HowerColumnn(*this._s_WIDGET, X)
   Protected HoverCol = -1
   Protected currentX = *this\OffsetX
   Protected visualCol = 0
   ForEach *this\col\_s()
      Protected ColumnWidth = *this\col\_s()\Width
      If X >= currentX And X < currentX + ColumnWidth
         HoverCol = visualCol
         Break
      EndIf
      currentX + ColumnWidth + SplittSize
      visualCol + 1
   Next
   ProcedureReturn HoverCol
EndProcedure

Procedure GetColumn(*this._s_WIDGET, col.l)
   ForEach *this\col\_s()
      If *this\col\_s()\ID = col
         ProcedureReturn @*this\col\_s() ; Нашли нужный паспорт данных!
      EndIf
   Next
EndProcedure

Procedure.s GetItemText(*this._s_WIDGET, row.l, col.l)
   ; 1. Защита от выхода за границы строк
   If row < 0 Or row >= *this\row\count : ProcedureReturn "" : EndIf
   
   ; 2. Ищем колонку с нужным ID
   Protected *col._s_COLS = GetColumn(*this, col)
   If *col
      ; 3. Нашли колонку, выбираем в ней нужную строку
      If SelectElement(*col\row(), row)
         ProcedureReturn *col\row()\text$
      EndIf
   EndIf
   ProcedureReturn ""
EndProcedure

Procedure SetItemText(*this._s_WIDGET, row.l, col.l, text$)
   ; 1. Защита от выхода за границы строк
   If row < 0 Or row >= *this\row\count : ProcedureReturn #False : EndIf
   
   ; 2. Ищем колонку с нужным ID
   Protected *col._s_COLS = GetColumn(*this, col)
   If *col
      ; 3. Нашли колонку, выбираем в ней нужную строку
      If SelectElement(*this\col\_s()\row(), row)
         *this\col\_s()\row()\text$ = text$
         ReDraw(*this) 
         ProcedureReturn #True
      EndIf
   EndIf
   ProcedureReturn #False
EndProcedure


Procedure ClearItems(*this._s_WIDGET)
   ; 1. Заходим в каждую колонку и полностью очищаем её внутренний список ячеек (строк)
   ForEach *this\col\_s()
      ClearList(*this\col\_s()\row())
   Next
   
   ; 2. Обнуляем счетчики и сбрасываем состояния
   *this\row\count = 0
   *this\row\selected = -1
   *this\col\selected = -1
   *this\row\hovered  = -1
   *this\col\hovered  = -1
   *this\OffsetY = 0
   
   ReDraw(*this)
EndProcedure

Procedure RemoveItem(*this._s_WIDGET, row.l)
   ; 1. Защита от выхода за границы общего количества строк
   If row < 0 Or row >= *this\row\count : ProcedureReturn #False : EndIf
   
   ; 2. Синхронно удаляем элемент с индексом 'row' из каждой колонки
   ForEach *this\col\_s()
      If SelectElement(*this\col\_s()\row(), row)
         DeleteElement(*this\col\_s()\row())
      EndIf
   Next
   
   ; 3. Корректировка выделения и сброс ховера
   If *this\row\selected = row
      *this\row\selected = -1
      *this\col\selected = -1
   ElseIf *this\row\selected > row
      *this\row\selected - 1
   EndIf
   
   *this\row\hovered = -1
   
   ; 4. Обновляем счетчик строк (берем размер списка из любой колонки, например первой)
   If FirstElement(*this\col\_s())
      *this\row\count = ListSize(*this\col\_s()\row())
   Else
      *this\row\count = 0
   EndIf
   
   ReDraw(*this)
   ProcedureReturn #True
EndProcedure

Procedure MoveItem(*this._s_WIDGET, FromIndex.l, ToIndex.l)
   If FromIndex = ToIndex : ProcedureReturn #True : EndIf 
   
   ; 1. Защита от выхода за границы
   If FromIndex < 0 Or FromIndex >= *this\row\count : ProcedureReturn #False : EndIf
   If ToIndex < 0 Or ToIndex >= *this\row\count : ProcedureReturn #False : EndIf
   
   ; 2. Синхронно перемещаем элементы во ВСЕХ колонках интерфейса
   ForEach *this\col\_s()
      Protected *col._s_COLS = @*this\col\_s()
      
      If ToIndex = 0
         SelectElement(*col\row(), FromIndex)
         MoveElement(*col\row(), #PB_List_First)
      Else
         ; Находим целевой элемент в текущей колонке
         SelectElement(*col\row(), ToIndex)
         Protected *targetCell._s_CELLS = @*col\row()
         
         ; Возвращаемся к перемещаемому элементу
         SelectElement(*col\row(), FromIndex)
         
         ; Перемещаем относительно целевого элемента
         If FromIndex < ToIndex
            MoveElement(*col\row(), #PB_List_After, *targetCell)
         Else
            MoveElement(*col\row(), #PB_List_Before, *targetCell)
         EndIf
      EndIf
   Next
   
   ; 3. Корректируем индекс выделенной строки
   If *this\row\selected = FromIndex
      *this\row\selected = ToIndex
   ElseIf FromIndex < ToIndex And *this\row\selected > FromIndex And *this\row\selected <= ToIndex
      *this\row\selected - 1
   ElseIf FromIndex > ToIndex And *this\row\selected >= ToIndex And *this\row\selected < FromIndex
      *this\row\selected + 1
   EndIf
   
   *this\row\hovered = -1
   
   ReDraw(*this)
   ProcedureReturn #True
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

Procedure RemoveColumn(*this._s_WIDGET, col.l)
   ; 1. Защита от выхода за границы общего количества колонок
   If col < 0 Or col >= *this\col\count : ProcedureReturn #False : EndIf
   
   ; 2. Выбираем нужную колонку по её порядковому номеру
   If SelectElement(*this\col\_s(), col)
      
      ; 3. ФИЗИЧЕСКИ УДАЛЯЕМ КОЛОНКУ.
      ; Магия: PureBasic сам автоматически уничтожит встроенный список row() 
      ; и освободит всю память от текстов ячеек этой колонки без всяких циклов!
      DeleteElement(*this\col\_s())
      
      ; 4. Обновляем счетчик общего количества колонок
      *this\col\count = ListSize(*this\col\_s())
      
      ; 5. Корректируем индексы выделения и ховера
      If *this\col\selected = col
         *this\col\selected = -1
         *this\row\selected = -1 ; Сбрасываем и строку, так как активная ячейка пропала
      ElseIf *this\col\selected > col
         *this\col\selected - 1
      EndIf
      *this\col\hovered = -1
      
      ; 6. Перерисовываем таблицу (колонка мгновенно исчезает с экрана)
      ReDraw(*this)
      ProcedureReturn #True ; Успешно удалено
   EndIf
   
   ProcedureReturn #False
EndProcedure

; =====================================================================
; Новая процедура: Физически меняет ширину колонки по её визуальному индексу
; =====================================================================
Procedure ResizeColumn(*this._s_WIDGET, colVisualIndex.l, NewWidth.l)
   If NewWidth < 20 : NewWidth = 20 : EndIf
   
   If colVisualIndex >= 0 And colVisualIndex < *this\col\count
      SelectElement(*this\col\_s(), colVisualIndex)
      
      ; Вычисляем разницу между старой и новой шириной
      Protected OldWidth = *this\col\_s()\Width
      Protected DeltaWidth = NewWidth - OldWidth
      
      ; Обновляем ширину конкретной колонки
      *this\col\_s()\Width = NewWidth
      
      ; Обновляем сохраненную общую ширину в структуре БЕЗ циклов
      *this\col\width + DeltaWidth
      
      ReDraw(*this)
      ProcedureReturn #True
   EndIf
   ProcedureReturn #False
EndProcedure

; Вспомогательная функция: Проверяет, находится ли X мыши на правой границе какой-либо колонки
Procedure GetColumnResizeBorder(*this._s_WIDGET, X.l)
   Protected currentX = *this\OffsetX
   Protected visualCol = 0
   Protected ZoneWidth = 4 ; Чувствительность зоны клика (в пикселях)
   
   ForEach *this\col\_s()
      Protected ColumnWidth = *this\col\_s()\Width
      Protected BorderX = currentX + ColumnWidth
      
      ; Если курсор мыши попал в зону стыка колонок (+/- 4 пикселя)
      If X >= BorderX - ZoneWidth And X <= BorderX + ZoneWidth
         ProcedureReturn visualCol ; Возвращаем визуальный индекс этой колонки
      EndIf
      
      currentX + ColumnWidth + SplittSize
      visualCol + 1
   Next
   
   ProcedureReturn -1 ; Мышь не на границе
EndProcedure

Procedure.i GetTotalColumnsWidth(*this._s_WIDGET)
   ProcedureReturn *this\col\width
   Protected TotalWidth.i = 0
   ForEach *this\col\_s()
      TotalWidth + *this\col\_s()\Width
   Next
   ProcedureReturn TotalWidth
EndProcedure

Procedure AddColumn(*this._s_WIDGET, title$, Width.l, align.i=0)
   Protected *col._s_COLS
   
   *this\col\count = ListSize(*this\col\_s()) 
   *col = AddElement(*this\col\_s()) 
   *col\Title$ = title$
   *col\Width = Width 
   *col\align = align
   *col\ID = *this\col\count
   
   ; ----------------------------------------------------
   ; СИНХРОНИЗАЦИЯ СТРОК (Важнейшее исправление для нового подхода)
   ; ----------------------------------------------------
   ; Если в таблице уже есть строки, новая колонка обязана содержать 
   ; ровно столько же пустых ячеек, иначе ReDraw упадет при отрисовке!
   If *this\row\count > 0
     Protected i.l
     For i = 1 To *this\row\count
         AddElement(*col\row())
         *col\row()\text$ = "" ; Инициализируем пустую ячейку данных
         ; *col\row()\ColorText = -1
         ; *col\row()\ColorBack = -1
      Next
   EndIf
   
   *this\col\width + Width ; Добавляем ширину новой колонки к общей сумме
   *this\col\count + 1
   ProcedureReturn *col
EndProcedure

; --- ЗАПОЛНЕНИЕ ДАННЫМИ ---
Procedure AddItem(*this._s_WIDGET, position.l, Text$, Image.i=-1, sublevel.l=0)
   Protected *col._s_COLS
   Protected *ptr.Character = @Text$
   Protected *colStart = *ptr
   
   ; Перебираем колонки. Если список пуст, ForEach просто пропустит весь этот блок!
   ForEach *this\col\_s()
      *col = @*this\col\_s()
      
      ; Быстрая вставка элемента во вложенный список текущей колонки
      If position = -1
         LastElement(*col\row())
         AddElement(*col\row())
      Else
         SelectElement(*col\row(), position)
         InsertElement(*col\row())
      EndIf
      
      ; Парсинг текста "на лету" прямо в память ячейки
      While *ptr\c <> 10 And *ptr\c <> 0
         *ptr + SizeOf(Character)
      Wend
      
      ; Копируем подстроку напрямую в ячейку
      *col\row()\Text$ = PeekS(*colStart, (*ptr - *colStart) >> 1)
      
      ; Инициализируем свойства ячейки
      *col\row()\ColorText = -1
      *col\row()\ColorBack = -1
      *col\row()\ImageID   = Image
      
      ; Сдвигаем указатели к началу следующего слова
      If *ptr\c = 10
         *ptr + SizeOf(Character)
      EndIf
      *colStart = *ptr
   Next
   
   ; Обновляем глобальный счетчик строк виджета.
   ; Проверяем, указывает ли список на элемент (был ли выполнен цикл хотя бы раз).
   ; Если да — пишем реальный размер списка, если нет — строк в гриде 0.
   *this\row\count = ListSize(*this\col\_s()\row())
EndProcedure


Procedure CanvasCallback()
   Protected CanvasID.i = EventGadget()
   ;Protected *this._s_WIDGET = GetGadgetData(CanvasID)
   If Not *this : ProcedureReturn : EndIf
   Protected ReDraw = #False
   Protected MouseX = GetGadgetAttribute(CanvasID, #PB_Canvas_MouseX)
   Protected MouseY = GetGadgetAttribute(CanvasID, #PB_Canvas_MouseY)
   Protected Height = GadgetHeight(CanvasID)
   Protected WheelDelta = GetGadgetAttribute(CanvasID, #PB_Canvas_WheelDelta)
   
   ; Высота одной строки в таблице 
   Protected RowHeight = *this\row\height 
   
   ; Координаты клика/ховера по строкам рассчитываются с вычетом высоты шапки
   Protected GridX = MouseX - *this\OffsetX
   Protected GridY = MouseY - *this\OffsetY - *this\col\height
   
   ; Точный расчет колонки под мышью по их ширине ---
   Protected HoverCol = HowerColumnn(*this, MouseX)
   Protected HoverRow = GridY / RowHeight
   
   ; Если мышка находится в зоне шапки или статус-бара, отключаем ховер строк
   If MouseY < *this\col\height
      HoverRow = -1
   EndIf
   
   If MouseY > Height - StatusBarHeight
      HoverRow = -1
      HoverCol = -1
   EndIf
   
   If HoverCol < 0 Or HoverCol >= *this\col\count : HoverCol = -1 : EndIf
   If HoverRow < 0 Or HoverRow >= *this\row\count : HoverRow = -1 : EndIf
   
   Select EventType()
         
      Case #PB_EventType_MouseMove
         ; 1. Если прямо сейчас пользователь ТЯНЕТ границу колонки:
         If *this\IsResizing
            Protected DeltaX = MouseX - *this\ResizeStartMouseX
            Protected NewWidth = *this\ResizeStartWidth + DeltaX
            ResizeColumn(*this, *this\ResizeColVisual, NewWidth)
            
            ; 2. Если пользователь просто двигает мышкой:
         Else
            ; Проверяем, находится ли мышь в районе шапки на стыке колок
            If HoverRow = -1
               Protected BorderCol = GetColumnResizeBorder(*this, MouseX)
               If BorderCol >= 0
                  ; Меняем курсор на стрелочки изменения размера <->
                  SetGadgetAttribute(CanvasID, #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
               Else
                  ; Возвращаем стандартный курсор-стрелку
                  SetGadgetAttribute(CanvasID, #PB_Canvas_Cursor, #PB_Cursor_Default)
               EndIf
            Else
               ; Если мышь ушла ниже шапки, возвращаем дефолтный курсор
               SetGadgetAttribute(CanvasID, #PB_Canvas_Cursor, #PB_Cursor_Default)
            EndIf
            
            ; Встроенный Hover (подсветка строки при наведении)
            If *this\row\hovered <> HoverRow
               *this\row\hovered = HoverRow
               ReDraw = #True
            EndIf
            
            If *this\col\hovered <> HoverCol
               *this\col\hovered = HoverCol
               ReDraw = #True
            EndIf
            
            
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         ; Проверяем, кликнул ли пользователь на границу колонки в шапке
         If HoverRow = -1
            Protected ClickedBorder = GetColumnResizeBorder(*this, MouseX)
            If ClickedBorder >= 0
               ; Включаем режим изменения размера
               *this\IsResizing = #True
               *this\ResizeColVisual = ClickedBorder
               *this\ResizeStartMouseX = MouseX
               
               ; Запоминаем текущую ширину колонки перед началом растягивания
               SelectElement(*this\col\_s(), ClickedBorder)
               *this\ResizeStartWidth = *this\col\_s()\Width
            EndIf
         Else
            ; Клик ниже шапки — встроенное выделение строки (Select)
            If *this\row\selected <> HoverRow
               *this\row\selected = HoverRow
               ReDraw = #True
            EndIf
         EndIf
         
         If *this\col\selected <> HoverCol
            *this\col\selected = HoverCol
            ReDraw = #True
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         ; Выключаем режим изменения размера при отпускании кнопки мыши
         If *this\IsResizing
            *this\IsResizing = #False
            SetGadgetAttribute(CanvasID, #PB_Canvas_Cursor, #PB_Cursor_Default)
         EndIf
         
      Case #PB_EventType_MouseWheel
         ; Если зажат Shift — крутим по горизонтали, иначе — по вертикали
         If GetGadgetAttribute(CanvasID, #PB_Canvas_Modifiers) & #PB_Canvas_Shift
            ; Считаем предел прокрутки: общая ширина колонок минус видимая ширина Canvas
            Protected MaxScrollX = GadgetWidth(CanvasID) - GetTotalColumnsWidth(*this)
            If MaxScrollX > 0 : MaxScrollX = 0 : EndIf ; Если всё влезает, лимит = 0
            
            *this\OffsetX + (WheelDelta * 30) ; Крутим влево/вправо
            
            ; Ограничиваем скролл рамками таблицы
            If *this\OffsetX > 0 : *this\OffsetX = 0 : EndIf
            If *this\OffsetX < MaxScrollX : *this\OffsetX = MaxScrollX : EndIf
         Else
            ; Твой стандартный вертикальный скролл
            *this\OffsetY + (WheelDelta * *this\row\height)
            If *this\OffsetY > 0 : *this\OffsetY = 0 : EndIf
         EndIf
         ReDraw = #True
         
      Case #PB_EventType_MouseLeave
         ; Сбрасываем подсветку и состояние, если мышь покинула гаджет
         If Not *this\IsResizing
            *this\row\hovered = -1
            *this\col\hovered = -1
            ReDraw = #True
         EndIf
         
   EndSelect
   
   If ReDraw : ReDraw(*this) : EndIf
EndProcedure

Procedure Open(window.i, X.l,Y.l,Width.l,Height.l, title$, Flag.i=0)
   OpenWindow(window, X,Y,Width,Height, title$, Flag)
   CanvasGadget(0, 0,0,Width,Height, #PB_Canvas_Keyboard)
   BindGadgetEvent(0, @CanvasCallback())
   ProcedureReturn 1
EndProcedure

Procedure ListIcon(X.l,Y.l,Width.l,Height.l, title$, titlewidth.l, Flag.i=0)
   Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
   *this\col\height = 50
   *this\col\selected = -1
   *this\col\hovered = -1
   ;
   *this\row\height = 30
   *this\row\selected = -1
   *this\row\hovered  = -1
   ProcedureReturn *this
EndProcedure

; --- ОКНО ПРИЛОЖЕНИЯ ---

If Open(0, 100, 100, 640, 480, "PureBasic 2D Grid with Header", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   *this = ListIcon(0, 0, 640, 480, "ID товара", 120)
   *this\CanvasID = 0
   
   ; 1. Заполняем ШАПКУ таблицы (тот самый верхний фиксированный ряд)
   AddColumn(*this, "ID товара", 120)
   AddColumn(*this, "Наименование", 120)
   AddColumn(*this, "Категория", 120, #__align_Center)
   AddColumn(*this, "Цена", 120, #__align_Right)
   AddColumn(*this, "Остаток", 120, #__align_Right)
   
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
   
       SetItemText(*this, 1, 3, "12345")
   ;    RemoveItem(*this, 1)
   ;    RemoveColumn(*this, 3)
       MoveColumn(*this, 1, 3)
       Debug GetItemText(*this, 1, 3)
   ;    MoveItem(*this, 1, 3)
   ; ResizeColumn(*this, 2, 240)
   
   Repeat
   Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 168
; FirstLine = 155
; Folding = ---------------
; EnableXP
; DPIAware