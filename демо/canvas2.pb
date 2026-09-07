EnableExplicit

; ============================================================================
; 1. СКРЫТЫЙ ИМПОРТ И СТРУКТУРЫ (Внутреннее ядро гаджета)
; ============================================================================
Prototype.b Canvas_AlphaBlend(hdcDest.i, xDest.l, yDest.l, wDest.l, hDest.l, hdcSrc.i, xSrc.l, ySrc.l, wSrc.l, hSrc.l, blendFunc.l)
Global Canvas_AlphaBlend_.Canvas_AlphaBlend

Structure CanvasStructure
  hWnd.i          ; Хэндл WinAPI окна гаджета
  IsDrawing.b     ; Флаг зажатой мыши (для рисования пользователем)
  LastX.l         ; Координаты мыши
  LastY.l
  hLayeredImage.i ; Скрытый буфер в памяти
  Width.l         ; Размеры буфера
  Height.l
  DrawColor.l     ; Индивидуальный цвет рисования пользователя
  Thickness.l     ; Индивидуальная толщина линии пользователя
  
  ; НОВЫЕ ПОЛЯ ДЛЯ ПОДДЕРЖКИ STARTDRAWING / STOPDRAWING:
  hCurrentDC.i    ; Хранит временный контекст рисования в памяти
  hOldBitmap.i    ; Хранит старый битмап для корректного освобождения ресурсов
EndStructure

Structure Canvas_BLENDFUNCTION
  BlendOp.b
  BlendFlags.b
  SourceConstantAlpha.b
  AlphaFormat.b
EndStructure

Global CanvasClassName$ = "PureBasic_Canvas_Class"

#Canvas_TimerID = 1      
#WM_Canvas_Clear = #WM_USER + 100 

