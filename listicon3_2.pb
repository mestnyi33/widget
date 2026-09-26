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

; Описание одной колонки в шапке
Structure _s_COLS
   ID.i        ; Жесткий внутренний ID (паспорт) этой колонки в памяти ячеек
   Title$      ; Название колонки (отображаемый текст)
   Width.i     ; Текущая ширина колонки в пикселях
               ;MinWidth.i      ; Минимальная ширина (чтобы пользователь не сжал колонку в 0)
               align.b     ; Выравнивание текста в этой колонке (#__align_Left, и т.д.)
                           ;IsHidden.b      ; Флаг: скрыта ли колонка (на будущее)
                 ; --- ДОБАВЛЯЕМ СЮДА ---
  TitleWidth.i  ; Здесь будет храниться вычисленная ширина текста заголовка в пикселях

EndStructure

; Описание одной ячейки данных
Structure _s_TXT
   String.s          ; Текст или значение внутри ячейки
   Width.i  ; Здесь будет храниться вычисленная ширина текста заголовка в пикселях
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
   
   Array txt._s_TXT(0) ; Список ячеек, лежащих в исходном порядке (ID)
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
   
   ; Настройки/Стили (Копии флагов вашего конструктора)
   GridLines.b     ; Включена ли сетка (#True/#False)
   CheckBoxes.b    ; Включены ли чекбоксы (#True/#False)
   FullRowSelect.b ; Выделять ли строку целиком (#True/#False)
   
   
   ; Индексы состояний
   row._s_ROW
   col._s_COL
   
   ; --- ДОБАВЛЯЕМ СЮДА ---
  FontHeight.i  ; Сюда мы один раз запишем высоту текста
  
   ; --- ДОБАВИТЬ ЭТИ ПОЛЯ СЮДА ---
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
   Protected *row._s_ROWS 
   
   If StartDrawing(CanvasOutput(CanvasID))
      ; [ОПТИМИЗАЦИЯ]: Берем готовое значение из структуры
      If Not *this\FontHeight
         ; Если вы используете кастомный шрифт, сначала примените его:
         ; DrawingFont(GetGadgetFont(CanvasID)) 
         
         *this\FontHeight = TextHeight("Y")
         
;          ; Автоматически делаем высоту строки RowHeight кратной высоте шрифта (например, высота + отступы)
;          *this\row\height = *this\FontHeight + 8 
;          *this\col\height = *this\FontHeight + 10
      EndIf
      Protected FontHeight = *this\FontHeight
      
      ; Если вдруг виджет не инициализировался, делаем безопасную проверку
      If FontHeight = 0 : FontHeight = 16 : EndIf 
      
      ; 1. Белый фон для всей рабочей области таблицы
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, W, H, RGB(255, 255, 255))
      
      ; ====================================================
      ; ЭТАП 1: Рисуем строки данных (Снаружи) + Виртуальный скролл
      ; ====================================================
      ; Ограничиваем область рисования строк: строго между шапкой и статус-баром
      ClipOutput(0, ColHeight, W, H - ColHeight - statusbarHeight)
      
      ; [ОПТИМИЗАЦИЯ]: Вычисляем индекс первой видимой строки на основе скролла OffsetY
      Protected StartRow = Abs(*this\OffsetY) / RowHeight
      
      ; Вычисляем, сколько строк физически помещается на экране
      Protected VisibleRowsCount = ((H - ColHeight - statusbarHeight) / RowHeight) + 1
      Protected EndRow = StartRow + VisibleRowsCount
      
      ; Защита от выхода за пределы реального количества строк списка
      Protected TotalRows = ListSize(*this\row\_s())
      If EndRow > TotalRows - 1
         EndRow = TotalRows - 1
      EndIf
      
      ; Перемещаем указатель списка сразу на первую видимую строку (работает мгновенно)
      *row = SelectElement(*this\row\_s(), StartRow)
      If *row
         
         r = StartRow
         For r = StartRow To EndRow
            ; Вычисляем Y-координату для текущей строки данных
            Y = r * RowHeight + *this\OffsetY + ColHeight
            
            ; --- РИСУЕМ ФОН СТРОКИ (ЦЕЛЬНЫЙ BOX НА ВСЮ ШИРИНУ) ---
            DrawingMode(#PB_2DDrawing_Default)
            If r = *this\row\selected
               Box(0, Y, W, RowHeight, RGB(220, 235, 255)) ; Выделенная строка
            ElseIf r = *this\row\hovered
               Box(0, Y, W, RowHeight, RGB(245, 247, 250)) ; Ховер строки
            ElseIf r % 2 = 1
               Box(0, Y, W, RowHeight, RGB(252, 252, 254)) ; Легкая "зебра" для читаемости
            EndIf
            
            ; --- ВНУТРЕННИЙ ЦИКЛ: КОЛОНКИ СТРОКИ ---
            X = *this\OffsetX ; Стартуем X от текущего горизонтального скролла
            c = 0
            
            ForEach *this\col\_s()
               Protected *col._s_COLS = @*this\col\_s()
               Protected ColumnWidth = *col\Width
               
               ; Отрисовываем ячейку только если она видна на экране по горизонтали
               If X + ColumnWidth >= 0 And X <= W
                  ; Сетка ячейки
                  DrawingMode(#PB_2DDrawing_Outlined)
                  Box(X, Y, ColumnWidth + 1, RowHeight + 1, RGB(220, 220, 220))
                  
                  ; Рамка активного фокуса на конкретной ячейке
                  If r = *this\row\selected And c = *this\col\selected
                     Box(X + 1, Y + 1, ColumnWidth - 1, RowHeight - 1, RGB(0, 102, 204))
                  EndIf
                  
                  ; Текст данных ячейки
                  Protected *txt._s_TXT = *row\txt(*col\ID)
                  Protected text$ = *txt\string
                  ; [ОПТИМИЗАЦИЯ]: Берем готовое значение из структуры
                  If Not *txt\width
                     If text$ <> ""
                        *txt\width = TextWidth(text$)
                     Else
                        *txt\width = 1
                     EndIf
                  EndIf
                  
                  If text$ <> ""
                   ; Локально зажимаем текст в рамки колонки (с отступом в 2 пикселя от краев)
                     ClipOutput(X + 2, ColHeight, ColumnWidth - 3, H - ColHeight - statusbarHeight)
                     
                     DrawingMode(#PB_2DDrawing_Transparent)
                     Protected text_x = GetTextX(X, ColumnWidth, *txt\width, *col\align)
                     DrawText(text_x, Y + (RowHeight - FontHeight) / 2, text$, RGB(50, 50, 50))
                     
                     ; Возвращаем общую обрезку для области строк данных
                     ClipOutput(0, ColHeight, W, H - ColHeight - statusbarHeight)
                  EndIf
               EndIf
               
               ; Смещаем X на ширину текущей колонки и разделителя
               X + ColumnWidth + SplittSize
               c + 1
            Next
            
            ; [ИСПРАВЛЕНИЕ ОШИБКИ]: Переходим к следующей строке и синхронизируем указатель *row
            *row = NextElement(*this\row\_s())
            If *row = 0
               Break
            EndIf
         Next
      EndIf
      
      ; [КРИТИЧЕСКИЙ СБРОС]: Отменяем обрезку перед отрисовкой шапки поверх строк!
      UnclipOutput()
      
      ; ====================================================
      ; ЭТАП 2: ФИКСИРОВАННАЯ ШАПКА
      ; ====================================================
      DrawingMode(#PB_2DDrawing_Default)
      ; Общий базовый серый фон для всей полосы шапки
      Box(0, 0, W, ColHeight, RGB(230, 232, 236))
      
      X = *this\OffsetX ; Сбрасываем X для отрисовки колонок шапки с учетом скролла
      ForEach *this\col\_s()
         *col = @*this\col\_s()
         ColumnWidth = *col\Width
         
         ; Отрисовываем элемент шапки, только если он виден на экране
         If X + ColumnWidth >= 0 And X <= W
            
            DrawingMode(#PB_2DDrawing_Default)
            ; 1. СНАЧАЛА РИСУЕМ ФОН (Перезаписываем дефолтный серый, если активен ховер или селект)
            If ListIndex(*this\col\_s()) = *this\col\selected
              ; Box(X, 0, ColumnWidth, ColHeight, RGB(220, 235, 255)) ; Выделенная колонка
            ElseIf ListIndex(*this\col\_s()) = *this\col\hovered And *this\row\hovered = -1
               Box(X, 0, ColumnWidth, ColHeight, RGB(245, 247, 250)) ; Ховер колонки
            EndIf
            
            ; 2. РИСУЕМ ТЕКСТ (Зажимаем обрезкой, чтобы длинный заголовок не вылезал на соседние колонки)
            Protected title$ = *col\Title$
            ; [ОПТИМИЗАЦИЯ]: Берем готовое значение из структуры
            If Not *col\TitleWidth
               If title$ <> ""
                  *col\TitleWidth = TextWidth(title$)
               Else
                  *col\TitleWidth = 1
               EndIf
            EndIf
            ClipOutput(X + 2, 0, ColumnWidth - 3, ColHeight)
            DrawingMode(#PB_2DDrawing_Transparent)
            Protected title_x = GetTextX(X, ColumnWidth, *col\TitleWidth, *col\align)
            DrawText(title_x, (ColHeight - FontHeight) / 2, title$, RGB(40, 45, 55))
            UnclipOutput() ; Сразу сбрасываем локальную обрезку текста
            
            ; 3. В САМЫЙ КОНЕЦ РИСУЕМ ЛИНИИ (Они лягут ПОВЕРХ любого ховера/выделения и не затрутся)
            DrawingMode(#PB_2DDrawing_Default)
            Line(X, 0, 1, ColHeight, RGB(190, 195, 200))
            Line(X + ColumnWidth, 0, 1, ColHeight, RGB(190, 195, 200))
         EndIf
         
         ; Сдвигаем X на ширину текущей колонки шапки
         X + ColumnWidth + SplittSize
      Next
      
      ; Нижняя сплошная разделительная черта шапки (рисуется поверх стыков)
      DrawingMode(#PB_2DDrawing_Default)
      Line(0, ColHeight - 1, W, 1, RGB(180, 185, 190))
      
      ; ====================================================
      ; ЭТАП 3: Нижний Статус-бар (Всегда поверх всего в самом низу)
      ; ====================================================
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, H - statusbarHeight, W, statusbarHeight, RGB(235, 235, 240))
      Line(0, H - statusbarHeight, W, 1, RGB(180, 180, 180))
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(10, H - statusbarHeight + (statusbarHeight - FontHeight) / 2, "Оптимизированный монолитный Grid: вертикальный скролл строк и шапки.", RGB(100, 100, 100))
      
      StopDrawing()
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

Procedure GetRowCell(*this._s_WIDGET, row.l, col.l)
   Protected *col._s_COLS
   Protected *row._s_ROWS = GetItem(*this, row)
   If *row
      *col = GetColumn(*this._s_WIDGET, col.l)
      If *col
         ProcedureReturn *row\txt(*col\ID)
      EndIf
   EndIf
EndProcedure

Procedure.s GetItemText(*this._s_WIDGET, row.l, col.l)
   Protected *txt._s_TXT = GetRowCell(*this, row, col.l)
   If *txt
      ProcedureReturn *txt\string
   EndIf
EndProcedure

Procedure SetItemText(*this._s_WIDGET, row.l, col.l, text$)
   Protected *txt._s_TXT = GetRowCell(*this, row, col.l)
   If *txt
      *txt\string = text$
      ReDraw(*this) 
      ProcedureReturn #True ; Успешно
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
      ; PureBasic сам автоматически уничтожит вложенный массив txt() для этой строки!
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
   ; PureBasic сам автоматически уничтожит все вложенные массивы txt() и тексты ячеек!
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

Procedure RemoveColumn(*this._s_WIDGET, col.l)
   Protected *txt._s_TXT
   Protected *col._s_COLS = GetColumn(*this, col)
   If *col
      ; 3. Пробегаемся по ВСЕМ строкам таблицы и освобождаем память от текста в этой ячейке
      ForEach *this\row\_s()
         *txt = @*this\row\_s()\txt(*col\ID)
         
         ; Присвоение пустой строки в PureBasic автоматически освобождает память,
         ; которую занимал текст этой конкретной ячейки в операционной системе
         *txt\string = ""
         *txt\ColorText = -1
         *txt\ColorBack = -1
         *txt\ImageID   = -1
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

Procedure AddColumn(*this._s_WIDGET, position, title$, Width.l, img.i = -1, align.i= #__align_left)
   Protected *col._s_COLS
   *this\col\count = ListSize(*this\col\_s()) 
   *col = AddElement(*this\col\_s()) 
   *col\Title$ = title$
   *col\Width = Width 
   *col\align = align
   *col\ID = *this\col\count
   ;
   *this\col\width + Width ; Добавляем ширину новой колонки к общей сумме
   *this\col\count + 1
   ProcedureReturn @*col
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
   
   Protected *row._s_ROWS = @*this\row\_s()
   ; Инициализируем базовые поля строки
   *row\Note$ = ""
   *row\ColorBack = -1 
   
   ; Меняем размер массива ячеек под количество колонок
   ReDim *row\txt(*this\col\count - 1)
   
   ; 2. ОПТИМИЗИРОВАННЫЙ СВЕРХБЫСТРЫЙ ПАРСИНГ
   Protected *ptr.Character = @text$
   Protected *colStart = *ptr
   Protected currentCol = 0
   Protected *txt._s_TXT
   
   While currentCol < *this\col\count
      ; Если нашли разделитель ИЛИ строка уже давно закончилась, но массив надо заполнить
      If *ptr\c = 10 Or *ptr\c = 0
         *txt = @*row\txt(currentCol)
         
         ; Если старт совпадает с ptr (строка закончилась), PeekS автоматически запишет ""
         *txt\string = PeekS(*colStart, (*ptr - *colStart) >> 1)
         *txt\ColorText = -1 
         *txt\ColorBack = -1 
         *txt\ImageID = Image
         
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
   AddColumn(*this, -1, title$, titlewidth)
   ProcedureReturn *this
EndProcedure

; --- ОКНО ПРИЛОЖЕНИЯ ---

If Open(0, 100, 100, 640, 480, "PureBasic 2D Grid with Header", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   *this = ListIcon(0, 0, 640, 480, "ID товара", 120)
   *this\CanvasID = 0
   
   ; 1. Заполняем ШАПКУ таблицы (тот самый верхний фиксированный ряд)
   AddColumn(*this, -1, "Наименование", 120, -1)
   AddColumn(*this, -1, "Категория", 120, -1, #__align_Center)
   AddColumn(*this, -1, "Цена", 120, -1, #__align_Right)
   AddColumn(*this, -1, "Остаток", 120, -1, #__align_Right)
   
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
       MoveColumn(*this, 1, 3)
   ;    MoveItem(*this, 1, 3)
   ; ResizeColumn(*this, 2, 240)
   
   Repeat
   Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 597
; FirstLine = 510
; Folding = --------+--------
; EnableXP
; DPIAware