EnableExplicit

; --- СТРУКТУРЫ ДАННЫХ ---

Structure GridCell
  text$          ; Текст ячейки
EndStructure

Structure GridRow
  Note$           ; Если не пусто "", то это строка-заметка (в ней нет ячеек)
  List Cells.GridCell() ; Список ячеек (только для обычных строк)
EndStructure

Structure PureGrid
  TotalRows.i
  TotalCols.i
  CellWidth.i
  CellHeight.i
  OffsetX.i       
  OffsetY.i       
  SelectedRow.i   
  SelectedCol.i   
  HoveredRow.i    
  List Rows.GridRow()
EndStructure

Global MyGrid.PureGrid

; --- ХЕЛПЕРЫ ДЛЯ ЗАПОЛНЕНИЯ ДАННЫХ ---

Procedure AddNormalRow()
  AddElement(MyGrid\Rows())
  MyGrid\Rows()\Note$ = "" ; Это ОБЫЧНАЯ строка, у неё будут ячейки
  MyGrid\TotalRows = ListSize(MyGrid\Rows())
EndProcedure

Procedure AddCellToCurrentRow(Text.s)
  ; Добавляем ячейку в текущую строку
  AddElement(MyGrid\Rows()\Cells())
  MyGrid\Rows()\Cells()\text$ = Text
  
  ; Считаем максимальное число колонок для контроля границ
  If ListSize(MyGrid\Rows()\Cells()) > MyGrid\TotalCols
    MyGrid\TotalCols = ListSize(MyGrid\Rows()\Cells())
  EndIf
EndProcedure

Procedure AddNoteRow(Text.s)
  AddElement(MyGrid\Rows())
  MyGrid\Rows()\Note$ = Text ; Это строка-заметка, у неё НЕТ ячеек
  MyGrid\TotalRows = ListSize(MyGrid\Rows())
EndProcedure

; Инициализация параметров
MyGrid\CellWidth  = 120
MyGrid\CellHeight = 30
MyGrid\SelectedRow = -1
MyGrid\SelectedCol = -1
MyGrid\HoveredRow  = -1

; ЗАПОЛНЯЕМ ТЕСТОВЫМИ ДАННЫМИ СТРОГО ПО ВАШЕМУ УСЛОВИЮ
Define r, c
For r = 1 To 15
  If r % 3 = 0
    ; Каждая 3-я строка — это просто строка-заметка (информационная лента)
    AddNoteRow("Заметка для строки " + Str(r) + ": Проверить баланс!")
  Else
    ; Все остальные строки — это нормальные строки таблицы с ячейками (Rows)
    AddNormalRow()
    For c = 1 To 5
      AddCellToCurrentRow("Ячейка " + Str(r) + "," + Str(c))
    Next
  EndIf
Next

; --- ФУНКЦИЯ ОТРИСОВКИ ---

