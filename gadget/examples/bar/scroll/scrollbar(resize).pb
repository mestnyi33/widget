﻿;XIncludeFile "../../gadgets.pbi" : UseModule gadget

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Define h = 40
  Define *g1, *g2, *g3, *g4, *g5, *g6
  
  If OpenWindow(#PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = ScrollBarGadget(#PB_Any,     30, 30, 200, h, 0,301,139 )
    *g2 = ScrollBarGadget(#PB_Any, 30+210, 30, 200, h, 0,301,129 )
    *g3 = ScrollBarGadget(#PB_Any, 30+420, 30, 200, h, 0,301,139 )
    
    *g4 = SplitterGadget(#PB_Any, 0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g5 = SplitterGadget(#PB_Any, 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    *g6 = SplitterGadget(#PB_Any, 30,30,620,h, *g5,TextGadget(#PB_Any, 0,0,0,0,""))
    
    SetGadgetState(*g4, 200)
    SetGadgetState(*g5, 200*2)
    SetGadgetState(*g6, h)
    
    SetGadgetState(*g2, 172/2)
    SetGadgetState(*g3, 162)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP