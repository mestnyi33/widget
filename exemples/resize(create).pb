CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/widgets()"
  XIncludeFile "../fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget/widgets()"
CompilerElse
  IncludePath "Z:/Documents/GitHub/Widget/widgets()"
CompilerEndIf


CompilerIf Not Defined(bar, #PB_Module)
  XIncludeFile "bar.pbi"
CompilerEndIf


;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule bar
  UseModule constants
  UseModule structures
  
  Macro OpenWindow(Window, X, Y, Width, Height, Title, Flag=0, ParentID=0)
    bar::Open_Window(Window, X, Y, Width, Height, Title, Flag, ParentID)
  EndMacro
  
  Global Button_1, Button_2, Button_3, Splitter_1, Splitter_2
  
  
  If OpenWindow(0, 0, 0, 380, 400, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Button_1 = Progress(0, 0, 0, 0, 1, 100, 30)
    Button_2 = ScrollArea(0, 0, 0, 0, 150, 150, 1) : CloseList()        ; as they will be sized automatically
    Button_3 = Progress(0, 0, 0, 0, 1, 100, 30)
    
    ;     Splitter_1 = Splitter(0, 0, 0, 0, Button_1, Button_2, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    ;     Splitter_2 = Splitter(10, 10, 285+30, 140, Splitter_1, Button_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    Splitter_1 = Splitter(0, 0, 0, 0, Button_1, Button_2, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_2 = Splitter(10, 10, 285+30, 140, Splitter_1, Button_3, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    
    SetState(Splitter_1, 40)
    SetState(Splitter_2, 245)
    
    If OpenList(Button_2)
      ScrollArea(-1, -1, 90, 90, 150, 150, 1)
      Define i, time
      time = ElapsedMilliseconds()
      For i=0 To 5000
        Progress(10+i*2, 10+i*2, 50, 30, 1, 100, 30)
      Next
      CloseList()
      For i=0 To 5000
        Progress(100-i*2, 10+i*2, 50, 30, 1, 100, 30)
      Next
      Debug "time - "+Str(ElapsedMilliseconds()-time)
      CloseList()
    EndIf
    
    ; Gadget
    Button_1 = ProgressBarGadget(#PB_Any, 0, 0, 0, 0, 1, 100, 30)
    Button_2 = ScrollAreaGadget(#PB_Any, 0, 0, 0, 0, 150, 150, 1) : CloseGadgetList() 
    Button_3 = ProgressBarGadget(#PB_Any, 0, 0, 0, 0, 1, 100, 30)
    
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_1, Button_2, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_2 = SplitterGadget(#PB_Any, 10, 160, 285+30, 140, Splitter_1, Button_3, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    
    SetGadgetState(Splitter_1, 40)
    SetGadgetState(Splitter_2, 245)
    
    If OpenGadgetList(Button_2)
      ScrollAreaGadget(#PB_Any, -1, -1, 90, 90, 150, 150, 1)
      Define i, time
      time = ElapsedMilliseconds()
      For i=0 To 5000
        ProgressBarGadget(#PB_Any, 10+i*2, 10+i*2, 50, 30, 1, 100, 30)
      Next
      CloseGadgetList()
      For i=0 To 5000
        ProgressBarGadget(#PB_Any, 100-i*2, 10+i*2, 50, 30, 1, 100, 30)
      Next
      Debug "time - "+Str(ElapsedMilliseconds()-time)
      CloseGadgetList()
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP