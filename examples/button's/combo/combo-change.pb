XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global *g
   Global h = 100
   Global item = 1
   
   Procedure Change_events( )
      Debug "["+ WidgetEventItem( )+"] event change item"
   EndProcedure
   
   If Open(0, 0, 0, 360, 60+h, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *g = ComboBox( 30, 30, 300, h, #__flag_Right)
      AddItem(*g, -1, "[0] item" )
      AddItem(*g, -1, "[1] item" )
      AddItem(*g, -1, "[2] item" )
      SetState(*g, item)
      Bind(*g, @Change_events(), #__event_change)
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 11
; Folding = -
; EnableXP
; DPIAware