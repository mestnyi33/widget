
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Global *menu._s_WIDGET
   
   ;-
   Procedure TestHandler()
      Debug "Test menu event"
   EndProcedure
   
   Procedure QuitHandler()
      Debug "Quit menu event"
      ;End
   EndProcedure
   
   Procedure ClickHandler( )
      ;Debug " "+mouse( )\x +" "+ mouse( )\y 
      If is_root_( EventWidget( ))
         DisplayPopupMenu( 0, WindowID(EventWindow()))
      Else
         DisplayPopupMenuBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
      EndIf
   EndProcedure
   
   ;\\
   Define window = GetWindow(Open( 1, 100, 100, 500, 400, "main window_1", #__Window_SystemMenu))
   ;Define container = ContainerGadget( #PB_Any, 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseGadgetList( )
   
   
;    CreatePopupMenu( 0 )
;    MenuItem(1, "Open")      ; You can use all commands for creating a menu
;    MenuItem(2, "Save")      ; just like in a normal menu...
;    MenuBar( )
;    ;
;    OpenSubMenu("open sub item 1")
;    MenuItem(5, "5 sub item")
;    MenuItem(6, "6 sub item")
;    CloseSubMenu()
;    ;
;    MenuBar( )
;    MenuItem(3, "Before")
;    MenuItem(4, "After")
;    MenuBar( )
;    ;
;    OpenSubMenu("open sub item 2")
;    MenuItem(10, "10 sub item")
;    MenuItem(11, "11 sub item")
;    MenuBar( )
;    ;
;    OpenSubMenu("open sub item 3")
;    MenuItem(12, "12 sub item")
;    MenuItem(13, "13 sub item")
;    CloseSubMenu()
;    ;
;    MenuBar( )
;    MenuItem(14, "14 sub item")
;    MenuItem(15, "15 sub item")
;    MenuBar( )
;    MenuItem(16, "16 sub item")
;    MenuItem(17, "17 sub item")
;    CloseSubMenu( )
;    ;
;    MenuBar( )
;    MenuItem(7, "exit")
   
   If CreatePopupMenu(0)      ; creation of the pop-up menu begins...
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
   
   BindMenuEvent(0, 6, @TestHandler())
   BindMenuEvent(0, 4, @QuitHandler())
   
   ;
   Define *window._s_widget = Window(100, 100, 300, 100, "menu click test", #PB_Window_SystemMenu)
   Define *container._s_widget = Container( 100, 10, 300-20-90, 100-20, #PB_Container_Flat ) : CloseList( )
   CloseList( )
   ;   widget( )\bs = 8
   ;   SetFrame(widget( ), 3);, -1)
   
    *menu = CreatePopupMenuBar( )
;    BarItem(1, "test")      ; You can use all commands for creating a menu
;    BarItem(2, "Save")      ; just like in a normal menu...
;    BarSeparator( )
;    ;
;    OpenBar("open sub item 1")
;    BarItem(5, "5 sub item")
;    BarItem(6, "6 sub item")
;    CloseBar()
;    ;
;    BarSeparator( )
;    BarItem(3, "Before")
;    BarItem(4, "After")
;    BarSeparator( )
;    ;
;    OpenBar("open sub item 2")
;    BarItem(10, "10 sub item")
;    BarItem(11, "11 sub item")
;    BarSeparator( )
;    ;
;    OpenBar("open sub item 3")
;    BarItem(12, "12 sub item")
;    BarItem(13, "13 sub item")
;    CloseBar()
;    ;
;    BarSeparator( )
;    BarItem(14, "14 sub item")
;    BarItem(15, "15 sub item")
;    BarSeparator( )
;    BarItem(16, "16 sub item")
;    BarItem(17, "17 sub item")
;    CloseBar( )
;    ;
;    BarSeparator( )
;    BarItem(7, "exit")
    
    If *menu                  ; creation of the pop-up menu begins...
      BarItem(1, "Open")      ; You can use all commands for creating a menu
      BarItem(2, "Save")      ; just like in a normal menu...
      BarItem(3, "Save as")
      BarItem(4, "Quit")
      BarSeparator( )
      OpenBar("Recent files")
        BarItem(5, "PureBasic.exe")
        BarItem(6, "Test.txt")
      CloseBar( )
    EndIf
   
   Bind(*menu, @TestHandler(), #__event_LeftClick, 6)
   Bind(*menu, @QuitHandler(), #__event_LeftClick, 4)
   
   Bind(root(), @ClickHandler(), #__event_LeftClick)
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 141
; FirstLine = 112
; Folding = --
; EnableXP