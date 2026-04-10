; ; Пример получения координат всех символов в строке через WinAPI
; EnableExplicit
; 
; Procedure GetTextCharacterPositions(Text$, FontID)
;   Protected hDC, oldFont, n, i
;   n = Len(Text$)
;   
;   ; Создаем массив для хранения накопленной ширины (координат X)
;   Dim positions.l(n)
;   Protected sz.SIZE
;   
;   ; Получаем контекст устройства (в данном случае рабочего стола или окна)
;   hDC = GetDC_(0)
;   If hDC
;     ; Выбираем нужный шрифт в контекст
;     oldFont = SelectObject_(hDC, FontID)
;     
;     ; GetTextExtentExPoint_ возвращает массив 'positions', где
;     ; positions[0] - ширина 1-го символа
;     ; positions[1] - ширина 1-го и 2-го символа вместе и т.д.
;     If GetTextExtentExPoint_(hDC, Text$, n, 0, 0, @positions(0), @sz)
;       
;       Debug "Общая ширина строки: " + sz\cx
;       Debug "--- Координаты символов ---"
;       
;       For i = 0 To n - 1
;         Debug "Символ '" + Mid(Text$, i + 1, 1) + "' заканчивается на X = " + Str(positions(i))
;       Next
;       
;     EndIf
;     
;     ; Возвращаем старый шрифт и освобождаем контекст
;     SelectObject_(hDC, oldFont)
;     ReleaseDC_(0, hDC)
;   EndIf
; EndProcedure
; 
; ; --- ТЕСТ ---
; LoadFont(0, "Segoe UI", 12)
; Define myText$ = "Windows API Kerning Test"
; 
; If OpenWindow(0, 0, 0, 400, 200, "API Text Width", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;   GetTextCharacterPositions(myText$, FontID(0))
;   
;   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; EndIf


EnableExplicit

; Структура для хранения данных о строке
Structure TextData
  Text$
  nLen.l
  Array xCoords.l(0)
  TotalWidth.l
EndStructure

Procedure DrawPreciseText(Canvas, X, Y, FontID, Text$)
  Protected td.TextData, i, hDC, oldFont
  td\Text$ = Text$
  td\nLen = Len(Text$)
  Dim td\xCoords(td\nLen)
  
  StartDrawing(CanvasOutput(Canvas))
    hDC = DrawingBuffer() ; Получаем контекст рисования Canvas
    hDC = GetDC_(GadgetID(Canvas)) ; Для надежности берем DC гаджета
    
    oldFont = SelectObject_(hDC, FontID)
    
    ; 1. Получаем точные координаты (ширины)
    Protected sz.SIZE
    GetTextExtentExPoint_(hDC, td\Text$, td\nLen, 0, 0, @td\xCoords(0), @sz)
    
    ; 2. Отрисовываем текст. 
    ; Мы используем ExtTextOut, чтобы принудительно расставить символы по нашим X-координатам.
    ; Для этого нам нужен массив межлитерных интервалов (расстояние между текущим и следующим символом)
    Dim dx.l(td\nLen - 1)
    dx(0) = td\xCoords(0)
    For i = 1 To td\nLen - 1
      dx(i) = td\xCoords(i) - td\xCoords(i-1)
    Next
    
    SetBkMode_(hDC, #TRANSPARENT)
    SetTextColor_(hDC, RGB(0, 0, 0))
    
    ; Сама отрисовка: x, y, опции, прямоугольник(0), текст, длина, массив ширин
    ExtTextOut_(hDC, X, Y, 0, 0, td\Text$, td\nLen, @dx(0))
    
    ; Рисуем отладочные линии под каждым символом, чтобы убедиться в точности
    For i = 0 To td\nLen - 1
      Line(X + td\xCoords(i), Y + 25, 1, 5, RGB(255, 0, 0))
    Next
    
    SelectObject_(hDC, oldFont)
    ReleaseDC_(GadgetID(Canvas), hDC)
  StopDrawing()
EndProcedure

; --- ТЕСТ ---
LoadFont(0, "Times New Roman", 18) ; Шрифт с выраженным кернингом
Define txt$ = "Waverly Text Kerning AV VA"

If OpenWindow(0, 0, 0, 500, 200, "Precise Rendering", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 500, 200)
  
  DrawPreciseText(0, 20, 50, FontID(0), txt$)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 110
; FirstLine = 84
; Folding = -
; EnableXP
; DPIAware