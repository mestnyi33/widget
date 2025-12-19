
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   If Open( 0, 0, 0, 300, 260, "ComboBox Upper&Lower case test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      SetBackColor( Widget(), - 1 )
      
      ComboBox( 10, 10, 280, 50, #PB_ComboBox_UpperCase )
      AddItem( Widget(), - 1, "comboBOX (UPPER)" )
      SetState( Widget(), 0 )
      
      ComboBox( 10, 70, 280, 50, #PB_ComboBox_LowerCase )
      AddItem( Widget(), - 1, "COMBObox (lower)" )
      SetState( Widget(), 0 )
      
      ComboBox( 10, 130, 280, 50, #PB_ComboBox_Editable|#PB_ComboBox_UpperCase )
      AddItem( Widget(), - 1, "comboBOX (UPPER)" )
      SetState( Widget(), 0 )
      
      ComboBox( 10, 190, 280, 50, #PB_ComboBox_Editable|#PB_ComboBox_LowerCase )
      AddItem( Widget(), - 1, "COMBObox (lower)" )
      SetState( Widget(), 0 )
      
      WaitClose( ) 
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 23
; FirstLine = 1
; Folding = -
; EnableXP
; DPIAware