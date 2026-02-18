XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   Global._s_WIDGET *g
   
   Open(0, 0, 0, 400, 150, "ListIcon - Add Columns", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ;*g = Panel(0,0,0,0, #__flag_BorderLess) : CloseList(); 
   *g = Container(0,0,0,0, #__flag_BorderLess) : CloseList(); 
   ;*g = Tree(0,0,0,0, #__flag_BorderLess)
   *g\fs[2] = 30
   AddButtons( *g, Button(0,0,100,*g\fs[2], "column"), #__align_Full )
   
   ;Resize( *g, 30,30,100,100 )
   Splitter( 10,10,380,130, *g,-1, #PB_Splitter_Vertical )
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 9
; Folding = -
; EnableXP
; DPIAware