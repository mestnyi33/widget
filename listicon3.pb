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
  Title$          ; Название колонки (отображаемый текст)
  Width.i         ; Текущая ширина колонки в пикселях
  MinWidth.i      ; Минимальная ширина (чтобы пользователь не сжал колонку в 0)
  DataID.i        ; Жесткий внутренний ID (паспорт) этой колонки в памяти ячеек
  Alignment.b     ; Выравнивание текста в этой колонке (#Grid_Align_Left, и т.д.)
  IsHidden.b      ; Флаг: скрыта ли колонка (на будущее)
EndStructure

; Описание одной ячейки данных
Structure GridCell
  Value$          ; Текст или значение внутри ячейки
  ColorText.i     ; Кастомный цвет текста для этой ячейки (-1, если стандартный)
  ColorBack.i     ; Кастомный цвет фона для этой ячейки (-1, если стандартный)
  ImageID.i       ; Ссылка на иконку внутри ячейки (если понадобится)
EndStructure

; Описание одной строки таблицы
Structure GridRow
  IsHeader.b      ; Флаг: является ли эта строка шапкой
  IsChecked.b     ; Состояние чекбокса (для флага #__Flag_CheckBoxes)
  ColorBack.i     ; Кастомный цвет фона всей строки (например, для подсветки ошибок)
  Note$           ; Заметка для строки (ваше изначальное условие)
  
  List Columns.GridCell() ; Список ячеек, лежащих в исходном порядке (DataID)
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
  CellHeight.i    ; Фиксированная высота строки
  HeaderHeight.i  ; Высота шапки таблицы
  
  ; Индексы состояний
  SelectedRow.i   ; Индекс выделенной строки (-1 если нет)
  SelectedCol.i   ; Индекс выделенной колонки (визуальный, -1 если нет)
  HoveredRow.i    ; Строка под курсором мыши
  HoveredCol.i    ; Колонка под курсором мыши
  
  ; Настройки/Стили (Копии флагов вашего конструктора)
  GridLines.b     ; Включена ли сетка (#True/#False)
  CheckBoxes.b    ; Включены ли чекбоксы (#True/#False)
  FullRowSelect.b ; Выделять ли строку целиком (#True/#False)
  
  
  CellWidth.i
  
  ; Динамическая память гаджета
  List Headers.GridColumn() ; Список колонок шапки (управляет порядком вывода)
  List Rows.GridRow()       ; Список всех строк таблицы
EndStructure

Global MyGrid.PureGrid

; --- ЗАПОЛНЕНИЕ ДАННЫМИ ---

MyGrid\CellWidth  = 120
MyGrid\CellHeight = 30
MyGrid\SelectedRow = -1
MyGrid\SelectedCol = -1
MyGrid\HoveredRow  = -1

; 1. Заполняем ШАПКУ таблицы (тот самый верхний фиксированный ряд)
AddElement(MyGrid\Headers()) : MyGrid\Headers()\Title$ = "ID товара"
AddElement(MyGrid\Headers()) : MyGrid\Headers()\Title$ = "Наименование"
AddElement(MyGrid\Headers()) : MyGrid\Headers()\Title$ = "Категория"
AddElement(MyGrid\Headers()) : MyGrid\Headers()\Title$ = "Цена"
AddElement(MyGrid\Headers()) : MyGrid\Headers()\Title$ = "Остаток"
MyGrid\TotalCols = ListSize(MyGrid\Headers())

; 2. Заполняем обычные строки с данными (вниз)
Define r, c
For r = 1 To 20
  AddElement(MyGrid\Rows())
  MyGrid\Rows()\Note$ = ""
  
  ; Добавляем ячейки, соответствующие колонкам шапки
  AddElement(MyGrid\Rows()\Columns()) : MyGrid\Rows()\Columns()\Value$ = "#" + Str(1000 + r)
  AddElement(MyGrid\Rows()\Columns()) : MyGrid\Rows()\Columns()\Value$ = "Товар " + Str(r)
  AddElement(MyGrid\Rows()\Columns()) : MyGrid\Rows()\Columns()\Value$ = "Электроника"
  AddElement(MyGrid\Rows()\Columns()) : MyGrid\Rows()\Columns()\Value$ = Str(r * 150) + " руб"
  AddElement(MyGrid\Rows()\Columns()) : MyGrid\Rows()\Columns()\Value$ = Str(Random(50, 5)) + " шт"
Next
MyGrid\TotalRows = ListSize(MyGrid\Rows())


; --- ФУНКЦИЯ ОТРИСОВКИ ---

Procedure DrawGrid(CanvasID.i)
  Protected W = GadgetWidth(CanvasID)
  Protected H = GadgetHeight(CanvasID)
  Protected r, c, X, Y
  
  If StartDrawing(CanvasOutput(CanvasID))
    
    ; Белый фон для рабочей области таблицы
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, 0, W, H, RGB(255, 255, 255))
    
    ; ----------------------------------------------------
    ; ЭТАП 1: Рисуем строки данных (с учетом вертикального скролла)
    ; Обратите внимание: данные начинают рисоваться ПОД шапкой (смещаем на MyGrid\CellHeight)
    ; ----------------------------------------------------
    r = 0
    ForEach MyGrid\Rows()
      ; Y-координата строки: позиция + скролл + отступ под шапку
      Y = r * MyGrid\CellHeight + MyGrid\OffsetY + MyGrid\CellHeight
      
      ; Рисуем только то, что видно между Шапкой и Статус-баром
      If Y >= MyGrid\CellHeight And Y <= H - 30
        
        ; Подсветка ховера или выделения строки
        DrawingMode(#PB_2DDrawing_Default)
        If r = MyGrid\SelectedRow
          Box(0, Y, W, MyGrid\CellHeight, RGB(220, 235, 255)) ; Выделенная строка
        ElseIf r = MyGrid\HoveredRow
          Box(0, Y, W, MyGrid\CellHeight, RGB(245, 247, 250)) ; Ховер строки
        EndIf
        
        ; Рисуем ячейки текущей строки
        c = 0
        ForEach MyGrid\Rows()\Columns()
          X = c * MyGrid\CellWidth + MyGrid\OffsetX
          
          If X + MyGrid\CellWidth >= 0 And X <= W
            ; Сетка
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(X, Y, MyGrid\CellWidth + 1, MyGrid\CellHeight + 1, RGB(220, 220, 220))
            
            ; Рамка для фокуса на конкретной ячейке
            If r = MyGrid\SelectedRow And c = MyGrid\SelectedCol
              Box(X + 1, Y + 1, MyGrid\CellWidth - 1, MyGrid\CellHeight - 1, RGB(0, 102, 204))
            EndIf
            
            ; Текст данных
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText(X + 10, Y + (MyGrid\CellHeight - TextHeight("Y")) / 2, MyGrid\Rows()\Columns()\Value$, RGB(50, 50, 50))
          EndIf
          c + 1
        Next
      EndIf
      r + 1
    Next
    
    ; ----------------------------------------------------
    ; ЭТАП 2: ФИКСИРОВАННАЯ ШАПКА (Рисуется ПОВЕРХ строк, всегда на Y = 0)
    ; Она сдвигается по горизонтали (OffsetX), но никогда по вертикали!
    ; ----------------------------------------------------
    DrawingMode(#PB_2DDrawing_Default)
    ; Красивый серый градиентный фон для шапки
    Box(0, 0, W, MyGrid\CellHeight, RGB(230, 232, 236))
    ; Нижняя разделительная черта шапки
    Line(0, MyGrid\CellHeight - 1, W, 1, RGB(180, 185, 190))
    
    c = 0
    ForEach MyGrid\Headers()
      X = c * MyGrid\CellWidth + MyGrid\OffsetX
      
      If X + MyGrid\CellWidth >= 0 And X <= W
        ; Граница между колонками в шапке
        Line(X + MyGrid\CellWidth, 0, 1, MyGrid\CellHeight, RGB(190, 195, 200))
        
        ; Текст колонки (Жирный визуально за счет цвета или шрифта)
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(X + 10, (MyGrid\CellHeight - TextHeight("Y")) / 2, MyGrid\Headers()\Title$, RGB(40, 45, 55))
      EndIf
      c + 1
    Next
    
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


; --- ОБРАБОТКА МЫШИ (с учетом сдвига шапки) ---

Procedure CanvasCallback()
  Protected X = GetGadgetAttribute(0, #PB_Canvas_MouseX)
  Protected Y = GetGadgetAttribute(0, #PB_Canvas_MouseY)
  Protected Delta = GetGadgetAttribute(0, #PB_Canvas_WheelDelta)
  
  ; Координаты клика/ховера по строкам рассчитываются с вычетом высоты шапки
  Protected GridX = X - MyGrid\OffsetX
  Protected GridY = Y - MyGrid\OffsetY - MyGrid\CellHeight
  
  Protected HoverCol = GridX / MyGrid\CellWidth
  Protected HoverRow = GridY / MyGrid\CellHeight
  
  ; Если мышка находится в зоне шапки (Y < CellHeight), отключаем ховер строк
  If Y < MyGrid\CellHeight Or Y > GadgetHeight(0) - 30
    HoverRow = -1
    HoverCol = -1
  EndIf
  
  If HoverCol < 0 Or HoverCol >= MyGrid\TotalCols : HoverCol = -1 : EndIf
  If HoverRow < 0 Or HoverRow >= MyGrid\TotalRows : HoverRow = -1 : EndIf
  
  Select EventType()
    Case #PB_EventType_MouseMove
      If MyGrid\HoveredRow <> HoverRow
        MyGrid\HoveredRow = HoverRow
        DrawGrid(0)
      EndIf
      
    Case #PB_EventType_LeftButtonDown
      If HoverRow >= 0 And HoverCol >= 0
        MyGrid\SelectedRow = HoverRow
        MyGrid\SelectedCol = HoverCol
        DrawGrid(0)
      EndIf
      
    Case #PB_EventType_MouseWheel
      MyGrid\OffsetY + (Delta * 15)
      ; Ограничиваем скролл вверх
      If MyGrid\OffsetY > 0 : MyGrid\OffsetY = 0 : EndIf
      DrawGrid(0)
      
    Case #PB_EventType_MouseLeave
      MyGrid\HoveredRow = -1
      DrawGrid(0)
  EndSelect
EndProcedure


; --- ОКНО ПРИЛОЖЕНИЯ ---

If OpenWindow(0, 100, 100, 640, 480, "PureBasic 2D Grid with Header", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 640, 480, #PB_Canvas_Keyboard)
  BindGadgetEvent(0, @CanvasCallback())
  DrawGrid(0)
  
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 122
; FirstLine = 89
; Folding = ----
; EnableXP
; DPIAware