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
   
   Procedure PopupMenuBar( x, y, width, height )
      Static count
      Protected *parent._s_WIDGET
      *parent = Root( ) ; Container( x, y, width + x*2, height + y*2 ) ; 
      
      __gui\popup = Create( *parent, "PopupMenu_"+count, #__type_Menu,
                                x, y, width, height, #Null$, #__flag_vertical, 0, 0, 0, 0, 0, 30 ) ; |#__flag_vertical
      SetColor( __gui\popup, #__color_back, $FFF7FDFF)
      Hide(__gui\popup,  1) 
      __gui\popup\menu = __gui\popup
      
      ;CloseList( ) ; *parent
      
      widget( ) = __gui\popup 
      count + 1
      ProcedureReturn __gui\popup
   EndProcedure
   
   Procedure CreatePopupMenuBar( flag = #Null ) 
      ProcedureReturn PopupMenuBar( 10, 10, 200, 200 )
      ;       ;__gui\popup = Create( root( ), "PopupMenu", #__type_ListView, 0, 0, 0, 0, #Null$, #__flag_child | #__flag_nobuttons | #__flag_nolines ) ;| #__flag_borderless
;       __gui\popup = Create( root( ), "PopupMenu", #__type_Menu, 0, 0, 0, 0, #Null$, #__flag_child|#__flag_vertical, 0, 0, 0, 0, 0, 30 )
;       
;       
;       ;Hide( __gui\popup, #True )
;       ProcedureReturn __gui\popup
   EndProcedure
   
   Procedure MenuBarItem( item, text.s, image = - 1 )
      If __gui\popup
         AddItem( __gui\popup, - 1, text, image )
         If __gui\popup\menu
            Protected *parent_row._s_ROWS = __gui\popup\data
            
            If *parent_row
               *parent_row\childrens + 1
               *parent_row\data = __gui\popup
               __gui\popup\__tabs( )\parent = *parent_row
            EndIf
            
         EndIf
      EndIf
      ProcedureReturn __gui\popup\__tabs( )
   EndProcedure
   
   Procedure MenuBarSeparator( )
      If __gui\popup
         AddItem( __gui\popup, #PB_Ignore, "", - 1, #Null )
         __gui\popup\__tabs( )\itemindex = #PB_Ignore
      EndIf
   EndProcedure
   
   Procedure MenuBarOpenSubItem( text.s, image =- 1)
      Protected *item._s_ROWS, menu
      *item = MenuBarItem( #PB_Ignore, text.s, image )
      
      menu = __gui\popup
      
      __gui\popup = PopupMenuBar( 200,50,200,100 )
      __gui\popup\menu = menu
      Debug "open " +__gui\popup\menu\class +" "+ __gui\popup\class
      
      
      ;
      __gui\popup\data = *item
      ;*item\data = __gui\popup
      ;
      ProcedureReturn __gui\popup
   EndProcedure
   
   Procedure MenuBarCloseSubItem( )
      Debug "close "+__gui\popup\class +" "+  __gui\popup\menu\class
      __gui\popup = __gui\popup\menu
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
   MenuBar()
   OpenSubMenu("open sub item")
   MenuItem(5, "1 sub item")
   MenuItem(6, "2 sub item")
   CloseSubMenu()
   MenuBar()
   MenuItem(3, "Save as")
   MenuItem(4, "Quit")
   
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
   MenuBarItem(3, "Save as")
   MenuBarItem(4, "Quit")
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
; CursorPosition = 61
; FirstLine = 60
; Folding = ---
; EnableXP