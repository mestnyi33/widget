XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   Global._s_WIDGET *g
   
   
   Procedure AddCaption( *this._s_WIDGET, position, Height, Text.s, Flag.q = #__FLAG_Left ) 
      Protected *g._s_WIDGET
      ;Protected position = 4
      *this\fs[position] = Height
      
      If position = 1
         *g = Button( 0,0,Height,0, Text.s, Flag|#__FLAG_Vertical )
         SetParent( *g, *this, #PB_Ignore )
         SetAlign( *g, 0, 1,#__FLAG_auto,0,#__FLAG_auto, 0 )              
      EndIf
      If position = 2
         *g = Button( 0,0,0,Height, Text.s, Flag )
         SetParent( *g, *this, #PB_Ignore )
         SetAlign( *g, 0, #__FLAG_auto,1,#__FLAG_auto,0, 0 )              
      EndIf
      If position = 3
         *g = Button( 0,0,Height,0, Text.s, Flag|#__FLAG_Vertical|#__FLAG_invert )
         SetParent( *g, *this, #PB_Ignore )
         SetAlign( *g, 0, 0,#__FLAG_auto,1,#__FLAG_auto, 0 )              
      EndIf
      If position = 4
         *g = Button( 0,80,100,Height, Text.s, Flag )
         SetParent( *g, *this, #PB_Ignore )
         SetAlign( *g, 0, #__FLAG_auto,0,#__FLAG_auto,1, 0 )              
      EndIf
   EndProcedure
   
   
  
   
   Open(0, 0, 0, 400, 150, "ListIcon - Add Columns", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ;*g = Panel(0,0,0,0, #__FLAG_BorderLess) : CloseList(); 
   ;*g = Container(0,0,0,0, #__FLAG_BorderLess) : CloseList(); 
   *g = Container(0,0,0,0) 
   Button(0,0,0,0, "inner1", #__FLAG_autosize)
   CloseList(); 
   AddCaption( *g, 1, 30, "column" ) 
   
   *g1 = Container(0,0,0,0) 
   Button(0,0,0,0, "inner2", #__FLAG_autosize)
   CloseList(); 
   AddCaption( *g1, 3, 30, "column" ) 
    
   ;Resize( *g, 30,30,100,100 )
   Splitter( 10,10,380,130, *g,*g1, #PB_Splitter_Vertical )
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 46
; FirstLine = 23
; Folding = --
; EnableXP
; DPIAware