;                                                                     - PB 
;                                                                     - IsMenu( #Menu )
;                                                                     - MenuID( #Menu )
;                                                    Free( *address ) - FreeMenu( #Menu )
;                                                    HideWidget( *address ) - HideMenu( #Menu, State )
;                                                  WidgetHeight( *address ) - MenuHeight( )
; 
;                                             PopupMenuBar( [flags] ) - CreatePopupMenu( #Menu )
;                                                                       CreatePopupImageMenu( #Menu [, Flags] )
;
;                                        MenuBar( *parent [, flags] ) - CreateMenu( #Menu, WindowID )
;                                                                       CreateImageMenu( #Menu, WindowID [, Flags] )
; 
;                 DisplayPopupMenuBar( *address, *display [, x, y] )  - DisplayPopupMenu( #Menu, WindowID [, x, y] )
;
;                                                     BarSeparator( ) - MenuBar( )
;                                                  BarTitle( Title$ ) - MenuTitle( Title$ )
;                                      BarItem( item, text.s, image ) - MenuItem( MenuItemID, Text$ [, ImageID]) )
;                                         OpenBar( text.s [, image] ) - OpenSubMenu( Text$ [, ImageID] )
;                                                         CloseBar( ) - CloseSubMenu( )
; 
; 
;                                 GetItemText( *address, TitleIndex ) - GetMenuTitleText( #Menu, Title )
;                         SetItemText( *address, TitleIndex, text.s ) - SetMenuTitleText( #Menu, Title, Text$ )
;
;                                DisableItem( *address, item, state ) - DisableMenuItem( #Menu, MenuItem, State )
;                               SetItemState( *address, item, state ) - SetMenuItemState( #Menu, MenuItem, State )
;                                      GetItemState( *address, item ) - GetMenuItemState( #Menu, MenuItem )
;                               SetItemText( *address, item, text.s ) - SetMenuItemText( #Menu, Item, Text$ )
;                                       GetItemText( *address, item ) - GetMenuItemText( #Menu, Item )
;
;                              Bind( *address, @callback( ), 0, item) - BindMenuEvent( #Menu, MenuItem, @Callback( ) )
;                            UnBind( *address, @callback( ), 0, item) - UnbindMenuEvent( #Menu, MenuItem, @Callback( ) )

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define *menu._s_widget
   ;-
   Procedure HandlerEvents()
      Protected event = WidgetEvent( )
      
      If event = #__event_LeftClick
         Debug " -777- event "
      EndIf
      
      If event = #__event_MouseEnter
         Debug "  - "+GetActiveGadget( )+" "+GetActiveWindow( )
         ForEach roots( )
            Debug ""+roots( )\canvas\gadget +" "+ roots( )\canvas\window +" "+ roots( )\class +" "+ roots( )\focus
            
            If StartEnum( roots( ) )
               Debug "   "+ widget( )\class +" "+ widget( )\focus
               StopEnum( )
            EndIf
         Next
         Debug ""
      EndIf
      
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
   
   ;\\
   Define windowID = Open( 0, 100, 100, 500, 350, "main window_0", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
   ContainerGadget( #PB_Any, 10, 35, 80, 80, #PB_Container_Flat ) 
   StringGadget( #PB_Any, 10, 10, 80, 35, "String1" )
   StringGadget( #PB_Any, 10, 50, 80, 35, "String2" )
   CloseGadgetList( )
   StringGadget( #PB_Any, 10, 120, 80, 35, "String1" )
   StringGadget( #PB_Any, 10, 160, 80, 35, "String2" )
   
   CreateMenu(0, WindowID(0))
   MenuTitle("Title-1")
   MenuItem(1, "title-1-item-1")
   MenuBar()
   ;
   OpenSubMenu("title-1-sub-item")   
   MenuItem(3, "title-1-item")
   MenuBar()
   ;
   OpenSubMenu("title-2-sub-item")   
   MenuItem(13, "title-2-item")
   MenuBar()
   ;
   OpenSubMenu("title-3-sub-item")   
   MenuItem(23, "title-3-item")
   CloseSubMenu( ) 
   ;
   MenuBar()
   MenuItem(24, "title-2-item")
   CloseSubMenu( ) 
   ;
   MenuBar()
   MenuItem(14, "title-1-item")
   CloseSubMenu( ) 
   ;
   MenuBar()
   MenuItem(2, "title-1-item-2")
   
   MenuTitle("Title-2")
;    MenuItem(5, "title-2-item-1")
;    MenuItem(6, "title-2-item-2")
   
   MenuTitle("Title-event-test")
   MenuItem(7, "test")
   MenuBar( )
   MenuItem(8, "quit")
   
   MenuTitle("Title-4")
   MenuItem(9, "title-4-item-1")
   MenuItem(10, "title-4-item-2")
   
   BindMenuEvent(0, 7, @TestHandler())
   BindMenuEvent(0, 8, @QuitHandler())
   
   ButtonGadget(777, 10, 220, 80, 35, "-777-" )
   Bind(Button( 10, 220, 80, 35, "-777-" ), @HandlerEvents( ), #__event_LeftClick)  : SetClass(widget(), "-777-" )
   
   ;\\
   *menu = CreateMenuBar( root( ) ) : SetClass(widget( ), "root_MenuBar" )
   SetColor( *menu, #__color_back, $FFF7FEE2 )
   
   BarTitle("Title-1")
   BarItem(1, "title-1-item-1")
   BarSeparator( )
   
   OpenBar("title-1-sub-item")
   BarItem(3, "title-1-item")
   BarSeparator( )
   ;
   OpenBar("title-2-sub-item")   
   BarItem(13, "title-2-item")
   BarSeparator( )
   ;
   OpenBar("title-3-sub-item")   
   BarItem(23, "title-3-item")
   CloseBar( ) 
   ;
   BarSeparator( )
   BarItem(14, "title-2-item")
   CloseBar( ) 
   ;
   BarSeparator( )
   BarItem(4, "title-1-item")
   CloseBar( ) 
   ;
   BarSeparator( )
   BarItem(2, "title-1-item-2")
   
   BarTitle("Title-2")
;    BarItem(5, "title-2-item-1")
;    BarItem(6, "title-2-item-2")
   
   BarTitle("Title-event-test")
   BarItem(7, "test")
   BarSeparator( )
   BarItem(8, "quit")
   
   BarTitle("Title-4")
   BarItem(9, "title-4-item-1")
   BarItem(10, "title-4-item-2")
   
   Bind(*menu, @TestHandler(), -1, 7)
   Bind(*menu, @QuitHandler(), -1, 8)
   
   ;\\
   Button( 415, 180, 80, 35, "Button1" ) : SetClass(widget(), "Button1" )
   Bind(Button( 415, 220, 80, 35, "Button2" ), @HandlerEvents( ), #__event_MouseEnter)  : SetClass(widget(), "Button2" )
   Define *window._s_widget = Window(100, 50, 300, 200, "menu click test", #PB_Window_SystemMenu)
   Container( 10, 10, 80, 80, #PB_Container_Flat )
   String( 10, 10, 80, 35, "String1" )
   String( 10, 50, 80, 35, "String2" )
   CloseList( )
   String( 10, 100, 80, 35, "String1" )
   String( 10, 140, 80, 35, "String2" )
   
   *menu = CreateMenuBar( *window ) : SetClass(widget(), "window_MenuBar" )
   SetColor( *menu, #__color_back, $FFDFDFDF )
   
   BarTitle("Title-1")
   BarItem(1, "title-1-item-1")
   BarSeparator( )   
   ;
   OpenBar("title-1-sub-item")
   BarItem(3, "title-1-item")
   BarSeparator( )
   ;
   OpenBar("title-2-sub-item")   
   BarItem(13, "title-2-item")
   BarSeparator( )
   ;
   OpenBar("title-3-sub-item")   
   BarItem(23, "title-3-item")
   CloseBar( ) 
   ;
   BarSeparator( )
   BarItem(14, "title-2-item")
   CloseBar( ) 
   ;
   BarSeparator( )
   BarItem(4, "title-1-item")
   CloseBar( ) 
   ;
   BarSeparator( )
   BarItem(2, "title-1-item-2")
   
   BarTitle("Title-2")
;    BarItem(5, "title-2-item-1")
;    BarItem(6, "title-2-item-2")
   
   BarTitle("Title-event-test")
   BarItem(7, "test")
   BarSeparator( )
   BarItem(8, "quit")
   
   BarTitle("Title-4")
   BarItem(9, "title-4-item-1")
   BarItem(10, "title-4-item-2")
   
   Bind(*menu, @TestHandler(), -1, 7)
   Bind(*menu, @QuitHandler(), -1, 8)
   
   
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         If EventGadget() = 777
            Debug " -777- event "
         EndIf
      EndIf
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 56
; FirstLine = 52
; Folding = --
; EnableXP
; DPIAware