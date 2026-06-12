EnableExplicit

; ============================================================================
; 1. СКРЫТЫЙ ИМПОРТ И СТРУКТУРЫ (Внутреннее ядро гаджета)
; ============================================================================
Prototype.b Canvas_AlphaBlend(hdcDest.i, xDest.l, yDest.l, wDest.l, hDest.l, hdcSrc.i, xSrc.l, ySrc.l, wSrc.l, hSrc.l, blendFunc.l)

Structure CanvasStructure
   hWnd.i          ; Хэндл WinAPI окна гаджета
   IsDrawing.b     ; Флаг зажатой мыши пользователя
   LastX.l         ; Координаты мыши
   LastY.l
   hLayeredImage.i ; Скрытый буфер в памяти
   Width.l         ; Размеры буфера
   Height.l
   DrawColor.l     ; Цвет рисования пользователя
   Thickness.l     ; Толщина линии пользователя
   hCurrentDC.i    ; Виртуальный контекст рисования
   hOldBitmap.i    ; Старый битмап для очистки памяти
                   ; НОВОЕ ПОЛЕ: Хранит дескриптор текущего шрифта холста
   hCurrentFont.i  
   DrawingMode.l
   IsEraser.b      ; #True - режим ластика, #False - режим маркера
EndStructure

Structure Canvas_BLENDFUNCTION
   BlendOp.b
   BlendFlags.b
   SourceConstantAlpha.b
   AlphaFormat.b
EndStructure

Global CanvasClassName$ = "PureBasic_Canvas_Class"
Global Canvas_AlphaBlend_.Canvas_AlphaBlend

; Ваш глобальный указатель, который динамически переключается на лету
Global *myData.CanvasStructure

#Canvas_TimerID = 1      
#WM_Canvas_Clear = #WM_USER + 100 

