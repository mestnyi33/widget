CompilerIf #PB_Compiler_IsMainFile
  
  ;Uselib(Widget)
  EnableExplicit
  
  Define g,*g;._s_widget
  Define Text.s
   
  Procedure ResizeCallBack()
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-16, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  
  Define time = ElapsedMilliseconds()
  ;Define file$ = "/Users/as/Documents/GitHub/Widget/widget-events.pbi"
  ;Define file$ = "../../../widget-events.pbi"
  ; Define file$ = "../../../IDE/ide(form).pb"
  ;  ;//
  ;  If ReadFile(0, file$)   ; if the file could be read, we continue...
  ;       While Eof(0) = 0           ; loop as long the 'end of file' isn't reached
  ;         text + ReadString(0) + #LF$      ; display line by line in the debug window
  ;       Wend
  ;       CloseFile(0)               ; close the previously opened file
  ;     Else
  ;       MessageRequester("Information","Couldn't open the file!")
  ;     EndIf
  
  ;\\
;   If ReadFile(0, file$)
;     Define  length = Lof(0)                       ; read length of file
;     FileSeek(0, length-100000)                     ; set the file pointer 10 chars from end of file
;     
;     ;Debug "Position: " + Str(Loc(0))      ; show actual file pointer position
;     Define  *MemoryID = AllocateMemory(length)    ; allocate the needed memory for 10 bytes
;     If *MemoryID
;       Define bytes = ReadData(0, *MemoryID, length)  ; read this last 10 chars in the file
;       text = PeekS(*MemoryID, -1, #PB_UTF8)
;     EndIf
;     CloseFile(0)
;   EndIf
  Define *Output, Result, fuf$, Format = #PB_UTF8
 
Define File$, length, *mem, bytes, bytesCompress, bytesUnCompress
 
  Define file$ = "/Users/as/Documents/GitHub/Widget/widget-events.pbi"
  ;File$ = OpenFileRequester("Выберите файл", GetCurrentDirectory() + "AkelPad.ini", "Все файлы (*.*)|*.*", 0)
If Asc(File$)
    If ReadFile(0, File$, Format)
      length = Lof(0) ; Читает размер файла в байтах
        FileSeek(0, length-100000)                     ; set the file pointer 100000 chars from end of file
        *mem = AllocateMemory(length) ; Выделяет блок памяти с размером файла
        If *mem
            bytes = ReadData(0, *mem, length) ; Читает данные из файла и помещает их в блок памяти
            Debug "Количество прочитанных байтов: " + Str(bytes)
            text = PeekS(*mem, length, Format)
        EndIf
        CloseFile(0)
    EndIf
  EndIf
  Debug Str(ElapsedMilliseconds()-time) + " - read time"
  
   
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    EditorGadget(0, 8, 8, 402, 230, #PB_Editor_WordWrap) 
    Define time = ElapsedMilliseconds()
    SetGadgetText(0, Text.s) 
    Debug Str(ElapsedMilliseconds()-time) + " - time gadget set text count - " + CountGadgetItems(0)
    
    
;     Open(0, 8, 250, 402, 230)
;     *g = Editor(0, 0, 402, 230, #__flag_autosize) : g = getgadget(*g)
;     Define time = ElapsedMilliseconds()
;     SetText(*g, Text.s) 
;     Debug Str(ElapsedMilliseconds()-time) + " - widget set text time count - " + CountItems(*g)
;     
;     
    Define item = 2395
    
    Define time = ElapsedMilliseconds()
    Define String.s = GetGadgetItemText( 0, item)
    Debug Str(ElapsedMilliseconds()-time) + " - time GetGadgetItemText " + item +" "+ String
    Debug ""
    Define time = ElapsedMilliseconds()
    Text.s = ReplaceString( Text.s, #LFCR$, #LF$ )
    Text.s = ReplaceString( Text.s, #CRLF$, #LF$ )
    Text.s = ReplaceString( Text.s, #CR$, #LF$ )
    
    Define *str.Character ;= @Text
    Define *end.Character = @Text
    Debug Str(ElapsedMilliseconds()-time) + " - time widget set text count - "+Str(CountString(Text, #LF$ )+1)
    
    Define time = ElapsedMilliseconds()
    Define String.s = StringField( Text, 1+item, #LF$)
    Debug Str(ElapsedMilliseconds()-time) + " - time StringField " + item +" "+ String
    
    item -1
    Debug  "------------loop----------------"
    Define time = ElapsedMilliseconds()
    Define count = 0
    
    While *End\c
      If *end\c = #LF ;Or *End\c = 0
                      ;edit_AddItem( *this, *this\_rows( ), - 1, *str, (*end-*str)>>#PB_Compiler_Unicode )
        If count = item
          Debug PeekS(*str, (*end-*str)>>#PB_Compiler_Unicode )
          Break
        EndIf
        
        count + 1
        *str = *end + SizeOf(Character) 
      EndIf 
      *end + SizeOf(Character) 
    Wend
    
    ;Debug PeekS(*str, (*end-*str)>>#PB_Compiler_Unicode )
    
     Debug Str(ElapsedMilliseconds()-time) + " - time"
;     
;     Debug  "----------------------------"
;     Define time = ElapsedMilliseconds()
;     Define count = CountString(Text, #LF$ )
;     Define i
;     For i=0 To count
;       StringField(Text, 1+i, #LF$ ) 
;       
;       SetupStringField(this.StringField,string$,del$)
;   
;   While GetStringFieldEnd(this) = 0
;     NextStringField(this)
;     x+Val(GetStringField(this))
;   Wend
;     Next
;     Debug Str(ElapsedMilliseconds()-time) + " - time"
;    
		
;     
;     
;     
;     
;     ;\\
;     SplitterGadget(10,8, 8, 306, 491-16, 0,g)
;     CompilerIf #PB_Compiler_Version =< 546
;       BindGadgetEvent(10, @SplitterCallBack())
;     CompilerEndIf
;     PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
;     BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
   ; Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf



; mac os
; Количество прочитанных байтов: 100000
; 4 - Read time
; 4 - time gadget set text count - 2396
; 10 - time GetGadgetItemText 2395 ; EnableXP
; 
; 2 - time widget set text count - 2396
; 0 - time StringField 2395 ; EnableXP
; ------------loop----------------
; 19 - time
; ----------------------------
; 110 - time
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP