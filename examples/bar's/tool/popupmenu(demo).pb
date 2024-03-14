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
;                              MenuBarOpenSubItem( text.s [, image] ) - OpenSubMenu( Text$ [, ImageID] )
;                                              MenuBarCloseSubItem( ) - CloseSubMenu( )
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
   
   Macro menu( )
     widget( ) ; __gui\popup
   EndMacro
   
   Procedure PopupMenuBar( x, y, width, height )
      Static count
      Protected *parent._s_WIDGET, menu 
      *parent = Root( ) ; Container( x, y, width + x*2, height + y*2 ) ; 
      
      menu = menu( )
      menu( ) = Create( *parent, "PopupMenu_"+count, #__type_Menu,
                                x, y, width, height, #Null$, #__flag_vertical, 0, 0, 0, 0, 0, 30 ) ; |#__flag_vertical
      SetColor( menu( ), #__color_back, $FFF7FDFF)
      Hide(menu( ),  1) 
      menu( )\menu = menu
      
      ;CloseList( ) ; *parent
      
      widget( ) = menu( ) 
      count + 1
      ProcedureReturn menu( )
   EndProcedure
   
   Procedure CreatePopupMenuBar( flag = #Null ) 
      ProcedureReturn PopupMenuBar( 10, 10, 200, 200 )
      ;       ;menu( ) = Create( root( ), "PopupMenu", #__type_ListView, 0, 0, 0, 0, #Null$, #__flag_child | #__flag_nobuttons | #__flag_nolines ) ;| #__flag_borderless
;       menu( ) = Create( root( ), "PopupMenu", #__type_Menu, 0, 0, 0, 0, #Null$, #__flag_child|#__flag_vertical, 0, 0, 0, 0, 0, 30 )
;       
;       
;       ;Hide( menu( ), #True )
;       ProcedureReturn menu( )
   EndProcedure
   
   Procedure MenuBarSeparator( )
      If menu( )
         AddItem( menu( ), #PB_Ignore, "", - 1, #Null )
         menu( )\__tabs( )\itemindex = #PB_Ignore
      EndIf
   EndProcedure
   
   Procedure MenuBarItem( item, text.s, image = - 1 )
      Protected *item._s_ROWS 
      If menu( )
         *item = AddItem( menu( ), - 1, text, image )
         
         If menu( )\data
            *item\parent = menu( )\data
            *item\parent\childrens + 1
            *item\parent\data = menu( )
         EndIf
      EndIf
      ProcedureReturn *item
   EndProcedure
   
   Procedure MenuBarOpenSubItem( text.s, image =- 1)
      Protected *item._s_ROWS
      If menu( )
         *item = MenuBarItem( #PB_Ignore, text.s, image )
         
         menu( ) = PopupMenuBar( 200,50,200,100 )
         menu( )\data = *item
         ;*item\data = menu( )
         
         ; Debug "open " +menu( )\menu\class +" "+ menu( )\class
         ProcedureReturn menu( )
      EndIf
   EndProcedure
   
   Procedure MenuBarCloseSubItem( )
      ; Debug "close "+menu( )\class +" "+  menu( )\menu\class
     If menu( )\menu
         menu( ) = menu( )\menu
      EndIf
   EndProcedure
   
   
   
   ;-
   ;-
   Procedure TestHandler()
      Debug "Test menu event"
   EndProcedure
   
   Procedure QuitHandler()
      Debug "Quit menu event"
      End
   EndProcedure
   
   Procedure ClickHandler( )
      If is_root_( EventWidget( ))
         DisplayPopupMenu( 0, WindowID(EventWindow()))
      Else
         DisplayPopupMenuBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
      EndIf
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
   Define *container._s_widget = Container( 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseList( )
   CloseList( )
   ;   widget( )\bs = 8
   ;   SetFrame(widget( ), 3);, -1)
   
   *menu = CreatePopupMenuBar( )
   
   MenuBarItem(1, "Open")      ; You can use all commands for creating a menu
   MenuBarItem(2, "Save")      ; just like in a normal menu...
   MenuBarSeparator( )
   ;
   MenuBarOpenSubItem("open sub item 1")
   MenuBarItem(5, "5 sub item")
   MenuBarItem(6, "6 sub item")
   MenuBarCloseSubItem()
   ;
   MenuBarSeparator( )
   MenuBarItem(3, "Before")
   MenuBarItem(4, "After")
   MenuBarSeparator( )
   ;
   MenuBarOpenSubItem("open sub item 2")
   MenuBarItem(10, "10 sub item")
   MenuBarItem(11, "11 sub item")
   MenuBarSeparator( )
   ;
   MenuBarOpenSubItem("open sub item 3")
   MenuBarItem(12, "12 sub item")
   MenuBarItem(13, "13 sub item")
   MenuBarCloseSubItem()
   ;
   MenuBarSeparator( )
   MenuBarItem(14, "14 sub item")
   MenuBarItem(15, "15 sub item")
   MenuBarSeparator( )
   MenuBarItem(16, "16 sub item")
   MenuBarItem(17, "17 sub item")
   MenuBarCloseSubItem( )
   ;
   MenuBarSeparator( )
   MenuBarItem(7, "exit")
   
   
   ;   Bind(*menu, @TestHandler(), 7)
   ;   Bind(*menu, @QuitHandler(), 8)
   
   
   
   Bind(root(), @ClickHandler(), #__event_LeftClick)
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 109
; FirstLine = 72
; Folding = v--
; EnableXP