Structure WrappedLine
   string.s
EndStructure

Structure CustomWrap
   List Lines.WrappedLine()
   LastWidth.i
   LastText.s
EndStructure

Global MyCanvas.CustomWrap

; Кроссплатформенная процедура (Windows / macOS / Linux)
Procedure UpdateWrap(Text$, MaxWidth)
   ClearList(MyCanvas\Lines())
   If MyCanvas\LastWidth <> MaxWidth
      MyCanvas\LastWidth = MaxWidth
      Debug "update"
   EndIf
   If MyCanvas\LastText <> Text$
      MyCanvas\LastText = Text$
      Debug "change"
   EndIf
   
   Protected *p.Character = @Text$        ; Текущий символ
   Protected *lineStart = @Text$          ; Начало текущей строки
   Protected *lastSpace.Character = 0     ; Место последнего пробела
   
   While *p\c <> 0
      ; Если нашли пробел — запоминаем его адрес
      If *p\c = ' ' 
         *lastSpace = *p 
      EndIf
      
      ; Замеряем ширину от начала строки до текущего символа
      If TextWidth(PeekS(*lineStart, (*p - *lineStart) / SizeOf(Character) + 1)) > MaxWidth
         
         AddElement(MyCanvas\Lines())
         
         ; --- ВОТ ТА САМАЯ ЛОГИКА ---
         If *lastSpace > *lineStart
            ; 1. Если был пробел в этой строке — режем по нему (красиво)
            MyCanvas\Lines()\string = PeekS(*lineStart, (*lastSpace - *lineStart) / SizeOf(Character))
            *lineStart = *lastSpace + SizeOf(Character) ; Новая строка начнется ПОСЛЕ пробела
            *p = *lineStart
            *lastSpace = 0
         Else
            ; 2. Если слово слишком длинное и не имеет пробелов — рубим где есть
            MyCanvas\Lines()\string = PeekS(*lineStart, (*p - *lineStart) / SizeOf(Character))
            *lineStart = *p
         EndIf
         
      Else
         *p + SizeOf(Character)
      EndIf
   Wend
   
   ; Добавляем остаток текста
   If *p > *lineStart
      AddElement(MyCanvas\Lines())
      MyCanvas\Lines()\string = PeekS(*lineStart)
   EndIf
EndProcedure

Procedure DrawAll(CanvasGadget, Text$)
   Protected CurrentW = GadgetWidth(CanvasGadget)-40
   
   StartDrawing(CanvasOutput(CanvasGadget))
   ; МАСКА: пересчитываем только если ширина или текст изменились
   If MyCanvas\LastWidth <> CurrentW Or
      MyCanvas\LastText <> Text$
      UpdateWrap(Text$, CurrentW)
   EndIf
   
   Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF)
   DrawingMode(#PB_2DDrawing_Transparent)
   FrontColor($202020)
   
   Protected Y = 20
   ForEach MyCanvas\Lines()
      DrawText(20, Y, MyCanvas\Lines()\string)
      Y + TextHeight("A") + 4
   Next
   StopDrawing()
EndProcedure

; --- Запуск ---
If OpenWindow(0, 0, 0, 400, 300, "Crossplatform Wrap", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 400, 300)
   Txt$ = "Этот метод использует прямые указатели на память строки (*Ptr) и массив вместо списка, что делает его максимально производительным в PureBasic. Маска проверяет ширину и пересчитывает индексы только при необходимости."
 
   DrawAll(0, Txt$)
   
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_SizeWindow
         ResizeGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
         DrawAll(0, Txt$)
      EndIf
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 89
; FirstLine = 58
; Folding = ---
; EnableXP
; DPIAware