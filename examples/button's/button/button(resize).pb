﻿XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define h = 80
  Define._s_widget *g1, *g2, *g3, *g4, *g5, *g6
  
  If Open(#PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = Button(    30, 30, 200, h, "butt_left", #PB_Button_Left)
    *g2 = Button(30+210, 30, 200, h, "butt" + #LF$ + "center" + #LF$ + "multi", #PB_Button_MultiLine)
    *g3 = Button(30+420, 30, 200, h, "right_butt", #PB_Button_Right)
    
    *g4 = Splitter(0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g5 = Splitter(30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    *g6 = Splitter(30,30,620,h, *g5,#Null)
    
    SetState(*g4, 200)
    SetState(*g5, 200*2)
    SetState(*g6, h)
   
    WaitClose( )
  EndIf
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 13
; Folding = -
; EnableXP
; DPIAware