; Процедура отрисовки через WinAPI
Procedure DrawWinAPIWrap(CanvasGadget, Text$)
  Protected rect.RECT
  
  ; 1. Подготовка области рисования (контейнера)
  ; Задаем отступы: лево, право, верх.
  rect\left = 20
  rect\top = 20
  rect\right = GadgetWidth(CanvasGadget) - 20
  rect\bottom = GadgetHeight(CanvasGadget) - 20
  
  If StartDrawing(CanvasOutput(CanvasGadget))
    ; Очищаем фон
    Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF)
    
    ; Задаем цвет текста
    FrontColor($000000)
    DrawingMode(#PB_2DDrawing_Transparent)
    
    ; Получаем HDC (Handle Device Context) текущего сеанса рисования
    Protected DrawText_Context = ImageContext() ; Или просто вызвать DrawText_
    
    ; В современных версиях PureBasic (начиная с 5.30+) переменная DrawText_Context была заменена на специальную функцию
    ; hdc = GetGadgetContext(#Gadget) или системную переменную *DrawingInfo\Context.
    
    ; 2. Вызов системного API
    ; hDC - это контекст устройства, который PureBasic дает через StartDrawing
    ; #DT_WORDBREAK - автоматический перенос по словам
    ; #DT_EXPANDTABS - поддержка табуляции
    DrawText_(DrawText_Context, Text$, -1, @rect, #DT_WORDBREAK | #DT_EXPANDTABS)
    
    StopDrawing()
  EndIf
EndProcedure

; --- ОСНОВНОЙ ЦИКЛ ---

If OpenWindow(0, 0, 0, 400, 300, "Windows API WordWrap", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 400, 300)
  
  Define MyTxt$ = "Это использование функции WinAPI DrawText_. " + 
                  "Она сама переносит текст, учитывает границы прямоугольника (rect) " +
                  "и работает быстрее, чем любые ручные циклы на PureBasic. " +
                  "Попробуйте изменить размер окна — текст будет перетекать идеально."
  
  DrawWinAPIWrap(0, MyTxt$)

  Repeat
    Event = WaitWindowEvent()
    If Event = #PB_Event_SizeWindow
      ResizeGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
      DrawWinAPIWrap(0, MyTxt$)
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 20
; FirstLine = 15
; Folding = -
; EnableXP
; DPIAware