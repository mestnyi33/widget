CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../../widgets.pbi"
CompilerEndIf

UseWidgets( )
EnableExplicit

Global EDITORFONTS = - 1

Global STRING_FONT = - 1
Global STRING_1 = - 1
Global STRING_SIZE = - 1
Global TREE_FONT = - 1
Global TREE_1 = - 1
Global TREE_SIZE = - 1
Global TREE_4 = - 1
Global CHECKBOX_0 = - 1
Global CHECKBOX_1 = - 1
Global COMBOBOX_0 = - 1
Global COMBOBOX_1 = - 1
Global BUTTON_0 = - 1
Global BUTTON_1 = - 1
Global COMBOBOX_2 = - 1

Procedure Open_EDITORFONTS( )
   EDITORFONTS = Open( #PB_Any, 84, 84, 386, 260, "EDITORFONTS",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered  )
      STRING_FONT = String( 7, 7, 148, 22, "MS sans serif" ) : SetRound( Widget( ), 10 )
      STRING_1 = String( 231, 7, 148, 22, "обычный" ) : SetRound( Widget( ), 10 )
      STRING_SIZE = String( 161, 7, 64, 22, "8" ) : SetRound( Widget( ), 10 )
      TREE_FONT = Tree( 7, 35, 148, 78 ) : SetRound( Widget( ), 10 )
      TREE_SIZE = Tree( 161, 35, 64, 78 ) : SetRound( Widget( ), 10 )
      TREE_1 = Tree( 231, 35, 148, 78 ) : SetRound( Widget( ), 10 )
      TREE_4 = Text( 7, 147, 218, 106, "Образец" ) : SetRound( Widget( ), 10 )
      COMBOBOX_0 = ComboBox( 231, 119, 148, 22 ) : SetRound( Widget( ), 10 )
      COMBOBOX_1 = ComboBox( 7, 119, 148, 22 ) : SetRound( Widget( ), 10 )
      COMBOBOX_2 = ComboBox( 161, 119, 64, 22 ) : SetRound( Widget( ), 10 )
      
;       CHECKBOX_0 = Button( 231, 147, 148, 22, "Зачеркнутый",#PB_Button_Toggle,10 )
;       CHECKBOX_1 = Button( 231, 175, 148, 22, "Подчеркнутый",#PB_Button_Toggle,10 )
      ;
      CHECKBOX_0 = Text( 231, 147, 148, 22, "Зачеркнутый", #__flag_Textcenter ) : SetRound( CHECKBOX_0, 10 )
      CHECKBOX_0 = CheckBox( 231+4, 147, 148-8, 22, " ", #__flag_Borderless|#__flag_Transparent )
      CHECKBOX_1 = Text( 231, 175, 148, 22, "Подчеркнутый", #__flag_Textcenter ) : SetRound( CHECKBOX_1, 10 )
      CHECKBOX_1 = CheckBox( 231+4, 175, 148-8, 22, " ", #__flag_Borderless|#__flag_Transparent )
      ;
;       CHECKBOX_0 = CheckBox( 231, 147, 148, 22, "Зачеркнутый", #__flag_Borderless|#__flag_Transparent )
;       CHECKBOX_1 = CheckBox( 231, 175, 148, 22, "Подчеркнутый", #__flag_Borderless|#__flag_Transparent )
      
      BUTTON_0 = Button( 231, 203, 148, 22, "Ок",0,10 )
      BUTTON_1 = Button( 231, 231, 148, 22, "Отмена",0,10 )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_EDITORFONTS( )

   WaitClose( )
   End
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; DPIAware