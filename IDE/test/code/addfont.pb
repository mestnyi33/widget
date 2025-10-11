CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../../widgets.pbi"
   UseWidgets( )
CompilerEndIf

DisableExplicit

#my_font_2 = 2

LoadFont(1, "Arial", 19 )
; LoadFont(2, "Consolas", 21, #PB_Font_Bold )
LoadFont(#my_font_2, "Consolas", 16, #PB_Font_Bold|#PB_Font_Italic )
my_font_2 = LoadFont(#PB_Any, "Consolas", 25, #PB_Font_Bold )

If Open( 0, 0, 0, 350, 280, "demo font", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
   
   WINDOW_1 = Window( 10, 10, 320, 253, "window_1" ) 
   SetClass( WINDOW_1, "WINDOW_1")
   BUTTON_8 = Button( 21, 14, 260, 64, "button_8", #PB_Button_Left )
   SetFont( BUTTON_8, (1))
   SetColor( BUTTON_8, #PB_Gadget_BackColor, (0))
   BUTTON_9 = Button( 21, 91, 260, 30, "button_9", #__flag_TextRight )
   ;SetFont( BUTTON_9, (2))
   SetFont( BUTTON_9, (#my_font_2))
   BUTTON_19 = Button( 21, 126, 260, 30, "button_19", #__flag_TextRight )
   ;SetFont( BUTTON_19, (2))
   SetFont( BUTTON_19, (#my_font_2))
   
   BUTTON_10 = Button( 21, 175, 260, 64, "button_10" )
   SetFont( BUTTON_10, (my_font_2))
   SetColor( BUTTON_8, #PB_Gadget_FrontColor, (0))
   
   
   SetFont( BUTTON_19, #PB_Default )
   
EndIf

CompilerIf #PB_Compiler_IsMainFile
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 33
; Folding = -
; EnableXP
; DPIAware