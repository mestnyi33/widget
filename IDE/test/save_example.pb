EnableExplicit

CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "C:\Users\user\Documents\GitHub\widget\widgets.pbi"
CompilerEndIf

UseWidgets( )
UsePNGImageDecoder( )

Global WINDOW_0 = - 1

Global EDITOR_VIEW = - 1
Global BUTTON_ADD = - 1
Global BUTTON_DELETE = - 1

Procedure all_events( )
   
EndProcedure

Procedure Open_WINDOW_0( )
   WINDOW_0 = Open( #PB_Any, 7, 7, 411, 253, "window_0", #PB_Window_SystemMenu | #PB_Window_SizeGadget  )
      EDITOR_VIEW = Editor( 14, 14, 382, 166 )
      BUTTON_ADD = Button( 14, 187, 181, 51, "добавить" )
      BUTTON_DELETE = Button( 209, 187, 188, 51, "удалить" )
      Bind(#PB_All, @all_events())
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_0( )

   WaitClose( )
   End
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 16
; Folding = -
; EnableXP
; DPIAware