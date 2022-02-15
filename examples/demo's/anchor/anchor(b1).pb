;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../CE.pb" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib( WIDGET )
  
  If Open(OpenWindow(#PB_Any, 0, 0, 800, 450, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    a_init(root())
    SetColor(root(), #__color_back, RGBA(128, 192, 64, 125))
    
    Object(20, 20, 200, 100, "Layer = 1", RGBA(128, 192, 64, 125))
    Object(320, 20, 200, 100, "Layer = 2", RGBA(192, 64, 128, 125))
    Object(20, 320, 200, 100, "Layer = 3", RGBA(92, 64, 128, 125))
    Object(320, 320, 200, 100, "Layer = 4", RGBA(192, 164, 128, 125))
    
    WaitClose( )
  EndIf
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP