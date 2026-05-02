Structure LinePointer
   *Ptr.Character ; Указатель на начало строки в памяти
   Len.i          ; Длина строки в символах
EndStructure

Structure FastWrap
   Array Lines.LinePointer(0)
   Count.i
   LastWidth.i
   LastText$    ; Для проверки изменения текста
EndStructure

Global MyCanvas.FastWrap

Procedure UpdateWrap(*p.Character, MaxWidth)
   MyCanvas\Count = 0
   Protected *lineStart = *p
   Protected *lastSpace.Character = 0
   
   While *p\c <> 0
      If *p\c = ' ' : *lastSpace = *p : EndIf
      
      ; Замеряем ширину текущего участка
      If TextWidth(PeekS(*lineStart, (*p - *lineStart) / SizeOf(Character) + 1)) > MaxWidth
         
         Protected *breakPtr.Character = *p
         If *lastSpace > *lineStart : *breakPtr = *lastSpace : EndIf
         
         ; Записываем в массив
         ReDim MyCanvas\Lines(MyCanvas\Count)
         MyCanvas\Lines(MyCanvas\Count)\Ptr = *lineStart
         MyCanvas\Lines(MyCanvas\Count)\Len = (*breakPtr - *lineStart) / SizeOf(Character)
         MyCanvas\Count + 1
         
         ; Переходим к следующей строке
         *lineStart = *breakPtr + SizeOf(Character)
         *p = *lineStart
         *lastSpace = 0
      Else
         *p + SizeOf(Character)
      EndIf
   Wend
   
   ; Хвост текста
   If *p > *lineStart
      ReDim MyCanvas\Lines(MyCanvas\Count)
      MyCanvas\Lines(MyCanvas\Count)\Ptr = *lineStart
      MyCanvas\Lines(MyCanvas\Count)\Len = (*p - *lineStart) / SizeOf(Character)
      MyCanvas\Count + 1
   EndIf
EndProcedure

; Основная процедура, объединяющая маску и быстрый вордврап
Procedure DrawSmartFast(CanvasGadget, Text$)
   Protected MaxWidth = GadgetWidth(CanvasGadget) - 40
   Protected RebuildNeeded = #False
   
   If StartDrawing(CanvasOutput(CanvasGadget))
      Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF)
      DrawingMode(#PB_2DDrawing_Transparent)
      FrontColor($000000)
      
      ; МАСКА: Проверяем, нужно ли пересчитывать
      If MyCanvas\LastWidth <> MaxWidth Or MyCanvas\LastText$ <> Text$
         MyCanvas\LastWidth = MaxWidth
         MyCanvas\LastText$ = Text$
         UpdateWrap(@Text$, MaxWidth)
      EndIf
      
      ; ОТРИСОВКА (всегда из массива)
      Protected i, Y = 20
      For i = 0 To MyCanvas\Count - 1
         DrawText(20, Y, PeekS(MyCanvas\Lines(i)\Ptr, MyCanvas\Lines(i)\Len))
         Y + TextHeight("A") + 2
      Next
      
      StopDrawing()
   EndIf
EndProcedure

; --- ПРИМЕР РАБОТЫ ---

If OpenWindow(0, 0, 0, 500, 400, "Fast Pointer Wrap", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 500, 400)
   
   Define MyTxt$ = "Этот метод использует прямые указатели на память строки (*Ptr) и массив вместо списка, что делает его максимально производительным в PureBasic. Маска проверяет ширину и пересчитывает индексы только при необходимости."
   
   DrawSmartFast(0, MyTxt$)
   
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_SizeWindow
         ResizeGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
         DrawSmartFast(0, MyTxt$) ; Пересчитает только если ширина изменилась
      EndIf
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 23
; Folding = ---
; EnableXP
; DPIAware