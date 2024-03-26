;                                                                     - PB 
;                                                PopupMenu( [flags] ) - CreatePopupMenu( #Menu )
;                                                                       CreatePopupImageMenu( #Menu [, Flags] )
;
;                                           Menu( *parent [, flags] ) - CreateMenu( #Menu, WindowID )
;                                                                       CreateImageMenu( #Menu, WindowID [, Flags] )
; 
;                        DisplayPopup( *address, *display [, x, y] )  - DisplayPopupMenu( #Menu, WindowID [, x, y] )
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

XIncludeFile "../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Define *menu._s_widget
   ;-
   
   Procedure test( *this._s_widget )
      If GetActive( )
         Debug "a - "+GetActive( )\class
      EndIf
      If ActiveWindow( )
         Debug "aw - "+ActiveWindow( )\class
         If ActiveGadget( )
            Debug "ag - "+ActiveGadget( )\class
         EndIf
      EndIf
      
      Debug ">"
      Debug ""+*this\class +" "+ *this\focus
      If StartEnumerate( *this )
         
         Debug ""+widget( )\class +" "+ widget( )\focus
         
         StopEnumerate( )
      EndIf
      Debug "<"
   EndProcedure
   
   Procedure TestHandler()
      ;ClearDebugOutput()
      Debug "Test menu event"
   EndProcedure
   
   Procedure QuitHandler()
      ;ClearDebugOutput()
      Debug "Quit menu event"
      ; End
   EndProcedure
   
   Procedure Handler()
     Debug ""+ClassFromEvent( WidgetEventType( ) ) +" - "+ EventWidget( )\class
   EndProcedure
   
   ;\\
   Define window = GetWindow(Open( 0, 100, 100, 500, 250, "main window_0", #__Window_SystemMenu))
   Define container = ContainerGadget( #PB_Any, 10, 35, 80, 100-20, #PB_Container_Flat ) : CloseGadgetList( )
   
   CreateMenu(0, WindowID(window))
   
   MenuTitle("Title-1")
   MenuTitle("Title-2")
   MenuTitle("Title-event-test")
   MenuTitle("Title-4")
   
   
   
   ;\\
   Define *window._s_widget = root( )
   
   *menu = CreateMenuBar( *window ) : SetClass(menu(), "root_MenuBar" )
   
   BarTitle("Title-1")
   BarTitle("Title-2")
   BarTitle("Title-event-test")
   BarTitle("Title-4")
   
   ;\\
   Define *window._s_widget = Window(100, 50, 300, 100, "menu click test", #PB_Window_SystemMenu)
   Define *container._s_widget = Container( 10, 10, 80, 100-20, #PB_Container_Flat ) : CloseList( )
   
   *menu = CreateMenuBar( *window ) : SetClass(menu(), "window_MenuBar" )
   
   BarTitle("Title-1")
   BarTitle("Title-2")
   BarTitle("Title-event-test")
   BarTitle("Title-4")
   
   
   test( root() )
   
   Bind( Root( ), @Handler(), #__event_Focus)
   Bind( Root( ), @Handler(), #__event_LostFocus)
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 77
; FirstLine = 42
; Folding = --
; EnableXP