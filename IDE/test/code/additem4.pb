XIncludeFile "../../ide.pb"
XIncludeFile "../../code.pbi"
;- 
CompilerIf #PB_Compiler_IsMainFile
   DisableExplicit
   Define Width = 350
   If Open( 0, 0, 0, Width, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      TEST = Window( 10, 10, 382, 382, "", #PB_Window_BorderLess  )
      _0 = Panel(8, 8, 356, 203)
      ;AddItem(_0, -1, "Панель 1")
      AddItem(_0, -1, "Панель 2")
      _1 = Panel(5, 30, 340, 166)
      AddItem(_1, -1, "Под-Панель 1")
      _2 = Panel(5, 30, 340, 166)
      AddItem(_2, -1, "Под-Под-Панель 1")
      
      AddItem(_2, -1, "Под-Под-Панель 2")
      Button(5, 5, 155, 22,"Под-Под-Панель 2")
      
      AddItem(_2, -1, "Под-Под-Панель 3")
      CloseList()
      
      AddItem(_1, -1, "Под-Панель 2")
      Button(5, 25, 155, 22,"Под-Панель 2")
      
      AddItem(_1, -1, "Под-Панель 3")
      CloseList()
      
      Button(5, 5, 155, 22,"Панель 2 1")
      
      AddItem (_0, -1,"Панель 3")
      Button(10, 15, 80, 24,"Панель 3 1")
      Button(95, 15, 80, 24,"Панель 3 2")
      CloseList()
   
            
      
;       If StartEnum( root( ) )
;          AddParseObject( widget( ))
;          StopEnum( )
;       EndIf
     
   EndIf
   
   Define *root = root( )
   If Open( 1, 0, 0, Width * 2, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ResizeWindow( 0, WindowX( 0 ) - WindowWidth( 1 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ResizeWindow( 1, WindowX( 1 ) + WindowWidth( 0 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      Define *g = Editor( 0, 0, 0, 0, #__flag_autosize )
      
      Define code$ = GeneratePBCode( *root )
      
      SetText( *g, code$ )
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 3
; Folding = -
; EnableXP
; DPIAware