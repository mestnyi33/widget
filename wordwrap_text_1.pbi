; Структура для хранения закэшированного текста
Structure WrappedText
  List Lines.s()
  MaxW.i
  LastText.s
EndStructure

Global MyWrapped.WrappedText

; Процедура подготовки строк (вызываем только при ресайзе или смене текста)
Procedure RefreshWordWrap(CanvasGadget, Text$, MaxWidth)
  ClearList(MyWrapped\Lines())
  MyWrapped\MaxW = MaxWidth
  MyWrapped\LastText = Text$
  
  Protected WordCount = CountString(Text$, " ") + 1
  Protected i, Word$, CurrentLine$, TestLine$
  
  StartDrawing(CanvasOutput(CanvasGadget))
    ; DrawingFont(FontID(#YourFont)) ; Установите ваш шрифт здесь
    
    For i = 1 To WordCount
      Word$ = StringField(Text$, i, " ")
      TestLine$ = CurrentLine$ + Word$ + " "
      
      If TextWidth(Trim(TestLine$)) > MaxWidth And CurrentLine$ <> ""
        AddElement(MyWrapped\Lines())
        MyWrapped\Lines() = Trim(CurrentLine$)
        CurrentLine$ = Word$ + " "
      Else
        CurrentLine$ = TestLine$
      EndIf
    Next i
    
    If CurrentLine$ <> ""
      AddElement(MyWrapped\Lines())
      MyWrapped\Lines() = Trim(CurrentLine$)
    EndIf
  StopDrawing()
EndProcedure

; Процедура быстрой отрисовки
Procedure RedrawCanvas(CanvasGadget)
  StartDrawing(CanvasOutput(CanvasGadget))
    Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF) ; Чистим фон
    
    DrawingMode(#PB_2DDrawing_Transparent)
    FrontColor($000000)
    
    Protected Y = 20
    ForEach MyWrapped\Lines()
      DrawText(20, Y, MyWrapped\Lines())
      Y + 25 ; Фиксированный шаг строки
    Next
  StopDrawing()
EndProcedure

; --- Основной код ---
If OpenWindow(0, 0, 0, 400, 300, "Cached Wrap", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 400, 300)
  
  Define Txt$ = "Это текст, который кэшируется в список. Перерасчет идет только тогда, когда вы меняете размер окна."
  
  ; Первичная подготовка
  RefreshWordWrap(0, Txt$, WindowWidth(0) - 40)
  RedrawCanvas(0)

  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
        
      Case #PB_Event_SizeWindow ; Событие изменения размера
        ResizeGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
        ; Пересобираем кэш только здесь!
        RefreshWordWrap(0, Txt$, WindowWidth(0) - 40)
        RedrawCanvas(0)
        
      Case #PB_Event_Gadget
        If EventGadget() = 0 And EventType() = #PB_EventType_MouseEnter
          ; Пример: отрисовка при наведении (без пересчета вордврапа)
          RedrawCanvas(0)
        EndIf
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 71
; FirstLine = 54
; Folding = --
; EnableXP
; DPIAware