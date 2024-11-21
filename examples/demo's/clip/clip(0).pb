XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  If Open( 1, 150, 150, 649, 441, "button - draw parent-inner-clip coordinate", #__Window_SizeGadget | #__Window_SystemMenu)
    a_init( root( ) )
    Define scrollstep = mouse( )\steps
    
    SetColor(ScrollArea(30,30,450-2,250-2, 440,750, scrollstep), #__color_back, $C0F2AEDA)
    
    Button(60,60,450,250,"button")
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 8
; Folding = -
; EnableXP