XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define h = 80
  Define._s_widget *g1, *g2, *g3, *g4, *g5, *g6
  
  If OpenRoot(#PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = ButtonWidget(    30, 30, 200, h, "butt_left", #__flag_TextLeft)
    *g2 = ButtonWidget(30+210, 30, 200, h, "butt" + #LF$ + "center" + #LF$ + "multi", #__flag_Textmultiline)
    *g3 = ButtonWidget(30+420, 30, 200, h, "right_butt", #__flag_TextRight)
    
    *g4 = SplitterWidget(0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g5 = SplitterWidget(30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    *g6 = SplitterWidget(30,30,620,h, *g5,#Null)
    
    SetWidgetState(*g4, 200)
    SetWidgetState(*g5, 200*2)
    SetWidgetState(*g6, h)
   
    WaitCloseRoot( )
  EndIf
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; Folding = -
; EnableXP