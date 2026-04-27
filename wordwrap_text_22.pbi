Structure WrappedLine
  TextLine.s
EndStructure

Structure CustomWrap
  List Lines.WrappedLine()
  LastWidth.i
  LastText.s
EndStructure

Global MyCanvasText.CustomWrap

; Кроссплатформенная процедура (Windows / macOS / Linux)
Procedure _UpdateWrap(CanvasGadget, Text$, MaxWidth)
  ClearList(MyCanvasText\Lines())
  MyCanvasText\LastWidth = MaxWidth
  MyCanvasText\LastText = Text$
  
  Protected *p.Character = @Text$
  Protected *lineStart = @Text$
  Protected *lastSpace.Character = 0
  
  StartDrawing(CanvasOutput(CanvasGadget))
    ; DrawingFont(FontID(#YourFont)) ; Раскомментируй, если есть свой шрифт
    
    While *p\c <> 0
      If *p\c = ' ' : *lastSpace = *p : EndIf
      
      ; Замеряем ширину текущего сегмента
      If TextWidth(PeekS(*lineStart, (*p - *lineStart) / SizeOf(Character) + 1)) > MaxWidth
        
        AddElement(MyCanvasText\Lines())
        If *lastSpace > *lineStart
          MyCanvasText\Lines()\TextLine = PeekS(*lineStart, (*lastSpace - *lineStart) / SizeOf(Character))
          *lineStart = *lastSpace + SizeOf(Character)
          *p = *lineStart
          *lastSpace = 0
        Else
          ; Если слово слишком длинное и не имеет пробелов — рубим где есть
          MyCanvasText\Lines()\TextLine = PeekS(*lineStart, (*p - *lineStart) / SizeOf(Character))
          *lineStart = *p
        EndIf
      Else
        *p + SizeOf(Character)
      EndIf
    Wend
    
    ; Добавляем остаток
    If *p > *lineStart
      AddElement(MyCanvasText\Lines())
      MyCanvasText\Lines()\TextLine = PeekS(*lineStart)
    EndIf
    
  StopDrawing()
EndProcedure
Procedure UpdateWrap(CanvasGadget, Text$, MaxWidth)
  ClearList(MyCanvasText\Lines())
  MyCanvasText\LastWidth = MaxWidth
  MyCanvasText\LastText = Text$
  
  Protected *p.Character = @Text$        ; Текущий символ
  Protected *lineStart = @Text$          ; Начало текущей строки
  Protected *lastSpace.Character = 0     ; Место последнего пробела
  
  StartDrawing(CanvasOutput(CanvasGadget))
    ; DrawingFont(FontID(#YourFont)) 
    
    While *p\c <> 0
      ; Если нашли пробел — запоминаем его адрес
      If *p\c = ' ' 
        *lastSpace = *p 
      EndIf
      
      ; Замеряем ширину от начала строки до текущего символа
      If TextWidth(PeekS(*lineStart, (*p - *lineStart) / SizeOf(Character) + 1)) > MaxWidth
        
        AddElement(MyCanvasText\Lines())
        
        ; --- ВОТ ТА САМАЯ ЛОГИКА ---
        If *lastSpace > *lineStart
          ; 1. Если был пробел в этой строке — режем по нему (красиво)
          MyCanvasText\Lines()\TextLine = PeekS(*lineStart, (*lastSpace - *lineStart) / SizeOf(Character))
          *lineStart = *lastSpace + SizeOf(Character) ; Новая строка начнется ПОСЛЕ пробела
          *p = *lineStart
          *lastSpace = 0
        Else
          ; 2. Если пробелов НЕТ (одно сверхдлинное слово) — режем прямо по текущему символу
          MyCanvasText\Lines()\TextLine = PeekS(*lineStart, (*p - *lineStart) / SizeOf(Character))
          *lineStart = *p
          ; Здесь пробел не обнуляем, его и так не было
        EndIf
        
      Else
        *p + SizeOf(Character)
      EndIf
    Wend
    
    ; Добавляем остаток текста
    If *p > *lineStart
      AddElement(MyCanvasText\Lines())
      MyCanvasText\Lines()\TextLine = PeekS(*lineStart)
    EndIf
    
  StopDrawing()
EndProcedure

Procedure DrawAll(CanvasGadget, Text$)
  Protected CurrentW = GadgetWidth(CanvasGadget) - 40
  
  ; МАСКА: пересчитываем только если ширина или текст изменились
  If MyCanvasText\LastWidth <> CurrentW Or MyCanvasText\LastText <> Text$
    UpdateWrap(CanvasGadget, Text$, CurrentW)
  EndIf
  
  StartDrawing(CanvasOutput(CanvasGadget))
    Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF)
    DrawingMode(#PB_2DDrawing_Transparent)
    FrontColor($202020)
    
    Protected Y = 20
    ForEach MyCanvasText\Lines()
      DrawText(20, Y, MyCanvasText\Lines()\TextLine)
      Y + TextHeight("A") + 4
    Next
  StopDrawing()
EndProcedure

; --- Запуск ---
If OpenWindow(0, 0, 0, 400, 300, "Crossplatform Wrap", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 400, 300)
  Txt$ = "Этот метод никогда не вернет -1, потому что он не лезет в системные потроха DrawingBuffer, а использует стабильные функции PureBasic. Работает на Windows, Mac и Linux одинаково быстро!"
  
  DrawAll(0, Txt$)

  Repeat
    Event = WaitWindowEvent()
    If Event = #PB_Event_SizeWindow
      ResizeGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
      DrawAll(0, Txt$)
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 105
; FirstLine = 37
; Folding = 8--
; EnableXP
; DPIAware
