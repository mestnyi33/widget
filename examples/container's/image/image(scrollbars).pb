IncludePath "../../../"
XIncludeFile "widgets.pbi"

UseWidgets( )

test_iclip = 1

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
   
   
   Debug "----CLIPOUT----"
   Debug ""+*g\clip_x() +" "+*g\clip_y() +" "+*g\clip_width() +" "+*g\clip_height()
   Debug ""+*g\clip_ix() +" "+*g\clip_iy() +" "+*g\clip_iwidth() +" "+*g\clip_iheight()
   
EndProcedure


If Open(0, 100, 50, 490, 400, "ListViewGadget", #PB_Window_SystemMenu)
   Button( 400, 10, 80, 30, "1")
   Button( 400, 45, 80, 30, "2")
   Button( 400, 80, 80, 30, "3")
   Button( 400, 115, 80, 30, "4")
   Bind( #PB_All, @all_events( ), #__event_LeftClick)
   
   ; LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp") ; bug
   ;a_init(Root())
   LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp") ; good
   *g = Image(10, 10, size, size, (0)) 
   ;a_set(*g)

   ; Debug " - test show and size scroll bars - "
   ; Resize(*g,#PB_Ignore,#PB_Ignore,256,256 )
   ; Resize(*g,#PB_Ignore,#PB_Ignore,#PB_Ignore,255 )
   ; Resize(*g,#PB_Ignore,#PB_Ignore,255,#PB_Ignore )
   ; Resize(*g,#PB_Ignore,#PB_Ignore,255,255 )
   
   *s1 = Splitter( 10, 10, 380, 380, #PB_Default, *g, #PB_Splitter_Vertical )
   *s2 = Splitter( 10, 10, 380, 380, #PB_Default, *s1 )
   SetState( *s1, 0 )
   SetState( *s2, 0 )
   
   WaitClose()
EndIf


; If *this\tabbar
;                ix = *this\inner_x( )
;                iy = *this\inner_y( )
;                iwidth = *this\inner_width( )
;                iheight = *this\inner_height( )
;                
;                *this\inner_x( ) = X
;                *this\inner_y( ) = Y
;                *this\inner_width( ) = Width
;                *this\inner_height( ) = Height
;                
;                ;\\
;                If *this\tabbar\autosize
;                   Resize( *this\tabbar, *this\fs, *this\fs, iwidth, iheight )
;                Else
;                   If *this\tabbar\bar\vertical
;                      If *this\fs[1]
;                         Resize( *this\tabbar, *this\fs, *this\fs, *this\fs[1], iheight )
;                      EndIf
;                      If *this\fs[3]
;                         Resize( *this\tabbar, *this\fs + iwidth, *this\fs, *this\fs[3], iheight )
;                      EndIf
;                   Else
;                      If *this\fs[2]
;                         Resize( *this\tabbar, *this\fs, *this\fs + *this\TitleBarHeight + *this\MenuBarHeight, iwidth, *this\ToolBarHeight )
;                      EndIf
;                      If *this\fs[4]
;                         Resize( *this\tabbar, *this\fs, *this\fs + iheight, iwidth, *this\fs[4] )
;                      EndIf
;                   EndIf
;                EndIf
;                
;                *this\inner_x( ) = ix
;                *this\inner_y( ) = iy
;                *this\inner_width( ) = iwidth
;                *this\inner_height( ) = iheight
;             EndIf
            
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 99
; FirstLine = 75
; Folding = -
; EnableXP
; DPIAware