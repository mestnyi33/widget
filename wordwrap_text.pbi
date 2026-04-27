Structure WrappedText
  List Lines.s()
  LineHeight.i
  LastWidth.i      ; Маска/флаг: старая ширина
  LastText.s       ; Маска/флаг: старое содержимое
EndStructure

Global MyText.WrappedText
MyText\LineHeight = 25 ; Высота строки

; Единая процедура отрисовки с логикой "маски"
Procedure DrawCanvasContent(CanvasGadget, Text$)
  Protected CurrentWidth = GadgetWidth(CanvasGadget) - 40 ; Учитываем отступы
  Protected RebuildNeeded = #False
  
  ; Проверяем "маску": изменилась ли ширина или сам текст?
  If MyText\LastWidth <> CurrentWidth Or MyText\LastText <> Text$
    RebuildNeeded = #True
  EndIf
  
  StartDrawing(CanvasOutput(CanvasGadget))
    Box(0, 0, OutputWidth(), OutputHeight(), $F0F0F0) ; Фон
    DrawingMode(#PB_2DDrawing_Transparent)
    FrontColor($202020)
    
    ; --- ЛОГИКА ОБНОВЛЕНИЯ (WORD WRAP) ---
    If RebuildNeeded
      ClearList(MyText\Lines())
      MyText\LastWidth = CurrentWidth
      MyText\LastText = Text$
      
      Protected WordCount = CountString(Text$, " ") + 1
      Protected i, Word$, CurrentLine$, TestLine$
      
      For i = 1 To WordCount
        Word$ = StringField(Text$, i, " ")
        TestLine$ = CurrentLine$ + Word$ + " "
        
        If TextWidth(Trim(TestLine$)) > CurrentWidth And CurrentLine$ <> ""
          AddElement(MyText\Lines())
          MyText\Lines() = Trim(CurrentLine$)
          CurrentLine$ = Word$ + " "
        Else
          CurrentLine$ = TestLine$
        EndIf
      Next i
      
      If CurrentLine$ <> ""
        AddElement(MyText\Lines())
        MyText\Lines() = Trim(CurrentLine$)
      EndIf
    EndIf
    
    ; --- ЛОГИКА ОТРИСОВКИ ---
    Protected Y = 20
    ForEach MyText\Lines()
      DrawText(20, Y, MyText\Lines())
      Y + MyText\LineHeight
    Next
    
  StopDrawing()
EndProcedure

; --- Основной цикл ---
If OpenWindow(0, 0, 0, 400, 300, "Smart Wrap", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 400, 300)
  WindowBounds(0, 150, 100, #PB_Ignore, #PB_Ignore) ; Ограничим минимум
  
  Txt$ = "Измените размер окна, и вы увидите, как вордврап пересчитывается только при изменении ширины. В остальное время он берет данные из списка структур."

  ; Первый запуск
  DrawCanvasContent(0, Txt$)

  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_SizeWindow
        ; Просто меняем размер гаджета
        ResizeGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
        ; Вызываем отрисовку — она сама поймет, что пора пересчитать вордврап
        DrawCanvasContent(0, Txt$)
        
      Case #PB_Event_Gadget
        If EventGadget() = 0 And EventType() = #PB_EventType_MouseEnter
          ; Здесь вордврап пересчитываться НЕ БУДЕТ, так как ширина та же
          DrawCanvasContent(0, Txt$)
        EndIf
        
      Case #PB_Event_CloseWindow
        Break
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 2
; Folding = --
; EnableXP
; DPIAware