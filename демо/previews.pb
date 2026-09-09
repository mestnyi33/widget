EnableExplicit

; --- СТРУКТУРЫ ---

; Для окон и гаджетов (с геометрией)
Structure ControlParams
  ID.i
  X.i
  Y.i
  W.i
  H.i
  Text$
  Flag.i
  Param1.i
  Param2.i
  Param3.i
EndStructure

; Для сервисных функций и команд управления
Structure FunctionParams
  ID.i
  Value.i
  Text$
  Param1.i
  Param2.i
EndStructure


; --- ПРОЦЕДУРЫ ПАРСИНГА ---

; Очистка строк (остается без изменений)
Procedure.s CleanArg(Value$)
  Value$ = Trim(Value$)
  Value$ = RemoveString(Value$, Chr(34))
  ProcedureReturn Value$
EndProcedure

; Умный вычислитель аргументов. Понимает числа, константы и функции RGB/RGBA
Procedure.i EvaluateArg(Value$)
  Value$ = Trim(Value$)
  Value$ = RemoveString(Value$, Chr(34)) ; Убираем кавычки, если они проскочили
  Protected LowVal$ = LCase(Value$)
  
  ; 1. ОБРАБОТКА СИСТЕМНЫХ КОНСТАНТ PUREBASIC
  If Left(LowVal$, 4) = "#pb_"
    Select LowVal$
      ; Константы типов цвета гаджетов
      Case "#pb_gadget_frontcolor" : ProcedureReturn 0
      Case "#pb_gadget_backcolor"  : ProcedureReturn 1
      Case "#pb_gadget_linecolor"  : ProcedureReturn 2
        
      ; Константы флагов окон (для примера, можно расширять)
      Case "#pb_window_systemmenu"     : ProcedureReturn #PB_Window_SystemMenu
      Case "#pb_window_screencentered" : ProcedureReturn #PB_Window_ScreenCentered
        
      ; Константы позиций для AddGadgetItem
      Case "#pb_any" : ProcedureReturn #PB_Any
    EndSelect
  EndIf
  
  ; 2. ОБРАБОТКА ДИНАМИЧЕСКИХ ФУНКЦИЙ ЦВЕТА
  Protected BracketPos = FindString(LowVal$, "(")
  If BracketPos
    Protected Func$ = Trim(Left(LowVal$, BracketPos - 1))
    Protected Args$ = Mid(Value$, BracketPos + 1)
    If Right(Args$, 1) = ")" : Args$ = Left(Args$, Len(Args$) - 1) : EndIf
    
    Select Func$
      Case "rgb"
        Protected R = Val(Trim(StringField(Args$, 1, ",")))
        Protected G = Val(Trim(StringField(Args$, 2, ",")))
        Protected B = Val(Trim(StringField(Args$, 3, ",")))
        ProcedureReturn RGB(R, G, B)
        
      Case "rgba"
        Protected R2 = Val(Trim(StringField(Args$, 1, ",")))
        Protected G2 = Val(Trim(StringField(Args$, 2, ",")))
        Protected B2 = Val(Trim(StringField(Args$, 3, ",")))
        Protected A2 = Val(Trim(StringField(Args$, 4, ",")))
        ProcedureReturn RGBA(R2, G2, B2, A2)
    EndSelect
  EndIf
  
  ; 3. ОБЫЧНОЕ ЧИСЛО (или битовые маски, если они склеены как строки)
  ; Если в строке остался разделитель "|" от констант, считаем их сумму
  If FindString(Value$, "|")
    Protected i, Sum = 0, PartsCount = CountString(Value$, "|") + 1
    For i = 1 To PartsCount
      Sum | EvaluateArg(StringField(Value$, i, "|"))
    Next i
    ProcedureReturn Sum
  EndIf
  
  ProcedureReturn Val(Value$)
