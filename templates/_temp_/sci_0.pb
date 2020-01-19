; Активируем Scintilla.dll
InitScintilla("Scintilla.dll")
 
; Эти константы будут использоватся для подсветки синтаксиса.
Enumeration 0 
   #LexerState_Space 
   #LexerState_Comment 
   #LexerState_Keyword 
   #LexerState_FoldKeyword 
EndEnumeration 
 
Procedure MyLexerInit()
   ; Шрифт
   ScintillaSendMessage(0, #SCI_STYLESETFONT,#STYLE_DEFAULT, @"Lucida Console") 
   ; Размер шрифта
   ScintillaSendMessage(0, #SCI_STYLESETSIZE,#STYLE_DEFAULT, 10) 
   ScintillaSendMessage(0, #SCI_STYLECLEARALL) 
   
   ; Цвет активной строки
   ScintillaSendMessage(0, #SCI_SETCARETLINEBACK,RGB(254, 252, 202)) 
   ; Разрешаем отмачать активную строку
   ScintillaSendMessage(0, #SCI_SETCARETLINEVISIBLE,#True) 
   
   ; Устанавливаем цвета для подсветки синтаксиса
   ; Эти цвета условно присваиваются константам #LexerState_...
   
   ScintillaSendMessage(0, #SCI_STYLESETFORE,#LexerState_Comment, $BB00) ; Цвет комментариев 
   ScintillaSendMessage(0, #SCI_STYLESETITALIC,#LexerState_Comment, 1) ; Выделять комментарии наклонным шрифтом
   ScintillaSendMessage(0, #SCI_STYLESETFORE,#LexerState_Keyword, 0)  ; Цвет обычного текста
   ScintillaSendMessage(0, #SCI_STYLESETFORE,#LexerState_FoldKeyword, $FF) ; Цвет ключевых слов.
   
   ; Margins 
   ScintillaSendMessage(0, #SCI_SETMARGINTYPEN, 0, #SC_MARGIN_NUMBER) ; Добавляем поле автонумирации
   ScintillaSendMessage(0, #SCI_SETMARGINMASKN, 2, #SC_MASK_FOLDERS) ; Добавляем поле для свертки и маркеров
   ScintillaSendMessage(0, #SCI_SETMARGINWIDTHN, 0, 20) ; Ширина поля автонумирации
   ScintillaSendMessage(0, #SCI_SETMARGINWIDTHN, 2, 20) ; Ширина поля свертки и маркеров
   ScintillaSendMessage(0, #SCI_SETMARGINSENSITIVEN, 2, #True) 
   
   ; Иконки свёртки текста 
   ScintillaSendMessage(0, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDER, #SC_MARK_CIRCLEPLUS) 
   ScintillaSendMessage(0, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPEN, #SC_MARK_CIRCLEMINUS) 
   ScintillaSendMessage(0, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERSUB, #SC_MARK_VLINE) 
   ScintillaSendMessage(0, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERTAIL, #SC_MARK_LCORNERCURVE) 
   ScintillaSendMessage(0, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEREND, #SC_MARK_CIRCLEPLUSCONNECTED) 
   ScintillaSendMessage(0, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPENMID, #SC_MARK_CIRCLEMINUSCONNECTED) 
   ScintillaSendMessage(0, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERMIDTAIL, #SC_MARK_TCORNERCURVE) 
   
   ; Choose folding icon colours 
   ScintillaSendMessage(0, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDER, $FFFFFF) 
   ScintillaSendMessage(0, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDER, $FF) 
   
   ScintillaSendMessage(0, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPEN, $FFFFFF) 
   ScintillaSendMessage(0, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPEN, $FF) 
   
   ScintillaSendMessage(0, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPENMID, $FFFFFF) 
   ScintillaSendMessage(0, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPENMID, $FF00) 
   
   ScintillaSendMessage(0, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEREND, $FFFFFF) 
   ScintillaSendMessage(0, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEREND, $FF00) 
   
   ScintillaSendMessage(0, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDERMIDTAIL, $FFFFFF) 
   ScintillaSendMessage(0, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERMIDTAIL, 0)
   
   ScintillaSendMessage(0, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDERSUB, $FFFFFF) 
   ScintillaSendMessage(0, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERSUB, 0) 
   
   ScintillaSendMessage(0, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDERTAIL, $FFFFFF) 
   ScintillaSendMessage(0, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERTAIL, 0) 
EndProcedure
 
Procedure SCI_CB(Gadget, *scinotify.SCNotification) ; Обработка событий от редактора
; Переписываем данные из структуры в переменные
 code=             *scinotify.SCNotification\nmhdr\code
 pos=              *scinotify.SCNotification\Position
 ch=               *scinotify.SCNotification\ch
 modificationType= *scinotify.SCNotification\modifiers
 text=             *scinotify.SCNotification\text
 Length=           *scinotify.SCNotification\length
 linesAdded=       *scinotify.SCNotification\linesAdded
 message=          *scinotify.SCNotification\message
 wParam=           *scinotify.SCNotification\wParam
 lParam=           *scinotify.SCNotification\lParam
 line=             *scinotify.SCNotification\line
 foldLevelNow=     *scinotify.SCNotification\foldLevelNow
 foldLevelPrev=    *scinotify.SCNotification\foldLevelPrev
 margin=           *scinotify.SCNotification\margin
 listType=         *scinotify.SCNotification\listType
 x=                *scinotify.SCNotification\x
 y=                *scinotify.SCNotification\y
 
 
 Select code
      Case #SCN_MARGINCLICK ; Щёлчёк по редаткору
         ; Update folding 
         linenumber = ScintillaSendMessage(0,#SCI_LINEFROMPOSITION,pos ) ; Узнаём номер строки
         Select margin 
            Case 2 ; Если был щелчёк пополю свёртки текста, своравиваем или разворачиваем его
               ScintillaSendMessage(0,#SCI_TOGGLEFOLD,linenumber) 
         EndSelect 
      Case #SCN_STYLENEEDED
         ; Syntax highlighter   
         EndPos=pos
         EndStyledPos = ScintillaSendMessage(0,#SCI_GETENDSTYLED) ; Вероятно узнаёт количество символов в редакторе.
         linenumber = ScintillaSendMessage(0,#SCI_LINEFROMPOSITION,EndStyledPos) ; Наверное узнаём номер последней строки.
         
         If linenumber = 0 
            level = #SC_FOLDLEVELBASE 
         Else 
            linenumber - 1 
            level = ScintillaSendMessage(0,#SCI_GETFOLDLEVEL,linenumber) & ~ #SC_FOLDLEVELHEADERFLAG ; Что-то связаное со свёрткой текста
         EndIf 
         
         thislevel = level 
         nextlevel = level 
         
         CurrentPos.l = ScintillaSendMessage(0,#SCI_POSITIONFROMLINE,linenumber) ; Текуцая позиция курсора.
         ScintillaSendMessage(0,#SCI_STARTSTYLING,CurrentPos, $1F | #INDICS_MASK) ; Подготовка к стилистической правке 
         State = #LexerState_Space 
         KeywordStartPos = CurrentPos 
         keyword.s = "" 
         
         While CurrentPos <= EndPos 
            OldState = State 
            
            Char.l = ScintillaSendMessage(0,#SCI_GETCHARAT, CurrentPos) ; Получаем символ из текущей позиции курсора.
            If Char = ';' 
               State = #LexerState_Comment 
            ElseIf Char = 10 Or Char = 13 
               State = #LexerState_Space 
            ElseIf State <> #LexerState_Comment 
               If Char = 9 Or Char = ' ' Or Char = '.' 
                  State = #LexerState_Space 
               Else 
                  State = #LexerState_Keyword 
                  keyword + Chr(Char) 
               EndIf 
            EndIf 
            
            If OldState <> State Or CurrentPos = EndPos 
               If OldState = #LexerState_Keyword 
                  lkeyword.s = LCase(keyword) 
                  If lkeyword = "procedure" Or lkeyword = "if" 
                     thislevel | #SC_FOLDLEVELHEADERFLAG ; указывает, что линия является заголовком ???
                     nextlevel + 1 
                     OldState = #LexerState_FoldKeyword 
                  ElseIf lkeyword = "endprocedure" Or lkeyword = "endif" 
                     nextlevel - 1 
                     If nextlevel < #SC_FOLDLEVELBASE 
                        nextlevel = #SC_FOLDLEVELBASE 
                     EndIf 
                     OldState = #LexerState_FoldKeyword 
                  EndIf 
                  keyword = "" 
               EndIf 
               ScintillaSendMessage(0,#SCI_SETSTYLING, CurrentPos - KeywordStartPos, OldState) ; Вроде как подсвечивание синтаксиса. Или только подготовка к этому ???
               KeywordStartPos = CurrentPos 
            EndIf 
            
            If Char = 10 Or CurrentPos = EndPos 
               ScintillaSendMessage(0,#SCI_SETFOLDLEVEL, linenumber, thislevel) ; Кажется за свёртку отвечает.
               thislevel = nextlevel 
               linenumber + 1 
            EndIf 
            
            CurrentPos + 1 
         Wend
         
   EndSelect
EndProcedure
 
If OpenWindow(0, 450, 200, 402, 402, "Static Scintilla Example", #PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)
 If CreateGadgetList(WindowID(0))
  ScintillaGadget(0, 2, 2, 398, 398, @SCI_CB()) ; Создаём гаджет и прогедуре SCI_CB() присваиваем статус обработчика событий редактора.
    
  
  MyLexerInit() ; Настраиваем редактор
   ; Set some sample text 
   text.s = "; A custom Scintilla lexer example" 
   text + #CRLF$ + "Procedure hello()" + #CRLF$
   text + #CRLF$ + "If OK "
   text + #CRLF$ + "  Debug(" + Chr(34) + "Woo" + Chr(34) + ")"
   text + #CRLF$ + "EndIf" + #CRLF$
   text + #CRLF$ + "EndProcedure" 
   ;SetGadgetText(0,text)
       *Text=UTF8(text)
      ScintillaSendMessage(0, #SCI_SETTEXT, 0, *Text)
      FreeMemory(*Text) ; The buffer made by UTF8() has to be freed, to avoid memory leak

  Repeat 
  Event = WaitWindowEvent() 
  Gadget=EventGadget()
  
  If Event=#PB_Event_SizeWindow
   ResizeGadget(0,#PB_Ignore,#PB_Ignore,WindowWidth(0)-4,WindowHeight(0)-2)
  EndIf
      
  Until Event=#PB_Event_CloseWindow 
 EndIf
EndIf 
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---
; EnableXP