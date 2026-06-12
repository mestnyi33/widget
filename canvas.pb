Structure CANVAS_INFO
  window.i
  gadget.i
EndStructure

Structure ROOT_INFO
  drawmode.l
  Canvas.CANVAS_INFO
EndStructure

; --- Специфический обработчик (Callback) для Windows ---
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
Procedure CanvasCallback(hWnd, uMsg, wParam, lParam)
  Protected OldCallback = GetProp_(hWnd, "OldCallback")
  
  Select uMsg
    Case #WM_ERASEBKGND
      ; Шаг 1: Запрещаем Windows рисовать дефолтный белый/серый фон гаджета
      ProcedureReturn 1 
      
    Case #WM_PAINT
      ; Шаг 2: Перед тем, как нарисовать графику из DrawingBuffer, 
      ; заставляем родительское окно прорисовать себя сквозь наш холст
      Protected rect.RECT
      GetClientRect_(hWnd, @rect)
      MapWindowPoints_(hWnd, GetParent_(hWnd), @rect, 2)
      InvalidateRect_(GetParent_(hWnd), @rect, #True)
      UpdateWindow_(GetParent_(hWnd))
  EndSelect
  
  ProcedureReturn CallWindowProc_(OldCallback, hWnd, uMsg, wParam, lParam)
EndProcedure
CompilerEndIf


; --- Основная универсальная процедура очистки ---
Procedure RedrawCanvas(*root.ROOT_INFO)
  If *root\drawmode & 1<<2
    If StartDrawing(CanvasOutput(*root\canvas\gadget))
      
      Protected BufferSize = DrawingBufferPitch() * OutputHeight()
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        ; Для Mac ОС просто зануляем память, включая Альфа-канал
        FillMemory(DrawingBuffer(), BufferSize, 0)
        
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
        ; Для Windows забиваем буфер нулями.
        ; Благодаря перехвату #WM_ERASEBKGND в Callback, нули больше не красят холст в черный цвет!
        ; Вместо этого пиксели становятся полностью "прозрачным стеклом".
        FillMemory(DrawingBuffer(), BufferSize, 0)
        
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
        ; Для Linux (если нужен прозрачный слой)
        FillMemory(DrawingBuffer(), BufferSize, 0)
      CompilerEndIf
      
      ; --- ТЕСТ: Рисуем графику поверх ПРОЗРАЧНОГО фона ---
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
      Circle(50, 50, 30, RGBA(0, 128, 255, 200)) ; Полупрозрачный синий круг
      FrontColor(RGBA(255, 0, 0, 255))
      DrawText(90, 40, "Прозрачный Canvas!")
      
      StopDrawing()
    EndIf
  EndIf
EndProcedure


; --- Инициализация тестового окна ---
Define Root.ROOT_INFO
Root\drawmode = 4
Root\canvas\window = OpenWindow(#PB_Any, 100, 200, 400, 200, "Кроссплатформенный прозрачный холст")

; Зададим окну яркий фоновый цвет, чтобы прозрачность холста была сразу видна
SetWindowColor(Root\canvas\window, $A0D8FF) 

Root\canvas\gadget = CanvasGadget(#PB_Any, 30, 30, 340, 140)

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  ; Включаем субклассирование для Windows-гаджета
  Protected hWndCanvas = GadgetID(Root\canvas\gadget)
  SetProp_(hWndCanvas, "OldCallback", SetWindowLongPtr_(hWndCanvas, #GWL_WNDPROC, @CanvasCallback()))
CompilerEndIf

; Вызываем отрисовку
RedrawCanvas(@root)

Repeat
  Define Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 91
; FirstLine = 69
; Folding = --
; EnableXP
; DPIAware