EndProcedure
; Парсер №1: Для элементов управления (Ваш оптимизированный вариант)
Procedure ParseControlParams(Args$, *Result.ControlParams)
  Protected Tail$, CleanTail$, LastQuote, Pos
  Protected.s arg1, arg2, arg3, arg4, arg5
  
  arg1 = StringField(Args$, 1, ",")
  arg2 = StringField(Args$, 2, ",")
  arg3 = StringField(Args$, 3, ",")
  arg4 = StringField(Args$, 4, ",")
  arg5 = StringField(Args$, 5, ",")
  
  *Result\Id = Val(CleanArg(arg1))
  *Result\X  = Val(CleanArg(arg2))
  *Result\Y  = Val(CleanArg(arg3))
  *Result\W  = Val(CleanArg(arg4))
  *Result\H  = Val(CleanArg(arg5))
  
  *Result\Text$  = "" : *Result\Flag = 0 : *Result\Param1 = 0 : *Result\Param2 = 0 : *Result\Param3 = 0
  
  If CountString(Args$, ",") > 4
    Protected HeadLen = Len(arg1+","+arg2+","+arg3+","+arg4+","+arg5)
    Pos = FindString(Args$, ",", HeadLen + 1)
    
    If Pos > 0
      Tail$ = Trim(Mid(Args$, Pos + 1))
      
      If Left(Tail$, 1) = Chr(34)
        LastQuote = FindString(Tail$, Chr(34), 2)
        If LastQuote
          *Result\Text$ = Mid(Tail$, 2, LastQuote - 2)
          CleanTail$ = Trim(Mid(Tail$, LastQuote + 1))
          If Left(CleanTail$, 1) = "," : CleanTail$ = Mid(CleanTail$, 2) : EndIf
          
          *Result\Flag   = Val(CleanArg(StringField(CleanTail$, 1, ",")))
          *Result\Param1 = Val(CleanArg(StringField(CleanTail$, 2, ",")))
          *Result\Param2 = Val(CleanArg(StringField(CleanTail$, 3, ",")))
          *Result\Param3 = Val(CleanArg(StringField(CleanTail$, 4, ",")))
        EndIf
      Else
        *Result\Flag   = Val(CleanArg(StringField(Tail$, 1, ",")))
        *Result\Param1 = Val(CleanArg(StringField(Tail$, 2, ",")))
        *Result\Param2 = Val(CleanArg(StringField(Tail$, 3, ",")))
        *Result\Param3 = Val(CleanArg(StringField(Tail$, 4, ",")))
      EndIf
    EndIf
  EndIf
EndProcedure

; Парсер №2: Универсальный разбор для функций (AddGadgetItem, SetGadgetText и т.д.)
Procedure ParseFunctionParams(Args$, *Result.FunctionParams)
  Protected FirstQ, LastQ
  
  ; По умолчанию обнуляем структуру
  *Result\Id = 0 : *Result\Value = 0 : *Result\Text$ = "" : *Result\Param1 = 0 : *Result\Param2 = 0
  
  ; Первые два параметра у функций почти всегда числа (ID гаджета, позиция/состояние)
  *Result\Id    = Val(CleanArg(StringField(Args$, 1, ",")))
  *Result\Value = Val(CleanArg(StringField(Args$, 2, ",")))
  
  ; Безопасно вытаскиваем текст из кавычек, если он вообще есть в аргументах
  FirstQ = FindString(Args$, Chr(34))
  LastQ  = FindString(Args$, Chr(34), FirstQ + 1)
  If FirstQ And LastQ
    *Result\Text$ = Mid(Args$, FirstQ + 1, LastQ - FirstQ - 1)
    
    ; Если после кавычек есть еще параметры через запятую
    Protected Tail$ = Trim(Mid(Args$, LastQ + 1))
    If Left(Tail$, 1) = "," : Tail$ = Mid(Tail$, 2) : EndIf
    *Result\Param1 = Val(CleanArg(StringField(Tail$, 1, ",")))
    *Result\Param2 = Val(CleanArg(StringField(Tail$, 2, ",")))
  Else
    ; Если кавычек с текстом нет, добираем оставшиеся параметры как числа
    *Result\Param1 = Val(CleanArg(StringField(Args$, 3, ",")))
    *Result\Param2 = Val(CleanArg(StringField(Args$, 4, ",")))
  EndIf
