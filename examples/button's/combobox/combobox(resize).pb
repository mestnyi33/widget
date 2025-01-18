XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define h = 100
  Global *g1, *g2, *g3, *g4, *g5, *g6, *g7
  
  Procedure Change_events( )
     Select WidgetEventItem( )
        Case 0 
           Debug 0
        Case 1
           Debug 1
     EndSelect
  EndProcedure
  
  If Open(#PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = ComboBox( 30, 30, 200, h)
    AddItem(*g1, -1, "left 00000000000000000000000000000000000")
    SetState(*g1,0)
    
    *g2 = ComboBox( 30+210, 30, 200, h, #__text_Center|#__text_Top)
    AddItem(*g2, -1, "0000000000000000000 center 00000000000000000000" )
    SetState(*g2,0)
    
    *g3 = ComboBox( 30+420, 30, 200, h, #__text_Right|#__text_Top)
    AddItem(*g3, -1, "00000000000000000000000000000000000 right" )
    SetState(*g3,0)
    
    *g4 = ComboBox( 30+420, 30, 200, h, #__text_Right|#__text_Top)
    AddItem(*g4, -1, "no editable" )
    AddItem(*g4, -1, "editable" )
    SetState(*g4,0)
    Bind(*g4, @Change_events(), #__event_change)
    
    *g5 = Splitter( 0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g6 = Splitter( 30,30,620,h, *g5,*g3, #PB_Splitter_Vertical)
    *g7 = Splitter( 30,30,620,h, *g6,*g4)
    
    SetState(*g5, 200)
    SetState(*g6, 200*2+#__bar_splitter_size)
    ;SetState(*g6, h)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 24
; FirstLine = 20
; Folding = -
; EnableXP