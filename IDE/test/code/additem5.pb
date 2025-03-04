XIncludeFile "../../ide.pb"
XIncludeFile "../../code.pbi"
;- 
CompilerIf #PB_Compiler_IsMainFile
   DisableExplicit
   Define Width = 350
   
   If Open( 0, 0, 0, Width, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      TEST = Window( 0, 0, 582, 582, "",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
      PANEL_0=Panel(8, 8, 356, 203)
         AddItem(PANEL_0, -1, "Панель 1")
         AddItem(PANEL_0, -1, "Панель 2")
         AddItem(PANEL_0, -1, "Панель 3")
         
         SetState( PANEL_0, 2 )
            
         PANEL_1=Panel( 5, 30, 340, 166)
            AddItem(PANEL_1, -1, "Под-Панель 1")
            AddItem(PANEL_1, -1, "Под-Панель 2")
            AddItem(PANEL_1, -1, "Под-Панель 3")
            
            SetState( PANEL_1, 2 )
            
            PANEL_2=Panel( 5, 30, 340, 166)
               AddItem(PANEL_2, -1, "Под-Под-Панель 1")
               AddItem(PANEL_2, -1, "Под-Под-Панель 2")
               AddItem(PANEL_2, -1, "Под-Под-Панель 3")
               
               SetState( PANEL_2, 2 )
            CloseList( )   
         CloseList( )   
      CloseList( )   
            
      
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
; CursorPosition = 38
; FirstLine = 9
; Folding = -
; EnableXP
; DPIAware