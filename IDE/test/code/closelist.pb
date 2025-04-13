CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../ide.pb"
   XIncludeFile "../../code.pbi"
CompilerEndIf

DisableExplicit

If Open( 0, 0, 0, 350, 280, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
   
   TEST = Window( 10, 10, 320, 253, "",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
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
      
      SetBackColor( _1, $BA54EDDE )
      
;       If StartEnum( root( ) )
;          AddParseObject( widget( ))
;          StopEnum( )
;       EndIf
     
   EndIf
   
CompilerIf #PB_Compiler_IsMainFile
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 34
; FirstLine = 11
; Folding = -
; EnableXP
; DPIAware