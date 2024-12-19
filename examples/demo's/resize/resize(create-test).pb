IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  test_resize = 1
  
  Global Button_1, Button_2, Button_3, Splitter_1, Splitter_2
  
  
  If OpenWindow(5, 0, 0, 380, 400, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ; gadgets
    Button_1 = ScrollAreaGadget(#PB_Any, 0, 0, 0, 0, 150, 150, 1) : CloseGadgetList() 
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "button_1")
    
    Splitter_1 = SplitterGadget(#PB_Any, 10, 10, 285+30, 140, Button_1, Button_2, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)

    Open(5, 10, 160, 285+30+2, 140+2)
    Button_1 = ScrollArea( 0, 0, 0, 0, 150, 150, 1) : CloseList() 
    Button_2 = Button( 0, 0, 0, 0, "button_1")
    Splitter_1 = Splitter(0, 0, 285+30, 140, Button_1,Button_2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    
    WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 6
; Folding = -
; EnableXP
; DPIAware