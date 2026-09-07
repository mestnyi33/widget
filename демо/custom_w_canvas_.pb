EnableExplicit

; ============================================================================
; 1. СКРЫТЫЙ ИМПОРТ И СТРУКТУРЫ (Внутреннее ядро гаджета)
; ============================================================================
Prototype.b Canvas_AlphaBlend(hdcDest.i, xDest.l, yDest.l, wDest.l, hDest.l, hdcSrc.i, xSrc.l, ySrc.l, wSrc.l, hSrc.l, blendFunc.l)
Global Canvas_AlphaBlend_.Canvas_AlphaBlend

Structure CanvasStructure
   hWnd.i          ; Хэндл WinAPI окна гаджета
   IsDrawing.b     ; Флаг зажатой мыши
   LastX.l         ; Координаты мыши
   LastY.l
   hLayeredImage.i ; Скрытый буфер в памяти
   Width.l         ; Индивидуальная ширина холста
   Height.l        ; Индивидуальная высота холста
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
   ; Извлекаем структуру конкретно ТОГО холста, который вызвал это событие
   Protected *myData.CanvasStructure = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
   Protected ps.PAINTSTRUCT
   Protected hdc.i, hMemDC.i, hOldBitmap.i, rect.RECT
   Protected X.l, Y.l, hPen.i, hBrush.i, parentHWND.i
   Protected pt.POINT
   
   Select uMsg
      Case #WM_CREATE
         ; Это событие происходит отдельно для каждого создаваемого CanvasGadget_
         *myData = AllocateMemory(SizeOf(CanvasStructure))
         InitializeStructure(*myData, CanvasStructure)
         *myData\hWnd = hWnd
         
         ; Временно ставим размеры, они обновятся при первом #WM_SIZE
         *myData\Width = 100  
         *myData\Height = 100
         
         SetTimer_(hWnd, #Canvas_TimerID, 50, #Null)
         SetWindowLongPtr_(hWnd, #GWLP_USERDATA, *myData)
         ProcedureReturn 0
         
      Case #WM_SIZE
         ; СОБЫТИЕ: Окно создано или изменило размер. Выделяем буфер под точные размеры гаджета
         If *myData
            *myData\Width = lParam & $FFFF
            *myData\Height = (lParam >> 16) & $FFFF
            
            ; Если буфер уже был — удаляем старый
            If *myData\hLayeredImage : DeleteObject_(*myData\hLayeredImage) : EndIf
            
            ; Создаем новый буфер строго под размеры этого гаджета
            hdc = GetDC_(hWnd)
            *myData\hLayeredImage = CreateCompatibleBitmap_(hdc, *myData\Width, *myData\Height)
            hMemDC = CreateCompatibleDC_(hdc)
            hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
            
            ; Заливаем буфер черным цветом прозрачности
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
         
         ;     Case #WM_TIMER
         ;       ; ЭФФЕКТ ЗАТУХАНИЯ ЛИНИЙ (работает изолированно для каждого холста)
         ;       If wParam = #Canvas_TimerID And *myData And *myData\hLayeredImage And Canvas_AlphaBlend_
         ;         hdc = GetDC_(hWnd)
         ;         hMemDC = CreateCompatibleDC_(hdc)
         ;         hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
         ;         
         ;         Protected bf.Canvas_BLENDFUNCTION
         ;         bf\BlendOp = 0          
         ;         bf\BlendFlags = 0
         ;         bf\SourceConstantAlpha = 15 
         ;         bf\AlphaFormat = 0
         ;         
         ;         Protected blendValue.l
         ;         CopyMemory(@bf, @blendValue, 4)
         ;         
         ;         Protected hTempDC = CreateCompatibleDC_(hdc)
         ;         Protected hTempBitmap = CreateCompatibleBitmap_(hdc, *myData\Width, *myData\Height)
         ;         Protected hOldTemp = SelectObject_(hTempDC, hTempBitmap)
         ;         
         ;         SetRect_(@rect, 0, 0, *myData\Width, *myData\Height)
         ;         hBrush = CreateSolidBrush_(RGB(0, 0, 0))
         ;         FillRect_(hTempDC, @rect, hBrush)
         ;         DeleteObject_(hBrush)
         ;         
         ;         Canvas_AlphaBlend_(hMemDC, 0, 0, *myData\Width, *myData\Height, hTempDC, 0, 0, *myData\Width, *myData\Height, blendValue)
         ;         
         ;         SelectObject_(hTempDC, hOldTemp)
         ;         DeleteObject_(hTempBitmap)
         ;         DeleteDC_(hTempDC)
         ;         SelectObject_(hMemDC, hOldBitmap)
         ;         DeleteDC_(hMemDC)
         ;         ReleaseDC_(hWnd, hdc)
         ;         
         ;         InvalidateRect_(hWnd, #Null, #False)
         ;       EndIf
         ;       ProcedureReturn 0
         
      Case #WM_Canvas_Clear
         ; ИЗОЛИРОВАННАЯ ОЧИСТКА КОНКРЕТНОГО ХОЛСТА
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
            
            ; Получаем координаты ТОЛЬКО ЭТОГО холста на родительском окне
            parentHWND = GetParent_(hWnd)
            GetWindowRect_(hWnd, @rect)
            pt\x = rect\left : pt\y = rect\top
            ScreenToClient_(parentHWND, @pt)
            
            rect\right = pt\x + (rect\right - rect\left)
            rect\bottom = pt\y + (rect\bottom - rect\top)
            rect\left = pt\x : rect\top = pt\y
            
            ; Обновляем строго прямоугольник этого холста, остальные элементы не мигают!
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
; 2. ПУБЛИЧНЫЙ ИНТЕРФЕЙС ГАДЖЕТА
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
   
   If RegisterClassEx_(@wcex)
      IsInit = #True
      ProcedureReturn #True
   EndIf
   ProcedureReturn #False
EndProcedure

Procedure.i CanvasGadget_(Gadget.i, X.l, Y.l, Width.l, Height.l)
   InitCanvasInternal_()
   Protected ParentHWND.i = UseGadgetList(0) 
   Protected hWnd.i, ID.i
   
   If Gadget = #PB_Any
      ID = UseGadgetList(ParentHWND) 
   Else
      ID = Gadget
   EndIf
   
   hWnd = CreateWindowEx_(#WS_EX_TRANSPARENT, CanvasClassName$, "", #WS_CHILD | #WS_VISIBLE, X, Y, Width, Height, ParentHWND, ID, GetModuleHandle_(#Null), #Null)
   ProcedureReturn hWnd
EndProcedure

Procedure ClearCanvas_(Gadget.i)
   If IsGadget(Gadget)
      SendMessage_(GadgetID(Gadget), #WM_Canvas_Clear, 0, 0)
   Else
      SendMessage_(Gadget, #WM_Canvas_Clear, 0, 0)
   EndIf
EndProcedure

Procedure DrawCanvasFrame_(Gadget.i, Color.l, Thickness.l)
   Protected hWnd.i, *myData.CanvasStructure
   Protected hdc.i, hMemDC.i, hOldBitmap.i, hPen.i, hOldPen.i, hOldBrush.i
   
   If IsGadget(Gadget) : hWnd = GadgetID(Gadget) : Else : hWnd = Gadget : EndIf
   *myData = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
   
   If *myData And *myData\hLayeredImage
      hdc = GetDC_(hWnd)
      hMemDC = CreateCompatibleDC_(hdc)
      hOldBitmap = SelectObject_(hMemDC, *myData\hLayeredImage)
      
      ; Создаем маркер нужной толщины и цвета
      hPen = CreatePen_(#PS_SOLID, Thickness, Color)
      hOldPen = SelectObject_(hMemDC, hPen)
      
      ; NULL_BRUSH защищает рисунок внутри холста от закрашивания черным цветом
      hOldBrush = SelectObject_(hMemDC, GetStockObject_(#NULL_BRUSH))
      
      ; Отрисовываем прямоугольник рамки
      Rectangle_(hMemDC, 0, 0, *myData\Width, *myData\Height)
      
      SelectObject_(hMemDC, hOldBrush)
      SelectObject_(hMemDC, hOldPen)
      DeleteObject_(hPen)
      SelectObject_(hMemDC, hOldBitmap)
      DeleteDC_(hMemDC)
      ReleaseDC_(hWnd, hdc)
      
      InvalidateRect_(hWnd, #Null, #False)
   EndIf
EndProcedure


; ============================================================================
; 3. ДЕМОНСТРАЦИЯ РАБОТЫ (Создаем 4 независимых холста)
; ============================================================================
Global Event.i
Global Canvas1.i, Canvas2.i, Canvas3.i, Canvas4.i

If OpenWindow(0, 100, 100, 700, 560, "4 Холста в одном окне", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   SetWindowColor(0, RGB(235, 235, 240))
   
   ; Текстовые подложки под холстами для проверки прозрачности
   TextGadget(10,  40,  60, 200, 20, "Подложка Холста №1")
   TextGadget(11, 380,  60, 200, 20, "Подложка Холста №2")
   TextGadget(12,  40, 350, 200, 20, "Подложка Холста №3")
   TextGadget(13, 380, 350, 200, 20, "Подложка Холста №4")
   
   ; СОЗДАЕМ 4 НЕЗАВИСИМЫХ ХОЛСТА (с ID от 1 до 4)
   Canvas1 = CanvasGadget_(1,  20,  20, 300, 200)
   Canvas2 = CanvasGadget_(2, 360,  20, 300, 200)
   Canvas3 = CanvasGadget_(3,  20, 370, 300, 200)
   Canvas4 = CanvasGadget_(4, 360,370, 300, 200)
   
   ; ПРИМЕНЕНИЕ: Рисуем рамки разного цвета и толщины на каждом холсте
   DrawCanvasFrame_(Canvas1, RGB(0, 128, 255), 3)  ; Синяя тонкая рамка
   DrawCanvasFrame_(Canvas2, RGB(0, 200, 100), 6)  ; Зеленая рамка потолще
   DrawCanvasFrame_(Canvas3, RGB(255, 128, 0), 2)  ; Оранжевая тонкая линия
   DrawCanvasFrame_(Canvas4, RGB(150, 0, 250), 10) ; Фиолетовая жирная рамка
   
   ; Кнопки очистки для каждого холста
   ButtonGadget(101,  20, 230, 120, 30, "Очистить 1")
   ButtonGadget(102, 360, 230, 120, 30, "Очистить 2")
   ButtonGadget(103,  20, 480, 120, 30, "Очистить 3")
   ButtonGadget(104, 360, 480, 120, 30, "Очистить 4")
   
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         Select EventGadget()
            Case 101 : ClearCanvas_(Canvas1)
            Case 102 : ClearCanvas_(Canvas2)
            Case 103 : ClearCanvas_(Canvas3)
            Case 104 : ClearCanvas_(Canvas4)
         EndSelect
      EndIf
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 350
; FirstLine = 310
; Folding = -----
; EnableXP
; DPIAware