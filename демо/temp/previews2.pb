EnableExplicit

; =============================================================================
; 1. УЛЬТИМАТИВНЫЕ СТРУКТУРЫ
; =============================================================================

Structure ControlParams
  ID.i
  X.i
  Y.i
  W.i
  H.i
  Text$
  
  ; Единое фиксированное поле флага для абсолютно всех гаджетов
  Flag.i 
  
  ; --- ОБЪЕДИНЕНИЕ ДЛЯ ПЕРВОГО УНИКАЛЬНОГО ПАРАМЕТРА (P1) ---
  StructureUnion
    P1.i
    ScrollWidth.i   ; ScrollAreaGadget (Ширина внутренней области)
    ImageId.i       ; ButtonImageGadget, ImageGadget (ID картинки)
    Min.i           ; TrackBar, ProgressBar, Spin, ScrollBar (Минимум)
    State.i         ; CheckBox, Option (Начальное состояние)
    FirstGadget.i   ; SplitterGadget (Первый гаджет)
    LinkColor.i     ; HyperLinkGadget (Цвет ссылки)
    DateValue.i     ; DateGadget (Числовое значение даты)
  EndStructureUnion
  
  ; --- ОБЪЕДИНЕНИЕ ДЛЯ ВТОРОГО УНИКАЛЬНОГО ПАРАМЕТРА (P2) ---
  StructureUnion
    P2.i
    ScrollHeight.i  ; ScrollAreaGadget (Высота внутренней области)
    Max.i           ; TrackBar, ProgressBar, Spin, ScrollBar (Максимум)
    ParentId.i      ; OpenWindow (ID родительского окна)
    ColumnWidth.i   ; ListIconGadget (Ширина первой колонки)
    SecondGadget.i  ; SplitterGadget (Второй гаджет)
  EndStructureUnion
  
  ; --- ОБЪЕДИНЕНИЕ ДЛЯ ТРЕТЬЕГО УНИКАЛЬНОГО ПАРАМЕТРА (P3) ---
  StructureUnion
    P3.i
    ScrollStep.i    ; ScrollAreaGadget (Шаг прокрутки)
    PageLength.i    ; ScrollBarGadget (Размер ползунка)
  EndStructureUnion
EndStructure

Structure FunctionParams
  ID.i
  Value.i   ; Позиция / состояние / индекс
  Text$     ; Строковый контент (например, имя вкладки)
  Param1.i  ; Дополнительные флаги/числа
  Param2.i
EndStructure

; =============================================================================
; 2. ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И УМНЫЙ ВЫЧИСЛИТЕЛЬ
; =============================================================================

Procedure.s CleanArg(Value$)
  Value$ = Trim(Value$)
  Value$ = RemoveString(Value$, Chr(34))
  ProcedureReturn Value$
EndProcedure

Procedure.i EvaluateArg(Value$)
  Value$ = Trim(Value$)
  Value$ = RemoveString(Value$, Chr(34))
  Protected LowVal$ = LCase(Value$)
  
  ; Обработка системных констант PureBasic
  If Left(LowVal$, 4) = "#pb_"
    Select LowVal$
      Case "#pb_gadget_frontcolor"     : ProcedureReturn #PB_Gadget_FrontColor
      Case "#pb_gadget_backcolor"      : ProcedureReturn #PB_Gadget_BackColor
      Case "#pb_gadget_linecolor"      : ProcedureReturn #PB_Gadget_LineColor
      Case "#pb_window_systemmenu"     : ProcedureReturn #PB_Window_SystemMenu
      Case "#pb_window_screencentered" : ProcedureReturn #PB_Window_ScreenCentered
      Case "#pb_splitter_vertical"     : ProcedureReturn #PB_Splitter_Vertical
      Case "#pb_splitter_horizontal"   : ProcedureReturn #PB_Splitter_Horizontal
    EndSelect
  EndIf
  
  ; Обработка функций цвета RGB / RGBA
  Protected BracketPos = FindString(LowVal$, "(")
  If BracketPos
    Protected Func$ = Trim(Left(LowVal$, BracketPos - 1))
    Protected Args$ = Mid(Value$, BracketPos + 1)
    If Right(Args$, 1) = ")" : Args$ = Left(Args$, Len(Args$) - 1) : EndIf
    
    Select Func$
      Case "rgb"
        ProcedureReturn RGB(Val(Trim(StringField(Args$, 1, ","))), Val(Trim(StringField(Args$, 2, ","))), Val(Trim(StringField(Args$, 3, ","))))
      Case "rgba"
        ProcedureReturn RGBA(Val(Trim(StringField(Args$, 1, ","))), Val(Trim(StringField(Args$, 2, ","))), Val(Trim(StringField(Args$, 3, ","))), Val(Trim(StringField(Args$, 4, ","))))
    EndSelect
  EndIf
  
  ; Сборка битовых флагов через черту "|"
  If FindString(Value$, "|")
    Protected i, Sum = 0, PartsCount = CountString(Value$, "|") + 1
    For i = 1 To PartsCount
      Sum | EvaluateArg(StringField(Value$, i, "|"))
    Next i
    ProcedureReturn Sum
  EndIf
  
  ProcedureReturn Val(Value$)