; Внутренний WinAPI-обработчик событий гаджета
Procedure.i CanvasInternalProc(hWnd.i, uMsg.l, wParam.i, lParam.i)
  Protected *myData.CanvasStructure = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
  Protected ps.PAINTSTRUCT
  Protected hdc.i, hMemDC.i, hOldBitmap.i, rect.RECT
  Protected X.l, Y.l, hPen.i, hBrush.i, parentHWND.i
  Protected pt.POINT
  
  Select uMsg
    Case #WM_CREATE
      *myData = AllocateMemory(SizeOf(CanvasStructure))
      InitializeStructure(*myData, CanvasStructure)
      *myData\hWnd = hWnd
      *myData\Width = 100  
      *myData\Height = 100
      *myData\DrawColor = RGB(255, 0, 0) 
      *myData\Thickness = 5              
      
      SetTimer_(hWnd, #Canvas_TimerID, 50, #Null)
      SetWindowLongPtr_(hWnd, #GWLP_USERDATA, *myData)
      ProcedureReturn 0

    Case #WM_SIZE
      If *myData
        *myData\Width = lParam & $FFFF
        *myData\Height = (lParam >> 16) & $FFFF
        
        If *myData\hLayeredImage : DeleteObject_(*myData\hLayeredImage) : EndIf
        
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
      EndIf
      ProcedureReturn 0

    Case #WM_NCDESTROY
      If *myData
        KillTimer_(hWnd, #Canvas_TimerID) 
        If *myData\hLayeredImage : DeleteObject_(*myData\hLayeredImage) : EndIf
        FreeMemory(*myData)
      EndIf
      ProcedureReturn 0

    Case #WM_ERASEBKGND
      ProcedureReturn 1 

    Case #WM_PAINT
      hdc = BeginPaint_(hWnd, @ps)
      If *myData And *myData\hLayeredImage
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
      If wParam = #Canvas_TimerID And *myData And *myData\hLayeredImage And Canvas_AlphaBlend_
        ; Проверяем, не занят ли холст программным рисованием прямо сейчас
        If *myData\hCurrentDC = #Null
          hdc = GetDC_(hWnd)
          hMemDC = CreateCompatibleDC_(hdc)
          hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
          
          Protected bf.Canvas_BLENDFUNCTION
          bf\BlendOp = 0          
          bf\BlendFlags = 0
          bf\SourceConstantAlpha = 15 
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
          
          Canvas_AlphaBlend_(hMemDC, 0, 0, *myData\Width, *myData\Height, hTempDC, 0, 0, *myData\Width, *myData\Height, blendValue)
          
          SelectObject_(hTempDC, hOldTemp)
          DeleteObject_(hTempBitmap)
          DeleteDC_(hTempDC)
          SelectObject_(hMemDC, hOldBitmap)
          DeleteDC_(hMemDC)
          ReleaseDC_(hWnd, hdc)
          
          InvalidateRect_(hWnd, #Null, #False)
        EndIf
      EndIf
      ProcedureReturn 0

    Case #WM_Canvas_Clear
      If *myData And *myData\hLayeredImage
        ShowWindow_(hWnd, #SW_HIDE)
        hdc = GetDC_(hWnd)
        hMemDC = CreateCompatibleDC_(hdc)
        hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
        
        SetRect_(@rect, 0, 0, *myData\Width, *myData\Height)
        hBrush = CreateSolidBrush_(RGB(0, 0, 0))
        FillRect_(hMemDC, @rect, hBrush)
        DeleteObject_(hBrush)
        
        SelectObject_(hMemDC, hOldBitmap)
        DeleteDC_(hMemDC)
        ReleaseDC_(hWnd, hdc)
        
        parentHWND = GetParent_(hWnd)
        GetWindowRect_(hWnd, @rect)
        pt\x = rect\left : pt\y = rect\top
        ScreenToClient_(parentHWND, @pt)
        
        rect\right = pt\x + (rect\right - rect\left)
        rect\bottom = pt\y + (rect\bottom - rect\top)
        rect\left = pt\x : rect\top = pt\y
        
        RedrawWindow_(parentHWND, @rect, #Null, #RDW_ERASE | #RDW_INVALIDATE | #RDW_UPDATENOW)
        ShowWindow_(hWnd, #SW_SHOW)
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
      If *myData And *myData\IsDrawing And *myData\hLayeredImage
        X = lParam & $FFFF
        Y = (lParam >> 16) & $FFFF
        
        hdc = GetDC_(hWnd)
        hMemDC = CreateCompatibleDC_(hdc)
        hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
        
        hPen = CreatePen_(#PS_SOLID, *myData\Thickness, *myData\DrawColor) 
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
; 2. ПУБЛИЧНЫЙ ИНТЕРФЕЙС ГАДЖЕТА (Камуфляж функций)
; ============================================================================
Procedure.i InitCanvasInternal_()
  Static IsInit = #False
  If IsInit : ProcedureReturn #True : EndIf
  Protected Lib = OpenLibrary(#PB_Any, "msimg32.dll")
  If Lib : Canvas_AlphaBlend_ = GetFunction(Lib, "AlphaBlend") : EndIf
  Protected wcex.WNDCLASSEX
  wcex\cbSize        = SizeOf(WNDCLASSEX)
  wcex\style         = #CS_HREDRAW | #CS_VREDRAW
  wcex\lpfnWndProc   = @CanvasInternalProc()
  wcex\hInstance     = GetModuleHandle_(#Null)
  wcex\hCursor       = LoadCursor_(#Null, #IDC_ARROW)
  wcex\lpszClassName = @CanvasClassName$
  If RegisterClassEx_(@wcex) : IsInit = #True : ProcedureReturn #True : EndIf
  ProcedureReturn #False
EndProcedure

Procedure.i CanvasGadget_(Gadget.i, X.l, Y.l, Width.l, Height.l)
  InitCanvasInternal_()
  Protected ParentHWND.i = UseGadgetList(0) 
  Protected hWnd.i, ID.i
  If Gadget = #PB_Any : ID = UseGadgetList(ParentHWND) : Else : ID = Gadget : EndIf
  hWnd = CreateWindowEx_(#WS_EX_TRANSPARENT, CanvasClassName$, "", #WS_CHILD | #WS_VISIBLE, X, Y, Width, Height, ParentHWND, ID, GetModuleHandle_(#Null), #Null)
  ProcedureReturn hWnd
EndProcedure

Procedure ClearCanvas_(Gadget.i)
  If IsGadget(Gadget) : SendMessage_(GadgetID(Gadget), #WM_Canvas_Clear, 0, 0) : Else : SendMessage_(Gadget, #WM_Canvas_Clear, 0, 0) : EndIf
EndProcedure

; ----------------------------------------------------------------------------
; НОВЫЕ ФУНКЦИИ: КАНАЛ ПРОГРАММНОГО РИСОВАНИЯ (START/STOP DRAWING)
; ----------------------------------------------------------------------------

; Функция открывает контекст для рисования на холсте. Возвращает Handle для GDI.
Procedure.i StartDrawing_(Gadget.i)
  Protected hWnd.i, *myData.CanvasStructure
  Protected hdc.i
  
  If IsGadget(Gadget) : hWnd = GadgetID(Gadget) : Else : hWnd = Gadget : EndIf
  *myData = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
  
  If *myData And *myData\hLayeredImage
    ; Создаем изолированный контекст рисования в памяти
    hdc = GetDC_(hWnd)
    *myData\hCurrentDC = CreateCompatibleDC_(hdc)
    *myData\hOldBitmap = SelectObject_(*myData\hCurrentDC, *myData\hLayeredImage)
    ReleaseDC_(hWnd, hdc)
    
    ; Возвращаем хэндл контекста. Теперь в него можно посылать WinAPI команды рисования!
    ProcedureReturn *myData\hCurrentDC
  EndIf
  ProcedureReturn #Null
EndProcedure
; Функция закрывает контекст и мгновенно выводит нарисованное на экран
Procedure StopDrawing_(Gadget.i)
   Protected hWnd.i, *myData.CanvasStructure
   If IsGadget(Gadget) : hWnd = GadgetID(Gadget) : Else : hWnd = Gadget : EndIf
   *myData = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
   If *myData And *myData\hCurrentDC 
      ; Закрываем контекст, возвращая буфер на место
      SelectObject_(*myData\hCurrentDC, *myData\hOldBitmap)
      DeleteDC_(*myData\hCurrentDC)
      *myData\hCurrentDC = #Null
      *myData\hOldBitmap = #Null
      ; Принудительно заставляем холст обновиться на экране
      InvalidateRect_(hWnd, #Null, #False)
   EndIf
EndProcedure

; Вспомогательные функции для рисования внутри блока StartDrawing/StopDrawing
Procedure DrawingLine_(DC.i, X1.l, Y1.l, X2.l, Y2.l, Color.l, Thickness.l)
   Protected hPen = CreatePen_(#PS_SOLID, Thickness, Color)
   Protected hOldPen = SelectObject_(DC, hPen)
   MoveToEx_(DC, X1, Y1, #Null)
   LineTo_(DC, X2, Y2)
   SelectObject_(DC, hOldPen)
   DeleteObject_(hPen)
EndProcedure

Procedure DrawingText_(DC.i, X.l, Y.l, Text$, Color.l)
   SetBkMode_(DC, #TRANSPARENT)
   SetTextColor_(DC, Color)
   TextOut_(DC, X, Y, Text$, Len(Text$))
EndProcedure

; ============================================================================
; 3. ТЕСТОВЫЙ ЗАПУСК (Программное рисование через StartDrawing_)
; ============================================================================
Global Event.i, MyCanvas.i, hDC.i
If OpenWindow(0, 100, 100, 640, 500, "Синтаксис StartDrawing / StopDrawing", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
SetWindowColor(0, RGB(235, 235, 240))
TextGadget(11, 40, 100, 400, 30, "Этот текст лежит ПОД стеклом")
ButtonGadget(2, 20, 450, 150, 35, "Нарисовать кодом")
MyCanvas = CanvasGadget_(1, 20, 20, 600, 400)

Repeat
   Event = WaitWindowEvent()
   If Event = #PB_Event_Gadget
      If EventGadget() = 2
         ; ТАК ВЫГЛЯДИТ ПРОГРАММНОЕ РИСОВАНИЕ НА НАШЕМ ХОЛСТЕ
         hDC = StartDrawing_(MyCanvas)
         If hDC; Рисуем синий крест кодом
            DrawingLine_(hDC, 0, 0, 600, 400, RGB(0, 100, 255), 4)
            DrawingLine_(hDC, 600, 0, 0, 400, RGB(0, 100, 255), 4)
            ; Выводим текст поверх прозрачного холста
            DrawingText_(hDC, 200, 180, "ПРОГРАММНЫЙ ВЫВОД!", RGB(255, 255, 0))
            StopDrawing_(MyCanvas)
         EndIf
      EndIf
   EndIf
Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; FirstLine = 262
; Folding = ------
; EnableXP
; DPIAware