;                                                                     - PB 
;                                                                     - IsMenu( #Menu )
;                                                                     - MenuID( #Menu )
;                                                 FreeBar( *address ) - FreeMenu( #Menu )
;                                                 HideBar( *address ) - HideMenu( #Menu, State )
;                                               BarWidgetHeight( *address ) - MenuWidgetHeight( )
; 
;                                           CreatePopupBar( [flags] ) - CreatePopupMenu( #Menu )
;                                                                       CreatePopupImageMenu( #Menu [, Flags] )
;
;                                      CreateBar( *parent [, flags] ) - CreateMenu( #Menu, WindowID )
;                                                                       CreateImageMenu( #Menu, WindowID [, Flags] )
; 
;                     DisplayPopupBar( *address, *display [, x, y] )  - DisplayPopupMenu( #Menu, WindowID [, x, y] )
;
;                                                           BarBar( ) - MenuBar( )
;                                                  BarTitle( Title$ ) - MenuTitle( Title$ )
;                                   BarItem( BarItem, text.s, image ) - MenuItem( MenuItemID, Text$ [, ImageID]) )
;                                      OpenSubBar( text.s [, image] ) - OpenSubMenu( Text$ [, ImageID] )
;                                                      CloseSubBar( ) - CloseSubMenu( )
; 
; 
;                                 GetItemTextWidget( *address, TitleIndex ) - GetMenuTitleTextWidget( #Menu, Title )
;                         SetItemTextWidget( *address, TitleIndex, text.s ) - SetMenuTitleTextWidget( #Menu, Title, Text$ )
;
;                          DisableBarItem( *address, BarItem, state ) - DisableMenuItem( #Menu, MenuItem, State )
;                         SetBarItemState( *address, BarItem, state ) - SetMenuItemState( #Menu, MenuItem, State )
;                                GetBarItemState( *address, BarItem ) - GetMenuItemState( #Menu, MenuItem )
;                         SetBarItemTextWidget( *address, BarItem, text.s ) - SetMenuItemTextWidget( #Menu, Item, Text$ )
;                                 GetBarItemTextWidget( *address, BarItem ) - GetMenuItemTextWidget( #Menu, Item )
;
;                      BindBarEvent( *address, BarItem, @callback( )) - BindMenuEvent( #Menu, MenuItem, @Callback( ) )
;                    UnbindBarEvent( *address, BarItem, @callback( )) - UnbindMenuEvent( #Menu, MenuItem, @Callback( ) )

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
   Define windowID = OpenRootWidget( 0, 100, 100, 500, 350, "main window_0", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
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
   BindWidgetEvent(ButtonWidget( 10, 220, 80, 35, "-777-" ), @HandlerEvents( ), #__event_LeftClick)  : SetWidgetClass(widget(), "-777-" )
   
   ;\\
   *menu = CreateBar( root( ) ) : SetWidgetClass(widget( ), "root_MenuBar" )
   SetWidgetColor( *menu, #__color_back, $FFF7FEE2 )
   
   BarTitle("Title-1")
   BarItem(1, "title-1-item-1")
   BarBar( )
   
   OpenSubBar("title-1-sub-item")
   BarItem(3, "title-1-item")
   BarBar( )
   ;
   OpenSubBar("title-2-sub-item")   
   BarItem(13, "title-2-item")
   BarBar( )
   ;
   OpenSubBar("title-3-sub-item")   
   BarItem(23, "title-3-item")
   CloseSubBar( ) 
   ;
   BarBar( )
   BarItem(14, "title-2-item")
   CloseSubBar( ) 
   ;
   BarBar( )
   BarItem(4, "title-1-item")
   CloseSubBar( ) 
   ;
   BarBar( )
   BarItem(2, "title-1-item-2")
   
   BarTitle("Title-2")
;    BarItem(5, "title-2-item-1")
;    BarItem(6, "title-2-item-2")
   
   BarTitle("Title-event-test")
   BarItem(7, "test")
   BarBar( )
   BarItem(8, "quit")
   
   BarTitle("Title-4")
   BarItem(9, "title-4-item-1")
   BarItem(10, "title-4-item-2")
   
   BindWidgetEvent(*menu, @TestHandler(), -1, 7)
   BindWidgetEvent(*menu, @QuitHandler(), -1, 8)
   
   ;\\
   ButtonWidget( 415, 180, 80, 35, "Button1" ) : SetWidgetClass(widget(), "Button1" )
   BindWidgetEvent(ButtonWidget( 415, 220, 80, 35, "Button2" ), @HandlerEvents( ), #__event_MouseEnter)  : SetWidgetClass(widget(), "Button2" )
   Define *window._s_widget = WindowWidget(100, 50, 300, 200, "menu click test", #PB_Window_SystemMenu)
   ContainerWidget( 10, 10, 80, 80, #PB_Container_Flat )
   StringWidget( 10, 10, 80, 35, "String1" )
   StringWidget( 10, 50, 80, 35, "String2" )
   CloseWidgetList( )
   StringWidget( 10, 100, 80, 35, "String1" )
   StringWidget( 10, 140, 80, 35, "String2" )
   
   *menu = CreateBar( *window ) : SetWidgetClass(widget(), "window_MenuBar" )
   SetWidgetColor( *menu, #__color_back, $FFDFDFDF )
   
   BarTitle("Title-1")
   BarItem(1, "title-1-item-1")
   BarBar( )   
   ;
   OpenSubBar("title-1-sub-item")
   BarItem(3, "title-1-item")
   BarBar( )
   ;
   OpenSubBar("title-2-sub-item")   
   BarItem(13, "title-2-item")
   BarBar( )
   ;
   OpenSubBar("title-3-sub-item")   
   BarItem(23, "title-3-item")
   CloseSubBar( ) 
   ;
   BarBar( )
   BarItem(14, "title-2-item")
   CloseSubBar( ) 
   ;
   BarBar( )
   BarItem(4, "title-1-item")
   CloseSubBar( ) 
   ;
   BarBar( )
   BarItem(2, "title-1-item-2")
   
   BarTitle("Title-2")
;    BarItem(5, "title-2-item-1")
;    BarItem(6, "title-2-item-2")
   
   BarTitle("Title-event-test")
   BarItem(7, "test")
   BarBar( )
   BarItem(8, "quit")
   
   BarTitle("Title-4")
   BarItem(9, "title-4-item-1")
   BarItem(10, "title-4-item-2")
   
   BindWidgetEvent(*menu, @TestHandler(), -1, 7)
   BindWidgetEvent(*menu, @QuitHandler(), -1, 8)
   
   
   
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
; CursorPosition = 204
; FirstLine = 201
; Folding = --
; EnableXP
; DPIAware