
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global menu, *menu._s_WIDGET
   ;-
   Procedure TestHandler()
      Debug "Test menu event"
   EndProcedure
   
   Procedure QuitHandler()
      Debug "Quit menu event"
      ;End
   EndProcedure
   
   ;\\
   OpenWindow( 1, 100, 100, 500, 400, "main window_1", #PB_Window_SystemMenu)
   menu = CreatePopupMenu( #PB_Any )
   MenuItem(1, "Open")      ; You can use all commands for creating a menu
   MenuItem(2, "Save")      ; just like in a normal menu...
   MenuBar( )
   ;
   OpenSubMenu("open sub item 1")
   MenuItem(5, "5 sub item")
   MenuItem(6, "6 sub item")
   CloseSubMenu()
   ;
   MenuBar( )
   MenuItem(3, "Before")
   MenuItem(4, "After")
   MenuBar( )
   ;
   OpenSubMenu("open sub item 2")
   MenuItem(10, "10 sub item")
   MenuItem(11, "11 sub item")
   MenuBar( )
   ;
   OpenSubMenu("open sub item 3")
   MenuItem(12, "12 sub item")
   MenuItem(13, "13 sub item")
   CloseSubMenu()
   ;
   MenuBar( )
   MenuItem(14, "14 sub item")
   MenuItem(15, "15 sub item")
   MenuBar( )
   MenuItem(16, "16 sub item")
   MenuItem(17, "17 sub item")
   CloseSubMenu( )
   ;
   MenuBar( )
   MenuItem(7, "exit")
   
   If IsMenu(menu)                ; creation of the pop-up menu begins...
      MenuItem(1, "Open")      ; You can use all commands for creating a menu
      MenuItem(2, "Save")      ; just like in a normal menu...
      MenuItem(3, "Save as")
      MenuItem(4, "Quit")
      MenuBar()
      OpenSubMenu("Recent files")
      MenuItem(5, "PureBasic.exe")
      MenuItem(6, "Test.txt")
      CloseSubMenu()
   EndIf
   
   BindMenuEvent(menu, 6, @TestHandler())
   BindMenuEvent(menu, 4, @QuitHandler())
   
   ;\\
   Procedure ClickHandler( )
      DisplayPopupBar( *menu, EventWidget( ) )
   EndProcedure
   
   Bind(Open( 1, 10, 10, 480, 200), @ClickHandler(), #__event_LeftClick)
   *menu = CreatePopupBar( )
   BarItem(1, "test")      ; You can use all commands for creating a menu
   BarItem(2, "Save")      ; just like in a normal menu...
   BarBar( )
   ;
   OpenSubBar("open sub item 1")
   BarItem(5, "5 sub item")
   BarItem(6, "6 sub item")
   CloseSubBar()
   ;
   BarBar( )
   BarItem(3, "Before")
   BarItem(4, "After")
   BarBar( )
   ;
   OpenSubBar("open sub item 2")
   BarItem(10, "10 sub item")
   BarItem(11, "11 sub item")
   BarBar( )
   ;
   OpenSubBar("open sub item 3")
   BarItem(12, "12 sub item")
   BarItem(13, "13 sub item")
   CloseSubBar()
   ;
   BarBar( )
   BarItem(14, "14 sub item")
   BarItem(15, "15 sub item")
   BarBar( )
   BarItem(16, "16 sub item")
   BarItem(17, "17 sub item")
   CloseSubBar( )
   ;
   BarBar( )
   BarItem(7, "exit")
   
   If is_menu_( *menu )                 ; creation of the pop-up menu begins...
      BarItem(1, "Open")     ; You can use all commands for creating a menu
      BarItem(2, "Save")     ; just like in a normal menu...
      BarItem(3, "Save as")
      BarItem(4, "Quit")
      BarBar( )
      OpenSubBar("Recent files")
      BarItem(5, "PureBasic.exe")
      BarItem(6, "Test.txt")
      CloseSubBar( )
   EndIf
   
   Bind(*menu, @TestHandler(), #__event_LeftClick, 6)
   Bind(*menu, @QuitHandler(), #__event_LeftClick, 4)
   
   
   Define Event
   Repeat
      Event = WaitWindowEvent( )
      If event = #PB_Event_LeftClick
         DisplayPopupMenu( menu, WindowID(EventWindow()), DesktopMouseX(), DesktopMouseY())
      EndIf
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 73
; FirstLine = 63
; Folding = --
; EnableXP
; DPIAware