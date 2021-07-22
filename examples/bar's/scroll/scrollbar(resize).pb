﻿XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Define h = 40
  Define._s_widget *g1, *g2, *g3, *g4, *g5, *g6
  
  If Open(#PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = Scroll(    30, 30, 200, h, 0,301,139)
    *g2 = Scroll(30+210, 30, 200, h, 0,301,129)
    *g3 = Scroll(30+420, 30, 200, h, 0,301,139)
    
    *g4 = Splitter(0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g5 = Splitter(30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    *g6 = Splitter(30,30,620,h, *g5,#Null)
    
    SetState(*g4, 200)
    SetState(*g5, 200*2)
    SetState(*g6, h)
    
    SetState(*g2, *g2\bar\page\end/2)
    SetState(*g3, *g2\bar\page\end)
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP