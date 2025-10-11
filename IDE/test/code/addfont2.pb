EnableExplicit

CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "C:\Users\user\Documents\GitHub\widget\widgets.pbi"
CompilerEndIf

UseWidgets( )

Global WINDOW_1 = - 1
Global WINDOW_2 = - 1

Global BUTTON_8 = - 1
Global BUTTON_9 = - 1
Global BUTTON_19 = - 1
Global BUTTON_10 = - 1

Global FONT_ARIAL_19 = LoadFont( #PB_Any, "Arial", 19 )
Global FONT_CONSOLAS_25_BOLD  = LoadFont( #PB_Any, "Consolas", 25, #PB_Font_Bold  )
Global FONT_CONSOLAS_16_BOLD_ITALIC  = LoadFont( #PB_Any, "Consolas", 16, #PB_Font_Bold | #PB_Font_Italic  )

Procedure Open_WINDOW_1( )
   WINDOW_1 = Open( #PB_Any, 21, 21, 323, 253, "window_1", #PB_Window_SystemMenu | #PB_Window_SizeGadget  )
     ; WINDOW_2 = Window( 10, 10, 320, 253, "window_1", #PB_Window_SystemMenu ) 
      BUTTON_8 = Button( 21, 14, 260, 64, "button_8", #__flag_TextLeft  )
         SetColor( BUTTON_8, #PB_Gadget_BackColor, $0 )
         SetFont( BUTTON_8, FONT_ARIAL_19 )
      
      BUTTON_9 = Button( 21, 91, 260, 29, "button_9", #__flag_TextRight  )
         SetFont( BUTTON_9, FONT_CONSOLAS_16_BOLD_ITALIC  )
      
      BUTTON_19 = Button( 21, 126, 260, 29, "button_19", #__flag_TextRight  )
      BUTTON_10 = Button( 21, 175, 260, 64, "button_10" )
         SetFont( BUTTON_10, FONT_CONSOLAS_25_BOLD  )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_1( )

   WaitClose( )
   End
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 22
; FirstLine = 2
; Folding = -
; EnableXP
; DPIAware