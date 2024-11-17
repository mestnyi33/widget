XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  If Open( 1, 150, 150, 649, 441, "button - draw parent-inner-clip coordinate", #__Window_SizeGadget | #__Window_SystemMenu)
    a_init( root( ) )
    Define scrollstep = a_transform()\grid_size
    
    SetWidgetColor(ScrollAreaWidget(30,30,450-2,250-2, 440,750, scrollstep), #__color_back, $C0F2AEDA)
    
    ButtonWidget(60,60,450,250,"button")
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP