CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../ide.pb"
   XIncludeFile "../../code.pbi"
CompilerEndIf

DisableExplicit

If Open( 0, 0, 0, 350, 280, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
   
   TEST = Window( 10, 10, 320, 253, "",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
   PANEL_0=Panel(8, 8, 356, 203)
   
   PANEL_1=Panel( 5, 30, 340, 166)
   AddItem(PANEL_1, -1, "Под-Панель 1")
   AddItem(PANEL_1, -1, "Под-Панель 2")
   AddItem(PANEL_1, -1, "Под-Панель 3")
   AddItem(PANEL_1, -1, "Под-Панель 4")
   
   AddItem(PANEL_0, -1, "Панель 3")
   AddItem(PANEL_0, -1, "Панель 4")
   Button( 10,10,50,30, "")
   
   
   ;       If StartEnum( root( ) )
   ;          AddParseObject( widget( ))
   ;          StopEnum( )
   ;       EndIf
   
EndIf

CompilerIf #PB_Compiler_IsMainFile
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 32
; Folding = -
; EnableXP
; DPIAware