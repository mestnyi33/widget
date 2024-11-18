XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define h = 185, bh = 26, *g1, *g2, *g3, *g4, *g5, *g6
  If OpenRoot( #PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
    
    *g1 = StringWidget(     30, 30, 200, h, "left 00000000000000000000000000000000000" )
    *g2 = StringWidget( 30+210, 30, 200, h, "0000000000000000 center 0000000000000000", #__flag_Textcenter )
    *g3 = StringWidget( 30+420, 30, 200, h, "00000000000000000000000000000000000 right", #__flag_Textright )
    
    *g4 = SplitterWidget(  0, 0,  0,0, *g1,*g2, #PB_Splitter_Vertical | #PB_Splitter_FirstFixed )
    *g5 = SplitterWidget( 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical )
    *g6 = SplitterWidget( 30,30,620,h, *g5,#Null )
    
    SetWidgetState( *g4, 200 )
    SetWidgetState( *g5, 200*2+#__splittersize )
    ;SetWidgetState( *g6, h )
    
    Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 4
; Folding = -
; EnableXP