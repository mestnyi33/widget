CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../ide.pb"
   XIncludeFile "../../code.pbi"
CompilerEndIf

DisableExplicit


If Open( 0, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
   
   Window( 10, 10, 240, 175, "main window", #PB_Window_SystemMenu ) : SetClass( widget( ), "MAIN")
   Button( 14, 14, 120, 64, "button_8" )
   Button( 14, 91, 120, 71, "button_9" )
   
   Window( 40, 150, 240, 175, "window_0", #PB_Window_SystemMenu ) : SetClass( widget( ), "WINDOW_1")
   Button( 14, 14, 120, 64, "button_8" )
   Button( 14, 91, 120, 71, "button_9" )
   
   Window( 70, 300, 240, 175, "window_1", #PB_Window_SystemMenu ) : SetClass( widget( ), "WINDOW_2")
   Button( 14, 14, 120, 64, "button_8" )
   Button( 14, 91, 120, 71, "button_9" )
   
   
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