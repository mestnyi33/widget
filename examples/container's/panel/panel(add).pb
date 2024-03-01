
XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global._s_widget *PANEL_1, *PANEL_2
  
  If Open(3, 0, 0, 400, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *PANEL_1 = Panel (30, 30, 340, 240)
    AddItem(*PANEL_1, -1, "*PANEL_1 - 1")
    CloseList( ) ; close *PANEL_1 list
    
    OpenList( *PANEL_1, GetState( *PANEL_1 ) ) 
    Button( 10,10,80,30,"Button1")
    CloseList( )
    OpenList( *PANEL_1, GetState( *PANEL_1 ) ) 
    Button( 10,45,80,30,"Button2")
    CloseList( )
    OpenList( *PANEL_1, GetState( *PANEL_1 ) ) 
    Button( 10,80,80,30,"Button3")
    CloseList( )
    
    AddItem(*PANEL_1, -1, "*PANEL_1 - 3")
    
    ;OpenList( *PANEL_1, 2 )
    Debug GetState( *PANEL_1 )
    OpenList( *PANEL_1, GetState( *PANEL_1 ) ) 
    Debug Opened( )\TabBox( )\OpenedTabIndex( )
    Button( 200,10,80,30,"Button4")
    CloseList( )
    Debug GetState( *PANEL_1 )
    OpenList( *PANEL_1, GetState( *PANEL_1 ) ) 
    Button( 200,45,80,30,"Button5")
    CloseList( )
    Debug GetState( *PANEL_1 )
    OpenList( *PANEL_1, GetState( *PANEL_1 ) ) 
    Button( 200,80,80,30,"Button6")
    CloseList( )
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 24
; FirstLine = 10
; Folding = -
; EnableXP