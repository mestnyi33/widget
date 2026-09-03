; Загружаем системные библиотеки
Global hOle32 = LoadLibrary_("ole32.dll")

; Процедура конвертации системного хендла курсора в ImageID PureBasic
Procedure CursorToImage(hCursor)
   Protected iconInfo.ICONINFO
   Protected h, img = -1
   
   If GetIconInfo_(hCursor, @iconInfo)
      ; Создаем новое изображение такого же размера, как курсор
      ; Обычно это 32x32 или размер, заданный системой
      img = CreateImage(#PB_Any, 32, 32, 32, #PB_Image_Transparent)
      
      If img
         h = StartDrawing(ImageOutput(img))
         ; Отрисовываем иконку/курсор прямо в контекст изображения
         DrawIconEx_(h, 0, 0, hCursor, 32, 32, 0, 0, #DI_NORMAL)
         StopDrawing()
      EndIf
      
      ; Важно: GetIconInfo создает копии битмапов, их нужно удалить!
      DeleteObject_(iconInfo\hbmMask)
      DeleteObject_(iconInfo\hbmColor)
   EndIf
   
   ProcedureReturn img
EndProcedure

; Извлекаем хендлы курсоров
; В разных версиях Windows индексы в ole32 могут чуть отличаться, 
; но обычно это 1 (Move), 2 (Copy), 3 (Link)
; Global hCur_5 = LoadCursor_(hOle32, 5)
; Global hCur_6 = LoadCursor_(hOle32, 6)
; Global hCur_7 = LoadCursor_(hOle32, 7)
Global hCur_Move = LoadCursor_(hOle32, 1)
Global hCur_Copy = LoadCursor_(hOle32, 2)
Global hCur_Link = LoadCursor_(hOle32, 3)
Global hCur_None = LoadCursor_(0, 32648) ; Стандартный IDC_NO (Запрет)

; Конвертируем хендл в картинку PureBasic
imgID = CursorToImage(hCur_Copy)


If OpenWindow(0, 0, 0, 450, 200, "Системные курсоры Drag & Drop", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(0, 10, 10, 430, 180)
   
   hDC = StartDrawing(CanvasOutput(0))
   If hDC; Очистка фона
      Box(0, 120, 430, 130, $F0F0F0)
      
      ; Функция рисования курсора через API (DrawIcon рисует и иконки, и курсоры)
      ; Параметры: hDC, x, y, hCursor
      ; hDC = BoxVectorOutput() ; Получаем контекст рисования для API
      
      ; 1. Перемещение (Move)
      DrawIcon_(hDC, 40, 140, hCur_Move)
      DrawText(20, 180, "Move (1)", $000000, $F0F0F0)
      
      ; 2. Копирование (Copy)
      DrawIcon_(hDC, 140, 140, hCur_Copy)
      DrawText(120, 180, "Copy (2)", $000000, $F0F0F0)
      
      ; 3. Ссылка (Link)
      DrawIcon_(hDC, 240, 140, hCur_Link)
      DrawText(220, 180, "Link (3)", $000000, $F0F0F0)
      
      ; 4. Запрет (None)
      DrawIcon_(hDC, 340, 140, hCur_None)
      DrawText(320, 180, "None (IDC_NO)", $000000, $F0F0F0)
      
      StopDrawing()
   EndIf
   
   
   If imgID <> -1
      ; Теперь это обычная картинка! Можем её увеличить или вывести в ImageGadget
      ImageGadget(2, 20, 20, 100, 100, ImageID(imgID))
      
      ; Пример: рисуем эту картинку на Canvas, увеличив в 2 раза
      If StartDrawing(CanvasOutput(0))
         DrawAlphaImage(ImageID(imgID), 150, 20, 255) ; Вывод с прозрачностью
        DrawText(150, 50, "draw canvas", $000000, $F0F0F0)
       StopDrawing()
      EndIf
   EndIf
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   
   ; Чистим за собой
   If hOle32 : FreeLibrary_(hOle32) : EndIf
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 81
; FirstLine = 52
; Folding = --
; EnableXP
; DPIAware