EndProcedure

; =============================================================================
; 3. ПРОЦЕДУРЫ КОРРЕКТНОГО ПАРСИНГА ПАРАМЕТРОВ
; =============================================================================

Procedure ParseControlParams(Cmd$, Args$, *Result.ControlParams)
  Protected Tail$, CleanTail$, LastQuote, Pos, i
  Protected.s arg1, arg2, arg3, arg4, arg5
  Protected Dim P.i(4)
  
  arg1 = StringField(Args$, 1, ",")
  arg2 = StringField(Args$, 2, ",")
  arg3 = StringField(Args$, 3, ",")
  arg4 = StringField(Args$, 4, ",")
  arg5 = StringField(Args$, 5, ",")
  
  *Result\Id = EvaluateArg(arg1)
  *Result\X  = EvaluateArg(arg2)
  *Result\Y  = EvaluateArg(arg3)
  *Result\W  = EvaluateArg(arg4)
  *Result\H  = EvaluateArg(arg5)
  
  *Result\Text$ = "" : *Result\Flag = 0
  *Result\P1 = 0 : *Result\P2 = 0 : *Result\P3 = 0
  
  If CountString(Args$, ",") > 4
    Protected HeadLen = Len(arg1 + "," + arg2 + "," + arg3 + "," + arg4 + "," + arg5)
    Pos = FindString(Args$, ",", HeadLen + 1)
    
    If Pos > 0
      Tail$ = Trim(Mid(Args$, Pos + 1))
      
      If Left(Tail$, 1) = Chr(34)
        LastQuote = FindString(Tail$, Chr(34), 2)
        If LastQuote
          *Result\Text$ = Mid(Tail$, 2, LastQuote - 2)
          CleanTail$ = Trim(Mid(Tail$, LastQuote + 1))
          If Left(CleanTail$, 1) = "," : CleanTail$ = Mid(CleanTail$, 2) : EndIf
          
          For i = 1 To 4
            P(i) = EvaluateArg(StringField(CleanTail$, i, ","))
          Next
        EndIf
      Else
        For i = 1 To 4
          P(i) = EvaluateArg(StringField(Tail$, i, ","))
        Next
      EndIf
    EndIf
  EndIf
  
  Select Cmd$
    Case "openwindow"
      *Result\Flag     = P(1)
      *Result\ParentId = P(2)
      
    Case "buttongadget", "stringgadget", "textgadget", "checkboxgadget", 
         "optiongadget", "webgadget"
      *Result\Flag     = P(1)
      
    Case "hyperlinkgadget"
      *Result\LinkColor = P(1)
      *Result\Flag      = P(2)
      
    Case "dategadget"
      *Result\DateValue = P(1)
      *Result\Flag      = P(2)
      
    Case "listicongadget"
      *Result\ColumnWidth = P(1)
      *Result\Flag        = P(2)
      
    Case "panelgadget", "containergadget", "mdigadget", "comboboxgadget", 
         "listgadget", "listviewgadget", "treegadget", "calendargadget", 
         "editorgadget", "explorerlistgadget", "explorertreegadget", "ipaddressgadget"
      *Result\Flag     = P(1)
      
    Case "buttonimagegadget", "imagegadget"
      *Result\ImageId  = P(1)
      *Result\Flag     = P(2)
      
    Case "trackbargadget", "progressbargadget", "spingadget"
      *Result\Min      = P(1)
      *Result\Max      = P(2)
      *Result\Flag     = P(3)
      
    Case "splittergadget"
      *Result\FirstGadget  = P(1)
      *Result\SecondGadget = P(2)
      *Result\Flag         = P(3)
      
    Case "scrollareagadget"
      *Result\ScrollWidth  = P(1)
      *Result\ScrollHeight = P(2)
      *Result\ScrollStep   = P(3)
      *Result\Flag         = P(4)
      
    Case "scrollbargadget"
      *Result\Min          = P(1)
      *Result\Max          = P(2)
      *Result\PageLength   = P(3)
      *Result\Flag         = P(4)
  EndSelect
