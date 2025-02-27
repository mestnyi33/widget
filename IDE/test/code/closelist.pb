XIncludeFile "../../ide.pb"
XIncludeFile "../../code.pbi"
;- 
CompilerIf #PB_Compiler_IsMainFile
   DisableExplicit
   
   If Open( 0, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
       TEST = Window( 0, 0, 582, 582, "",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
      R1 = Container(7, 7, 568, 568,  #PB_Container_Single  )
         R1Y1 = Container(7, 7, 274, 274,  #PB_Container_Single  )
            R1Y1G1 = Container(7, 7, 127, 127,  #PB_Container_Single  )
               R1Y1G1B1 = Container(7, 7, 50, 50,  #PB_Container_Single  )
                  R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
                  CloseList( )
                  
; ;                   R1Y1G1B1P2 = Container(28, 7, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
; ;                   
; ;                   R1Y1G1B1P3 = Container(7, 28, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
; ;                   
; ;                   R1Y1G1B1P4 = Container(28, 28, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
;                CloseList( )
;                
;                R1Y1G1B2 = Container(63, 7, 50, 50,  #PB_Container_Single  )
;                   R1Y1G1B2P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;                   CloseList( )
;                   
; ;                   R1Y1G1B2P2 = Container(28, 7, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
; ;                   
; ;                   R1Y1G1B2P3 = Container(7, 28, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
; ;                   
; ;                   R1Y1G1B2P4 = Container(28, 28, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
;                CloseList( )
;                
;                R1Y1G1B3 = Container(7, 63, 50, 50,  #PB_Container_Single  )
;                   R1Y1G1B3P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;                   CloseList( )
;                   
; ;                   R1Y1G1B3P2 = Container(28, 7, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
; ;                   
; ;                   R1Y1G1B3P3 = Container(7, 28, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
; ;                   
; ;                   R1Y1G1B3P4 = Container(28, 28, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
;                CloseList( )
;                
;                R1Y1G1B4 = Container(63, 63, 50, 50,  #PB_Container_Single  )
;                   R1Y1G1B4P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;                   CloseList( )
;                   
; ;                   R1Y1G1B4P2 = Container(28, 7, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
; ;                   
; ;                   R1Y1G1B4P3 = Container(7, 28, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
; ;                   
; ;                   R1Y1G1B4P4 = Container(28, 28, 15, 15,  #PB_Container_Single  )
; ;                   CloseList( )
               CloseList( )
            CloseList( )
         CloseList( )
      CloseList( )

      
      If StartEnum( root( ) )
         AddParseObject( widget( ))
         StopEnum( )
      EndIf
     
   EndIf
   
   Define *root = root( )
   If Open( 1, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ResizeWindow( 0, WindowX( 0 ) - WindowWidth( 0 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ResizeWindow( 1, WindowX( 1 ) + WindowWidth( 1 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      Define *g = Editor( 0, 0, 0, 0, #__flag_autosize )
      
      Define code$ = GeneratePBCode( *root )
      
      SetText( *g, code$ )
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 65
; FirstLine = 33
; Folding = -
; EnableXP
; DPIAware