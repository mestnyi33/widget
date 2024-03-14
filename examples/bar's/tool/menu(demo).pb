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
   
   Procedure CreateMenuBar( *parent._s_widget, flag = #Null )
      ProcedureReturn ToolBar( *parent, #PB_ToolBar_Small|#PB_ToolBar_Text )
      
      *parent\MenuBarHeight = #__menu_height
      
      Protected *this._s_WIDGET = Create( *parent, *parent\class + "_Menu", #__type_Menu, 0, 0, 0, 
                                          *parent\MenuBarHeight, #Null$, Flag | #__flag_child, 0, 0, 0, 0, 0, 30 )
      
      *parent\TabBox( ) = *this
      
      Resize( *parent, #PB_Ignore, *parent\inner_y( )+1, #PB_Ignore, #PB_Ignore )
      
      widget( ) = *this 
      ProcedureReturn *this
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
   
   Procedure MenuBarTitle( title.s )
      MenuBarCloseSubItem( )
      MenuBarOpenSubItem( title, - 1)
   EndProcedure
   
   
   ;-
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
   MenuBar()
   OpenSubMenu("title-1-sub-item")   
   MenuItem(3, "title-1-item-3")
   MenuItem(4, "title-1-item-4")
   CloseSubMenu( ) 
   
   MenuTitle("Title-2")
   MenuItem(5, "title-2-item-1")
   MenuItem(6, "title-2-item-2")
   
   MenuTitle("Title-event-test")
   MenuItem(7, "test")
   MenuBar( )
   MenuItem(8, "quit")
   
   MenuTitle("Title-4")
   MenuItem(9, "title-4-item-1")
   MenuItem(10, "title-4-item-2")
   
   BindMenuEvent(0, 7, @TestHandler())
   BindMenuEvent(0, 8, @QuitHandler())
   
   ;
   Define *window._s_widget = Window(100, 100, 300, 100, "menu click test", #PB_Window_SystemMenu)
   Define *container._s_widget = Container( 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseList( )
   ;   widget( )\bs = 8
   ;   SetFrame(widget( ), 3);, -1)
   
   Define *menu = CreateMenuBar( *window )
   MenuBarTitle("Title-1")
   MenuBarItem(1, "title-1-item-1")
   MenuBarItem(2, "title-1-item-2")
   ;   MenuBarSeparator( )
   ;   MenuBarOpenSubItem("title-1-sub-item")   
   ;   MenuBarItem(3, "title-1-item-3")
   ;   MenuBarItem(4, "title-1-item-4")
   ;   MenuBarCloseSubItem( ) 
   ;   
   MenuBarTitle("Title-2")
   MenuBarItem(5, "title-2-item-1")
   MenuBarItem(6, "title-2-item-2")
   ;   
   ;   MenuBarTitle("Title-event-test")
   ;   MenuBarItem(7, "test")
   ;   MenuBarSeparator( )
   ;   MenuBarItem(8, "quit")
   ;   
   ;   MenuBarTitle("Title-4")
   ;   MenuBarItem(9, "title-4-item-1")
   ;   MenuBarItem(10, "title-4-item-2")
   ;   
   ;   
   ; ;   Bind(*menu, @TestHandler(), 7)
   ; ;   Bind(*menu, @QuitHandler(), 8)
   ;   
   
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 105
; FirstLine = 79
; Folding = ---
; EnableXP