XIncludeFile "../../../widget-events.pbi"


CompilerIf #PB_Compiler_IsMainFile
  
  Uselib(Widget)
  EnableExplicit
  
  Define g,*g._s_widget
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
  Define file$ = "../../../widget-events.pbi"
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
  If ReadFile(0, file$)
    Define  length = Lof(0)                       ; read length of file
    ;FileSeek(0, length-100000)                     ; set the file pointer 10 chars from end of file
    
    ;Debug "Position: " + Str(Loc(0))      ; show actual file pointer position
    Define  *MemoryID = AllocateMemory(length)    ; allocate the needed memory for 10 bytes
    If *MemoryID
      Define bytes = ReadData(0, *MemoryID, length)  ; read this last 10 chars in the file
      text = PeekS(*MemoryID, -1, #PB_UTF8)
    EndIf
    CloseFile(0)
  EndIf
  Debug Str(ElapsedMilliseconds()-time) + " - read time"
  
   
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    EditorGadget(0, 8, 8, 402, 230, #PB_Editor_WordWrap) 
    Define time = ElapsedMilliseconds()
    SetGadgetText(0, Text.s) 
    Debug Str(ElapsedMilliseconds()-time) + " - gadget set text time count - " + CountGadgetItems(0)
    
    
    Open(0, 8, 250, 402, 230)
    *g = Editor(0, 0, 402, 230, #__flag_autosize) : g = getgadget(*g)
    Define time = ElapsedMilliseconds()
    SetText(*g, Text.s) 
    Debug Str(ElapsedMilliseconds()-time) + " - widget set text time count - " + CountItems(*g)
    
    
    
    
    ;\\
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------------------0f-f----------------------------
; EnableXP
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP