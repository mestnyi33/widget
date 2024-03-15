;                                                                     - PB 
;                                       CreatePopupMenuBar( [flags] ) - CreatePopupMenu( #Menu )
;                                                                       CreatePopupImageMenu( #Menu [, Flags] )
;
;                                  CreateMenuBar( *parent [, flags] ) - CreateMenu( #Menu, WindowID )
;                                                                       CreateImageMenu( #Menu, WindowID [, Flags] )
; 
;                             Display( *address, *display [, x, y] )  - DisplayPopupMenu( #Menu, WindowID [, x, y] )
;                                                                     - IsMenu( #Menu )
;                                                                     - MenuID( #Menu )
; 
;                                              MenuBarTitle( Title$ ) - MenuTitle( Title$ )
;                                 GetItemText( *address, TitleIndex ) - GetMenuTitleText( #Menu, Title )
;                         SetItemText( *address, TitleIndex, text.s ) - SetMenuTitleText( #Menu, Title, Text$ )
; 
;                                                    Free( *address ) - FreeMenu( #Menu )
;                                DisableItem( *address, item, state ) - DisableMenuItem( #Menu, MenuItem, State )
;                                      GetItemState( *address, item ) - GetMenuItemState( #Menu, MenuItem )
;                                       GetItemText( *address, item ) - GetMenuItemText( #Menu, Item )
;                                                    Hide( *address ) - HideMenu( #Menu, State )
;                                      MenuBarSeparator( [*address] ) - MenuBar( )
;                                                  Height( *address ) - MenuHeight( )
;                            AddItem( *address, item, text.s, image ) - MenuItem( MenuItemID, Text$ [, ImageID]) )
;
;                                     MenuBarItem( text.s [, image] ) = AddItem( *address, item, text.s, image, mode )
;                              MenuOpenSubBar( text.s [, image] ) - OpenSubMenu( Text$ [, ImageID] )
;                                              MenuCloseSubBar( ) - CloseSubMenu( )
; 
;                        MenuBarSetItemState( *address, item, state ) - SetMenuItemState( #Menu, MenuItem, State )
;                        MenuBarSetItemText( *address, item, text.s ) - SetMenuItemText( #Menu, Item, Text$ )
;
;          BindMenuBarEvent( *address, @callback( ), eventtype, item) - BindMenuEvent( #Menu, MenuItem, @Callback( ) )
;                    UnBind( *address, @callback( ), eventtype, item) - UnbindMenuEvent( #Menu, MenuItem, @Callback( ) )

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
      End
   EndProcedure
   
   Procedure ClickHandler( )
      Debug " "+mouse( )\x +" "+ mouse( )\y 
;       If is_root_( EventWidget( ))
;          DisplayPopupMenu( 0, WindowID(EventWindow()))
;       Else
          DisplayPopupBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
;       EndIf
   EndProcedure
   
   ;\\
   Define window = GetWindow(Open( 1, 100, 100, 500, 400, "main window_1", #__Window_SystemMenu))
   ;Define container = ContainerGadget( #PB_Any, 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseGadgetList( )
   
   
   CreatePopupMenu( 0 )
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
   
   BindMenuEvent(0, 6, @TestHandler())
   BindMenuEvent(0, 4, @QuitHandler())
   
   ;
   Define *window._s_widget = Window(100, 100, 300, 100, "menu click test", #PB_Window_SystemMenu)
   Define *container._s_widget = Container( 100, 10, 300-20-90, 100-20, #PB_Container_Flat ) : CloseList( )
   CloseList( )
   ;   widget( )\bs = 8
   ;   SetFrame(widget( ), 3);, -1)
   
   *menu = CreatePopupMenuBar( )
   
   BarItem(1, "Open")      ; You can use all commands for creating a menu
   BarItem(2, "Save")      ; just like in a normal menu...
   BarSeparator( )
   ;
   OpenSubBar("open sub item 1")
   BarItem(5, "5 sub item")
   BarItem(6, "6 sub item")
   CloseSubBar()
   ;
   BarSeparator( )
   BarItem(3, "Before")
   BarItem(4, "After")
   BarSeparator( )
   ;
   OpenSubBar("open sub item 2")
   BarItem(10, "10 sub item")
   BarItem(11, "11 sub item")
   BarSeparator( )
   ;
   OpenSubBar("open sub item 3")
   BarItem(12, "12 sub item")
   BarItem(13, "13 sub item")
   CloseSubBar()
   ;
   BarSeparator( )
   BarItem(14, "14 sub item")
   BarItem(15, "15 sub item")
   BarSeparator( )
   BarItem(16, "16 sub item")
   BarItem(17, "17 sub item")
   CloseSubBar( )
   ;
   BarSeparator( )
   BarItem(7, "exit")
   
   
   ;   Bind(*menu, @TestHandler(), 7)
   ;   Bind(*menu, @QuitHandler(), 8)
   
   
   
   Bind(root(), @ClickHandler(), #__event_LeftClick)
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 57
; FirstLine = 35
; Folding = -
; EnableXP