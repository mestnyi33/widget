XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  If Open(0, 0, 0, 430, 440, "Container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    
    Container( 100,100,200,100, #__flag_Flat ) 
    ToolBar( widget( ) )
    CloseList( )
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 9
; Folding = -
; EnableXP