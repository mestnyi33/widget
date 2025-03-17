CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../ide.pb"
   XIncludeFile "../../code.pbi"
CompilerEndIf

DisableExplicit

#my_font_2 = 2

LoadFont(1, "Arial", 19 )
; LoadFont(2, "Consolas", 21, #PB_Font_Bold )
LoadFont(#my_font_2, "Consolas", 16, #PB_Font_Bold )
my_font_2 = LoadFont(#PB_Any, "Consolas", 25, #PB_Font_Bold )

If Open( 0, 0, 0, 350, 280, "demo font", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
   
   WINDOW_1 = Window( 10, 10, 320, 253, "window_1" ) 
   SetClass( WINDOW_1, "WINDOW_1")
   BUTTON_8 = Button( 21, 14, 120, 64, "button_8" )
   SetFont( BUTTON_8, (1))
   SetColor( BUTTON_8, #PB_Gadget_BackColor, (0))
   BUTTON_9 = Button( 21, 91, 120, 71, "button_9" )
   ;SetFont( BUTTON_9, (2))
   SetFont( BUTTON_9, (#my_font_2))
   BUTTON_10 = Button( 21, 175, 120, 64, "button_10" )
   SetFont( BUTTON_10, (my_font_2))
   
EndIf

CompilerIf #PB_Compiler_IsMainFile
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; Folding = -
; EnableXP
; DPIAware