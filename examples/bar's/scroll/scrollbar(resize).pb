XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define h = 60, max = 301
  Define._s_widget *g1, *g2, *g3, *g4, *g5, *g6
  
  If OpenRoot(0, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = ScrollBarWidget(    30, 30, 200, h, 0,max,139)
    *g2 = ScrollBarWidget(30+210, 30, 200, h, 0,max,139)
    *g3 = ScrollBarWidget(30+420, 30, 200, h, 0,max,139)
    
    SetWidgetState(*g2, *g2\bar\page\end/2)
    SetWidgetState(*g3, *g3\bar\page\end)
    
    *g4 = SplitterWidget(0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g5 = SplitterWidget(0,0,0,0, *g4,*g3, #PB_Splitter_Vertical)
    *g6 = SplitterWidget(30,30,620,h, *g5,#PB_Default)
    
    SetWidgetState(*g4, 200)
    SetWidgetState(*g5, 200*2+8)
    SetWidgetState(*g6, h)
    
    WaitCloseRoot( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 13
; Folding = -
; EnableXP