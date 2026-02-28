XIncludeFile "../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define h = 100, bh = 26, *g1, *g2, *g3, *g4, *g5, *g6
  Procedure Test( X,Y,Width,Height, txt$, flags.q=0 )
      Protected._s_WIDGET *g  
      Protected img = 1
      
      If flags & #__flag_Center
         flags &~ #__flag_Center
        ; flags |  ;| #__flag_Left
      EndIf
      
;       If word$ = #LF$
;         ; txt$+#LF$+"line"
;        ;  flags|#__flag_TextMultiLine
;       EndIf
      
      ;txt$ = ""
      ;img =- 1
      
      *g = Editor( X,Y,Width,Height, flags|#__flag_Center) : SetText( *g, txt$ ) 
      ;*g = EditorGadget(-1, X,Y,Width,Height, flags|#PB_Editor_WordWrap) : SetGadgetText( *g, txt$ ) 
      
      ProcedureReturn *g
   EndProcedure
   
   If Open( #PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
    
    *g1 = Test(     30, 30, 200, h, "left 00000000000000000000000000000000000", #__flag_Left )
    *g2 = Test( 30+210, 30, 200, h, "0000000000000000 center 0000000000000000", #__flag_Center )
    *g3 = Test( 30+420, 30, 200, h, "0000000000000000000000000000000000 right", #__flag_Right )
    
    *g4 = Splitter(  0, 0,  0,0, *g1,*g2, #PB_Splitter_Vertical | #PB_Splitter_FirstFixed )
    *g5 = Splitter( 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical )
    *g6 = Splitter( 30,30,620,h, *g5,#Null )
    
    SetState( *g4, 200 )
    SetState( *g5, 200*2+#__bar_splitter_size )
    SetState( *g6, h )
    
    Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 12
; FirstLine = 6
; Folding = -
; EnableXP