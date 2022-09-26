XIncludeFile "../../../widgets.pbi": UseLib( widget )
;XIncludeFile "../../s.pbi" : UseModule 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Define bh = 140,h = bh*4 + 2
  Define *g1, *g2, *g3, *g4, *g5, *g6
  Define text.s = "line_1" + #LF$ + 
                  "line_2" + #LF$ +
                  "line_3" + #LF$ +
                  "line_4" + #LF$ +
                  "line_5" + #LF$ +
                  "line_6" + #LF$ +
                  "line_7"
    
  If Open(#PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    
    ;*g4 = Splitter( 0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g4 = Container( 0,0,0,0 ) 
;     Button( 0,   0,0,bh, text, #__text_right) : SetAlignment( widget( ), #__align_left|#__align_right)
;     String( 0,bh*1,0,bh, text, #__text_right) : SetAlignment( widget( ), #__align_left|#__align_right)
;     Text( 0,bh*2,0,bh, text, #__text_right) : SetAlignment( widget( ), #__align_left|#__align_right)
     Editor( 0,bh*3,0,bh, #__text_right) : SetText( widget( ), text) : SetAlignmentFlag( widget( ), #__align_left|#__align_right)
    ;Button( 0,bh*4,0,bh, text, #__text_right) : SetAlignment( widget( ), #__align_left|#__align_right)
    
    CloseList( )
    
    *g5 = Splitter( 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    ;*g6 = Splitter( 30,30,620,h, *g5,#Null)
    
    ;SetState(*g4, 200)
    SetState(*g5, 200*2)
    ;SetState(*g6, h)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP