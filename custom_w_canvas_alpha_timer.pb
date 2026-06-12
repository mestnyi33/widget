EnableExplicit

; ============================================================================
; 1. РУЧНОЙ ИМПОРТ ФУНКЦИИ ALPHABLEND ИЗ WINAPI (msimg32.dll)
; ============================================================================
Prototype.b AlphaBlendProto(hdcDest.i, xDest.l, yDest.l, wDest.l, hDest.l, hdcSrc.i, xSrc.l, ySrc.l, wSrc.l, hSrc.l, blendFunc.l)
Global AlphaBlend_.AlphaBlendProto

Procedure InitWinAPIExtensions()
  Protected Lib = OpenLibrary(#PB_Any, "msimg32.dll")
  If Lib
    AlphaBlend_ = GetFunction(Lib, "AlphaBlend")
  EndIf
EndProcedure

InitWinAPIExtensions()

; ============================================================================
; 2. СТРУКТУРЫ И КОНСТАНТЫ
; ============================================================================
Structure CustomCanvas
  hWnd.i          ; Хэндл окна гаджета
  IsDrawing.b     ; Флаг рисования
  LastX.l         ; Предыдущая координата X
  LastY.l         ; Предыдущая координата Y
  hLayeredImage.i ; Скрытый буфер (битмап) в памяти
  Width.l         ; Текущая ширина холста
  Height.l        ; Текущая высота холста
EndStructure

Structure WinAPI_BLENDFUNCTION
  BlendOp.b
  BlendFlags.b
  SourceConstantAlpha.b
  AlphaFormat.b
EndStructure

Global DynamicClassName.s = "PureBasic_RealGlassCanvas_Class"

#TIMER_FADE_ID = 1      
#WM_CLEAR_CANVAS = #WM_USER + 100 

; ============================================================================
; 3. ЦЕНТРАЛЬНЫЙ ОБРАБОТЧИК СОБЫТИЙ ОКНА
; ============================================================================
Procedure.i CustomCanvasProc(hWnd.i, uMsg.l, wParam.i, lParam.i)
  Protected *myData.CustomCanvas = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
  Protected ps.PAINTSTRUCT
  Protected hdc.i, hMemDC.i, hOldBitmap.i, rect.RECT
  Protected X.l, Y.l, hPen.i, hBrush.i
  Protected parentHWND.i, pt.POINT
  
  Select uMsg
    Case #WM_CREATE
      *myData = AllocateMemory(SizeOf(CustomCanvas))
      InitializeStructure(*myData, CustomCanvas)
      *myData\hWnd = hWnd
      *myData\Width = 2000  
      *myData\Height = 2000
      
      hdc = GetDC_(hWnd)
      *myData\hLayeredImage = CreateCompatibleBitmap_(hdc, *myData\Width, *myData\Height)
      hMemDC = CreateCompatibleDC_(hdc)
      hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
      
      SetRect_(@rect, 0, 0, *myData\Width, *myData\Height)
      hBrush = CreateSolidBrush_(RGB(0, 0, 0))
      FillRect_(hMemDC, @rect, hBrush)
      DeleteObject_(hBrush)
      
      SelectObject_(hMemDC, hOldBitmap)
      DeleteDC_(hMemDC)
      ReleaseDC_(hWnd, hdc)
      
      SetTimer_(hWnd, #TIMER_FADE_ID, 50, #Null)
      
      SetWindowLongPtr_(hWnd, #GWLP_USERDATA, *myData)
      ProcedureReturn 0

    Case #WM_NCDESTROY
      If *myData
        KillTimer_(hWnd, #TIMER_FADE_ID) 
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
        
        TransparentBlt_(hdc, 0, 0, rect\right, rect\bottom, hMemDC, 0, 0, rect\right, rect\bottom, RGB(0, 0, 0))
        
        SelectObject_(hMemDC, hOldBitmap)
        DeleteDC_(hMemDC)
      EndIf
      EndPaint_(hWnd, @ps)
      ProcedureReturn 0

    Case #WM_TIMER
      If wParam = #TIMER_FADE_ID And *myData And AlphaBlend_
        hdc = GetDC_(hWnd)
        hMemDC = CreateCompatibleDC_(hdc)
        hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
        
        Protected bf.WinAPI_BLENDFUNCTION
        bf\BlendOp = 0          
        bf\BlendFlags = 0
        bf\SourceConstantAlpha = 15 ; Скорость автозатухания
        bf\AlphaFormat = 0
        
        Protected blendValue.l
        CopyMemory(@bf, @blendValue, 4)
        
        Protected hTempDC = CreateCompatibleDC_(hdc)
        Protected hTempBitmap = CreateCompatibleBitmap_(hdc, *myData\Width, *myData\Height)
        Protected hOldTemp = SelectObject_(hTempDC, hTempBitmap)
        
        SetRect_(@rect, 0, 0, *myData\Width, *myData\Height)
        hBrush = CreateSolidBrush_(RGB(0, 0, 0))
        FillRect_(hTempDC, @rect, hBrush)
        DeleteObject_(hBrush)
        
        AlphaBlend_(hMemDC, 0, 0, *myData\Width, *myData\Height, hTempDC, 0, 0, *myData\Width, *myData\Height, blendValue)
        
        SelectObject_(hTempDC, hOldTemp)
        DeleteObject_(hTempBitmap)
        DeleteDC_(hTempDC)
        
        SelectObject_(hMemDC, hOldBitmap)
        DeleteDC_(hMemDC)
        ReleaseDC_(hWnd, hdc)
        
        InvalidateRect_(hWnd, #Null, #False)
      EndIf
      ProcedureReturn 0

    Case #WM_CLEAR_CANVAS
      ; --- ИСПРАВЛЕННАЯ ОЧИСТКА ХОЛСТА ---
      If *myData
        hdc = GetDC_(hWnd)
        hMemDC = CreateCompatibleDC_(hdc)
        hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
        
        ; 1. Стираем рисунок в буфере памяти (заливаем черным)
        SetRect_(@rect, 0, 0, *myData\Width, *myData\Height)
        hBrush = CreateSolidBrush_(RGB(0, 0, 0))
        FillRect_(hMemDC, @rect, hBrush)
        DeleteObject_(hBrush)
        
        SelectObject_(hMemDC, hOldBitmap)
        DeleteDC_(hMemDC)
        ReleaseDC_(hWnd, hdc)
        
        ; 2. РЕШЕНИЕ ПРОБЛЕМЫ: Находим координаты холста на родительском окне
        parentHWND = GetParent_(hWnd)
        GetWindowRect_(hWnd, @rect)
        
        pt\x = rect\left : pt\y = rect\top
        ScreenToClient_(parentHWND, @pt)
        
        ; Пересчитываем границы
        rect\right = pt\x + (rect\right - rect\left)
        rect\bottom = pt\y + (rect\bottom - rect\top)
        rect\left = pt\x : rect\top = pt\y
        
        ; И принудительно заставляем само главное окно перерисовать этот кусок под нами [Claim 1.2.1]
        InvalidateRect_(parentHWND, @rect, #True)
        UpdateWindow_(parentHWND)
      EndIf
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
        
        hPen = CreatePen_(#PS_SOLID, 5, RGB(255, 0, 0)) 
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
; 4. РЕГИСТРАЦИЯ И СОЗДАНИЕ
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
  wcex\hbrBackground = #Null
  wcex\lpszClassName = @DynamicClassName

  ProcedureReturn RegisterClassEx_(@wcex)
EndProcedure

Procedure.i GlassCanvasGadget(ID.i, X.l, Y.l, Width.l, Height.l, ParentHWND.i)
  ProcedureReturn CreateWindowEx_(#WS_EX_TRANSPARENT, DynamicClassName, "", #WS_CHILD | #WS_VISIBLE, X, Y, Width, Height, ParentHWND, ID, GetModuleHandle_(#Null), #Null)
EndProcedure

; ============================================================================
; 5. ИСПОЛНЯЕМЫЙ КОД
; ============================================================================
If Not RegisterGlassCanvas() : End : EndIf

Global Event.i, CanvasHandle.i

If OpenWindow(0, 100, 100, 640, 500, "Canvas: Исчезающие линии + Очистка", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  SetWindowColor(0, RGB(235, 235, 240))
  
  ; Кнопка для очистки
  ButtonGadget(2, 20, 450, 120, 35, "Очистить холст")
  
  ; Декоративный текст ПОД стеклом
  TextGadget(11, 40, 100, 400, 30, "Попробуйте быстро нарисовать что-нибудь!")
  
  ; Создаем кастомный холст ПОВЕРХ текста
  CanvasHandle = GlassCanvasGadget(1, 20, 20, 600, 400, WindowID(0))

  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget
      If EventGadget() = 2
        SendMessage_(CanvasHandle, #WM_CLEAR_CANVAS, 0, 0)
      EndIf
    EndIf
    
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 278
; FirstLine = 158
; Folding = ----
; EnableXP
; DPIAware