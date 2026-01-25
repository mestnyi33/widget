XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  test_draw_area = 1
  
  Define h = 185, bh = 26
  Define *g1, *g2, *g3, *g4, *g5, *g6
  
  Procedure Test( X,Y,Width,Height, txt$, flags.q=0 )
      Protected._s_WIDGET *g  
;       
;       If flags & #__flag_Center
;          flags &~ #__flag_Center
;       EndIf
;       
;       If multiline
;          txt$+#LF$+"line"
;          flags|#__flag_TextMultiLine
;       EndIf
;       
      
      *g = Editor( X,Y,Width,Height, flags) : *g\Text\MultiLine = 0
      
      ;*g = Text( X,Y,Width,Height, txt$, flags|#__flag_TextInLine)
      ;*g = Text( X,Y,Width,Height, txt$, flags|#__flag_TextMultiLine) ; BUG
      ;*g = Text( X,Y,Width,Height, txt$, flags|#__flag_TextWordWrap)
      
      If *g\type = #__type_Editor
         If *g\Text\MultiLine
            SetText(*g,     txt$)
         EndIf
         AddItem(*g, -1, txt$)
      EndIf
   
      ProcedureReturn *g
   EndProcedure
   
  
  If Open(#PB_Any, 0, 0, 680, 60+h, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = Test( 30, 30, 200, h, "left 00000000000000000000000000000000000")
    *g2 = Test( 30+210, 30, 200, h, "0000000000000000000 center 00000000000000000000", #__flag_Top|#__flag_Center) 
    *g3 = Test( 30+420, 30, 200, h, "00000000000000000000000000000000000 right", #__flag_Top|#__flag_Right)
    
    *g4 = Splitter( 0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g5 = Splitter( 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    *g6 = Splitter( 30,30,620,h, *g5,#Null)
    
    SetState(*g4, 200)
    SetState(*g5, 200*2+#__bar_splitter_size)
    ;SetState(*g6, h)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 21
; FirstLine = 8
; Folding = -
; EnableXP
; DPIAware