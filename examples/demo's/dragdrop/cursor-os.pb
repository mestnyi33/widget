; Загружаем системные библиотеки
Global hOle32 = LoadLibrary_("ole32.dll")

; Извлекаем хендлы курсоров
; В разных версиях Windows индексы в ole32 могут чуть отличаться, 
; но обычно это 1 (Move), 2 (Copy), 3 (Link)
Global hCur_Move = LoadCursor_(hOle32, 1)
Global hCur_Copy = LoadCursor_(hOle32, 2)
Global hCur_Link = LoadCursor_(hOle32, 3)
Global hCur_None = LoadCursor_(0, 32648) ; Стандартный IDC_NO (Запрет)

If OpenWindow(0, 0, 0, 450, 150, "Системные курсоры Drag & Drop", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(0, 10, 10, 430, 130)

  hDC = StartDrawing(CanvasOutput(0))
    If hDC; Очистка фона
    Box(0, 0, 430, 130, $F0F0F0)
    
    ; Функция рисования курсора через API (DrawIcon рисует и иконки, и курсоры)
    ; Параметры: hDC, x, y, hCursor
   ; hDC = BoxVectorOutput() ; Получаем контекст рисования для API
    
    ; 1. Перемещение (Move)
    DrawIcon_(hDC, 40, 40, hCur_Move)
    DrawText(20, 80, "Move (1)", $000000, $F0F0F0)
    
    ; 2. Копирование (Copy)
    DrawIcon_(hDC, 140, 40, hCur_Copy)
    DrawText(120, 80, "Copy (2)", $000000, $F0F0F0)
    
    ; 3. Ссылка (Link)
    DrawIcon_(hDC, 240, 40, hCur_Link)
    DrawText(220, 80, "Link (3)", $000000, $F0F0F0)
    
    ; 4. Запрет (None)
    DrawIcon_(hDC, 340, 40, hCur_None)
    DrawText(320, 80, "None (IDC_NO)", $000000, $F0F0F0)
    
    StopDrawing()
  EndIf

  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
  ; Чистим за собой
  If hOle32 : FreeLibrary_(hOle32) : EndIf
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 27
; FirstLine = 2
; Folding = -
; EnableXP
; DPIAware