IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global count = 1000
  Global Button_1, Button_2, Button_3, Splitter_1, Splitter_2
  
  
  If Open(0, 0, 0, 380, 400, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ; gadgets
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "button_1")
    Button_2 = ScrollAreaGadget(#PB_Any, 0, 0, 0, 0, 150, 150, 1) : CloseGadgetList() 
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "button_2")
    
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_1, Button_2, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_2 = SplitterGadget(#PB_Any, 10, 10, 285+30, 140, Splitter_1, Button_3, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    
    SetGadgetState(Splitter_1, 40)
    SetGadgetState(Splitter_2, 245)
    
    If OpenGadgetList(Button_2)
      ScrollAreaGadget(#PB_Any, -1, -1, 90, 90, 150, 150, 1)
      Define i, time
      time = ElapsedMilliseconds()
      For i=0 To count
        ButtonGadget(#PB_Any, 10+i*2, 10+i*2, 50, 30, Str(i)+"_button")
      Next
      CloseGadgetList()
      For i=0 To count
        ButtonGadget(#PB_Any, 100-i*2, 10+i*2, 50, 30, Str(i)+"_button")
      Next
      
      Debug Str(ElapsedMilliseconds()-time)+ " - time " +count+ " create gadget"; 204 - macos
      CloseGadgetList()
    EndIf
    
    ; widgets
    Button_1 = Button(0, 0, 0, 0, "button_1")
    Button_2 = ScrollArea(0, 0, 0, 0, 150, 150, 1) : CloseList()        ; as they will be sized automatically
    Button_3 = Button(0, 0, 0, 0, "button_3")
    
    Splitter_1 = Splitter(0, 0, 0, 0, Button_1, Button_2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    Splitter_2 = Splitter(10, 160, 285+30, 140, Splitter_1, Button_3, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    
    SetState(Splitter_1, 40)
    SetState(Splitter_2, 245)
    
    If OpenList(Button_2)
      ScrollArea(-1, -1, 90, 90, 150, 150, 1)
      Define i, time
      time = ElapsedMilliseconds()
      For i=0 To count
        Button(10+i*2, 10+i*2, 50, 30, Str(i)+"_button")
      Next
      CloseList()
      For i=0 To count
        Button(100-i*2, 10+i*2, 50, 30, Str(i)+"_button")
      Next
      
      Debug Str(ElapsedMilliseconds()-time)+ " - time " +count+ " create widget"; 75 - macos
      CloseList()
    EndIf
    
    WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; DPIAware