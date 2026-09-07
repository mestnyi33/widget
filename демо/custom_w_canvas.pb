EnableExplicit

; ============================================================================
; 1. СТРУКТУРА И ПЕРЕМЕННЫЕ КАСТОМНОГО ГАДЖЕТА
; ============================================================================
Structure CustomCanvas
  hWnd.i          ; Хэндл окна гаджета
  Width.l         ; Ширина
  Height.l        ; Высота
  BackColor.l     ; Цвет фона
  IsDrawing.b     ; Флаг процесса рисования
  LastX.l         ; Предыдущая координата X мыши
  LastY.l         ; Предыдущая координата Y мыши
EndStructure

Global DynamicClassName.s = "PureBasic_CustomCanvas_Class"

; ============================================================================
; 2.ОБРАБОТЧИК СОБЫТИЙ ОКНА (Window Procedure)
; ============================================================================
Procedure.i CustomCanvasProc(hWnd.i, uMsg.l, wParam.i, lParam.i)
  Protected *myData.CustomCanvas = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
  Protected ps.PAINTSTRUCT
  Protected hdc.i, hBrush.i, hPen.i
  Protected X.l, Y.l

  Select uMsg
    Case #WM_CREATE
      ; Выделяем память под структуру гаджета при его создании
      *myData = AllocateMemory(SizeOf(CustomCanvas))
      InitializeStructure(*myData, CustomCanvas)
      *myData\hWnd = hWnd
      *myData\BackColor = RGB(255, 255, 255) ; Белый фон по умолчанию
      SetWindowLongPtr_(hWnd, #GWLP_USERDATA, *myData)
      ProcedureReturn 0

    Case #WM_NCDESTROY
      ; Освобождаем память при уничтожении гаджета
      If *myData
        FreeMemory(*myData)
      EndIf
      ProcedureReturn 0

    Case #WM_SIZE
      ; Обновляем размеры при изменении окна
      If *myData
        *myData\Width = lParam & $FFFF
        *myData\Height = (lParam >> 16) & $FFFF
      EndIf
      ProcedureReturn 0

    Case #WM_PAINT
      ; Отрисовка холста через GDI
      hdc = BeginPaint_(hWnd, @ps)
      If *myData
        ; Заливка фона
        hBrush = CreateSolidBrush_(*myData\BackColor)
        FillRect_(hdc, @ps\rcPaint, hBrush)
        DeleteObject_(hBrush)
        
        ; Пример текста внутри кастомного гаджета
        SetBkMode_(hdc, #TRANSPARENT)
        SetTextColor_(hdc, RGB(100, 100, 100))
        TextOut_(hdc, 10, 10, "Кастомный Canvas (Зажмите ЛКМ для рисования)", 44)
      EndIf
      EndPaint_(hWnd, @ps)
      ProcedureReturn 0

    Case #WM_LBUTTONDOWN
      ; Начало рисования при зажатии левой кнопки мыши
      If *myData
        *myData\IsDrawing = #True
        *myData\LastX = lParam & $FFFF
        *myData\LastY = (lParam >> 16) & $FFFF
        SetCapture_(hWnd) ; Захватываем мышь
      EndIf
      ProcedureReturn 0

    Case #WM_LBUTTONUP
      ; Конец рисования
      If *myData And *myData\IsDrawing
        *myData\IsDrawing = #False
        ReleaseCapture_() ; Освобождаем мышь
      EndIf
      ProcedureReturn 0

    Case #WM_MOUSEMOVE
      ; Процесс рисования линий
      If *myData And *myData\IsDrawing
        X = lParam & $FFFF
        Y = (lParam >> 16) & $FFFF
        
        ; Рисуем линию напрямую на контексте устройства окна (HDC)
        hdc = GetDC_(hWnd)
        hPen = CreatePen_(#PS_SOLID, 3, RGB(255, 0, 0)) ; Красное перо толщиной 3 пикселя
        SelectObject_(hdc, hPen)
        
        MoveToEx_(hdc, *myData\LastX, *myData\LastY, #Null)
        LineTo_(hdc, X, Y)
        
        DeleteObject_(hPen)
        ReleaseDC_(hWnd, hdc)
        
        ; Запоминаем последние координаты
        *myData\LastX = X
        *myData\LastY = Y
      EndIf
      ProcedureReturn 0

  EndSelect

  ; Все остальные сообщения отправляем стандартному обработчику Windows
  ProcedureReturn DefWindowProc_(hWnd, uMsg, wParam, lParam)
EndProcedure

; ============================================================================
; 3. ФУНКЦИЯ РЕГИСТРАЦИИ И СОЗДАНИЯ ГАДЖЕТА
; ============================================================================
Procedure.i RegisterCustomCanvas()
  Protected wcex.WNDCLASSEX
  
  wcex\cbSize        = SizeOf(WNDCLASSEX)
  wcex\style         = #CS_HREDRAW | #CS_VREDRAW | #CS_DBLCLKS
  wcex\lpfnWndProc   = @CustomCanvasProc()
  wcex\cbClsExtra    = 0
  wcex\cbWndExtra    = 0
  wcex\hInstance     = GetModuleHandle_(#Null)
  wcex\hIcon         = #Null
  wcex\hCursor       = LoadCursor_(#Null, #IDC_ARROW)
  wcex\hbrBackground = #Null ; Будем очищать сами в WM_PAINT
  wcex\lpszMenuName  = #Null
  wcex\lpszClassName = @DynamicClassName
  wcex\hIconSm       = #Null

  ProcedureReturn RegisterClassEx_(@wcex)
EndProcedure

Procedure.i CustomCanvasGadget(ID.i, X.l, Y.l, Width.l, Height.l, ParentHWND.i)
  Protected hWnd.i
  
  ; Создаем окно дочернего типа (#WS_CHILD) внутри родительского окна PB
  hWnd = CreateWindowEx_(0, DynamicClassName, "", #WS_CHILD | #WS_VISIBLE | #WS_CLIPSIBLINGS, X, Y, Width, Height, ParentHWND, ID, GetModuleHandle_(#Null), #Null)
  
  ProcedureReturn hWnd
EndProcedure

; ============================================================================
; 4. ДЕМОНСТРАЦИЯ РАБОТЫ (Main)
; ============================================================================

; Регистрируем класс в системе Windows
If Not RegisterCustomCanvas()
  MessageRequester("Ошибка", "Не удалось зарегистрировать класс Canvas!")
  End
EndIf

; Создаем стандартное окно PureBasic
Define Event.i
If OpenWindow(0, 100, 100, 640, 480, "Custom Canvas от нуля под Windows", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Создаем наш кастомный гаджет, передавая хэндл родительского окна
  CustomCanvasGadget(1, 20, 20, 600, 440, WindowID(0))

  ; Главный цикл обработки событий PureBasic
  Repeat
     Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 118
; FirstLine = 126
; Folding = ---
; EnableXP
; DPIAware