EndProcedure


; Функция визуализации превью (возвращает внутренний ID созданного окна)
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
      
      ; --- ТЕПЕРЬ ПАРСИМ ВСЁ ЧЕРЕЗ ОДНУ ФУНКЦИЮ ---
      Select Cmd$
         ; Группа А: Визуальные контролы с геометрией
         Case "openwindow",
              "buttongadget", 
              "stringgadget",
              "textgadget",
              "panelgadget",
              "scrollareagadget"
            ParseControlParams(Args$, @G)
            
            ; Группа Б: Функции управления и динамического наполнения
         Case "addgadgetitem", 
              "setgadgettext", 
              "setgadgetstate", 
              "setgadgetcolor", 
              "setgadgetfont"
            ParseFunctionParams(Args$, @F)
      EndSelect
      
      If Cmd$ = "openwindow"
        ; Если это окно, применяем защитные значения по умолчанию, если парсер выдал нули
        If G\W = 0 : G\W = 300 : EndIf
        If G\H = 0 : G\H = 150 : EndIf
        If G\Text$ = "" : G\Text$ = "Превью кода" : EndIf
        
        ; Создаем изолированное окно (флаги можно оставить фиксированными)
        PreviewWindowID = OpenWindow(#PB_Any, G\X, G\Y, G\W, G\H, G\Text$, #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
        
      Else
        ; Для всех остальных команд проверяем, что окно превью уже создано
        If PreviewWindowID
          UseGadgetList(WindowID(PreviewWindowID))
          
          Select Cmd$
            Case "buttongadget"     : ButtonGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "stringgadget"     : StringGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "textgadget"       : TextGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "panelgadget"      : PanelGadget(G\Id, G\X, G\Y, G\W, G\H)
            Case "scrollareagadget" : ScrollAreaGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag, G\Param1, G\Param2)
              
            ; Динамическое наполнение
            Case "addgadgetitem"   : AddGadgetItem(F\Id, F\Value, F\Text$)
            Case "setgadgettext"   : SetGadgetText(F\Id, F\Text$)
            Case "setgadgetstate"  : SetGadgetState(F\Id, F\Value)
              
            ; НОВАЯ КОМАНДА: Установка цвета
            ; Синтаксис PB: SetGadgetColor(#Gadget, ColorType, Color)
            ; В нашей структуре: F\Id = #Gadget, F\Value = ColorType, F\Param1 = Color (результат RGB/значение)
            Case "setgadgetcolor"  : SetGadgetColor(F\Id, F\Value, F\Param1)
              
            ; НОВАЯ КОМАНДА: Установка шрифта
            ; Синтаксис PB: SetGadgetFont(#Gadget, FontID)
            ; В нашей структуре: F\Id = #Gadget, F\Value = FontID
            Case "setgadgetfont"   : SetGadgetFont(F\Id, F\Value)
               
            Case "closegadgetlist"
              CloseGadgetList()
              
          EndSelect
        EndIf
      EndIf
      
    EndIf
  Next i
  
  ; Возвращаем контекст создания гаджетов обратно в IDE
  If OldGadgetList : UseGadgetList(OldGadgetList) : EndIf
  
  ; Если окно успешно создано, делаем его активным поверх IDE
  If PreviewWindowID
    SetActiveWindow(PreviewWindowID)
  EndIf
  
  ProcedureReturn PreviewWindowID
EndProcedure
; --- ДЕМОНСТРАЦИЯ ЦИКЛА РАБОТЫ В IDE ---

#MainWindow = 10
#BtnLaunchPreview = 10
#EditorField = 20

; Открываем главное окно вашей IDE
OpenWindow(#MainWindow, 50, 50, 500, 400, "Конструктор интерфейса (IDE)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
EditorGadget(#EditorField, 10, 10, 480, 320)
ButtonGadget(#BtnLaunchPreview, 10, 340, 480, 50, "ПОСМОТРЕТЬ ИНТЕРФЕЙС (ПРАВКА КОДА)")

; Заполняем поле редактора начальным кодом
Define DefaultCode$ = "If OpenWindow(0, 100, 100, 300, 150, " + Chr(34) + "Тестовое Окно" + Chr(34) + ", #PB_Window_SystemMenu)" + #CRLF$ +
                      "  ButtonGadget(1, 20, 30, 260, 35, " + Chr(34) + "Нажми меня" + Chr(34) + ")" + #CRLF$ +
                      "  StringGadget(2, 20, 80, 260, 30, " + Chr(34) + "Текст..." + Chr(34) + ")" + #CRLF$ +
                      "EndIf"
                      
                      ; В этом тесте проверяем сразу: Окно, Кнопку, Панель (5 параметров) и вкладки AddGadgetItem
Define DefaultCode$ = "If OpenWindow(0, 100, 100, 360, 250, " + Chr(34) + "Тест панелей и кнопок" + Chr(34) + ", #PB_Window_SystemMenu)" + #CRLF$ +
                          "  PanelGadget(1, 10, 10, 340, 180)" + #CRLF$ +
                          "    AddGadgetItem(1, -1, " + Chr(34) + "Вкладка 1" + Chr(34) + ")" + #CRLF$ +
                          "      ButtonGadget(2, 20, 30, 150, 40, " + Chr(34) + "Кнопка на табе 1" + Chr(34) + ")" + #CRLF$ +
                          "      StringGadget(3, 20, 90, 200, 30, " + Chr(34) + "Текст..." + Chr(34) + ")" + #CRLF$ +
                          "    AddGadgetItem(1, -1, " + Chr(34) + "Вкладка 2" + Chr(34) + ")" + #CRLF$ +
                          "      TextGadget(4, 20, 30, 200, 20, " + Chr(34) + "Контент второй вкладки" + Chr(34) + ")" + #CRLF$ +
                          "  CloseGadgetList()" + #CRLF$ +
                          "  ButtonGadget(5, 10, 200, 340, 40, " + Chr(34) + "Общая кнопка внизу" + Chr(34) + ")" + #CRLF$ +
                          "EndIf"

SetGadgetText(#EditorField, DefaultCode$)

Define CurrentPreview = 0

; Главный цикл обработки событий IDE
Repeat
  Define Event = WaitWindowEvent()
  Define EventWindow = EventWindow()
  
  Select Event
    Case #PB_Event_Gadget
      ; 1. Проверяем события на главном окне IDE
      If EventWindow = #MainWindow
        If EventGadget() = #BtnLaunchPreview
          
          ; Если пользователь забыл закрыть старое превью — закрываем его принудительно
          If CurrentPreview And IsWindow(CurrentPreview)
            CloseWindow(CurrentPreview)
          EndIf
          
          ; Берем текущий измененный текст из редактора и запускаем превью
          Define UserCode$ = GetGadgetText(#EditorField)
          CurrentPreview = ExecuteGuiPreview(UserCode$)
          
        EndIf
        
      ; 2. Проверяем события внутри окна ПРЕВЬЮ
      ElseIf EventWindow = CurrentPreview
        ; Здесь можно отслеживать интерактивность кнопок из превью, если потребуется
        ; Например: If EventGadget() = 1 : Debug "Нажата кнопка из превью!" : EndIf
      EndIf
      
    Case #PB_Event_CloseWindow
      ; Корректно разделяем закрытие окон
      If EventWindow = #MainWindow
        End ; Закрыли IDE -> Выход из программы
      ElseIf EventWindow = CurrentPreview
        CloseWindow(CurrentPreview) ; Закрыли Превью -> Просто уничтожаем его, IDE живет
        CurrentPreview = 0
      EndIf
      
  EndSelect
ForEver
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 94
; FirstLine = 74
; Folding = -------
; EnableXP
; DPIAware