CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../ide.pb"
   XIncludeFile "../../code.pbi"
CompilerEndIf

DisableExplicit


If Open( 0, 0, 0, 322, 600, "main window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) : SetClass( widget( ), "MAIN")
   
   Window( 10, 10, 148, 175, "window_0", #PB_Window_SystemMenu ) : SetClass( widget( ), "WINDOW_0")
   Button( 14, 14, 120, 64, "button_1" )
   Button( 14, 91, 120, 71, "button_2" )
   
   Window( 60, 120, 148, 175, "window_1", #PB_Window_SystemMenu ) : SetClass( widget( ), "WINDOW_1")
   Button( 14, 14, 120, 64, "button_3" )
   Button( 14, 91, 120, 71, "button_4" )
   
   Window( 110, 240, 148, 175, "window_2", #PB_Window_SystemMenu ) : SetClass( widget( ), "WINDOW_2")
   Button( 14, 14, 120, 64, "button_5" )
   Button( 14, 91, 120, 71, "button_6" )
   
EndIf

CompilerIf #PB_Compiler_IsMainFile
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 20
; Folding = -
; EnableXP
; DPIAware