EndProcedure

Procedure ParseFunctionParams(Args$, *Result.FunctionParams)
  Protected FirstQ, LastQ, Tail$
  
  *Result\Id = 0 : *Result\Value = 0 : *Result\Text$ = "" : *Result\Param1 = 0 : *Result\Param2 = 0
  
  *Result\Id    = EvaluateArg(StringField(Args$, 1, ","))
  *Result\Value = EvaluateArg(StringField(Args$, 2, ","))
  
  FirstQ = FindString(Args$, Chr(34))
  LastQ  = FindString(Args$, Chr(34), FirstQ + 1)
  
  If FirstQ And LastQ
    *Result\Text$ = Mid(Args$, FirstQ + 1, LastQ - FirstQ - 1)
    Tail$ = Trim(Mid(Args$, LastQ + 1))
    If Left(Tail$, 1) = "," : Tail$ = Mid(Tail$, 2) : EndIf
    *Result\Param1 = EvaluateArg(StringField(Tail$, 1, ","))
    *Result\Param2 = EvaluateArg(StringField(Tail$, 2, ","))
  Else
    *Result\Param1 = EvaluateArg(StringField(Args$, 3, ","))
    *Result\Param2 = EvaluateArg(StringField(Args$, 4, ","))
  EndIf
EndProcedure

; =============================================================================
; 4. ГЛАВНЫЙ ИНТЕРПРЕТАТОР И ОТРЕНДЕРИВАНИЕ ИНТЕРФЕЙСА ПРЕВЬЮ
; =============================================================================

