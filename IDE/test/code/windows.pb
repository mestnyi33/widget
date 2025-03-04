XIncludeFile "../../ide.pb"
XIncludeFile "../../code.pbi"
;- 
CompilerIf #PB_Compiler_IsMainFile
   DisableExplicit
   
   If Open( 0, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      Window( 10, 10, 240, 200, "main window", #PB_Window_SystemMenu ) : SetClass( widget( ), "MAIN")
      Button( 21, 14, 120, 64, "button_8" )
      Button( 21, 91, 120, 71, "button_9" )
      
      Window( 40, 150, 240, 200, "window_0", #PB_Window_SystemMenu ) : SetClass( widget( ), "WINDOW_1")
      Button( 21, 14, 120, 64, "button_8" )
      Button( 21, 91, 120, 71, "button_9" )
      
      Window( 70, 300, 240, 200, "window_1", #PB_Window_SystemMenu ) : SetClass( widget( ), "WINDOW_2")
      Button( 21, 14, 120, 64, "button_8" )
      Button( 21, 91, 120, 71, "button_9" )
      
      
;       If StartEnum( root( ) )
;          AddParseObject( widget( ))
;          StopEnum( )
;       EndIf
     
   EndIf
   
   Define *root = root( )
   If Open( 1, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ResizeWindow( 0, WindowX( 0 ) - WindowWidth( 0 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ResizeWindow( 1, WindowX( 1 ) + WindowWidth( 1 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      Define *g = Editor( 0, 0, 0, 0, #__flag_autosize )
      
      Define code$ = GeneratePBCode( *root )
      
      SetText( *g, code$ )
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 24
; Folding = -
; EnableXP
; DPIAware