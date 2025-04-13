
IncludePath "../../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   If Open( 0, 0, 0, 300, 130, "ComboBox Upper&Lower case test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      SetBackColor( widget(), - 1 )
      
      ComboBox( 10, 10, 280, 50, #PB_ComboBox_UpperCase )
      AddItem( widget(), - 1, "comboBOX"+" (UPPER)" )
      SetState( widget(), 0 )
      
      ComboBox( 10, 70, 280, 50, #PB_ComboBox_LowerCase )
      AddItem( widget(), - 1, "COMBObox"+" (lower)" )
      SetState( widget(), 0 )
      
      WaitClose( ) 
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 8
; Folding = -
; EnableXP
; DPIAware