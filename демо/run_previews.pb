Procedure RunPreview(SourceCode$)
   If SourceCode$ = "" : ProcedureReturn : EndIf
   Protected TempFileName$, hTempFile
   Protected CompilerPath$, CompilPreview, CompilPreviewOutput$
   Protected PreviewProgramName$, Flags$, PreviewRunning
   
   ; НАСТРОЙКА ПУТИ К КОМПИЛЯТОРУ
   ; АВТОМАТИЧЕСКОЕ ОПРЕДЕЛЕНИЕ ПУТИ
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      CompilerPath$ = #PB_Compiler_Home + "Compilers\pbcompiler.exe"
   CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      ; Так как #PB_Compiler_Home уже включает "Contents/Resources/", 
      ; нам остается добавить только "compilers/pbcompiler" строго в нижнем регистре
      CompilerPath$ = #PB_Compiler_Home + "compilers/pbcompiler"
   CompilerEndIf
   
   ; Проверяем, существует ли файл компилятора
   If FileSize(CompilerPath$) <= 0
      MessageRequester("Ошибка", "Компилятор не найден!" + #CRLF$ + "Искали по пути: " + CompilerPath$, #PB_MessageRequester_Error)
      ProcedureReturn
   EndIf
   
   ; Создаем временный файл кода в текущей папке
   TempFileName$ = GetCurrentDirectory() + "preview_temp.pb"
   hTempFile = CreateFile(#PB_Any, TempFileName$, #PB_UTF8)
   If hTempFile
      WriteStringFormat(hTempFile, #PB_UTF8)
      WriteStringN(hTempFile, SourceCode$)
      CloseFile(hTempFile)
      
      ; Формируем имя исполняемого файла
      PreviewProgramName$ = GetCurrentDirectory() + "preview_app"
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
         PreviewProgramName$ + ".exe"
         Flags$ = #DQUOTE$ + TempFileName$ + #DQUOTE$ + " /EXE " + #DQUOTE$ + PreviewProgramName$ + #DQUOTE$ + " /XP /DPIAWARE"
      CompilerElse
         Flags$ = #DQUOTE$ + TempFileName$ + #DQUOTE$ + " -o " + #DQUOTE$ + PreviewProgramName$ + #DQUOTE$
      CompilerEndIf
      
      ; Запуск компиляции
      CompilPreview = RunProgram(CompilerPath$, Flags$, "", #PB_Program_Hide | #PB_Program_Open | #PB_Program_Read)
      
      If CompilPreview
         ; Читаем лог компиляции
         While ProgramRunning(CompilPreview)
            If AvailableProgramOutput(CompilPreview)
               CompilPreviewOutput$ + ReadProgramString(CompilPreview) + #CRLF$
            EndIf
         Wend
         While AvailableProgramOutput(CompilPreview)
            CompilPreviewOutput$ + ReadProgramString(CompilPreview) + #CRLF$
         Wend
         
         If ProgramExitCode(CompilPreview) <> 0
            CloseProgram(CompilPreview)
            DeleteFile(TempFileName$)
            MessageRequester("Ошибка компиляции", "Компилятор вернул ошибку:" + #CRLF$ + CompilPreviewOutput$, #PB_MessageRequester_Error)
         Else
            CloseProgram(CompilPreview)
            DeleteFile(TempFileName$)
            
            ; Если файл успешно создан — запускаем его
            If FileSize(PreviewProgramName$) > 0
               PreviewRunning = RunProgram(PreviewProgramName$, "", "", #PB_Program_Open)
               If Not PreviewRunning
                  MessageRequester("Ошибка", "Не удалось запустить скомпилированный файл.", #PB_MessageRequester_Error)
               EndIf
            Else
               MessageRequester("Ошибка", "Файл скомпилировался, но бинарник не создался.", #PB_MessageRequester_Error)
            EndIf
         EndIf
      Else
         MessageRequester("Ошибка", "Не удалось запустить процесс компилятора pbcompiler.", #PB_MessageRequester_Error)
      EndIf
   Else
      MessageRequester("Ошибка", "Не удалось создать временный файл кода на диске.", #PB_MessageRequester_Error)
   EndIf
EndProcedure

; --- ТЕСТОВЫЙ ЗАПУСК ---
; Этот код мы передаем компилятору «внутри» программы
DemoCode$ = "If OpenWindow(0, 100, 100, 300, 100, " + Chr(34) + "Тест превью" + Chr(34) + ", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)" + #CRLF$ +
"  ButtonGadget(0, 10, 30, 280, 40, " + Chr(34) + "Работает!" + Chr(34) + ")" + #CRLF$ +
""+
"  StickyWindow(0, 1)" + #CRLF$ +
""+
"  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS"  + #CRLF$+
""+
~"    CocoaMessage(0, CocoaMessage(0, 0, \"NSApplication sharedApplication\"), \"activateIgnoringOtherApps:\", #True)\n"  + #CRLF$+
""+
"  CompilerEndIf" + #CRLF$+
""+
"  Repeat" + #CRLF$ +
""+
"    Event = WaitWindowEvent()" + #CRLF$ +
""+
"  Until Event = #PB_Event_CloseWindow" + #CRLF$ +
""+
"EndIf"

RunPreview(DemoCode$)

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 82
; FirstLine = 73
; Folding = --
; EnableXP
; DPIAware