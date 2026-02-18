XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   Global._s_WIDGET *g
   
   
   Procedure AddCaption( *this._s_WIDGET, Height, Text.s, Flag.q = #__flag_Left ) 
      Protected *g._s_WIDGET
      Protected position = 2
      *this\fs[position] = Height
      
      If position = 1
         *g = Button( 0,0,Height,0, Text.s, Flag|#__flag_Vertical )
         SetParent( *g, *this, #PB_Ignore )
         SetAlign( *g, 0, 1,#__align_auto,0,#__align_auto, 0 )              
      EndIf
      If position = 2
         *g = Button( 0,0,0,Height, Text.s, Flag )
         SetParent( *g, *this, #PB_Ignore )
         SetAlign( *g, 0, #__align_auto,1,#__align_auto,0, 0 )              
      EndIf
      If position = 3
         *g = Button( 0,0,Height,0, Text.s, Flag|#__flag_Vertical )
         SetParent( *g, *this, #PB_Ignore )
         SetAlign( *g, 0, 0,#__align_auto,1,#__align_auto, 0 )              
      EndIf
      If position = 4
         *g = Button( 0,0,0,Height, Text.s, Flag )
         SetParent( *g, *this, #PB_Ignore )
         SetAlign( *g, 0, #__align_auto,0,#__align_auto,1, 0 )              
      EndIf
   EndProcedure
   
   
  
   
   Open(0, 0, 0, 400, 150, "ListIcon - Add Columns", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ;*g = Panel(0,0,0,0, #__flag_BorderLess) : CloseList(); 
   ;*g = Container(0,0,0,0, #__flag_BorderLess) : CloseList(); 
   *g = Container(0,0,0,0, #__flag_Borderflat) : CloseList(); 
   ;*g = Tree(0,0,0,0, #__flag_BorderLess)
   ;*g\fs[2] = 30
   ;AddButtons( *g, Button(0,0,100,*g\fs[2], "column"), #__align_Full )
   AddCaption( *g, 30, "column" ) 
      
   ;Resize( *g, 30,30,100,100 )
   Splitter( 10,10,380,130, *g,-1, #PB_Splitter_Vertical )
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 40
; FirstLine = 19
; Folding = --
; EnableXP
; DPIAware