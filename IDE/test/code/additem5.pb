CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../ide.pb"
   XIncludeFile "../../code.pbi"
CompilerEndIf

DisableExplicit

If Open( 0, 0, 0, 350, 280, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
   
   TEST = Window( 10, 10, 320, 253, "",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
   PANEL_0=Panel(8, 8, 356, 203)
   AddItem(PANEL_0, -1, "Панель 1")
   AddItem(PANEL_0, -1, "Панель 2")
   AddItem(PANEL_0, -1, "Панель 3")
   
   SetState( PANEL_0, 2 )
   
   PANEL_1=Panel( 5, 30, 340, 166)
   AddItem(PANEL_1, -1, "Под-Панель 1")
   AddItem(PANEL_1, -1, "Под-Панель 2")
   AddItem(PANEL_1, -1, "Под-Панель 3")
   
   SetState( PANEL_1, 2 )
   
   PANEL_2=Panel( 5, 30, 340, 166)
   AddItem(PANEL_2, -1, "Под-Под-Панель 1")
   AddItem(PANEL_2, -1, "Под-Под-Панель 2")
   AddItem(PANEL_2, -1, "Под-Под-Панель 3")
   
   SetState( PANEL_2, 2 )
   CloseList( )   
   CloseList( )   
   CloseList( )   
   
   
   ;       If StartEnum( root( ) )
   ;          AddParseObject( widget( ))
   ;          StopEnum( )
   ;       EndIf
   
EndIf

CompilerIf #PB_Compiler_IsMainFile
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 22
; FirstLine = 7
; Folding = -
; EnableXP
; DPIAware