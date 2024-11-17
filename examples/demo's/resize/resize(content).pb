XIncludeFile "../../../widgets.pbi"
UseWidgets( )
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
    
  If OpenRootWidget(0, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    
    ;*g4 = SplitterWidget( 0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g4 = ContainerWidget( 0,0,0,0 ) 
;     ButtonWidget( 0,   0,0,bh, text, #__flag_Textright) : SetAlign( widget( ), #__align_left|#__align_right)
;     StringWidget( 0,bh*1,0,bh, text, #__flag_Textright) : SetAlign( widget( ), #__align_left|#__align_right)
;     TextWidget( 0,bh*2,0,bh, text, #__flag_Textright) : SetAlign( widget( ), #__align_left|#__align_right)
     EditorWidget( 0,bh*3,0,bh, #__flag_Textright) : SetTextWidget( widget( ), text) ;: SetAlignmentFlag( widget( ), #__align_left|#__align_right)
    ;ButtonWidget( 0,bh*4,0,bh, text, #__flag_Textright) : SetAlign( widget( ), #__align_left|#__align_right)
    
    CloseWidgetList( )
    
    *g5 = SplitterWidget( 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    ;*g6 = SplitterWidget( 30,30,620,h, *g5,#Null)
    
    ;SetState(*g4, 200)
    SetState(*g5, 200*2)
    ;SetState(*g6, h)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP