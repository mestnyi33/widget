EnableExplicit

; ============================================================================
; 1. СТРУКТУРА КАСТОМНОГО ГАДЖЕТА И ХРАНЕНИЕ РИСУНКА
; ============================================================================
Structure CustomCanvas
  hWnd.i          ; Хэндл окна гаджета
  IsDrawing.b     ; Флаг процесса рисования
  LastX.l         ; Предыдущая координата X мыши
  LastY.l         ; Предыдущая координата Y мыши
  hLayeredImage.i ; Скрытый битмап, где мы храним нарисованное пользователем
EndStructure

Global DynamicClassName.s = "PureBasic_RealGlassCanvas_Class"

; ============================================================================
; 2. ОБРАБОТЧИК СОБЫТИЙ ОКНА
; ============================================================================
Procedure.i _CustomCanvasProc(hWnd.i, uMsg.l, wParam.i, lParam.i)
  Protected *myData.CustomCanvas = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
  Protected ps.PAINTSTRUCT
  Protected hdc.i, hMemDC.i, hOldBitmap.i, rect.RECT
  Protected X.l, Y.l, hPen.i

  Select uMsg
    Case #WM_CREATE
      *myData = AllocateMemory(SizeOf(CustomCanvas))
      InitializeStructure(*myData, CustomCanvas)
      *myData\hWnd = hWnd
      
      ; Создаем невидимый буфер в памяти для рисования (чтобы линии не стирались)
      ; Для простоты примера берем фиксированный большой размер буфера
      hdc = GetDC_(hWnd)
      *myData\hLayeredImage = CreateCompatibleBitmap_(hdc, 2000, 2000)
      hMemDC = CreateCompatibleDC_(hdc)
      hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
      
      ; Заливаем буфер прозрачным цветом (пусть это будет чистый черный $000000)
      SetRect_(@rect, 0, 0, 2000, 2000)
      hPen = CreateSolidBrush_(RGB(0, 0, 0))
      FillRect_(hMemDC, @rect, hPen)
      DeleteObject_(hPen)
      
      SelectObject_(hMemDC, hOldBitmap)
      DeleteDC_(hMemDC)
      ReleaseDC_(hWnd, hdc)
      
      SetWindowLongPtr_(hWnd, #GWLP_USERDATA, *myData)
      ProcedureReturn 0

    Case #WM_NCDESTROY
      If *myData
        If *myData\hLayeredImage : DeleteObject_(*myData\hLayeredImage) : EndIf
        FreeMemory(*myData)
      EndIf
      ProcedureReturn 0

    Case #WM_ERASEBKGND
      ; ГЛАВНЫЙ СЕКРЕТ ПРОЗРАЧНОСТИ №1:
      ; Говорим Windows НЕ рисовать фон вообще. Окно становится "дырявым".
      ProcedureReturn 1 

    Case #WM_PAINT
      ; ГЛАВНЫЙ СЕКРЕТ ПРОЗРАЧНОСТИ №2:
      ; Отрисовываем только наши линии, используя маску прозрачности
      hdc = BeginPaint_(hWnd, @ps)
      If *myData
        GetClientRect_(hWnd, @rect)
        hMemDC = CreateCompatibleDC_(hdc)
        hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
        
        ; Рисуем содержимое памяти на экран. 
        ; Используем SRCPAINT (или TransparentBlt), чтобы черный цвет буфера стал невидимым
        BitBlt_(hdc, 0, 0, rect\right, rect\bottom, hMemDC, 0, 0, #SRCPAINT)
        
        SelectObject_(hMemDC, hOldBitmap)
        DeleteDC_(hMemDC)
      EndIf
      EndPaint_(hWnd, @ps)
      ProcedureReturn 0

    Case #WM_LBUTTONDOWN
      If *myData
        *myData\IsDrawing = #True
        *myData\LastX = lParam & $FFFF
        *myData\LastY = (lParam >> 16) & $FFFF
        SetCapture_(hWnd)
      EndIf
      ProcedureReturn 0

    Case #WM_LBUTTONUP
      If *myData And *myData\IsDrawing
        *myData\IsDrawing = #False
        ReleaseCapture_()
      EndIf
      ProcedureReturn 0

    Case #WM_MOUSEMOVE
      If *myData And *myData\IsDrawing
        X = lParam & $FFFF
        Y = (lParam >> 16) & $FFFF
        
        ; Рисуем линию в наш невидимый буфер памяти
        hdc = GetDC_(hWnd)
        hMemDC = CreateCompatibleDC_(hdc)
        hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
        
        hPen = CreatePen_(#PS_SOLID, 4, RGB(0, 255, 0)) ; Зеленый маркер
        SelectObject_(hMemDC, hPen)
        
        MoveToEx_(hMemDC, *myData\LastX, *myData\LastY, #Null)
        LineTo_(hMemDC, X, Y)
        
        DeleteObject_(hPen)
        SelectObject_(hMemDC, hOldBitmap)
        DeleteDC_(hMemDC)
        ReleaseDC_(hWnd, hdc)
        
        *myData\LastX = X
        *myData\LastY = Y
        
        ; Принудительно обновляем холст
        InvalidateRect_(hWnd, #Null, #False)
      EndIf
      ProcedureReturn 0

  EndSelect

  ProcedureReturn DefWindowProc_(hWnd, uMsg, wParam, lParam)
EndProcedure
Procedure.i CustomCanvasProc(hWnd.i, uMsg.l, wParam.i, lParam.i)
  Protected *myData.CustomCanvas = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
  Protected ps.PAINTSTRUCT
  Protected hdc.i, hMemDC.i, hOldBitmap.i, rect.RECT
  Protected X.l, Y.l, hPen.i

  Select uMsg
    Case #WM_CREATE
      *myData = AllocateMemory(SizeOf(CustomCanvas))
      InitializeStructure(*myData, CustomCanvas)
      *myData\hWnd = hWnd
      
      hdc = GetDC_(hWnd)
      *myData\hLayeredImage = CreateCompatibleBitmap_(hdc, 2000, 2000)
      hMemDC = CreateCompatibleDC_(hdc)
      hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
      
      ; Заливаем буфер чисто черным цветом (RGB 0,0,0) — он станет нашей прозрачной маской
      SetRect_(@rect, 0, 0, 2000, 2000)
      hPen = CreateSolidBrush_(RGB(0, 0, 0))
      FillRect_(hMemDC, @rect, hPen)
      DeleteObject_(hPen)
      
      SelectObject_(hMemDC, hOldBitmap)
      DeleteDC_(hMemDC)
      ReleaseDC_(hWnd, hdc)
      
      SetWindowLongPtr_(hWnd, #GWLP_USERDATA, *myData)
      ProcedureReturn 0

    Case #WM_NCDESTROY
      If *myData
        If *myData\hLayeredImage : DeleteObject_(*myData\hLayeredImage) : EndIf
        FreeMemory(*myData)
      EndIf
      ProcedureReturn 0

    Case #WM_ERASEBKGND
      ProcedureReturn 1 

    Case #WM_PAINT
      hdc = BeginPaint_(hWnd, @ps)
      If *myData
        GetClientRect_(hWnd, @rect)
        hMemDC = CreateCompatibleDC_(hdc)
        hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
        
        ; ИСПРАВЛЕНИЕ: Используем TransparentBlt вместо BitBlt со #SRCPAINT.
        ; Последний параметр RGB(0, 0, 0) указывает, какой цвет нужно сделать невидимым.
        TransparentBlt_(hdc, 0, 0, rect\right, rect\bottom, hMemDC, 0, 0, rect\right, rect\bottom, RGB(0, 0, 0))
        
        SelectObject_(hMemDC, hOldBitmap)
        DeleteDC_(hMemDC)
      EndIf
      EndPaint_(hWnd, @ps)
      ProcedureReturn 0

    Case #WM_LBUTTONDOWN
      If *myData
        *myData\IsDrawing = #True
        *myData\LastX = lParam & $FFFF
        *myData\LastY = (lParam >> 16) & $FFFF
        SetCapture_(hWnd)
      EndIf
      ProcedureReturn 0

    Case #WM_LBUTTONUP
      If *myData And *myData\IsDrawing
        *myData\IsDrawing = #False
        ReleaseCapture_()
      EndIf
      ProcedureReturn 0

    Case #WM_MOUSEMOVE
      If *myData And *myData\IsDrawing
        X = lParam & $FFFF
        Y = (lParam >> 16) & $FFFF
        
        hdc = GetDC_(hWnd)
        hMemDC = CreateCompatibleDC_(hdc)
        hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
        
        ; Теперь любой цвет здесь (например, чистый красный) будет отображаться идеально корректно!
        hPen = CreatePen_(#PS_SOLID, 4, RGB(255, 0, 0)) 
        SelectObject_(hMemDC, hPen)
        
        MoveToEx_(hMemDC, *myData\LastX, *myData\LastY, #Null)
        LineTo_(hMemDC, X, Y)
        
        DeleteObject_(hPen)
        SelectObject_(hMemDC, hOldBitmap)
        DeleteDC_(hMemDC)
        ReleaseDC_(hWnd, hdc)
        
        *myData\LastX = X
        *myData\LastY = Y
        
        InvalidateRect_(hWnd, #Null, #False)
      EndIf
      ProcedureReturn 0

  EndSelect

  ProcedureReturn DefWindowProc_(hWnd, uMsg, wParam, lParam)
EndProcedure

; ============================================================================
; 3. РЕГИСТРАЦИЯ И СОЗДАНИЕ СТИЛЯ
; ============================================================================
Procedure.i RegisterGlassCanvas()
  Protected wcex.WNDCLASSEX
  wcex\cbSize        = SizeOf(WNDCLASSEX)
  wcex\style         = #CS_HREDRAW | #CS_VREDRAW
  wcex\lpfnWndProc   = @CustomCanvasProc()
  wcex\cbClsExtra    = 0
  wcex\cbWndExtra    = 0
  wcex\hInstance     = GetModuleHandle_(#Null)
  wcex\hCursor       = LoadCursor_(#Null, #IDC_ARROW)
  wcex\hbrBackground = #Null ; Нет фона
  wcex\lpszClassName = @DynamicClassName

  ProcedureReturn RegisterClassEx_(@wcex)
EndProcedure

Procedure.i GlassCanvasGadget(ID.i, X.l, Y.l, Width.l, Height.l, ParentHWND.i)
  ; КЛЮЧЕВОЙ МОМЕНТ: Используем расширенный стиль #WS_EX_TRANSPARENT.
  ; Он заставляет Windows сначала нарисовать всё, что находится ПОД гаджетом, а уже потом вызывать наш гаджет.
  ProcedureReturn CreateWindowEx_(#WS_EX_TRANSPARENT, DynamicClassName, "", #WS_CHILD | #WS_VISIBLE, X, Y, Width, Height, ParentHWND, ID, GetModuleHandle_(#Null), #Null)
EndProcedure

; ============================================================================
; 4. ТЕСТИРОВАНИЕ ПРОЗРАЧНОСТИ
; ============================================================================
If Not RegisterGlassCanvas() : End : EndIf

If OpenWindow(0, 100, 100, 640, 480, "Настоящий прозрачный Canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  SetWindowColor(0, RGB(240, 240, 240))
  
  ; --- Создаем стандартные элементы PureBasic, которые будут ПОД холстом ---
  ButtonGadget(10, 60, 60, 200, 40, "Кнопка ПОД холстом")
  TextGadget(11, 60, 120, 300, 30, "Этот текст находится под стеклом!")
  ContainerGadget(12, 60, 180, 250, 100, #PB_Container_Flat)
    ButtonGadget(13, 10, 10, 100, 30, "Внутри контейнера")
  CloseGadgetList()
  ; -------------------------------------------------------------------------

  ; Создаем наш кастомный прозрачный холст ПОВЕРХ всех кнопок
  ; Он занимает почти всё окно, но вы прекрасно видите элементы под ним!
  GlassCanvasGadget(1, 20, 20, 600, 440, WindowID(0))

  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 235
; Folding = 0---
; EnableXP
; DPIAware