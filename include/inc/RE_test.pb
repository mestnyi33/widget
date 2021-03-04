EnableExplicit


CompilerSelect #PB_Compiler_OS
   CompilerCase #PB_OS_Windows
      Global UserIntLang, *Lang
      If OpenLibrary(0, "kernel32.dll")
         *Lang = GetFunction(0, "GetUserDefaultUILanguage")
         If *Lang
            UserIntLang = CallFunctionFast(*Lang)
         EndIf
         CloseLibrary(0)
      EndIf
   CompilerCase #PB_OS_Linux
      Global UserIntLang$
      If ExamineEnvironmentVariables()
          While NextEnvironmentVariable()
             If Left(EnvironmentVariableName(), 4) = "LANG"
;                 LANG=ru_RU.UTF-8
;                 LANGUAGE=ru
               UserIntLang$ = Left(EnvironmentVariableValue(), 2)
               Break
            EndIf
          Wend
      EndIf
CompilerEndSelect


Global Dim Lng.s(29)
Lng(1) = "There is no text to process"
Lng(2) = "Found"
Lng(3) = "Not found."
Lng(4) = "No groups, enclose groups with parentheses in regular expression"
Lng(5) = "Regular Expression Test"
Lng(6) = "Start"
Lng(7) = "Search"
Lng(8) = "Replacement"
Lng(9) = "Array"
Lng(10) = "Groups"
Lng(11) = "Step by step"
Lng(12) = "Until the first match"
Lng(13) = "Replace all occurrences"
Lng(14) = "All full occurrences"
Lng(15) = "What's in brackets"
Lng(16) = "More position and length"
Lng(17) = "(?s) dot everything"
Lng(18) = "(?x) ignore spaces and comments."
Lng(19) = "(?m) multiline text (^ ... $)"
Lng(20) = "Any of CR, LF, and CRLF"
Lng(21) = "(?i) ignore case"
Lng(22) = "The point also includes LF"
Lng(23) = "Line splitting can be any of these symbols"
Lng(24) = "Regular Expressions for Search"
Lng(25) = "Replacement text"
Lng(26) = "Text to be processed and result"
Lng(27) = "With markup"
Lng(28) = "Marks start, useful for multi-line"
Lng(29) = "Reference"


CompilerSelect #PB_Compiler_OS
   CompilerCase #PB_OS_Windows
      If UserIntLang = 1049
    CompilerCase #PB_OS_Linux
      If UserIntLang$ = "ru"
CompilerEndSelect
   Lng(1) = "Отсутствует текст для обработки"
   Lng(2) = "Найдено"
   Lng(3) = "Не найдено."
   Lng(4) = "Нет групп, выделите группы скобками в регулярном выражении"
   Lng(5) = "Тест регулярных выражений"
   Lng(6) = "Старт"
   Lng(7) = "Поиск"
   Lng(8) = "Замена"
   Lng(9) = "Массив"
   Lng(10) = "Группы"
   Lng(11) = "Пошаговый"
   Lng(12) = "До первого совпадения"
   Lng(13) = "Замена всех вхождений"
   Lng(14) = "Все полные вхождения"
   Lng(15) = "То что в скобках"
   Lng(16) = "Ещё позиция и длина"
   Lng(17) = "(?s) точка всё"
   Lng(18) = "(?x) игнор пробелов и коммент."
   Lng(19) = "(?m) многостроч. текст (^...$)"
   Lng(20) = "Любой из CR, LF, и CRLF"
   Lng(21) = "(?i) не учитывать регистр"
   Lng(22) = "Точка включает в себя ещё и LF"
   Lng(23) = "Разделение строк может быть любым из этих сиволов"
   Lng(24) = "Регулярное выражения для поиска"
   Lng(25) = "Текст замены"
   Lng(26) = "Текст для обработки и результат"
   Lng(27) = "С разметкой"
   Lng(28) = "Помечает начало, полезно для многострочных"
   Lng(29) = "Справка"
;EndIf


EnableExplicit

Global Error_Procedure = 0
Define eMenu, FlagsRE, Label, sResult$

Global TextLength
#SCFIND_CXX11REGEX = $00800000

Declare SciNotification(Gadget, *scinotify.SCNotification)
Declare MakeUTF8Text(text.s)
Declare Color2(*regex, regexLength, n)
Declare.s GetScintillaGadgetText(ID)


