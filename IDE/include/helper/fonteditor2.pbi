CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "C:\Users\user\Documents\GitHub\widget\widgets.pbi"
CompilerEndIf

UseWidgets( )
EnableExplicit

Global WINDOW_0 = - 1

Global STRING_0 = - 1
Global STRING_1 = - 1
Global STRING_2 = - 1
Global TEXT_0 = - 1
Global TEXT_1 = - 1
Global TEXT_2 = - 1
Global CONTAINER_0 = - 1
Global COMBOBOX_0 = - 1
Global CHECKBOX_0 = - 1
Global CHECKBOX_1 = - 1
Global COMBOBOX_1 = - 1
Global BUTTON_1 = - 1
Global BUTTON_0 = - 1

Procedure Open_WINDOW_0( )
   WINDOW_0 = Open( #PB_Any, 98, 98, 372, 316, "window_0",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered  )
      STRING_0 = String( 7, 7, 148, 22, "MS sans serif" )
      STRING_1 = String( 231, 7, 134, 22, "обычный" )
      STRING_2 = String( 161, 7, 64, 22, "8" )
      TEXT_0 = Tree( 7, 35, 148, 134 )
      TEXT_1 = Tree( 231, 35, 134, 134 )
      TEXT_2 = Tree( 161, 35, 64, 134 )
      CONTAINER_0 = Text( 7, 175, 218, 134, "" )
      COMBOBOX_0 = ComboBox( 231, 175, 134, 22, #PB_ComboBox_Editable )
      CHECKBOX_0 = CheckBox( 231, 203, 134, 22, "Зачеркнутый" )
         SetState( CHECKBOX_0, 1 )
      
      CHECKBOX_1 = CheckBox( 231, 231, 134, 22, "Подчеркнутый" )
         SetState( CHECKBOX_1, 1 )
      
      COMBOBOX_1 = ComboBox( 231, 259, 134, 22 )
      BUTTON_1 = Button( 231, 287, 64, 22, "Отмена" )
      BUTTON_0 = Button( 301, 287, 64, 22, "Ок" )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_0( )

   WaitClose( )
   End
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 25
; FirstLine = 12
; Folding = -
; EnableXP
; DPIAware