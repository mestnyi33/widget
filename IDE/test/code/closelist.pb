XIncludeFile "../../ide.pb"
XIncludeFile "../../code.pbi"
;- 
CompilerIf #PB_Compiler_IsMainFile
   DisableExplicit
   Define Width = 350
   
   If Open( 0, 0, 0, Width, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      TEST = Window( 0, 0, 582, 582, "",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
      ;
      _0 = Container(7, 7, 568, 568,  #PB_Container_Single  )
         _1 = Container(7, 7, 274, 274,  #PB_Container_Single  )
            ;
            _2 = Container(7, 7, 127, 127,  #PB_Container_Single  )
               _3 = Container(7, 7, 50, 50,  #PB_Container_Single  )
                  _4 = Container(7, 7, 15, 15,  #PB_Container_Single  )
                     _5 = Container(7, 7, 15, 15,  #PB_Container_Single  )
                        _6 = Container(7, 7, 15, 15,  #PB_Container_Single  )
                        CloseList( )
                        ;
                        _7 = Container(28, 7, 15, 15,  #PB_Container_Single  )
                        CloseList( )
                     CloseList( )
                  CloseList( )
               CloseList( )
            CloseList( )
            ;
            _8 = Container(143, 7, 127, 127,  #PB_Container_Single  )
            CloseList( )
         CloseList( )
      CloseList( )
      ;
      
      SetBackgroundColor( _1, $BA54EDDE )
      
;       If StartEnum( root( ) )
;          AddParseObject( widget( ))
;          StopEnum( )
;       EndIf
     
   EndIf
   
   Define *root = root( )
   If Open( 1, 0, 0, Width*2, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ResizeWindow( 0, WindowX( 0 ) - WindowWidth( 1 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ResizeWindow( 1, WindowX( 1 ) + WindowWidth( 0 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      Define *g = Editor( 0, 0, 0, 0, #__flag_autosize )
      
      Define code$ = GeneratePBCode( *root )
      
      SetText( *g, code$ )
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 39
; FirstLine = 17
; Folding = -
; EnableXP
; DPIAware