Procedure.s ExtractRE(sRE1$, sED3$, FlagsRE, Label)
   Protected sResult$, NbFound, i, Gsub$ = Chr($25AC)
   If sED3$ = ""
      Error_Procedure = 1
      ProcedureReturn Lng(1)
   EndIf
   If CreateRegularExpression(0, sRE1$, FlagsRE)
      Protected Dim asResult$(0)
      NbFound = ExtractRegularExpression(0, sED3$, asResult$())
      For i = 0 To NbFound-1
         If Label
            sResult$ + Gsub$ + " " + Str(i) + " " + asResult$(i) + #CRLF$
         Else
            sResult$ + asResult$(i) + #CRLF$
         EndIf
      Next
   Else
      Error_Procedure = 1
      ProcedureReturn RegularExpressionError()
   EndIf
   ProcedureReturn sResult$
EndProcedure

Procedure.s SearchRE(sRE1$, sED3$, FlagsRE)
   Protected sResult$
   If sED3$ = ""
      Error_Procedure = 1
      ProcedureReturn Lng(1)
   EndIf
   If CreateRegularExpression(0, sRE1$, FlagsRE)
      If MatchRegularExpression(0, sED3$)
         sResult$ = Lng(2)
      Else
         sResult$ = Lng(3)
      EndIf
   Else
      Error_Procedure = 1
      ProcedureReturn RegularExpressionError()
   EndIf
   ProcedureReturn sResult$
EndProcedure

Procedure.s StepRE(sRE1$, sED3$, FlagsRE, Label)
   Protected sResult$, Gsub$ = Chr($25AC), i
   If sED3$ = ""
      Error_Procedure = 1
      ProcedureReturn Lng(1)
   EndIf
   If CreateRegularExpression(0, sRE1$, FlagsRE)
      If ExamineRegularExpression(0, sED3$)
         While NextRegularExpressionMatch(0)
            If Label
               i+1
               sResult$ + Gsub$ + " " + Str(i) + " " + Gsub$ + " " + Str(RegularExpressionMatchPosition(0)) + " : " + Str(RegularExpressionMatchLength(0)) + " : " + RegularExpressionMatchString(0) + #CRLF$
            Else
               sResult$ + Str(RegularExpressionMatchPosition(0)) + " : " + Str(RegularExpressionMatchLength(0)) + " : " + RegularExpressionMatchString(0) + #CRLF$
            EndIf
         Wend
      EndIf
   Else
      Error_Procedure = 1
      ProcedureReturn RegularExpressionError()
   EndIf
   ;    SetClipboardText(sResult$)
   ProcedureReturn sResult$
EndProcedure

Procedure.s GroupsRE(sRE1$, sED3$, FlagsRE, Label)
   Protected sResult$, Groups, i, d, Groot$, Gsub$ = Chr($25AC)
   If sED3$ = ""
      Error_Procedure = 1
      ProcedureReturn Lng(1)
   EndIf
   If CreateRegularExpression(0, sRE1$, FlagsRE)
      Groups = CountRegularExpressionGroups(0)
      If Not Groups
         Error_Procedure = 1
         ProcedureReturn Lng(4)
      EndIf
      Groot$ = LSet("" , 10, Gsub$)
      If ExamineRegularExpression(0, sED3$)
         While NextRegularExpressionMatch(0)
            If Label
               d+1
               sResult$ + Str(d) + " " + Groot$ + #CRLF$
            EndIf
            For i = 1 To Groups
               If Label
                  sResult$ + Gsub$ + Gsub$ + " " + Str(i) + " " + Gsub$ + " " + RegularExpressionGroup(0, i) + #CRLF$
               Else
                  sResult$ + RegularExpressionGroup(0, i) + #CRLF$
               EndIf
            Next
         Wend
      EndIf
   Else
      Error_Procedure = 1
      ProcedureReturn RegularExpressionError()
   EndIf
   ProcedureReturn sResult$
EndProcedure

Procedure.s ReplaceRE(sRE1$, sED3$, sRP2$, FlagsRE)
   If sED3$ = ""
      Error_Procedure = 1
      ProcedureReturn Lng(1)
   EndIf
   If CreateRegularExpression(0, sRE1$, FlagsRE)
      ProcedureReturn ReplaceRegularExpression(0, sED3$, sRP2$)
   Else
      Error_Procedure = 1
      ProcedureReturn RegularExpressionError()
   EndIf