; Внутренний WinAPI-обработчик событий гаджета
Procedure.i CanvasInternalProc(hWnd.i, uMsg.l, wParam.i, lParam.i)
   Protected *localData.CanvasStructure = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
   Protected ps.PAINTSTRUCT
   Protected hdc.i, hMemDC.i, hOldBitmap.i, rect.RECT
   Protected X.l, Y.l, hPen.i, hBrush.i, parentHWND.i
   Protected pt.POINT
   
   Select uMsg
      Case #WM_CREATE
         *localData = AllocateMemory(SizeOf(CanvasStructure))
         InitializeStructure(*localData, CanvasStructure)
         *localData\hWnd = hWnd
         *localData\Width = 100  
         *localData\Height = 100
         *localData\DrawColor = RGB(255, 0, 0) 
         *localData\Thickness = 5              
         
         SetTimer_(hWnd, #Canvas_TimerID, 50, #Null)
         SetWindowLongPtr_(hWnd, #GWLP_USERDATA, *localData)
         ProcedureReturn 0
         
      Case #WM_SIZE
         If *localData
            *localData\Width = lParam & $FFFF
            *localData\Height = (lParam >> 16) & $FFFF
            
            If *localData\hLayeredImage : DeleteObject_(*localData\hLayeredImage) : EndIf
            
            hdc = GetDC_(hWnd)
            *localData\hLayeredImage = CreateCompatibleBitmap_(hdc, *localData\Width, *localData\Height)
            hMemDC = CreateCompatibleDC_(hdc)
            hOldBitmap = SelectObject_(hMemDC, *localData\hLayeredImage)
            
            SetRect_(@rect, 0, 0, *localData\Width, *localData\Height)
            hBrush = CreateSolidBrush_(RGB(0, 0, 0))
            FillRect_(hMemDC, @rect, hBrush)
            DeleteObject_(hBrush)
            
            SelectObject_(hMemDC, hOldBitmap)
            DeleteDC_(hMemDC)
            ReleaseDC_(hWnd, hdc)
         EndIf
         ProcedureReturn 0
         
      Case #WM_NCDESTROY
         If *localData
            KillTimer_(hWnd, #Canvas_TimerID) 
            If *localData\hLayeredImage : DeleteObject_(*localData\hLayeredImage) : EndIf
            FreeMemory(*localData)
         EndIf
         ProcedureReturn 0
         
      Case #WM_ERASEBKGND
         ProcedureReturn 1 
         
      Case #WM_PAINT
         hdc = BeginPaint_(hWnd, @ps)
         If *localData And *localData\hLayeredImage
            GetClientRect_(hWnd, @rect)
            hMemDC = CreateCompatibleDC_(hdc)
            hOldBitmap = SelectObject_(hMemDC, *localData\hLayeredImage)
            TransparentBlt_(hdc, 0, 0, rect\right, rect\bottom, hMemDC, 0, 0, rect\right, rect\bottom, RGB(0, 0, 0))
            SelectObject_(hMemDC, hOldBitmap)
            DeleteDC_(hMemDC)
         EndIf
         EndPaint_(hWnd, @ps)
         ProcedureReturn 0
         
         ;       Case #WM_TIMER
         ;          If wParam = #Canvas_TimerID And *localData And *localData\hLayeredImage And Canvas_AlphaBlend_
         ;             If *localData\hCurrentDC = #Null
         ;                hdc = GetDC_(hWnd)
         ;                hMemDC = CreateCompatibleDC_(hdc)
         ;                hOldBitmap = SelectObject_(hMemDC, *localData\hLayeredImage)
         ;                
         ;                Protected bf.Canvas_BLENDFUNCTION
         ;                bf\BlendOp = 0          
         ;                bf\BlendFlags = 0
         ;                bf\SourceConstantAlpha = 15 
         ;                bf\AlphaFormat = 0
         ;                
         ;                Protected blendValue.l
         ;                CopyMemory(@bf, @blendValue, 4)
         ;                
         ;                Protected hTempDC = CreateCompatibleDC_(hdc)
         ;                Protected hTempBitmap = CreateCompatibleBitmap_(hdc, *localData\Width, *localData\Height)
         ;                Protected hOldTemp = SelectObject_(hTempDC, hTempBitmap)
         ;                
         ;                SetRect_(@rect, 0, 0, *localData\Width, *localData\Height)
         ;                hBrush = CreateSolidBrush_(RGB(0, 0, 0))
         ;                FillRect_(hTempDC, @rect, hBrush)
         ;                DeleteObject_(hBrush)
         ;                
         ;                Canvas_AlphaBlend_(hMemDC, 0, 0, *localData\Width, *localData\Height, hTempDC, 0, 0, *localData\Width, *localData\Height, blendValue)
         ;                
         ;                SelectObject_(hTempDC, hOldTemp)
         ;                DeleteObject_(hTempBitmap)
         ;                DeleteDC_(hTempDC)
         ;                SelectObject_(hMemDC, hOldBitmap)
         ;                DeleteDC_(hMemDC)
         ;                ReleaseDC_(hWnd, hdc)
         ;                
         ;                InvalidateRect_(hWnd, #Null, #False)
         ;             EndIf
         ;          EndIf
         ;          ProcedureReturn 0
         ;          
      Case #WM_Canvas_Clear
         If *localData And *localData\hLayeredImage
            ShowWindow_(hWnd, #SW_HIDE)
            hdc = GetDC_(hWnd)
            hMemDC = CreateCompatibleDC_(hdc)
            hOldBitmap = SelectObject_(hMemDC, *localData\hLayeredImage)
            
            SetRect_(@rect, 0, 0, *localData\Width, *localData\Height)
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
         If *localData
            *localData\IsDrawing = #True
            *localData\LastX = lParam & $FFFF
            *localData\LastY = (lParam >> 16) & $FFFF
            SetCapture_(hWnd)
         EndIf
         ProcedureReturn 0
         
      Case #WM_LBUTTONUP
         If *localData And *localData\IsDrawing
            *localData\IsDrawing = #False
            ReleaseCapture_()
         EndIf
         ProcedureReturn 0
         
      Case #WM_MOUSEMOVE
         If *localData And *localData\IsDrawing And *localData\hLayeredImage
            X = lParam & $FFFF
            Y = (lParam >> 16) & $FFFF
            
            hdc = GetDC_(hWnd)
            hMemDC = CreateCompatibleDC_(hdc)
            hOldBitmap = SelectObject_(hMemDC, *localData\hLayeredImage)
            
            ; ИСПРАВЛЕНИЕ ДЛЯ ЛАСТИКА:
            If *localData\IsEraser
               ; Поскольку прозрачным цветом нашего холста является чистый черный RGB(0,0,0),
               ; то чтобы стереть линию "до стекла", нам нужно просто рисовать черным цветом!
               hPen = CreatePen_(#PS_SOLID, *localData\Thickness, RGB(0, 0, 0)) 
            Else
               ; Обычный режим рисования маркером
               hPen = CreatePen_(#PS_SOLID, *localData\Thickness, *localData\DrawColor) 
            EndIf
            
            SelectObject_(hMemDC, hPen)
            MoveToEx_(hMemDC, *localData\LastX, *localData\LastY, #Null)
            LineTo_(hMemDC, X, Y)
            
            DeleteObject_(hPen)
            SelectObject_(hMemDC, hOldBitmap)
            DeleteDC_(hMemDC)
            ReleaseDC_(hWnd, hdc)
            
            *localData\LastX = X
            *localData\LastY = Y
            
            InvalidateRect_(hWnd, #Null, #False)
         EndIf
         ProcedureReturn 0

   EndSelect
   
   ProcedureReturn DefWindowProc_(hWnd, uMsg, wParam, lParam)
EndProcedure

; ============================================================================
; 2. ПУБЛИЧНЫЙ ИНТЕРФЕЙС ГАДЖЕТА (Камуфляж функций)
; ============================================================================
Procedure.i CanvasGadget_(Gadget.i, X.l, Y.l, Width.l, Height.l)
   ; Статическая переменная для контроля однократной инициализации
   Static IsInit = #False
   
   ; Если инициализация класса ещё не проводилась
   If Not IsInit
      ; 1. Загружаем WinAPI библиотеку блендинга
      Protected Lib = OpenLibrary(#PB_Any, "msimg32.dll")
      If Lib : Canvas_AlphaBlend_ = GetFunction(Lib, "AlphaBlend") : EndIf
      
      ; 2. Подготавливаем и регистрируем класс окна гаджета в Windows
      Protected wcex.WNDCLASSEX
      wcex\cbSize        = SizeOf(WNDCLASSEX)
      wcex\style         = #CS_HREDRAW | #CS_VREDRAW
      wcex\lpfnWndProc   = @CanvasInternalProc()
      wcex\hInstance     = GetModuleHandle_(#Null)
      wcex\hCursor       = LoadCursor_(#Null, #IDC_ARROW)
      wcex\lpszClassName = @CanvasClassName$
      
      If RegisterClassEx_(@wcex)
         IsInit = #True ; Успешно зарегистрировано, больше сюда не заходим
      Else
         ProcedureReturn #Null ; Если Windows не смогла создать класс, выходим
      EndIf
   EndIf
   
   ; --- ДАЛЬШЕ ИДЁТ СТАНДАРТНОЕ СОЗДАНИЕ ГАДЖЕТА ---
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

Procedure ClearCanvasGadget_(Gadget.i)
   If IsGadget(Gadget) : SendMessage_(GadgetID(Gadget), #WM_Canvas_Clear, 0, 0) : Else : SendMessage_(Gadget, #WM_Canvas_Clear, 0, 0) : EndIf
EndProcedure

; ============================================================================
;- ПУБЛИЧНЫЕ УНИВЕРСАЛЬНЫЕ КОМАНДЫ РИСОВАНИЯ
; ============================================================================

; 1. (Создает контекст для рисования)
Procedure.i StartDrawing_(Gadget.i)
   Protected hWnd.i, hdc.i
   
   If IsGadget(Gadget) : hWnd = GadgetID(Gadget) : Else : hWnd = Gadget : EndIf
   *myData = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
   
   If *myData And *myData\hLayeredImage
      *myData\hWnd = hWnd
      hdc = GetDC_(hWnd)
      
      ; Создаем виртуальный контекст для рисования
      *myData\hCurrentDC = CreateCompatibleDC_(hdc)
      *myData\hOldBitmap = SelectObject_(*myData\hCurrentDC, *myData\hLayeredImage)
      
      ReleaseDC_(hWnd, hdc)
      
      ; Если у холста с прошлого раза остался шрифт — сразу активируем его
      If *myData\hCurrentFont
         SelectObject_(*myData\hCurrentDC, *myData\hCurrentFont)
      EndIf
      
      ProcedureReturn *myData\hCurrentDC
   EndIf
   ProcedureReturn #Null
EndProcedure

; 3. (Закрывает контекст и выводит графику на экран)
Procedure StopDrawing_()
   If *myData And *myData\hCurrentDC 
      ; Возвращаем старый дефолтный битмап на место и удаляем контекст рисования
      SelectObject_(*myData\hCurrentDC, *myData\hOldBitmap)
      DeleteDC_(*myData\hCurrentDC)
      
      *myData\hCurrentDC = #Null
      *myData\hOldBitmap = #Null
      
      ; Мгновенно перерисовываем холст на экране
      InvalidateRect_(*myData\hWnd, #Null, #False)
   EndIf
EndProcedure

; Наша новая ключевая функция переключения режимов
Procedure DrawingMode_(Mode.l)
   If *myData
      *myData\DrawingMode = Mode
   EndIf
EndProcedure

; --- КЛЮЧЕВАЯ КОМАНДА: УСТАНОВКА ШРИФТА ДЛЯ РИСОВАНИЯ ---
Procedure DrawingFont_(FontID.i)
   If *myData
      ; Просто сохраняем переданный системный дескриптор FontID() в структуру холста
      *myData\hCurrentFont = FontID
      
      ; Прямое применение: если контекст открыт, мгновенно передаем шрифт в WinAPI
      If *myData\hCurrentDC
         SelectObject_(*myData\hCurrentDC, *myData\hCurrentFont)
      EndIf
   EndIf
EndProcedure

; Универсальный круг (Circle)
Procedure DrawingCircle_(X.l, Y.l, Radius.l, Color.l, Thickness.l = 1)
   If *myData And *myData\hCurrentDC
      Protected DC.i = *myData\hCurrentDC
      Protected hPen.i, hOldPen.i, hBrush.i, hOldBrush.i
      
      ; Перья создаем всегда (для режима заливки толщина принудительно 1 пиксель)
      If *myData\DrawingMode & #PB_2DDrawing_Outlined
         hPen = CreatePen_(#PS_SOLID, Thickness, Color)
         hBrush = GetStockObject_(#NULL_BRUSH) ; Пустая кисть для контура
      Else
         hPen = CreatePen_(#PS_SOLID, 1, Color)
         hBrush = CreateSolidBrush_(Color)      ; Плотная кисть для заливки
      EndIf
      
      hOldPen = SelectObject_(DC, hPen)
      hOldBrush = SelectObject_(DC, hBrush)
      
      Ellipse_(DC, X - Radius, Y - Radius, X + Radius, Y + Radius)
      
      SelectObject_(DC, hOldBrush)
      SelectObject_(DC, hOldPen)
      
      ; Чистим в памяти только то, что создавали вручную
      If Not (*myData\DrawingMode & #PB_2DDrawing_Outlined)
         DeleteObject_(hBrush)
      EndIf
      DeleteObject_(hPen)
   EndIf
EndProcedure

; Универсальный прямоугольник (Box)
Procedure DrawingBox_(X.l, Y.l, Width.l, Height.l, Color.l, Thickness.l = 1)
   If *myData And *myData\hCurrentDC
      Protected DC.i = *myData\hCurrentDC
      Protected hPen.i, hOldPen.i, hBrush.i, hOldBrush.i
      
      If *myData\DrawingMode & #PB_2DDrawing_Outlined
         hPen = CreatePen_(#PS_SOLID, Thickness, Color)
         hBrush = GetStockObject_(#NULL_BRUSH)
      Else
         hPen = CreatePen_(#PS_SOLID, 1, Color)
         hBrush = CreateSolidBrush_(Color)
      EndIf
      
      hOldPen = SelectObject_(DC, hPen)
      hOldBrush = SelectObject_(DC, hBrush)
      
      Rectangle_(DC, X, Y, X + Width, Y + Height)
      
      SelectObject_(DC, hOldBrush)
      SelectObject_(DC, hOldPen)
      
      If Not (*myData\DrawingMode & #PB_2DDrawing_Outlined)
         DeleteObject_(hBrush)
      EndIf
      DeleteObject_(hPen)
   EndIf
EndProcedure

; Универсальный скругленный прямоугольник (RoundBox)
Procedure DrawingRoundBox_(X.l, Y.l, Width.l, Height.l, RoundX.l, RoundY.l, Color.l, Thickness.l = 1)
   If *myData And *myData\hCurrentDC
      Protected DC.i = *myData\hCurrentDC
      Protected hPen.i, hOldPen.i, hBrush.i, hOldBrush.i
      
      If *myData\DrawingMode & #PB_2DDrawing_Outlined
         hPen = CreatePen_(#PS_SOLID, Thickness, Color)
         hBrush = GetStockObject_(#NULL_BRUSH)
      Else
         hPen = CreatePen_(#PS_SOLID, 1, Color)
         hBrush = CreateSolidBrush_(Color)
      EndIf
      
      hOldPen = SelectObject_(DC, hPen)
      hOldBrush = SelectObject_(DC, hBrush)
      
      RoundRect_(DC, X, Y, X + Width, Y + Height, RoundX, RoundY)
      
      SelectObject_(DC, hOldBrush)
      SelectObject_(DC, hOldPen)
      
      If Not (*myData\DrawingMode & #PB_2DDrawing_Outlined)
         DeleteObject_(hBrush)
      EndIf
      DeleteObject_(hPen)
   EndIf
EndProcedure

; Вспомогательные функции для рисования внутри блока StartDrawing/StopDrawing
Procedure DrawingLine_(X1.l, Y1.l, X2.l, Y2.l, Color.l, Thickness.l)
   If *myData And *myData\hCurrentDC
      Protected DC.i = *myData\hCurrentDC
      Protected hPen = CreatePen_(#PS_SOLID, Thickness, Color)
      Protected hOldPen = SelectObject_(DC, hPen)
      MoveToEx_(DC, X1, Y1, #Null)
      LineTo_(DC, X2, Y2)
      SelectObject_(DC, hOldPen)
      DeleteObject_(hPen)
   EndIf
EndProcedure

; Обновленный вывод текста: теперь он сам берёт шрифт холста
Procedure DrawingText_(X.l, Y.l, Text$, Color.l)
   If *myData And *myData\hCurrentDC
      Protected DC.i = *myData\hCurrentDC
      SetBkMode_(DC, #TRANSPARENT)
      SetTextColor_(DC, Color)
      TextOut_(DC, X, Y, Text$, Len(Text$))
   EndIf
EndProcedure


; 1. Функция переключения режима ластика
Procedure SetCanvasEraser_(Gadget.i, State.b)
   Protected hWnd.i, *localData.CanvasStructure
   If IsGadget(Gadget) : hWnd = GadgetID(Gadget) : Else : hWnd = Gadget : EndIf
   *localData = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
   If *localData
      *localData\IsEraser = State
   EndIf
EndProcedure

; 2. ПОЛУЧЕНИЕ ЦВЕТА ПИКСЕЛЯ (Аналог Point() в PureBasic)
Procedure.l Point_(X.l, Y.l)
   If *myData And *myData\hCurrentDC
      ; Извлекаем RGB цвет точки напрямую из виртуального контекста памяти
      ProcedureReturn GetPixel_(*myData\hCurrentDC, X, Y)
   EndIf
   ProcedureReturn 0
EndProcedure

; 3. ЗАЛИВКА ЗАМКНУТОЙ ОБЛАСТИ (Аналог FillArea() в PureBasic)
Procedure FillArea_(X.l, Y.l, Color.l)
   If *myData And *myData\hCurrentDC
      Protected DC.i = *myData\hCurrentDC
      Protected hBrush.i, hOldBrush.i, TargetColor.l
      
      ; Узнаем цвет пикселя, по которому кликнули (он будет заменяться)
      TargetColor = GetPixel_(DC, X, Y)
      
      ; Если цвет пикселя уже совпадает с цветом заливки — ничего не делаем (защита от зависания)
      If TargetColor = Color : ProcedureReturn : EndIf
      
      ; Создаем кисть нужного цвета и выбираем её в контекст
      hBrush = CreateSolidBrush_(Color)
      hOldBrush = SelectObject_(DC, hBrush)
      
      ; WinAPI функция "умной" заливки. Растекается, пока не встретит цвет, отличный от TargetColor
      ExtFloodFill_(DC, X, Y, TargetColor, #FLOODFILLSURFACE)
      
      ; Освобождаем ресурсы кисти
      SelectObject_(DC, hOldBrush)
      DeleteObject_(hBrush)
   EndIf
EndProcedure

;-
; Обновленная кнопка: теперь она тоже наследует шрифт по умолчанию с вашего холста!
Procedure DrawingButton_(X.l, Y.l, Width.l, Height.l, Text$, IsPressed.b = #False)
   If *myData And *myData\hCurrentDC
      Protected DC.i = *myData\hCurrentDC
      Protected rect.RECT
      Protected hOldFont.i = 0, hBrush.i
      
      SetRect_(@rect, X, Y, X + Width, Y + Height)
      
      ; Отрисовка тела кнопки
      If IsPressed
         hBrush = CreateSolidBrush_(RGB(80, 80, 80))
         FillRect_(DC, @rect, hBrush)
         DeleteObject_(hBrush)
         DrawEdge_(DC, @rect, #EDGE_SUNKEN, #BF_RECT)
      Else
         hBrush = CreateSolidBrush_(RGB(220, 222, 225))
         FillRect_(DC, @rect, hBrush)
         DeleteObject_(hBrush)
         DrawEdge_(DC, @rect, #EDGE_RAISED, #BF_RECT)
      EndIf
      
      SetBkMode_(DC, #TRANSPARENT)
      
      If IsPressed
         SetTextColor_(DC, RGB(255, 255, 255))
         rect\left + 1 : rect\top + 1
      Else
         SetTextColor_(DC, RGB(40, 40, 40))
      EndIf
      
      DrawText_(DC, Text$, Len(Text$), @rect, #DT_CENTER | #DT_VCENTER | #DT_SINGLELINE)
   EndIf
EndProcedure

Procedure SetCanvasFont_(Gadget.i, FontName$, Size.l, Bold.b = #False)
;    Protected hWnd.i
;    Protected Style.l = #FW_NORMAL
;    If Bold : Style = #FW_BOLD : EndIf
;    
;    If IsGadget(Gadget) : hWnd = GadgetID(Gadget) : Else : hWnd = Gadget : EndIf
;    *myData = GetWindowLongPtr_(hWnd, #GWLP_USERDATA)
;    
;    If *myData
;       ; Если шрифт уже был задан ранее — удаляем его старую копию из памяти
;       If *myData\hCurrentFont : DeleteObject_(*myData\hCurrentFont) : EndIf
;       
;       ; Создаем жесткий шрифт без ClearType-размытия для идеальной чёткости на стекле
;       *myData\hCurrentFont = CreateFont_(Size, 0, 0, 0, Style, #False, #False, #False, #DEFAULT_CHARSET, #OUT_DEFAULT_PRECIS, #CLIP_DEFAULT_PRECIS, #NONANTIALIASED_QUALITY, #DEFAULT_PITCH | #FF_DONTCARE, FontName$)
;    EndIf
EndProcedure


; ============================================================================
; 3. ТЕСТОВЫЙ ЗАПУСК С ДВУМЯ АКТИВНЫМИ ХОЛСТАМИ
; ============================================================================
Global Event.i, Canvas1.i, Canvas2.i

If OpenWindow(0, 100, 100, 700, 500, "Проверка мульти-холста через один *myData", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   SetWindowColor(0, RGB(235, 235, 240))
   
   TextGadget(10, 40,  60, 200, 20, "Текст под Холстом №1")
   TextGadget(11, 380, 60, 200, 20, "Текст под Холстом №2")
   
   ButtonGadget(2, 20, 440, 180, 35, "Нарисовать на Холсте 1")
   ButtonGadget(3, 360, 440, 180, 35, "Нарисовать на Холсте 2")
   
   ; Создаем два независимых прозрачных холста
   Canvas1 = CanvasGadget_(1, 20, 20, 300, 380)
   Canvas2 = CanvasGadget_(2, 360, 20, 300, 380)
   
   
   ; Рисуем кнопку на ПЕРВОМ холсте
   If StartDrawing_(Canvas1)
      ; Рисуем кнопку на координатах X=50, Y=50, размером 150х40 пикселей
      DrawingButton_(50, 150, 150, 40, "WinAPI Кнопка")
      StopDrawing_()
   EndIf
   
   ; Рисуем ЗАЖАТУЮ кнопку на ВТОРОМ холсте
   If StartDrawing_(Canvas2)
      ; Последний параметр #True заставит кнопку отрисоваться вдавленной
      DrawingButton_(50, 150, 150, 40, "Зажатая кнопка", #True)
      StopDrawing_()
   EndIf
   
   If StartDrawing_(Canvas1)
      
      DrawingMode_(#PB_2DDrawing_Default)
      ; Рисуем красивый плотный синий круг в центре (X=300, Y=200, радиус=50)
      DrawingCircle_(30, 200, 50, RGB(0, 100, 255))
      
      DrawingMode_(#PB_2DDrawing_Outlined)
      ; Рисуем вокруг него три контурных зеленых кольца потолще
      DrawingCircle_(30, 200, 80, RGB(0, 255, 64), 3)
      DrawingCircle_(30, 200, 110, RGB(0, 255, 64), 5)
      DrawingCircle_(30, 200, 140, RGB(0, 255, 64), 8)
      
      StopDrawing_()
   EndIf
   
   If StartDrawing_(Canvas2)
      
      DrawingMode_(#PB_2DDrawing_Default)
      DrawingBox_(120, 100, 120, 100, RGB(255, 128, 0)) ; Оранжевый блок
      DrawingRoundBox_(50, 200, 200, 120, 25, 25, RGB(140, 0, 255))
      
      DrawingMode_(#PB_2DDrawing_Outlined)
      DrawingBox_(100, 80, 160, 140, RGB(255, 0, 128), 3)   ; Розовая рамка
      DrawingRoundBox_(30, 180, 240, 160, 30, 30, RGB(0, 255, 200), 4)
      
      StopDrawing_()
   EndIf
   
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         
         If EventGadget() = 2
            ; Рисуем на ПЕРВОМ холсте
            If StartDrawing_(Canvas1)
               DrawingLine_(0, 0, 300, 380, RGB(0, 100, 255), 4)
               DrawingText_(40, 150, "ПЕРВЫЙ ХОЛСТ", RGB(255, 255, 0))
               StopDrawing_()
            EndIf
         EndIf
         
         If EventGadget() = 3
            ; Рисуем на ВТОРОМ холсте
            If StartDrawing_(Canvas2)
               DrawingLine_(300, 0, 0, 380, RGB(0, 200, 64), 6)
               DrawingText_(40, 150, "ВТОРОЙ ХОЛСТ", RGB(255, 0, 255))
               StopDrawing_()
            EndIf
         EndIf
         
      EndIf
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 195
; FirstLine = 191
; Folding = ------------
; EnableXP
; DPIAware