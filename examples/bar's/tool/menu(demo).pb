;                                                                     - PB 
;                                                PopupMenu( [flags] ) - CreatePopupMenu( #Menu )
;                                                                       CreatePopupImageMenu( #Menu [, Flags] )
;
;                                           Menu( *parent [, flags] ) - CreateMenu( #Menu, WindowID )
;                                                                       CreateImageMenu( #Menu, WindowID [, Flags] )
; 
;                             Display( *address, *display [, x, y] )  - DisplayPopupMenu( #Menu, WindowID [, x, y] )
;                                                                     - IsMenu( #Menu )
;                                                                     - MenuID( #Menu )
; 
;                                                     Title( Title$ ) - MenuTitle( Title$ )
;                                 GetItemText( *address, TitleIndex ) - GetMenuTitleText( #Menu, Title )
;                         SetItemText( *address, TitleIndex, text.s ) - SetMenuTitleText( #Menu, Title, Text$ )
; 
;                                                    Free( *address ) - FreeMenu( #Menu )
;                                DisableItem( *address, item, state ) - DisableMenuItem( #Menu, MenuItem, State )
;                                      GetItemState( *address, item ) - GetMenuItemState( #Menu, MenuItem )
;                                       GetItemText( *address, item ) - GetMenuItemText( #Menu, Item )
;                                                    Hide( *address ) - HideMenu( #Menu, State )
;                                             Separator( [*address] ) - MenuBar( )
;                                                  Height( *address ) - MenuHeight( )
;                            AddItem( *address, item, text.s, image ) - MenuItem( MenuItemID, Text$ [, ImageID]) )
;
;                                        OpenItem( text.s [, image] ) = AddItem( *address, item, text.s, image, mode )
;                                        OpenItem( text.s [, image] ) - OpenSubMenu( Text$ [, ImageID] )
;                                                        CloseItem( ) - CloseSubMenu( )
; 
;                               SetItemState( *address, item, state ) - SetMenuItemState( #Menu, MenuItem, State )
;                               SetItemText( *address, item, text.s ) - SetMenuItemText( #Menu, Item, Text$ )
;
;                      Bind( *address, @callback( ), eventtype, item) - BindMenuEvent( #Menu, MenuItem, @Callback( ) )
;                    UnBind( *address, @callback( ), eventtype, item) - UnbindMenuEvent( #Menu, MenuItem, @Callback( ) )

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Procedure Menu( *parent._s_widget, flag = #Null )
     *parent\MenuBarHeight = #__menu_height
     
     Protected *this._s_WIDGET = Create( *parent, *parent\class + "_Menu", #__type_Menu, 0, 0, 0, 
                                         *parent\MenuBarHeight, #Null$, Flag | #__flag_child, 0, 0, 0, 0, 0, 30 )
     
     *parent\TabBox( ) = *this
     
     Resize( *parent, #PB_Ignore, *parent\inner_y( )+1, #PB_Ignore, #PB_Ignore )
     
     widget( ) = *this 
     ProcedureReturn *this
  EndProcedure
  
  Procedure Title( title.s )
     ToolBarButton( -1, -1, #PB_ToolBar_Toggle, title.s )
  EndProcedure
  
  Procedure Item( item, text.s, image = - 1 )
     Debug widget( )\count\items
     ; ToolBarButton( item, image, #PB_ToolBar_Toggle, text.s )
  EndProcedure
  
  Procedure Bar( )
     ;
  EndProcedure
  
  Procedure TestHandler()
    Debug "Test menu event"
  EndProcedure
  
  Procedure QuitHandler()
    Debug "Quit menu event"
    End
  EndProcedure
  
  ;\\
  Define window = GetWindow(Open( 1, 100, 100, 500, 400, "main window_1", #__Window_SystemMenu))
  ;Define container = ContainerGadget( #PB_Any, 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseGadgetList( )
  
  
  CreateMenu(0, WindowID(window))
  MenuTitle("Title-1")
  MenuItem(1, "title-1-item-1")
  MenuItem(2, "title-1-item-2")
  
  MenuTitle("Title-2")
  MenuItem(3, "title-2-item-1")
  MenuItem(4, "title-2-item-2")
  
  MenuTitle("Title-3")
  MenuItem(5, "title-3-item-1")
  MenuItem(6, "title-3-item-2")
  
  MenuTitle("Title-event-test")
  MenuItem(7, "test")
  MenuBar()
  MenuItem(8, "quit")
  
  BindMenuEvent(0, 7, @TestHandler())
  BindMenuEvent(0, 8, @QuitHandler())
  
  ;
  Define *window._s_widget = Window(100, 100, 300, 100, "menu click test", #PB_Window_SystemMenu)
  Define *container._s_widget = Container( 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseList( )
  ;   widget( )\bs = 8
  ;   SetFrame(widget( ), 3);, -1)
  
  Define *menu = Menu( *window )
  Title("Title-1")
  Item(1, "title-1-item-1")
  Item(2, "title-1-item-2")
  
  Title("Title-2")
  Item(3, "title-2-item-1")
  Item(4, "title-2-item-2")
  
  Title("Title-3")
  Item(5, "title-3-item-1")
  Item(6, "title-3-item-2")
  
  Title("Title-event-test")
  Item(7, "test")
  Bar( )
  Item(8, "quit")
  
;   Bind(*menu, @TestHandler(), 7)
;   Bind(*menu, @QuitHandler(), 8)
  
  
  
  Define Event
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 43
; FirstLine = 26
; Folding = --
; EnableXP