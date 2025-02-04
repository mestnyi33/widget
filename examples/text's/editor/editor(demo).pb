XIncludeFile "../../../widgets.pbi"
;   WordWrap ! 1
;         SetGadgetAttribute(0, #PB_Editor_WordWrap, WordWrap)


; Key 
;         (UP & Down) переход коретки на один итем верх или вниз и делаем видимим итем на который перешла коретка
;         (PageUP & PageDown) прокрутка на одну страницу верх и вниз 
; Ctrl -  (PageUP & PageDown) прокрутка на один итем верх и вниз коретка остается на том же итеме
; Shift - (PageUP & PageDown) выделения на один итем верх и вниз если доходим на первый или последный выдимий итем то прокручиваем
;         (Left&Right) 
;
;
;
;
;
;
;
;
;

; Количество прочитанных байтов: 1107522
; 18 - Read time
; 261 - add gadget time
; 173 - add widget time


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_edit_text = 1
   
   Define g, *g, Text.s, m.s=#LF$
   
   Text.s = "This is a long line." + m.s +
            "Who should show." + m.s +
            m.s +
            m.s +
            "I have to write the text in the box or not." + m.s +
            m.s +
            m.s +
            "The string must be very long." + m.s +
            "Otherwise it will not work."
   
   Define time = ElapsedMilliseconds()
   Define File$, length, *mem, bytes, bytesCompress, bytesUnCompress, Format = #PB_UTF8
   Define file$ = "../../../widgets.pbi"
   ;File$ = OpenFileRequester("Выберите файл", GetCurrentDirectory() + "AkelPad.ini", "Все файлы (*.*)|*.*", 0)
   
   If Asc(File$)
     If ReadFile(0, File$, Format)
       length = Lof(0)                                         ; Читает размер файла в байтах
       FileSeek(0, 0)                                          ; length-100000)                         ; set the file pointer 100000 chars from end of file
       *mem = AllocateMemory(length)                           ; Выделяет блок памяти с размером файла
       If *mem
         bytes = ReadData(0, *mem, length)                    ; Читает данные из файла и помещает их в блок памяти
         Debug "Количество прочитанных байтов: " + Str(bytes)
         Text = PeekS(*mem, length, Format)
       EndIf
       
;        ; 2 вариант
;        Text = ReadString(0, #PB_File_IgnoreEOL) ; 31
       
       
       CloseFile(0)
     EndIf
   EndIf
   Debug Str(ElapsedMilliseconds()-time) + " - read time"
   
   
   LoadFont(1, "Courier", 14)
   If Open(0, 0, 0, 522, 490, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      
      Define time = ElapsedMilliseconds()
      ; g = EditorGadget(#PB_Any, 8, 8, 306, 133) 
      g = EditorGadget(#PB_Any, 0, 0, 0, 0);, #PB_Editor_WordWrap) ; bug PB on windows 
      SetGadgetText(g, Text.s)
      AddGadgetItem(g, 0, "add line first")
      AddGadgetItem(g, 4, "add line "+Str(4))
      AddGadgetItem(g, 8, "add line "+Str(8))
      AddGadgetItem(g, -1, "add line last")
      ; SetGadgetFont(g, FontID(1))
      Debug Str(ElapsedMilliseconds()-time) + " - add gadget time"
   
      Define time = ElapsedMilliseconds()
      ; *g = Editor(8, 146, 306, 133) 
      *g = Editor(0, 0, 0, 0);, #PB_Editor_WordWrap) ; с ним очень плохо работает ; commit 1,622
      SetBackgroundColor(*g, $FFB3FDFF)
      SetText(*g, Text.s)
;       Debug ""
       AddItem(*g, 0, "add line first")
       AddItem(*g, 4, "add line "+Str(4))
       AddItem(*g, 8, "add line "+Str(8))
       AddItem(*g, -1, "add line last")
;       ; SetFont(*g, FontID(1))
      Debug Str(ElapsedMilliseconds()-time) + " - add widget time"
   
      Splitter(8, 8, 522-16, 490-16, g, *g, #__flag_autosize)
      
      
       
      
      Repeat
         Define Event = WaitWindowEvent()
         
         Select Event
            Case #PB_Event_LeftClick 
               SetActiveGadget(0)
            Case #PB_Event_RightClick
               SetActiveGadget(10)
         EndSelect
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS - C Backend (MacOS X - x64)
; CursorPosition = 58
; FirstLine = 42
; Folding = --
; EnableXP
; DPIAware