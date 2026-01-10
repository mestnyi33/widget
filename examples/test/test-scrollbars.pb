IncludePath "../../"
XIncludeFile "widgets.pbi"

UseWidgets( )

Global._S_widget *g, *s1, *s2
Global size = 370

Procedure all_events( )
   ClearDebugOutput( )
   
   Resize(*g,#PB_Ignore,#PB_Ignore, size, size )
   Debug " ------- test show and size scroll bars ------- "
   
   Select GetText( EventWidget())
      Case "1"
         Resize(*g,#PB_Ignore,#PB_Ignore,256,256 )
      Case "2"
         Resize(*g,#PB_Ignore,#PB_Ignore,#PB_Ignore,255 )
      Case "3"
         Resize(*g,#PB_Ignore,#PB_Ignore,255,#PB_Ignore )
      Case "4"
         Resize(*g,#PB_Ignore,#PB_Ignore,255,255 )
   EndSelect
   
   Debug "-------"
   Debug ""+*g\clip_x() +" "+*g\clip_y() +" "+*g\clip_width() +" "+*g\clip_height()
   Debug ""+*g\clip_ix() +" "+*g\clip_iy() +" "+*g\clip_iwidth() +" "+*g\clip_iheight()
   
EndProcedure

Procedure Test( Type, img )
   Protected._S_widget *g
   
   If Type = #__type_ScrollArea
      *g = ScrollArea(10, 10, size, size, ImageWidth(img), ImageHeight(img), 1, #PB_ScrollArea_Single)   
      ; SetFrame( *g, 10 )
      Button( 0,0, ImageWidth(img), ImageHeight(img), "scroll inner size")
      SetBackgroundColor( *g, $ff0000ff )
      CloseList( ) 
   EndIf
   
   If Type = #__type_Image
      *g = Image(10, 10, size, size, (img)) 
   EndIf
   
   ProcedureReturn *g
EndProcedure


If Open(0, 100, 50, 490, 400, "ListViewGadget", #PB_Window_SystemMenu)
   Button( 400, 10, 80, 30, "1")
   Button( 400, 45, 80, 30, "2")
   Button( 400, 80, 80, 30, "3")
   Button( 400, 115, 80, 30, "4")
   Bind( #PB_All, @all_events( ), #__event_LeftClick)
   
   ;a_init(Root())
   Define img = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
   
   *g = Test( #__type_ScrollArea, img )
   ; *g = Test( #__type_Image, img )
   ;a_set(*g)
   
   *s1 = Splitter( 10, 10, 380, 380, #PB_Default, *g, #PB_Splitter_Vertical )
   *s2 = Splitter( 10, 10, 380, 380, #PB_Default, *s1 )
   SetState( *s1, 0 )
   SetState( *s2, 0 )
   
   
   WaitClose()
EndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 36
; FirstLine = 26
; Folding = --
; EnableXP
; DPIAware