EndProcedure


Enumeration 0
   #SciGadget
EndEnumeration

If OpenWindow(0, 0, 0, 930, 508, Lng(5), #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget)
   ;    StringGadget(1 , 10, 22, 590, 22 , "")
   
   ScintillaGadget(#SciGadget, 10, 22, 590, 24, @SciNotification())
   ; Устанавливает режим текста
   ScintillaSendMessage(#SciGadget, #SCI_SETWRAPMODE, #SC_WRAP_NONE) ; без переносов строк
   ScintillaSendMessage(#SciGadget, #SCI_SETCODEPAGE, #SC_CP_UTF8)     ; в кодировке UTF-8
   ScintillaSendMessage(#SciGadget, #SCI_SETCARETSTICKY, 1)        ; делает всегда видимым (?)
   ScintillaSendMessage(#SciGadget, #SCI_SETCARETWIDTH, 1)           ; толщина текстовго курсора
   ScintillaSendMessage(#SciGadget, #SCI_SETCARETFORE, RGB(255, 255, 255))     ; цвет текстовго курсора
   ScintillaSendMessage(#SciGadget, #SCI_SETSELALPHA, 100)                 ; прозрачность выделения
   ScintillaSendMessage(#SciGadget, #SCI_SETSELBACK, 1, RGB(255, 255, 255))  ; цвет фона выделения
   ScintillaSendMessage(#SciGadget, #SCI_SETSELFORE, 1, RGB(160, 160, 160))  ; цвет текста выделения
   ScintillaSendMessage(#SciGadget, #SCI_SETMULTIPLESELECTION, 0)           ; мультивыделение
   ScintillaSendMessage(#SciGadget, #SCI_STYLESETBACK, #STYLE_DEFAULT, $3f3f3f)        ; цвет фона
   ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #STYLE_DEFAULT, $aaaaaa)        ; цвет текста
   ScintillaSendMessage(#SciGadget, #SCI_STYLECLEARALL)
   ScintillaSendMessage(#SciGadget, #SCI_SETCARETLINEBACK, RGB(0, 0, 0)) ; цвет подсвеченной строки
   ScintillaSendMessage(#SciGadget, #SCI_SETHSCROLLBAR, 0)              ; не показывать горизонтальную прокрутку
   ScintillaSendMessage(#SciGadget, #SCI_SETVSCROLLBAR, 0)              ; не показывать вертикальную прокрутку
   ScintillaSendMessage(#SciGadget, #SCI_SETMARGINWIDTHN, 0, 0)        ; Устанавливает ширину поля 0 (номеров строк)
   ScintillaSendMessage(#SciGadget, #SCI_SETMARGINWIDTHN, 1, 0)        ; Устанавливает ширину поля 1 (номеров строк)
   
   
   ; Эти константы будут использоватся для подсветки синтаксиса.
   Enumeration 1
      #LexerState_Repeat
      #LexerState_SquareBrackets
      #LexerState_RoundBrackets
      #LexerState_AnyText
      #LexerState_Meta
      #LexerState_Borders
      #LexerState_ChrH
      ;    #LexerState_Number
      ;    #LexerState_Keyword
      ;    #LexerState_String
      ;    #LexerState_Preprocessor
      ;    #LexerState_Operator
      ;    #LexerState_Comment
      ;    #LexerState_FoldKeyword
   EndEnumeration
   ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_Repeat, $71AE71) ; {3,4} повтор
   ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_SquareBrackets, $FF8000) ; [ ... ] квадратные скобки, классы
   ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_RoundBrackets, $8080FF)    ; ( ... ) круглые скобки, флаги
   ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_AnyText, $DE97D9)       ; .*? любой текст
   ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_Meta, $72C0C4)          ; .\w метасимволы
   ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_Borders, $FF66F6)       ; \A границы
   ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_ChrH, $DE97D9)          ; код символа
                                                                      ; ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_Comment, $71AE71) ; Цвет комментариев
                                                                      ; ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_Number, $ABCEE3)            ; Цвет чисел, BGR
                                                                      ; ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_Keyword, $FF9F00)         ; Цвет ключевых слов, BGR
                                                                      ; ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_Operator, $8080FF)         ; Цвет препроцессор, BGR
                                                                      ; ScintillaSendMessage(#SciGadget, #SCI_STYLESETFORE, #LexerState_FoldKeyword, RGB(0, 136, 0))   ; Цвет ключевых слов со сворачиванием.
                                                                      ; ScintillaSendMessage(#SciGadget, #SCI_STYLESETBOLD, #LexerState_Number, 1)               ; Выделять чисел жирным шрифтом
                                                                      ; ScintillaSendMessage(#SciGadget, #SCI_STYLESETITALIC, #LexerState_Comment, 1)            ; Выделять комментарии наклонным шрифтом
   
   
   
   
   
   
   
   StringGadget(2 , 10, 70, 640, 22 , "")
   ;    EditorGadget(3, 10, 120, 640, 180)
   ;    SetGadgetText(3 , "Тестовый текст sRE1$, sED3$, sRP2$ , Text$)") ; Тестовый текст, временная вставка
   ;    EditorGadget(4, 10, 321, 640, 180)
   EditorGadget(3, 0, 0, 0, 0)
   ;    SetGadgetText(3 , "Тестовый текст sRE1$, sED3$, sRP2$ , Text$)") ; Тестовый текст, временная вставка
   EditorGadget(4, 0, 0, 0, 0)
   ;    #Splitter
   SplitterGadget(23, 10, 120, 640, 370, 3, 4, #PB_Splitter_Separator)
   
   ButtonGadget(5, 700, 430, 110, 45, Lng(6))
   
   ButtonGadget(22, 602, 22, 17, 17, Chr($25BC))
   If CreatePopupMenu(0)
      MenuItem(1, "[А-Яа-яЁё]+")
      MenuItem(2, "[A-Fa-f\d]+")
      MenuItem(3, "(?:(?:2(?:[0-4][\d|5[0-5])|[0-1]?\d{1,2})\.){3}(?:(?:2(?:[0-4]\d|5[0-5])|[0-1]?\d{1,2}))")
      MenuItem(4, "(\r\n|\r|\n){2,}")
      MenuItem(5, "(\d+)(((.|,)\d+)+)?")
      MenuItem(6, "\h+(?=\r|\n|\z)")
      
      ;       MenuBar()
   EndIf
   
   OptionGadget(6, 680, 300, 120, 20, Lng(7))
   OptionGadget(7, 680, 320, 120, 20, Lng(8))
   OptionGadget(8, 680, 340, 120, 20, Lng(9))
   OptionGadget(9, 680, 360, 120, 20, Lng(10))
   OptionGadget(10, 680, 380, 120, 20, Lng(11))
   SetGadgetState(8, 1)
   GadgetToolTip(6, Lng(12))
   GadgetToolTip(7, Lng(13))
   GadgetToolTip(8, Lng(14))
   GadgetToolTip(9, Lng(15))
   GadgetToolTip(10, Lng(16))
   
   CheckBoxGadget(11, 660, 10, 180, 20, Lng(17))
   CheckBoxGadget(12, 660, 30, 180, 20, Lng(18))
   CheckBoxGadget(13, 660, 50, 180, 20, Lng(19))
   CheckBoxGadget(14, 660, 70, 180, 20, Lng(20))
   CheckBoxGadget(15, 660, 90, 180, 20, Lng(21))
   SetGadgetState(11, 1)
   SetGadgetState(14, 1)
   SetGadgetState(15, 1)
   GadgetToolTip(11, Lng(22))
   GadgetToolTip(14, Lng(23))
   
   TextGadget(16, 10, 4, 320, 14, Lng(24))
   TextGadget(17, 10, 50, 320, 14, Lng(25))
   TextGadget(18, 10, 101, 320, 14, Lng(26))
   ;    TextGadget(18, 10, 101, 280, 14, "Текст для обработки")
   ;    TextGadget(19, 10, 300, 280, 14, "Результаты обработки")
   
   
   CheckBoxGadget(20, 660, 400, 180, 20, Lng(27))
   GadgetToolTip(20, Lng(28))
   HyperLinkGadget(21, 710, 210, 60, 30, Lng(29), RGB(0, 155,255), #PB_HyperLink_Underline)
   
   
   Repeat
      Select WaitWindowEvent()
         Case #PB_Event_Menu
            eMenu = EventMenu()
            Select eMenu
               Case 1 To 6
                  ;                   SetGadgetText(1 , GetMenuItemText(#SciGadget , eMenu))
                  ScintillaSendMessage(#SciGadget, #SCI_SETTEXT, 0, MakeUTF8Text(GetMenuItemText(0 , eMenu))) ; Установить текст гаджета
            EndSelect
         Case #PB_Event_Gadget
            Select EventGadget()
               Case 22
                  DisplayPopupMenu(0, WindowID(0))  ; покажем всплывающее Меню
               Case 21
                  
                  CompilerSelect #PB_Compiler_OS
                     CompilerCase #PB_OS_Windows
                        RunProgram("http://forum.ru-board.com/topic.cgi?forum=33&topic=0472&start=0&limit=1&m=2#1")
                     CompilerCase #PB_OS_Linux
                        RunProgram("xdg-open", "http://forum.ru-board.com/topic.cgi?forum=33&topic=0472&start=0&limit=1&m=2#1", "")
                  CompilerEndSelect
               Case 5
                  ClearGadgetItems(4) ; SetGadgetText иногда не заменяет текст, пришлось очищать
                  FlagsRE = 0
                  If GetGadgetState(11)
                     FlagsRE | #PB_RegularExpression_DotAll
                  EndIf
                  If GetGadgetState(12)
                     FlagsRE | #PB_RegularExpression_Extended
                  EndIf
                  If GetGadgetState(13)
                     FlagsRE | #PB_RegularExpression_MultiLine
                  EndIf
                  If GetGadgetState(14)
                     FlagsRE | #PB_RegularExpression_AnyNewLine
                  EndIf
                  If GetGadgetState(15)
                     FlagsRE | #PB_RegularExpression_NoCase
                  EndIf
                  Label = 0
                  If GetGadgetState(20)
                     Label = 1
                  EndIf
                  
                  Select 1
                     Case GetGadgetState(6)
                        sResult$ = SearchRE(GetScintillaGadgetText(1), GetGadgetText(3), FlagsRE)
                        SetGadgetText(4, sResult$)
                     Case GetGadgetState(7)
                        sResult$ = ReplaceRE(GetScintillaGadgetText(1), GetGadgetText(3), GetGadgetText(2), FlagsRE)
                        SetGadgetText(4, sResult$)
                     Case GetGadgetState(8)
                        sResult$ = ExtractRE(GetScintillaGadgetText(1), GetGadgetText(3), FlagsRE, Label)
                        SetGadgetText(4, sResult$)
                     Case GetGadgetState(9)
                        sResult$ = GroupsRE(GetScintillaGadgetText(1), GetGadgetText(3), FlagsRE, Label)
                        SetGadgetText(4, sResult$)
                     Case GetGadgetState(10)
                        sResult$ = StepRE(GetScintillaGadgetText(1), GetGadgetText(3), FlagsRE, Label)
                        SetGadgetText(4, sResult$)
                  EndSelect
                  FreeRegularExpression(#PB_All)
            EndSelect
         Case #PB_Event_CloseWindow
            CloseWindow(0)
            FreeRegularExpression(#PB_All)
            End
      EndSelect
   ForEver
   
EndIf




; Получить текст из Scintilla
Procedure.s GetScintillaGadgetText(ID)
   Protected txtLen, *mem, text$
   txtLen = ScintillaSendMessage(#SciGadget, #SCI_GETLENGTH)                          ; получает длину текста в байтах
   *mem = AllocateMemory(txtLen+2)                                               ; Выделяем память на длину текста и 1 символ на Null
   If *mem                                                                 ; Если указатель получен, то
      ScintillaSendMessage(#SciGadget, #SCI_GETTEXT, txtLen+1, *mem)                    ; получает текста
      text$ = PeekS(*mem, -1, #PB_UTF8)                                         ; Считываем значение из области памяти
      FreeMemory(*mem)
      ProcedureReturn text$
   EndIf
   ProcedureReturn ""
EndProcedure

; Преобразование текста в текст для вставки в Scintilla
Procedure MakeUTF8Text(text.s)
   Static buffer.s
   buffer=Space(StringByteLength(text, #PB_UTF8))
   PokeS(@buffer, text, -1, #PB_UTF8)
   ProcedureReturn @buffer
EndProcedure

; Подсвечивание через стиль
Procedure Color2(*regex, regexLength, n)
   Protected txtLen, StartPos, EndPos, firstMatchPos
   
   ; Устанавливает режим поиска (REGEX + POSIX фигурные скобки)
   ScintillaSendMessage(#SciGadget, #SCI_SETSEARCHFLAGS, #SCFIND_REGEXP | #SCFIND_POSIX)
   ;    ScintillaSendMessage(#SciGadget, #SCI_SETSEARCHFLAGS, #SCFIND_REGEXP | #SCFIND_CXX11REGEX)
   
   ; Устанавливает целевой диапазон поиска
   txtLen = ScintillaSendMessage(#SciGadget, #SCI_GETTEXTLENGTH) ; получает длину текста
   
   EndPos = 0
   Repeat
      ScintillaSendMessage(#SciGadget, #SCI_SETTARGETSTART, EndPos)      ; от начала (задаём область поиска) используя позицию конца предыдущего поиска
      ScintillaSendMessage(#SciGadget, #SCI_SETTARGETEND, txtLen)         ; до конца по длине текста
      firstMatchPos=ScintillaSendMessage(#SciGadget, #SCI_SEARCHINTARGET, regexLength, *regex) ; возвращает позицию первого найденного. В параметрах длина искомого и указатель
                                                                         ;       Debug firstMatchPos
      If firstMatchPos>-1                                                       ; если больше -1, то есть найдено, то
         StartPos=ScintillaSendMessage(#SciGadget, #SCI_GETTARGETSTART)                   ; получает позицию начала найденного
         EndPos=ScintillaSendMessage(#SciGadget, #SCI_GETTARGETEND)                      ; получает позицию конца найденного
         ScintillaSendMessage(#SciGadget, #SCI_STARTSTYLING, StartPos, 0)                ; позиция начала (с 50-го)
         ScintillaSendMessage(#SciGadget, #SCI_SETSTYLING, EndPos - StartPos, n)             ; ширина и номер стиля
      Else
         Break
      EndIf
   ForEver
EndProcedure

Procedure MakeScintillaText(text.s, *sciLength.Integer=0)
   Static sciLength : sciLength=StringByteLength(text, #PB_UTF8) ; #TextEncoding
   Static sciText.s : sciText = Space(sciLength)
   If *sciLength : *sciLength\i=sciLength : EndIf ;<--- Возвращает длину буфера scintilla  (требуется для определенной команды scintilla)
   PokeS(@sciText, text, -1, #PB_UTF8)            ; #TextEncoding
   ProcedureReturn @sciText
EndProcedure

; Уведомления
ProcedureDLL SciNotification(Gadget, *scinotify.SCNotification)
   Protected regex$
   ;    Select Gadget
   ;       Case 0 ; уведомление гаджету 0 (Scintilla)
   With *scinotify
      Select \nmhdr\code
         Case #SCN_STYLENEEDED ; нужна стилизация
                          ;            regex$ = "\d+"
            regex$ = "\{[\d,]+\}" ; {2,3} число повторов
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_Repeat)
            regex$ = "\.[*+]\??" ; .*? любой текст
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_AnyText)
            regex$ = "\\[fhrntvdswFHRNVDSW][*+]?\??" ; \w+? метасимвол
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_Meta)
            regex$ = "\\[ABbZzQE]" ; \A границы
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_Borders)
            regex$ = "[$^|]" ; \A границы
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_Borders)
            regex$ = "\\(x\d\d|x\{[0-9A-Fa-f]{2}(?:[0-9A-Fa-f]{2})?\}|\d{3})[*+]?\??" ; \033 код-символ
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_ChrH)
            ;             regex$ = "\[\^|\[)(.*?[^\\:])(\]\+?\??" ; [ ... ] квадратные скобки, классы
            regex$ = "[\[\]]\+?\??" ; [ ... ] квадратные скобки, классы
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_SquareBrackets)
            regex$ = "\(\?<?[:=!]" ; ( ... ) круглые скобки, группы
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_RoundBrackets)
            regex$ = "\(\?[smixJU\-]+?:" ; ( ... ) круглые скобки, флаги
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_RoundBrackets)
            regex$ = "[()][+?]?" ; ( ... ) круглые скобки, флаги
            Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_RoundBrackets)
            ;             regex$ = "\[\:^?(alnum|alpha|ascii|blank|cntrl|digit|graph|lower|print|punct|space|upper|word|xdigit)\:\]" ; [] классы посих, не работает из-за |
            ;             Color2(MakeScintillaText(regex$, @TextLength), Len(regex$), #LexerState_Number)
      EndSelect
   EndWith
   ;    EndSelect
EndProcedure
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---------
; EnableXP