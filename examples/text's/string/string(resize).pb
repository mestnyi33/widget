XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib( widget )
  
  Define h = 185, bh = 26, *g1, *g2, *g3, *g4, *g5, *g6
  If Open( #PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
    
    *g1 = String(     30, 30, 200, h, "left 00000000000000000000000000000000000" )
    *g2 = String( 30+210, 30, 200, h, "0000000000000000000 center 00000000000000000000", #__string_center )
    *g3 = String( 30+420, 30, 200, h, "00000000000000000000000000000000000 right", #__string_right )
    
    *g4 = Splitter(  0, 0,  0,0, *g1,*g2, #PB_Splitter_Vertical | #PB_Splitter_FirstFixed )
    *g5 = Splitter( 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical )
    *g6 = Splitter( 30,30,620,h, *g5,#Null )
    
    SetState( *g4, 200 )
    SetState( *g5, 200*2 )
    SetState( *g6, h )
    
    Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 19
; Folding = -
; EnableXP