Procedure.i ExecuteGuiPreview(Code$)
  Protected Count, i, Line$, Cmd$, Args$
  Protected PreviewWindowID = 0
  Protected G.ControlParams
  Protected F.FunctionParams
      
  Code$ = ReplaceString(Code$, #CRLF$, #LF$)
  Count = CountString(Code$, #LF$) + 1
  
  ; Сохраняем текущее состояние создания гаджетов IDE
  Protected OldGadgetList = UseGadgetList(0)
  
  For i = 1 To Count
    Line$ = Trim(StringField(Code$, i, #LF$))
    If Line$ = "" Or Left(Line$, 1) = ";" : Continue : EndIf
    
    Protected LowLine$ = LCase(Line$)
    If Left(LowLine$, 2) = "if" : Line$ = Trim(Mid(Line$, 3)) : EndIf
    If Left(LowLine$, 5) = "endif" Or Left(LowLine$, 6) = "repeat" Or Left(LowLine$, 5) = "until" : Continue : EndIf
    
    Protected BracketPos = FindString(Line$, "(")
    If BracketPos
      Cmd$ = LCase(Trim(Left(Line$, BracketPos - 1)))
      Args$ = Mid(Line$, BracketPos + 1)
      
      If Right(Args$, 1) = ")" : Args$ = Left(Args$, Len(Args$) - 1) : EndIf
      If FindString(Args$, ")") : Args$ = StringField(Args$, 1, ")") : EndIf
      
      ; --- ТАКТИЧЕСКИЙ ВЫЗОВ НУЖНОГО ПАРСЕРА ЧЕРЕЗ МУЛЬТИ-СЕЛЕКТ ---
      Select Cmd$
         Case "openwindow", "buttongadget", "stringgadget", "textgadget", "checkboxgadget", 
              "optiongadget", "hyperlinkgadget", "webgadget", "listicongadget", "comboboxgadget", 
              "listgadget", "listviewgadget", "treegadget", "panelgadget", "containergadget", 
              "scrollareagadget", "splittergadget", "trackbargadget", "progressbargadget", 
              "spingadget", "scrollbargadget", "imagegadget", "buttonimagegadget", 
              "calendargadget", "dategadget", "editorgadget", "ipaddressgadget", 
              "explorerlistgadget", "explorertreegadget"
              
            ParseControlParams(Cmd$, Args$, @G)
            
         Case "addgadgetitem", "setgadgettext", "setgadgetstate", "setgadgetcolor", "setgadgetfont"
            ParseFunctionParams(Args$, @F)
      EndSelect
      
      ; --- ОТРИСОВКА ИНТЕРФЕЙСА ПРЕВЬЮ ---
      If Cmd$ = "openwindow"
        If G\W = 0 : G\W = 320 : EndIf
        If G\H = 0 : G\H = 240 : EndIf
        If G\Text$ = "" : G\Text$ = "Превью" : EndIf
        If G\Flag = 0 : G\Flag = #PB_Window_SystemMenu | #PB_Window_ScreenCentered : EndIf
        
        PreviewWindowID = OpenWindow(#PB_Any, G\X, G\Y, G\W, G\H, G\Text$, G\Flag, G\ParentId)
      Else
        If PreviewWindowID
          UseGadgetList(WindowID(PreviewWindowID))
          
          Select Cmd$
            Case "buttongadget"       : ButtonGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\Flag)
            Case "stringgadget"       : StringGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\Flag)
            Case "textgadget"         : TextGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\Flag)
            Case "checkboxgadget"     : CheckBoxGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\Flag)
            Case "optiongadget"       : OptionGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\Flag)
            Case "webgadget"          : WebGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "hyperlinkgadget"    : HyperLinkGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\LinkColor, G\Flag)
            Case "dategadget"         : DateGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\DateValue, G\Flag)
            
            Case "listicongadget"     : ListIconGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\ColumnWidth, G\Flag)
            Case "comboboxgadget"     : ComboBoxGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag)
            Case "listgadget", "listviewgadget" : ListViewGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag)
            Case "treegadget"         : TreeGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag)
            
            Case "panelgadget"        : PanelGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag)
            Case "containergadget"    : ContainerGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag)
            Case "scrollareagadget"   : ScrollAreaGadget(G\Id, G\X, G\Y, G\W, G\H, G\ScrollWidth, G\ScrollHeight, G\ScrollStep, G\Flag)
            Case "splittergadget"     : SplitterGadget(G\Id, G\X, G\Y, G\W, G\H, G\FirstGadget, G\SecondGadget, G\Flag)
            
            Case "trackbargadget"     : TrackBarGadget(G\Id, G\X, G\Y, G\W, G\H, G\Min, G\Max, G\Flag)
            Case "progressbargadget"  : ProgressBarGadget(G\Id, G\X, G\Y, G\W, G\H, G\Min, G\Max, G\Flag)
            Case "spingadget"         : SpinGadget(G\Id, G\X, G\Y, G\W, G\H, G\Min, G\Max, G\Flag)
            Case "scrollbargadget"    : ScrollBarGadget(G\Id, G\X, G\Y, G\W, G\H, G\Min, G\Max, G\PageLength, G\Flag)
            
            Case "imagegadget"        : ImageGadget(G\Id, G\X, G\Y, G\W, G\H, G\ImageId, G\Flag)
            Case "buttonimagegadget"  : ButtonImageGadget(G\Id, G\X, G\Y, G\W, G\H, G\ImageId, G\Flag)
            
            Case "calendargadget"     : CalendarGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag)
            Case "editorgadget"       : EditorGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag)
            Case "ipaddressgadget"    : IPAddressGadget(G\Id, G\X, G\Y, G\W, G\H)
            Case "explorerlistgadget" : ExplorerListGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\Flag)
            Case "explorertreegadget" : ExplorerTreeGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$, G\Flag)
              
            ; Команды манипуляции элементами (используют структуру F)
            Case "addgadgetitem"   : AddGadgetItem(F\Id, F\Value, F\Text$)
            Case "setgadgettext"   : SetGadgetText(F\Id, F\Text$)
            Case "setgadgetstate"  : SetGadgetState(F\Id, F\Value)
            Case "setgadgetcolor"  : SetGadgetColor(F\Id, F\Value, F\Param1)
            Case "setgadgetfont"   : SetGadgetFont(F\Id, F\Value)
              
            Case "closegadgetlist" : CloseGadgetList()
          EndSelect
        EndIf
      EndIf
    EndIf
  Next i
  
  ; Возвращаем контекст создания гаджетов обратно в IDE
  If OldGadgetList : UseGadgetList(OldGadgetList) : EndIf
  
  ; Если окно успешно создано, делаем его активным поверх IDE
  If PreviewWindowID : SetActiveWindow(PreviewWindowID) : EndIf
  
  ProcedureReturn PreviewWindowID
EndProcedure
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 48
; FirstLine = 43
; Folding = -------
; EnableXP
; DPIAware