Procedure DrawGrid(CanvasID.i)
  Protected W = GadgetWidth(CanvasID)
  Protected H = GadgetHeight(CanvasID)
  Protected r, c, X, Y
  
  If StartDrawing(CanvasOutput(CanvasID))
    
    ; Белый фон для всего холста
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, 0, W, H, RGB(255, 255, 255))
    
    r = 0
    ForEach MyGrid\Rows()
      Y = r * MyGrid\CellHeight + MyGrid\OffsetY
      
      ; Отсекаем то, что не влазит по вертикали (оставляя снизу место под статус-бар)
      If Y + MyGrid\CellHeight >= 0 And Y <= H - 30
        
        ; 1. ЕСЛИ ЭТО СТРОКА-ЗАМЕТКА
        If MyGrid\Rows()\Note$ <> ""
          
          ; Рисуем сплошной желтоватый фон для строки-заметки
          DrawingMode(#PB_2DDrawing_Default)
          Box(0, Y, W, MyGrid\CellHeight, RGB(255, 243, 224))
          
          ; Бордюры сверху и снизу заметки
          Line(0, Y, W, 1, RGB(255, 183, 77))
          Line(0, Y + MyGrid\CellHeight - 1, W, 1, RGB(255, 183, 77))
          
          ; Пишем текст заметки
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText(15, Y + (MyGrid\CellHeight - TextHeight("Y")) / 2, "📌 " + MyGrid\Rows()\Note$, RGB(216, 67, 21))
          
        Else
          ; 2. ЕСЛИ ЭТО ОБЫЧНАЯ СТРОКА (ROW) С ЯЧЕЙКАМИ
          
          ; Подсветка ховера или выделения строки
          DrawingMode(#PB_2DDrawing_Default)
          If r = MyGrid\SelectedRow
            Box(0, Y, W, MyGrid\CellHeight, RGB(207, 216, 220)) ; Выбранная строка (серо-голубой)
          ElseIf r = MyGrid\HoveredRow
            Box(0, Y, W, MyGrid\CellHeight, RGB(245, 245, 245)) ; Ховер (светло-серый)
          EndIf
          
          ; Перебираем и рисуем ВСЕ ячейки (колонки) в этой строке
          c = 0
          ForEach MyGrid\Rows()\Cells()
            X = c * MyGrid\CellWidth + MyGrid\OffsetX
            
            ; Рисуем только если ячейка видна на экране по горизонтали
            If X + MyGrid\CellWidth >= 0 And X <= W
              
              ; Сетка ячейки (Бордюр)
              DrawingMode(#PB_2DDrawing_Outlined)
              Box(X, Y, MyGrid\CellWidth, MyGrid\CellHeight, RGB(200, 200, 200))
              
              ; Если это конкретно выбранная ячейка, рисуем синюю рамку
              If r = MyGrid\SelectedRow And c = MyGrid\SelectedCol
                Box(X + 1, Y + 1, MyGrid\CellWidth - 2, MyGrid\CellHeight - 2, RGB(25, 118, 210))
                Box(X + 2, Y + 2, MyGrid\CellWidth - 4, MyGrid\CellHeight - 4, RGB(25, 118, 210))
              EndIf
              
              ; Текст ячейки (Рисуем поверх всего!)
              DrawingMode(#PB_2DDrawing_Transparent)
              DrawText(X + 10, Y + (MyGrid\CellHeight - TextHeight("Y")) / 2, MyGrid\Rows()\Cells()\text$, RGB(33, 33, 33))
            EndIf
            c + 1
          Next
          
        EndIf
      EndIf
      r + 1
    Next
    
    ; 3. Нижний Статус-бар (перекрывает таблицу при скролле)
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, H - 30, W, 30, RGB(233, 235, 238))
    Line(0, H - 30, W, 1, RGB(180, 180, 180))
    
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(10, H - 22, "Таблица: Обычные строки имеют сетку и ячейки, а строки % 3 — это заметки.", RGB(100, 100, 100))
    
    StopDrawing()
  EndIf
EndProcedure

; --- ОБРАБОТКА МЫШИ ---

Procedure CanvasCallback()
  Protected X = GetGadgetAttribute(0, #PB_Canvas_MouseX)
  Protected Y = GetGadgetAttribute(0, #PB_Canvas_MouseY)
  Protected Delta = GetGadgetAttribute(0, #PB_Canvas_WheelDelta)
  
  Protected GridX = X - MyGrid\OffsetX
  Protected GridY = Y - MyGrid\OffsetY
  Protected HoverCol = GridX / MyGrid\CellWidth
  Protected HoverRow = GridY / MyGrid\CellHeight
  
  If HoverCol < 0 Or HoverCol >= MyGrid\TotalCols : HoverCol = -1 : EndIf
  If HoverRow < 0 Or HoverRow >= MyGrid\TotalRows : HoverRow = -1 : EndIf
  
  Select EventType()
    Case #PB_EventType_MouseMove
      If MyGrid\HoveredRow <> HoverRow
        MyGrid\HoveredRow = HoverRow
        DrawGrid(0)
      EndIf
      
    Case #PB_EventType_LeftButtonDown
      If HoverRow >= 0
        ; Находим выбранную строку в списке, чтобы проверить, является ли она заметкой
        SelectElement(MyGrid\Rows(), HoverRow)
        If MyGrid\Rows()\Note$ = "" ; Клики работают только на обычных строках
          MyGrid\SelectedRow = HoverRow
          MyGrid\SelectedCol = HoverCol
        Else
          MyGrid\SelectedRow = -1
          MyGrid\SelectedCol = -1
        EndIf
        DrawGrid(0)
      EndIf
      
    Case #PB_EventType_MouseWheel
      MyGrid\OffsetY + (Delta * 15)
      If MyGrid\OffsetY > 0 : MyGrid\OffsetY = 0 : EndIf
      DrawGrid(0)
      
    Case #PB_EventType_MouseLeave
      MyGrid\HoveredRow = -1
      DrawGrid(0)
  EndSelect
EndProcedure

; --- ОКНО ПРИЛОЖЕНИЯ ---

If OpenWindow(0, 100, 100, 640, 480, "PureBasic 2D Grid - Rows and Notes", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 640, 480, #PB_Canvas_Keyboard)
  BindGadgetEvent(0, @CanvasCallback())
  DrawGrid(0)
  
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 131
; FirstLine = 123
; Folding = ----
; EnableXP
; DPIAware