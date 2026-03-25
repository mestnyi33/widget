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

; --- ПРИМЕР ИСПОЛЬЗОВАНИЯ ---

hOle32 = LoadLibrary_("ole32.dll")
hCur_Copy = LoadCursor_(hOle32, 2) ; Курсор "Копирование"

If OpenWindow(0, 0, 0, 200, 200, "Cursor to Image", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Конвертируем хендл в картинку PureBasic
  imgID = CursorToImage(hCur_Copy)
  
  If imgID <> -1
    ; Теперь это обычная картинка! Можем её увеличить или вывести в ImageGadget
    ImageGadget(0, 50, 50, 100, 100, ImageID(imgID))
    
    ; Пример: рисуем эту картинку на Canvas, увеличив в 2 раза
    CanvasGadget(1, 120, 50, 64, 64)
    If StartDrawing(CanvasOutput(1))
      DrawAlphaImage(ImageID(imgID), 0, 0, 255) ; Вывод с прозрачностью
      StopDrawing()
    EndIf
  EndIf

  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
  If hOle32 : FreeLibrary_(hOle32) : EndIf
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 3
; Folding = --
; EnableXP
; DPIAware